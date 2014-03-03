Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49327 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753750AbaCCKHw (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Mar 2014 05:07:52 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 15/79] [media] drx-j: do more CodingStyle fixes
Date: Mon,  3 Mar 2014 07:06:09 -0300
Message-Id: <1393841233-24840-16-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1393841233-24840-1-git-send-email-m.chehab@samsung.com>
References: <1393841233-24840-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This time, use checkpatch --strict --fix.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/dvb-frontends/drx39xyj/drx39xxj.c    |   2 +-
 drivers/media/dvb-frontends/drx39xyj/drx39xxj.h    |   2 +-
 .../media/dvb-frontends/drx39xyj/drx39xxj_dummy.c  |   2 +-
 .../media/dvb-frontends/drx39xyj/drx_dap_fasi.c    |  32 +--
 .../media/dvb-frontends/drx39xyj/drx_dap_fasi.h    |   4 +-
 drivers/media/dvb-frontends/drx39xyj/drx_driver.c  |  20 +-
 drivers/media/dvb-frontends/drx39xyj/drx_driver.h  |  32 +--
 drivers/media/dvb-frontends/drx39xyj/drxj.c        | 270 ++++++++++-----------
 drivers/media/dvb-frontends/drx39xyj/drxj.h        |   6 +-
 drivers/media/dvb-frontends/drx39xyj/drxj_mc.h     |   2 +-
 drivers/media/dvb-frontends/drx39xyj/drxj_mc_vsb.h |   2 +-
 .../media/dvb-frontends/drx39xyj/drxj_mc_vsbqam.h  |   2 +-
 12 files changed, 188 insertions(+), 188 deletions(-)

diff --git a/drivers/media/dvb-frontends/drx39xyj/drx39xxj.c b/drivers/media/dvb-frontends/drx39xyj/drx39xxj.c
index d80ef7ee09b8..d32bab033bf0 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drx39xxj.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drx39xxj.c
@@ -376,7 +376,7 @@ struct dvb_frontend *drx39xxj_attach(struct i2c_adapter *i2c)
 
 	demod->my_ext_attr = demod_ext_attr;
 	memcpy(demod->my_ext_attr, &drxj_data_g, sizeof(drxj_data_t));
-	((drxj_data_t *) demod->my_ext_attr)->uio_sma_tx_mode =
+	((drxj_data_t *)demod->my_ext_attr)->uio_sma_tx_mode =
 	    DRX_UIO_MODE_READWRITE;
 
 	demod->my_tuner = NULL;
diff --git a/drivers/media/dvb-frontends/drx39xyj/drx39xxj.h b/drivers/media/dvb-frontends/drx39xyj/drx39xxj.h
index 30657c8eaa5f..622172d25a9f 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drx39xxj.h
+++ b/drivers/media/dvb-frontends/drx39xyj/drx39xxj.h
@@ -35,6 +35,6 @@ struct drx39xxj_state {
 	unsigned int i2c_gate_open:1;
 };
 
-extern struct dvb_frontend *drx39xxj_attach(struct i2c_adapter *i2c);
+struct dvb_frontend *drx39xxj_attach(struct i2c_adapter *i2c);
 
 #endif /* DVB_DUMMY_FE_H */
diff --git a/drivers/media/dvb-frontends/drx39xyj/drx39xxj_dummy.c b/drivers/media/dvb-frontends/drx39xyj/drx39xxj_dummy.c
index 61e04c68db41..2cedf7c90385 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drx39xxj_dummy.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drx39xxj_dummy.c
@@ -30,7 +30,7 @@ int drxbsp_tuner_set_frequency(struct tuner_instance *tuner,
 
 int
 drxbsp_tuner_get_frequency(struct tuner_instance *tuner,
-			  u32 mode,
+			   u32 mode,
 			  s32 *r_ffrequency,
 			  s32 *i_ffrequency)
 {
diff --git a/drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c b/drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c
index 71805b46a5e5..9e9556b6d8a4 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c
@@ -252,8 +252,8 @@ static int drxdap_fasi_read_block(struct i2c_device_addr *dev_addr,
 		addr &= ~DRXDAP_FASI_FLAGS;
 		addr |= flags;
 
-#if (( DRXDAPFASI_LONG_ADDR_ALLOWED == 1) && \
-      (DRXDAPFASI_SHORT_ADDR_ALLOWED == 1) )
+#if ((DRXDAPFASI_LONG_ADDR_ALLOWED == 1) && \
+      (DRXDAPFASI_SHORT_ADDR_ALLOWED == 1))
 		/* short format address preferred but long format otherwise */
 		if (DRXDAP_FASI_LONG_FORMAT(addr)) {
 #endif
@@ -263,8 +263,8 @@ static int drxdap_fasi_read_block(struct i2c_device_addr *dev_addr,
 			buf[bufx++] = (u8) ((addr >> 24) & 0xFF);
 			buf[bufx++] = (u8) ((addr >> 7) & 0xFF);
 #endif
-#if (( DRXDAPFASI_LONG_ADDR_ALLOWED == 1) && \
-      (DRXDAPFASI_SHORT_ADDR_ALLOWED == 1) )
+#if ((DRXDAPFASI_LONG_ADDR_ALLOWED == 1) && \
+      (DRXDAPFASI_SHORT_ADDR_ALLOWED == 1))
 		} else {
 #endif
 #if (DRXDAPFASI_SHORT_ADDR_ALLOWED == 1)
@@ -273,8 +273,8 @@ static int drxdap_fasi_read_block(struct i2c_device_addr *dev_addr,
 			    (u8) (((addr >> 16) & 0x0F) |
 				    ((addr >> 18) & 0xF0));
 #endif
-#if (( DRXDAPFASI_LONG_ADDR_ALLOWED == 1) && \
-      (DRXDAPFASI_SHORT_ADDR_ALLOWED == 1) )
+#if ((DRXDAPFASI_LONG_ADDR_ALLOWED == 1) && \
+      (DRXDAPFASI_SHORT_ADDR_ALLOWED == 1))
 		}
 #endif
 
@@ -478,8 +478,8 @@ static int drxdap_fasi_write_block(struct i2c_device_addr *dev_addr,
 		/* Buffer device address */
 		addr &= ~DRXDAP_FASI_FLAGS;
 		addr |= flags;
-#if (( (DRXDAPFASI_LONG_ADDR_ALLOWED) == 1) && \
-      ((DRXDAPFASI_SHORT_ADDR_ALLOWED) == 1) )
+#if (((DRXDAPFASI_LONG_ADDR_ALLOWED) == 1) && \
+      ((DRXDAPFASI_SHORT_ADDR_ALLOWED) == 1))
 		/* short format address preferred but long format otherwise */
 		if (DRXDAP_FASI_LONG_FORMAT(addr)) {
 #endif
@@ -489,8 +489,8 @@ static int drxdap_fasi_write_block(struct i2c_device_addr *dev_addr,
 			buf[bufx++] = (u8) ((addr >> 24) & 0xFF);
 			buf[bufx++] = (u8) ((addr >> 7) & 0xFF);
 #endif
-#if (( (DRXDAPFASI_LONG_ADDR_ALLOWED) == 1) && \
-      ((DRXDAPFASI_SHORT_ADDR_ALLOWED) == 1) )
+#if (((DRXDAPFASI_LONG_ADDR_ALLOWED) == 1) && \
+      ((DRXDAPFASI_SHORT_ADDR_ALLOWED) == 1))
 		} else {
 #endif
 #if ((DRXDAPFASI_SHORT_ADDR_ALLOWED) == 1)
@@ -499,8 +499,8 @@ static int drxdap_fasi_write_block(struct i2c_device_addr *dev_addr,
 			    (u8) (((addr >> 16) & 0x0F) |
 				    ((addr >> 18) & 0xF0));
 #endif
-#if (( (DRXDAPFASI_LONG_ADDR_ALLOWED) == 1) && \
-      ((DRXDAPFASI_SHORT_ADDR_ALLOWED) == 1) )
+#if (((DRXDAPFASI_LONG_ADDR_ALLOWED) == 1) && \
+      ((DRXDAPFASI_SHORT_ADDR_ALLOWED) == 1))
 		}
 #endif
 
@@ -526,8 +526,8 @@ static int drxdap_fasi_write_block(struct i2c_device_addr *dev_addr,
 			st = drxbsp_i2c_write_read(dev_addr,
 						  (u16) (bufx),
 						  buf,
-						  (struct i2c_device_addr *) (NULL),
-						  0, (u8 *) (NULL));
+						  (struct i2c_device_addr *)(NULL),
+						  0, (u8 *)(NULL));
 
 			if ((st != DRX_STS_OK) && (first_err == DRX_STS_OK)) {
 				/* at the end, return the first error encountered */
@@ -543,8 +543,8 @@ static int drxdap_fasi_write_block(struct i2c_device_addr *dev_addr,
 		st = drxbsp_i2c_write_read(dev_addr,
 					  (u16) (bufx + todo),
 					  buf,
-					  (struct i2c_device_addr *) (NULL),
-					  0, (u8 *) (NULL));
+					  (struct i2c_device_addr *)(NULL),
+					  0, (u8 *)(NULL));
 
 		if ((st != DRX_STS_OK) && (first_err == DRX_STS_OK)) {
 			/* at the end, return the first error encountered */
diff --git a/drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.h b/drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.h
index 4152d6290bf8..02b2c3037954 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.h
+++ b/drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.h
@@ -93,8 +93,8 @@
 #endif
 
 /* check */
-#if (( DRXDAPFASI_LONG_ADDR_ALLOWED == 0) && \
-      (DRXDAPFASI_SHORT_ADDR_ALLOWED == 0) )
+#if ((DRXDAPFASI_LONG_ADDR_ALLOWED == 0) && \
+      (DRXDAPFASI_SHORT_ADDR_ALLOWED == 0))
 #error  At least one of short- or long-addressing format must be allowed.
 *;				/* illegal statement to force compiler error */
 #endif
diff --git a/drivers/media/dvb-frontends/drx39xyj/drx_driver.c b/drivers/media/dvb-frontends/drx39xyj/drx_driver.c
index 847e17a91e41..e8d1a26bf581 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drx_driver.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drx_driver.c
@@ -99,7 +99,7 @@ DEFINES
 /*=== MACROS =================================================================*/
 /*============================================================================*/
 
-#define DRX_ISPOWERDOWNMODE(mode) (  ( mode == DRX_POWER_MODE_9  ) || \
+#define DRX_ISPOWERDOWNMODE(mode) (( mode == DRX_POWER_MODE_9) || \
 				       (mode == DRX_POWER_MODE_10) || \
 				       (mode == DRX_POWER_MODE_11) || \
 				       (mode == DRX_POWER_MODE_12) || \
