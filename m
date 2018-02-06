Return-path: <linux-media-owner@vger.kernel.org>
Received: from butterbrot.org ([176.9.106.16]:59785 "EHLO butterbrot.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754047AbeBFVB4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 6 Feb 2018 16:01:56 -0500
From: Florian Echtler <floe@butterbrot.org>
To: hverkuil@xs4all.nl, linux-media@vger.kernel.org
Cc: linux-input@vger.kernel.org, modin@yuri.at,
        Florian Echtler <floe@butterbrot.org>
Subject: [PATCH 3/5] add panel register access functions
Date: Tue,  6 Feb 2018 22:01:43 +0100
Message-Id: <1517950905-5015-4-git-send-email-floe@butterbrot.org>
In-Reply-To: <1517950905-5015-1-git-send-email-floe@butterbrot.org>
References: <1517950905-5015-1-git-send-email-floe@butterbrot.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

These functions provide write access to the internal LCD panel registers
which also control the sensor. They can be used to disable the
preprocessor, set the illumination brightness, and adjust gain/contrast
(which are stored together in one register internally called "vsvideo").

Signed-off-by: Florian Echtler <floe@butterbrot.org>
---
 drivers/input/touchscreen/sur40.c | 71 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 71 insertions(+)

diff --git a/drivers/input/touchscreen/sur40.c b/drivers/input/touchscreen/sur40.c
index 3af63415..7f6461d 100644
--- a/drivers/input/touchscreen/sur40.c
+++ b/drivers/input/touchscreen/sur40.c
@@ -240,6 +240,81 @@ static int sur40_command(struct sur40_state *dev,
 			       0x00, index, buffer, size, 1000);
 }
 
+/* poke a byte in the panel register space */
+static int sur40_poke(struct sur40_state *dev, u8 offset, u8 value)
+{
+	int result;
+	u8 index = 0x96; // 0xae for permanent write
+
+	result = usb_control_msg(dev->usbdev, usb_sndctrlpipe(dev->usbdev, 0),
+		SUR40_POKE, USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_OUT,
+		0x32, index, NULL, 0, 1000);
+	if (result < 0)
+		goto error;
+	msleep(5);
+
+	result = usb_control_msg(dev->usbdev, usb_sndctrlpipe(dev->usbdev, 0),
+		SUR40_POKE, USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_OUT,
+		0x72, offset, NULL, 0, 1000);
+	if (result < 0)
+		goto error;
+	msleep(5);
+
+	result = usb_control_msg(dev->usbdev, usb_sndctrlpipe(dev->usbdev, 0),
+		SUR40_POKE, USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_OUT,
+		0xb2, value, NULL, 0, 1000);
+	if (result < 0)
+		goto error;
+	msleep(5);
+
+error:
+	return result;
+}
+
+static int sur40_set_preprocessor(struct sur40_state *dev, u8 value)
+{
+	u8 setting_07[2] = { 0x01, 0x00 };
+	u8 setting_17[2] = { 0x85, 0x80 };
+	int result;
+
+	if (value > 1)
+		return -ERANGE;
+
+	result = usb_control_msg(dev->usbdev, usb_sndctrlpipe(dev->usbdev, 0),
+		SUR40_POKE, USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_OUT,
+		0x07, setting_07[value], NULL, 0, 1000);
+	if (result < 0)
+		goto error;
+	msleep(5);
+
+	result = usb_control_msg(dev->usbdev, usb_sndctrlpipe(dev->usbdev, 0),
+		SUR40_POKE, USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_OUT,
+		0x17, setting_17[value], NULL, 0, 1000);
+	if (result < 0)
+		goto error;
+	msleep(5);
+
+error:
+	return result;
+}
+
+static void sur40_set_vsvideo(struct sur40_state *handle, u8 value)
+{
+	int i;
+
+	for (i = 0; i < 4; i++)
+		sur40_poke(handle, 0x1c+i, value);
+	handle->vsvideo = value;
+}
+
+static void sur40_set_irlevel(struct sur40_state *handle, u8 value)
+{
+	int i;
+
+	for (i = 0; i < 8; i++)
+		sur40_poke(handle, 0x08+(2*i), value);
+}
+
 /* Initialization routine, called from sur40_open */
 static int sur40_init(struct sur40_state *dev)
 {
-- 
2.7.4
