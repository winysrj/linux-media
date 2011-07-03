Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.23]:50881 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751253Ab1GCQ5m (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 3 Jul 2011 12:57:42 -0400
From: Oliver Endriss <o.endriss@gmx.de>
To: linux-media@vger.kernel.org
Subject: [PATCH 07/16] get_dvb_firmware: Get DRX-K firmware for Digital Devices DVB-CT cards
Date: Sun, 3 Jul 2011 18:53:50 +0200
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
References: <201107031831.20378@orion.escape-edv.de>
In-Reply-To: <201107031831.20378@orion.escape-edv.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201107031853.51404@orion.escape-edv.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Get DRX-K firmware for Digital Devices DVB-CT cards

Signed-off-by: Oliver Endriss <o.endriss@gmx.de>
---
 Documentation/dvb/get_dvb_firmware |   20 +++++++++++++++++++-
 1 files changed, 19 insertions(+), 1 deletions(-)

diff --git a/Documentation/dvb/get_dvb_firmware b/Documentation/dvb/get_dvb_firmware
index 3348d31..224d9e6 100644
--- a/Documentation/dvb/get_dvb_firmware
+++ b/Documentation/dvb/get_dvb_firmware
@@ -27,7 +27,7 @@ use IO::Handle;
 		"or51211", "or51132_qam", "or51132_vsb", "bluebird",
 		"opera1", "cx231xx", "cx18", "cx23885", "pvrusb2", "mpc718",
 		"af9015", "ngene", "az6027", "lme2510_lg", "lme2510c_s7395",
-		"lme2510c_s7395_old");
+		"lme2510c_s7395_old", "drxk");
 
 # Check args
 syntax() if (scalar(@ARGV) != 1);
@@ -634,6 +634,24 @@ sub lme2510c_s7395_old {
     $outfile;
 }
 
+sub drxk {
+    my $url = "http://l4m-daten.de/files/";
+    my $zipfile = "DDTuner.zip";
+    my $hash = "f5a37b9a20a3534997997c0b1382a3e5";
+    my $tmpdir = tempdir(DIR => "/tmp", CLEANUP => 1);
+    my $drvfile = "DDTuner.sys";
+    my $fwfile = "drxk_a3.mc";
+
+    checkstandard();
+
+    wgetfile($zipfile, $url . $zipfile);
+    verify($zipfile, $hash);
+    unzip($zipfile, $tmpdir);
+    extract("$tmpdir/$drvfile", 0x14dd8, 15634, "$fwfile");
+
+    "$fwfile"
+}
+
 # ---------------------------------------------------------------
 # Utilities
 
-- 
1.7.4.1

