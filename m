Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from dd15922.kasserver.com ([85.13.137.18])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mldvb@mortal-soul.de>) id 1KVBJ7-0006vR-0x
	for linux-dvb@linuxtv.org; Mon, 18 Aug 2008 22:26:32 +0200
From: Matthias Dahl <mldvb@mortal-soul.de>
To: Oliver Endriss <o.endriss@gmx.de>
Date: Mon, 18 Aug 2008 22:26:19 +0200
References: <200808121443.27020.mldvb@mortal-soul.de>
	<200808160631.23359@orion.escape-edv.de>
In-Reply-To: <200808160631.23359@orion.escape-edv.de>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_trdqI9rWqCBaQwA"
Message-Id: <200808182226.21705.mldvb@mortal-soul.de>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Possible SMP problems with budget_av/saa7134
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

--Boundary-00=_trdqI9rWqCBaQwA
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello Oliver.

On Saturday 16 August 2008 06:31:21 Oliver Endriss wrote:

> Please test the attached patch 

So far everything is looking very good- haven't had a single failure in almost 
2 days now. So all my work on the en50221 implementation was pretty much 
wasted, at least I understand now how things work. :-) Tomorrow I'll start 
testing with vdr no longer bound to one cpu core and see how this goes.

By the way, I hope you don't mind but I've extended your patch a bit to close 
the few remaining locking holes which could cause a race condition. You find 
it attached to this mail. Basically I've expanded the locking for the reset 
function and added locking for the remaining relevant functions. It's still 
untested because my system is currently busy but I'll have it properly tested 
tomorrow. Just wanted to already get some feedback on it.

Thanks for taking the time by the way, it's really appreciated!

So long,
matthias.

--Boundary-00=_trdqI9rWqCBaQwA
Content-Type: text/x-diff;
  charset="iso-8859-15";
  name="budget-av_camlock_2.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="budget-av_camlock_2.diff"

--- budget-av.c.orig	2008-07-13 23:51:29.000000000 +0200
+++ budget-av.c	2008-08-18 21:53:10.000000000 +0200
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

--Boundary-00=_trdqI9rWqCBaQwA
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--Boundary-00=_trdqI9rWqCBaQwA--
