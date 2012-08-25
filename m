Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:63962 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754678Ab2HYDJW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Aug 2012 23:09:22 -0400
Received: by mail-yw0-f46.google.com with SMTP id m54so582622yhm.19
        for <linux-media@vger.kernel.org>; Fri, 24 Aug 2012 20:09:22 -0700 (PDT)
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Ezequiel Garcia <elezegarcia@gmail.com>
Subject: [PATCH 7/9] stk1160: Don't check vb2_queue_init() return
Date: Sat, 25 Aug 2012 00:09:04 -0300
Message-Id: <1345864146-2207-7-git-send-email-elezegarcia@gmail.com>
In-Reply-To: <1345864146-2207-1-git-send-email-elezegarcia@gmail.com>
References: <1345864146-2207-1-git-send-email-elezegarcia@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Right now vb2_queue_init() returns always 0
and it will be changed to return void.

Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
---
 drivers/media/usb/stk1160/stk1160-core.c |    4 +---
 drivers/media/usb/stk1160/stk1160-v4l.c  |   12 +++---------
 drivers/media/usb/stk1160/stk1160.h      |    2 +-
 3 files changed, 5 insertions(+), 13 deletions(-)

diff --git a/drivers/media/usb/stk1160/stk1160-core.c b/drivers/media/usb/stk1160/stk1160-core.c
index 74236fd..0af08e7 100644
--- a/drivers/media/usb/stk1160/stk1160-core.c
+++ b/drivers/media/usb/stk1160/stk1160-core.c
@@ -306,9 +306,7 @@ static int stk1160_probe(struct usb_interface *interface,
 	usb_set_intfdata(interface, dev);
 
 	/* initialize videobuf2 stuff */
-	rc = stk1160_vb2_setup(dev);
-	if (rc < 0)
-		goto free_err;
+	stk1160_vb2_setup(dev);
 
 	/*
 	 * There is no need to take any locks here in probe
diff --git a/drivers/media/usb/stk1160/stk1160-v4l.c b/drivers/media/usb/stk1160/stk1160-v4l.c
index fe6e857..abb933d 100644
--- a/drivers/media/usb/stk1160/stk1160-v4l.c
+++ b/drivers/media/usb/stk1160/stk1160-v4l.c
@@ -670,12 +670,10 @@ void stk1160_clear_queue(struct stk1160 *dev)
 	spin_unlock_irqrestore(&dev->buf_lock, flags);
 }
 
-int stk1160_vb2_setup(struct stk1160 *dev)
+void stk1160_vb2_setup(struct stk1160 *dev)
 {
-	int rc;
-	struct vb2_queue *q;
+	struct vb2_queue *q = &dev->vb_vidq;
 
-	q = &dev->vb_vidq;
 	q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 	q->io_modes = VB2_READ | VB2_MMAP | VB2_USERPTR;
 	q->drv_priv = dev;
@@ -683,14 +681,10 @@ int stk1160_vb2_setup(struct stk1160 *dev)
 	q->ops = &stk1160_video_qops;
 	q->mem_ops = &vb2_vmalloc_memops;
 
-	rc = vb2_queue_init(q);
-	if (rc < 0)
-		return rc;
+	vb2_queue_init(q);
 
 	/* initialize video dma queue */
 	INIT_LIST_HEAD(&dev->avail_bufs);
-
-	return 0;
 }
 
 int stk1160_video_register(struct stk1160 *dev)
diff --git a/drivers/media/usb/stk1160/stk1160.h b/drivers/media/usb/stk1160/stk1160.h
index 3feba00..3618481 100644
--- a/drivers/media/usb/stk1160/stk1160.h
+++ b/drivers/media/usb/stk1160/stk1160.h
@@ -173,7 +173,7 @@ struct regval {
 };
 
 /* Provided by stk1160-v4l.c */
-int stk1160_vb2_setup(struct stk1160 *dev);
+void stk1160_vb2_setup(struct stk1160 *dev);
 int stk1160_video_register(struct stk1160 *dev);
 void stk1160_video_unregister(struct stk1160 *dev);
 void stk1160_clear_queue(struct stk1160 *dev);
-- 
1.7.8.6

