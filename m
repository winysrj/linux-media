Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:58791 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752943Ab1GaWH5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 31 Jul 2011 18:07:57 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Jonathan Cameron <jic23@cam.ac.uk>
Subject: Re: Error routes through omap3isp ccdc.
Date: Sun, 31 Jul 2011 17:15:15 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
References: <4E1AD36D.4030702@cam.ac.uk> <201107111257.24089.laurent.pinchart@ideasonboard.com> <4E1ADB90.8050305@cam.ac.uk>
In-Reply-To: <4E1ADB90.8050305@cam.ac.uk>
MIME-Version: 1.0
Content-Type: Text/Plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-Id: <201107311715.16374.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jonathan,

On Monday 11 July 2011 13:16:32 Jonathan Cameron wrote:
> On 07/11/11 11:57, Laurent Pinchart wrote:
> > On Monday 11 July 2011 12:54:42 Laurent Pinchart wrote:
> >> On Monday 11 July 2011 12:41:49 Jonathan Cameron wrote:
> > [snip]
> > 
> >> I think we should try to fix it in ispvideo.c instead. You could add a
> >> check to isp_video_validate_pipeline() to make sure that the pipeline
> >> has a video source.
> > 
> > And I forgot to mention, I can send a patch if you don't want to write
> > it.
> 
> Given I can't quite see why the validate_pipeline code would ever want to
> break on source pad being null (which I think is what it is currently
> doing), I'll leave it to you.  Really don't know this code well enough!

Could you please test the following patch ?

>From 578d0b64a25177290815f974fb7898e32587b450 Mon Sep 17 00:00:00 2001
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Date: Sun, 31 Jul 2011 17:12:02 +0200
Subject: [PATCH] omap3isp: Don't accept pipelines with no video source as valid

Make sure the pipeline has a valid video source (either a subdev with no
sink pad, or a non-subdev entity) at stream-on time and return -EPIPE if
no video source can be found.

Reported-by: Jonathan Cameron <jic23@cam.ac.uk>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/omap3isp/ispvideo.c |   14 ++++++++++----
 1 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/media/video/omap3isp/ispvideo.c b/drivers/media/video/omap3isp/ispvideo.c
index fd965ad..d3ddfc0 100644
--- a/drivers/media/video/omap3isp/ispvideo.c
+++ b/drivers/media/video/omap3isp/ispvideo.c
@@ -278,7 +278,8 @@ isp_video_far_end(struct isp_video *video)
  * limits reported by every block in the pipeline.
  *
  * Return 0 if all formats match, or -EPIPE if at least one link is found with
- * different formats on its two ends.
+ * different formats on its two ends or if the pipeline doesn't start with a
+ * video source (either a subdev with no input pad, or a non-subdev entity).
  */
 static int isp_video_validate_pipeline(struct isp_pipeline *pipe)
 {
@@ -329,10 +330,15 @@ static int isp_video_validate_pipeline(struct isp_pipeline *pipe)
 		 * in the middle of it. */
 		shifter_link = subdev == &isp->isp_ccdc.subdev;
 
-		/* Retrieve the source format */
+		/* Retrieve the source format. Return an error if no source
+		 * entity can be found, and stop checking the pipeline if the
+		 * source entity isn't a subdev.
+		 */
 		pad = media_entity_remote_source(pad);
-		if (pad == NULL ||
-		    media_entity_type(pad->entity) != MEDIA_ENT_T_V4L2_SUBDEV)
+		if (pad == NULL
+			return -EPIPE;
+
+		if (media_entity_type(pad->entity) != MEDIA_ENT_T_V4L2_SUBDEV)
 			break;
 
 		subdev = media_entity_to_v4l2_subdev(pad->entity);
-- 
Regards,

Laurent Pinchart
