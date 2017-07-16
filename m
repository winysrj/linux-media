Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.anw.at ([195.234.101.228]:46232 "EHLO mail.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751209AbdGPAni (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 15 Jul 2017 20:43:38 -0400
From: "Jasmin J." <jasmin@anw.at>
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, max.kellermann@gmail.com,
        rjkm@metzlerbros.de, d.scheller@gmx.net, crope@iki.fi,
        jasmin@anw.at
Subject: [PATCH V3 11/16] [media] dvb-core/dvb_ca_en50221.c: Fixed 80 char limit
Date: Sun, 16 Jul 2017 02:43:12 +0200
Message-Id: <1500165797-16987-12-git-send-email-jasmin@anw.at>
In-Reply-To: <1500165797-16987-1-git-send-email-jasmin@anw.at>
References: <1500165797-16987-1-git-send-email-jasmin@anw.at>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jasmin Jessich <jasmin@anw.at>

Fixed most of:
  WARNING: line over 80 characters
The remaining lines are printk strings, which should not be split and
lines where I thing they should stay as they are.

Signed-off-by: Jasmin Jessich <jasmin@anw.at>
---
 drivers/media/dvb-core/dvb_ca_en50221.c | 57 +++++++++++++++++++++++----------
 1 file changed, 40 insertions(+), 17 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_ca_en50221.c b/drivers/media/dvb-core/dvb_ca_en50221.c
index 99cf460..8c0c730 100644
--- a/drivers/media/dvb-core/dvb_ca_en50221.c
+++ b/drivers/media/dvb-core/dvb_ca_en50221.c
@@ -155,7 +155,10 @@ struct dvb_ca_private {
 	/* Delay the main thread should use */
 	unsigned long delay;
 
-	/* Slot to start looking for data to read from in the next user-space read operation */
+	/*
+	 * Slot to start looking for data to read from in the next user-space
+	 * read operation
+	 */
 	int next_read_slot;
 
 	/* mutex serializing ioctls */
@@ -225,7 +228,7 @@ static char *findstr(char *haystack, int hlen, char *needle, int nlen)
 
 
 
-/* ******************************************************************************** */
+/* ************************************************************************** */
 /* EN50221 physical interface functions */
 
 
@@ -365,7 +368,10 @@ static int dvb_ca_en50221_link_init(struct dvb_ca_private *ca, int slot)
 	if (ret)
 		return ret;
 
-	/* store it, and choose the minimum of our buffer and the CAM's buffer size */
+	/*
+	 * store it, and choose the minimum of our buffer and the CAM's buffer
+	 * size
+	 */
 	buf_size = (buf[0] << 8) | buf[1];
 	if (buf_size > HOST_LINK_BUF_SIZE)
 		buf_size = HOST_LINK_BUF_SIZE;
@@ -435,7 +441,8 @@ static int dvb_ca_en50221_read_tuple(struct dvb_ca_private *ca, int slot,
 
 	/* read in the whole tuple */
 	for (i = 0; i < _tuple_length; i++) {
-		tuple[i] = ca->pub->read_attribute_mem(ca->pub, slot, _address + (i * 2));
+		tuple[i] = ca->pub->read_attribute_mem(ca->pub, slot,
+						       _address + (i * 2));
 		dprintk("  0x%02x: 0x%02x %c\n",
 			i, tuple[i] & 0xff,
 			((tuple[i] > 31) && (tuple[i] < 127)) ? tuple[i] : '.');
@@ -590,7 +597,7 @@ static int dvb_ca_en50221_parse_attributes(struct dvb_ca_private *ca, int slot)
 			end_chain = 1;
 			break;
 
-		default:	/* Unknown tuple type - just skip this tuple and move to the next one */
+		default:	/* Unknown tuple type - just skip this tuple */
 			dprintk("dvb_ca: Skipping unknown tuple type:0x%x length:0x%x\n",
 				tuple_type, tuple_length);
 			break;
@@ -766,7 +773,10 @@ static int dvb_ca_en50221_read_data(struct dvb_ca_private *ca, int slot,
 		}
 	}
 
-	/* OK, add it to the receive buffer, or copy into external buffer if supplied */
+	/*
+	 * OK, add it to the receive buffer, or copy into external buffer if
+	 * supplied
+	 */
 	if (ebuf == NULL) {
 		if (!sl->rx_buffer.data) {
 			status = -EIO;
@@ -918,7 +928,7 @@ static int dvb_ca_en50221_write_data(struct dvb_ca_private *ca, int slot,
 
 
 
-/* ******************************************************************************** */
+/* ************************************************************************** */
 /* EN50221 higher level functions */
 
 
@@ -955,7 +965,8 @@ static int dvb_ca_en50221_slot_shutdown(struct dvb_ca_private *ca, int slot)
  * @slot: Slot concerned.
  * @change_type: One of the DVB_CA_CAMCHANGE_* values.
  */
-void dvb_ca_en50221_camchange_irq(struct dvb_ca_en50221 *pubca, int slot, int change_type)
+void dvb_ca_en50221_camchange_irq(struct dvb_ca_en50221 *pubca, int slot,
+				  int change_type)
 {
 	struct dvb_ca_private *ca = pubca->private;
 	struct dvb_ca_slot *sl = &ca->slot_info[slot];
@@ -1031,7 +1042,7 @@ void dvb_ca_en50221_frda_irq(struct dvb_ca_en50221 *pubca, int slot)
 EXPORT_SYMBOL(dvb_ca_en50221_frda_irq);
 
 
-/* ******************************************************************************** */
+/* ************************************************************************** */
 /* EN50221 thread functions */
 
 /**
@@ -1351,7 +1362,7 @@ static int dvb_ca_en50221_thread(void *data)
 
 
 
-/* ******************************************************************************** */
+/* ************************************************************************** */
 /* EN50221 IO interface functions */
 
 /**
@@ -1484,7 +1495,10 @@ static ssize_t dvb_ca_en50221_io_write(struct file *file,
 
 	dprintk("%s\n", __func__);
 
-	/* Incoming packet has a 2 byte header. hdr[0] = slot_id, hdr[1] = connection_id */
+	/*
+	 * Incoming packet has a 2 byte header.
+	 * hdr[0] = slot_id, hdr[1] = connection_id
+	 */
 	if (count < 2)
 		return -EINVAL;
 
@@ -1522,14 +1536,18 @@ static ssize_t dvb_ca_en50221_io_write(struct file *file,
 		timeout = jiffies + HZ / 2;
 		written = 0;
 		while (!time_after(jiffies, timeout)) {
-			/* check the CAM hasn't been removed/reset in the meantime */
+			/*
+			 * check the CAM hasn't been removed/reset in the
+			 * meantime
+			 */
 			if (sl->slot_state != DVB_CA_SLOTSTATE_RUNNING) {
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
@@ -1583,7 +1601,8 @@ static int dvb_ca_en50221_io_read_condition(struct dvb_ca_private *ca,
 			dvb_ringbuffer_pkt_read(&sl->rx_buffer, idx, 0, hdr, 2);
 			if (connection_id == -1)
 				connection_id = hdr[0];
-			if ((hdr[0] == connection_id) && ((hdr[1] & 0x80) == 0)) {
+			if ((hdr[0] == connection_id) &&
+			    ((hdr[1] & 0x80) == 0)) {
 				*_slot = slot;
 				found = 1;
 				break;
@@ -1632,7 +1651,10 @@ static ssize_t dvb_ca_en50221_io_read(struct file *file, char __user *buf,
 
 	dprintk("%s\n", __func__);
 
-	/* Outgoing packet has a 2 byte header. hdr[0] = slot_id, hdr[1] = connection_id */
+	/*
+	 * Outgoing packet has a 2 byte header.
+	 * hdr[0] = slot_id, hdr[1] = connection_id
+	 */
 	if (count < 2)
 		return -EINVAL;
 
@@ -1852,7 +1874,7 @@ static const struct dvb_device dvbdev_ca = {
 	.fops = &dvb_ca_fops,
 };
 
-/* ******************************************************************************** */
+/* ************************************************************************** */
 /* Initialisation/shutdown functions */
 
 
@@ -1901,7 +1923,8 @@ int dvb_ca_en50221_init(struct dvb_adapter *dvb_adapter,
 	pubca->private = ca;
 
 	/* register the DVB device */
-	ret = dvb_register_device(dvb_adapter, &ca->dvbdev, &dvbdev_ca, ca, DVB_DEVICE_CA, 0);
+	ret = dvb_register_device(dvb_adapter, &ca->dvbdev, &dvbdev_ca, ca,
+				  DVB_DEVICE_CA, 0);
 	if (ret)
 		goto free_slot_info;
 
-- 
2.7.4
