Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:50346 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932274AbdJXPWp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 24 Oct 2017 11:22:45 -0400
Received: by mail-pf0-f194.google.com with SMTP id b6so19920047pfh.7
        for <linux-media@vger.kernel.org>; Tue, 24 Oct 2017 08:22:44 -0700 (PDT)
Date: Tue, 24 Oct 2017 08:22:42 -0700
From: Kees Cook <keescook@chromium.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Andy Walls <awalls@md.metrocast.net>,
        Sergey Kozlov <serjk@netup.ru>, Abylay Ospan <aospan@netup.ru>,
        Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
        Hans Verkuil <hansverk@cisco.com>,
        Arvind Yadav <arvind.yadav.cs@gmail.com>,
        Geliang Tang <geliangtang@gmail.com>,
        Sean Young <sean@mess.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] media: pci: Convert timers to use timer_setup()
Message-ID: <20171024152242.GA104904@beast>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In preparation for unconditionally passing the struct timer_list pointer to
all timer callbacks, switch to using the new timer_setup() and from_timer()
to pass the timer pointer explicitly.

Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Andy Walls <awalls@md.metrocast.net>
Cc: Sergey Kozlov <serjk@netup.ru>
Cc: Abylay Ospan <aospan@netup.ru>
Cc: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Cc: Hans Verkuil <hansverk@cisco.com>
Cc: Arvind Yadav <arvind.yadav.cs@gmail.com>
Cc: Geliang Tang <geliangtang@gmail.com>
Cc: Sean Young <sean@mess.org>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: "Pali Rohár" <pali.rohar@gmail.com>
Cc: linux-media@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/media/pci/bt8xx/bttv-driver.c              |  6 +++---
 drivers/media/pci/bt8xx/bttv-input.c               | 19 ++++++++++---------
 drivers/media/pci/bt8xx/bttvp.h                    |  1 +
 drivers/media/pci/cx18/cx18-fileops.c              |  4 ++--
 drivers/media/pci/cx18/cx18-fileops.h              |  2 +-
 drivers/media/pci/cx18/cx18-streams.c              |  2 +-
 drivers/media/pci/ivtv/ivtv-driver.c               |  3 +--
 drivers/media/pci/ivtv/ivtv-irq.c                  |  4 ++--
 drivers/media/pci/ivtv/ivtv-irq.h                  |  2 +-
 drivers/media/pci/netup_unidvb/netup_unidvb_core.c |  7 +++----
 drivers/media/pci/ttpci/av7110_ir.c                |  7 +++----
 drivers/media/pci/tw686x/tw686x-core.c             |  7 +++----
 12 files changed, 31 insertions(+), 33 deletions(-)

diff --git a/drivers/media/pci/bt8xx/bttv-driver.c b/drivers/media/pci/bt8xx/bttv-driver.c
index 227086a2e99c..b366a7e1d976 100644
--- a/drivers/media/pci/bt8xx/bttv-driver.c
+++ b/drivers/media/pci/bt8xx/bttv-driver.c
@@ -3652,9 +3652,9 @@ bttv_irq_wakeup_vbi(struct bttv *btv, struct bttv_buffer *wakeup,
 	wake_up(&wakeup->vb.done);
 }
 
-static void bttv_irq_timeout(unsigned long data)
+static void bttv_irq_timeout(struct timer_list *t)
 {
-	struct bttv *btv = (struct bttv *)data;
+	struct bttv *btv = from_timer(btv, t, timeout);
 	struct bttv_buffer_set old,new;
 	struct bttv_buffer *ovbi;
 	struct bttv_buffer *item;
@@ -4043,7 +4043,7 @@ static int bttv_probe(struct pci_dev *dev, const struct pci_device_id *pci_id)
 	INIT_LIST_HEAD(&btv->capture);
 	INIT_LIST_HEAD(&btv->vcapture);
 
-	setup_timer(&btv->timeout, bttv_irq_timeout, (unsigned long)btv);
+	timer_setup(&btv->timeout, bttv_irq_timeout, 0);
 
 	btv->i2c_rc = -1;
 	btv->tuner_type  = UNSET;
diff --git a/drivers/media/pci/bt8xx/bttv-input.c b/drivers/media/pci/bt8xx/bttv-input.c
index 73d655d073d6..ac7674700685 100644
--- a/drivers/media/pci/bt8xx/bttv-input.c
+++ b/drivers/media/pci/bt8xx/bttv-input.c
@@ -133,10 +133,10 @@ void bttv_input_irq(struct bttv *btv)
 		ir_handle_key(btv);
 }
 
