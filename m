Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49358 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754101AbaCCKH4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Mar 2014 05:07:56 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 48/79] [media] drx-j: prepend function names with drx_ at drx_driver.c
Date: Mon,  3 Mar 2014 07:06:42 -0300
Message-Id: <1393841233-24840-49-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1393841233-24840-1-git-send-email-m.chehab@samsung.com>
References: <1393841233-24840-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In order to prepare to get rid of drx_driver.c, prepend all functions
there with drx_.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/dvb-frontends/drx39xyj/drx_driver.c | 28 +++++++++++------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/media/dvb-frontends/drx39xyj/drx_driver.c b/drivers/media/dvb-frontends/drx39xyj/drx_driver.c
index afeda82a1acd..0ebc0d285296 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drx_driver.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drx_driver.c
@@ -46,7 +46,7 @@ INCLUDE FILES
  */
 
 /*
-/* MICROCODE RELATED DEFINES
+ * MICROCODE RELATED DEFINES
  */
 
 /* Magic word for checking correct Endianess of microcode data */
@@ -108,13 +108,13 @@ FUNCTIONS
  */
 
 /**
- * u_code_compute_crc	- Compute CRC of block of microcode data.
+ * drx_u_code_compute_crc	- Compute CRC of block of microcode data.
  * @block_data: Pointer to microcode data.
  * @nr_words:   Size of microcode block (number of 16 bits words).
  *
  * returns The computed CRC residue.
  */
-static u16 u_code_compute_crc(u8 *block_data, u16 nr_words)
+static u16 drx_u_code_compute_crc(u8 *block_data, u16 nr_words)
 {
 	u16 i = 0;
 	u16 j = 0;
@@ -136,13 +136,13 @@ static u16 u_code_compute_crc(u8 *block_data, u16 nr_words)
 }
 
 /**
- * check_firmware - checks if the loaded firmware is valid
+ * drx_check_firmware - checks if the loaded firmware is valid
  *
  * @demod:	demod structure
  * @mc_data:	pointer to the start of the firmware
  * @size:	firmware size
  */
-static int check_firmware(struct drx_demod_instance *demod, u8 *mc_data,
+static int drx_check_firmware(struct drx_demod_instance *demod, u8 *mc_data,
 			  unsigned size)
 {
 	struct drxu_code_block_hdr block_hdr;
@@ -222,7 +222,7 @@ eof:
 }
 
 /**
- * ctrl_u_code - Handle microcode upload or verify.
+ * drx_ctrl_u_code - Handle microcode upload or verify.
  * @dev_addr: Address of device.
  * @mc_info:  Pointer to information about microcode data.
  * @action:  Either UCODE_UPLOAD or UCODE_VERIFY
@@ -240,7 +240,7 @@ eof:
  *		- Invalid arguments.
  *		- Provided image is corrupt
  */
-static int ctrl_u_code(struct drx_demod_instance *demod,
+static int drx_ctrl_u_code(struct drx_demod_instance *demod,
 		       struct drxu_code_info *mc_info,
 		       enum drxu_code_action action)
 {
@@ -295,7 +295,7 @@ static int ctrl_u_code(struct drx_demod_instance *demod,
 	}
 
 	if (action == UCODE_UPLOAD) {
-		rc = check_firmware(demod, (u8 *)mc_data_init, size);
+		rc = drx_check_firmware(demod, (u8 *)mc_data_init, size);
 		if (rc)
 			goto release;
 
@@ -337,7 +337,7 @@ static int ctrl_u_code(struct drx_demod_instance *demod,
 		 */
 		if ((block_hdr.size > 0x7FFF) ||
 		    (((block_hdr.flags & DRX_UCODE_CRC_FLAG) != 0) &&
-		     (block_hdr.CRC != u_code_compute_crc(mc_data, block_hdr.size)))
+		     (block_hdr.CRC != drx_u_code_compute_crc(mc_data, block_hdr.size)))
 		    ) {
 			/* Wrong data ! */
 			rc = -EINVAL;
@@ -424,7 +424,7 @@ release:
 /*============================================================================*/
 
 /**
- * ctrl_version - Build list of version information.
+ * drx_ctrl_version - Build list of version information.
  * @demod: A pointer to a demodulator instance.
  * @version_list: Pointer to linked list of versions.
  *
@@ -432,7 +432,7 @@ release:
  *	0:		Version information stored in version_list
  *	-EINVAL:	Invalid arguments.
  */
-static int ctrl_version(struct drx_demod_instance *demod,
+static int drx_ctrl_version(struct drx_demod_instance *demod,
 			struct drx_version_list **version_list)
 {
 	static char drx_driver_core_module_name[] = "Core driver";
@@ -607,7 +607,7 @@ int drx_ctrl(struct drx_demod_instance *demod, u32 ctrl, void *ctrl_data)
 
       /*======================================================================*/
 	case DRX_CTRL_VERSION:
-		return ctrl_version(demod, (struct drx_version_list **)ctrl_data);
+		return drx_ctrl_version(demod, (struct drx_version_list **)ctrl_data);
 		break;
 
       /*======================================================================*/
@@ -624,7 +624,7 @@ int drx_ctrl(struct drx_demod_instance *demod, u32 ctrl, void *ctrl_data)
 		switch (ctrl) {
 	 /*===================================================================*/
 		case DRX_CTRL_LOAD_UCODE:
-			return ctrl_u_code(demod,
+			return drx_ctrl_u_code(demod,
 					 (struct drxu_code_info *)ctrl_data,
 					 UCODE_UPLOAD);
 			break;
@@ -632,7 +632,7 @@ int drx_ctrl(struct drx_demod_instance *demod, u32 ctrl, void *ctrl_data)
 	 /*===================================================================*/
 		case DRX_CTRL_VERIFY_UCODE:
 			{
-				return ctrl_u_code(demod,
+				return drx_ctrl_u_code(demod,
 						 (struct drxu_code_info *)ctrl_data,
 						 UCODE_VERIFY);
 			}
-- 
1.8.5.3

