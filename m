Return-path: <linux-media-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:36024 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754835AbZDVVDX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Apr 2009 17:03:23 -0400
Subject: patch usb-pwc-do-not-pass-stack-allocated-buffers-to-usb-core.patch added to gregkh-2.6 tree
To: mfuzzey@gmail.com, gregkh@suse.de, greg@kroah.com,
	linux-media@vger.kernel.org
From: <gregkh@suse.de>
Date: Wed, 22 Apr 2009 14:00:24 -0700
In-Reply-To: <20090421194808.8272.8437.stgit@mfuzzey-laptop>
Message-ID: <12404340242540@kroah.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


This is a note to let you know that I've just added the patch titled

    Subject: USB: pwc : do not pass stack allocated buffers to USB core.

to my gregkh-2.6 tree.  Its filename is

    usb-pwc-do-not-pass-stack-allocated-buffers-to-usb-core.patch

This tree can be found at 
    http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/


>From mfuzzey@gmail.com  Wed Apr 22 13:31:46 2009
From: Martin Fuzzey <mfuzzey@gmail.com>
Date: Tue, 21 Apr 2009 21:48:09 +0200
Subject: USB: pwc : do not pass stack allocated buffers to USB core.
To: Greg KH <greg@kroah.com>, <linux-media@vger.kernel.org>
Message-ID: <20090421194808.8272.8437.stgit@mfuzzey-laptop>


This is causes problems on platforms that have alignment requirements
for DMA transfers.

Signed-off-by: Martin Fuzzey <mfuzzey@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 drivers/media/video/pwc/pwc-ctrl.c |  240 +++++++++++++++++++++++++------------
 1 file changed, 165 insertions(+), 75 deletions(-)

