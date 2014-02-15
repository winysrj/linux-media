Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:44776 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752134AbaBOBSz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Feb 2014 20:18:55 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Peter Meerwald <pmeerw@pmeerw.net>, sakari.ailus@iki.fi
Subject: [PATCH 1/2] omap3isp: Don't try to locate external subdev for mem-to-mem pipelines
Date: Sat, 15 Feb 2014 02:19:54 +0100
Message-Id: <1392427195-2017-2-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1392427195-2017-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1392427195-2017-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Memory-to-memory pipelines have no external subdev, we shouldn't try to
locate one and validate its configuration. The driver currently works by
chance due to another bug that results in failure to locate the external
subdev being ignored.

This gets rid of the "omap3isp omap3isp: can't find source, failing now"
error message in the kernel log when operating on a memory-to-memory
pipeline.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/omap3isp/ispvideo.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/platform/omap3isp/ispvideo.c b/drivers/media/platform/omap3isp/ispvideo.c
index 856fdf5..313fd13 100644
--- a/drivers/media/platform/omap3isp/ispvideo.c
+++ b/drivers/media/platform/omap3isp/ispvideo.c
@@ -888,6 +888,10 @@ static int isp_video_check_external_subdevs(struct isp_video *video,
 	unsigned int i;
 	int ret = 0;
 
+	/* Memory-to-memory pipelines have no external subdev. */
+	if (pipe->input != NULL)
+		return 0;
+
 	for (i = 0; i < ARRAY_SIZE(ents); i++) {
 		/* Is the entity part of the pipeline? */
 		if (!(pipe->entities & (1 << ents[i]->id)))
-- 
1.8.3.2

