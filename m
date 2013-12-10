Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:60296 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777Ab3LJBxd (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Dec 2013 20:53:33 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@iki.fi
Subject: [PATCH] omap3isp: Fix buffer flags handling when querying buffer
Date: Tue, 10 Dec 2013 02:53:39 +0100
Message-Id: <1386640419-2922-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

A missing break resulted in all done buffers being flagged with
V4L2_BUF_FLAG_QUEUED. Fix it.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/omap3isp/ispqueue.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/platform/omap3isp/ispqueue.c b/drivers/media/platform/omap3isp/ispqueue.c
index e15f013..5f0f8fa 100644
--- a/drivers/media/platform/omap3isp/ispqueue.c
+++ b/drivers/media/platform/omap3isp/ispqueue.c
@@ -553,8 +553,10 @@ static void isp_video_buffer_query(struct isp_video_buffer *buf,
 	switch (buf->state) {
 	case ISP_BUF_STATE_ERROR:
 		vbuf->flags |= V4L2_BUF_FLAG_ERROR;
+		/* Fallthrough */
 	case ISP_BUF_STATE_DONE:
 		vbuf->flags |= V4L2_BUF_FLAG_DONE;
+		break;
 	case ISP_BUF_STATE_QUEUED:
 	case ISP_BUF_STATE_ACTIVE:
 		vbuf->flags |= V4L2_BUF_FLAG_QUEUED;
-- 
Regards,

Laurent Pinchart

