Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Date: Sun, 14 Sep 2008 12:47:00 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <48CA9628.7030709@linuxtv.org>
To: linux-dvb@linuxtv.org
Message-id: <48CD4004.4040005@linuxtv.org>
MIME-version: 1.0
Content-type: multipart/mixed; boundary="Boundary_(ID_4bQD28KOeTl0nqEI8gbVXQ)"
References: <48CA0355.6080903@linuxtv.org> <200809120826.31108.hftom@free.fr>
	<48CA6C2E.7050908@linuxtv.org> <200809121529.41795.hftom@free.fr>
	<48CA77DE.1020700@linuxtv.org> <20080912152755.GA29142@linuxtv.org>
	<48CA9628.7030709@linuxtv.org>
Cc: Steven Toth <stoth@hauppauge.com>
Subject: Re: [linux-dvb] S2API - Status  - Thu Sep 11th
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.

--Boundary_(ID_4bQD28KOeTl0nqEI8gbVXQ)
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT

Steven Toth wrote:
> Johannes Stezenbach wrote:
>> On Fri, Sep 12, 2008, Steven Toth wrote:
>>> Christophe Thommeret wrote:
>>>> As far  as i understand, the cinergyT2 driver is a bit unusual, e.g. 
>>>> dvb_register_frontend is never called (hence no dtv_* log messages). 
>>>> I don't know if there is others drivers like this, but this has to 
>>>> be investigated cause rewritting all drivers for S2API could be a 
>>>> bit of work :)
>>>>
>>>> P.S.
>>>> I think there is an alternate driver for cinergyT2 actually in 
>>>> developement but idon't remember where it's located neither its state.
>>> Good to know. (I also saw your followup email). I have zero 
>>> experience with the cinergyT2 but the old api should still be working 
>>> reliably. I plan to investigate this, sounds like a bug! :)
>>
>> Holger was of the opinion that having the demux in dvb-core
>> was stupid for devices which have no hw demux, so he
>> programmed around dvb-core. His plan was to add a
>> mmap-dma-buffers kind of API to the frontend device,
>> but it never got implemented.
>>
>> Anyway, it's bad if one driver is different than all the others.
> 
> Hmm, I didn't realize this, good to know.
> 
> Now it's peaked my interest, I'll have to look at the code.
> 
> The existing API should still work at a bare minimum, if it's not - it 
> needs to.

So I looked the the cinergyT2 code, that's a complete eye-opener. It has 
it's own ioctl handler, outside of dvb-core.

It's a good news / bad news thing.

The good news is that this driver will not be effected by the S2API 
changes, so nothing can break.

The bad news is that this driver will not be effected by the S2API 
changes, so it doesn't get the benefit.

Regardless of S2API or multiproto, I see no reason why we shouldn't 
bring this driver back into dvb-core.

I don't have a device to test, but here's a patch (0% tested, with bugs 
probably) that converts the module back to a regular dvb-core compatible 
device, so the S2API would work with this. If anyone wants to test this, 
and finds bugs - I won't get back to this driver for a couple of weeks - 
so your patches would be welcome. :)

Frankly, is S2API is selected for merge and we have enough users of the 
current non-dvb-core driver, I'll probably re-write it from the spec.

So much to do, so little time.

- Steve

--Boundary_(ID_4bQD28KOeTl0nqEI8gbVXQ)
Content-type: text/plain; x-mac-type=0; x-mac-creator=0; name=cinergyt2.patch
Content-transfer-encoding: 7BIT
Content-disposition: inline; filename=cinergyt2.patch

Index: s2/linux/drivers/media/dvb/cinergyT2/cinergyT2.c
===================================================================
--- s2.orig/linux/drivers/media/dvb/cinergyT2/cinergyT2.c	2008-09-14 12:31:34.000000000 -0400
+++ s2/linux/drivers/media/dvb/cinergyT2/cinergyT2.c	2008-09-14 12:40:47.000000000 -0400
@@ -36,6 +36,7 @@
 #include "dmxdev.h"
 #include "dvb_demux.h"
 #include "dvb_net.h"
+#include "dvb_frontend.h"
 
 #ifdef CONFIG_DVB_CINERGYT2_TUNING
 	#define STREAM_URB_COUNT (CONFIG_DVB_CINERGYT2_STREAM_URB_COUNT)
