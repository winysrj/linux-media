Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f42.google.com ([74.125.83.42]:33199 "EHLO
        mail-pg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751180AbdFBVe5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 2 Jun 2017 17:34:57 -0400
Received: by mail-pg0-f42.google.com with SMTP id u13so2873165pgb.0
        for <linux-media@vger.kernel.org>; Fri, 02 Jun 2017 14:34:57 -0700 (PDT)
From: Kevin Hilman <khilman@baylibre.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org
Cc: Sekhar Nori <nsekhar@ti.com>,
        Patrick Titiano <ptitiano@baylibre.com>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 3/4] [media] davinci: vpif_capture: cleanup raw camera support
Date: Fri,  2 Jun 2017 14:34:30 -0700
Message-Id: <20170602213431.10777-4-khilman@baylibre.com>
In-Reply-To: <20170602213431.10777-1-khilman@baylibre.com>
References: <20170602213431.10777-1-khilman@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The current driver has a handful of hard-coded assumptions based on its
primary use for capture of video signals.  Cleanup those assumptions,
and also query the subdev for format information and use that if
available.

Tested with 10-bit raw bayer input (SGRBG10) using the aptina,mt9v032
sensor, and also tested that composite video input still works from
ti,tvp514x decoder.  Both tests done on the da850-evm board with the
add-on UI board.

NOTE: Will need further testing for other sensors with different bus
formats.

Signed-off-by: Kevin Hilman <khilman@baylibre.com>
---
 drivers/media/platform/davinci/vpif_capture.c | 82 ++++++++++++++++++++++++++-
 1 file changed, 80 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
index b9d927d1e5a8..67624dbf1272 100644
--- a/drivers/media/platform/davinci/vpif_capture.c
+++ b/drivers/media/platform/davinci/vpif_capture.c
@@ -24,6 +24,9 @@
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-of.h>
 #include <media/i2c/tvp514x.h>
+#include <media/v4l2-mediabus.h>
+
+#include <linux/videodev2.h>
 
 #include "vpif.h"
 #include "vpif_capture.h"
@@ -387,7 +390,8 @@ static irqreturn_t vpif_channel_isr(int irq, void *dev_id)
 		common = &ch->common[i];
 		/* skip If streaming is not started in this channel */
 		/* Check the field format */
