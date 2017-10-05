Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f179.google.com ([209.85.192.179]:52905 "EHLO
        mail-pf0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752943AbdJEAxI (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 4 Oct 2017 20:53:08 -0400
Received: by mail-pf0-f179.google.com with SMTP id a1so3900138pfj.9
        for <linux-media@vger.kernel.org>; Wed, 04 Oct 2017 17:53:08 -0700 (PDT)
Date: Wed, 4 Oct 2017 17:53:06 -0700
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] media: saa7146: Convert timers to use timer_setup()
Message-ID: <20171005005306.GA23710@beast>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In preparation for unconditionally passing the struct timer_list pointer to
all timer callbacks, switch to using the new timer_setup() and from_timer()
to pass the timer pointer explicitly.

Cc: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
This requires commit 686fef928bba ("timer: Prepare to change timer
callback argument type") in v4.14-rc3, but should be otherwise
stand-alone.
---
 drivers/media/common/saa7146/saa7146_fops.c  | 4 ++--
 drivers/media/common/saa7146/saa7146_vbi.c   | 3 +--
 drivers/media/common/saa7146/saa7146_video.c | 3 +--
 include/media/drv-intf/saa7146_vv.h          | 2 +-
 4 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/media/common/saa7146/saa7146_fops.c b/drivers/media/common/saa7146/saa7146_fops.c
index c4664f0da874..8c87d6837c49 100644
--- a/drivers/media/common/saa7146/saa7146_fops.c
+++ b/drivers/media/common/saa7146/saa7146_fops.c
@@ -163,9 +163,9 @@ void saa7146_buffer_next(struct saa7146_dev *dev,
 	}
 }
 
-void saa7146_buffer_timeout(unsigned long data)
+void saa7146_buffer_timeout(struct timer_list *t)
 {
-	struct saa7146_dmaqueue *q = (struct saa7146_dmaqueue*)data;
+	struct saa7146_dmaqueue *q = from_timer(q, t, timeout);
 	struct saa7146_dev *dev = q->dev;
 	unsigned long flags;
 
diff --git a/drivers/media/common/saa7146/saa7146_vbi.c b/drivers/media/common/saa7146/saa7146_vbi.c
index f65c0b934c22..0f7599ad4958 100644
--- a/drivers/media/common/saa7146/saa7146_vbi.c
+++ b/drivers/media/common/saa7146/saa7146_vbi.c
@@ -366,8 +366,7 @@ static void vbi_init(struct saa7146_dev *dev, struct saa7146_vv *vv)
 
 	INIT_LIST_HEAD(&vv->vbi_dmaq.queue);
 
-	setup_timer(&vv->vbi_dmaq.timeout, saa7146_buffer_timeout,
-		    (unsigned long)(&vv->vbi_dmaq));
+	timer_setup(&vv->vbi_dmaq.timeout, saa7146_buffer_timeout, 0);
 	vv->vbi_dmaq.dev              = dev;
 
 	init_waitqueue_head(&vv->vbi_wq);
diff --git a/drivers/media/common/saa7146/saa7146_video.c b/drivers/media/common/saa7146/saa7146_video.c
index 37b4654dc21c..ed9b5300dcce 100644
--- a/drivers/media/common/saa7146/saa7146_video.c
+++ b/drivers/media/common/saa7146/saa7146_video.c
@@ -1201,8 +1201,7 @@ static void video_init(struct saa7146_dev *dev, struct saa7146_vv *vv)
 {
 	INIT_LIST_HEAD(&vv->video_dmaq.queue);
 
-	setup_timer(&vv->video_dmaq.timeout, saa7146_buffer_timeout,
-		    (unsigned long)(&vv->video_dmaq));
+	timer_setup(&vv->video_dmaq.timeout, saa7146_buffer_timeout, 0);
 	vv->video_dmaq.dev              = dev;
 
 	/* set some default values */
diff --git a/include/media/drv-intf/saa7146_vv.h b/include/media/drv-intf/saa7146_vv.h
index fbe36d05fb79..b1f25240968f 100644
--- a/include/media/drv-intf/saa7146_vv.h
+++ b/include/media/drv-intf/saa7146_vv.h
@@ -184,7 +184,7 @@ int saa7146_unregister_device(struct video_device *vid, struct saa7146_dev *dev)
 void saa7146_buffer_finish(struct saa7146_dev *dev, struct saa7146_dmaqueue *q, int state);
 void saa7146_buffer_next(struct saa7146_dev *dev, struct saa7146_dmaqueue *q,int vbi);
 int saa7146_buffer_queue(struct saa7146_dev *dev, struct saa7146_dmaqueue *q, struct saa7146_buf *buf);
-void saa7146_buffer_timeout(unsigned long data);
+void saa7146_buffer_timeout(struct timer_list *t);
 void saa7146_dma_free(struct saa7146_dev* dev,struct videobuf_queue *q,
 						struct saa7146_buf *buf);
 
-- 
2.7.4


-- 
Kees Cook
Pixel Security
