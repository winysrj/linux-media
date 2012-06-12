Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:53931 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753336Ab2FLWTi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Jun 2012 18:19:38 -0400
Received: by weyu7 with SMTP id u7so40014wey.19
        for <linux-media@vger.kernel.org>; Tue, 12 Jun 2012 15:19:37 -0700 (PDT)
From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To: linux-media@vger.kernel.org
Cc: sven.pilz@gmail.com, soeren.moch@ims.uni-hannover.de,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH 2/3] [media] em28xx: Add the DRX-K at I2C address 0x29 to the list of known I2C devices.
Date: Wed, 13 Jun 2012 00:19:27 +0200
Message-Id: <1339539568-7725-3-git-send-email-martin.blumenstingl@googlemail.com>
In-Reply-To: <1339539568-7725-1-git-send-email-martin.blumenstingl@googlemail.com>
References: <1339539568-7725-1-git-send-email-martin.blumenstingl@googlemail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 drivers/media/video/em28xx/em28xx-i2c.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/video/em28xx/em28xx-i2c.c b/drivers/media/video/em28xx/em28xx-i2c.c
index 185db65..1683bd9 100644
--- a/drivers/media/video/em28xx/em28xx-i2c.c
+++ b/drivers/media/video/em28xx/em28xx-i2c.c
@@ -475,6 +475,7 @@ static struct i2c_client em28xx_client_template = {
  */
 static char *i2c_devs[128] = {
 	[0x4a >> 1] = "saa7113h",
+	[0x52 >> 1] = "drxk",
 	[0x60 >> 1] = "remote IR sensor",
 	[0x8e >> 1] = "remote IR sensor",
 	[0x86 >> 1] = "tda9887",
-- 
1.7.10.4

