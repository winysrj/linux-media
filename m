Return-path: <linux-media-owner@vger.kernel.org>
Received: from butterbrot.org ([176.9.106.16]:33098 "EHLO butterbrot.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752548AbbEYME3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 25 May 2015 08:04:29 -0400
From: Florian Echtler <floe@butterbrot.org>
To: hans.verkuil@cisco.com, mchehab@osg.samsung.com
Cc: linux-media@vger.kernel.org, modin@yuri.at,
	Florian Echtler <floe@butterbrot.org>
Subject: [PATCHv2 4/4] return BUF_STATE_ERROR if streaming stopped during acquisition
Date: Mon, 25 May 2015 14:04:16 +0200
Message-Id: <1432555456-20292-5-git-send-email-floe@butterbrot.org>
In-Reply-To: <1432555456-20292-1-git-send-email-floe@butterbrot.org>
References: <1432555456-20292-1-git-send-email-floe@butterbrot.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When stop_streaming is called while a frame is currently being retrieved, the
buffer being filled will still be returned with BUF_STATE_DONE. By resetting
the sequence number and checking before returning the buffer, it can now
correctly be returned with BUF_STATE_ERROR.

Signed-off-by: Martin Kaltenbrunner <modin@yuri.at>
Signed-off-by: Florian Echtler <floe@butterbrot.org>
---
 drivers/input/touchscreen/sur40.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/input/touchscreen/sur40.c b/drivers/input/touchscreen/sur40.c
index 8add986..8be7b9b 100644
--- a/drivers/input/touchscreen/sur40.c
+++ b/drivers/input/touchscreen/sur40.c
@@ -438,6 +438,10 @@ static void sur40_process_video(struct sur40_state *sur40)
 
 	dev_dbg(sur40->dev, "image acquired\n");
 
+	/* return error if streaming was stopped in the meantime */
+	if (sur40->sequence == -1)
+		goto err_poll;
+
 	/* mark as finished */
 	v4l2_get_timestamp(&new_buf->vb.v4l2_buf.timestamp);
 	new_buf->vb.v4l2_buf.sequence = sur40->sequence++;
@@ -723,6 +727,7 @@ static int sur40_start_streaming(struct vb2_queue *vq, unsigned int count)
 static void sur40_stop_streaming(struct vb2_queue *vq)
 {
 	struct sur40_state *sur40 = vb2_get_drv_priv(vq);
+	sur40->sequence = -1;
 
 	/* Release all active buffers */
 	return_all_buffers(sur40, VB2_BUF_STATE_ERROR);
-- 
1.9.1

