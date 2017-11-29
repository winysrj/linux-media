Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:36348 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752529AbdK2TI5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 29 Nov 2017 14:08:57 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Abylay Ospan <aospan@netup.ru>,
        Malcolm Priestley <tvboxspy@gmail.com>,
        Antti Palosaari <crope@iki.fi>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Martin Kepplinger <martink@posteo.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Philippe Ombredanne <pombredanne@nexb.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH 20/22] media: dvb_frontends: fix kernel-doc macros
Date: Wed, 29 Nov 2017 14:08:38 -0500
Message-Id: <7490181e5a5f03182806a55a6405bdf7e9b41978.1511982439.git.mchehab@s-opensource.com>
In-Reply-To: <73497577f67fbb917e40ab4328104ff310a7c356.1511982439.git.mchehab@s-opensource.com>
References: <73497577f67fbb917e40ab4328104ff310a7c356.1511982439.git.mchehab@s-opensource.com>
In-Reply-To: <73497577f67fbb917e40ab4328104ff310a7c356.1511982439.git.mchehab@s-opensource.com>
References: <73497577f67fbb917e40ab4328104ff310a7c356.1511982439.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now, the Kernel checks for kernel_doc format issues.
Weird enough, it didn't get any of those troubles. Shssst!

Well, let's fix it, as a preventive way to avoid having
hundreds of new warnings on some next Linux version.

Tested by adding all files under dvb-frontends that have
"/**" on them.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/dvb-frontends/drx39xyj/bsp_i2c.h    |  12 +-
 drivers/media/dvb-frontends/drx39xyj/drx_driver.h | 878 +++++++++++-----------
 drivers/media/dvb-frontends/drx39xyj/drxj.h       | 220 +++---
 drivers/media/dvb-frontends/drxk.h                |   5 +-
 drivers/media/dvb-frontends/dvb-pll.h             |  11 +-
 drivers/media/dvb-frontends/helene.h              |   1 +
 drivers/media/dvb-frontends/ix2505v.h             |  17 +-
 drivers/media/dvb-frontends/l64781.c              |   2 +-
 drivers/media/dvb-frontends/mn88472.h             |  16 +-
 drivers/media/dvb-frontends/rtl2832_sdr.h         |   6 +-
 drivers/media/dvb-frontends/stb6000.h             |   9 +-
 drivers/media/dvb-frontends/stv0299.c             |   2 +-
 drivers/media/dvb-frontends/tda826x.h             |  11 +-
 drivers/media/dvb-frontends/tua6100.h             |   2 +-
 drivers/media/dvb-frontends/zd1301_demod.h        |   7 +-
 drivers/media/dvb-frontends/zl10036.h             |  16 +-
 16 files changed, 607 insertions(+), 608 deletions(-)

diff --git a/drivers/media/dvb-frontends/drx39xyj/bsp_i2c.h b/drivers/media/dvb-frontends/drx39xyj/bsp_i2c.h
index 5b5421f70388..2b3af247a1f1 100644
--- a/drivers/media/dvb-frontends/drx39xyj/bsp_i2c.h
+++ b/drivers/media/dvb-frontends/drx39xyj/bsp_i2c.h
@@ -52,7 +52,7 @@ struct i2c_device_addr {
 };
 
 
-/**
+/*
 * \def IS_I2C_10BIT( addr )
 * \brief Determine if I2C address 'addr' is a 10 bits address or not.
 * \param addr The I2C address.
@@ -67,7 +67,7 @@ struct i2c_device_addr {
 Exported FUNCTIONS
 ------------------------------------------------------------------------------*/
 
-/**
+/*
 * \fn drxbsp_i2c_init()
 * \brief Initialize I2C communication module.
 * \return drx_status_t Return status.
@@ -76,7 +76,7 @@ Exported FUNCTIONS
 */
 	drx_status_t drxbsp_i2c_init(void);
 
-/**
+/*
 * \fn drxbsp_i2c_term()
 * \brief Terminate I2C communication module.
 * \return drx_status_t Return status.
@@ -85,7 +85,7 @@ Exported FUNCTIONS
 */
 	drx_status_t drxbsp_i2c_term(void);
 
-/**
+/*
 * \fn drx_status_t drxbsp_i2c_write_read( struct i2c_device_addr *w_dev_addr,
 *                                       u16 w_count,
 *                                       u8 *wData,
@@ -121,7 +121,7 @@ Exported FUNCTIONS
 					 struct i2c_device_addr *r_dev_addr,
 					 u16 r_count, u8 *r_data);
 
-/**
+/*
 * \fn drxbsp_i2c_error_text()
 * \brief Returns a human readable error.
 * Counter part of numerical drx_i2c_error_g.
@@ -130,7 +130,7 @@ Exported FUNCTIONS
 */
 	char *drxbsp_i2c_error_text(void);
 
-/**
+/*
 * \var drx_i2c_error_g;
 * \brief I2C specific error codes, platform dependent.
 */
diff --git a/drivers/media/dvb-frontends/drx39xyj/drx_driver.h b/drivers/media/dvb-frontends/drx39xyj/drx_driver.h
index cd69e187ba7a..855685b6b386 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drx_driver.h
+++ b/drivers/media/dvb-frontends/drx39xyj/drx_driver.h
@@ -46,7 +46,7 @@ struct i2c_device_addr {
 	void *user_data;		/* User data pointer */
 };
 
-/**
+/*
 * \def IS_I2C_10BIT( addr )
 * \brief Determine if I2C address 'addr' is a 10 bits address or not.
 * \param addr The I2C address.
@@ -61,7 +61,7 @@ struct i2c_device_addr {
 Exported FUNCTIONS
 ------------------------------------------------------------------------------*/
 
-/**
+/*
 * \fn drxbsp_i2c_init()
 * \brief Initialize I2C communication module.
 * \return int Return status.
@@ -70,7 +70,7 @@ Exported FUNCTIONS
 */
 int drxbsp_i2c_init(void);
 
-/**
+/*
 * \fn drxbsp_i2c_term()
 * \brief Terminate I2C communication module.
 * \return int Return status.
@@ -79,7 +79,7 @@ int drxbsp_i2c_init(void);
 */
 int drxbsp_i2c_term(void);
 
-/**
+/*
 * \fn int drxbsp_i2c_write_read( struct i2c_device_addr *w_dev_addr,
 *                                       u16 w_count,
 *                                       u8 * wData,
@@ -115,7 +115,7 @@ int drxbsp_i2c_write_read(struct i2c_device_addr *w_dev_addr,
 					struct i2c_device_addr *r_dev_addr,
 					u16 r_count, u8 *r_data);
 
-/**
+/*
 * \fn drxbsp_i2c_error_text()
 * \brief Returns a human readable error.
 * Counter part of numerical drx_i2c_error_g.
@@ -124,7 +124,7 @@ int drxbsp_i2c_write_read(struct i2c_device_addr *w_dev_addr,
 */
 char *drxbsp_i2c_error_text(void);
 
-/**
+/*
 * \var drx_i2c_error_g;
 * \brief I2C specific error codes, platform dependent.
 */
@@ -241,13 +241,13 @@ int drxbsp_tuner_default_i2c_write_read(struct tuner_instance *tuner,
 						struct i2c_device_addr *r_dev_addr,
 						u16 r_count, u8 *r_data);
 
-/**************
+/*************
 *
 * This section configures the DRX Data Access Protocols (DAPs).
 *
 **************/
 
-/**
+/*
 * \def DRXDAP_SINGLE_MASTER
 * \brief Enable I2C single or I2C multimaster mode on host.
 *
@@ -262,7 +262,7 @@ int drxbsp_tuner_default_i2c_write_read(struct tuner_instance *tuner,
 #define DRXDAP_SINGLE_MASTER 1
 #endif
 
-/**
+/*
 * \def DRXDAP_MAX_WCHUNKSIZE
 * \brief Defines maximum chunksize of an i2c write action by host.
 *
@@ -282,7 +282,7 @@ int drxbsp_tuner_default_i2c_write_read(struct tuner_instance *tuner,
 #define  DRXDAP_MAX_WCHUNKSIZE 60
 #endif
 
-/**
+/*
 * \def DRXDAP_MAX_RCHUNKSIZE
 * \brief Defines maximum chunksize of an i2c read action by host.
 *
@@ -297,13 +297,13 @@ int drxbsp_tuner_default_i2c_write_read(struct tuner_instance *tuner,
 #define  DRXDAP_MAX_RCHUNKSIZE 60
 #endif
 
-/**************
+/*************
 *
 * This section describes drxdriver defines.
 *
 **************/
 
-/**
+/*
 * \def DRX_UNKNOWN
 * \brief Generic UNKNOWN value for DRX enumerated types.
 *
@@ -313,7 +313,7 @@ int drxbsp_tuner_default_i2c_write_read(struct tuner_instance *tuner,
 #define DRX_UNKNOWN (254)
 #endif
 
-/**
+/*
 * \def DRX_AUTO
 * \brief Generic AUTO value for DRX enumerated types.
 *
@@ -324,104 +324,104 @@ int drxbsp_tuner_default_i2c_write_read(struct tuner_instance *tuner,
 #define DRX_AUTO    (255)
 #endif
 
-/**************
+/*************
 *
 * This section describes flag definitions for the device capbilities.
 *
 **************/
 
-/**
+/*
 * \brief LNA capability flag
 *
 * Device has a Low Noise Amplifier
 *
 */
 #define DRX_CAPABILITY_HAS_LNA           (1UL <<  0)
-/**
+/*
 * \brief OOB-RX capability flag
 *
 * Device has OOB-RX
 *
 */
 #define DRX_CAPABILITY_HAS_OOBRX         (1UL <<  1)
-/**
+/*
 * \brief ATV capability flag
 *
 * Device has ATV
 *
 */
 #define DRX_CAPABILITY_HAS_ATV           (1UL <<  2)
-/**
+/*
 * \brief DVB-T capability flag
 *
 * Device has DVB-T
 *
 */
 #define DRX_CAPABILITY_HAS_DVBT          (1UL <<  3)
-/**
+/*
 * \brief  ITU-B capability flag
 *
 * Device has ITU-B
 *
 */
 #define DRX_CAPABILITY_HAS_ITUB          (1UL <<  4)
-/**
+/*
 * \brief  Audio capability flag
 *
 * Device has Audio
 *
 */
 #define DRX_CAPABILITY_HAS_AUD           (1UL <<  5)
-/**
+/*
 * \brief  SAW switch capability flag
 *
 * Device has SAW switch
 *
 */
 #define DRX_CAPABILITY_HAS_SAWSW         (1UL <<  6)
-/**
+/*
 * \brief  GPIO1 capability flag
 *
 * Device has GPIO1
 *
 */
 #define DRX_CAPABILITY_HAS_GPIO1         (1UL <<  7)
-/**
+/*
 * \brief  GPIO2 capability flag
 *
 * Device has GPIO2
 *
 */
 #define DRX_CAPABILITY_HAS_GPIO2         (1UL <<  8)
-/**
+/*
 * \brief  IRQN capability flag
 *
 * Device has IRQN
 *
 */
 #define DRX_CAPABILITY_HAS_IRQN          (1UL <<  9)
-/**
+/*
 * \brief  8VSB capability flag
 *
 * Device has 8VSB
 *
 */
 #define DRX_CAPABILITY_HAS_8VSB          (1UL << 10)
-/**
+/*
 * \brief  SMA-TX capability flag
 *
 * Device has SMATX
 *
 */
 #define DRX_CAPABILITY_HAS_SMATX         (1UL << 11)
-/**
+/*
 * \brief  SMA-RX capability flag
 *
 * Device has SMARX
 *
 */
 #define DRX_CAPABILITY_HAS_SMARX         (1UL << 12)
-/**
+/*
 * \brief  ITU-A/C capability flag
 *
 * Device has ITU-A/C
@@ -439,7 +439,7 @@ MACROS
 	 DRX_VERSIONSTRING_HELP(PATCH)
 #define DRX_VERSIONSTRING_HELP(NUM) #NUM
 
-/**
+/*
 * \brief Macro to create byte array elements from 16 bit integers.
 * This macro is used to create byte arrays for block writes.
 * Block writes speed up I2C traffic between host and demod.
@@ -449,7 +449,7 @@ MACROS
 #define DRX_16TO8(x) ((u8) (((u16)x) & 0xFF)), \
 			((u8)((((u16)x)>>8)&0xFF))
 
-/**
+/*
 * \brief Macro to convert 16 bit register value to a s32
 */
 #define DRX_U16TODRXFREQ(x)   ((x & 0x8000) ? \
@@ -461,191 +461,191 @@ MACROS
 ENUM
 -------------------------------------------------------------------------*/
 
-/**
+/*
 * \enum enum drx_standard
 * \brief Modulation standards.
 */
 enum drx_standard {
-	DRX_STANDARD_DVBT = 0, /**< Terrestrial DVB-T.               */
-	DRX_STANDARD_8VSB,     /**< Terrestrial 8VSB.                */
-	DRX_STANDARD_NTSC,     /**< Terrestrial\Cable analog NTSC.   */
+	DRX_STANDARD_DVBT = 0, /*< Terrestrial DVB-T.               */
+	DRX_STANDARD_8VSB,     /*< Terrestrial 8VSB.                */
+	DRX_STANDARD_NTSC,     /*< Terrestrial\Cable analog NTSC.   */
 	DRX_STANDARD_PAL_SECAM_BG,
-				/**< Terrestrial analog PAL/SECAM B/G */
+				/*< Terrestrial analog PAL/SECAM B/G */
 	DRX_STANDARD_PAL_SECAM_DK,
-				/**< Terrestrial analog PAL/SECAM D/K */
+				/*< Terrestrial analog PAL/SECAM D/K */
 	DRX_STANDARD_PAL_SECAM_I,
-				/**< Terrestrial analog PAL/SECAM I   */
+				/*< Terrestrial analog PAL/SECAM I   */
 	DRX_STANDARD_PAL_SECAM_L,
-				/**< Terrestrial analog PAL/SECAM L
+				/*< Terrestrial analog PAL/SECAM L
 					with negative modulation        */
 	DRX_STANDARD_PAL_SECAM_LP,
-				/**< Terrestrial analog PAL/SECAM L
+				/*< Terrestrial analog PAL/SECAM L
 					with positive modulation        */
-	DRX_STANDARD_ITU_A,    /**< Cable ITU ANNEX A.               */
-	DRX_STANDARD_ITU_B,    /**< Cable ITU ANNEX B.               */
-	DRX_STANDARD_ITU_C,    /**< Cable ITU ANNEX C.               */
-	DRX_STANDARD_ITU_D,    /**< Cable ITU ANNEX D.               */
-	DRX_STANDARD_FM,       /**< Terrestrial\Cable FM radio       */
-	DRX_STANDARD_DTMB,     /**< Terrestrial DTMB standard (China)*/
+	DRX_STANDARD_ITU_A,    /*< Cable ITU ANNEX A.               */
+	DRX_STANDARD_ITU_B,    /*< Cable ITU ANNEX B.               */
+	DRX_STANDARD_ITU_C,    /*< Cable ITU ANNEX C.               */
+	DRX_STANDARD_ITU_D,    /*< Cable ITU ANNEX D.               */
+	DRX_STANDARD_FM,       /*< Terrestrial\Cable FM radio       */
+	DRX_STANDARD_DTMB,     /*< Terrestrial DTMB standard (China)*/
 	DRX_STANDARD_UNKNOWN = DRX_UNKNOWN,
-				/**< Standard unknown.                */
+				/*< Standard unknown.                */
 	DRX_STANDARD_AUTO = DRX_AUTO
-				/**< Autodetect standard.             */
+				/*< Autodetect standard.             */
 };
 
