Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.anw.at ([195.234.101.228]:37458 "EHLO mail.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753192AbdJMXwT (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 13 Oct 2017 19:52:19 -0400
From: "Jasmin J." <jasmin@anw.at>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, d.scheller@gmx.net, jasmin@anw.at
Subject: [PATCH] build: Fixed patches partly for Kernel 2.6.32
Date: Sat, 14 Oct 2017 01:52:11 +0200
Message-Id: <1507938731-23816-1-git-send-email-jasmin@anw.at>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jasmin Jessich <jasmin@anw.at>

Signed-off-by: Jasmin Jessich <jasmin@anw.at>
---
 backports/v2.6.32_dvb_net.patch |  16 +--
 backports/v2.6.32_kfifo.patch   | 209 ++++++++++++++++++++--------------------
 2 files changed, 112 insertions(+), 113 deletions(-)

diff --git a/backports/v2.6.32_dvb_net.patch b/backports/v2.6.32_dvb_net.patch
index 76e1932..265d012 100644
--- a/backports/v2.6.32_dvb_net.patch
+++ b/backports/v2.6.32_dvb_net.patch
@@ -2,12 +2,12 @@ diff --git a/drivers/media/dvb-core/dvb_net.c b/drivers/media/dvb-core/dvb_net.c
 index f91c80c..d487c15 100644
 --- a/drivers/media/dvb-core/dvb_net.c
 +++ b/drivers/media/dvb-core/dvb_net.c
-@@ -653,7 +653,7 @@ static void dvb_net_ule( struct net_device *dev, const u8 *buf, size_t buf_len )
- 				dev_kfree_skb(priv->ule_skb);
- 			} else {
- 				/* CRC32 verified OK. */
--				u8 dest_addr[ETH_ALEN];
-+				u8 dest_addr[ETH_ALEN] = { 0 };
- 				static const u8 bc_addr[ETH_ALEN] =
- 					{ [ 0 ... ETH_ALEN-1] = 0xff };
+@@ -662,7 +662,7 @@
+ static void dvb_net_ule_check_crc(struct dvb_net_ule_handle *h,
+ 				  u32 ule_crc, u32 expected_crc)
+ {
+-	u8 dest_addr[ETH_ALEN];
++	u8 dest_addr[ETH_ALEN] = { 0 };
  
+ 	if (ule_crc != expected_crc) {
+ 		pr_warn("%lu: CRC32 check FAILED: %08x / %08x, SNDU len %d type %#x, ts_remain %d, next 2: %x.\n",
diff --git a/backports/v2.6.32_kfifo.patch b/backports/v2.6.32_kfifo.patch
index 2bf6131..2276d0e 100644
--- a/backports/v2.6.32_kfifo.patch
+++ b/backports/v2.6.32_kfifo.patch
@@ -2,7 +2,7 @@ diff --git a/drivers/media/i2c/cx25840/cx25840-ir.c b/drivers/media/i2c/cx25840/
 index 4cf8f18..facb846 100644
 --- a/drivers/media/i2c/cx25840/cx25840-ir.c
 +++ b/drivers/media/i2c/cx25840/cx25840-ir.c
-@@ -117,7 +117,7 @@ struct cx25840_ir_state {
+@@ -112,7 +112,7 @@ struct cx25840_ir_state {
  	atomic_t rxclk_divider;
  	atomic_t rx_invert;
  
@@ -11,7 +11,7 @@ index 4cf8f18..facb846 100644
  	spinlock_t rx_kfifo_lock; /* protect Rx data kfifo */
  
  	struct v4l2_subdev_ir_parameters tx_params;
-@@ -524,7 +524,6 @@ int cx25840_ir_irq_handler(struct v4l2_subdev *sd, u32 status, bool *handled)
+@@ -519,7 +519,6 @@ int cx25840_ir_irq_handler(struct v4l2_subdev *sd, u32 status, bool *handled)
  	struct cx25840_state *state = to_state(sd);
  	struct cx25840_ir_state *ir_state = to_ir_state(sd);
  	struct i2c_client *c = NULL;
@@ -19,7 +19,7 @@ index 4cf8f18..facb846 100644
  
  	union cx25840_ir_fifo_rec rx_data[FIFO_RX_DEPTH];
  	unsigned int i, j, k;
-@@ -610,9 +609,8 @@ int cx25840_ir_irq_handler(struct v4l2_subdev *sd, u32 status, bool *handled)
+@@ -605,9 +604,8 @@ int cx25840_ir_irq_handler(struct v4l2_subdev *sd, u32 status, bool *handled)
  			if (i == 0)
  				break;
  			j = i * sizeof(union cx25840_ir_fifo_rec);
@@ -31,7 +31,7 @@ index 4cf8f18..facb846 100644
  			if (k != j)
  				kror++; /* rx_kfifo over run */
  		}
-@@ -648,10 +646,8 @@ int cx25840_ir_irq_handler(struct v4l2_subdev *sd, u32 status, bool *handled)
+@@ -643,10 +641,8 @@ int cx25840_ir_irq_handler(struct v4l2_subdev *sd, u32 status, bool *handled)
  		cx25840_write4(c, CX25840_IR_CNTRL_REG, cntrl);
  		*handled = true;
  	}
@@ -43,7 +43,7 @@ index 4cf8f18..facb846 100644
  
  	if (events)
  		v4l2_subdev_notify(sd, V4L2_SUBDEV_IR_RX_NOTIFY, &events);
-@@ -682,8 +678,7 @@ static int cx25840_ir_rx_read(struct v4l2_subdev *sd, u8 *buf, size_t count,
+@@ -677,8 +673,7 @@ static int cx25840_ir_rx_read(struct v4l2_subdev *sd, u8 *buf, size_t count,
  		return 0;
  	}
  
@@ -53,7 +53,7 @@ index 4cf8f18..facb846 100644
  
  	n /= sizeof(union cx25840_ir_fifo_rec);
  	*num = n * sizeof(union cx25840_ir_fifo_rec);
-@@ -839,11 +834,7 @@ static int cx25840_ir_rx_s_parameters(struct v4l2_subdev *sd,
+@@ -834,11 +829,7 @@ static int cx25840_ir_rx_s_parameters(struct v4l2_subdev *sd,
  	o->interrupt_enable = p->interrupt_enable;
  	o->enable = p->enable;
  	if (p->enable) {
@@ -66,7 +66,7 @@ index 4cf8f18..facb846 100644
  		if (p->interrupt_enable)
  			irqenable_rx(sd, IRQEN_RSE | IRQEN_RTE | IRQEN_ROE);
  		control_rx_enable(c, p->enable);
-@@ -1235,8 +1226,9 @@ int cx25840_ir_probe(struct v4l2_subdev *sd)
+@@ -1229,8 +1220,9 @@ int cx25840_ir_probe(struct v4l2_subdev *sd)
  		return -ENOMEM;
  
  	spin_lock_init(&ir_state->rx_kfifo_lock);
@@ -78,7 +78,7 @@ index 4cf8f18..facb846 100644
  		return -ENOMEM;
  
  	ir_state->c = state->c;
-@@ -1270,7 +1262,7 @@ int cx25840_ir_remove(struct v4l2_subdev *sd)
+@@ -1264,7 +1256,7 @@ int cx25840_ir_remove(struct v4l2_subdev *sd)
  	cx25840_ir_rx_shutdown(sd);
  	cx25840_ir_tx_shutdown(sd);
  
@@ -157,7 +157,7 @@ index c1aa888..b04d70c 100644
  		if (p->interrupt_enable)
  			irqenable_rx(dev, IRQEN_RSE | IRQEN_RTE | IRQEN_ROE);
  		control_rx_enable(dev, p->enable);
-@@ -1179,8 +1170,10 @@ int cx23888_ir_probe(struct cx23885_dev *dev)
+@@ -1178,8 +1169,10 @@ int cx23888_ir_probe(struct cx23885_dev *dev)
  		return -ENOMEM;
  
  	spin_lock_init(&state->rx_kfifo_lock);
@@ -170,7 +170,7 @@ index c1aa888..b04d70c 100644
  
  	state->dev = dev;
  	sd = &state->sd;
-@@ -1208,7 +1201,7 @@ int cx23888_ir_probe(struct cx23885_dev *dev)
+@@ -1207,7 +1200,7 @@ int cx23888_ir_probe(struct cx23885_dev *dev)
  		default_params = default_tx_params;
  		v4l2_subdev_call(sd, ir, tx_s_parameters, &default_params);
  	} else {
@@ -179,7 +179,7 @@ index c1aa888..b04d70c 100644
  	}
  	return ret;
  }
-@@ -1227,7 +1220,7 @@ int cx23888_ir_remove(struct cx23885_dev *dev)
+@@ -1226,7 +1219,7 @@ int cx23888_ir_remove(struct cx23885_dev *dev)
  
  	state = to_state(sd);
  	v4l2_device_unregister_subdev(sd);
@@ -192,7 +192,7 @@ diff --git a/drivers/media/pci/meye/meye.c b/drivers/media/pci/meye/meye.c
 index aeae547..3d85fff 100644
 --- a/drivers/media/pci/meye/meye.c
 +++ b/drivers/media/pci/meye/meye.c
-@@ -804,8 +804,8 @@ again:
+@@ -796,8 +796,8 @@ again:
  		return IRQ_HANDLED;
  
  	if (meye.mchip_mode == MCHIP_HIC_MODE_CONT_OUT) {
@@ -203,7 +203,7 @@ index aeae547..3d85fff 100644
  			mchip_free_frame();
  			return IRQ_HANDLED;
  		}
-@@ -815,8 +815,7 @@ again:
+@@ -807,8 +807,7 @@ again:
  		meye.grab_buffer[reqnr].state = MEYE_BUF_DONE;
  		v4l2_get_timestamp(&meye.grab_buffer[reqnr].timestamp);
  		meye.grab_buffer[reqnr].sequence = sequence++;
@@ -213,7 +213,7 @@ index aeae547..3d85fff 100644
  		wake_up_interruptible(&meye.proc_list);
  	} else {
  		int size;
-@@ -825,8 +824,8 @@ again:
+@@ -817,8 +816,8 @@ again:
  			mchip_free_frame();
  			goto again;
  		}
@@ -224,7 +224,7 @@ index aeae547..3d85fff 100644
  			mchip_free_frame();
  			goto again;
  		}
-@@ -836,8 +835,7 @@ again:
+@@ -828,8 +827,7 @@ again:
  		meye.grab_buffer[reqnr].state = MEYE_BUF_DONE;
  		v4l2_get_timestamp(&meye.grab_buffer[reqnr].timestamp);
  		meye.grab_buffer[reqnr].sequence = sequence++;
@@ -234,7 +234,7 @@ index aeae547..3d85fff 100644
  		wake_up_interruptible(&meye.proc_list);
  	}
  	mchip_free_frame();
-@@ -865,8 +863,8 @@ static int meye_open(struct file *file)
+@@ -857,8 +855,8 @@ static int meye_open(struct file *file)
  
  	for (i = 0; i < MEYE_MAX_BUFNBRS; i++)
  		meye.grab_buffer[i].state = MEYE_BUF_UNUSED;
@@ -245,7 +245,7 @@ index aeae547..3d85fff 100644
  	return v4l2_fh_open(file);
  }
  
-@@ -939,8 +937,7 @@ static int meyeioc_qbuf_capt(int *nb)
+@@ -931,8 +929,7 @@ static int meyeioc_qbuf_capt(int *nb)
  		mchip_cont_compression_start();
  
  	meye.grab_buffer[*nb].state = MEYE_BUF_USING;
@@ -255,7 +255,7 @@ index aeae547..3d85fff 100644
  	mutex_unlock(&meye.lock);
  
  	return 0;
-@@ -972,9 +969,7 @@ static int meyeioc_sync(struct file *file, void *fh, int *i)
+@@ -964,9 +961,7 @@ static int meyeioc_sync(struct file *file, void *fh, int *i)
  		/* fall through */
  	case MEYE_BUF_DONE:
  		meye.grab_buffer[*i].state = MEYE_BUF_UNUSED;
@@ -266,7 +266,7 @@ index aeae547..3d85fff 100644
  	}
  	*i = meye.grab_buffer[*i].size;
  	mutex_unlock(&meye.lock);
-@@ -1319,8 +1314,7 @@ static int vidioc_qbuf(struct file *file, void *fh, struct v4l2_buffer *buf)
+@@ -1307,8 +1302,7 @@ static int vidioc_qbuf(struct file *file, void *fh, struct v4l2_buffer *buf)
  	buf->flags |= V4L2_BUF_FLAG_QUEUED;
  	buf->flags &= ~V4L2_BUF_FLAG_DONE;
  	meye.grab_buffer[buf->index].state = MEYE_BUF_USING;
@@ -276,7 +276,7 @@ index aeae547..3d85fff 100644
  	mutex_unlock(&meye.lock);
  
  	return 0;
-@@ -1335,19 +1329,19 @@ static int vidioc_dqbuf(struct file *file, void *fh, struct v4l2_buffer *buf)
+@@ -1323,19 +1317,19 @@ static int vidioc_dqbuf(struct file *file, void *fh, struct v4l2_buffer *buf)
  
  	mutex_lock(&meye.lock);
  
@@ -300,7 +300,7 @@ index aeae547..3d85fff 100644
  		mutex_unlock(&meye.lock);
  		return -EBUSY;
  	}
