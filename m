Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49367 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754110AbaCCKH4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Mar 2014 05:07:56 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 51/79] [media] drx-j: Remove duplicated firmware upload code
Date: Mon,  3 Mar 2014 07:06:45 -0300
Message-Id: <1393841233-24840-52-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1393841233-24840-1-git-send-email-m.chehab@samsung.com>
References: <1393841233-24840-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove the duplicated firmware upload code that was commented
inside drxj.c.

This code is not used, and will not work anyway, as it doesn't
download the firmware from userspace.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/dvb-frontends/drx39xyj/drxj.c | 388 ----------------------------
 1 file changed, 388 deletions(-)

diff --git a/drivers/media/dvb-frontends/drx39xyj/drxj.c b/drivers/media/dvb-frontends/drx39xyj/drxj.c
index b92ca9013f55..cea5b6d66ab7 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drxj.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drxj.c
@@ -343,56 +343,6 @@ DEFINES
 				       (mode == DRX_POWER_MODE_16) || \
 				       (mode == DRX_POWER_DOWN))
 
-#ifdef DRXJ_SPLIT_UCODE_UPLOAD
-/*============================================================================*/
-/*=== MICROCODE RELATED DEFINES ==============================================*/
-/*============================================================================*/
-
-/**
-* \def DRXJ_UCODE_MAGIC_WORD
-* \brief Magic word for checking correct Endianess of microcode data.
-*
-*/
-
-#ifndef DRXJ_UCODE_MAGIC_WORD
-#define DRXJ_UCODE_MAGIC_WORD         ((((u16)'H')<<8)+((u16)'L'))
-#endif
-
-/**
-* \def DRXJ_UCODE_CRC_FLAG
-* \brief CRC flag in ucode header, flags field.
-*
-*/
-
-#ifndef DRXJ_UCODE_CRC_FLAG
-#define DRXJ_UCODE_CRC_FLAG           (0x0001)
-#endif
-
-/**
-* \def DRXJ_UCODE_COMPRESSION_FLAG
-* \brief Compression flag in ucode header, flags field.
-*
-*/
-
-#ifndef DRXJ_UCODE_COMPRESSION_FLAG
-#define DRXJ_UCODE_COMPRESSION_FLAG   (0x0002)
-#endif
-
-/**
-* \def DRXJ_UCODE_MAX_BUF_SIZE
-* \brief Maximum size of buffer used to verify the microcode.Must be an even number.
-*
-*/
-
-#ifndef DRXJ_UCODE_MAX_BUF_SIZE
-#define DRXJ_UCODE_MAX_BUF_SIZE       (DRXDAP_MAX_RCHUNKSIZE)
-#endif
-#if DRXJ_UCODE_MAX_BUF_SIZE & 1
-#error DRXJ_UCODE_MAX_BUF_SIZE must be an even number
-#endif
-
-#endif /* DRXJ_SPLIT_UCODE_UPLOAD */
-
 /* Pin safe mode macro */
 #define DRXJ_PIN_SAFE_MODE 0x0000
 /*============================================================================*/