-/**
+/*
 * \enum enum drx_standard
 * \brief Modulation sub-standards.
 */
 enum drx_substandard {
-	DRX_SUBSTANDARD_MAIN = 0, /**< Main subvariant of standard   */
+	DRX_SUBSTANDARD_MAIN = 0, /*< Main subvariant of standard   */
 	DRX_SUBSTANDARD_ATV_BG_SCANDINAVIA,
 	DRX_SUBSTANDARD_ATV_DK_POLAND,
 	DRX_SUBSTANDARD_ATV_DK_CHINA,
 	DRX_SUBSTANDARD_UNKNOWN = DRX_UNKNOWN,
-					/**< Sub-standard unknown.         */
+					/*< Sub-standard unknown.         */
 	DRX_SUBSTANDARD_AUTO = DRX_AUTO
-					/**< Auto (default) sub-standard   */
+					/*< Auto (default) sub-standard   */
 };
 
-/**
+/*
 * \enum enum drx_bandwidth
 * \brief Channel bandwidth or channel spacing.
 */
 enum drx_bandwidth {
-	DRX_BANDWIDTH_8MHZ = 0,	 /**< Bandwidth 8 MHz.   */
-	DRX_BANDWIDTH_7MHZ,	 /**< Bandwidth 7 MHz.   */
-	DRX_BANDWIDTH_6MHZ,	 /**< Bandwidth 6 MHz.   */
+	DRX_BANDWIDTH_8MHZ = 0,	 /*< Bandwidth 8 MHz.   */
+	DRX_BANDWIDTH_7MHZ,	 /*< Bandwidth 7 MHz.   */
+	DRX_BANDWIDTH_6MHZ,	 /*< Bandwidth 6 MHz.   */
 	DRX_BANDWIDTH_UNKNOWN = DRX_UNKNOWN,
-					/**< Bandwidth unknown. */
+					/*< Bandwidth unknown. */
 	DRX_BANDWIDTH_AUTO = DRX_AUTO
-					/**< Auto Set Bandwidth */
+					/*< Auto Set Bandwidth */
 };
 
-/**
+/*
 * \enum enum drx_mirror
 * \brief Indicate if channel spectrum is mirrored or not.
 */
 enum drx_mirror {
-	DRX_MIRROR_NO = 0,   /**< Spectrum is not mirrored.           */
-	DRX_MIRROR_YES,	     /**< Spectrum is mirrored.               */
+	DRX_MIRROR_NO = 0,   /*< Spectrum is not mirrored.           */
+	DRX_MIRROR_YES,	     /*< Spectrum is mirrored.               */
 	DRX_MIRROR_UNKNOWN = DRX_UNKNOWN,
-				/**< Unknown if spectrum is mirrored.    */
+				/*< Unknown if spectrum is mirrored.    */
 	DRX_MIRROR_AUTO = DRX_AUTO
-				/**< Autodetect if spectrum is mirrored. */
+				/*< Autodetect if spectrum is mirrored. */
 };
 
-/**
+/*
 * \enum enum drx_modulation
 * \brief Constellation type of the channel.
 */
 enum drx_modulation {
-	DRX_CONSTELLATION_BPSK = 0,  /**< Modulation is BPSK.       */
-	DRX_CONSTELLATION_QPSK,	     /**< Constellation is QPSK.    */
-	DRX_CONSTELLATION_PSK8,	     /**< Constellation is PSK8.    */
-	DRX_CONSTELLATION_QAM16,     /**< Constellation is QAM16.   */
-	DRX_CONSTELLATION_QAM32,     /**< Constellation is QAM32.   */
-	DRX_CONSTELLATION_QAM64,     /**< Constellation is QAM64.   */
-	DRX_CONSTELLATION_QAM128,    /**< Constellation is QAM128.  */
-	DRX_CONSTELLATION_QAM256,    /**< Constellation is QAM256.  */
-	DRX_CONSTELLATION_QAM512,    /**< Constellation is QAM512.  */
-	DRX_CONSTELLATION_QAM1024,   /**< Constellation is QAM1024. */
-	DRX_CONSTELLATION_QPSK_NR,   /**< Constellation is QPSK_NR  */
+	DRX_CONSTELLATION_BPSK = 0,  /*< Modulation is BPSK.       */
+	DRX_CONSTELLATION_QPSK,	     /*< Constellation is QPSK.    */
+	DRX_CONSTELLATION_PSK8,	     /*< Constellation is PSK8.    */
+	DRX_CONSTELLATION_QAM16,     /*< Constellation is QAM16.   */
+	DRX_CONSTELLATION_QAM32,     /*< Constellation is QAM32.   */
+	DRX_CONSTELLATION_QAM64,     /*< Constellation is QAM64.   */
+	DRX_CONSTELLATION_QAM128,    /*< Constellation is QAM128.  */
+	DRX_CONSTELLATION_QAM256,    /*< Constellation is QAM256.  */
+	DRX_CONSTELLATION_QAM512,    /*< Constellation is QAM512.  */
+	DRX_CONSTELLATION_QAM1024,   /*< Constellation is QAM1024. */
+	DRX_CONSTELLATION_QPSK_NR,   /*< Constellation is QPSK_NR  */
 	DRX_CONSTELLATION_UNKNOWN = DRX_UNKNOWN,
-					/**< Constellation unknown.    */
+					/*< Constellation unknown.    */
 	DRX_CONSTELLATION_AUTO = DRX_AUTO
-					/**< Autodetect constellation. */
+					/*< Autodetect constellation. */
 };
 
-/**
+/*
 * \enum enum drx_hierarchy
 * \brief Hierarchy of the channel.
 */
 enum drx_hierarchy {
-	DRX_HIERARCHY_NONE = 0,	/**< None hierarchical channel.     */
-	DRX_HIERARCHY_ALPHA1,	/**< Hierarchical channel, alpha=1. */
-	DRX_HIERARCHY_ALPHA2,	/**< Hierarchical channel, alpha=2. */
-	DRX_HIERARCHY_ALPHA4,	/**< Hierarchical channel, alpha=4. */
+	DRX_HIERARCHY_NONE = 0,	/*< None hierarchical channel.     */
+	DRX_HIERARCHY_ALPHA1,	/*< Hierarchical channel, alpha=1. */
+	DRX_HIERARCHY_ALPHA2,	/*< Hierarchical channel, alpha=2. */
+	DRX_HIERARCHY_ALPHA4,	/*< Hierarchical channel, alpha=4. */
 	DRX_HIERARCHY_UNKNOWN = DRX_UNKNOWN,
-				/**< Hierarchy unknown.             */
+				/*< Hierarchy unknown.             */
 	DRX_HIERARCHY_AUTO = DRX_AUTO
-				/**< Autodetect hierarchy.          */
+				/*< Autodetect hierarchy.          */
 };
 
-/**
+/*
 * \enum enum drx_priority
 * \brief Channel priority in case of hierarchical transmission.
 */
 enum drx_priority {
-	DRX_PRIORITY_LOW = 0,  /**< Low priority channel.  */
-	DRX_PRIORITY_HIGH,     /**< High priority channel. */
+	DRX_PRIORITY_LOW = 0,  /*< Low priority channel.  */
+	DRX_PRIORITY_HIGH,     /*< High priority channel. */
 	DRX_PRIORITY_UNKNOWN = DRX_UNKNOWN
-				/**< Priority unknown.      */
+				/*< Priority unknown.      */
 };
 
-/**
+/*
 * \enum enum drx_coderate
 * \brief Channel priority in case of hierarchical transmission.
 */
 enum drx_coderate {
-		DRX_CODERATE_1DIV2 = 0,	/**< Code rate 1/2nd.      */
-		DRX_CODERATE_2DIV3,	/**< Code rate 2/3nd.      */
-		DRX_CODERATE_3DIV4,	/**< Code rate 3/4nd.      */
-		DRX_CODERATE_5DIV6,	/**< Code rate 5/6nd.      */
-		DRX_CODERATE_7DIV8,	/**< Code rate 7/8nd.      */
+		DRX_CODERATE_1DIV2 = 0,	/*< Code rate 1/2nd.      */
+		DRX_CODERATE_2DIV3,	/*< Code rate 2/3nd.      */
+		DRX_CODERATE_3DIV4,	/*< Code rate 3/4nd.      */
+		DRX_CODERATE_5DIV6,	/*< Code rate 5/6nd.      */
+		DRX_CODERATE_7DIV8,	/*< Code rate 7/8nd.      */
 		DRX_CODERATE_UNKNOWN = DRX_UNKNOWN,
-					/**< Code rate unknown.    */
+					/*< Code rate unknown.    */
 		DRX_CODERATE_AUTO = DRX_AUTO
-					/**< Autodetect code rate. */
+					/*< Autodetect code rate. */
 };
 
-/**
+/*
 * \enum enum drx_guard
 * \brief Guard interval of a channel.
 */
 enum drx_guard {
-	DRX_GUARD_1DIV32 = 0, /**< Guard interval 1/32nd.     */
-	DRX_GUARD_1DIV16,     /**< Guard interval 1/16th.     */
-	DRX_GUARD_1DIV8,      /**< Guard interval 1/8th.      */
-	DRX_GUARD_1DIV4,      /**< Guard interval 1/4th.      */
+	DRX_GUARD_1DIV32 = 0, /*< Guard interval 1/32nd.     */
+	DRX_GUARD_1DIV16,     /*< Guard interval 1/16th.     */
+	DRX_GUARD_1DIV8,      /*< Guard interval 1/8th.      */
+	DRX_GUARD_1DIV4,      /*< Guard interval 1/4th.      */
 	DRX_GUARD_UNKNOWN = DRX_UNKNOWN,
-				/**< Guard interval unknown.    */
+				/*< Guard interval unknown.    */
 	DRX_GUARD_AUTO = DRX_AUTO
-				/**< Autodetect guard interval. */
+				/*< Autodetect guard interval. */
 };
 
-/**
+/*
 * \enum enum drx_fft_mode
 * \brief FFT mode.
 */
 enum drx_fft_mode {
-	DRX_FFTMODE_2K = 0,    /**< 2K FFT mode.         */
-	DRX_FFTMODE_4K,	       /**< 4K FFT mode.         */
-	DRX_FFTMODE_8K,	       /**< 8K FFT mode.         */
+	DRX_FFTMODE_2K = 0,    /*< 2K FFT mode.         */
+	DRX_FFTMODE_4K,	       /*< 4K FFT mode.         */
+	DRX_FFTMODE_8K,	       /*< 8K FFT mode.         */
 	DRX_FFTMODE_UNKNOWN = DRX_UNKNOWN,
-				/**< FFT mode unknown.    */
+				/*< FFT mode unknown.    */
 	DRX_FFTMODE_AUTO = DRX_AUTO
-				/**< Autodetect FFT mode. */
+				/*< Autodetect FFT mode. */
 };
 
-/**
+/*
 * \enum enum drx_classification
 * \brief Channel classification.
 */
 enum drx_classification {
-	DRX_CLASSIFICATION_GAUSS = 0, /**< Gaussion noise.            */
-	DRX_CLASSIFICATION_HVY_GAUSS, /**< Heavy Gaussion noise.      */
-	DRX_CLASSIFICATION_COCHANNEL, /**< Co-channel.                */
-	DRX_CLASSIFICATION_STATIC,    /**< Static echo.               */
-	DRX_CLASSIFICATION_MOVING,    /**< Moving echo.               */
-	DRX_CLASSIFICATION_ZERODB,    /**< Zero dB echo.              */
+	DRX_CLASSIFICATION_GAUSS = 0, /*< Gaussion noise.            */
+	DRX_CLASSIFICATION_HVY_GAUSS, /*< Heavy Gaussion noise.      */
+	DRX_CLASSIFICATION_COCHANNEL, /*< Co-channel.                */
+	DRX_CLASSIFICATION_STATIC,    /*< Static echo.               */
+	DRX_CLASSIFICATION_MOVING,    /*< Moving echo.               */
+	DRX_CLASSIFICATION_ZERODB,    /*< Zero dB echo.              */
 	DRX_CLASSIFICATION_UNKNOWN = DRX_UNKNOWN,
-					/**< Unknown classification     */
+					/*< Unknown classification     */
 	DRX_CLASSIFICATION_AUTO = DRX_AUTO
-					/**< Autodetect classification. */
+					/*< Autodetect classification. */
 };
 
-/**
+/*
 * /enum enum drx_interleave_mode
 * /brief Interleave modes
 */
@@ -673,80 +673,80 @@ enum drx_interleave_mode {
 	DRX_INTERLEAVEMODE_B52_M48,
 	DRX_INTERLEAVEMODE_B52_M0,
 	DRX_INTERLEAVEMODE_UNKNOWN = DRX_UNKNOWN,
-					/**< Unknown interleave mode    */
+					/*< Unknown interleave mode    */
 	DRX_INTERLEAVEMODE_AUTO = DRX_AUTO
-					/**< Autodetect interleave mode */
+					/*< Autodetect interleave mode */
 };
 
-/**
+/*
 * \enum enum drx_carrier_mode
 * \brief Channel Carrier Mode.
 */
 enum drx_carrier_mode {
-	DRX_CARRIER_MULTI = 0,		/**< Multi carrier mode       */
-	DRX_CARRIER_SINGLE,		/**< Single carrier mode      */
+	DRX_CARRIER_MULTI = 0,		/*< Multi carrier mode       */
+	DRX_CARRIER_SINGLE,		/*< Single carrier mode      */
 	DRX_CARRIER_UNKNOWN = DRX_UNKNOWN,
-					/**< Carrier mode unknown.    */
-	DRX_CARRIER_AUTO = DRX_AUTO	/**< Autodetect carrier mode  */
+					/*< Carrier mode unknown.    */
+	DRX_CARRIER_AUTO = DRX_AUTO	/*< Autodetect carrier mode  */
 };
 
