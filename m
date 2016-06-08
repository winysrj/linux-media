Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:43858 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756448AbcFHX6W (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Jun 2016 19:58:22 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org
Subject: [PATCH 1/5] v4l: vsp1: pipe: Fix typo in comment
Date: Thu,  9 Jun 2016 02:58:12 +0300
Message-Id: <1465430296-22644-2-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1465430296-22644-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1465430296-22644-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The vsp1_pipeline wq field is a wait queue, not a work queue. Fix the
comment accordingly.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_pipe.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/vsp1/vsp1_pipe.h b/drivers/media/platform/vsp1/vsp1_pipe.h
index 3ecd3c1794a9..2cbf1a5ea1fb 100644
--- a/drivers/media/platform/vsp1/vsp1_pipe.h
+++ b/drivers/media/platform/vsp1/vsp1_pipe.h
@@ -61,7 +61,7 @@ enum vsp1_pipeline_state {
  * @pipe: the media pipeline
  * @irqlock: protects the pipeline state
  * @state: current state
- * @wq: work queue to wait for state change completion
+ * @wq: wait queue to wait for state change completion
  * @frame_end: frame end interrupt handler
  * @lock: protects the pipeline use count and stream count
  * @kref: pipeline reference count
-- 
Regards,

Laurent Pinchart

