Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail2.matrix-vision.com ([85.214.244.251]:40050 "EHLO
	mail2.matrix-vision.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756584Ab2F0POV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Jun 2012 11:14:21 -0400
From: Michael Jones <michael.jones@matrix-vision.de>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [PATCH] [media] omap3isp: fix dqbuf description comment
Date: Wed, 27 Jun 2012 17:06:57 +0200
Message-Id: <1340809617-5914-1-git-send-email-michael.jones@matrix-vision.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Signed-off-by: Michael Jones <michael.jones@matrix-vision.de>
---
 drivers/media/video/omap3isp/ispqueue.c |    9 ++-------
 1 files changed, 2 insertions(+), 7 deletions(-)

This comment looks like it was a copy-paste from the description of qbuf.

diff --git a/drivers/media/video/omap3isp/ispqueue.c b/drivers/media/video/omap3isp/ispqueue.c
index 5fda5d0..23915ce 100644
--- a/drivers/media/video/omap3isp/ispqueue.c
+++ b/drivers/media/video/omap3isp/ispqueue.c
@@ -908,13 +908,8 @@ done:
  *
  * This function is intended to be used as a VIDIOC_DQBUF ioctl handler.
  *
- * The v4l2_buffer structure passed from userspace is first sanity tested. If
- * sane, the buffer is then processed and added to the main queue and, if the
- * queue is streaming, to the IRQ queue.
- *
- * Before being enqueued, USERPTR buffers are checked for address changes. If
- * the buffer has a different userspace address, the old memory area is unlocked
- * and the new memory area is locked.
+ * if nonblocking=1, returns -EAGAIN if no buffer is available.
+ * if nonblocking=0, waits on IRQ queue until a buffer becomes available.
  */
 int omap3isp_video_queue_dqbuf(struct isp_video_queue *queue,
 			       struct v4l2_buffer *vbuf, int nonblocking)
-- 
1.7.4.1


MATRIX VISION GmbH, Talstrasse 16, DE-71570 Oppenweiler
Registergericht: Amtsgericht Stuttgart, HRB 271090
Geschaeftsfuehrer: Gerhard Thullner, Werner Armingeon, Uwe Furtner, Erhard Meier
