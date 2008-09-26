Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from dd15922.kasserver.com ([85.13.137.18])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mldvb@mortal-soul.de>) id 1Kj9dQ-0002Oy-FK
	for linux-dvb@linuxtv.org; Fri, 26 Sep 2008 11:29:13 +0200
Received: from marvin (88-134-42-89-dynip.superkabel.de [88.134.42.89])
	by dd15922.kasserver.com (Postfix) with ESMTP id B173A2C094785
	for <linux-dvb@linuxtv.org>; Fri, 26 Sep 2008 11:29:10 +0200 (CEST)
To: linux-dvb@linuxtv.org
From: Matthias Dahl <mldvb@mortal-soul.de>
Date: Fri, 26 Sep 2008 11:29:03 +0200
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_jtK3IbCh1OX3Pd3"
Message-Id: <200809261129.07494.mldvb@mortal-soul.de>
Subject: [linux-dvb] [PATCH] implement proper locking in the dvb ca en50221
	driver
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

--Boundary-00=_jtK3IbCh1OX3Pd3
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello.

Since Oliver regrettably resigned from maintaining the dvb-ttpci subtree, I am 
resending this patch which hopefully gets applied to the main tree. It fixes 
a long standing issue with the ci device getting in an semi-undefined state 
where the application needs to be restarted for the ci device to work again. 

Attached you'll find the patch for the dvb ca en50221 driver which fixes all 
reported problems without introducing new ones. The patched driver has been 
working for a few weeks now without any sign of trouble. I also got one user 
reporting that at least nothing broke and that he hopes this fixes his issues 
as well. (so far it looks good for him) 

If you got any more questions, suggestions or anything else, please let me 
know.

So long,
matthias.

--Boundary-00=_jtK3IbCh1OX3Pd3
Content-Type: text/x-diff;
  charset="iso 8859-15";
  name="dvb_ca_en50221-locking_v2.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="dvb_ca_en50221-locking_v2.patch"

Concurrent access to a single DVB CA 50221 interface slot is generally
discouraged. The underlying drivers (budget-av, budget-ci) do not implement
proper locking and thus two transactions could (and do) interfere with on
another.

This fixes the following problems seen by others and myself:

 - sudden i/o errors when writing to the ci device which usually would
   result in an undefined state of the hw and require a software restart

 - errors about the CAM trying to send a buffer larger than the agreed size
   usually also resulting in an undefined state of the hw

Due the to design of the DVB CA 50221 driver, implementing the locks in the
underlying drivers would not be enough and still leave some race conditions,
even though they were harder to trigger.

Signed-off-by: Matthias Dahl <devel@mortal-soul.de>

--- a/linux/drivers/media/dvb/dvb-core/dvb_ca_en50221.c	2008-07-13 23:51:29.000000000 +0200
+++ b/linux/drivers/media/dvb/dvb-core/dvb_ca_en50221.c	2008-09-14 14:44:26.000000000 +0200
@@ -93,6 +93,9 @@ struct dvb_ca_slot {
 	/* current state of the CAM */
 	int slot_state;
 
+	/* mutex used for serializing access to one CI slot */
+	struct mutex slot_lock;
+
 	/* Number of CAMCHANGES that have occurred since last processing */
 	atomic_t camchange_count;
 
@@ -711,14 +714,20 @@ static int dvb_ca_en50221_write_data(str
 	dprintk("%s\n", __func__);
 
 
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
@@ -987,6 +996,8 @@ static int dvb_ca_en50221_thread(void *d
 		/* go through all the slots processing them */
 		for (slot = 0; slot < ca->slot_count; slot++) {
 
+			mutex_lock(&ca->slot_info[slot].slot_lock);
+
 			// check the cam status + deal with CAMCHANGEs
 			while (dvb_ca_en50221_check_camstatus(ca, slot)) {
 				/* clear down an old CI slot if necessary */
@@ -1122,7 +1133,7 @@ static int dvb_ca_en50221_thread(void *d
 
 			case DVB_CA_SLOTSTATE_RUNNING:
 				if (!ca->open)
-					continue;
+					break;
 
 				// poll slots for data
 				pktcount = 0;
@@ -1146,6 +1157,8 @@ static int dvb_ca_en50221_thread(void *d
 				}
 				break;
 			}
+
+			mutex_unlock(&ca->slot_info[slot].slot_lock);
 		}
 	}
 
@@ -1181,6 +1194,7 @@ static int dvb_ca_en50221_io_do_ioctl(st
 	switch (cmd) {
 	case CA_RESET:
 		for (slot = 0; slot < ca->slot_count; slot++) {
+			mutex_lock(&ca->slot_info[slot].slot_lock);
 			if (ca->slot_info[slot].slot_state != DVB_CA_SLOTSTATE_NONE) {
 				dvb_ca_en50221_slot_shutdown(ca, slot);
 				if (ca->flags & DVB_CA_EN50221_FLAG_IRQ_CAMCHANGE)
@@ -1188,6 +1202,7 @@ static int dvb_ca_en50221_io_do_ioctl(st
 								     slot,
 								     DVB_CA_EN50221_CAMCHANGE_INSERTED);
 			}
+			mutex_unlock(&ca->slot_info[slot].slot_lock);
 		}
 		ca->next_read_slot = 0;
 		dvb_ca_en50221_thread_wakeup(ca);
@@ -1308,7 +1323,9 @@ static ssize_t dvb_ca_en50221_io_write(s
 				goto exit;
 			}
 
+			mutex_lock(&ca->slot_info[slot].slot_lock);
 			status = dvb_ca_en50221_write_data(ca, slot, fragbuf, fraglen + 2);
+			mutex_unlock(&ca->slot_info[slot].slot_lock);
 			if (status == (fraglen + 2)) {
 				written = 1;
 				break;
@@ -1664,6 +1681,7 @@ int dvb_ca_en50221_init(struct dvb_adapt
 		ca->slot_info[i].slot_state = DVB_CA_SLOTSTATE_NONE;
 		atomic_set(&ca->slot_info[i].camchange_count, 0);
 		ca->slot_info[i].camchange_type = DVB_CA_EN50221_CAMCHANGE_REMOVED;
+		mutex_init(&ca->slot_info[i].slot_lock);
 	}
 
 	if (signal_pending(current)) {
--- a/linux/drivers/media/dvb/dvb-core/dvb_ca_en50221.h	2008-07-13 23:51:29.000000000 +0200
+++ b/linux/drivers/media/dvb/dvb-core/dvb_ca_en50221.h	2008-09-14 14:19:20.000000000 +0200
@@ -45,8 +45,10 @@ struct dvb_ca_en50221 {
 	/* the module owning this structure */
 	struct module* owner;
 
-	/* NOTE: the read_*, write_* and poll_slot_status functions must use locks as
-	 * they may be called from several threads at once */
+	/* NOTE: the read_*, write_* and poll_slot_status functions will be
+	 * called for different slots concurrently and need to use locks where
+	 * and if appropriate. There will be no concurrent access to one slot.
+	 */
 
 	/* functions for accessing attribute memory on the CAM */
 	int (*read_attribute_mem)(struct dvb_ca_en50221* ca, int slot, int address);

--Boundary-00=_jtK3IbCh1OX3Pd3
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--Boundary-00=_jtK3IbCh1OX3Pd3--