-static void bttv_input_timer(unsigned long data)
+static void bttv_input_timer(struct timer_list *t)
 {
-	struct bttv *btv = (struct bttv*)data;
-	struct bttv_ir *ir = btv->remote;
+	struct bttv_ir *ir = from_timer(ir, t, timer);
+	struct bttv *btv = ir->btv;
 
 	if (btv->c.type == BTTV_BOARD_ENLTV_FM_2)
 		ir_enltv_handle_key(btv);
@@ -189,9 +189,9 @@ static u32 bttv_rc5_decode(unsigned int code)
 	return rc5;
 }
 
-static void bttv_rc5_timer_end(unsigned long data)
+static void bttv_rc5_timer_end(struct timer_list *t)
 {
-	struct bttv_ir *ir = (struct bttv_ir *)data;
+	struct bttv_ir *ir = from_timer(ir, t, timer);
 	ktime_t tv;
 	u32 gap, rc5, scancode;
 	u8 toggle, command, system;
@@ -296,15 +296,15 @@ static int bttv_rc5_irq(struct bttv *btv)
 
 /* ---------------------------------------------------------------------- */
 
-static void bttv_ir_start(struct bttv *btv, struct bttv_ir *ir)
+static void bttv_ir_start(struct bttv_ir *ir)
 {
 	if (ir->polling) {
-		setup_timer(&ir->timer, bttv_input_timer, (unsigned long)btv);
+		timer_setup(&ir->timer, bttv_input_timer, 0);
 		ir->timer.expires  = jiffies + msecs_to_jiffies(1000);
 		add_timer(&ir->timer);
 	} else if (ir->rc5_gpio) {
 		/* set timer_end for code completion */
-		setup_timer(&ir->timer, bttv_rc5_timer_end, (unsigned long)ir);
+		timer_setup(&ir->timer, bttv_rc5_timer_end, 0);
 		ir->shift_by = 1;
 		ir->rc5_remote_gap = ir_rc5_remote_gap;
 	}
@@ -531,6 +531,7 @@ int bttv_input_init(struct bttv *btv)
 
 	/* init input device */
 	ir->dev = rc;
+	ir->btv = btv;
 
 	snprintf(ir->name, sizeof(ir->name), "bttv IR (card=%d)",
 		 btv->c.type);
@@ -553,7 +554,7 @@ int bttv_input_init(struct bttv *btv)
 	rc->driver_name = MODULE_NAME;
 
 	btv->remote = ir;
-	bttv_ir_start(btv, ir);
+	bttv_ir_start(ir);
 
 	/* all done */
 	err = rc_register_device(rc);
diff --git a/drivers/media/pci/bt8xx/bttvp.h b/drivers/media/pci/bt8xx/bttvp.h
index 9efc4559fa8e..47f9b42b9879 100644
--- a/drivers/media/pci/bt8xx/bttvp.h
+++ b/drivers/media/pci/bt8xx/bttvp.h
@@ -122,6 +122,7 @@ struct bttv_format {
 
 struct bttv_ir {
 	struct rc_dev           *dev;
+	struct bttv		*btv;
 	struct timer_list       timer;
 
 	char                    name[32];
diff --git a/drivers/media/pci/cx18/cx18-fileops.c b/drivers/media/pci/cx18/cx18-fileops.c
index 98467b2089fa..4f9c2395941b 100644
--- a/drivers/media/pci/cx18/cx18-fileops.c
+++ b/drivers/media/pci/cx18/cx18-fileops.c
@@ -684,9 +684,9 @@ int cx18_v4l2_mmap(struct file *file, struct vm_area_struct *vma)
 	return -EINVAL;
 }
 
-void cx18_vb_timeout(unsigned long data)
+void cx18_vb_timeout(struct timer_list *t)
 {
-	struct cx18_stream *s = (struct cx18_stream *)data;
+	struct cx18_stream *s = from_timer(s, t, vb_timeout);
 	struct cx18_videobuf_buffer *buf;
 	unsigned long flags;
 
diff --git a/drivers/media/pci/cx18/cx18-fileops.h b/drivers/media/pci/cx18/cx18-fileops.h
index 58b00b433708..37ef34e866cb 100644
--- a/drivers/media/pci/cx18/cx18-fileops.h
+++ b/drivers/media/pci/cx18/cx18-fileops.h
@@ -29,7 +29,7 @@ void cx18_stop_capture(struct cx18_open_id *id, int gop_end);
 void cx18_mute(struct cx18 *cx);
 void cx18_unmute(struct cx18 *cx);
 int cx18_v4l2_mmap(struct file *file, struct vm_area_struct *vma);
-void cx18_vb_timeout(unsigned long data);
+void cx18_vb_timeout(struct timer_list *t);
 
 /* Shared with cx18-alsa module */
 int cx18_claim_stream(struct cx18_open_id *id, int type);
diff --git a/drivers/media/pci/cx18/cx18-streams.c b/drivers/media/pci/cx18/cx18-streams.c
index 8385411af641..f35f78d66985 100644
--- a/drivers/media/pci/cx18/cx18-streams.c
+++ b/drivers/media/pci/cx18/cx18-streams.c
@@ -282,7 +282,7 @@ static void cx18_stream_init(struct cx18 *cx, int type)
 	INIT_WORK(&s->out_work_order, cx18_out_work_handler);
 
 	INIT_LIST_HEAD(&s->vb_capture);
-	setup_timer(&s->vb_timeout, cx18_vb_timeout, (unsigned long)s);
+	timer_setup(&s->vb_timeout, cx18_vb_timeout, 0);
 	spin_lock_init(&s->vb_lock);
 	if (type == CX18_ENC_STREAM_TYPE_YUV) {
 		spin_lock_init(&s->vbuf_q_lock);
diff --git a/drivers/media/pci/ivtv/ivtv-driver.c b/drivers/media/pci/ivtv/ivtv-driver.c
index 54dcac4b2229..6b2ffdc96961 100644
--- a/drivers/media/pci/ivtv/ivtv-driver.c
+++ b/drivers/media/pci/ivtv/ivtv-driver.c
@@ -770,8 +770,7 @@ static int ivtv_init_struct1(struct ivtv *itv)
 	init_waitqueue_head(&itv->event_waitq);
 	init_waitqueue_head(&itv->vsync_waitq);
 	init_waitqueue_head(&itv->dma_waitq);
-	setup_timer(&itv->dma_timer, ivtv_unfinished_dma,
-		    (unsigned long)itv);
+	timer_setup(&itv->dma_timer, ivtv_unfinished_dma, 0);
 
 	itv->cur_dma_stream = -1;
 	itv->cur_pio_stream = -1;
diff --git a/drivers/media/pci/ivtv/ivtv-irq.c b/drivers/media/pci/ivtv/ivtv-irq.c
index 6efe1f71262c..63b09bf73bf0 100644
--- a/drivers/media/pci/ivtv/ivtv-irq.c
+++ b/drivers/media/pci/ivtv/ivtv-irq.c
@@ -1074,9 +1074,9 @@ irqreturn_t ivtv_irq_handler(int irq, void *dev_id)
 	return vsync_force ? IRQ_NONE : IRQ_HANDLED;
 }
 
-void ivtv_unfinished_dma(unsigned long arg)
+void ivtv_unfinished_dma(struct timer_list *t)
 {
-	struct ivtv *itv = (struct ivtv *)arg;
+	struct ivtv *itv = from_timer(itv, t, dma_timer);
 
 	if (!test_bit(IVTV_F_I_DMA, &itv->i_flags))
 		return;
diff --git a/drivers/media/pci/ivtv/ivtv-irq.h b/drivers/media/pci/ivtv/ivtv-irq.h
index 1e84433737cc..bcab5f07d37f 100644
--- a/drivers/media/pci/ivtv/ivtv-irq.h
+++ b/drivers/media/pci/ivtv/ivtv-irq.h
@@ -48,6 +48,6 @@ irqreturn_t ivtv_irq_handler(int irq, void *dev_id);
 
 void ivtv_irq_work_handler(struct kthread_work *work);
 void ivtv_dma_stream_dec_prepare(struct ivtv_stream *s, u32 offset, int lock);
-void ivtv_unfinished_dma(unsigned long arg);
+void ivtv_unfinished_dma(struct timer_list *t);
 
 #endif
diff --git a/drivers/media/pci/netup_unidvb/netup_unidvb_core.c b/drivers/media/pci/netup_unidvb/netup_unidvb_core.c
index 60e6cd5b3a03..11829c0fa138 100644
--- a/drivers/media/pci/netup_unidvb/netup_unidvb_core.c
+++ b/drivers/media/pci/netup_unidvb/netup_unidvb_core.c
@@ -638,9 +638,9 @@ static void netup_unidvb_queue_cleanup(struct netup_dma *dma)
 	spin_unlock_irqrestore(&dma->lock, flags);
 }
 
-static void netup_unidvb_dma_timeout(unsigned long data)
+static void netup_unidvb_dma_timeout(struct timer_list *t)
 {
-	struct netup_dma *dma = (struct netup_dma *)data;
+	struct netup_dma *dma = from_timer(dma, t, timeout);
 	struct netup_unidvb_dev *ndev = dma->ndev;
 
 	dev_dbg(&ndev->pci_dev->dev, "%s()\n", __func__);
@@ -664,8 +664,7 @@ static int netup_unidvb_dma_init(struct netup_unidvb_dev *ndev, int num)
 	spin_lock_init(&dma->lock);
 	INIT_WORK(&dma->work, netup_unidvb_dma_worker);
 	INIT_LIST_HEAD(&dma->free_buffers);
-	setup_timer(&dma->timeout, netup_unidvb_dma_timeout,
-		    (unsigned long)dma);
+	timer_setup(&dma->timeout, netup_unidvb_dma_timeout, 0);
 	dma->ring_buffer_size = ndev->dma_size / 2;
 	dma->addr_virt = ndev->dma_virt + dma->ring_buffer_size * num;
 	dma->addr_phys = (dma_addr_t)((u64)ndev->dma_phys +
diff --git a/drivers/media/pci/ttpci/av7110_ir.c b/drivers/media/pci/ttpci/av7110_ir.c
index a883caa6488c..1e0684665eea 100644
--- a/drivers/media/pci/ttpci/av7110_ir.c
+++ b/drivers/media/pci/ttpci/av7110_ir.c
@@ -84,9 +84,9 @@ static u16 default_key_map [256] = {
 
 
 /* key-up timer */
-static void av7110_emit_keyup(unsigned long parm)
+static void av7110_emit_keyup(struct timer_list *t)
 {
-	struct infrared *ir = (struct infrared *) parm;
+	struct infrared *ir = from_timer(ir, t, keyup_timer);
 
 	if (!ir || !test_bit(ir->last_key, ir->input_dev->key))
 		return;
@@ -334,8 +334,7 @@ int av7110_ir_init(struct av7110 *av7110)
 	av_list[av_cnt++] = av7110;
 	av7110_check_ir_config(av7110, true);
 
-	setup_timer(&av7110->ir.keyup_timer, av7110_emit_keyup,
-		    (unsigned long)&av7110->ir);
+	timer_setup(&av7110->ir.keyup_timer, av7110_emit_keyup, 0);
 
 	input_dev = input_allocate_device();
 	if (!input_dev)
diff --git a/drivers/media/pci/tw686x/tw686x-core.c b/drivers/media/pci/tw686x/tw686x-core.c
index 336e2f9bc1b6..c74c23cf8ced 100644
--- a/drivers/media/pci/tw686x/tw686x-core.c
+++ b/drivers/media/pci/tw686x/tw686x-core.c
@@ -126,9 +126,9 @@ void tw686x_enable_channel(struct tw686x_dev *dev, unsigned int channel)
  * channels "too fast" which makes some TW686x devices very
  * angry and freeze the CPU (see note 1).
  */
-static void tw686x_dma_delay(unsigned long data)
+static void tw686x_dma_delay(struct timer_list *t)
 {
-	struct tw686x_dev *dev = (struct tw686x_dev *)data;
+	struct tw686x_dev *dev = from_timer(dev, t, dma_delay_timer);
 	unsigned long flags;
 
 	spin_lock_irqsave(&dev->lock, flags);
@@ -325,8 +325,7 @@ static int tw686x_probe(struct pci_dev *pci_dev,
 		goto iounmap;
 	}
 
-	setup_timer(&dev->dma_delay_timer,
-		    tw686x_dma_delay, (unsigned long) dev);
+	timer_setup(&dev->dma_delay_timer, tw686x_dma_delay, 0);
 
 	/*
 	 * This must be set right before initializing v4l2_dev.
-- 
2.7.4


-- 
Kees Cook
Pixel Security
