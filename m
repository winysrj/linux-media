Return-path: <linux-media-owner@vger.kernel.org>
Received: from szxga07-in.huawei.com ([45.249.212.35]:49722 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725953AbeINHgu (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Sep 2018 03:36:50 -0400
From: YueHaibing <yuehaibing@huawei.com>
To: Antti Palosaari <crope@iki.fi>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
CC: YueHaibing <yuehaibing@huawei.com>, <linux-media@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>
Subject: [PATCH -next] media: dvb-usb-v2/gl861: Use kmemdup rather than duplicating its implementation in gl861_i2c_write_ex
Date: Fri, 14 Sep 2018 02:34:23 +0000
Message-ID: <1536892463-129710-1-git-send-email-yuehaibing@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use kmemdup rather than duplicating its implementation

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/media/usb/dvb-usb-v2/gl861.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/gl861.c b/drivers/media/usb/dvb-usb-v2/gl861.c
index 0559417..80fed44 100644
--- a/drivers/media/usb/dvb-usb-v2/gl861.c
+++ b/drivers/media/usb/dvb-usb-v2/gl861.c
@@ -200,11 +200,10 @@ struct friio_config {
 	u8 *buf;
 	int ret;
 
-	buf = kmalloc(wlen, GFP_KERNEL);
+	buf = kmemdup(wbuf, wlen, GFP_KERNEL);
 	if (!buf)
 		return -ENOMEM;
 
-	memcpy(buf, wbuf, wlen);
 	ret = usb_control_msg(d->udev, usb_sndctrlpipe(d->udev, 0),
 				 GL861_REQ_I2C_RAW, GL861_WRITE,
 				 addr << (8 + 1), 0x0100, buf, wlen, 2000);
