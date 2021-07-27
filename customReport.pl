#!/usr/bin/perl
use lib qw(/usr/share/fireflow/local/etc/site/lib);

use Data::Dumper;
use FetchGroupDetails;

my $tempReport = $ARGV[0];
print "\n Temp path: $tempReport \n";
my @tempReportValues = split ('/',$tempReport);
$tempReport = $tempReportValues[scalar(@tempReportValues)-1];

#my $report = '/home/afa/.fa/';
my $report = $tempReport;
my $userReportName = 'report_results.csv';
my $htmlbody1 = "";
my $htmlbody2 = "";
print "\n Path: $report";

my $user = 'admin';
my $pass = 'algosec';

print "PS Custom Report:  Generation Begins \n";

my $deviceID = shift;

my $sessionId = FetchGroupDetails::getSessionId({'UserName' => $user, 'Password' => $pass});

my $groupName = FetchGroupDetails::getCompleteGroupList({'SessionId' => $sessionId,'DeviceId' => $deviceID});

#print "\n Group List Fetched " . Dumper(@$groupName)."\n";

foreach my $hash (@$groupName){
	my %groupHash = %$hash;
	if($groupHash{'Members'}){
		my @members = @{$groupHash{'Members'}};
		if(scalar(@members) > 0){
			$htmlbody1 .= "<TR> <TD> <a id='$groupHash{'Name'}'> $groupHash{'Name'} </a></TD>";
			$htmlbody1 .= "<TD>";
			foreach my $mem (@members){
				$htmlbody1 .= "<a href='#$mem'>$mem </a> <br>";
			}
			$htmlbody1 .= "</TD>";
			$htmlbody1 .= "</TR>";
		}
	}
	else{
		my $ip = $groupHash{'IP'};
		$htmlbody2 .= "<TR> <TD> <a id='$groupHash{'Name'}'> $groupHash{'Name'} </a> </TD>";
		$htmlbody2 .= "<TD> $groupHash{'IP'} </TD></TR>";	
	}
}
$htmlbody .= "</table>";

open (user_report, ">$userReportName") or die "Can't open : $@";

my $htmlhead=<<HTMLHEAD
<HTML>
<head>
</head>
<!--<body bgcolor='#4682B4'>-->
<title>HTML Report</title>
<div align='left'>
<h4> Group and Member Details </h4>
HTMLHEAD
;

my $htmlTable1=<<TABLE1
<table border='2' cellpadding='5' cellspacing='0' bordercolor='#2B4E6C' >

<tr><b>Table 1</b></tr>
<br>
<tr>
	<TD div align='center' bgcolor='#CECED6' width="100" ><font size='4' color='#2B4E6C'>Group</TD> 
	<TD div align='center' bgcolor='#CECED6' width="200" ><font size='4' color='#2B4E6C'>Members</TD>
</tr>
TABLE1
;

my $htmlTailTable1=<<TAILTABLE1
</table>
TAILTABLE1
;

my $htmlTable2=<<TABLE2
<br><br>
<table border='2' cellpadding='5' cellspacing='0' bordercolor='#2B4E6C' >
<tr><b>Table 2</b></tr>
<br>
<tr>
        <TD div align='center' bgcolor='#CECED6' width="100" ><font size='4' color='#2B4E6C'>Hostname</TD>
        <TD div align='center' bgcolor='#CECED6' width="200" ><font size='4' color='#2B4E6C'>IP Address</TD>
</tr>
TABLE2
;

my $htmlTailTable2=<<TAILTABLE2
</table>
TAILTABLE2
;

my $htmltail=<<HTMLTAIL
</body>
</html>

HTMLTAIL
;

print user_report ($htmlhead);
print user_report ($htmlTable1);
print user_report ($htmlbody1);
print user_report ($htmlTailTable1);
print user_report ($htmlTable2);
print user_report ($htmlbody2);
print user_report ($htmlTailTable2);
print user_report ($htmltail);
	
close (user_report);

my $SourceFile = "report_results.csv";
my $DestFile = "user_defined.html";

#`cp $SourceFile $DestFile`;
 