-/**
+/*
 * \enum enum drx_frame_mode
 * \brief Channel Frame Mode.
 */
 enum drx_frame_mode {
-	DRX_FRAMEMODE_420 = 0,	 /**< 420 with variable PN  */
-	DRX_FRAMEMODE_595,	 /**< 595                   */
-	DRX_FRAMEMODE_945,	 /**< 945 with variable PN  */
+	DRX_FRAMEMODE_420 = 0,	 /*< 420 with variable PN  */
+	DRX_FRAMEMODE_595,	 /*< 595                   */
+	DRX_FRAMEMODE_945,	 /*< 945 with variable PN  */
 	DRX_FRAMEMODE_420_FIXED_PN,
-					/**< 420 with fixed PN     */
+					/*< 420 with fixed PN     */
 	DRX_FRAMEMODE_945_FIXED_PN,
-					/**< 945 with fixed PN     */
+					/*< 945 with fixed PN     */
 	DRX_FRAMEMODE_UNKNOWN = DRX_UNKNOWN,
-					/**< Frame mode unknown.   */
+					/*< Frame mode unknown.   */
 	DRX_FRAMEMODE_AUTO = DRX_AUTO
-					/**< Autodetect frame mode */
+					/*< Autodetect frame mode */
 };
 
-/**
+/*
 * \enum enum drx_tps_frame
 * \brief Frame number in current super-frame.
 */
 enum drx_tps_frame {
-	DRX_TPS_FRAME1 = 0,	  /**< TPS frame 1.       */
-	DRX_TPS_FRAME2,		  /**< TPS frame 2.       */
-	DRX_TPS_FRAME3,		  /**< TPS frame 3.       */
-	DRX_TPS_FRAME4,		  /**< TPS frame 4.       */
+	DRX_TPS_FRAME1 = 0,	  /*< TPS frame 1.       */
+	DRX_TPS_FRAME2,		  /*< TPS frame 2.       */
+	DRX_TPS_FRAME3,		  /*< TPS frame 3.       */
+	DRX_TPS_FRAME4,		  /*< TPS frame 4.       */
 	DRX_TPS_FRAME_UNKNOWN = DRX_UNKNOWN
-					/**< TPS frame unknown. */
+					/*< TPS frame unknown. */
 };
 
-/**
+/*
 * \enum enum drx_ldpc
 * \brief TPS LDPC .
 */
 enum drx_ldpc {
-	DRX_LDPC_0_4 = 0,	  /**< LDPC 0.4           */
-	DRX_LDPC_0_6,		  /**< LDPC 0.6           */
-	DRX_LDPC_0_8,		  /**< LDPC 0.8           */
+	DRX_LDPC_0_4 = 0,	  /*< LDPC 0.4           */
+	DRX_LDPC_0_6,		  /*< LDPC 0.6           */
+	DRX_LDPC_0_8,		  /*< LDPC 0.8           */
 	DRX_LDPC_UNKNOWN = DRX_UNKNOWN,
-					/**< LDPC unknown.      */
-	DRX_LDPC_AUTO = DRX_AUTO  /**< Autodetect LDPC    */
+					/*< LDPC unknown.      */
+	DRX_LDPC_AUTO = DRX_AUTO  /*< Autodetect LDPC    */
 };
 
-/**
+/*
 * \enum enum drx_pilot_mode
 * \brief Pilot modes in DTMB.
 */
 enum drx_pilot_mode {
-	DRX_PILOT_ON = 0,	  /**< Pilot On             */
-	DRX_PILOT_OFF,		  /**< Pilot Off            */
+	DRX_PILOT_ON = 0,	  /*< Pilot On             */
+	DRX_PILOT_OFF,		  /*< Pilot Off            */
 	DRX_PILOT_UNKNOWN = DRX_UNKNOWN,
-					/**< Pilot unknown.       */
-	DRX_PILOT_AUTO = DRX_AUTO /**< Autodetect Pilot     */
+					/*< Pilot unknown.       */
+	DRX_PILOT_AUTO = DRX_AUTO /*< Autodetect Pilot     */
 };
 
