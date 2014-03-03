Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49392 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754130AbaCCKH6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Mar 2014 05:07:58 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 44/79] [media] drx-j: get rid of its own be??_to_cpu() implementation
Date: Mon,  3 Mar 2014 07:06:38 -0300
Message-Id: <1393841233-24840-45-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1393841233-24840-1-git-send-email-m.chehab@samsung.com>
References: <1393841233-24840-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of handling endiannes with its own internal way, use the
already existing macros.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/dvb-frontends/drx39xyj/drx_driver.c | 86 +++++------------------
 1 file changed, 16 insertions(+), 70 deletions(-)

diff --git a/drivers/media/dvb-frontends/drx39xyj/drx_driver.c b/drivers/media/dvb-frontends/drx39xyj/drx_driver.c
index c144fb7080cf..0803298b89bf 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drx_driver.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drx_driver.c
@@ -134,62 +134,8 @@ FUNCTIONS
 ------------------------------------------------------------------------------*/
 
 /*============================================================================*/
-/*============================================================================*/
 /*===Microcode related functions==============================================*/
 /*============================================================================*/
-/*============================================================================*/
-
-/**
-* \brief Read a 16 bits word, expects big endian data.
-* \param addr: Pointer to memory from which to read the 16 bits word.
-* \return u16 The data read.
-*
-* This function takes care of the possible difference in endianness between the
-* host and the data contained in the microcode image file.
-*
-*/
-static u16 u_code_read16(u8 *addr)
-{
-	/* Works fo any host processor */
-
-	u16 word = 0;
-
-	word = ((u16) addr[0]);
-	word <<= 8;
-	word |= ((u16) addr[1]);
-
-	return word;
-}
-
-/*============================================================================*/
-
-/**
-* \brief Read a 32 bits word, expects big endian data.
-* \param addr: Pointer to memory from which to read the 32 bits word.
-* \return u32 The data read.
-*
-* This function takes care of the possible difference in endianness between the
-* host and the data contained in the microcode image file.
-*
-*/
-static u32 u_code_read32(u8 *addr)
-{
-	/* Works fo any host processor */
-
-	u32 word = 0;
-
-	word = ((u16) addr[0]);
-	word <<= 8;
-	word |= ((u16) addr[1]);
-	word <<= 8;
-	word |= ((u16) addr[2]);
-	word <<= 8;
-	word |= ((u16) addr[3]);
-
-	return word;
-}
-
-/*============================================================================*/
 
 /**
 * \brief Compute CRC of block of microcode data.
@@ -205,7 +151,7 @@ static u16 u_code_compute_crc(u8 *block_data, u16 nr_words)
 	u32 carry = 0;
 
 	while (i < nr_words) {
-		crc_word |= (u32) u_code_read16(block_data);
+		crc_word |= (u32) be16_to_cpu(*(u32 *)(block_data));
 		for (j = 0; j < 16; j++) {
 			crc_word <<= 1;
 			if (carry != 0)
@@ -228,7 +174,7 @@ static int check_firmware(struct drx_demod_instance *demod, u8 *mc_data,
 	int i;
 	unsigned count = 2 * sizeof(u16);
 	u32 mc_dev_type, mc_version, mc_base_version;
-	u16 mc_nr_of_blks = u_code_read16(mc_data + sizeof(u16));
+	u16 mc_nr_of_blks = be16_to_cpu(*(u32 *)(mc_data + sizeof(u16)));
 
 	/*
 	 * Scan microcode blocks first for version info
@@ -246,13 +192,13 @@ static int check_firmware(struct drx_demod_instance *demod, u8 *mc_data,
 			goto eof;
 
 		/* Process block header */
-		block_hdr.addr = u_code_read32(mc_data + count);
+		block_hdr.addr = be32_to_cpu(*(u32 *)(mc_data + count));
 		count += sizeof(u32);
-		block_hdr.size = u_code_read16(mc_data + count);
+		block_hdr.size = be16_to_cpu(*(u32 *)(mc_data + count));
 		count += sizeof(u16);
-		block_hdr.flags = u_code_read16(mc_data + count);
+		block_hdr.flags = be16_to_cpu(*(u32 *)(mc_data + count));
 		count += sizeof(u16);
-		block_hdr.CRC = u_code_read16(mc_data + count);
+		block_hdr.CRC = be16_to_cpu(*(u32 *)(mc_data + count));
 		count += sizeof(u16);
 
 		pr_debug("%u: addr %u, size %u, flags 0x%04x, CRC 0x%04x\n",
@@ -266,7 +212,7 @@ static int check_firmware(struct drx_demod_instance *demod, u8 *mc_data,
 			if (block_hdr.addr + sizeof(u16) > size)
 				goto eof;
 
-			auxtype = u_code_read16(auxblk);
+			auxtype = be16_to_cpu(*(u32 *)(auxblk));
 
 			/* Aux block. Check type */
 			if (DRX_ISMCVERTYPE(auxtype)) {
@@ -274,11 +220,11 @@ static int check_firmware(struct drx_demod_instance *demod, u8 *mc_data,
 					goto eof;
 
 				auxblk += sizeof(u16);
-				mc_dev_type = u_code_read32(auxblk);
+				mc_dev_type = be32_to_cpu(*(u32 *)(auxblk));
 				auxblk += sizeof(u32);
-				mc_version = u_code_read32(auxblk);
+				mc_version = be32_to_cpu(*(u32 *)(auxblk));
 				auxblk += sizeof(u32);
-				mc_base_version = u_code_read32(auxblk);
+				mc_base_version = be32_to_cpu(*(u32 *)(auxblk));
 
 				DRX_ATTR_MCRECORD(demod).aux_type = auxtype;
 				DRX_ATTR_MCRECORD(demod).mc_dev_type = mc_dev_type;
@@ -361,9 +307,9 @@ ctrl_u_code(struct drx_demod_instance *demod,
 
 	mc_data = (void *)mc_data_init;
 	/* Check data */
-	mc_magic_word = u_code_read16(mc_data);
+	mc_magic_word = be16_to_cpu(*(u32 *)(mc_data));
 	mc_data += sizeof(u16);
-	mc_nr_of_blks = u_code_read16(mc_data);
+	mc_nr_of_blks = be16_to_cpu(*(u32 *)(mc_data));
 	mc_data += sizeof(u16);
 
 	if ((mc_magic_word != DRX_UCODE_MAGIC_WORD) || (mc_nr_of_blks == 0)) {
@@ -396,13 +342,13 @@ ctrl_u_code(struct drx_demod_instance *demod,
 		u16 mc_block_nr_bytes = 0;
 
 		/* Process block header */
-		block_hdr.addr = u_code_read32(mc_data);
+		block_hdr.addr = be32_to_cpu(*(u32 *)(mc_data));
 		mc_data += sizeof(u32);
-		block_hdr.size = u_code_read16(mc_data);
+		block_hdr.size = be16_to_cpu(*(u32 *)(mc_data));
 		mc_data += sizeof(u16);
-		block_hdr.flags = u_code_read16(mc_data);
+		block_hdr.flags = be16_to_cpu(*(u32 *)(mc_data));
 		mc_data += sizeof(u16);
-		block_hdr.CRC = u_code_read16(mc_data);
+		block_hdr.CRC = be16_to_cpu(*(u32 *)(mc_data));
 		mc_data += sizeof(u16);
 
 		pr_debug("%u: addr %u, size %u, flags 0x%04x, CRC 0x%04x\n",
-- 
1.8.5.3

