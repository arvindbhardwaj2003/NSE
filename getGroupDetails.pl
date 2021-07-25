## This code is to get details of All group from device using SOAP API
no warnings qw(redefine);
#use strict;

use lib qw(/usr/share/fireflow/local/etc/site/lib);

use AFAWebServicesClient;
use Data::Dumper;

open(FH, '>', '/tmp/hostGroupDetails.log') or die $!;

my $user = 'admin';
my $pass = 'algosec';

$gDetails;

print "PS Custom Report:  Generation Begins \n";

my $sessionId = AFAWebServicesClient::ConnectAFA("$user","$pass");

print "PS Custom Report:  Session Id generated - $sessionId \n";

my @groupName = AFAWebServicesClient::GetHostGroupsRequest($sessionId,'10_20_26_1_David_Bowie_Ashes_To_Ashes');

print FH Dumper(@groupName)."\n";

my $totalHostNames = scalar (@groupName);

for (my $i=0; $i < $totalHostNames; $i++) {
      if ($groupName [$i]{'Members'} ne ''){
      print "$groupName [$i]{'Members'}  is:". Dumper($groupName [$i]{'Members'})."\n";
}
   }