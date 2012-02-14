Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:35505 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754002Ab2BNLfp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Feb 2012 06:35:45 -0500
Received: by wgbdt10 with SMTP id dt10so5832274wgb.1
        for <linux-media@vger.kernel.org>; Tue, 14 Feb 2012 03:35:44 -0800 (PST)
MIME-Version: 1.0
From: Javier Martin <javier.martin@vista-silicon.com>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, mchehab@infradead.org,
	s.hauer@pengutronix.de,
	Javier Martin <javier.martin@vista-silicon.com>
Subject: [PATCH] media: i.MX27 camera: Add resizing support.
Date: Tue, 14 Feb 2012 12:35:32 +0100
Message-Id: <1329219332-27620-1-git-send-email-javier.martin@vista-silicon.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If the attached video sensor cannot provide the
requested image size, try to use resizing engine
included in the eMMa-PrP IP.

This patch supports both averaging and bilinear
algorithms.

Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
---
 drivers/media/video/mx2_camera.c |  251 +++++++++++++++++++++++++++++++++++++-
 1 files changed, 249 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/mx2_camera.c b/drivers/media/video/mx2_camera.c
index 9e84368..6516ee4 100644
--- a/drivers/media/video/mx2_camera.c
+++ b/drivers/media/video/mx2_camera.c
@@ -19,6 +19,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/errno.h>
 #include <linux/fs.h>
+#include <linux/gcd.h>
 #include <linux/interrupt.h>
 #include <linux/kernel.h>
 #include <linux/mm.h>
@@ -204,10 +205,25 @@
 #define PRP_INTR_LBOVF		(1 << 7)
 #define PRP_INTR_CH2OVF		(1 << 8)
 
+/* Resizing registers */
+#define PRP_RZ_VALID_TBL_LEN(x)	((x) << 24)
+#define PRP_RZ_VALID_BILINEAR	(1 << 31)
+
 #define mx27_camera_emma(pcdev)	(cpu_is_mx27() && pcdev->use_emma)
 
 #define MAX_VIDEO_MEM	16
 
