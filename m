Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail01d.mail.t-online.hu ([84.2.42.6]:63500 "EHLO
	mail01d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754020AbZKHMcb (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 8 Nov 2009 07:32:31 -0500
Message-ID: <4AF6BA5C.9030304@freemail.hu>
Date: Sun, 08 Nov 2009 13:32:28 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Hans de Goede <hdegoede@redhat.com>,
	Jean-Francois Moine <moinejf@free.fr>,
	V4L Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 1/2] gspca pac7302/pac7311: propagate error to higher level
 software
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Márton Németh <nm127@freemail.hu>

The usb_control_msg() can fail any time. Only continue writing
sequence if there was no error with the previous write. If there
was any problem stop sending URBs and propagate the error to the
gspca_main.

Only the pac7302 driver was tested with Labtec Webcam 2200
(USB ID 093a:2626) because of lack of hardware for pac7311.

Signed-off-by: Márton Németh <nm127@freemail.hu>
---
The patch is based on the 13327:19c0469c02c3 of http://linuxtv.org/hg/v4l-dvb/ .
This patch replaces http://linuxtv.org/hg/~jfrancois/v4l-dvb/rev/2dc5e25b76c1
and http://linuxtv.org/hg/~jfrancois/v4l-dvb/rev/43be85676a49 . In addition to
those patches this patch also updates sd_stopN() function in pac7311.
---
diff -r 19c0469c02c3 linux/drivers/media/video/gspca/pac7302.c
--- a/linux/drivers/media/video/gspca/pac7302.c	Sat Nov 07 15:51:01 2009 -0200
+++ b/linux/drivers/media/video/gspca/pac7302.c	Sun Nov 08 11:54:26 2009 +0100
@@ -331,7 +331,7 @@
 	0x00
 };

-static void reg_w_buf(struct gspca_dev *gspca_dev,
+static int reg_w_buf(struct gspca_dev *gspca_dev,
 		  __u8 index,
 		  const char *buffer, int len)
 {
@@ -349,6 +349,7 @@
 		PDEBUG(D_ERR, "reg_w_buf(): "
 		"Failed to write registers to index 0x%x, error %i",
 		index, ret);
+	return ret;
 }

 #if 0 /* not used */
@@ -373,7 +374,7 @@
 }
 #endif

