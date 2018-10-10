Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk1-f196.google.com ([209.85.222.196]:41840 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725860AbeJJII7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 10 Oct 2018 04:08:59 -0400
Date: Tue, 9 Oct 2018 21:49:21 -0300
From: Gabriel Francisco Mandaji <gfmandaji@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: lkcamp@lists.libreplanetbr.org
Subject: [PATCH] media: vivid: Improve timestamping
Message-ID: <20181010004921.GA6532@gfm-note>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Simulate a more precise timestamp by calculating it based on the
current framerate.

Signed-off-by: Gabriel Francisco Mandaji <gfmandaji@gmail.com>
---
 drivers/media/platform/vivid/vivid-core.h        |  1 +
 drivers/media/platform/vivid/vivid-kthread-cap.c | 24 ++++++++++++++++--------
 2 files changed, 17 insertions(+), 8 deletions(-)

diff --git a/drivers/media/platform/vivid/vivid-core.h b/drivers/media/platform/vivid/vivid-core.h
index cd4c823..cbdadd8 100644
--- a/drivers/media/platform/vivid/vivid-core.h
+++ b/drivers/media/platform/vivid/vivid-core.h
@@ -384,6 +384,7 @@ struct vivid_dev {
 	/* thread for generating video capture stream */
 	struct task_struct		*kthread_vid_cap;
 	unsigned long			jiffies_vid_cap;
+	u64				cap_stream_start;
 	u32				cap_seq_offset;
 	u32				cap_seq_count;
 	bool				cap_seq_resync;
diff --git a/drivers/media/platform/vivid/vivid-kthread-cap.c b/drivers/media/platform/vivid/vivid-kthread-cap.c
index f06003b..0793b15 100644
--- a/drivers/media/platform/vivid/vivid-kthread-cap.c
+++ b/drivers/media/platform/vivid/vivid-kthread-cap.c
@@ -416,6 +416,7 @@ static void vivid_fillbuff(struct vivid_dev *dev, struct vivid_buffer *buf)
 	char str[100];
 	s32 gain;
 	bool is_loop = false;
+	u64 soe_time = 0;
 
 	if (dev->loop_video && dev->can_loop_video &&
 		((vivid_is_svid_cap(dev) &&
@@ -426,11 +427,11 @@ static void vivid_fillbuff(struct vivid_dev *dev, struct vivid_buffer *buf)
 
 	buf->vb.sequence = dev->vid_cap_seq_count;
 	/*
-	 * Take the timestamp now if the timestamp source is set to
-	 * "Start of Exposure".
+	 * Store the current time to calculate the delta if source is set to
+	 * "End of Frame".
 	 */
-	if (dev->tstamp_src_is_soe)
-		buf->vb.vb2_buf.timestamp = ktime_get_ns();
+	if (!dev->tstamp_src_is_soe)
+		soe_time = ktime_get_ns();
 	if (dev->field_cap == V4L2_FIELD_ALTERNATE) {
 		/*
 		 * 60 Hz standards start with the bottom field, 50 Hz standards
@@ -556,12 +557,18 @@ static void vivid_fillbuff(struct vivid_dev *dev, struct vivid_buffer *buf)
 	}
 
 	/*
-	 * If "End of Frame" is specified at the timestamp source, then take
-	 * the timestamp now.
+	 * If "End of Frame", then calculate the "exposition time" and add
+	 * it to the timestamp.
 	 */
 	if (!dev->tstamp_src_is_soe)
-		buf->vb.vb2_buf.timestamp = ktime_get_ns();
-	buf->vb.vb2_buf.timestamp += dev->time_wrap_offset;
+		soe_time = ktime_get_ns() - soe_time;
+	buf->vb.vb2_buf.timestamp = dev->timeperframe_vid_cap.numerator *
+				    1000000000 /
+				    dev->timeperframe_vid_cap.denominator *
+				    dev->vid_cap_seq_count +
+				    dev->cap_stream_start +
+				    soe_time +
+				    dev->time_wrap_offset;
 }
 
 /*
@@ -759,6 +766,7 @@ static int vivid_thread_vid_cap(void *data)
 	dev->cap_seq_count = 0;
 	dev->cap_seq_resync = false;
 	dev->jiffies_vid_cap = jiffies;
+	dev->cap_stream_start = ktime_get_ns();
 
 	for (;;) {
 		try_to_freeze();
-- 
1.9.1
