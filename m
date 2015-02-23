Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:52738 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751898AbbBWUTk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Feb 2015 15:19:40 -0500
From: Lad Prabhakar <prabhakar.csengg@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: LMML <linux-media@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH 1/3] media: omap3isp: ispvideo: drop setting of vb2 buffer state to VB2_BUF_STATE_ACTIVE
Date: Mon, 23 Feb 2015 20:19:31 +0000
Message-Id: <1424722773-20131-2-git-send-email-prabhakar.csengg@gmail.com>
In-Reply-To: <1424722773-20131-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1424722773-20131-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

There isn't a need to assign the state of vb2_buffer to active
as this is already done by the core.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/platform/omap3isp/ispvideo.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/platform/omap3isp/ispvideo.c b/drivers/media/platform/omap3isp/ispvideo.c
index 3fe9047..837018d 100644
--- a/drivers/media/platform/omap3isp/ispvideo.c
+++ b/drivers/media/platform/omap3isp/ispvideo.c
@@ -524,7 +524,6 @@ struct isp_buffer *omap3isp_video_buffer_next(struct isp_video *video)
 
 	buf = list_first_entry(&video->dmaqueue, struct isp_buffer,
 			       irqlist);
-	buf->vb.state = VB2_BUF_STATE_ACTIVE;
 
 	spin_unlock_irqrestore(&video->irqlock, flags);
 
-- 
2.1.0

