Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.anw.at ([195.234.101.228]:35906 "EHLO mail.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755934AbdEGWEy (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 7 May 2017 18:04:54 -0400
From: "Jasmin J." <jasmin@anw.at>
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, max.kellermann@gmail.com, jasmin@anw.at
Subject: [PATCH 03/11] [media] dvb-core/dvb_ca_en50221.c: Used a helper variable
Date: Sun,  7 May 2017 23:23:26 +0200
Message-Id: <1494192214-20082-4-git-send-email-jasmin@anw.at>
In-Reply-To: <1494192214-20082-1-git-send-email-jasmin@anw.at>
References: <1494192214-20082-1-git-send-email-jasmin@anw.at>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jasmin Jessich <jasmin@anw.at>

Used a helper variable "struct dvb_ca_slot *sl" instead of
"ca->slot_info[slot]". This reduces the line lenght and simplifies
code reading.
Renamed "i" to "slot" in some functions to make the code more readable.

Signed-off-by: Jasmin Jessich <jasmin@anw.at>
---
 drivers/media/dvb-core/dvb_ca_en50221.c | 221 ++++++++++++++++++--------------
 1 file changed, 123 insertions(+), 98 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_ca_en50221.c b/drivers/media/dvb-core/dvb_ca_en50221.c
index 750989c..ba30bcf4 100644
--- a/drivers/media/dvb-core/dvb_ca_en50221.c
+++ b/drivers/media/dvb-core/dvb_ca_en50221.c
@@ -232,13 +232,14 @@ static char *findstr(char * haystack, int hlen, char * needle, int nlen)
  */
 static int dvb_ca_en50221_check_camstatus(struct dvb_ca_private *ca, int slot)
 {
+	struct dvb_ca_slot *sl = &ca->slot_info[slot];
 	int slot_status;
 	int cam_present_now;
 	int cam_changed;
 
 	/* IRQ mode */
 	if (ca->flags & DVB_CA_EN50221_FLAG_IRQ_CAMCHANGE) {
-		return (atomic_read(&ca->slot_info[slot].camchange_count) != 0);
+		return (atomic_read(&sl->camchange_count) != 0);
 	}
 
 	/* poll mode */
@@ -247,22 +248,22 @@ static int dvb_ca_en50221_check_camstatus(struct dvb_ca_private *ca, int slot)
 	cam_present_now = (slot_status & DVB_CA_EN50221_POLL_CAM_PRESENT) ? 1 : 0;
 	cam_changed = (slot_status & DVB_CA_EN50221_POLL_CAM_CHANGED) ? 1 : 0;
 	if (!cam_changed) {
-		int cam_present_old = (ca->slot_info[slot].slot_state != SLOT_STAT_NONE);
+		int cam_present_old = (sl->slot_state != SLOT_STAT_NONE);
 		cam_changed = (cam_present_now != cam_present_old);
 	}
 
 	if (cam_changed) {
 		if (!cam_present_now) {
-			ca->slot_info[slot].camchange_type = DVB_CA_EN50221_CAMCHANGE_REMOVED;
+			sl->camchange_type = DVB_CA_EN50221_CAMCHANGE_REMOVED;
 		} else {
-			ca->slot_info[slot].camchange_type = DVB_CA_EN50221_CAMCHANGE_INSERTED;
+			sl->camchange_type = DVB_CA_EN50221_CAMCHANGE_INSERTED;
 		}
-		atomic_set(&ca->slot_info[slot].camchange_count, 1);
+		atomic_set(&sl->camchange_count, 1);
 	} else {
-		if ((ca->slot_info[slot].slot_state == SLOT_STAT_WAITREADY) &&
+		if ((sl->slot_state == SLOT_STAT_WAITREADY) &&
 		    (slot_status & DVB_CA_EN50221_POLL_CAM_READY)) {
 			// move to validate state if reset is completed
-			ca->slot_info[slot].slot_state = SLOT_STAT_VALIDATE;
+			sl->slot_state = SLOT_STAT_VALIDATE;
 		}
 	}
 
@@ -331,6 +332,7 @@ static int dvb_ca_en50221_wait_if_status(struct dvb_ca_private *ca, int slot,
  */
 static int dvb_ca_en50221_link_init(struct dvb_ca_private *ca, int slot)
 {
+	struct dvb_ca_slot *sl = &ca->slot_info[slot];
 	int ret;
 	int buf_size;
 	u8 buf[2];
@@ -338,11 +340,11 @@ static int dvb_ca_en50221_link_init(struct dvb_ca_private *ca, int slot)
 	dprintk("%s\n", __func__);
 
 	/* we'll be determining these during this function */
-	ca->slot_info[slot].da_irq_supported = 0;
+	sl->da_irq_supported = 0;
 
 	/* set the host link buffer size temporarily. it will be overwritten with the
 	 * real negotiated size later. */
-	ca->slot_info[slot].link_buf_size = 2;
+	sl->link_buf_size = 2;
 
 	/* read the buffer size from the CAM */
 	if ((ret = ca->pub->write_cam_control(ca->pub, slot, CTRLIF_COMMAND, IRQEN | CMDREG_SR)) != 0)
@@ -358,7 +360,7 @@ static int dvb_ca_en50221_link_init(struct dvb_ca_private *ca, int slot)
 	buf_size = (buf[0] << 8) | buf[1];
 	if (buf_size > HOST_LINK_BUF_SIZE)
 		buf_size = HOST_LINK_BUF_SIZE;
-	ca->slot_info[slot].link_buf_size = buf_size;
+	sl->link_buf_size = buf_size;
 	buf[0] = buf_size >> 8;
 	buf[1] = buf_size & 0xff;
 	dprintk("Chosen link buffer size of %i\n", buf_size);
@@ -441,6 +443,7 @@ static int dvb_ca_en50221_read_tuple(struct dvb_ca_private *ca, int slot,
  */
 static int dvb_ca_en50221_parse_attributes(struct dvb_ca_private *ca, int slot)
 {
+	struct dvb_ca_slot *sl;
 	int address = 0;
 	int tupleLength;
 	int tupleType;
@@ -508,9 +511,11 @@ static int dvb_ca_en50221_parse_attributes(struct dvb_ca_private *ca, int slot)
 	rasz = tuple[0] & 3;
 	if (tupleLength < (3 + rasz + 14))
 		return -EINVAL;
-	ca->slot_info[slot].config_base = 0;
+
+	sl = &ca->slot_info[slot];
+	sl->config_base = 0;
 	for (i = 0; i < rasz + 1; i++) {
-		ca->slot_info[slot].config_base |= (tuple[2 + i] << (8 * i));
+		sl->config_base |= (tuple[2 + i] << (8 * i));
 	}
 
 	/* check it contains the correct DVB string */
@@ -543,7 +548,7 @@ static int dvb_ca_en50221_parse_attributes(struct dvb_ca_private *ca, int slot)
 				break;
 
 			/* get the config option */
-			ca->slot_info[slot].config_option = tuple[0] & 0x3f;
+			sl->config_option = tuple[0] & 0x3f;
 
 			/* OK, check it contains the correct strings */
 			if ((findstr((char *)tuple, tupleLength, "DVB_HOST", 8) == NULL) ||
@@ -571,8 +576,7 @@ static int dvb_ca_en50221_parse_attributes(struct dvb_ca_private *ca, int slot)
 		return -EINVAL;
 
 	dprintk("Valid DVB CAM detected MANID:%x DEVID:%x CONFIGBASE:0x%x CONFIGOPTION:0x%x\n",
-		manfid, devid, ca->slot_info[slot].config_base,
-		ca->slot_info[slot].config_option);
+		manfid, devid, sl->config_base, sl->config_option);
 
 	// success!
 	return 0;
@@ -587,19 +591,20 @@ static int dvb_ca_en50221_parse_attributes(struct dvb_ca_private *ca, int slot)
  */
 static int dvb_ca_en50221_set_configoption(struct dvb_ca_private *ca, int slot)
 {
+	struct dvb_ca_slot *sl = &ca->slot_info[slot];
 	int configoption;
 
 	dprintk("%s\n", __func__);
 
 	/* set the config option */
-	ca->pub->write_attribute_mem(ca->pub, slot,
-				     ca->slot_info[slot].config_base,
-				     ca->slot_info[slot].config_option);
+	ca->pub->write_attribute_mem(ca->pub, slot, sl->config_base,
+				     sl->config_option);
 
 	/* check it */
-	configoption = ca->pub->read_attribute_mem(ca->pub, slot, ca->slot_info[slot].config_base);
+	configoption = ca->pub->read_attribute_mem(ca->pub, slot,
+						   sl->config_base);
 	dprintk("Set configoption 0x%x, read configoption 0x%x\n",
-		ca->slot_info[slot].config_option, configoption & 0x3f);
+		sl->config_option, configoption & 0x3f);
 
 	/* fine! */
 	return 0;
@@ -623,6 +628,7 @@ static int dvb_ca_en50221_set_configoption(struct dvb_ca_private *ca, int slot)
  */
 static int dvb_ca_en50221_read_data(struct dvb_ca_private *ca, int slot, u8 * ebuf, int ecount)
 {
+	struct dvb_ca_slot *sl = &ca->slot_info[slot];
 	int bytes_read;
 	int status;
 	u8 buf[HOST_LINK_BUF_SIZE];
@@ -634,19 +640,19 @@ static int dvb_ca_en50221_read_data(struct dvb_ca_private *ca, int slot, u8 * eb
 	if (ebuf == NULL) {
 		int buf_free;
 
-		if (ca->slot_info[slot].rx_buffer.data == NULL) {
+		if (sl->rx_buffer.data == NULL) {
 			status = -EIO;
 			goto exit;
 		}
-		buf_free = dvb_ringbuffer_free(&ca->slot_info[slot].rx_buffer);
+		buf_free = dvb_ringbuffer_free(&sl->rx_buffer);
 
-		if (buf_free < (ca->slot_info[slot].link_buf_size + DVB_RINGBUFFER_PKTHDRSIZE)) {
+		if (buf_free < (sl->link_buf_size + DVB_RINGBUFFER_PKTHDRSIZE)) {
 			status = -EAGAIN;
 			goto exit;
 		}
 	}
 
-	if (ca->pub->read_data && (ca->slot_info[slot].slot_state != SLOT_STAT_LINKINIT)) {
+	if (ca->pub->read_data && (sl->slot_state != SLOT_STAT_LINKINIT)) {
 		if (ebuf == NULL)
 			status = ca->pub->read_data(ca->pub, slot, buf, sizeof(buf));
 		else
@@ -677,17 +683,17 @@ static int dvb_ca_en50221_read_data(struct dvb_ca_private *ca, int slot, u8 * eb
 
 		/* check it will fit */
 		if (ebuf == NULL) {
-			if (bytes_read > ca->slot_info[slot].link_buf_size) {
+			if (bytes_read > sl->link_buf_size) {
 				pr_err("dvb_ca adapter %d: CAM tried to send a buffer larger than the link buffer size (%i > %i)!\n",
-				       ca->dvbdev->adapter->num, bytes_read, ca->slot_info[slot].link_buf_size);
-				ca->slot_info[slot].slot_state = SLOT_STAT_LINKINIT;
+				       ca->dvbdev->adapter->num, bytes_read, sl->link_buf_size);
+				sl->slot_state = SLOT_STAT_LINKINIT;
 				status = -EIO;
 				goto exit;
 			}
 			if (bytes_read < 2) {
 				pr_err("dvb_ca adapter %d: CAM sent a buffer that was less than 2 bytes!\n",
 				       ca->dvbdev->adapter->num);
-				ca->slot_info[slot].slot_state = SLOT_STAT_LINKINIT;
+				sl->slot_state = SLOT_STAT_LINKINIT;
 				status = -EIO;
 				goto exit;
 			}
@@ -714,7 +720,7 @@ static int dvb_ca_en50221_read_data(struct dvb_ca_private *ca, int slot, u8 * eb
 		if ((status = ca->pub->read_cam_control(ca->pub, slot, CTRLIF_STATUS)) < 0)
 			goto exit;
 		if (status & STATREG_RE) {
-			ca->slot_info[slot].slot_state = SLOT_STAT_LINKINIT;
+			sl->slot_state = SLOT_STAT_LINKINIT;
 			status = -EIO;
 			goto exit;
 		}
@@ -722,11 +728,11 @@ static int dvb_ca_en50221_read_data(struct dvb_ca_private *ca, int slot, u8 * eb
 
 	/* OK, add it to the receive buffer, or copy into external buffer if supplied */
 	if (ebuf == NULL) {
-		if (ca->slot_info[slot].rx_buffer.data == NULL) {
+		if (sl->rx_buffer.data == NULL) {
 			status = -EIO;
 			goto exit;
 		}
-		dvb_ringbuffer_pkt_write(&ca->slot_info[slot].rx_buffer, buf, bytes_read);
+		dvb_ringbuffer_pkt_write(&sl->rx_buffer, buf, bytes_read);
 	} else {
 		memcpy(ebuf, buf, bytes_read);
 	}
@@ -759,6 +765,7 @@ static int dvb_ca_en50221_read_data(struct dvb_ca_private *ca, int slot, u8 * eb
  */
 static int dvb_ca_en50221_write_data(struct dvb_ca_private *ca, int slot, u8 * buf, int bytes_write)
 {
+	struct dvb_ca_slot *sl = &ca->slot_info[slot];
 	int status;
 	int i;
 
@@ -766,10 +773,10 @@ static int dvb_ca_en50221_write_data(struct dvb_ca_private *ca, int slot, u8 * b
 
 
 	/* sanity check */
-	if (bytes_write > ca->slot_info[slot].link_buf_size)
+	if (bytes_write > sl->link_buf_size)
 		return -EINVAL;
 
-	if (ca->pub->write_data && (ca->slot_info[slot].slot_state != SLOT_STAT_LINKINIT))
+	if (ca->pub->write_data && (sl->slot_state != SLOT_STAT_LINKINIT))
 		return ca->pub->write_data(ca->pub, slot, buf, bytes_write);
 
 	/* it is possible we are dealing with a single buffer implementation,
@@ -840,7 +847,7 @@ static int dvb_ca_en50221_write_data(struct dvb_ca_private *ca, int slot, u8 * b
 	if ((status = ca->pub->read_cam_control(ca->pub, slot, CTRLIF_STATUS)) < 0)
 		goto exit;
 	if (status & STATREG_WE) {
-		ca->slot_info[slot].slot_state = SLOT_STAT_LINKINIT;
+		sl->slot_state = SLOT_STAT_LINKINIT;
 		status = -EIO;
 		goto exit;
 	}
@@ -898,6 +905,7 @@ EXPORT_SYMBOL(dvb_ca_en50221_camready_irq);
 void dvb_ca_en50221_camchange_irq(struct dvb_ca_en50221 *pubca, int slot, int change_type)
 {
 	struct dvb_ca_private *ca = pubca->private;
+	struct dvb_ca_slot *sl = &ca->slot_info[slot];
 
 	dprintk("CAMCHANGE IRQ slot:%i change_type:%i\n", slot, change_type);
 
@@ -910,8 +918,8 @@ void dvb_ca_en50221_camchange_irq(struct dvb_ca_en50221 *pubca, int slot, int ch
 		return;
 	}
 
-	ca->slot_info[slot].camchange_type = change_type;
-	atomic_inc(&ca->slot_info[slot].camchange_count);
+	sl->camchange_type = change_type;
+	atomic_inc(&sl->camchange_count);
 	dvb_ca_en50221_thread_wakeup(ca);
 }
 EXPORT_SYMBOL(dvb_ca_en50221_frda_irq);
@@ -926,11 +934,12 @@ EXPORT_SYMBOL(dvb_ca_en50221_frda_irq);
 void dvb_ca_en50221_camready_irq(struct dvb_ca_en50221 *pubca, int slot)
 {
 	struct dvb_ca_private *ca = pubca->private;
+	struct dvb_ca_slot *sl = &ca->slot_info[slot];
 
 	dprintk("CAMREADY IRQ slot:%i\n", slot);
 
-	if (ca->slot_info[slot].slot_state == SLOT_STAT_WAITREADY) {
-		ca->slot_info[slot].slot_state = SLOT_STAT_VALIDATE;
+	if (sl->slot_state == SLOT_STAT_WAITREADY) {
+		sl->slot_state = SLOT_STAT_VALIDATE;
 		dvb_ca_en50221_thread_wakeup(ca);
 	}
 }
@@ -945,16 +954,17 @@ void dvb_ca_en50221_camready_irq(struct dvb_ca_en50221 *pubca, int slot)
 void dvb_ca_en50221_frda_irq(struct dvb_ca_en50221 *pubca, int slot)
 {
 	struct dvb_ca_private *ca = pubca->private;
+	struct dvb_ca_slot *sl = &ca->slot_info[slot];
 	int flags;
 
 	dprintk("FR/DA IRQ slot:%i\n", slot);
 
-	switch (ca->slot_info[slot].slot_state) {
+	switch (sl->slot_state) {
 	case SLOT_STAT_LINKINIT:
 		flags = ca->pub->read_cam_control(pubca, slot, CTRLIF_STATUS);
 		if (flags & STATREG_DA) {
 			dprintk("CAM supports DA IRQ\n");
-			ca->slot_info[slot].da_irq_supported = 1;
+			sl->da_irq_supported = 1;
 		}
 		break;
 
@@ -1000,7 +1010,9 @@ static void dvb_ca_en50221_thread_update_delay(struct dvb_ca_private *ca)
 	 * call might take several hundred milliseconds until timeout!
 	 */
 	for (slot = 0; slot < ca->slot_count; slot++) {
-		switch (ca->slot_info[slot].slot_state) {
+		struct dvb_ca_slot *sl = &ca->slot_info[slot];
+
+		switch (sl->slot_state) {
 		default:
 		case SLOT_STAT_NONE:
 			delay = HZ * 60;  /* 60s */
@@ -1026,7 +1038,7 @@ static void dvb_ca_en50221_thread_update_delay(struct dvb_ca_private *ca)
 			if (!(ca->flags & DVB_CA_EN50221_FLAG_IRQ_CAMCHANGE))
 				delay = HZ / 10;  /* 100ms */
 			if (ca->open) {
-				if ((!ca->slot_info[slot].da_irq_supported) ||
+				if ((!sl->da_irq_supported) ||
 				    (!(ca->flags & DVB_CA_EN50221_FLAG_IRQ_DA)))
 					delay = HZ / 10;  /* 100ms */
 			}
@@ -1072,43 +1084,44 @@ static int dvb_ca_en50221_thread(void *data)
 
 		/* go through all the slots processing them */
 		for (slot = 0; slot < ca->slot_count; slot++) {
+			struct dvb_ca_slot *sl = &ca->slot_info[slot];
 
-			mutex_lock(&ca->slot_info[slot].slot_lock);
+			mutex_lock(&sl->slot_lock);
 
 			// check the cam status + deal with CAMCHANGEs
 			while (dvb_ca_en50221_check_camstatus(ca, slot)) {
 				/* clear down an old CI slot if necessary */
-				if (ca->slot_info[slot].slot_state != SLOT_STAT_NONE)
+				if (sl->slot_state != SLOT_STAT_NONE)
 					dvb_ca_en50221_slot_shutdown(ca, slot);
 
 				/* if a CAM is NOW present, initialise it */
-				if (ca->slot_info[slot].camchange_type == DVB_CA_EN50221_CAMCHANGE_INSERTED) {
-					ca->slot_info[slot].slot_state = SLOT_STAT_UNINIT;
+				if (sl->camchange_type == DVB_CA_EN50221_CAMCHANGE_INSERTED) {
+					sl->slot_state = SLOT_STAT_UNINIT;
 				}
 
 				/* we've handled one CAMCHANGE */
 				dvb_ca_en50221_thread_update_delay(ca);
-				atomic_dec(&ca->slot_info[slot].camchange_count);
+				atomic_dec(&sl->camchange_count);
 			}
 
 			// CAM state machine
-			switch (ca->slot_info[slot].slot_state) {
+			switch (sl->slot_state) {
 			case SLOT_STAT_NONE:
 			case SLOT_STAT_INVALID:
 				// no action needed
 				break;
 
 			case SLOT_STAT_UNINIT:
-				ca->slot_info[slot].slot_state = SLOT_STAT_WAITREADY;
+				sl->slot_state = SLOT_STAT_WAITREADY;
 				ca->pub->slot_reset(ca->pub, slot);
-				ca->slot_info[slot].timeout = jiffies + (INIT_TIMEOUT_SECS * HZ);
+				sl->timeout = jiffies + (INIT_TIMEOUT_SECS * HZ);
 				break;
 
 			case SLOT_STAT_WAITREADY:
-				if (time_after(jiffies, ca->slot_info[slot].timeout)) {
+				if (time_after(jiffies, sl->timeout)) {
 					pr_err("dvb_ca adaptor %d: PC card did not respond :(\n",
 					       ca->dvbdev->adapter->num);
-					ca->slot_info[slot].slot_state = SLOT_STAT_INVALID;
+					sl->slot_state = SLOT_STAT_INVALID;
 					dvb_ca_en50221_thread_update_delay(ca);
 					break;
 				}
@@ -1122,7 +1135,7 @@ static int dvb_ca_en50221_thread(void *data)
 					    (ca->pub->poll_slot_status)) {
 						status = ca->pub->poll_slot_status(ca->pub, slot, 0);
 						if (!(status & DVB_CA_EN50221_POLL_CAM_PRESENT)) {
-							ca->slot_info[slot].slot_state = SLOT_STAT_NONE;
+							sl->slot_state = SLOT_STAT_NONE;
 							dvb_ca_en50221_thread_update_delay(ca);
 							break;
 						}
@@ -1130,14 +1143,14 @@ static int dvb_ca_en50221_thread(void *data)
 
 					pr_err("dvb_ca adapter %d: Invalid PC card inserted :(\n",
 					       ca->dvbdev->adapter->num);
-					ca->slot_info[slot].slot_state = SLOT_STAT_INVALID;
+					sl->slot_state = SLOT_STAT_INVALID;
 					dvb_ca_en50221_thread_update_delay(ca);
 					break;
 				}
 				if (dvb_ca_en50221_set_configoption(ca, slot) != 0) {
 					pr_err("dvb_ca adapter %d: Unable to initialise CAM :(\n",
 					       ca->dvbdev->adapter->num);
-					ca->slot_info[slot].slot_state = SLOT_STAT_INVALID;
+					sl->slot_state = SLOT_STAT_INVALID;
 					dvb_ca_en50221_thread_update_delay(ca);
 					break;
 				}
@@ -1145,29 +1158,29 @@ static int dvb_ca_en50221_thread(void *data)
 							       CTRLIF_COMMAND, CMDREG_RS) != 0) {
 					pr_err("dvb_ca adapter %d: Unable to reset CAM IF\n",
 					       ca->dvbdev->adapter->num);
-					ca->slot_info[slot].slot_state = SLOT_STAT_INVALID;
+					sl->slot_state = SLOT_STAT_INVALID;
 					dvb_ca_en50221_thread_update_delay(ca);
 					break;
 				}
 				dprintk("DVB CAM validated successfully\n");
 
-				ca->slot_info[slot].timeout = jiffies + (INIT_TIMEOUT_SECS * HZ);
-				ca->slot_info[slot].slot_state = SLOT_STAT_WAITFR;
+				sl->timeout = jiffies + (INIT_TIMEOUT_SECS * HZ);
+				sl->slot_state = SLOT_STAT_WAITFR;
 				ca->wakeup = 1;
 				break;
 
 			case SLOT_STAT_WAITFR:
-				if (time_after(jiffies, ca->slot_info[slot].timeout)) {
+				if (time_after(jiffies, sl->timeout)) {
 					pr_err("dvb_ca adapter %d: DVB CAM did not respond :(\n",
 					       ca->dvbdev->adapter->num);
-					ca->slot_info[slot].slot_state = SLOT_STAT_INVALID;
+					sl->slot_state = SLOT_STAT_INVALID;
 					dvb_ca_en50221_thread_update_delay(ca);
 					break;
 				}
 
 				flags = ca->pub->read_cam_control(ca->pub, slot, CTRLIF_STATUS);
 				if (flags & STATREG_FR) {
-					ca->slot_info[slot].slot_state = SLOT_STAT_LINKINIT;
+					sl->slot_state = SLOT_STAT_LINKINIT;
 					ca->wakeup = 1;
 				}
 				break;
@@ -1179,7 +1192,7 @@ static int dvb_ca_en50221_thread(void *data)
 					    (ca->pub->poll_slot_status)) {
 						status = ca->pub->poll_slot_status(ca->pub, slot, 0);
 						if (!(status & DVB_CA_EN50221_POLL_CAM_PRESENT)) {
-							ca->slot_info[slot].slot_state = SLOT_STAT_NONE;
+							sl->slot_state = SLOT_STAT_NONE;
 							dvb_ca_en50221_thread_update_delay(ca);
 							break;
 						}
@@ -1187,25 +1200,25 @@ static int dvb_ca_en50221_thread(void *data)
 
 					pr_err("dvb_ca adapter %d: DVB CAM link initialisation failed :(\n",
 					       ca->dvbdev->adapter->num);
-					ca->slot_info[slot].slot_state = SLOT_STAT_UNINIT;
+					sl->slot_state = SLOT_STAT_UNINIT;
 					dvb_ca_en50221_thread_update_delay(ca);
 					break;
 				}
 
-				if (ca->slot_info[slot].rx_buffer.data == NULL) {
+				if (sl->rx_buffer.data == NULL) {
 					rxbuf = vmalloc(RX_BUFFER_SIZE);
 					if (rxbuf == NULL) {
 						pr_err("dvb_ca adapter %d: Unable to allocate CAM rx buffer :(\n",
 						       ca->dvbdev->adapter->num);
-						ca->slot_info[slot].slot_state = SLOT_STAT_INVALID;
+						sl->slot_state = SLOT_STAT_INVALID;
 						dvb_ca_en50221_thread_update_delay(ca);
 						break;
 					}
-					dvb_ringbuffer_init(&ca->slot_info[slot].rx_buffer, rxbuf, RX_BUFFER_SIZE);
+					dvb_ringbuffer_init(&sl->rx_buffer, rxbuf, RX_BUFFER_SIZE);
 				}
 
 				ca->pub->slot_ts_enable(ca->pub, slot);
-				ca->slot_info[slot].slot_state = SLOT_STAT_RUNNING;
+				sl->slot_state = SLOT_STAT_RUNNING;
 				dvb_ca_en50221_thread_update_delay(ca);
 				pr_err("dvb_ca adapter %d: DVB CAM detected and initialised successfully\n",
 				       ca->dvbdev->adapter->num);
@@ -1238,7 +1251,7 @@ static int dvb_ca_en50221_thread(void *data)
 				break;
 			}
 
-			mutex_unlock(&ca->slot_info[slot].slot_lock);
+			mutex_unlock(&sl->slot_lock);
 		}
 	}
 
@@ -1277,15 +1290,16 @@ static int dvb_ca_en50221_io_do_ioctl(struct file *file,
 	switch (cmd) {
 	case CA_RESET:
 		for (slot = 0; slot < ca->slot_count; slot++) {
-			mutex_lock(&ca->slot_info[slot].slot_lock);
-			if (ca->slot_info[slot].slot_state != SLOT_STAT_NONE) {
+			struct dvb_ca_slot *sl = &ca->slot_info[slot];
+			mutex_lock(&sl->slot_lock);
+			if (sl->slot_state != SLOT_STAT_NONE) {
 				dvb_ca_en50221_slot_shutdown(ca, slot);
 				if (ca->flags & DVB_CA_EN50221_FLAG_IRQ_CAMCHANGE)
 					dvb_ca_en50221_camchange_irq(ca->pub,
 								     slot,
 								     DVB_CA_EN50221_CAMCHANGE_INSERTED);
 			}
-			mutex_unlock(&ca->slot_info[slot].slot_lock);
+			mutex_unlock(&sl->slot_lock);
 		}
 		ca->next_read_slot = 0;
 		dvb_ca_en50221_thread_wakeup(ca);
@@ -1303,19 +1317,22 @@ static int dvb_ca_en50221_io_do_ioctl(struct file *file,
 
 	case CA_GET_SLOT_INFO: {
 		struct ca_slot_info *info = parg;
+		struct dvb_ca_slot *sl;
 
-		if ((info->num > ca->slot_count) || (info->num < 0)) {
+		slot = info->num;
+		if ((slot > ca->slot_count) || (slot < 0)) {
 			err = -EINVAL;
 			goto out_unlock;
 		}
 
 		info->type = CA_CI_LINK;
 		info->flags = 0;
-		if ((ca->slot_info[info->num].slot_state != SLOT_STAT_NONE)
-			&& (ca->slot_info[info->num].slot_state != SLOT_STAT_INVALID)) {
+		sl = &ca->slot_info[slot];
+		if ((sl->slot_state != SLOT_STAT_NONE)
+			&& (sl->slot_state != SLOT_STAT_INVALID)) {
 			info->flags = CA_CI_MODULE_PRESENT;
 		}
-		if (ca->slot_info[info->num].slot_state == SLOT_STAT_RUNNING) {
+		if (sl->slot_state == SLOT_STAT_RUNNING) {
 			info->flags |= CA_CI_MODULE_READY;
 		}
 		break;
@@ -1364,6 +1381,7 @@ static ssize_t dvb_ca_en50221_io_write(struct file *file,
 {
 	struct dvb_device *dvbdev = file->private_data;
 	struct dvb_ca_private *ca = dvbdev->priv;
+	struct dvb_ca_slot *sl;
 	u8 slot, connection_id;
 	int status;
 	u8 fragbuf[HOST_LINK_BUF_SIZE];
@@ -1385,14 +1403,15 @@ static ssize_t dvb_ca_en50221_io_write(struct file *file,
 		return -EFAULT;
 	buf += 2;
 	count -= 2;
+	sl = &ca->slot_info[slot];
 
 	/* check if the slot is actually running */
-	if (ca->slot_info[slot].slot_state != SLOT_STAT_RUNNING)
+	if (sl->slot_state != SLOT_STAT_RUNNING)
 		return -EINVAL;
 
 	/* fragment the packets & store in the buffer */
 	while (fragpos < count) {
-		fraglen = ca->slot_info[slot].link_buf_size - 2;
+		fraglen = sl->link_buf_size - 2;
 		if (fraglen < 0)
 			break;
 		if (fraglen > HOST_LINK_BUF_SIZE - 2)
@@ -1412,14 +1431,14 @@ static ssize_t dvb_ca_en50221_io_write(struct file *file,
 		written = 0;
 		while (!time_after(jiffies, timeout)) {
 			/* check the CAM hasn't been removed/reset in the meantime */
-			if (ca->slot_info[slot].slot_state != SLOT_STAT_RUNNING) {
+			if (sl->slot_state != SLOT_STAT_RUNNING) {
 				status = -EIO;
 				goto exit;
 			}
 
-			mutex_lock(&ca->slot_info[slot].slot_lock);
+			mutex_lock(&sl->slot_lock);
 			status = dvb_ca_en50221_write_data(ca, slot, fragbuf, fraglen + 2);
-			mutex_unlock(&ca->slot_info[slot].slot_lock);
+			mutex_unlock(&sl->slot_lock);
 			if (status == (fraglen + 2)) {
 				written = 1;
 				break;
@@ -1459,16 +1478,18 @@ static int dvb_ca_en50221_io_read_condition(struct dvb_ca_private *ca,
 
 	slot = ca->next_read_slot;
 	while ((slot_count < ca->slot_count) && (!found)) {
-		if (ca->slot_info[slot].slot_state != SLOT_STAT_RUNNING)
+		struct dvb_ca_slot *sl = &ca->slot_info[slot];
+
+		if (sl->slot_state != SLOT_STAT_RUNNING)
 			goto nextslot;
 
-		if (ca->slot_info[slot].rx_buffer.data == NULL) {
+		if (sl->rx_buffer.data == NULL) {
 			return 0;
 		}
 
-		idx = dvb_ringbuffer_pkt_next(&ca->slot_info[slot].rx_buffer, -1, &fraglen);
+		idx = dvb_ringbuffer_pkt_next(&sl->rx_buffer, -1, &fraglen);
 		while (idx != -1) {
-			dvb_ringbuffer_pkt_read(&ca->slot_info[slot].rx_buffer, idx, 0, hdr, 2);
+			dvb_ringbuffer_pkt_read(&sl->rx_buffer, idx, 0, hdr, 2);
 			if (connection_id == -1)
 				connection_id = hdr[0];
 			if ((hdr[0] == connection_id) && ((hdr[1] & 0x80) == 0)) {
@@ -1477,7 +1498,7 @@ static int dvb_ca_en50221_io_read_condition(struct dvb_ca_private *ca,
 				break;
 			}
 
-			idx = dvb_ringbuffer_pkt_next(&ca->slot_info[slot].rx_buffer, idx, &fraglen);
+			idx = dvb_ringbuffer_pkt_next(&sl->rx_buffer, idx, &fraglen);
 		}
 
 nextslot:
@@ -1505,6 +1526,7 @@ static ssize_t dvb_ca_en50221_io_read(struct file *file, char __user * buf,
 {
 	struct dvb_device *dvbdev = file->private_data;
 	struct dvb_ca_private *ca = dvbdev->priv;
+	struct dvb_ca_slot *sl;
 	int status;
 	int result = 0;
 	u8 hdr[2];
@@ -1540,7 +1562,8 @@ static ssize_t dvb_ca_en50221_io_read(struct file *file, char __user * buf,
 		return status;
 	}
 
-	idx = dvb_ringbuffer_pkt_next(&ca->slot_info[slot].rx_buffer, -1, &fraglen);
+	sl = &ca->slot_info[slot];
+	idx = dvb_ringbuffer_pkt_next(&sl->rx_buffer, -1, &fraglen);
 	pktlen = 2;
 	do {
 		if (idx == -1) {
@@ -1550,7 +1573,7 @@ static ssize_t dvb_ca_en50221_io_read(struct file *file, char __user * buf,
 			goto exit;
 		}
 
-		dvb_ringbuffer_pkt_read(&ca->slot_info[slot].rx_buffer, idx, 0, hdr, 2);
+		dvb_ringbuffer_pkt_read(&sl->rx_buffer, idx, 0, hdr, 2);
 		if (connection_id == -1)
 			connection_id = hdr[0];
 		if (hdr[0] == connection_id) {
@@ -1561,7 +1584,7 @@ static ssize_t dvb_ca_en50221_io_read(struct file *file, char __user * buf,
 					fraglen -= 2;
 				}
 
-				if ((status = dvb_ringbuffer_pkt_read_user(&ca->slot_info[slot].rx_buffer, idx, 2,
+				if ((status = dvb_ringbuffer_pkt_read_user(&sl->rx_buffer, idx, 2,
 								      buf + pktlen, fraglen)) < 0) {
 					goto exit;
 				}
@@ -1573,9 +1596,9 @@ static ssize_t dvb_ca_en50221_io_read(struct file *file, char __user * buf,
 			dispose = 1;
 		}
 
-		idx2 = dvb_ringbuffer_pkt_next(&ca->slot_info[slot].rx_buffer, idx, &fraglen);
+		idx2 = dvb_ringbuffer_pkt_next(&sl->rx_buffer, idx, &fraglen);
 		if (dispose)
-			dvb_ringbuffer_pkt_dispose(&ca->slot_info[slot].rx_buffer, idx);
+			dvb_ringbuffer_pkt_dispose(&sl->rx_buffer, idx);
 		idx = idx2;
 		dispose = 0;
 	} while (!last_fragment);
@@ -1621,12 +1644,13 @@ static int dvb_ca_en50221_io_open(struct inode *inode, struct file *file)
 	}
 
 	for (i = 0; i < ca->slot_count; i++) {
+		struct dvb_ca_slot *sl = &ca->slot_info[i];
 
-		if (ca->slot_info[i].slot_state == SLOT_STAT_RUNNING) {
-			if (ca->slot_info[i].rx_buffer.data != NULL) {
+		if (sl->slot_state == SLOT_STAT_RUNNING) {
+			if (sl->rx_buffer.data != NULL) {
 				/* it is safe to call this here without locks because
 				 * ca->open == 0. Data is not read in this case */
-				dvb_ringbuffer_flush(&ca->slot_info[i].rx_buffer);
+				dvb_ringbuffer_flush(&sl->rx_buffer);
 			}
 		}
 	}
@@ -1783,11 +1807,12 @@ int dvb_ca_en50221_init(struct dvb_adapter *dvb_adapter,
 
 	/* now initialise each slot */
 	for (i = 0; i < slot_count; i++) {
-		memset(&ca->slot_info[i], 0, sizeof(struct dvb_ca_slot));
-		ca->slot_info[i].slot_state = SLOT_STAT_NONE;
-		atomic_set(&ca->slot_info[i].camchange_count, 0);
-		ca->slot_info[i].camchange_type = DVB_CA_EN50221_CAMCHANGE_REMOVED;
-		mutex_init(&ca->slot_info[i].slot_lock);
+		struct dvb_ca_slot *sl = &ca->slot_info[i];
+		memset(sl, 0, sizeof(struct dvb_ca_slot));
+		sl->slot_state = SLOT_STAT_NONE;
+		atomic_set(&sl->camchange_count, 0);
+		sl->camchange_type = DVB_CA_EN50221_CAMCHANGE_REMOVED;
+		mutex_init(&sl->slot_lock);
 	}
 
 	mutex_init(&ca->ioctl_mutex);
-- 
2.7.4