-@@ -1397,8 +1391,8 @@ static int vidioc_streamoff(struct file *file, void *fh, enum v4l2_buf_type i)
+@@ -1385,8 +1379,8 @@ static int vidioc_streamoff(struct file *file, void *fh, enum v4l2_buf_type i)
  {
  	mutex_lock(&meye.lock);
  	mchip_hic_stop();
@@ -311,7 +311,7 @@ index aeae547..3d85fff 100644
  
  	for (i = 0; i < MEYE_MAX_BUFNBRS; i++)
  		meye.grab_buffer[i].state = MEYE_BUF_UNUSED;
-@@ -1441,7 +1435,7 @@ static unsigned int meye_poll(struct file *file, poll_table *wait)
+@@ -1429,7 +1423,7 @@ static unsigned int meye_poll(struct file *file, poll_table *wait)
  
  	mutex_lock(&meye.lock);
  	poll_wait(file, &meye.proc_list, wait);
@@ -320,28 +320,27 @@ index aeae547..3d85fff 100644
  		res |= POLLIN | POLLRDNORM;
  	mutex_unlock(&meye.lock);
  	return res;
-@@ -1649,14 +1643,16 @@ static int meye_probe(struct pci_dev *pcidev, const struct pci_device_id *ent)
- 	}
+@@ -1630,13 +1624,15 @@ static int meye_probe(struct pci_dev *pcidev, const struct pci_device_id *ent)
+ 		goto outvmalloc;
  
  	spin_lock_init(&meye.grabq_lock);
 -	if (kfifo_alloc(&meye.grabq, sizeof(int) * MEYE_MAX_BUFNBRS,
--				GFP_KERNEL)) {
+-			GFP_KERNEL))
 +	meye.grabq = kfifo_alloc(sizeof(int) * MEYE_MAX_BUFNBRS, GFP_KERNEL,
-+				 &meye.grabq_lock);
-+	if (IS_ERR(meye.grabq)) {
- 		v4l2_err(v4l2_dev, "fifo allocation failed\n");
++		     &meye.grabq_lock);
++	if (IS_ERR(meye.grabq))
  		goto outkfifoalloc1;
