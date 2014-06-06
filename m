Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:42318 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530AbaFFPVW (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Jun 2014 11:21:22 -0400
Received: from avalon.ideasonboard.com (unknown [91.178.142.25])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id C048E363DE
	for <linux-media@vger.kernel.org>; Fri,  6 Jun 2014 17:20:53 +0200 (CEST)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 2/5] v4l: omap4iss: Add module debug parameter
Date: Fri,  6 Jun 2014 17:21:43 +0200
Message-Id: <1402068106-32677-3-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1402068106-32677-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1402068106-32677-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The parameter is used to initialize the video node debug field and
activate the V4L debug infrastructure.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/staging/media/omap4iss/iss_video.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/staging/media/omap4iss/iss_video.c b/drivers/staging/media/omap4iss/iss_video.c
index 7aded26..a54ee8c 100644
--- a/drivers/staging/media/omap4iss/iss_video.c
+++ b/drivers/staging/media/omap4iss/iss_video.c
@@ -25,6 +25,9 @@
 #include "iss_video.h"
 #include "iss.h"
 
+static unsigned debug;
+module_param(debug, uint, 0644);
+MODULE_PARM_DESC(debug, "activates debug info");
 
 /* -----------------------------------------------------------------------------
  * Helper functions
@@ -1043,6 +1046,8 @@ static int iss_video_open(struct file *file)
 	if (handle == NULL)
 		return -ENOMEM;
 
+	video->video.debug = debug;
+
 	v4l2_fh_init(&handle->vfh, &video->video);
 	v4l2_fh_add(&handle->vfh);
 
-- 
1.8.5.5

