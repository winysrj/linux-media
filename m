Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:43254 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756573AbaGVUMb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Jul 2014 16:12:31 -0400
From: Matthias Schwarzott <zzam@gentoo.org>
To: crope@iki.fi, m.chehab@samsung.com, linux-media@vger.kernel.org
Cc: Matthias Schwarzott <zzam@gentoo.org>
Subject: [PATCH 1/8] get_dvb_firmware: Add firmware extractor for si2165
Date: Tue, 22 Jul 2014 22:12:11 +0200
Message-Id: <1406059938-21141-2-git-send-email-zzam@gentoo.org>
In-Reply-To: <1406059938-21141-1-git-send-email-zzam@gentoo.org>
References: <1406059938-21141-1-git-send-email-zzam@gentoo.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>
---
 Documentation/dvb/get_dvb_firmware | 33 ++++++++++++++++++++++++++++++++-
 1 file changed, 32 insertions(+), 1 deletion(-)

diff --git a/Documentation/dvb/get_dvb_firmware b/Documentation/dvb/get_dvb_firmware
index d91b8be..26c623d 100755
--- a/Documentation/dvb/get_dvb_firmware
+++ b/Documentation/dvb/get_dvb_firmware
@@ -29,7 +29,7 @@ use IO::Handle;
 		"af9015", "ngene", "az6027", "lme2510_lg", "lme2510c_s7395",
 		"lme2510c_s7395_old", "drxk", "drxk_terratec_h5",
 		"drxk_hauppauge_hvr930c", "tda10071", "it9135", "drxk_pctv",
-		"drxk_terratec_htc_stick", "sms1xxx_hcw");
+		"drxk_terratec_htc_stick", "sms1xxx_hcw", "si2165");
 
 # Check args
 syntax() if (scalar(@ARGV) != 1);
@@ -783,6 +783,37 @@ sub sms1xxx_hcw {
     $allfiles;
 }
 
+sub si2165 {
+    my $sourcefile = "model_111xxx_122xxx_driver_6_0_119_31191_WHQL.zip";
+    my $url = "http://www.hauppauge.de/files/drivers/";
+    my $hash = "76633e7c76b0edee47c3ba18ded99336";
+    my $fwfile = "dvb-demod-si2165.fw";
+    my $tmpdir = tempdir(DIR => "/tmp", CLEANUP => 1);
+
+    checkstandard();
+
+    wgetfile($sourcefile, $url . $sourcefile);
+    verify($sourcefile, $hash);
+    unzip($sourcefile, $tmpdir);
+    extract("$tmpdir/Driver10/Hcw10bda.sys", 0x80788, 0x81E08-0x80788, "$tmpdir/fw1");
+
+    delzero("$tmpdir/fw1","$tmpdir/fw1-1");
+    #verify("$tmpdir/fw1","5e0909858fdf0b5b09ad48b9fe622e70");
+
+    my $CRC="\x0A\xCC";
+    my $BLOCKS_MAIN="\x27";
+    open FW,">$fwfile";
+    print FW "\x01\x00"; # just a version id for the driver itself
+    print FW "\x9A"; # fw version
+    print FW "\x00"; # padding
+    print FW "$BLOCKS_MAIN"; # number of blocks of main part
+    print FW "\x00"; # padding
+    print FW "$CRC"; # 16bit crc value of main part
+    appendfile(FW,"$tmpdir/fw1");
+
+    "$fwfile";
+}
+
 # ---------------------------------------------------------------
 # Utilities
 
-- 
2.0.0

