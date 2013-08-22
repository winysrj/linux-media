Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:36036 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754615Ab3HVX0a (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Aug 2013 19:26:30 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-sh@vger.kernel.org
Subject: [PATCH] v4l: vsp1: Fix mutex double lock at streamon time
Date: Fri, 23 Aug 2013 01:27:41 +0200
Message-Id: <1377214061-16484-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

A mutex_lock() was left when the driver was converted to use the vb2
ioctl helpers, resulting in a deadlock at streamon time. Fix it.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_video.c | 2 --
 1 file changed, 2 deletions(-)

Yet another v3.12 fix for the VSP1 driver. I'm not sure how I've managed to let
this bug slip in. This should hopefully be the last one, sorry for the noise :-/

diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
index f51f842..714c53e 100644
--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -839,8 +839,6 @@ vsp1_video_streamon(struct file *file, void *fh, enum v4l2_buf_type type)
 	struct vsp1_pipeline *pipe;
 	int ret;
 
-	mutex_lock(&video->lock);
-
 	if (video->queue.owner && video->queue.owner != file->private_data)
 		return -EBUSY;
 
-- 
Regards,

Laurent Pinchart

