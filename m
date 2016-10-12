Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:46229
        "EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750764AbcJLCS0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Oct 2016 22:18:26 -0400
Date: Tue, 11 Oct 2016 23:18:17 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Kosuke Tatsukawa <tatsu@ab.jp.nec.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        "Mauro Carvalho Chehab" <mchehab@osg.samsung.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Andy Lutomirski <luto@amacapital.net>,
        "Johannes Stezenbach" <js@linuxtv.org>,
        Jiri Kosina <jikos@kernel.org>,
        "Patrick Boettcher" <patrick.boettcher@posteo.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        "Michael Krufky" <mkrufky@linuxtv.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "jrg.otte@gmail.com" <jrg.otte@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Wolfram Sang <wsa-dev@sang-engineering.com>,
        Kosuke Tatsukawa <tatsu@ab.jp.nec.com>
Subject: [PATCH v2 .1 28/31] cpia2_usb: don't use stack for DMA
Message-ID: <20161011231817.331f1244@vento.lan>
In-Reply-To: <17EC94B0A072C34B8DCF0D30AD16044A028EFC0B@BPXM09GP.gisp.nec.co.jp>
References: <c2dd60621e2e63076d4c7e250eed9cacb7d5bad3.1476179975.git.mchehab@s-opensource.com>
        <17EC94B0A072C34B8DCF0D30AD16044A028EFC0B@BPXM09GP.gisp.nec.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The USB control messages require DMA to work. We cannot pass
a stack-allocated buffer, as it is not warranted that the
stack would be into a DMA enabled area.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

-- 

v2.1: As pointed by Kosuke Tatsukawa, I forgot to replace "registers" var
to "buf" at one of the usb_control_msg() calls.

diff --git a/drivers/media/usb/cpia2/cpia2_usb.c b/drivers/media/usb/cpia2/cpia2_usb.c
index 13620cdf0599..e9100a235831 100644
--- a/drivers/media/usb/cpia2/cpia2_usb.c
+++ b/drivers/media/usb/cpia2/cpia2_usb.c
@@ -545,18 +545,30 @@ static void free_sbufs(struct camera_data *cam)
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
 			       start,	/* value */
 			       0,	/* index */
-			       registers,	/* buffer */
+			       buf,	/* buffer */
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
+		memcpy(registers, buf, size);
+
+	kfree(buf);
+
+	return ret;
 }
 
 /******************************************************************************
