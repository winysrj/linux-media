Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:3452 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827AbaHDFhE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Aug 2014 01:37:04 -0400
Message-ID: <53DF1BEF.6030904@xs4all.nl>
Date: Mon, 04 Aug 2014 07:36:47 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH for v3.17] videobuf2-core: add comments before the WARN_ON
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Recently WARN_ON() calls have been added to warn if the driver is not
properly returning buffers to vb2 in start_streaming (if it fails) or
stop_streaming(). Add comments before those WARN_ON calls that refer
to the videobuf2-core.h header that explains what drivers are supposed
to do in these situations. That should help point developers in the
right direction if they see these warnings.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/videobuf2-core.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index c359006..d3f2a22 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -1762,6 +1762,12 @@ static int vb2_start_streaming(struct vb2_queue *q)
 	q->start_streaming_called = 0;
 
 	dprintk(1, "driver refused to start streaming\n");
+	/*
+	 * If you see this warning, then the driver isn't cleaning up properly
+	 * after a failed start_streaming(). See the start_streaming()
+	 * documentation in videobuf2-core.h for more information how buffers
+	 * should be returned to vb2 in start_streaming().
+	 */
 	if (WARN_ON(atomic_read(&q->owned_by_drv_count))) {
 		unsigned i;
 
@@ -2123,6 +2129,12 @@ static void __vb2_queue_cancel(struct vb2_queue *q)
 	if (q->start_streaming_called)
 		call_void_qop(q, stop_streaming, q);
 
+	/*
+	 * If you see this warning, then the driver isn't cleaning up properly
+	 * in stop_streaming(). See the stop_streaming() documentation in
+	 * videobuf2-core.h for more information how buffers should be returned
+	 * to vb2 in stop_streaming().
+	 */
 	if (WARN_ON(atomic_read(&q->owned_by_drv_count))) {
 		for (i = 0; i < q->num_buffers; ++i)
 			if (q->bufs[i]->state == VB2_BUF_STATE_ACTIVE)
-- 
2.0.1