- 	}
+ 
  	spin_lock_init(&meye.doneq_lock);
 -	if (kfifo_alloc(&meye.doneq, sizeof(int) * MEYE_MAX_BUFNBRS,
--				GFP_KERNEL)) {
+-			GFP_KERNEL))
 +	meye.doneq = kfifo_alloc(sizeof(int) * MEYE_MAX_BUFNBRS, GFP_KERNEL,
-+				 &meye.doneq_lock);
-+	if (IS_ERR(meye.doneq)) {
- 		v4l2_err(v4l2_dev, "fifo allocation failed\n");
++		     &meye.doneq_lock);
++	if (IS_ERR(meye.doneq))
  		goto outkfifoalloc2;
- 	}
-@@ -1774,9 +1770,9 @@ outregions:
+ 
+ 	meye.vdev = meye_template;
+@@ -1753,9 +1749,9 @@ outregions:
  outenabledev:
  	sony_pic_camera_command(SONY_PIC_COMMAND_SETCAMERA, 0);
  outsonypienable:
@@ -353,7 +352,7 @@ index aeae547..3d85fff 100644
  outkfifoalloc1:
  	vfree(meye.grab_temp);
  outvmalloc:
-@@ -1807,8 +1803,8 @@ static void meye_remove(struct pci_dev *pcidev)
+@@ -1784,8 +1780,8 @@ static void meye_remove(struct pci_dev *pcidev)
  
  	sony_pic_camera_command(SONY_PIC_COMMAND_SETCAMERA, 0);
  