-		if (1 == ch->vpifparams.std_info.frm_fmt) {
+		if (1 == ch->vpifparams.std_info.frm_fmt ||
+		    common->fmt.fmt.pix.field == V4L2_FIELD_NONE) {
 			/* Progressive mode */
 			spin_lock(&common->irqlock);
 			if (list_empty(&common->dma_queue)) {
@@ -468,9 +472,38 @@ static int vpif_update_std_info(struct channel_obj *ch)
 	struct vpif_channel_config_params *std_info = &vpifparams->std_info;
 	struct video_obj *vid_ch = &ch->video;
 	int index;
+	struct v4l2_pix_format *pixfmt = &common->fmt.fmt.pix;
 
 	vpif_dbg(2, debug, "vpif_update_std_info\n");
 
+	/*
+	 * if called after try_fmt or g_fmt, there will already be a size
+	 * so use that by default.
+	 */
+	if (pixfmt->width && pixfmt->height) {
+		if (pixfmt->field == V4L2_FIELD_ANY ||
+		    pixfmt->field == V4L2_FIELD_NONE)
+			pixfmt->field = V4L2_FIELD_NONE;
+		
+		vpifparams->iface.if_type = VPIF_IF_BT656;
+		if (pixfmt->pixelformat == V4L2_PIX_FMT_SGRBG10 ||
+		    pixfmt->pixelformat == V4L2_PIX_FMT_SBGGR8)
+			vpifparams->iface.if_type = VPIF_IF_RAW_BAYER;
+
+		if (pixfmt->pixelformat == V4L2_PIX_FMT_SGRBG10)
+			vpifparams->params.data_sz = 1; /* 10 bits/pixel.  */
+
+		/* 
+		 * For raw formats from camera sensors, we don't need 
+		 * the std_info from table lookup, so nothing else to do here.
+		 */
+		if (vpifparams->iface.if_type == VPIF_IF_RAW_BAYER) {
+			memset(std_info, 0, sizeof(struct vpif_channel_config_params));
+			vpifparams->std_info.capture_format = 1; /* CCD/raw mode */
+			return 0;
+		}
+	}
+
 	for (index = 0; index < vpif_ch_params_count; index++) {
 		config = &vpif_ch_params[index];
 		if (config->hd_sd == 0) {
@@ -939,6 +972,7 @@ static int vpif_try_fmt_vid_cap(struct file *file, void *priv,
 	struct v4l2_pix_format *pixfmt = &fmt->fmt.pix;
 	struct common_obj *common = &(ch->common[VPIF_VIDEO_INDEX]);
 
+	common->fmt = *fmt;
 	vpif_update_std_info(ch);
 
 	pixfmt->field = common->fmt.fmt.pix.field;
@@ -947,8 +981,17 @@ static int vpif_try_fmt_vid_cap(struct file *file, void *priv,
 	pixfmt->width = common->fmt.fmt.pix.width;
 	pixfmt->height = common->fmt.fmt.pix.height;
 	pixfmt->sizeimage = pixfmt->bytesperline * pixfmt->height * 2;
+	if (pixfmt->pixelformat == V4L2_PIX_FMT_SGRBG10) {
+		pixfmt->bytesperline = common->fmt.fmt.pix.width * 2;
+		pixfmt->sizeimage = pixfmt->bytesperline * pixfmt->height;
+	}
 	pixfmt->priv = 0;
 
+	dev_dbg(vpif_dev, "%s: %d x %d; pitch=%d pixelformat=0x%08x, field=%d, size=%d\n", __func__,
+		pixfmt->width, pixfmt->height,
+		pixfmt->bytesperline, pixfmt->pixelformat,
+		pixfmt->field, pixfmt->sizeimage);
+
 	return 0;
 }
 
@@ -965,13 +1008,47 @@ static int vpif_g_fmt_vid_cap(struct file *file, void *priv,
 	struct video_device *vdev = video_devdata(file);
 	struct channel_obj *ch = video_get_drvdata(vdev);
 	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
+	struct v4l2_pix_format *pix_fmt = &fmt->fmt.pix;
+	struct v4l2_subdev_format format = {
+		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
+	};
+	struct v4l2_mbus_framefmt *mbus_fmt = &format.format;
+	int ret;
 
 	/* Check the validity of the buffer type */
 	if (common->fmt.type != fmt->type)
 		return -EINVAL;
 
-	/* Fill in the information about format */
+	/* By default, use currently set fmt */
 	*fmt = common->fmt;
+	
+	/* If subdev has get_fmt, use that to override */
+	ret = v4l2_subdev_call(ch->sd, pad, get_fmt, NULL, &format);
+	if (!ret && mbus_fmt->code) {
+		v4l2_fill_pix_format(pix_fmt, mbus_fmt);
+		pix_fmt->bytesperline = pix_fmt->width;
+		if (mbus_fmt->code == MEDIA_BUS_FMT_SGRBG10_1X10) {
+			/* e.g. mt9v032 */
+			pix_fmt->pixelformat = V4L2_PIX_FMT_SGRBG10;
+			pix_fmt->bytesperline = pix_fmt->width * 2;
+		} else if (mbus_fmt->code == MEDIA_BUS_FMT_UYVY8_2X8) {
+			/* e.g. tvp514x */
+			pix_fmt->pixelformat = V4L2_PIX_FMT_NV16;
+			pix_fmt->bytesperline = pix_fmt->width * 2;
+		} else {
+			dev_warn(vpif_dev, "%s: Unhandled media-bus format 0x%x\n",
+				 __func__, mbus_fmt->code);
+		}
+		pix_fmt->sizeimage = pix_fmt->bytesperline * pix_fmt->height;
+		dev_dbg(vpif_dev, "%s: %d x %d; pitch=%d, pixelformat=0x%08x, code=0x%x, field=%d, size=%d\n", __func__,
+			pix_fmt->width, pix_fmt->height,
+			pix_fmt->bytesperline, pix_fmt->pixelformat, 
+			mbus_fmt->code, pix_fmt->field, pix_fmt->sizeimage);
+
+		common->fmt = *fmt;
+		vpif_update_std_info(ch);
+	}
+
 	return 0;
 }
 
@@ -1358,6 +1435,7 @@ static int vpif_probe_complete(void)
 		/* set initial format */
 		ch->video.stdid = V4L2_STD_525_60;
 		memset(&ch->video.dv_timings, 0, sizeof(ch->video.dv_timings));
+		common->fmt.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 		vpif_update_std_info(ch);
 
 		/* Initialize vb2 queue */
-- 
2.9.3
