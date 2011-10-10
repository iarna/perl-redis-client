package Redis::Client::Hash;

use strict;
use warnings;

use Carp 'croak';
use Data::Dumper;


sub TIEHASH { 
    my ( $class, %args ) = @_;

    croak 'No key specified' unless $args{key};
    croak 'No Redis client object specified' unless $args{client};

    my $obj = { %args };

    return bless $obj, $class;
}

sub FETCH { 
    my ( $self, $key ) = @_;

    my $val = $self->{client}->hget( $self->{key}, $key );
    return $val;
}

sub STORE { 
    my ( $self, $key, $val ) = @_;

    return $self->{client}->hset( $self->{key}, $key, $val );
}

sub DELETE { 
    my ( $self, $key ) = @_;

    my $val = $self->FETCH( $key );

    if ( $self->{client}->hdel( $self->{key}, $key ) ) { 
        return $val;
    }

    return;
}

sub CLEAR { 
    my ( $self ) = @_;

    my @keys = $self->{client}->hkeys( $self->{key} );

    foreach my $key( @keys ) { 
        $self->DELETE( $key );
    }
}

sub EXISTS { 
    my ( $self, $key ) = @_;

    return 1 if $self->{client}->hexists( $self->{key}, $key );
    return;
}

sub FIRSTKEY { 
    my ( $self ) = @_;

    my @keys = $self->{client}->hkeys( $self->{key} );
    return if @keys == 0;

    $self->{keys} = \@keys;

    return $self->NEXTKEY;
}

sub NEXTKEY { 
    my ( $self ) = @_;

    return shift @{ $self->{keys} };
}


1;