--- a/drivers/media/video/pwc/pwc-ctrl.c
+++ b/drivers/media/video/pwc/pwc-ctrl.c
@@ -159,35 +159,67 @@ static void pwc_set_image_buffer_size(st
 
 /****************************************************************************/
 
+static int _send_control_msg(struct pwc_device *pdev,
+	u8 request, u16 value, int index, void *buf, int buflen, int timeout)
+{
+	int rc;
+	void *kbuf = NULL;
+
+	if (buflen) {
+		kbuf = kmalloc(buflen, GFP_KERNEL); /* not allowed on stack */
+		if (kbuf == NULL)
+			return -ENOMEM;
+		memcpy(kbuf, buf, buflen);
+	}
 
-#define SendControlMsg(request, value, buflen) \
-	usb_control_msg(pdev->udev, usb_sndctrlpipe(pdev->udev, 0), \
-		request, \
-		USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE, \
-		value, \
-		pdev->vcinterface, \
-		&buf, buflen, 500)
-
-#define RecvControlMsg(request, value, buflen) \
-	usb_control_msg(pdev->udev, usb_rcvctrlpipe(pdev->udev, 0), \
-		request, \
-		USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE, \
-		value, \
-		pdev->vcinterface, \
-		&buf, buflen, 500)
+	rc = usb_control_msg(pdev->udev, usb_sndctrlpipe(pdev->udev, 0),
+		request,
+		USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
+		value,
+		index,
+		kbuf, buflen, timeout);
 
+	kfree(kbuf);
+	return rc;
+}
 
-static int send_video_command(struct usb_device *udev, int index, void *buf, int buflen)
+static int recv_control_msg(struct pwc_device *pdev,
+	u8 request, u16 value, void *buf, int buflen)
 {
-	return usb_control_msg(udev,
-		usb_sndctrlpipe(udev, 0),
+	int rc;
+	void *kbuf = kmalloc(buflen, GFP_KERNEL); /* not allowed on stack */
+
+	if (kbuf == NULL)
+		return -ENOMEM;
+
+	rc = usb_control_msg(pdev->udev, usb_rcvctrlpipe(pdev->udev, 0),
+		request,
+		USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
+		value,
+		pdev->vcinterface,
+		kbuf, buflen, 500);
+	memcpy(buf, kbuf, buflen);
+	kfree(kbuf);
+	return rc;
+}
+
+static inline int send_video_command(struct pwc_device *pdev,
+	int index, void *buf, int buflen)
+{
+	return _send_control_msg(pdev,
 		SET_EP_STREAM_CTL,
-		USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
 		VIDEO_OUTPUT_CONTROL_FORMATTER,
 		index,
 		buf, buflen, 1000);
 }
 
+static inline int send_control_msg(struct pwc_device *pdev,
+	u8 request, u16 value, void *buf, int buflen)
+{
+	return _send_control_msg(pdev,
+		request, value, pdev->vcinterface, buf, buflen, 500);
+}
+
 
 
 static int set_video_mode_Nala(struct pwc_device *pdev, int size, int frames)
@@ -224,7 +256,7 @@ static int set_video_mode_Nala(struct pw
 		return -EINVAL;
 
 	memcpy(buf, pEntry->mode, 3);
-	ret = send_video_command(pdev->udev, pdev->vendpoint, buf, 3);
+	ret = send_video_command(pdev, pdev->vendpoint, buf, 3);
 	if (ret < 0) {
 		PWC_DEBUG_MODULE("Failed to send video command... %d\n", ret);
 		return ret;
@@ -285,7 +317,7 @@ static int set_video_mode_Timon(struct p
 	memcpy(buf, pChoose->mode, 13);
 	if (snapshot)
 		buf[0] |= 0x80;
-	ret = send_video_command(pdev->udev, pdev->vendpoint, buf, 13);
+	ret = send_video_command(pdev, pdev->vendpoint, buf, 13);
 	if (ret < 0)
 		return ret;
 
@@ -358,7 +390,7 @@ static int set_video_mode_Kiara(struct p
 		buf[0] |= 0x80;
 
 	/* Firmware bug: video endpoint is 5, but commands are sent to endpoint 4 */
-	ret = send_video_command(pdev->udev, 4 /* pdev->vendpoint */, buf, 12);
+	ret = send_video_command(pdev, 4 /* pdev->vendpoint */, buf, 12);
 	if (ret < 0)
 		return ret;
 
@@ -530,7 +562,8 @@ int pwc_get_brightness(struct pwc_device
 	char buf;
 	int ret;
 
-	ret = RecvControlMsg(GET_LUM_CTL, BRIGHTNESS_FORMATTER, 1);
+	ret = recv_control_msg(pdev,
+		GET_LUM_CTL, BRIGHTNESS_FORMATTER, &buf, sizeof(buf));
 	if (ret < 0)
 		return ret;
 	return buf;
@@ -545,7 +578,8 @@ int pwc_set_brightness(struct pwc_device
 	if (value > 0xffff)
 		value = 0xffff;
 	buf = (value >> 9) & 0x7f;
-	return SendControlMsg(SET_LUM_CTL, BRIGHTNESS_FORMATTER, 1);
+	return send_control_msg(pdev,
+		SET_LUM_CTL, BRIGHTNESS_FORMATTER, &buf, sizeof(buf));
 }
 
 /* CONTRAST */
@@ -555,7 +589,8 @@ int pwc_get_contrast(struct pwc_device *
 	char buf;
 	int ret;
 
-	ret = RecvControlMsg(GET_LUM_CTL, CONTRAST_FORMATTER, 1);
+	ret = recv_control_msg(pdev,
+		GET_LUM_CTL, CONTRAST_FORMATTER, &buf, sizeof(buf));
 	if (ret < 0)
 		return ret;
 	return buf;
@@ -570,7 +605,8 @@ int pwc_set_contrast(struct pwc_device *
 	if (value > 0xffff)
 		value = 0xffff;
 	buf = (value >> 10) & 0x3f;
-	return SendControlMsg(SET_LUM_CTL, CONTRAST_FORMATTER, 1);
+	return send_control_msg(pdev,
+		SET_LUM_CTL, CONTRAST_FORMATTER, &buf, sizeof(buf));
 }
 
 /* GAMMA */
@@ -580,7 +616,8 @@ int pwc_get_gamma(struct pwc_device *pde
 	char buf;
 	int ret;
 
-	ret = RecvControlMsg(GET_LUM_CTL, GAMMA_FORMATTER, 1);
+	ret = recv_control_msg(pdev,
+		GET_LUM_CTL, GAMMA_FORMATTER, &buf, sizeof(buf));
 	if (ret < 0)
 		return ret;
 	return buf;
@@ -595,7 +632,8 @@ int pwc_set_gamma(struct pwc_device *pde
 	if (value > 0xffff)
 		value = 0xffff;
 	buf = (value >> 11) & 0x1f;
-	return SendControlMsg(SET_LUM_CTL, GAMMA_FORMATTER, 1);
+	return send_control_msg(pdev,
+		SET_LUM_CTL, GAMMA_FORMATTER, &buf, sizeof(buf));
 }
 
 
@@ -613,7 +651,8 @@ int pwc_get_saturation(struct pwc_device
 		saturation_register = SATURATION_MODE_FORMATTER2;
 	else
 		saturation_register = SATURATION_MODE_FORMATTER1;
-	ret = RecvControlMsg(GET_CHROM_CTL, saturation_register, 1);
+	ret = recv_control_msg(pdev,
+		GET_CHROM_CTL, saturation_register, &buf, sizeof(buf));
 	if (ret < 0)
 		return ret;
 	*value = (signed)buf;
@@ -636,7 +675,8 @@ int pwc_set_saturation(struct pwc_device
 		saturation_register = SATURATION_MODE_FORMATTER2;
 	else
 		saturation_register = SATURATION_MODE_FORMATTER1;
-	return SendControlMsg(SET_CHROM_CTL, saturation_register, 1);
+	return send_control_msg(pdev,
+		SET_CHROM_CTL, saturation_register, &buf, sizeof(buf));
 }
 
 /* AGC */
@@ -651,7 +691,8 @@ int pwc_set_agc(struct pwc_device *pdev,
 	else
 		buf = 0xff; /* fixed */
 
-	ret = SendControlMsg(SET_LUM_CTL, AGC_MODE_FORMATTER, 1);
+	ret = send_control_msg(pdev,
+		SET_LUM_CTL, AGC_MODE_FORMATTER, &buf, sizeof(buf));
 
 	if (!mode && ret >= 0) {
 		if (value < 0)
@@ -659,7 +700,8 @@ int pwc_set_agc(struct pwc_device *pdev,
 		if (value > 0xffff)
 			value = 0xffff;
 		buf = (value >> 10) & 0x3F;
-		ret = SendControlMsg(SET_LUM_CTL, PRESET_AGC_FORMATTER, 1);
+		ret = send_control_msg(pdev,
+			SET_LUM_CTL, PRESET_AGC_FORMATTER, &buf, sizeof(buf));
 	}
 	if (ret < 0)
 		return ret;
@@ -671,12 +713,14 @@ int pwc_get_agc(struct pwc_device *pdev,
 	unsigned char buf;
 	int ret;
 
-	ret = RecvControlMsg(GET_LUM_CTL, AGC_MODE_FORMATTER, 1);
+	ret = recv_control_msg(pdev,
+		GET_LUM_CTL, AGC_MODE_FORMATTER, &buf, sizeof(buf));
 	if (ret < 0)
 		return ret;
 
 	if (buf != 0) { /* fixed */
-		ret = RecvControlMsg(GET_LUM_CTL, PRESET_AGC_FORMATTER, 1);
+		ret = recv_control_msg(pdev,
+			GET_LUM_CTL, PRESET_AGC_FORMATTER, &buf, sizeof(buf));
 		if (ret < 0)
 			return ret;
 		if (buf > 0x3F)
@@ -684,7 +728,8 @@ int pwc_get_agc(struct pwc_device *pdev,
 		*value = (buf << 10);
 	}
 	else { /* auto */
-		ret = RecvControlMsg(GET_STATUS_CTL, READ_AGC_FORMATTER, 1);
+		ret = recv_control_msg(pdev,
+			GET_STATUS_CTL, READ_AGC_FORMATTER, &buf, sizeof(buf));
 		if (ret < 0)
 			return ret;
 		/* Gah... this value ranges from 0x00 ... 0x9F */
@@ -707,7 +752,8 @@ int pwc_set_shutter_speed(struct pwc_dev
 	else
 		buf[0] = 0xff; /* fixed */
 
-	ret = SendControlMsg(SET_LUM_CTL, SHUTTER_MODE_FORMATTER, 1);
+	ret = send_control_msg(pdev,
+		SET_LUM_CTL, SHUTTER_MODE_FORMATTER, &buf, sizeof(buf));
 
 	if (!mode && ret >= 0) {
 		if (value < 0)
@@ -726,7 +772,9 @@ int pwc_set_shutter_speed(struct pwc_dev
 			buf[0] = value >> 8;
 		}
 
-		ret = SendControlMsg(SET_LUM_CTL, PRESET_SHUTTER_FORMATTER, 2);
+		ret = send_control_msg(pdev,
+			SET_LUM_CTL, PRESET_SHUTTER_FORMATTER,
+			&buf, sizeof(buf));
 	}
 	return ret;
 }
@@ -737,7 +785,8 @@ int pwc_get_shutter_speed(struct pwc_dev
 	unsigned char buf[2];
 	int ret;
 
-	ret = RecvControlMsg(GET_STATUS_CTL, READ_SHUTTER_FORMATTER, 2);
+	ret = recv_control_msg(pdev,
+		GET_STATUS_CTL, READ_SHUTTER_FORMATTER, &buf, sizeof(buf));
 	if (ret < 0)
 		return ret;
 	*value = buf[0] + (buf[1] << 8);
@@ -764,7 +813,9 @@ int pwc_camera_power(struct pwc_device *
 		buf = 0x00; /* active */
 	else
 		buf = 0xFF; /* power save */
-	return SendControlMsg(SET_STATUS_CTL, SET_POWER_SAVE_MODE_FORMATTER, 1);
+	return send_control_msg(pdev,
+		SET_STATUS_CTL, SET_POWER_SAVE_MODE_FORMATTER,
+		&buf, sizeof(buf));
 }
 
 
@@ -773,20 +824,20 @@ int pwc_camera_power(struct pwc_device *
 
 int pwc_restore_user(struct pwc_device *pdev)
 {
-	char buf; /* dummy */
-	return SendControlMsg(SET_STATUS_CTL, RESTORE_USER_DEFAULTS_FORMATTER, 0);
+	return send_control_msg(pdev,
+		SET_STATUS_CTL, RESTORE_USER_DEFAULTS_FORMATTER, NULL, 0);
 }
 
 int pwc_save_user(struct pwc_device *pdev)
 {
-	char buf; /* dummy */
-	return SendControlMsg(SET_STATUS_CTL, SAVE_USER_DEFAULTS_FORMATTER, 0);
+	return send_control_msg(pdev,
+		SET_STATUS_CTL, SAVE_USER_DEFAULTS_FORMATTER, NULL, 0);
 }
 
 int pwc_restore_factory(struct pwc_device *pdev)
 {
-	char buf; /* dummy */
-	return SendControlMsg(SET_STATUS_CTL, RESTORE_FACTORY_DEFAULTS_FORMATTER, 0);
+	return send_control_msg(pdev,
+		SET_STATUS_CTL, RESTORE_FACTORY_DEFAULTS_FORMATTER, NULL, 0);
 }
 
  /* ************************************************* */
@@ -814,7 +865,8 @@ int pwc_set_awb(struct pwc_device *pdev,
 
 	buf = mode & 0x07; /* just the lowest three bits */
 
-	ret = SendControlMsg(SET_CHROM_CTL, WB_MODE_FORMATTER, 1);
+	ret = send_control_msg(pdev,
+		SET_CHROM_CTL, WB_MODE_FORMATTER, &buf, sizeof(buf));
 
 	if (ret < 0)
 		return ret;
@@ -826,7 +878,8 @@ int pwc_get_awb(struct pwc_device *pdev)
 	unsigned char buf;
 	int ret;
 
-	ret = RecvControlMsg(GET_CHROM_CTL, WB_MODE_FORMATTER, 1);
+	ret = recv_control_msg(pdev,
+		GET_CHROM_CTL, WB_MODE_FORMATTER, &buf, sizeof(buf));
 
 	if (ret < 0)
 		return ret;
@@ -843,7 +896,9 @@ int pwc_set_red_gain(struct pwc_device *
 		value = 0xffff;
 	/* only the msb is considered */
 	buf = value >> 8;
-	return SendControlMsg(SET_CHROM_CTL, PRESET_MANUAL_RED_GAIN_FORMATTER, 1);
+	return send_control_msg(pdev,
+		SET_CHROM_CTL, PRESET_MANUAL_RED_GAIN_FORMATTER,
+		&buf, sizeof(buf));
 }
 
 int pwc_get_red_gain(struct pwc_device *pdev, int *value)
@@ -851,7 +906,9 @@ int pwc_get_red_gain(struct pwc_device *
 	unsigned char buf;
 	int ret;
 
-	ret = RecvControlMsg(GET_CHROM_CTL, PRESET_MANUAL_RED_GAIN_FORMATTER, 1);
+	ret = recv_control_msg(pdev,
+		GET_CHROM_CTL, PRESET_MANUAL_RED_GAIN_FORMATTER,
+		&buf, sizeof(buf));
 	if (ret < 0)
 	    return ret;
 	*value = buf << 8;
@@ -869,7 +926,9 @@ int pwc_set_blue_gain(struct pwc_device 
 		value = 0xffff;
 	/* only the msb is considered */
 	buf = value >> 8;
-	return SendControlMsg(SET_CHROM_CTL, PRESET_MANUAL_BLUE_GAIN_FORMATTER, 1);
+	return send_control_msg(pdev,
+		SET_CHROM_CTL, PRESET_MANUAL_BLUE_GAIN_FORMATTER,
+		&buf, sizeof(buf));
 }
 
 int pwc_get_blue_gain(struct pwc_device *pdev, int *value)
@@ -877,7 +936,9 @@ int pwc_get_blue_gain(struct pwc_device 
 	unsigned char buf;
 	int ret;
 
-	ret = RecvControlMsg(GET_CHROM_CTL, PRESET_MANUAL_BLUE_GAIN_FORMATTER, 1);
+	ret = recv_control_msg(pdev,
+		GET_CHROM_CTL, PRESET_MANUAL_BLUE_GAIN_FORMATTER,
+		&buf, sizeof(buf));
 	if (ret < 0)
 	    return ret;
 	*value = buf << 8;
@@ -894,7 +955,8 @@ static int pwc_read_red_gain(struct pwc_
 	unsigned char buf;
 	int ret;
 
-	ret = RecvControlMsg(GET_STATUS_CTL, READ_RED_GAIN_FORMATTER, 1);
+	ret = recv_control_msg(pdev,
+		GET_STATUS_CTL, READ_RED_GAIN_FORMATTER, &buf, sizeof(buf));
 	if (ret < 0)
 		return ret;
 	*value = buf << 8;
@@ -906,7 +968,8 @@ static int pwc_read_blue_gain(struct pwc
 	unsigned char buf;
 	int ret;
 
-	ret = RecvControlMsg(GET_STATUS_CTL, READ_BLUE_GAIN_FORMATTER, 1);
+	ret = recv_control_msg(pdev,
+		GET_STATUS_CTL, READ_BLUE_GAIN_FORMATTER, &buf, sizeof(buf));
 	if (ret < 0)
 		return ret;
 	*value = buf << 8;
@@ -920,7 +983,8 @@ static int pwc_set_wb_speed(struct pwc_d
 
 	/* useful range is 0x01..0x20 */
 	buf = speed / 0x7f0;
-	return SendControlMsg(SET_CHROM_CTL, AWB_CONTROL_SPEED_FORMATTER, 1);
+	return send_control_msg(pdev,
+		SET_CHROM_CTL, AWB_CONTROL_SPEED_FORMATTER, &buf, sizeof(buf));
 }
 
 static int pwc_get_wb_speed(struct pwc_device *pdev, int *value)
@@ -928,7 +992,8 @@ static int pwc_get_wb_speed(struct pwc_d
 	unsigned char buf;
 	int ret;
 
-	ret = RecvControlMsg(GET_CHROM_CTL, AWB_CONTROL_SPEED_FORMATTER, 1);
+	ret = recv_control_msg(pdev,
+		GET_CHROM_CTL, AWB_CONTROL_SPEED_FORMATTER, &buf, sizeof(buf));
 	if (ret < 0)
 		return ret;
 	*value = buf * 0x7f0;
@@ -942,7 +1007,8 @@ static int pwc_set_wb_delay(struct pwc_d
 
 	/* useful range is 0x01..0x3F */
 	buf = (delay >> 10);
-	return SendControlMsg(SET_CHROM_CTL, AWB_CONTROL_DELAY_FORMATTER, 1);
+	return send_control_msg(pdev,
+		SET_CHROM_CTL, AWB_CONTROL_DELAY_FORMATTER, &buf, sizeof(buf));
 }
 
 static int pwc_get_wb_delay(struct pwc_device *pdev, int *value)
@@ -950,7 +1016,8 @@ static int pwc_get_wb_delay(struct pwc_d
 	unsigned char buf;
 	int ret;
 
-	ret = RecvControlMsg(GET_CHROM_CTL, AWB_CONTROL_DELAY_FORMATTER, 1);
+	ret = recv_control_msg(pdev,
+		GET_CHROM_CTL, AWB_CONTROL_DELAY_FORMATTER, &buf, sizeof(buf));
 	if (ret < 0)
 		return ret;
 	*value = buf << 10;
@@ -978,7 +1045,8 @@ int pwc_set_leds(struct pwc_device *pdev
 	buf[0] = on_value;
 	buf[1] = off_value;
 
-	return SendControlMsg(SET_STATUS_CTL, LED_FORMATTER, 2);
+	return send_control_msg(pdev,
+		SET_STATUS_CTL, LED_FORMATTER, &buf, sizeof(buf));
 }
 
 static int pwc_get_leds(struct pwc_device *pdev, int *on_value, int *off_value)
@@ -992,7 +1060,8 @@ static int pwc_get_leds(struct pwc_devic
 		return 0;
 	}
 
-	ret = RecvControlMsg(GET_STATUS_CTL, LED_FORMATTER, 2);
+	ret = recv_control_msg(pdev,
+		GET_STATUS_CTL, LED_FORMATTER, &buf, sizeof(buf));
 	if (ret < 0)
 		return ret;
 	*on_value = buf[0] * 100;
@@ -1009,7 +1078,8 @@ int pwc_set_contour(struct pwc_device *p
 		buf = 0xff; /* auto contour on */
 	else
 		buf = 0x0; /* auto contour off */
-	ret = SendControlMsg(SET_LUM_CTL, AUTO_CONTOUR_FORMATTER, 1);
+	ret = send_control_msg(pdev,
+		SET_LUM_CTL, AUTO_CONTOUR_FORMATTER, &buf, sizeof(buf));
 	if (ret < 0)
 		return ret;
 
@@ -1019,7 +1089,8 @@ int pwc_set_contour(struct pwc_device *p
 		contour = 0xffff;
 
 	buf = (contour >> 10); /* contour preset is [0..3f] */
-	ret = SendControlMsg(SET_LUM_CTL, PRESET_CONTOUR_FORMATTER, 1);
+	ret = send_control_msg(pdev,
+		SET_LUM_CTL, PRESET_CONTOUR_FORMATTER, &buf, sizeof(buf));
 	if (ret < 0)
 		return ret;
 	return 0;
@@ -1030,13 +1101,16 @@ int pwc_get_contour(struct pwc_device *p
 	unsigned char buf;
 	int ret;
 
-	ret = RecvControlMsg(GET_LUM_CTL, AUTO_CONTOUR_FORMATTER, 1);
+	ret = recv_control_msg(pdev,
+		GET_LUM_CTL, AUTO_CONTOUR_FORMATTER, &buf, sizeof(buf));
 	if (ret < 0)
 		return ret;
 
 	if (buf == 0) {
 		/* auto mode off, query current preset value */
-		ret = RecvControlMsg(GET_LUM_CTL, PRESET_CONTOUR_FORMATTER, 1);
+		ret = recv_control_msg(pdev,
+			GET_LUM_CTL, PRESET_CONTOUR_FORMATTER,
+			&buf, sizeof(buf));
 		if (ret < 0)
 			return ret;
 		*contour = buf << 10;
@@ -1055,7 +1129,9 @@ int pwc_set_backlight(struct pwc_device 
 		buf = 0xff;
 	else
 		buf = 0x0;
-	return SendControlMsg(SET_LUM_CTL, BACK_LIGHT_COMPENSATION_FORMATTER, 1);
+	return send_control_msg(pdev,
+		SET_LUM_CTL, BACK_LIGHT_COMPENSATION_FORMATTER,
+		&buf, sizeof(buf));
 }
 
 int pwc_get_backlight(struct pwc_device *pdev, int *backlight)
@@ -1063,7 +1139,9 @@ int pwc_get_backlight(struct pwc_device 
 	int ret;
 	unsigned char buf;
 
-	ret = RecvControlMsg(GET_LUM_CTL, BACK_LIGHT_COMPENSATION_FORMATTER, 1);
+	ret = recv_control_msg(pdev,
+		GET_LUM_CTL, BACK_LIGHT_COMPENSATION_FORMATTER,
+		&buf, sizeof(buf));
 	if (ret < 0)
 		return ret;
 	*backlight = !!buf;
@@ -1078,7 +1156,8 @@ int pwc_set_colour_mode(struct pwc_devic
 		buf = 0xff;
 	else
 		buf = 0x0;
-	return SendControlMsg(SET_CHROM_CTL, COLOUR_MODE_FORMATTER, 1);
+	return send_control_msg(pdev,
+		SET_CHROM_CTL, COLOUR_MODE_FORMATTER, &buf, sizeof(buf));
 }
 
 int pwc_get_colour_mode(struct pwc_device *pdev, int *colour)
@@ -1086,7 +1165,8 @@ int pwc_get_colour_mode(struct pwc_devic
 	int ret;
 	unsigned char buf;
 
-	ret = RecvControlMsg(GET_CHROM_CTL, COLOUR_MODE_FORMATTER, 1);
+	ret = recv_control_msg(pdev,
+		GET_CHROM_CTL, COLOUR_MODE_FORMATTER, &buf, sizeof(buf));
 	if (ret < 0)
 		return ret;
 	*colour = !!buf;
@@ -1102,7 +1182,8 @@ int pwc_set_flicker(struct pwc_device *p
 		buf = 0xff;
 	else
 		buf = 0x0;
-	return SendControlMsg(SET_LUM_CTL, FLICKERLESS_MODE_FORMATTER, 1);
+	return send_control_msg(pdev,
+		SET_LUM_CTL, FLICKERLESS_MODE_FORMATTER, &buf, sizeof(buf));
 }
 
 int pwc_get_flicker(struct pwc_device *pdev, int *flicker)
@@ -1110,7 +1191,8 @@ int pwc_get_flicker(struct pwc_device *p
 	int ret;
 	unsigned char buf;
 
-	ret = RecvControlMsg(GET_LUM_CTL, FLICKERLESS_MODE_FORMATTER, 1);
+	ret = recv_control_msg(pdev,
+		GET_LUM_CTL, FLICKERLESS_MODE_FORMATTER, &buf, sizeof(buf));
 	if (ret < 0)
 		return ret;
 	*flicker = !!buf;
@@ -1126,7 +1208,9 @@ int pwc_set_dynamic_noise(struct pwc_dev
 	if (noise > 3)
 		noise = 3;
 	buf = noise;
-	return SendControlMsg(SET_LUM_CTL, DYNAMIC_NOISE_CONTROL_FORMATTER, 1);
+	return send_control_msg(pdev,
+		SET_LUM_CTL, DYNAMIC_NOISE_CONTROL_FORMATTER,
+		&buf, sizeof(buf));
 }
 
 int pwc_get_dynamic_noise(struct pwc_device *pdev, int *noise)
@@ -1134,7 +1218,9 @@ int pwc_get_dynamic_noise(struct pwc_dev
 	int ret;
 	unsigned char buf;
 
-	ret = RecvControlMsg(GET_LUM_CTL, DYNAMIC_NOISE_CONTROL_FORMATTER, 1);
+	ret = recv_control_msg(pdev,
+		GET_LUM_CTL, DYNAMIC_NOISE_CONTROL_FORMATTER,
+		&buf, sizeof(buf));
 	if (ret < 0)
 		return ret;
 	*noise = buf;
@@ -1146,7 +1232,8 @@ static int _pwc_mpt_reset(struct pwc_dev
 	unsigned char buf;
 
 	buf = flags & 0x03; // only lower two bits are currently used
-	return SendControlMsg(SET_MPT_CTL, PT_RESET_CONTROL_FORMATTER, 1);
+	return send_control_msg(pdev,
+		SET_MPT_CTL, PT_RESET_CONTROL_FORMATTER, &buf, sizeof(buf));
 }
 
 int pwc_mpt_reset(struct pwc_device *pdev, int flags)
@@ -1175,7 +1262,8 @@ static int _pwc_mpt_set_angle(struct pwc
 	buf[1] = (pan >> 8) & 0xFF;
 	buf[2] = tilt & 0xFF;
 	buf[3] = (tilt >> 8) & 0xFF;
-	return SendControlMsg(SET_MPT_CTL, PT_RELATIVE_CONTROL_FORMATTER, 4);
+	return send_control_msg(pdev,
+		SET_MPT_CTL, PT_RELATIVE_CONTROL_FORMATTER, &buf, sizeof(buf));
 }
 
 int pwc_mpt_set_angle(struct pwc_device *pdev, int pan, int tilt)
@@ -1211,7 +1299,8 @@ static int pwc_mpt_get_status(struct pwc
 	int ret;
 	unsigned char buf[5];
 
-	ret = RecvControlMsg(GET_MPT_CTL, PT_STATUS_FORMATTER, 5);
+	ret = recv_control_msg(pdev,
+		GET_MPT_CTL, PT_STATUS_FORMATTER, &buf, sizeof(buf));
 	if (ret < 0)
 		return ret;
 	status->status = buf[0] & 0x7; // 3 bits are used for reporting
@@ -1233,7 +1322,8 @@ int pwc_get_cmos_sensor(struct pwc_devic
 	else
 		request = SENSOR_TYPE_FORMATTER2;
 
-	ret = RecvControlMsg(GET_STATUS_CTL, request, 1);
+	ret = recv_control_msg(pdev,
+		GET_STATUS_CTL, request, &buf, sizeof(buf));
 	if (ret < 0)
 		return ret;
 	if (pdev->type < 675)

