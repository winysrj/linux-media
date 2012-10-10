Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp207.alice.it ([82.57.200.103]:54917 "EHLO smtp207.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756334Ab2JJNpT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Oct 2012 09:45:19 -0400
From: Antonio Ospite <ospite@studenti.unina.it>
To: linux-media@vger.kernel.org
Cc: Aapo Tahkola <aet@rasterburn.org>,
	Antonio Ospite <ospite@studenti.unina.it>,
	CityK <cityk@rogers.com>
Subject: [PATCH 4/5] m920x_parse.pl: fix strict and warnings checks
Date: Wed, 10 Oct 2012 15:39:21 +0200
Message-Id: <1349876363-12098-5-git-send-email-ospite@studenti.unina.it>
In-Reply-To: <1349876363-12098-1-git-send-email-ospite@studenti.unina.it>
References: <1349876363-12098-1-git-send-email-ospite@studenti.unina.it>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>
---
 contrib/m920x/m920x_parse.pl |   30 ++++++++++++++++++++----------
 1 file changed, 20 insertions(+), 10 deletions(-)

diff --git a/contrib/m920x/m920x_parse.pl b/contrib/m920x/m920x_parse.pl
index 9093e16..b315400 100755
--- a/contrib/m920x/m920x_parse.pl
+++ b/contrib/m920x/m920x_parse.pl
@@ -3,8 +3,15 @@
 # This ULi M920x specific script processes usbsnoop log files (as well as those which have been parsed by mrec's parser.pl utility).
 # Taken from http://www.linuxtv.org/wiki/index.php/ULi_M920x_parse
 
+use strict;
+use warnings;
 use Getopt::Std;
 
+my $line;
+my $mode;
+my $input;
+my %opt;
+
 sub expand_string {
 	my @arr = ();
 	my ($str) = @_;
@@ -85,6 +92,7 @@ sub get_line {
 	my @ret;
 	my @cmp;
 	my $i;
+	my $foo;
 
 	again:
 	while($line = <STDIN>) {
@@ -169,32 +177,34 @@ if ($mode ne "fw" && $mode ne "i2c") {
 	usage();
 }
 
+my @bytes;
+
 if ($mode eq "fw") {
-	open(out, ">fw") || die "Can't open fw";
+	open(OUT, ">", "fw") || die "Can't open fw";
 
 	while(@bytes = get_line()) {
 		if(scalar(@bytes) <= 1) {
 			last;
 		}
 
-		$len = hex($bytes[6] . $bytes[7]);
+		my $len = hex($bytes[6] . $bytes[7]);
 		if ($len < 32) {
 			next;
 		}
 
-		@fw_bytes = us_get_write();
+		my @fw_bytes = us_get_write();
 		if ($len != scalar(@fw_bytes)) {
 			#note: usbmon will not log bulk writes longer than 32 bytes by default
 			print "bulk size doesn't match! Check usbmon.\n";
 			print $len . " != " . scalar(@fw_bytes) . "\n";
 			exit(0);
 		}
-		print out pack("v", hex($bytes[2] . $bytes[3]));
-		print out pack("v", hex($bytes[4] . $bytes[5]));
-		print out pack("v", scalar(@fw_bytes));
+		print OUT pack("v", hex($bytes[2] . $bytes[3]));
+		print OUT pack("v", hex($bytes[4] . $bytes[5]));
+		print OUT pack("v", scalar(@fw_bytes));
 
 		foreach(@fw_bytes) {
-			print out pack("C", hex($_));
+			print OUT pack("C", hex($_));
 		}
 	}
 	exit(1);
@@ -205,7 +215,7 @@ while(@bytes = get_line("-1")) {
 		last;
 	}
 
-	$master_line = $. - 1;
+	my $master_line = $. - 1;
 
 	if ($bytes[0] eq "40" && $bytes[1] eq "23") {
 
@@ -224,7 +234,7 @@ while(@bytes = get_line("-1")) {
 
 			@bytes = get_line("40 23");
 
-			$reg = $bytes[2];
+			my $reg = $bytes[2];
 			if ($bytes[4] eq "80") {
 				$multibyte = 1;
 			} else {
@@ -236,7 +246,7 @@ while(@bytes = get_line("-1")) {
 
 			if ($bytes[4] eq "80") {
 				if ($multibyte == 0) {
-					$raddr = sprintf("%02x", hex($addr) | 0x1);
+					my $raddr = sprintf("%02x", hex($addr) | 0x1);
 
 					check("40 23 $raddr 00 80 00 00 00", @bytes);
 
-- 
1.7.10.4

