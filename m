Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:52176 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755349AbaHERA0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Aug 2014 13:00:26 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Kamil Debski <k.debski@samsung.com>, kernel@pengutronix.de,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Michael Olbrich <m.olbrich@pengutronix.de>
Subject: [PATCH 12/15] [media] coda: fix timestamp list handling
Date: Tue,  5 Aug 2014 19:00:17 +0200
Message-Id: <1407258020-12078-13-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1407258020-12078-1-git-send-email-p.zabel@pengutronix.de>
References: <1407258020-12078-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Lock modification of the timestamp list with bitstream_mutex and do not
try to remove a timestamp element if the list is empty. This can happen
if the userspace feeds us garbage or multiple encoded frames in a single
buffer.

Signed-off-by: Michael Olbrich <m.olbrich@pengutronix.de>
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-bit.c    | 28 +++++++++++++++++++---------
 drivers/media/platform/coda/coda-common.c |  2 ++
 2 files changed, 21 insertions(+), 9 deletions(-)

diff --git a/drivers/media/platform/coda/coda-bit.c b/drivers/media/platform/coda/coda-bit.c
index 529cc3e..18fa369 100644
--- a/drivers/media/platform/coda/coda-bit.c
+++ b/drivers/media/platform/coda/coda-bit.c
@@ -1699,18 +1699,28 @@ static void coda_finish_decode(struct coda_ctx *ctx)
 		v4l2_err(&dev->v4l2_dev,
 			 "decoded frame index out of range: %d\n", decoded_idx);
 	} else {
-		ts = list_first_entry(&ctx->timestamp_list,
-				      struct coda_timestamp, list);
-		list_del(&ts->list);
 		val = coda_read(dev, CODA_RET_DEC_PIC_FRAME_NUM) - 1;
 		val -= ctx->sequence_offset;
-		if (val != (ts->sequence & 0xffff)) {
-			v4l2_err(&dev->v4l2_dev,
-				 "sequence number mismatch (%d(%d) != %d)\n",
-				 val, ctx->sequence_offset, ts->sequence);
+		mutex_lock(&ctx->bitstream_mutex);
+		if (!list_empty(&ctx->timestamp_list)) {
+			ts = list_first_entry(&ctx->timestamp_list,
+					      struct coda_timestamp, list);
+			list_del(&ts->list);
+			if (val != (ts->sequence & 0xffff)) {
+				v4l2_err(&dev->v4l2_dev,
+					 "sequence number mismatch (%d(%d) != %d)\n",
+					 val, ctx->sequence_offset,
+					 ts->sequence);
+			}
+			ctx->frame_timestamps[decoded_idx] = *ts;
+			kfree(ts);
+		} else {
+			v4l2_err(&dev->v4l2_dev, "empty timestamp list!\n");
+			memset(&ctx->frame_timestamps[decoded_idx], 0,
+			       sizeof(struct coda_timestamp));
+			ctx->frame_timestamps[decoded_idx].sequence = val;
 		}
-		ctx->frame_timestamps[decoded_idx] = *ts;
-		kfree(ts);
+		mutex_unlock(&ctx->bitstream_mutex);
 
 		val = coda_read(dev, CODA_RET_DEC_PIC_TYPE) & 0x7;
 		if (val == 0)
diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index 0f8a2c9..e84b320 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -1116,12 +1116,14 @@ static void coda_stop_streaming(struct vb2_queue *q)
 	if (!ctx->streamon_out && !ctx->streamon_cap) {
 		struct coda_timestamp *ts;
 
+		mutex_lock(&ctx->bitstream_mutex);
 		while (!list_empty(&ctx->timestamp_list)) {
 			ts = list_first_entry(&ctx->timestamp_list,
 					      struct coda_timestamp, list);
 			list_del(&ts->list);
 			kfree(ts);
 		}
+		mutex_unlock(&ctx->bitstream_mutex);
 		kfifo_init(&ctx->bitstream_fifo,
 			ctx->bitstream.vaddr, ctx->bitstream.size);
 		ctx->runcounter = 0;
-- 
2.0.1

