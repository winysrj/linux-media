Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.anw.at ([195.234.101.228]:35906 "EHLO mail.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756498AbdEGWFO (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 7 May 2017 18:05:14 -0400
From: "Jasmin J." <jasmin@anw.at>
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, max.kellermann@gmail.com,
        rjkm@metzlerbros.de, d.scheller@gmx.net, jasmin@anw.at
Subject: [PATCH 3/7] [media] dvb-core/dvb_ca_en50221.c: Add block read/write functions
Date: Sun,  7 May 2017 22:51:49 +0200
Message-Id: <1494190313-18557-4-git-send-email-jasmin@anw.at>
In-Reply-To: <1494190313-18557-1-git-send-email-jasmin@anw.at>
References: <1494190313-18557-1-git-send-email-jasmin@anw.at>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jasmin Jessich <jasmin@anw.at>

Some lower level drivers may work better when sending blocks of data instead
byte per byte. For this we need new function pointers in the dvb_ca_en50221
protocol structure (read_data, write_data) and the protocol needs to execute
them, if they are defined.
Block data transmission is done in all states expect LINKINIT.

Signed-off-by: Ralph Metzler <rjkm@metzlerbros.de>
Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
Signed-off-by: Jasmin Jessich <jasmin@anw.at>
---
 drivers/media/dvb-core/dvb_ca_en50221.c | 117 ++++++++++++++++++--------------
 drivers/media/dvb-core/dvb_ca_en50221.h |   7 ++
 2 files changed, 73 insertions(+), 51 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_ca_en50221.c b/drivers/media/dvb-core/dvb_ca_en50221.c
index 1cdd80a..cc709c9 100644
--- a/drivers/media/dvb-core/dvb_ca_en50221.c
+++ b/drivers/media/dvb-core/dvb_ca_en50221.c
@@ -646,66 +646,78 @@ static int dvb_ca_en50221_read_data(struct dvb_ca_private *ca, int slot, u8 * eb
 		}
 	}
 
