Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:37285 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755002Ab2CSPse (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Mar 2012 11:48:34 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 1/2] get_dvb_firmware: add dvb-demod-drxk-pctv.fw
Date: Mon, 19 Mar 2012 17:48:18 +0200
Message-Id: <1332172099-7210-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Firmware for the PCTV QuatroStick nano (520e).

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 Documentation/dvb/get_dvb_firmware |   20 +++++++++++++++++++-
 1 files changed, 19 insertions(+), 1 deletions(-)

diff --git a/Documentation/dvb/get_dvb_firmware b/Documentation/dvb/get_dvb_firmware
index d1d4a17..fbb2411 100755
--- a/Documentation/dvb/get_dvb_firmware
+++ b/Documentation/dvb/get_dvb_firmware
@@ -28,7 +28,8 @@ use IO::Handle;
 		"opera1", "cx231xx", "cx18", "cx23885", "pvrusb2", "mpc718",
 		"af9015", "ngene", "az6027", "lme2510_lg", "lme2510c_s7395",
 		"lme2510c_s7395_old", "drxk", "drxk_terratec_h5",
-		"drxk_hauppauge_hvr930c", "tda10071", "it9135", "it9137");
+		"drxk_hauppauge_hvr930c", "tda10071", "it9135", "it9137",
+		"drxk_pctv");
 
 # Check args
 syntax() if (scalar(@ARGV) != 1);
@@ -730,6 +731,23 @@ sub tda10071 {
     "$fwfile";
 }
 
+sub drxk_pctv {
+    my $sourcefile = "PCTV_460e_reference.zip";
+    my $url = "ftp://ftp.pctvsystems.com/TV/driver/PCTV%2070e%2080e%20100e%20320e%20330e%20800e/";
+    my $hash = "4403de903bf2593464c8d74bbc200a57";
+    my $fwfile = "dvb-demod-drxk-pctv.fw";
+    my $tmpdir = tempdir(DIR => "/tmp", CLEANUP => 1);
+
+    checkstandard();
+
+    wgetfile($sourcefile, $url . $sourcefile);
+    verify($sourcefile, $hash);
+    unzip($sourcefile, $tmpdir);
+    extract("$tmpdir/PCTV\ 70e\ 80e\ 100e\ 320e\ 330e\ 800e/32\ bit/emOEM.sys", 0x72b80, 42692, $fwfile);
+
+    "$fwfile";
+}
+
 # ---------------------------------------------------------------
 # Utilities
 
-- 
1.7.7.6

