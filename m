Return-path: <linux-media-owner@vger.kernel.org>
Received: from butterbrot.org ([176.9.106.16]:37635 "EHLO butterbrot.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753522AbcEMW1l (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 13 May 2016 18:27:41 -0400
From: Florian Echtler <floe@butterbrot.org>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, Florian Echtler <floe@butterbrot.org>,
	Martin Kaltenbrunner <modin@yuri.at>
Subject: [PATCH 3/3] fix occasional oopses on device close
Date: Fri, 13 May 2016 15:19:17 -0700
Message-Id: <1463177957-8240-3-git-send-email-floe@butterbrot.org>
In-Reply-To: <1463177957-8240-1-git-send-email-floe@butterbrot.org>
References: <1463177957-8240-1-git-send-email-floe@butterbrot.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Closing the V4L2 device sometimes triggers a kernel oops.
Present patch fixes this.

Signed-off-by: Martin Kaltenbrunner <modin@yuri.at>
Signed-off-by: Florian Echtler <floe@butterbrot.org>
---
 drivers/input/touchscreen/sur40.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/input/touchscreen/sur40.c b/drivers/input/touchscreen/sur40.c
index 7b1052a1..38ebb24 100644
--- a/drivers/input/touchscreen/sur40.c
+++ b/drivers/input/touchscreen/sur40.c
@@ -448,7 +448,7 @@ static void sur40_process_video(struct sur40_state *sur40)
 
 	/* return error if streaming was stopped in the meantime */
 	if (sur40->sequence == -1)
-		goto err_poll;
+		return;
 
 	/* mark as finished */
 	new_buf->vb.vb2_buf.timestamp = ktime_get_ns();
@@ -736,6 +736,7 @@ static int sur40_start_streaming(struct vb2_queue *vq, unsigned int count)
 static void sur40_stop_streaming(struct vb2_queue *vq)
 {
 	struct sur40_state *sur40 = vb2_get_drv_priv(vq);
+	vb2_wait_for_all_buffers(vq);
 	sur40->sequence = -1;
 
 	/* Release all active buffers */
-- 
1.9.1

