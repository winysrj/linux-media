Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:55018 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932244AbbLECNK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Dec 2015 21:13:10 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-sh@vger.kernel.org
Subject: [PATCH v2 14/32] v4l: vsp1: Reuse local variable instead of recomputing it
Date: Sat,  5 Dec 2015 04:12:48 +0200
Message-Id: <1449281586-25726-15-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1449281586-25726-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1449281586-25726-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

No need to waste CPU cycles when the value we need is already available.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_video.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
index b82ff1a0371b..c958ba6a20ce 100644
--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -416,7 +416,7 @@ static int vsp1_video_pipeline_validate(struct vsp1_pipeline *pipe,
 			rwpf->video->pipe_index = pipe->num_inputs;
 		} else if (e->type == VSP1_ENTITY_WPF) {
 			rwpf = to_rwpf(subdev);
-			pipe->output = to_rwpf(subdev);
+			pipe->output = rwpf;
 			rwpf->video->pipe_index = 0;
 		} else if (e->type == VSP1_ENTITY_LIF) {
 			pipe->lif = e;
-- 
2.4.10

