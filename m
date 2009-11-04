Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail01d.mail.t-online.hu ([84.2.42.6]:58455 "EHLO
	mail01d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758230AbZKDVfe (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Nov 2009 16:35:34 -0500
Message-ID: <4AF1F3A3.6000107@freemail.hu>
Date: Wed, 04 Nov 2009 22:35:31 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>,
	V4L Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] gspca pac7302/pac7311: handle return value of usb_control_msg()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Márton Németh <nm127@freemail.hu>

The function usb_control_msg() can return error any time so at least
warn the user if an error happens. No message is printed in case of
normal operation.

Signed-off-by: Márton Németh <nm127@freemail.hu>
---
diff -r e628f4381170 linux/drivers/media/video/gspca/pac7302.c
--- a/linux/drivers/media/video/gspca/pac7302.c	Mon Nov 02 14:00:48 2009 +0100
+++ b/linux/drivers/media/video/gspca/pac7302.c	Wed Nov 04 23:30:53 2009 +0100
@@ -335,27 +335,40 @@
 		  __u8 index,
 		  const char *buffer, int len)
 {
+	int ret;
+
 	memcpy(gspca_dev->usb_buf, buffer, len);
-	usb_control_msg(gspca_dev->dev,
+	ret = usb_control_msg(gspca_dev->dev,
 			usb_sndctrlpipe(gspca_dev->dev, 0),
 			1,		/* request */
 			USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
 			0,		/* value */
 			index, gspca_dev->usb_buf, len,
 			500);
+	if (ret < 0)
+		PDEBUG(D_ERR, "reg_w_buf(): "
+		"Failed to write registers to index 0x%x, error %i",
+		index, ret);
 }

 #if 0 /* not used */
 static __u8 reg_r(struct gspca_dev *gspca_dev,
 			     __u8 index)
 {
-	usb_control_msg(gspca_dev->dev,
+	int ret;
+
+	ret = usb_control_msg(gspca_dev->dev,
 			usb_rcvctrlpipe(gspca_dev->dev, 0),
 			0,			/* request */
 			USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
 			0,			/* value */
 			index, gspca_dev->usb_buf, 1,
 			500);
+	if (ret < 0)
+		PDEBUG(D_ERR, "reg_r(): "
+		"Failed to read register from index 0x%x, error %i",
+		index, ret);
+
 	return gspca_dev->usb_buf[0];
 }
 #endif
@@ -364,13 +377,19 @@
 		  __u8 index,
 		  __u8 value)
 {
+	int ret;
+
 	gspca_dev->usb_buf[0] = value;
-	usb_control_msg(gspca_dev->dev,
+	ret = usb_control_msg(gspca_dev->dev,
 			usb_sndctrlpipe(gspca_dev->dev, 0),
 			0,			/* request */
 			USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
 			0, index, gspca_dev->usb_buf, 1,
 			500);
+	if (ret < 0)
+		PDEBUG(D_ERR, "reg_w(): "
+		"Failed to write register to index 0x%x, value 0x%x, error %i",
+		index, value, ret);
 }

 static void reg_w_seq(struct gspca_dev *gspca_dev,
@@ -387,17 +406,23 @@
 			const __u8 *page, int len)
 {
 	int index;
+	int ret;

 	for (index = 0; index < len; index++) {
 		if (page[index] == SKIP)		/* skip this index */
 			continue;
 		gspca_dev->usb_buf[0] = page[index];
-		usb_control_msg(gspca_dev->dev,
+		ret = usb_control_msg(gspca_dev->dev,
 				usb_sndctrlpipe(gspca_dev->dev, 0),
 				0,			/* request */
 			USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
 				0, index, gspca_dev->usb_buf, 1,
 				500);
+		if (ret < 0)
+			PDEBUG(D_ERR, "reg_w_page(): "
+			"Failed to write register to index 0x%x, "
+			"value 0x%x, error %i",
+			index, page[index], ret);
 	}
 }

diff -r e628f4381170 linux/drivers/media/video/gspca/pac7311.c
--- a/linux/drivers/media/video/gspca/pac7311.c	Mon Nov 02 14:00:48 2009 +0100
+++ b/linux/drivers/media/video/gspca/pac7311.c	Wed Nov 04 23:30:53 2009 +0100
@@ -263,27 +263,40 @@
 		  __u8 index,
 		  const char *buffer, int len)
 {
+	int ret;
+
 	memcpy(gspca_dev->usb_buf, buffer, len);
-	usb_control_msg(gspca_dev->dev,
+	ret = usb_control_msg(gspca_dev->dev,
 			usb_sndctrlpipe(gspca_dev->dev, 0),
 			1,		/* request */
 			USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
 			0,		/* value */
 			index, gspca_dev->usb_buf, len,
 			500);
+	if (ret < 0)
+		PDEBUG(D_ERR, "reg_w_buf(): "
+		"Failed to write registers to index 0x%x, error %i",
+		index, ret);
 }

 #if 0 /* not used */
 static __u8 reg_r(struct gspca_dev *gspca_dev,
 			     __u8 index)
 {
-	usb_control_msg(gspca_dev->dev,
+	int ret;
+
+	ret = usb_control_msg(gspca_dev->dev,
 			usb_rcvctrlpipe(gspca_dev->dev, 0),
 			0,			/* request */
 			USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
 			0,			/* value */
 			index, gspca_dev->usb_buf, 1,
 			500);
+	if (ret < 0)
+		PDEBUG(D_ERR, "reg_r(): "
+		"Failed to read register from index 0x%x, error %i",
+		index, ret);
+
 	return gspca_dev->usb_buf[0];
 }
 #endif
@@ -292,13 +305,19 @@
 		  __u8 index,
 		  __u8 value)
 {
+	int ret;
+
 	gspca_dev->usb_buf[0] = value;
-	usb_control_msg(gspca_dev->dev,
+	ret = usb_control_msg(gspca_dev->dev,
 			usb_sndctrlpipe(gspca_dev->dev, 0),
 			0,			/* request */
 			USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
 			0, index, gspca_dev->usb_buf, 1,
 			500);
+	if (ret < 0)
+		PDEBUG(D_ERR, "reg_w(): "
+		"Failed to write register to index 0x%x, value 0x%x, error %i",
+		index, value, ret);
 }

 static void reg_w_seq(struct gspca_dev *gspca_dev,
@@ -315,17 +334,23 @@
 			const __u8 *page, int len)
 {
 	int index;
+	int ret;

 	for (index = 0; index < len; index++) {
 		if (page[index] == SKIP)		/* skip this index */
 			continue;
 		gspca_dev->usb_buf[0] = page[index];
-		usb_control_msg(gspca_dev->dev,
+		ret = usb_control_msg(gspca_dev->dev,
 				usb_sndctrlpipe(gspca_dev->dev, 0),
 				0,			/* request */
 			USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
 				0, index, gspca_dev->usb_buf, 1,
 				500);
+		if (ret < 0)
+			PDEBUG(D_ERR, "reg_w_page(): "
+			"Failed to write register to index 0x%x, "
+			"value 0x%x, error %i",
+			index, page[index], ret);
 	}
 }

