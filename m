Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f52.google.com ([209.85.214.52]:43884 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752188Ab3AANBX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Jan 2013 08:01:23 -0500
Received: by mail-bk0-f52.google.com with SMTP id w5so5706338bku.11
        for <linux-media@vger.kernel.org>; Tue, 01 Jan 2013 05:01:22 -0800 (PST)
From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To: linux-media@vger.kernel.org
Cc: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH] [media] Fix firmware download for the Terratec Cinergy HTC Stick HD. The file was moved on the server.
Date: Tue,  1 Jan 2013 13:54:26 +0100
Message-Id: <1357044866-6933-1-git-send-email-martin.blumenstingl@googlemail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 Documentation/dvb/get_dvb_firmware | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/dvb/get_dvb_firmware b/Documentation/dvb/get_dvb_firmware
index 32bc56b..543054a 100755
--- a/Documentation/dvb/get_dvb_firmware
+++ b/Documentation/dvb/get_dvb_firmware
@@ -677,7 +677,7 @@ sub drxk_terratec_h5 {
 }
 
 sub drxk_terratec_htc_stick {
-    my $url = "http://ftp.terratec.de/Receiver/Cinergy_HTC_Stick/Updates/";
+    my $url = "http://ftp.terratec.de/Receiver/Cinergy_HTC_Stick/Updates/History/";
     my $zipfile = "Cinergy_HTC_Stick_Drv_5.09.1202.00_XP_Vista_7.exe";
     my $hash = "6722a2442a05423b781721fbc069ed5e";
     my $tmpdir = tempdir(DIR => "/tmp", CLEANUP => 0);
-- 
1.8.0.3

