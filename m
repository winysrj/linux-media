Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:51845 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936380Ab3DRVf5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Apr 2013 17:35:57 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: [PATCH 05/24] V4L2: allow dummy file-handle initialisation by v4l2_fh_init()
Date: Thu, 18 Apr 2013 23:35:26 +0200
Message-Id: <1366320945-21591-6-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1366320945-21591-1-git-send-email-g.liakhovetski@gmx.de>
References: <1366320945-21591-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

v4l2_fh_init() can be used to initialise dummy file-handles with vdev ==
NULL.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/v4l2-core/v4l2-fh.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-fh.c b/drivers/media/v4l2-core/v4l2-fh.c
index e57c002..7ae608b 100644
--- a/drivers/media/v4l2-core/v4l2-fh.c
+++ b/drivers/media/v4l2-core/v4l2-fh.c
@@ -33,10 +33,12 @@
 void v4l2_fh_init(struct v4l2_fh *fh, struct video_device *vdev)
 {
 	fh->vdev = vdev;
-	/* Inherit from video_device. May be overridden by the driver. */
-	fh->ctrl_handler = vdev->ctrl_handler;
+	if (vdev) {
+		/* Inherit from video_device. May be overridden by the driver. */
+		fh->ctrl_handler = vdev->ctrl_handler;
+		set_bit(V4L2_FL_USES_V4L2_FH, &fh->vdev->flags);
+	}
 	INIT_LIST_HEAD(&fh->list);
-	set_bit(V4L2_FL_USES_V4L2_FH, &fh->vdev->flags);
 	fh->prio = V4L2_PRIORITY_UNSET;
 	init_waitqueue_head(&fh->wait);
 	INIT_LIST_HEAD(&fh->available);
-- 
1.7.2.5

