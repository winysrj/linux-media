Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:50922 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886AbcDMUnd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Apr 2016 16:43:33 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-renesas-soc@vger.kernel.org
Subject: [PATCH] [media] vsp1: make vsp1_drm_frame_end static
Date: Wed, 13 Apr 2016 17:42:24 -0300
Message-Id: <5fb2107346cfc6d8fe62117a2cbf91fc1f92cc84.1460580142.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As reported by smatch:
	drivers/media/platform/vsp1/vsp1_drm.c:39:6: warning: no previous prototype for 'vsp1_drm_frame_end' [-Wmissing-prototypes]
	 void vsp1_drm_frame_end(struct vsp1_pipeline *pipe)

Fixes: ef9621bcd664 ("[media] v4l: vsp1: Store the display list manager in the WPF")
Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/platform/vsp1/vsp1_drm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/vsp1/vsp1_drm.c b/drivers/media/platform/vsp1/vsp1_drm.c
index 22f67360b750..1f08da4b933b 100644
--- a/drivers/media/platform/vsp1/vsp1_drm.c
+++ b/drivers/media/platform/vsp1/vsp1_drm.c
@@ -36,7 +36,7 @@ void vsp1_drm_display_start(struct vsp1_device *vsp1)
 	vsp1_dlm_irq_display_start(vsp1->drm->pipe.output->dlm);
 }
 
-void vsp1_drm_frame_end(struct vsp1_pipeline *pipe)
+static void vsp1_drm_frame_end(struct vsp1_pipeline *pipe)
 {
 	vsp1_dlm_irq_frame_end(pipe->output->dlm);
 }
-- 
2.5.5

