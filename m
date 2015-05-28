Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vn0-f48.google.com ([209.85.216.48]:36636 "EHLO
	mail-vn0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754006AbbE1WWW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 May 2015 18:22:22 -0400
Received: by vnbg190 with SMTP id g190so6472121vnb.3
        for <linux-media@vger.kernel.org>; Thu, 28 May 2015 15:22:22 -0700 (PDT)
From: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: <linux-media@vger.kernel.org>,
	Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
	Michael Stegemann <michael@stegemann.it>,
	Dale Hamel <dale.hamel@srvthe.net>
Subject: [PATCH] stk1160: Add frame scaling support
Date: Thu, 28 May 2015 19:19:03 -0300
Message-Id: <1432851543-3576-1-git-send-email-ezequiel@vanguardiasur.com.ar>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This commit implements frame decimation for stk1160, which allows
to support format changes instead of a static frame size.

The stk1160 supports independent row and column decimation, in two
different modes:
 * set a number of rows/columns units to skip for each unit sent.
 * set a number of rows/columns units to send for each unit skipped.

This effectively allows to achieve different frame scaling ratios.

The unit number can be set to either two row/columns sent/skipped,
or four row/columns sent/skipped. Since the video format (UYVY)
has 4-bytes, using a unit number of two row/columns, results
in frame color 'shifting'.

Signed-off-by: Michael Stegemann <michael@stegemann.it>
Signed-off-by: Dale Hamel <dale.hamel@srvthe.net>
Signed-off-by: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
---
 drivers/media/usb/stk1160/stk1160-reg.h |  34 ++++++
 drivers/media/usb/stk1160/stk1160-v4l.c | 178 +++++++++++++++++++++++++++-----
 2 files changed, 184 insertions(+), 28 deletions(-)

diff --git a/drivers/media/usb/stk1160/stk1160-reg.h b/drivers/media/usb/stk1160/stk1160-reg.h
index 3e49da6..81ff3a1 100644
--- a/drivers/media/usb/stk1160/stk1160-reg.h
+++ b/drivers/media/usb/stk1160/stk1160-reg.h
@@ -33,6 +33,40 @@
  */
 #define STK1160_DCTRL			0x100
 
+/*
+ * Decimation Control Register:
+ * Byte 104: Horizontal Decimation Line Unit Count
+ * Byte 105: Vertical Decimation Line Unit Count
+ * Byte 106: Decimation Control
+ * Bit 0 - Horizontal Decimation Control
+ *   0 Horizontal decimation is disabled.
+ *   1 Horizontal decimation is enabled.
+ * Bit 1 - Decimates Half or More Column
+ *   0 Decimates less than half from original column,
+ *     send count unit (0x105) before each unit skipped.
+ *   1 Decimates half or more from original column,
+ *     skip count unit (0x105) before each unit sent.
+ * Bit 2 - Vertical Decimation Control
+ *   0 Vertical decimation is disabled.
+ *   1 Vertical decimation is enabled.
+ * Bit 3 - Vertical Greater or Equal to Half
+ *   0 Decimates less than half from original row,
+ *     send count unit (0x105) before each unit skipped.
+ *   1 Decimates half or more from original row,
+ *     skip count unit (0x105) before each unit sent.
+ * Bit 4 - Decimation Unit
+ *  0 Decimation will work with 2 rows or columns per unit.
+ *  1 Decimation will work with 4 rows or columns per unit.
+ */
+#define STK1160_DMCTRL_H_UNITS		0x104
+#define STK1160_DMCTRL_V_UNITS		0x105
+#define STK1160_DMCTRL			0x106
+#define  STK1160_H_DEC_EN		BIT(0)
+#define  STK1160_H_DEC_MODE		BIT(1)
+#define  STK1160_V_DEC_EN		BIT(2)
+#define  STK1160_V_DEC_MODE		BIT(3)
+#define  STK1160_DEC_UNIT_SIZE		BIT(4)
+
 /* Capture Frame Start Position */
 #define STK116_CFSPO			0x110
 #define STK116_CFSPO_STX_L		0x110
diff --git a/drivers/media/usb/stk1160/stk1160-v4l.c b/drivers/media/usb/stk1160/stk1160-v4l.c
index 749ad56..5b0a3ac 100644
--- a/drivers/media/usb/stk1160/stk1160-v4l.c
+++ b/drivers/media/usb/stk1160/stk1160-v4l.c
@@ -42,6 +42,17 @@ static bool keep_buffers;
 module_param(keep_buffers, bool, 0644);
 MODULE_PARM_DESC(keep_buffers, "don't release buffers upon stop streaming");
 
+enum stk1160_decimate_mode {
+	STK1160_DECIMATE_MORE_THAN_HALF,
+	STK1160_DECIMATE_LESS_THAN_HALF,
+};
+
+struct stk1160_decimate_ctrl {
+	bool col_en, row_en;
+	enum stk1160_decimate_mode col_mode, row_mode;
+	unsigned int col_n, row_n;
+};
+
 /* supported video standards */
 static struct stk1160_fmt format[] = {
 	{
@@ -106,6 +117,37 @@ static void stk1160_set_std(struct stk1160 *dev)
 
 }
 
+static void stk1160_set_fmt(struct stk1160 *dev,
+			    struct stk1160_decimate_ctrl *ctrl)
+{
+	u32 val = 0;
+
+	if (ctrl) {
+		/*
+		 * Since the format is UYVY, the device must skip or send
+		 * a number of rows/columns multiple of four. This way, the
+		 * colour format is preserved. The STK1160_DEC_UNIT_SIZE bit
+		 * does exactly this.
+		 */
+		val |= STK1160_DEC_UNIT_SIZE;
+		val |= ctrl->col_en ? STK1160_H_DEC_EN : 0;
+		val |= ctrl->row_en ? STK1160_V_DEC_EN : 0;
+		val |= ctrl->col_mode == STK1160_DECIMATE_MORE_THAN_HALF ? STK1160_H_DEC_MODE : 0;
+		val |= ctrl->row_mode == STK1160_DECIMATE_MORE_THAN_HALF ? STK1160_V_DEC_MODE : 0;
+
+		/* Horizontal count units */
+		stk1160_write_reg(dev, STK1160_DMCTRL_H_UNITS, ctrl->col_n);
+		/* Vertical count units */
+		stk1160_write_reg(dev, STK1160_DMCTRL_V_UNITS, ctrl->row_n);
+
+		stk1160_dbg("decimate 0x%x, column units %d, row units %d\n",
+			    val, ctrl->col_n, ctrl->row_n);
+	}
+
+	/* Decimation control */
+	stk1160_write_reg(dev, STK1160_DMCTRL, val);
+}
+
 /*
  * Set a new alternate setting.
  * Returns true is dev->max_pkt_size has changed, false otherwise.
@@ -321,26 +363,111 @@ static int vidioc_g_fmt_vid_cap(struct file *file, void *priv,
 	return 0;
 }
 
-static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
-			struct v4l2_format *f)
+static void stk1160_try_fmt(struct stk1160 *dev, struct v4l2_format *f,
+			    struct stk1160_decimate_ctrl *ctrl)
 {
-	struct stk1160 *dev = video_drvdata(file);
+	int height = f->fmt.pix.height;
+	int width = f->fmt.pix.width;
+	int base_width, base_height;
+	unsigned int col_n, row_n;
+	enum stk1160_decimate_mode col_mode, row_mode;
+	bool col_en, row_en;
+
+	base_width = 720;
+	base_height = (dev->norm & V4L2_STD_525_60) ? 480 : 576;
+
+	if (width >= base_width) {
+		col_en = false;
+		col_mode = STK1160_DECIMATE_LESS_THAN_HALF;
+		col_n = 0;
+		f->fmt.pix.width = base_width;
+	} else if (width > base_width / 2) {
+		/*
+		 * The device will send count units for each
+		 * unit skipped. This means count unit is:
+		 *
+		 * n = width / (frame width - width)
+		 *
+		 * And the width is:
+		 *
+		 * width = (n / n + 1) * frame width
+		 */
+		col_en = true;
+		col_mode = STK1160_DECIMATE_LESS_THAN_HALF;
+		col_n = DIV_ROUND_CLOSEST(width, base_width - width);
+		f->fmt.pix.width = (base_width * col_n) / (col_n + 1);
 
-	/*
-	 * User can't choose size at his own will,
-	 * so we just return him the current size chosen
-	 * at standard selection.
-	 * TODO: Implement frame scaling?
-	 */
+	} else if (width <= base_width / 2) {
+
+		/*
+		 * The device will skip count units for each
+		 * unit sent. This means count is:
+		 *
+		 * n = (frame width / width) - 1
+		 *
+		 * And the width is:
+		 *
+		 * width = frame width / (n + 1)
+		 */
+		col_en = true;
+		col_mode = STK1160_DECIMATE_MORE_THAN_HALF;
+		col_n = DIV_ROUND_CLOSEST(base_width, width) - 1;
+		f->fmt.pix.width = base_width / (col_n + 1);
+	} else {
+		col_en = false;
+		col_mode = STK1160_DECIMATE_LESS_THAN_HALF;
+		col_n = 0;
+		f->fmt.pix.width = base_width;
+	}
+
+	if (height >= base_height) {
+		row_en = false;
+		row_mode = STK1160_DECIMATE_LESS_THAN_HALF;
+		row_n = 0;
+		f->fmt.pix.height = base_height;
+	} else if (height > base_height / 2) {
+		row_en = true;
+		row_mode = STK1160_DECIMATE_LESS_THAN_HALF;
+		row_n = DIV_ROUND_CLOSEST(height, base_height - height);
+		f->fmt.pix.height = (base_height * row_n) / (row_n + 1);
+
+	} else if (height <= base_height / 2) {
+		row_en = true;
+		row_mode = STK1160_DECIMATE_MORE_THAN_HALF;
+		row_n = DIV_ROUND_CLOSEST(base_height, height) - 1;
+		f->fmt.pix.height = base_height / (row_n + 1);
+	} else {
+		row_en = false;
+		row_mode = STK1160_DECIMATE_LESS_THAN_HALF;
+		row_n = 0;
+		f->fmt.pix.height = base_height;
+	}
 
 	f->fmt.pix.pixelformat = dev->fmt->fourcc;
-	f->fmt.pix.width = dev->width;
-	f->fmt.pix.height = dev->height;
 	f->fmt.pix.field = V4L2_FIELD_INTERLACED;
-	f->fmt.pix.bytesperline = dev->width * 2;
-	f->fmt.pix.sizeimage = dev->height * f->fmt.pix.bytesperline;
+	f->fmt.pix.bytesperline = f->fmt.pix.width * 2;
+	f->fmt.pix.sizeimage = f->fmt.pix.height * f->fmt.pix.bytesperline;
 	f->fmt.pix.colorspace = V4L2_COLORSPACE_SMPTE170M;
 
+	if (ctrl) {
+		ctrl->col_en = col_en;
+		ctrl->col_n = col_n;
+		ctrl->col_mode = col_mode;
+		ctrl->row_en = row_en;
+		ctrl->row_n = row_n;
+		ctrl->row_mode = row_mode;
+	}
+
+	stk1160_dbg("width %d, height %d\n",
+		    f->fmt.pix.width, f->fmt.pix.height);
+}
+
+static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
+				  struct v4l2_format *f)
+{
+	struct stk1160 *dev = video_drvdata(file);
+
+	stk1160_try_fmt(dev, f, NULL);
 	return 0;
 }
 
