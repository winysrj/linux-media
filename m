Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:42449 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752018AbaKBMcs (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 2 Nov 2014 07:32:48 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Matthias Schwarzott <zzam@gentoo.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Antti Palosaari <crope@iki.fi>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: [PATCHv2 06/14] [media] cx231xx: use 1 byte read for i2c scan
Date: Sun,  2 Nov 2014 10:32:29 -0200
Message-Id: <56a0c18deacf14045b569771d03c8e3a5f82b1bf.1414929816.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1414929816.git.mchehab@osg.samsung.com>
References: <cover.1414929816.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1414929816.git.mchehab@osg.samsung.com>
References: <cover.1414929816.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Matthias Schwarzott <zzam@gentoo.org>

Now cx231xx_i2c_check_for_device works like i2c_check_for_device of em28xx driver.

For me this fixes scanning of all ports but port 2.

Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/usb/cx231xx/cx231xx-i2c.c b/drivers/media/usb/cx231xx/cx231xx-i2c.c
index 1a0d9efeb209..5a0604711be0 100644
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
1.9.3

