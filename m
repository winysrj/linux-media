Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.anw.at ([195.234.101.228]:46238 "EHLO mail.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751258AbdGPAnj (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 15 Jul 2017 20:43:39 -0400
From: "Jasmin J." <jasmin@anw.at>
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, max.kellermann@gmail.com,
        rjkm@metzlerbros.de, d.scheller@gmx.net, crope@iki.fi,
        jasmin@anw.at
Subject: [PATCH V3 01/16] [media] dvb-core/dvb_ca_en50221.c: Refactored dvb_ca_en50221_thread
Date: Sun, 16 Jul 2017 02:43:02 +0200
Message-Id: <1500165797-16987-2-git-send-email-jasmin@anw.at>
In-Reply-To: <1500165797-16987-1-git-send-email-jasmin@anw.at>
References: <1500165797-16987-1-git-send-email-jasmin@anw.at>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jasmin Jessich <jasmin@anw.at>

Refactored "dvb_ca_en50221_thread" by moving the state machine into the
new function "dvb_ca_en50221_thread_state_machine". This reduces the
thread function size and reduces the structural complexity and of course
gives us more space to meet the line length goal in the new function.

Signed-off-by: Jasmin Jessich <jasmin@anw.at>
---
 drivers/media/dvb-core/dvb_ca_en50221.c | 363 +++++++++++++++++---------------
 1 file changed, 198 insertions(+), 165 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_ca_en50221.c b/drivers/media/dvb-core/dvb_ca_en50221.c
index 17970cd..e2f35b7 100644
--- a/drivers/media/dvb-core/dvb_ca_en50221.c
+++ b/drivers/media/dvb-core/dvb_ca_en50221.c
@@ -1063,207 +1063,240 @@ static void dvb_ca_en50221_thread_update_delay(struct dvb_ca_private *ca)
 	ca->delay = curdelay;
 }
 
-
-
 /**
- * Kernel thread which monitors CA slots for CAM changes, and performs data transfers.
+ * Thread state machine for one CA slot to perform the data transfer.
+ *
+ * @ca: CA instance.
+ * @slot: Slot to process.
  */
