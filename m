Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:39786 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751736AbcJKKhu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Oct 2016 06:37:50 -0400
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
        Geunyoung Kim <nenggun.kim@samsung.com>,
        Inki Dae <inki.dae@samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Junghak Sung <jh1009.sung@samsung.com>,
        Wolfram Sang <wsa-dev@sang-engineering.com>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [PATCH v2 29/31] s2255drv: don't use stack for DMA
Date: Tue, 11 Oct 2016 07:09:44 -0300
Message-Id: <474df449f4368f552aaa52d7ef77d4500f681bb3.1476179975.git.mchehab@s-opensource.com>
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
 drivers/media/usb/s2255/s2255drv.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/s2255/s2255drv.c b/drivers/media/usb/s2255/s2255drv.c
index c3a0e87066eb..f7bb78c1873c 100644
--- a/drivers/media/usb/s2255/s2255drv.c
+++ b/drivers/media/usb/s2255/s2255drv.c
@@ -1901,19 +1901,30 @@ static long s2255_vendor_req(struct s2255_dev *dev, unsigned char Request,
 			     s32 TransferBufferLength, int bOut)
 {
 	int r;
+	unsigned char *buf;
+
+	buf = kmalloc(TransferBufferLength, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
 	if (!bOut) {
 		r = usb_control_msg(dev->udev, usb_rcvctrlpipe(dev->udev, 0),
 				    Request,
 				    USB_TYPE_VENDOR | USB_RECIP_DEVICE |
 				    USB_DIR_IN,
-				    Value, Index, TransferBuffer,
+				    Value, Index, buf,
 				    TransferBufferLength, HZ * 5);
+
+		if (r >= 0)
+			memcpy(TransferBuffer, buf, TransferBufferLength);
 	} else {
+		memcpy(buf, TransferBuffer, TransferBufferLength);
 		r = usb_control_msg(dev->udev, usb_sndctrlpipe(dev->udev, 0),
 				    Request, USB_TYPE_VENDOR | USB_RECIP_DEVICE,
-				    Value, Index, TransferBuffer,
+				    Value, Index, buf,
 				    TransferBufferLength, HZ * 5);
 	}
+	kfree(buf);
 	return r;
 }
 
-- 
2.7.4


