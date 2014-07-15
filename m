Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:45847 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933304AbaGOTfD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Jul 2014 15:35:03 -0400
From: Matthias Schwarzott <zzam@gentoo.org>
To: crope@iki.fi, linux-media@vger.kernel.org
Cc: Matthias Schwarzott <zzam@gentoo.org>
Subject: [PATCH 2/3] em28xx-dvb: Prepare for si2157 driver getting more parameters
Date: Tue, 15 Jul 2014 21:34:35 +0200
Message-Id: <1405452876-8543-2-git-send-email-zzam@gentoo.org>
In-Reply-To: <53C58067.8000601@gentoo.org>
References: <53C58067.8000601@gentoo.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Modify all users of si2157_config to correctly initialize all not
listed values to 0.

Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>
---
 drivers/media/usb/em28xx/em28xx-dvb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
index a121ed9..96a0bdb 100644
--- a/drivers/media/usb/em28xx/em28xx-dvb.c
+++ b/drivers/media/usb/em28xx/em28xx-dvb.c
@@ -1545,6 +1545,7 @@ static int em28xx_dvb_init(struct em28xx *dev)
 			dvb->i2c_client_demod = client;
 
 			/* attach tuner */
+			memset(&si2157_config, 0, sizeof(si2157_config));
 			si2157_config.fe = dvb->fe[0];
 			memset(&info, 0, sizeof(struct i2c_board_info));
 			strlcpy(info.type, "si2157", I2C_NAME_SIZE);
-- 
2.0.0

