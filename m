Return-path: <mchehab@pedra>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51910 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480Ab1CTXbh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 20 Mar 2011 19:31:37 -0400
Received: by iyb26 with SMTP id 26so5871761iyb.19
        for <linux-media@vger.kernel.org>; Sun, 20 Mar 2011 16:31:36 -0700 (PDT)
From: Pawel Osciak <pawel@osciak.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, Pawel Osciak <pawel@osciak.com>
Subject: [PATCH 1/2] [media] vb2: vb2_poll() fix return values for file I/O mode
Date: Sun, 20 Mar 2011 16:31:15 -0700
Message-Id: <1300663876-24712-1-git-send-email-pawel@osciak.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

poll() should be returning poll-specific error values, not E* errors.

Signed-off-by: Pawel Osciak <pawel@osciak.com>
---
 drivers/media/video/videobuf2-core.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/video/videobuf2-core.c b/drivers/media/video/videobuf2-core.c
index ce03225..8c6f04b 100644
--- a/drivers/media/video/videobuf2-core.c
+++ b/drivers/media/video/videobuf2-core.c
@@ -1364,18 +1364,18 @@ unsigned int vb2_poll(struct vb2_queue *q, struct file *file, poll_table *wait)
 	struct vb2_buffer *vb = NULL;
 
 	/*
-	 * Start file io emulator if streaming api has not been used yet.
+	 * Start file I/O emulator only if streaming API has not been used yet.
 	 */
 	if (q->num_buffers == 0 && q->fileio == NULL) {
 		if (!V4L2_TYPE_IS_OUTPUT(q->type) && (q->io_modes & VB2_READ)) {
 			ret = __vb2_init_fileio(q, 1);
 			if (ret)
-				return ret;
+				return POLLERR;
 		}
 		if (V4L2_TYPE_IS_OUTPUT(q->type) && (q->io_modes & VB2_WRITE)) {
 			ret = __vb2_init_fileio(q, 0);
 			if (ret)
-				return ret;
+				return POLLERR;
 			/*
 			 * Write to OUTPUT queue can be done immediately.
 			 */
-- 
1.7.4.1

