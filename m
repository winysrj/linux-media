Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:56700 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751507AbaHIU1c (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 9 Aug 2014 16:27:32 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Bimow Chen <Bimow.Chen@ite.com.tw>, Antti Palosaari <crope@iki.fi>
Subject: [PATCH 01/14] get_dvb_firmware: Update firmware of ITEtech IT9135
Date: Sat,  9 Aug 2014 23:26:59 +0300
Message-Id: <1407616032-2722-2-git-send-email-crope@iki.fi>
In-Reply-To: <1407616032-2722-1-git-send-email-crope@iki.fi>
References: <1407616032-2722-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Bimow Chen <Bimow.Chen@ite.com.tw>

IT9135 firmware update.

Signed-off-by: Bimow Chen <Bimow.Chen@ite.com.tw>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 Documentation/dvb/get_dvb_firmware | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/Documentation/dvb/get_dvb_firmware b/Documentation/dvb/get_dvb_firmware
index 26c623d..91b43d2 100755
--- a/Documentation/dvb/get_dvb_firmware
+++ b/Documentation/dvb/get_dvb_firmware
@@ -708,23 +708,25 @@ sub drxk_terratec_htc_stick {
 }
 
 sub it9135 {
-	my $sourcefile = "dvb-usb-it9135.zip";
-	my $url = "http://www.ite.com.tw/uploads/firmware/v3.6.0.0/$sourcefile";
-	my $hash = "1e55f6c8833f1d0ae067c2bb2953e6a9";
-	my $tmpdir = tempdir(DIR => "/tmp", CLEANUP => 0);
-	my $outfile = "dvb-usb-it9135.fw";
+	my $url = "http://www.ite.com.tw/uploads/firmware/v3.25.0.0/";
+	my $file1 = "dvb-usb-it9135-01.zip";
 	my $fwfile1 = "dvb-usb-it9135-01.fw";
+	my $hash1 = "02fcf11174eda84745dae7e61c5ff9ba";
+	my $file2 = "dvb-usb-it9135-02.zip";
 	my $fwfile2 = "dvb-usb-it9135-02.fw";
+	my $hash2 = "d5e1437dc24358578e07999475d4cac9";
 
 	checkstandard();
 
-	wgetfile($sourcefile, $url);
-	unzip($sourcefile, $tmpdir);
-	verify("$tmpdir/$outfile", $hash);
-	extract("$tmpdir/$outfile", 64, 8128, "$fwfile1");
-	extract("$tmpdir/$outfile", 12866, 5817, "$fwfile2");
+	wgetfile($file1, $url . $file1);
+	unzip($file1, "");
+	verify("$fwfile1", $hash1);
+
+	wgetfile($file2, $url . $file2);
+	unzip($file2, "");
+	verify("$fwfile2", $hash2);
 
-	"$fwfile1 $fwfile2"
+	"$file1 $file2"
 }
 
 sub tda10071 {
-- 
http://palosaari.fi/

