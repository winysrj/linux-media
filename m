Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:44652 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933258AbbLQIkw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Dec 2015 03:40:52 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-sh@vger.kernel.org
Subject: [PATCH/RFC 13/48] v4l: vsp1: Document calling context of vsp1_pipeline_propagate_alpha()
Date: Thu, 17 Dec 2015 10:39:51 +0200
Message-Id: <1450341626-6695-14-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1450341626-6695-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1450341626-6695-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The function can only be called from a s_stream handler as it requires a
valid display list context (due to calling vsp1_uds_set_alpha() which
writes to module registers). Document the requirement.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_pipe.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/platform/vsp1/vsp1_pipe.c b/drivers/media/platform/vsp1/vsp1_pipe.c
index facf68f999ce..9549aacab3cf 100644
--- a/drivers/media/platform/vsp1/vsp1_pipe.c
+++ b/drivers/media/platform/vsp1/vsp1_pipe.c
@@ -297,6 +297,9 @@ done:
  * to be scaled, we disable alpha scaling when the UDS input has a fixed alpha
  * value. The UDS then outputs a fixed alpha value which needs to be programmed
  * from the input RPF alpha.
+ *
+ * This function can only be called from a subdev s_stream handler as it
+ * requires a valid display list context.
  */
 void vsp1_pipeline_propagate_alpha(struct vsp1_pipeline *pipe,
 				   struct vsp1_entity *input,
-- 
2.4.10

