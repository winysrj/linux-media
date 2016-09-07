Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:54026 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752159AbcIGWYy (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 7 Sep 2016 18:24:54 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran@ksquared.org.uk>
Subject: [PATCH v3 07/10] v4l: fdp1: Remove unused struct fdp1_v4l2_buffer
Date: Thu,  8 Sep 2016 01:25:07 +0300
Message-Id: <1473287110-780-8-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1473287110-780-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1473287110-780-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The structure is not used, remove it.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/rcar_fdp1.c | 13 -------------
 1 file changed, 13 deletions(-)

diff --git a/drivers/media/platform/rcar_fdp1.c b/drivers/media/platform/rcar_fdp1.c
index bbeacf1527b5..fdab41165f5a 100644
--- a/drivers/media/platform/rcar_fdp1.c
+++ b/drivers/media/platform/rcar_fdp1.c
@@ -514,19 +514,6 @@ enum fdp1_deint_mode {
 	 mode == FDP1_PREVFIELD)
 
 /*
- * fdp1_v4l2_buffer: Track v4l2_buffers with a reference count
- *
- * As buffers come in, they may be used for more than one field.
- * It then becomes necessary to track the usage of these buffers,
- * and only release when the last job has completed using this
- * vb buffer.
- */
-struct fdp1_v4l2_buffer {
-	struct vb2_v4l2_buffer	vb;
-	struct list_head	list;
-};
-
-/*
  * FDP1 operates on potentially 3 fields, which are tracked
  * from the VB buffers using this context structure.
  * Will always be a field or a full frame, never two fields.
-- 
Regards,

Laurent Pinchart

