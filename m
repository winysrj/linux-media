Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:50161 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758469AbaKAUTc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 1 Nov 2014 16:19:32 -0400
From: Matthias Schwarzott <zzam@gentoo.org>
To: mchehab@osg.samsung.com, linux-media@vger.kernel.org
Cc: mchehab@infradead.org, crope@iki.fi, hans.verkuil@cisco.com,
	Matthias Schwarzott <zzam@gentoo.org>
Subject: [PATCH] cx231xx: use 1 byte read for i2c scan
Date: Sat,  1 Nov 2014 21:19:21 +0100
Message-Id: <1414873161-23668-1-git-send-email-zzam@gentoo.org>
In-Reply-To: <54550E71.9010006@gentoo.org>
References: <54550E71.9010006@gentoo.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now cx231xx_i2c_check_for_device works like i2c_check_for_device of em28xx driver.

For me this fixes scanning of all ports but port 2.

Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>
---
 drivers/media/usb/cx231xx/cx231xx-i2c.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/media/usb/cx231xx/cx231xx-i2c.c b/drivers/media/usb/cx231xx/cx231xx-i2c.c
index d1003c7..fe17a13 100644
--- a/drivers/media/usb/cx231xx/cx231xx-i2c.c
+++ b/drivers/media/usb/cx231xx/cx231xx-i2c.c
@@ -350,14 +350,15 @@ static int cx231xx_i2c_check_for_device(struct i2c_adapter *i2c_adap,
 	struct cx231xx *dev = bus->dev;
 	struct cx231xx_i2c_xfer_data req_data;
 	int status = 0;
+	u8 buf[1];
 
 	/* prepare xfer_data struct */
 	req_data.dev_addr = msg->addr;
-	req_data.direction = msg->flags;
+	req_data.direction = I2C_M_RD;
 	req_data.saddr_len = 0;
 	req_data.saddr_dat = 0;
-	req_data.buf_size = 0;
-	req_data.p_buffer = NULL;
+	req_data.buf_size = 1;
+	req_data.p_buffer = buf;
 
 	/* usb send command */
 	status = dev->cx231xx_send_usb_command(bus, &req_data);
-- 
2.1.3

