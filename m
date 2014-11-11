Return-path: <linux-media-owner@vger.kernel.org>
Received: from elasmtp-dupuy.atl.sa.earthlink.net ([209.86.89.62]:33881 "EHLO
	elasmtp-dupuy.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752351AbaKKWnw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Nov 2014 17:43:52 -0500
Received: from [24.206.115.17] (helo=[192.168.1.7])
	by elasmtp-dupuy.atl.sa.earthlink.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.67)
	(envelope-from <thebitpit@earthlink.net>)
	id 1XoKAB-0006n5-VV
	for linux-media@vger.kernel.org; Tue, 11 Nov 2014 17:43:52 -0500
Message-ID: <54629127.2000004@earthlink.net>
Date: Tue, 11 Nov 2014 16:43:51 -0600
From: The Bit Pit <thebitpit@earthlink.net>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] add "lgdt330x" device name i2c_devs array
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>From Wilson Michaels <thebitpit@earthlink.net>

This patch adds "lgdt330x" device name i2c_devs array used for debugging

Signed-off-by: Wilson Michaels <thebitpit@earthlink.net>

#
# On branch media_tree/master
# Your branch is up-to-date with 'r_media_tree/master'.
#
# Changes to be committed:
# modified:   drivers/media/usb/em28xx/em28xx-i2c.c
#
diff --git a/drivers/media/usb/em28xx/em28xx-i2c.c
b/drivers/media/usb/em28xx/em28xx-i2c.c
index 1048c1a..5bc6ef1 100644
--- a/drivers/media/usb/em28xx/em28xx-i2c.c
+++ b/drivers/media/usb/em28xx/em28xx-i2c.c
@@ -877,6 +877,7 @@ static struct i2c_client em28xx_client_template = {
  * incomplete list of known devices
  */
 static char *i2c_devs[128] = {
+       [0x1c >> 1] = "lgdt330x",
        [0x3e >> 1] = "remote IR sensor",
        [0x4a >> 1] = "saa7113h",
        [0x52 >> 1] = "drxk",


