Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp206.alice.it ([82.57.200.102]:53345 "EHLO smtp206.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756318Ab2JJNj3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Oct 2012 09:39:29 -0400
From: Antonio Ospite <ospite@studenti.unina.it>
To: linux-media@vger.kernel.org
Cc: Aapo Tahkola <aet@rasterburn.org>,
	Antonio Ospite <ospite@studenti.unina.it>,
	CityK <cityk@rogers.com>
Subject: [PATCH 3/5] m920x_parse.pl: use string comparison operators
Date: Wed, 10 Oct 2012 15:39:20 +0200
Message-Id: <1349876363-12098-4-git-send-email-ospite@studenti.unina.it>
In-Reply-To: <1349876363-12098-1-git-send-email-ospite@studenti.unina.it>
References: <1349876363-12098-1-git-send-email-ospite@studenti.unina.it>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

---
 contrib/m920x/m920x_parse.pl |   30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/contrib/m920x/m920x_parse.pl b/contrib/m920x/m920x_parse.pl
index 135ed5a..9093e16 100755
--- a/contrib/m920x/m920x_parse.pl
+++ b/contrib/m920x/m920x_parse.pl
@@ -64,7 +64,7 @@ sub check {
 	@cmp = split(/ /, $cmd);
 	for ($i = 0; $i < scalar(@cmp); $i++) {
 		#print "check $bytes[$i] vs $cmp[$i]\n";
-		if ($cmp[$i] == "-1") {
+		if ($cmp[$i] eq "-1") {
 			next;
 		}
 
@@ -102,7 +102,7 @@ sub get_line {
 	}
 	@cmp = split(/ /, $cmd);
 	for ($i = 0; $i < scalar(@cmp); $i++) {
-		if ($cmp[$i] == "-1") {
+		if ($cmp[$i] eq "-1") {
 			next;
 		}
 
@@ -117,10 +117,10 @@ sub get_line {
 
 sub us_get_write {
 	#print "<$line>\n";
-	if($input == "us" && $line =~ m/>>>\s+([a-fA-F0-9 ]+)/) {
+	if($input eq "us" && $line =~ m/>>>\s+([a-fA-F0-9 ]+)/) {
 		return split(/ /, $1);
 	}
-	if($input == "um") {
+	if($input eq "um") {
 		if($line =~ m/\S+ \S+ \S+ \S+ \S+ \S+ \S+ \S+ \S+ \S+ \S+ = ([a-fA-F0-9 ]+)/) {
 			#print "read match $line\n";
 			return expand_string_long(split(/ /, $1));
@@ -130,10 +130,10 @@ sub us_get_write {
 
 sub get_read {
 	#print "<$line>\n";
-	if($input == "us" && $line =~ m/<<<  ([a-fA-F0-9 ]+)/) {
+	if($input eq "us" && $line =~ m/<<<  ([a-fA-F0-9 ]+)/) {
 		return split(/ /, $1);
 	}
-	if($input == "um") {
+	if($input eq "um") {
 		while($line = <STDIN>) {
 			if($line =~ m/\S+ \S+ \S+ \S+ \S+ \S+ = ([a-fA-F0-9 ]+)/) {
 				return expand_string_long(split(/ /, $1));
@@ -161,11 +161,11 @@ getopts("m:i:", \%opt ) or usage();
 $mode = $opt{m};
 $input = $opt{i};
 
-if ($input != "um" && $input != "us" && $input != "sp") {
+if ($input ne "um" && $input ne "us" && $input ne "sp") {
 	usage();
 }
 
-if ($mode != "fw" && $mode != "i2c") {
+if ($mode ne "fw" && $mode ne "i2c") {
 	usage();
 }
 
@@ -207,9 +207,9 @@ while(@bytes = get_line("-1")) {
 
 	$master_line = $. - 1;
 
-	if ($bytes[0] == "40" && $bytes[1] == "23") {
+	if ($bytes[0] eq "40" && $bytes[1] eq "23") {
 
-		if ($bytes[4] == "80" || $bytes[4] == "00") {
+		if ($bytes[4] eq "80" || $bytes[4] eq "00") {
 			my $multibyte = 0;
 			my $addr;
 
@@ -225,16 +225,16 @@ while(@bytes = get_line("-1")) {
 			@bytes = get_line("40 23");
 
 			$reg = $bytes[2];
-			if ($bytes[4] == "80") {
+			if ($bytes[4] eq "80") {
 				$multibyte = 1;
 			} else {
 				@bytes = get_line("40 23");
 			}
-			#if ($bytes[4] != "40") {
+			#if ($bytes[4] ne "40") {
 			#	print "(missing 40)";
 			#}
 
-			if ($bytes[4] == "80") {
+			if ($bytes[4] eq "80") {
 				if ($multibyte == 0) {
 					$raddr = sprintf("%02x", hex($addr) | 0x1);
 
@@ -245,7 +245,7 @@ while(@bytes = get_line("-1")) {
 				} else {
 					print "$reg = ";
 					@bytes = get_line("c0 23");
-					while ($bytes[4] == "21") {
+					while ($bytes[4] eq "21") {
 						check("c0 23 00 00 21 00 -1 -1", @bytes);
 
 						@bytes = get_read();
@@ -265,7 +265,7 @@ while(@bytes = get_line("-1")) {
 				check("40 23 -1 00 4|00 00 00 00", @bytes);
 				print "reg $reg = $bytes[2]";
 
-				while ($bytes[4] != "40") {
+				while ($bytes[4] ne "40") {
 					@bytes = get_line("40 23");
 					check("40 23 -1 00 4|00 00 00 00", @bytes);
 					print " $bytes[2]";
-- 
1.7.10.4

