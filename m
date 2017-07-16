Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.anw.at ([195.234.101.228]:46245 "EHLO mail.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751253AbdGPAnj (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 15 Jul 2017 20:43:39 -0400
From: "Jasmin J." <jasmin@anw.at>
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, max.kellermann@gmail.com,
        rjkm@metzlerbros.de, d.scheller@gmx.net, crope@iki.fi,
        jasmin@anw.at
Subject: [PATCH V3 08/16] [media] dvb-core/dvb_ca_en50221.c: Removed useless braces
Date: Sun, 16 Jul 2017 02:43:09 +0200
Message-Id: <1500165797-16987-9-git-send-email-jasmin@anw.at>
In-Reply-To: <1500165797-16987-1-git-send-email-jasmin@anw.at>
References: <1500165797-16987-1-git-send-email-jasmin@anw.at>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jasmin Jessich <jasmin@anw.at>

Fixed all:
  WARNING: braces {} are not necessary for single statement blocks

Signed-off-by: Jasmin Jessich <jasmin@anw.at>
---
 drivers/media/dvb-core/dvb_ca_en50221.c | 30 ++++++++++++------------------
 1 file changed, 12 insertions(+), 18 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_ca_en50221.c b/drivers/media/dvb-core/dvb_ca_en50221.c
index 678bd6a..ce22bdb 100644
--- a/drivers/media/dvb-core/dvb_ca_en50221.c
+++ b/drivers/media/dvb-core/dvb_ca_en50221.c
@@ -242,9 +242,8 @@ static int dvb_ca_en50221_check_camstatus(struct dvb_ca_private *ca, int slot)
 	int cam_changed;
 
 	/* IRQ mode */
-	if (ca->flags & DVB_CA_EN50221_FLAG_IRQ_CAMCHANGE) {
+	if (ca->flags & DVB_CA_EN50221_FLAG_IRQ_CAMCHANGE)
 		return (atomic_read(&sl->camchange_count) != 0);
-	}
 
 	/* poll mode */
 	slot_status = ca->pub->poll_slot_status(ca->pub, slot, ca->open);
@@ -258,11 +257,10 @@ static int dvb_ca_en50221_check_camstatus(struct dvb_ca_private *ca, int slot)
 	}
 
 	if (cam_changed) {
-		if (!cam_present_now) {
+		if (!cam_present_now)
 			sl->camchange_type = DVB_CA_EN50221_CAMCHANGE_REMOVED;
-		} else {
+		else
 			sl->camchange_type = DVB_CA_EN50221_CAMCHANGE_INSERTED;
-		}
 		atomic_set(&sl->camchange_count, 1);
 	} else {
 		if ((sl->slot_state == DVB_CA_SLOTSTATE_WAITREADY) &&
@@ -314,9 +312,8 @@ static int dvb_ca_en50221_wait_if_status(struct dvb_ca_private *ca, int slot,
 		}
 
 		/* check for timeout */
-		if (time_after(jiffies, timeout)) {
+		if (time_after(jiffies, timeout))
 			break;
-		}
 
 		/* wait for a bit */
 		usleep_range(1000, 1100);
@@ -786,9 +783,9 @@ static int dvb_ca_en50221_read_data(struct dvb_ca_private *ca, int slot,
 		buf[0], (buf[1] & 0x80) == 0, bytes_read);
 
 	/* wake up readers when a last_fragment is received */
-	if ((buf[1] & 0x80) == 0x00) {
+	if ((buf[1] & 0x80) == 0x00)
 		wake_up_interruptible(&ca->wait_queue);
-	}
+
 	status = bytes_read;
 
 exit:
@@ -1676,11 +1673,10 @@ static ssize_t dvb_ca_en50221_io_read(struct file *file, char __user *buf,
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
@@ -1818,9 +1814,8 @@ static unsigned int dvb_ca_en50221_io_poll(struct file *file, poll_table *wait)
 
 	dprintk("%s\n", __func__);
 
-	if (dvb_ca_en50221_io_read_condition(ca, &result, &slot) == 1) {
+	if (dvb_ca_en50221_io_read_condition(ca, &result, &slot) == 1)
 		mask |= POLLIN;
-	}
 
 	/* if there is something, return now */
 	if (mask)
@@ -1829,9 +1824,8 @@ static unsigned int dvb_ca_en50221_io_poll(struct file *file, poll_table *wait)
 	/* wait for something to happen */
 	poll_wait(file, &ca->wait_queue, wait);
 
-	if (dvb_ca_en50221_io_read_condition(ca, &result, &slot) == 1) {
+	if (dvb_ca_en50221_io_read_condition(ca, &result, &slot) == 1)
 		mask |= POLLIN;
-	}
 
 	return mask;
 }
@@ -1973,9 +1967,9 @@ void dvb_ca_en50221_release(struct dvb_ca_en50221 *pubca)
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
