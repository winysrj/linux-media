Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49394 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754153AbaCCKH7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Mar 2014 05:07:59 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 47/79] [media] drx-j: Some cleanups at drx_driver.c source
Date: Mon,  3 Mar 2014 07:06:41 -0300
Message-Id: <1393841233-24840-48-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1393841233-24840-1-git-send-email-m.chehab@samsung.com>
References: <1393841233-24840-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is mostly CodingStyle fixes and improvements.

No functional changes.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/dvb-frontends/drx39xyj/drx39xxj.h   |   2 +-
 drivers/media/dvb-frontends/drx39xyj/drx_driver.c | 269 ++++++++++------------
 2 files changed, 118 insertions(+), 153 deletions(-)

diff --git a/drivers/media/dvb-frontends/drx39xyj/drx39xxj.h b/drivers/media/dvb-frontends/drx39xyj/drx39xxj.h
index 8c24d73410bc..b9f642e5d98b 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drx39xxj.h
+++ b/drivers/media/dvb-frontends/drx39xyj/drx39xxj.h
@@ -31,7 +31,7 @@ struct drx39xxj_state {
 	struct drx_demod_instance *demod;
 	enum drx_standard current_standard;
 	struct dvb_frontend frontend;
-	int powered_up:1;
+	unsigned int powered_up:1;
 	unsigned int i2c_gate_open:1;
 	const struct firmware *fw;
 };
diff --git a/drivers/media/dvb-frontends/drx39xyj/drx_driver.c b/drivers/media/dvb-frontends/drx39xyj/drx_driver.c
index 0803298b89bf..afeda82a1acd 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drx_driver.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drx_driver.c
@@ -32,70 +32,42 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ":%s: " fmt, __func__
 
-
 /*------------------------------------------------------------------------------
 INCLUDE FILES
 ------------------------------------------------------------------------------*/
 #include "drx_driver.h"
 
-#define VERSION_FIXED 0
-#if     VERSION_FIXED
 #define VERSION_MAJOR 0
 #define VERSION_MINOR 0
 #define VERSION_PATCH 0
-#else
-#include "drx_driver_version.h"
-#endif
 
-/*------------------------------------------------------------------------------
-DEFINES
-------------------------------------------------------------------------------*/
+/*
+ * DEFINES
+ */
 
-/*============================================================================*/
-/*=== MICROCODE RELATED DEFINES ==============================================*/
-/*============================================================================*/
+/*
+/* MICROCODE RELATED DEFINES
+ */
 
-/** \brief Magic word for checking correct Endianess of microcode data. */
-#ifndef DRX_UCODE_MAGIC_WORD
+/* Magic word for checking correct Endianess of microcode data */
 #define DRX_UCODE_MAGIC_WORD         ((((u16)'H')<<8)+((u16)'L'))
-#endif
 
-/** \brief CRC flag in ucode header, flags field. */
-#ifndef DRX_UCODE_CRC_FLAG
+/* CRC flag in ucode header, flags field. */
 #define DRX_UCODE_CRC_FLAG           (0x0001)
-#endif
 
-/** \brief Compression flag in ucode header, flags field. */
-#ifndef DRX_UCODE_COMPRESSION_FLAG
-#define DRX_UCODE_COMPRESSION_FLAG   (0x0002)
-#endif
-
-/** \brief Maximum size of buffer used to verify the microcode.
-   Must be an even number. */
-#ifndef DRX_UCODE_MAX_BUF_SIZE
+/*
+ * Maximum size of buffer used to verify the microcode.
+ * Must be an even number
+ */
 #define DRX_UCODE_MAX_BUF_SIZE       (DRXDAP_MAX_RCHUNKSIZE)
-#endif
+
 #if DRX_UCODE_MAX_BUF_SIZE & 1
 #error DRX_UCODE_MAX_BUF_SIZE must be an even number
 #endif
 
-/*============================================================================*/
-/*=== CHANNEL SCAN RELATED DEFINES ===========================================*/
-/*============================================================================*/
-
-/**
-* \brief Maximum progress indication.
-*
-* Progress indication will run from 0 upto DRX_SCAN_MAX_PROGRESS during scan.
-*
-*/
-#ifndef DRX_SCAN_MAX_PROGRESS
-#define DRX_SCAN_MAX_PROGRESS 1000
-#endif
-
-/*============================================================================*/
-/*=== MACROS =================================================================*/
-/*============================================================================*/
+/*
+ * Power mode macros
+ */
 
 #define DRX_ISPOWERDOWNMODE(mode) ((mode == DRX_POWER_MODE_9) || \
 				       (mode == DRX_POWER_MODE_10) || \
@@ -108,41 +80,40 @@ DEFINES
 				       (mode == DRX_POWER_DOWN))
 
 /*------------------------------------------------------------------------------
-GLOBAL VARIABLES
-------------------------------------------------------------------------------*/
-
-/*------------------------------------------------------------------------------
 STRUCTURES
 ------------------------------------------------------------------------------*/