@@ -103,29 +104,17 @@
 	uint8_t prev_lock_bits;
 } __attribute__((packed));
 
-static struct dvb_frontend_info cinergyt2_fe_info = {
-	.name = DRIVER_NAME,
-	.type = FE_OFDM,
-	.frequency_min = 174000000,
-	.frequency_max = 862000000,
-	.frequency_stepsize = 166667,
-	.caps = FE_CAN_INVERSION_AUTO | FE_CAN_FEC_1_2 | FE_CAN_FEC_2_3 |
-		FE_CAN_FEC_3_4 | FE_CAN_FEC_5_6 | FE_CAN_FEC_7_8 |
-		FE_CAN_FEC_AUTO |
-		FE_CAN_QPSK | FE_CAN_QAM_16 | FE_CAN_QAM_64 | FE_CAN_QAM_AUTO |
-		FE_CAN_TRANSMISSION_MODE_AUTO | FE_CAN_GUARD_INTERVAL_AUTO |
-		FE_CAN_HIERARCHY_AUTO | FE_CAN_RECOVER | FE_CAN_MUTE_TS
-};
-
 struct cinergyt2 {
 	struct dvb_demux demux;
 	struct usb_device *udev;
 	struct mutex sem;
 	struct mutex wq_sem;
 	struct dvb_adapter adapter;
-	struct dvb_device *fedev;
 	struct dmxdev dmxdev;
 	struct dvb_net dvbnet;
+	struct dvb_frontend *frontend;
+	struct dmx_frontend fe_hw;
+	struct dmx_frontend fe_mem;
 
 	int streaming;
 	int sleeping;
@@ -501,266 +490,208 @@
 	return tps;
 }
 
-static int cinergyt2_open (struct inode *inode, struct file *file)
+static void cinergyt2_unregister(struct cinergyt2 *cinergyt2)
+{
+	if (cinergyt2->frontend != NULL) {
+		dvb_net_release(&cinergyt2->dvbnet);
+		cinergyt2->demux.dmx.remove_frontend(&cinergyt2->demux.dmx, &cinergyt2->fe_mem);
+		cinergyt2->demux.dmx.remove_frontend(&cinergyt2->demux.dmx, &cinergyt2->fe_hw);
+		dvb_dmxdev_release(&cinergyt2->dmxdev);
+		dvb_dmx_release(&cinergyt2->demux);
+		dvb_unregister_frontend(cinergyt2->frontend);
+		dvb_frontend_detach(cinergyt2->frontend);
+		dvb_unregister_adapter(&cinergyt2->adapter);
+	}
+
+	cinergyt2_free_stream_urbs(cinergyt2);
+	kfree(cinergyt2);
+}
+
+static unsigned int cinergyt2_poll (struct file *file, struct poll_table_struct *wait)
 {
 	struct dvb_device *dvbdev = file->private_data;
 	struct cinergyt2 *cinergyt2 = dvbdev->priv;
-	int err = -EAGAIN;
+	unsigned int mask = 0;
 
 	if (cinergyt2->disconnect_pending)
-		goto out;
-	err = mutex_lock_interruptible(&cinergyt2->wq_sem);
-	if (err)
-		goto out;
-
-	err = mutex_lock_interruptible(&cinergyt2->sem);
-	if (err)
-		goto out_unlock1;
-
-	if ((err = dvb_generic_open(inode, file)))
-		goto out_unlock2;
+		return -EAGAIN;
+	if (mutex_lock_interruptible(&cinergyt2->sem))
+		return -ERESTARTSYS;
 
-	if ((file->f_flags & O_ACCMODE) != O_RDONLY) {
-		cinergyt2_sleep(cinergyt2, 0);
-		schedule_delayed_work(&cinergyt2->query_work, HZ/2);
-	}
+	poll_wait(file, &cinergyt2->poll_wq, wait);
 
-	atomic_inc(&cinergyt2->inuse);
+	if (cinergyt2->pending_fe_events != 0)
+		mask |= (POLLIN | POLLRDNORM | POLLPRI);
 
-out_unlock2:
 	mutex_unlock(&cinergyt2->sem);
-out_unlock1:
-	mutex_unlock(&cinergyt2->wq_sem);
-out:
-	return err;
+
+	return mask;
 }
 
