Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:35284 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754524Ab2DKIYK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Apr 2012 04:24:10 -0400
Received: by eekc41 with SMTP id c41so137010eek.19
        for <linux-media@vger.kernel.org>; Wed, 11 Apr 2012 01:24:09 -0700 (PDT)
From: Gianluca Gennari <gennarone@gmail.com>
To: linux-media@vger.kernel.org, mchehab@redhat.com
Cc: hans.verkuil@cisco.com, Gianluca Gennari <gennarone@gmail.com>
Subject: [PATCH] media_build: fix v2.6.32_kfifo backport patch
Date: Wed, 11 Apr 2012 10:24:00 +0200
Message-Id: <1334132640-20201-1-git-send-email-gennarone@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch:
http://patchwork.linuxtv.org/patch/10425/
collides with the v2.6.32_kfifo backport patch.
Fix it and rebase it on the new media_build tree.

Signed-off-by: Gianluca Gennari <gennarone@gmail.com>
---
 backports/v2.6.32_kfifo.patch |  130 ++++++++++++++++++++++-------------------
 1 files changed, 70 insertions(+), 60 deletions(-)

diff --git a/backports/v2.6.32_kfifo.patch b/backports/v2.6.32_kfifo.patch
index 10075b9..21769a8 100644
--- a/backports/v2.6.32_kfifo.patch
+++ b/backports/v2.6.32_kfifo.patch
@@ -1,36 +1,34 @@
 ---
- drivers/media/rc/ir-raw.c                |   14 +++----
- drivers/media/rc/rc-core-priv.h          |    2 -
- drivers/media/video/cx23885/cx23888-ir.c |   33 ++++++-----------
+ drivers/media/rc/ir-raw.c                |   16 ++++----
+ drivers/media/rc/rc-core-priv.h          |    2 +-
+ drivers/media/video/cx23885/cx23888-ir.c |   33 ++++++----------
  drivers/media/video/cx25840/cx25840-ir.c |   28 +++++---------
- drivers/media/video/meye.c               |   60 ++++++++++++++-----------------
+ drivers/media/video/meye.c               |   60 ++++++++++++++----------------
  drivers/media/video/meye.h               |    4 +-
  include/media/lirc_dev.h                 |   50 +++++++++----------------
- 7 files changed, 79 insertions(+), 112 deletions(-)
+ 7 files changed, 80 insertions(+), 113 deletions(-)
 