-/** \brief  Structure of the microcode block headers */
+
+/**
+ * struct drxu_code_block_hdr - Structure of the microcode block headers
+ *
+ * @addr:	Destination address of the data in this block
+ * @size:	Size of the block data following this header counted in
+ *		16 bits words
+ * @CRC:	CRC value of the data block, only valid if CRC flag is
+ *		set.
+ */
 struct drxu_code_block_hdr {
 	u32 addr;
-		  /**<  Destination address of the data in this block */
 	u16 size;
-		  /**<  Size of the block data following this header counted in
-			16 bits words */
 	u16 flags;
-		  /**<  Flags for this data block:
-			- bit[0]= CRC on/off
-			- bit[1]= compression on/off
-			- bit[15..2]=reserved */
-	u16 CRC;/**<  CRC value of the data block, only valid if CRC flag is
-			set. */};
+	u16 CRC;
+};
 
 /*------------------------------------------------------------------------------
 FUNCTIONS
 ------------------------------------------------------------------------------*/
 
-/*============================================================================*/
-/*===Microcode related functions==============================================*/
-/*============================================================================*/
+/*
+ * Microcode related functions
+ */
 
 /**
-* \brief Compute CRC of block of microcode data.
-* \param block_data: Pointer to microcode data.
-* \param nr_words:   Size of microcode block (number of 16 bits words).
-* \return u16 The computed CRC residu.
-*/
+ * u_code_compute_crc	- Compute CRC of block of microcode data.
+ * @block_data: Pointer to microcode data.
+ * @nr_words:   Size of microcode block (number of 16 bits words).
+ *
+ * returns The computed CRC residue.
+ */
 static u16 u_code_compute_crc(u8 *block_data, u16 nr_words)
 {
 	u16 i = 0;
@@ -151,7 +122,7 @@ static u16 u_code_compute_crc(u8 *block_data, u16 nr_words)
 	u32 carry = 0;
 
 	while (i < nr_words) {
-		crc_word |= (u32) be16_to_cpu(*(u32 *)(block_data));
+		crc_word |= (u32)be16_to_cpu(*(u32 *)(block_data));
 		for (j = 0; j < 16; j++) {
 			crc_word <<= 1;
 			if (carry != 0)
@@ -164,9 +135,13 @@ static u16 u_code_compute_crc(u8 *block_data, u16 nr_words)
 	return (u16)(crc_word >> 16);
 }
 
-/*============================================================================*/
-
-
+/**
+ * check_firmware - checks if the loaded firmware is valid
+ *
+ * @demod:	demod structure
+ * @mc_data:	pointer to the start of the firmware
+ * @size:	firmware size
+ */
 static int check_firmware(struct drx_demod_instance *demod, u8 *mc_data,
 			  unsigned size)
 {
@@ -247,26 +222,27 @@ eof:
 }
 
 /**
-* \brief Handle microcode upload or verify.
-* \param dev_addr: Address of device.
-* \param mc_info:  Pointer to information about microcode data.
-* \param action:  Either UCODE_UPLOAD or UCODE_VERIFY
-* \return int.
-* \retval 0:
-*                    - In case of UCODE_UPLOAD: code is successfully uploaded.
-*                    - In case of UCODE_VERIFY: image on device is equal to
-*                      image provided to this control function.
-* \retval -EIO:
-*                    - In case of UCODE_UPLOAD: I2C error.
-*                    - In case of UCODE_VERIFY: I2C error or image on device
-*                      is not equal to image provided to this control function.
-* \retval -EINVAL:
-*                    - Invalid arguments.
-*                    - Provided image is corrupt
-*/
-static int
-ctrl_u_code(struct drx_demod_instance *demod,
-	    struct drxu_code_info *mc_info, enum drxu_code_action action)
+ * ctrl_u_code - Handle microcode upload or verify.
+ * @dev_addr: Address of device.
+ * @mc_info:  Pointer to information about microcode data.
+ * @action:  Either UCODE_UPLOAD or UCODE_VERIFY
+ *
+ * This function returns:
+ *	0:
+ *		- In case of UCODE_UPLOAD: code is successfully uploaded.
+ *               - In case of UCODE_VERIFY: image on device is equal to
+ *		  image provided to this control function.
+ *	-EIO:
+ *		- In case of UCODE_UPLOAD: I2C error.
+ *		- In case of UCODE_VERIFY: I2C error or image on device
+ *		  is not equal to image provided to this control function.
+ * 	-EINVAL:
+ *		- Invalid arguments.
+ *		- Provided image is corrupt
+ */
+static int ctrl_u_code(struct drx_demod_instance *demod,
+		       struct drxu_code_info *mc_info,
+		       enum drxu_code_action action)
 {
 	struct i2c_device_addr *dev_addr = demod->my_i2c_dev_addr;
 	int rc;
@@ -448,15 +424,16 @@ release:
 /*============================================================================*/
 
 /**
-* \brief Build list of version information.
-* \param demod: A pointer to a demodulator instance.
-* \param version_list: Pointer to linked list of versions.
-* \return int.
-* \retval 0:          Version information stored in version_list
-* \retval -EINVAL: Invalid arguments.
-*/
-static int
-ctrl_version(struct drx_demod_instance *demod, struct drx_version_list **version_list)
+ * ctrl_version - Build list of version information.
+ * @demod: A pointer to a demodulator instance.
+ * @version_list: Pointer to linked list of versions.
+ *
+ * This function returns:
+ *	0:		Version information stored in version_list
+ *	-EINVAL:	Invalid arguments.
+ */
+static int ctrl_version(struct drx_demod_instance *demod,
+			struct drx_version_list **version_list)
 {
 	static char drx_driver_core_module_name[] = "Core driver";
 	static char drx_driver_core_version_text[] =
@@ -465,7 +442,7 @@ ctrl_version(struct drx_demod_instance *demod, struct drx_version_list **version
 	static struct drx_version drx_driver_core_version;
 	static struct drx_version_list drx_driver_core_version_list;
 
-	struct drx_version_list *demod_version_list = (struct drx_version_list *) (NULL);
+	struct drx_version_list *demod_version_list = NULL;
 	int return_status = -EIO;
 
 	/* Check arguments */
@@ -507,22 +484,21 @@ ctrl_version(struct drx_demod_instance *demod, struct drx_version_list **version
 	return 0;
 }
 
-/*============================================================================*/
-/*============================================================================*/
-/*== Exported functions ======================================================*/
-/*============================================================================*/
-/*============================================================================*/
+/*
+ * Exported functions
+ */
 
 /**
-* \brief Open a demodulator instance.
-* \param demod: A pointer to a demodulator instance.
-* \return int Return status.
-* \retval 0:          Opened demod instance with succes.
-* \retval -EIO:       Driver not initialized or unable to initialize
-*                              demod.
-* \retval -EINVAL: Demod instance has invalid content.
-*
-*/
+ * drx_open - Open a demodulator instance.
+ * @demod: A pointer to a demodulator instance.
+ *
+ * This function returns:
+ *	0:		Opened demod instance with succes.
+ *	-EIO:		Driver not initialized or unable to initialize
+ *			demod.
+ *	-EINVAL:	Demod instance has invalid content.
+ *
+ */
 
 int drx_open(struct drx_demod_instance *demod)
 {
@@ -548,18 +524,18 @@ int drx_open(struct drx_demod_instance *demod)
 /*============================================================================*/
 
 /**
-* \brief Close device.
-* \param demod: A pointer to a demodulator instance.
-* \return int Return status.
-* \retval 0:          Closed demod instance with succes.
-* \retval -EIO:       Driver not initialized or error during close
-*                              demod.
-* \retval -EINVAL: Demod instance has invalid content.
-*
-* Free resources occupied by device instance.
-* Put device into sleep mode.
-*/
-
+ * drx_close - Close device
+ * @demod: A pointer to a demodulator instance.
+ *
+ * Free resources occupied by device instance.
+ * Put device into sleep mode.
+ *
+ * This function returns:
+ *	0:		Closed demod instance with succes.
+ *	-EIO:		Driver not initialized or error during close
+ *			demod.
+ *	-EINVAL:	Demod instance has invalid content.
+ */
 int drx_close(struct drx_demod_instance *demod)
 {
 	int status = 0;
@@ -579,29 +555,22 @@ int drx_close(struct drx_demod_instance *demod)
 
 	return status;
 }
-
-/*============================================================================*/
-
 /**
-* \brief Control the device.
-* \param demod:    A pointer to a demodulator instance.
-* \param ctrl:     Reference to desired control function.
-* \param ctrl_data: Pointer to data structure for control function.
-* \return int Return status.
-* \retval 0:                 Control function completed successfully.
-* \retval -EIO:              Driver not initialized or error during
-*                                     control demod.
-* \retval -EINVAL:        Demod instance or ctrl_data has invalid
-*                                     content.
-* \retval -ENOTSUPP: Specified control function is not
-*                                     available.
-*
-* Data needed or returned by the control function is stored in ctrl_data.
-*
-*/
-
-int
-drx_ctrl(struct drx_demod_instance *demod, u32 ctrl, void *ctrl_data)
+ * drx_ctrl - Control the device.
+ * @demod:    A pointer to a demodulator instance.
+ * @ctrl:     Reference to desired control function.
+ * @ctrl_data: Pointer to data structure for control function.
+ *
+ * Data needed or returned by the control function is stored in ctrl_data.
+ *
+ * This function returns:
+ *	0:		Control function completed successfully.
+ *	-EIO:		Driver not initialized or error during control demod.
+ *	-EINVAL:	Demod instance or ctrl_data has invalid content.
+ *	-ENOTSUPP:	Specified control function is not available.
+ */
+
+int drx_ctrl(struct drx_demod_instance *demod, u32 ctrl, void *ctrl_data)
 {
 	int status = -EIO;
 
@@ -680,7 +649,3 @@ drx_ctrl(struct drx_demod_instance *demod, u32 ctrl, void *ctrl_data)
 
 	return 0;
 }
-
-/*============================================================================*/
-
-/* END OF FILE */
-- 
1.8.5.3