-static void cinergyt2_unregister(struct cinergyt2 *cinergyt2)
+static int cinergyt2_read_status(struct dvb_frontend* fe, fe_status_t* status)
 {
-	dvb_net_release(&cinergyt2->dvbnet);
-	dvb_dmxdev_release(&cinergyt2->dmxdev);
-	dvb_dmx_release(&cinergyt2->demux);
-	dvb_unregister_device(cinergyt2->fedev);
-	dvb_unregister_adapter(&cinergyt2->adapter);
+	struct cinergyt2 *cinergyt2 = fe->demodulator_priv;
+	struct dvbt_get_status_msg *s = &cinergyt2->status;
 
-	cinergyt2_free_stream_urbs(cinergyt2);
-	kfree(cinergyt2);
+	if (0xffff - le16_to_cpu(s->gain) > 30)
+		*status |= FE_HAS_SIGNAL;
+	if (s->lock_bits & (1 << 6))
+		*status |= FE_HAS_LOCK;
+	if (s->lock_bits & (1 << 5))
+		*status |= FE_HAS_SYNC;
+	if (s->lock_bits & (1 << 4))
+		*status |= FE_HAS_CARRIER;
+	if (s->lock_bits & (1 << 1))
+		*status |= FE_HAS_VITERBI;
+
+	return 0;
 }
 
-static int cinergyt2_release (struct inode *inode, struct file *file)
+static int cinergyt2_read_ber(struct dvb_frontend* fe, u32* ber)
 {
-	struct dvb_device *dvbdev = file->private_data;
-	struct cinergyt2 *cinergyt2 = dvbdev->priv;
+	struct cinergyt2 *cinergyt2 = fe->demodulator_priv;
+	struct dvbt_get_status_msg *s = &cinergyt2->status;
 
-	mutex_lock(&cinergyt2->wq_sem);
+	*ber = s->viterbi_error_rate;
 
-	if (!cinergyt2->disconnect_pending && (file->f_flags & O_ACCMODE) != O_RDONLY) {
-		cancel_rearming_delayed_work(&cinergyt2->query_work);
+	return 0;
+}
 
-		mutex_lock(&cinergyt2->sem);
-		cinergyt2_sleep(cinergyt2, 1);
-		mutex_unlock(&cinergyt2->sem);
-	}
+static int cinergyt2_read_signal_strength(struct dvb_frontend* fe, u16* signal_strength)
+{
+	struct cinergyt2 *cinergyt2 = fe->demodulator_priv;
+	struct dvbt_get_status_msg *s = &cinergyt2->status;
 
-	mutex_unlock(&cinergyt2->wq_sem);
+	*signal_strength = 0xffff - le16_to_cpu(s->gain);
 
-	if (atomic_dec_and_test(&cinergyt2->inuse) && cinergyt2->disconnect_pending) {
-		warn("delayed unregister in release");
-		cinergyt2_unregister(cinergyt2);
-	}
+	return 0;
+}
+
+static int cinergyt2_read_snr(struct dvb_frontend* fe, u16* snr)
+{
+	struct cinergyt2 *cinergyt2 = fe->demodulator_priv;
+	struct dvbt_get_status_msg *s = &cinergyt2->status;
 
-	return dvb_generic_release(inode, file);
+	*snr = (s->snr << 8) | s->snr;
+
+	return 0;
 }
 
-static unsigned int cinergyt2_poll (struct file *file, struct poll_table_struct *wait)
+static int cinergyt2_read_ucblocks(struct dvb_frontend* fe, u32* ucblocks)
 {
-	struct dvb_device *dvbdev = file->private_data;
-	struct cinergyt2 *cinergyt2 = dvbdev->priv;
-	unsigned int mask = 0;
+	struct cinergyt2 *cinergyt2 = fe->demodulator_priv;
 
-	if (cinergyt2->disconnect_pending)
-		return -EAGAIN;
 	if (mutex_lock_interruptible(&cinergyt2->sem))
 		return -ERESTARTSYS;
 
-	poll_wait(file, &cinergyt2->poll_wq, wait);
+	*ucblocks = cinergyt2->uncorrected_block_count;
 
-	if (cinergyt2->pending_fe_events != 0)
-		mask |= (POLLIN | POLLRDNORM | POLLPRI);
+	cinergyt2->uncorrected_block_count = 0;
 
 	mutex_unlock(&cinergyt2->sem);
 
-	return mask;
+	/* UNC are already converted to host byte order... */
+
+	return 0;
 }
 
