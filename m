Return-path: <mchehab@pedra>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:64126 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751752Ab1CTXbj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 20 Mar 2011 19:31:39 -0400
Received: by iwn34 with SMTP id 34so5875650iwn.19
        for <linux-media@vger.kernel.org>; Sun, 20 Mar 2011 16:31:39 -0700 (PDT)
From: Pawel Osciak <pawel@osciak.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, Pawel Osciak <pawel@osciak.com>
Subject: [PATCH 2/2] [media] vb2: Handle return value from start_streaming callback
Date: Sun, 20 Mar 2011 16:31:16 -0700
Message-Id: <1300663876-24712-2-git-send-email-pawel@osciak.com>
In-Reply-To: <1300663876-24712-1-git-send-email-pawel@osciak.com>
References: <1300663876-24712-1-git-send-email-pawel@osciak.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Fix vb2 not handling return value from start_streaming() callback.

Signed-off-by: Pawel Osciak <pawel@osciak.com>
---
 drivers/media/video/videobuf2-core.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/media/video/videobuf2-core.c b/drivers/media/video/videobuf2-core.c
index 8c6f04b..6698c77 100644
--- a/drivers/media/video/videobuf2-core.c
+++ b/drivers/media/video/videobuf2-core.c
@@ -1111,6 +1111,7 @@ EXPORT_SYMBOL_GPL(vb2_dqbuf);
 int vb2_streamon(struct vb2_queue *q, enum v4l2_buf_type type)
 {
 	struct vb2_buffer *vb;
+	int ret;
 
 	if (q->fileio) {
 		dprintk(1, "streamon: file io in progress\n");
@@ -1138,12 +1139,16 @@ int vb2_streamon(struct vb2_queue *q, enum v4l2_buf_type type)
 		}
 	}
 
-	q->streaming = 1;
-
 	/*
 	 * Let driver notice that streaming state has been enabled.
 	 */
-	call_qop(q, start_streaming, q);
+	ret = call_qop(q, start_streaming, q);
+	if (ret) {
+		dprintk(1, "streamon: driver refused to start streaming\n");
+		return ret;
+	}
+
+	q->streaming = 1;
 
 	/*
 	 * If any buffers were queued before streamon,
-- 
1.7.4.1