+#define RESIZE_NUM_MIN	1
+#define RESIZE_NUM_MAX	20
+#define BC_COEF		3
+#define SZ_COEF		(1 << BC_COEF)
+
+#define RESIZE_DIR_H	0
+#define RESIZE_DIR_V	1
+
+#define RESIZE_ALGO_BILINEAR 0
+#define RESIZE_ALGO_AVERAGING 1
+
 struct mx2_prp_cfg {
 	int channel;
 	u32 in_fmt;
@@ -217,6 +233,13 @@ struct mx2_prp_cfg {
 	u32 irq_flags;
 };
 
+/* prp resizing parameters */
+struct emma_prp_resize {
+	int		algo; /* type of algorithm used */
+	int		len; /* number of coefficients */
+	unsigned char	s[RESIZE_NUM_MAX]; /* table of coefficients */
+};
+
 /* prp configuration for a client-host fmt pair */
 struct mx2_fmt_cfg {
 	enum v4l2_mbus_pixelcode	in_fmt;
@@ -278,6 +301,8 @@ struct mx2_camera_dev {
 	dma_addr_t		discard_buffer_dma;
 	size_t			discard_size;
 	struct mx2_fmt_cfg	*emma_prp;
+	struct emma_prp_resize	resizing[2];
+	unsigned int		s_width, s_height;
 	u32			frame_count;
 	struct vb2_alloc_ctx	*alloc_ctx;
 };
@@ -687,7 +712,7 @@ static void mx27_camera_emma_buf_init(struct soc_camera_device *icd,
 	struct mx2_camera_dev *pcdev = ici->priv;
 	struct mx2_fmt_cfg *prp = pcdev->emma_prp;
 
-	writel((icd->user_width << 16) | icd->user_height,
+	writel((pcdev->s_width << 16) | pcdev->s_height,
 	       pcdev->base_emma + PRP_SRC_FRAME_SIZE);
 	writel(prp->cfg.src_pixel,
 	       pcdev->base_emma + PRP_SRC_PIXEL_FORMAT_CNTL);
@@ -707,6 +732,74 @@ static void mx27_camera_emma_buf_init(struct soc_camera_device *icd,
 	writel(prp->cfg.irq_flags, pcdev->base_emma + PRP_INTR_CNTL);
 }
 
+static void mx2_prp_resize_commit(struct mx2_camera_dev *pcdev)
+{
+	int dir;
+
+	for (dir = RESIZE_DIR_H; dir <= RESIZE_DIR_V; dir++) {
+		unsigned char *s = pcdev->resizing[dir].s;
+		int len = pcdev->resizing[dir].len;
+		unsigned int coeff[2] = {0, 0};
+		unsigned int valid  = 0;
+		int i;
+
+		if (len == 0)
+			continue;
+
+		for (i = RESIZE_NUM_MAX - 1; i >= 0; i--) {
+			int j;
+
+			j = i > 9 ? 1 : 0;
+			coeff[j] = (coeff[j] << BC_COEF) |
+			(s[i] & (SZ_COEF - 1));
+
+			if (i == 5 || i == 15)
+				coeff[j] <<= 1;
+
+			valid = (valid << 1) | (s[i] >> BC_COEF);
+		}
+
+		valid |= PRP_RZ_VALID_TBL_LEN(len);
+
+		if (pcdev->resizing[dir].algo == RESIZE_ALGO_BILINEAR)
+			valid |= PRP_RZ_VALID_BILINEAR;
+
+		if (pcdev->emma_prp->cfg.channel == 1) {
+			if (dir == RESIZE_DIR_H) {
+				writel(coeff[0], pcdev->base_emma +
+							PRP_CH1_RZ_HORI_COEF1);
+				writel(coeff[1], pcdev->base_emma +
+							PRP_CH1_RZ_HORI_COEF2);
+				writel(valid, pcdev->base_emma +
+							PRP_CH1_RZ_HORI_VALID);
+			} else {
+				writel(coeff[0], pcdev->base_emma +
+							PRP_CH1_RZ_VERT_COEF1);
+				writel(coeff[1], pcdev->base_emma +
+							PRP_CH1_RZ_VERT_COEF2);
+				writel(valid, pcdev->base_emma +
+							PRP_CH1_RZ_VERT_VALID);
+			}
+		} else {
+			if (dir == RESIZE_DIR_H) {
+				writel(coeff[0], pcdev->base_emma +
+							PRP_CH2_RZ_HORI_COEF1);
+				writel(coeff[1], pcdev->base_emma +
+							PRP_CH2_RZ_HORI_COEF2);
+				writel(valid, pcdev->base_emma +
+							PRP_CH2_RZ_HORI_VALID);
+			} else {
+				writel(coeff[0], pcdev->base_emma +
+							PRP_CH2_RZ_VERT_COEF1);
+				writel(coeff[1], pcdev->base_emma +
+							PRP_CH2_RZ_VERT_COEF2);
+				writel(valid, pcdev->base_emma +
+							PRP_CH2_RZ_VERT_VALID);
+			}
+		}
+	}
+}
+
 static int mx2_start_streaming(struct vb2_queue *q, unsigned int count)
 {
 	struct soc_camera_device *icd = soc_camera_from_vb2q(q);
@@ -773,6 +866,8 @@ static int mx2_start_streaming(struct vb2_queue *q, unsigned int count)
 		list_add_tail(&pcdev->buf_discard[1].queue,
 				      &pcdev->discard);
 
+		mx2_prp_resize_commit(pcdev);
+
 		mx27_camera_emma_buf_init(icd, bytesperline);
 
 		if (prp->cfg.channel == 1) {
@@ -1059,6 +1154,119 @@ static int mx2_camera_get_formats(struct soc_camera_device *icd,
 	return formats;
 }
 
+static int mx2_emmaprp_resize(struct mx2_camera_dev *pcdev,
+			      struct v4l2_mbus_framefmt *mf_in,
+			      struct v4l2_pix_format *pix_out)
+{
+	int num, den;
+	unsigned long m;
+	int i, dir;
+
+	for (dir = RESIZE_DIR_H; dir <= RESIZE_DIR_V; dir++) {
+		unsigned char *s = pcdev->resizing[dir].s;
+		int len = 0;
+		int in, out;
+
+		if (dir == RESIZE_DIR_H) {
+			in = mf_in->width;
+			out = pix_out->width;
+		} else {
+			in = mf_in->height;
+			out = pix_out->height;
+		}
+
+		if (in < out)
+			return -EINVAL;
+		else if (in == out)
+			continue;
+
+		/* Calculate ratio */
+		m = gcd(in, out);
+		num = in / m;
+		den = out / m;
+		if (num > RESIZE_NUM_MAX)
+			return -EINVAL;
+
+		if ((num >= 2 * den) && (den == 1) &&
+		    (num < 9) && (!(num & 0x01))) {
+			int sum = 0;
+			int j;
+
+			/* Average scaling for > 2:1 ratios */
+			/* Support can be added for num >=9 and odd values */
+
+			pcdev->resizing[dir].algo = RESIZE_ALGO_AVERAGING;
+			len = num;
+
+			for (i = 0; i < (len / 2); i++)
+				s[i] = 8;
+
+			do {
+				for (i = 0; i < (len / 2); i++) {
+					s[i] = s[i] >> 1;
+					sum = 0;
+					for (j = 0; j < (len / 2); j++)
+						sum += s[j];
+					if (sum == 4)
+						break;
+				}
+			} while (sum != 4);
+
+			for (i = (len / 2); i < len; i++)
+				s[i] = s[len - i - 1];
+
+			s[len - 1] |= SZ_COEF;
+		} else {
+			/* bilinear scaling for < 2:1 ratios */
+			int v; /* overflow counter */
+			int coeff, nxt; /* table output */
+			int in_pos_inc = 2 * den;
+			int out_pos = num;
+			int out_pos_inc = 2 * num;
+			int init_carry = num - den;
+			int carry = init_carry;
+
+			pcdev->resizing[dir].algo = RESIZE_ALGO_BILINEAR;
+			v = den + in_pos_inc;
+			do {
+				coeff = v - out_pos;
+				out_pos += out_pos_inc;
+				carry += out_pos_inc;
+				for (nxt = 0; v < out_pos; nxt++) {
+					v += in_pos_inc;
+					carry -= in_pos_inc;
+				}
+
+				if (len > RESIZE_NUM_MAX)
+					return -EINVAL;
+
+				coeff = ((coeff << BC_COEF) +
+					(in_pos_inc >> 1)) / in_pos_inc;
+
+				if (coeff >= (SZ_COEF - 1))
+					coeff--;
+
+				coeff |= SZ_COEF;
+				s[len] = (unsigned char)coeff;
+				len++;
+
+				for (i = 1; i < nxt; i++) {
+					if (len >= RESIZE_NUM_MAX)
+						return -EINVAL;
+					s[len] = 0;
+					len++;
+				}
+			} while (carry != init_carry);
+		}
+		pcdev->resizing[dir].len = len;
+		if (dir == RESIZE_DIR_H)
+			mf_in->width = mf_in->width * den / num;
+		else
+			mf_in->height = mf_in->height * den / num;
+	}
+	return 0;
+}
+
 static int mx2_camera_set_fmt(struct soc_camera_device *icd,
 			       struct v4l2_format *f)
 {
@@ -1070,6 +1278,9 @@ static int mx2_camera_set_fmt(struct soc_camera_device *icd,
 	struct v4l2_mbus_framefmt mf;
 	int ret;
 
+	dev_dbg(icd->parent, "%s: requested params: width = %d, height = %d\n",
+		__func__, pix->width, pix->height);
+
 	xlate = soc_camera_xlate_by_fourcc(icd, pix->pixelformat);
 	if (!xlate) {
 		dev_warn(icd->parent, "Format %x not found\n",
@@ -1087,6 +1298,18 @@ static int mx2_camera_set_fmt(struct soc_camera_device *icd,
 	if (ret < 0 && ret != -ENOIOCTLCMD)
 		return ret;
 
+	/* Store width and height returned by the sensor for resizing */
+	pcdev->s_width = mf.width;
+	pcdev->s_height = mf.height;
+	dev_dbg(icd->parent, "%s: sensor params: width = %d, height = %d\n",
+		__func__, pcdev->s_width, pcdev->s_height);
+
+	memset(pcdev->resizing, 0, sizeof(struct emma_prp_resize) << 1);
+	if (mf.width != pix->width || mf.height != pix->height) {
+		if (mx2_emmaprp_resize(pcdev, &mf, pix) < 0)
+			return -EINVAL;
+	}
+
 	if (mf.code != xlate->code)
 		return -EINVAL;
 
@@ -1100,6 +1323,9 @@ static int mx2_camera_set_fmt(struct soc_camera_device *icd,
 		pcdev->emma_prp = mx27_emma_prp_get_format(xlate->code,
 						xlate->host_fmt->fourcc);
 
+	dev_dbg(icd->parent, "%s: returned params: width = %d, height = %d\n",
+		__func__, pix->width, pix->height);
+
 	return 0;
 }
 
@@ -1109,11 +1335,16 @@ static int mx2_camera_try_fmt(struct soc_camera_device *icd,
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
 	const struct soc_camera_format_xlate *xlate;
 	struct v4l2_pix_format *pix = &f->fmt.pix;
-	struct v4l2_mbus_framefmt mf;
 	__u32 pixfmt = pix->pixelformat;
+	struct v4l2_mbus_framefmt mf;
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
+	struct mx2_camera_dev *pcdev = ici->priv;
 	unsigned int width_limit;
 	int ret;
 
+	dev_dbg(icd->parent, "%s: requested params: width = %d, height = %d\n",
+		__func__, pix->width, pix->height);
+
 	xlate = soc_camera_xlate_by_fourcc(icd, pixfmt);
 	if (pixfmt && !xlate) {
 		dev_warn(icd->parent, "Format %x not found\n", pixfmt);
@@ -1163,6 +1394,19 @@ static int mx2_camera_try_fmt(struct soc_camera_device *icd,
 	if (ret < 0)
 		return ret;
 
+	/* Store width and height returned by the sensor for resizing */
+	pcdev->s_width = mf.width;
+	pcdev->s_height = mf.height;
+	dev_dbg(icd->parent, "%s: sensor params: width = %d, height = %d\n",
+		__func__, pcdev->s_width, pcdev->s_height);
+
+	/* If the sensor does not support image size try PrP resizing */
+	memset(pcdev->resizing, 0, sizeof(struct emma_prp_resize) << 1);
+	if (mf.width != pix->width || mf.height != pix->height) {
+		if (mx2_emmaprp_resize(pcdev, &mf, pix) < 0)
+			return -EINVAL;
+	}
+
 	if (mf.field == V4L2_FIELD_ANY)
 		mf.field = V4L2_FIELD_NONE;
 	/*
@@ -1181,6 +1425,9 @@ static int mx2_camera_try_fmt(struct soc_camera_device *icd,
 	pix->field	= mf.field;
 	pix->colorspace	= mf.colorspace;
 
+	dev_dbg(icd->parent, "%s: returned params: width = %d, height = %d\n",
+		__func__, pix->width, pix->height);
+
 	return 0;
 }
 
-- 
1.7.0.4

