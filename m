Return-path: <mchehab@pedra>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48497 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500Ab1FHUBF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Jun 2011 16:01:05 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?=
	<u.kleine-koenig@pengutronix.de>
To: linux-media@vger.kernel.org
Date: Wed,  8 Jun 2011 22:00:49 +0200
Message-Id: <1307563249-4700-1-git-send-email-u.kleine-koenig@pengutronix.de>
In-Reply-To: <1307525477-18491-1-git-send-email-u.kleine-koenig@pengutronix.de>
References: <1307525477-18491-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: [PATCH] Don't shortcut vb2_reqbufs in case the format changed
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Just checking for number of buffers and memory access method isn't
enough because the format might have changed since the buffers were
allocated and the new format might need bigger ones.

This reverts commit 31901a078af29c33c736dcbf815656920e904632.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
Hello,

I resend, because the original post didn't made it into patchwork. (The
web interface showed a database error around that time.)
And please note that my name is still wrong in patchwork.

Best regards
Uwe

 drivers/media/video/videobuf2-core.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/drivers/media/video/videobuf2-core.c b/drivers/media/video/videobuf2-core.c
index 6ba1461..6489aa2 100644
--- a/drivers/media/video/videobuf2-core.c
+++ b/drivers/media/video/videobuf2-core.c
@@ -492,13 +492,6 @@ int vb2_reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req)
 		return -EINVAL;
 	}
 
-	/*
-	 * If the same number of buffers and memory access method is requested
-	 * then return immediately.
-	 */
-	if (q->memory == req->memory && req->count == q->num_buffers)
-		return 0;
-
 	if (req->count == 0 || q->num_buffers != 0 || q->memory != req->memory) {
 		/*
 		 * We already have buffers allocated, so first check if they
-- 
1.7.5.3

