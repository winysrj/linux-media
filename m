Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from dd15922.kasserver.com ([85.13.137.18])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mldvb@mortal-soul.de>) id 1KWX6x-0002d6-D0
	for linux-dvb@linuxtv.org; Fri, 22 Aug 2008 15:55:32 +0200
From: Matthias Dahl <mldvb@mortal-soul.de>
To: Oliver Endriss <o.endriss@gmx.de>
Date: Fri, 22 Aug 2008 15:55:24 +0200
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_OVsrIkNnZn1oC3B"
Message-Id: <200808221555.26507.mldvb@mortal-soul.de>
Cc: linux-dvb@linuxtv.org
Subject: [linux-dvb] [PATCH] budget_av / dvb_ca_en50221: fixes ci/cam
	handling especially on SMP machines
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

--Boundary-00=_OVsrIkNnZn1oC3B
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi Oliver.

I can happily report that with the following two patches applied, I haven't 
seen a single case where the cam stopped working due to i/o errors or 
anything like it.

The budget_av patch is basically your patch just a bit extended which I 
thought was necessary to cover all relevant cases. Works just fine.

The dvb_ca_en50221 patch introduces the concept of slot lock that means, you 
can either read or write to a slot but concurrent i/o on a slot is no longer 
allowed. This case was already thought of and partly taken care of but 
unfortunately due to the missing locking mechanism, it just made the race 
condition harder to trigger but not impossible... especially on SMP systems 
where this is easier to hit. That's way I introduced a mutex. I left the 
original check in there but it actually never should get triggered anymore. 
Right now actually, if it gets triggered, one could assume the ci/cam is in 
an undefined state and trigger a reinit, like it's done on a few other 
places.

Could you please apply those patches to the dvb tree and maybe get into the 
official 2.6.27? Those bugs haven been around for quite some time now and 
without the patches, they are not so hard to trigger.

Thanks a lot for your help by the way!

So long,
matthias.

--Boundary-00=_OVsrIkNnZn1oC3B
Content-Type: text/x-diff;
  charset="us-ascii";
  name="budget-av_camlock_2.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="budget-av_camlock_2.diff"

--- a/drivers/media/dvb/ttpci/budget-av.c	2008-07-13 23:51:29.000000000 +0200
+++ b/drivers/media/dvb/ttpci/budget-av.c	2008-08-18 21:53:10.000000000 +0200
@@ -65,10 +65,11 @@ struct budget_av {
 	struct tasklet_struct ciintf_irq_tasklet;
 	int slot_status;
 	struct dvb_ca_en50221 ca;
+	struct mutex camlock;
 	u8 reinitialise_demod:1;
 };
 
