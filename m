Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:46825 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S938979AbcJGRYr (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 7 Oct 2016 13:24:47 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Johannes Stezenbach <js@linuxtv.org>,
        Jiri Kosina <jikos@kernel.org>,
        Patrick Boettcher <patrick.boettcher@posteo.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        =?UTF-8?q?J=C3=B6rg=20Otte?= <jrg.otte@gmail.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [PATCH 16/26] dtv5100: : don't do DMA on stack
Date: Fri,  7 Oct 2016 14:24:26 -0300
Message-Id: <a1a04725a0aeec355c133222da7ab5dac89f08a2.1475860773.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1475860773.git.mchehab@s-opensource.com>
References: <cover.1475860773.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1475860773.git.mchehab@s-opensource.com>
References: <cover.1475860773.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

The USB control messages require DMA to work. We cannot pass
a stack-allocated buffer, as it is not warranted that the
stack would be into a DMA enabled area.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/usb/dvb-usb/dtv5100.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/dvb-usb/dtv5100.c b/drivers/media/usb/dvb-usb/dtv5100.c
index 3d11df41cac0..c60fb54f445f 100644
--- a/drivers/media/usb/dvb-usb/dtv5100.c
+++ b/drivers/media/usb/dvb-usb/dtv5100.c
@@ -31,9 +31,14 @@ module_param_named(debug, dvb_usb_dtv5100_debug, int, 0644);
 MODULE_PARM_DESC(debug, "set debugging level" DVB_USB_DEBUG_STATUS);
 DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 
+struct dtv5100_state {
+	unsigned char data[80];
+};
+
 static int dtv5100_i2c_msg(struct dvb_usb_device *d, u8 addr,
 			   u8 *wbuf, u16 wlen, u8 *rbuf, u16 rlen)
 {
+	struct dtv5100_state *st = d->priv;
 	u8 request;
 	u8 type;
 	u16 value;
@@ -60,9 +65,10 @@ static int dtv5100_i2c_msg(struct dvb_usb_device *d, u8 addr,
 	}
 	index = (addr << 8) + wbuf[0];
 
+	memcpy(st->data, rbuf, rlen);
 	msleep(1); /* avoid I2C errors */
 	return usb_control_msg(d->udev, usb_rcvctrlpipe(d->udev, 0), request,
-			       type, value, index, rbuf, rlen,
+			       type, value, index, st->data, rlen,
 			       DTV5100_USB_TIMEOUT);
 }
 
@@ -176,7 +182,7 @@ static struct dvb_usb_device_properties dtv5100_properties = {
 	.caps = DVB_USB_IS_AN_I2C_ADAPTER,
 	.usb_ctrl = DEVICE_SPECIFIC,
 
-	.size_of_priv = 0,
+	.size_of_priv = sizeof(struct dtv5100_state),
 
 	.num_adapters = 1,
 	.adapter = {{
-- 
2.7.4


