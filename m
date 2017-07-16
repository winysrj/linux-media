Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.anw.at ([195.234.101.228]:46234 "EHLO mail.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751262AbdGPAnj (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 15 Jul 2017 20:43:39 -0400
From: "Jasmin J." <jasmin@anw.at>
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, max.kellermann@gmail.com,
        rjkm@metzlerbros.de, d.scheller@gmx.net, crope@iki.fi,
        jasmin@anw.at
Subject: [PATCH V3 04/16] [media] dvb-core/dvb_ca_en50221.c: Fixed block comments
Date: Sun, 16 Jul 2017 02:43:05 +0200
Message-Id: <1500165797-16987-5-git-send-email-jasmin@anw.at>
In-Reply-To: <1500165797-16987-1-git-send-email-jasmin@anw.at>
References: <1500165797-16987-1-git-send-email-jasmin@anw.at>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jasmin Jessich <jasmin@anw.at>

Fixed all:
  WARNING: Block comments use * on subsequent lines
Added also the missing opening empty comment line.

Signed-off-by: Jasmin Jessich <jasmin@anw.at>
---
 drivers/media/dvb-core/dvb_ca_en50221.c | 29 +++++++++++++++++++----------
 1 file changed, 19 insertions(+), 10 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_ca_en50221.c b/drivers/media/dvb-core/dvb_ca_en50221.c
index 725fdd0..28e6102 100644
--- a/drivers/media/dvb-core/dvb_ca_en50221.c
+++ b/drivers/media/dvb-core/dvb_ca_en50221.c
@@ -342,8 +342,10 @@ static int dvb_ca_en50221_link_init(struct dvb_ca_private *ca, int slot)
 	/* we'll be determining these during this function */
 	ca->slot_info[slot].da_irq_supported = 0;
 
-	/* set the host link buffer size temporarily. it will be overwritten with the
-	 * real negotiated size later. */
+	/*
+	 * set the host link buffer size temporarily. it will be overwritten
+	 * with the real negotiated size later.
+	 */
 	ca->slot_info[slot].link_buf_size = 2;
 
 	/* read the buffer size from the CAM */
@@ -796,10 +798,12 @@ static int dvb_ca_en50221_write_data(struct dvb_ca_private *ca, int slot,
 	    (ca->slot_info[slot].slot_state != DVB_CA_SLOTSTATE_LINKINIT))
 		return ca->pub->write_data(ca->pub, slot, buf, bytes_write);
 
-	/* it is possible we are dealing with a single buffer implementation,
-	   thus if there is data available for read or if there is even a read
-	   already in progress, we do nothing but awake the kernel thread to
-	   process the data if necessary. */
+	/*
+	 * it is possible we are dealing with a single buffer implementation,
+	 * thus if there is data available for read or if there is even a read
+	 * already in progress, we do nothing but awake the kernel thread to
+	 * process the data if necessary.
+	 */
 	if ((status = ca->pub->read_cam_control(ca->pub, slot, CTRLIF_STATUS)) < 0)
 		goto exitnowrite;
 	if (status & (STATUSREG_DA | STATUSREG_RE)) {
@@ -899,8 +903,10 @@ static int dvb_ca_en50221_slot_shutdown(struct dvb_ca_private *ca, int slot)
 	ca->pub->slot_shutdown(ca->pub, slot);
 	ca->slot_info[slot].slot_state = DVB_CA_SLOTSTATE_NONE;
 
-	/* need to wake up all processes to check if they're now
-	   trying to write to a defunct CAM */
+	/*
+	 * need to wake up all processes to check if they're now trying to
+	 * write to a defunct CAM
+	 */
 	wake_up_interruptible(&ca->wait_queue);
 
 	dprintk("Slot %i shutdown\n", slot);
@@ -1686,8 +1692,11 @@ static int dvb_ca_en50221_io_open(struct inode *inode, struct file *file)
 
 		if (ca->slot_info[i].slot_state == DVB_CA_SLOTSTATE_RUNNING) {
 			if (ca->slot_info[i].rx_buffer.data != NULL) {
-				/* it is safe to call this here without locks because
-				 * ca->open == 0. Data is not read in this case */
+				/*
+				 * it is safe to call this here without locks
+				 * because ca->open == 0. Data is not read in
+				 * this case
+				 */
 				dvb_ringbuffer_flush(&ca->slot_info[i].rx_buffer);
 			}
 		}
-- 
2.7.4
