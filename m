Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:59575 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751316AbaHYRMP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Aug 2014 13:12:15 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 01/12] airspy: fix error handling on start streaming
Date: Mon, 25 Aug 2014 20:11:47 +0300
Message-Id: <1408986718-3881-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Free all reserved USB buffers and URBs on failure. Return all queued
buffers to vb2 with state queued on error case.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/airspy/airspy.c | 36 +++++++++++++++++++++++++++++-------
 1 file changed, 29 insertions(+), 7 deletions(-)

diff --git a/drivers/media/usb/airspy/airspy.c b/drivers/media/usb/airspy/airspy.c
index cb0e515..56a1ae0 100644
--- a/drivers/media/usb/airspy/airspy.c
+++ b/drivers/media/usb/airspy/airspy.c
@@ -540,27 +540,49 @@ static int airspy_start_streaming(struct vb2_queue *vq, unsigned int count)
 
 	mutex_lock(&s->v4l2_lock);
 
-	set_bit(POWER_ON, &s->flags);
-
 	s->sequence = 0;
 
+	set_bit(POWER_ON, &s->flags);
+
 	ret = airspy_alloc_stream_bufs(s);
 	if (ret)
-		goto err;
+		goto err_clear_bit;
 
 	ret = airspy_alloc_urbs(s);
 	if (ret)
-		goto err;
+		goto err_free_stream_bufs;
 
 	ret = airspy_submit_urbs(s);
 	if (ret)
-		goto err;
+		goto err_free_urbs;
 
 	/* start hardware streaming */
 	ret = airspy_ctrl_msg(s, CMD_RECEIVER_MODE, 1, 0, NULL, 0);
 	if (ret)
-		goto err;
-err:
+		goto err_kill_urbs;
+
+	goto exit_mutex_unlock;
+
+err_kill_urbs:
+	airspy_kill_urbs(s);
+err_free_urbs:
+	airspy_free_urbs(s);
+err_free_stream_bufs:
+	airspy_free_stream_bufs(s);
+err_clear_bit:
+	clear_bit(POWER_ON, &s->flags);
+
+	/* return all queued buffers to vb2 */
+	{
+		struct airspy_frame_buf *buf, *tmp;
+
+		list_for_each_entry_safe(buf, tmp, &s->queued_bufs, list) {
+			list_del(&buf->list);
+			vb2_buffer_done(&buf->vb, VB2_BUF_STATE_QUEUED);
+		}
+	}
+
+exit_mutex_unlock:
 	mutex_unlock(&s->v4l2_lock);
 
 	return ret;
-- 
http://palosaari.fi/

