Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.anw.at ([195.234.101.228]:54586 "EHLO mail.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750704AbdGLXBl (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Jul 2017 19:01:41 -0400
From: "Jasmin J." <jasmin@anw.at>
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, max.kellermann@gmail.com,
        rjkm@metzlerbros.de, d.scheller@gmx.net, jasmin@anw.at
Subject: [PATCH V2 9/9] [media] dvb-core/dvb_ca_en50221.c: Fixed 80 char limit
Date: Thu, 13 Jul 2017 01:00:58 +0200
Message-Id: <1499900458-2339-10-git-send-email-jasmin@anw.at>
In-Reply-To: <1499900458-2339-1-git-send-email-jasmin@anw.at>
References: <1499900458-2339-1-git-send-email-jasmin@anw.at>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jasmin Jessich <jasmin@anw.at>

Fixed most of:
  WARNING: line over 80 characters
The remaining lines are printk strings, which should not be split and
lines where I thing they should stay as they are.

Signed-off-by: Jasmin Jessich <jasmin@anw.at>
---
 drivers/media/dvb-core/dvb_ca_en50221.c | 57 +++++++++++++++++++++------------
 1 file changed, 37 insertions(+), 20 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_ca_en50221.c b/drivers/media/dvb-core/dvb_ca_en50221.c
index 3e390a4..947c95c 100644
--- a/drivers/media/dvb-core/dvb_ca_en50221.c
+++ b/drivers/media/dvb-core/dvb_ca_en50221.c
@@ -76,7 +76,7 @@ MODULE_PARM_DESC(cam_debug, "enable verbose debug messages");
 #define STATUSREG_WE     2	/* write error */
 #define STATUSREG_FR  0x40	/* module free */
 #define STATUSREG_DA  0x80	/* data available */
-#define STATUSREG_TXERR (STATUSREG_RE|STATUSREG_WE)	/* general transfer error */
+#define STATUSREG_TXERR (STATUSREG_RE|STATUSREG_WE) /* general transfer error */
 
 
 #define DVB_CA_SLOTSTATE_NONE           0
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
 
 
@@ -346,8 +348,8 @@ static int dvb_ca_en50221_link_init(struct dvb_ca_private *ca, int slot)
 	/* we'll be determining these during this function */
 	sl->da_irq_supported = 0;
 
-	/* set the host link buffer size temporarily. it will be overwritten with the
-	 * real negotiated size later.
+	/* set the host link buffer size temporarily. it will be overwritten
+	 * with the real negotiated size later.
 	 */
 	sl->link_buf_size = 2;
 
@@ -366,7 +368,9 @@ static int dvb_ca_en50221_link_init(struct dvb_ca_private *ca, int slot)
 	if (ret != 0)
 		return ret;
 
-	/* store it, and choose the minimum of our buffer and the CAM's buffer size */
+	/* store it, and choose the minimum of our buffer and the CAM's buffer
+	 * size
+	 */
 	buf_size = (buf[0] << 8) | buf[1];
 	if (buf_size > HOST_LINK_BUF_SIZE)
 		buf_size = HOST_LINK_BUF_SIZE;
@@ -435,7 +439,8 @@ static int dvb_ca_en50221_read_tuple(struct dvb_ca_private *ca, int slot,
 
 	/* read in the whole tuple */
 	for (i = 0; i < _tupleLength; i++) {
-		tuple[i] = ca->pub->read_attribute_mem(ca->pub, slot, _address + (i * 2));
+		tuple[i] = ca->pub->read_attribute_mem(ca->pub, slot,
+						       _address + (i * 2));
 		dprintk("  0x%02x: 0x%02x %c\n",
 			i, tuple[i] & 0xff,
 			((tuple[i] > 31) && (tuple[i] < 127)) ? tuple[i] : '.');
@@ -588,7 +593,7 @@ static int dvb_ca_en50221_parse_attributes(struct dvb_ca_private *ca, int slot)
 			end_chain = 1;
 			break;
 
-		default:	/* Unknown tuple type - just skip this tuple and move to the next one */
+		default:	/* Unknown tuple type - just skip this tuple */
 			dprintk("dvb_ca: Skipping unknown tuple type:0x%x length:0x%x\n",
 				tupleType, tupleLength);
 			break;
@@ -764,7 +769,9 @@ static int dvb_ca_en50221_read_data(struct dvb_ca_private *ca, int slot,
 		}
 	}
 
-	/* OK, add it to the receive buffer, or copy into external buffer if supplied */
+	/* OK, add it to the receive buffer, or copy into external buffer if
+	 * supplied
+	 */
 	if (ebuf == NULL) {
 		if (sl->rx_buffer.data == NULL) {
 			status = -EIO;
@@ -915,7 +922,7 @@ static int dvb_ca_en50221_write_data(struct dvb_ca_private *ca, int slot,
 
 
 
-/* ******************************************************************************** */
+/* ************************************************************************** */
 /* EN50221 higher level functions */
 
 
@@ -951,7 +958,8 @@ static int dvb_ca_en50221_slot_shutdown(struct dvb_ca_private *ca, int slot)
  * @slot: Slot concerned.
  * @change_type: One of the DVB_CA_CAMCHANGE_* values.
  */
-void dvb_ca_en50221_camchange_irq(struct dvb_ca_en50221 *pubca, int slot, int change_type)
+void dvb_ca_en50221_camchange_irq(struct dvb_ca_en50221 *pubca, int slot,
+				  int change_type)
 {
 	struct dvb_ca_private *ca = pubca->private;
 	struct dvb_ca_slot *sl = &ca->slot_info[slot];
@@ -1027,7 +1035,7 @@ void dvb_ca_en50221_frda_irq(struct dvb_ca_en50221 *pubca, int slot)
 EXPORT_SYMBOL(dvb_ca_en50221_frda_irq);
 
 
-/* ******************************************************************************** */
+/* ************************************************************************** */
 /* EN50221 thread functions */
 
 /**
@@ -1342,7 +1350,7 @@ static int dvb_ca_en50221_thread(void *data)
 
 
 
-/* ******************************************************************************** */
+/* ************************************************************************** */
 /* EN50221 IO interface functions */
 
 /**
@@ -1475,7 +1483,9 @@ static ssize_t dvb_ca_en50221_io_write(struct file *file,
 
 	dprintk("%s\n", __func__);
 
-	/* Incoming packet has a 2 byte header. hdr[0] = slot_id, hdr[1] = connection_id */
+	/* Incoming packet has a 2 byte header.
+	 * hdr[0] = slot_id, hdr[1] = connection_id
+	 */
 	if (count < 2)
 		return -EINVAL;
 
@@ -1513,14 +1523,17 @@ static ssize_t dvb_ca_en50221_io_write(struct file *file,
 		timeout = jiffies + HZ / 2;
 		written = 0;
 		while (!time_after(jiffies, timeout)) {
-			/* check the CAM hasn't been removed/reset in the meantime */
+			/* check the CAM hasn't been removed/reset in the
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
@@ -1574,7 +1587,8 @@ static int dvb_ca_en50221_io_read_condition(struct dvb_ca_private *ca,
 			dvb_ringbuffer_pkt_read(&sl->rx_buffer, idx, 0, hdr, 2);
 			if (connection_id == -1)
 				connection_id = hdr[0];
-			if ((hdr[0] == connection_id) && ((hdr[1] & 0x80) == 0)) {
+			if ((hdr[0] == connection_id) &&
+			    ((hdr[1] & 0x80) == 0)) {
 				*_slot = slot;
 				found = 1;
 				break;
@@ -1623,7 +1637,9 @@ static ssize_t dvb_ca_en50221_io_read(struct file *file, char __user *buf,
 
 	dprintk("%s\n", __func__);
 
-	/* Outgoing packet has a 2 byte header. hdr[0] = slot_id, hdr[1] = connection_id */
+	/* Outgoing packet has a 2 byte header.
+	 * hdr[0] = slot_id, hdr[1] = connection_id
+	 */
 	if (count < 2)
 		return -EINVAL;
 
@@ -1842,7 +1858,7 @@ static const struct dvb_device dvbdev_ca = {
 	.fops = &dvb_ca_fops,
 };
 
-/* ******************************************************************************** */
+/* ************************************************************************** */
 /* Initialisation/shutdown functions */
 
 
@@ -1891,7 +1907,8 @@ int dvb_ca_en50221_init(struct dvb_adapter *dvb_adapter,
 	pubca->private = ca;
 
 	/* register the DVB device */
-	ret = dvb_register_device(dvb_adapter, &ca->dvbdev, &dvbdev_ca, ca, DVB_DEVICE_CA, 0);
+	ret = dvb_register_device(dvb_adapter, &ca->dvbdev, &dvbdev_ca, ca,
+				  DVB_DEVICE_CA, 0);
 	if (ret)
 		goto free_slot_info;
 
-- 
2.7.4