@@ -107,7 +107,7 @@ DEFINES
 				       (mode == DRX_POWER_MODE_14) || \
 				       (mode == DRX_POWER_MODE_15) || \
 				       (mode == DRX_POWER_MODE_16) || \
-				       (mode == DRX_POWER_DOWN) )
+				       (mode == DRX_POWER_DOWN))
 
 /*------------------------------------------------------------------------------
 GLOBAL VARIABLES
@@ -147,7 +147,7 @@ FUNCTIONS
 /* Prototype of default scanning function */
 static int
 scan_function_default(void *scan_context,
-		    drx_scan_command_t scan_command,
+		      drx_scan_command_t scan_command,
 		    pdrx_channel_t scan_channel, bool *get_next_channel);
 
 /**
@@ -355,7 +355,7 @@ scan_prepare_next_scan(pdrx_demod_instance_t demod, s32 skip)
 */
 static int
 scan_function_default(void *scan_context,
-		    drx_scan_command_t scan_command,
+		      drx_scan_command_t scan_command,
 		    pdrx_channel_t scan_channel, bool *get_next_channel)
 {
 	pdrx_demod_instance_t demod = NULL;
@@ -604,7 +604,7 @@ static int ctrl_scan_stop(pdrx_demod_instance_t demod)
 static int ctrl_scan_next(pdrx_demod_instance_t demod, u16 *scan_progress)
 {
 	pdrx_common_attr_t common_attr = (pdrx_common_attr_t) (NULL);
-	bool *scan_ready = (bool *) (NULL);
+	bool *scan_ready = (bool *)(NULL);
 	u16 max_progress = DRX_SCAN_MAX_PROGRESS;
 	u32 num_tries = 0;
 	u32 i = 0;
@@ -983,14 +983,14 @@ static u16 u_code_compute_crc(u8 *block_data, u16 nr_words)
 */
 static int
 ctrl_u_code(pdrx_demod_instance_t demod,
-	  p_drxu_code_info_t mc_info, drxu_code_action_t action)
+	    p_drxu_code_info_t mc_info, drxu_code_action_t action)
 {
 	int rc;
 	u16 i = 0;
 	u16 mc_nr_of_blks = 0;
 	u16 mc_magic_word = 0;
-	u8 *mc_data = (u8 *) (NULL);
-	struct i2c_device_addr *dev_addr = (struct i2c_device_addr *) (NULL);
+	u8 *mc_data = (u8 *)(NULL);
+	struct i2c_device_addr *dev_addr = (struct i2c_device_addr *)(NULL);
 
 	dev_addr = demod->my_i2c_dev_addr;
 
@@ -1420,7 +1420,7 @@ drx_ctrl(pdrx_demod_instance_t demod, u32 ctrl, void *ctrl_data)
 
       /*======================================================================*/
 	case DRX_CTRL_VERSION:
-		return ctrl_version(demod, (p_drx_version_list_t *) ctrl_data);
+		return ctrl_version(demod, (p_drx_version_list_t *)ctrl_data);
 		break;
 
       /*======================================================================*/
@@ -1463,7 +1463,7 @@ drx_ctrl(pdrx_demod_instance_t demod, u32 ctrl, void *ctrl_data)
 	 /*===================================================================*/
 		case DRX_CTRL_SCAN_NEXT:
 			{
-				return ctrl_scan_next(demod, (u16 *) ctrl_data);
+				return ctrl_scan_next(demod, (u16 *)ctrl_data);
 			}
 			break;
 
diff --git a/drivers/media/dvb-frontends/drx39xyj/drx_driver.h b/drivers/media/dvb-frontends/drx39xyj/drx_driver.h
index f4a041139ee9..ca07a6c4f58d 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drx_driver.h
+++ b/drivers/media/dvb-frontends/drx39xyj/drx_driver.h
@@ -493,23 +493,23 @@ MACROS
 /**
 * \brief Macro to sign extend signed 9 bit value to signed  16 bit value
 */
-#define DRX_S9TOS16(x) ((((u16)x)&0x100)?((s16)((u16)(x)|0xFF00)):(x))
+#define DRX_S9TOS16(x) ((((u16)x)&0x100) ? ((s16)((u16)(x)|0xFF00)) : (x))
 
 /**
 * \brief Macro to sign extend signed 9 bit value to signed  16 bit value
 */
-#define DRX_S24TODRXFREQ(x) (( ( (u32) x) & 0x00800000UL ) ? \
+#define DRX_S24TODRXFREQ(x) ((( (u32) x) & 0x00800000UL) ? \
 				 ((s32) \
-				    (( (u32) x) | 0xFF000000 ) ) : \
-				 ((s32) x) )
+				    (((u32) x) | 0xFF000000) ) : \
+				 ((s32) x))
 
 /**
 * \brief Macro to convert 16 bit register value to a s32
 */
-#define DRX_U16TODRXFREQ(x)   (( x & 0x8000) ? \
+#define DRX_U16TODRXFREQ(x)   ((x & 0x8000) ? \
 				 ((s32) \
-				    (( (u32) x) | 0xFFFF0000 ) ) : \
-				 ((s32) x) )
+				    (((u32) x) | 0xFFFF0000) ) : \
+				 ((s32) x))
 
 /*-------------------------------------------------------------------------
 ENUM
@@ -2868,14 +2868,14 @@ Access macros
 #define DRX_GET_PRESET(d, x) \
    DRX_ACCESSMACRO_GET((d), (x), DRX_XS_CFG_PRESET, char*, "ERROR")
 
-#define DRX_SET_AUD_BTSC_DETECT(d, x) DRX_ACCESSMACRO_SET( (d), (x), \
+#define DRX_SET_AUD_BTSC_DETECT(d, x) DRX_ACCESSMACRO_SET((d), (x), \
 	 DRX_XS_CFG_AUD_BTSC_DETECT, drx_aud_btsc_detect_t)
-#define DRX_GET_AUD_BTSC_DETECT(d, x) DRX_ACCESSMACRO_GET( (d), (x), \
+#define DRX_GET_AUD_BTSC_DETECT(d, x) DRX_ACCESSMACRO_GET((d), (x), \
 	 DRX_XS_CFG_AUD_BTSC_DETECT, drx_aud_btsc_detect_t, DRX_UNKNOWN)
 
-#define DRX_SET_QAM_LOCKRANGE(d, x) DRX_ACCESSMACRO_SET( (d), (x), \
+#define DRX_SET_QAM_LOCKRANGE(d, x) DRX_ACCESSMACRO_SET((d), (x), \
 	 DRX_XS_CFG_QAM_LOCKRANGE, drx_qam_lock_range_t)
-#define DRX_GET_QAM_LOCKRANGE(d, x) DRX_ACCESSMACRO_GET( (d), (x), \
+#define DRX_GET_QAM_LOCKRANGE(d, x) DRX_ACCESSMACRO_GET((d), (x), \
 	 DRX_XS_CFG_QAM_LOCKRANGE, drx_qam_lock_range_t, DRX_UNKNOWN)
 
 /**
@@ -2883,20 +2883,20 @@ Access macros
 * \retval true std is an ATV standard
 * \retval false std is an ATV standard
 */
-#define DRX_ISATVSTD(std) ( ( (std) == DRX_STANDARD_PAL_SECAM_BG ) || \
+#define DRX_ISATVSTD(std) (( (std) == DRX_STANDARD_PAL_SECAM_BG) || \
 			      ((std) == DRX_STANDARD_PAL_SECAM_DK) || \
 			      ((std) == DRX_STANDARD_PAL_SECAM_I) || \
 			      ((std) == DRX_STANDARD_PAL_SECAM_L) || \
 			      ((std) == DRX_STANDARD_PAL_SECAM_LP) || \
 			      ((std) == DRX_STANDARD_NTSC) || \
-			      ((std) == DRX_STANDARD_FM) )
+			      ((std) == DRX_STANDARD_FM))
 
 /**
 * \brief Macro to check if std is an QAM standard
 * \retval true std is an QAM standards
 * \retval false std is an QAM standards
 */
-#define DRX_ISQAMSTD(std) ( ( (std) == DRX_STANDARD_ITU_A ) || \
+#define DRX_ISQAMSTD(std) (( (std) == DRX_STANDARD_ITU_A) || \
 			      ((std) == DRX_STANDARD_ITU_B) || \
 			      ((std) == DRX_STANDARD_ITU_C) || \
 			      ((std) == DRX_STANDARD_ITU_D))
@@ -2906,14 +2906,14 @@ Access macros
 * \retval true std is VSB standard
 * \retval false std is not VSB standard
 */
-#define DRX_ISVSBSTD(std) ( (std) == DRX_STANDARD_8VSB )
+#define DRX_ISVSBSTD(std) ((std) == DRX_STANDARD_8VSB)
 
 /**
 * \brief Macro to check if std is DVBT standard
 * \retval true std is DVBT standard
 * \retval false std is not DVBT standard
 */
-#define DRX_ISDVBTSTD(std) ( (std) == DRX_STANDARD_DVBT )
+#define DRX_ISDVBTSTD(std) ((std) == DRX_STANDARD_DVBT)
 
 /*-------------------------------------------------------------------------
 Exported FUNCTIONS
diff --git a/drivers/media/dvb-frontends/drx39xyj/drxj.c b/drivers/media/dvb-frontends/drx39xyj/drxj.c
index 3a63520b745c..bd7ad1838d89 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drxj.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drxj.c
@@ -509,34 +509,34 @@ DEFINES
    } while (0)
 
 #define WR16(dev, addr, val) \
-   CHK_ERROR(DRXJ_DAP.write_reg16func( (dev), (addr), (val), 0) )
+   CHK_ERROR(DRXJ_DAP.write_reg16func((dev), (addr), (val), 0))
 
 #define RR16(dev, addr, val) \
-   CHK_ERROR(DRXJ_DAP.read_reg16func( (dev), (addr), (val), 0) )
+   CHK_ERROR(DRXJ_DAP.read_reg16func((dev), (addr), (val), 0))
 
 #define WR32(dev, addr, val) \
-   CHK_ERROR(DRXJ_DAP.write_reg32func( (dev), (addr), (val), 0) )
+   CHK_ERROR(DRXJ_DAP.write_reg32func((dev), (addr), (val), 0))
 
 #define RR32(dev, addr, val) \
-   CHK_ERROR(DRXJ_DAP.read_reg32func( (dev), (addr), (val), 0) )
+   CHK_ERROR(DRXJ_DAP.read_reg32func((dev), (addr), (val), 0))
 
 #define WRB(dev, addr, len, block) \
-   CHK_ERROR(DRXJ_DAP.write_block_func( (dev), (addr), (len), (block), 0) )
+   CHK_ERROR(DRXJ_DAP.write_block_func((dev), (addr), (len), (block), 0))
 
 #define RRB(dev, addr, len, block) \
-   CHK_ERROR(DRXJ_DAP.read_block_func( (dev), (addr), (len), (block), 0) )
+   CHK_ERROR(DRXJ_DAP.read_block_func((dev), (addr), (len), (block), 0))
 
 #define BCWR16(dev, addr, val) \
-   CHK_ERROR(DRXJ_DAP.write_reg16func( (dev), (addr), (val), DRXDAP_FASI_BROADCAST) )
+   CHK_ERROR(DRXJ_DAP.write_reg16func((dev), (addr), (val), DRXDAP_FASI_BROADCAST))
 
 #define ARR32(dev, addr, val) \
-   CHK_ERROR(drxj_dap_atomic_read_reg32( (dev), (addr), (val), 0) )
+   CHK_ERROR(drxj_dap_atomic_read_reg32((dev), (addr), (val), 0))
 
 #define SARR16(dev, addr, val) \
-   CHK_ERROR(drxj_dap_scu_atomic_read_reg16( (dev), (addr), (val), 0) )
+   CHK_ERROR(drxj_dap_scu_atomic_read_reg16((dev), (addr), (val), 0))
 
 #define SAWR16(dev, addr, val) \
-   CHK_ERROR(drxj_dap_scu_atomic_write_reg16( (dev), (addr), (val), 0) )
+   CHK_ERROR(drxj_dap_scu_atomic_write_reg16((dev), (addr), (val), 0))
 
 /**
 * This macro is used to create byte arrays for block writes.
@@ -570,15 +570,15 @@ DEFINES
 /*=== STANDARD RELATED MACROS ================================================*/
 /*============================================================================*/
 
