Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail2.matrix-vision.com ([85.214.244.251]:45089 "EHLO
	mail2.matrix-vision.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114Ab1HIGnV (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Aug 2011 02:43:21 -0400
From: Michael Jones <michael.jones@matrix-vision.de>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v2] [media] omap3isp: queue: fail QBUF if user buffer is too small
Date: Tue,  9 Aug 2011 08:42:20 +0200
Message-Id: <1312872140-7517-1-git-send-email-michael.jones@matrix-vision.de>
In-Reply-To: <1312472437-26231-1-git-send-email-michael.jones@matrix-vision.de>
References: <1312472437-26231-1-git-send-email-michael.jones@matrix-vision.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add buffer length check to sanity checks for USERPTR QBUF

Signed-off-by: Michael Jones <michael.jones@matrix-vision.de>
---
Changes for v2:
 - only check when V4L2_MEMORY_USERPTR

 drivers/media/video/omap3isp/ispqueue.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/omap3isp/ispqueue.c b/drivers/media/video/omap3isp/ispqueue.c
index 9c31714..9bebb1e 100644
--- a/drivers/media/video/omap3isp/ispqueue.c
+++ b/drivers/media/video/omap3isp/ispqueue.c
@@ -868,6 +868,10 @@ int omap3isp_video_queue_qbuf(struct isp_video_queue *queue,
 		goto done;
 
 	if (vbuf->memory == V4L2_MEMORY_USERPTR &&
+	    vbuf->length < buf->vbuf.length)
+		goto done;
+
+	if (vbuf->memory == V4L2_MEMORY_USERPTR &&
 	    vbuf->m.userptr != buf->vbuf.m.userptr) {
 		isp_video_buffer_cleanup(buf);
 		buf->vbuf.m.userptr = vbuf->m.userptr;
-- 
1.7.6


MATRIX VISION GmbH, Talstrasse 16, DE-71570 Oppenweiler
Registergericht: Amtsgericht Stuttgart, HRB 271090
Geschaeftsfuehrer: Gerhard Thullner, Werner Armingeon, Uwe Furtner, Erhard Meier
