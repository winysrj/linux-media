Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr19.xs4all.nl ([194.109.24.39]:1080 "EHLO
	smtp-vbr19.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752659Ab3DJLP7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Apr 2013 07:15:59 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 2/2] dt3155v4l: fix timestamp handling.
Date: Wed, 10 Apr 2013 13:15:47 +0200
Message-Id: <1365592547-21951-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1365592547-21951-1-git-send-email-hverkuil@xs4all.nl>
References: <1365592547-21951-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Use the monotonic clock and set the timestamp_type that vb2 expects.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/staging/media/dt3155v4l/dt3155v4l.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/media/dt3155v4l/dt3155v4l.c b/drivers/staging/media/dt3155v4l/dt3155v4l.c
index 57fadea..c32e0ac 100644
--- a/drivers/staging/media/dt3155v4l/dt3155v4l.c
+++ b/drivers/staging/media/dt3155v4l/dt3155v4l.c
@@ -26,6 +26,7 @@
 #include <linux/slab.h>
 #include <media/v4l2-dev.h>
 #include <media/v4l2-ioctl.h>
+#include <media/v4l2-common.h>
 #include <media/videobuf2-dma-contig.h>
 
 #include "dt3155v4l.h"
@@ -341,7 +342,7 @@ dt3155_irq_handler_even(int irq, void *dev_id)
 
 	spin_lock(&ipd->lock);
 	if (ipd->curr_buf) {
-		do_gettimeofday(&ipd->curr_buf->v4l2_buf.timestamp);
+		v4l2_get_timestamp(&ipd->curr_buf->v4l2_buf.timestamp);
 		ipd->curr_buf->v4l2_buf.sequence = (ipd->field_count) >> 1;
 		vb2_buffer_done(ipd->curr_buf, VB2_BUF_STATE_DONE);
 	}
@@ -390,6 +391,7 @@ dt3155_open(struct file *filp)
 			goto err_alloc_queue;
 		}
 		pd->q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+		pd->q->timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
 		pd->q->io_modes = VB2_READ | VB2_MMAP;
 		pd->q->ops = &q_ops;
 		pd->q->mem_ops = &vb2_dma_contig_memops;
-- 
1.7.10.4

