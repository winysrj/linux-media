Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:40390 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755414AbaLHQYM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 8 Dec 2014 11:24:12 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv2 for v3.19 2/2] cx88: remove leftover start_video_dma() call
Date: Mon,  8 Dec 2014 17:23:50 +0100
Message-Id: <1418055830-12687-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1418055830-12687-1-git-send-email-hverkuil@xs4all.nl>
References: <1418055830-12687-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The start_streaming op is responsible for starting the video dma,
so it shouldn't be called anymore from the buf_queue op.

Unfortunately, this call to start_video_dma() was added to the
start_streaming op, but was forgotten to be removed from the
buf_queue op, which is where it used to be before the vb2 conversion.

Calling this function twice causes very hard to find errors: sometimes
it works, sometimes it doesn't. It took me a whole friggin' day
to track this down, and in the end it was just luck that my eye suddenly
triggered on that line.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/cx88/cx88-video.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/pci/cx88/cx88-video.c b/drivers/media/pci/cx88/cx88-video.c
index 25a4b7f31..860c98fc 100644
--- a/drivers/media/pci/cx88/cx88-video.c
+++ b/drivers/media/pci/cx88/cx88-video.c
@@ -523,7 +523,6 @@ static void buffer_queue(struct vb2_buffer *vb)
 
 	if (list_empty(&q->active)) {
 		list_add_tail(&buf->list, &q->active);
-		start_video_dma(dev, q, buf);
 		buf->count    = q->count++;
 		dprintk(2,"[%p/%d] buffer_queue - first active\n",
 			buf, buf->vb.v4l2_buf.index);
-- 
2.1.0