-static int dvb_ca_en50221_thread(void *data)
+static void dvb_ca_en50221_thread_state_machine(struct dvb_ca_private *ca,
+						int slot)
 {
-	struct dvb_ca_private *ca = data;
-	int slot;
+	struct dvb_ca_slot *sl = &ca->slot_info[slot];
 	int flags;
 	int status;
 	int pktcount;
 	void *rxbuf;
 
-	dprintk("%s\n", __func__);
+	mutex_lock(&sl->slot_lock);
 
-	/* choose the correct initial delay */
-	dvb_ca_en50221_thread_update_delay(ca);
+	/* check the cam status + deal with CAMCHANGEs */
+	while (dvb_ca_en50221_check_camstatus(ca, slot)) {
+		/* clear down an old CI slot if necessary */
+		if (sl->slot_state != DVB_CA_SLOTSTATE_NONE)
+			dvb_ca_en50221_slot_shutdown(ca, slot);
 
-	/* main loop */
-	while (!kthread_should_stop()) {
-		/* sleep for a bit */
-		if (!ca->wakeup) {
-			set_current_state(TASK_INTERRUPTIBLE);
-			schedule_timeout(ca->delay);
-			if (kthread_should_stop())
-				return 0;
-		}
-		ca->wakeup = 0;
+		/* if a CAM is NOW present, initialise it */
+		if (sl->camchange_type == DVB_CA_EN50221_CAMCHANGE_INSERTED)
+			sl->slot_state = DVB_CA_SLOTSTATE_UNINITIALISED;
 
-		/* go through all the slots processing them */
-		for (slot = 0; slot < ca->slot_count; slot++) {
-
-			mutex_lock(&ca->slot_info[slot].slot_lock);
-
-			// check the cam status + deal with CAMCHANGEs
-			while (dvb_ca_en50221_check_camstatus(ca, slot)) {
-				/* clear down an old CI slot if necessary */
-				if (ca->slot_info[slot].slot_state != DVB_CA_SLOTSTATE_NONE)
-					dvb_ca_en50221_slot_shutdown(ca, slot);
-
-				/* if a CAM is NOW present, initialise it */
-				if (ca->slot_info[slot].camchange_type == DVB_CA_EN50221_CAMCHANGE_INSERTED) {
-					ca->slot_info[slot].slot_state = DVB_CA_SLOTSTATE_UNINITIALISED;
-				}
+		/* we've handled one CAMCHANGE */
+		dvb_ca_en50221_thread_update_delay(ca);
+		atomic_dec(&sl->camchange_count);
+	}
 
-				/* we've handled one CAMCHANGE */
-				dvb_ca_en50221_thread_update_delay(ca);
-				atomic_dec(&ca->slot_info[slot].camchange_count);
-			}
+	/* CAM state machine */
+	switch (sl->slot_state) {
+	case DVB_CA_SLOTSTATE_NONE:
+	case DVB_CA_SLOTSTATE_INVALID:
+		/* no action needed */
+		break;
 
-			// CAM state machine
-			switch (ca->slot_info[slot].slot_state) {
-			case DVB_CA_SLOTSTATE_NONE:
-			case DVB_CA_SLOTSTATE_INVALID:
-				// no action needed
-				break;
+	case DVB_CA_SLOTSTATE_UNINITIALISED:
+		sl->slot_state = DVB_CA_SLOTSTATE_WAITREADY;
+		ca->pub->slot_reset(ca->pub, slot);
+		sl->timeout = jiffies + (INIT_TIMEOUT_SECS * HZ);
+		break;
 
-			case DVB_CA_SLOTSTATE_UNINITIALISED:
-				ca->slot_info[slot].slot_state = DVB_CA_SLOTSTATE_WAITREADY;
-				ca->pub->slot_reset(ca->pub, slot);
-				ca->slot_info[slot].timeout = jiffies + (INIT_TIMEOUT_SECS * HZ);
-				break;
+	case DVB_CA_SLOTSTATE_WAITREADY:
+		if (time_after(jiffies, sl->timeout)) {
+			pr_err("dvb_ca adaptor %d: PC card did not respond :(\n",
+			       ca->dvbdev->adapter->num);
+			sl->slot_state = DVB_CA_SLOTSTATE_INVALID;
+			dvb_ca_en50221_thread_update_delay(ca);
+			break;
+		}
+		/*
+		 * no other action needed; will automatically change state when
+		 * ready
+		 */
+		break;
 
-			case DVB_CA_SLOTSTATE_WAITREADY:
-				if (time_after(jiffies, ca->slot_info[slot].timeout)) {
-					pr_err("dvb_ca adaptor %d: PC card did not respond :(\n",
-					       ca->dvbdev->adapter->num);
-					ca->slot_info[slot].slot_state = DVB_CA_SLOTSTATE_INVALID;
+	case DVB_CA_SLOTSTATE_VALIDATE:
+		if (dvb_ca_en50221_parse_attributes(ca, slot) != 0) {
+			/*
+			 * we need this extra check for annoying interfaces like
+			 * the budget-av
+			 */
+			if ((!(ca->flags & DVB_CA_EN50221_FLAG_IRQ_CAMCHANGE))
+			    && (ca->pub->poll_slot_status)) {
+				status = ca->pub->poll_slot_status(ca->pub,
+								   slot, 0);
+				if (!(status &
+				      DVB_CA_EN50221_POLL_CAM_PRESENT)) {
+					sl->slot_state = DVB_CA_SLOTSTATE_NONE;
 					dvb_ca_en50221_thread_update_delay(ca);
 					break;
 				}
-				// no other action needed; will automatically change state when ready
-				break;
+			}
 
-			case DVB_CA_SLOTSTATE_VALIDATE:
-				if (dvb_ca_en50221_parse_attributes(ca, slot) != 0) {
-					/* we need this extra check for annoying interfaces like the budget-av */
-					if ((!(ca->flags & DVB_CA_EN50221_FLAG_IRQ_CAMCHANGE)) &&
-					    (ca->pub->poll_slot_status)) {
-						status = ca->pub->poll_slot_status(ca->pub, slot, 0);
-						if (!(status & DVB_CA_EN50221_POLL_CAM_PRESENT)) {
-							ca->slot_info[slot].slot_state = DVB_CA_SLOTSTATE_NONE;
-							dvb_ca_en50221_thread_update_delay(ca);
-							break;
-						}
-					}
-
-					pr_err("dvb_ca adapter %d: Invalid PC card inserted :(\n",
-					       ca->dvbdev->adapter->num);
-					ca->slot_info[slot].slot_state = DVB_CA_SLOTSTATE_INVALID;
-					dvb_ca_en50221_thread_update_delay(ca);
-					break;
-				}
-				if (dvb_ca_en50221_set_configoption(ca, slot) != 0) {
-					pr_err("dvb_ca adapter %d: Unable to initialise CAM :(\n",
-					       ca->dvbdev->adapter->num);
-					ca->slot_info[slot].slot_state = DVB_CA_SLOTSTATE_INVALID;
-					dvb_ca_en50221_thread_update_delay(ca);
-					break;
-				}
-				if (ca->pub->write_cam_control(ca->pub, slot,
-							       CTRLIF_COMMAND, CMDREG_RS) != 0) {
-					pr_err("dvb_ca adapter %d: Unable to reset CAM IF\n",
-					       ca->dvbdev->adapter->num);
-					ca->slot_info[slot].slot_state = DVB_CA_SLOTSTATE_INVALID;
-					dvb_ca_en50221_thread_update_delay(ca);
-					break;
-				}
-				dprintk("DVB CAM validated successfully\n");
+			pr_err("dvb_ca adapter %d: Invalid PC card inserted :(\n",
+			       ca->dvbdev->adapter->num);
+			sl->slot_state = DVB_CA_SLOTSTATE_INVALID;
+			dvb_ca_en50221_thread_update_delay(ca);
+			break;
+		}
+		if (dvb_ca_en50221_set_configoption(ca, slot) != 0) {
+			pr_err("dvb_ca adapter %d: Unable to initialise CAM :(\n",
+			       ca->dvbdev->adapter->num);
+			sl->slot_state = DVB_CA_SLOTSTATE_INVALID;
+			dvb_ca_en50221_thread_update_delay(ca);
+			break;
+		}
+		if (ca->pub->write_cam_control(ca->pub, slot,
+					       CTRLIF_COMMAND,
+					       CMDREG_RS) != 0) {
+			pr_err("dvb_ca adapter %d: Unable to reset CAM IF\n",
+			       ca->dvbdev->adapter->num);
+			sl->slot_state = DVB_CA_SLOTSTATE_INVALID;
+			dvb_ca_en50221_thread_update_delay(ca);
+			break;
+		}
+		dprintk("DVB CAM validated successfully\n");
 
-				ca->slot_info[slot].timeout = jiffies + (INIT_TIMEOUT_SECS * HZ);
-				ca->slot_info[slot].slot_state = DVB_CA_SLOTSTATE_WAITFR;
-				ca->wakeup = 1;
-				break;
+		sl->timeout = jiffies + (INIT_TIMEOUT_SECS * HZ);
+		sl->slot_state = DVB_CA_SLOTSTATE_WAITFR;
+		ca->wakeup = 1;
+		break;
 
-			case DVB_CA_SLOTSTATE_WAITFR:
-				if (time_after(jiffies, ca->slot_info[slot].timeout)) {
-					pr_err("dvb_ca adapter %d: DVB CAM did not respond :(\n",
-					       ca->dvbdev->adapter->num);
-					ca->slot_info[slot].slot_state = DVB_CA_SLOTSTATE_INVALID;
-					dvb_ca_en50221_thread_update_delay(ca);
-					break;
-				}
+	case DVB_CA_SLOTSTATE_WAITFR:
+		if (time_after(jiffies, sl->timeout)) {
+			pr_err("dvb_ca adapter %d: DVB CAM did not respond :(\n",
+			       ca->dvbdev->adapter->num);
+			sl->slot_state = DVB_CA_SLOTSTATE_INVALID;
+			dvb_ca_en50221_thread_update_delay(ca);
+			break;
+		}
 
-				flags = ca->pub->read_cam_control(ca->pub, slot, CTRLIF_STATUS);
-				if (flags & STATUSREG_FR) {
-					ca->slot_info[slot].slot_state = DVB_CA_SLOTSTATE_LINKINIT;
-					ca->wakeup = 1;
-				}
-				break;
+		flags = ca->pub->read_cam_control(ca->pub, slot, CTRLIF_STATUS);
+		if (flags & STATUSREG_FR) {
+			sl->slot_state = DVB_CA_SLOTSTATE_LINKINIT;
+			ca->wakeup = 1;
+		}
+		break;
 
-			case DVB_CA_SLOTSTATE_LINKINIT:
-				if (dvb_ca_en50221_link_init(ca, slot) != 0) {
-					/* we need this extra check for annoying interfaces like the budget-av */
-					if ((!(ca->flags & DVB_CA_EN50221_FLAG_IRQ_CAMCHANGE)) &&
-					    (ca->pub->poll_slot_status)) {
-						status = ca->pub->poll_slot_status(ca->pub, slot, 0);
-						if (!(status & DVB_CA_EN50221_POLL_CAM_PRESENT)) {
-							ca->slot_info[slot].slot_state = DVB_CA_SLOTSTATE_NONE;
-							dvb_ca_en50221_thread_update_delay(ca);
-							break;
-						}
-					}
-
-					pr_err("dvb_ca adapter %d: DVB CAM link initialisation failed :(\n",
-					       ca->dvbdev->adapter->num);
-					ca->slot_info[slot].slot_state =
-						DVB_CA_SLOTSTATE_UNINITIALISED;
+	case DVB_CA_SLOTSTATE_LINKINIT:
+		if (dvb_ca_en50221_link_init(ca, slot) != 0) {
+			/*
+			 * we need this extra check for annoying interfaces like
+			 * the budget-av
+			 */
+			if ((!(ca->flags & DVB_CA_EN50221_FLAG_IRQ_CAMCHANGE))
+			    && (ca->pub->poll_slot_status)) {
+				status = ca->pub->poll_slot_status(ca->pub,
+								   slot, 0);
+				if (!(status &
+					DVB_CA_EN50221_POLL_CAM_PRESENT)) {
+					sl->slot_state = DVB_CA_SLOTSTATE_NONE;
 					dvb_ca_en50221_thread_update_delay(ca);
 					break;
 				}
+			}
 
-				if (ca->slot_info[slot].rx_buffer.data == NULL) {
-					rxbuf = vmalloc(RX_BUFFER_SIZE);
-					if (rxbuf == NULL) {
-						pr_err("dvb_ca adapter %d: Unable to allocate CAM rx buffer :(\n",
-						       ca->dvbdev->adapter->num);
-						ca->slot_info[slot].slot_state = DVB_CA_SLOTSTATE_INVALID;
-						dvb_ca_en50221_thread_update_delay(ca);
-						break;
-					}
-					dvb_ringbuffer_init(&ca->slot_info[slot].rx_buffer, rxbuf, RX_BUFFER_SIZE);
-				}
+			pr_err("dvb_ca adapter %d: DVB CAM link initialisation failed :(\n",
+			       ca->dvbdev->adapter->num);
+			sl->slot_state = DVB_CA_SLOTSTATE_UNINITIALISED;
+			dvb_ca_en50221_thread_update_delay(ca);
+			break;
+		}
 
-				ca->pub->slot_ts_enable(ca->pub, slot);
-				ca->slot_info[slot].slot_state = DVB_CA_SLOTSTATE_RUNNING;
-				dvb_ca_en50221_thread_update_delay(ca);
-				pr_err("dvb_ca adapter %d: DVB CAM detected and initialised successfully\n",
+		if (!sl->rx_buffer.data) {
+			rxbuf = vmalloc(RX_BUFFER_SIZE);
+			if (!rxbuf) {
+				pr_err("dvb_ca adapter %d: Unable to allocate CAM rx buffer :(\n",
 				       ca->dvbdev->adapter->num);
+				sl->slot_state = DVB_CA_SLOTSTATE_INVALID;
+				dvb_ca_en50221_thread_update_delay(ca);
 				break;
+			}
+			dvb_ringbuffer_init(&sl->rx_buffer, rxbuf,
+					    RX_BUFFER_SIZE);
+		}
 
-			case DVB_CA_SLOTSTATE_RUNNING:
-				if (!ca->open)
-					break;
+		ca->pub->slot_ts_enable(ca->pub, slot);
+		sl->slot_state = DVB_CA_SLOTSTATE_RUNNING;
+		dvb_ca_en50221_thread_update_delay(ca);
+		pr_err("dvb_ca adapter %d: DVB CAM detected and initialised successfully\n",
+		       ca->dvbdev->adapter->num);
+		break;
 
-				// poll slots for data
-				pktcount = 0;
-				while ((status = dvb_ca_en50221_read_data(ca, slot, NULL, 0)) > 0) {
-					if (!ca->open)
-						break;
-
-					/* if a CAMCHANGE occurred at some point, do not do any more processing of this slot */
-					if (dvb_ca_en50221_check_camstatus(ca, slot)) {
-						// we dont want to sleep on the next iteration so we can handle the cam change
-						ca->wakeup = 1;
-						break;
-					}
-
-					/* check if we've hit our limit this time */
-					if (++pktcount >= MAX_RX_PACKETS_PER_ITERATION) {
-						// dont sleep; there is likely to be more data to read
-						ca->wakeup = 1;
-						break;
-					}
-				}
+	case DVB_CA_SLOTSTATE_RUNNING:
+		if (!ca->open)
+			break;
+
+		/* poll slots for data */
+		pktcount = 0;
+		while (dvb_ca_en50221_read_data(ca, slot, NULL, 0) > 0) {
+			if (!ca->open)
+				break;
+
+			/*
+			 * if a CAMCHANGE occurred at some point, do not do any
+			 * more processing of this slot
+			 */
+			if (dvb_ca_en50221_check_camstatus(ca, slot)) {
+				/*
+				 * we dont want to sleep on the next iteration
+				 * so we can handle the cam change
+				 */
+				ca->wakeup = 1;
 				break;
 			}
 
-			mutex_unlock(&ca->slot_info[slot].slot_lock);
+			/* check if we've hit our limit this time */
+			if (++pktcount >= MAX_RX_PACKETS_PER_ITERATION) {
+				/*
+				 * dont sleep; there is likely to be more data
+				 * to read
+				 */
+				ca->wakeup = 1;
+				break;
+			}
+		}
+		break;
+	}
+
+	mutex_unlock(&sl->slot_lock);
+}
+
+/**
+ * Kernel thread which monitors CA slots for CAM changes, and performs data
+ * transfers.
+ */
+static int dvb_ca_en50221_thread(void *data)
+{
+	struct dvb_ca_private *ca = data;
+	int slot;
+
+	dprintk("%s\n", __func__);
+
+	/* choose the correct initial delay */
+	dvb_ca_en50221_thread_update_delay(ca);
+
+	/* main loop */
+	while (!kthread_should_stop()) {
+		/* sleep for a bit */
+		if (!ca->wakeup) {
+			set_current_state(TASK_INTERRUPTIBLE);
+			schedule_timeout(ca->delay);
+			if (kthread_should_stop())
+				return 0;
 		}
+		ca->wakeup = 0;
+
+		/* go through all the slots processing them */
+		for (slot = 0; slot < ca->slot_count; slot++)
+			dvb_ca_en50221_thread_state_machine(ca, slot);
 	}
 
 	return 0;
-- 
2.7.4
