Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:40677 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752649AbcCYKo7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Mar 2016 06:44:59 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org
Subject: [PATCH v2 34/54] v4l: vsp1: Use __vsp1_video_try_format to initialize format at init time
Date: Fri, 25 Mar 2016 12:44:08 +0200
Message-Id: <1458902668-1141-35-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1458902668-1141-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1458902668-1141-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Reuse the runtime logic to initialize the default format instead of
open-coding it. This ensures coherency between intialization and
runtime.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_video.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
index a3f1145c8a79..4dcc892977df 100644
--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -958,17 +958,10 @@ struct vsp1_video *vsp1_video_create(struct vsp1_device *vsp1,
 		return ERR_PTR(ret);
 
 	/* ... and the format ... */
-	rwpf->fmtinfo = vsp1_get_format_info(VSP1_VIDEO_DEF_FORMAT);
-	rwpf->format.pixelformat = rwpf->fmtinfo->fourcc;
-	rwpf->format.colorspace = V4L2_COLORSPACE_SRGB;
-	rwpf->format.field = V4L2_FIELD_NONE;
+	rwpf->format.pixelformat = VSP1_VIDEO_DEF_FORMAT;
 	rwpf->format.width = VSP1_VIDEO_DEF_WIDTH;
 	rwpf->format.height = VSP1_VIDEO_DEF_HEIGHT;
-	rwpf->format.num_planes = 1;
-	rwpf->format.plane_fmt[0].bytesperline =
-		rwpf->format.width * rwpf->fmtinfo->bpp[0] / 8;
-	rwpf->format.plane_fmt[0].sizeimage =
-		rwpf->format.plane_fmt[0].bytesperline * rwpf->format.height;
+	__vsp1_video_try_format(video, &rwpf->format, &rwpf->fmtinfo);
 
 	/* ... and the video node... */
 	video->video.v4l2_dev = &video->vsp1->v4l2_dev;
-- 
2.7.3