-/**
+/*
  * enum drxu_code_action - indicate if firmware has to be uploaded or verified.
  * @UCODE_UPLOAD:	Upload the microcode image to device
  * @UCODE_VERIFY:	Compare microcode image with code on device
@@ -756,7 +756,7 @@ enum drxu_code_action {
 	UCODE_VERIFY
 };
 
-/**
+/*
 * \enum enum drx_lock_status * \brief Used to reflect current lock status of demodulator.
 *
 * The generic lock states have device dependent semantics.
@@ -801,7 +801,7 @@ enum drx_lock_status {
 	DRX_LOCKED
 };
 
-/**
+/*
 * \enum enum drx_uio* \brief Used to address a User IO (UIO).
 */
 enum drx_uio {
@@ -840,7 +840,7 @@ enum drx_uio {
 	DRX_UIO_MAX = DRX_UIO32
 };
 
-/**
+/*
 * \enum enum drxuio_mode * \brief Used to configure the modus oprandi of a UIO.
 *
 * DRX_UIO_MODE_FIRMWARE is an old uio mode.
@@ -850,37 +850,37 @@ enum drx_uio {
 */
 enum drxuio_mode {
 	DRX_UIO_MODE_DISABLE = 0x01,
-			    /**< not used, pin is configured as input */
+			    /*< not used, pin is configured as input */
 	DRX_UIO_MODE_READWRITE = 0x02,
-			    /**< used for read/write by application   */
+			    /*< used for read/write by application   */
 	DRX_UIO_MODE_FIRMWARE = 0x04,
-			    /**< controlled by firmware, function 0   */
+			    /*< controlled by firmware, function 0   */
 	DRX_UIO_MODE_FIRMWARE0 = DRX_UIO_MODE_FIRMWARE,
-					    /**< same as above        */
+					    /*< same as above        */
 	DRX_UIO_MODE_FIRMWARE1 = 0x08,
-			    /**< controlled by firmware, function 1   */
+			    /*< controlled by firmware, function 1   */
 	DRX_UIO_MODE_FIRMWARE2 = 0x10,
-			    /**< controlled by firmware, function 2   */
+			    /*< controlled by firmware, function 2   */
 	DRX_UIO_MODE_FIRMWARE3 = 0x20,
-			    /**< controlled by firmware, function 3   */
+			    /*< controlled by firmware, function 3   */
 	DRX_UIO_MODE_FIRMWARE4 = 0x40,
-			    /**< controlled by firmware, function 4   */
+			    /*< controlled by firmware, function 4   */
 	DRX_UIO_MODE_FIRMWARE5 = 0x80
-			    /**< controlled by firmware, function 5   */
+			    /*< controlled by firmware, function 5   */
 };
 
-/**
+/*
 * \enum enum drxoob_downstream_standard * \brief Used to select OOB standard.
 *
 * Based on ANSI 55-1 and 55-2
 */
 enum drxoob_downstream_standard {
 	DRX_OOB_MODE_A = 0,
-		       /**< ANSI 55-1   */
+		       /*< ANSI 55-1   */
 	DRX_OOB_MODE_B_GRADE_A,
-		       /**< ANSI 55-2 A */
+		       /*< ANSI 55-2 A */
 	DRX_OOB_MODE_B_GRADE_B
-		       /**< ANSI 55-2 B */
+		       /*< ANSI 55-2 B */
 };
 
 /*-------------------------------------------------------------------------
@@ -924,7 +924,7 @@ STRUCTS
 /*============================================================================*/
 /*============================================================================*/
 
-/**
+/*
  * struct drxu_code_info	Parameters for microcode upload and verfiy.
  *
  * @mc_file:	microcode file name
@@ -935,7 +935,7 @@ struct drxu_code_info {
 	char 			*mc_file;
 };
 
-/**
+/*
 * \struct drx_mc_version_rec_t
 * \brief Microcode version record
 * Version numbers are stored in BCD format, as usual:
@@ -963,7 +963,7 @@ struct drx_mc_version_rec {
 
 /*========================================*/
 
-/**
+/*
 * \struct drx_filter_info_t
 * \brief Parameters for loading filter coefficients
 *
@@ -971,18 +971,18 @@ struct drx_mc_version_rec {
 */
 struct drx_filter_info {
 	u8 *data_re;
-	      /**< pointer to coefficients for RE */
+	      /*< pointer to coefficients for RE */
 	u8 *data_im;
-	      /**< pointer to coefficients for IM */
+	      /*< pointer to coefficients for IM */
 	u16 size_re;
-	      /**< size of coefficients for RE    */
+	      /*< size of coefficients for RE    */
 	u16 size_im;
-	      /**< size of coefficients for IM    */
+	      /*< size of coefficients for IM    */
 };
 
 /*========================================*/
 
-/**
+/*
 * \struct struct drx_channel * \brief The set of parameters describing a single channel.
 *
 * Used by DRX_CTRL_SET_CHANNEL and DRX_CTRL_GET_CHANNEL.
@@ -991,29 +991,29 @@ struct drx_filter_info {
 */
 struct drx_channel {
 	s32 frequency;
-				/**< frequency in kHz                 */
+				/*< frequency in kHz                 */
 	enum drx_bandwidth bandwidth;
-				/**< bandwidth                        */
-	enum drx_mirror mirror;	/**< mirrored or not on RF            */
+				/*< bandwidth                        */
+	enum drx_mirror mirror;	/*< mirrored or not on RF            */
 	enum drx_modulation constellation;
-				/**< constellation                    */
+				/*< constellation                    */
 	enum drx_hierarchy hierarchy;
-				/**< hierarchy                        */
-	enum drx_priority priority;	/**< priority                         */
-	enum drx_coderate coderate;	/**< coderate                         */
-	enum drx_guard guard;	/**< guard interval                   */
-	enum drx_fft_mode fftmode;	/**< fftmode                          */
+				/*< hierarchy                        */
+	enum drx_priority priority;	/*< priority                         */
+	enum drx_coderate coderate;	/*< coderate                         */
+	enum drx_guard guard;	/*< guard interval                   */
+	enum drx_fft_mode fftmode;	/*< fftmode                          */
 	enum drx_classification classification;
-				/**< classification                   */
+				/*< classification                   */
 	u32 symbolrate;
-				/**< symbolrate in symbols/sec        */
+				/*< symbolrate in symbols/sec        */
 	enum drx_interleave_mode interleavemode;
-				/**< interleaveMode QAM               */
-	enum drx_ldpc ldpc;		/**< ldpc                             */
-	enum drx_carrier_mode carrier;	/**< carrier                          */
+				/*< interleaveMode QAM               */
+	enum drx_ldpc ldpc;		/*< ldpc                             */
+	enum drx_carrier_mode carrier;	/*< carrier                          */
 	enum drx_frame_mode framemode;
-				/**< frame mode                       */
-	enum drx_pilot_mode pilot;	/**< pilot mode                       */
+				/*< frame mode                       */
+	enum drx_pilot_mode pilot;	/*< pilot mode                       */
 };
 
 /*========================================*/
@@ -1027,74 +1027,74 @@ enum drx_cfg_sqi_speed {
 
 /*========================================*/
 
-/**
+/*
 * \struct struct drx_complex * A complex number.
 *
 * Used by DRX_CTRL_CONSTEL.
 */
 struct drx_complex {
 	s16 im;
-     /**< Imaginary part. */
+     /*< Imaginary part. */
 	s16 re;
-     /**< Real part.      */
+     /*< Real part.      */
 };
 
 /*========================================*/
 
-/**
+/*
 * \struct struct drx_frequency_plan * Array element of a frequency plan.
 *
 * Used by DRX_CTRL_SCAN_INIT.
 */
 struct drx_frequency_plan {
 	s32 first;
-		     /**< First centre frequency in this band        */
+		     /*< First centre frequency in this band        */
 	s32 last;
-		     /**< Last centre frequency in this band         */
+		     /*< Last centre frequency in this band         */
 	s32 step;
-		     /**< Stepping frequency in this band            */
+		     /*< Stepping frequency in this band            */
 	enum drx_bandwidth bandwidth;
-		     /**< Bandwidth within this frequency band       */
+		     /*< Bandwidth within this frequency band       */
 	u16 ch_number;
-		     /**< First channel number in this band, or first
+		     /*< First channel number in this band, or first
 			    index in ch_names                         */
 	char **ch_names;
-		     /**< Optional list of channel names in this
+		     /*< Optional list of channel names in this
 			    band                                     */
 };
 
 /*========================================*/
 
-/**
+/*
 * \struct struct drx_scan_param * Parameters for channel scan.
 *
 * Used by DRX_CTRL_SCAN_INIT.
 */
 struct drx_scan_param {
 	struct drx_frequency_plan *frequency_plan;
-				  /**< Frequency plan (array)*/
-	u16 frequency_plan_size;  /**< Number of bands       */
-	u32 num_tries;		  /**< Max channels tried    */
-	s32 skip;	  /**< Minimum frequency step to take
+				  /*< Frequency plan (array)*/
+	u16 frequency_plan_size;  /*< Number of bands       */
+	u32 num_tries;		  /*< Max channels tried    */
+	s32 skip;	  /*< Minimum frequency step to take
 					after a channel is found */
-	void *ext_params;	  /**< Standard specific params */
+	void *ext_params;	  /*< Standard specific params */
 };
 
 /*========================================*/
 
-/**
+/*
 * \brief Scan commands.
 * Used by scanning algorithms.
 */
 enum drx_scan_command {
-		DRX_SCAN_COMMAND_INIT = 0,/**< Initialize scanning */
-		DRX_SCAN_COMMAND_NEXT,	  /**< Next scan           */
-		DRX_SCAN_COMMAND_STOP	  /**< Stop scanning       */
+		DRX_SCAN_COMMAND_INIT = 0,/*< Initialize scanning */
+		DRX_SCAN_COMMAND_NEXT,	  /*< Next scan           */
+		DRX_SCAN_COMMAND_STOP	  /*< Stop scanning       */
 };
 
 /*========================================*/
 
-/**
+/*
 * \brief Inner scan function prototype.
 */
 typedef int(*drx_scan_func_t) (void *scan_context,
@@ -1104,77 +1104,77 @@ typedef int(*drx_scan_func_t) (void *scan_context,
 
 /*========================================*/
 
-/**
+/*
 * \struct struct drxtps_info * TPS information, DVB-T specific.
 *
 * Used by DRX_CTRL_TPS_INFO.
 */
 	struct drxtps_info {
-		enum drx_fft_mode fftmode;	/**< Fft mode       */
-		enum drx_guard guard;	/**< Guard interval */
+		enum drx_fft_mode fftmode;	/*< Fft mode       */
+		enum drx_guard guard;	/*< Guard interval */
 		enum drx_modulation constellation;
-					/**< Constellation  */
+					/*< Constellation  */
 		enum drx_hierarchy hierarchy;
-					/**< Hierarchy      */
+					/*< Hierarchy      */
 		enum drx_coderate high_coderate;
-					/**< High code rate */
+					/*< High code rate */
 		enum drx_coderate low_coderate;
-					/**< Low cod rate   */
-		enum drx_tps_frame frame;	/**< Tps frame      */
-		u8 length;		/**< Length         */
-		u16 cell_id;		/**< Cell id        */
+					/*< Low cod rate   */
+		enum drx_tps_frame frame;	/*< Tps frame      */
+		u8 length;		/*< Length         */
+		u16 cell_id;		/*< Cell id        */
 	};
 
 /*========================================*/
 
-/**
+/*
 * \brief Power mode of device.
 *
 * Used by DRX_CTRL_SET_POWER_MODE.
 */
 	enum drx_power_mode {
 		DRX_POWER_UP = 0,
-			 /**< Generic         , Power Up Mode   */
+			 /*< Generic         , Power Up Mode   */
 		DRX_POWER_MODE_1,
-			 /**< Device specific , Power Up Mode   */
+			 /*< Device specific , Power Up Mode   */
 		DRX_POWER_MODE_2,
-			 /**< Device specific , Power Up Mode   */
+			 /*< Device specific , Power Up Mode   */
 		DRX_POWER_MODE_3,
-			 /**< Device specific , Power Up Mode   */
+			 /*< Device specific , Power Up Mode   */
 		DRX_POWER_MODE_4,
-			 /**< Device specific , Power Up Mode   */
+			 /*< Device specific , Power Up Mode   */
 		DRX_POWER_MODE_5,
-			 /**< Device specific , Power Up Mode   */
+			 /*< Device specific , Power Up Mode   */
 		DRX_POWER_MODE_6,
-			 /**< Device specific , Power Up Mode   */
+			 /*< Device specific , Power Up Mode   */
 		DRX_POWER_MODE_7,
-			 /**< Device specific , Power Up Mode   */
+			 /*< Device specific , Power Up Mode   */
 		DRX_POWER_MODE_8,
-			 /**< Device specific , Power Up Mode   */
+			 /*< Device specific , Power Up Mode   */
 
 		DRX_POWER_MODE_9,
-			 /**< Device specific , Power Down Mode */
+			 /*< Device specific , Power Down Mode */
 		DRX_POWER_MODE_10,
-			 /**< Device specific , Power Down Mode */
+			 /*< Device specific , Power Down Mode */
 		DRX_POWER_MODE_11,
-			 /**< Device specific , Power Down Mode */
+			 /*< Device specific , Power Down Mode */
 		DRX_POWER_MODE_12,
-			 /**< Device specific , Power Down Mode */
+			 /*< Device specific , Power Down Mode */
 		DRX_POWER_MODE_13,
-			 /**< Device specific , Power Down Mode */
+			 /*< Device specific , Power Down Mode */
 		DRX_POWER_MODE_14,
-			 /**< Device specific , Power Down Mode */
+			 /*< Device specific , Power Down Mode */
 		DRX_POWER_MODE_15,
-			 /**< Device specific , Power Down Mode */
+			 /*< Device specific , Power Down Mode */
 		DRX_POWER_MODE_16,
-			 /**< Device specific , Power Down Mode */
+			 /*< Device specific , Power Down Mode */
 		DRX_POWER_DOWN = 255
-			 /**< Generic         , Power Down Mode */
+			 /*< Generic         , Power Down Mode */
 	};
 
 /*========================================*/
 
-/**
+/*
 * \enum enum drx_module * \brief Software module identification.
 *
 * Used by DRX_CTRL_VERSION.
@@ -1191,93 +1191,93 @@ typedef int(*drx_scan_func_t) (void *scan_context,
 		DRX_MODULE_UNKNOWN
 	};
 
-/**
+/*
 * \enum struct drx_version * \brief Version information of one software module.
 *
 * Used by DRX_CTRL_VERSION.
 */
 	struct drx_version {
 		enum drx_module module_type;
-			       /**< Type identifier of the module */
+			       /*< Type identifier of the module */
 		char *module_name;
-			       /**< Name or description of module */
-		u16 v_major;  /**< Major version number          */
-		u16 v_minor;  /**< Minor version number          */
-		u16 v_patch;  /**< Patch version number          */
-		char *v_string; /**< Version as text string        */
+			       /*< Name or description of module */
+		u16 v_major;  /*< Major version number          */
+		u16 v_minor;  /*< Minor version number          */
+		u16 v_patch;  /*< Patch version number          */
+		char *v_string; /*< Version as text string        */
 	};
 
-/**
+/*
 * \enum struct drx_version_list * \brief List element of NULL terminated, linked list for version information.
 *
 * Used by DRX_CTRL_VERSION.
 */
 struct drx_version_list {
-	struct drx_version *version;/**< Version information */
+	struct drx_version *version;/*< Version information */
 	struct drx_version_list *next;
-			      /**< Next list element   */
+			      /*< Next list element   */
 };
 
 /*========================================*/
 
-/**
+/*
 * \brief Parameters needed to confiugure a UIO.
 *
 * Used by DRX_CTRL_UIO_CFG.
 */
 	struct drxuio_cfg {
 		enum drx_uio uio;
-		       /**< UIO identifier       */
+		       /*< UIO identifier       */
 		enum drxuio_mode mode;
-		       /**< UIO operational mode */
+		       /*< UIO operational mode */
 	};
 
 /*========================================*/
 
-/**
+/*
 * \brief Parameters needed to read from or write to a UIO.
 *
 * Used by DRX_CTRL_UIO_READ and DRX_CTRL_UIO_WRITE.
 */
 	struct drxuio_data {
 		enum drx_uio uio;
-		   /**< UIO identifier              */
+		   /*< UIO identifier              */
 		bool value;
-		   /**< UIO value (true=1, false=0) */
+		   /*< UIO value (true=1, false=0) */
 	};
 
 /*========================================*/
 
-/**
+/*
 * \brief Parameters needed to configure OOB.
 *
 * Used by DRX_CTRL_SET_OOB.
 */
 	struct drxoob {
-		s32 frequency;	   /**< Frequency in kHz      */
+		s32 frequency;	   /*< Frequency in kHz      */
 		enum drxoob_downstream_standard standard;
-						   /**< OOB standard          */
-		bool spectrum_inverted;	   /**< If true, then spectrum
+						   /*< OOB standard          */
+		bool spectrum_inverted;	   /*< If true, then spectrum
 							 is inverted          */
 	};
 
 /*========================================*/
 
-/**
+/*
 * \brief Metrics from OOB.
 *
 * Used by DRX_CTRL_GET_OOB.
 */
 	struct drxoob_status {
-		s32 frequency; /**< Frequency in Khz         */
-		enum drx_lock_status lock;	  /**< Lock status              */
-		u32 mer;		  /**< MER                      */
-		s32 symbol_rate_offset;	  /**< Symbolrate offset in ppm */
+		s32 frequency; /*< Frequency in Khz         */
+		enum drx_lock_status lock;	  /*< Lock status              */
+		u32 mer;		  /*< MER                      */
+		s32 symbol_rate_offset;	  /*< Symbolrate offset in ppm */
 	};
 
 /*========================================*/
 
-/**
+/*
 * \brief Device dependent configuration data.
 *
 * Used by DRX_CTRL_SET_CFG and DRX_CTRL_GET_CFG.
@@ -1285,14 +1285,14 @@ struct drx_version_list {
 */
 	struct drx_cfg {
 		u32 cfg_type;
-			  /**< Function identifier */
+			  /*< Function identifier */
 		void *cfg_data;
-			  /**< Function data */
+			  /*< Function data */
 	};
 
 /*========================================*/
 
-/**
+/*
 * /struct DRXMpegStartWidth_t
 * MStart width [nr MCLK cycles] for serial MPEG output.
 */
@@ -1303,7 +1303,7 @@ struct drx_version_list {
 	};
 
 /* CTRL CFG MPEG output */
-/**
+/*
 * \struct struct drx_cfg_mpeg_output * \brief Configuration parameters for MPEG output control.
 *
 * Used by DRX_CFG_MPEG_OUTPUT, in combination with DRX_CTRL_SET_CFG and
@@ -1311,29 +1311,29 @@ struct drx_version_list {
 */
 
 	struct drx_cfg_mpeg_output {
-		bool enable_mpeg_output;/**< If true, enable MPEG output      */
-		bool insert_rs_byte;	/**< If true, insert RS byte          */
-		bool enable_parallel;	/**< If true, parallel out otherwise
+		bool enable_mpeg_output;/*< If true, enable MPEG output      */
+		bool insert_rs_byte;	/*< If true, insert RS byte          */
+		bool enable_parallel;	/*< If true, parallel out otherwise
 								     serial   */
-		bool invert_data;	/**< If true, invert DATA signals     */
-		bool invert_err;	/**< If true, invert ERR signal       */
-		bool invert_str;	/**< If true, invert STR signals      */
-		bool invert_val;	/**< If true, invert VAL signals      */
-		bool invert_clk;	/**< If true, invert CLK signals      */
-		bool static_clk;	/**< If true, static MPEG clockrate
+		bool invert_data;	/*< If true, invert DATA signals     */
+		bool invert_err;	/*< If true, invert ERR signal       */
+		bool invert_str;	/*< If true, invert STR signals      */
+		bool invert_val;	/*< If true, invert VAL signals      */
+		bool invert_clk;	/*< If true, invert CLK signals      */
+		bool static_clk;	/*< If true, static MPEG clockrate
 					     will be used, otherwise clockrate
 					     will adapt to the bitrate of the
 					     TS                               */
-		u32 bitrate;		/**< Maximum bitrate in b/s in case
+		u32 bitrate;		/*< Maximum bitrate in b/s in case
 					     static clockrate is selected     */
 		enum drxmpeg_str_width width_str;
-					/**< MPEG start width                 */
+					/*< MPEG start width                 */
 	};
 
 
 /*========================================*/
 
-/**
+/*
 * \struct struct drxi2c_data * \brief Data for I2C via 2nd or 3rd or etc I2C port.
 *
 * Used by DRX_CTRL_I2C_READWRITE.
@@ -1341,187 +1341,187 @@ struct drx_version_list {
 *
 */
 	struct drxi2c_data {
-		u16 port_nr;	/**< I2C port number               */
+		u16 port_nr;	/*< I2C port number               */
 		struct i2c_device_addr *w_dev_addr;
-				/**< Write device address          */
-		u16 w_count;	/**< Size of write data in bytes   */
-		u8 *wData;	/**< Pointer to write data         */
+				/*< Write device address          */
+		u16 w_count;	/*< Size of write data in bytes   */
+		u8 *wData;	/*< Pointer to write data         */
 		struct i2c_device_addr *r_dev_addr;
-				/**< Read device address           */
-		u16 r_count;	/**< Size of data to read in bytes */
-		u8 *r_data;	/**< Pointer to read buffer        */
+				/*< Read device address           */
+		u16 r_count;	/*< Size of data to read in bytes */
+		u8 *r_data;	/*< Pointer to read buffer        */
 	};
 
 /*========================================*/
 
-/**
+/*
 * \enum enum drx_aud_standard * \brief Audio standard identifier.
 *
 * Used by DRX_CTRL_SET_AUD.
 */
 	enum drx_aud_standard {
-		DRX_AUD_STANDARD_BTSC,	   /**< set BTSC standard (USA)       */
-		DRX_AUD_STANDARD_A2,	   /**< set A2-Korea FM Stereo        */
-		DRX_AUD_STANDARD_EIAJ,	   /**< set to Japanese FM Stereo     */
-		DRX_AUD_STANDARD_FM_STEREO,/**< set to FM-Stereo Radio        */
-		DRX_AUD_STANDARD_M_MONO,   /**< for 4.5 MHz mono detected     */
-		DRX_AUD_STANDARD_D_K_MONO, /**< for 6.5 MHz mono detected     */
-		DRX_AUD_STANDARD_BG_FM,	   /**< set BG_FM standard            */
-		DRX_AUD_STANDARD_D_K1,	   /**< set D_K1 standard             */
-		DRX_AUD_STANDARD_D_K2,	   /**< set D_K2 standard             */
-		DRX_AUD_STANDARD_D_K3,	   /**< set D_K3 standard             */
+		DRX_AUD_STANDARD_BTSC,	   /*< set BTSC standard (USA)       */
+		DRX_AUD_STANDARD_A2,	   /*< set A2-Korea FM Stereo        */
+		DRX_AUD_STANDARD_EIAJ,	   /*< set to Japanese FM Stereo     */
+		DRX_AUD_STANDARD_FM_STEREO,/*< set to FM-Stereo Radio        */
+		DRX_AUD_STANDARD_M_MONO,   /*< for 4.5 MHz mono detected     */
+		DRX_AUD_STANDARD_D_K_MONO, /*< for 6.5 MHz mono detected     */
+		DRX_AUD_STANDARD_BG_FM,	   /*< set BG_FM standard            */
+		DRX_AUD_STANDARD_D_K1,	   /*< set D_K1 standard             */
+		DRX_AUD_STANDARD_D_K2,	   /*< set D_K2 standard             */
+		DRX_AUD_STANDARD_D_K3,	   /*< set D_K3 standard             */
 		DRX_AUD_STANDARD_BG_NICAM_FM,
-					   /**< set BG_NICAM_FM standard      */
+					   /*< set BG_NICAM_FM standard      */
 		DRX_AUD_STANDARD_L_NICAM_AM,
-					   /**< set L_NICAM_AM standard       */
+					   /*< set L_NICAM_AM standard       */
 		DRX_AUD_STANDARD_I_NICAM_FM,
-					   /**< set I_NICAM_FM standard       */
+					   /*< set I_NICAM_FM standard       */
 		DRX_AUD_STANDARD_D_K_NICAM_FM,
-					   /**< set D_K_NICAM_FM standard     */
-		DRX_AUD_STANDARD_NOT_READY,/**< used to detect audio standard */
+					   /*< set D_K_NICAM_FM standard     */
+		DRX_AUD_STANDARD_NOT_READY,/*< used to detect audio standard */
 		DRX_AUD_STANDARD_AUTO = DRX_AUTO,
-					   /**< Automatic Standard Detection  */
+					   /*< Automatic Standard Detection  */
 		DRX_AUD_STANDARD_UNKNOWN = DRX_UNKNOWN
-					   /**< used as auto and for readback */
+					   /*< used as auto and for readback */
 	};
 
 /* CTRL_AUD_GET_STATUS    - struct drx_aud_status */
-/**
+/*
 * \enum enum drx_aud_nicam_status * \brief Status of NICAM carrier.
 */
 	enum drx_aud_nicam_status {
 		DRX_AUD_NICAM_DETECTED = 0,
-					  /**< NICAM carrier detected         */
+					  /*< NICAM carrier detected         */
 		DRX_AUD_NICAM_NOT_DETECTED,
-					  /**< NICAM carrier not detected     */
-		DRX_AUD_NICAM_BAD	  /**< NICAM carrier bad quality      */
+					  /*< NICAM carrier not detected     */
+		DRX_AUD_NICAM_BAD	  /*< NICAM carrier bad quality      */
 	};
 
-/**
+/*
 * \struct struct drx_aud_status * \brief Audio status characteristics.
 */
 	struct drx_aud_status {
-		bool stereo;		  /**< stereo detection               */
-		bool carrier_a;	  /**< carrier A detected             */
-		bool carrier_b;	  /**< carrier B detected             */
-		bool sap;		  /**< sap / bilingual detection      */
-		bool rds;		  /**< RDS data array present         */
+		bool stereo;		  /*< stereo detection               */
+		bool carrier_a;	  /*< carrier A detected             */
+		bool carrier_b;	  /*< carrier B detected             */
+		bool sap;		  /*< sap / bilingual detection      */
+		bool rds;		  /*< RDS data array present         */
 		enum drx_aud_nicam_status nicam_status;
-					  /**< status of NICAM carrier        */
-		s8 fm_ident;		  /**< FM Identification value        */
+					  /*< status of NICAM carrier        */
+		s8 fm_ident;		  /*< FM Identification value        */
 	};
 
 /* CTRL_AUD_READ_RDS       - DRXRDSdata_t */
 
-/**
+/*
 * \struct DRXRDSdata_t
 * \brief Raw RDS data array.
 */
 	struct drx_cfg_aud_rds {
-		bool valid;		  /**< RDS data validation            */
-		u16 data[18];		  /**< data from one RDS data array   */
+		bool valid;		  /*< RDS data validation            */
+		u16 data[18];		  /*< data from one RDS data array   */
 	};
 
 /* DRX_CFG_AUD_VOLUME      - struct drx_cfg_aud_volume - set/get */
-/**
+/*
 * \enum DRXAudAVCDecayTime_t
 * \brief Automatic volume control configuration.
 */
 	enum drx_aud_avc_mode {
-		DRX_AUD_AVC_OFF,	  /**< Automatic volume control off   */
-		DRX_AUD_AVC_DECAYTIME_8S, /**< level volume in  8 seconds     */
-		DRX_AUD_AVC_DECAYTIME_4S, /**< level volume in  4 seconds     */
-		DRX_AUD_AVC_DECAYTIME_2S, /**< level volume in  2 seconds     */
-		DRX_AUD_AVC_DECAYTIME_20MS/**< level volume in 20 millisec    */
+		DRX_AUD_AVC_OFF,	  /*< Automatic volume control off   */
+		DRX_AUD_AVC_DECAYTIME_8S, /*< level volume in  8 seconds     */
+		DRX_AUD_AVC_DECAYTIME_4S, /*< level volume in  4 seconds     */
+		DRX_AUD_AVC_DECAYTIME_2S, /*< level volume in  2 seconds     */
+		DRX_AUD_AVC_DECAYTIME_20MS/*< level volume in 20 millisec    */
 	};
 
-/**
+/*
 * /enum DRXAudMaxAVCGain_t
 * /brief Automatic volume control max gain in audio baseband.
 */
 	enum drx_aud_avc_max_gain {
-		DRX_AUD_AVC_MAX_GAIN_0DB, /**< maximum AVC gain  0 dB         */
-		DRX_AUD_AVC_MAX_GAIN_6DB, /**< maximum AVC gain  6 dB         */
-		DRX_AUD_AVC_MAX_GAIN_12DB /**< maximum AVC gain 12 dB         */
+		DRX_AUD_AVC_MAX_GAIN_0DB, /*< maximum AVC gain  0 dB         */
+		DRX_AUD_AVC_MAX_GAIN_6DB, /*< maximum AVC gain  6 dB         */
+		DRX_AUD_AVC_MAX_GAIN_12DB /*< maximum AVC gain 12 dB         */
 	};
 
-/**
+/*
 * /enum DRXAudMaxAVCAtten_t
 * /brief Automatic volume control max attenuation in audio baseband.
 */
 	enum drx_aud_avc_max_atten {
 		DRX_AUD_AVC_MAX_ATTEN_12DB,
-					  /**< maximum AVC attenuation 12 dB  */
+					  /*< maximum AVC attenuation 12 dB  */
 		DRX_AUD_AVC_MAX_ATTEN_18DB,
-					  /**< maximum AVC attenuation 18 dB  */
-		DRX_AUD_AVC_MAX_ATTEN_24DB/**< maximum AVC attenuation 24 dB  */
+					  /*< maximum AVC attenuation 18 dB  */
+		DRX_AUD_AVC_MAX_ATTEN_24DB/*< maximum AVC attenuation 24 dB  */
 	};
-/**
+/*
 * \struct struct drx_cfg_aud_volume * \brief Audio volume configuration.
 */
 	struct drx_cfg_aud_volume {
-		bool mute;		  /**< mute overrides volume setting  */
-		s16 volume;		  /**< volume, range -114 to 12 dB    */
-		enum drx_aud_avc_mode avc_mode;  /**< AVC auto volume control mode   */
-		u16 avc_ref_level;	  /**< AVC reference level            */
+		bool mute;		  /*< mute overrides volume setting  */
+		s16 volume;		  /*< volume, range -114 to 12 dB    */
+		enum drx_aud_avc_mode avc_mode;  /*< AVC auto volume control mode   */
+		u16 avc_ref_level;	  /*< AVC reference level            */
 		enum drx_aud_avc_max_gain avc_max_gain;
-					  /**< AVC max gain selection         */
+					  /*< AVC max gain selection         */
 		enum drx_aud_avc_max_atten avc_max_atten;
-					  /**< AVC max attenuation selection  */
-		s16 strength_left;	  /**< quasi-peak, left speaker       */
-		s16 strength_right;	  /**< quasi-peak, right speaker      */
+					  /*< AVC max attenuation selection  */
+		s16 strength_left;	  /*< quasi-peak, left speaker       */
+		s16 strength_right;	  /*< quasi-peak, right speaker      */
 	};
 
 /* DRX_CFG_I2S_OUTPUT      - struct drx_cfg_i2s_output - set/get */
-/**
+/*
 * \enum enum drxi2s_mode * \brief I2S output mode.
 */
 	enum drxi2s_mode {
-		DRX_I2S_MODE_MASTER,	  /**< I2S is in master mode          */
-		DRX_I2S_MODE_SLAVE	  /**< I2S is in slave mode           */
+		DRX_I2S_MODE_MASTER,	  /*< I2S is in master mode          */
+		DRX_I2S_MODE_SLAVE	  /*< I2S is in slave mode           */
 	};
 
-/**
+/*
 * \enum enum drxi2s_word_length * \brief Width of I2S data.
 */
 	enum drxi2s_word_length {
-		DRX_I2S_WORDLENGTH_32 = 0,/**< I2S data is 32 bit wide        */
-		DRX_I2S_WORDLENGTH_16 = 1 /**< I2S data is 16 bit wide        */
+		DRX_I2S_WORDLENGTH_32 = 0,/*< I2S data is 32 bit wide        */
+		DRX_I2S_WORDLENGTH_16 = 1 /*< I2S data is 16 bit wide        */
 	};
 
-/**
+/*
 * \enum enum drxi2s_format * \brief Data wordstrobe alignment for I2S.
 */
 	enum drxi2s_format {
 		DRX_I2S_FORMAT_WS_WITH_DATA,
-				    /**< I2S data and wordstrobe are aligned  */
+				    /*< I2S data and wordstrobe are aligned  */
 		DRX_I2S_FORMAT_WS_ADVANCED
-				    /**< I2S data one cycle after wordstrobe  */
+				    /*< I2S data one cycle after wordstrobe  */
 	};
 
-/**
+/*
 * \enum enum drxi2s_polarity * \brief Polarity of I2S data.
 */
 	enum drxi2s_polarity {
-		DRX_I2S_POLARITY_RIGHT,/**< wordstrobe - right high, left low */
-		DRX_I2S_POLARITY_LEFT  /**< wordstrobe - right low, left high */
+		DRX_I2S_POLARITY_RIGHT,/*< wordstrobe - right high, left low */
+		DRX_I2S_POLARITY_LEFT  /*< wordstrobe - right low, left high */
 	};
 
-/**
+/*
 * \struct struct drx_cfg_i2s_output * \brief I2S output configuration.
 */
 	struct drx_cfg_i2s_output {
-		bool output_enable;	  /**< I2S output enable              */
-		u32 frequency;	  /**< range from 8000-48000 Hz       */
-		enum drxi2s_mode mode;	  /**< I2S mode, master or slave      */
+		bool output_enable;	  /*< I2S output enable              */
+		u32 frequency;	  /*< range from 8000-48000 Hz       */
+		enum drxi2s_mode mode;	  /*< I2S mode, master or slave      */
 		enum drxi2s_word_length word_length;
-					  /**< I2S wordlength, 16 or 32 bits  */
-		enum drxi2s_polarity polarity;/**< I2S wordstrobe polarity        */
-		enum drxi2s_format format;	  /**< I2S wordstrobe delay to data   */
+					  /*< I2S wordlength, 16 or 32 bits  */
+		enum drxi2s_polarity polarity;/*< I2S wordstrobe polarity        */
+		enum drxi2s_format format;	  /*< I2S wordstrobe delay to data   */
 	};
 
 /* ------------------------------expert interface-----------------------------*/
-/**
+/*
 * /enum enum drx_aud_fm_deemphasis * setting for FM-Deemphasis in audio demodulator.
 *
 */
@@ -1531,7 +1531,7 @@ struct drx_version_list {
 		DRX_AUD_FM_DEEMPH_OFF
 	};
 
-/**
+/*
 * /enum DRXAudDeviation_t
 * setting for deviation mode in audio demodulator.
 *
@@ -1541,7 +1541,7 @@ struct drx_version_list {
 		DRX_AUD_DEVIATION_HIGH
 	};
 
-/**
+/*
 * /enum enum drx_no_carrier_option * setting for carrier, mute/noise.
 *
 */
@@ -1550,7 +1550,7 @@ struct drx_version_list {
 		DRX_NO_CARRIER_NOISE
 	};
 
-/**
+/*
 * \enum DRXAudAutoSound_t
 * \brief Automatic Sound
 */
@@ -1560,7 +1560,7 @@ struct drx_version_list {
 		DRX_AUD_AUTO_SOUND_SELECT_ON_CHANGE_OFF
 	};
 
-/**
+/*
 * \enum DRXAudASSThres_t
 * \brief Automatic Sound Select Thresholds
 */
@@ -1570,7 +1570,7 @@ struct drx_version_list {
 		u16 nicam;	/* Nicam Threshold for ASS configuration */
 	};
 
-/**
+/*
 * \struct struct drx_aud_carrier * \brief Carrier detection related parameters
 */
 	struct drx_aud_carrier {
@@ -1580,7 +1580,7 @@ struct drx_version_list {
 		s32 dco;	/* frequency adjustment (A) */
 	};
 
-/**
+/*
 * \struct struct drx_cfg_aud_carriers * \brief combining carrier A & B to one struct
 */
 	struct drx_cfg_aud_carriers {
@@ -1588,7 +1588,7 @@ struct drx_version_list {
 		struct drx_aud_carrier b;
 	};
 
-/**
+/*
 * /enum enum drx_aud_i2s_src * Selection of audio source
 */
 	enum drx_aud_i2s_src {
@@ -1597,19 +1597,19 @@ struct drx_version_list {
 		DRX_AUD_SRC_STEREO_OR_A,
 		DRX_AUD_SRC_STEREO_OR_B};
 
-/**
+/*
 * \enum enum drx_aud_i2s_matrix * \brief Used for selecting I2S output.
 */
 	enum drx_aud_i2s_matrix {
 		DRX_AUD_I2S_MATRIX_A_MONO,
-					/**< A sound only, stereo or mono     */
+					/*< A sound only, stereo or mono     */
 		DRX_AUD_I2S_MATRIX_B_MONO,
-					/**< B sound only, stereo or mono     */
+					/*< B sound only, stereo or mono     */
 		DRX_AUD_I2S_MATRIX_STEREO,
-					/**< A+B sound, transparant           */
-		DRX_AUD_I2S_MATRIX_MONO	/**< A+B mixed to mono sum, (L+R)/2   */};
+					/*< A+B sound, transparant           */
+		DRX_AUD_I2S_MATRIX_MONO	/*< A+B mixed to mono sum, (L+R)/2   */};
 
-/**
+/*
 * /enum enum drx_aud_fm_matrix * setting for FM-Matrix in audio demodulator.
 *
 */
@@ -1620,7 +1620,7 @@ struct drx_version_list {
 		DRX_AUD_FM_MATRIX_SOUND_A,
 		DRX_AUD_FM_MATRIX_SOUND_B};
 
-/**
+/*
 * \struct DRXAudMatrices_t
 * \brief Mixer settings
 */
@@ -1630,22 +1630,22 @@ struct drx_cfg_aud_mixer {
 	enum drx_aud_fm_matrix matrix_fm;
 };
 
-/**
+/*
 * \enum DRXI2SVidSync_t
 * \brief Audio/video synchronization, interacts with I2S mode.
 * AUTO_1 and AUTO_2 are for automatic video standard detection with preference
 * for NTSC or Monochrome, because the frequencies are too close (59.94 & 60 Hz)
 */
 	enum drx_cfg_aud_av_sync {
-		DRX_AUD_AVSYNC_OFF,/**< audio/video synchronization is off   */
+		DRX_AUD_AVSYNC_OFF,/*< audio/video synchronization is off   */
 		DRX_AUD_AVSYNC_NTSC,
-				   /**< it is an NTSC system                 */
+				   /*< it is an NTSC system                 */
 		DRX_AUD_AVSYNC_MONOCHROME,
-				   /**< it is a MONOCHROME system            */
+				   /*< it is a MONOCHROME system            */
 		DRX_AUD_AVSYNC_PAL_SECAM
-				   /**< it is a PAL/SECAM system             */};
+				   /*< it is a PAL/SECAM system             */};
 
-/**
+/*
 * \struct struct drx_cfg_aud_prescale * \brief Prescalers
 */
 struct drx_cfg_aud_prescale {
@@ -1653,7 +1653,7 @@ struct drx_cfg_aud_prescale {
 	s16 nicam_gain;
 };
 
-/**
+/*
 * \struct struct drx_aud_beep * \brief Beep
 */
 struct drx_aud_beep {
@@ -1662,14 +1662,14 @@ struct drx_aud_beep {
 	bool mute;
 };
 
-/**
+/*
 * \enum enum drx_aud_btsc_detect * \brief BTSC detetcion mode
 */
 	enum drx_aud_btsc_detect {
 		DRX_BTSC_STEREO,
 		DRX_BTSC_MONO_AND_SAP};
 
-/**
+/*
 * \struct struct drx_aud_data * \brief Audio data structure
 */
 struct drx_aud_data {
@@ -1692,7 +1692,7 @@ struct drx_aud_data {
 	bool rds_data_present;
 };
 
-/**
+/*
 * \enum enum drx_qam_lock_range * \brief QAM lock range mode
 */
 	enum drx_qam_lock_range {
@@ -1782,7 +1782,7 @@ struct drx_aud_data {
 							     u32 wdata,	/* data to write               */
 							     u32 *rdata);	/* data to read                */
 
-/**
+/*
 * \struct struct drx_access_func * \brief Interface to an access protocol.
 */
 struct drx_access_func {
@@ -1811,85 +1811,85 @@ struct drx_reg_dump {
 /*============================================================================*/
 /*============================================================================*/
 
-/**
+/*
 * \struct struct drx_common_attr * \brief Set of common attributes, shared by all DRX devices.
 */
 	struct drx_common_attr {
 		/* Microcode (firmware) attributes */
-		char *microcode_file;   /**<  microcode filename           */
+		char *microcode_file;   /*<  microcode filename           */
 		bool verify_microcode;
-				   /**< Use microcode verify or not.          */
+				   /*< Use microcode verify or not.          */
 		struct drx_mc_version_rec mcversion;
-				   /**< Version record of microcode from file */
+				   /*< Version record of microcode from file */
 
 		/* Clocks and tuner attributes */
 		s32 intermediate_freq;
-				     /**< IF,if tuner instance not used. (kHz)*/
+				     /*< IF,if tuner instance not used. (kHz)*/
 		s32 sys_clock_freq;
-				     /**< Systemclock frequency.  (kHz)       */
+				     /*< Systemclock frequency.  (kHz)       */
 		s32 osc_clock_freq;
-				     /**< Oscillator clock frequency.  (kHz)  */
+				     /*< Oscillator clock frequency.  (kHz)  */
 		s16 osc_clock_deviation;
-				     /**< Oscillator clock deviation.  (ppm)  */
+				     /*< Oscillator clock deviation.  (ppm)  */
 		bool mirror_freq_spect;
-				     /**< Mirror IF frequency spectrum or not.*/
+				     /*< Mirror IF frequency spectrum or not.*/
 
 		/* Initial MPEG output attributes */
 		struct drx_cfg_mpeg_output mpeg_cfg;
-				     /**< MPEG configuration                  */
+				     /*< MPEG configuration                  */
 
-		bool is_opened;     /**< if true instance is already opened. */
+		bool is_opened;     /*< if true instance is already opened. */
 
 		/* Channel scan */
 		struct drx_scan_param *scan_param;
-				      /**< scan parameters                    */
+				      /*< scan parameters                    */
 		u16 scan_freq_plan_index;
-				      /**< next index in freq plan            */
+				      /*< next index in freq plan            */
 		s32 scan_next_frequency;
-				      /**< next freq to scan                  */
-		bool scan_ready;     /**< scan ready flag                    */
-		u32 scan_max_channels;/**< number of channels in freqplan     */
+				      /*< next freq to scan                  */
+		bool scan_ready;     /*< scan ready flag                    */
+		u32 scan_max_channels;/*< number of channels in freqplan     */
 		u32 scan_channels_scanned;
-					/**< number of channels scanned       */
+					/*< number of channels scanned       */
 		/* Channel scan - inner loop: demod related */
 		drx_scan_func_t scan_function;
-				      /**< function to check channel          */
+				      /*< function to check channel          */
 		/* Channel scan - inner loop: SYSObj related */
-		void *scan_context;    /**< Context Pointer of SYSObj          */
+		void *scan_context;    /*< Context Pointer of SYSObj          */
 		/* Channel scan - parameters for default DTV scan function in core driver  */
 		u16 scan_demod_lock_timeout;
-					 /**< millisecs to wait for lock      */
+					 /*< millisecs to wait for lock      */
 		enum drx_lock_status scan_desired_lock;
-				      /**< lock requirement for channel found */
+				      /*< lock requirement for channel found */
 		/* scan_active can be used by SetChannel to decide how to program the tuner,
 		   fast or slow (but stable). Usually fast during scan. */
-		bool scan_active;    /**< true when scan routines are active */
+		bool scan_active;    /*< true when scan routines are active */
 
 		/* Power management */
 		enum drx_power_mode current_power_mode;
-				      /**< current power management mode      */
+				      /*< current power management mode      */
 
 		/* Tuner */
-		u8 tuner_port_nr;     /**< nr of I2C port to wich tuner is    */
+		u8 tuner_port_nr;     /*< nr of I2C port to wich tuner is    */
 		s32 tuner_min_freq_rf;
-				      /**< minimum RF input frequency, in kHz */
+				      /*< minimum RF input frequency, in kHz */
 		s32 tuner_max_freq_rf;
-				      /**< maximum RF input frequency, in kHz */
-		bool tuner_rf_agc_pol; /**< if true invert RF AGC polarity     */
-		bool tuner_if_agc_pol; /**< if true invert IF AGC polarity     */
-		bool tuner_slow_mode; /**< if true invert IF AGC polarity     */
+				      /*< maximum RF input frequency, in kHz */
+		bool tuner_rf_agc_pol; /*< if true invert RF AGC polarity     */
+		bool tuner_if_agc_pol; /*< if true invert IF AGC polarity     */
+		bool tuner_slow_mode; /*< if true invert IF AGC polarity     */
 
 		struct drx_channel current_channel;
-				      /**< current channel parameters         */
+				      /*< current channel parameters         */
 		enum drx_standard current_standard;
-				      /**< current standard selection         */
+				      /*< current standard selection         */
 		enum drx_standard prev_standard;
-				      /**< previous standard selection        */
+				      /*< previous standard selection        */
 		enum drx_standard di_cache_standard;
-				      /**< standard in DI cache if available  */
-		bool use_bootloader; /**< use bootloader in open             */
-		u32 capabilities;   /**< capabilities flags                 */
-		u32 product_id;      /**< product ID inc. metal fix number   */};
+				      /*< standard in DI cache if available  */
+		bool use_bootloader; /*< use bootloader in open             */
+		u32 capabilities;   /*< capabilities flags                 */
+		u32 product_id;      /*< product ID inc. metal fix number   */};
 
 /*
 * Generic functions for DRX devices.
@@ -1897,16 +1897,16 @@ struct drx_reg_dump {
 
 struct drx_demod_instance;
 
-/**
+/*
 * \struct struct drx_demod_instance * \brief Top structure of demodulator instance.
 */
 struct drx_demod_instance {
-				/**< data access protocol functions       */
+				/*< data access protocol functions       */
 	struct i2c_device_addr *my_i2c_dev_addr;
-				/**< i2c address and device identifier    */
+				/*< i2c address and device identifier    */
 	struct drx_common_attr *my_common_attr;
-				/**< common DRX attributes                */
-	void *my_ext_attr;    /**< device specific attributes           */
+				/*< common DRX attributes                */
+	void *my_ext_attr;    /*< device specific attributes           */
 	/* generic demodulator data */
 
 	struct i2c_adapter	*i2c;
@@ -2195,7 +2195,7 @@ Conversion from enum values to human readable form.
 Access macros
 -------------------------------------------------------------------------*/
 
-/**
+/*
 * \brief Create a compilable reference to the microcode attribute
 * \param d pointer to demod instance
 *
@@ -2229,7 +2229,7 @@ Access macros
 #define DRX_ATTR_I2CDEVID(d)        ((d)->my_i2c_dev_addr->i2c_dev_id)
 #define DRX_ISMCVERTYPE(x) ((x) == AUX_VER_RECORD)
 
-/**************************/
+/*************************/
 
 /* Macros with device-specific handling are converted to CFG functions */
 
@@ -2285,7 +2285,7 @@ Access macros
 #define DRX_GET_QAM_LOCKRANGE(d, x) DRX_ACCESSMACRO_GET((d), (x), \
 	 DRX_XS_CFG_QAM_LOCKRANGE, enum drx_qam_lock_range, DRX_UNKNOWN)
 
-/**
+/*
 * \brief Macro to check if std is an ATV standard
 * \retval true std is an ATV standard
 * \retval false std is an ATV standard
@@ -2298,7 +2298,7 @@ Access macros
 			      ((std) == DRX_STANDARD_NTSC) || \
 			      ((std) == DRX_STANDARD_FM))
 
-/**
+/*
 * \brief Macro to check if std is an QAM standard
 * \retval true std is an QAM standards
 * \retval false std is an QAM standards
@@ -2308,14 +2308,14 @@ Access macros
 			      ((std) == DRX_STANDARD_ITU_C) || \
 			      ((std) == DRX_STANDARD_ITU_D))
 
-/**
+/*
 * \brief Macro to check if std is VSB standard
 * \retval true std is VSB standard
 * \retval false std is not VSB standard
 */
 #define DRX_ISVSBSTD(std) ((std) == DRX_STANDARD_8VSB)
 
-/**
+/*
 * \brief Macro to check if std is DVBT standard
 * \retval true std is DVBT standard
 * \retval false std is not DVBT standard
diff --git a/drivers/media/dvb-frontends/drx39xyj/drxj.h b/drivers/media/dvb-frontends/drx39xyj/drxj.h
index 6c5b8f78f9f6..d3ee1c23bb2f 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drxj.h
+++ b/drivers/media/dvb-frontends/drx39xyj/drxj.h
@@ -69,15 +69,15 @@ TYPEDEFS
 
 	struct drxjscu_cmd {
 		u16 command;
-			/**< Command number */
+			/*< Command number */
 		u16 parameter_len;
-			/**< Data length in byte */
+			/*< Data length in byte */
 		u16 result_len;
-			/**< result length in byte */
+			/*< result length in byte */
 		u16 *parameter;
-			/**< General purpous param */
+			/*< General purpous param */
 		u16 *result;
-			/**< General purpous param */};
+			/*< General purpous param */};
 
 /*============================================================================*/
 /*============================================================================*/
@@ -130,7 +130,7 @@ TYPEDEFS
 
 		DRXJ_CFG_MAX	/* dummy, never to be used */};
 
-/**
+/*
 * /struct enum drxj_cfg_smart_ant_io * smart antenna i/o.
 */
 enum drxj_cfg_smart_ant_io {
@@ -138,7 +138,7 @@ enum drxj_cfg_smart_ant_io {
 	DRXJ_SMT_ANT_INPUT
 };
 
-/**
+/*
 * /struct struct drxj_cfg_smart_ant * Set smart antenna.
 */
 	struct drxj_cfg_smart_ant {
@@ -146,7 +146,7 @@ enum drxj_cfg_smart_ant_io {
 		u16 ctrl_data;
 	};
 
-/**
+/*
 * /struct DRXJAGCSTATUS_t
 * AGC status information from the DRXJ-IQM-AF.
 */
@@ -158,7 +158,7 @@ struct drxj_agc_status {
 
 /* DRXJ_CFG_AGC_RF, DRXJ_CFG_AGC_IF */
 
-/**
+/*
 * /struct enum drxj_agc_ctrl_mode * Available AGCs modes in the DRXJ.
 */
 	enum drxj_agc_ctrl_mode {
@@ -166,7 +166,7 @@ struct drxj_agc_status {
 		DRX_AGC_CTRL_USER,
 		DRX_AGC_CTRL_OFF};
 
-/**
+/*
 * /struct struct drxj_cfg_agc * Generic interface for all AGCs present on the DRXJ.
 */
 	struct drxj_cfg_agc {
@@ -182,7 +182,7 @@ struct drxj_agc_status {
 
 /* DRXJ_CFG_PRE_SAW */
 
-/**
+/*
 * /struct struct drxj_cfg_pre_saw * Interface to configure pre SAW sense.
 */
 	struct drxj_cfg_pre_saw {
@@ -192,14 +192,14 @@ struct drxj_agc_status {
 
 /* DRXJ_CFG_AFE_GAIN */
 
-/**
+/*
 * /struct struct drxj_cfg_afe_gain * Interface to configure gain of AFE (LNA + PGA).
 */
 	struct drxj_cfg_afe_gain {
 		enum drx_standard standard;	/* standard to which these settings apply */
 		u16 gain;	/* gain in 0.1 dB steps, DRXJ range 140 .. 335 */};
 
-/**
+/*
 * /struct drxjrs_errors
 * Available failure information in DRXJ_FEC_RS.
 *
@@ -208,25 +208,25 @@ struct drxj_agc_status {
 */
 	struct drxjrs_errors {
 		u16 nr_bit_errors;
-				/**< no of pre RS bit errors          */
+				/*< no of pre RS bit errors          */
 		u16 nr_symbol_errors;
-				/**< no of pre RS symbol errors       */
+				/*< no of pre RS symbol errors       */
 		u16 nr_packet_errors;
-				/**< no of pre RS packet errors       */
+				/*< no of pre RS packet errors       */
 		u16 nr_failures;
-				/**< no of post RS failures to decode */
+				/*< no of post RS failures to decode */
 		u16 nr_snc_par_fail_count;
-				/**< no of post RS bit erros          */
+				/*< no of post RS bit erros          */
 	};
 
-/**
+/*
 * /struct struct drxj_cfg_vsb_misc * symbol error rate
 */
 	struct drxj_cfg_vsb_misc {
 		u32 symb_error;
-			      /**< symbol error rate sps */};
+			      /*< symbol error rate sps */};
 
-/**
+/*
 * /enum enum drxj_mpeg_output_clock_rate * Mpeg output clock rate.
 *
 */
@@ -234,7 +234,7 @@ struct drxj_agc_status {
 		DRXJ_MPEG_START_WIDTH_1CLKCYC,
 		DRXJ_MPEG_START_WIDTH_8CLKCYC};
 
-/**
+/*
 * /enum enum drxj_mpeg_output_clock_rate * Mpeg output clock rate.
 *
 */
@@ -247,20 +247,20 @@ struct drxj_agc_status {
 		DRXJ_MPEGOUTPUT_CLOCK_RATE_25313K,
 		DRXJ_MPEGOUTPUT_CLOCK_RATE_21696K};
 
-/**
+/*
 * /struct DRXJCfgMisc_t
 * Change TEI bit of MPEG output
 * reverse MPEG output bit order
 * set MPEG output clock rate
 */
 	struct drxj_cfg_mpeg_output_misc {
-		bool disable_tei_handling;	      /**< if true pass (not change) TEI bit */
-		bool bit_reverse_mpeg_outout;	      /**< if true, parallel: msb on MD0; serial: lsb out first */
+		bool disable_tei_handling;	      /*< if true pass (not change) TEI bit */
+		bool bit_reverse_mpeg_outout;	      /*< if true, parallel: msb on MD0; serial: lsb out first */
 		enum drxj_mpeg_output_clock_rate mpeg_output_clock_rate;
-						      /**< set MPEG output clock rate that overwirtes the derived one from symbol rate */
-		enum drxj_mpeg_start_width mpeg_start_width;  /**< set MPEG output start width */};
+						      /*< set MPEG output clock rate that overwirtes the derived one from symbol rate */
+		enum drxj_mpeg_start_width mpeg_start_width;  /*< set MPEG output start width */};
 
-/**
+/*
 * /enum enum drxj_xtal_freq * Supported external crystal reference frequency.
 */
 	enum drxj_xtal_freq {
@@ -269,21 +269,21 @@ struct drxj_agc_status {
 		DRXJ_XTAL_FREQ_20P25MHZ,
 		DRXJ_XTAL_FREQ_4MHZ};
 
-/**
+/*
 * /enum enum drxj_xtal_freq * Supported external crystal reference frequency.
 */
 	enum drxji2c_speed {
 		DRXJ_I2C_SPEED_400KBPS,
 		DRXJ_I2C_SPEED_100KBPS};
 
-/**
+/*
 * /struct struct drxj_cfg_hw_cfg * Get hw configuration, such as crystal reference frequency, I2C speed, etc...
 */
 	struct drxj_cfg_hw_cfg {
 		enum drxj_xtal_freq xtal_freq;
-				   /**< crystal reference frequency */
+				   /*< crystal reference frequency */
 		enum drxji2c_speed i2c_speed;
-				   /**< 100 or 400 kbps */};
+				   /*< 100 or 400 kbps */};
 
 /*
  *  DRXJ_CFG_ATV_MISC
@@ -352,7 +352,7 @@ struct drxj_cfg_oob_misc {
  *  DRXJ_CFG_ATV_OUTPUT
  */
 
-/**
+/*
 * /enum DRXJAttenuation_t
 * Attenuation setting for SIF AGC.
 *
@@ -363,7 +363,7 @@ struct drxj_cfg_oob_misc {
 		DRXJ_SIF_ATTENUATION_6DB,
 		DRXJ_SIF_ATTENUATION_9DB};
 
-/**
+/*
 * /struct struct drxj_cfg_atv_output * SIF attenuation setting.
 *
 */
@@ -398,7 +398,7 @@ struct drxj_cfg_atv_output {
 /*============================================================================*/
 
 /*========================================*/
-/**
+/*
 * /struct struct drxj_data * DRXJ specific attributes.
 *
 * Global data container for DRXJ specific data.
@@ -406,93 +406,93 @@ struct drxj_cfg_atv_output {
 */
 	struct drxj_data {
 		/* device capabilties (determined during drx_open()) */
-		bool has_lna;		  /**< true if LNA (aka PGA) present */
-		bool has_oob;		  /**< true if OOB supported */
-		bool has_ntsc;		  /**< true if NTSC supported */
-		bool has_btsc;		  /**< true if BTSC supported */
-		bool has_smatx;	  /**< true if mat_tx is available */
-		bool has_smarx;	  /**< true if mat_rx is available */
-		bool has_gpio;		  /**< true if GPIO is available */
-		bool has_irqn;		  /**< true if IRQN is available */
+		bool has_lna;		  /*< true if LNA (aka PGA) present */
+		bool has_oob;		  /*< true if OOB supported */
+		bool has_ntsc;		  /*< true if NTSC supported */
+		bool has_btsc;		  /*< true if BTSC supported */
+		bool has_smatx;	  /*< true if mat_tx is available */
+		bool has_smarx;	  /*< true if mat_rx is available */
+		bool has_gpio;		  /*< true if GPIO is available */
+		bool has_irqn;		  /*< true if IRQN is available */
 		/* A1/A2/A... */
-		u8 mfx;		  /**< metal fix */
+		u8 mfx;		  /*< metal fix */
 
 		/* tuner settings */
-		bool mirror_freq_spect_oob;/**< tuner inversion (true = tuner mirrors the signal */
+		bool mirror_freq_spect_oob;/*< tuner inversion (true = tuner mirrors the signal */
 
 		/* standard/channel settings */
-		enum drx_standard standard;	  /**< current standard information                     */
+		enum drx_standard standard;	  /*< current standard information                     */
 		enum drx_modulation constellation;
-					  /**< current constellation                            */
-		s32 frequency; /**< center signal frequency in KHz                   */
+					  /*< current constellation                            */
+		s32 frequency; /*< center signal frequency in KHz                   */
 		enum drx_bandwidth curr_bandwidth;
-					  /**< current channel bandwidth                        */
-		enum drx_mirror mirror;	  /**< current channel mirror                           */
+					  /*< current channel bandwidth                        */
+		enum drx_mirror mirror;	  /*< current channel mirror                           */
 
 		/* signal quality information */
-		u32 fec_bits_desired;	  /**< BER accounting period                            */
-		u16 fec_vd_plen;	  /**< no of trellis symbols: VD SER measurement period */
-		u16 qam_vd_prescale;	  /**< Viterbi Measurement Prescale                     */
-		u16 qam_vd_period;	  /**< Viterbi Measurement period                       */
-		u16 fec_rs_plen;	  /**< defines RS BER measurement period                */
-		u16 fec_rs_prescale;	  /**< ReedSolomon Measurement Prescale                 */
-		u16 fec_rs_period;	  /**< ReedSolomon Measurement period                   */
-		bool reset_pkt_err_acc;	  /**< Set a flag to reset accumulated packet error     */
-		u16 pkt_err_acc_start;	  /**< Set a flag to reset accumulated packet error     */
+		u32 fec_bits_desired;	  /*< BER accounting period                            */
+		u16 fec_vd_plen;	  /*< no of trellis symbols: VD SER measurement period */
+		u16 qam_vd_prescale;	  /*< Viterbi Measurement Prescale                     */
+		u16 qam_vd_period;	  /*< Viterbi Measurement period                       */
+		u16 fec_rs_plen;	  /*< defines RS BER measurement period                */
+		u16 fec_rs_prescale;	  /*< ReedSolomon Measurement Prescale                 */
+		u16 fec_rs_period;	  /*< ReedSolomon Measurement period                   */
+		bool reset_pkt_err_acc;	  /*< Set a flag to reset accumulated packet error     */
+		u16 pkt_err_acc_start;	  /*< Set a flag to reset accumulated packet error     */
 
 		/* HI configuration */
-		u16 hi_cfg_timing_div;	  /**< HI Configure() parameter 2                       */
-		u16 hi_cfg_bridge_delay;	  /**< HI Configure() parameter 3                       */
-		u16 hi_cfg_wake_up_key;	  /**< HI Configure() parameter 4                       */
-		u16 hi_cfg_ctrl;	  /**< HI Configure() parameter 5                       */
-		u16 hi_cfg_transmit;	  /**< HI Configure() parameter 6                       */
+		u16 hi_cfg_timing_div;	  /*< HI Configure() parameter 2                       */
+		u16 hi_cfg_bridge_delay;	  /*< HI Configure() parameter 3                       */
+		u16 hi_cfg_wake_up_key;	  /*< HI Configure() parameter 4                       */
+		u16 hi_cfg_ctrl;	  /*< HI Configure() parameter 5                       */
+		u16 hi_cfg_transmit;	  /*< HI Configure() parameter 6                       */
 
 		/* UIO configuration */
-		enum drxuio_mode uio_sma_rx_mode;/**< current mode of SmaRx pin                        */
-		enum drxuio_mode uio_sma_tx_mode;/**< current mode of SmaTx pin                        */
-		enum drxuio_mode uio_gpio_mode; /**< current mode of ASEL pin                         */
-		enum drxuio_mode uio_irqn_mode; /**< current mode of IRQN pin                         */
+		enum drxuio_mode uio_sma_rx_mode;/*< current mode of SmaRx pin                        */
+		enum drxuio_mode uio_sma_tx_mode;/*< current mode of SmaTx pin                        */
+		enum drxuio_mode uio_gpio_mode; /*< current mode of ASEL pin                         */
+		enum drxuio_mode uio_irqn_mode; /*< current mode of IRQN pin                         */
 
 		/* IQM fs frequecy shift and inversion */
-		u32 iqm_fs_rate_ofs;	   /**< frequency shifter setting after setchannel      */
-		bool pos_image;	   /**< Ture: positive image                            */
+		u32 iqm_fs_rate_ofs;	   /*< frequency shifter setting after setchannel      */
+		bool pos_image;	   /*< Ture: positive image                            */
 		/* IQM RC frequecy shift */
-		u32 iqm_rc_rate_ofs;	   /**< frequency shifter setting after setchannel      */
+		u32 iqm_rc_rate_ofs;	   /*< frequency shifter setting after setchannel      */
 
 		/* ATV configuration */
-		u32 atv_cfg_changed_flags; /**< flag: flags cfg changes */
-		s16 atv_top_equ0[DRXJ_COEF_IDX_MAX];	     /**< shadow of ATV_TOP_EQU0__A */
-		s16 atv_top_equ1[DRXJ_COEF_IDX_MAX];	     /**< shadow of ATV_TOP_EQU1__A */
-		s16 atv_top_equ2[DRXJ_COEF_IDX_MAX];	     /**< shadow of ATV_TOP_EQU2__A */
-		s16 atv_top_equ3[DRXJ_COEF_IDX_MAX];	     /**< shadow of ATV_TOP_EQU3__A */
-		bool phase_correction_bypass;/**< flag: true=bypass */
-		s16 atv_top_vid_peak;	  /**< shadow of ATV_TOP_VID_PEAK__A */
-		u16 atv_top_noise_th;	  /**< shadow of ATV_TOP_NOISE_TH__A */
-		bool enable_cvbs_output;  /**< flag CVBS ouput enable */
-		bool enable_sif_output;	  /**< flag SIF ouput enable */
+		u32 atv_cfg_changed_flags; /*< flag: flags cfg changes */
+		s16 atv_top_equ0[DRXJ_COEF_IDX_MAX];	     /*< shadow of ATV_TOP_EQU0__A */
+		s16 atv_top_equ1[DRXJ_COEF_IDX_MAX];	     /*< shadow of ATV_TOP_EQU1__A */
+		s16 atv_top_equ2[DRXJ_COEF_IDX_MAX];	     /*< shadow of ATV_TOP_EQU2__A */
+		s16 atv_top_equ3[DRXJ_COEF_IDX_MAX];	     /*< shadow of ATV_TOP_EQU3__A */
+		bool phase_correction_bypass;/*< flag: true=bypass */
+		s16 atv_top_vid_peak;	  /*< shadow of ATV_TOP_VID_PEAK__A */
+		u16 atv_top_noise_th;	  /*< shadow of ATV_TOP_NOISE_TH__A */
+		bool enable_cvbs_output;  /*< flag CVBS ouput enable */
+		bool enable_sif_output;	  /*< flag SIF ouput enable */
 		 enum drxjsif_attenuation sif_attenuation;
-					  /**< current SIF att setting */
+					  /*< current SIF att setting */
 		/* Agc configuration for QAM and VSB */
-		struct drxj_cfg_agc qam_rf_agc_cfg; /**< qam RF AGC config */
-		struct drxj_cfg_agc qam_if_agc_cfg; /**< qam IF AGC config */
-		struct drxj_cfg_agc vsb_rf_agc_cfg; /**< vsb RF AGC config */
-		struct drxj_cfg_agc vsb_if_agc_cfg; /**< vsb IF AGC config */
+		struct drxj_cfg_agc qam_rf_agc_cfg; /*< qam RF AGC config */
+		struct drxj_cfg_agc qam_if_agc_cfg; /*< qam IF AGC config */
+		struct drxj_cfg_agc vsb_rf_agc_cfg; /*< vsb RF AGC config */
+		struct drxj_cfg_agc vsb_if_agc_cfg; /*< vsb IF AGC config */
 
 		/* PGA gain configuration for QAM and VSB */
-		u16 qam_pga_cfg;	  /**< qam PGA config */
-		u16 vsb_pga_cfg;	  /**< vsb PGA config */
+		u16 qam_pga_cfg;	  /*< qam PGA config */
+		u16 vsb_pga_cfg;	  /*< vsb PGA config */
 
 		/* Pre SAW configuration for QAM and VSB */
 		struct drxj_cfg_pre_saw qam_pre_saw_cfg;
-					  /**< qam pre SAW config */
+					  /*< qam pre SAW config */
 		struct drxj_cfg_pre_saw vsb_pre_saw_cfg;
-					  /**< qam pre SAW config */
+					  /*< qam pre SAW config */
 
 		/* Version information */
-		char v_text[2][12];	  /**< allocated text versions */
-		struct drx_version v_version[2]; /**< allocated versions structs */
+		char v_text[2][12];	  /*< allocated text versions */
+		struct drx_version v_version[2]; /*< allocated versions structs */
 		struct drx_version_list v_list_elements[2];
-					  /**< allocated version list */
+					  /*< allocated version list */
 
 		/* smart antenna configuration */
 		bool smart_ant_inverted;
@@ -502,25 +502,25 @@ struct drxj_cfg_atv_output {
 		bool oob_power_on;
 
 		/* MPEG static bitrate setting */
-		u32 mpeg_ts_static_bitrate;  /**< bitrate static MPEG output */
-		bool disable_te_ihandling;  /**< MPEG TS TEI handling */
-		bool bit_reverse_mpeg_outout;/**< MPEG output bit order */
+		u32 mpeg_ts_static_bitrate;  /*< bitrate static MPEG output */
+		bool disable_te_ihandling;  /*< MPEG TS TEI handling */
+		bool bit_reverse_mpeg_outout;/*< MPEG output bit order */
 		 enum drxj_mpeg_output_clock_rate mpeg_output_clock_rate;
-					    /**< MPEG output clock rate */
+					    /*< MPEG output clock rate */
 		 enum drxj_mpeg_start_width mpeg_start_width;
-					    /**< MPEG Start width */
+					    /*< MPEG Start width */
 
 		/* Pre SAW & Agc configuration for ATV */
 		struct drxj_cfg_pre_saw atv_pre_saw_cfg;
-					  /**< atv pre SAW config */
-		struct drxj_cfg_agc atv_rf_agc_cfg; /**< atv RF AGC config */
-		struct drxj_cfg_agc atv_if_agc_cfg; /**< atv IF AGC config */
-		u16 atv_pga_cfg;	  /**< atv pga config    */
+					  /*< atv pre SAW config */
+		struct drxj_cfg_agc atv_rf_agc_cfg; /*< atv RF AGC config */
+		struct drxj_cfg_agc atv_if_agc_cfg; /*< atv IF AGC config */
+		u16 atv_pga_cfg;	  /*< atv pga config    */
 
 		u32 curr_symbol_rate;
 
 		/* pin-safe mode */
-		bool pdr_safe_mode;	    /**< PDR safe mode activated      */
+		bool pdr_safe_mode;	    /*< PDR safe mode activated      */
 		u16 pdr_safe_restore_val_gpio;
 		u16 pdr_safe_restore_val_v_sync;
 		u16 pdr_safe_restore_val_sma_rx;
@@ -531,12 +531,12 @@ struct drxj_cfg_atv_output {
 		enum drxj_cfg_oob_lo_power oob_lo_pow;
 
 		struct drx_aud_data aud_data;
-				    /**< audio storage                  */};
+				    /*< audio storage                  */};
 
 /*-------------------------------------------------------------------------
 Access MACROS
 -------------------------------------------------------------------------*/
-/**
+/*
 * \brief Compilable references to attributes
 * \param d pointer to demod instance
 *
@@ -554,7 +554,7 @@ Access MACROS
 DEFINES
 -------------------------------------------------------------------------*/
 
-/**
+/*
 * \def DRXJ_NTSC_CARRIER_FREQ_OFFSET
 * \brief Offset from picture carrier to centre frequency in kHz, in RF domain
 *
@@ -569,7 +569,7 @@ DEFINES
 */
 #define DRXJ_NTSC_CARRIER_FREQ_OFFSET           ((s32)(1750))
 
-/**
+/*
 * \def DRXJ_PAL_SECAM_BG_CARRIER_FREQ_OFFSET
 * \brief Offset from picture carrier to centre frequency in kHz, in RF domain
 *
@@ -585,7 +585,7 @@ DEFINES
 */
 #define DRXJ_PAL_SECAM_BG_CARRIER_FREQ_OFFSET   ((s32)(2375))
 
-/**
+/*
 * \def DRXJ_PAL_SECAM_DKIL_CARRIER_FREQ_OFFSET
 * \brief Offset from picture carrier to centre frequency in kHz, in RF domain
 *
@@ -601,7 +601,7 @@ DEFINES
 */
 #define DRXJ_PAL_SECAM_DKIL_CARRIER_FREQ_OFFSET ((s32)(2775))
 
-/**
+/*
 * \def DRXJ_PAL_SECAM_LP_CARRIER_FREQ_OFFSET
 * \brief Offset from picture carrier to centre frequency in kHz, in RF domain
 *
@@ -616,7 +616,7 @@ DEFINES
 */
 #define DRXJ_PAL_SECAM_LP_CARRIER_FREQ_OFFSET   ((s32)(-3255))
 
-/**
+/*
 * \def DRXJ_FM_CARRIER_FREQ_OFFSET
 * \brief Offset from sound carrier to centre frequency in kHz, in RF domain
 *
diff --git a/drivers/media/dvb-frontends/drxk.h b/drivers/media/dvb-frontends/drxk.h
index eb9bdc9f59c4..c936142367fb 100644
--- a/drivers/media/dvb-frontends/drxk.h
+++ b/drivers/media/dvb-frontends/drxk.h
@@ -20,17 +20,18 @@
  * @antenna_dvbt:	GPIO bit for changing antenna to DVB-C. A value of 1
  *			means that 1=DVBC, 0 = DVBT. Zero means the opposite.
  * @mpeg_out_clk_strength: DRXK Mpeg output clock drive strength.
+ * @chunk_size:		maximum size for I2C messages
  * @microcode_name:	Name of the firmware file with the microcode
  * @qam_demod_parameter_count:	The number of parameters used for the command
  *				to set the demodulator parameters. All
  *				firmwares are using the 2-parameter commmand.
- *				An exception is the "drxk_a3.mc" firmware,
+ *				An exception is the ``drxk_a3.mc`` firmware,
  *				which uses the 4-parameter command.
  *				A value of 0 (default) or lower indicates that
  *				the correct number of parameters will be
  *				automatically detected.
  *
- * On the *_gpio vars, bit 0 is UIO-1, bit 1 is UIO-2 and bit 2 is
+ * On the ``*_gpio`` vars, bit 0 is UIO-1, bit 1 is UIO-2 and bit 2 is
  * UIO-3.
  */
 struct drxk_config {
diff --git a/drivers/media/dvb-frontends/dvb-pll.h b/drivers/media/dvb-frontends/dvb-pll.h
index 6aaa9c6bff9c..01dbcc4d9550 100644
--- a/drivers/media/dvb-frontends/dvb-pll.h
+++ b/drivers/media/dvb-frontends/dvb-pll.h
@@ -33,11 +33,12 @@
 /**
  * Attach a dvb-pll to the supplied frontend structure.
  *
- * @param fe Frontend to attach to.
- * @param pll_addr i2c address of the PLL (if used).
- * @param i2c i2c adapter to use (set to NULL if not used).
- * @param pll_desc_id dvb_pll_desc to use.
- * @return Frontend pointer on success, NULL on failure
+ * @fe: Frontend to attach to.
+ * @pll_addr: i2c address of the PLL (if used).
+ * @i2c: i2c adapter to use (set to NULL if not used).
+ * @pll_desc_id: dvb_pll_desc to use.
+ *
+ * return: Frontend pointer on success, NULL on failure
  */
 #if IS_REACHABLE(CONFIG_DVB_PLL)
 extern struct dvb_frontend *dvb_pll_attach(struct dvb_frontend *fe,
diff --git a/drivers/media/dvb-frontends/helene.h b/drivers/media/dvb-frontends/helene.h
index 333615491d9e..3f504f5d1d4f 100644
--- a/drivers/media/dvb-frontends/helene.h
+++ b/drivers/media/dvb-frontends/helene.h
@@ -38,6 +38,7 @@ enum helene_xtal {
  * @set_tuner_priv:	Callback function private context
  * @set_tuner_callback:	Callback function that notifies the parent driver
  *			which tuner is active now
+ * @xtal: Cristal frequency as described by &enum helene_xtal
  */
 struct helene_config {
 	u8	i2c_address;
diff --git a/drivers/media/dvb-frontends/ix2505v.h b/drivers/media/dvb-frontends/ix2505v.h
index 0b0a431c74f6..31ca03a7b827 100644
--- a/drivers/media/dvb-frontends/ix2505v.h
+++ b/drivers/media/dvb-frontends/ix2505v.h
@@ -19,14 +19,6 @@
 #include <linux/i2c.h>
 #include "dvb_frontend.h"
 
-/**
- * Attach a ix2505v tuner to the supplied frontend structure.
- *
- * @param fe Frontend to attach to.
- * @param config ix2505v_config structure
- * @return FE pointer on success, NULL on failure.
- */
-
 struct ix2505v_config {
 	u8 tuner_address;
 
@@ -45,6 +37,15 @@ struct ix2505v_config {
 };
 
 #if IS_REACHABLE(CONFIG_DVB_IX2505V)
+/**
+ * Attach a ix2505v tuner to the supplied frontend structure.
+ *
+ * @fe: Frontend to attach to.
+ * @config: pointer to &struct ix2505v_config
+ * @i2c: pointer to &struct i2c_adapter.
+ *
+ * return: FE pointer on success, NULL on failure.
+ */
 extern struct dvb_frontend *ix2505v_attach(struct dvb_frontend *fe,
 	const struct ix2505v_config *config, struct i2c_adapter *i2c);
 #else
diff --git a/drivers/media/dvb-frontends/l64781.c b/drivers/media/dvb-frontends/l64781.c
index 68923c84679a..e5a6c1766664 100644
--- a/drivers/media/dvb-frontends/l64781.c
+++ b/drivers/media/dvb-frontends/l64781.c
@@ -517,7 +517,7 @@ struct dvb_frontend* l64781_attach(const struct l64781_config* config,
 	state->i2c = i2c;
 	state->first = 1;
 
-	/**
+	/*
 	 *  the L64781 won't show up before we send the reset_and_configure()
 	 *  broadcast. If nothing responds there is no L64781 on the bus...
 	 */
diff --git a/drivers/media/dvb-frontends/mn88472.h b/drivers/media/dvb-frontends/mn88472.h
index 323632523876..8cd5ef61903b 100644
--- a/drivers/media/dvb-frontends/mn88472.h
+++ b/drivers/media/dvb-frontends/mn88472.h
@@ -19,21 +19,21 @@
 
 #include <linux/dvb/frontend.h>
 
+/* Define old names for backward compatibility */
+#define VARIABLE_TS_CLOCK   MN88472_TS_CLK_VARIABLE
+#define FIXED_TS_CLOCK      MN88472_TS_CLK_FIXED
+#define SERIAL_TS_MODE      MN88472_TS_MODE_SERIAL
+#define PARALLEL_TS_MODE    MN88472_TS_MODE_PARALLEL
+
 /**
  * struct mn88472_config - Platform data for the mn88472 driver
  * @xtal: Clock frequency.
  * @ts_mode: TS mode.
  * @ts_clock: TS clock config.
  * @i2c_wr_max: Max number of bytes driver writes to I2C at once.
- * @get_dvb_frontend: Get DVB frontend.
+ * @fe: pointer to a frontend pointer
+ * @get_dvb_frontend: Get DVB frontend callback.
  */
-
-/* Define old names for backward compatibility */
-#define VARIABLE_TS_CLOCK   MN88472_TS_CLK_VARIABLE
-#define FIXED_TS_CLOCK      MN88472_TS_CLK_FIXED
-#define SERIAL_TS_MODE      MN88472_TS_MODE_SERIAL
-#define PARALLEL_TS_MODE    MN88472_TS_MODE_PARALLEL
-
 struct mn88472_config {
 	unsigned int xtal;
 
diff --git a/drivers/media/dvb-frontends/rtl2832_sdr.h b/drivers/media/dvb-frontends/rtl2832_sdr.h
index d8fc7e7212e3..8f88c2fb8627 100644
--- a/drivers/media/dvb-frontends/rtl2832_sdr.h
+++ b/drivers/media/dvb-frontends/rtl2832_sdr.h
@@ -33,15 +33,11 @@
  * struct rtl2832_sdr_platform_data - Platform data for the rtl2832_sdr driver
  * @clk: Clock frequency (4000000, 16000000, 25000000, 28800000).
  * @tuner: Used tuner model.
- * @i2c_client: rtl2832 demod driver I2C client.
- * @bulk_read: rtl2832 driver private I/O interface.
- * @bulk_write: rtl2832 driver private I/O interface.
- * @update_bits: rtl2832 driver private I/O interface.
+ * @regmap: pointer to &struct regmap.
  * @dvb_frontend: rtl2832 DVB frontend.
  * @v4l2_subdev: Tuner v4l2 controls.
  * @dvb_usb_device: DVB USB interface for USB streaming.
  */
-
 struct rtl2832_sdr_platform_data {
 	u32 clk;
 	/*
diff --git a/drivers/media/dvb-frontends/stb6000.h b/drivers/media/dvb-frontends/stb6000.h
index 78e75dfc317f..3c4d51dd5415 100644
--- a/drivers/media/dvb-frontends/stb6000.h
+++ b/drivers/media/dvb-frontends/stb6000.h
@@ -29,10 +29,11 @@
 /**
  * Attach a stb6000 tuner to the supplied frontend structure.
  *
- * @param fe Frontend to attach to.
- * @param addr i2c address of the tuner.
- * @param i2c i2c adapter to use.
- * @return FE pointer on success, NULL on failure.
+ * @fe: Frontend to attach to.
+ * @addr: i2c address of the tuner.
+ * @i2c: i2c adapter to use.
+ *
+ * return: FE pointer on success, NULL on failure.
  */
 #if IS_REACHABLE(CONFIG_DVB_STB6000)
 extern struct dvb_frontend *stb6000_attach(struct dvb_frontend *fe, int addr,
diff --git a/drivers/media/dvb-frontends/stv0299.c b/drivers/media/dvb-frontends/stv0299.c
index b36b21a13201..b1f3d675d316 100644
--- a/drivers/media/dvb-frontends/stv0299.c
+++ b/drivers/media/dvb-frontends/stv0299.c
@@ -368,7 +368,7 @@ static int stv0299_set_voltage(struct dvb_frontend *fe,
 	reg0x08 = stv0299_readreg (state, 0x08);
 	reg0x0c = stv0299_readreg (state, 0x0c);
 
-	/**
+	/*
 	 *  H/V switching over OP0, OP1 and OP2 are LNB power enable bits
 	 */
 	reg0x0c &= 0x0f;
diff --git a/drivers/media/dvb-frontends/tda826x.h b/drivers/media/dvb-frontends/tda826x.h
index 81abe1aebe9f..6a7bed12e741 100644
--- a/drivers/media/dvb-frontends/tda826x.h
+++ b/drivers/media/dvb-frontends/tda826x.h
@@ -29,11 +29,12 @@
 /**
  * Attach a tda826x tuner to the supplied frontend structure.
  *
- * @param fe Frontend to attach to.
- * @param addr i2c address of the tuner.
- * @param i2c i2c adapter to use.
- * @param has_loopthrough Set to 1 if the card has a loopthrough RF connector.
- * @return FE pointer on success, NULL on failure.
+ * @fe: Frontend to attach to.
+ * @addr: i2c address of the tuner.
+ * @i2c: i2c adapter to use.
+ * @has_loopthrough: Set to 1 if the card has a loopthrough RF connector.
+ *
+ * return: FE pointer on success, NULL on failure.
  */
 #if IS_REACHABLE(CONFIG_DVB_TDA826X)
 extern struct dvb_frontend* tda826x_attach(struct dvb_frontend *fe, int addr,
diff --git a/drivers/media/dvb-frontends/tua6100.h b/drivers/media/dvb-frontends/tua6100.h
index 9f15cbdfdeca..6c098a894ea6 100644
--- a/drivers/media/dvb-frontends/tua6100.h
+++ b/drivers/media/dvb-frontends/tua6100.h
@@ -1,4 +1,4 @@
-/**
+/*
  * Driver for Infineon tua6100 PLL.
  *
  * (c) 2006 Andrew de Quincey
diff --git a/drivers/media/dvb-frontends/zd1301_demod.h b/drivers/media/dvb-frontends/zd1301_demod.h
index ceb2e05e873c..9496f7e8b4dd 100644
--- a/drivers/media/dvb-frontends/zd1301_demod.h
+++ b/drivers/media/dvb-frontends/zd1301_demod.h
@@ -27,7 +27,6 @@
  * @reg_read: Register read callback.
  * @reg_write: Register write callback.
  */
-
 struct zd1301_demod_platform_data {
 	void *reg_priv;
 	int (*reg_read)(void *, u16, u8 *);
@@ -41,8 +40,7 @@ struct zd1301_demod_platform_data {
  *
  * Return: Pointer to DVB frontend which given platform device owns.
  */
-
-struct dvb_frontend *zd1301_demod_get_dvb_frontend(struct platform_device *);
+struct dvb_frontend *zd1301_demod_get_dvb_frontend(struct platform_device *pdev);
 
 /**
  * zd1301_demod_get_i2c_adapter() - Get pointer to I2C adapter
@@ -50,8 +48,7 @@ struct dvb_frontend *zd1301_demod_get_dvb_frontend(struct platform_device *);
  *
  * Return: Pointer to I2C adapter which given platform device owns.
  */
-
-struct i2c_adapter *zd1301_demod_get_i2c_adapter(struct platform_device *);
+struct i2c_adapter *zd1301_demod_get_i2c_adapter(struct platform_device *pdev);
 
 #else
 
diff --git a/drivers/media/dvb-frontends/zl10036.h b/drivers/media/dvb-frontends/zl10036.h
index 88751adfecf7..ec90ca927739 100644
--- a/drivers/media/dvb-frontends/zl10036.h
+++ b/drivers/media/dvb-frontends/zl10036.h
@@ -20,20 +20,20 @@
 #include <linux/i2c.h>
 #include "dvb_frontend.h"
 
-/**
- * Attach a zl10036 tuner to the supplied frontend structure.
- *
- * @param fe Frontend to attach to.
- * @param config zl10036_config structure
- * @return FE pointer on success, NULL on failure.
- */
-
 struct zl10036_config {
 	u8 tuner_address;
 	int rf_loop_enable;
 };
 
 #if IS_REACHABLE(CONFIG_DVB_ZL10036)
+/**
+ * Attach a zl10036 tuner to the supplied frontend structure.
+ *
+ * @fe: Frontend to attach to.
+ * @config: zl10036_config structure.
+ * @i2c: pointer to struct i2c_adapter.
+ * return: FE pointer on success, NULL on failure.
+ */
 extern struct dvb_frontend *zl10036_attach(struct dvb_frontend *fe,
 	const struct zl10036_config *config, struct i2c_adapter *i2c);
 #else
-- 
2.14.3
