Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:54028 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752172AbcIGWYu (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 7 Sep 2016 18:24:50 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran@ksquared.org.uk>
Subject: [PATCH v3 06/10] v4l: fdp1: Incorporate miscellaneous review comments
Date: Thu,  8 Sep 2016 01:25:06 +0300
Message-Id: <1473287110-780-7-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1473287110-780-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1473287110-780-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

- Constify data tables
- Add missing break in switch statement
- Use struct video_device::device_caps
- Don't set read-only flag manually for V4L2_CID_MIN_BUFFERS_FOR_CAPTURE
- Use V4L2_YCBCR_ENC_709 instead of V4L2_COLORSPACE_REC709 for ycbcr_enc
- Fix handling of V4L2_FIELD_INTERLACED
- Use the standard V4L2_CID_DEINTERLACER_MODE control
- Add missing white space

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/rcar_fdp1.c | 111 +++++++++++++++++--------------------
 1 file changed, 52 insertions(+), 59 deletions(-)

diff --git a/drivers/media/platform/rcar_fdp1.c b/drivers/media/platform/rcar_fdp1.c
index a2587745ca68..bbeacf1527b5 100644
--- a/drivers/media/platform/rcar_fdp1.c
+++ b/drivers/media/platform/rcar_fdp1.c
@@ -297,108 +297,108 @@ struct fdp1_fmt {
 static const struct fdp1_fmt fdp1_formats[] = {
 	/* RGB formats are only supported by the Write Pixel Formatter */
 
-	{ V4L2_PIX_FMT_RGB332, { 8, 0, 0}, 1, 1, 1, 0x00, false, false,
+	{ V4L2_PIX_FMT_RGB332, { 8, 0, 0 }, 1, 1, 1, 0x00, false, false,
 	  FD1_RWPF_SWAP_LLWD | FD1_RWPF_SWAP_LWRD |
 	  FD1_RWPF_SWAP_WORD | FD1_RWPF_SWAP_BYTE,
 	  FDP1_CAPTURE },
-	{ V4L2_PIX_FMT_XRGB444, { 16, 0, 0}, 1, 1, 1, 0x01, false, false,
+	{ V4L2_PIX_FMT_XRGB444, { 16, 0, 0 }, 1, 1, 1, 0x01, false, false,
 	  FD1_RWPF_SWAP_LLWD | FD1_RWPF_SWAP_LWRD |
 	  FD1_RWPF_SWAP_WORD,
 	  FDP1_CAPTURE },
-	{ V4L2_PIX_FMT_XRGB555, { 16, 0, 0}, 1, 1, 1, 0x04, false, false,
+	{ V4L2_PIX_FMT_XRGB555, { 16, 0, 0 }, 1, 1, 1, 0x04, false, false,
 	  FD1_RWPF_SWAP_LLWD | FD1_RWPF_SWAP_LWRD |
 	  FD1_RWPF_SWAP_WORD,
 	  FDP1_CAPTURE },
-	{ V4L2_PIX_FMT_RGB565, { 16, 0, 0}, 1, 1, 1, 0x06, false, false,
+	{ V4L2_PIX_FMT_RGB565, { 16, 0, 0 }, 1, 1, 1, 0x06, false, false,
 	  FD1_RWPF_SWAP_LLWD | FD1_RWPF_SWAP_LWRD |
 	  FD1_RWPF_SWAP_WORD,
 	  FDP1_CAPTURE },
-	{ V4L2_PIX_FMT_ABGR32, { 32, 0, 0}, 1, 1, 1, 0x13, false, false,
+	{ V4L2_PIX_FMT_ABGR32, { 32, 0, 0 }, 1, 1, 1, 0x13, false, false,
 	  FD1_RWPF_SWAP_LLWD | FD1_RWPF_SWAP_LWRD,
 	  FDP1_CAPTURE },
-	{ V4L2_PIX_FMT_XBGR32, { 32, 0, 0}, 1, 1, 1, 0x13, false, false,
+	{ V4L2_PIX_FMT_XBGR32, { 32, 0, 0 }, 1, 1, 1, 0x13, false, false,
 	  FD1_RWPF_SWAP_LLWD | FD1_RWPF_SWAP_LWRD,
 	  FDP1_CAPTURE },
-	{ V4L2_PIX_FMT_ARGB32, { 32, 0, 0}, 1, 1, 1, 0x13, false, false,
+	{ V4L2_PIX_FMT_ARGB32, { 32, 0, 0 }, 1, 1, 1, 0x13, false, false,
 	  FD1_RWPF_SWAP_LLWD | FD1_RWPF_SWAP_LWRD |
 	  FD1_RWPF_SWAP_WORD | FD1_RWPF_SWAP_BYTE,
 	  FDP1_CAPTURE },
-	{ V4L2_PIX_FMT_XRGB32, { 32, 0, 0}, 1, 1, 1, 0x13, false, false,
+	{ V4L2_PIX_FMT_XRGB32, { 32, 0, 0 }, 1, 1, 1, 0x13, false, false,
 	  FD1_RWPF_SWAP_LLWD | FD1_RWPF_SWAP_LWRD |
 	  FD1_RWPF_SWAP_WORD | FD1_RWPF_SWAP_BYTE,
 	  FDP1_CAPTURE },
-	{ V4L2_PIX_FMT_RGB24, { 24, 0, 0}, 1, 1, 1, 0x15, false, false,
+	{ V4L2_PIX_FMT_RGB24, { 24, 0, 0 }, 1, 1, 1, 0x15, false, false,
 	  FD1_RWPF_SWAP_LLWD | FD1_RWPF_SWAP_LWRD |
 	  FD1_RWPF_SWAP_WORD | FD1_RWPF_SWAP_BYTE,
 	  FDP1_CAPTURE },
-	{ V4L2_PIX_FMT_BGR24, { 24, 0, 0}, 1, 1, 1, 0x18, false, false,
+	{ V4L2_PIX_FMT_BGR24, { 24, 0, 0 }, 1, 1, 1, 0x18, false, false,
 	  FD1_RWPF_SWAP_LLWD | FD1_RWPF_SWAP_LWRD |
 	  FD1_RWPF_SWAP_WORD | FD1_RWPF_SWAP_BYTE,
 	  FDP1_CAPTURE },
-	{ V4L2_PIX_FMT_ARGB444, { 16, 0, 0}, 1, 1, 1, 0x19, false, false,
+	{ V4L2_PIX_FMT_ARGB444, { 16, 0, 0 }, 1, 1, 1, 0x19, false, false,
 	  FD1_RWPF_SWAP_LLWD | FD1_RWPF_SWAP_LWRD |
 	  FD1_RWPF_SWAP_WORD,
 	  FDP1_CAPTURE },
-	{ V4L2_PIX_FMT_ARGB555, { 16, 0, 0}, 1, 1, 1, 0x1b, false, false,
+	{ V4L2_PIX_FMT_ARGB555, { 16, 0, 0 }, 1, 1, 1, 0x1b, false, false,
 	  FD1_RWPF_SWAP_LLWD | FD1_RWPF_SWAP_LWRD |
 	  FD1_RWPF_SWAP_WORD,
 	  FDP1_CAPTURE },
 
 	/* YUV Formats are supported by Read and Write Pixel Formatters */
 
-	{ V4L2_PIX_FMT_NV16M, { 8, 16, 0}, 2, 2, 1, 0x41, false, false,
+	{ V4L2_PIX_FMT_NV16M, { 8, 16, 0 }, 2, 2, 1, 0x41, false, false,
 	  FD1_RWPF_SWAP_LLWD | FD1_RWPF_SWAP_LWRD |
 	  FD1_RWPF_SWAP_WORD | FD1_RWPF_SWAP_BYTE,
 	  FDP1_CAPTURE | FDP1_OUTPUT },
-	{ V4L2_PIX_FMT_NV61M, { 8, 16, 0}, 2, 2, 1, 0x41, false, true,
+	{ V4L2_PIX_FMT_NV61M, { 8, 16, 0 }, 2, 2, 1, 0x41, false, true,
 	  FD1_RWPF_SWAP_LLWD | FD1_RWPF_SWAP_LWRD |
 	  FD1_RWPF_SWAP_WORD | FD1_RWPF_SWAP_BYTE,
 	  FDP1_CAPTURE | FDP1_OUTPUT },
-	{ V4L2_PIX_FMT_NV12M, { 8, 16, 0}, 2, 2, 2, 0x42, false, false,
+	{ V4L2_PIX_FMT_NV12M, { 8, 16, 0 }, 2, 2, 2, 0x42, false, false,
 	  FD1_RWPF_SWAP_LLWD | FD1_RWPF_SWAP_LWRD |
 	  FD1_RWPF_SWAP_WORD | FD1_RWPF_SWAP_BYTE,
 	  FDP1_CAPTURE | FDP1_OUTPUT },
-	{ V4L2_PIX_FMT_NV21M, { 8, 16, 0}, 2, 2, 2, 0x42, false, true,
+	{ V4L2_PIX_FMT_NV21M, { 8, 16, 0 }, 2, 2, 2, 0x42, false, true,
 	  FD1_RWPF_SWAP_LLWD | FD1_RWPF_SWAP_LWRD |
 	  FD1_RWPF_SWAP_WORD | FD1_RWPF_SWAP_BYTE,
 	  FDP1_CAPTURE | FDP1_OUTPUT },
-	{ V4L2_PIX_FMT_UYVY, { 16, 0, 0}, 1, 2, 1, 0x47, false, false,
+	{ V4L2_PIX_FMT_UYVY, { 16, 0, 0 }, 1, 2, 1, 0x47, false, false,
 	  FD1_RWPF_SWAP_LLWD | FD1_RWPF_SWAP_LWRD |
 	  FD1_RWPF_SWAP_WORD | FD1_RWPF_SWAP_BYTE,
 	  FDP1_CAPTURE | FDP1_OUTPUT },
-	{ V4L2_PIX_FMT_VYUY, { 16, 0, 0}, 1, 2, 1, 0x47, false, true,
+	{ V4L2_PIX_FMT_VYUY, { 16, 0, 0 }, 1, 2, 1, 0x47, false, true,
 	  FD1_RWPF_SWAP_LLWD | FD1_RWPF_SWAP_LWRD |
 	  FD1_RWPF_SWAP_WORD | FD1_RWPF_SWAP_BYTE,
 	  FDP1_CAPTURE | FDP1_OUTPUT },
-	{ V4L2_PIX_FMT_YUYV, { 16, 0, 0}, 1, 2, 1, 0x47, true, false,
+	{ V4L2_PIX_FMT_YUYV, { 16, 0, 0 }, 1, 2, 1, 0x47, true, false,
 	  FD1_RWPF_SWAP_LLWD | FD1_RWPF_SWAP_LWRD |
 	  FD1_RWPF_SWAP_WORD | FD1_RWPF_SWAP_BYTE,
 	  FDP1_CAPTURE | FDP1_OUTPUT },
-	{ V4L2_PIX_FMT_YVYU, { 16, 0, 0}, 1, 2, 1, 0x47, true, true,
+	{ V4L2_PIX_FMT_YVYU, { 16, 0, 0 }, 1, 2, 1, 0x47, true, true,
 	  FD1_RWPF_SWAP_LLWD | FD1_RWPF_SWAP_LWRD |
 	  FD1_RWPF_SWAP_WORD | FD1_RWPF_SWAP_BYTE,
 	  FDP1_CAPTURE | FDP1_OUTPUT },
-	{ V4L2_PIX_FMT_YUV444M, { 8, 8, 8}, 3, 1, 1, 0x4a, false, false,
+	{ V4L2_PIX_FMT_YUV444M, { 8, 8, 8 }, 3, 1, 1, 0x4a, false, false,
 	  FD1_RWPF_SWAP_LLWD | FD1_RWPF_SWAP_LWRD |
 	  FD1_RWPF_SWAP_WORD | FD1_RWPF_SWAP_BYTE,
 	  FDP1_CAPTURE | FDP1_OUTPUT },
-	{ V4L2_PIX_FMT_YVU444M, { 8, 8, 8}, 3, 1, 1, 0x4a, false, true,
+	{ V4L2_PIX_FMT_YVU444M, { 8, 8, 8 }, 3, 1, 1, 0x4a, false, true,
 	  FD1_RWPF_SWAP_LLWD | FD1_RWPF_SWAP_LWRD |
 	  FD1_RWPF_SWAP_WORD | FD1_RWPF_SWAP_BYTE,
 	  FDP1_CAPTURE | FDP1_OUTPUT },
-	{ V4L2_PIX_FMT_YUV422M, { 8, 8, 8}, 3, 2, 1, 0x4b, false, false,
+	{ V4L2_PIX_FMT_YUV422M, { 8, 8, 8 }, 3, 2, 1, 0x4b, false, false,
 	  FD1_RWPF_SWAP_LLWD | FD1_RWPF_SWAP_LWRD |
 	  FD1_RWPF_SWAP_WORD | FD1_RWPF_SWAP_BYTE,
 	  FDP1_CAPTURE | FDP1_OUTPUT },
-	{ V4L2_PIX_FMT_YVU422M, { 8, 8, 8}, 3, 2, 1, 0x4b, false, true,
+	{ V4L2_PIX_FMT_YVU422M, { 8, 8, 8 }, 3, 2, 1, 0x4b, false, true,
 	  FD1_RWPF_SWAP_LLWD | FD1_RWPF_SWAP_LWRD |
 	  FD1_RWPF_SWAP_WORD | FD1_RWPF_SWAP_BYTE,
 	  FDP1_CAPTURE | FDP1_OUTPUT },
-	{ V4L2_PIX_FMT_YUV420M, { 8, 8, 8}, 3, 2, 2, 0x4c, false, false,
+	{ V4L2_PIX_FMT_YUV420M, { 8, 8, 8 }, 3, 2, 2, 0x4c, false, false,
 	  FD1_RWPF_SWAP_LLWD | FD1_RWPF_SWAP_LWRD |
 	  FD1_RWPF_SWAP_WORD | FD1_RWPF_SWAP_BYTE,
 	  FDP1_CAPTURE | FDP1_OUTPUT },
-	{ V4L2_PIX_FMT_YVU420M, { 8, 8, 8}, 3, 2, 2, 0x4c, false, true,
+	{ V4L2_PIX_FMT_YVU420M, { 8, 8, 8 }, 3, 2, 2, 0x4c, false, true,
 	  FD1_RWPF_SWAP_LLWD | FD1_RWPF_SWAP_LWRD |
 	  FD1_RWPF_SWAP_WORD | FD1_RWPF_SWAP_BYTE,
 	  FDP1_CAPTURE | FDP1_OUTPUT },
@@ -415,27 +415,27 @@ static int fdp1_fmt_is_rgb(const struct fdp1_fmt *fmt)
  * Each table must be less than 256 entries, and all tables
  * are padded out to 256 entries by duplicating the last value.
  */
-static u8 fdp1_diff_adj[] = {
+static const u8 fdp1_diff_adj[] = {
 	0x00, 0x24, 0x43, 0x5e, 0x76, 0x8c, 0x9e, 0xaf,
 	0xbd, 0xc9, 0xd4, 0xdd, 0xe4, 0xea, 0xef, 0xf3,
 	0xf6, 0xf9, 0xfb, 0xfc, 0xfd, 0xfe, 0xfe, 0xff,
 };
 
-static u8 fdp1_sad_adj[] = {
+static const u8 fdp1_sad_adj[] = {
 	0x00, 0x24, 0x43, 0x5e, 0x76, 0x8c, 0x9e, 0xaf,
 	0xbd, 0xc9, 0xd4, 0xdd, 0xe4, 0xea, 0xef, 0xf3,
 	0xf6, 0xf9, 0xfb, 0xfc, 0xfd, 0xfe, 0xfe, 0xff,
 };
 
-static u8 fdp1_bld_gain[] = {
+static const u8 fdp1_bld_gain[] = {
 	0x80,
 };
 
-static u8 fdp1_dif_gain[] = {
+static const u8 fdp1_dif_gain[] = {
 	0x80,
 };
 
-static u8 fdp1_mdet[] = {
+static const u8 fdp1_mdet[] = {
 	0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07,
 	0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f,
 	0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17,
@@ -480,9 +480,6 @@ struct fdp1_q_data {
 	unsigned int		stride_c;
 };
 
-/* Custom controls */
-#define V4L2_CID_DEINT_MODE		(V4L2_CID_USER_BASE + 0x1000)
-
 static const struct fdp1_fmt *fdp1_find_format(u32 pixelformat)
 {
 	const struct fdp1_fmt *fmt;
@@ -882,10 +879,8 @@ static void fdp1_set_ipc_sensor(struct fdp1_ctx *ctx)
  *
  * The last byte of the table is written to all remaining entries.
  */
-static void fdp1_write_lut(struct fdp1_dev *fdp1,
-			   u8 *lut,
-			   unsigned int len,
-			   unsigned int base)
+static void fdp1_write_lut(struct fdp1_dev *fdp1, const u8 *lut,
+			   unsigned int len, unsigned int base)
 {
 	unsigned int i;
 	u8 pad;
@@ -1007,7 +1002,7 @@ static void fdp1_configure_wpf(struct fdp1_ctx *ctx,
 		format |= FD1_WPF_FORMAT_CSC;
 
 		/* Set WRTM */
-		if (src_q_data->format.ycbcr_enc == V4L2_COLORSPACE_REC709)
+		if (src_q_data->format.ycbcr_enc == V4L2_YCBCR_ENC_709)
 			format |= FD1_WPF_FORMAT_WRTM_709_16;
 		else if (src_q_data->format.quantization ==
 				V4L2_QUANTIZATION_FULL_RANGE)
@@ -1236,16 +1231,25 @@ static void prepare_buffer(struct fdp1_ctx *ctx,
 
 	switch (vb->field) {
 	case V4L2_FIELD_INTERLACED:
+		/*
+		 * Interlaced means bottom-top for 60Hz TV standards (NTSC) and
+		 * top-bottom for 50Hz. As TV standards are not applicable to
+		 * the mem-to-mem API, use the height as a heuristic.
+		 */
+		buf->field = (q_data->format.height < 576) == next_field
+			   ? V4L2_FIELD_TOP : V4L2_FIELD_BOTTOM;
+		break;
 	case V4L2_FIELD_INTERLACED_TB:
 	case V4L2_FIELD_SEQ_TB:
-		buf->field = (next_field) ? V4L2_FIELD_BOTTOM : V4L2_FIELD_TOP;
+		buf->field = next_field ? V4L2_FIELD_BOTTOM : V4L2_FIELD_TOP;
 		break;
 	case V4L2_FIELD_INTERLACED_BT:
 	case V4L2_FIELD_SEQ_BT:
-		buf->field = (next_field) ? V4L2_FIELD_TOP : V4L2_FIELD_BOTTOM;
+		buf->field = next_field ? V4L2_FIELD_TOP : V4L2_FIELD_BOTTOM;
 		break;
 	default:
 		buf->field = vb->field;
+		break;
 	}
 
 	/* Buffer is completed */
@@ -1462,8 +1466,6 @@ static int fdp1_vidioc_querycap(struct file *file, void *priv,
 	strlcpy(cap->card, DRIVER_NAME, sizeof(cap->card));
 	snprintf(cap->bus_info, sizeof(cap->bus_info),
 			"platform:%s", DRIVER_NAME);
-	cap->device_caps = V4L2_CAP_VIDEO_M2M_MPLANE | V4L2_CAP_STREAMING;
-	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
 	return 0;
 }
 
@@ -1719,7 +1721,7 @@ static int fdp1_s_ctrl(struct v4l2_ctrl *ctrl)
 		ctx->alpha = ctrl->val;
 		break;
 
-	case V4L2_CID_DEINT_MODE:
+	case V4L2_CID_DEINTERLACING_MODE:
 		ctx->deint_mode = ctrl->val;
 		break;
 	}
@@ -1742,18 +1744,6 @@ static const char * const fdp1_ctrl_deint_menu[] = {
 	NULL
 };
 
-static const struct v4l2_ctrl_config fdp1_ctrl_deint_mode = {
-	.ops = &fdp1_ctrl_ops,
-	.id = V4L2_CID_DEINT_MODE,
-	.name = "Deinterlace Mode",
-	.type = V4L2_CTRL_TYPE_MENU,
-	.qmenu = fdp1_ctrl_deint_menu,
-	.def = FDP1_FIXED3D,
-	.min = FDP1_ADAPT2D3D,
-	.max = FDP1_NEXTFIELD,
-	.menu_skip_mask = BIT(0),
-};
-
 static const struct v4l2_ioctl_ops fdp1_ioctl_ops = {
 	.vidioc_querycap	= fdp1_vidioc_querycap,
 
@@ -2044,13 +2034,15 @@ static int fdp1_open(struct file *file)
 	/* Initialise controls */
 
 	v4l2_ctrl_handler_init(&ctx->hdl, 3);
-	v4l2_ctrl_new_custom(&ctx->hdl, &fdp1_ctrl_deint_mode, NULL);
+	v4l2_ctrl_new_std_menu_items(&ctx->hdl, &fdp1_ctrl_ops,
+				     V4L2_CID_DEINTERLACING_MODE,
+				     FDP1_NEXTFIELD, BIT(0), FDP1_FIXED3D,
+				     fdp1_ctrl_deint_menu);
 
 	ctrl = v4l2_ctrl_new_std(&ctx->hdl, &fdp1_ctrl_ops,
 			V4L2_CID_MIN_BUFFERS_FOR_CAPTURE, 1, 2, 1, 1);
 	if (ctrl)
-		ctrl->flags |= V4L2_CTRL_FLAG_VOLATILE |
-			       V4L2_CTRL_FLAG_READ_ONLY;
+		ctrl->flags |= V4L2_CTRL_FLAG_VOLATILE;
 
 	v4l2_ctrl_new_std(&ctx->hdl, &fdp1_ctrl_ops,
 			  V4L2_CID_ALPHA_COMPONENT, 0, 255, 1, 255);
@@ -2126,6 +2118,7 @@ static const struct video_device fdp1_videodev = {
 	.name		= DRIVER_NAME,
 	.vfl_dir	= VFL_DIR_M2M,
 	.fops		= &fdp1_fops,
+	.device_caps	= V4L2_CAP_VIDEO_M2M_MPLANE | V4L2_CAP_STREAMING,
 	.ioctl_ops	= &fdp1_ioctl_ops,
 	.minor		= -1,
 	.release	= video_device_release_empty,
-- 
Regards,

Laurent Pinchart

