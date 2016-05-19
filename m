Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:56484 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755345AbcESXmB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 May 2016 19:42:01 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org
Subject: [PATCH 3/3] v4l: vsp1: Fix crash when resetting pipeline
Date: Fri, 20 May 2016 02:41:58 +0300
Message-Id: <1463701318-22081-4-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1463701318-22081-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1463701318-22081-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The vsp1_pipeline_reset() function loops over pipeline inputs and output
and resets them. When doing so it assumes both that the pipeline has
been correctly configured with an output, and that inputs are are stored
in the pipe inputs array at positions 0 to num_inputs-1.

Both the assumptions are incorrect. The pipeline might need to be reset
after a failed attempts to configure it, without any output specified.
Furthermore, inputs are stored in a positiong equal to their RPF index,
possibly creating holes in the inputs array if the RPFs are not used in
sequence.

Fix both issues by looping over the whole inputs array and skipping
unused entries, and ignoring the output when not set.

Fixes: ff7e97c94d9f ("[media] v4l: vsp1: Store pipeline pointer in rwpf")
Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_pipe.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_pipe.c b/drivers/media/platform/vsp1/vsp1_pipe.c
index be47c8a1a812..3c6f623f056c 100644
--- a/drivers/media/platform/vsp1/vsp1_pipe.c
+++ b/drivers/media/platform/vsp1/vsp1_pipe.c
@@ -172,13 +172,17 @@ void vsp1_pipeline_reset(struct vsp1_pipeline *pipe)
 			bru->inputs[i].rpf = NULL;
 	}
 
-	for (i = 0; i < pipe->num_inputs; ++i) {
-		pipe->inputs[i]->pipe = NULL;
-		pipe->inputs[i] = NULL;
+	for (i = 0; i < ARRAY_SIZE(pipe->inputs); ++i) {
+		if (pipe->inputs[i]) {
+			pipe->inputs[i]->pipe = NULL;
+			pipe->inputs[i] = NULL;
+		}
 	}
 
-	pipe->output->pipe = NULL;
-	pipe->output = NULL;
+	if (pipe->output) {
+		pipe->output->pipe = NULL;
+		pipe->output = NULL;
+	}
 
 	INIT_LIST_HEAD(&pipe->entities);
 	pipe->state = VSP1_PIPELINE_STOPPED;
-- 
2.7.3

