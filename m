Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp209.alice.it ([82.57.200.105]:37349 "EHLO smtp209.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754675Ab2JJNpG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Oct 2012 09:45:06 -0400
From: Antonio Ospite <ospite@studenti.unina.it>
To: linux-media@vger.kernel.org
Cc: Aapo Tahkola <aet@rasterburn.org>, CityK <cityk@rogers.com>
Subject: [PATCH 2/5] contrib: add a script to convert usbmon captures to usbsnoop
Date: Wed, 10 Oct 2012 15:39:19 +0200
Message-Id: <1349876363-12098-3-git-send-email-ospite@studenti.unina.it>
In-Reply-To: <1349876363-12098-1-git-send-email-ospite@studenti.unina.it>
References: <1349876363-12098-1-git-send-email-ospite@studenti.unina.it>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Aapo Tahkola <aet@rasterburn.org>

This makes it possible to reuse tools written for usbsnoop with captures
done using a virtual machine and usbmon.

Signed-off-by: Aapo Tahkola <aet@rasterburn.org>
---
 contrib/usbmon2usbsnoop.pl |   53 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 53 insertions(+)
 create mode 100755 contrib/usbmon2usbsnoop.pl

diff --git a/contrib/usbmon2usbsnoop.pl b/contrib/usbmon2usbsnoop.pl
new file mode 100755
index 0000000..c656687
--- /dev/null
+++ b/contrib/usbmon2usbsnoop.pl
@@ -0,0 +1,53 @@
+#!/usr/bin/perl
+#
+# This perl script converts output from usbmon to a format (usbsnoop's log format) that is compatible with usbreplay.
+# Taken from http://www.linuxtv.org/wiki/index.php/Usbmon2usbsnoop
+
+sub print_bytes{
+	my($str) = @_;
+
+	@str_1 = split(/ /, $str);
+
+	foreach(@str_1){
+		if (length($_) == 8) {
+			print substr($_, 0, 2) . " " . substr($_, 2, 2) . " " . substr($_, 4, 2) . " " . substr($_, 6, 2);
+		}elsif(length($_) == 4) {
+			print substr($_, 2, 2) . " " . substr($_, 0, 2);
+		}elsif(length($_) == 2) {
+			print $_;
+		}elsif(length($_) == 1) {
+			next;
+		}
+		print " ";
+	}
+}
+
+
+$i = 0;
+while($line = <STDIN>) {
+	$i++;
+
+	if($line =~ m/\S+ \S+ \S+ \S+ \S+ (.+) \S+ </) {
+		printf "%06d:  OUT: %06d ms %06d ms ", $i, 1, $i;
+		print_bytes($1);
+		print "<<< ";
+		$line = <STDIN>;
+		$i++;
+		if($line =~ m/\S+ \S+ \S+ \S+ [a-fA-F0-9 ]+ = ([a-fA-F0-9 ]+)/) {
+			print_bytes($1);
+			#print "\n";
+			#print " $1\n";
+		}
+		print "\n";
+	}elsif($line =~ m/\S+ \S+ \S+ \S+ ([a-fA-F0-9 ]+) [a-fA-F0-9]+ = ([a-fA-F0-9 ]+)/) {
+		printf "%06d:  OUT: %06d ms %06d ms ", $i, 1, $i;
+		print_bytes($1);
+		print ">>> ";
+		print_bytes($2);
+		print "\n";
+	}elsif($line =~ m/\S+ \S+ \S+ \S+ s (.+)/) {
+		printf "%06d:  OUT: %06d ms %06d ms ", $i, 1, $i;
+		print_bytes($1);
+		print ">>>\n";
+	}
+}
-- 
1.7.10.4

