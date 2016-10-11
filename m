Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:39799 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752323AbcJKKh5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Oct 2016 06:37:57 -0400
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
        Hans Verkuil <hans.verkuil@cisco.com>,
        Wolfram Sang <wsa-dev@sang-engineering.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [PATCH v2 30/31] stk-webcam: don't use stack for DMA
Date: Tue, 11 Oct 2016 07:09:45 -0300
Message-Id: <851ca35bb29e470269b83845ed564204c7d15004.1476179975.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476179975.git.mchehab@s-opensource.com>
References: <cover.1476179975.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476179975.git.mchehab@s-opensource.com>
References: <cover.1476179975.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

The USB control messages require DMA to work. We cannot pass
a stack-allocated buffer, as it is not warranted that the
stack would be into a DMA enabled area.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/usb/stkwebcam/stk-webcam.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/media/usb/stkwebcam/stk-webcam.c b/drivers/media/usb/stkwebcam/stk-webcam.c
index db200c9d796d..22a9aae16291 100644
--- a/drivers/media/usb/stkwebcam/stk-webcam.c
+++ b/drivers/media/usb/stkwebcam/stk-webcam.c
@@ -147,20 +147,26 @@ int stk_camera_write_reg(struct stk_camera *dev, u16 index, u8 value)
 int stk_camera_read_reg(struct stk_camera *dev, u16 index, int *value)
 {
 	struct usb_device *udev = dev->udev;
+	unsigned char *buf;
 	int ret;
 
+	buf = kmalloc(sizeof(u8), GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
 	ret = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0),
 			0x00,
 			USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
 			0x00,
 			index,
-			(u8 *) value,
+			buf,
 			sizeof(u8),
 			500);
-	if (ret < 0)
-		return ret;
-	else
-		return 0;
+	if (ret >= 0)
+		memcpy(value, buf, sizeof(u8));
+
+	kfree(buf);
+	return ret;
 }
 
 static int stk_start_stream(struct stk_camera *dev)
-- 
2.7.4


