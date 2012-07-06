Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55040 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756009Ab2GFBij (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 5 Jul 2012 21:38:39 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Steven Toth <stoth@kernellabs.com>
Subject: [PATCH] [media] get_dvb_firmware: add logic to get sms1xx-hcw* firmware
Date: Thu,  5 Jul 2012 22:38:30 -0300
Message-Id: <1341538710-21997-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The firmwares are there at the same place for a long time. However,
each time I need to remember where it is, I need to seek at the net.

The better is to just add a logic at the get_dvb_firmare script,
in order to obtain it from a reliable source.

Cc: Steven Toth <stoth@kernellabs.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 Documentation/dvb/get_dvb_firmware |   24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/Documentation/dvb/get_dvb_firmware b/Documentation/dvb/get_dvb_firmware
index 94b0168..12d3952e 100755
--- a/Documentation/dvb/get_dvb_firmware
+++ b/Documentation/dvb/get_dvb_firmware
@@ -29,7 +29,7 @@ use IO::Handle;
 		"af9015", "ngene", "az6027", "lme2510_lg", "lme2510c_s7395",
 		"lme2510c_s7395_old", "drxk", "drxk_terratec_h5",
 		"drxk_hauppauge_hvr930c", "tda10071", "it9135", "it9137",
-		"drxk_pctv", "drxk_terratec_htc_stick");
+		"drxk_pctv", "drxk_terratec_htc_stick", "sms1xxx_hcw");
 
 # Check args
 syntax() if (scalar(@ARGV) != 1);
@@ -766,6 +766,28 @@ sub drxk_pctv {
     "$fwfile";
 }
 
+sub sms1xxx_hcw {
+    my $url = "http://steventoth.net/linux/sms1xxx/";
+    my %files = (
+	'sms1xxx-hcw-55xxx-dvbt-01.fw'  => "afb6f9fb9a71d64392e8564ef9577e5a",
+	'sms1xxx-hcw-55xxx-dvbt-02.fw'  => "b44807098ba26e52cbedeadc052ba58f",
+	'sms1xxx-hcw-55xxx-isdbt-02.fw' => "dae934eeea85225acbd63ce6cfe1c9e4",
+    );
+
+    checkstandard();
+
+    my $allfiles;
+    foreach my $fwfile (keys %files) {
+	wgetfile($fwfile, "$url/$fwfile");
+	verify($fwfile, $files{$fwfile});
+	$allfiles .= " $fwfile";
+    }
+
+    $allfiles =~ s/^\s//;
+
+    $allfiles;
+}
+
 # ---------------------------------------------------------------
 # Utilities
 
-- 
1.7.10.4

