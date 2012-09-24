Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:19377 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756166Ab2IXO4M (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Sep 2012 10:56:12 -0400
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MAV0047205JKX20@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Mon, 24 Sep 2012 23:56:10 +0900 (KST)
Received: from amdc248.digital.local ([106.116.147.32])
 by mmp1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0MAV0044E052DB30@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 24 Sep 2012 23:56:10 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: a.hajda@samsung.com, sakari.ailus@iki.fi,
	laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl,
	kyungmin.park@samsung.com, sw0312.kim@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH RFC 3/5] s5p-csis: Add support for non-image data packets
 capture
Date: Mon, 24 Sep 2012 16:55:44 +0200
Message-id: <1348498546-2652-4-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1348498546-2652-1-git-send-email-s.nawrocki@samsung.com>
References: <1348498546-2652-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

MIPI-CSI has internal memory mapped buffers for the frame embedded
(non-image) data. There are two buffers, for even and odd frames which
need to be saved after an interrupt is raised. The packet data buffers
size is 4 KiB and there is no status register in the hardware where the
actual non-image data size can be read from. Hence the driver copies
whole packet data buffer into a buffer provided by the FIMC driver.
This will form a separate plane in the user buffer.

When FIMC DMA engine is stopped by the driver due the to user space
not keeping up with buffer de-queuing the MIPI-CSIS will still run,
however it must discard data which is not captured by FIMC. Which
frames are actually capture by MIPI-CSIS is determined by means of
the s_tx_buffer subdev callback. When it is not called after a single
embedded data frame has been captured and copied and before next
embedded data frame interrupt occurrs, subsequent embedded data frames
will be dropped.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/s5p-fimc/mipi-csis.c | 51 +++++++++++++++++++++++++++++
 1 file changed, 51 insertions(+)

diff --git a/drivers/media/platform/s5p-fimc/mipi-csis.c b/drivers/media/platform/s5p-fimc/mipi-csis.c
index c1c5c86..306410f 100644
--- a/drivers/media/platform/s5p-fimc/mipi-csis.c
+++ b/drivers/media/platform/s5p-fimc/mipi-csis.c
@@ -98,6 +98,11 @@ MODULE_PARM_DESC(debug, "Debug level (0-2)");
 #define CSIS_MAX_PIX_WIDTH		0xffff
 #define CSIS_MAX_PIX_HEIGHT		0xffff
 
+/* Non-image packet data buffers */
+#define S5PCSIS_PKTDATA_ODD		0x2000
+#define S5PCSIS_PKTDATA_EVEN		0x3000
+#define S5PCSIS_PKTDATA_SIZE		SZ_4K
+
 enum {
 	CSIS_CLK_MUX,
 	CSIS_CLK_GATE,
@@ -144,6 +149,11 @@ static const struct s5pcsis_event s5pcsis_events[] = {
 };
 #define S5PCSIS_NUM_EVENTS ARRAY_SIZE(s5pcsis_events)
 
+struct csis_pktbuf {
+	u32 *data;
+	unsigned int len;
+};
+
 /**
  * struct csis_state - the driver's internal state data structure
  * @lock: mutex serializing the subdev and power management operations,
@@ -160,6 +170,7 @@ static const struct s5pcsis_event s5pcsis_events[] = {
  * @csis_fmt: current CSIS pixel format
  * @format: common media bus format for the source and sink pad
  * @slock: spinlock protecting structure members below
+ * @pkt_buf: the frame embedded (non-image) data buffer
  * @events: MIPI-CSIS event (error) counters
  */
 struct csis_state {
@@ -177,6 +188,7 @@ struct csis_state {
 	struct v4l2_mbus_framefmt format;
 
 	struct spinlock slock;
+	struct csis_pktbuf pkt_buf;
 	struct s5pcsis_event events[S5PCSIS_NUM_EVENTS];
 };
 
@@ -534,6 +546,21 @@ static int s5pcsis_get_fmt(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
 	return 0;
 }
 
+static int s5pcsis_s_rx_buffer(struct v4l2_subdev *sd, void *buf,
+			       unsigned int *size)
+{
+	struct csis_state *state = sd_to_csis_state(sd);
+	unsigned long flags;
+
+	spin_lock_irqsave(&state->slock, flags);
+	*size = min_t(unsigned int, *size, S5PCSIS_PKTDATA_SIZE);
+	state->pkt_buf.data = buf;
+	state->pkt_buf.len = *size;
+	spin_unlock_irqrestore(&state->slock, flags);
+
+	return 0;
+}
+
 static int s5pcsis_log_status(struct v4l2_subdev *sd)
 {
 	struct csis_state *state = sd_to_csis_state(sd);
@@ -571,6 +598,7 @@ static struct v4l2_subdev_pad_ops s5pcsis_pad_ops = {
 };
 
 static struct v4l2_subdev_video_ops s5pcsis_video_ops = {
+	.s_rx_buffer = s5pcsis_s_rx_buffer,
 	.s_stream = s5pcsis_s_stream,
 };
 
@@ -580,16 +608,39 @@ static struct v4l2_subdev_ops s5pcsis_subdev_ops = {
 	.video = &s5pcsis_video_ops,
 };
 
+static void s5pcsis_pkt_copy(struct csis_state *state, u32 *buf,
+			     u32 offset, u32 size)
+{
+	int i;
+
+	for (i = 0; i < S5PCSIS_PKTDATA_SIZE; i += 4, buf++)
+		*buf = s5pcsis_read(state, offset + i);
+}
+
 static irqreturn_t s5pcsis_irq_handler(int irq, void *dev_id)
 {
 	struct csis_state *state = dev_id;
+	struct csis_pktbuf *pktbuf = &state->pkt_buf;
 	unsigned long flags;
 	u32 status;
 
 	status = s5pcsis_read(state, S5PCSIS_INTSRC);
+	s5pcsis_write(state, S5PCSIS_INTSRC, status);
 
 	spin_lock_irqsave(&state->slock, flags);
 
+	if ((status & S5PCSIS_INTSRC_NON_IMAGE_DATA) && pktbuf->data) {
+		u32 offset;
+
+		if (status & S5PCSIS_INTSRC_EVEN)
+			offset = S5PCSIS_PKTDATA_EVEN;
+		else
+			offset = S5PCSIS_PKTDATA_ODD;
+
+		s5pcsis_pkt_copy(state, pktbuf->data, offset, pktbuf->len);
+		pktbuf->data = NULL;
+	}
+
 	/* Update the event/error counters */
 	if ((status & S5PCSIS_INTSRC_ERRORS) || debug) {
 		int i;
-- 
1.7.11.3

