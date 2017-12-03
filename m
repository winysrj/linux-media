Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:53675 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752071AbdLCK5e (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 3 Dec 2017 05:57:34 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc: linux-renesas-soc@vger.kernel.org
Subject: [PATCH 1/9] v4l: vsp1: Fix display stalls when requesting too many inputs
Date: Sun,  3 Dec 2017 12:57:27 +0200
Message-Id: <20171203105735.10529-2-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <20171203105735.10529-1-laurent.pinchart+renesas@ideasonboard.com>
References: <20171203105735.10529-1-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make sure we don't accept more inputs than the hardware can handle. This
is a temporary fix to avoid display stall, we need to instead allocate
the BRU or BRS to display pipelines dynamically based on the number of
planes they each use.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_drm.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/media/platform/vsp1/vsp1_drm.c b/drivers/media/platform/vsp1/vsp1_drm.c
index 7ce69f23f50a..ac85942162c1 100644
--- a/drivers/media/platform/vsp1/vsp1_drm.c
+++ b/drivers/media/platform/vsp1/vsp1_drm.c
@@ -530,6 +530,15 @@ void vsp1_du_atomic_flush(struct device *dev, unsigned int pipe_index)
 		struct vsp1_rwpf *rpf = vsp1->rpf[i];
 		unsigned int j;
 
+		/*
+		 * Make sure we don't accept more inputs than the hardware can
+		 * handle. This is a temporary fix to avoid display stall, we
+		 * need to instead allocate the BRU or BRS to display pipelines
+		 * dynamically based on the number of planes they each use.
+		 */
+		if (pipe->num_inputs >= pipe->bru->source_pad)
+			pipe->inputs[i] = NULL;
+
 		if (!pipe->inputs[i])
 			continue;
 
-- 
Regards,

Laurent Pinchart
