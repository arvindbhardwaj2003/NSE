## This code is to get details of All group from device using SOAP API
no warnings qw(redefine);
use strict;

use lib qw(/usr/share/fireflow/local/etc/site/lib);

use AFAWebServicesClient;
use Data::Dumper;

open(FH, '>', '/tmp/hostGroupDetails.log') or die $!;

my $user = 'admin';
my $pass = 'algosec';

print "PS Custom Report:  Generation Begins \n";

my $sessionId = AFAWebServicesClient::ConnectAFA("$user","$pass");

print "PS Custom Report:  Session Id generated - $sessionId \n";

my @groupName = AFAWebServicesClient::GetHostGroupsRequest($sessionId,'Bamba');

print FH Dumper(@groupName)."\n";

print @groupName."\n";