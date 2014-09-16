Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-1.cisco.com ([173.38.203.51]:17571 "EHLO
	aer-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752825AbaIPK2y (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Sep 2014 06:28:54 -0400
Message-ID: <541810E2.4040509@cisco.com>
Date: Tue, 16 Sep 2014 12:28:50 +0200
From: Hans Verkuil <hansverk@cisco.com>
MIME-Version: 1.0
To: linux-media <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Pawel Osciak <pawel@osciak.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>
Subject: [RFC PATCH] vb2: regression fix for vbi capture & poll
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

(My proposal to fix this. Note that it is untested, I plan to do that this
evening)

Commit 9241650d62f7 broke vbi capture applications that expect POLLERR to be
returned if STREAMON wasn't called.

Rather than checking whether buffers were queued AND vb2 was not yet streaming,
just check whether streaming is in progress and return POLLERR if not.

This change makes it impossible to poll in one thread and call STREAMON in
another, but doing that breaks existing applications and is also not according
to the spec. So be it.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 7e6aff6..0452fb2 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -2583,10 +2583,10 @@ unsigned int vb2_poll(struct vb2_queue *q, struct file *file, poll_table *wait)
 	}
 
 	/*
-	 * There is nothing to wait for if no buffer has been queued and the
-	 * queue isn't streaming, or if the error flag is set.
+	 * There is nothing to wait for if the queue isn't streaming, or if
+	 * the error flag is set.
 	 */
-	if ((list_empty(&q->queued_list) && !vb2_is_streaming(q)) || q->error)
+	if (!vb2_is_streaming(q) || q->error)
 		return res | POLLERR;
 
 	/*
