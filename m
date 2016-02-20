Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:41186 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1949123AbcBTI5n (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Feb 2016 03:57:43 -0500
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] vivid: support new multiplanar YUV formats
Message-ID: <56C82A82.3030409@xs4all.nl>
Date: Sat, 20 Feb 2016 09:57:38 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add support for the new YUV422M, YVU422M, YUV444M and YVU444M formats.
This allows applications to check their support for these formats.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

diff --git a/drivers/media/platform/vivid/vivid-tpg.c b/drivers/media/platform/vivid/vivid-tpg.c
index 1425614..da862bb 100644
--- a/drivers/media/platform/vivid/vivid-tpg.c
+++ b/drivers/media/platform/vivid/vivid-tpg.c
@@ -251,6 +251,10 @@ bool tpg_s_fourcc(struct tpg_data *tpg, u32 fourcc)
 		tpg->planes = 3;
 		tpg->is_yuv = true;
 		break;
+	case V4L2_PIX_FMT_YUV422M:
+	case V4L2_PIX_FMT_YVU422M:
+		tpg->buffers = 3;
+		/* fall through */
 	case V4L2_PIX_FMT_YUV422P:
 		tpg->vdownsampling[1] = 1;
 		tpg->vdownsampling[2] = 1;
@@ -283,6 +287,16 @@ bool tpg_s_fourcc(struct tpg_data *tpg, u32 fourcc)
 		tpg->planes = 2;
 		tpg->is_yuv = true;
 		break;
+	case V4L2_PIX_FMT_YUV444M:
+	case V4L2_PIX_FMT_YVU444M:
+		tpg->buffers = 3;
+		tpg->planes = 3;
+		tpg->vdownsampling[1] = 1;
+		tpg->vdownsampling[2] = 1;
+		tpg->hdownsampling[1] = 1;
+		tpg->hdownsampling[2] = 1;
+		tpg->is_yuv = true;
+		break;
 	case V4L2_PIX_FMT_NV24:
 	case V4L2_PIX_FMT_NV42:
 		tpg->vdownsampling[1] = 1;
@@ -368,6 +382,10 @@ bool tpg_s_fourcc(struct tpg_data *tpg, u32 fourcc)
 		tpg->twopixelsize[0] = 4;
 		tpg->twopixelsize[1] = 4;
 		break;
+	case V4L2_PIX_FMT_YUV444M:
+	case V4L2_PIX_FMT_YVU444M:
+	case V4L2_PIX_FMT_YUV422M:
+	case V4L2_PIX_FMT_YVU422M:
 	case V4L2_PIX_FMT_YUV422P:
 	case V4L2_PIX_FMT_YUV420:
 	case V4L2_PIX_FMT_YVU420:
@@ -933,6 +951,7 @@ static void gen_twopix(struct tpg_data *tpg,
 		buf[0][offset] = r_y;
 		buf[0][offset+1] = r_y == 0xff ? r_y : 0;
 		break;
+	case V4L2_PIX_FMT_YUV422M:
 	case V4L2_PIX_FMT_YUV422P:
 	case V4L2_PIX_FMT_YUV420:
 	case V4L2_PIX_FMT_YUV420M:
@@ -947,6 +966,7 @@ static void gen_twopix(struct tpg_data *tpg,
 		buf[1][0] = g_u;
 		buf[2][0] = b_v;
 		break;
+	case V4L2_PIX_FMT_YVU422M:
 	case V4L2_PIX_FMT_YVU420:
 	case V4L2_PIX_FMT_YVU420M:
 		buf[0][offset] = r_y;
@@ -988,6 +1008,18 @@ static void gen_twopix(struct tpg_data *tpg,
 		buf[1][1] = g_u;
 		break;

+	case V4L2_PIX_FMT_YUV444M:
+		buf[0][offset] = r_y;
+		buf[1][offset] = g_u;
+		buf[2][offset] = b_v;
+		break;
+
+	case V4L2_PIX_FMT_YVU444M:
+		buf[0][offset] = r_y;
+		buf[1][offset] = b_v;
+		buf[2][offset] = g_u;
+		break;
+
 	case V4L2_PIX_FMT_NV24:
 		buf[0][offset] = r_y;
 		buf[1][2 * offset] = g_u;
diff --git a/drivers/media/platform/vivid/vivid-vid-common.c b/drivers/media/platform/vivid/vivid-vid-common.c
index 1678b73..b0d4e3a 100644
--- a/drivers/media/platform/vivid/vivid-vid-common.c
+++ b/drivers/media/platform/vivid/vivid-vid-common.c
@@ -445,6 +445,9 @@ struct vivid_fmt vivid_formats[] = {
 		.planes   = 1,
 		.buffers = 1,
 	},
+
+	/* Multiplanar formats */
+
 	{
 		.fourcc   = V4L2_PIX_FMT_NV16M,
 		.vdownsampling = { 1, 1 },
@@ -495,10 +498,42 @@ struct vivid_fmt vivid_formats[] = {
 		.planes   = 2,
 		.buffers = 2,
 	},
+	{
+		.fourcc   = V4L2_PIX_FMT_YUV422M,
+		.vdownsampling = { 1, 1, 1 },
+		.bit_depth = { 8, 4, 4 },
+		.is_yuv   = true,
+		.planes   = 3,
+		.buffers = 3,
+	},
+	{
+		.fourcc   = V4L2_PIX_FMT_YVU422M,
+		.vdownsampling = { 1, 1, 1 },
+		.bit_depth = { 8, 4, 4 },
+		.is_yuv   = true,
+		.planes   = 3,
+		.buffers = 3,
+	},
+	{
+		.fourcc   = V4L2_PIX_FMT_YUV444M,
+		.vdownsampling = { 1, 1, 1 },
+		.bit_depth = { 8, 8, 8 },
+		.is_yuv   = true,
+		.planes   = 3,
+		.buffers = 3,
+	},
+	{
+		.fourcc   = V4L2_PIX_FMT_YVU444M,
+		.vdownsampling = { 1, 1, 1 },
+		.bit_depth = { 8, 8, 8 },
+		.is_yuv   = true,
+		.planes   = 3,
+		.buffers = 3,
+	},
 };

-/* There are 6 multiplanar formats in the list */
-#define VIVID_MPLANAR_FORMATS 6
+/* There are this many multiplanar formats in the list */
+#define VIVID_MPLANAR_FORMATS 10

 const struct vivid_fmt *vivid_get_format(struct vivid_dev *dev, u32 pixelformat)
 {
