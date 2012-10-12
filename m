Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:54545 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760009Ab2JLS0v (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Oct 2012 14:26:51 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@iki.fi
Subject: [PATCH 2/3] omap3isp: video: Fix warning caused by bad vidioc_s_crop prototype
Date: Fri, 12 Oct 2012 20:27:29 +0200
Message-Id: <1350066450-17370-3-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1350066450-17370-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1350066450-17370-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Commit 4f996594 ("v4l2: make vidioc_s_crop const") modified the
vidioc_s_crop operation prototype but forgot to update the OMAP3 ISP
driver. Add a const keyword to fix the function prototype.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/omap3isp/ispvideo.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/platform/omap3isp/ispvideo.c b/drivers/media/platform/omap3isp/ispvideo.c
index a0b737fe..75cd309 100644
--- a/drivers/media/platform/omap3isp/ispvideo.c
+++ b/drivers/media/platform/omap3isp/ispvideo.c
@@ -792,7 +792,7 @@ isp_video_get_crop(struct file *file, void *fh, struct v4l2_crop *crop)
 }
 
 static int
-isp_video_set_crop(struct file *file, void *fh, struct v4l2_crop *crop)
+isp_video_set_crop(struct file *file, void *fh, const struct v4l2_crop *crop)
 {
 	struct isp_video *video = video_drvdata(file);
 	struct v4l2_subdev *subdev;
-- 
1.7.8.6

