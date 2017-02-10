Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:35508 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751081AbdBJWaW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 10 Feb 2017 17:30:22 -0500
From: Derek Robson <robsonde@gmail.com>
To: mchehab@kernel.org, gregkh@linuxfoundation.org, robsonde@gmail.com,
        thaissa.falbo@gmail.com, karniksayli1995@gmail.com,
        bhaktipriya96@gmail.com, laurent.pinchart@ideasonboard.com,
        arnd@arndb.de, gnudevliz@gmail.com, aryasaatvik@gmail.com,
        janani.rvchndrn@gmail.com
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: media: davinci_vpfe - style fix
Date: Sat, 11 Feb 2017 11:28:25 +1300
Message-Id: <20170210222825.23390-1-robsonde@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fixed alignment of block commenents across whole driver.
Found using checkpatch.

Signed-off-by: Derek Robson <robsonde@gmail.com>
---
 .../staging/media/davinci_vpfe/davinci_vpfe_user.h | 24 +++++++++++-----------
 .../staging/media/davinci_vpfe/dm365_ipipe_hw.c    |  4 ++--
 .../staging/media/davinci_vpfe/dm365_isif_regs.h   | 20 +++++++++---------
 drivers/staging/media/davinci_vpfe/dm365_resizer.c |  6 +++---
 4 files changed, 27 insertions(+), 27 deletions(-)

diff --git a/drivers/staging/media/davinci_vpfe/davinci_vpfe_user.h b/drivers/staging/media/davinci_vpfe/davinci_vpfe_user.h
index d3f34f9bf712..7cc115c9ebe6 100644
--- a/drivers/staging/media/davinci_vpfe/davinci_vpfe_user.h
+++ b/drivers/staging/media/davinci_vpfe/davinci_vpfe_user.h
@@ -155,8 +155,8 @@ struct vpfe_isif_dfc {
 };
 
 /************************************************************************
-*   Digital/Black clamp or DC Subtract parameters
-************************************************************************/
+ *   Digital/Black clamp or DC Subtract parameters
+ ************************************************************************/
 /**
  * Horizontal Black Clamp modes
  */
@@ -309,8 +309,8 @@ struct vpfe_isif_black_clamp {
 };
 
 /*************************************************************************
-** Color Space Conversion (CSC)
-*************************************************************************/
+ ** Color Space Conversion (CSC)
+ *************************************************************************/
 /**
  * Number of Coefficient values used for CSC
  */
@@ -331,8 +331,8 @@ struct float_16_bit {
 };
 
 /*************************************************************************
-**  Color Space Conversion parameters
-*************************************************************************/
+ **  Color Space Conversion parameters
+ *************************************************************************/
 /**
  * Structure used for CSC config params
  */
