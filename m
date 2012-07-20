Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:62056 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944Ab2GTN61 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Jul 2012 09:58:27 -0400
Date: Fri, 20 Jul 2012 15:58:25 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: linux-media@vger.kernel.org
Subject: Re: [PATCH v2 8/9] ov772x: Compute window size registers at runtime
In-Reply-To: <1342619906-5820-9-git-send-email-laurent.pinchart@ideasonboard.com>
Message-ID: <Pine.LNX.4.64.1207201554130.5505@axis700.grange>
References: <1342619906-5820-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <1342619906-5820-9-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent

Thanks for the patch

On Wed, 18 Jul 2012, Laurent Pinchart wrote:

> Instead of hardcoding register arrays, compute the values at runtime.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  drivers/media/video/ov772x.c |  162 +++++++++++++++++-------------------------
>  1 files changed, 65 insertions(+), 97 deletions(-)
> 
> diff --git a/drivers/media/video/ov772x.c b/drivers/media/video/ov772x.c
> index 3874dbc..aa2ba9e 100644
> --- a/drivers/media/video/ov772x.c
> +++ b/drivers/media/video/ov772x.c

I'm afraid, I still don't quite agree with your changes to size macros. 
This is not a huge deal, but I'd preserve the current (Q)VGA_* naming for 
now until we find a better solution. How about this patch merged with yours:

diff --git a/drivers/media/video/ov772x.c b/drivers/media/video/ov772x.c
index a2dde04..76a80b6 100644
--- a/drivers/media/video/ov772x.c
+++ b/drivers/media/video/ov772x.c
@@ -360,8 +360,12 @@
 #define SCAL0_ACTRL     0x08 /* Auto scaling factor control */
 #define SCAL1_2_ACTRL   0x04 /* Auto scaling factor control */
 
-#define OV772X_DEFAULT_WIDTH	640
-#define OV772X_DEFAULT_HEIGHT	480
+#define VGA_WIDTH		640
+#define VGA_HEIGHT		480
+#define QVGA_WIDTH		320
+#define QVGA_HEIGHT		240
+#define OV772X_MAX_WIDTH	VGA_WIDTH
+#define OV772X_MAX_HEIGHT	VGA_HEIGHT
 
 /*
  * ID
@@ -488,8 +492,8 @@ static const struct ov772x_win_size ov772x_win_sizes[] = {
 		.rect = {
 			.left = 140,
 			.top = 14,
-			.width = 640,
-			.height = 480,
+			.width = VGA_WIDTH,
+			.height = VGA_HEIGHT,
 		},
 	}, {
 		.name     = "QVGA",
@@ -497,8 +501,8 @@ static const struct ov772x_win_size ov772x_win_sizes[] = {
 		.rect = {
 			.left = 252,
 			.top = 6,
-			.width = 320,
-			.height = 240,
+			.width = QVGA_WIDTH,
+			.height = QVGA_HEIGHT,
 		},
 	},
 };
@@ -858,8 +862,8 @@ static int ov772x_g_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
 {
 	a->c.left	= 0;
 	a->c.top	= 0;
-	a->c.width	= OV772X_DEFAULT_WIDTH;
-	a->c.height	= OV772X_DEFAULT_HEIGHT;
+	a->c.width	= VGA_WIDTH;
+	a->c.height	= VGA_HEIGHT;
 	a->type		= V4L2_BUF_TYPE_VIDEO_CAPTURE;
 
 	return 0;
@@ -869,8 +873,8 @@ static int ov772x_cropcap(struct v4l2_subdev *sd, struct v4l2_cropcap *a)
 {
 	a->bounds.left			= 0;
 	a->bounds.top			= 0;
-	a->bounds.width			= OV772X_DEFAULT_WIDTH;
-	a->bounds.height		= OV772X_DEFAULT_HEIGHT;
+	a->bounds.width			= OV772X_MAX_WIDTH;
+	a->bounds.height		= OV772X_MAX_HEIGHT;
 	a->defrect			= a->bounds;
 	a->type				= V4L2_BUF_TYPE_VIDEO_CAPTURE;
 	a->pixelaspect.numerator	= 1;

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