---- linux.orig/drivers/media/rc/rc-core-priv.h
-+++ linux/drivers/media/rc/rc-core-priv.h
-@@ -35,7 +35,7 @@ struct ir_raw_event_ctrl {
- 	struct list_head		list;		/* to keep track of raw clients */
- 	struct task_struct		*thread;
- 	spinlock_t			lock;
--	struct kfifo			kfifo;		/* fifo for the pulse/space durations */
-+	struct kfifo			*kfifo;		/* fifo for the pulse/space durations */
- 	ktime_t				last_event;	/* when last event occurred */
- 	enum raw_event_type		last_type;	/* last event type */
- 	struct rc_dev			*dev;		/* pointer to the parent rc_dev */
---- linux.orig/drivers/media/rc/ir-raw.c
-+++ linux/drivers/media/rc/ir-raw.c
-@@ -44,7 +44,7 @@ static int ir_raw_event_thread(void *dat
+--- a/drivers/media/rc/ir-raw.c
++++ b/drivers/media/rc/ir-raw.c
+@@ -45,7 +45,7 @@ static int ir_raw_event_thread(void *data)
  	while (!kthread_should_stop()) {
  
  		spin_lock_irq(&raw->lock);
+-		retval = kfifo_len(&raw->kfifo);
++		retval = kfifo_len(raw->kfifo);
+ 
+ 		if (retval < sizeof(ev)) {
+ 			set_current_state(TASK_INTERRUPTIBLE);
+@@ -58,7 +58,7 @@ static int ir_raw_event_thread(void *data)
+ 			continue;
+ 		}
+ 
 -		retval = kfifo_out(&raw->kfifo, &ev, sizeof(ev));
 +		retval = __kfifo_get(raw->kfifo, (void *)&ev, sizeof(ev));
+ 		spin_unlock_irq(&raw->lock);
  
- 		if (!retval) {
- 			set_current_state(TASK_INTERRUPTIBLE);
-@@ -90,7 +90,7 @@ int ir_raw_event_store(struct rc_dev *de
+ 		mutex_lock(&ir_raw_handler_lock);
+@@ -89,7 +89,7 @@ int ir_raw_event_store(struct rc_dev *dev, struct ir_raw_event *ev)
  	IR_dprintk(2, "sample: (%05dus %s)\n",
  		   TO_US(ev->duration), TO_STR(ev->pulse));
  
@@ -39,7 +37,7 @@
  		return -ENOMEM;
  
  	return 0;
-@@ -258,11 +258,11 @@ int ir_raw_event_register(struct rc_dev 
+@@ -259,11 +259,11 @@ int ir_raw_event_register(struct rc_dev *dev)
  
  	dev->raw->dev = dev;
  	dev->raw->enabled_protocols = ~0;
@@ -55,7 +53,7 @@
  
  	spin_lock_init(&dev->raw->lock);
  	dev->raw->thread = kthread_run(ir_raw_event_thread, dev->raw,
-@@ -304,7 +304,7 @@ void ir_raw_event_unregister(struct rc_d
+@@ -305,7 +305,7 @@ void ir_raw_event_unregister(struct rc_dev *dev)
  			handler->raw_unregister(dev);
  	mutex_unlock(&ir_raw_handler_lock);
  
@@ -64,8 +62,19 @@
  	kfree(dev->raw);
  	dev->raw = NULL;
  }
---- linux.orig/drivers/media/video/cx23885/cx23888-ir.c
-+++ linux/drivers/media/video/cx23885/cx23888-ir.c
+--- a/drivers/media/rc/rc-core-priv.h
++++ b/drivers/media/rc/rc-core-priv.h
+@@ -35,7 +35,7 @@ struct ir_raw_event_ctrl {
+ 	struct list_head		list;		/* to keep track of raw clients */
+ 	struct task_struct		*thread;
+ 	spinlock_t			lock;
+-	struct kfifo			kfifo;		/* fifo for the pulse/space durations */
++	struct kfifo			*kfifo;		/* fifo for the pulse/space durations */
+ 	ktime_t				last_event;	/* when last event occurred */
+ 	enum raw_event_type		last_type;	/* last event type */
+ 	struct rc_dev			*dev;		/* pointer to the parent rc_dev */
+--- a/drivers/media/video/cx23885/cx23888-ir.c
++++ b/drivers/media/video/cx23885/cx23888-ir.c
 @@ -138,7 +138,7 @@ struct cx23888_ir_state {
  	atomic_t rxclk_divider;
  	atomic_t rx_invert;
@@ -75,7 +84,7 @@
  	spinlock_t rx_kfifo_lock;
  
  	struct v4l2_subdev_ir_parameters tx_params;
-@@ -540,7 +540,6 @@ static int cx23888_ir_irq_handler(struct
+@@ -540,7 +540,6 @@ static int cx23888_ir_irq_handler(struct v4l2_subdev *sd, u32 status,
  {
  	struct cx23888_ir_state *state = to_state(sd);
  	struct cx23885_dev *dev = state->dev;
@@ -83,7 +92,7 @@
  
  	u32 cntrl = cx23888_ir_read4(dev, CX23888_IR_CNTRL_REG);
  	u32 irqen = cx23888_ir_read4(dev, CX23888_IR_IRQEN_REG);
-@@ -613,10 +612,9 @@ static int cx23888_ir_irq_handler(struct
+@@ -613,10 +612,9 @@ static int cx23888_ir_irq_handler(struct v4l2_subdev *sd, u32 status,
  			}
  			if (i == 0)
  				break;
@@ -97,7 +106,7 @@
  			if (k != j)
  				kror++; /* rx_kfifo over run */
  		}
-@@ -653,10 +651,8 @@ static int cx23888_ir_irq_handler(struct
+@@ -653,10 +651,8 @@ static int cx23888_ir_irq_handler(struct v4l2_subdev *sd, u32 status,
  		*handled = true;
  	}
  
@@ -109,7 +118,7 @@
  
  	if (events)
  		v4l2_subdev_notify(sd, V4L2_SUBDEV_IR_RX_NOTIFY, &events);
-@@ -682,7 +678,7 @@ static int cx23888_ir_rx_read(struct v4l
+@@ -682,7 +678,7 @@ static int cx23888_ir_rx_read(struct v4l2_subdev *sd, u8 *buf, size_t count,
  		return 0;
  	}
  
@@ -118,7 +127,7 @@
  
  	n /= sizeof(union cx23888_ir_fifo_rec);
  	*num = n * sizeof(union cx23888_ir_fifo_rec);
-@@ -817,12 +813,7 @@ static int cx23888_ir_rx_s_parameters(st
+@@ -821,12 +817,7 @@ static int cx23888_ir_rx_s_parameters(struct v4l2_subdev *sd,
  	o->interrupt_enable = p->interrupt_enable;
  	o->enable = p->enable;
  	if (p->enable) {
@@ -132,7 +141,7 @@
  		if (p->interrupt_enable)
  			irqenable_rx(dev, IRQEN_RSE | IRQEN_RTE | IRQEN_ROE);
  		control_rx_enable(dev, p->enable);
-@@ -1210,8 +1201,10 @@ int cx23888_ir_probe(struct cx23885_dev 
+@@ -1214,8 +1205,10 @@ int cx23888_ir_probe(struct cx23885_dev *dev)
  		return -ENOMEM;
  
  	spin_lock_init(&state->rx_kfifo_lock);
@@ -145,7 +154,7 @@
  
  	state->dev = dev;
  	state->id = V4L2_IDENT_CX23888_IR;
-@@ -1243,7 +1236,7 @@ int cx23888_ir_probe(struct cx23885_dev 
+@@ -1247,7 +1240,7 @@ int cx23888_ir_probe(struct cx23885_dev *dev)
  		       sizeof(struct v4l2_subdev_ir_parameters));
  		v4l2_subdev_call(sd, ir, tx_s_parameters, &default_params);
  	} else {
@@ -154,7 +163,7 @@
  	}
  	return ret;
  }
-@@ -1262,7 +1255,7 @@ int cx23888_ir_remove(struct cx23885_dev
+@@ -1266,7 +1259,7 @@ int cx23888_ir_remove(struct cx23885_dev *dev)
  
  	state = to_state(sd);
  	v4l2_device_unregister_subdev(sd);
@@ -163,9 +172,9 @@
  	kfree(state);
  	/* Nothing more to free() as state held the actual v4l2_subdev object */
  	return 0;
---- linux.orig/drivers/media/video/cx25840/cx25840-ir.c
-+++ linux/drivers/media/video/cx25840/cx25840-ir.c
-@@ -116,7 +116,7 @@ struct cx25840_ir_state {
+--- a/drivers/media/video/cx25840/cx25840-ir.c
++++ b/drivers/media/video/cx25840/cx25840-ir.c
+@@ -117,7 +117,7 @@ struct cx25840_ir_state {
  	atomic_t rxclk_divider;
  	atomic_t rx_invert;
  
@@ -174,7 +183,7 @@
  	spinlock_t rx_kfifo_lock; /* protect Rx data kfifo */
  
  	struct v4l2_subdev_ir_parameters tx_params;
-@@ -525,7 +525,6 @@ int cx25840_ir_irq_handler(struct v4l2_s
+@@ -526,7 +526,6 @@ int cx25840_ir_irq_handler(struct v4l2_subdev *sd, u32 status, bool *handled)
  	struct cx25840_state *state = to_state(sd);
  	struct cx25840_ir_state *ir_state = to_ir_state(sd);
  	struct i2c_client *c = NULL;
@@ -182,7 +191,7 @@
  
  	union cx25840_ir_fifo_rec rx_data[FIFO_RX_DEPTH];
  	unsigned int i, j, k;
-@@ -611,9 +610,8 @@ int cx25840_ir_irq_handler(struct v4l2_s
+@@ -612,9 +611,8 @@ int cx25840_ir_irq_handler(struct v4l2_subdev *sd, u32 status, bool *handled)
  			if (i == 0)
  				break;
  			j = i * sizeof(union cx25840_ir_fifo_rec);
@@ -194,7 +203,7 @@
  			if (k != j)
  				kror++; /* rx_kfifo over run */
  		}
-@@ -649,10 +647,8 @@ int cx25840_ir_irq_handler(struct v4l2_s
+@@ -650,10 +648,8 @@ int cx25840_ir_irq_handler(struct v4l2_subdev *sd, u32 status, bool *handled)
  		cx25840_write4(c, CX25840_IR_CNTRL_REG, cntrl);
  		*handled = true;
  	}
@@ -206,7 +215,7 @@
  
  	if (events)
  		v4l2_subdev_notify(sd, V4L2_SUBDEV_IR_RX_NOTIFY, &events);
-@@ -683,8 +679,7 @@ static int cx25840_ir_rx_read(struct v4l
+@@ -684,8 +680,7 @@ static int cx25840_ir_rx_read(struct v4l2_subdev *sd, u8 *buf, size_t count,
  		return 0;
  	}
  
@@ -216,7 +225,7 @@
  
  	n /= sizeof(union cx25840_ir_fifo_rec);
  	*num = n * sizeof(union cx25840_ir_fifo_rec);
-@@ -836,11 +831,7 @@ static int cx25840_ir_rx_s_parameters(st
+@@ -841,11 +836,7 @@ static int cx25840_ir_rx_s_parameters(struct v4l2_subdev *sd,
  	o->interrupt_enable = p->interrupt_enable;
  	o->enable = p->enable;
  	if (p->enable) {
@@ -229,7 +238,7 @@
  		if (p->interrupt_enable)
  			irqenable_rx(sd, IRQEN_RSE | IRQEN_RTE | IRQEN_ROE);
  		control_rx_enable(c, p->enable);
-@@ -1234,8 +1225,9 @@ int cx25840_ir_probe(struct v4l2_subdev 
+@@ -1239,8 +1230,9 @@ int cx25840_ir_probe(struct v4l2_subdev *sd)
  		return -ENOMEM;
  
  	spin_lock_init(&ir_state->rx_kfifo_lock);
@@ -241,7 +250,7 @@
  		kfree(ir_state);
  		return -ENOMEM;
  	}
-@@ -1273,7 +1265,7 @@ int cx25840_ir_remove(struct v4l2_subdev
+@@ -1278,7 +1270,7 @@ int cx25840_ir_remove(struct v4l2_subdev *sd)
  	cx25840_ir_rx_shutdown(sd);
  	cx25840_ir_tx_shutdown(sd);
  
@@ -250,8 +259,8 @@
  	kfree(ir_state);
  	state->ir_state = NULL;
  	return 0;
---- linux.orig/drivers/media/video/meye.c
-+++ linux/drivers/media/video/meye.c
+--- a/drivers/media/video/meye.c
++++ b/drivers/media/video/meye.c
 @@ -802,8 +802,8 @@ again:
  		return IRQ_HANDLED;
  
@@ -315,7 +324,7 @@
  	mutex_unlock(&meye.lock);
  
  	return 0;
-@@ -970,9 +967,7 @@ static int meyeioc_sync(struct file *fil
+@@ -970,9 +967,7 @@ static int meyeioc_sync(struct file *file, void *fh, int *i)
  		/* fall through */
  	case MEYE_BUF_DONE:
  		meye.grab_buffer[*i].state = MEYE_BUF_UNUSED;
@@ -326,7 +335,7 @@
  	}
  	*i = meye.grab_buffer[*i].size;
  	mutex_unlock(&meye.lock);
-@@ -1459,8 +1454,7 @@ static int vidioc_qbuf(struct file *file
+@@ -1459,8 +1454,7 @@ static int vidioc_qbuf(struct file *file, void *fh, struct v4l2_buffer *buf)
  	buf->flags |= V4L2_BUF_FLAG_QUEUED;
  	buf->flags &= ~V4L2_BUF_FLAG_DONE;
  	meye.grab_buffer[buf->index].state = MEYE_BUF_USING;
@@ -336,7 +345,7 @@
  	mutex_unlock(&meye.lock);
  
  	return 0;
-@@ -1475,19 +1469,19 @@ static int vidioc_dqbuf(struct file *fil
+@@ -1475,19 +1469,19 @@ static int vidioc_dqbuf(struct file *file, void *fh, struct v4l2_buffer *buf)
  
  	mutex_lock(&meye.lock);
  
@@ -360,7 +369,7 @@
  		mutex_unlock(&meye.lock);
  		return -EBUSY;
  	}
-@@ -1537,8 +1531,8 @@ static int vidioc_streamoff(struct file 
+@@ -1537,8 +1531,8 @@ static int vidioc_streamoff(struct file *file, void *fh, enum v4l2_buf_type i)
  {
  	mutex_lock(&meye.lock);
  	mchip_hic_stop();
@@ -371,7 +380,7 @@
  
  	for (i = 0; i < MEYE_MAX_BUFNBRS; i++)
  		meye.grab_buffer[i].state = MEYE_BUF_UNUSED;
-@@ -1581,7 +1575,7 @@ static unsigned int meye_poll(struct fil
+@@ -1581,7 +1575,7 @@ static unsigned int meye_poll(struct file *file, poll_table *wait)
  
  	mutex_lock(&meye.lock);
  	poll_wait(file, &meye.proc_list, wait);
@@ -380,7 +389,7 @@
  		res = POLLIN | POLLRDNORM;
  	mutex_unlock(&meye.lock);
  	return res;
-@@ -1760,14 +1754,16 @@ static int __devinit meye_probe(struct p
+@@ -1760,14 +1754,16 @@ static int __devinit meye_probe(struct pci_dev *pcidev,
  	}
  
  	spin_lock_init(&meye.grabq_lock);
@@ -413,7 +422,7 @@
  outkfifoalloc1:
  	vfree(meye.grab_temp);
  outvmalloc:
-@@ -1911,8 +1907,8 @@ static void __devexit meye_remove(struct
+@@ -1911,8 +1907,8 @@ static void __devexit meye_remove(struct pci_dev *pcidev)
  
  	sony_pic_camera_command(SONY_PIC_COMMAND_SETCAMERA, 0);
  
@@ -424,8 +433,8 @@
  
  	vfree(meye.grab_temp);
  
---- linux.orig/drivers/media/video/meye.h
-+++ linux/drivers/media/video/meye.h
+--- a/drivers/media/video/meye.h
++++ b/drivers/media/video/meye.h
 @@ -304,9 +304,9 @@ struct meye {
  	struct meye_grab_buffer grab_buffer[MEYE_MAX_BUFNBRS];
  	int vma_use_count[MEYE_MAX_BUFNBRS]; /* mmap count */
@@ -438,8 +447,8 @@
  	spinlock_t doneq_lock;		/* lock protecting the queue */
  	wait_queue_head_t proc_list;	/* wait queue */
  	struct video_device *vdev;	/* video device parameters */
---- linux.orig/include/media/lirc_dev.h
-+++ linux/include/media/lirc_dev.h
+--- a/include/media/lirc_dev.h
++++ b/include/media/lirc_dev.h
 @@ -28,19 +28,15 @@ struct lirc_buffer {
  	unsigned int size; /* in chunks */
  	/* Using chunks instead of bytes pretends to simplify boundary checking
@@ -464,7 +473,7 @@
  		WARN(1, "calling %s on an uninitialized lirc_buffer\n",
  		     __func__);
  }
-@@ -49,25 +45,23 @@ static inline int lirc_buffer_init(struc
+@@ -49,25 +45,23 @@ static inline int lirc_buffer_init(struct lirc_buffer *buf,
  				    unsigned int chunk_size,
  				    unsigned int size)
  {
@@ -498,7 +507,7 @@
  		WARN(1, "calling %s on an uninitialized lirc_buffer\n",
  		     __func__);
  }
-@@ -75,11 +69,8 @@ static inline void lirc_buffer_free(stru
+@@ -75,11 +69,8 @@ static inline void lirc_buffer_free(struct lirc_buffer *buf)
  static inline int lirc_buffer_len(struct lirc_buffer *buf)
  {
  	int len;
@@ -511,7 +520,7 @@
  
  	return len;
  }
-@@ -102,24 +93,19 @@ static inline int lirc_buffer_available(
+@@ -102,24 +93,19 @@ static inline int lirc_buffer_available(struct lirc_buffer *buf)
  static inline unsigned int lirc_buffer_read(struct lirc_buffer *buf,
  					    unsigned char *dest)
  {
@@ -541,3 +550,4 @@
  }
  
  struct lirc_driver {
+
-- 
1.7.0.4

