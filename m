Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:39783 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751710AbcJKKht (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Oct 2016 06:37:49 -0400
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
        Kosuke Tatsukawa <tatsu@ab.jp.nec.com>,
        Wolfram Sang <wsa-dev@sang-engineering.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [PATCH v2 28/31] cpia2_usb: don't use stack for DMA
Date: Tue, 11 Oct 2016 07:09:43 -0300
Message-Id: <c2dd60621e2e63076d4c7e250eed9cacb7d5bad3.1476179975.git.mchehab@s-opensource.com>
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
 drivers/media/usb/cpia2/cpia2_usb.c | 32 +++++++++++++++++++++++++++++---
 1 file changed, 29 insertions(+), 3 deletions(-)

diff --git a/drivers/media/usb/cpia2/cpia2_usb.c b/drivers/media/usb/cpia2/cpia2_usb.c
index 13620cdf0599..417d683b237d 100644
--- a/drivers/media/usb/cpia2/cpia2_usb.c
+++ b/drivers/media/usb/cpia2/cpia2_usb.c
@@ -545,10 +545,19 @@ static void free_sbufs(struct camera_data *cam)
 static int write_packet(struct usb_device *udev,
 			u8 request, u8 * registers, u16 start, size_t size)
 {
+	unsigned char *buf;
+	int ret;
+
 	if (!registers || size <= 0)
 		return -EINVAL;
 
-	return usb_control_msg(udev,
+	buf = kmalloc(size, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	memcpy(buf, registers, size);
+
+	ret = usb_control_msg(udev,
 			       usb_sndctrlpipe(udev, 0),
 			       request,
 			       USB_TYPE_VENDOR | USB_RECIP_DEVICE,
@@ -557,6 +566,9 @@ static int write_packet(struct usb_device *udev,
 			       registers,	/* buffer */
 			       size,
 			       HZ);
+
+	kfree(buf);
+	return ret;
 }
 
 /****************************************************************************
@@ -567,18 +579,32 @@ static int write_packet(struct usb_device *udev,
 static int read_packet(struct usb_device *udev,
 		       u8 request, u8 * registers, u16 start, size_t size)
 {
+	unsigned char *buf;
+	int ret;
+
 	if (!registers || size <= 0)
 		return -EINVAL;
 
-	return usb_control_msg(udev,
+	buf = kmalloc(size, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	ret = usb_control_msg(udev,
 			       usb_rcvctrlpipe(udev, 0),
 			       request,
 			       USB_DIR_IN|USB_TYPE_VENDOR|USB_RECIP_DEVICE,
 			       start,	/* value */
 			       0,	/* index */
-			       registers,	/* buffer */
+			       buf,	/* buffer */
 			       size,
 			       HZ);
+
+	if (ret >= 0)
+		memcpy (registers, buf, size);
+
+	kfree(buf);
+
+	return ret;
 }
 
 /******************************************************************************
-- 
2.7.4


