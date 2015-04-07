Return-path: <linux-media-owner@vger.kernel.org>
Received: from andre.telenet-ops.be ([195.130.132.53]:50331 "EHLO
	andre.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754393AbbDGNrt (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Apr 2015 09:47:49 -0400
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Hans Verkuil <hans.verkuil@cisco.com>,
	Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH] [media] vb2: Remove unused variable fileio in vb2_thread_stop()
Date: Tue,  7 Apr 2015 15:47:50 +0200
Message-Id: <1428414470-29114-1-git-send-email-geert+renesas@glider.be>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/v4l2-core/videobuf2-core.c: In function 'vb2_thread_stop':
drivers/media/v4l2-core/videobuf2-core.c:3228:26: warning: unused variable 'fileio' [-Wunused-variable]

Fixes: 0e661006370b7e7f ("[media] vb2: fix 'UNBALANCED' warnings when calling vb2_thread_stop()")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 drivers/media/v4l2-core/videobuf2-core.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index cc16e76a24933c41..471b171cec3dabfa 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -3225,7 +3225,6 @@ EXPORT_SYMBOL_GPL(vb2_thread_start);
 int vb2_thread_stop(struct vb2_queue *q)
 {
 	struct vb2_threadio_data *threadio = q->threadio;
-	struct vb2_fileio_data *fileio = q->fileio;
 	int err;
 
 	if (threadio == NULL)
-- 
1.9.1