+static int cinergyt2_get_tune_settings(struct dvb_frontend* fe, struct dvb_frontend_tune_settings *tune)
+{
+	tune->min_delay_ms = 1000;
+	return 0;
+}
 
-static int cinergyt2_ioctl (struct inode *inode, struct file *file,
-		     unsigned cmd, unsigned long arg)
+static int cinergyt2_get_frontend(struct dvb_frontend* fe, struct dvb_frontend_parameters *p)
 {
-	struct dvb_device *dvbdev = file->private_data;
-	struct cinergyt2 *cinergyt2 = dvbdev->priv;
-	struct dvbt_get_status_msg *stat = &cinergyt2->status;
-	fe_status_t status = 0;
+	/* Taken from the previous IOCTL handler */
 
-	switch (cmd) {
-	case FE_GET_INFO:
-		return copy_to_user((void __user*) arg, &cinergyt2_fe_info,
-				    sizeof(struct dvb_frontend_info));
-
-	case FE_READ_STATUS:
-		if (0xffff - le16_to_cpu(stat->gain) > 30)
-			status |= FE_HAS_SIGNAL;
-		if (stat->lock_bits & (1 << 6))
-			status |= FE_HAS_LOCK;
-		if (stat->lock_bits & (1 << 5))
-			status |= FE_HAS_SYNC;
-		if (stat->lock_bits & (1 << 4))
-			status |= FE_HAS_CARRIER;
-		if (stat->lock_bits & (1 << 1))
-			status |= FE_HAS_VITERBI;
-
-		return copy_to_user((void  __user*) arg, &status, sizeof(status));
-
-	case FE_READ_BER:
-		return put_user(le32_to_cpu(stat->viterbi_error_rate),
-				(__u32 __user *) arg);
-
-	case FE_READ_SIGNAL_STRENGTH:
-		return put_user(0xffff - le16_to_cpu(stat->gain),
-				(__u16 __user *) arg);
-
-	case FE_READ_SNR:
-		return put_user((stat->snr << 8) | stat->snr,
-				(__u16 __user *) arg);
-
-	case FE_READ_UNCORRECTED_BLOCKS:
-	{
-		uint32_t unc_count;
-
-		if (mutex_lock_interruptible(&cinergyt2->sem))
-			return -ERESTARTSYS;
-		unc_count = cinergyt2->uncorrected_block_count;
-		cinergyt2->uncorrected_block_count = 0;
-		mutex_unlock(&cinergyt2->sem);
-
-		/* UNC are already converted to host byte order... */
-		return put_user(unc_count,(__u32 __user *) arg);
-	}
-	case FE_SET_FRONTEND:
-	{
-		struct dvbt_set_parameters_msg *param = &cinergyt2->param;
-		struct dvb_frontend_parameters p;
-		int err;
-
-		if ((file->f_flags & O_ACCMODE) == O_RDONLY)
-			return -EPERM;
-
-		if (copy_from_user(&p, (void  __user*) arg, sizeof(p)))
-			return -EFAULT;
-
-		if (cinergyt2->disconnect_pending)
-			return -EAGAIN;
-		if (mutex_lock_interruptible(&cinergyt2->sem))
-			return -ERESTARTSYS;
-
-		param->cmd = CINERGYT2_EP1_SET_TUNER_PARAMETERS;
-		param->tps = cpu_to_le16(compute_tps(&p));
-		param->freq = cpu_to_le32(p.frequency / 1000);
-		param->bandwidth = 8 - p.u.ofdm.bandwidth - BANDWIDTH_8_MHZ;
+	/**
+	 *  trivial to implement (see struct dvbt_get_status_msg).
+	 *  equivalent to FE_READ ioctls, but needs
+	 *  TPS -> linux-dvb parameter set conversion. Feel free
+	 *  to implement this and send us a patch if you need this
+	 *  functionality.
+	 */
 
-		stat->lock_bits = 0;
-		cinergyt2->pending_fe_events++;
-		wake_up_interruptible(&cinergyt2->poll_wq);
+	return 0;
+}
 
-		err = cinergyt2_command(cinergyt2,
-					(char *) param, sizeof(*param),
-					NULL, 0);
-
-		mutex_unlock(&cinergyt2->sem);
-
-		return (err < 0) ? err : 0;
-	}
-
-	case FE_GET_FRONTEND:
-		/**
-		 *  trivial to implement (see struct dvbt_get_status_msg).
-		 *  equivalent to FE_READ ioctls, but needs
-		 *  TPS -> linux-dvb parameter set conversion. Feel free
-		 *  to implement this and send us a patch if you need this
-		 *  functionality.
-		 */
-		break;
-
-	case FE_GET_EVENT:
-	{
-		/**
-		 *  for now we only fill the status field. the parameters
-		 *  are trivial to fill as soon FE_GET_FRONTEND is done.
-		 */
-		struct dvb_frontend_event __user *e = (void __user *) arg;
-		if (cinergyt2->pending_fe_events == 0) {
-			if (file->f_flags & O_NONBLOCK)
-				return -EWOULDBLOCK;
-			wait_event_interruptible(cinergyt2->poll_wq,
-						 cinergyt2->pending_fe_events > 0);
-		}
-		cinergyt2->pending_fe_events = 0;
-		return cinergyt2_ioctl(inode, file, FE_READ_STATUS,
-					(unsigned long) &e->status);
-	}
+static int cinergyt2_set_frontend(struct dvb_frontend* fe, struct dvb_frontend_parameters *p)
+{
+	struct cinergyt2 *cinergyt2 = fe->demodulator_priv;
+	struct dvbt_get_status_msg *s = &cinergyt2->status;
+	struct dvbt_set_parameters_msg *param = &cinergyt2->param;
+	int err;
 
-	default:
-		;
-	}
+	if (cinergyt2->disconnect_pending)
+		return -EAGAIN;
+	if (mutex_lock_interruptible(&cinergyt2->sem))
+		return -ERESTARTSYS;
+
+	param->cmd = CINERGYT2_EP1_SET_TUNER_PARAMETERS;
+	param->tps = cpu_to_le16(compute_tps(p));
+	param->freq = cpu_to_le32(p->frequency / 1000);
+	param->bandwidth = 8 - p->u.ofdm.bandwidth - BANDWIDTH_8_MHZ;
 
-	return -EINVAL;
+	s->lock_bits = 0;
+	cinergyt2->pending_fe_events++;
+	wake_up_interruptible(&cinergyt2->poll_wq);
+
+	err = cinergyt2_command(cinergyt2,
+		(char *) param, sizeof(*param),
+		NULL, 0);
+
+	mutex_unlock(&cinergyt2->sem);
+
+	return (err < 0) ? err : 0;
 }
 
