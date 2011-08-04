Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.matrix-vision.com ([78.47.19.71]:40504 "EHLO
	mail1.matrix-vision.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751766Ab1HDPlO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Aug 2011 11:41:14 -0400
From: Michael Jones <michael.jones@matrix-vision.de>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] [media] omap3isp: queue: fail QBUF if buffer is too small
Date: Thu,  4 Aug 2011 17:40:37 +0200
Message-Id: <1312472437-26231-1-git-send-email-michael.jones@matrix-vision.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add buffer length to sanity checks for QBUF.

Signed-off-by: Michael Jones <michael.jones@matrix-vision.de>
---
 drivers/media/video/omap3isp/ispqueue.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/omap3isp/ispqueue.c b/drivers/media/video/omap3isp/ispqueue.c
index 9c31714..4f6876f 100644
--- a/drivers/media/video/omap3isp/ispqueue.c
+++ b/drivers/media/video/omap3isp/ispqueue.c
@@ -867,6 +867,9 @@ int omap3isp_video_queue_qbuf(struct isp_video_queue *queue,
 	if (buf->state != ISP_BUF_STATE_IDLE)
 		goto done;
 
+	if (vbuf->length < buf->vbuf.length)
+		goto done;
+
 	if (vbuf->memory == V4L2_MEMORY_USERPTR &&
 	    vbuf->m.userptr != buf->vbuf.m.userptr) {
 		isp_video_buffer_cleanup(buf);
-- 
1.7.6


MATRIX VISION GmbH, Talstrasse 16, DE-71570 Oppenweiler
Registergericht: Amtsgericht Stuttgart, HRB 271090
Geschaeftsfuehrer: Gerhard Thullner, Werner Armingeon, Uwe Furtner, Erhard Meier