-	/* check if there is data available */
-	if ((status = ca->pub->read_cam_control(ca->pub, slot, CTRLIF_STATUS)) < 0)
-		goto exit;
-	if (!(status & STATUSREG_DA)) {
-		/* no data */
-		status = 0;
-		goto exit;
-	}
-
-	/* read the amount of data */
-	if ((status = ca->pub->read_cam_control(ca->pub, slot, CTRLIF_SIZE_HIGH)) < 0)
-		goto exit;
-	bytes_read = status << 8;
-	if ((status = ca->pub->read_cam_control(ca->pub, slot, CTRLIF_SIZE_LOW)) < 0)
-		goto exit;
-	bytes_read |= status;
+	if (ca->pub->read_data && (ca->slot_info[slot].slot_state != DVB_CA_SLOTSTATE_LINKINIT)) {
+		if (ebuf == NULL)
+			status = ca->pub->read_data(ca->pub, slot, buf, sizeof(buf));
+		else
+			status = ca->pub->read_data(ca->pub, slot, buf, ecount);
+		if (status < 0)
+			return status;
+		bytes_read =  status;
+		if (status == 0)
+			goto exit;
+	} else {
 
-	/* check it will fit */
-	if (ebuf == NULL) {
-		if (bytes_read > ca->slot_info[slot].link_buf_size) {
-			pr_err("dvb_ca adapter %d: CAM tried to send a buffer larger than the link buffer size (%i > %i)!\n",
-			       ca->dvbdev->adapter->num, bytes_read,
-			       ca->slot_info[slot].link_buf_size);
-			ca->slot_info[slot].slot_state = DVB_CA_SLOTSTATE_LINKINIT;
-			status = -EIO;
+		/* check if there is data available */
+		if ((status = ca->pub->read_cam_control(ca->pub, slot, CTRLIF_STATUS)) < 0)
 			goto exit;
-		}
-		if (bytes_read < 2) {
-			pr_err("dvb_ca adapter %d: CAM sent a buffer that was less than 2 bytes!\n",
-			       ca->dvbdev->adapter->num);
-			ca->slot_info[slot].slot_state = DVB_CA_SLOTSTATE_LINKINIT;
-			status = -EIO;
+		if (!(status & STATUSREG_DA)) {
+			/* no data */
+			status = 0;
 			goto exit;
 		}
-	} else {
-		if (bytes_read > ecount) {
-			pr_err("dvb_ca adapter %d: CAM tried to send a buffer larger than the ecount size!\n",
-			       ca->dvbdev->adapter->num);
-			status = -EIO;
+
+		/* read the amount of data */
+		if ((status = ca->pub->read_cam_control(ca->pub, slot, CTRLIF_SIZE_HIGH)) < 0)
+			goto exit;
+		bytes_read = status << 8;
+		if ((status = ca->pub->read_cam_control(ca->pub, slot, CTRLIF_SIZE_LOW)) < 0)
 			goto exit;
+		bytes_read |= status;
+
+		/* check it will fit */
+		if (ebuf == NULL) {
+			if (bytes_read > ca->slot_info[slot].link_buf_size) {
+				pr_err("dvb_ca adapter %d: CAM tried to send a buffer larger than the link buffer size (%i > %i)!\n",
+				       ca->dvbdev->adapter->num, bytes_read, ca->slot_info[slot].link_buf_size);
+				ca->slot_info[slot].slot_state = DVB_CA_SLOTSTATE_LINKINIT;
+				status = -EIO;
+				goto exit;
+			}
+			if (bytes_read < 2) {
+				pr_err("dvb_ca adapter %d: CAM sent a buffer that was less than 2 bytes!\n",
+				       ca->dvbdev->adapter->num);
+				ca->slot_info[slot].slot_state = DVB_CA_SLOTSTATE_LINKINIT;
+				status = -EIO;
+				goto exit;
+			}
+		} else {
+			if (bytes_read > ecount) {
+				pr_err("dvb_ca adapter %d: CAM tried to send a buffer larger than the ecount size!\n",
+				       ca->dvbdev->adapter->num);
+				status = -EIO;
+				goto exit;
+			}
 		}
-	}
 
-	/* fill the buffer */
-	for (i = 0; i < bytes_read; i++) {
-		/* read byte and check */
-		if ((status = ca->pub->read_cam_control(ca->pub, slot, CTRLIF_DATA)) < 0)
-			goto exit;
+		/* fill the buffer */
+		for (i = 0; i < bytes_read; i++) {
+			/* read byte and check */
+			if ((status = ca->pub->read_cam_control(ca->pub, slot, CTRLIF_DATA)) < 0)
+				goto exit;
 
-		/* OK, store it in the buffer */
-		buf[i] = status;
-	}
+			/* OK, store it in the buffer */
+			buf[i] = status;
+		}
 
-	/* check for read error (RE should now be 0) */
-	if ((status = ca->pub->read_cam_control(ca->pub, slot, CTRLIF_STATUS)) < 0)
-		goto exit;
-	if (status & STATUSREG_RE) {
-		ca->slot_info[slot].slot_state = DVB_CA_SLOTSTATE_LINKINIT;
-		status = -EIO;
-		goto exit;
+		/* check for read error (RE should now be 0) */
+		if ((status = ca->pub->read_cam_control(ca->pub, slot, CTRLIF_STATUS)) < 0)
+			goto exit;
+		if (status & STATUSREG_RE) {
+			ca->slot_info[slot].slot_state = DVB_CA_SLOTSTATE_LINKINIT;
+			status = -EIO;
+			goto exit;
+		}
 	}
 
 	/* OK, add it to the receive buffer, or copy into external buffer if supplied */
@@ -757,6 +769,9 @@ static int dvb_ca_en50221_write_data(struct dvb_ca_private *ca, int slot, u8 * b
 	if (bytes_write > ca->slot_info[slot].link_buf_size)
 		return -EINVAL;
 
+	if (ca->pub->write_data && (ca->slot_info[slot].slot_state != DVB_CA_SLOTSTATE_LINKINIT))
+		return ca->pub->write_data(ca->pub, slot, buf, bytes_write);
+
 	/* it is possible we are dealing with a single buffer implementation,
 	   thus if there is data available for read or if there is even a read
 	   already in progress, we do nothing but awake the kernel thread to
diff --git a/drivers/media/dvb-core/dvb_ca_en50221.h b/drivers/media/dvb-core/dvb_ca_en50221.h
index 1e4bbbd..82617ba 100644
--- a/drivers/media/dvb-core/dvb_ca_en50221.h
+++ b/drivers/media/dvb-core/dvb_ca_en50221.h
@@ -41,6 +41,8 @@
  * @write_attribute_mem: function for writing attribute memory on the CAM
  * @read_cam_control:	function for reading the control interface on the CAM
  * @write_cam_control:	function for reading the control interface on the CAM
+ * @read_data:		function for reading data (block mode)
+ * @write_data:		function for writing data (block mode)
  * @slot_reset:		function to reset the CAM slot
  * @slot_shutdown:	function to shutdown a CAM slot
  * @slot_ts_enable:	function to enable the Transport Stream on a CAM slot
@@ -66,6 +68,11 @@ struct dvb_ca_en50221 {
 	int (*write_cam_control)(struct dvb_ca_en50221 *ca,
 				 int slot, u8 address, u8 value);
 
+	int (*read_data)(struct dvb_ca_en50221 *ca,
+				int slot, u8 *ebuf, int ecount);
+	int (*write_data)(struct dvb_ca_en50221 *ca,
+				int slot, u8 *ebuf, int ecount);
+
 	int (*slot_reset)(struct dvb_ca_en50221 *ca, int slot);
 	int (*slot_shutdown)(struct dvb_ca_en50221 *ca, int slot);
 	int (*slot_ts_enable)(struct dvb_ca_en50221 *ca, int slot);
-- 
2.7.4
