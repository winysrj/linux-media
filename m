Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.anw.at ([195.234.101.228]:35906 "EHLO mail.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756201AbdEGWEw (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 7 May 2017 18:04:52 -0400
From: "Jasmin J." <jasmin@anw.at>
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, max.kellermann@gmail.com, jasmin@anw.at
Subject: [PATCH 02/11] [media] dvb-core/dvb_ca_en50221.c: Rename DVB_CA_SLOTSTATE_???
Date: Sun,  7 May 2017 23:23:25 +0200
Message-Id: <1494192214-20082-3-git-send-email-jasmin@anw.at>
In-Reply-To: <1494192214-20082-1-git-send-email-jasmin@anw.at>
References: <1494192214-20082-1-git-send-email-jasmin@anw.at>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jasmin Jessich <jasmin@anw.at>

Rename DVB_CA_SLOTSTATE_??? -> SLOT_STAT_??? to reduce the line length.

Signed-off-by: Jasmin Jessich <jasmin@anw.at>
---
 drivers/media/dvb-core/dvb_ca_en50221.c | 124 ++++++++++++++++----------------
 1 file changed, 62 insertions(+), 62 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_ca_en50221.c b/drivers/media/dvb-core/dvb_ca_en50221.c
index b978246..750989c 100644
--- a/drivers/media/dvb-core/dvb_ca_en50221.c
+++ b/drivers/media/dvb-core/dvb_ca_en50221.c
@@ -79,14 +79,14 @@ MODULE_PARM_DESC(cam_debug, "enable verbose debug messages");
 #define STATREG_TXERR (STATREG_RE|STATREG_WE)	/* general transfer error */
 
 
-#define DVB_CA_SLOTSTATE_NONE           0
-#define DVB_CA_SLOTSTATE_UNINITIALISED  1
-#define DVB_CA_SLOTSTATE_RUNNING        2
-#define DVB_CA_SLOTSTATE_INVALID        3
-#define DVB_CA_SLOTSTATE_WAITREADY      4
-#define DVB_CA_SLOTSTATE_VALIDATE       5
-#define DVB_CA_SLOTSTATE_WAITFR         6
-#define DVB_CA_SLOTSTATE_LINKINIT       7
+#define SLOT_STAT_NONE       0
+#define SLOT_STAT_UNINIT     1
+#define SLOT_STAT_RUNNING    2
+#define SLOT_STAT_INVALID    3
+#define SLOT_STAT_WAITREADY  4
+#define SLOT_STAT_VALIDATE   5
+#define SLOT_STAT_WAITFR     6
+#define SLOT_STAT_LINKINIT   7
 
 
 /* Information on a CA slot */
@@ -247,7 +247,7 @@ static int dvb_ca_en50221_check_camstatus(struct dvb_ca_private *ca, int slot)
 	cam_present_now = (slot_status & DVB_CA_EN50221_POLL_CAM_PRESENT) ? 1 : 0;
 	cam_changed = (slot_status & DVB_CA_EN50221_POLL_CAM_CHANGED) ? 1 : 0;
 	if (!cam_changed) {
-		int cam_present_old = (ca->slot_info[slot].slot_state != DVB_CA_SLOTSTATE_NONE);
+		int cam_present_old = (ca->slot_info[slot].slot_state != SLOT_STAT_NONE);
 		cam_changed = (cam_present_now != cam_present_old);
 	}
 
@@ -259,10 +259,10 @@ static int dvb_ca_en50221_check_camstatus(struct dvb_ca_private *ca, int slot)
 		}
 		atomic_set(&ca->slot_info[slot].camchange_count, 1);
 	} else {
-		if ((ca->slot_info[slot].slot_state == DVB_CA_SLOTSTATE_WAITREADY) &&
+		if ((ca->slot_info[slot].slot_state == SLOT_STAT_WAITREADY) &&
 		    (slot_status & DVB_CA_EN50221_POLL_CAM_READY)) {
 			// move to validate state if reset is completed
-			ca->slot_info[slot].slot_state = DVB_CA_SLOTSTATE_VALIDATE;
+			ca->slot_info[slot].slot_state = SLOT_STAT_VALIDATE;
 		}
 	}
 
@@ -646,7 +646,7 @@ static int dvb_ca_en50221_read_data(struct dvb_ca_private *ca, int slot, u8 * eb
 		}
 	}
 