@@ -365,8 +365,8 @@ enum vpfe_isif_datasft {
 
 #define VPFE_ISIF_LINEAR_TAB_SIZE		192
 /*************************************************************************
-**  Linearization parameters
-*************************************************************************/
+ **  Linearization parameters
+ *************************************************************************/
 /**
  * Structure for Sensor data linearization
  */
@@ -382,8 +382,8 @@ struct vpfe_isif_linearize {
 };
 
 /*************************************************************************
-**  ISIF Raw configuration parameters
-*************************************************************************/
+ **  ISIF Raw configuration parameters
+ *************************************************************************/
 enum vpfe_isif_fmt_mode {
 	VPFE_ISIF_SPLIT,
 	VPFE_ISIF_COMBINE
@@ -1189,8 +1189,8 @@ struct vpfe_ipipe_config {
 };
 
 /*******************************************************************
-**  Resizer API structures
-*******************************************************************/
+ **  Resizer API structures
+ *******************************************************************/
 /* Interpolation types used for horizontal rescale */
 enum vpfe_rsz_intp_t {
 	VPFE_RSZ_INTP_CUBIC,
diff --git a/drivers/staging/media/davinci_vpfe/dm365_ipipe_hw.c b/drivers/staging/media/davinci_vpfe/dm365_ipipe_hw.c
index 958ef71ee4d5..a893072d0f04 100644
--- a/drivers/staging/media/davinci_vpfe/dm365_ipipe_hw.c
+++ b/drivers/staging/media/davinci_vpfe/dm365_ipipe_hw.c
@@ -1003,8 +1003,8 @@ void ipipe_set_car_regs(void __iomem *base_addr, struct vpfe_ipipe_car *car)
 		ipipe_set_mf(base_addr);
 		ipipe_set_gain_ctrl(base_addr, car);
 		/* Set the threshold for switching between
-		  * the two Here we overwrite the MF SW0 value
-		  */
+		 * the two Here we overwrite the MF SW0 value
+		 */
 		regw_ip(base_addr, VPFE_IPIPE_CAR_DYN_SWITCH, CAR_TYP);
 		val = car->sw1;
 		val <<= CAR_SW1_SHIFT;
diff --git a/drivers/staging/media/davinci_vpfe/dm365_isif_regs.h b/drivers/staging/media/davinci_vpfe/dm365_isif_regs.h
index 8aceabb43f8e..64fbb459baa2 100644
--- a/drivers/staging/media/davinci_vpfe/dm365_isif_regs.h
+++ b/drivers/staging/media/davinci_vpfe/dm365_isif_regs.h
@@ -59,8 +59,8 @@
 #define REC656IF				0x84
 #define CCDCFG					0x88
 /*****************************************************
-* Defect Correction registers
-*****************************************************/
+ * Defect Correction registers
+ *****************************************************/
 #define DFCCTL					0x8c
 #define VDFSATLV				0x90
 #define DFCMEMCTL				0x94
@@ -70,8 +70,8 @@
 #define DFCMEM3					0xa4
 #define DFCMEM4					0xa8
 /****************************************************
-* Black Clamp registers
-****************************************************/
+ * Black Clamp registers
+ ****************************************************/
 #define CLAMPCFG				0xac
 #define CLDCOFST				0xb0
 #define CLSV					0xb4
@@ -84,8 +84,8 @@
 #define CLVWIN2					0xd0
 #define CLVWIN3					0xd4
 /****************************************************
-* Lense Shading Correction
-****************************************************/
+ * Lense Shading Correction
+ ****************************************************/
 #define DATAHOFST				0xd8
 #define DATAVOFST				0xdc
 #define LSCHVAL					0xe0
@@ -102,8 +102,8 @@
 #define TWODLSCIRQEN				0x10c
 #define TWODLSCIRQST				0x110
 /****************************************************
-* Data formatter
-****************************************************/
+ * Data formatter
+ ****************************************************/
 #define FMTCFG					0x114
 #define FMTPLEN					0x118
 #define FMTSPH					0x11c
@@ -128,8 +128,8 @@
 #define FMTPGMAPS6				0x19c
 #define FMTPGMAPS7				0x1a0
 /************************************************
-* Color Space Converter
-************************************************/
+ * Color Space Converter
+ ************************************************/
 #define CSCCTL					0x1a4
 #define CSCM0					0x1a8
 #define CSCM1					0x1ac
diff --git a/drivers/staging/media/davinci_vpfe/dm365_resizer.c b/drivers/staging/media/davinci_vpfe/dm365_resizer.c
index 5fbc2d447ff2..857b0e847c5e 100644
--- a/drivers/staging/media/davinci_vpfe/dm365_resizer.c
+++ b/drivers/staging/media/davinci_vpfe/dm365_resizer.c
@@ -1133,9 +1133,9 @@ void vpfe_resizer_buffer_isr(struct vpfe_resizer_device *resizer)
 		}
 	} else if (fid == 0) {
 		/*
-		* out of sync. Recover from any hardware out-of-sync.
-		* May loose one frame
-		*/
+		 * out of sync. Recover from any hardware out-of-sync.
+		 * May loose one frame
+		 */
 		video_out->field_id = fid;
 	}
 }
-- 
2.11.1

