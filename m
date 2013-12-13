Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:3024 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751849Ab3LMM1L (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Dec 2013 07:27:11 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 1/4] si470x: don't use buffer on the stack for USB transfers.
Date: Fri, 13 Dec 2013 13:26:46 +0100
Message-Id: <1386937609-11581-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1386937609-11581-1-git-send-email-hverkuil@xs4all.nl>
References: <1386937609-11581-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

You shouldn't use buffers allocated on the stack for USB transfers,
always kmalloc them.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/radio/si470x/radio-si470x-usb.c | 57 +++++++++++++++------------
 drivers/media/radio/si470x/radio-si470x.h     |  1 +
 2 files changed, 32 insertions(+), 26 deletions(-)

diff --git a/drivers/media/radio/si470x/radio-si470x-usb.c b/drivers/media/radio/si470x/radio-si470x-usb.c
index d6d4d60..cd74025 100644
--- a/drivers/media/radio/si470x/radio-si470x-usb.c
+++ b/drivers/media/radio/si470x/radio-si470x-usb.c
@@ -137,6 +137,8 @@ MODULE_PARM_DESC(max_rds_errors, "RDS maximum block errors: *1*");
 /* interrupt out endpoint 2 every 1 millisecond */
 #define UNUSED_REPORT		23
 
