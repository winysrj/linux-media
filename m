Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f47.google.com ([209.85.214.47]:61420 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150Ab3AAMxg (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Jan 2013 07:53:36 -0500
Received: by mail-bk0-f47.google.com with SMTP id j4so5657567bkw.20
        for <linux-media@vger.kernel.org>; Tue, 01 Jan 2013 04:53:34 -0800 (PST)
From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To: martin.blumenstingl@googlemail.com
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] [media] Fix firmware download for the Terratec Cinergy HTC Stick HD. The file was moved on the server.
Date: Tue,  1 Jan 2013 13:53:26 +0100
Message-Id: <1357044806-6867-1-git-send-email-martin.blumenstingl@googlemail.com>
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

