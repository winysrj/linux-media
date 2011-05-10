Return-path: <mchehab@gaivota>
Received: from claranet-outbound-smtp00.uk.clara.net ([195.8.89.33]:55351 "EHLO
	claranet-outbound-smtp00.uk.clara.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755258Ab1EJNuA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 May 2011 09:50:00 -0400
From: Simon Farnsworth <simon.farnsworth@onelan.co.uk>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Andy Walls <awalls@md.metrocast.net>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	Steven Toth <stoth@kernellabs.com>,
	Simon Farnsworth <simon.farnsworth@onelan.co.uk>
Subject: [PATCH] cx18: Move spinlock and vb_type initialisation into stream_init
Date: Tue, 10 May 2011 14:49:50 +0100
Message-Id: <1305035390-31439-1-git-send-email-simon.farnsworth@onelan.co.uk>
In-Reply-To: <4DC2A8FD.4010902@infradead.org>
References: <4DC2A8FD.4010902@infradead.org>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

The initialisation of vb_type in serialized_open was preventing
REQBUFS from working reliably. Remove it, and move the spinlock into
stream_init for good measure - it's only used when we have a stream
that supports videobuf anyway.

Signed-off-by: Simon Farnsworth <simon.farnsworth@onelan.co.uk>
---
Mauro,

This fixes a bug I introduced, and noticed while trying to work out
how videobuf works and interacts with the rest of the driver, in
preparation for working out how to port this code to videobuf2.

Briefly, if you open a device node at the wrong time, you lose
videobuf support forever.

Please consider this for 2.6.40,

Simon

 drivers/media/video/cx18/cx18-fileops.c |    3 ---
 drivers/media/video/cx18/cx18-streams.c |    2 ++
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/media/video/cx18/cx18-fileops.c b/drivers/media/video/cx18/cx18-fileops.c
index 6609222..07411f3 100644
--- a/drivers/media/video/cx18/cx18-fileops.c
+++ b/drivers/media/video/cx18/cx18-fileops.c
@@ -810,9 +810,6 @@ static int cx18_serialized_open(struct cx18_stream *s, struct file *filp)
 	item->cx = cx;
 	item->type = s->type;
 
-	spin_lock_init(&s->vbuf_q_lock);
-	s->vb_type = 0;
-
 	item->open_id = cx->open_id++;
 	filp->private_data = &item->fh;
 
diff --git a/drivers/media/video/cx18/cx18-streams.c b/drivers/media/video/cx18/cx18-streams.c
index 24c9688..4282ff5 100644
--- a/drivers/media/video/cx18/cx18-streams.c
+++ b/drivers/media/video/cx18/cx18-streams.c
@@ -275,6 +275,8 @@ static void cx18_stream_init(struct cx18 *cx, int type)
 	init_timer(&s->vb_timeout);
 	spin_lock_init(&s->vb_lock);
 	if (type == CX18_ENC_STREAM_TYPE_YUV) {
+		spin_lock_init(&s->vbuf_q_lock);
+
 		s->vb_type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 		videobuf_queue_vmalloc_init(&s->vbuf_q, &cx18_videobuf_qops,
 			&cx->pci_dev->dev, &s->vbuf_q_lock,
-- 
1.7.4