@@ -704,9 +654,6 @@ struct drxj_data drxj_data_g = {
 /*   false,                  * flagHDevSet       */
 /*   (u16) 0xFFF,          * rdsLastCount      */
 
-/*#ifdef DRXJ_SPLIT_UCODE_UPLOAD
-   false,                  * flag_aud_mc_uploaded */
-/*#endif * DRXJ_SPLIT_UCODE_UPLOAD */
 	/* ATV configuartion */
 	0UL,			/* flags cfg changes */
 	/* shadow of ATV_TOP_EQU0__A */
@@ -1133,13 +1080,6 @@ ctrl_set_cfg_pre_saw(struct drx_demod_instance *demod, struct drxj_cfg_pre_saw *
 static int
 ctrl_set_cfg_afe_gain(struct drx_demod_instance *demod, struct drxj_cfg_afe_gain *afe_gain);
 
-#ifdef DRXJ_SPLIT_UCODE_UPLOAD
-static int
-ctrl_u_code_upload(struct drx_demod_instance *demod,
-		  struct drxu_code_info *mc_info,
-		enum drxu_code_actionaction, bool audio_mc_upload);
-#endif /* DRXJ_SPLIT_UCODE_UPLOAD */
-
 /*============================================================================*/
 /*============================================================================*/
 /*==                          HELPER FUNCTIONS                              ==*/
@@ -1531,82 +1471,6 @@ static u32 frac(u32 N, u32 D, u16 RC)
 }
 #endif
 
-#ifdef DRXJ_SPLIT_UCODE_UPLOAD
-/*============================================================================*/
-
-/**
-* \fn u16 u_code_read16( u8 *addr)
-* \brief Read a 16 bits word, expect big endian data.
-* \return u16 The data read.
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
-* \fn u32 u_code_read32( u8 *addr)
-* \brief Read a 32 bits word, expect big endian data.
-* \return u32 The data read.
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
-
-/**
-* \fn u16 u_code_compute_crc (u8 *block_data, u16 nr_words)
-* \brief Compute CRC of block of microcode data.
-* \param block_data Pointer to microcode data.
-* \param nr_words Size of microcode block (number of 16 bits words).
-* \return u16 The computed CRC residu.
-*/
-static u16 u_code_compute_crc(u8 *block_data, u16 nr_words)
-{
-	u16 i = 0;
-	u16 j = 0;
-	u32 crc_word = 0;
-	u32 carry = 0;
-
-	while (i < nr_words) {
-		crc_word |= (u32) u_code_read16(block_data);
-		for (j = 0; j < 16; j++) {
-			crc_word <<= 1;
-			if (carry != 0)
-				crc_word ^= 0x80050000UL;
-			carry = crc_word & 0x80000000UL;
-		}
-		i++;
-		block_data += (sizeof(u16));
-	}
-	return (u16)(crc_word >> 16);
-}
-#endif /* DRXJ_SPLIT_UCODE_UPLOAD */
-
 /**
 * \brief Values for NICAM prescaler gain. Computed from dB to integer
 *        and rounded. For calc used formula: 16*10^(prescaleGain[dB]/20).
@@ -12193,43 +12057,12 @@ trouble ?
 	};
 	u16 cmd_result = 0;
 	u16 cmd_param = 0;
-#ifdef DRXJ_SPLIT_UCODE_UPLOAD
-	struct drxu_code_info ucode_info;
-	struct drx_common_attr *common_attr = NULL;
-#endif /* DRXJ_SPLIT_UCODE_UPLOAD */
 	struct drxj_data *ext_attr = NULL;
 	int rc;
 
 	ext_attr = (struct drxj_data *) demod->my_ext_attr;
 	dev_addr = demod->my_i2c_dev_addr;
 
-#ifdef DRXJ_SPLIT_UCODE_UPLOAD
-	common_attr = demod->my_common_attr;
-
-	/* Check if audio microcode is already uploaded */
-	if (!(ext_attr->flag_aud_mc_uploaded)) {
-		ucode_info.mc_data = common_attr->microcode;
-
-		/* Upload only audio microcode */
-		rc = ctrl_u_code_upload(demod, &ucode_info, UCODE_UPLOAD, true);
-		if (rc != 0) {
-			pr_err("error %d\n", rc);
-			goto rw_error;
-		}
-
-		if (common_attr->verify_microcode == true) {
-			rc = ctrl_u_code_upload(demod, &ucode_info, UCODE_VERIFY, true);
-			if (rc != 0) {
-				pr_err("error %d\n", rc);
-				goto rw_error;
-			}
-		}
-
-		/* Prevent uploading audio microcode again */
-		ext_attr->flag_aud_mc_uploaded = true;
-	}
-#endif /* DRXJ_SPLIT_UCODE_UPLOAD */
-
 	rc = DRXJ_DAP.write_reg16func(dev_addr, ATV_COMM_EXEC__A, ATV_COMM_EXEC_STOP, 0);
 	if (rc != 0) {
 		pr_err("error %d\n", rc);
@@ -18913,194 +18746,6 @@ rw_error:
 	return -EIO;
 }
 
-#ifdef DRXJ_SPLIT_UCODE_UPLOAD
-/*============================================================================*/
-
-/**
-* \fn int is_mc_block_audio()
-* \brief Check if MC block is Audio or not Audio.
-* \param addr        Pointer to demodulator instance.
-* \param audioUpload true  if MC block is Audio
-		     false if MC block not Audio
-* \return bool.
-*/
-bool is_mc_block_audio(u32 addr)
-{
-	if ((addr == AUD_XFP_PRAM_4K__A) || (addr == AUD_XDFP_PRAM_4K__A))
-		return true;
-
-	return false;
-}
-
-/*============================================================================*/
-
-/**
-* \fn int ctrl_u_code_upload()
-* \brief Handle Audio or !Audio part of microcode upload.
-* \param demod          Pointer to demodulator instance.
-* \param mc_info         Pointer to information about microcode data.
-* \param action         Either UCODE_UPLOAD or UCODE_VERIFY.
-* \param upload_audio_mc  true  if Audio MC need to be uploaded.
-			false if !Audio MC need to be uploaded.
-* \return int.
-*/
-static int
-ctrl_u_code_upload(struct drx_demod_instance *demod,
-		   struct drxu_code_info *mc_info,
-		   enum drxu_code_actionaction, bool upload_audio_mc)
-{
-	u16 i = 0;
-	u16 mc_nr_of_blks = 0;
-	u16 mc_magic_word = 0;
-	u8 *mc_data = (u8 *)(NULL);
-	struct i2c_device_addr *dev_addr = (struct i2c_device_addr *)(NULL);
-	struct drxj_data *ext_attr = (struct drxj_data *) (NULL);
-	int rc;
-
-	dev_addr = demod->my_i2c_dev_addr;
-	ext_attr = (struct drxj_data *) demod->my_ext_attr;
-
-	/* Check arguments */
-	if (!mc_info || !mc_info->mc_data) {
-		return -EINVAL;
-	}
-
-	mc_data = mc_info->mc_data;
-
-	/* Check data */
-	mc_magic_word = u_code_read16(mc_data);
-	mc_data += sizeof(u16);
-	mc_nr_of_blks = u_code_read16(mc_data);
-	mc_data += sizeof(u16);
-
-	if ((mc_magic_word != DRXJ_UCODE_MAGIC_WORD) || (mc_nr_of_blks == 0)) {
-		/* wrong endianess or wrong data ? */
-		return -EINVAL;
-	}
-
-	/* Process microcode blocks */
-	for (i = 0; i < mc_nr_of_blks; i++) {
-		struct drxu_code_block_hdr block_hdr;
-		u16 mc_block_nr_bytes = 0;
-
-		/* Process block header */
-		block_hdr.addr = u_code_read32(mc_data);
-		mc_data += sizeof(u32);
-		block_hdr.size = u_code_read16(mc_data);
-		mc_data += sizeof(u16);
-		block_hdr.flags = u_code_read16(mc_data);
-		mc_data += sizeof(u16);
-		block_hdr.CRC = u_code_read16(mc_data);
-		mc_data += sizeof(u16);
-
-		/* Check block header on:
-		   - no data
-		   - data larger then 64Kb
-		   - if CRC enabled check CRC
-		 */
-		if ((block_hdr.size == 0) ||
-		    (block_hdr.size > 0x7FFF) ||
-		    (((block_hdr.flags & DRXJ_UCODE_CRC_FLAG) != 0) &&
-		     (block_hdr.CRC != u_code_compute_crc(mc_data, block_hdr.size)))
-		    ) {
-			/* Wrong data ! */
-			return -EINVAL;
-		}
-
-		mc_block_nr_bytes = block_hdr.size * sizeof(u16);
-
-		/* Perform the desired action */
-		/* Check which part of MC need to be uploaded - Audio or not Audio */
-		if (is_mc_block_audio(block_hdr.addr) == upload_audio_mc) {
-			switch (action) {
-	    /*===================================================================*/
-			case UCODE_UPLOAD:
-				{
-					/* Upload microcode */
-					if (demod->my_access_funct->
-					    write_block_func(dev_addr,
-							   (dr_xaddr_t) block_hdr.
-							   addr, mc_block_nr_bytes,
-							   mc_data,
-							   0x0000) !=
-					    0) {
-						return -EIO;
-					}
-				}
-				break;
-
-	    /*===================================================================*/
-			case UCODE_VERIFY:
-				{
-					int result = 0;
-					u8 mc_data_buffer
-					    [DRXJ_UCODE_MAX_BUF_SIZE];
-					u32 bytes_to_compare = 0;
-					u32 bytes_left_to_compare = 0;
-					u32 curr_addr = (dr_xaddr_t) 0;
-					u8 *curr_ptr = NULL;
-
-					bytes_left_to_compare = mc_block_nr_bytes;
-					curr_addr = block_hdr.addr;
-					curr_ptr = mc_data;
-
-					while (bytes_left_to_compare != 0) {
-						if (bytes_left_to_compare > ((u32)DRXJ_UCODE_MAX_BUF_SIZE))
-							bytes_to_compare = ((u32)DRXJ_UCODE_MAX_BUF_SIZE);
-						else
-							bytes_to_compare = bytes_left_to_compare;
-
-						if (demod->my_access_funct->
-						    read_block_func(dev_addr,
-								  curr_addr,
-								  (u16)
-								  bytes_to_compare,
-								  (u8 *)
-								  mc_data_buffer,
-								  0x0000) !=
-						    0) {
-							return -EIO;
-						}
-
-						result =
-						    drxbsp_hst_memcmp(curr_ptr,
-								      mc_data_buffer,
-								      bytes_to_compare);
-
-						if (result != 0)
-							return -EIO;
-
-						curr_addr +=
-						    ((dr_xaddr_t)
-						     (bytes_to_compare / 2));
-						curr_ptr =
-						    &(curr_ptr[bytes_to_compare]);
-						bytes_left_to_compare -=
-						    ((u32) bytes_to_compare);
-					}	/* while( bytes_to_compare > DRXJ_UCODE_MAX_BUF_SIZE ) */
-				}
-				break;
-
-	    /*===================================================================*/
-			default:
-				return -EINVAL;
-				break;
-
-			}	/* switch ( action ) */
-		}
-
-		/* if( is_mc_block_audio( block_hdr.addr ) == upload_audio_mc ) */
-		/* Next block */
-		mc_data += mc_block_nr_bytes;
-	}			/* for( i = 0 ; i<mc_nr_of_blks ; i++ ) */
-
-	if (!upload_audio_mc)
-		ext_attr->flag_aud_mc_uploaded = false;
-
-	return 0;
-}
-#endif /* DRXJ_SPLIT_UCODE_UPLOAD */
-
 /*============================================================================*/
 /*== CTRL Set/Get Config related functions ===================================*/
 /*============================================================================*/
@@ -20263,34 +19908,17 @@ int drxj_open(struct drx_demod_instance *demod)
 		common_attr->is_opened = true;
 		ucode_info.mc_file = common_attr->microcode_file;
 
-#ifdef DRXJ_SPLIT_UCODE_UPLOAD
-		/* Upload microcode without audio part */
-		rc = ctrl_u_code_upload(demod, &ucode_info, UCODE_UPLOAD, false);
-		if (rc != 0) {
-			pr_err("error %d\n", rc);
-			goto rw_error;
-		}
-#else
 		rc = drx_ctrl(demod, DRX_CTRL_LOAD_UCODE, &ucode_info);
 		if (rc != 0) {
 			pr_err("error %d\n", rc);
 			goto rw_error;
 		}
-#endif /* DRXJ_SPLIT_UCODE_UPLOAD */
 		if (common_attr->verify_microcode == true) {
-#ifdef DRXJ_SPLIT_UCODE_UPLOAD
-			rc = ctrl_u_code_upload(demod, &ucode_info, UCODE_VERIFY, false);
-			if (rc != 0) {
-				pr_err("error %d\n", rc);
-				goto rw_error;
-			}
-#else
 			rc = drx_ctrl(demod, DRX_CTRL_VERIFY_UCODE, &ucode_info);
 			if (rc != 0) {
 				pr_err("error %d\n", rc);
 				goto rw_error;
 			}
-#endif /* DRXJ_SPLIT_UCODE_UPLOAD */
 		}
 		common_attr->is_opened = false;
 	}
@@ -20620,22 +20248,6 @@ drxj_ctrl(struct drx_demod_instance *demod, u32 ctrl, void *ctrl_data)
 						(struct drxi2c_data *) ctrl_data);
 		}
 		break;
-#ifdef DRXJ_SPLIT_UCODE_UPLOAD
-	case DRX_CTRL_LOAD_UCODE:
-		{
-			return ctrl_u_code_upload(demod,
-					       (p_drxu_code_info_t) ctrl_data,
-					       UCODE_UPLOAD, false);
-		}
-		break;
-	case DRX_CTRL_VERIFY_UCODE:
-		{
-			return ctrl_u_code_upload(demod,
-					       (p_drxu_code_info_t) ctrl_data,
-					       UCODE_VERIFY, false);
-		}
-		break;
-#endif /* DRXJ_SPLIT_UCODE_UPLOAD */
 	case DRX_CTRL_VALIDATE_UCODE:
 		{
 			return ctrl_validate_u_code(demod);
-- 
1.8.5.3

