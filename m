Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f171.google.com ([209.85.192.171]:47234 "EHLO
        mail-pf0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753571AbdJPXLd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 16 Oct 2017 19:11:33 -0400
Received: by mail-pf0-f171.google.com with SMTP id z11so16908361pfk.4
        for <linux-media@vger.kernel.org>; Mon, 16 Oct 2017 16:11:33 -0700 (PDT)
Date: Mon, 16 Oct 2017 16:11:30 -0700
From: Kees Cook <keescook@chromium.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        Sean Young <sean@mess.org>,
        Geliang Tang <geliangtang@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] media: saa7134: Convert timers to use timer_setup()
Message-ID: <20171016231130.GA99867@beast>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In preparation for unconditionally passing the struct timer_list pointer to
all timer callbacks, switch to using the new timer_setup() and from_timer()
to pass the timer pointer explicitly.

Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Sean Young <sean@mess.org>
Cc: Geliang Tang <geliangtang@gmail.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Cc: linux-media@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/media/pci/saa7134/saa7134-core.c  | 6 +++---
 drivers/media/pci/saa7134/saa7134-input.c | 9 ++++-----
 drivers/media/pci/saa7134/saa7134-ts.c    | 3 +--
 drivers/media/pci/saa7134/saa7134-vbi.c   | 3 +--
 drivers/media/pci/saa7134/saa7134-video.c | 3 +--
 drivers/media/pci/saa7134/saa7134.h       | 2 +-
 6 files changed, 11 insertions(+), 15 deletions(-)

diff --git a/drivers/media/pci/saa7134/saa7134-core.c b/drivers/media/pci/saa7134/saa7134-core.c
index 7976c5a12ca8..9e76de2411ae 100644
--- a/drivers/media/pci/saa7134/saa7134-core.c
+++ b/drivers/media/pci/saa7134/saa7134-core.c
@@ -338,9 +338,9 @@ void saa7134_buffer_next(struct saa7134_dev *dev,
 	}
 }
 
-void saa7134_buffer_timeout(unsigned long data)
+void saa7134_buffer_timeout(struct timer_list *t)
 {
-	struct saa7134_dmaqueue *q = (struct saa7134_dmaqueue *)data;
+	struct saa7134_dmaqueue *q = from_timer(q, t, timeout);
 	struct saa7134_dev *dev = q->dev;
 	unsigned long flags;
 
@@ -378,7 +378,7 @@ void saa7134_stop_streaming(struct saa7134_dev *dev, struct saa7134_dmaqueue *q)
 		}
 	}
 	spin_unlock_irqrestore(&dev->slock, flags);
-	saa7134_buffer_timeout((unsigned long)q); /* also calls del_timer(&q->timeout) */
+	saa7134_buffer_timeout(&q->timeout); /* also calls del_timer(&q->timeout) */
 }
 EXPORT_SYMBOL_GPL(saa7134_stop_streaming);
 
diff --git a/drivers/media/pci/saa7134/saa7134-input.c b/drivers/media/pci/saa7134/saa7134-input.c
index 9337e4615519..2d5abeddc079 100644
--- a/drivers/media/pci/saa7134/saa7134-input.c
+++ b/drivers/media/pci/saa7134/saa7134-input.c
@@ -447,10 +447,10 @@ void saa7134_input_irq(struct saa7134_dev *dev)
 	}
 }
 
