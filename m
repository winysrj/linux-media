Return-path: <linux-media-owner@vger.kernel.org>
Received: from vsp-unauthed02.binero.net ([195.74.38.227]:27247 "EHLO
        bin-vsp-out-01.atm.binero.net" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1164156AbeCBB7U (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 1 Mar 2018 20:59:20 -0500
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH v11 22/32] rcar-vin: force default colorspace for media centric mode
Date: Fri,  2 Mar 2018 02:57:41 +0100
Message-Id: <20180302015751.25596-23-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20180302015751.25596-1-niklas.soderlund+renesas@ragnatech.se>
References: <20180302015751.25596-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When the VIN driver is running in media centric mode (on Gen3) the
colorspace is not retrieved from the video source instead the user is
expected to set it as part of the format. There is no way for the VIN
driver to validated the colorspace requested by user-space, this creates
a problem where validation tools fail. Until the user requested
colorspace can be validated lets force it to the driver default.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/platform/rcar-vin/rcar-v4l2.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c b/drivers/media/platform/rcar-vin/rcar-v4l2.c
index 8d92710efffa7276..02f3100ed30db63c 100644
--- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
+++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
@@ -675,12 +675,24 @@ static const struct v4l2_ioctl_ops rvin_ioctl_ops = {
  * V4L2 Media Controller
  */
 
+static int rvin_mc_try_format(struct rvin_dev *vin, struct v4l2_pix_format *pix)
+{
+	/*
+	 * There is no way to validate the colorspace provided by the
+	 * user. Until it can be validated force colorspace to the
+	 * driver default.
+	 */
+	pix->colorspace = RVIN_DEFAULT_COLORSPACE;
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
@@ -692,7 +704,7 @@ static int rvin_mc_s_fmt_vid_cap(struct file *file, void *priv,
 	if (vb2_is_busy(&vin->queue))
 		return -EBUSY;
 
-	ret = rvin_format_align(vin, &f->fmt.pix);
+	ret = rvin_mc_try_format(vin, &f->fmt.pix);
 	if (ret)
 		return ret;
 
-- 
2.16.2
