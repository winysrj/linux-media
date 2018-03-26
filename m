Return-path: <linux-media-owner@vger.kernel.org>
Received: from vsp-unauthed02.binero.net ([195.74.38.227]:31802 "EHLO
        vsp-unauthed02.binero.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752497AbeCZVq4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Mar 2018 17:46:56 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH v13 23/33] rcar-vin: force default colorspace for media centric mode
Date: Mon, 26 Mar 2018 23:44:46 +0200
Message-Id: <20180326214456.6655-24-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20180326214456.6655-1-niklas.soderlund+renesas@ragnatech.se>
References: <20180326214456.6655-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The V4L2 specification clearly documents the colorspace fields as being
set by drivers for capture devices. Using the values supplied by
userspace thus wouldn't comply with the API. Until the API is updated to
allow for userspace to set these Hans wants the fields to be set by the
driver to fixed values.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/rcar-vin/rcar-v4l2.c | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c b/drivers/media/platform/rcar-vin/rcar-v4l2.c
index 2280535ca981993f..ea0759a645e49490 100644
--- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
+++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
@@ -664,12 +664,29 @@ static const struct v4l2_ioctl_ops rvin_ioctl_ops = {
  * V4L2 Media Controller
  */
 
+static int rvin_mc_try_format(struct rvin_dev *vin, struct v4l2_pix_format *pix)
+{
+	/*
+	 * The V4L2 specification clearly documents the colorspace fields
+	 * as being set by drivers for capture devices. Using the values
+	 * supplied by userspace thus wouldn't comply with the API. Until
+	 * the API is updated force fixed vaules.
+	 */
+	pix->colorspace = RVIN_DEFAULT_COLORSPACE;
+	pix->xfer_func = V4L2_MAP_XFER_FUNC_DEFAULT(pix->colorspace);
+	pix->ycbcr_enc = V4L2_MAP_YCBCR_ENC_DEFAULT(pix->colorspace);
+	pix->quantization = V4L2_MAP_QUANTIZATION_DEFAULT(true, pix->colorspace,
+							  pix->ycbcr_enc);
+
+	return rvin_format_align(vin, pix);
+}
+
 static int rvin_mc_try_fmt_vid_cap(struct file *file, void *priv,
 				   struct v4l2_format *f)
 {
 	struct rvin_dev *vin = video_drvdata(file);
 
-	return rvin_format_align(vin, &f->fmt.pix);
+	return rvin_mc_try_format(vin, &f->fmt.pix);
 }
 
 static int rvin_mc_s_fmt_vid_cap(struct file *file, void *priv,
@@ -681,7 +698,7 @@ static int rvin_mc_s_fmt_vid_cap(struct file *file, void *priv,
 	if (vb2_is_busy(&vin->queue))
 		return -EBUSY;
 
-	ret = rvin_format_align(vin, &f->fmt.pix);
+	ret = rvin_mc_try_format(vin, &f->fmt.pix);
 	if (ret)
 		return ret;
 
-- 
2.16.2