-#define DRXJ_ISATVSTD(std) ( ( std == DRX_STANDARD_PAL_SECAM_BG ) || \
+#define DRXJ_ISATVSTD(std) (( std == DRX_STANDARD_PAL_SECAM_BG) || \
 			       (std == DRX_STANDARD_PAL_SECAM_DK) || \
 			       (std == DRX_STANDARD_PAL_SECAM_I) || \
 			       (std == DRX_STANDARD_PAL_SECAM_L) || \
 			       (std == DRX_STANDARD_PAL_SECAM_LP) || \
 			       (std == DRX_STANDARD_NTSC) || \
-			       (std == DRX_STANDARD_FM) )
+			       (std == DRX_STANDARD_FM))
 
-#define DRXJ_ISQAMSTD(std) ( ( std == DRX_STANDARD_ITU_A ) || \
+#define DRXJ_ISQAMSTD(std) (( std == DRX_STANDARD_ITU_A) || \
 			       (std == DRX_STANDARD_ITU_B) || \
 			       (std == DRX_STANDARD_ITU_C) || \
 			       (std == DRX_STANDARD_ITU_D))
@@ -950,7 +950,7 @@ struct i2c_device_addr drxj_default_addr_g = {
 * \brief Default common attributes of a drxj demodulator instance.
 */
 drx_common_attr_t drxj_default_comm_attr_g = {
-	(u8 *) NULL,		/* ucode ptr            */
+	(u8 *)NULL,		/* ucode ptr            */
 	0,			/* ucode size           */
 	true,			/* ucode verify switch  */
 	{0},			/* version record       */
@@ -1147,7 +1147,7 @@ FUNCTIONS
 /* Some prototypes */
 static int
 hi_command(struct i2c_device_addr *dev_addr,
-	  const pdrxj_hi_cmd_t cmd, u16 *result);
+	   const pdrxj_hi_cmd_t cmd, u16 *result);
 
 static int
 ctrl_lock_status(pdrx_demod_instance_t demod, pdrx_lock_status_t lock_stat);
@@ -1173,7 +1173,7 @@ ctrl_set_cfg_afe_gain(pdrx_demod_instance_t demod, p_drxj_cfg_afe_gain_t afe_gai
 #ifdef DRXJ_SPLIT_UCODE_UPLOAD
 static int
 ctrl_u_codeUpload(pdrx_demod_instance_t demod,
-		p_drxu_code_info_t mc_info,
+		  p_drxu_code_info_t mc_info,
 		drxu_code_action_t action, bool audio_mc_upload);
 #endif /* DRXJ_SPLIT_UCODE_UPLOAD */
 
@@ -1683,7 +1683,7 @@ static const u16 nicam_presc_table_val[43] =
    TODO: check ignoring single/multimaster is ok for AUD access ?
 */
 
-#define DRXJ_ISAUDWRITE(addr) (((((addr)>>16)&1) == 1)?true:false)
+#define DRXJ_ISAUDWRITE(addr) (((((addr)>>16)&1) == 1) ? true : false)
 #define DRXJ_DAP_AUDTRIF_TIMEOUT 80	/* millisec */
 /*============================================================================*/
 
@@ -2136,7 +2136,7 @@ int drxj_dap_atomic_read_write_block(struct i2c_device_addr *dev_addr,
 			word = ((u16) data[2 * i]);
 			word += (((u16) data[(2 * i) + 1]) << 8);
 			drxj_dap_write_reg16(dev_addr,
-					    (DRXJ_HI_ATOMIC_BUF_START + i),
+					     (DRXJ_HI_ATOMIC_BUF_START + i),
 					    word, 0);
 		}
 	}
@@ -2147,7 +2147,7 @@ int drxj_dap_atomic_read_write_block(struct i2c_device_addr *dev_addr,
 		/* read data from buffer */
 		for (i = 0; i < (datasize / 2); i++) {
 			drxj_dap_read_reg16(dev_addr,
-					   (DRXJ_HI_ATOMIC_BUF_START + i),
+					    (DRXJ_HI_ATOMIC_BUF_START + i),
 					   &word, 0);
 			data[2 * i] = (u8) (word & 0xFF);
 			data[(2 * i) + 1] = (u8) (word >> 8);
@@ -2338,7 +2338,7 @@ static int init_hi(const pdrx_demod_instance_t demod)
 {
 	pdrxj_data_t ext_attr = (pdrxj_data_t) (NULL);
 	pdrx_common_attr_t common_attr = (pdrx_common_attr_t) (NULL);
-	struct i2c_device_addr *dev_addr = (struct i2c_device_addr *) (NULL);
+	struct i2c_device_addr *dev_addr = (struct i2c_device_addr *)(NULL);
 
 	ext_attr = (pdrxj_data_t) demod->my_ext_attr;
 	common_attr = (pdrx_common_attr_t) demod->my_common_attr;
@@ -2415,7 +2415,7 @@ static int get_device_capabilities(pdrx_demod_instance_t demod)
 {
 	pdrx_common_attr_t common_attr = (pdrx_common_attr_t) (NULL);
 	pdrxj_data_t ext_attr = (pdrxj_data_t) NULL;
-	struct i2c_device_addr *dev_addr = (struct i2c_device_addr *) (NULL);
+	struct i2c_device_addr *dev_addr = (struct i2c_device_addr *)(NULL);
 	u16 sio_pdr_ohw_cfg = 0;
 	u32 sio_top_jtagid_lo = 0;
 	u16 bid = 0;
@@ -2588,7 +2588,7 @@ rw_error:
 
 static int power_up_device(pdrx_demod_instance_t demod)
 {
-	struct i2c_device_addr *dev_addr = (struct i2c_device_addr *) (NULL);
+	struct i2c_device_addr *dev_addr = (struct i2c_device_addr *)(NULL);
 	u8 data = 0;
 	u16 retry_count = 0;
 	struct i2c_device_addr wake_up_addr;
@@ -2603,12 +2603,12 @@ static int power_up_device(pdrx_demod_instance_t demod)
 	do {
 		data = 0;
 		drxbsp_i2c_write_read(&wake_up_addr, 1, &data,
-				     (struct i2c_device_addr *) (NULL), 0,
-				     (u8 *) (NULL));
+				      (struct i2c_device_addr *)(NULL), 0,
+				     (u8 *)(NULL));
 		drxbsp_hst_sleep(10);
 		retry_count++;
 	} while ((drxbsp_i2c_write_read
-		  ((struct i2c_device_addr *) (NULL), 0, (u8 *) (NULL), dev_addr, 1,
+		  ((struct i2c_device_addr *) (NULL), 0, (u8 *)(NULL), dev_addr, 1,
 		   &data)
 		  != DRX_STS_OK) && (retry_count < DRXJ_MAX_RETRIES_POWERUP));
 
@@ -2638,7 +2638,7 @@ static int power_up_device(pdrx_demod_instance_t demod)
 static int
 ctrl_set_cfg_mpeg_output(pdrx_demod_instance_t demod, pdrx_cfg_mpeg_output_t cfg_data)
 {
-	struct i2c_device_addr *dev_addr = (struct i2c_device_addr *) (NULL);
+	struct i2c_device_addr *dev_addr = (struct i2c_device_addr *)(NULL);
 	pdrxj_data_t ext_attr = (pdrxj_data_t) (NULL);
 	pdrx_common_attr_t common_attr = (pdrx_common_attr_t) (NULL);
 	u16 fec_oc_reg_mode = 0;
@@ -3040,7 +3040,7 @@ rw_error:
 static int
 ctrl_get_cfg_mpeg_output(pdrx_demod_instance_t demod, pdrx_cfg_mpeg_output_t cfg_data)
 {
-	struct i2c_device_addr *dev_addr = (struct i2c_device_addr *) (NULL);
+	struct i2c_device_addr *dev_addr = (struct i2c_device_addr *)(NULL);
 	pdrx_common_attr_t common_attr = (pdrx_common_attr_t) (NULL);
 	drx_lock_status_t lock_status = DRX_NOT_LOCKED;
 	u32 rate_reg = 0;
@@ -3098,7 +3098,7 @@ rw_error:
 static int set_mpegtei_handling(pdrx_demod_instance_t demod)
 {
 	pdrxj_data_t ext_attr = (pdrxj_data_t) (NULL);
-	struct i2c_device_addr *dev_addr = (struct i2c_device_addr *) (NULL);
+	struct i2c_device_addr *dev_addr = (struct i2c_device_addr *)(NULL);
 	u16 fec_oc_dpr_mode = 0;
 	u16 fec_oc_snc_mode = 0;
 	u16 fec_oc_ems_mode = 0;
@@ -3146,7 +3146,7 @@ rw_error:
 static int bit_reverse_mpeg_output(pdrx_demod_instance_t demod)
 {
 	pdrxj_data_t ext_attr = (pdrxj_data_t) (NULL);
-	struct i2c_device_addr *dev_addr = (struct i2c_device_addr *) (NULL);
+	struct i2c_device_addr *dev_addr = (struct i2c_device_addr *)(NULL);
 	u16 fec_oc_ipr_mode = 0;
 
 	dev_addr = demod->my_i2c_dev_addr;
@@ -3182,7 +3182,7 @@ rw_error:
 static int set_mpeg_output_clock_rate(pdrx_demod_instance_t demod)
 {
 	pdrxj_data_t ext_attr = (pdrxj_data_t) (NULL);
-	struct i2c_device_addr *dev_addr = (struct i2c_device_addr *) (NULL);
+	struct i2c_device_addr *dev_addr = (struct i2c_device_addr *)(NULL);
 
 	dev_addr = demod->my_i2c_dev_addr;
 	ext_attr = (pdrxj_data_t) demod->my_ext_attr;
@@ -3210,7 +3210,7 @@ rw_error:
 static int set_mpeg_start_width(pdrx_demod_instance_t demod)
 {
 	pdrxj_data_t ext_attr = (pdrxj_data_t) (NULL);
-	struct i2c_device_addr *dev_addr = (struct i2c_device_addr *) (NULL);
+	struct i2c_device_addr *dev_addr = (struct i2c_device_addr *)(NULL);
 	u16 fec_oc_comm_mb = 0;
 	pdrx_common_attr_t common_attr = (pdrx_common_attr_t) NULL;
 
@@ -3247,7 +3247,7 @@ rw_error:
 */
 static int
 ctrl_set_cfg_mpeg_output_misc(pdrx_demod_instance_t demod,
-			 p_drxj_cfg_mpeg_output_misc_t cfg_data)
+			      p_drxj_cfg_mpeg_output_misc_t cfg_data)
 {
 	pdrxj_data_t ext_attr = (pdrxj_data_t) (NULL);
 
@@ -3297,7 +3297,7 @@ rw_error:
 */
 static int
 ctrl_get_cfg_mpeg_output_misc(pdrx_demod_instance_t demod,
-			 p_drxj_cfg_mpeg_output_misc_t cfg_data)
+			      p_drxj_cfg_mpeg_output_misc_t cfg_data)
 {
 	pdrxj_data_t ext_attr = (pdrxj_data_t) (NULL);
 	u16 data = 0;
@@ -4206,7 +4206,7 @@ ctrl_i2c_write_read(pdrx_demod_instance_t demod, pdrxi2c_data_t i2c_data)
 
 int
 tuner_i2c_write_read(struct tuner_instance *tuner,
-		  struct i2c_device_addr *w_dev_addr,
+		     struct i2c_device_addr *w_dev_addr,
 		  u16 w_count,
 		  u8 *wData,
 		  struct i2c_device_addr *r_dev_addr, u16 r_count, u8 *r_data)
@@ -4359,7 +4359,7 @@ static int
 ctrl_set_cfg_pdr_safe_mode(pdrx_demod_instance_t demod, bool *enable)
 {
 	pdrxj_data_t ext_attr = (pdrxj_data_t) NULL;
-	struct i2c_device_addr *dev_addr = (struct i2c_device_addr *) NULL;
+	struct i2c_device_addr *dev_addr = (struct i2c_device_addr *)NULL;
 	pdrx_common_attr_t common_attr = (pdrx_common_attr_t) NULL;
 
 	if (enable == NULL) {
@@ -4758,7 +4758,7 @@ rw_error:
 */
 static int
 set_frequency(pdrx_demod_instance_t demod,
-	     pdrx_channel_t channel, s32 tuner_freq_offset)
+	      pdrx_channel_t channel, s32 tuner_freq_offset)
 {
 	struct i2c_device_addr *dev_addr = NULL;
 	pdrx_common_attr_t common_attr = NULL;
@@ -5046,7 +5046,7 @@ static int get_ctl_freq_offset(pdrx_demod_instance_t demod, s32 *ctl_freq)
 
 	/* both registers are sign extended */
 	nominal_frequency = ext_attr->iqm_fs_rate_ofs;
-	ARR32(dev_addr, IQM_FS_RATE_LO__A, (u32 *) &current_frequency);
+	ARR32(dev_addr, IQM_FS_RATE_LO__A, (u32 *)&current_frequency);
 
 	if (ext_attr->pos_image == true) {
 		/* negative image */
@@ -5144,7 +5144,7 @@ set_agc_rf(pdrx_demod_instance_t demod, p_drxj_cfg_agc_t agc_settings, bool atom
 				  (dev_addr, SCU_RAM_AGC_KI_RED__A, &data, 0));
 			data &= ~SCU_RAM_AGC_KI_RED_RAGC_RED__M;
 			CHK_ERROR((*scu_wr16) (dev_addr, SCU_RAM_AGC_KI_RED__A,
-					      (~
+					       (~
 					       (agc_settings->
 						speed <<
 						SCU_RAM_AGC_KI_RED_RAGC_RED__B)
@@ -5383,7 +5383,7 @@ set_agc_if(pdrx_demod_instance_t demod, p_drxj_cfg_agc_t agc_settings, bool atom
 				  (dev_addr, SCU_RAM_AGC_KI_RED__A, &data, 0));
 			data &= ~SCU_RAM_AGC_KI_RED_IAGC_RED__M;
 			CHK_ERROR((*scu_wr16) (dev_addr, SCU_RAM_AGC_KI_RED__A,
-					      (~
+					       (~
 					       (agc_settings->
 						speed <<
 						SCU_RAM_AGC_KI_RED_IAGC_RED__B)
@@ -5468,7 +5468,7 @@ set_agc_if(pdrx_demod_instance_t demod, p_drxj_cfg_agc_t agc_settings, bool atom
 
 		/* always set the top to support configurations without if-loop */
 		CHK_ERROR((*scu_wr16) (dev_addr,
-				      SCU_RAM_AGC_INGAIN_TGT_MIN__A,
+				       SCU_RAM_AGC_INGAIN_TGT_MIN__A,
 				      agc_settings->top, 0));
 	}
 
@@ -5870,9 +5870,9 @@ static int set_vsb_leak_n_gain(pdrx_demod_instance_t demod)
 
 	dev_addr = demod->my_i2c_dev_addr;
 	WRB(dev_addr, VSB_SYSCTRL_RAM0_FFETRAINLKRATIO1__A,
-	    sizeof(vsb_ffe_leak_gain_ram0), ((u8 *) vsb_ffe_leak_gain_ram0));
+	    sizeof(vsb_ffe_leak_gain_ram0), ((u8 *)vsb_ffe_leak_gain_ram0));
 	WRB(dev_addr, VSB_SYSCTRL_RAM1_FIRRCA1GAIN9__A,
-	    sizeof(vsb_ffe_leak_gain_ram1), ((u8 *) vsb_ffe_leak_gain_ram1));
+	    sizeof(vsb_ffe_leak_gain_ram1), ((u8 *)vsb_ffe_leak_gain_ram1));
 
 	return (DRX_STS_OK);
 rw_error:
@@ -5966,9 +5966,9 @@ static int set_vsb(pdrx_demod_instance_t demod)
 	WR16(dev_addr, IQM_CF_POW_MEAS_LEN__A, 1);
 
 	WRB(dev_addr, IQM_CF_TAP_RE0__A, sizeof(vsb_taps_re),
-	    ((u8 *) vsb_taps_re));
+	    ((u8 *)vsb_taps_re));
 	WRB(dev_addr, IQM_CF_TAP_IM0__A, sizeof(vsb_taps_re),
-	    ((u8 *) vsb_taps_re));
+	    ((u8 *)vsb_taps_re));
 
 	WR16(dev_addr, VSB_TOP_BNTHRESH__A, 330);	/* set higher threshold */
 	WR16(dev_addr, VSB_TOP_CLPLASTNUM__A, 90);	/* burst detection on   */
@@ -6382,7 +6382,7 @@ rw_error:
 #ifndef DRXJ_VSB_ONLY
 static int
 set_qam_measurement(pdrx_demod_instance_t demod,
-		  enum drx_modulation constellation, u32 symbol_rate)
+		    enum drx_modulation constellation, u32 symbol_rate)
 {
 	struct i2c_device_addr *dev_addr = NULL;	/* device address for I2C writes */
 	pdrxj_data_t ext_attr = NULL;	/* Global data container for DRXJ specif data */
@@ -6564,9 +6564,9 @@ static int set_qam16(pdrx_demod_instance_t demod)
 	};
 
 	WRB(dev_addr, QAM_DQ_QUAL_FUN0__A, sizeof(qam_dq_qual_fun),
-	    ((u8 *) qam_dq_qual_fun));
+	    ((u8 *)qam_dq_qual_fun));
 	WRB(dev_addr, SCU_RAM_QAM_EQ_CMA_RAD0__A, sizeof(qam_eq_cma_rad),
-	    ((u8 *) qam_eq_cma_rad));
+	    ((u8 *)qam_eq_cma_rad));
 
 	WR16(dev_addr, SCU_RAM_QAM_FSM_RTH__A, 140);
 	WR16(dev_addr, SCU_RAM_QAM_FSM_FTH__A, 50);
@@ -6644,9 +6644,9 @@ static int set_qam32(pdrx_demod_instance_t demod)
 	};
 
 	WRB(dev_addr, QAM_DQ_QUAL_FUN0__A, sizeof(qam_dq_qual_fun),
-	    ((u8 *) qam_dq_qual_fun));
+	    ((u8 *)qam_dq_qual_fun));
 	WRB(dev_addr, SCU_RAM_QAM_EQ_CMA_RAD0__A, sizeof(qam_eq_cma_rad),
-	    ((u8 *) qam_eq_cma_rad));
+	    ((u8 *)qam_eq_cma_rad));
 
 	WR16(dev_addr, SCU_RAM_QAM_FSM_RTH__A, 90);
 	WR16(dev_addr, SCU_RAM_QAM_FSM_FTH__A, 50);
@@ -6724,9 +6724,9 @@ static int set_qam64(pdrx_demod_instance_t demod)
 	};
 
 	WRB(dev_addr, QAM_DQ_QUAL_FUN0__A, sizeof(qam_dq_qual_fun),
-	    ((u8 *) qam_dq_qual_fun));
+	    ((u8 *)qam_dq_qual_fun));
 	WRB(dev_addr, SCU_RAM_QAM_EQ_CMA_RAD0__A, sizeof(qam_eq_cma_rad),
-	    ((u8 *) qam_eq_cma_rad));
+	    ((u8 *)qam_eq_cma_rad));
 
 	WR16(dev_addr, SCU_RAM_QAM_FSM_RTH__A, 105);
 	WR16(dev_addr, SCU_RAM_QAM_FSM_FTH__A, 60);
@@ -6804,9 +6804,9 @@ static int set_qam128(pdrx_demod_instance_t demod)
 	};
 
 	WRB(dev_addr, QAM_DQ_QUAL_FUN0__A, sizeof(qam_dq_qual_fun),
-	    ((u8 *) qam_dq_qual_fun));
+	    ((u8 *)qam_dq_qual_fun));
 	WRB(dev_addr, SCU_RAM_QAM_EQ_CMA_RAD0__A, sizeof(qam_eq_cma_rad),
-	    ((u8 *) qam_eq_cma_rad));
+	    ((u8 *)qam_eq_cma_rad));
 
 	WR16(dev_addr, SCU_RAM_QAM_FSM_RTH__A, 50);
 	WR16(dev_addr, SCU_RAM_QAM_FSM_FTH__A, 60);
@@ -6884,9 +6884,9 @@ static int set_qam256(pdrx_demod_instance_t demod)
 	};
 
 	WRB(dev_addr, QAM_DQ_QUAL_FUN0__A, sizeof(qam_dq_qual_fun),
-	    ((u8 *) qam_dq_qual_fun));
+	    ((u8 *)qam_dq_qual_fun));
 	WRB(dev_addr, SCU_RAM_QAM_EQ_CMA_RAD0__A, sizeof(qam_eq_cma_rad),
-	    ((u8 *) qam_eq_cma_rad));
+	    ((u8 *)qam_eq_cma_rad));
 
 	WR16(dev_addr, SCU_RAM_QAM_FSM_RTH__A, 50);
 	WR16(dev_addr, SCU_RAM_QAM_FSM_FTH__A, 60);
@@ -6949,7 +6949,7 @@ rw_error:
 */
 static int
 set_qam(pdrx_demod_instance_t demod,
-       pdrx_channel_t channel, s32 tuner_freq_offset, u32 op)
+	pdrx_channel_t channel, s32 tuner_freq_offset, u32 op)
 {
 	struct i2c_device_addr *dev_addr = NULL;
 	pdrxj_data_t ext_attr = NULL;
@@ -7308,33 +7308,33 @@ set_qam(pdrx_demod_instance_t demod,
 	if ((op & QAM_SET_OP_ALL) || (op & QAM_SET_OP_CONSTELLATION)) {
 		if (ext_attr->standard == DRX_STANDARD_ITU_A) {
 			WRB(dev_addr, IQM_CF_TAP_RE0__A, sizeof(qam_a_taps),
-			    ((u8 *) qam_a_taps));
+			    ((u8 *)qam_a_taps));
 			WRB(dev_addr, IQM_CF_TAP_IM0__A, sizeof(qam_a_taps),
-			    ((u8 *) qam_a_taps));
+			    ((u8 *)qam_a_taps));
 		} else if (ext_attr->standard == DRX_STANDARD_ITU_B) {
 			switch (channel->constellation) {
 			case DRX_CONSTELLATION_QAM64:
 				WRB(dev_addr, IQM_CF_TAP_RE0__A,
-				    sizeof(qam_b64_taps), ((u8 *) qam_b64_taps));
+				    sizeof(qam_b64_taps), ((u8 *)qam_b64_taps));
 				WRB(dev_addr, IQM_CF_TAP_IM0__A,
-				    sizeof(qam_b64_taps), ((u8 *) qam_b64_taps));
+				    sizeof(qam_b64_taps), ((u8 *)qam_b64_taps));
 				break;
 			case DRX_CONSTELLATION_QAM256:
 				WRB(dev_addr, IQM_CF_TAP_RE0__A,
 				    sizeof(qam_b256_taps),
-				    ((u8 *) qam_b256_taps));
+				    ((u8 *)qam_b256_taps));
 				WRB(dev_addr, IQM_CF_TAP_IM0__A,
 				    sizeof(qam_b256_taps),
-				    ((u8 *) qam_b256_taps));
+				    ((u8 *)qam_b256_taps));
 				break;
 			default:
 				return (DRX_STS_ERROR);
 			}
 		} else if (ext_attr->standard == DRX_STANDARD_ITU_C) {
 			WRB(dev_addr, IQM_CF_TAP_RE0__A, sizeof(qam_c_taps),
-			    ((u8 *) qam_c_taps));
+			    ((u8 *)qam_c_taps));
 			WRB(dev_addr, IQM_CF_TAP_IM0__A, sizeof(qam_c_taps),
-			    ((u8 *) qam_c_taps));
+			    ((u8 *)qam_c_taps));
 		}
 
 		/* SETP 4: constellation specific setup */