+#define MAX_REPORT_SIZE		64
+
 
 
 /**************************************************************************
@@ -208,7 +210,7 @@ MODULE_PARM_DESC(max_rds_errors, "RDS maximum block errors: *1*");
  */
 static int si470x_get_report(struct si470x_device *radio, void *buf, int size)
 {
-	unsigned char *report = (unsigned char *) buf;
+	unsigned char *report = buf;
 	int retval;
 
 	retval = usb_control_msg(radio->usbdev,
@@ -231,7 +233,7 @@ static int si470x_get_report(struct si470x_device *radio, void *buf, int size)
  */
 static int si470x_set_report(struct si470x_device *radio, void *buf, int size)
 {
-	unsigned char *report = (unsigned char *) buf;
+	unsigned char *report = buf;
 	int retval;
 
 	retval = usb_control_msg(radio->usbdev,
@@ -254,15 +256,14 @@ static int si470x_set_report(struct si470x_device *radio, void *buf, int size)
  */
 int si470x_get_register(struct si470x_device *radio, int regnr)
 {
-	unsigned char buf[REGISTER_REPORT_SIZE];
 	int retval;
 
-	buf[0] = REGISTER_REPORT(regnr);
+	radio->usb_buf[0] = REGISTER_REPORT(regnr);
 
-	retval = si470x_get_report(radio, (void *) &buf, sizeof(buf));
+	retval = si470x_get_report(radio, radio->usb_buf, REGISTER_REPORT_SIZE);
 
 	if (retval >= 0)
-		radio->registers[regnr] = get_unaligned_be16(&buf[1]);
+		radio->registers[regnr] = get_unaligned_be16(&radio->usb_buf[1]);
 
 	return (retval < 0) ? -EINVAL : 0;
 }
@@ -273,13 +274,12 @@ int si470x_get_register(struct si470x_device *radio, int regnr)
  */
 int si470x_set_register(struct si470x_device *radio, int regnr)
 {
-	unsigned char buf[REGISTER_REPORT_SIZE];
 	int retval;
 
-	buf[0] = REGISTER_REPORT(regnr);
-	put_unaligned_be16(radio->registers[regnr], &buf[1]);
+	radio->usb_buf[0] = REGISTER_REPORT(regnr);
+	put_unaligned_be16(radio->registers[regnr], &radio->usb_buf[1]);
 
-	retval = si470x_set_report(radio, (void *) &buf, sizeof(buf));
+	retval = si470x_set_report(radio, radio->usb_buf, REGISTER_REPORT_SIZE);
 
 	return (retval < 0) ? -EINVAL : 0;
 }
@@ -295,18 +295,17 @@ int si470x_set_register(struct si470x_device *radio, int regnr)
  */
 static int si470x_get_all_registers(struct si470x_device *radio)
 {
-	unsigned char buf[ENTIRE_REPORT_SIZE];
 	int retval;
 	unsigned char regnr;
 
-	buf[0] = ENTIRE_REPORT;
+	radio->usb_buf[0] = ENTIRE_REPORT;
 
-	retval = si470x_get_report(radio, (void *) &buf, sizeof(buf));
+	retval = si470x_get_report(radio, radio->usb_buf, ENTIRE_REPORT_SIZE);
 
 	if (retval >= 0)
 		for (regnr = 0; regnr < RADIO_REGISTER_NUM; regnr++)
 			radio->registers[regnr] = get_unaligned_be16(
-				&buf[regnr * RADIO_REGISTER_SIZE + 1]);
+				&radio->usb_buf[regnr * RADIO_REGISTER_SIZE + 1]);
 
 	return (retval < 0) ? -EINVAL : 0;
 }
@@ -323,14 +322,13 @@ static int si470x_get_all_registers(struct si470x_device *radio)
 static int si470x_set_led_state(struct si470x_device *radio,
 		unsigned char led_state)
 {
-	unsigned char buf[LED_REPORT_SIZE];
 	int retval;
 
-	buf[0] = LED_REPORT;
-	buf[1] = LED_COMMAND;
-	buf[2] = led_state;
+	radio->usb_buf[0] = LED_REPORT;
+	radio->usb_buf[1] = LED_COMMAND;
+	radio->usb_buf[2] = led_state;
 
-	retval = si470x_set_report(radio, (void *) &buf, sizeof(buf));
+	retval = si470x_set_report(radio, radio->usb_buf, LED_REPORT_SIZE);
 
 	return (retval < 0) ? -EINVAL : 0;
 }
@@ -346,19 +344,18 @@ static int si470x_set_led_state(struct si470x_device *radio,
  */
 static int si470x_get_scratch_page_versions(struct si470x_device *radio)
 {
-	unsigned char buf[SCRATCH_REPORT_SIZE];
 	int retval;
 
-	buf[0] = SCRATCH_REPORT;
+	radio->usb_buf[0] = SCRATCH_REPORT;
 
-	retval = si470x_get_report(radio, (void *) &buf, sizeof(buf));
+	retval = si470x_get_report(radio, radio->usb_buf, SCRATCH_REPORT_SIZE);
 
 	if (retval < 0)
 		dev_warn(&radio->intf->dev, "si470x_get_scratch: "
 			"si470x_get_report returned %d\n", retval);
 	else {
-		radio->software_version = buf[1];
-		radio->hardware_version = buf[2];
+		radio->software_version = radio->usb_buf[1];
+		radio->hardware_version = radio->usb_buf[2];
 	}
 
 	return (retval < 0) ? -EINVAL : 0;
@@ -509,6 +506,7 @@ static void si470x_usb_release(struct v4l2_device *v4l2_dev)
 	v4l2_device_unregister(&radio->v4l2_dev);
 	kfree(radio->int_in_buffer);
 	kfree(radio->buffer);
+	kfree(radio->usb_buf);
 	kfree(radio);
 }
 
@@ -593,6 +591,11 @@ static int si470x_usb_driver_probe(struct usb_interface *intf,
 		retval = -ENOMEM;
 		goto err_initial;
 	}
+	radio->usb_buf = kmalloc(MAX_REPORT_SIZE, GFP_KERNEL);
+	if (radio->usb_buf == NULL) {
+		retval = -ENOMEM;
+		goto err_radio;
+	}
 	radio->usbdev = interface_to_usbdev(intf);
 	radio->intf = intf;
 	radio->band = 1; /* Default to 76 - 108 MHz */
@@ -612,7 +615,7 @@ static int si470x_usb_driver_probe(struct usb_interface *intf,
 	if (!radio->int_in_endpoint) {
 		dev_info(&intf->dev, "could not find interrupt in endpoint\n");
 		retval = -EIO;
-		goto err_radio;
+		goto err_usbbuf;
 	}
 
 	int_end_size = le16_to_cpu(radio->int_in_endpoint->wMaxPacketSize);
@@ -621,7 +624,7 @@ static int si470x_usb_driver_probe(struct usb_interface *intf,
 	if (!radio->int_in_buffer) {
 		dev_info(&intf->dev, "could not allocate int_in_buffer");
 		retval = -ENOMEM;
-		goto err_radio;
+		goto err_usbbuf;
 	}
 
 	radio->int_in_urb = usb_alloc_urb(0, GFP_KERNEL);
@@ -743,6 +746,8 @@ err_urb:
 	usb_free_urb(radio->int_in_urb);
 err_intbuffer:
 	kfree(radio->int_in_buffer);
+err_usbbuf:
+	kfree(radio->usb_buf);
 err_radio:
 	kfree(radio);
 err_initial:
diff --git a/drivers/media/radio/si470x/radio-si470x.h b/drivers/media/radio/si470x/radio-si470x.h
index 467e955..4b76604 100644
--- a/drivers/media/radio/si470x/radio-si470x.h
+++ b/drivers/media/radio/si470x/radio-si470x.h
@@ -167,6 +167,7 @@ struct si470x_device {
 	/* reference to USB and video device */
 	struct usb_device *usbdev;
 	struct usb_interface *intf;
+	char *usb_buf;
 
 	/* Interrupt endpoint handling */
 	char *int_in_buffer;
-- 
1.8.4.3

