Return-path: <mchehab@pedra>
Received: from tex.lwn.net ([70.33.254.29]:57320 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754631Ab1FTTPF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jun 2011 15:15:05 -0400
From: Jonathan Corbet <corbet@lwn.net>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, Kassey Lee <ygli@marvell.com>,
	Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 4/5] marvell-cam: Don't spam the logs on frame loss
Date: Mon, 20 Jun 2011 13:14:39 -0600
Message-Id: <1308597280-138673-5-git-send-email-corbet@lwn.net>
In-Reply-To: <1308597280-138673-1-git-send-email-corbet@lwn.net>
References: <1308597280-138673-1-git-send-email-corbet@lwn.net>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The sequence numbers already give that information if user space cares;
this is a frequent occurrence on slower machines, alas.

Signed-off-by: Jonathan Corbet <corbet@lwn.net>
---
 drivers/media/video/marvell-ccic/mcam-core.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/marvell-ccic/mcam-core.c b/drivers/media/video/marvell-ccic/mcam-core.c
index da7ec2f..ca3c56f 100644
--- a/drivers/media/video/marvell-ccic/mcam-core.c
+++ b/drivers/media/video/marvell-ccic/mcam-core.c
@@ -1263,8 +1263,6 @@ static void mcam_frame_complete(struct mcam_camera *cam, int frame)
 	/*
 	 * Basic frame housekeeping.
 	 */
-	if (test_bit(frame, &cam->flags) && printk_ratelimit())
-		cam_err(cam, "Frame overrun on %d, frames lost\n", frame);
 	set_bit(frame, &cam->flags);
 	clear_bit(CF_DMA_ACTIVE, &cam->flags);
 	if (cam->next_buf < 0)
-- 
1.7.5.4

