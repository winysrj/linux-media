Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:59564 "EHLO
        lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753026AbdCFOY4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 6 Mar 2017 09:24:56 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] vivid: fix try_fmt behavior
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Vincent ABRIOU <vincent.abriou@st.com>
Message-ID: <31f776c6-bfd8-5c88-6a04-8e29cde9a53a@xs4all.nl>
Date: Mon, 6 Mar 2017 15:23:15 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

vivid_try_fmt_vid_cap() called tpg_calc_line_width to calculate the sizeimage
value, but that tpg function uses the current format, not the proposed (tried)
format.

Rewrote this code to calculate this correctly.

The vivid_try_fmt_vid_out() code was completely wrong w.r.t. sizeimage, and
neither did it take the vdownsampling[] factors into account.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com
---
diff --git a/drivers/media/platform/vivid/vivid-vid-cap.c b/drivers/media/platform/vivid/vivid-vid-cap.c
index a18e6fec219b..01419455e545 100644
--- a/drivers/media/platform/vivid/vivid-vid-cap.c
+++ b/drivers/media/platform/vivid/vivid-vid-cap.c
@@ -616,7 +616,7 @@ int vivid_try_fmt_vid_cap(struct file *file, void *priv,
  	/* This driver supports custom bytesperline values */

  	mp->num_planes = fmt->buffers;
-	for (p = 0; p < mp->num_planes; p++) {
+	for (p = 0; p < fmt->buffers; p++) {
  		/* Calculate the minimum supported bytesperline value */
  		bytesperline = (mp->width * fmt->bit_depth[p]) >> 3;
  		/* Calculate the maximum supported bytesperline value */
@@ -626,10 +626,17 @@ int vivid_try_fmt_vid_cap(struct file *file, void *priv,
  			pfmt[p].bytesperline = max_bpl;
  		if (pfmt[p].bytesperline < bytesperline)
  			pfmt[p].bytesperline = bytesperline;
-		pfmt[p].sizeimage = tpg_calc_line_width(&dev->tpg, p, pfmt[p].bytesperline) *
-			mp->height + fmt->data_offset[p];
+
+		pfmt[p].sizeimage = (pfmt[p].bytesperline * mp->height) /
+				fmt->vdownsampling[p] + fmt->data_offset[p];
+
  		memset(pfmt[p].reserved, 0, sizeof(pfmt[p].reserved));
  	}
+	for (p = fmt->buffers; p < fmt->planes; p++)
+		pfmt[0].sizeimage += (pfmt[0].bytesperline * mp->height *
+			(fmt->bit_depth[p] / fmt->vdownsampling[p])) /
+			(fmt->bit_depth[0] / fmt->vdownsampling[0]);
+
  	mp->colorspace = vivid_colorspace_cap(dev);
  	if (fmt->color_enc == TGP_COLOR_ENC_HSV)
  		mp->hsv_enc = vivid_hsv_enc_cap(dev);
diff --git a/drivers/media/platform/vivid/vivid-vid-out.c b/drivers/media/platform/vivid/vivid-vid-out.c
index 7ba52ee98371..b3b3b31c873b 100644
--- a/drivers/media/platform/vivid/vivid-vid-out.c
+++ b/drivers/media/platform/vivid/vivid-vid-out.c
@@ -390,22 +390,28 @@ int vivid_try_fmt_vid_out(struct file *file, void *priv,

  	/* This driver supports custom bytesperline values */

-	/* Calculate the minimum supported bytesperline value */
-	bytesperline = (mp->width * fmt->bit_depth[0]) >> 3;
-	/* Calculate the maximum supported bytesperline value */
-	max_bpl = (MAX_ZOOM * MAX_WIDTH * fmt->bit_depth[0]) >> 3;
  	mp->num_planes = fmt->buffers;
-	for (p = 0; p < mp->num_planes; p++) {
+	for (p = 0; p < fmt->buffers; p++) {
+		/* Calculate the minimum supported bytesperline value */
+		bytesperline = (mp->width * fmt->bit_depth[p]) >> 3;
+		/* Calculate the maximum supported bytesperline value */
+		max_bpl = (MAX_ZOOM * MAX_WIDTH * fmt->bit_depth[p]) >> 3;
+
  		if (pfmt[p].bytesperline > max_bpl)
  			pfmt[p].bytesperline = max_bpl;
  		if (pfmt[p].bytesperline < bytesperline)
  			pfmt[p].bytesperline = bytesperline;
-		pfmt[p].sizeimage = pfmt[p].bytesperline * mp->height;
+
+		pfmt[p].sizeimage = (pfmt[p].bytesperline * mp->height) /
+					fmt->vdownsampling[p];
+
  		memset(pfmt[p].reserved, 0, sizeof(pfmt[p].reserved));
  	}
  	for (p = fmt->buffers; p < fmt->planes; p++)
-		pfmt[0].sizeimage += (pfmt[0].bytesperline * fmt->bit_depth[p]) /
-				     (fmt->bit_depth[0] * fmt->vdownsampling[p]);
+		pfmt[0].sizeimage += (pfmt[0].bytesperline * mp->height *
+			(fmt->bit_depth[p] / fmt->vdownsampling[p])) /
+			(fmt->bit_depth[0] / fmt->vdownsampling[0]);
+
  	mp->xfer_func = V4L2_XFER_FUNC_DEFAULT;
  	mp->ycbcr_enc = V4L2_YCBCR_ENC_DEFAULT;
  	mp->quantization = V4L2_QUANTIZATION_DEFAULT;
