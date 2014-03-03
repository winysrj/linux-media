Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49400 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754172AbaCCKH7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Mar 2014 05:07:59 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 41/79] [media] drx-j: Split firmware size check from the main routine
Date: Mon,  3 Mar 2014 07:06:35 -0300
Message-Id: <1393841233-24840-42-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1393841233-24840-1-git-send-email-m.chehab@samsung.com>
References: <1393841233-24840-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The firmware upload routine is already complex enough. Split the
first loop that verifies the firmware size into a separate routine,
making the code more readable.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/dvb-frontends/drx39xyj/drx_driver.c | 215 ++++++++++++----------
 1 file changed, 122 insertions(+), 93 deletions(-)

diff --git a/drivers/media/dvb-frontends/drx39xyj/drx_driver.c b/drivers/media/dvb-frontends/drx39xyj/drx_driver.c
index 194be8344273..94768b16ee92 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drx_driver.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drx_driver.c
@@ -933,6 +933,86 @@ static u16 u_code_compute_crc(u8 *block_data, u16 nr_words)
 
 /*============================================================================*/
 
+
+static int check_firmware(struct drx_demod_instance *demod, u8 *mc_data,
+			  unsigned size)
+{
+	struct drxu_code_block_hdr block_hdr;
+	int i;
+	unsigned count = 2 * sizeof(u16);
+	u32 mc_dev_type, mc_version, mc_base_version;
+	u16 mc_nr_of_blks = u_code_read16(mc_data + sizeof(u16));
+
+	/*
+	 * Scan microcode blocks first for version info
+	 * and firmware check
+	 */
+
+	/* Clear version block */
+	DRX_ATTR_MCRECORD(demod).aux_type = 0;
+	DRX_ATTR_MCRECORD(demod).mc_dev_type = 0;
+	DRX_ATTR_MCRECORD(demod).mc_version = 0;
+	DRX_ATTR_MCRECORD(demod).mc_base_version = 0;
+
+	for (i = 0; i < mc_nr_of_blks; i++) {
+		if (count + 3 * sizeof(u16) + sizeof(u32) > size)
+			goto eof;
+
+		/* Process block header */
+		block_hdr.addr = u_code_read32(mc_data + count);
+		count += sizeof(u32);
+		block_hdr.size = u_code_read16(mc_data + count);
+		count += sizeof(u16);
+		block_hdr.flags = u_code_read16(mc_data + count);
+		count += sizeof(u16);
+		block_hdr.CRC = u_code_read16(mc_data + count);
+		count += sizeof(u16);
+
+		pr_debug("%u: addr %u, size %u, flags 0x%04x, CRC 0x%04x\n",
+			count, block_hdr.addr, block_hdr.size, block_hdr.flags,
+			block_hdr.CRC);
+
+		if (block_hdr.flags & 0x8) {
+			u8 *auxblk = ((void *)mc_data) + block_hdr.addr;
+			u16 auxtype;
+
+			if (block_hdr.addr + sizeof(u16) > size)
+				goto eof;
+
+			auxtype = u_code_read16(auxblk);
+
+			/* Aux block. Check type */
+			if (DRX_ISMCVERTYPE(auxtype)) {
+				if (block_hdr.addr + 2 * sizeof(u16) + 2 * sizeof (u32) > size)
+					goto eof;
+
+				auxblk += sizeof(u16);
+				mc_dev_type = u_code_read32(auxblk);
+				auxblk += sizeof(u32);
+				mc_version = u_code_read32(auxblk);
+				auxblk += sizeof(u32);
+				mc_base_version = u_code_read32(auxblk);
+
+				DRX_ATTR_MCRECORD(demod).aux_type = auxtype;
+				DRX_ATTR_MCRECORD(demod).mc_dev_type = mc_dev_type;
+				DRX_ATTR_MCRECORD(demod).mc_version = mc_version;
+				DRX_ATTR_MCRECORD(demod).mc_base_version = mc_base_version;
+
+				pr_info("Firmware dev %x, ver %x, base ver %x\n",
+					mc_dev_type, mc_version, mc_base_version);
+
+			}
+		} else if (count + block_hdr.size * sizeof(u16) > size)
+			goto eof;
+
+		count += block_hdr.size * sizeof(u16);
+	}
+	return 0;
+eof:
+	pr_err("Firmware is truncated at pos %u/%u\n", count, size);
+	return -EINVAL;
+}
+
 /**
 * \brief Handle microcode upload or verify.
 * \param dev_addr: Address of device.
@@ -962,24 +1042,15 @@ ctrl_u_code(struct drx_demod_instance *demod,
 	u16 mc_magic_word = 0;
 	const u8 *mc_data_init = NULL;
 	u8 *mc_data = NULL;
+	unsigned size;
 	char *mc_file = mc_info->mc_file;
 
 	/* Check arguments */
 	if (!mc_info || !mc_file)
 		return -EINVAL;
 
