Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.anw.at ([195.234.101.228]:35906 "EHLO mail.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755934AbdEGWEr (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 7 May 2017 18:04:47 -0400
From: "Jasmin J." <jasmin@anw.at>
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, max.kellermann@gmail.com, jasmin@anw.at
Subject: [PATCH 06/11] [media] dvb-core/dvb_ca_en50221.c: Make checkpatch happy 2
Date: Sun,  7 May 2017 23:23:29 +0200
Message-Id: <1494192214-20082-7-git-send-email-jasmin@anw.at>
In-Reply-To: <1494192214-20082-1-git-send-email-jasmin@anw.at>
References: <1494192214-20082-1-git-send-email-jasmin@anw.at>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jasmin Jessich <jasmin@anw.at>

Fixed all:
  ERROR: do not use assignment in if condition

Signed-off-by: Jasmin Jessich <jasmin@anw.at>
---
 drivers/media/dvb-core/dvb_ca_en50221.c | 130 +++++++++++++++++++++-----------
 1 file changed, 88 insertions(+), 42 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_ca_en50221.c b/drivers/media/dvb-core/dvb_ca_en50221.c
index 48b652b..6d405b5 100644
--- a/drivers/media/dvb-core/dvb_ca_en50221.c
+++ b/drivers/media/dvb-core/dvb_ca_en50221.c
@@ -349,13 +349,18 @@ static int dvb_ca_en50221_link_init(struct dvb_ca_private *ca, int slot)
 	sl->link_buf_size = 2;
 
 	/* read the buffer size from the CAM */
-	if ((ret = ca->pub->write_cam_control(ca->pub, slot, CTRLIF_COMMAND, IRQEN | CMDREG_SR)) != 0)
+	ret = ca->pub->write_cam_control(ca->pub, slot, CTRLIF_COMMAND,
+					 IRQEN | CMDREG_SR);
+	if (ret != 0)
 		return ret;
-	if ((ret = dvb_ca_en50221_wait_if_status(ca, slot, STATREG_DA, HZ)) != 0)
+	ret = dvb_ca_en50221_wait_if_status(ca, slot, STATREG_DA, HZ);
+	if (ret != 0)
 		return ret;
-	if ((ret = dvb_ca_en50221_read_data(ca, slot, buf, 2)) != 2)
+	ret = dvb_ca_en50221_read_data(ca, slot, buf, 2);
+	if (ret != 2)
 		return -EIO;
-	if ((ret = ca->pub->write_cam_control(ca->pub, slot, CTRLIF_COMMAND, IRQEN)) != 0)
+	ret = ca->pub->write_cam_control(ca->pub, slot, CTRLIF_COMMAND, IRQEN);
+	if (ret != 0)
 		return ret;
 
 	/* store it, and choose the minimum of our buffer and the CAM's buffer size */
@@ -368,13 +373,18 @@ static int dvb_ca_en50221_link_init(struct dvb_ca_private *ca, int slot)
 	dprintk("Chosen link buffer size of %i\n", buf_size);
 
 	/* write the buffer size to the CAM */
-	if ((ret = ca->pub->write_cam_control(ca->pub, slot, CTRLIF_COMMAND, IRQEN | CMDREG_SW)) != 0)
+	ret = ca->pub->write_cam_control(ca->pub, slot, CTRLIF_COMMAND,
+					 IRQEN | CMDREG_SW);
+	if (ret != 0)
 		return ret;
-	if ((ret = dvb_ca_en50221_wait_if_status(ca, slot, STATREG_FR, HZ / 10)) != 0)
+	ret = dvb_ca_en50221_wait_if_status(ca, slot, STATREG_FR, HZ / 10);
+	if (ret != 0)
 		return ret;
-	if ((ret = dvb_ca_en50221_write_data(ca, slot, buf, 2)) != 2)
+	ret = dvb_ca_en50221_write_data(ca, slot, buf, 2);
+	if (ret != 2)
 		return -EIO;
-	if ((ret = ca->pub->write_cam_control(ca->pub, slot, CTRLIF_COMMAND, IRQEN)) != 0)
+	ret = ca->pub->write_cam_control(ca->pub, slot, CTRLIF_COMMAND, IRQEN);
+	if (ret != 0)
 		return ret;
 
 	/* success */
@@ -403,7 +413,8 @@ static int dvb_ca_en50221_read_tuple(struct dvb_ca_private *ca, int slot,
 	int _address = *address;
 
 	/* grab the next tuple length and type */
-	if ((_tupleType = ca->pub->read_attribute_mem(ca->pub, slot, _address)) < 0)
+	_tupleType = ca->pub->read_attribute_mem(ca->pub, slot, _address);
+	if (_tupleType < 0)
 		return _tupleType;
 	if (_tupleType == 0xff) {
 		dprintk("END OF CHAIN TUPLE type:0x%x\n", _tupleType);
@@ -412,7 +423,8 @@ static int dvb_ca_en50221_read_tuple(struct dvb_ca_private *ca, int slot,
 		*tupleLength = 0;
 		return 0;
 	}
-	if ((_tupleLength = ca->pub->read_attribute_mem(ca->pub, slot, _address + 2)) < 0)
+	_tupleLength = ca->pub->read_attribute_mem(ca->pub, slot, _address + 2);
+	if (_tupleLength < 0)
 		return _tupleLength;
 	_address += 4;
 
@@ -462,8 +474,9 @@ static int dvb_ca_en50221_parse_attributes(struct dvb_ca_private *ca, int slot)
 
 
 	// CISTPL_DEVICE_0A
-	if ((status =
-	     dvb_ca_en50221_read_tuple(ca, slot, &address, &tupleType, &tupleLength, tuple)) < 0)
+	status = dvb_ca_en50221_read_tuple(ca, slot, &address, &tupleType,
+					   &tupleLength, tuple);
+	if (status < 0)
 		return status;
 	if (tupleType != 0x1D)
 		return -EINVAL;
@@ -471,8 +484,9 @@ static int dvb_ca_en50221_parse_attributes(struct dvb_ca_private *ca, int slot)
 
 
 	// CISTPL_DEVICE_0C
-	if ((status =
-	     dvb_ca_en50221_read_tuple(ca, slot, &address, &tupleType, &tupleLength, tuple)) < 0)
+	status = dvb_ca_en50221_read_tuple(ca, slot, &address, &tupleType,
+					   &tupleLength, tuple);
+	if (status < 0)
 		return status;
 	if (tupleType != 0x1C)
 		return -EINVAL;
@@ -480,8 +494,9 @@ static int dvb_ca_en50221_parse_attributes(struct dvb_ca_private *ca, int slot)
 
 
 	// CISTPL_VERS_1
-	if ((status =
-	     dvb_ca_en50221_read_tuple(ca, slot, &address, &tupleType, &tupleLength, tuple)) < 0)
+	status = dvb_ca_en50221_read_tuple(ca, slot, &address, &tupleType,
+					   &tupleLength, tuple);
+	if (status < 0)
 		return status;
 	if (tupleType != 0x15)
 		return -EINVAL;
@@ -489,8 +504,9 @@ static int dvb_ca_en50221_parse_attributes(struct dvb_ca_private *ca, int slot)
 
 
 	// CISTPL_MANFID
-	if ((status = dvb_ca_en50221_read_tuple(ca, slot, &address, &tupleType,
-						&tupleLength, tuple)) < 0)
+	status = dvb_ca_en50221_read_tuple(ca, slot, &address, &tupleType,
+					   &tupleLength, tuple);
+	if (status < 0)
 		return status;
 	if (tupleType != 0x20)
 		return -EINVAL;
@@ -502,8 +518,9 @@ static int dvb_ca_en50221_parse_attributes(struct dvb_ca_private *ca, int slot)
 
 
 	// CISTPL_CONFIG
-	if ((status = dvb_ca_en50221_read_tuple(ca, slot, &address, &tupleType,
-						&tupleLength, tuple)) < 0)
+	status = dvb_ca_en50221_read_tuple(ca, slot, &address, &tupleType,
+					   &tupleLength, tuple);
+	if (status < 0)
 		return status;
 	if (tupleType != 0x1A)
 		return -EINVAL;
@@ -538,8 +555,10 @@ static int dvb_ca_en50221_parse_attributes(struct dvb_ca_private *ca, int slot)
 
 	/* process the CFTABLE_ENTRY tuples, and any after those */
 	while ((!end_chain) && (address < 0x1000)) {
-		if ((status = dvb_ca_en50221_read_tuple(ca, slot, &address, &tupleType,
-							&tupleLength, tuple)) < 0)
+		status = dvb_ca_en50221_read_tuple(ca, slot, &address,
+						   &tupleType, &tupleLength,
+						   tuple);
+		if (status < 0)
 			return status;
 		switch (tupleType) {
 		case 0x1B:	// CISTPL_CFTABLE_ENTRY
@@ -669,7 +688,9 @@ static int dvb_ca_en50221_read_data(struct dvb_ca_private *ca, int slot,
 	} else {
 
 		/* check if there is data available */
-		if ((status = ca->pub->read_cam_control(ca->pub, slot, CTRLIF_STATUS)) < 0)
+		status = ca->pub->read_cam_control(ca->pub, slot,
+						   CTRLIF_STATUS);
+		if (status < 0)
 			goto exit;
 		if (!(status & STATREG_DA)) {
 			/* no data */
@@ -678,10 +699,14 @@ static int dvb_ca_en50221_read_data(struct dvb_ca_private *ca, int slot,
 		}
 
 		/* read the amount of data */
-		if ((status = ca->pub->read_cam_control(ca->pub, slot, CTRLIF_SIZE_HIGH)) < 0)
+		status = ca->pub->read_cam_control(ca->pub, slot,
+						   CTRLIF_SIZE_HIGH);
+		if (status < 0)
 			goto exit;
 		bytes_read = status << 8;
-		if ((status = ca->pub->read_cam_control(ca->pub, slot, CTRLIF_SIZE_LOW)) < 0)
+		status = ca->pub->read_cam_control(ca->pub, slot,
+						   CTRLIF_SIZE_LOW);
+		if (status < 0)
 			goto exit;
 		bytes_read |= status;
 
@@ -713,7 +738,9 @@ static int dvb_ca_en50221_read_data(struct dvb_ca_private *ca, int slot,
 		/* fill the buffer */
 		for (i = 0; i < bytes_read; i++) {
 			/* read byte and check */
-			if ((status = ca->pub->read_cam_control(ca->pub, slot, CTRLIF_DATA)) < 0)
+			status = ca->pub->read_cam_control(ca->pub, slot,
+							   CTRLIF_DATA);
+			if (status < 0)
 				goto exit;
 
 			/* OK, store it in the buffer */
@@ -721,7 +748,9 @@ static int dvb_ca_en50221_read_data(struct dvb_ca_private *ca, int slot,
 		}
 
 		/* check for read error (RE should now be 0) */
-		if ((status = ca->pub->read_cam_control(ca->pub, slot, CTRLIF_STATUS)) < 0)
+		status = ca->pub->read_cam_control(ca->pub, slot,
+						   CTRLIF_STATUS);
+		if (status < 0)
 			goto exit;
 		if (status & STATREG_RE) {
 			sl->slot_state = SLOT_STAT_LINKINIT;
@@ -788,7 +817,8 @@ static int dvb_ca_en50221_write_data(struct dvb_ca_private *ca, int slot,
 	   thus if there is data available for read or if there is even a read
 	   already in progress, we do nothing but awake the kernel thread to
 	   process the data if necessary. */
-	if ((status = ca->pub->read_cam_control(ca->pub, slot, CTRLIF_STATUS)) < 0)
+	status = ca->pub->read_cam_control(ca->pub, slot, CTRLIF_STATUS);
+	if (status < 0)
 		goto exitnowrite;
 	if (status & (STATREG_DA | STATREG_RE)) {
 		if (status & STATREG_DA)
@@ -799,12 +829,14 @@ static int dvb_ca_en50221_write_data(struct dvb_ca_private *ca, int slot,
 	}
 
 	/* OK, set HC bit */
-	if ((status = ca->pub->write_cam_control(ca->pub, slot, CTRLIF_COMMAND,
-						 IRQEN | CMDREG_HC)) != 0)
+	status = ca->pub->write_cam_control(ca->pub, slot, CTRLIF_COMMAND,
+					    IRQEN | CMDREG_HC);
+	if (status != 0)
 		goto exit;
 
 	/* check if interface is still free */
-	if ((status = ca->pub->read_cam_control(ca->pub, slot, CTRLIF_STATUS)) < 0)
+	status = ca->pub->read_cam_control(ca->pub, slot, CTRLIF_STATUS);
+	if (status < 0)
 		goto exit;
 	if (!(status & STATREG_FR)) {
 		/* it wasn't free => try again later */
@@ -836,20 +868,26 @@ static int dvb_ca_en50221_write_data(struct dvb_ca_private *ca, int slot,
 	}
 
 	/* send the amount of data */
-	if ((status = ca->pub->write_cam_control(ca->pub, slot, CTRLIF_SIZE_HIGH, bytes_write >> 8)) != 0)
+	status = ca->pub->write_cam_control(ca->pub, slot, CTRLIF_SIZE_HIGH,
+					    bytes_write >> 8);
+	if (status != 0)
 		goto exit;
-	if ((status = ca->pub->write_cam_control(ca->pub, slot, CTRLIF_SIZE_LOW,
-						 bytes_write & 0xff)) != 0)
+	status = ca->pub->write_cam_control(ca->pub, slot, CTRLIF_SIZE_LOW,
+					    bytes_write & 0xff);
+	if (status != 0)
 		goto exit;
 
 	/* send the buffer */
 	for (i = 0; i < bytes_write; i++) {
-		if ((status = ca->pub->write_cam_control(ca->pub, slot, CTRLIF_DATA, buf[i])) != 0)
+		status = ca->pub->write_cam_control(ca->pub, slot, CTRLIF_DATA,
+						    buf[i]);
+		if (status != 0)
 			goto exit;
 	}
 
 	/* check for write error (WE should now be 0) */
-	if ((status = ca->pub->read_cam_control(ca->pub, slot, CTRLIF_STATUS)) < 0)
+	status = ca->pub->read_cam_control(ca->pub, slot, CTRLIF_STATUS);
+	if (status < 0)
 		goto exit;
 	if (status & STATREG_WE) {
 		sl->slot_state = SLOT_STAT_LINKINIT;
@@ -1565,7 +1603,8 @@ static ssize_t dvb_ca_en50221_io_read(struct file *file, char __user *buf,
 		return -EINVAL;
 
 	/* wait for some data */
-	if ((status = dvb_ca_en50221_io_read_condition(ca, &result, &slot)) == 0) {
+	status = dvb_ca_en50221_io_read_condition(ca, &result, &slot);
+	if (status == 0) {
 
 		/* if we're in nonblocking mode, exit immediately */
 		if (file->f_flags & O_NONBLOCK)
@@ -1604,8 +1643,12 @@ static ssize_t dvb_ca_en50221_io_read(struct file *file, char __user *buf,
 					fraglen -= 2;
 				}
 
-				if ((status = dvb_ringbuffer_pkt_read_user(&sl->rx_buffer, idx, 2,
-								      buf + pktlen, fraglen)) < 0) {
+				status =
+				   dvb_ringbuffer_pkt_read_user(&sl->rx_buffer,
+								idx, 2,
+								buf + pktlen,
+								fraglen);
+				if (status < 0) {
 					goto exit;
 				}
 				pktlen += fraglen;
@@ -1801,8 +1844,9 @@ int dvb_ca_en50221_init(struct dvb_adapter *dvb_adapter,
 	if (slot_count < 1)
 		return -EINVAL;
 
-	/* initialise the system data */
-	if ((ca = kzalloc(sizeof(struct dvb_ca_private), GFP_KERNEL)) == NULL) {
+	/* initialize the system data */
+	ca = kzalloc(sizeof(struct dvb_ca_private), GFP_KERNEL);
+	if (ca == NULL) {
 		ret = -ENOMEM;
 		goto exit;
 	}
@@ -1810,7 +1854,9 @@ int dvb_ca_en50221_init(struct dvb_adapter *dvb_adapter,
 	ca->pub = pubca;
 	ca->flags = flags;
 	ca->slot_count = slot_count;
-	if ((ca->slot_info = kcalloc(slot_count, sizeof(struct dvb_ca_slot), GFP_KERNEL)) == NULL) {
+	ca->slot_info = kcalloc(slot_count, sizeof(struct dvb_ca_slot),
+				GFP_KERNEL);
+	if (ca->slot_info == NULL) {
 		ret = -ENOMEM;
 		goto free_ca;
 	}
-- 
2.7.4
