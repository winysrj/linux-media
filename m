Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:45147 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754089AbaETN1b (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 May 2014 09:27:31 -0400
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N5V0016SK1TPC90@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Tue, 20 May 2014 22:27:29 +0900 (KST)
From: Kamil Debski <k.debski@samsung.com>
To: linux-media@vger.kernel.org
Cc: posciak@chromium.org, s.nawrocki@samsung.com, t.figa@samsung.com,
	arun.kk@samsung.com, Kamil Debski <k.debski@samsung.com>
Subject: [PATCH v3] v4l: s5p-mfc: Limit enum_fmt to output formats of current
 version
Date: Tue, 20 May 2014 15:25:00 +0200
Message-id: <1400592300-18207-1-git-send-email-k.debski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

MFC versions support a different set of formats, this specially applies
to the raw YUV formats. This patch changes enum_fmt, so that it only
reports formats that are supported by the used MFC version.

Signed-off-by: Kamil Debski <k.debski@samsung.com>
Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
v2 included suggestions made by Pawel Osciak.
v3 includes a fix in the codecs supported by the MFC encoder.
---
 drivers/media/platform/s5p-mfc/s5p_mfc.c        |    3 ++
 drivers/media/platform/s5p-mfc/s5p_mfc_common.h |    7 ++++
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c    |   49 +++++++++++++---------
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c    |   50 ++++++++++++-----------
 4 files changed, 67 insertions(+), 42 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index 2ab90dd..2ae7168 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -1339,6 +1339,7 @@ struct s5p_mfc_buf_align mfc_buf_align_v5 = {
 
 static struct s5p_mfc_variant mfc_drvdata_v5 = {
 	.version	= MFC_VERSION,
+	.version_bit	= MFC_V5_BIT,
 	.port_num	= MFC_NUM_PORTS,
 	.buf_size	= &buf_size_v5,
 	.buf_align	= &mfc_buf_align_v5,
@@ -1365,6 +1366,7 @@ struct s5p_mfc_buf_align mfc_buf_align_v6 = {
 
 static struct s5p_mfc_variant mfc_drvdata_v6 = {
 	.version	= MFC_VERSION_V6,
+	.version_bit	= MFC_V6_BIT,
 	.port_num	= MFC_NUM_PORTS_V6,
 	.buf_size	= &buf_size_v6,
 	.buf_align	= &mfc_buf_align_v6,
@@ -1391,6 +1393,7 @@ struct s5p_mfc_buf_align mfc_buf_align_v7 = {
 
 static struct s5p_mfc_variant mfc_drvdata_v7 = {
 	.version	= MFC_VERSION_V7,
+	.version_bit	= MFC_V7_BIT,
 	.port_num	= MFC_NUM_PORTS_V7,
 	.buf_size	= &buf_size_v7,
 	.buf_align	= &mfc_buf_align_v7,
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
index 993c993..4f3d38e 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
@@ -223,6 +223,7 @@ struct s5p_mfc_buf_align {
 struct s5p_mfc_variant {
 	unsigned int version;
 	unsigned int port_num;
+	u32 version_bit;
 	struct s5p_mfc_buf_size *buf_size;
 	struct s5p_mfc_buf_align *buf_align;
 	char	*fw_name;
@@ -664,6 +665,7 @@ struct s5p_mfc_fmt {
 	u32 codec_mode;
 	enum s5p_mfc_fmt_type type;
 	u32 num_planes;
+	u32 versions;
 };
 
 /**
@@ -703,4 +705,9 @@ void set_work_bit_irqsave(struct s5p_mfc_ctx *ctx);
 #define IS_MFCV6_PLUS(dev)	(dev->variant->version >= 0x60 ? 1 : 0)
 #define IS_MFCV7_PLUS(dev)	(dev->variant->version >= 0x70 ? 1 : 0)
 
+#define MFC_V5_BIT	BIT(0)
+#define MFC_V6_BIT	BIT(1)
+#define MFC_V7_BIT	BIT(2)
+
+
 #endif /* S5P_MFC_COMMON_H_ */
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
index ac43a4a..641ff07 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
@@ -39,6 +39,7 @@ static struct s5p_mfc_fmt formats[] = {
 		.codec_mode	= S5P_MFC_CODEC_NONE,
 		.type		= MFC_FMT_RAW,
 		.num_planes	= 2,
+		.versions	= MFC_V6_BIT | MFC_V7_BIT,
 	},
 	{
 		.name		= "4:2:0 2 Planes 64x32 Tiles",
@@ -46,6 +47,7 @@ static struct s5p_mfc_fmt formats[] = {
 		.codec_mode	= S5P_MFC_CODEC_NONE,
 		.type		= MFC_FMT_RAW,
 		.num_planes	= 2,
+		.versions	= MFC_V5_BIT,
 	},
 	{
 		.name		= "4:2:0 2 Planes Y/CbCr",
@@ -53,6 +55,7 @@ static struct s5p_mfc_fmt formats[] = {
 		.codec_mode	= S5P_MFC_CODEC_NONE,
 		.type		= MFC_FMT_RAW,
 		.num_planes	= 2,
+		.versions	= MFC_V6_BIT | MFC_V7_BIT,
 	},
 	{
 		.name		= "4:2:0 2 Planes Y/CrCb",
@@ -60,6 +63,7 @@ static struct s5p_mfc_fmt formats[] = {
 		.codec_mode	= S5P_MFC_CODEC_NONE,
 		.type		= MFC_FMT_RAW,
 		.num_planes	= 2,
+		.versions	= MFC_V6_BIT | MFC_V7_BIT,
 	},
 	{
 		.name		= "H264 Encoded Stream",
@@ -67,6 +71,7 @@ static struct s5p_mfc_fmt formats[] = {
 		.codec_mode	= S5P_MFC_CODEC_H264_DEC,
 		.type		= MFC_FMT_DEC,
 		.num_planes	= 1,
+		.versions	= MFC_V5_BIT | MFC_V6_BIT | MFC_V7_BIT,
 	},
 	{
 		.name		= "H264/MVC Encoded Stream",
@@ -74,6 +79,7 @@ static struct s5p_mfc_fmt formats[] = {
 		.codec_mode	= S5P_MFC_CODEC_H264_MVC_DEC,
 		.type		= MFC_FMT_DEC,
 		.num_planes	= 1,
+		.versions	= MFC_V6_BIT | MFC_V7_BIT,
 	},
 	{
 		.name		= "H263 Encoded Stream",
@@ -81,6 +87,7 @@ static struct s5p_mfc_fmt formats[] = {
 		.codec_mode	= S5P_MFC_CODEC_H263_DEC,
 		.type		= MFC_FMT_DEC,
 		.num_planes	= 1,
+		.versions	= MFC_V5_BIT | MFC_V6_BIT | MFC_V7_BIT,
 	},
 	{
 		.name		= "MPEG1 Encoded Stream",
@@ -88,6 +95,7 @@ static struct s5p_mfc_fmt formats[] = {
 		.codec_mode	= S5P_MFC_CODEC_MPEG2_DEC,
 		.type		= MFC_FMT_DEC,
 		.num_planes	= 1,
+		.versions	= MFC_V5_BIT | MFC_V6_BIT | MFC_V7_BIT,
 	},
 	{
 		.name		= "MPEG2 Encoded Stream",
@@ -95,6 +103,7 @@ static struct s5p_mfc_fmt formats[] = {
 		.codec_mode	= S5P_MFC_CODEC_MPEG2_DEC,
 		.type		= MFC_FMT_DEC,
 		.num_planes	= 1,
+		.versions	= MFC_V5_BIT | MFC_V6_BIT | MFC_V7_BIT,
 	},
 	{
 		.name		= "MPEG4 Encoded Stream",
@@ -102,6 +111,7 @@ static struct s5p_mfc_fmt formats[] = {
 		.codec_mode	= S5P_MFC_CODEC_MPEG4_DEC,
 		.type		= MFC_FMT_DEC,
 		.num_planes	= 1,
+		.versions	= MFC_V5_BIT | MFC_V6_BIT | MFC_V7_BIT,
 	},
 	{
 		.name		= "XviD Encoded Stream",
@@ -109,6 +119,7 @@ static struct s5p_mfc_fmt formats[] = {
 		.codec_mode	= S5P_MFC_CODEC_MPEG4_DEC,
 		.type		= MFC_FMT_DEC,
 		.num_planes	= 1,
+		.versions	= MFC_V5_BIT | MFC_V6_BIT | MFC_V7_BIT,
 	},
 	{
 		.name		= "VC1 Encoded Stream",
@@ -116,6 +127,7 @@ static struct s5p_mfc_fmt formats[] = {
 		.codec_mode	= S5P_MFC_CODEC_VC1_DEC,
 		.type		= MFC_FMT_DEC,
 		.num_planes	= 1,
+		.versions	= MFC_V5_BIT | MFC_V6_BIT | MFC_V7_BIT,
 	},
 	{
 		.name		= "VC1 RCV Encoded Stream",
@@ -123,6 +135,7 @@ static struct s5p_mfc_fmt formats[] = {
 		.codec_mode	= S5P_MFC_CODEC_VC1RCV_DEC,
 		.type		= MFC_FMT_DEC,
 		.num_planes	= 1,
+		.versions	= MFC_V5_BIT | MFC_V6_BIT | MFC_V7_BIT,
 	},
 	{
 		.name		= "VP8 Encoded Stream",
@@ -130,6 +143,7 @@ static struct s5p_mfc_fmt formats[] = {
 		.codec_mode	= S5P_MFC_CODEC_VP8_DEC,
 		.type		= MFC_FMT_DEC,
 		.num_planes	= 1,
+		.versions	= MFC_V6_BIT | MFC_V7_BIT,
 	},
 };
 
@@ -260,8 +274,10 @@ static int vidioc_querycap(struct file *file, void *priv,
 }
 
 /* Enumerate format */
-static int vidioc_enum_fmt(struct v4l2_fmtdesc *f, bool mplane, bool out)
+static int vidioc_enum_fmt(struct file *file, struct v4l2_fmtdesc *f,
+							bool mplane, bool out)
 {
+	struct s5p_mfc_dev *dev = video_drvdata(file);
 	struct s5p_mfc_fmt *fmt;
 	int i, j = 0;
 
@@ -274,6 +290,8 @@ static int vidioc_enum_fmt(struct v4l2_fmtdesc *f, bool mplane, bool out)
 			continue;
 		else if (!out && formats[i].type != MFC_FMT_RAW)
 			continue;
+		else if ((dev->variant->version_bit & formats[i].versions) == 0)
+			continue;
 
 		if (j == f->index)
 			break;
@@ -290,25 +308,25 @@ static int vidioc_enum_fmt(struct v4l2_fmtdesc *f, bool mplane, bool out)
 static int vidioc_enum_fmt_vid_cap(struct file *file, void *pirv,
 							struct v4l2_fmtdesc *f)
 {
-	return vidioc_enum_fmt(f, false, false);
+	return vidioc_enum_fmt(file, f, false, false);
 }
 
 static int vidioc_enum_fmt_vid_cap_mplane(struct file *file, void *pirv,
 							struct v4l2_fmtdesc *f)
 {
-	return vidioc_enum_fmt(f, true, false);
+	return vidioc_enum_fmt(file, f, true, false);
 }
 
-static int vidioc_enum_fmt_vid_out(struct file *file, void *prov,
+static int vidioc_enum_fmt_vid_out(struct file *file, void *priv,
 							struct v4l2_fmtdesc *f)
 {
-	return vidioc_enum_fmt(f, false, true);
+	return vidioc_enum_fmt(file, f, false, true);
 }
 
-static int vidioc_enum_fmt_vid_out_mplane(struct file *file, void *prov,
+static int vidioc_enum_fmt_vid_out_mplane(struct file *file, void *priv,
 							struct v4l2_fmtdesc *f)
 {
-	return vidioc_enum_fmt(f, true, true);
+	return vidioc_enum_fmt(file, f, true, true);
 }
 
 /* Get format */
@@ -384,11 +402,9 @@ static int vidioc_try_fmt(struct file *file, void *priv, struct v4l2_format *f)
 			mfc_err("Unknown codec\n");
 			return -EINVAL;
 		}
-		if (!IS_MFCV6_PLUS(dev)) {
-			if (fmt->fourcc == V4L2_PIX_FMT_VP8) {
-				mfc_err("Not supported format.\n");
-				return -EINVAL;
-			}
+		if ((dev->variant->version_bit & fmt->versions) == 0) {
+			mfc_err("Unsupported format by this MFC version.\n");
+			return -EINVAL;
 		}
 	} else if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
 		fmt = find_format(f, MFC_FMT_RAW);
@@ -396,13 +412,8 @@ static int vidioc_try_fmt(struct file *file, void *priv, struct v4l2_format *f)
 			mfc_err("Unsupported format for destination.\n");
 			return -EINVAL;
 		}
-		if (IS_MFCV6_PLUS(dev) &&
-				(fmt->fourcc == V4L2_PIX_FMT_NV12MT)) {
-			mfc_err("Not supported format.\n");
-			return -EINVAL;
-		} else if (!IS_MFCV6_PLUS(dev) &&
-				(fmt->fourcc != V4L2_PIX_FMT_NV12MT)) {
-			mfc_err("Not supported format.\n");
+		if ((dev->variant->version_bit & fmt->versions) == 0) {
+			mfc_err("Unsupported format by this MFC version.\n");
 			return -EINVAL;
 		}
 	}
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
index d09c2e1..0eb8600 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
@@ -42,6 +42,7 @@ static struct s5p_mfc_fmt formats[] = {
 		.codec_mode	= S5P_MFC_CODEC_NONE,
 		.type		= MFC_FMT_RAW,
 		.num_planes	= 2,
+		.versions	= MFC_V6_BIT | MFC_V7_BIT,
 	},
 	{
 		.name		= "4:2:0 2 Planes 64x32 Tiles",
@@ -49,6 +50,7 @@ static struct s5p_mfc_fmt formats[] = {
 		.codec_mode	= S5P_MFC_CODEC_NONE,
 		.type		= MFC_FMT_RAW,
 		.num_planes	= 2,
+		.versions	= MFC_V5_BIT,
 	},
 	{
 		.name		= "4:2:0 2 Planes Y/CbCr",
@@ -56,6 +58,7 @@ static struct s5p_mfc_fmt formats[] = {
 		.codec_mode	= S5P_MFC_CODEC_NONE,
 		.type		= MFC_FMT_RAW,
 		.num_planes	= 2,
+		.versions	= MFC_V5_BIT | MFC_V6_BIT | MFC_V7_BIT,
 	},
 	{
 		.name		= "4:2:0 2 Planes Y/CrCb",
@@ -63,6 +66,7 @@ static struct s5p_mfc_fmt formats[] = {
 		.codec_mode	= S5P_MFC_CODEC_NONE,
 		.type		= MFC_FMT_RAW,
 		.num_planes	= 2,
+		.versions	= MFC_V5_BIT | MFC_V6_BIT | MFC_V7_BIT,
 	},
 	{
 		.name		= "H264 Encoded Stream",
@@ -70,6 +74,7 @@ static struct s5p_mfc_fmt formats[] = {
 		.codec_mode	= S5P_MFC_CODEC_H264_ENC,
 		.type		= MFC_FMT_ENC,
 		.num_planes	= 1,
+		.versions	= MFC_V5_BIT | MFC_V6_BIT | MFC_V7_BIT,
 	},
 	{
 		.name		= "MPEG4 Encoded Stream",
@@ -77,6 +82,7 @@ static struct s5p_mfc_fmt formats[] = {
 		.codec_mode	= S5P_MFC_CODEC_MPEG4_ENC,
 		.type		= MFC_FMT_ENC,
 		.num_planes	= 1,
+		.versions	= MFC_V5_BIT | MFC_V6_BIT | MFC_V7_BIT,
 	},
 	{
 		.name		= "H263 Encoded Stream",
@@ -84,6 +90,7 @@ static struct s5p_mfc_fmt formats[] = {
 		.codec_mode	= S5P_MFC_CODEC_H263_ENC,
 		.type		= MFC_FMT_ENC,
 		.num_planes	= 1,
+		.versions	= MFC_V5_BIT | MFC_V6_BIT | MFC_V7_BIT,
 	},
 	{
 		.name		= "VP8 Encoded Stream",
@@ -91,6 +98,7 @@ static struct s5p_mfc_fmt formats[] = {
 		.codec_mode	= S5P_MFC_CODEC_VP8_ENC,
 		.type		= MFC_FMT_ENC,
 		.num_planes	= 1,
+		.versions	= MFC_V7_BIT,
 	},
 };
 
@@ -940,8 +948,10 @@ static int vidioc_querycap(struct file *file, void *priv,
 	return 0;
 }
 
-static int vidioc_enum_fmt(struct v4l2_fmtdesc *f, bool mplane, bool out)
+static int vidioc_enum_fmt(struct file *file, struct v4l2_fmtdesc *f,
+							bool mplane, bool out)
 {
+	struct s5p_mfc_dev *dev = video_drvdata(file);
 	struct s5p_mfc_fmt *fmt;
 	int i, j = 0;
 
@@ -954,6 +964,9 @@ static int vidioc_enum_fmt(struct v4l2_fmtdesc *f, bool mplane, bool out)
 			continue;
 		else if (!out && formats[i].type != MFC_FMT_ENC)
 			continue;
+		else if ((dev->variant->version_bit & formats[i].versions) == 0)
+			continue;
+
 		if (j == f->index) {
 			fmt = &formats[i];
 			strlcpy(f->description, fmt->name,
@@ -969,25 +982,25 @@ static int vidioc_enum_fmt(struct v4l2_fmtdesc *f, bool mplane, bool out)
 static int vidioc_enum_fmt_vid_cap(struct file *file, void *pirv,
 				   struct v4l2_fmtdesc *f)
 {
-	return vidioc_enum_fmt(f, false, false);
+	return vidioc_enum_fmt(file, f, false, false);
 }
 
 static int vidioc_enum_fmt_vid_cap_mplane(struct file *file, void *pirv,
 					  struct v4l2_fmtdesc *f)
 {
-	return vidioc_enum_fmt(f, true, false);
+	return vidioc_enum_fmt(file, f, true, false);
 }
 
 static int vidioc_enum_fmt_vid_out(struct file *file, void *prov,
 				   struct v4l2_fmtdesc *f)
 {
-	return vidioc_enum_fmt(f, false, true);
+	return vidioc_enum_fmt(file, f, false, true);
 }
 
 static int vidioc_enum_fmt_vid_out_mplane(struct file *file, void *prov,
 					  struct v4l2_fmtdesc *f)
 {
-	return vidioc_enum_fmt(f, true, true);
+	return vidioc_enum_fmt(file, f, true, true);
 }
 
 static int vidioc_g_fmt(struct file *file, void *priv, struct v4l2_format *f)
@@ -1038,16 +1051,14 @@ static int vidioc_try_fmt(struct file *file, void *priv, struct v4l2_format *f)
 			mfc_err("failed to try output format\n");
 			return -EINVAL;
 		}
-
-		if (!IS_MFCV7_PLUS(dev) && (fmt->fourcc == V4L2_PIX_FMT_VP8)) {
-			mfc_err("VP8 is supported only in MFC v7\n");
-			return -EINVAL;
-		}
-
 		if (pix_fmt_mp->plane_fmt[0].sizeimage == 0) {
 			mfc_err("must be set encoding output size\n");
 			return -EINVAL;
 		}
+		if ((dev->variant->version_bit & fmt->versions) == 0) {
+			mfc_err("Unsupported format by this MFC version.\n");
+			return -EINVAL;
+		}
 
 		pix_fmt_mp->plane_fmt[0].bytesperline =
 			pix_fmt_mp->plane_fmt[0].sizeimage;
@@ -1058,22 +1069,15 @@ static int vidioc_try_fmt(struct file *file, void *priv, struct v4l2_format *f)
 			return -EINVAL;
 		}
 
-		if (!IS_MFCV6_PLUS(dev)) {
-			if (fmt->fourcc == V4L2_PIX_FMT_NV12MT_16X16) {
-				mfc_err("Not supported format.\n");
-				return -EINVAL;
-			}
-		} else if (IS_MFCV6_PLUS(dev)) {
-			if (fmt->fourcc == V4L2_PIX_FMT_NV12MT) {
-				mfc_err("Not supported format.\n");
-				return -EINVAL;
-			}
-		}
-
 		if (fmt->num_planes != pix_fmt_mp->num_planes) {
 			mfc_err("failed to try output format\n");
 			return -EINVAL;
 		}
+		if ((dev->variant->version_bit & fmt->versions) == 0) {
+			mfc_err("Unsupported format by this MFC version.\n");
+			return -EINVAL;
+		}
+
 		v4l_bound_align_image(&pix_fmt_mp->width, 8, 1920, 1,
 			&pix_fmt_mp->height, 4, 1080, 1, 0);
 	} else {
-- 
1.7.9.5