-static int ciintf_slot_shutdown(struct dvb_ca_en50221 *ca, int slot);
+static int ciintf_unlocked_slot_shutdown(struct dvb_ca_en50221 *ca, int slot);
 
 
 /* GPIO Connections:
@@ -128,7 +129,7 @@ static int i2c_writereg(struct i2c_adapt
 	return i2c_transfer(i2c, &msgs, 1);
 }
 
-static int ciintf_read_attribute_mem(struct dvb_ca_en50221 *ca, int slot, int address)
+static int ciintf_unlocked_read_attribute_mem(struct dvb_ca_en50221 *ca, int slot, int address)
 {
 	struct budget_av *budget_av = (struct budget_av *) ca->data;
 	int result;
@@ -141,9 +142,22 @@ static int ciintf_read_attribute_mem(str
 
 	result = ttpci_budget_debiread(&budget_av->budget, DEBICICAM, address & 0xfff, 1, 0, 1);
 	if (result == -ETIMEDOUT) {
-		ciintf_slot_shutdown(ca, slot);
+		ciintf_unlocked_slot_shutdown(ca, slot);
 		printk(KERN_INFO "budget-av: cam ejected 1\n");
 	}
+
+	return result;
+}
+
+static int ciintf_read_attribute_mem(struct dvb_ca_en50221 *ca, int slot, int address)
+{
+	struct budget_av *budget_av = (struct budget_av *) ca->data;
+	int result;
+
+	mutex_lock(&budget_av->camlock);
+	result = ciintf_unlocked_read_attribute_mem(ca, slot, address);
+	mutex_unlock(&budget_av->camlock);
+
 	return result;
 }
 
@@ -155,14 +169,19 @@ static int ciintf_write_attribute_mem(st
 	if (slot != 0)
 		return -EINVAL;
 
+	mutex_lock(&budget_av->camlock);
+
 	saa7146_setgpio(budget_av->budget.dev, 1, SAA7146_GPIO_OUTHI);
 	udelay(1);
 
 	result = ttpci_budget_debiwrite(&budget_av->budget, DEBICICAM, address & 0xfff, 1, value, 0, 1);
 	if (result == -ETIMEDOUT) {
-		ciintf_slot_shutdown(ca, slot);
+		ciintf_unlocked_slot_shutdown(ca, slot);
 		printk(KERN_INFO "budget-av: cam ejected 2\n");
 	}
+
+	mutex_unlock(&budget_av->camlock);
+
 	return result;
 }
 
@@ -174,15 +193,19 @@ static int ciintf_read_cam_control(struc
 	if (slot != 0)
 		return -EINVAL;
 
+	mutex_lock(&budget_av->camlock);
+
 	saa7146_setgpio(budget_av->budget.dev, 1, SAA7146_GPIO_OUTLO);
 	udelay(1);
 
 	result = ttpci_budget_debiread(&budget_av->budget, DEBICICAM, address & 3, 1, 0, 0);
 	if (result == -ETIMEDOUT) {
-		ciintf_slot_shutdown(ca, slot);
+		ciintf_unlocked_slot_shutdown(ca, slot);
 		printk(KERN_INFO "budget-av: cam ejected 3\n");
-		return -ETIMEDOUT;
 	}
+
+	mutex_unlock(&budget_av->camlock);
+
 	return result;
 }
 
@@ -194,14 +217,19 @@ static int ciintf_write_cam_control(stru
 	if (slot != 0)
 		return -EINVAL;
 
+	mutex_lock(&budget_av->camlock);
+
 	saa7146_setgpio(budget_av->budget.dev, 1, SAA7146_GPIO_OUTLO);
 	udelay(1);
 
 	result = ttpci_budget_debiwrite(&budget_av->budget, DEBICICAM, address & 3, 1, value, 0, 0);
 	if (result == -ETIMEDOUT) {
-		ciintf_slot_shutdown(ca, slot);
+		ciintf_unlocked_slot_shutdown(ca, slot);
 		printk(KERN_INFO "budget-av: cam ejected 5\n");
 	}
+
+	mutex_unlock(&budget_av->camlock);
+
 	return result;
 }
 
@@ -213,6 +241,8 @@ static int ciintf_slot_reset(struct dvb_
 	if (slot != 0)
 		return -EINVAL;
 
+	mutex_lock(&budget_av->camlock);
+
 	dprintk(1, "ciintf_slot_reset\n");
 	budget_av->slot_status = SLOTSTATUS_RESET;
 
@@ -231,10 +261,12 @@ static int ciintf_slot_reset(struct dvb_
 	if (budget_av->reinitialise_demod)
 		dvb_frontend_reinitialise(budget_av->budget.dvb_frontend);
 
+	mutex_unlock(&budget_av->camlock);
+
 	return 0;
 }
 
-static int ciintf_slot_shutdown(struct dvb_ca_en50221 *ca, int slot)
+static int ciintf_unlocked_slot_shutdown(struct dvb_ca_en50221 *ca, int slot)
 {
 	struct budget_av *budget_av = (struct budget_av *) ca->data;
 	struct saa7146_dev *saa = budget_av->budget.dev;
@@ -250,6 +282,18 @@ static int ciintf_slot_shutdown(struct d
 	return 0;
 }
 
+static int ciintf_slot_shutdown(struct dvb_ca_en50221 *ca, int slot)
+{
+	struct budget_av *budget_av = (struct budget_av *) ca->data;
+	int result;
+
+	mutex_lock(&budget_av->camlock);
+	result = ciintf_unlocked_slot_shutdown(ca, slot);
+	mutex_unlock(&budget_av->camlock);
+
+	return result;
+}
+
 static int ciintf_slot_ts_enable(struct dvb_ca_en50221 *ca, int slot)
 {
 	struct budget_av *budget_av = (struct budget_av *) ca->data;
@@ -258,10 +302,13 @@ static int ciintf_slot_ts_enable(struct 
 	if (slot != 0)
 		return -EINVAL;
 
-	dprintk(1, "ciintf_slot_ts_enable: %d\n", budget_av->slot_status);
+	mutex_lock(&budget_av->camlock);
 
+	dprintk(1, "ciintf_slot_ts_enable: %d\n", budget_av->slot_status);
 	ttpci_budget_set_video_port(saa, BUDGET_VIDEO_PORTA);
 
+	mutex_unlock(&budget_av->camlock);
+
 	return 0;
 }
 
@@ -274,6 +321,8 @@ static int ciintf_poll_slot_status(struc
 	if (slot != 0)
 		return -EINVAL;
 
+	mutex_lock(&budget_av->camlock);
+
 	/* test the card detect line - needs to be done carefully
 	 * since it never goes high for some CAMs on this interface (e.g. topuptv) */
 	if (budget_av->slot_status == SLOTSTATUS_NONE) {
@@ -302,8 +351,9 @@ static int ciintf_poll_slot_status(struc
 			printk(KERN_INFO "budget-av: cam inserted B\n");
 		} else if (result < 0) {
 			if (budget_av->slot_status != SLOTSTATUS_NONE) {
-				ciintf_slot_shutdown(ca, slot);
+				ciintf_unlocked_slot_shutdown(ca, slot);
 				printk(KERN_INFO "budget-av: cam ejected 5\n");
+				mutex_unlock(&budget_av->camlock);
 				return 0;
 			}
 		}
@@ -311,20 +361,23 @@ static int ciintf_poll_slot_status(struc
 
 	/* read from attribute memory in reset/ready state to know when the CAM is ready */
 	if (budget_av->slot_status == SLOTSTATUS_RESET) {
-		result = ciintf_read_attribute_mem(ca, slot, 0);
+		result = ciintf_unlocked_read_attribute_mem(ca, slot, 0);
 		if (result == 0x1d) {
 			budget_av->slot_status = SLOTSTATUS_READY;
 		}
 	}
 
 	/* work out correct return code */
+	result = 0;
 	if (budget_av->slot_status != SLOTSTATUS_NONE) {
-		if (budget_av->slot_status & SLOTSTATUS_READY) {
-			return DVB_CA_EN50221_POLL_CAM_PRESENT | DVB_CA_EN50221_POLL_CAM_READY;
-		}
-		return DVB_CA_EN50221_POLL_CAM_PRESENT;
+		result = DVB_CA_EN50221_POLL_CAM_PRESENT;
+		if (budget_av->slot_status & SLOTSTATUS_READY)
+			result |= DVB_CA_EN50221_POLL_CAM_READY;
 	}
-	return 0;
+
+	mutex_unlock(&budget_av->camlock);
+
+	return result;
 }
 
 static int ciintf_init(struct budget_av *budget_av)
@@ -332,6 +385,7 @@ static int ciintf_init(struct budget_av 
 	struct saa7146_dev *saa = budget_av->budget.dev;
 	int result;
 
+	mutex_init(&budget_av->camlock);
 	memset(&budget_av->ca, 0, sizeof(struct dvb_ca_en50221));
 
 	saa7146_setgpio(saa, 0, SAA7146_GPIO_OUTLO);

--Boundary-00=_OVsrIkNnZn1oC3B
Content-Type: text/x-diff;
  charset="us-ascii";
  name="dvb_ca_en50221.c.v1.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="dvb_ca_en50221.c.v1.patch"

--- a/drivers/media/dvb/dvb-core/dvb_ca_en50221.c	2008-07-13 23:51:29.000000000 +0200
+++ b/drivers/media/dvb/dvb-core/dvb_ca_en50221.c	2008-08-22 09:05:31.000000000 +0200
@@ -93,6 +93,9 @@ struct dvb_ca_slot {
 	/* current state of the CAM */
 	int slot_state;
 
+	/* slot mutex for serializing data read/write access */
+	struct mutex slotlock;
+
 	/* Number of CAMCHANGES that have occurred since last processing */
 	atomic_t camchange_count;
 
@@ -589,6 +592,8 @@ static int dvb_ca_en50221_read_data(stru
 
 	dprintk("%s\n", __func__);
 
+	mutex_lock(&ca->slot_info[slot].slotlock);
+
 	/* check if we have space for a link buf in the rx_buffer */
 	if (ebuf == NULL) {
 		int buf_free;
@@ -687,6 +692,7 @@ static int dvb_ca_en50221_read_data(stru
 	status = bytes_read;
 
 exit:
+	mutex_unlock(&ca->slot_info[slot].slotlock);
 	return status;
 }
 
@@ -710,15 +716,22 @@ static int dvb_ca_en50221_write_data(str
 
 	dprintk("%s\n", __func__);
 
+	mutex_lock(&ca->slot_info[slot].slotlock);
 
-	// sanity check
+	/* sanity check */
 	if (bytes_write > ca->slot_info[slot].link_buf_size)
 		return -EINVAL;
 
-	/* check if interface is actually waiting for us to read from it, or if a read is in progress */
+	/* it is possible we are dealing with a single buffer implementation,
+	   thus if there is data available for read or if there is even a read
+	   already in progress, we do nothing but awake the kernel thread to
+	   process the data if necessary. */
 	if ((status = ca->pub->read_cam_control(ca->pub, slot, CTRLIF_STATUS)) < 0)
 		goto exitnowrite;
 	if (status & (STATUSREG_DA | STATUSREG_RE)) {
+		if (status & STATUSREG_DA)
+			dvb_ca_en50221_thread_wakeup(ca);
+
 		status = -EAGAIN;
 		goto exitnowrite;
 	}
@@ -767,6 +780,7 @@ exit:
 	ca->pub->write_cam_control(ca->pub, slot, CTRLIF_COMMAND, IRQEN);
 
 exitnowrite:
+	mutex_unlock(&ca->slot_info[slot].slotlock);
 	return status;
 }
 EXPORT_SYMBOL(dvb_ca_en50221_camchange_irq);
@@ -1662,6 +1676,7 @@ int dvb_ca_en50221_init(struct dvb_adapt
 	for (i = 0; i < slot_count; i++) {
 		memset(&ca->slot_info[i], 0, sizeof(struct dvb_ca_slot));
 		ca->slot_info[i].slot_state = DVB_CA_SLOTSTATE_NONE;
+		mutex_init(&ca->slot_info[i].slotlock);
 		atomic_set(&ca->slot_info[i].camchange_count, 0);
 		ca->slot_info[i].camchange_type = DVB_CA_EN50221_CAMCHANGE_REMOVED;
 	}

--Boundary-00=_OVsrIkNnZn1oC3B
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--Boundary-00=_OVsrIkNnZn1oC3B--
