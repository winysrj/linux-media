Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:56070 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1162039Ab2CPXgU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Mar 2012 19:36:20 -0400
From: Jonathan Corbet <corbet@lwn.net>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 2/7] marvell-cam: Remove broken "owner" logic
Date: Fri, 16 Mar 2012 17:14:51 -0600
Message-Id: <1331939696-12482-3-git-send-email-corbet@lwn.net>
In-Reply-To: <1331939696-12482-1-git-send-email-corbet@lwn.net>
References: <1331939696-12482-1-git-send-email-corbet@lwn.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The marvell cam driver retained just enough of the owner-tracking logic
from cafe_ccic to be broken; it could, conceivably, cause the driver to
release DMA memory while the controller is still active.  Simply remove the
remaining pieces and ensure that the controller is stopped before we free
things.

Signed-off-by: Jonathan Corbet <corbet@lwn.net>
---
 drivers/media/video/marvell-ccic/mcam-core.c |    5 +----
 drivers/media/video/marvell-ccic/mcam-core.h |    1 -
 2 files changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/media/video/marvell-ccic/mcam-core.c b/drivers/media/video/marvell-ccic/mcam-core.c
index 35cd89d..b261182 100644
--- a/drivers/media/video/marvell-ccic/mcam-core.c
+++ b/drivers/media/video/marvell-ccic/mcam-core.c
@@ -1564,11 +1564,8 @@ static int mcam_v4l_release(struct file *filp)
 			singles, delivered);
 	mutex_lock(&cam->s_mutex);
 	(cam->users)--;
-	if (filp == cam->owner) {
-		mcam_ctlr_stop_dma(cam);
-		cam->owner = NULL;
-	}
 	if (cam->users == 0) {
+		mcam_ctlr_stop_dma(cam);
 		mcam_cleanup_vb2(cam);
 		mcam_ctlr_power_down(cam);
 		if (cam->buffer_mode == B_vmalloc && alloc_bufs_at_read)
diff --git a/drivers/media/video/marvell-ccic/mcam-core.h b/drivers/media/video/marvell-ccic/mcam-core.h
index 917200e..bd6acba 100644
--- a/drivers/media/video/marvell-ccic/mcam-core.h
+++ b/drivers/media/video/marvell-ccic/mcam-core.h
@@ -107,7 +107,6 @@ struct mcam_camera {
 	enum mcam_state state;
 	unsigned long flags;		/* Buffer status, mainly (dev_lock) */
 	int users;			/* How many open FDs */
-	struct file *owner;		/* Who has data access (v4l2) */
 
 	/*
 	 * Subsystem structures.
-- 
1.7.9.3

