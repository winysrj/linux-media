Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-4.sys.kth.se ([130.237.48.193]:44910 "EHLO
        smtp-4.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752232AbdLHBI7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 7 Dec 2017 20:08:59 -0500
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH v9 10/28] rcar-vin: do not reset crop and compose when setting format
Date: Fri,  8 Dec 2017 02:08:24 +0100
Message-Id: <20171208010842.20047-11-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20171208010842.20047-1-niklas.soderlund+renesas@ragnatech.se>
References: <20171208010842.20047-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It was a bad idea to reset the crop and compose settings when a new
format is set. This would overwrite any crop/compose set by s_select and
cause unexpected behaviors, remove it. Also fold the reset helper in to
the only remaining caller.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/rcar-vin/rcar-v4l2.c | 21 +++++++--------------
 1 file changed, 7 insertions(+), 14 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c b/drivers/media/platform/rcar-vin/rcar-v4l2.c
index 1c5e7f6d5b963740..254fa1c8770275a5 100644
--- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
+++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
@@ -90,17 +90,6 @@ static u32 rvin_format_sizeimage(struct v4l2_pix_format *pix)
  * V4L2
  */
 
-static void rvin_reset_crop_compose(struct rvin_dev *vin)
-{
-	vin->crop.top = vin->crop.left = 0;
-	vin->crop.width = vin->source.width;
-	vin->crop.height = vin->source.height;
-
-	vin->compose.top = vin->compose.left = 0;
-	vin->compose.width = vin->format.width;
-	vin->compose.height = vin->format.height;
-}
-
 static int rvin_reset_format(struct rvin_dev *vin)
 {
 	struct v4l2_subdev_format fmt = {
@@ -147,7 +136,13 @@ static int rvin_reset_format(struct rvin_dev *vin)
 		break;
 	}
 
-	rvin_reset_crop_compose(vin);
+	vin->crop.top = vin->crop.left = 0;
+	vin->crop.width = mf->width;
+	vin->crop.height = mf->height;
+
+	vin->compose.top = vin->compose.left = 0;
+	vin->compose.width = mf->width;
+	vin->compose.height = mf->height;
 
 	vin->format.bytesperline = rvin_format_bytesperline(&vin->format);
 	vin->format.sizeimage = rvin_format_sizeimage(&vin->format);
@@ -317,8 +312,6 @@ static int rvin_s_fmt_vid_cap(struct file *file, void *priv,
 
 	vin->format = f->fmt.pix;
 
-	rvin_reset_crop_compose(vin);
-
 	return 0;
 }
 
-- 
2.15.0
