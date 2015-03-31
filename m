Return-path: <linux-media-owner@vger.kernel.org>
Received: from butterbrot.org ([176.9.106.16]:50377 "EHLO butterbrot.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750962AbbCaJnf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 31 Mar 2015 05:43:35 -0400
From: Florian Echtler <floe@butterbrot.org>
To: hverkuil@xs4all.nl, m.chehab@samsung.com
Cc: laurent.pinchart@ideasonboard.com, linux-input@vger.kernel.org,
	linux-media@vger.kernel.org, Florian Echtler <floe@butterbrot.org>
Subject: [PATCH] sur40: fix occasional hard freeze due to buffer queue underrun
Date: Tue, 31 Mar 2015 11:43:28 +0200
Message-Id: <1427795008-10385-1-git-send-email-floe@butterbrot.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch fixes a kernel panic which occurs when buf_list is empty. This can
happen occasionally when user space is under heavy load (e.g. due to image 
processing on the CPU) and new buffers aren't re-queued fast enough. In that 
case, vb2_start_streaming_called can return true, but when the spinlock
is taken and sur40_poll attempts to fetch the next buffer from buf_list, the 
list is in fact empty.

This patch needs to be applied on top of the queued one adding V4L2 support 
to the sur40 driver.

Signed-off-by: Florian Echtler <floe@butterbrot.org>
---
 drivers/input/touchscreen/sur40.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/input/touchscreen/sur40.c b/drivers/input/touchscreen/sur40.c
index 1e7dacf..d618514 100644
--- a/drivers/input/touchscreen/sur40.c
+++ b/drivers/input/touchscreen/sur40.c
@@ -380,6 +380,11 @@ static void sur40_process_video(struct sur40_state *sur40)
 
 	/* get a new buffer from the list */
 	spin_lock(&sur40->qlock);
+	if (list_empty(&sur40->buf_list)) {
+		dev_dbg(sur40->dev, "buffer queue empty\n");
+		spin_unlock(&sur40->qlock);
+		return;
+	}
 	new_buf = list_entry(sur40->buf_list.next, struct sur40_buffer, list);
 	list_del(&new_buf->list);
 	spin_unlock(&sur40->qlock);
-- 
1.9.1

