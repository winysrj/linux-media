Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55614 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751019Ab1L3SNp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Dec 2011 13:13:45 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Pawel Osciak <pawel@osciak.com>
Subject: [PATCH] [media] videobuf2-core: fix a warning at vb2
Date: Fri, 30 Dec 2011 16:13:26 -0200
Message-Id: <1325268806-27148-1-git-send-email-mchehab@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It seems that a cut-and-past error were added by the last patch:

drivers/media/video/videobuf2-core.c: In function ‘vb2_qbuf’:
drivers/media/video/videobuf2-core.c:1099:14: warning: comparison between ‘enum v4l2_buf_type’ and ‘enum v4l2_memory’ [-Wenum-compare]

On all places V4L2_MEMORY_USERPTR is used, it is associated with
q->memory, and not b->type. So, the fix seems obvious.

Cc: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Pawel Osciak <pawel@osciak.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/video/videobuf2-core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/videobuf2-core.c b/drivers/media/video/videobuf2-core.c
index 26cfbf5..2e8f1df 100644
--- a/drivers/media/video/videobuf2-core.c
+++ b/drivers/media/video/videobuf2-core.c
@@ -1096,7 +1096,7 @@ int vb2_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
 	 * beggining of qbuf processing. This way the queue status is
 	 * consistent after getting driver's lock back.
 	 */
-	if (b->type == V4L2_MEMORY_USERPTR) {
+	if (q->memory == V4L2_MEMORY_USERPTR) {
 		mmap_sem = &current->mm->mmap_sem;
 		call_qop(q, wait_prepare, q);
 		down_read(mmap_sem);
-- 
1.7.8.352.g876a6

