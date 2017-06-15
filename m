Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:35691 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751908AbdFOIX6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Jun 2017 04:23:58 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org
Subject: [PATCH 5/6] v4l: vsp1: Fill display list headers without holding dlm spinlock
Date: Thu, 15 Jun 2017 11:24:08 +0300
Message-Id: <20170615082409.9523-6-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <20170615082409.9523-1-laurent.pinchart+renesas@ideasonboard.com>
References: <20170615082409.9523-1-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The display list headers are filled using information from the display
list only. Lower the display list manager spinlock contention by filling
the headers without holding the lock.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_dl.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_dl.c b/drivers/media/platform/vsp1/vsp1_dl.c
index 7d8f37772b56..534100581404 100644
--- a/drivers/media/platform/vsp1/vsp1_dl.c
+++ b/drivers/media/platform/vsp1/vsp1_dl.c
@@ -483,8 +483,6 @@ void vsp1_dl_list_commit(struct vsp1_dl_list *dl)
 	unsigned long flags;
 	bool update;
 
-	spin_lock_irqsave(&dlm->lock, flags);
-
 	if (dl->dlm->mode == VSP1_DL_MODE_HEADER) {
 		struct vsp1_dl_list *dl_child;
 
@@ -501,7 +499,11 @@ void vsp1_dl_list_commit(struct vsp1_dl_list *dl)
 
 			vsp1_dl_list_fill_header(dl_child, last);
 		}
+	}
 
+	spin_lock_irqsave(&dlm->lock, flags);
+
+	if (dl->dlm->mode == VSP1_DL_MODE_HEADER) {
 		/*
 		 * Commit the head display list to hardware. Chained headers
 		 * will auto-start.
-- 
Regards,

Laurent Pinchart
