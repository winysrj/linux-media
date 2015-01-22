Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:60065 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752521AbbAVOsT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Jan 2015 09:48:19 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	sadegh abbasi <sadegh612000@yahoo.co.uk>
Subject: [PATCH 5/7] Revert "[media] v4l: omap4iss: Add module debug parameter"
Date: Thu, 22 Jan 2015 16:48:44 +0200
Message-Id: <1421938126-17747-6-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1421938126-17747-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1421938126-17747-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This reverts commit 186612342500b0af8498d7c8bc6b3ac32ac7a48e.

The video_device debug field has been renamed to dev_debug, resulting in
a compilation failure. As v4l2 debugging is supposed to be controlled
through a sysfs attribute created by the v4l2 core, there's no need to
duplicate debug control through a module parameter. Remove it.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/staging/media/omap4iss/iss_video.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/staging/media/omap4iss/iss_video.c b/drivers/staging/media/omap4iss/iss_video.c
index 2085f69..6955044 100644
--- a/drivers/staging/media/omap4iss/iss_video.c
+++ b/drivers/staging/media/omap4iss/iss_video.c
@@ -25,9 +25,6 @@
 #include "iss_video.h"
 #include "iss.h"
 
-static unsigned debug;
-module_param(debug, uint, 0644);
-MODULE_PARM_DESC(debug, "activates debug info");
 
 /* -----------------------------------------------------------------------------
  * Helper functions
@@ -1053,8 +1050,6 @@ static int iss_video_open(struct file *file)
 	if (handle == NULL)
 		return -ENOMEM;
 
-	video->video.debug = debug;
-
 	v4l2_fh_init(&handle->vfh, &video->video);
 	v4l2_fh_add(&handle->vfh);
 
-- 
2.0.5

