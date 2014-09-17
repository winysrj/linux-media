Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:3089 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754687AbaIQJOz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Sep 2014 05:14:55 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 1/4] vb2: fix VBI regression
Date: Wed, 17 Sep 2014 11:14:29 +0200
Message-Id: <1410945272-48149-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1410945272-48149-1-git-send-email-hverkuil@xs4all.nl>
References: <1410945272-48149-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This patch brings the vb2 poll() behavior in line with vb1. The poll()
function is expected to return POLLERR if REQBUFS has been called, but
not yet STREAMON.

Various VBI capture applications (mtt, alevt) rely on that behavior,
and in fact the V4L2 Specification requires it as well.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Tested-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/videobuf2-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 7e6aff6..9fbf6b7 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -2586,7 +2586,7 @@ unsigned int vb2_poll(struct vb2_queue *q, struct file *file, poll_table *wait)
 	 * There is nothing to wait for if no buffer has been queued and the
 	 * queue isn't streaming, or if the error flag is set.
 	 */
-	if ((list_empty(&q->queued_list) && !vb2_is_streaming(q)) || q->error)
+	if (!vb2_is_streaming(q) || q->error)
 		return res | POLLERR;
 
 	/*
-- 
2.1.0

