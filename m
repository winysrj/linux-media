Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f48.google.com ([209.85.215.48]:33316 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031025AbbDWVLo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Apr 2015 17:11:44 -0400
Received: by layy10 with SMTP id y10so22026755lay.0
        for <linux-media@vger.kernel.org>; Thu, 23 Apr 2015 14:11:42 -0700 (PDT)
From: Olli Salonen <olli.salonen@iki.fi>
To: linux-media@vger.kernel.org
Cc: Olli Salonen <olli.salonen@iki.fi>
Subject: [PATCH 10/12] em28xx: specify if_port for si2157 devices
Date: Fri, 24 Apr 2015 00:11:09 +0300
Message-Id: <1429823471-21835-10-git-send-email-olli.salonen@iki.fi>
In-Reply-To: <1429823471-21835-1-git-send-email-olli.salonen@iki.fi>
References: <1429823471-21835-1-git-send-email-olli.salonen@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Set the if_port parameter for all Si2157-based devices.

Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
---
 drivers/media/usb/em28xx/em28xx-dvb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
index a5b22c5..5b7c7c88 100644
--- a/drivers/media/usb/em28xx/em28xx-dvb.c
+++ b/drivers/media/usb/em28xx/em28xx-dvb.c
@@ -1579,6 +1579,7 @@ static int em28xx_dvb_init(struct em28xx *dev)
 			/* attach tuner */
 			memset(&si2157_config, 0, sizeof(si2157_config));
 			si2157_config.fe = dvb->fe[0];
+			si2157_config.if_port = 1;
 			memset(&info, 0, sizeof(struct i2c_board_info));
 			strlcpy(info.type, "si2157", I2C_NAME_SIZE);
 			info.addr = 0x60;
@@ -1639,6 +1640,7 @@ static int em28xx_dvb_init(struct em28xx *dev)
 			/* attach tuner */
 			memset(&si2157_config, 0, sizeof(si2157_config));
 			si2157_config.fe = dvb->fe[0];
+			si2157_config.if_port = 0;
 			memset(&info, 0, sizeof(struct i2c_board_info));
 			strlcpy(info.type, "si2146", I2C_NAME_SIZE);
 			info.addr = 0x60;
-- 
1.9.1

