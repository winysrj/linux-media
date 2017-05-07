Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.anw.at ([195.234.101.228]:35906 "EHLO mail.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756275AbdEGWEu (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 7 May 2017 18:04:50 -0400
From: "Jasmin J." <jasmin@anw.at>
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, max.kellermann@gmail.com, jasmin@anw.at
Subject: [PATCH 10/11] [media] dvb-core/dvb_ca_en50221.c: Make checkpatch happy 6
Date: Sun,  7 May 2017 23:23:33 +0200
Message-Id: <1494192214-20082-11-git-send-email-jasmin@anw.at>
In-Reply-To: <1494192214-20082-1-git-send-email-jasmin@anw.at>
References: <1494192214-20082-1-git-send-email-jasmin@anw.at>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jasmin Jessich <jasmin@anw.at>

Fixed most of
  WARNING: line over 80 characters
The remaining lines are printk strings, which should not be split.

The
  WARNING: memory barrier without comment
  WARNING: Prefer [subsystem eg: netdev]_dbg
will not be fixed.

checkpatch result:
  total: 0 errors, 7 warnings, 1987 lines checked

Signed-off-by: Jasmin Jessich <jasmin@anw.at>
---
 drivers/media/dvb-core/dvb_ca_en50221.c | 158 +++++++++++++++++++++-----------
 1 file changed, 105 insertions(+), 53 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_ca_en50221.c b/drivers/media/dvb-core/dvb_ca_en50221.c
index 724fb34..ec9d63e 100644
--- a/drivers/media/dvb-core/dvb_ca_en50221.c
+++ b/drivers/media/dvb-core/dvb_ca_en50221.c
@@ -157,7 +157,9 @@ struct dvb_ca_private {
 	/* Delay the main thread should use */
 	unsigned long delay;
 
-	/* Slot to start looking for data to read from in the next user-space read operation */
+	/* Slot to start looking for data to read from in the next user-space
+	 * read operation
+	 */
 	int next_read_slot;
 
 	/* mutex serializing ioctls */
@@ -227,7 +229,7 @@ static char *findstr(char *haystack, int hlen, char *needle, int nlen)
 
 
 
-/* ******************************************************************************** */
+/* ************************************************************************** */
 /* EN50221 physical interface functions */
 
 
@@ -249,7 +251,8 @@ static int dvb_ca_en50221_check_camstatus(struct dvb_ca_private *ca, int slot)
 	/* poll mode */
 	slot_status = ca->pub->poll_slot_status(ca->pub, slot, ca->open);
 
-	cam_present_now = (slot_status & DVB_CA_EN50221_POLL_CAM_PRESENT) ? 1 : 0;
+	cam_present_now = (slot_status & DVB_CA_EN50221_POLL_CAM_PRESENT) ?
+			  1 : 0;
 	cam_changed = (slot_status & DVB_CA_EN50221_POLL_CAM_CHANGED) ? 1 : 0;
 	if (!cam_changed) {
 		cam_present_old = (sl->slot_state != SLOT_STAT_NONE);
@@ -344,8 +347,9 @@ static int dvb_ca_en50221_link_init(struct dvb_ca_private *ca, int slot)
 	/* we'll be determining these during this function */
 	sl->da_irq_supported = 0;
 
-	/* set the host link buffer size temporarily. it will be overwritten with the
-	 * real negotiated size later. */
+	/* set the host link buffer size temporarily. it will be overwritten
+	 * with the real negotiated size later.
+	 */
 	sl->link_buf_size = 2;
 
 	/* read the buffer size from the CAM */
@@ -363,7 +367,9 @@ static int dvb_ca_en50221_link_init(struct dvb_ca_private *ca, int slot)
 	if (ret != 0)
 		return ret;
 
-	/* store it, and choose the minimum of our buffer and the CAM's buffer size */
+	/* store it, and choose the minimum of our buffer and the CAM's buffer
+	 * size
+	 */
 	buf_size = (buf[0] << 8) | buf[1];
 	if (buf_size > HOST_LINK_BUF_SIZE)
 		buf_size = HOST_LINK_BUF_SIZE;
@@ -432,7 +438,8 @@ static int dvb_ca_en50221_read_tuple(struct dvb_ca_private *ca, int slot,
 
 	/* read in the whole tuple */
 	for (i = 0; i < _tupleLength; i++) {
-		tuple[i] = ca->pub->read_attribute_mem(ca->pub, slot, _address + (i * 2));
+		tuple[i] = ca->pub->read_attribute_mem(ca->pub, slot,
+						       _address + (i * 2));
 		dprintk("  0x%02x: 0x%02x %c\n",
 			i, tuple[i] & 0xff,
 			((tuple[i] > 31) && (tuple[i] < 127)) ? tuple[i] : '.');
@@ -572,8 +579,10 @@ static int dvb_ca_en50221_parse_attributes(struct dvb_ca_private *ca, int slot)
 			sl->config_option = tuple[0] & 0x3f;
 
 			/* OK, check it contains the correct strings */
-			if ((findstr((char *)tuple, tupleLength, "DVB_HOST", 8) == NULL) ||
-			    (findstr((char *)tuple, tupleLength, "DVB_CI_MODULE", 13) == NULL))
+			if ((findstr((char *)tuple, tupleLength,
+				     "DVB_HOST", 8) == NULL) ||
+			    (findstr((char *)tuple, tupleLength,
+				     "DVB_CI_MODULE", 13) == NULL))
 				break;
 
 			got_cftableentry = 1;
@@ -586,7 +595,10 @@ static int dvb_ca_en50221_parse_attributes(struct dvb_ca_private *ca, int slot)
 			end_chain = 1;
 			break;
 
-		default:	/* Unknown tuple type - just skip this tuple and move to the next one */
+		/* Unknown tuple type - just skip this tuple and move to the
+		 * next one
+		 */
+		default:
 			dprintk("dvb_ca: Skipping unknown tuple type:0x%x length:0x%x\n",
 				tupleType, tupleLength);
 			break;
@@ -668,7 +680,8 @@ static int dvb_ca_en50221_read_data(struct dvb_ca_private *ca, int slot,
 		}
 		buf_free = dvb_ringbuffer_free(&sl->rx_buffer);
 
-		if (buf_free < (sl->link_buf_size + DVB_RINGBUFFER_PKTHDRSIZE)) {
+		if (buf_free < (sl->link_buf_size +
+				DVB_RINGBUFFER_PKTHDRSIZE)) {
 			status = -EAGAIN;
 			goto exit;
 		}
@@ -676,7 +689,8 @@ static int dvb_ca_en50221_read_data(struct dvb_ca_private *ca, int slot,
 
 	if (ca->pub->read_data && (sl->slot_state != SLOT_STAT_LINKINIT)) {
 		if (ebuf == NULL)
-			status = ca->pub->read_data(ca->pub, slot, buf, sizeof(buf));
+			status = ca->pub->read_data(ca->pub, slot, buf,
+						    sizeof(buf));
 		else
 			status = ca->pub->read_data(ca->pub, slot, buf, ecount);
 		if (status < 0)
@@ -713,7 +727,8 @@ static int dvb_ca_en50221_read_data(struct dvb_ca_private *ca, int slot,
 		if (ebuf == NULL) {
 			if (bytes_read > sl->link_buf_size) {
 				pr_err("dvb_ca adapter %d: CAM tried to send a buffer larger than the link buffer size (%i > %i)!\n",
-				       ca->dvbdev->adapter->num, bytes_read, sl->link_buf_size);
+				       ca->dvbdev->adapter->num, bytes_read,
+				       sl->link_buf_size);
 				sl->slot_state = SLOT_STAT_LINKINIT;
 				status = -EIO;
 				goto exit;
@@ -758,7 +773,9 @@ static int dvb_ca_en50221_read_data(struct dvb_ca_private *ca, int slot,
 		}
 	}
 
-	/* OK, add it to the receive buffer, or copy into external buffer if supplied */
+	/* OK, add it to the receive buffer, or copy into external buffer if
+	 * supplied
+	 */
 	if (ebuf == NULL) {
 		if (sl->rx_buffer.data == NULL) {
 			status = -EIO;
@@ -909,7 +926,7 @@ EXPORT_SYMBOL(dvb_ca_en50221_camchange_irq);
 
 
 
-/* ******************************************************************************** */
+/* ************************************************************************** */
 /* EN50221 higher level functions */
 
 
@@ -946,7 +963,8 @@ EXPORT_SYMBOL(dvb_ca_en50221_camready_irq);
  * @slot: Slot concerned.
  * @change_type: One of the DVB_CA_CAMCHANGE_* values.
  */
-void dvb_ca_en50221_camchange_irq(struct dvb_ca_en50221 *pubca, int slot, int change_type)
+void dvb_ca_en50221_camchange_irq(struct dvb_ca_en50221 *pubca, int slot,
+				  int change_type)
 {
 	struct dvb_ca_private *ca = pubca->private;
 	struct dvb_ca_slot *sl = &ca->slot_info[slot];
@@ -1021,7 +1039,7 @@ void dvb_ca_en50221_frda_irq(struct dvb_ca_en50221 *pubca, int slot)
 
 
 
-/* ******************************************************************************** */
+/* ************************************************************************** */
 /* EN50221 thread functions */
 
 /**
@@ -1152,16 +1170,22 @@ static void dvb_ca_en50221_thread_state_machine(struct dvb_ca_private *ca,
 			dvb_ca_en50221_thread_update_delay(ca);
 			break;
 		}
-		// no other action needed; will automatically change state when ready
+		/* no other action needed; will automatically change state when
+		 * ready
+		 */
 		break;
 
 	case SLOT_STAT_VALIDATE:
 		if (dvb_ca_en50221_parse_attributes(ca, slot) != 0) {
-			/* we need this extra check for annoying interfaces like the budget-av */
-			if ((!(ca->flags & DVB_CA_EN50221_FLAG_IRQ_CAMCHANGE)) &&
-			    (ca->pub->poll_slot_status)) {
-				status = ca->pub->poll_slot_status(ca->pub, slot, 0);
-				if (!(status & DVB_CA_EN50221_POLL_CAM_PRESENT)) {
+			/* we need this extra check for annoying interfaces like
+			 * the budget-av
+			 */
+			if ((!(ca->flags & DVB_CA_EN50221_FLAG_IRQ_CAMCHANGE))
+			    && (ca->pub->poll_slot_status)) {
+				status = ca->pub->poll_slot_status(ca->pub,
+								   slot, 0);
+				if (!(status &
+				      DVB_CA_EN50221_POLL_CAM_PRESENT)) {
 					sl->slot_state = SLOT_STAT_NONE;
 					dvb_ca_en50221_thread_update_delay(ca);
 					break;
@@ -1182,7 +1206,8 @@ static void dvb_ca_en50221_thread_state_machine(struct dvb_ca_private *ca,
 			break;
 		}
 		if (ca->pub->write_cam_control(ca->pub, slot,
-					       CTRLIF_COMMAND, CMDREG_RS) != 0) {
+					       CTRLIF_COMMAND,
+					       CMDREG_RS) != 0) {
 			pr_err("dvb_ca adapter %d: Unable to reset CAM IF\n",
 			       ca->dvbdev->adapter->num);
 			sl->slot_state = SLOT_STAT_INVALID;
@@ -1214,11 +1239,15 @@ static void dvb_ca_en50221_thread_state_machine(struct dvb_ca_private *ca,
 
 	case SLOT_STAT_LINKINIT:
 		if (dvb_ca_en50221_link_init(ca, slot) != 0) {
-			/* we need this extra check for annoying interfaces like the budget-av */
-			if ((!(ca->flags & DVB_CA_EN50221_FLAG_IRQ_CAMCHANGE)) &&
-			    (ca->pub->poll_slot_status)) {
-				status = ca->pub->poll_slot_status(ca->pub, slot, 0);
-				if (!(status & DVB_CA_EN50221_POLL_CAM_PRESENT)) {
+			/* we need this extra check for annoying interfaces like
+			 * the budget-av
+			 */
+			if ((!(ca->flags & DVB_CA_EN50221_FLAG_IRQ_CAMCHANGE))
+			    && (ca->pub->poll_slot_status)) {
+				status = ca->pub->poll_slot_status(ca->pub,
+								   slot, 0);
+				if (!(status &
+				      DVB_CA_EN50221_POLL_CAM_PRESENT)) {
 					sl->slot_state = SLOT_STAT_NONE;
 					dvb_ca_en50221_thread_update_delay(ca);
 					break;
@@ -1241,7 +1270,8 @@ static void dvb_ca_en50221_thread_state_machine(struct dvb_ca_private *ca,
 				dvb_ca_en50221_thread_update_delay(ca);
 				break;
 			}
-			dvb_ringbuffer_init(&sl->rx_buffer, rxbuf, RX_BUFFER_SIZE);
+			dvb_ringbuffer_init(&sl->rx_buffer, rxbuf,
+					    RX_BUFFER_SIZE);
 		}
 
 		ca->pub->slot_ts_enable(ca->pub, slot);
@@ -1257,20 +1287,27 @@ static void dvb_ca_en50221_thread_state_machine(struct dvb_ca_private *ca,
 
 		// poll slots for data
 		pktcount = 0;
-		while ((status = dvb_ca_en50221_read_data(ca, slot, NULL, 0)) > 0) {
+		while ((status = dvb_ca_en50221_read_data(ca, slot, NULL,
+							  0)) > 0) {
 			if (!ca->open)
 				break;
 
-			/* if a CAMCHANGE occurred at some point, do not do any more processing of this slot */
+			/* if a CAMCHANGE occurred at some point, do not do any
+			 * more processing of this slot
+			 */
 			if (dvb_ca_en50221_check_camstatus(ca, slot)) {
-				// we dont want to sleep on the next iteration so we can handle the cam change
+				/* we don't want to sleep on the next iteration
+				 * so we can handle the CAM change
+				 */
 				ca->wakeup = 1;
 				break;
 			}
 
 			/* check if we've hit our limit this time */
 			if (++pktcount >= MAX_RX_PACKETS_PER_ITERATION) {
-				// dont sleep; there is likely to be more data to read
+				/* don't sleep; there is likely to be more data
+				 * to read
+				 */
 				ca->wakeup = 1;
 				break;
 			}
@@ -1284,7 +1321,8 @@ static void dvb_ca_en50221_thread_state_machine(struct dvb_ca_private *ca,
 
 
 /**
- * Kernel thread which monitors CA slots for CAM changes, and performs data transfers.
+ * Kernel thread which monitors CA slots for CAM changes, and performs data
+ * transfers.
  */
 static int dvb_ca_en50221_thread(void *data)
 {
@@ -1317,7 +1355,7 @@ static int dvb_ca_en50221_thread(void *data)
 
 
 
-/* ******************************************************************************** */
+/* ************************************************************************** */
 /* EN50221 IO interface functions */
 
 /**
@@ -1352,10 +1390,11 @@ static int dvb_ca_en50221_io_do_ioctl(struct file *file,
 			mutex_lock(&sl->slot_lock);
 			if (sl->slot_state != SLOT_STAT_NONE) {
 				dvb_ca_en50221_slot_shutdown(ca, slot);
-				if (ca->flags & DVB_CA_EN50221_FLAG_IRQ_CAMCHANGE)
-					dvb_ca_en50221_camchange_irq(ca->pub,
-								     slot,
-								     DVB_CA_EN50221_CAMCHANGE_INSERTED);
+				if (ca->flags &
+				    DVB_CA_EN50221_FLAG_IRQ_CAMCHANGE)
+					dvb_ca_en50221_camchange_irq(
+					    ca->pub, slot,
+					    DVB_CA_EN50221_CAMCHANGE_INSERTED);
 			}
 			mutex_unlock(&sl->slot_lock);
 		}
@@ -1450,7 +1489,9 @@ static ssize_t dvb_ca_en50221_io_write(struct file *file,
 
 	dprintk("%s\n", __func__);
 
-	/* Incoming packet has a 2 byte header. hdr[0] = slot_id, hdr[1] = connection_id */
+	/* Incoming packet has a 2 byte header. hdr[0] = slot_id,
+	 * hdr[1] = connection_id
+	 */
 	if (count < 2)
 		return -EINVAL;
 
@@ -1488,14 +1529,17 @@ static ssize_t dvb_ca_en50221_io_write(struct file *file,
 		timeout = jiffies + HZ / 2;
 		written = 0;
 		while (!time_after(jiffies, timeout)) {
-			/* check the CAM hasn't been removed/reset in the meantime */
+			/* check the CAM hasn't been removed/reset in the
+			 * meantime
+			 */
 			if (sl->slot_state != SLOT_STAT_RUNNING) {
 				status = -EIO;
 				goto exit;
 			}
 
 			mutex_lock(&sl->slot_lock);
-			status = dvb_ca_en50221_write_data(ca, slot, fragbuf, fraglen + 2);
+			status = dvb_ca_en50221_write_data(ca, slot, fragbuf,
+							   fraglen + 2);
 			mutex_unlock(&sl->slot_lock);
 			if (status == (fraglen + 2)) {
 				written = 1;
@@ -1549,13 +1593,15 @@ static int dvb_ca_en50221_io_read_condition(struct dvb_ca_private *ca,
 			dvb_ringbuffer_pkt_read(&sl->rx_buffer, idx, 0, hdr, 2);
 			if (connection_id == -1)
 				connection_id = hdr[0];
-			if ((hdr[0] == connection_id) && ((hdr[1] & 0x80) == 0)) {
+			if ((hdr[0] == connection_id) &&
+			    ((hdr[1] & 0x80) == 0)) {
 				*_slot = slot;
 				found = 1;
 				break;
 			}
 
-			idx = dvb_ringbuffer_pkt_next(&sl->rx_buffer, idx, &fraglen);
+			idx = dvb_ringbuffer_pkt_next(&sl->rx_buffer, idx,
+						      &fraglen);
 		}
 
 nextslot:
@@ -1597,7 +1643,9 @@ static ssize_t dvb_ca_en50221_io_read(struct file *file, char __user *buf,
 
 	dprintk("%s\n", __func__);
 
-	/* Outgoing packet has a 2 byte header. hdr[0] = slot_id, hdr[1] = connection_id */
+	/* Outgoing packet has a 2 byte header. hdr[0] = slot_id,
+	 * hdr[1] = connection_id
+	 */
 	if (count < 2)
 		return -EINVAL;
 
@@ -1610,9 +1658,10 @@ static ssize_t dvb_ca_en50221_io_read(struct file *file, char __user *buf,
 			return -EWOULDBLOCK;
 
 		/* wait for some data */
-		status = wait_event_interruptible(ca->wait_queue,
-						  dvb_ca_en50221_io_read_condition
-						  (ca, &result, &slot));
+		status =
+		   wait_event_interruptible(ca->wait_queue,
+					    dvb_ca_en50221_io_read_condition
+					       (ca, &result, &slot));
 	}
 	if ((status < 0) || (result < 0)) {
 		if (result)
@@ -1708,8 +1757,10 @@ static int dvb_ca_en50221_io_open(struct inode *inode, struct file *file)
 
 		if (sl->slot_state == SLOT_STAT_RUNNING) {
 			if (sl->rx_buffer.data != NULL) {
-				/* it is safe to call this here without locks because
-				 * ca->open == 0. Data is not read in this case */
+				/* it is safe to call this here without locks
+				 * because ca->open == 0. Data is not read in
+				 * this case
+				 */
 				dvb_ringbuffer_flush(&sl->rx_buffer);
 			}
 		}
@@ -1813,7 +1864,7 @@ static const struct dvb_device dvbdev_ca = {
 	.fops = &dvb_ca_fops,
 };
 
-/* ******************************************************************************** */
+/* ************************************************************************** */
 /* Initialisation/shutdown functions */
 
 
@@ -1862,7 +1913,8 @@ int dvb_ca_en50221_init(struct dvb_adapter *dvb_adapter,
 	pubca->private = ca;
 
 	/* register the DVB device */
-	ret = dvb_register_device(dvb_adapter, &ca->dvbdev, &dvbdev_ca, ca, DVB_DEVICE_CA, 0);
+	ret = dvb_register_device(dvb_adapter, &ca->dvbdev, &dvbdev_ca, ca,
+				  DVB_DEVICE_CA, 0);
 	if (ret)
 		goto free_slot_info;
 
-- 
2.7.4
