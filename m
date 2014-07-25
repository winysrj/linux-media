Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:37973 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754171AbaGYPIn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Jul 2014 11:08:43 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	kernel@pengutronix.de, Michael Olbrich <m.olbrich@pengutronix.de>,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 11/11] [media] coda: fix timestamp list handling
Date: Fri, 25 Jul 2014 17:08:37 +0200
Message-Id: <1406300917-18169-12-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1406300917-18169-1-git-send-email-p.zabel@pengutronix.de>
References: <1406300917-18169-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Michael Olbrich <m.olbrich@pengutronix.de>

Lock modification of the timestamp list with bitstream_mutex and do not
try to remove a timestamp element if the list is empty. This can happen
if the userspace feeds us garbage or multiple encoded frames in a single
buffer.

Signed-off-by: Michael Olbrich <m.olbrich@pengutronix.de>
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-bit.c    | 27 ++++++++++++++++++---------
 drivers/media/platform/coda/coda-common.c |  2 ++
 2 files changed, 20 insertions(+), 9 deletions(-)

diff --git a/drivers/media/platform/coda/coda-bit.c b/drivers/media/platform/coda/coda-bit.c
index fcc676c..1e7a243 100644
--- a/drivers/media/platform/coda/coda-bit.c
+++ b/drivers/media/platform/coda/coda-bit.c
@@ -1696,18 +1696,27 @@ static void coda_finish_decode(struct coda_ctx *ctx)
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
+					 val, ctx->sequence_offset, ts->sequence);
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
index 425e279..6cb8349 100644
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

