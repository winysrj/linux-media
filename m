Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:3280 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753257AbaHTW7p (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Aug 2014 18:59:45 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 15/29] drxj: fix sparse warnings
Date: Thu, 21 Aug 2014 00:59:14 +0200
Message-Id: <1408575568-20562-16-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1408575568-20562-1-git-send-email-hverkuil@xs4all.nl>
References: <1408575568-20562-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

drivers/media/dvb-frontends/drx39xyj/drxj.c:11768:25: warning: cast to restricted __be16
drivers/media/dvb-frontends/drx39xyj/drxj.c:11768:25: warning: cast to restricted __be16
drivers/media/dvb-frontends/drx39xyj/drxj.c:11768:25: warning: cast to restricted __be16
drivers/media/dvb-frontends/drx39xyj/drxj.c:11768:25: warning: cast to restricted __be16
drivers/media/dvb-frontends/drx39xyj/drxj.c:11770:25: warning: cast to restricted __be16
drivers/media/dvb-frontends/drx39xyj/drxj.c:11770:25: warning: cast to restricted __be16
drivers/media/dvb-frontends/drx39xyj/drxj.c:11770:25: warning: cast to restricted __be16
drivers/media/dvb-frontends/drx39xyj/drxj.c:11770:25: warning: cast to restricted __be16
drivers/media/dvb-frontends/drx39xyj/drxj.c:11794:34: warning: cast to restricted __be32
drivers/media/dvb-frontends/drx39xyj/drxj.c:11794:34: warning: cast to restricted __be32
drivers/media/dvb-frontends/drx39xyj/drxj.c:11794:34: warning: cast to restricted __be32
drivers/media/dvb-frontends/drx39xyj/drxj.c:11794:34: warning: cast to restricted __be32
drivers/media/dvb-frontends/drx39xyj/drxj.c:11794:34: warning: cast to restricted __be32
drivers/media/dvb-frontends/drx39xyj/drxj.c:11794:34: warning: cast to restricted __be32
drivers/media/dvb-frontends/drx39xyj/drxj.c:11796:34: warning: cast to restricted __be16
drivers/media/dvb-frontends/drx39xyj/drxj.c:11796:34: warning: cast to restricted __be16
drivers/media/dvb-frontends/drx39xyj/drxj.c:11796:34: warning: cast to restricted __be16
drivers/media/dvb-frontends/drx39xyj/drxj.c:11796:34: warning: cast to restricted __be16
drivers/media/dvb-frontends/drx39xyj/drxj.c:11798:35: warning: cast to restricted __be16
drivers/media/dvb-frontends/drx39xyj/drxj.c:11798:35: warning: cast to restricted __be16
drivers/media/dvb-frontends/drx39xyj/drxj.c:11798:35: warning: cast to restricted __be16
drivers/media/dvb-frontends/drx39xyj/drxj.c:11798:35: warning: cast to restricted __be16
drivers/media/dvb-frontends/drx39xyj/drxj.c:11800:33: warning: cast to restricted __be16
drivers/media/dvb-frontends/drx39xyj/drxj.c:11800:33: warning: cast to restricted __be16
drivers/media/dvb-frontends/drx39xyj/drxj.c:11800:33: warning: cast to restricted __be16
drivers/media/dvb-frontends/drx39xyj/drxj.c:11800:33: warning: cast to restricted __be16
drivers/media/dvb-frontends/drx39xyj/drxj.c:11605:34: warning: cast to restricted __be16
drivers/media/dvb-frontends/drx39xyj/drxj.c:11605:34: warning: cast to restricted __be16
drivers/media/dvb-frontends/drx39xyj/drxj.c:11605:34: warning: cast to restricted __be16
drivers/media/dvb-frontends/drx39xyj/drxj.c:11605:34: warning: cast to restricted __be16
drivers/media/dvb-frontends/drx39xyj/drxj.c:11632:29: warning: cast to restricted __be16
drivers/media/dvb-frontends/drx39xyj/drxj.c:11632:29: warning: cast to restricted __be16
drivers/media/dvb-frontends/drx39xyj/drxj.c:11632:29: warning: cast to restricted __be16
drivers/media/dvb-frontends/drx39xyj/drxj.c:11632:29: warning: cast to restricted __be16
drivers/media/dvb-frontends/drx39xyj/drxj.c:11650:34: warning: cast to restricted __be32
drivers/media/dvb-frontends/drx39xyj/drxj.c:11650:34: warning: cast to restricted __be32
drivers/media/dvb-frontends/drx39xyj/drxj.c:11650:34: warning: cast to restricted __be32
drivers/media/dvb-frontends/drx39xyj/drxj.c:11650:34: warning: cast to restricted __be32
drivers/media/dvb-frontends/drx39xyj/drxj.c:11650:34: warning: cast to restricted __be32
drivers/media/dvb-frontends/drx39xyj/drxj.c:11650:34: warning: cast to restricted __be32
drivers/media/dvb-frontends/drx39xyj/drxj.c:11652:34: warning: cast to restricted __be16
drivers/media/dvb-frontends/drx39xyj/drxj.c:11652:34: warning: cast to restricted __be16
drivers/media/dvb-frontends/drx39xyj/drxj.c:11652:34: warning: cast to restricted __be16
drivers/media/dvb-frontends/drx39xyj/drxj.c:11652:34: warning: cast to restricted __be16
drivers/media/dvb-frontends/drx39xyj/drxj.c:11654:35: warning: cast to restricted __be16
drivers/media/dvb-frontends/drx39xyj/drxj.c:11654:35: warning: cast to restricted __be16
drivers/media/dvb-frontends/drx39xyj/drxj.c:11654:35: warning: cast to restricted __be16
drivers/media/dvb-frontends/drx39xyj/drxj.c:11654:35: warning: cast to restricted __be16
drivers/media/dvb-frontends/drx39xyj/drxj.c:11656:33: warning: cast to restricted __be16
drivers/media/dvb-frontends/drx39xyj/drxj.c:11656:33: warning: cast to restricted __be16
drivers/media/dvb-frontends/drx39xyj/drxj.c:11656:33: warning: cast to restricted __be16
drivers/media/dvb-frontends/drx39xyj/drxj.c:11656:33: warning: cast to restricted __be16
drivers/media/dvb-frontends/drx39xyj/drxj.c:11670:35: warning: cast to restricted __be16
drivers/media/dvb-frontends/drx39xyj/drxj.c:11670:35: warning: cast to restricted __be16
drivers/media/dvb-frontends/drx39xyj/drxj.c:11670:35: warning: cast to restricted __be16
drivers/media/dvb-frontends/drx39xyj/drxj.c:11670:35: warning: cast to restricted __be16
drivers/media/dvb-frontends/drx39xyj/drxj.c:11678:47: warning: cast to restricted __be32
drivers/media/dvb-frontends/drx39xyj/drxj.c:11678:47: warning: cast to restricted __be32
drivers/media/dvb-frontends/drx39xyj/drxj.c:11678:47: warning: cast to restricted __be32
drivers/media/dvb-frontends/drx39xyj/drxj.c:11678:47: warning: cast to restricted __be32
drivers/media/dvb-frontends/drx39xyj/drxj.c:11678:47: warning: cast to restricted __be32
drivers/media/dvb-frontends/drx39xyj/drxj.c:11678:47: warning: cast to restricted __be32
drivers/media/dvb-frontends/drx39xyj/drxj.c:11680:46: warning: cast to restricted __be32
drivers/media/dvb-frontends/drx39xyj/drxj.c:11680:46: warning: cast to restricted __be32
drivers/media/dvb-frontends/drx39xyj/drxj.c:11680:46: warning: cast to restricted __be32
drivers/media/dvb-frontends/drx39xyj/drxj.c:11680:46: warning: cast to restricted __be32
drivers/media/dvb-frontends/drx39xyj/drxj.c:11680:46: warning: cast to restricted __be32
drivers/media/dvb-frontends/drx39xyj/drxj.c:11680:46: warning: cast to restricted __be32
drivers/media/dvb-frontends/drx39xyj/drxj.c:11682:51: warning: cast to restricted __be32
drivers/media/dvb-frontends/drx39xyj/drxj.c:11682:51: warning: cast to restricted __be32
drivers/media/dvb-frontends/drx39xyj/drxj.c:11682:51: warning: cast to restricted __be32
drivers/media/dvb-frontends/drx39xyj/drxj.c:11682:51: warning: cast to restricted __be32
drivers/media/dvb-frontends/drx39xyj/drxj.c:11682:51: warning: cast to restricted __be32
drivers/media/dvb-frontends/drx39xyj/drxj.c:11682:51: warning: cast to restricted __be32

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/dvb-frontends/drx39xyj/drxj.c | 38 ++++++++++++++---------------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/media/dvb-frontends/drx39xyj/drxj.c b/drivers/media/dvb-frontends/drx39xyj/drxj.c
index 7ca7a21..5ec221f 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drxj.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drxj.c
@@ -2174,7 +2174,7 @@ int drxj_dap_atomic_read_reg32(struct i2c_device_addr *dev_addr,
 				     u32 addr,
 				     u32 *data, u32 flags)
 {
-	u8 buf[sizeof(*data)];
+	u8 buf[sizeof(*data)] = { 0 };
 	int rc = -EIO;
 	u32 word = 0;
 
@@ -4193,7 +4193,7 @@ int drxj_dap_scu_atomic_read_reg16(struct i2c_device_addr *dev_addr,
 					 u32 addr,
 					 u16 *data, u32 flags)
 {
-	u8 buf[2];
+	u8 buf[2] = { 0 };
 	int rc = -EIO;
 	u16 word = 0;
 
@@ -10667,7 +10667,7 @@ ctrl_sig_quality(struct drx_demod_instance *demod,
 	enum drx_standard standard = ext_attr->standard;
 	int rc;
 	u32 ber, cnt, err, pkt;
-	u16 mer, strength;
+	u16 mer, strength = 0;
 
 	rc = get_sig_strength(demod, &strength);
 	if (rc < 0) {
@@ -11602,7 +11602,7 @@ static u16 drx_u_code_compute_crc(u8 *block_data, u16 nr_words)
 	u32 carry = 0;
 
 	while (i < nr_words) {
-		crc_word |= (u32)be16_to_cpu(*(u32 *)(block_data));
+		crc_word |= (u32)be16_to_cpu(*(__be16 *)(block_data));
 		for (j = 0; j < 16; j++) {
 			crc_word <<= 1;
 			if (carry != 0)
@@ -11629,7 +11629,7 @@ static int drx_check_firmware(struct drx_demod_instance *demod, u8 *mc_data,
 	int i;
 	unsigned count = 2 * sizeof(u16);
 	u32 mc_dev_type, mc_version, mc_base_version;
-	u16 mc_nr_of_blks = be16_to_cpu(*(u32 *)(mc_data + sizeof(u16)));
+	u16 mc_nr_of_blks = be16_to_cpu(*(__be16 *)(mc_data + sizeof(u16)));
 
 	/*
 	 * Scan microcode blocks first for version info
@@ -11647,13 +11647,13 @@ static int drx_check_firmware(struct drx_demod_instance *demod, u8 *mc_data,
 			goto eof;
 
 		/* Process block header */
-		block_hdr.addr = be32_to_cpu(*(u32 *)(mc_data + count));
+		block_hdr.addr = be32_to_cpu(*(__be32 *)(mc_data + count));
 		count += sizeof(u32);
-		block_hdr.size = be16_to_cpu(*(u32 *)(mc_data + count));
+		block_hdr.size = be16_to_cpu(*(__be16 *)(mc_data + count));
 		count += sizeof(u16);
-		block_hdr.flags = be16_to_cpu(*(u32 *)(mc_data + count));
+		block_hdr.flags = be16_to_cpu(*(__be16 *)(mc_data + count));
 		count += sizeof(u16);
-		block_hdr.CRC = be16_to_cpu(*(u32 *)(mc_data + count));
+		block_hdr.CRC = be16_to_cpu(*(__be16 *)(mc_data + count));
 		count += sizeof(u16);
 
 		pr_debug("%u: addr %u, size %u, flags 0x%04x, CRC 0x%04x\n",
@@ -11667,7 +11667,7 @@ static int drx_check_firmware(struct drx_demod_instance *demod, u8 *mc_data,
 			if (block_hdr.addr + sizeof(u16) > size)
 				goto eof;
 
-			auxtype = be16_to_cpu(*(u32 *)(auxblk));
+			auxtype = be16_to_cpu(*(__be16 *)(auxblk));
 
 			/* Aux block. Check type */
 			if (DRX_ISMCVERTYPE(auxtype)) {
@@ -11675,11 +11675,11 @@ static int drx_check_firmware(struct drx_demod_instance *demod, u8 *mc_data,
 					goto eof;
 
 				auxblk += sizeof(u16);
-				mc_dev_type = be32_to_cpu(*(u32 *)(auxblk));
+				mc_dev_type = be32_to_cpu(*(__be32 *)(auxblk));
 				auxblk += sizeof(u32);
-				mc_version = be32_to_cpu(*(u32 *)(auxblk));
+				mc_version = be32_to_cpu(*(__be32 *)(auxblk));
 				auxblk += sizeof(u32);
-				mc_base_version = be32_to_cpu(*(u32 *)(auxblk));
+				mc_base_version = be32_to_cpu(*(__be32 *)(auxblk));
 
 				DRX_ATTR_MCRECORD(demod).aux_type = auxtype;
 				DRX_ATTR_MCRECORD(demod).mc_dev_type = mc_dev_type;
@@ -11765,9 +11765,9 @@ static int drx_ctrl_u_code(struct drx_demod_instance *demod,
 
 	mc_data = (void *)mc_data_init;
 	/* Check data */
-	mc_magic_word = be16_to_cpu(*(u32 *)(mc_data));
+	mc_magic_word = be16_to_cpu(*(__be16 *)(mc_data));
 	mc_data += sizeof(u16);
-	mc_nr_of_blks = be16_to_cpu(*(u32 *)(mc_data));
+	mc_nr_of_blks = be16_to_cpu(*(__be16 *)(mc_data));
 	mc_data += sizeof(u16);
 
 	if ((mc_magic_word != DRX_UCODE_MAGIC_WORD) || (mc_nr_of_blks == 0)) {
@@ -11791,13 +11791,13 @@ static int drx_ctrl_u_code(struct drx_demod_instance *demod,
 		u16 mc_block_nr_bytes = 0;
 
 		/* Process block header */
-		block_hdr.addr = be32_to_cpu(*(u32 *)(mc_data));
+		block_hdr.addr = be32_to_cpu(*(__be32 *)(mc_data));
 		mc_data += sizeof(u32);
-		block_hdr.size = be16_to_cpu(*(u32 *)(mc_data));
+		block_hdr.size = be16_to_cpu(*(__be16 *)(mc_data));
 		mc_data += sizeof(u16);
-		block_hdr.flags = be16_to_cpu(*(u32 *)(mc_data));
+		block_hdr.flags = be16_to_cpu(*(__be16 *)(mc_data));
 		mc_data += sizeof(u16);
-		block_hdr.CRC = be16_to_cpu(*(u32 *)(mc_data));
+		block_hdr.CRC = be16_to_cpu(*(__be16 *)(mc_data));
 		mc_data += sizeof(u16);
 
 		pr_debug("%u: addr %u, size %u, flags 0x%04x, CRC 0x%04x\n",
-- 
2.1.0.rc1

