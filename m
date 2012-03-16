Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:56074 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1162042Ab2CPXgU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Mar 2012 19:36:20 -0400
From: Jonathan Corbet <corbet@lwn.net>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 5/7] marvell-cam: Don't signal multiple frame completions in scatter/gather mode
Date: Fri, 16 Mar 2012 17:14:54 -0600
Message-Id: <1331939696-12482-6-git-send-email-corbet@lwn.net>
In-Reply-To: <1331939696-12482-1-git-send-email-corbet@lwn.net>
References: <1331939696-12482-1-git-send-email-corbet@lwn.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There is only one frame known to the DMA engine in scatter/gather mode, but
it still tells us that any or all of frames 1-3 are done at each completion
interrupt.  Avoid the creation of junk frames by being sure to only
"complete" one on each interrupt.

Signed-off-by: Jonathan Corbet <corbet@lwn.net>
---
 drivers/media/video/marvell-ccic/mcam-core.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/video/marvell-ccic/mcam-core.c b/drivers/media/video/marvell-ccic/mcam-core.c
index e46a72a..036db27 100644
--- a/drivers/media/video/marvell-ccic/mcam-core.c
+++ b/drivers/media/video/marvell-ccic/mcam-core.c
@@ -1697,6 +1697,8 @@ int mccic_irq(struct mcam_camera *cam, unsigned int irqs)
 		if (irqs & (IRQ_EOF0 << frame)) {
 			mcam_frame_complete(cam, frame);
 			handled = 1;
+			if (cam->buffer_mode == B_DMA_sg)
+				break;
 		}
 	/*
 	 * If a frame starts, note that we have DMA active.  This
-- 
1.7.9.3