@@ -7693,7 +7693,7 @@ rw_error:
 */
 static int
 set_qamChannel(pdrx_demod_instance_t demod,
-	      pdrx_channel_t channel, s32 tuner_freq_offset)
+	       pdrx_channel_t channel, s32 tuner_freq_offset)
 {
 	drx_lock_status_t lock_status = DRX_NOT_LOCKED;
 	pdrxj_data_t ext_attr = NULL;
@@ -8639,7 +8639,7 @@ rw_error:
 */
 static int
 ctrl_get_cfg_atv_agc_status(pdrx_demod_instance_t demod,
-		       p_drxj_cfg_atv_agc_status_t agc_status)
+			    p_drxj_cfg_atv_agc_status_t agc_status)
 {
 	struct i2c_device_addr *dev_addr = NULL;
 	pdrxj_data_t ext_attr = NULL;
@@ -9166,9 +9166,9 @@ trouble ?
 		WR16(dev_addr, IQM_RT_LO_INCR__A, IQM_RT_LO_INCR_MN);
 		WR16(dev_addr, IQM_CF_MIDTAP__A, IQM_CF_MIDTAP_RE__M);
 		WRB(dev_addr, IQM_CF_TAP_RE0__A, sizeof(ntsc_taps_re),
-		    ((u8 *) ntsc_taps_re));
+		    ((u8 *)ntsc_taps_re));
 		WRB(dev_addr, IQM_CF_TAP_IM0__A, sizeof(ntsc_taps_im),
-		    ((u8 *) ntsc_taps_im));
+		    ((u8 *)ntsc_taps_im));
 
 		WR16(dev_addr, ATV_TOP_CR_AMP_TH__A, ATV_TOP_CR_AMP_TH_MN);
 		WR16(dev_addr, ATV_TOP_CR_CONT__A,
@@ -9196,9 +9196,9 @@ trouble ?
 		WR16(dev_addr, IQM_RT_LO_INCR__A, 2994);
 		WR16(dev_addr, IQM_CF_MIDTAP__A, 0);
 		WRB(dev_addr, IQM_CF_TAP_RE0__A, sizeof(fm_taps_re),
-		    ((u8 *) fm_taps_re));
+		    ((u8 *)fm_taps_re));
 		WRB(dev_addr, IQM_CF_TAP_IM0__A, sizeof(fm_taps_im),
-		    ((u8 *) fm_taps_im));
+		    ((u8 *)fm_taps_im));
 		WR16(dev_addr, ATV_TOP_STD__A, (ATV_TOP_STD_MODE_FM |
 					       ATV_TOP_STD_VID_POL_FM));
 		WR16(dev_addr, ATV_TOP_MOD_CONTROL__A, 0);