-static void reg_w(struct gspca_dev *gspca_dev,
+static int reg_w(struct gspca_dev *gspca_dev,
 		  __u8 index,
 		  __u8 value)
 {
@@ -390,23 +391,27 @@
 		PDEBUG(D_ERR, "reg_w(): "
 		"Failed to write register to index 0x%x, value 0x%x, error %i",
 		index, value, ret);
+	return ret;
 }

-static void reg_w_seq(struct gspca_dev *gspca_dev,
+static int reg_w_seq(struct gspca_dev *gspca_dev,
 		const __u8 *seq, int len)
 {
+	int ret = 0;
 	while (--len >= 0) {
-		reg_w(gspca_dev, seq[0], seq[1]);
+		if (0 <= ret)
+			ret = reg_w(gspca_dev, seq[0], seq[1]);
 		seq += 2;
 	}
+	return ret;
 }

 /* load the beginning of a page */
-static void reg_w_page(struct gspca_dev *gspca_dev,
+static int reg_w_page(struct gspca_dev *gspca_dev,
 			const __u8 *page, int len)
 {
 	int index;
-	int ret;
+	int ret = 0;

 	for (index = 0; index < len; index++) {
 		if (page[index] == SKIP)		/* skip this index */
@@ -418,52 +423,61 @@
 			USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
 				0, index, gspca_dev->usb_buf, 1,
 				500);
-		if (ret < 0)
+		if (ret < 0) {
 			PDEBUG(D_ERR, "reg_w_page(): "
 			"Failed to write register to index 0x%x, "
 			"value 0x%x, error %i",
 			index, page[index], ret);
+			break;
+		}
 	}
+	return ret;
 }

 /* output a variable sequence */
-static void reg_w_var(struct gspca_dev *gspca_dev,
+static int reg_w_var(struct gspca_dev *gspca_dev,
 			const __u8 *seq,
 			const __u8 *page3, unsigned int page3_len,
 			const __u8 *page4, unsigned int page4_len)
 {
 	int index, len;
+	int ret = 0;

 	for (;;) {
 		index = *seq++;
 		len = *seq++;
 		switch (len) {
 		case END_OF_SEQUENCE:
-			return;
+			return ret;
 		case LOAD_PAGE4:
-			reg_w_page(gspca_dev, page4, page4_len);
+			ret = reg_w_page(gspca_dev, page4, page4_len);
 			break;
 		case LOAD_PAGE3:
-			reg_w_page(gspca_dev, page3, page3_len);
+			ret = reg_w_page(gspca_dev, page3, page3_len);
 			break;
 		default:
 			if (len > USB_BUF_SZ) {
 				PDEBUG(D_ERR|D_STREAM,
 					"Incorrect variable sequence");
-				return;
+				return -EINVAL;
 			}
 			while (len > 0) {
 				if (len < 8) {
-					reg_w_buf(gspca_dev, index, seq, len);
+					ret = reg_w_buf(gspca_dev,
+						index, seq, len);
+					if (ret < 0)
+						return ret;
 					seq += len;
 					break;
 				}
-				reg_w_buf(gspca_dev, index, seq, 8);
+				ret = reg_w_buf(gspca_dev, index, seq, 8);
 				seq += 8;
 				index += 8;
 				len -= 8;
 			}
 		}
+		if (ret < 0)
+			return ret;
 	}
 	/* not reached */
 }
@@ -493,10 +507,11 @@
 }

 /* This function is used by pac7302 only */
-static void setbrightcont(struct gspca_dev *gspca_dev)
+static int setbrightcont(struct gspca_dev *gspca_dev)
 {
 	struct sd *sd = (struct sd *) gspca_dev;
 	int i, v;
+	int ret;
 	static const __u8 max[10] =
 		{0x29, 0x33, 0x42, 0x5a, 0x6e, 0x80, 0x9f, 0xbb,
 		 0xd4, 0xec};
@@ -504,7 +519,7 @@
 		{0x35, 0x33, 0x33, 0x2f, 0x2a, 0x25, 0x1e, 0x17,
 		 0x11, 0x0b};

-	reg_w(gspca_dev, 0xff, 0x00);	/* page 0 */
+	ret = reg_w(gspca_dev, 0xff, 0x00);	/* page 0 */
 	for (i = 0; i < 10; i++) {
 		v = max[i];
 		v += (sd->brightness - BRIGHTNESS_MAX)
@@ -514,47 +529,62 @@
 			v = 0;
 		else if (v > 0xff)
 			v = 0xff;
-		reg_w(gspca_dev, 0xa2 + i, v);
+		if (0 <= ret)
+			ret = reg_w(gspca_dev, 0xa2 + i, v);
 	}
-	reg_w(gspca_dev, 0xdc, 0x01);
+	if (0 <= ret)
+		ret = reg_w(gspca_dev, 0xdc, 0x01);
+	return ret;
 }

 /* This function is used by pac7302 only */
-static void setcolors(struct gspca_dev *gspca_dev)
+static int setcolors(struct gspca_dev *gspca_dev)
 {
 	struct sd *sd = (struct sd *) gspca_dev;
 	int i, v;
+	int ret;
 	static const int a[9] =
 		{217, -212, 0, -101, 170, -67, -38, -315, 355};
 	static const int b[9] =
 		{19, 106, 0, 19, 106, 1, 19, 106, 1};

-	reg_w(gspca_dev, 0xff, 0x03);	/* page 3 */
-	reg_w(gspca_dev, 0x11, 0x01);
-	reg_w(gspca_dev, 0xff, 0x00);	/* page 0 */
+	ret = reg_w(gspca_dev, 0xff, 0x03);	/* page 3 */
+	if (0 <= ret)
+		ret = reg_w(gspca_dev, 0x11, 0x01);
+	if (0 <= ret)
+		ret = reg_w(gspca_dev, 0xff, 0x00);	/* page 0 */
 	for (i = 0; i < 9; i++) {
 		v = a[i] * sd->colors / COLOR_MAX + b[i];
-		reg_w(gspca_dev, 0x0f + 2 * i, (v >> 8) & 0x07);
-		reg_w(gspca_dev, 0x0f + 2 * i + 1, v);
+		if (0 <= ret)
+			ret = reg_w(gspca_dev, 0x0f + 2 * i, (v >> 8) & 0x07);
+		if (0 <= ret)
+			ret = reg_w(gspca_dev, 0x0f + 2 * i + 1, v);
 	}
-	reg_w(gspca_dev, 0xdc, 0x01);
+	if (0 <= ret)
+		ret = reg_w(gspca_dev, 0xdc, 0x01);
 	PDEBUG(D_CONF|D_STREAM, "color: %i", sd->colors);
+	return ret;
 }

-static void setgain(struct gspca_dev *gspca_dev)
+static int setgain(struct gspca_dev *gspca_dev)
 {
 	struct sd *sd = (struct sd *) gspca_dev;
+	int ret;

-	reg_w(gspca_dev, 0xff, 0x03);		/* page 3 */
-	reg_w(gspca_dev, 0x10, sd->gain >> 3);
+	ret = reg_w(gspca_dev, 0xff, 0x03);		/* page 3 */
+	if (0 <= ret)
+		ret = reg_w(gspca_dev, 0x10, sd->gain >> 3);

 	/* load registers to sensor (Bit 0, auto clear) */
-	reg_w(gspca_dev, 0x11, 0x01);
+	if (0 <= ret)
+		ret = reg_w(gspca_dev, 0x11, 0x01);
+	return ret;
 }

-static void setexposure(struct gspca_dev *gspca_dev)
+static int setexposure(struct gspca_dev *gspca_dev)
 {
 	struct sd *sd = (struct sd *) gspca_dev;
+	int ret;
 	__u8 reg;

 	/* register 2 of frame 3/4 contains the clock divider configuring the
@@ -570,47 +600,58 @@
 	   the nearest multiple of 3, except when between 6 and 12? */
 	if (reg < 6 || reg > 12)
 		reg = ((reg + 1) / 3) * 3;
-	reg_w(gspca_dev, 0xff, 0x03);		/* page 3 */
-	reg_w(gspca_dev, 0x02, reg);
+	ret = reg_w(gspca_dev, 0xff, 0x03);		/* page 3 */
+	if (0 <= ret)
+		ret = reg_w(gspca_dev, 0x02, reg);

 	/* load registers to sensor (Bit 0, auto clear) */
-	reg_w(gspca_dev, 0x11, 0x01);
+	if (0 <= ret)
+		ret = reg_w(gspca_dev, 0x11, 0x01);
+	return ret;
 }

-static void sethvflip(struct gspca_dev *gspca_dev)
+static int sethvflip(struct gspca_dev *gspca_dev)
 {
 	struct sd *sd = (struct sd *) gspca_dev;
+	int ret;
 	__u8 data;

-	reg_w(gspca_dev, 0xff, 0x03);		/* page 3 */
+	ret = reg_w(gspca_dev, 0xff, 0x03);		/* page 3 */
 	data = (sd->hflip ? 0x08 : 0x00) | (sd->vflip ? 0x04 : 0x00);
-	reg_w(gspca_dev, 0x21, data);
+	if (0 <= ret)
+		ret = reg_w(gspca_dev, 0x21, data);
 	/* load registers to sensor (Bit 0, auto clear) */
-	reg_w(gspca_dev, 0x11, 0x01);
+	if (0 <= ret)
+		ret = reg_w(gspca_dev, 0x11, 0x01);
+	return ret;
 }

 /* this function is called at probe and resume time for pac7302 */
 static int sd_init(struct gspca_dev *gspca_dev)
 {
-	reg_w_seq(gspca_dev, init_7302, sizeof(init_7302)/2);
-
-	return 0;
+	return reg_w_seq(gspca_dev, init_7302, sizeof(init_7302)/2);
 }

 static int sd_start(struct gspca_dev *gspca_dev)
 {
 	struct sd *sd = (struct sd *) gspca_dev;
+	int ret = 0;

 	sd->sof_read = 0;

-	reg_w_var(gspca_dev, start_7302,
+	ret = reg_w_var(gspca_dev, start_7302,
 		page3_7302, sizeof(page3_7302),
 		NULL, 0);
-	setbrightcont(gspca_dev);
-	setcolors(gspca_dev);
-	setgain(gspca_dev);
-	setexposure(gspca_dev);
-	sethvflip(gspca_dev);
+	if (0 <= ret)
+		ret = setbrightcont(gspca_dev);
+	if (0 <= ret)
+		ret = setcolors(gspca_dev);
+	if (0 <= ret)
+		ret = setgain(gspca_dev);
+	if (0 <= ret)
+		ret = setexposure(gspca_dev);
+	if (0 <= ret)
+		ret = sethvflip(gspca_dev);

 	/* only resolution 640x480 is supported for pac7302 */

@@ -619,26 +660,35 @@
 	atomic_set(&sd->avg_lum, -1);

 	/* start stream */
-	reg_w(gspca_dev, 0xff, 0x01);
-	reg_w(gspca_dev, 0x78, 0x01);
+	if (0 <= ret)
+		ret = reg_w(gspca_dev, 0xff, 0x01);
+	if (0 <= ret)
+		ret = reg_w(gspca_dev, 0x78, 0x01);

-	return 0;
+	return ret;
 }

 static void sd_stopN(struct gspca_dev *gspca_dev)
 {
-	reg_w(gspca_dev, 0xff, 0x01);
-	reg_w(gspca_dev, 0x78, 0x00);
-	reg_w(gspca_dev, 0x78, 0x00);
+	int ret;
+
+	ret = reg_w(gspca_dev, 0xff, 0x01);
+	if (0 <= ret)
+		ret = reg_w(gspca_dev, 0x78, 0x00);
+	if (0 <= ret)
+		ret = reg_w(gspca_dev, 0x78, 0x00);
 }

 /* called on streamoff with alt 0 and on disconnect for pac7302 */
 static void sd_stop0(struct gspca_dev *gspca_dev)
 {
+	int ret;
+
 	if (!gspca_dev->present)
 		return;
-	reg_w(gspca_dev, 0xff, 0x01);
-	reg_w(gspca_dev, 0x78, 0x40);
+	ret = reg_w(gspca_dev, 0xff, 0x01);
+	if (0 <= ret)
+		ret = reg_w(gspca_dev, 0x78, 0x40);
 }

 /* Include pac common sof detection functions */
diff -r 19c0469c02c3 linux/drivers/media/video/gspca/pac7311.c
--- a/linux/drivers/media/video/gspca/pac7311.c	Sat Nov 07 15:51:01 2009 -0200
+++ b/linux/drivers/media/video/gspca/pac7311.c	Sun Nov 08 11:54:26 2009 +0100
@@ -259,7 +259,7 @@
 	0x23, 0x28, 0x04, 0x11, 0x00, 0x00
 };

-static void reg_w_buf(struct gspca_dev *gspca_dev,
+static int reg_w_buf(struct gspca_dev *gspca_dev,
 		  __u8 index,
 		  const char *buffer, int len)
 {
@@ -277,6 +277,7 @@
 		PDEBUG(D_ERR, "reg_w_buf(): "
 		"Failed to write registers to index 0x%x, error %i",
 		index, ret);
+	return ret;
 }

 #if 0 /* not used */
@@ -301,7 +302,7 @@
 }
 #endif

-static void reg_w(struct gspca_dev *gspca_dev,
+static int reg_w(struct gspca_dev *gspca_dev,
 		  __u8 index,
 		  __u8 value)
 {
@@ -318,23 +319,27 @@
 		PDEBUG(D_ERR, "reg_w(): "
 		"Failed to write register to index 0x%x, value 0x%x, error %i",
 		index, value, ret);
+	return ret;
 }

-static void reg_w_seq(struct gspca_dev *gspca_dev,
+static int reg_w_seq(struct gspca_dev *gspca_dev,
 		const __u8 *seq, int len)
 {
+	int ret = 0;
 	while (--len >= 0) {
-		reg_w(gspca_dev, seq[0], seq[1]);
+		if (0 <= ret)
+			ret = reg_w(gspca_dev, seq[0], seq[1]);
 		seq += 2;
 	}
+	return ret;
 }

 /* load the beginning of a page */
-static void reg_w_page(struct gspca_dev *gspca_dev,
+static int reg_w_page(struct gspca_dev *gspca_dev,
 			const __u8 *page, int len)
 {
 	int index;
-	int ret;
+	int ret = 0;

 	for (index = 0; index < len; index++) {
 		if (page[index] == SKIP)		/* skip this index */
@@ -346,52 +351,61 @@
 			USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
 				0, index, gspca_dev->usb_buf, 1,
 				500);
-		if (ret < 0)
+		if (ret < 0) {
 			PDEBUG(D_ERR, "reg_w_page(): "
 			"Failed to write register to index 0x%x, "
 			"value 0x%x, error %i",
 			index, page[index], ret);
+			break;
+		}
 	}
+	return ret;
 }

 /* output a variable sequence */
-static void reg_w_var(struct gspca_dev *gspca_dev,
+static int reg_w_var(struct gspca_dev *gspca_dev,
 			const __u8 *seq,
 			const __u8 *page3, unsigned int page3_len,
 			const __u8 *page4, unsigned int page4_len)
 {
 	int index, len;
+	int ret = 0;

 	for (;;) {
 		index = *seq++;
 		len = *seq++;
 		switch (len) {
 		case END_OF_SEQUENCE:
-			return;
+			return ret;
 		case LOAD_PAGE4:
-			reg_w_page(gspca_dev, page4, page4_len);
+			ret = reg_w_page(gspca_dev, page4, page4_len);
 			break;
 		case LOAD_PAGE3:
-			reg_w_page(gspca_dev, page3, page3_len);
+			ret = reg_w_page(gspca_dev, page3, page3_len);
 			break;
 		default:
 			if (len > USB_BUF_SZ) {
 				PDEBUG(D_ERR|D_STREAM,
 					"Incorrect variable sequence");
-				return;
+				return -EINVAL;
 			}
 			while (len > 0) {
 				if (len < 8) {
-					reg_w_buf(gspca_dev, index, seq, len);
+					ret = reg_w_buf(gspca_dev,
+						index, seq, len);
+					if (ret < 0)
+						return ret;
 					seq += len;
 					break;
 				}
-				reg_w_buf(gspca_dev, index, seq, 8);
+				ret = reg_w_buf(gspca_dev, index, seq, 8);
 				seq += 8;
 				index += 8;
 				len -= 8;
 			}
 		}
+		if (ret < 0)
+			return ret;
 	}
 	/* not reached */
 }
@@ -419,36 +433,46 @@
 }

 /* This function is used by pac7311 only */
-static void setcontrast(struct gspca_dev *gspca_dev)
+static int setcontrast(struct gspca_dev *gspca_dev)
 {
 	struct sd *sd = (struct sd *) gspca_dev;
+	int ret;

-	reg_w(gspca_dev, 0xff, 0x04);
-	reg_w(gspca_dev, 0x10, sd->contrast >> 4);
+	ret = reg_w(gspca_dev, 0xff, 0x04);
+	if (0 <= ret)
+		ret = reg_w(gspca_dev, 0x10, sd->contrast >> 4);
 	/* load registers to sensor (Bit 0, auto clear) */
-	reg_w(gspca_dev, 0x11, 0x01);
+	if (0 <= ret)
+		ret = reg_w(gspca_dev, 0x11, 0x01);
+	return ret;
 }

-static void setgain(struct gspca_dev *gspca_dev)
+static int setgain(struct gspca_dev *gspca_dev)
 {
 	struct sd *sd = (struct sd *) gspca_dev;
 	int gain = GAIN_MAX - sd->gain;
+	int ret;

 	if (gain < 1)
 		gain = 1;
 	else if (gain > 245)
 		gain = 245;
-	reg_w(gspca_dev, 0xff, 0x04);		/* page 4 */
-	reg_w(gspca_dev, 0x0e, 0x00);
-	reg_w(gspca_dev, 0x0f, gain);
+	ret = reg_w(gspca_dev, 0xff, 0x04);		/* page 4 */
+	if (0 <= ret)
+		ret = reg_w(gspca_dev, 0x0e, 0x00);
+	if (0 <= ret)
+		ret = reg_w(gspca_dev, 0x0f, gain);

 	/* load registers to sensor (Bit 0, auto clear) */
-	reg_w(gspca_dev, 0x11, 0x01);
+	if (0 <= ret)
+		ret = reg_w(gspca_dev, 0x11, 0x01);
+	return ret;
 }

-static void setexposure(struct gspca_dev *gspca_dev)
+static int setexposure(struct gspca_dev *gspca_dev)
 {
 	struct sd *sd = (struct sd *) gspca_dev;
+	int ret;
 	__u8 reg;

 	/* register 2 of frame 3/4 contains the clock divider configuring the
@@ -460,71 +484,94 @@
 	else if (reg > 63)
 		reg = 63;

-	reg_w(gspca_dev, 0xff, 0x04);		/* page 4 */
-	reg_w(gspca_dev, 0x02, reg);
+	ret = reg_w(gspca_dev, 0xff, 0x04);		/* page 4 */
+	if (0 <= ret)
+		ret = reg_w(gspca_dev, 0x02, reg);
 	/* Page 1 register 8 must always be 0x08 except when not in
 	   640x480 mode and Page3/4 reg 2 <= 3 then it must be 9 */
-	reg_w(gspca_dev, 0xff, 0x01);
+	if (0 <= ret)
+		ret = reg_w(gspca_dev, 0xff, 0x01);
 	if (gspca_dev->cam.cam_mode[(int)gspca_dev->curr_mode].priv &&
-			reg <= 3)
-		reg_w(gspca_dev, 0x08, 0x09);
-	else
-		reg_w(gspca_dev, 0x08, 0x08);
+			reg <= 3) {
+		if (0 <= ret)
+			ret = reg_w(gspca_dev, 0x08, 0x09);
+	} else {
+		if (0 <= ret)
+			ret = reg_w(gspca_dev, 0x08, 0x08);
+	}

 	/* load registers to sensor (Bit 0, auto clear) */
-	reg_w(gspca_dev, 0x11, 0x01);
+	if (0 <= ret)
+		ret = reg_w(gspca_dev, 0x11, 0x01);
+	return ret;
 }

-static void sethvflip(struct gspca_dev *gspca_dev)
+static int sethvflip(struct gspca_dev *gspca_dev)
 {
 	struct sd *sd = (struct sd *) gspca_dev;
+	int ret;
 	__u8 data;

-	reg_w(gspca_dev, 0xff, 0x04);		/* page 4 */
+	ret = reg_w(gspca_dev, 0xff, 0x04);		/* page 4 */
 	data = (sd->hflip ? 0x04 : 0x00) | (sd->vflip ? 0x08 : 0x00);
-	reg_w(gspca_dev, 0x21, data);
+	if (0 <= ret)
+		ret = reg_w(gspca_dev, 0x21, data);
 	/* load registers to sensor (Bit 0, auto clear) */
-	reg_w(gspca_dev, 0x11, 0x01);
+	if (0 <= ret)
+		ret = reg_w(gspca_dev, 0x11, 0x01);
+	return ret;
 }

 /* this function is called at probe and resume time for pac7311 */
 static int sd_init(struct gspca_dev *gspca_dev)
 {
-	reg_w_seq(gspca_dev, init_7311, sizeof(init_7311)/2);
-
-	return 0;
+	return reg_w_seq(gspca_dev, init_7311, sizeof(init_7311)/2);
 }

 static int sd_start(struct gspca_dev *gspca_dev)
 {
 	struct sd *sd = (struct sd *) gspca_dev;
+	int ret;

 	sd->sof_read = 0;

-	reg_w_var(gspca_dev, start_7311,
+	ret = reg_w_var(gspca_dev, start_7311,
 		NULL, 0,
 		page4_7311, sizeof(page4_7311));
-	setcontrast(gspca_dev);
-	setgain(gspca_dev);
-	setexposure(gspca_dev);
-	sethvflip(gspca_dev);
+	if (0 <= ret)
+		ret = setcontrast(gspca_dev);
+	if (0 <= ret)
+		ret = setgain(gspca_dev);
+	if (0 <= ret)
+		ret = setexposure(gspca_dev);
+	if (0 <= ret)
+		ret = sethvflip(gspca_dev);

 	/* set correct resolution */
 	switch (gspca_dev->cam.cam_mode[(int) gspca_dev->curr_mode].priv) {
 	case 2:					/* 160x120 pac7311 */
-		reg_w(gspca_dev, 0xff, 0x01);
-		reg_w(gspca_dev, 0x17, 0x20);
-		reg_w(gspca_dev, 0x87, 0x10);
+		if (0 <= ret)
+			ret = reg_w(gspca_dev, 0xff, 0x01);
+		if (0 <= ret)
+			ret = reg_w(gspca_dev, 0x17, 0x20);
+		if (0 <= ret)
+			ret = reg_w(gspca_dev, 0x87, 0x10);
 		break;
 	case 1:					/* 320x240 pac7311 */
-		reg_w(gspca_dev, 0xff, 0x01);
-		reg_w(gspca_dev, 0x17, 0x30);
-		reg_w(gspca_dev, 0x87, 0x11);
+		if (0 <= ret)
+			ret = reg_w(gspca_dev, 0xff, 0x01);
+		if (0 <= ret)
+			ret = reg_w(gspca_dev, 0x17, 0x30);
+		if (0 <= ret)
+			ret = reg_w(gspca_dev, 0x87, 0x11);
 		break;
 	case 0:					/* 640x480 */
-		reg_w(gspca_dev, 0xff, 0x01);
-		reg_w(gspca_dev, 0x17, 0x00);
-		reg_w(gspca_dev, 0x87, 0x12);
+		if (0 <= ret)
+			ret = reg_w(gspca_dev, 0xff, 0x01);
+		if (0 <= ret)
+			ret = reg_w(gspca_dev, 0x17, 0x00);
+		if (0 <= ret)
+			ret = reg_w(gspca_dev, 0x87, 0x12);
 		break;
 	}

@@ -533,24 +580,37 @@
 	atomic_set(&sd->avg_lum, -1);

 	/* start stream */
-	reg_w(gspca_dev, 0xff, 0x01);
-	reg_w(gspca_dev, 0x78, 0x05);
+	if (0 <= ret)
+		ret = reg_w(gspca_dev, 0xff, 0x01);
+	if (0 <= ret)
+		ret = reg_w(gspca_dev, 0x78, 0x05);

-	return 0;
+	return ret;
 }

 static void sd_stopN(struct gspca_dev *gspca_dev)
 {
-	reg_w(gspca_dev, 0xff, 0x04);
-	reg_w(gspca_dev, 0x27, 0x80);
-	reg_w(gspca_dev, 0x28, 0xca);
-	reg_w(gspca_dev, 0x29, 0x53);
-	reg_w(gspca_dev, 0x2a, 0x0e);
-	reg_w(gspca_dev, 0xff, 0x01);
-	reg_w(gspca_dev, 0x3e, 0x20);
-	reg_w(gspca_dev, 0x78, 0x44); /* Bit_0=start stream, Bit_6=LED */
-	reg_w(gspca_dev, 0x78, 0x44); /* Bit_0=start stream, Bit_6=LED */
-	reg_w(gspca_dev, 0x78, 0x44); /* Bit_0=start stream, Bit_6=LED */
+	int ret;
+
+	ret = reg_w(gspca_dev, 0xff, 0x04);
+	if (0 <= ret)
+		ret = reg_w(gspca_dev, 0x27, 0x80);
+	if (0 <= ret)
+		ret = reg_w(gspca_dev, 0x28, 0xca);
+	if (0 <= ret)
+		ret = reg_w(gspca_dev, 0x29, 0x53);
+	if (0 <= ret)
+		ret = reg_w(gspca_dev, 0x2a, 0x0e);
+	if (0 <= ret)
+		ret = reg_w(gspca_dev, 0xff, 0x01);
+	if (0 <= ret)
+		ret = reg_w(gspca_dev, 0x3e, 0x20);
+	if (0 <= ret)
+		ret = reg_w(gspca_dev, 0x78, 0x44); /* Bit_0=start stream, Bit_6=LED */
+	if (0 <= ret)
+		ret = reg_w(gspca_dev, 0x78, 0x44); /* Bit_0=start stream, Bit_6=LED */
+	if (0 <= ret)
+		ret = reg_w(gspca_dev, 0x78, 0x44); /* Bit_0=start stream, Bit_6=LED */
 }

 /* called on streamoff with alt 0 and on disconnect for 7311 */
