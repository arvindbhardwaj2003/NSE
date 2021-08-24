#!/usr/bin/perl

package NSEFunction;

###########################################################################################
#					REVISION HISTORY
#	 				 								
# DATE				NAME					COMMENT
# 18 Aug 2021 		Arvind Bhardwaj			Creation: Addded subroutine getCustomFieldValue()
#
#				
###########################################################################################

use strict;
use warnings;

use lib qw(/usr/share/fireflow/local/etc/site/lib/NSE/);
use XML::Simple;
use Data::Dumper;

#Set a flag for debugging
my $debug = 1;

##########################################################################################
#	Method Name: getCustomFieldValue
#
##########################################################################################
#
#	Description: This subroutine is used to fetch Custom Field Value for NSE
#	
#	Input: Ticket* , XML value of ticket*
#
#	Output: Success/Failure
#				
##########################################################################################

sub getCustomFieldValue {

	my $ticket = shift;
	my $val = shift;

	my $env;
	my $mkt ;
	my @envArray;

	


	if (ref($val->{'Environment'}) eq 'ARRAY'){
	   @envArray = @{$val->{'Environment'}};
		$env = join(',',@{$val->{'Environment'}});
	}
	else {
	  $env = $val->{'Environment'};
	}

	if (ref($val->{'Market'}) eq 'ARRAY'){
	  my @mktArray = @{$val->{'Market'}};
	  $mkt = join(',', @{$val->{'Market'}});
	}
	else {
	  $mkt = $val->{'Market'};
	}


	$RT::Logger->info("Arvind ticket XML is: " . Dumper (@envArray));

	#$RT::Logger->info("Arvind Environment: " . Dumper ($val->{'Environment'}));

	#$RT::Logger->info("Arvind Market: " . Dumper ($val->{'Market'}));

	$RT::Logger->info("Arvind Environment: $env" );

	$RT::Logger->info("Arvind Market: $mkt" );

	if(!$env){
		$RT::Logger->info("Environment cannot be empty. Exiting with error from getCustomFieldValue");
		return 0;
	}
	elsif(!$mkt){
		$RT::Logger->info("Market cannot be empty. Exiting with error from getCustomFieldValue");
		return 0;
	}
	else{
		return($env, $mkt);
	}


}

##########################################################################################
#	Method Name: getFWNamePerEnvironment
#
##########################################################################################
#
#	Description: This subroutine is used to fetch DeviceName based on Environment 
#				 value saved in Fireflow configuration parameters
#	
#	Input: Environment* 
#
#	Output: Success/Failure
#			DeviceName
#				
##########################################################################################

sub getFWNamePerEnvironment{
	my $args = shift;
	
	#Check if mandatory parameters are missing, return error
	if(!$$args{'Environment'}){
		$RT::Logger->info("Information about 'Environment' is missing. Exiting with error from getFWNamePerEnvironment");
		return 0;
	}

	#Collect mandatory and optional parameters
	my $env = $$args{'Environment'};
	my $completeEnv = '';
	
	#Create actual param name
	if($env =~ m/PROD|COLO/){
		$completeEnv = "PROD_COLO_FW";
	}
	else{
		$completeEnv = $env . "_FW";
	}
	
	#Let's fetch the value of environment from fireflow configuration paramters
	my $deviceName = RT->Config->Get($completeEnv);
	
	$RT::Logger->info("Device name fetched is $deviceName ");
	print "Device name fetched is $deviceName";
	
	if(!$deviceName){
		$RT::Logger->info("DeviceName cannot be empty. Exiting with error from getFWNamePerEnvironment");
		return 0;
	}
	
	return $deviceName;
}

##########################################################################################
#	Method Name: getGroupNamePerMarket
#
##########################################################################################
#
#	Description: This subroutine is used to fetch GroupName based on member 
#				 value saved in Fireflow configuration parameters
#	
#	Input: Market* 
#
#	Output: Success/Failure
#			groupName
#				
##########################################################################################

sub getGroupNamePerMarket{
	my $args = shift;
	
	#Check if mandatory parameters are missing, return error
	if(!$$args{'Market'}){
		$RT::Logger->info("Information about 'Market' is missing. Exiting with error from getGroupNamePerMarket");
		return 0;
	}
	#Check if mandatory parameters are missing, return error
	if(!$$args{'Environment'}){
		$RT::Logger->info("Information about 'Environment' is missing. Exiting with error from getGroupNamePerMarket");
		return 0;
	}
	
	#Collect mandatory and optional parameters
	my $market = $$args{'Market'};
	my $env = $$args{'Environment'};
	
	#Create actual param name
	my $completeMkt = $market . $env;
	
	#Let's fetch the value of environment from fireflow configuration paramters
	my $groupName = RT->Config->Get($completeMkt);
	
	$RT::Logger->info("Group name fetched is $groupName ");
	print "Group name fetched is $groupName";
	
	if(!$groupName){
		$RT::Logger->info("GroupName cannot be empty. Exiting with error from getGroupNamePerMarket");
		return 0;
	}
	+
	return $groupName;
}

##########################################################################################
#	Method Name: getGroupNamePerMarket
#
##########################################################################################
#
#	Description: This subroutine is used to fetch Group List  based on member 
#				 value saved in Fireflow configuration parameters
#	
#	Input: Market* 
#
#	Output: Success/Failure
#			groupName
#				
##########################################################################################

sub getAndSetLatestGroupName{
	my $args = shift;
	
	#Check if mandatory parameters are missing, return error
	if(!$$args{'Market'}){
		$RT::Logger->info("Information about 'Market' is missing. Exiting with error from getAndSetLatestGroupName");
		return 0;
	}
	#Check if mandatory parameters are missing, return error
	if(!$$args{'Environment'}){
		$RT::Logger->info("Information about 'Environment' is missing. Exiting with error from getAndSetLatestGroupName");
		return 0;
	}
	
	#Collect mandatory and optional parameters
	my $market = $$args{'Market'};
	my $env = $$args{'Environment'};
	
	#First call the func for device name
	# obtain session id
	#call function for group name
	# call another function to obtain all group per device
	
	#Create actual param name
	my $completeMkt = $market . $env;
	
	#Let's fetch the value of environment from fireflow configuration paramters
	my $groupName = RT->Config->Get($completeMkt);
	
	$RT::Logger->info("Group name fetched is $groupName ");
	print "Group name fetched is $groupName";
	
	if(!$groupName){
		$RT::Logger->info("GroupName cannot be empty. Exiting with error from getAndSetLatestGroupName");
		return 0;
	}
	+
	return $groupName;
}

#

##########################################################################################
#	Method Name: setCustomField
#
##########################################################################################
#
#	Description: Just a quick subroutine to simplify the process of setting an AFF ticket's custom field
#	
#	Input: Ticket Object and Custom Field Name
#
#	Output: Updated Custom Field
#				
##########################################################################################
sub setCustomField{
  my $ticket = shift;
  my $cf_name = shift;
  my $cf_value = shift;
  $RT::Logger->info("PS: HP Integration setting custom field [$cf_name] for FireFlow [ ". $ticket->id() ." ] to value [ $cf_value ].");
  $ticket->MarkTicketAsAllowToChangeCFs();
  my $cf = RT::CustomField->new($RT::SystemUser);
  $cf->Load($cf_name);
  $ticket->AddCustomFieldValue(Field => $cf, Value => "$cf_value");
  $ticket->UnMarkTicketAsAllowToChangeCFs();
	return 1;
}

1;