@@ -368,7 +367,7 @@ diff --git a/drivers/media/pci/meye/meye.h b/drivers/media/pci/meye/meye.h
 index 6fed927..77aad1f 100644
 --- a/drivers/media/pci/meye/meye.h
 +++ b/drivers/media/pci/meye/meye.h
-@@ -306,9 +306,9 @@ struct meye {
+@@ -302,9 +302,9 @@ struct meye {
  	struct meye_grab_buffer grab_buffer[MEYE_MAX_BUFNBRS];
  	int vma_use_count[MEYE_MAX_BUFNBRS]; /* mmap count */
  	struct mutex lock;		/* mutex for open/mmap... */
@@ -379,84 +378,84 @@ index 6fed927..77aad1f 100644
 +	struct kfifo *doneq;		/* queue for grabbed buffers */
  	spinlock_t doneq_lock;		/* lock protecting the queue */
  	wait_queue_head_t proc_list;	/* wait queue */
- 	struct video_device *vdev;	/* video device parameters */
+ 	struct video_device vdev;	/* video device parameters */
 diff --git a/drivers/media/rc/rc-core-priv.h b/drivers/media/rc/rc-core-priv.h
 index 84967ca..2aca801 100644
 --- a/drivers/media/rc/rc-core-priv.h
 +++ b/drivers/media/rc/rc-core-priv.h
-@@ -35,7 +35,7 @@ struct ir_raw_event_ctrl {
+@@ -39,7 +39,7 @@ struct ir_raw_event_ctrl {
  	struct list_head		list;		/* to keep track of raw clients */
  	struct task_struct		*thread;
- 	spinlock_t			lock;
--	struct kfifo			kfifo;		/* fifo for the pulse/space durations */
-+	struct kfifo			*kfifo;		/* fifo for the pulse/space durations */
+ 	/* fifo for the pulse/space durations */
+-	struct kfifo			kfifo;
++	struct kfifo			*kfifo;
  	ktime_t				last_event;	/* when last event occurred */
- 	enum raw_event_type		last_type;	/* last event type */
  	struct rc_dev			*dev;		/* pointer to the parent rc_dev */
-diff --git a/drivers/media/rc/rc-ir-raw.c b/drivers/media/rc/rc-ir-raw.c
-index e8fff2a..7709c32 100644
---- a/drivers/media/rc/rc-ir-raw.c
-+++ b/drivers/media/rc/rc-ir-raw.c
-@@ -41,7 +41,7 @@ static int ir_raw_event_thread(void *data)
- 	while (!kthread_should_stop()) {
- 
- 		spin_lock_irq(&raw->lock);
--		retval = kfifo_len(&raw->kfifo);
-+		retval = kfifo_len(raw->kfifo);
- 
- 		if (retval < sizeof(ev)) {
- 			set_current_state(TASK_INTERRUPTIBLE);
-@@ -54,7 +54,7 @@ static int ir_raw_event_thread(void *data)
- 			continue;
- 		}
- 
--		retval = kfifo_out(&raw->kfifo, &ev, sizeof(ev));
-+		retval = __kfifo_get(raw->kfifo, (void *)&ev, sizeof(ev));
- 		spin_unlock_irq(&raw->lock);
- 
- 		mutex_lock(&ir_raw_handler_lock);
-@@ -85,7 +85,7 @@ int ir_raw_event_store(struct rc_dev *dev, struct ir_raw_event *ev)
- 	IR_dprintk(2, "sample: (%05dus %s)\n",
- 		   TO_US(ev->duration), TO_STR(ev->pulse));
- 
--	if (kfifo_in(&dev->raw->kfifo, ev, sizeof(*ev)) != sizeof(*ev))
-+	if (__kfifo_put(dev->raw->kfifo, (void *)ev, sizeof(*ev)) != sizeof(*ev))
- 		return -ENOMEM;
- 
- 	return 0;
-@@ -264,11 +264,11 @@ int ir_raw_event_register(struct rc_dev *dev)
- 	dev->raw->dev = dev;
- 	dev->enabled_protocols = ~0;
- 	dev->change_protocol = change_protocol;
--	rc = kfifo_alloc(&dev->raw->kfifo,
--			 sizeof(struct ir_raw_event) * MAX_IR_EVENT_SIZE,
--			 GFP_KERNEL);
--	if (rc < 0)
-+	dev->raw->kfifo = kfifo_alloc(sizeof(struct ir_raw_event) * MAX_IR_EVENT_SIZE, GFP_KERNEL, NULL);
-+	if (IS_ERR(dev->raw->kfifo)) {
-+		rc = PTR_ERR(dev->raw->kfifo);
- 		goto out;
-+	}
- 
- 	spin_lock_init(&dev->raw->lock);
- 	dev->raw->thread = kthread_run(ir_raw_event_thread, dev->raw,
-@@ -310,7 +310,7 @@ void ir_raw_event_unregister(struct rc_dev *dev)
- 			handler->raw_unregister(dev);
- 	mutex_unlock(&ir_raw_handler_lock);
- 
--	kfifo_free(&dev->raw->kfifo);
-+	kfifo_free(dev->raw->kfifo);
- 	kfree(dev->raw);
- 	dev->raw = NULL;
- }
+ 	/* edge driver */
+### diff --git a/drivers/media/rc/rc-ir-raw.c b/drivers/media/rc/rc-ir-raw.c
+### index e8fff2a..7709c32 100644
+### --- a/drivers/media/rc/rc-ir-raw.c
+### +++ b/drivers/media/rc/rc-ir-raw.c
+### @@ -41,7 +41,7 @@ static int ir_raw_event_thread(void *data)
+###  	while (!kthread_should_stop()) {
+###  
+###  		spin_lock_irq(&raw->lock);
+### -		retval = kfifo_len(&raw->kfifo);
+### +		retval = kfifo_len(raw->kfifo);
+###  
+###  		if (retval < sizeof(ev)) {
+###  			set_current_state(TASK_INTERRUPTIBLE);
+### @@ -54,7 +54,7 @@ static int ir_raw_event_thread(void *data)
+###  			continue;
+###  		}
+###  
+### -		retval = kfifo_out(&raw->kfifo, &ev, sizeof(ev));
+### +		retval = __kfifo_get(raw->kfifo, (void *)&ev, sizeof(ev));
+###  		spin_unlock_irq(&raw->lock);
+###  
+###  		mutex_lock(&ir_raw_handler_lock);
+### @@ -85,7 +85,7 @@ int ir_raw_event_store(struct rc_dev *dev, struct ir_raw_event *ev)
+###  	IR_dprintk(2, "sample: (%05dus %s)\n",
+###  		   TO_US(ev->duration), TO_STR(ev->pulse));
+###  
+### -	if (kfifo_in(&dev->raw->kfifo, ev, sizeof(*ev)) != sizeof(*ev))
+### +	if (__kfifo_put(dev->raw->kfifo, (void *)ev, sizeof(*ev)) != sizeof(*ev))
+###  		return -ENOMEM;
+###  
+###  	return 0;
+### @@ -264,11 +264,11 @@ int ir_raw_event_register(struct rc_dev *dev)
+###  	dev->raw->dev = dev;
+###  	dev->enabled_protocols = ~0;
+###  	dev->change_protocol = change_protocol;
+### -	rc = kfifo_alloc(&dev->raw->kfifo,
+### -			 sizeof(struct ir_raw_event) * MAX_IR_EVENT_SIZE,
+### -			 GFP_KERNEL);
+### -	if (rc < 0)
+### +	dev->raw->kfifo = kfifo_alloc(sizeof(struct ir_raw_event) * MAX_IR_EVENT_SIZE, GFP_KERNEL, NULL);
+### +	if (IS_ERR(dev->raw->kfifo)) {
+### +		rc = PTR_ERR(dev->raw->kfifo);
+###  		goto out;
+### +	}
+###  
+###  	spin_lock_init(&dev->raw->lock);
+###  	dev->raw->thread = kthread_run(ir_raw_event_thread, dev->raw,
+### @@ -310,7 +310,7 @@ void ir_raw_event_unregister(struct rc_dev *dev)
+###  			handler->raw_unregister(dev);
+###  	mutex_unlock(&ir_raw_handler_lock);
+###  
+### -	kfifo_free(&dev->raw->kfifo);
+### +	kfifo_free(dev->raw->kfifo);
+###  	kfree(dev->raw);
+###  	dev->raw = NULL;
+###  }
 diff --git a/drivers/staging/media/lirc/lirc_zilog.c b/drivers/staging/media/lirc/lirc_zilog.c
 index 1ccf626..b0e514b 100644
 --- a/drivers/staging/media/lirc/lirc_zilog.c
 +++ b/drivers/staging/media/lirc/lirc_zilog.c
-@@ -199,7 +199,7 @@ static void release_ir_device(struct kref *ref)
- 		lirc_unregister_driver(ir->l.minor);
- 		ir->l.minor = MAX_IRCTL_DEVICES;
- 	}
+@@ -187,7 +187,7 @@ static void release_ir_device(struct kref *ref)
+ 	if (ir->l)
+ 		lirc_unregister_device(ir->l);
+ 
 -	if (kfifo_initialized(&ir->rbuf.fifo))
 +	if (ir->rbuf.fifo)
  		lirc_buffer_free(&ir->rbuf);
@@ -533,7 +532,7 @@ index 05e7ad5..f40097c 100644
  
  	return len;
  }
-@@ -98,24 +92,19 @@ static inline int lirc_buffer_available(struct lirc_buffer *buf)
+@@ -93,24 +87,19 @@ static inline int lirc_buffer_available(struct lirc_buffer *buf)
  static inline unsigned int lirc_buffer_read(struct lirc_buffer *buf,
  					    unsigned char *dest)
  {
@@ -562,4 +561,4 @@ index 05e7ad5..f40097c 100644
 +	return 0;
  }
  
- struct lirc_driver {
+ /**
-- 
2.7.4
