Return-path: <linux-media-owner@vger.kernel.org>
Received: from butterbrot.org ([176.9.106.16]:48937 "EHLO butterbrot.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754764AbbEUMhQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 21 May 2015 08:37:16 -0400
From: Florian Echtler <floe@butterbrot.org>
To: hans.verkuil@cisco.com, mchehab@osg.samsung.com,
	linux-media@vger.kernel.org
Cc: modin@yuri.at, Florian Echtler <floe@butterbrot.org>
Subject: [PATCH 3/4] add extra debug output, remove noisy warning
Date: Thu, 21 May 2015 14:29:41 +0200
Message-Id: <1432211382-5155-4-git-send-email-floe@butterbrot.org>
In-Reply-To: <1432211382-5155-1-git-send-email-floe@butterbrot.org>
References: <1432211382-5155-1-git-send-email-floe@butterbrot.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Martin Kaltenbrunner <modin@yuri.at>
Signed-off-by: Florian Echtler <floe@butterbrot.org>
---
 drivers/input/touchscreen/sur40.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/input/touchscreen/sur40.c b/drivers/input/touchscreen/sur40.c
index d860d05..8add986 100644
--- a/drivers/input/touchscreen/sur40.c
+++ b/drivers/input/touchscreen/sur40.c
@@ -342,7 +342,7 @@ static void sur40_poll(struct input_polled_dev *polldev)
 		 * instead of at the end.
 		 */
 		if (packet_id != header->packet_id)
-			dev_warn(sur40->dev, "packet ID mismatch\n");
+			dev_dbg(sur40->dev, "packet ID mismatch\n");
 
 		packet_blobs = result / sizeof(struct sur40_blob);
 		dev_dbg(sur40->dev, "received %d blobs\n", packet_blobs);
@@ -389,6 +389,8 @@ static void sur40_process_video(struct sur40_state *sur40)
 	list_del(&new_buf->list);
 	spin_unlock(&sur40->qlock);
 
+	dev_dbg(sur40->dev, "buffer acquired\n");
+
 	/* retrieve data via bulk read */
 	result = usb_bulk_msg(sur40->usbdev,
 			usb_rcvbulkpipe(sur40->usbdev, VIDEO_ENDPOINT),
@@ -416,6 +418,8 @@ static void sur40_process_video(struct sur40_state *sur40)
 		goto err_poll;
 	}
 
+	dev_dbg(sur40->dev, "header acquired\n");
+
 	sgt = vb2_dma_sg_plane_desc(&new_buf->vb, 0);
 
 	result = usb_sg_init(&sgr, sur40->usbdev,
@@ -432,11 +436,14 @@ static void sur40_process_video(struct sur40_state *sur40)
 		goto err_poll;
 	}
 
+	dev_dbg(sur40->dev, "image acquired\n");
+
 	/* mark as finished */
 	v4l2_get_timestamp(&new_buf->vb.v4l2_buf.timestamp);
 	new_buf->vb.v4l2_buf.sequence = sur40->sequence++;
 	new_buf->vb.v4l2_buf.field = V4L2_FIELD_NONE;
 	vb2_buffer_done(&new_buf->vb, VB2_BUF_STATE_DONE);
+	dev_dbg(sur40->dev, "buffer marked done\n");
 	return;
 
 err_poll:
-- 
1.9.1

