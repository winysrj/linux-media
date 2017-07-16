Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.anw.at ([195.234.101.228]:46242 "EHLO mail.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751248AbdGPAni (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 15 Jul 2017 20:43:38 -0400
From: "Jasmin J." <jasmin@anw.at>
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, max.kellermann@gmail.com,
        rjkm@metzlerbros.de, d.scheller@gmx.net, crope@iki.fi,
        jasmin@anw.at
Subject: [PATCH V3 05/16] [media] dvb-core/dvb_ca_en50221.c: Avoid assignments in ifs
Date: Sun, 16 Jul 2017 02:43:06 +0200
Message-Id: <1500165797-16987-6-git-send-email-jasmin@anw.at>
In-Reply-To: <1500165797-16987-1-git-send-email-jasmin@anw.at>
References: <1500165797-16987-1-git-send-email-jasmin@anw.at>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jasmin Jessich <jasmin@anw.at>

Fixed all:
  ERROR: do not use assignment in if condition

Fixed also "-strict" checks in this patch:
- Changed "if (ret != 0)" to "if (ret)".
- Camel case variables have been converted to kernel_case.
- Comparison to NULL written as "!<var>".
- No space is necessary after a cast.

Signed-off-by: Jasmin Jessich <jasmin@anw.at>
---
 drivers/media/dvb-core/dvb_ca_en50221.c | 166 +++++++++++++++++++-------------
 1 file changed, 100 insertions(+), 66 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_ca_en50221.c b/drivers/media/dvb-core/dvb_ca_en50221.c
index 28e6102..d06cdc7 100644
--- a/drivers/media/dvb-core/dvb_ca_en50221.c
+++ b/drivers/media/dvb-core/dvb_ca_en50221.c
@@ -349,14 +349,18 @@ static int dvb_ca_en50221_link_init(struct dvb_ca_private *ca, int slot)
 	ca->slot_info[slot].link_buf_size = 2;
 
 	/* read the buffer size from the CAM */
-	if ((ret = ca->pub->write_cam_control(ca->pub, slot, CTRLIF_COMMAND, IRQEN | CMDREG_SR)) != 0)
+	ret = ca->pub->write_cam_control(ca->pub, slot, CTRLIF_COMMAND,
+					 IRQEN | CMDREG_SR);
+	if (ret)
 		return ret;
 	ret = dvb_ca_en50221_wait_if_status(ca, slot, STATUSREG_DA, HZ);
-	if (ret != 0)
+	if (ret)
 		return ret;
-	if ((ret = dvb_ca_en50221_read_data(ca, slot, buf, 2)) != 2)
+	ret = dvb_ca_en50221_read_data(ca, slot, buf, 2);
+	if (ret != 2)
 		return -EIO;
-	if ((ret = ca->pub->write_cam_control(ca->pub, slot, CTRLIF_COMMAND, IRQEN)) != 0)
+	ret = ca->pub->write_cam_control(ca->pub, slot, CTRLIF_COMMAND, IRQEN);
+	if (ret)
 		return ret;
 
 	/* store it, and choose the minimum of our buffer and the CAM's buffer size */
@@ -369,13 +373,18 @@ static int dvb_ca_en50221_link_init(struct dvb_ca_private *ca, int slot)
 	dprintk("Chosen link buffer size of %i\n", buf_size);
 
 	/* write the buffer size to the CAM */
-	if ((ret = ca->pub->write_cam_control(ca->pub, slot, CTRLIF_COMMAND, IRQEN | CMDREG_SW)) != 0)
+	ret = ca->pub->write_cam_control(ca->pub, slot, CTRLIF_COMMAND,
+					 IRQEN | CMDREG_SW);
+	if (ret)
 		return ret;
-	if ((ret = dvb_ca_en50221_wait_if_status(ca, slot, STATUSREG_FR, HZ / 10)) != 0)
+	ret = dvb_ca_en50221_wait_if_status(ca, slot, STATUSREG_FR, HZ / 10);
+	if (ret)
 		return ret;
-	if ((ret = dvb_ca_en50221_write_data(ca, slot, buf, 2)) != 2)
+	ret = dvb_ca_en50221_write_data(ca, slot, buf, 2);
+	if (ret != 2)
 		return -EIO;
-	if ((ret = ca->pub->write_cam_control(ca->pub, slot, CTRLIF_COMMAND, IRQEN)) != 0)
+	ret = ca->pub->write_cam_control(ca->pub, slot, CTRLIF_COMMAND, IRQEN);
+	if (ret)
 		return ret;
 
 	/* success */
@@ -395,42 +404,45 @@ static int dvb_ca_en50221_link_init(struct dvb_ca_private *ca, int slot)
  * @return 0 on success, nonzero on error.
  */
 static int dvb_ca_en50221_read_tuple(struct dvb_ca_private *ca, int slot,
-				     int *address, int *tupleType,
-				     int *tupleLength, u8 *tuple)
+				     int *address, int *tuple_type,
+				     int *tuple_length, u8 *tuple)
 {
 	int i;
-	int _tupleType;
-	int _tupleLength;
+	int _tuple_type;
+	int _tuple_length;
 	int _address = *address;
 
 	/* grab the next tuple length and type */
-	if ((_tupleType = ca->pub->read_attribute_mem(ca->pub, slot, _address)) < 0)
-		return _tupleType;
-	if (_tupleType == 0xff) {
-		dprintk("END OF CHAIN TUPLE type:0x%x\n", _tupleType);
+	_tuple_type = ca->pub->read_attribute_mem(ca->pub, slot, _address);
+	if (_tuple_type < 0)
+		return _tuple_type;
+	if (_tuple_type == 0xff) {
+		dprintk("END OF CHAIN TUPLE type:0x%x\n", _tuple_type);
 		*address += 2;
-		*tupleType = _tupleType;
-		*tupleLength = 0;
+		*tuple_type = _tuple_type;
+		*tuple_length = 0;
 		return 0;
 	}
-	if ((_tupleLength = ca->pub->read_attribute_mem(ca->pub, slot, _address + 2)) < 0)
-		return _tupleLength;
+	_tuple_length = ca->pub->read_attribute_mem(ca->pub, slot,
+						    _address + 2);
+	if (_tuple_length < 0)
+		return _tuple_length;
 	_address += 4;
 
-	dprintk("TUPLE type:0x%x length:%i\n", _tupleType, _tupleLength);
+	dprintk("TUPLE type:0x%x length:%i\n", _tuple_type, _tuple_length);
 
 	/* read in the whole tuple */
-	for (i = 0; i < _tupleLength; i++) {
+	for (i = 0; i < _tuple_length; i++) {
 		tuple[i] = ca->pub->read_attribute_mem(ca->pub, slot, _address + (i * 2));
 		dprintk("  0x%02x: 0x%02x %c\n",
 			i, tuple[i] & 0xff,
 			((tuple[i] > 31) && (tuple[i] < 127)) ? tuple[i] : '.');
 	}
-	_address += (_tupleLength * 2);
+	_address += (_tuple_length * 2);
 
 	// success
-	*tupleType = _tupleType;
-	*tupleLength = _tupleLength;
+	*tuple_type = _tuple_type;
+	*tuple_length = _tuple_length;
 	*address = _address;
 	return 0;
 }
@@ -448,8 +460,8 @@ static int dvb_ca_en50221_read_tuple(struct dvb_ca_private *ca, int slot,
 static int dvb_ca_en50221_parse_attributes(struct dvb_ca_private *ca, int slot)
 {
 	int address = 0;
-	int tupleLength;
-	int tupleType;
+	int tuple_length;
+	int tuple_type;
 	u8 tuple[257];
 	char *dvb_str;
 	int rasz;
@@ -462,39 +474,43 @@ static int dvb_ca_en50221_parse_attributes(struct dvb_ca_private *ca, int slot)
 
 
 	// CISTPL_DEVICE_0A
-	if ((status =
-	     dvb_ca_en50221_read_tuple(ca, slot, &address, &tupleType, &tupleLength, tuple)) < 0)
+	status = dvb_ca_en50221_read_tuple(ca, slot, &address, &tuple_type,
+					   &tuple_length, tuple);
+	if (status < 0)
 		return status;
-	if (tupleType != 0x1D)
+	if (tuple_type != 0x1D)
 		return -EINVAL;
 
 
 
 	// CISTPL_DEVICE_0C
-	if ((status =
-	     dvb_ca_en50221_read_tuple(ca, slot, &address, &tupleType, &tupleLength, tuple)) < 0)
+	status = dvb_ca_en50221_read_tuple(ca, slot, &address, &tuple_type,
+					   &tuple_length, tuple);
+	if (status < 0)
 		return status;
-	if (tupleType != 0x1C)
+	if (tuple_type != 0x1C)
 		return -EINVAL;
 
 
 
 	// CISTPL_VERS_1
-	if ((status =
-	     dvb_ca_en50221_read_tuple(ca, slot, &address, &tupleType, &tupleLength, tuple)) < 0)
+	status = dvb_ca_en50221_read_tuple(ca, slot, &address, &tuple_type,
+					   &tuple_length, tuple);
+	if (status < 0)
 		return status;
-	if (tupleType != 0x15)
+	if (tuple_type != 0x15)
 		return -EINVAL;
 
 
 
 	// CISTPL_MANFID
-	if ((status = dvb_ca_en50221_read_tuple(ca, slot, &address, &tupleType,
-						&tupleLength, tuple)) < 0)
+	status = dvb_ca_en50221_read_tuple(ca, slot, &address, &tuple_type,
+					   &tuple_length, tuple);
+	if (status < 0)
 		return status;
-	if (tupleType != 0x20)
+	if (tuple_type != 0x20)
 		return -EINVAL;
-	if (tupleLength != 4)
+	if (tuple_length != 4)
 		return -EINVAL;
 	manfid = (tuple[1] << 8) | tuple[0];
 	devid = (tuple[3] << 8) | tuple[2];
@@ -502,17 +518,18 @@ static int dvb_ca_en50221_parse_attributes(struct dvb_ca_private *ca, int slot)
 
 
 	// CISTPL_CONFIG
-	if ((status = dvb_ca_en50221_read_tuple(ca, slot, &address, &tupleType,
-						&tupleLength, tuple)) < 0)
+	status = dvb_ca_en50221_read_tuple(ca, slot, &address, &tuple_type,
+					   &tuple_length, tuple);
+	if (status < 0)
 		return status;
-	if (tupleType != 0x1A)
+	if (tuple_type != 0x1A)
 		return -EINVAL;
-	if (tupleLength < 3)
+	if (tuple_length < 3)
 		return -EINVAL;
 
 	/* extract the configbase */
 	rasz = tuple[0] & 3;
-	if (tupleLength < (3 + rasz + 14))
+	if (tuple_length < (3 + rasz + 14))
 		return -EINVAL;
 	ca->slot_info[slot].config_base = 0;
 	for (i = 0; i < rasz + 1; i++) {
@@ -520,10 +537,10 @@ static int dvb_ca_en50221_parse_attributes(struct dvb_ca_private *ca, int slot)
 	}
 
 	/* check it contains the correct DVB string */
-	dvb_str = findstr((char *)tuple, tupleLength, "DVB_CI_V", 8);
+	dvb_str = findstr((char *)tuple, tuple_length, "DVB_CI_V", 8);
 	if (dvb_str == NULL)
 		return -EINVAL;
-	if (tupleLength < ((dvb_str - (char *) tuple) + 12))
+	if (tuple_length < ((dvb_str - (char *)tuple) + 12))
 		return -EINVAL;
 
 	/* is it a version we support? */
@@ -536,12 +553,14 @@ static int dvb_ca_en50221_parse_attributes(struct dvb_ca_private *ca, int slot)
 
 	/* process the CFTABLE_ENTRY tuples, and any after those */
 	while ((!end_chain) && (address < 0x1000)) {
-		if ((status = dvb_ca_en50221_read_tuple(ca, slot, &address, &tupleType,
-							&tupleLength, tuple)) < 0)
+		status = dvb_ca_en50221_read_tuple(ca, slot, &address,
+						   &tuple_type, &tuple_length,
+						   tuple);
+		if (status < 0)
 			return status;
-		switch (tupleType) {
+		switch (tuple_type) {
 		case 0x1B:	// CISTPL_CFTABLE_ENTRY
-			if (tupleLength < (2 + 11 + 17))
+			if (tuple_length < (2 + 11 + 17))
 				break;
 
 			/* if we've already parsed one, just use it */
@@ -552,8 +571,10 @@ static int dvb_ca_en50221_parse_attributes(struct dvb_ca_private *ca, int slot)
 			ca->slot_info[slot].config_option = tuple[0] & 0x3f;
 
 			/* OK, check it contains the correct strings */
-			if ((findstr((char *)tuple, tupleLength, "DVB_HOST", 8) == NULL) ||
-			    (findstr((char *)tuple, tupleLength, "DVB_CI_MODULE", 13) == NULL))
+			if (!findstr((char *)tuple, tuple_length,
+				     "DVB_HOST", 8) ||
+			    !findstr((char *)tuple, tuple_length,
+				     "DVB_CI_MODULE", 13))
 				break;
 
 			got_cftableentry = 1;
@@ -568,7 +589,7 @@ static int dvb_ca_en50221_parse_attributes(struct dvb_ca_private *ca, int slot)
 
 		default:	/* Unknown tuple type - just skip this tuple and move to the next one */
 			dprintk("dvb_ca: Skipping unknown tuple type:0x%x length:0x%x\n",
-				tupleType, tupleLength);
+				tuple_type, tuple_length);
 			break;
 		}
 	}
@@ -804,7 +825,8 @@ static int dvb_ca_en50221_write_data(struct dvb_ca_private *ca, int slot,
 	 * already in progress, we do nothing but awake the kernel thread to
 	 * process the data if necessary.
 	 */
-	if ((status = ca->pub->read_cam_control(ca->pub, slot, CTRLIF_STATUS)) < 0)
+	status = ca->pub->read_cam_control(ca->pub, slot, CTRLIF_STATUS);
+	if (status < 0)
 		goto exitnowrite;
 	if (status & (STATUSREG_DA | STATUSREG_RE)) {
 		if (status & STATUSREG_DA)
@@ -815,12 +837,14 @@ static int dvb_ca_en50221_write_data(struct dvb_ca_private *ca, int slot,
 	}
 
 	/* OK, set HC bit */
-	if ((status = ca->pub->write_cam_control(ca->pub, slot, CTRLIF_COMMAND,
-						 IRQEN | CMDREG_HC)) != 0)
+	status = ca->pub->write_cam_control(ca->pub, slot, CTRLIF_COMMAND,
+					    IRQEN | CMDREG_HC);
+	if (status)
 		goto exit;
 
 	/* check if interface is still free */
-	if ((status = ca->pub->read_cam_control(ca->pub, slot, CTRLIF_STATUS)) < 0)
+	status = ca->pub->read_cam_control(ca->pub, slot, CTRLIF_STATUS);
+	if (status < 0)
 		goto exit;
 	if (!(status & STATUSREG_FR)) {
 		/* it wasn't free => try again later */
@@ -852,20 +876,26 @@ static int dvb_ca_en50221_write_data(struct dvb_ca_private *ca, int slot,
 	}
 
 	/* send the amount of data */
-	if ((status = ca->pub->write_cam_control(ca->pub, slot, CTRLIF_SIZE_HIGH, bytes_write >> 8)) != 0)
+	status = ca->pub->write_cam_control(ca->pub, slot, CTRLIF_SIZE_HIGH,
+					    bytes_write >> 8);
+	if (status)
 		goto exit;
-	if ((status = ca->pub->write_cam_control(ca->pub, slot, CTRLIF_SIZE_LOW,
-						 bytes_write & 0xff)) != 0)
+	status = ca->pub->write_cam_control(ca->pub, slot, CTRLIF_SIZE_LOW,
+					    bytes_write & 0xff);
+	if (status)
 		goto exit;
 
 	/* send the buffer */
 	for (i = 0; i < bytes_write; i++) {
-		if ((status = ca->pub->write_cam_control(ca->pub, slot, CTRLIF_DATA, buf[i])) != 0)
+		status = ca->pub->write_cam_control(ca->pub, slot, CTRLIF_DATA,
+						    buf[i]);
+		if (status)
 			goto exit;
 	}
 
 	/* check for write error (WE should now be 0) */
-	if ((status = ca->pub->read_cam_control(ca->pub, slot, CTRLIF_STATUS)) < 0)
+	status = ca->pub->read_cam_control(ca->pub, slot, CTRLIF_STATUS);
+	if (status < 0)
 		goto exit;
 	if (status & STATUSREG_WE) {
 		ca->slot_info[slot].slot_state = DVB_CA_SLOTSTATE_LINKINIT;
@@ -1591,7 +1621,8 @@ static ssize_t dvb_ca_en50221_io_read(struct file *file, char __user *buf,
 		return -EINVAL;
 
 	/* wait for some data */
-	if ((status = dvb_ca_en50221_io_read_condition(ca, &result, &slot)) == 0) {
+	status = dvb_ca_en50221_io_read_condition(ca, &result, &slot);
+	if (status == 0) {
 
 		/* if we're in nonblocking mode, exit immediately */
 		if (file->f_flags & O_NONBLOCK)
@@ -1829,7 +1860,8 @@ int dvb_ca_en50221_init(struct dvb_adapter *dvb_adapter,
 		return -EINVAL;
 
 	/* initialise the system data */
-	if ((ca = kzalloc(sizeof(struct dvb_ca_private), GFP_KERNEL)) == NULL) {
+	ca = kzalloc(sizeof(*ca), GFP_KERNEL);
+	if (!ca) {
 		ret = -ENOMEM;
 		goto exit;
 	}
@@ -1837,7 +1869,9 @@ int dvb_ca_en50221_init(struct dvb_adapter *dvb_adapter,
 	ca->pub = pubca;
 	ca->flags = flags;
 	ca->slot_count = slot_count;
-	if ((ca->slot_info = kcalloc(slot_count, sizeof(struct dvb_ca_slot), GFP_KERNEL)) == NULL) {
+	ca->slot_info = kcalloc(slot_count, sizeof(struct dvb_ca_slot),
+				GFP_KERNEL);
+	if (!ca->slot_info) {
 		ret = -ENOMEM;
 		goto free_ca;
 	}
-- 
2.7.4
