Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:3005 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751856Ab3LMM1M (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Dec 2013 07:27:12 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 2/4] si470x: add check to test if this is really a si470x.
Date: Fri, 13 Dec 2013 13:26:47 +0100
Message-Id: <1386937609-11581-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1386937609-11581-1-git-send-email-hverkuil@xs4all.nl>
References: <1386937609-11581-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/radio/si470x/radio-si470x-usb.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/media/radio/si470x/radio-si470x-usb.c b/drivers/media/radio/si470x/radio-si470x-usb.c
index cd74025..07ef405 100644
--- a/drivers/media/radio/si470x/radio-si470x-usb.c
+++ b/drivers/media/radio/si470x/radio-si470x-usb.c
@@ -635,6 +635,30 @@ static int si470x_usb_driver_probe(struct usb_interface *intf,
 	}
 
 	radio->v4l2_dev.release = si470x_usb_release;
+
+	/*
+	 * The si470x SiLabs reference design uses the same USB IDs as
+	 * 'Thanko's Raremono' si4734 based receiver. So check here which we
+	 * have: attempt to read the device ID from the si470x: the lower 12
+	 * bits should be 0x0242 for the si470x.
+	 *
+	 * We use this check to determine which device we are dealing with.
+	 */
+	if (id->idVendor == 0x10c4 && id->idProduct == 0x818a) {
+		retval = usb_control_msg(radio->usbdev,
+				usb_rcvctrlpipe(radio->usbdev, 0),
+				HID_REQ_GET_REPORT,
+				USB_TYPE_CLASS | USB_RECIP_INTERFACE | USB_DIR_IN,
+				1, 2,
+				radio->usb_buf, 3, 500);
+		if (retval != 3 ||
+		    (get_unaligned_be16(&radio->usb_buf[1]) & 0xfff) != 0x0242) {
+			dev_info(&intf->dev, "this is not a si470x device.\n");
+			retval = -ENODEV;
+			goto err_urb;
+		}
+	}
+
 	retval = v4l2_device_register(&intf->dev, &radio->v4l2_dev);
 	if (retval < 0) {
 		dev_err(&intf->dev, "couldn't register v4l2_device\n");
-- 
1.8.4.3

