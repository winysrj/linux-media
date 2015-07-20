Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:46823 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755565AbbGTNBE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jul 2015 09:01:04 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 10/12] usbvision: fix DMA from stack warnings.
Date: Mon, 20 Jul 2015 14:59:36 +0200
Message-Id: <1437397178-5013-11-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1437397178-5013-1-git-send-email-hverkuil@xs4all.nl>
References: <1437397178-5013-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

In various places the stack was used to provide buffers for USB data, but
this should be allocated memory.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/usbvision/usbvision-core.c | 18 ++++++++++--------
 drivers/media/usb/usbvision/usbvision-i2c.c  |  2 +-
 2 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/media/usb/usbvision/usbvision-core.c b/drivers/media/usb/usbvision/usbvision-core.c
index ec50984..9f4e630 100644
--- a/drivers/media/usb/usbvision/usbvision-core.c
+++ b/drivers/media/usb/usbvision/usbvision-core.c
@@ -1367,7 +1367,7 @@ static void usbvision_isoc_irq(struct urb *urb)
 int usbvision_read_reg(struct usb_usbvision *usbvision, unsigned char reg)
 {
 	int err_code = 0;
-	unsigned char buffer[1];
+	unsigned char *buffer = usbvision->ctrl_urb_buffer;
 
 	if (!USBVISION_IS_OPERATIONAL(usbvision))
 		return -1;
@@ -1401,10 +1401,12 @@ int usbvision_write_reg(struct usb_usbvision *usbvision, unsigned char reg,
 	if (!USBVISION_IS_OPERATIONAL(usbvision))
 		return 0;
 
+	usbvision->ctrl_urb_buffer[0] = value;
 	err_code = usb_control_msg(usbvision->dev, usb_sndctrlpipe(usbvision->dev, 1),
 				USBVISION_OP_CODE,
 				USB_DIR_OUT | USB_TYPE_VENDOR |
-				USB_RECIP_ENDPOINT, 0, (__u16) reg, &value, 1, HZ);
+				USB_RECIP_ENDPOINT, 0, (__u16) reg,
+				usbvision->ctrl_urb_buffer, 1, HZ);
 
 	if (err_code < 0) {
 		dev_err(&usbvision->dev->dev,
@@ -1596,7 +1598,7 @@ static int usbvision_init_webcam(struct usb_usbvision *usbvision)
 		{ 0x27, 0x00, 0x00 }, { 0x28, 0x00, 0x00 }, { 0x29, 0x00, 0x00 }, { 0x08, 0x80, 0x60 },
 		{ 0x0f, 0x2d, 0x24 }, { 0x0c, 0x80, 0x80 }
 	};
-	char value[3];
+	unsigned char *value = usbvision->ctrl_urb_buffer;
 
 	/* the only difference between PAL and NTSC init_values */
 	if (usbvision_device_data[usbvision->dev_model].video_norm == V4L2_STD_NTSC)
@@ -1635,8 +1637,8 @@ static int usbvision_init_webcam(struct usb_usbvision *usbvision)
 static int usbvision_set_video_format(struct usb_usbvision *usbvision, int format)
 {
 	static const char proc[] = "usbvision_set_video_format";
+	unsigned char *value = usbvision->ctrl_urb_buffer;
 	int rc;
-	unsigned char value[2];
 
 	if (!USBVISION_IS_OPERATIONAL(usbvision))
 		return 0;
@@ -1677,7 +1679,7 @@ int usbvision_set_output(struct usb_usbvision *usbvision, int width,
 	int err_code = 0;
 	int usb_width, usb_height;
 	unsigned int frame_rate = 0, frame_drop = 0;
-	unsigned char value[4];
+	unsigned char *value = usbvision->ctrl_urb_buffer;
 
 	if (!USBVISION_IS_OPERATIONAL(usbvision))
 		return 0;
@@ -1872,7 +1874,7 @@ static int usbvision_set_compress_params(struct usb_usbvision *usbvision)
 {
 	static const char proc[] = "usbvision_set_compresion_params: ";
 	int rc;
-	unsigned char value[6];
+	unsigned char *value = usbvision->ctrl_urb_buffer;
 
 	value[0] = 0x0F;    /* Intra-Compression cycle */
 	value[1] = 0x01;    /* Reg.45 one line per strip */
@@ -1946,7 +1948,7 @@ int usbvision_set_input(struct usb_usbvision *usbvision)
 {
 	static const char proc[] = "usbvision_set_input: ";
 	int rc;
-	unsigned char value[8];
+	unsigned char *value = usbvision->ctrl_urb_buffer;
 	unsigned char dvi_yuv_value;
 
 	if (!USBVISION_IS_OPERATIONAL(usbvision))
@@ -2062,8 +2064,8 @@ int usbvision_set_input(struct usb_usbvision *usbvision)
 
 static int usbvision_set_dram_settings(struct usb_usbvision *usbvision)
 {
+	unsigned char *value = usbvision->ctrl_urb_buffer;
 	int rc;
-	unsigned char value[8];
 
 	if (usbvision->isoc_mode == ISOC_MODE_COMPRESS) {
 		value[0] = 0x42;
diff --git a/drivers/media/usb/usbvision/usbvision-i2c.c b/drivers/media/usb/usbvision/usbvision-i2c.c
index 26dbcb1..120de2e 100644
--- a/drivers/media/usb/usbvision/usbvision-i2c.c
+++ b/drivers/media/usb/usbvision/usbvision-i2c.c
@@ -343,7 +343,7 @@ static int usbvision_i2c_write_max4(struct usb_usbvision *usbvision,
 {
 	int rc, retries;
 	int i;
-	unsigned char value[6];
+	unsigned char *value = usbvision->ctrl_urb_buffer;
 	unsigned char ser_cont;
 
 	ser_cont = (len & 0x07) | 0x10;
-- 
2.1.4

