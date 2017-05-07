Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.anw.at ([195.234.101.228]:35906 "EHLO mail.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754100AbdEGWEb (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 7 May 2017 18:04:31 -0400
From: "Jasmin J." <jasmin@anw.at>
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, max.kellermann@gmail.com, jasmin@anw.at
Subject: [PATCH 08/11] [media] dvb-core/dvb_ca_en50221.c: Make checkpatch happy 4
Date: Sun,  7 May 2017 23:23:31 +0200
Message-Id: <1494192214-20082-9-git-send-email-jasmin@anw.at>
In-Reply-To: <1494192214-20082-1-git-send-email-jasmin@anw.at>
References: <1494192214-20082-1-git-send-email-jasmin@anw.at>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jasmin Jessich <jasmin@anw.at>

Fixed all:
  WARNING: Missing a blank line after declarations
  WARNING: Block comments use * on subsequent lines

Signed-off-by: Jasmin Jessich <jasmin@anw.at>
---
 drivers/media/dvb-core/dvb_ca_en50221.c | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_ca_en50221.c b/drivers/media/dvb-core/dvb_ca_en50221.c
index af66c83..090f343 100644
--- a/drivers/media/dvb-core/dvb_ca_en50221.c
+++ b/drivers/media/dvb-core/dvb_ca_en50221.c
@@ -178,7 +178,9 @@ static void dvb_ca_private_free(struct dvb_ca_private *ca)
 
 static void dvb_ca_private_release(struct kref *ref)
 {
-	struct dvb_ca_private *ca = container_of(ref, struct dvb_ca_private, refcount);
+	struct dvb_ca_private *ca;
+
+	ca = container_of(ref, struct dvb_ca_private, refcount);
 	dvb_ca_private_free(ca);
 }
 
@@ -237,6 +239,7 @@ static int dvb_ca_en50221_check_camstatus(struct dvb_ca_private *ca, int slot)
 	struct dvb_ca_slot *sl = &ca->slot_info[slot];
 	int slot_status;
 	int cam_present_now;
+	int cam_present_old;
 	int cam_changed;
 
 	/* IRQ mode */
@@ -249,7 +252,7 @@ static int dvb_ca_en50221_check_camstatus(struct dvb_ca_private *ca, int slot)
 	cam_present_now = (slot_status & DVB_CA_EN50221_POLL_CAM_PRESENT) ? 1 : 0;
 	cam_changed = (slot_status & DVB_CA_EN50221_POLL_CAM_CHANGED) ? 1 : 0;
 	if (!cam_changed) {
-		int cam_present_old = (sl->slot_state != SLOT_STAT_NONE);
+		cam_present_old = (sl->slot_state != SLOT_STAT_NONE);
 		cam_changed = (cam_present_now != cam_present_old);
 	}
 
@@ -294,7 +297,8 @@ static int dvb_ca_en50221_wait_if_status(struct dvb_ca_private *ca, int slot,
 	timeout = jiffies + timeout_hz;
 	while (1) {
 		/* read the status and check for error */
-		int res = ca->pub->read_cam_control(ca->pub, slot, CTRLIF_STATUS);
+		int res = ca->pub->read_cam_control(ca->pub, slot,
+						    CTRLIF_STATUS);
 		if (res < 0)
 			return -EIO;
 
@@ -809,9 +813,10 @@ static int dvb_ca_en50221_write_data(struct dvb_ca_private *ca, int slot,
 		return ca->pub->write_data(ca->pub, slot, buf, bytes_write);
 
 	/* it is possible we are dealing with a single buffer implementation,
-	   thus if there is data available for read or if there is even a read
-	   already in progress, we do nothing but awake the kernel thread to
-	   process the data if necessary. */
+	 * thus if there is data available for read or if there is even a read
+	 * already in progress, we do nothing but awake the kernel thread to
+	 * process the data if necessary.
+	 */
 	status = ca->pub->read_cam_control(ca->pub, slot, CTRLIF_STATUS);
 	if (status < 0)
 		goto exitnowrite;
@@ -921,8 +926,9 @@ static int dvb_ca_en50221_slot_shutdown(struct dvb_ca_private *ca, int slot)
 	ca->pub->slot_shutdown(ca->pub, slot);
 	ca->slot_info[slot].slot_state = SLOT_STAT_NONE;
 
-	/* need to wake up all processes to check if they're now
-	   trying to write to a defunct CAM */
+	/* need to wake up all processes to check if they're now trying to
+	 * write to a defunct CAM
+	 */
 	wake_up_interruptible(&ca->wait_queue);
 
 	dprintk("Slot %i shutdown\n", slot);
@@ -1342,6 +1348,7 @@ static int dvb_ca_en50221_io_do_ioctl(struct file *file,
 	case CA_RESET:
 		for (slot = 0; slot < ca->slot_count; slot++) {
 			struct dvb_ca_slot *sl = &ca->slot_info[slot];
+
 			mutex_lock(&sl->slot_lock);
 			if (sl->slot_state != SLOT_STAT_NONE) {
 				dvb_ca_en50221_slot_shutdown(ca, slot);
@@ -1862,6 +1869,7 @@ int dvb_ca_en50221_init(struct dvb_adapter *dvb_adapter,
 	/* now initialise each slot */
 	for (i = 0; i < slot_count; i++) {
 		struct dvb_ca_slot *sl = &ca->slot_info[i];
+
 		memset(sl, 0, sizeof(struct dvb_ca_slot));
 		sl->slot_state = SLOT_STAT_NONE;
 		atomic_set(&sl->camchange_count, 0);
-- 
2.7.4