@@ -349,13 +476,15 @@ static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
 {
 	struct stk1160 *dev = video_drvdata(file);
 	struct vb2_queue *q = &dev->vb_vidq;
+	struct stk1160_decimate_ctrl ctrl;
 
 	if (vb2_is_busy(q))
 		return -EBUSY;
 
-	vidioc_try_fmt_vid_cap(file, priv, f);
-
-	/* We don't support any format changes */
+	stk1160_try_fmt(dev, f, &ctrl);
+	dev->width = f->fmt.pix.width;
+	dev->height = f->fmt.pix.height;
+	stk1160_set_fmt(dev, &ctrl);
 
 	return 0;
 }
@@ -391,22 +520,15 @@ static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id norm)
 		return -ENODEV;
 
 	/* We need to set this now, before we call stk1160_set_std */
+	dev->width = 720;
+	dev->height = (norm & V4L2_STD_525_60) ? 480 : 576;
 	dev->norm = norm;
 
-	/* This is taken from saa7115 video decoder */
-	if (dev->norm & V4L2_STD_525_60) {
-		dev->width = 720;
-		dev->height = 480;
-	} else if (dev->norm & V4L2_STD_625_50) {
-		dev->width = 720;
-		dev->height = 576;
-	} else {
-		stk1160_err("invalid standard\n");
-		return -EINVAL;
-	}
-
 	stk1160_set_std(dev);
 
+	/* Calling with NULL disables frame decimation */
+	stk1160_set_fmt(dev, NULL);
+
 	v4l2_device_call_all(&dev->v4l2_dev, 0, video, s_std,
 			dev->norm);
 
-- 
2.3.3

