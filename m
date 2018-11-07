Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:47750 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726635AbeKGXfa (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 7 Nov 2018 18:35:30 -0500
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] vim2m: use cancel_delayed_work_sync instead of
 flush_schedule_work
Message-ID: <ff77abc3-7c15-8319-f500-a48db4f4bd5d@xs4all.nl>
Date: Wed, 7 Nov 2018 15:04:54 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The use of flush_schedule_work() made no sense and caused a syzkaller error.
Replace with the correct cancel_delayed_work_sync().

Signed-off-by: Hans Verkuil <hans.verkuil>
Reported-by: syzbot+69780d144754b8071f4b@syzkaller.appspotmail.com
---
diff --git a/drivers/media/platform/vim2m.c b/drivers/media/platform/vim2m.c
index d82db738f174..f938a2c54314 100644
--- a/drivers/media/platform/vim2m.c
+++ b/drivers/media/platform/vim2m.c
@@ -805,10 +805,11 @@ static int vim2m_start_streaming(struct vb2_queue *q, unsigned count)
 static void vim2m_stop_streaming(struct vb2_queue *q)
 {
 	struct vim2m_ctx *ctx = vb2_get_drv_priv(q);
+	struct vim2m_dev *dev = ctx->dev;
 	struct vb2_v4l2_buffer *vbuf;
 	unsigned long flags;

-	flush_scheduled_work();
+	cancel_delayed_work_sync(&dev->work_run);
 	for (;;) {
 		if (V4L2_TYPE_IS_OUTPUT(q->type))
 			vbuf = v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx);
