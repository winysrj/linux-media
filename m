Return-path: <mchehab@localhost>
Received: from tex.lwn.net ([70.33.254.29]:36246 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752530Ab1GHUwI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 8 Jul 2011 16:52:08 -0400
From: Jonathan Corbet <corbet@lwn.net>
To: linux-media@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Kassey Lee <ygli@marvell.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 1/6] marvell-cam: delete struct mcam_sio_buffer
Date: Fri,  8 Jul 2011 14:50:45 -0600
Message-Id: <1310158250-168899-2-git-send-email-corbet@lwn.net>
In-Reply-To: <1310158250-168899-1-git-send-email-corbet@lwn.net>
References: <1310158250-168899-1-git-send-email-corbet@lwn.net>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

This structure got passed over in the videobuf2 conversion; it has no
reason to exist now.

Signed-off-by: Jonathan Corbet <corbet@lwn.net>
---
 drivers/media/video/marvell-ccic/mcam-core.h |   11 -----------
 1 files changed, 0 insertions(+), 11 deletions(-)

diff --git a/drivers/media/video/marvell-ccic/mcam-core.h b/drivers/media/video/marvell-ccic/mcam-core.h
index 55fd078..9a39e08 100644
--- a/drivers/media/video/marvell-ccic/mcam-core.h
+++ b/drivers/media/video/marvell-ccic/mcam-core.h
@@ -11,17 +11,6 @@
 #include <media/v4l2-dev.h>
 #include <media/videobuf2-core.h>
 
-/*
- * Tracking of streaming I/O buffers.
- * FIXME doesn't belong in this file
- */
-struct mcam_sio_buffer {
-	struct list_head list;
-	struct v4l2_buffer v4lbuf;
-	char *buffer;   /* Where it lives in kernel space */
-	int mapcount;
-	struct mcam_camera *cam;
-};
 
 enum mcam_state {
 	S_NOTREADY,	/* Not yet initialized */
-- 
1.7.6

