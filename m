Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.anw.at ([195.234.101.228]:35906 "EHLO mail.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754100AbdEGWEe (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 7 May 2017 18:04:34 -0400
From: "Jasmin J." <jasmin@anw.at>
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, max.kellermann@gmail.com, jasmin@anw.at
Subject: [PATCH 07/11] [media] dvb-core/dvb_ca_en50221.c: Make checkpatch happy 3
Date: Sun,  7 May 2017 23:23:30 +0200
Message-Id: <1494192214-20082-8-git-send-email-jasmin@anw.at>
In-Reply-To: <1494192214-20082-1-git-send-email-jasmin@anw.at>
References: <1494192214-20082-1-git-send-email-jasmin@anw.at>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jasmin Jessich <jasmin@anw.at>

Fixed all:
  WARNING: braces {} are not necessary for single statement blocks

Signed-off-by: Jasmin Jessich <jasmin@anw.at>
---
 drivers/media/dvb-core/dvb_ca_en50221.c | 48 +++++++++++++--------------------
 1 file changed, 18 insertions(+), 30 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_ca_en50221.c b/drivers/media/dvb-core/dvb_ca_en50221.c
index 6d405b5..af66c83 100644
--- a/drivers/media/dvb-core/dvb_ca_en50221.c
+++ b/drivers/media/dvb-core/dvb_ca_en50221.c
@@ -240,9 +240,8 @@ static int dvb_ca_en50221_check_camstatus(struct dvb_ca_private *ca, int slot)
 	int cam_changed;
 
 	/* IRQ mode */
-	if (ca->flags & DVB_CA_EN50221_FLAG_IRQ_CAMCHANGE) {
+	if (ca->flags & DVB_CA_EN50221_FLAG_IRQ_CAMCHANGE)
 		return (atomic_read(&sl->camchange_count) != 0);
-	}
 
 	/* poll mode */
 	slot_status = ca->pub->poll_slot_status(ca->pub, slot, ca->open);
@@ -255,11 +254,9 @@ static int dvb_ca_en50221_check_camstatus(struct dvb_ca_private *ca, int slot)
 	}
 
 	if (cam_changed) {
-		if (!cam_present_now) {
-			sl->camchange_type = DVB_CA_EN50221_CAMCHANGE_REMOVED;
-		} else {
-			sl->camchange_type = DVB_CA_EN50221_CAMCHANGE_INSERTED;
-		}
+		sl->camchange_type = cam_present_now ?
+				     DVB_CA_EN50221_CAMCHANGE_INSERTED :
+				     DVB_CA_EN50221_CAMCHANGE_REMOVED;
 		atomic_set(&sl->camchange_count, 1);
 	} else {
 		if ((sl->slot_state == SLOT_STAT_WAITREADY) &&
@@ -309,9 +306,8 @@ static int dvb_ca_en50221_wait_if_status(struct dvb_ca_private *ca, int slot,
 		}
 
 		/* check for timeout */
-		if (time_after(jiffies, timeout)) {
+		if (time_after(jiffies, timeout))
 			break;
-		}
 
 		/* wait for a bit */
 		msleep(1);
@@ -534,9 +530,8 @@ static int dvb_ca_en50221_parse_attributes(struct dvb_ca_private *ca, int slot)
 
 	sl = &ca->slot_info[slot];
 	sl->config_base = 0;
-	for (i = 0; i < rasz + 1; i++) {
+	for (i = 0; i < rasz + 1; i++)
 		sl->config_base |= (tuple[2 + i] << (8 * i));
-	}
 
 	/* check it contains the correct DVB string */
 	dvb_str = findstr((char *)tuple, tupleLength, "DVB_CI_V", 8);
@@ -774,9 +769,9 @@ static int dvb_ca_en50221_read_data(struct dvb_ca_private *ca, int slot,
 		buf[0], (buf[1] & 0x80) == 0, bytes_read);
 
 	/* wake up readers when a last_fragment is received */
-	if ((buf[1] & 0x80) == 0x00) {
+	if ((buf[1] & 0x80) == 0x00)
 		wake_up_interruptible(&ca->wait_queue);
-	}
+
 	status = bytes_read;
 
 exit:
@@ -1122,9 +1117,8 @@ static void dvb_ca_en50221_thread_state_machine(struct dvb_ca_private *ca,
 			dvb_ca_en50221_slot_shutdown(ca, slot);
 
 		/* if a CAM is NOW present, initialise it */
-		if (sl->camchange_type == DVB_CA_EN50221_CAMCHANGE_INSERTED) {
+		if (sl->camchange_type == DVB_CA_EN50221_CAMCHANGE_INSERTED)
 			sl->slot_state = SLOT_STAT_UNINIT;
-		}
 
 		/* we've handled one CAMCHANGE */
 		dvb_ca_en50221_thread_update_delay(ca);
@@ -1389,9 +1383,8 @@ static int dvb_ca_en50221_io_do_ioctl(struct file *file,
 			&& (sl->slot_state != SLOT_STAT_INVALID)) {
 			info->flags = CA_CI_MODULE_PRESENT;
 		}
-		if (sl->slot_state == SLOT_STAT_RUNNING) {
+		if (sl->slot_state == SLOT_STAT_RUNNING)
 			info->flags |= CA_CI_MODULE_READY;
-		}
 		break;
 	}
 
@@ -1541,9 +1534,8 @@ static int dvb_ca_en50221_io_read_condition(struct dvb_ca_private *ca,
 		if (sl->slot_state != SLOT_STAT_RUNNING)
 			goto nextslot;
 
-		if (sl->rx_buffer.data == NULL) {
+		if (sl->rx_buffer.data == NULL)
 			return 0;
-		}
 
 		idx = dvb_ringbuffer_pkt_next(&sl->rx_buffer, -1, &fraglen);
 		while (idx != -1) {
@@ -1637,20 +1629,18 @@ static ssize_t dvb_ca_en50221_io_read(struct file *file, char __user *buf,
 			connection_id = hdr[0];
 		if (hdr[0] == connection_id) {
 			if (pktlen < count) {
-				if ((pktlen + fraglen - 2) > count) {
+				if ((pktlen + fraglen - 2) > count)
 					fraglen = count - pktlen;
-				} else {
+				else
 					fraglen -= 2;
-				}
 
 				status =
 				   dvb_ringbuffer_pkt_read_user(&sl->rx_buffer,
 								idx, 2,
 								buf + pktlen,
 								fraglen);
-				if (status < 0) {
+				if (status < 0)
 					goto exit;
-				}
 				pktlen += fraglen;
 			}
 
@@ -1776,9 +1766,8 @@ static unsigned int dvb_ca_en50221_io_poll(struct file *file, poll_table *wait)
 
 	dprintk("%s\n", __func__);
 
-	if (dvb_ca_en50221_io_read_condition(ca, &result, &slot) == 1) {
+	if (dvb_ca_en50221_io_read_condition(ca, &result, &slot) == 1)
 		mask |= POLLIN;
-	}
 
 	/* if there is something, return now */
 	if (mask)
@@ -1787,9 +1776,8 @@ static unsigned int dvb_ca_en50221_io_poll(struct file *file, poll_table *wait)
 	/* wait for something to happen */
 	poll_wait(file, &ca->wait_queue, wait);
 
-	if (dvb_ca_en50221_io_read_condition(ca, &result, &slot) == 1) {
+	if (dvb_ca_en50221_io_read_condition(ca, &result, &slot) == 1)
 		mask |= POLLIN;
-	}
 
 	return mask;
 }
@@ -1930,9 +1918,9 @@ void dvb_ca_en50221_release(struct dvb_ca_en50221 *pubca)
 	/* shutdown the thread if there was one */
 	kthread_stop(ca->thread);
 
-	for (i = 0; i < ca->slot_count; i++) {
+	for (i = 0; i < ca->slot_count; i++)
 		dvb_ca_en50221_slot_shutdown(ca, i);
-	}
+
 	dvb_remove_device(ca->dvbdev);
 	dvb_ca_private_put(ca);
 	pubca->private = NULL;
-- 
2.7.4