-	if (demod->firmware) {
-		mc_data_init = demod->firmware->data;
-		mc_data = (void *)mc_data_init;
-
-		/* Check data */
-		mc_magic_word = u_code_read16(mc_data);
-		mc_data += sizeof(u16);
-		mc_nr_of_blks = u_code_read16(mc_data);
-		mc_data += sizeof(u16);
-	} else {
+	if (!demod->firmware) {
 		const struct firmware *fw = NULL;
-		unsigned size = 0;
 
 		rc = request_firmware(&fw, mc_file, demod->i2c->dev.parent);
 		if (rc < 0) {
@@ -987,95 +1058,49 @@ ctrl_u_code(struct drx_demod_instance *demod,
 			return -ENOENT;
 		}
 		demod->firmware = fw;
-		mc_data_init = demod->firmware->data;
-		size = demod->firmware->size;
-
-		pr_info("Firmware %s, size %u\n", mc_file, size);
-
-		mc_data = (void *)mc_data_init;
-		/* Check data */
-		if (mc_data - mc_data_init + 2 * sizeof(u16) > size)
-			goto eof;
-		mc_magic_word = u_code_read16(mc_data);
-		mc_data += sizeof(u16);
-		mc_nr_of_blks = u_code_read16(mc_data);
-		mc_data += sizeof(u16);
-
 
-		if ((mc_magic_word != DRX_UCODE_MAGIC_WORD) || (mc_nr_of_blks == 0)) {
-			rc = -EINVAL;		/* wrong endianess or wrong data ? */
-			pr_err("Firmware magic word doesn't match\n");
+		if (demod->firmware->size < 2 * sizeof(u16)) {
+			rc = -EINVAL;
+			pr_err("Firmware is too short!\n");
 			goto release;
 		}
 
-		/*
-		 * Scan microcode blocks first for version info
-		 * and firmware check
-		 */
-
-		/* Clear version block */
-		DRX_ATTR_MCRECORD(demod).aux_type = 0;
-		DRX_ATTR_MCRECORD(demod).mc_dev_type = 0;
-		DRX_ATTR_MCRECORD(demod).mc_version = 0;
-		DRX_ATTR_MCRECORD(demod).mc_base_version = 0;
-		for (i = 0; i < mc_nr_of_blks; i++) {
-			struct drxu_code_block_hdr block_hdr;
-
-			if (mc_data - mc_data_init +
-			    3 * sizeof(u16) + sizeof(u32) > size)
-				goto eof;
-			/* Process block header */
-			block_hdr.addr = u_code_read32(mc_data);
-			mc_data += sizeof(u32);
-			block_hdr.size = u_code_read16(mc_data);
-			mc_data += sizeof(u16);
-			block_hdr.flags = u_code_read16(mc_data);
-			mc_data += sizeof(u16);
-			block_hdr.CRC = u_code_read16(mc_data);
-			mc_data += sizeof(u16);
-
-			if (block_hdr.flags & 0x8) {
-				u8 *auxblk = ((void *)mc_data_init) + block_hdr.addr;
-				u16 auxtype;
-
-				if (mc_data - mc_data_init + sizeof(u16) +
-				    2 * sizeof(u32) > size)
-					goto eof;
+		pr_info("Firmware %s, size %zu\n",
+			mc_file, demod->firmware->size);
+	}
 
-				/* Aux block. Check type */
-				auxtype = u_code_read16(auxblk);
-				if (DRX_ISMCVERTYPE(auxtype)) {
-					DRX_ATTR_MCRECORD(demod).aux_type = u_code_read16(auxblk);
-					auxblk += sizeof(u16);
-					DRX_ATTR_MCRECORD(demod).mc_dev_type = u_code_read32(auxblk);
-					auxblk += sizeof(u32);
-					DRX_ATTR_MCRECORD(demod).mc_version = u_code_read32(auxblk);
-					auxblk += sizeof(u32);
-					DRX_ATTR_MCRECORD(demod).mc_base_version = u_code_read32(auxblk);
-				}
-			}
-			if (mc_data - mc_data_init +
-			    block_hdr.size * sizeof(u16) > size)
-				goto eof;
+	mc_data_init = demod->firmware->data;
+	size = demod->firmware->size;
 
-			/* Next block */
-			mc_data += block_hdr.size * sizeof(u16);
-		}
+	mc_data = (void *)mc_data_init;
+	/* Check data */
+	mc_magic_word = u_code_read16(mc_data);
+	mc_data += sizeof(u16);
+	mc_nr_of_blks = u_code_read16(mc_data);
+	mc_data += sizeof(u16);
 
-		/* Restore data pointer */
-		mc_data = ((void *)mc_data_init) + 2 * sizeof(u16);
+	if ((mc_magic_word != DRX_UCODE_MAGIC_WORD) || (mc_nr_of_blks == 0)) {
+		rc = -EINVAL;
+		pr_err("Firmware magic word doesn't match\n");
+		goto release;
 	}
 
 	if (action == UCODE_UPLOAD) {
+		rc = check_firmware(demod, (u8 *)mc_data_init, size);
+		if (rc)
+			goto release;
+
 		/* After scanning, validate the microcode.
 		   It is also valid if no validation control exists.
 		 */
 		rc = drx_ctrl(demod, DRX_CTRL_VALIDATE_UCODE, NULL);
 		if (rc != 0 && rc != -ENOTSUPP) {
 			pr_err("Validate ucode not supported\n");
-			goto release;
+			return rc;
 		}
 		pr_info("Uploading firmware %s\n", mc_file);
+	} else if (action == UCODE_VERIFY) {
+		pr_info("Verifying if firmware upload was ok.\n");
 	}
 
 	/* Process microcode blocks */
@@ -1093,6 +1118,10 @@ ctrl_u_code(struct drx_demod_instance *demod,
 		block_hdr.CRC = u_code_read16(mc_data);
 		mc_data += sizeof(u16);
 
+		pr_debug("%u: addr %u, size %u, flags 0x%04x, CRC 0x%04x\n",
+			(unsigned)(mc_data - mc_data_init), block_hdr.addr,
+			 block_hdr.size, block_hdr.flags, block_hdr.CRC);
+
 		/* Check block header on:
 		   - data larger than 64Kb
 		   - if CRC enabled check CRC
@@ -1114,17 +1143,18 @@ ctrl_u_code(struct drx_demod_instance *demod,
 
 		/* Perform the desired action */
 		switch (action) {
-		case UCODE_UPLOAD:
-			/* Upload microcode */
+		case UCODE_UPLOAD:	/* Upload microcode */
 			if (demod->my_access_funct->write_block_func(dev_addr,
 							block_hdr.addr,
 							mc_block_nr_bytes,
 							mc_data, 0x0000)) {
-				pr_err("error writing firmware\n");
+				rc = -EIO;
+				pr_err("error writing firmware at pos %u\n",
+				       (unsigned)(mc_data - mc_data_init));
 				goto release;
 			}
 			break;
-		case UCODE_VERIFY: {
+		case UCODE_VERIFY: {	/* Verify uploaded microcode */
 			int result = 0;
 			u8 mc_data_buffer[DRX_UCODE_MAX_BUF_SIZE];
 			u32 bytes_to_comp = 0;
@@ -1144,8 +1174,9 @@ ctrl_u_code(struct drx_demod_instance *demod,
 						    (u16)bytes_to_comp,
 						    (u8 *)mc_data_buffer,
 						    0x0000)) {
-					pr_err("error reading firmware\n");
-					goto release;
+					pr_err("error reading firmware at pos %u\n",
+					       (unsigned)(mc_data - mc_data_init));
+					return -EIO;
 				}
 
 				result =drxbsp_hst_memcmp(curr_ptr,
@@ -1153,7 +1184,8 @@ ctrl_u_code(struct drx_demod_instance *demod,
 							  bytes_to_comp);
 
 				if (result) {
-					pr_err("error verifying firmware\n");
+					pr_err("error verifying firmware at pos %u\n",
+					       (unsigned)(mc_data - mc_data_init));
 					return -EIO;
 				}
 
@@ -1172,10 +1204,7 @@ ctrl_u_code(struct drx_demod_instance *demod,
 	}
 
 	return 0;
-eof:
-	rc = -ENOENT;
-	pr_err("Firmware file %s is truncated at pos %lu\n",
-	       mc_file, (unsigned long)(mc_data - mc_data_init));
+
 release:
 	release_firmware(demod->firmware);
 	demod->firmware = NULL;
-- 
1.8.5.3

