Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:41308 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753676AbaIPALP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Sep 2014 20:11:15 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Pawel Osciak <pawel@osciak.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>
Subject: [PATCH] [media] BZ#84401: Revert "[media] v4l: vb2: Don't return POLLERR during transient buffer underruns"
Date: Mon, 15 Sep 2014 21:10:55 -0300
Message-Id: <1410826255-2025-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This reverts commit 9241650d62f79a3da01f1d5e8ebd195083330b75.

The commit 9241650d62f7 was meant to solve an issue with Gstreamer
version 0.10 with libv4l 1.2, where a fixup patch for DQBUF exposed
a bad behavior ag Gstreamer.

It does that by returning POLERR if VB2 is not streaming.

However, it broke VBI userspace support on alevt and mtt (and maybe
other VBI apps), as they rely on the old behavior.

Due to that, we need to roll back and restore the previous behavior.

It means that there are still some potential regressions by reverting it,
but those are known to occur only if:
	- libv4l is version 1.2 or upper (due to DQBUF fixup);
	- Gstreamer version 1.2 or before are being used, as this bug
got fixed on Gstreamer 1.4.

As both libv4l 1.2 and Gstreamer version 1.4 were released about the same
time, and the fix went only on Kernel 3.16 and were not backported to
stable, it is very unlikely that reverting it would cause much harm.

For more details, see:
	https://bugzilla.kernel.org/show_bug.cgi?id=84401

Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Pawel Osciak <pawel@osciak.com>
Cc: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/v4l2-core/videobuf2-core.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 7e6aff673a5a..7387821e7c72 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -2583,10 +2583,10 @@ unsigned int vb2_poll(struct vb2_queue *q, struct file *file, poll_table *wait)
 	}
 
 	/*
-	 * There is nothing to wait for if no buffer has been queued and the
-	 * queue isn't streaming, or if the error flag is set.
+	 * There is nothing to wait for if no buffer has been queued
+	 * or if the error flag is set.
 	 */
-	if ((list_empty(&q->queued_list) && !vb2_is_streaming(q)) || q->error)
+	if ((list_empty(&q->queued_list) || q->error)
 		return res | POLLERR;
 
 	/*
-- 
1.9.3

