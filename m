Return-path: <mchehab@pedra>
Received: from tex.lwn.net ([70.33.254.29]:57316 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751352Ab1FTTPF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jun 2011 15:15:05 -0400
From: Jonathan Corbet <corbet@lwn.net>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, Kassey Lee <ygli@marvell.com>,
	Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 3/5] marvell-cam: no need to initialize the DMA buffers
Date: Mon, 20 Jun 2011 13:14:38 -0600
Message-Id: <1308597280-138673-4-git-send-email-corbet@lwn.net>
In-Reply-To: <1308597280-138673-1-git-send-email-corbet@lwn.net>
References: <1308597280-138673-1-git-send-email-corbet@lwn.net>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This was an old debugging thing from years ago.  It's only done at
initialization time, but it's still unnecessary; take it out.

Signed-off-by: Jonathan Corbet <corbet@lwn.net>
---
 drivers/media/video/marvell-ccic/mcam-core.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/marvell-ccic/mcam-core.c b/drivers/media/video/marvell-ccic/mcam-core.c
index 65d9c0f..da7ec2f 100644
--- a/drivers/media/video/marvell-ccic/mcam-core.c
+++ b/drivers/media/video/marvell-ccic/mcam-core.c
@@ -499,8 +499,6 @@ static int mcam_alloc_dma_bufs(struct mcam_camera *cam, int loadtime)
 			cam_warn(cam, "Failed to allocate DMA buffer\n");
 			break;
 		}
-		/* For debug, remove eventually */
-		memset(cam->dma_bufs[i], 0xcc, cam->dma_buf_size);
 		(cam->nbufs)++;
 	}
 
-- 
1.7.5.4

