Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:42883 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756583AbcAJP7C (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jan 2016 10:59:02 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH] videobuf2-v4l2: Fix return with value warnings
Date: Sun, 10 Jan 2016 17:59:11 +0200
Message-Id: <1452441551-19426-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Commit 10cc3b1e1296 ("videobuf2-core: fill_user_buffer and
copy_timestamp should return void") forgot one return statement from the
videobuf2-v4l2 implementations of copy_timestamp and fill_user_buffer.
Remove them.

Fixes: 10cc3b1e1296 ("videobuf2-core: fill_user_buffer and copy_timestamp should return void")
Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/v4l2-core/videobuf2-v4l2.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-v4l2.c b/drivers/media/v4l2-core/videobuf2-v4l2.c
index a15cd1b4c7f0..bbbd8e1b1a99 100644
--- a/drivers/media/v4l2-core/videobuf2-v4l2.c
+++ b/drivers/media/v4l2-core/videobuf2-v4l2.c
@@ -121,7 +121,7 @@ static void __copy_timestamp(struct vb2_buffer *vb, const void *pb)
 	struct vb2_queue *q = vb->vb2_queue;
 
 	if (!pb)
-		return 0;
+		return;
 
 	if (q->is_output) {
 		/*
@@ -197,7 +197,7 @@ static void __fill_v4l2_buffer(struct vb2_buffer *vb, void *pb)
 	unsigned int plane;
 
 	if (!pb)
-		return 0;
+		return;
 
 	/* Copy back data such as timestamp, flags, etc. */
 	b->index = vb->index;
-- 
2.4.10