@@ -9218,9 +9218,9 @@ trouble ?
 		WR16(dev_addr, IQM_RT_LO_INCR__A, 1820);	/* TODO check with IS */
 		WR16(dev_addr, IQM_CF_MIDTAP__A, IQM_CF_MIDTAP_RE__M);
 		WRB(dev_addr, IQM_CF_TAP_RE0__A, sizeof(bg_taps_re),
-		    ((u8 *) bg_taps_re));
+		    ((u8 *)bg_taps_re));
 		WRB(dev_addr, IQM_CF_TAP_IM0__A, sizeof(bg_taps_im),
-		    ((u8 *) bg_taps_im));
+		    ((u8 *)bg_taps_im));
 		WR16(dev_addr, ATV_TOP_VID_AMP__A, ATV_TOP_VID_AMP_BG);
 		WR16(dev_addr, ATV_TOP_CR_AMP_TH__A, ATV_TOP_CR_AMP_TH_BG);
 		WR16(dev_addr, ATV_TOP_CR_CONT__A,
@@ -9247,9 +9247,9 @@ trouble ?
 		WR16(dev_addr, IQM_RT_LO_INCR__A, 2225);	/* TODO check with IS */
 		WR16(dev_addr, IQM_CF_MIDTAP__A, IQM_CF_MIDTAP_RE__M);
 		WRB(dev_addr, IQM_CF_TAP_RE0__A, sizeof(dk_i_l_lp_taps_re),
-		    ((u8 *) dk_i_l_lp_taps_re));
+		    ((u8 *)dk_i_l_lp_taps_re));
 		WRB(dev_addr, IQM_CF_TAP_IM0__A, sizeof(dk_i_l_lp_taps_im),
-		    ((u8 *) dk_i_l_lp_taps_im));
+		    ((u8 *)dk_i_l_lp_taps_im));
 		WR16(dev_addr, ATV_TOP_CR_AMP_TH__A, ATV_TOP_CR_AMP_TH_DK);
 		WR16(dev_addr, ATV_TOP_VID_AMP__A, ATV_TOP_VID_AMP_DK);
 		WR16(dev_addr, ATV_TOP_CR_CONT__A,
@@ -9276,9 +9276,9 @@ trouble ?
 		WR16(dev_addr, IQM_RT_LO_INCR__A, 2225);	/* TODO check with IS */
 		WR16(dev_addr, IQM_CF_MIDTAP__A, IQM_CF_MIDTAP_RE__M);
 		WRB(dev_addr, IQM_CF_TAP_RE0__A, sizeof(dk_i_l_lp_taps_re),
-		    ((u8 *) dk_i_l_lp_taps_re));
+		    ((u8 *)dk_i_l_lp_taps_re));
 		WRB(dev_addr, IQM_CF_TAP_IM0__A, sizeof(dk_i_l_lp_taps_im),
-		    ((u8 *) dk_i_l_lp_taps_im));
+		    ((u8 *)dk_i_l_lp_taps_im));
 		WR16(dev_addr, ATV_TOP_CR_AMP_TH__A, ATV_TOP_CR_AMP_TH_I);
 		WR16(dev_addr, ATV_TOP_VID_AMP__A, ATV_TOP_VID_AMP_I);
 		WR16(dev_addr, ATV_TOP_CR_CONT__A,
@@ -9306,9 +9306,9 @@ trouble ?
 		WR16(dev_addr, ATV_TOP_VID_AMP__A, ATV_TOP_VID_AMP_L);
 		WR16(dev_addr, IQM_CF_MIDTAP__A, IQM_CF_MIDTAP_RE__M);
 		WRB(dev_addr, IQM_CF_TAP_RE0__A, sizeof(dk_i_l_lp_taps_re),
-		    ((u8 *) dk_i_l_lp_taps_re));
+		    ((u8 *)dk_i_l_lp_taps_re));
 		WRB(dev_addr, IQM_CF_TAP_IM0__A, sizeof(dk_i_l_lp_taps_im),
-		    ((u8 *) dk_i_l_lp_taps_im));
+		    ((u8 *)dk_i_l_lp_taps_im));
 		WR16(dev_addr, ATV_TOP_CR_AMP_TH__A, 0x2);	/* TODO check with IS */
 		WR16(dev_addr, ATV_TOP_CR_CONT__A,
 		     (ATV_TOP_CR_CONT_CR_P_L |
@@ -9337,9 +9337,9 @@ trouble ?
 		WR16(dev_addr, IQM_RT_LO_INCR__A, 2225);	/* TODO check with IS */
 		WR16(dev_addr, IQM_CF_MIDTAP__A, IQM_CF_MIDTAP_RE__M);
 		WRB(dev_addr, IQM_CF_TAP_RE0__A, sizeof(dk_i_l_lp_taps_re),
-		    ((u8 *) dk_i_l_lp_taps_re));
+		    ((u8 *)dk_i_l_lp_taps_re));
 		WRB(dev_addr, IQM_CF_TAP_IM0__A, sizeof(dk_i_l_lp_taps_im),
-		    ((u8 *) dk_i_l_lp_taps_im));
+		    ((u8 *)dk_i_l_lp_taps_im));
 		WR16(dev_addr, ATV_TOP_CR_AMP_TH__A, 0x2);	/* TODO check with IS */
 		WR16(dev_addr, ATV_TOP_CR_CONT__A,
 		     (ATV_TOP_CR_CONT_CR_P_LP |
@@ -9457,7 +9457,7 @@ rw_error:
 */
 static int
 set_atv_channel(pdrx_demod_instance_t demod,
-	      s32 tuner_freq_offset,
+		s32 tuner_freq_offset,
 	      pdrx_channel_t channel, enum drx_standard standard)
 {
 	drxjscu_cmd_t cmd_scu = { /* command      */ 0,
@@ -9524,7 +9524,7 @@ rw_error:
 #ifndef DRXJ_DIGITAL_ONLY
 static int
 get_atv_channel(pdrx_demod_instance_t demod,
-	      pdrx_channel_t channel, enum drx_standard standard)
+		pdrx_channel_t channel, enum drx_standard standard)
 {
 	s32 offset = 0;
 	struct i2c_device_addr *dev_addr = NULL;
@@ -9811,7 +9811,7 @@ static int power_down_aud(pdrx_demod_instance_t demod)
 	struct i2c_device_addr *dev_addr = NULL;
 	pdrxj_data_t ext_attr = NULL;
 
-	dev_addr = (struct i2c_device_addr *) demod->my_i2c_dev_addr;
+	dev_addr = (struct i2c_device_addr *)demod->my_i2c_dev_addr;
 	ext_attr = (pdrxj_data_t) demod->my_ext_attr;
 
 	WR16(dev_addr, AUD_COMM_EXEC__A, AUD_COMM_EXEC_STOP);
@@ -9844,7 +9844,7 @@ static int aud_get_modus(pdrx_demod_instance_t demod, u16 *modus)
 		return DRX_STS_INVALID_ARG;
 	}
 
-	dev_addr = (struct i2c_device_addr *) demod->my_i2c_dev_addr;
+	dev_addr = (struct i2c_device_addr *)demod->my_i2c_dev_addr;
 	ext_attr = (pdrxj_data_t) demod->my_ext_attr;
 
 	/* power up */
@@ -9887,7 +9887,7 @@ aud_ctrl_get_cfg_rds(pdrx_demod_instance_t demod, pdrx_cfg_aud_rds_t status)
 	u16 r_rds_data = 0;
 	u16 rds_data_cnt = 0;
 
-	addr = (struct i2c_device_addr *) demod->my_i2c_dev_addr;
+	addr = (struct i2c_device_addr *)demod->my_i2c_dev_addr;
 	ext_attr = (pdrxj_data_t) demod->my_ext_attr;
 
 	if (status == NULL) {
@@ -9958,7 +9958,7 @@ aud_ctrl_get_carrier_detect_status(pdrx_demod_instance_t demod, pdrx_aud_status_
 		return DRX_STS_INVALID_ARG;
 	}
 
-	dev_addr = (struct i2c_device_addr *) demod->my_i2c_dev_addr;
+	dev_addr = (struct i2c_device_addr *)demod->my_i2c_dev_addr;
 	ext_attr = (pdrxj_data_t) demod->my_ext_attr;
 
 	/* power up */
@@ -10036,7 +10036,7 @@ aud_ctrl_get_status(pdrx_demod_instance_t demod, pdrx_aud_status_t status)
 		return DRX_STS_INVALID_ARG;
 	}
 
-	dev_addr = (struct i2c_device_addr *) demod->my_i2c_dev_addr;
+	dev_addr = (struct i2c_device_addr *)demod->my_i2c_dev_addr;
 	ext_attr = (pdrxj_data_t) demod->my_ext_attr;
 
 	/* carrier detection */
@@ -10080,7 +10080,7 @@ aud_ctrl_get_cfg_volume(pdrx_demod_instance_t demod, pdrx_cfg_aud_volume_t volum
 		return DRX_STS_INVALID_ARG;
 	}
 
-	dev_addr = (struct i2c_device_addr *) demod->my_i2c_dev_addr;
+	dev_addr = (struct i2c_device_addr *)demod->my_i2c_dev_addr;
 	ext_attr = (pdrxj_data_t) demod->my_ext_attr;
 
 	/* power up */
@@ -10212,7 +10212,7 @@ aud_ctrl_set_cfg_volume(pdrx_demod_instance_t demod, pdrx_cfg_aud_volume_t volum
 		return DRX_STS_INVALID_ARG;
 	}
 
-	dev_addr = (struct i2c_device_addr *) demod->my_i2c_dev_addr;
+	dev_addr = (struct i2c_device_addr *)demod->my_i2c_dev_addr;
 	ext_attr = (pdrxj_data_t) demod->my_ext_attr;
 
 	/* power up */
@@ -10347,7 +10347,7 @@ aud_ctrl_get_cfg_output_i2s(pdrx_demod_instance_t demod, pdrx_cfg_i2s_output_t o
 		return DRX_STS_INVALID_ARG;
 	}
 
-	dev_addr = (struct i2c_device_addr *) demod->my_i2c_dev_addr;
+	dev_addr = (struct i2c_device_addr *)demod->my_i2c_dev_addr;
 	ext_attr = (pdrxj_data_t) demod->my_ext_attr;
 
 	/* power up */
@@ -10453,7 +10453,7 @@ aud_ctrl_set_cfg_output_i2s(pdrx_demod_instance_t demod, pdrx_cfg_i2s_output_t o
 		return DRX_STS_INVALID_ARG;
 	}
 
-	dev_addr = (struct i2c_device_addr *) demod->my_i2c_dev_addr;
+	dev_addr = (struct i2c_device_addr *)demod->my_i2c_dev_addr;
 	ext_attr = (pdrxj_data_t) demod->my_ext_attr;
 
 	/* power up */
@@ -10594,9 +10594,9 @@ rw_error:
 */
 static int
 aud_ctrl_get_cfg_auto_sound(pdrx_demod_instance_t demod,
-		       pdrx_cfg_aud_auto_sound_t auto_sound)
+			    pdrx_cfg_aud_auto_sound_t auto_sound)
 {
-	struct i2c_device_addr *dev_addr = (struct i2c_device_addr *) NULL;
+	struct i2c_device_addr *dev_addr = (struct i2c_device_addr *)NULL;
 	pdrxj_data_t ext_attr = (pdrxj_data_t) NULL;
 
 	u16 r_modus = 0;
@@ -10651,9 +10651,9 @@ rw_error:
 */
 static int
 aud_ctr_setl_cfg_auto_sound(pdrx_demod_instance_t demod,
-		       pdrx_cfg_aud_auto_sound_t auto_sound)
+			    pdrx_cfg_aud_auto_sound_t auto_sound)
 {
-	struct i2c_device_addr *dev_addr = (struct i2c_device_addr *) NULL;
+	struct i2c_device_addr *dev_addr = (struct i2c_device_addr *)NULL;
 	pdrxj_data_t ext_attr = (pdrxj_data_t) NULL;
 
 	u16 r_modus = 0;
@@ -10718,7 +10718,7 @@ rw_error:
 static int
 aud_ctrl_get_cfg_ass_thres(pdrx_demod_instance_t demod, pdrx_cfg_aud_ass_thres_t thres)
 {
-	struct i2c_device_addr *dev_addr = (struct i2c_device_addr *) NULL;
+	struct i2c_device_addr *dev_addr = (struct i2c_device_addr *)NULL;
 	pdrxj_data_t ext_attr = (pdrxj_data_t) NULL;
 
 	u16 thres_a2 = 0;
@@ -10762,7 +10762,7 @@ rw_error:
 static int
 aud_ctrl_set_cfg_ass_thres(pdrx_demod_instance_t demod, pdrx_cfg_aud_ass_thres_t thres)
 {
-	struct i2c_device_addr *dev_addr = (struct i2c_device_addr *) NULL;
+	struct i2c_device_addr *dev_addr = (struct i2c_device_addr *)NULL;
 	pdrxj_data_t ext_attr = (pdrxj_data_t) NULL;
 
 	if (thres == NULL) {
@@ -10801,7 +10801,7 @@ rw_error:
 static int
 aud_ctrl_get_cfg_carrier(pdrx_demod_instance_t demod, pdrx_cfg_aud_carriers_t carriers)
 {
-	struct i2c_device_addr *dev_addr = (struct i2c_device_addr *) NULL;
+	struct i2c_device_addr *dev_addr = (struct i2c_device_addr *)NULL;
 	pdrxj_data_t ext_attr = (pdrxj_data_t) NULL;
 
 	u16 w_modus = 0;
@@ -10906,7 +10906,7 @@ rw_error:
 static int
 aud_ctrl_set_cfg_carrier(pdrx_demod_instance_t demod, pdrx_cfg_aud_carriers_t carriers)
 {
-	struct i2c_device_addr *dev_addr = (struct i2c_device_addr *) NULL;
+	struct i2c_device_addr *dev_addr = (struct i2c_device_addr *)NULL;
 	pdrxj_data_t ext_attr = (pdrxj_data_t) NULL;
 
 	u16 w_modus = 0;
@@ -11006,7 +11006,7 @@ rw_error:
 static int
 aud_ctrl_get_cfg_mixer(pdrx_demod_instance_t demod, pdrx_cfg_aud_mixer_t mixer)
 {
-	struct i2c_device_addr *dev_addr = (struct i2c_device_addr *) NULL;
+	struct i2c_device_addr *dev_addr = (struct i2c_device_addr *)NULL;
 	pdrxj_data_t ext_attr = (pdrxj_data_t) NULL;
 
 	u16 src_i2s_matr = 0;
@@ -11101,7 +11101,7 @@ rw_error:
 static int
 aud_ctrl_set_cfg_mixer(pdrx_demod_instance_t demod, pdrx_cfg_aud_mixer_t mixer)
 {
-	struct i2c_device_addr *dev_addr = (struct i2c_device_addr *) NULL;
+	struct i2c_device_addr *dev_addr = (struct i2c_device_addr *)NULL;
 	pdrxj_data_t ext_attr = (pdrxj_data_t) NULL;
 
 	u16 src_i2s_matr = 0;
@@ -11209,7 +11209,7 @@ rw_error:
 static int
 aud_ctrl_set_cfg_av_sync(pdrx_demod_instance_t demod, pdrx_cfg_aud_av_sync_t av_sync)
 {
-	struct i2c_device_addr *dev_addr = (struct i2c_device_addr *) NULL;
+	struct i2c_device_addr *dev_addr = (struct i2c_device_addr *)NULL;
 	pdrxj_data_t ext_attr = (pdrxj_data_t) NULL;
 
 	u16 w_aud_vid_sync = 0;
@@ -11274,7 +11274,7 @@ rw_error:
 static int
 aud_ctrl_get_cfg_av_sync(pdrx_demod_instance_t demod, pdrx_cfg_aud_av_sync_t av_sync)
 {
-	struct i2c_device_addr *dev_addr = (struct i2c_device_addr *) NULL;
+	struct i2c_device_addr *dev_addr = (struct i2c_device_addr *)NULL;
 	pdrxj_data_t ext_attr = (pdrxj_data_t) NULL;
 
 	u16 w_aud_vid_sync = 0;
@@ -11331,7 +11331,7 @@ rw_error:
 static int
 aud_ctrl_get_cfg_dev(pdrx_demod_instance_t demod, pdrx_cfg_aud_deviation_t dev)
 {
-	struct i2c_device_addr *dev_addr = (struct i2c_device_addr *) NULL;
+	struct i2c_device_addr *dev_addr = (struct i2c_device_addr *)NULL;
 	pdrxj_data_t ext_attr = (pdrxj_data_t) NULL;
 
 	u16 r_modus = 0;
@@ -11372,7 +11372,7 @@ rw_error:
 static int
 aud_ctrl_set_cfg_dev(pdrx_demod_instance_t demod, pdrx_cfg_aud_deviation_t dev)
 {
-	struct i2c_device_addr *dev_addr = (struct i2c_device_addr *) NULL;
+	struct i2c_device_addr *dev_addr = (struct i2c_device_addr *)NULL;
 	pdrxj_data_t ext_attr = (pdrxj_data_t) NULL;
 
 	u16 w_modus = 0;
@@ -11425,7 +11425,7 @@ rw_error:
 static int
 aud_ctrl_get_cfg_prescale(pdrx_demod_instance_t demod, pdrx_cfg_aud_prescale_t presc)
 {
-	struct i2c_device_addr *dev_addr = (struct i2c_device_addr *) NULL;
+	struct i2c_device_addr *dev_addr = (struct i2c_device_addr *)NULL;
 	pdrxj_data_t ext_attr = (pdrxj_data_t) NULL;
 
 	u16 r_max_fm_deviation = 0;
@@ -11500,7 +11500,7 @@ rw_error:
 static int
 aud_ctrl_set_cfg_prescale(pdrx_demod_instance_t demod, pdrx_cfg_aud_prescale_t presc)
 {
-	struct i2c_device_addr *dev_addr = (struct i2c_device_addr *) NULL;
+	struct i2c_device_addr *dev_addr = (struct i2c_device_addr *)NULL;
 	pdrxj_data_t ext_attr = (pdrxj_data_t) NULL;
 
 	u16 w_max_fm_deviation = 0;
@@ -11582,7 +11582,7 @@ rw_error:
 */
 static int aud_ctrl_beep(pdrx_demod_instance_t demod, pdrx_aud_beep_t beep)
 {
-	struct i2c_device_addr *dev_addr = (struct i2c_device_addr *) NULL;
+	struct i2c_device_addr *dev_addr = (struct i2c_device_addr *)NULL;
 	pdrxj_data_t ext_attr = (pdrxj_data_t) NULL;
 
 	u16 the_beep = 0;
@@ -11657,7 +11657,7 @@ aud_ctrl_set_standard(pdrx_demod_instance_t demod, pdrx_aud_standard_t standard)
 		return DRX_STS_INVALID_ARG;
 	}
 
-	dev_addr = (struct i2c_device_addr *) demod->my_i2c_dev_addr;
+	dev_addr = (struct i2c_device_addr *)demod->my_i2c_dev_addr;
 	ext_attr = (pdrxj_data_t) demod->my_ext_attr;
 
 	/* power up */
@@ -11829,7 +11829,7 @@ aud_ctrl_get_standard(pdrx_demod_instance_t demod, pdrx_aud_standard_t standard)
 	}
 
 	ext_attr = (pdrxj_data_t) demod->my_ext_attr;
-	dev_addr = (struct i2c_device_addr *) demod->my_i2c_dev_addr;
+	dev_addr = (struct i2c_device_addr *)demod->my_i2c_dev_addr;
 
 	/* power up */
 	if (ext_attr->aud_data.audio_is_active == false) {
@@ -11997,7 +11997,7 @@ rw_error:
 */
 static int
 get_oob_lock_status(pdrx_demod_instance_t demod,
-		 struct i2c_device_addr *dev_addr, pdrx_lock_status_t oob_lock)
+		    struct i2c_device_addr *dev_addr, pdrx_lock_status_t oob_lock)
 {
 	drxjscu_cmd_t scu_cmd;
 	u16 cmd_result[2];
@@ -12707,7 +12707,7 @@ static int ctrl_set_oob(pdrx_demod_instance_t demod, p_drxoob_t oob_param)
 
 	/* PRE-Filter coefficients (PFI) */
 	WRB(dev_addr, ORX_FWP_PFI_A_W__A, sizeof(pfi_coeffs[mode_index]),
-	    ((u8 *) pfi_coeffs[mode_index]));
+	    ((u8 *)pfi_coeffs[mode_index]));
 	WR16(dev_addr, ORX_TOP_MDE_W__A, mode_index);
 
 	/* NYQUIST-Filter coefficients (NYQ) */
@@ -13185,7 +13185,7 @@ ctrl_set_channel(pdrx_demod_instance_t demod, pdrx_channel_t channel)
 		}
 
 		CHK_ERROR(drxbsp_tuner_set_frequency(demod->my_tuner,
-						    tuner_mode, tuner_set_freq));
+						     tuner_mode, tuner_set_freq));
 		if (common_attr->tuner_port_nr == 1) {
 			/* open tuner bridge */
 			bridge_closed = false;
@@ -13194,7 +13194,7 @@ ctrl_set_channel(pdrx_demod_instance_t demod, pdrx_channel_t channel)
 
 		/* Get actual frequency set by tuner and compute offset */
 		CHK_ERROR(drxbsp_tuner_get_frequency(demod->my_tuner,
-						    0,
+						     0,
 						    &tuner_get_freq,
 						    &intermediate_freq));
 		tuner_freq_offset = tuner_get_freq - tuner_set_freq;
@@ -13230,7 +13230,7 @@ ctrl_set_channel(pdrx_demod_instance_t demod, pdrx_channel_t channel)
 			ext_attr->mirror = channel->mirror;
 		}
 		CHK_ERROR(set_atv_channel(demod,
-					tuner_freq_offset, channel, standard));
+					  tuner_freq_offset, channel, standard));
 		break;
 #endif
 #ifndef DRXJ_VSB_ONLY
@@ -13259,7 +13259,7 @@ ctrl_set_channel(pdrx_demod_instance_t demod, pdrx_channel_t channel)
 
 		/* set tuner frequency */
 		CHK_ERROR(drxbsp_tuner_set_frequency(demod->my_tuner,
-						    tuner_mode, tuner_set_freq));
+						     tuner_mode, tuner_set_freq));
 		if (common_attr->tuner_port_nr == 1) {
 			/* open tuner bridge */
 			bridge_closed = false;
@@ -13336,7 +13336,7 @@ ctrl_get_channel(pdrx_demod_instance_t demod, pdrx_channel_t channel)
 
 		/* Get frequency from tuner */
 		CHK_ERROR(drxbsp_tuner_get_frequency(demod->my_tuner,
-						    0,
+						     0,
 						    &(channel->frequency),
 						    &intermediate_freq));
 		tuner_freq_offset = channel->frequency - ext_attr->frequency;
@@ -13998,7 +13998,7 @@ ctrl_power_mode(pdrx_demod_instance_t demod, pdrx_power_mode_t mode)
 {
 	pdrx_common_attr_t common_attr = (pdrx_common_attr_t) NULL;
 	pdrxj_data_t ext_attr = (pdrxj_data_t) NULL;
-	struct i2c_device_addr *dev_addr = (struct i2c_device_addr *) NULL;
+	struct i2c_device_addr *dev_addr = (struct i2c_device_addr *)NULL;
 	u16 sio_cc_pwd_mode = 0;
 
 	common_attr = (pdrx_common_attr_t) demod->my_common_attr;
@@ -14125,7 +14125,7 @@ static int
 ctrl_version(pdrx_demod_instance_t demod, p_drx_version_list_t *version_list)
 {
 	pdrxj_data_t ext_attr = (pdrxj_data_t) (NULL);
-	struct i2c_device_addr *dev_addr = (struct i2c_device_addr *) (NULL);
+	struct i2c_device_addr *dev_addr = (struct i2c_device_addr *)(NULL);
 	pdrx_common_attr_t common_attr = (pdrx_common_attr_t) (NULL);
 	u16 ucode_major_minor = 0;	/* BCD Ma:Ma:Ma:Mi */
 	u16 ucode_patch = 0;	/* BCD Pa:Pa:Pa:Pa */
@@ -14371,14 +14371,14 @@ bool is_mc_block_audio(u32 addr)
 */
 static int
 ctrl_u_codeUpload(pdrx_demod_instance_t demod,
-		p_drxu_code_info_t mc_info,
+		  p_drxu_code_info_t mc_info,
 		drxu_code_action_t action, bool upload_audio_mc)
 {
 	u16 i = 0;
 	u16 mc_nr_of_blks = 0;
 	u16 mc_magic_word = 0;
-	u8 *mc_data = (u8 *) (NULL);
-	struct i2c_device_addr *dev_addr = (struct i2c_device_addr *) (NULL);
+	u8 *mc_data = (u8 *)(NULL);
+	struct i2c_device_addr *dev_addr = (struct i2c_device_addr *)(NULL);
 	pdrxj_data_t ext_attr = (pdrxj_data_t) (NULL);
 
 	dev_addr = demod->my_i2c_dev_addr;
@@ -15293,7 +15293,7 @@ static int ctrl_set_cfg(pdrx_demod_instance_t demod, pdrx_cfg_t config)
 					    (pdrx_cfg_mpeg_output_t) config->
 					    cfg_data);
 	case DRX_CFG_PINS_SAFE_MODE:
-		return ctrl_set_cfg_pdr_safe_mode(demod, (bool *) config->cfg_data);
+		return ctrl_set_cfg_pdr_safe_mode(demod, (bool *)config->cfg_data);
 	case DRXJ_CFG_AGC_RF:
 		return ctrl_set_cfg_agc_rf(demod, (p_drxj_cfg_agc_t) config->cfg_data);
 	case DRXJ_CFG_AGC_IF:
@@ -15312,7 +15312,7 @@ static int ctrl_set_cfg(pdrx_demod_instance_t demod, pdrx_cfg_t config)
 		return ctrl_set_cfg_reset_pkt_err(demod);
 #ifndef DRXJ_DIGITAL_ONLY
 	case DRXJ_CFG_OOB_PRE_SAW:
-		return ctrl_set_cfg_oob_pre_saw(demod, (u16 *) (config->cfg_data));
+		return ctrl_set_cfg_oob_pre_saw(demod, (u16 *)(config->cfg_data));
 	case DRXJ_CFG_OOB_LO_POW:
 		return ctrl_set_cfg_oob_lo_power(demod,
 					    (p_drxj_cfg_oob_lo_power_t) (config->
@@ -15402,13 +15402,13 @@ static int ctrl_get_cfg(pdrx_demod_instance_t demod, pdrx_cfg_t config)
 					    (pdrx_cfg_mpeg_output_t) config->
 					    cfg_data);
 	case DRX_CFG_PINS_SAFE_MODE:
-		return ctrl_get_cfg_pdr_safe_mode(demod, (bool *) config->cfg_data);
+		return ctrl_get_cfg_pdr_safe_mode(demod, (bool *)config->cfg_data);
 	case DRXJ_CFG_AGC_RF:
 		return ctrl_get_cfg_agc_rf(demod, (p_drxj_cfg_agc_t) config->cfg_data);
 	case DRXJ_CFG_AGC_IF:
 		return ctrl_get_cfg_agc_if(demod, (p_drxj_cfg_agc_t) config->cfg_data);
 	case DRXJ_CFG_AGC_INTERNAL:
-		return ctrl_get_cfg_agc_internal(demod, (u16 *) config->cfg_data);
+		return ctrl_get_cfg_agc_internal(demod, (u16 *)config->cfg_data);
 	case DRXJ_CFG_PRE_SAW:
 		return ctrl_get_cfg_pre_saw(demod,
 					(p_drxj_cfg_pre_saw_t) config->cfg_data);
@@ -15416,21 +15416,21 @@ static int ctrl_get_cfg(pdrx_demod_instance_t demod, pdrx_cfg_t config)
 		return ctrl_get_cfg_afe_gain(demod,
 					 (p_drxj_cfg_afe_gain_t) config->cfg_data);
 	case DRXJ_CFG_ACCUM_CR_RS_CW_ERR:
-		return ctrl_get_accum_cr_rs_cw_err(demod, (u32 *) config->cfg_data);
+		return ctrl_get_accum_cr_rs_cw_err(demod, (u32 *)config->cfg_data);
 	case DRXJ_CFG_FEC_MERS_SEQ_COUNT:
-		return ctrl_get_fec_meas_seq_count(demod, (u16 *) config->cfg_data);
+		return ctrl_get_fec_meas_seq_count(demod, (u16 *)config->cfg_data);
 	case DRXJ_CFG_VSB_MISC:
 		return ctrl_get_cfg_vsb_misc(demod,
 					 (p_drxj_cfg_vsb_misc_t) config->cfg_data);
 	case DRXJ_CFG_SYMBOL_CLK_OFFSET:
 		return ctrl_get_cfg_symbol_clock_offset(demod,
-						   (s32 *) config->cfg_data);
+						   (s32 *)config->cfg_data);
 #ifndef DRXJ_DIGITAL_ONLY
 	case DRXJ_CFG_OOB_MISC:
 		return ctrl_get_cfg_oob_misc(demod,
 					 (p_drxj_cfg_oob_misc_t) config->cfg_data);
 	case DRXJ_CFG_OOB_PRE_SAW:
-		return ctrl_get_cfg_oob_pre_saw(demod, (u16 *) (config->cfg_data));
+		return ctrl_get_cfg_oob_pre_saw(demod, (u16 *)(config->cfg_data));
 	case DRXJ_CFG_OOB_LO_POW:
 		return ctrl_get_cfg_oob_lo_power(demod,
 					    (p_drxj_cfg_oob_lo_power_t) (config->
@@ -15806,7 +15806,7 @@ drxj_ctrl(pdrx_demod_instance_t demod, u32 ctrl, void *ctrl_data)
       /*======================================================================*/
 	case DRX_CTRL_SIG_STRENGTH:
 		{
-			return ctrl_sig_strength(demod, (u16 *) ctrl_data);
+			return ctrl_sig_strength(demod, (u16 *)ctrl_data);
 		}
 		break;
       /*======================================================================*/
@@ -15830,7 +15830,7 @@ drxj_ctrl(pdrx_demod_instance_t demod, u32 ctrl, void *ctrl_data)
       /*======================================================================*/
 	case DRX_CTRL_I2C_BRIDGE:
 		{
-			return ctrl_i2c_bridge(demod, (bool *) ctrl_data);
+			return ctrl_i2c_bridge(demod, (bool *)ctrl_data);
 		}
 		break;
       /*======================================================================*/
@@ -15844,14 +15844,14 @@ drxj_ctrl(pdrx_demod_instance_t demod, u32 ctrl, void *ctrl_data)
 	case DRX_CTRL_SET_STANDARD:
 		{
 			return ctrl_set_standard(demod,
-					       (enum drx_standard *) ctrl_data);
+					       (enum drx_standard *)ctrl_data);
 		}
 		break;
       /*======================================================================*/
 	case DRX_CTRL_GET_STANDARD:
 		{
 			return ctrl_get_standard(demod,
-					       (enum drx_standard *) ctrl_data);
+					       (enum drx_standard *)ctrl_data);
 		}
 		break;
       /*======================================================================*/
@@ -15864,7 +15864,7 @@ drxj_ctrl(pdrx_demod_instance_t demod, u32 ctrl, void *ctrl_data)
 	case DRX_CTRL_VERSION:
 		{
 			return ctrl_version(demod,
-					   (p_drx_version_list_t *) ctrl_data);
+					   (p_drx_version_list_t *)ctrl_data);
 		}
 		break;
       /*======================================================================*/
diff --git a/drivers/media/dvb-frontends/drx39xyj/drxj.h b/drivers/media/dvb-frontends/drx39xyj/drxj.h
index 54b5c14f57cf..d882f2279619 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drxj.h
+++ b/drivers/media/dvb-frontends/drx39xyj/drxj.h
@@ -723,9 +723,9 @@ STRUCTS
 Exported FUNCTIONS
 -------------------------------------------------------------------------*/
 
-	extern int drxj_open(pdrx_demod_instance_t demod);
-	extern int drxj_close(pdrx_demod_instance_t demod);
-	extern int drxj_ctrl(pdrx_demod_instance_t demod,
+	int drxj_open(pdrx_demod_instance_t demod);
+	int drxj_close(pdrx_demod_instance_t demod);
+	int drxj_ctrl(pdrx_demod_instance_t demod,
 				     u32 ctrl, void *ctrl_data);
 
 /*-------------------------------------------------------------------------
diff --git a/drivers/media/dvb-frontends/drx39xyj/drxj_mc.h b/drivers/media/dvb-frontends/drx39xyj/drxj_mc.h
index 16f7a9f91fd8..dc2af8f1e38e 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drxj_mc.h
+++ b/drivers/media/dvb-frontends/drx39xyj/drxj_mc.h
@@ -41,7 +41,7 @@
 #ifndef __DRXJ_MC_MAIN_H__
 #define __DRXJ_MC_MAIN_H__
 
-#define DRXJ_MC_MAIN ((u8 *) drxj_mc_main_g)
+#define DRXJ_MC_MAIN ((u8 *)drxj_mc_main_g)
 
 const u8 drxj_mc_main_g[] = {
 	0x48, 0x4c, 0x00, 0x06, 0x00, 0x00, 0xf3, 0x10, 0x00, 0x00, 0x00, 0x08,
diff --git a/drivers/media/dvb-frontends/drx39xyj/drxj_mc_vsb.h b/drivers/media/dvb-frontends/drx39xyj/drxj_mc_vsb.h
index 211323591f77..a6c29ca36577 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drxj_mc_vsb.h
+++ b/drivers/media/dvb-frontends/drx39xyj/drxj_mc_vsb.h
@@ -41,7 +41,7 @@
 #ifndef __DRXJ_MC_VSB_H__
 #define __DRXJ_MC_VSB_H__
 
-#define DRXJ_MC_VSB ((u8 *) drxj_mc_vsb_g)
+#define DRXJ_MC_VSB ((u8 *)drxj_mc_vsb_g)
 
 const u8 drxj_mc_vsb_g[] = {
 	0x48, 0x4c, 0x00, 0x03, 0x00, 0x00, 0x2b, 0x62, 0x00, 0x00, 0x00, 0x08,
diff --git a/drivers/media/dvb-frontends/drx39xyj/drxj_mc_vsbqam.h b/drivers/media/dvb-frontends/drx39xyj/drxj_mc_vsbqam.h
index 9996c693f9c8..471660cd5768 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drxj_mc_vsbqam.h
+++ b/drivers/media/dvb-frontends/drx39xyj/drxj_mc_vsbqam.h
@@ -42,7 +42,7 @@
 #ifndef __DRXJ_MC_VSBQAM_H__
 #define __DRXJ_MC_VSBQAM_H__
 
-#define DRXJ_MC_VSBQAM ((u8 *) drxj_mc_vsbqam_g)
+#define DRXJ_MC_VSBQAM ((u8 *)drxj_mc_vsbqam_g)
 
 const u8 drxj_mc_vsbqam_g[] = {
 	0x48, 0x4c, 0x00, 0x04, 0x00, 0x00, 0x56, 0xa0, 0x00, 0x00, 0x00, 0x08,
-- 
1.8.5.3

