Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:54324 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751793AbeBZVor (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Feb 2018 16:44:47 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: [PATCH 02/15] v4l: vsp1: Remove outdated comment
Date: Mon, 26 Feb 2018 23:45:03 +0200
Message-Id: <20180226214516.11559-3-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <20180226214516.11559-1-laurent.pinchart+renesas@ideasonboard.com>
References: <20180226214516.11559-1-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The entities in the pipeline are all started when the LIF is setup.
Remove the outdated comment that state otherwise.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_drm.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_drm.c b/drivers/media/platform/vsp1/vsp1_drm.c
index e31fb371eaf9..a1f2ba044092 100644
--- a/drivers/media/platform/vsp1/vsp1_drm.c
+++ b/drivers/media/platform/vsp1/vsp1_drm.c
@@ -221,11 +221,7 @@ int vsp1_du_setup_lif(struct device *dev, unsigned int pipe_index,
 		return -EPIPE;
 	}
 
-	/*
-	 * Enable the VSP1. We don't start the entities themselves right at this
-	 * point as there's no plane configured yet, so we can't start
-	 * processing buffers.
-	 */
+	/* Enable the VSP1. */
 	ret = vsp1_device_get(vsp1);
 	if (ret < 0)
 		return ret;
-- 
Regards,

Laurent Pinchart
