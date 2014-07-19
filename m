Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:35734 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760216AbaGSCis (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Jul 2014 22:38:48 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Matthias Schwarzott <zzam@gentoo.org>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH 08/10] em28xx-dvb: Prepare for si2157 driver getting more parameters
Date: Sat, 19 Jul 2014 05:38:24 +0300
Message-Id: <1405737506-13186-8-git-send-email-crope@iki.fi>
In-Reply-To: <1405737506-13186-1-git-send-email-crope@iki.fi>
References: <1405737506-13186-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Matthias Schwarzott <zzam@gentoo.org>

Modify all users of si2157_config to correctly initialize all not
listed values to 0.

Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>
Signed-off-by: Antti Palosaari <crope@iki.fi>
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
1.9.3

