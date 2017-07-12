Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.anw.at ([195.234.101.228]:54585 "EHLO mail.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750808AbdGLXBm (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Jul 2017 19:01:42 -0400
From: "Jasmin J." <jasmin@anw.at>
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, max.kellermann@gmail.com,
        rjkm@metzlerbros.de, d.scheller@gmx.net, jasmin@anw.at
Subject: [PATCH V2 5/9] [media] dvb-core/dvb_ca_en50221.c: Avoid assignments in ifs
Date: Thu, 13 Jul 2017 01:00:54 +0200
Message-Id: <1499900458-2339-6-git-send-email-jasmin@anw.at>
In-Reply-To: <1499900458-2339-1-git-send-email-jasmin@anw.at>
References: <1499900458-2339-1-git-send-email-jasmin@anw.at>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jasmin Jessich <jasmin@anw.at>

Fixed all:
  ERROR: do not use assignment in if condition

Signed-off-by: Jasmin Jessich <jasmin@anw.at>
---
 drivers/media/dvb-core/dvb_ca_en50221.c | 97 ++++++++++++++++++++++-----------
 1 file changed, 64 insertions(+), 33 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_ca_en50221.c b/drivers/media/dvb-core/dvb_ca_en50221.c
index 317968b..02b8785 100644
--- a/drivers/media/dvb-core/dvb_ca_en50221.c
+++ b/drivers/media/dvb-core/dvb_ca_en50221.c
@@ -348,14 +348,18 @@ static int dvb_ca_en50221_link_init(struct dvb_ca_private *ca, int slot)
 	ca->slot_info[slot].link_buf_size = 2;
 
 	/* read the buffer size from the CAM */
-	if ((ret = ca->pub->write_cam_control(ca->pub, slot, CTRLIF_COMMAND, IRQEN | CMDREG_SR)) != 0)
+	ret = ca->pub->write_cam_control(ca->pub, slot, CTRLIF_COMMAND,
+					 IRQEN | CMDREG_SR);
+	if (ret != 0)
 		return ret;
 	ret = dvb_ca_en50221_wait_if_status(ca, slot, STATUSREG_DA, HZ);
 	if (ret != 0)
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
@@ -368,13 +372,18 @@ static int dvb_ca_en50221_link_init(struct dvb_ca_private *ca, int slot)
 	dprintk("Chosen link buffer size of %i\n", buf_size);
 
 	/* write the buffer size to the CAM */
-	if ((ret = ca->pub->write_cam_control(ca->pub, slot, CTRLIF_COMMAND, IRQEN | CMDREG_SW)) != 0)
+	ret = ca->pub->write_cam_control(ca->pub, slot, CTRLIF_COMMAND,
+					 IRQEN | CMDREG_SW);
+	if (ret != 0)
 		return ret;
-	if ((ret = dvb_ca_en50221_wait_if_status(ca, slot, STATUSREG_FR, HZ / 10)) != 0)
+	ret = dvb_ca_en50221_wait_if_status(ca, slot, STATUSREG_FR, HZ / 10);
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
@@ -403,7 +412,8 @@ static int dvb_ca_en50221_read_tuple(struct dvb_ca_private *ca, int slot,
 	int _address = *address;
 
 	/* grab the next tuple length and type */
-	if ((_tupleType = ca->pub->read_attribute_mem(ca->pub, slot, _address)) < 0)
+	_tupleType = ca->pub->read_attribute_mem(ca->pub, slot, _address);
+	if (_tupleType < 0)
 		return _tupleType;
 	if (_tupleType == 0xff) {
 		dprintk("END OF CHAIN TUPLE type:0x%x\n", _tupleType);
@@ -412,7 +422,8 @@ static int dvb_ca_en50221_read_tuple(struct dvb_ca_private *ca, int slot,
 		*tupleLength = 0;
 		return 0;
 	}
-	if ((_tupleLength = ca->pub->read_attribute_mem(ca->pub, slot, _address + 2)) < 0)
+	_tupleLength = ca->pub->read_attribute_mem(ca->pub, slot, _address + 2);
+	if (_tupleLength < 0)
 		return _tupleLength;
 	_address += 4;
 
@@ -461,8 +472,9 @@ static int dvb_ca_en50221_parse_attributes(struct dvb_ca_private *ca, int slot)
 
 
 	// CISTPL_DEVICE_0A
-	if ((status =
-	     dvb_ca_en50221_read_tuple(ca, slot, &address, &tupleType, &tupleLength, tuple)) < 0)
+	status = dvb_ca_en50221_read_tuple(ca, slot, &address, &tupleType,
+					   &tupleLength, tuple);
+	if (status < 0)
 		return status;
 	if (tupleType != 0x1D)
 		return -EINVAL;
@@ -470,8 +482,9 @@ static int dvb_ca_en50221_parse_attributes(struct dvb_ca_private *ca, int slot)
 
 
 	// CISTPL_DEVICE_0C
-	if ((status =
-	     dvb_ca_en50221_read_tuple(ca, slot, &address, &tupleType, &tupleLength, tuple)) < 0)
+	status = dvb_ca_en50221_read_tuple(ca, slot, &address, &tupleType,
+					   &tupleLength, tuple);
+	if (status < 0)
 		return status;
 	if (tupleType != 0x1C)
 		return -EINVAL;
@@ -479,8 +492,9 @@ static int dvb_ca_en50221_parse_attributes(struct dvb_ca_private *ca, int slot)
 
 
 	// CISTPL_VERS_1
-	if ((status =
-	     dvb_ca_en50221_read_tuple(ca, slot, &address, &tupleType, &tupleLength, tuple)) < 0)
+	status = dvb_ca_en50221_read_tuple(ca, slot, &address, &tupleType,
+					   &tupleLength, tuple);
+	if (status < 0)
 		return status;
 	if (tupleType != 0x15)
 		return -EINVAL;
@@ -488,8 +502,9 @@ static int dvb_ca_en50221_parse_attributes(struct dvb_ca_private *ca, int slot)
 
 
 	// CISTPL_MANFID
-	if ((status = dvb_ca_en50221_read_tuple(ca, slot, &address, &tupleType,
-						&tupleLength, tuple)) < 0)
+	status = dvb_ca_en50221_read_tuple(ca, slot, &address, &tupleType,
+							&tupleLength, tuple);
+	if (status < 0)
 		return status;
 	if (tupleType != 0x20)
 		return -EINVAL;
@@ -501,8 +516,9 @@ static int dvb_ca_en50221_parse_attributes(struct dvb_ca_private *ca, int slot)
 
 
 	// CISTPL_CONFIG
-	if ((status = dvb_ca_en50221_read_tuple(ca, slot, &address, &tupleType,
-						&tupleLength, tuple)) < 0)
+	status = dvb_ca_en50221_read_tuple(ca, slot, &address, &tupleType,
+					   &tupleLength, tuple);
+	if (status < 0)
 		return status;
 	if (tupleType != 0x1A)
 		return -EINVAL;
@@ -535,8 +551,10 @@ static int dvb_ca_en50221_parse_attributes(struct dvb_ca_private *ca, int slot)
 
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
@@ -802,7 +820,8 @@ static int dvb_ca_en50221_write_data(struct dvb_ca_private *ca, int slot,
 	 * already in progress, we do nothing but awake the kernel thread to
 	 * process the data if necessary.
 	 */
-	if ((status = ca->pub->read_cam_control(ca->pub, slot, CTRLIF_STATUS)) < 0)
+	status = ca->pub->read_cam_control(ca->pub, slot, CTRLIF_STATUS);
+	if (status < 0)
 		goto exitnowrite;
 	if (status & (STATUSREG_DA | STATUSREG_RE)) {
 		if (status & STATUSREG_DA)
@@ -813,12 +832,14 @@ static int dvb_ca_en50221_write_data(struct dvb_ca_private *ca, int slot,
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
 	if (!(status & STATUSREG_FR)) {
 		/* it wasn't free => try again later */
@@ -850,20 +871,26 @@ static int dvb_ca_en50221_write_data(struct dvb_ca_private *ca, int slot,
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
 	if (status & STATUSREG_WE) {
 		ca->slot_info[slot].slot_state = DVB_CA_SLOTSTATE_LINKINIT;
@@ -1583,7 +1610,8 @@ static ssize_t dvb_ca_en50221_io_read(struct file *file, char __user *buf,
 		return -EINVAL;
 
 	/* wait for some data */
-	if ((status = dvb_ca_en50221_io_read_condition(ca, &result, &slot)) == 0) {
+	status = dvb_ca_en50221_io_read_condition(ca, &result, &slot);
+	if (status == 0) {
 
 		/* if we're in nonblocking mode, exit immediately */
 		if (file->f_flags & O_NONBLOCK)
@@ -1820,7 +1848,8 @@ int dvb_ca_en50221_init(struct dvb_adapter *dvb_adapter,
 		return -EINVAL;
 
 	/* initialise the system data */
-	if ((ca = kzalloc(sizeof(struct dvb_ca_private), GFP_KERNEL)) == NULL) {
+	ca = kzalloc(sizeof(struct dvb_ca_private), GFP_KERNEL);
+	if (ca == NULL) {
 		ret = -ENOMEM;
 		goto exit;
 	}
@@ -1828,7 +1857,9 @@ int dvb_ca_en50221_init(struct dvb_adapter *dvb_adapter,
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