-static void saa7134_input_timer(unsigned long data)
+static void saa7134_input_timer(struct timer_list *t)
 {
-	struct saa7134_dev *dev = (struct saa7134_dev *)data;
-	struct saa7134_card_ir *ir = dev->remote;
+	struct saa7134_card_ir *ir = from_timer(ir, t, timer);
+	struct saa7134_dev *dev = ir->dev->priv;
 
 	build_key(dev);
 	mod_timer(&ir->timer, jiffies + msecs_to_jiffies(ir->polling));
@@ -507,8 +507,7 @@ static int __saa7134_ir_start(void *priv)
 	ir->running = true;
 
 	if (ir->polling) {
-		setup_timer(&ir->timer, saa7134_input_timer,
-			    (unsigned long)dev);
+		timer_setup(&ir->timer, saa7134_input_timer, 0);
 		ir->timer.expires = jiffies + HZ;
 		add_timer(&ir->timer);
 	}
diff --git a/drivers/media/pci/saa7134/saa7134-ts.c b/drivers/media/pci/saa7134/saa7134-ts.c
index 7414878af9e0..2be703617e29 100644
--- a/drivers/media/pci/saa7134/saa7134-ts.c
+++ b/drivers/media/pci/saa7134/saa7134-ts.c
@@ -223,8 +223,7 @@ int saa7134_ts_init1(struct saa7134_dev *dev)
 	dev->ts.nr_packets = ts_nr_packets;
 
 	INIT_LIST_HEAD(&dev->ts_q.queue);
-	setup_timer(&dev->ts_q.timeout, saa7134_buffer_timeout,
-		    (unsigned long)(&dev->ts_q));
+	timer_setup(&dev->ts_q.timeout, saa7134_buffer_timeout, 0);
 	dev->ts_q.dev              = dev;
 	dev->ts_q.need_two         = 1;
 	dev->ts_started            = 0;
diff --git a/drivers/media/pci/saa7134/saa7134-vbi.c b/drivers/media/pci/saa7134/saa7134-vbi.c
index bcad9b2d9bb3..af494c6147f1 100644
--- a/drivers/media/pci/saa7134/saa7134-vbi.c
+++ b/drivers/media/pci/saa7134/saa7134-vbi.c
@@ -181,8 +181,7 @@ struct vb2_ops saa7134_vbi_qops = {
 int saa7134_vbi_init1(struct saa7134_dev *dev)
 {
 	INIT_LIST_HEAD(&dev->vbi_q.queue);
-	setup_timer(&dev->vbi_q.timeout, saa7134_buffer_timeout,
-		    (unsigned long)(&dev->vbi_q));
+	timer_setup(&dev->vbi_q.timeout, saa7134_buffer_timeout, 0);
 	dev->vbi_q.dev              = dev;
 
 	if (vbibufs < 2)
diff --git a/drivers/media/pci/saa7134/saa7134-video.c b/drivers/media/pci/saa7134/saa7134-video.c
index 51d42bbf969e..82d2a24644e4 100644
--- a/drivers/media/pci/saa7134/saa7134-video.c
+++ b/drivers/media/pci/saa7134/saa7134-video.c
@@ -2145,8 +2145,7 @@ int saa7134_video_init1(struct saa7134_dev *dev)
 	dev->automute       = 0;
 
 	INIT_LIST_HEAD(&dev->video_q.queue);
-	setup_timer(&dev->video_q.timeout, saa7134_buffer_timeout,
-		    (unsigned long)(&dev->video_q));
+	timer_setup(&dev->video_q.timeout, saa7134_buffer_timeout, 0);
 	dev->video_q.dev              = dev;
 	dev->fmt = format_by_fourcc(V4L2_PIX_FMT_BGR24);
 	dev->width    = 720;
diff --git a/drivers/media/pci/saa7134/saa7134.h b/drivers/media/pci/saa7134/saa7134.h
index 816b5282d671..70131b93da3d 100644
--- a/drivers/media/pci/saa7134/saa7134.h
+++ b/drivers/media/pci/saa7134/saa7134.h
@@ -773,7 +773,7 @@ int saa7134_buffer_queue(struct saa7134_dev *dev, struct saa7134_dmaqueue *q,
 void saa7134_buffer_finish(struct saa7134_dev *dev, struct saa7134_dmaqueue *q,
 			   unsigned int state);
 void saa7134_buffer_next(struct saa7134_dev *dev, struct saa7134_dmaqueue *q);
-void saa7134_buffer_timeout(unsigned long data);
+void saa7134_buffer_timeout(struct timer_list *t);
 void saa7134_stop_streaming(struct saa7134_dev *dev, struct saa7134_dmaqueue *q);
 
 int saa7134_set_dmabits(struct saa7134_dev *dev);
-- 
2.7.4


-- 
Kees Cook
Pixel Security