-static int cinergyt2_mmap(struct file *file, struct vm_area_struct *vma)
+static int cinergyt2_fe_init(struct dvb_frontend* fe)
 {
-	struct dvb_device *dvbdev = file->private_data;
-	struct cinergyt2 *cinergyt2 = dvbdev->priv;
-	int ret = 0;
+	struct cinergyt2 *cinergyt2 = fe->demodulator_priv;
+        int err = -EAGAIN;
 
-	lock_kernel();
+        if (cinergyt2->disconnect_pending)
+                goto out;
+        err = mutex_lock_interruptible(&cinergyt2->wq_sem);
+        if (err)
+                goto out;
 
-	if (vma->vm_flags & (VM_WRITE | VM_EXEC)) {
-		ret = -EPERM;
-		goto bailout;
-	}
+        err = mutex_lock_interruptible(&cinergyt2->sem);
+        if (err)
+                goto out_unlock1;
 
-	if (vma->vm_end > vma->vm_start + STREAM_URB_COUNT * STREAM_BUF_SIZE) {
-		ret = -EINVAL;
-		goto bailout;
-	}
+	cinergyt2_sleep(cinergyt2, 0);
+	schedule_delayed_work(&cinergyt2->query_work, HZ/2);
 
-	vma->vm_flags |= (VM_IO | VM_DONTCOPY);
-	vma->vm_file = file;
+        atomic_inc(&cinergyt2->inuse);
 
-	ret = remap_pfn_range(vma, vma->vm_start,
-			      virt_to_phys(cinergyt2->streambuf) >> PAGE_SHIFT,
-			      vma->vm_end - vma->vm_start,
-			      vma->vm_page_prot) ? -EAGAIN : 0;
-bailout:
-	unlock_kernel();
-	return ret;
+        mutex_unlock(&cinergyt2->sem);
+out_unlock1:
+        mutex_unlock(&cinergyt2->wq_sem);
+out:
+        return err;
 }
 
