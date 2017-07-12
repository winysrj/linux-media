Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.anw.at ([195.234.101.228]:54591 "EHLO mail.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750805AbdGLXBm (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Jul 2017 19:01:42 -0400
From: "Jasmin J." <jasmin@anw.at>
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, max.kellermann@gmail.com,
        rjkm@metzlerbros.de, d.scheller@gmx.net, jasmin@anw.at
Subject: [PATCH V2 6/9] [media] dvb-core/dvb_ca_en50221.c: Used a helper variable
Date: Thu, 13 Jul 2017 01:00:55 +0200
Message-Id: <1499900458-2339-7-git-send-email-jasmin@anw.at>
In-Reply-To: <1499900458-2339-1-git-send-email-jasmin@anw.at>
References: <1499900458-2339-1-git-send-email-jasmin@anw.at>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jasmin Jessich <jasmin@anw.at>

Used a helper variable "struct dvb_ca_slot *sl" instead of
"ca->slot_info[slot]". This reduces the line length and simplifies
code reading.

Signed-off-by: Jasmin Jessich <jasmin@anw.at>
---
 drivers/media/dvb-core/dvb_ca_en50221.c | 187 ++++++++++++++++++--------------
 1 file changed, 106 insertions(+), 81 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_ca_en50221.c b/drivers/media/dvb-core/dvb_ca_en50221.c
index 02b8785..eb7f692 100644
--- a/drivers/media/dvb-core/dvb_ca_en50221.c
+++ b/drivers/media/dvb-core/dvb_ca_en50221.c
@@ -234,13 +234,14 @@ static char *findstr(char *haystack, int hlen, char *needle, int nlen)
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
@@ -249,22 +250,23 @@ static int dvb_ca_en50221_check_camstatus(struct dvb_ca_private *ca, int slot)
 	cam_present_now = (slot_status & DVB_CA_EN50221_POLL_CAM_PRESENT) ? 1 : 0;
 	cam_changed = (slot_status & DVB_CA_EN50221_POLL_CAM_CHANGED) ? 1 : 0;
 	if (!cam_changed) {
-		int cam_present_old = (ca->slot_info[slot].slot_state != DVB_CA_SLOTSTATE_NONE);
+		int cam_present_old = (sl->slot_state != DVB_CA_SLOTSTATE_NONE);
+
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
-		if ((ca->slot_info[slot].slot_state == DVB_CA_SLOTSTATE_WAITREADY) &&
+		if ((sl->slot_state == DVB_CA_SLOTSTATE_WAITREADY) &&
 		    (slot_status & DVB_CA_EN50221_POLL_CAM_READY)) {
 			// move to validate state if reset is completed
-			ca->slot_info[slot].slot_state = DVB_CA_SLOTSTATE_VALIDATE;
+			sl->slot_state = DVB_CA_SLOTSTATE_VALIDATE;
 		}
 	}
 
@@ -333,6 +335,7 @@ static int dvb_ca_en50221_wait_if_status(struct dvb_ca_private *ca, int slot,
  */
 static int dvb_ca_en50221_link_init(struct dvb_ca_private *ca, int slot)
 {
+	struct dvb_ca_slot *sl = &ca->slot_info[slot];
 	int ret;
 	int buf_size;
 	u8 buf[2];
@@ -340,12 +343,12 @@ static int dvb_ca_en50221_link_init(struct dvb_ca_private *ca, int slot)
 	dprintk("%s\n", __func__);
 
 	/* we'll be determining these during this function */
-	ca->slot_info[slot].da_irq_supported = 0;
+	sl->da_irq_supported = 0;
 
 	/* set the host link buffer size temporarily. it will be overwritten with the
 	 * real negotiated size later.
 	 */
-	ca->slot_info[slot].link_buf_size = 2;
+	sl->link_buf_size = 2;
 
 	/* read the buffer size from the CAM */
 	ret = ca->pub->write_cam_control(ca->pub, slot, CTRLIF_COMMAND,
@@ -366,7 +369,7 @@ static int dvb_ca_en50221_link_init(struct dvb_ca_private *ca, int slot)
 	buf_size = (buf[0] << 8) | buf[1];
 	if (buf_size > HOST_LINK_BUF_SIZE)
 		buf_size = HOST_LINK_BUF_SIZE;
-	ca->slot_info[slot].link_buf_size = buf_size;
+	sl->link_buf_size = buf_size;
 	buf[0] = buf_size >> 8;
 	buf[1] = buf_size & 0xff;
 	dprintk("Chosen link buffer size of %i\n", buf_size);
@@ -457,6 +460,7 @@ static int dvb_ca_en50221_read_tuple(struct dvb_ca_private *ca, int slot,
  */
 static int dvb_ca_en50221_parse_attributes(struct dvb_ca_private *ca, int slot)
 {
+	struct dvb_ca_slot *sl;
 	int address = 0;
 	int tupleLength;
 	int tupleType;
@@ -529,10 +533,10 @@ static int dvb_ca_en50221_parse_attributes(struct dvb_ca_private *ca, int slot)
 	rasz = tuple[0] & 3;
 	if (tupleLength < (3 + rasz + 14))
 		return -EINVAL;
-	ca->slot_info[slot].config_base = 0;
-	for (i = 0; i < rasz + 1; i++) {
-		ca->slot_info[slot].config_base |= (tuple[2 + i] << (8 * i));
-	}
+	sl = &ca->slot_info[slot];
+	sl->config_base = 0;
+	for (i = 0; i < rasz + 1; i++)
+		sl->config_base |= (tuple[2 + i] << (8 * i));
 
 	/* check it contains the correct DVB string */
 	dvb_str = findstr((char *)tuple, tupleLength, "DVB_CI_V", 8);
@@ -566,7 +570,7 @@ static int dvb_ca_en50221_parse_attributes(struct dvb_ca_private *ca, int slot)
 				break;
 
 			/* get the config option */
-			ca->slot_info[slot].config_option = tuple[0] & 0x3f;
+			sl->config_option = tuple[0] & 0x3f;
 
 			/* OK, check it contains the correct strings */
 			if ((findstr((char *)tuple, tupleLength, "DVB_HOST", 8) == NULL) ||
@@ -594,8 +598,7 @@ static int dvb_ca_en50221_parse_attributes(struct dvb_ca_private *ca, int slot)
 		return -EINVAL;
 
 	dprintk("Valid DVB CAM detected MANID:%x DEVID:%x CONFIGBASE:0x%x CONFIGOPTION:0x%x\n",
-		manfid, devid, ca->slot_info[slot].config_base,
-		ca->slot_info[slot].config_option);
+		manfid, devid, sl->config_base, sl->config_option);
 
 	// success!
 	return 0;
@@ -610,19 +613,20 @@ static int dvb_ca_en50221_parse_attributes(struct dvb_ca_private *ca, int slot)
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
@@ -647,6 +651,7 @@ static int dvb_ca_en50221_set_configoption(struct dvb_ca_private *ca, int slot)
 static int dvb_ca_en50221_read_data(struct dvb_ca_private *ca, int slot,
 				    u8 *ebuf, int ecount)
 {
+	struct dvb_ca_slot *sl = &ca->slot_info[slot];
 	int bytes_read;
 	int status;
 	u8 buf[HOST_LINK_BUF_SIZE];
@@ -658,13 +663,13 @@ static int dvb_ca_en50221_read_data(struct dvb_ca_private *ca, int slot,
 	if (ebuf == NULL) {
 		int buf_free;
 
-		if (ca->slot_info[slot].rx_buffer.data == NULL) {
+		if (sl->rx_buffer.data == NULL) {
 			status = -EIO;
 			goto exit;
 		}
-		buf_free = dvb_ringbuffer_free(&ca->slot_info[slot].rx_buffer);
+		buf_free = dvb_ringbuffer_free(&sl->rx_buffer);
 
-		if (buf_free < (ca->slot_info[slot].link_buf_size +
+		if (buf_free < (sl->link_buf_size +
 				DVB_RINGBUFFER_PKTHDRSIZE)) {
 			status = -EAGAIN;
 			goto exit;
@@ -672,7 +677,7 @@ static int dvb_ca_en50221_read_data(struct dvb_ca_private *ca, int slot,
 	}
 
 	if (ca->pub->read_data &&
-	    (ca->slot_info[slot].slot_state != DVB_CA_SLOTSTATE_LINKINIT)) {
+	    (sl->slot_state != DVB_CA_SLOTSTATE_LINKINIT)) {
 		if (ebuf == NULL)
 			status = ca->pub->read_data(ca->pub, slot, buf,
 						    sizeof(buf));
@@ -710,20 +715,18 @@ static int dvb_ca_en50221_read_data(struct dvb_ca_private *ca, int slot,
 
 		/* check it will fit */
 		if (ebuf == NULL) {
-			if (bytes_read > ca->slot_info[slot].link_buf_size) {
+			if (bytes_read > sl->link_buf_size) {
 				pr_err("dvb_ca adapter %d: CAM tried to send a buffer larger than the link buffer size (%i > %i)!\n",
 				       ca->dvbdev->adapter->num, bytes_read,
-				       ca->slot_info[slot].link_buf_size);
-				ca->slot_info[slot].slot_state =
-						     DVB_CA_SLOTSTATE_LINKINIT;
+				       sl->link_buf_size);
+				sl->slot_state = DVB_CA_SLOTSTATE_LINKINIT;
 				status = -EIO;
 				goto exit;
 			}
 			if (bytes_read < 2) {
 				pr_err("dvb_ca adapter %d: CAM sent a buffer that was less than 2 bytes!\n",
 				       ca->dvbdev->adapter->num);
-				ca->slot_info[slot].slot_state =
-						     DVB_CA_SLOTSTATE_LINKINIT;
+				sl->slot_state = DVB_CA_SLOTSTATE_LINKINIT;
 				status = -EIO;
 				goto exit;
 			}
@@ -754,8 +757,7 @@ static int dvb_ca_en50221_read_data(struct dvb_ca_private *ca, int slot,
 		if (status < 0)
 			goto exit;
 		if (status & STATUSREG_RE) {
-			ca->slot_info[slot].slot_state =
-						     DVB_CA_SLOTSTATE_LINKINIT;
+			sl->slot_state = DVB_CA_SLOTSTATE_LINKINIT;
 			status = -EIO;
 			goto exit;
 		}
@@ -763,11 +765,11 @@ static int dvb_ca_en50221_read_data(struct dvb_ca_private *ca, int slot,
 
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
@@ -801,6 +803,7 @@ static int dvb_ca_en50221_read_data(struct dvb_ca_private *ca, int slot,
 static int dvb_ca_en50221_write_data(struct dvb_ca_private *ca, int slot,
 				     u8 *buf, int bytes_write)
 {
+	struct dvb_ca_slot *sl = &ca->slot_info[slot];
 	int status;
 	int i;
 
@@ -808,11 +811,11 @@ static int dvb_ca_en50221_write_data(struct dvb_ca_private *ca, int slot,
 
 
 	/* sanity check */
-	if (bytes_write > ca->slot_info[slot].link_buf_size)
+	if (bytes_write > sl->link_buf_size)
 		return -EINVAL;
 
 	if (ca->pub->write_data &&
-	    (ca->slot_info[slot].slot_state != DVB_CA_SLOTSTATE_LINKINIT))
+	    (sl->slot_state != DVB_CA_SLOTSTATE_LINKINIT))
 		return ca->pub->write_data(ca->pub, slot, buf, bytes_write);
 
 	/* it is possible we are dealing with a single buffer implementation,
@@ -893,7 +896,7 @@ static int dvb_ca_en50221_write_data(struct dvb_ca_private *ca, int slot,
 	if (status < 0)
 		goto exit;
 	if (status & STATUSREG_WE) {
-		ca->slot_info[slot].slot_state = DVB_CA_SLOTSTATE_LINKINIT;
+		sl->slot_state = DVB_CA_SLOTSTATE_LINKINIT;
 		status = -EIO;
 		goto exit;
 	}
@@ -950,6 +953,7 @@ static int dvb_ca_en50221_slot_shutdown(struct dvb_ca_private *ca, int slot)
 void dvb_ca_en50221_camchange_irq(struct dvb_ca_en50221 *pubca, int slot, int change_type)
 {
 	struct dvb_ca_private *ca = pubca->private;
+	struct dvb_ca_slot *sl = &ca->slot_info[slot];
 
 	dprintk("CAMCHANGE IRQ slot:%i change_type:%i\n", slot, change_type);
 
@@ -962,8 +966,8 @@ void dvb_ca_en50221_camchange_irq(struct dvb_ca_en50221 *pubca, int slot, int ch
 		return;
 	}
 
-	ca->slot_info[slot].camchange_type = change_type;
-	atomic_inc(&ca->slot_info[slot].camchange_count);
+	sl->camchange_type = change_type;
+	atomic_inc(&sl->camchange_count);
 	dvb_ca_en50221_thread_wakeup(ca);
 }
 EXPORT_SYMBOL(dvb_ca_en50221_camchange_irq);
@@ -978,11 +982,12 @@ EXPORT_SYMBOL(dvb_ca_en50221_camchange_irq);
 void dvb_ca_en50221_camready_irq(struct dvb_ca_en50221 *pubca, int slot)
 {
 	struct dvb_ca_private *ca = pubca->private;
+	struct dvb_ca_slot *sl = &ca->slot_info[slot];
 
 	dprintk("CAMREADY IRQ slot:%i\n", slot);
 
-	if (ca->slot_info[slot].slot_state == DVB_CA_SLOTSTATE_WAITREADY) {
-		ca->slot_info[slot].slot_state = DVB_CA_SLOTSTATE_VALIDATE;
+	if (sl->slot_state == DVB_CA_SLOTSTATE_WAITREADY) {
+		sl->slot_state = DVB_CA_SLOTSTATE_VALIDATE;
 		dvb_ca_en50221_thread_wakeup(ca);
 	}
 }
@@ -998,16 +1003,17 @@ EXPORT_SYMBOL(dvb_ca_en50221_camready_irq);
 void dvb_ca_en50221_frda_irq(struct dvb_ca_en50221 *pubca, int slot)
 {
 	struct dvb_ca_private *ca = pubca->private;
+	struct dvb_ca_slot *sl = &ca->slot_info[slot];
 	int flags;
 
 	dprintk("FR/DA IRQ slot:%i\n", slot);
 
-	switch (ca->slot_info[slot].slot_state) {
+	switch (sl->slot_state) {
 	case DVB_CA_SLOTSTATE_LINKINIT:
 		flags = ca->pub->read_cam_control(pubca, slot, CTRLIF_STATUS);
 		if (flags & STATUSREG_DA) {
 			dprintk("CAM supports DA IRQ\n");
-			ca->slot_info[slot].da_irq_supported = 1;
+			sl->da_irq_supported = 1;
 		}
 		break;
 
@@ -1053,7 +1059,9 @@ static void dvb_ca_en50221_thread_update_delay(struct dvb_ca_private *ca)
 	 * call might take several hundred milliseconds until timeout!
 	 */
 	for (slot = 0; slot < ca->slot_count; slot++) {
-		switch (ca->slot_info[slot].slot_state) {
+		struct dvb_ca_slot *sl = &ca->slot_info[slot];
+
+		switch (sl->slot_state) {
 		default:
 		case DVB_CA_SLOTSTATE_NONE:
 			delay = HZ * 60;  /* 60s */
@@ -1079,7 +1087,7 @@ static void dvb_ca_en50221_thread_update_delay(struct dvb_ca_private *ca)
 			if (!(ca->flags & DVB_CA_EN50221_FLAG_IRQ_CAMCHANGE))
 				delay = HZ / 10;  /* 100ms */
 			if (ca->open) {
-				if ((!ca->slot_info[slot].da_irq_supported) ||
+				if ((!sl->da_irq_supported) ||
 				    (!(ca->flags & DVB_CA_EN50221_FLAG_IRQ_DA)))
 					delay = HZ / 10;  /* 100ms */
 			}
@@ -1363,15 +1371,17 @@ static int dvb_ca_en50221_io_do_ioctl(struct file *file,
 	switch (cmd) {
 	case CA_RESET:
 		for (slot = 0; slot < ca->slot_count; slot++) {
-			mutex_lock(&ca->slot_info[slot].slot_lock);
-			if (ca->slot_info[slot].slot_state != DVB_CA_SLOTSTATE_NONE) {
+			struct dvb_ca_slot *sl = &ca->slot_info[slot];
+
+			mutex_lock(&sl->slot_lock);
+			if (sl->slot_state != DVB_CA_SLOTSTATE_NONE) {
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
@@ -1389,21 +1399,23 @@ static int dvb_ca_en50221_io_do_ioctl(struct file *file,
 
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
-		if ((ca->slot_info[info->num].slot_state != DVB_CA_SLOTSTATE_NONE)
-			&& (ca->slot_info[info->num].slot_state != DVB_CA_SLOTSTATE_INVALID)) {
+		sl = &ca->slot_info[slot];
+		if ((sl->slot_state != DVB_CA_SLOTSTATE_NONE)
+			&& (sl->slot_state != DVB_CA_SLOTSTATE_INVALID)) {
 			info->flags = CA_CI_MODULE_PRESENT;
 		}
-		if (ca->slot_info[info->num].slot_state == DVB_CA_SLOTSTATE_RUNNING) {
+		if (sl->slot_state == DVB_CA_SLOTSTATE_RUNNING)
 			info->flags |= CA_CI_MODULE_READY;
-		}
 		break;
 	}
 
@@ -1451,6 +1463,7 @@ static ssize_t dvb_ca_en50221_io_write(struct file *file,
 {
 	struct dvb_device *dvbdev = file->private_data;
 	struct dvb_ca_private *ca = dvbdev->priv;
+	struct dvb_ca_slot *sl;
 	u8 slot, connection_id;
 	int status;
 	u8 fragbuf[HOST_LINK_BUF_SIZE];
@@ -1472,14 +1485,15 @@ static ssize_t dvb_ca_en50221_io_write(struct file *file,
 		return -EFAULT;
 	buf += 2;
 	count -= 2;
+	sl = &ca->slot_info[slot];
 
 	/* check if the slot is actually running */
-	if (ca->slot_info[slot].slot_state != DVB_CA_SLOTSTATE_RUNNING)
+	if (sl->slot_state != DVB_CA_SLOTSTATE_RUNNING)
 		return -EINVAL;
 
 	/* fragment the packets & store in the buffer */
 	while (fragpos < count) {
-		fraglen = ca->slot_info[slot].link_buf_size - 2;
+		fraglen = sl->link_buf_size - 2;
 		if (fraglen < 0)
 			break;
 		if (fraglen > HOST_LINK_BUF_SIZE - 2)
@@ -1499,14 +1513,14 @@ static ssize_t dvb_ca_en50221_io_write(struct file *file,
 		written = 0;
 		while (!time_after(jiffies, timeout)) {
 			/* check the CAM hasn't been removed/reset in the meantime */
-			if (ca->slot_info[slot].slot_state != DVB_CA_SLOTSTATE_RUNNING) {
+			if (sl->slot_state != DVB_CA_SLOTSTATE_RUNNING) {
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
@@ -1546,16 +1560,17 @@ static int dvb_ca_en50221_io_read_condition(struct dvb_ca_private *ca,
 
 	slot = ca->next_read_slot;
 	while ((slot_count < ca->slot_count) && (!found)) {
-		if (ca->slot_info[slot].slot_state != DVB_CA_SLOTSTATE_RUNNING)
+		struct dvb_ca_slot *sl = &ca->slot_info[slot];
+
+		if (sl->slot_state != DVB_CA_SLOTSTATE_RUNNING)
 			goto nextslot;
 
-		if (ca->slot_info[slot].rx_buffer.data == NULL) {
+		if (sl->rx_buffer.data == NULL)
 			return 0;
-		}
 
-		idx = dvb_ringbuffer_pkt_next(&ca->slot_info[slot].rx_buffer, -1, &fraglen);
+		idx = dvb_ringbuffer_pkt_next(&sl->rx_buffer, -1, &fraglen);
 		while (idx != -1) {
-			dvb_ringbuffer_pkt_read(&ca->slot_info[slot].rx_buffer, idx, 0, hdr, 2);
+			dvb_ringbuffer_pkt_read(&sl->rx_buffer, idx, 0, hdr, 2);
 			if (connection_id == -1)
 				connection_id = hdr[0];
 			if ((hdr[0] == connection_id) && ((hdr[1] & 0x80) == 0)) {
@@ -1564,7 +1579,8 @@ static int dvb_ca_en50221_io_read_condition(struct dvb_ca_private *ca,
 				break;
 			}
 
-			idx = dvb_ringbuffer_pkt_next(&ca->slot_info[slot].rx_buffer, idx, &fraglen);
+			idx = dvb_ringbuffer_pkt_next(&sl->rx_buffer, idx,
+						      &fraglen);
 		}
 
 nextslot:
@@ -1592,6 +1608,7 @@ static ssize_t dvb_ca_en50221_io_read(struct file *file, char __user *buf,
 {
 	struct dvb_device *dvbdev = file->private_data;
 	struct dvb_ca_private *ca = dvbdev->priv;
+	struct dvb_ca_slot *sl;
 	int status;
 	int result = 0;
 	u8 hdr[2];
@@ -1628,7 +1645,8 @@ static ssize_t dvb_ca_en50221_io_read(struct file *file, char __user *buf,
 		return status;
 	}
 
-	idx = dvb_ringbuffer_pkt_next(&ca->slot_info[slot].rx_buffer, -1, &fraglen);
+	sl = &ca->slot_info[slot];
+	idx = dvb_ringbuffer_pkt_next(&sl->rx_buffer, -1, &fraglen);
 	pktlen = 2;
 	do {
 		if (idx == -1) {
@@ -1638,7 +1656,7 @@ static ssize_t dvb_ca_en50221_io_read(struct file *file, char __user *buf,
 			goto exit;
 		}
 
-		dvb_ringbuffer_pkt_read(&ca->slot_info[slot].rx_buffer, idx, 0, hdr, 2);
+		dvb_ringbuffer_pkt_read(&sl->rx_buffer, idx, 0, hdr, 2);
 		if (connection_id == -1)
 			connection_id = hdr[0];
 		if (hdr[0] == connection_id) {
@@ -1649,10 +1667,14 @@ static ssize_t dvb_ca_en50221_io_read(struct file *file, char __user *buf,
 					fraglen -= 2;
 				}
 
-				if ((status = dvb_ringbuffer_pkt_read_user(&ca->slot_info[slot].rx_buffer, idx, 2,
-								      buf + pktlen, fraglen)) < 0) {
+				status =
+				   dvb_ringbuffer_pkt_read_user(&sl->rx_buffer,
+								idx, 2,
+								buf + pktlen,
+								fraglen);
+				if (status < 0)
 					goto exit;
-				}
+
 				pktlen += fraglen;
 			}
 
@@ -1661,9 +1683,9 @@ static ssize_t dvb_ca_en50221_io_read(struct file *file, char __user *buf,
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
@@ -1709,14 +1731,15 @@ static int dvb_ca_en50221_io_open(struct inode *inode, struct file *file)
 	}
 
 	for (i = 0; i < ca->slot_count; i++) {
+		struct dvb_ca_slot *sl = &ca->slot_info[i];
 
-		if (ca->slot_info[i].slot_state == DVB_CA_SLOTSTATE_RUNNING) {
-			if (ca->slot_info[i].rx_buffer.data != NULL) {
+		if (sl->slot_state == DVB_CA_SLOTSTATE_RUNNING) {
+			if (sl->rx_buffer.data != NULL) {
 				/* it is safe to call this here without locks
 				 * because ca->open == 0. Data is not read in
 				 * this case
 				 */
-				dvb_ringbuffer_flush(&ca->slot_info[i].rx_buffer);
+				dvb_ringbuffer_flush(&sl->rx_buffer);
 			}
 		}
 	}
@@ -1876,11 +1899,13 @@ int dvb_ca_en50221_init(struct dvb_adapter *dvb_adapter,
 
 	/* now initialise each slot */
 	for (i = 0; i < slot_count; i++) {
-		memset(&ca->slot_info[i], 0, sizeof(struct dvb_ca_slot));
-		ca->slot_info[i].slot_state = DVB_CA_SLOTSTATE_NONE;
-		atomic_set(&ca->slot_info[i].camchange_count, 0);
-		ca->slot_info[i].camchange_type = DVB_CA_EN50221_CAMCHANGE_REMOVED;
-		mutex_init(&ca->slot_info[i].slot_lock);
+		struct dvb_ca_slot *sl = &ca->slot_info[i];
+
+		memset(sl, 0, sizeof(struct dvb_ca_slot));
+		sl->slot_state = DVB_CA_SLOTSTATE_NONE;
+		atomic_set(&sl->camchange_count, 0);
+		sl->camchange_type = DVB_CA_EN50221_CAMCHANGE_REMOVED;
+		mutex_init(&sl->slot_lock);
 	}
 
 	mutex_init(&ca->ioctl_mutex);
-- 
2.7.4