-	if (ca->pub->read_data && (ca->slot_info[slot].slot_state != DVB_CA_SLOTSTATE_LINKINIT)) {
+	if (ca->pub->read_data && (ca->slot_info[slot].slot_state != SLOT_STAT_LINKINIT)) {
 		if (ebuf == NULL)
 			status = ca->pub->read_data(ca->pub, slot, buf, sizeof(buf));
 		else
@@ -680,14 +680,14 @@ static int dvb_ca_en50221_read_data(struct dvb_ca_private *ca, int slot, u8 * eb
 			if (bytes_read > ca->slot_info[slot].link_buf_size) {
 				pr_err("dvb_ca adapter %d: CAM tried to send a buffer larger than the link buffer size (%i > %i)!\n",
 				       ca->dvbdev->adapter->num, bytes_read, ca->slot_info[slot].link_buf_size);
-				ca->slot_info[slot].slot_state = DVB_CA_SLOTSTATE_LINKINIT;
+				ca->slot_info[slot].slot_state = SLOT_STAT_LINKINIT;
 				status = -EIO;
 				goto exit;
 			}
 			if (bytes_read < 2) {
 				pr_err("dvb_ca adapter %d: CAM sent a buffer that was less than 2 bytes!\n",
 				       ca->dvbdev->adapter->num);
-				ca->slot_info[slot].slot_state = DVB_CA_SLOTSTATE_LINKINIT;
+				ca->slot_info[slot].slot_state = SLOT_STAT_LINKINIT;
 				status = -EIO;
 				goto exit;
 			}
@@ -714,7 +714,7 @@ static int dvb_ca_en50221_read_data(struct dvb_ca_private *ca, int slot, u8 * eb
 		if ((status = ca->pub->read_cam_control(ca->pub, slot, CTRLIF_STATUS)) < 0)
 			goto exit;
 		if (status & STATREG_RE) {
-			ca->slot_info[slot].slot_state = DVB_CA_SLOTSTATE_LINKINIT;
+			ca->slot_info[slot].slot_state = SLOT_STAT_LINKINIT;
 			status = -EIO;
 			goto exit;
 		}
@@ -769,7 +769,7 @@ static int dvb_ca_en50221_write_data(struct dvb_ca_private *ca, int slot, u8 * b
 	if (bytes_write > ca->slot_info[slot].link_buf_size)
 		return -EINVAL;
 
-	if (ca->pub->write_data && (ca->slot_info[slot].slot_state != DVB_CA_SLOTSTATE_LINKINIT))
+	if (ca->pub->write_data && (ca->slot_info[slot].slot_state != SLOT_STAT_LINKINIT))
 		return ca->pub->write_data(ca->pub, slot, buf, bytes_write);
 
 	/* it is possible we are dealing with a single buffer implementation,
@@ -840,7 +840,7 @@ static int dvb_ca_en50221_write_data(struct dvb_ca_private *ca, int slot, u8 * b
 	if ((status = ca->pub->read_cam_control(ca->pub, slot, CTRLIF_STATUS)) < 0)
 		goto exit;
 	if (status & STATREG_WE) {
-		ca->slot_info[slot].slot_state = DVB_CA_SLOTSTATE_LINKINIT;
+		ca->slot_info[slot].slot_state = SLOT_STAT_LINKINIT;
 		status = -EIO;
 		goto exit;
 	}
@@ -874,7 +874,7 @@ static int dvb_ca_en50221_slot_shutdown(struct dvb_ca_private *ca, int slot)
 	dprintk("%s\n", __func__);
 
 	ca->pub->slot_shutdown(ca->pub, slot);
-	ca->slot_info[slot].slot_state = DVB_CA_SLOTSTATE_NONE;
+	ca->slot_info[slot].slot_state = SLOT_STAT_NONE;
 
 	/* need to wake up all processes to check if they're now
 	   trying to write to a defunct CAM */
@@ -929,8 +929,8 @@ void dvb_ca_en50221_camready_irq(struct dvb_ca_en50221 *pubca, int slot)
 
 	dprintk("CAMREADY IRQ slot:%i\n", slot);
 
-	if (ca->slot_info[slot].slot_state == DVB_CA_SLOTSTATE_WAITREADY) {
-		ca->slot_info[slot].slot_state = DVB_CA_SLOTSTATE_VALIDATE;
+	if (ca->slot_info[slot].slot_state == SLOT_STAT_WAITREADY) {
+		ca->slot_info[slot].slot_state = SLOT_STAT_VALIDATE;
 		dvb_ca_en50221_thread_wakeup(ca);
 	}
 }
@@ -950,7 +950,7 @@ void dvb_ca_en50221_frda_irq(struct dvb_ca_en50221 *pubca, int slot)
 	dprintk("FR/DA IRQ slot:%i\n", slot);
 
 	switch (ca->slot_info[slot].slot_state) {
-	case DVB_CA_SLOTSTATE_LINKINIT:
+	case SLOT_STAT_LINKINIT:
 		flags = ca->pub->read_cam_control(pubca, slot, CTRLIF_STATUS);
 		if (flags & STATREG_DA) {
 			dprintk("CAM supports DA IRQ\n");
@@ -958,7 +958,7 @@ void dvb_ca_en50221_frda_irq(struct dvb_ca_en50221 *pubca, int slot)
 		}
 		break;
 
-	case DVB_CA_SLOTSTATE_RUNNING:
+	case SLOT_STAT_RUNNING:
 		if (ca->open)
 			dvb_ca_en50221_thread_wakeup(ca);
 		break;
@@ -1002,26 +1002,26 @@ static void dvb_ca_en50221_thread_update_delay(struct dvb_ca_private *ca)
 	for (slot = 0; slot < ca->slot_count; slot++) {
 		switch (ca->slot_info[slot].slot_state) {
 		default:
-		case DVB_CA_SLOTSTATE_NONE:
+		case SLOT_STAT_NONE:
 			delay = HZ * 60;  /* 60s */
 			if (!(ca->flags & DVB_CA_EN50221_FLAG_IRQ_CAMCHANGE))
 				delay = HZ * 5;  /* 5s */
 			break;
-		case DVB_CA_SLOTSTATE_INVALID:
+		case SLOT_STAT_INVALID:
 			delay = HZ * 60;  /* 60s */
 			if (!(ca->flags & DVB_CA_EN50221_FLAG_IRQ_CAMCHANGE))
 				delay = HZ / 10;  /* 100ms */
 			break;
 
-		case DVB_CA_SLOTSTATE_UNINITIALISED:
-		case DVB_CA_SLOTSTATE_WAITREADY:
-		case DVB_CA_SLOTSTATE_VALIDATE:
-		case DVB_CA_SLOTSTATE_WAITFR:
-		case DVB_CA_SLOTSTATE_LINKINIT:
+		case SLOT_STAT_UNINIT:
+		case SLOT_STAT_WAITREADY:
+		case SLOT_STAT_VALIDATE:
+		case SLOT_STAT_WAITFR:
+		case SLOT_STAT_LINKINIT:
 			delay = HZ / 10;  /* 100ms */
 			break;
 
-		case DVB_CA_SLOTSTATE_RUNNING:
+		case SLOT_STAT_RUNNING:
 			delay = HZ * 60;  /* 60s */
 			if (!(ca->flags & DVB_CA_EN50221_FLAG_IRQ_CAMCHANGE))
 				delay = HZ / 10;  /* 100ms */
@@ -1078,12 +1078,12 @@ static int dvb_ca_en50221_thread(void *data)
 			// check the cam status + deal with CAMCHANGEs
 			while (dvb_ca_en50221_check_camstatus(ca, slot)) {
 				/* clear down an old CI slot if necessary */
-				if (ca->slot_info[slot].slot_state != DVB_CA_SLOTSTATE_NONE)
+				if (ca->slot_info[slot].slot_state != SLOT_STAT_NONE)
 					dvb_ca_en50221_slot_shutdown(ca, slot);
 
 				/* if a CAM is NOW present, initialise it */
 				if (ca->slot_info[slot].camchange_type == DVB_CA_EN50221_CAMCHANGE_INSERTED) {
-					ca->slot_info[slot].slot_state = DVB_CA_SLOTSTATE_UNINITIALISED;
+					ca->slot_info[slot].slot_state = SLOT_STAT_UNINIT;
 				}
 
 				/* we've handled one CAMCHANGE */
@@ -1093,36 +1093,36 @@ static int dvb_ca_en50221_thread(void *data)
 
 			// CAM state machine
 			switch (ca->slot_info[slot].slot_state) {
-			case DVB_CA_SLOTSTATE_NONE:
-			case DVB_CA_SLOTSTATE_INVALID:
+			case SLOT_STAT_NONE:
+			case SLOT_STAT_INVALID:
 				// no action needed
 				break;
 
-			case DVB_CA_SLOTSTATE_UNINITIALISED:
-				ca->slot_info[slot].slot_state = DVB_CA_SLOTSTATE_WAITREADY;
+			case SLOT_STAT_UNINIT:
+				ca->slot_info[slot].slot_state = SLOT_STAT_WAITREADY;
 				ca->pub->slot_reset(ca->pub, slot);
 				ca->slot_info[slot].timeout = jiffies + (INIT_TIMEOUT_SECS * HZ);
 				break;
 
-			case DVB_CA_SLOTSTATE_WAITREADY:
+			case SLOT_STAT_WAITREADY:
 				if (time_after(jiffies, ca->slot_info[slot].timeout)) {
 					pr_err("dvb_ca adaptor %d: PC card did not respond :(\n",
 					       ca->dvbdev->adapter->num);
-					ca->slot_info[slot].slot_state = DVB_CA_SLOTSTATE_INVALID;
+					ca->slot_info[slot].slot_state = SLOT_STAT_INVALID;
 					dvb_ca_en50221_thread_update_delay(ca);
 					break;
 				}
 				// no other action needed; will automatically change state when ready
 				break;
 
-			case DVB_CA_SLOTSTATE_VALIDATE:
+			case SLOT_STAT_VALIDATE:
 				if (dvb_ca_en50221_parse_attributes(ca, slot) != 0) {
 					/* we need this extra check for annoying interfaces like the budget-av */
 					if ((!(ca->flags & DVB_CA_EN50221_FLAG_IRQ_CAMCHANGE)) &&
 					    (ca->pub->poll_slot_status)) {
 						status = ca->pub->poll_slot_status(ca->pub, slot, 0);
 						if (!(status & DVB_CA_EN50221_POLL_CAM_PRESENT)) {
-							ca->slot_info[slot].slot_state = DVB_CA_SLOTSTATE_NONE;
+							ca->slot_info[slot].slot_state = SLOT_STAT_NONE;
 							dvb_ca_en50221_thread_update_delay(ca);
 							break;
 						}
@@ -1130,14 +1130,14 @@ static int dvb_ca_en50221_thread(void *data)
 
 					pr_err("dvb_ca adapter %d: Invalid PC card inserted :(\n",
 					       ca->dvbdev->adapter->num);
-					ca->slot_info[slot].slot_state = DVB_CA_SLOTSTATE_INVALID;
+					ca->slot_info[slot].slot_state = SLOT_STAT_INVALID;
 					dvb_ca_en50221_thread_update_delay(ca);
 					break;
 				}
 				if (dvb_ca_en50221_set_configoption(ca, slot) != 0) {
 					pr_err("dvb_ca adapter %d: Unable to initialise CAM :(\n",
 					       ca->dvbdev->adapter->num);
-					ca->slot_info[slot].slot_state = DVB_CA_SLOTSTATE_INVALID;
+					ca->slot_info[slot].slot_state = SLOT_STAT_INVALID;
 					dvb_ca_en50221_thread_update_delay(ca);
 					break;
 				}
@@ -1145,41 +1145,41 @@ static int dvb_ca_en50221_thread(void *data)
 							       CTRLIF_COMMAND, CMDREG_RS) != 0) {
 					pr_err("dvb_ca adapter %d: Unable to reset CAM IF\n",
 					       ca->dvbdev->adapter->num);
-					ca->slot_info[slot].slot_state = DVB_CA_SLOTSTATE_INVALID;
+					ca->slot_info[slot].slot_state = SLOT_STAT_INVALID;
 					dvb_ca_en50221_thread_update_delay(ca);
 					break;
 				}
 				dprintk("DVB CAM validated successfully\n");
 
 				ca->slot_info[slot].timeout = jiffies + (INIT_TIMEOUT_SECS * HZ);
-				ca->slot_info[slot].slot_state = DVB_CA_SLOTSTATE_WAITFR;
+				ca->slot_info[slot].slot_state = SLOT_STAT_WAITFR;
 				ca->wakeup = 1;
 				break;
 
-			case DVB_CA_SLOTSTATE_WAITFR:
+			case SLOT_STAT_WAITFR:
 				if (time_after(jiffies, ca->slot_info[slot].timeout)) {
 					pr_err("dvb_ca adapter %d: DVB CAM did not respond :(\n",
 					       ca->dvbdev->adapter->num);
-					ca->slot_info[slot].slot_state = DVB_CA_SLOTSTATE_INVALID;
+					ca->slot_info[slot].slot_state = SLOT_STAT_INVALID;
 					dvb_ca_en50221_thread_update_delay(ca);
 					break;
 				}
 
 				flags = ca->pub->read_cam_control(ca->pub, slot, CTRLIF_STATUS);
 				if (flags & STATREG_FR) {
-					ca->slot_info[slot].slot_state = DVB_CA_SLOTSTATE_LINKINIT;
+					ca->slot_info[slot].slot_state = SLOT_STAT_LINKINIT;
 					ca->wakeup = 1;
 				}
 				break;
 
-			case DVB_CA_SLOTSTATE_LINKINIT:
+			case SLOT_STAT_LINKINIT:
 				if (dvb_ca_en50221_link_init(ca, slot) != 0) {
 					/* we need this extra check for annoying interfaces like the budget-av */
 					if ((!(ca->flags & DVB_CA_EN50221_FLAG_IRQ_CAMCHANGE)) &&
 					    (ca->pub->poll_slot_status)) {
 						status = ca->pub->poll_slot_status(ca->pub, slot, 0);
 						if (!(status & DVB_CA_EN50221_POLL_CAM_PRESENT)) {
-							ca->slot_info[slot].slot_state = DVB_CA_SLOTSTATE_NONE;
+							ca->slot_info[slot].slot_state = SLOT_STAT_NONE;
 							dvb_ca_en50221_thread_update_delay(ca);
 							break;
 						}
@@ -1187,7 +1187,7 @@ static int dvb_ca_en50221_thread(void *data)
 
 					pr_err("dvb_ca adapter %d: DVB CAM link initialisation failed :(\n",
 					       ca->dvbdev->adapter->num);
-					ca->slot_info[slot].slot_state = DVB_CA_SLOTSTATE_UNINITIALISED;
+					ca->slot_info[slot].slot_state = SLOT_STAT_UNINIT;
 					dvb_ca_en50221_thread_update_delay(ca);
 					break;
 				}
@@ -1197,7 +1197,7 @@ static int dvb_ca_en50221_thread(void *data)
 					if (rxbuf == NULL) {
 						pr_err("dvb_ca adapter %d: Unable to allocate CAM rx buffer :(\n",
 						       ca->dvbdev->adapter->num);
-						ca->slot_info[slot].slot_state = DVB_CA_SLOTSTATE_INVALID;
+						ca->slot_info[slot].slot_state = SLOT_STAT_INVALID;
 						dvb_ca_en50221_thread_update_delay(ca);
 						break;
 					}
@@ -1205,13 +1205,13 @@ static int dvb_ca_en50221_thread(void *data)
 				}
 
 				ca->pub->slot_ts_enable(ca->pub, slot);
-				ca->slot_info[slot].slot_state = DVB_CA_SLOTSTATE_RUNNING;
+				ca->slot_info[slot].slot_state = SLOT_STAT_RUNNING;
 				dvb_ca_en50221_thread_update_delay(ca);
 				pr_err("dvb_ca adapter %d: DVB CAM detected and initialised successfully\n",
 				       ca->dvbdev->adapter->num);
 				break;
 
-			case DVB_CA_SLOTSTATE_RUNNING:
+			case SLOT_STAT_RUNNING:
 				if (!ca->open)
 					break;
 
@@ -1278,7 +1278,7 @@ static int dvb_ca_en50221_io_do_ioctl(struct file *file,
 	case CA_RESET:
 		for (slot = 0; slot < ca->slot_count; slot++) {
 			mutex_lock(&ca->slot_info[slot].slot_lock);
-			if (ca->slot_info[slot].slot_state != DVB_CA_SLOTSTATE_NONE) {
+			if (ca->slot_info[slot].slot_state != SLOT_STAT_NONE) {
 				dvb_ca_en50221_slot_shutdown(ca, slot);
 				if (ca->flags & DVB_CA_EN50221_FLAG_IRQ_CAMCHANGE)
 					dvb_ca_en50221_camchange_irq(ca->pub,
@@ -1311,11 +1311,11 @@ static int dvb_ca_en50221_io_do_ioctl(struct file *file,
 
 		info->type = CA_CI_LINK;
 		info->flags = 0;
-		if ((ca->slot_info[info->num].slot_state != DVB_CA_SLOTSTATE_NONE)
-			&& (ca->slot_info[info->num].slot_state != DVB_CA_SLOTSTATE_INVALID)) {
+		if ((ca->slot_info[info->num].slot_state != SLOT_STAT_NONE)
+			&& (ca->slot_info[info->num].slot_state != SLOT_STAT_INVALID)) {
 			info->flags = CA_CI_MODULE_PRESENT;
 		}
-		if (ca->slot_info[info->num].slot_state == DVB_CA_SLOTSTATE_RUNNING) {
+		if (ca->slot_info[info->num].slot_state == SLOT_STAT_RUNNING) {
 			info->flags |= CA_CI_MODULE_READY;
 		}
 		break;
@@ -1387,7 +1387,7 @@ static ssize_t dvb_ca_en50221_io_write(struct file *file,
 	count -= 2;
 
 	/* check if the slot is actually running */
-	if (ca->slot_info[slot].slot_state != DVB_CA_SLOTSTATE_RUNNING)
+	if (ca->slot_info[slot].slot_state != SLOT_STAT_RUNNING)
 		return -EINVAL;
 
 	/* fragment the packets & store in the buffer */
@@ -1412,7 +1412,7 @@ static ssize_t dvb_ca_en50221_io_write(struct file *file,
 		written = 0;
 		while (!time_after(jiffies, timeout)) {
 			/* check the CAM hasn't been removed/reset in the meantime */
-			if (ca->slot_info[slot].slot_state != DVB_CA_SLOTSTATE_RUNNING) {
+			if (ca->slot_info[slot].slot_state != SLOT_STAT_RUNNING) {
 				status = -EIO;
 				goto exit;
 			}
@@ -1459,7 +1459,7 @@ static int dvb_ca_en50221_io_read_condition(struct dvb_ca_private *ca,
 
 	slot = ca->next_read_slot;
 	while ((slot_count < ca->slot_count) && (!found)) {
-		if (ca->slot_info[slot].slot_state != DVB_CA_SLOTSTATE_RUNNING)
+		if (ca->slot_info[slot].slot_state != SLOT_STAT_RUNNING)
 			goto nextslot;
 
 		if (ca->slot_info[slot].rx_buffer.data == NULL) {
@@ -1622,7 +1622,7 @@ static int dvb_ca_en50221_io_open(struct inode *inode, struct file *file)
 
 	for (i = 0; i < ca->slot_count; i++) {
 
-		if (ca->slot_info[i].slot_state == DVB_CA_SLOTSTATE_RUNNING) {
+		if (ca->slot_info[i].slot_state == SLOT_STAT_RUNNING) {
 			if (ca->slot_info[i].rx_buffer.data != NULL) {
 				/* it is safe to call this here without locks because
 				 * ca->open == 0. Data is not read in this case */
@@ -1784,7 +1784,7 @@ int dvb_ca_en50221_init(struct dvb_adapter *dvb_adapter,
 	/* now initialise each slot */
 	for (i = 0; i < slot_count; i++) {
 		memset(&ca->slot_info[i], 0, sizeof(struct dvb_ca_slot));
-		ca->slot_info[i].slot_state = DVB_CA_SLOTSTATE_NONE;
+		ca->slot_info[i].slot_state = SLOT_STAT_NONE;
 		atomic_set(&ca->slot_info[i].camchange_count, 0);
 		ca->slot_info[i].camchange_type = DVB_CA_EN50221_CAMCHANGE_REMOVED;
 		mutex_init(&ca->slot_info[i].slot_lock);
-- 
2.7.4