-static struct file_operations cinergyt2_fops = {
-	.owner          = THIS_MODULE,
-	.ioctl		= cinergyt2_ioctl,
-	.poll           = cinergyt2_poll,
-	.open           = cinergyt2_open,
-	.release        = cinergyt2_release,
-	.mmap		= cinergyt2_mmap
-};
+static void cinergyt2_release(struct dvb_frontend* fe)
+{
+	struct cinergyt2 *cinergyt2 = fe->demodulator_priv;
 
-static struct dvb_device cinergyt2_fe_template = {
-	.users = ~0,
-	.writers = 1,
-	.readers = (~0)-1,
-	.fops = &cinergyt2_fops
-};
+	mutex_lock(&cinergyt2->wq_sem);
+
+	cancel_rearming_delayed_work(&cinergyt2->query_work);
+
+	mutex_lock(&cinergyt2->sem);
+	cinergyt2_sleep(cinergyt2, 1);
+	mutex_unlock(&cinergyt2->sem);
+
+	mutex_unlock(&cinergyt2->wq_sem);
+
+	if (atomic_dec_and_test(&cinergyt2->inuse) && cinergyt2->disconnect_pending) {
+		warn("delayed unregister in release");
+		cinergyt2_unregister(cinergyt2);
+	}
+}
 
 #ifdef ENABLE_RC
 
@@ -956,6 +887,8 @@
 	mutex_unlock(&cinergyt2->sem);
 }
 
+static struct dvb_frontend_ops cinergyt2_fe_ops;
+
 static int cinergyt2_probe (struct usb_interface *intf,
 		  const struct usb_device_id *id)
 {
@@ -995,6 +928,15 @@
 		return err;
 	}
 
+	/* register frontend */
+        cinergyt2->adapter.priv = cinergyt2;
+	err = dvb_register_frontend(&cinergyt2->adapter, cinergyt2->frontend);
+	if (err < 0) {
+		printk(KERN_ERR "%s: dvb_register_frontend failed "
+			"(errno = %d)\n", DRIVER_NAME, err);
+		goto fail_frontend;
+	}
+
 	cinergyt2->demux.priv = cinergyt2;
 	cinergyt2->demux.filternum = 256;
 	cinergyt2->demux.feednum = 256;
@@ -1006,7 +948,7 @@
 
 	if ((err = dvb_dmx_init(&cinergyt2->demux)) < 0) {
 		dprintk(1, "dvb_dmx_init() failed (err = %d)\n", err);
-		goto bailout;
+		goto fail_dmx;
 	}
 
 	cinergyt2->dmxdev.filternum = cinergyt2->demux.filternum;
@@ -1015,26 +957,60 @@
 
 	if ((err = dvb_dmxdev_init(&cinergyt2->dmxdev, &cinergyt2->adapter)) < 0) {
 		dprintk(1, "dvb_dmxdev_init() failed (err = %d)\n", err);
-		goto bailout;
+		goto fail_dmxdev;
 	}
 
+        cinergyt2->fe_hw.source = DMX_FRONTEND_0;
+        err = cinergyt2->demux.dmx.add_frontend(&cinergyt2->demux.dmx, &cinergyt2->fe_hw);
+        if (err < 0) {
+                printk(KERN_ERR "%s: add_frontend failed "
+                       "(DMX_FRONTEND_0, errno = %d)\n", DRIVER_NAME, err);
+                goto fail_fe_hw;
+        }
+
+        cinergyt2->fe_mem.source = DMX_MEMORY_FE;
+        err = cinergyt2->demux.dmx.add_frontend(&cinergyt2->demux.dmx, &cinergyt2->fe_mem);
+        if (err < 0) {
+                printk(KERN_ERR "%s: add_frontend failed "
+                       "(DMX_MEMORY_FE, errno = %d)\n", DRIVER_NAME, err);
+                goto fail_fe_mem;
+        }
+
+        err = cinergyt2->demux.dmx.connect_frontend(&cinergyt2->demux.dmx, &cinergyt2->fe_hw);
+        if (err < 0) {
+                printk(KERN_ERR "%s: connect_frontend failed (errno = %d)\n",
+                       DRIVER_NAME, err);
+                goto fail_fe_conn;
+        }
+
+	/* Attach the DVB frontend */
+	memcpy(&cinergyt2->frontend->ops, &cinergyt2_fe_ops, sizeof(struct dvb_frontend_ops));
+	cinergyt2->frontend->demodulator_priv = cinergyt2;
+
 	if (dvb_net_init(&cinergyt2->adapter, &cinergyt2->dvbnet, &cinergyt2->demux.dmx))
