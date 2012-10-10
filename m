Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp208.alice.it ([82.57.200.104]:42502 "EHLO smtp208.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756330Ab2JJNj3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Oct 2012 09:39:29 -0400
From: Antonio Ospite <ospite@studenti.unina.it>
To: linux-media@vger.kernel.org
Cc: Aapo Tahkola <aet@rasterburn.org>,
	Antonio Ospite <ospite@studenti.unina.it>,
	CityK <cityk@rogers.com>
Subject: [PATCH 5/5] m920x_parse.pl: add support for consuming the output of parse-sniffusb2.pl
Date: Wed, 10 Oct 2012 15:39:22 +0200
Message-Id: <1349876363-12098-6-git-send-email-ospite@studenti.unina.it>
In-Reply-To: <1349876363-12098-1-git-send-email-ospite@studenti.unina.it>
References: <1349876363-12098-1-git-send-email-ospite@studenti.unina.it>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

---
 contrib/m920x/m920x_parse.pl |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/contrib/m920x/m920x_parse.pl b/contrib/m920x/m920x_parse.pl
index b315400..b309250 100755
--- a/contrib/m920x/m920x_parse.pl
+++ b/contrib/m920x/m920x_parse.pl
@@ -103,6 +103,13 @@ sub get_line {
 			last;
 		}
 
+		#40 23 c0 00 80 00 00 00 >>>
+		if($input eq "us2" && $line =~ m/([a-fA-F0-9 ]+)/) {
+			@ret = split(/ /, $1); $foo = $1;
+			@ret[2,3,4,5,6,7] = @ret[3,2,5,4,7,6];
+			last;
+		}
+
 		if($input eq "um" && $line =~ m/\S+ \S+ \S+ \S+ s ([a-fA-F0-9 ]+)/) {
 			@ret = expand_string_long(split(/ /, $1)); $foo = $1;
 			last;
@@ -125,7 +132,7 @@ sub get_line {
 
 sub us_get_write {
 	#print "<$line>\n";
-	if($input eq "us" && $line =~ m/>>>\s+([a-fA-F0-9 ]+)/) {
+	if(($input eq "us" || $input eq "us2") && $line =~ m/>>>\s+([a-fA-F0-9 ]+)/) {
 		return split(/ /, $1);
 	}
 	if($input eq "um") {
@@ -138,7 +145,7 @@ sub us_get_write {
 
 sub get_read {
 	#print "<$line>\n";
-	if($input eq "us" && $line =~ m/<<<  ([a-fA-F0-9 ]+)/) {
+	if(($input eq "us" || $input eq "us2") && $line =~ m/<<<\s+([a-fA-F0-9 ]+)/) {
 		return split(/ /, $1);
 	}
 	if($input eq "um") {
@@ -156,6 +163,7 @@ sub usage {
 
 	-i	um (usbmon)
 		us (usb snoop)
+		us2 (usb snoop as produced by parse-sniffusb2.pl)
 		sp (snoopy pro)
 
 	-m	fw (extract firmware)
@@ -169,7 +177,7 @@ getopts("m:i:", \%opt ) or usage();
 $mode = $opt{m};
 $input = $opt{i};
 
-if ($input ne "um" && $input ne "us" && $input ne "sp") {
+if ($input ne "um" && $input ne "us" && $input ne "us2" && $input ne "sp") {
 	usage();
 }
 
-- 
1.7.10.4

