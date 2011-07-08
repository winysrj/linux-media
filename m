Return-path: <mchehab@localhost>
Received: from tex.lwn.net ([70.33.254.29]:36257 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752146Ab1GHUwI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 8 Jul 2011 16:52:08 -0400
From: Jonathan Corbet <corbet@lwn.net>
To: linux-media@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Kassey Lee <ygli@marvell.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 3/6] marvell-cam: remove {min,max}_buffers parameters
Date: Fri,  8 Jul 2011 14:50:47 -0600
Message-Id: <1310158250-168899-4-git-send-email-corbet@lwn.net>
In-Reply-To: <1310158250-168899-1-git-send-email-corbet@lwn.net>
References: <1310158250-168899-1-git-send-email-corbet@lwn.net>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

Somewhere along the way the code stopped actually paying any attention to
them, and I doubt anybody has ever made use of them.

Signed-off-by: Jonathan Corbet <corbet@lwn.net>
---
 drivers/media/video/marvell-ccic/mcam-core.c |   13 -------------
 1 files changed, 0 insertions(+), 13 deletions(-)

diff --git a/drivers/media/video/marvell-ccic/mcam-core.c b/drivers/media/video/marvell-ccic/mcam-core.c
index 8a99ec2..9867b3b 100644
--- a/drivers/media/video/marvell-ccic/mcam-core.c
+++ b/drivers/media/video/marvell-ccic/mcam-core.c
@@ -72,19 +72,6 @@ MODULE_PARM_DESC(dma_buf_size,
 		"parameters require larger buffers, an attempt to reallocate "
 		"will be made.");
 
-static int min_buffers = 1;
-module_param(min_buffers, uint, 0644);
-MODULE_PARM_DESC(min_buffers,
-		"The minimum number of streaming I/O buffers we are willing "
-		"to work with.");
-
-static int max_buffers = 10;
-module_param(max_buffers, uint, 0644);
-MODULE_PARM_DESC(max_buffers,
-		"The maximum number of streaming I/O buffers an application "
-		"will be allowed to allocate.  These buffers are big and live "
-		"in vmalloc space.");
-
 static int flip;
 module_param(flip, bool, 0444);
 MODULE_PARM_DESC(flip,
-- 
1.7.6