+		/* ST- Why wouldn't this be mandatory failure? */
 		dprintk(1, "dvb_net_init() failed!\n");
 
-	dvb_register_device(&cinergyt2->adapter, &cinergyt2->fedev,
-			    &cinergyt2_fe_template, cinergyt2,
-			    DVB_DEVICE_FRONTEND);
-
 	err = cinergyt2_register_rc(cinergyt2);
 	if (err)
-		goto bailout;
+		goto fail_net;
 
 	return 0;
 
-bailout:
+fail_net:
 	dvb_net_release(&cinergyt2->dvbnet);
+fail_fe_conn:
+	cinergyt2->demux.dmx.remove_frontend(&cinergyt2->demux.dmx, &cinergyt2->fe_mem);
+fail_fe_mem:
+	cinergyt2->demux.dmx.remove_frontend(&cinergyt2->demux.dmx, &cinergyt2->fe_hw);
+fail_fe_hw:
 	dvb_dmxdev_release(&cinergyt2->dmxdev);
+fail_dmxdev:
 	dvb_dmx_release(&cinergyt2->demux);
+fail_dmx:
+	dvb_unregister_frontend(cinergyt2->frontend);
+fail_frontend:
+	dvb_frontend_detach(cinergyt2->frontend);
 	dvb_unregister_adapter(&cinergyt2->adapter);
 	cinergyt2_free_stream_urbs(cinergyt2);
 	kfree(cinergyt2);
@@ -1119,6 +1095,37 @@
 
 MODULE_DEVICE_TABLE(usb, cinergyt2_table);
 
+static struct dvb_frontend_ops cinergyt2_fe_ops = {
+
+	.info = {
+		.name = DRIVER_NAME,
+		.type = FE_OFDM,
+		.frequency_min = 174000000,
+		.frequency_max = 862000000,
+		.frequency_stepsize = 166667,
+		.caps = FE_CAN_INVERSION_AUTO | FE_CAN_FEC_1_2 | FE_CAN_FEC_2_3 |
+			FE_CAN_FEC_3_4 | FE_CAN_FEC_5_6 | FE_CAN_FEC_7_8 |
+			FE_CAN_FEC_AUTO |
+			FE_CAN_QPSK | FE_CAN_QAM_16 | FE_CAN_QAM_64 | FE_CAN_QAM_AUTO |
+			FE_CAN_TRANSMISSION_MODE_AUTO | FE_CAN_GUARD_INTERVAL_AUTO |
+			FE_CAN_HIERARCHY_AUTO | FE_CAN_RECOVER | FE_CAN_MUTE_TS
+	},
+
+	.release = cinergyt2_release,
+
+	.init = cinergyt2_fe_init,
+
+	.set_frontend = cinergyt2_set_frontend,
+	.get_frontend = cinergyt2_get_frontend,
+	.get_tune_settings = cinergyt2_get_tune_settings,
+
+	.read_status = cinergyt2_read_status,
+	.read_ber = cinergyt2_read_ber,
+	.read_signal_strength = cinergyt2_read_signal_strength,
+	.read_snr = cinergyt2_read_snr,
+	.read_ucblocks = cinergyt2_read_ucblocks,
+};
+
 static struct usb_driver cinergyt2_driver = {
 	.name	= "cinergyT2",
 	.probe	= cinergyt2_probe,

--Boundary_(ID_4bQD28KOeTl0nqEI8gbVXQ)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--Boundary_(ID_4bQD28KOeTl0nqEI8gbVXQ)--
