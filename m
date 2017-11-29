Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:52816 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753853AbdK2Kqr (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 29 Nov 2017 05:46:47 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Colin Ian King <colin.king@canonical.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arushi Singhal <arushisinghal19971997@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Daniel Scheller <d.scheller@gmx.net>
Subject: [PATCH 05/12] media: drxj and drxk: don't produce kernel-doc warnings
Date: Wed, 29 Nov 2017 05:46:26 -0500
Message-Id: <34eb9751ea8285c7732991a09cb8729d624f6245.1511952372.git.mchehab@s-opensource.com>
In-Reply-To: <46e42a303178ca1341d1ab3e0b5c1227b89b60ee.1511952372.git.mchehab@s-opensource.com>
References: <46e42a303178ca1341d1ab3e0b5c1227b89b60ee.1511952372.git.mchehab@s-opensource.com>
In-Reply-To: <46e42a303178ca1341d1ab3e0b5c1227b89b60ee.1511952372.git.mchehab@s-opensource.com>
References: <46e42a303178ca1341d1ab3e0b5c1227b89b60ee.1511952372.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Those drivers use a different notation for comments. While
it is not worth converting to kernel-doc, removing it is also
not an option.

So, just replace /** by /* and be happy :-)

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/dvb-frontends/drx39xyj/drxj.c | 248 ++++++++++++++--------------
 drivers/media/dvb-frontends/drxk_hard.c     |  32 ++--
 2 files changed, 140 insertions(+), 140 deletions(-)

diff --git a/drivers/media/dvb-frontends/drx39xyj/drxj.c b/drivers/media/dvb-frontends/drx39xyj/drxj.c
index 499ccff557bf..8cbd8cc21059 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drxj.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drxj.c
@@ -73,7 +73,7 @@ INCLUDE FILES
 
 #define DRX39XX_MAIN_FIRMWARE "dvb-fe-drxj-mc-1.0.8.fw"
 
-/**
+/*
 * \brief Maximum u32 value.
 */
 #ifndef MAX_U32
@@ -100,8 +100,8 @@ INCLUDE FILES
 #ifndef OOB_DRX_DRIVE_STRENGTH
 #define OOB_DRX_DRIVE_STRENGTH 0x02
 #endif
-/**** START DJCOMBO patches to DRXJ registermap constants *********************/
-/**** registermap 200706071303 from drxj **************************************/
+/*** START DJCOMBO patches to DRXJ registermap constants *********************/
+/*** registermap 200706071303 from drxj **************************************/
 #define   ATV_TOP_CR_AMP_TH_FM                                              0x0
 #define   ATV_TOP_CR_AMP_TH_L                                               0xA
 #define   ATV_TOP_CR_AMP_TH_LP                                              0xA
@@ -188,7 +188,7 @@ INCLUDE FILES
 #define     IQM_RC_ADJ_SEL_B_OFF                                            0x0
 #define     IQM_RC_ADJ_SEL_B_QAM                                            0x1
 #define     IQM_RC_ADJ_SEL_B_VSB                                            0x2
-/**** END DJCOMBO patches to DRXJ registermap *********************************/
+/*** END DJCOMBO patches to DRXJ registermap *********************************/
 
 #include "drx_driver_version.h"
 
@@ -208,25 +208,25 @@ DEFINES
 #define DRXJ_WAKE_UP_KEY (demod->my_i2c_dev_addr->i2c_addr)
 #endif
 
-/**
+/*
 * \def DRXJ_DEF_I2C_ADDR
 * \brief Default I2C address of a demodulator instance.
 */
 #define DRXJ_DEF_I2C_ADDR (0x52)
 
-/**
+/*
 * \def DRXJ_DEF_DEMOD_DEV_ID
 * \brief Default device identifier of a demodultor instance.
 */
 #define DRXJ_DEF_DEMOD_DEV_ID      (1)
 
-/**
+/*
 * \def DRXJ_SCAN_TIMEOUT
 * \brief Timeout value for waiting on demod lock during channel scan (millisec).
 */
 #define DRXJ_SCAN_TIMEOUT    1000
 
-/**
+/*
 * \def HI_I2C_DELAY
 * \brief HI timing delay for I2C timing (in nano seconds)
 *
@@ -234,7 +234,7 @@ DEFINES
 */
 #define HI_I2C_DELAY    42
 
-/**
+/*
 * \def HI_I2C_BRIDGE_DELAY
 * \brief HI timing delay for I2C timing (in nano seconds)
 *
@@ -242,13 +242,13 @@ DEFINES
 */
 #define HI_I2C_BRIDGE_DELAY   750
 
-/**
+/*
 * \brief Time Window for MER and SER Measurement in Units of Segment duration.
 */
 #define VSB_TOP_MEASUREMENT_PERIOD  64
 #define SYMBOLS_PER_SEGMENT         832
 
-/**
+/*
 * \brief bit rate and segment rate constants used for SER and BER.
 */
 /* values taken from the QAM microcode */
@@ -260,21 +260,21 @@ DEFINES
 #define DRXJ_QAM_SL_SIG_POWER_QAM64       43008
 #define DRXJ_QAM_SL_SIG_POWER_QAM128      20992
 #define DRXJ_QAM_SL_SIG_POWER_QAM256      43520
-/**
+/*
 * \brief Min supported symbolrates.
 */
 #ifndef DRXJ_QAM_SYMBOLRATE_MIN
 #define DRXJ_QAM_SYMBOLRATE_MIN          (520000)
 #endif
 
-/**
+/*
 * \brief Max supported symbolrates.
 */
 #ifndef DRXJ_QAM_SYMBOLRATE_MAX
 #define DRXJ_QAM_SYMBOLRATE_MAX         (7233000)
 #endif
 
-/**
+/*
 * \def DRXJ_QAM_MAX_WAITTIME
 * \brief Maximal wait time for QAM auto constellation in ms
 */
@@ -290,7 +290,7 @@ DEFINES
 #define DRXJ_QAM_DEMOD_LOCK_EXT_WAITTIME 200
 #endif
 
-/**
+/*
 * \def SCU status and results
 * \brief SCU
 */
@@ -299,7 +299,7 @@ DEFINES
 #define FEC_RS_MEASUREMENT_PERIOD   12894	/* 1 sec */
 #define FEC_RS_MEASUREMENT_PRESCALE 1	/* n sec */
 
-/**
+/*
 * \def DRX_AUD_MAX_DEVIATION
 * \brief Needed for calculation of prescale feature in AUD
 */
@@ -307,14 +307,14 @@ DEFINES
 #define DRXJ_AUD_MAX_FM_DEVIATION  100	/* kHz */
 #endif
 
-/**
+/*
 * \brief Needed for calculation of NICAM prescale feature in AUD
 */
 #ifndef DRXJ_AUD_MAX_NICAM_PRESCALE
 #define DRXJ_AUD_MAX_NICAM_PRESCALE  (9)	/* dB */
 #endif
 
-/**
+/*
 * \brief Needed for calculation of NICAM prescale feature in AUD
 */
 #ifndef DRXJ_AUD_MAX_WAITTIME
@@ -371,21 +371,21 @@ DEFINES
 /*============================================================================*/
 /*=== GLOBAL VARIABLEs =======================================================*/
 /*============================================================================*/
-/**
+/*
 */
 
-/**
+/*
 * \brief Temporary register definitions.
 *        (register definitions that are not yet available in register master)
 */
 
-/******************************************************************************/
+/*****************************************************************************/
 /* Audio block 0x103 is write only. To avoid shadowing in driver accessing    */
 /* RAM adresses directly. This must be READ ONLY to avoid problems.           */
 /* Writing to the interface adresses is more than only writing the RAM        */
 /* locations                                                                  */
-/******************************************************************************/
-/**
+/*****************************************************************************/
+/*
 * \brief RAM location of MODUS registers
 */
 #define AUD_DEM_RAM_MODUS_HI__A              0x10204A3
@@ -394,13 +394,13 @@ DEFINES
 #define AUD_DEM_RAM_MODUS_LO__A              0x10204A4
 #define AUD_DEM_RAM_MODUS_LO__M              0x0FFF
 
-/**
+/*
 * \brief RAM location of I2S config registers
 */
 #define AUD_DEM_RAM_I2S_CONFIG1__A           0x10204B1
 #define AUD_DEM_RAM_I2S_CONFIG2__A           0x10204B2
 
-/**
+/*
 * \brief RAM location of DCO config registers
 */
 #define AUD_DEM_RAM_DCO_B_HI__A              0x1020461
@@ -408,20 +408,20 @@ DEFINES
 #define AUD_DEM_RAM_DCO_A_HI__A              0x1020463
 #define AUD_DEM_RAM_DCO_A_LO__A              0x1020464
 
-/**
+/*
 * \brief RAM location of Threshold registers
 */
 #define AUD_DEM_RAM_NICAM_THRSHLD__A         0x102045A
 #define AUD_DEM_RAM_A2_THRSHLD__A            0x10204BB
 #define AUD_DEM_RAM_BTSC_THRSHLD__A          0x10204A6
 
-/**
+/*
 * \brief RAM location of Carrier Threshold registers
 */
 #define AUD_DEM_RAM_CM_A_THRSHLD__A          0x10204AF
 #define AUD_DEM_RAM_CM_B_THRSHLD__A          0x10204B0
 
-/**
+/*
 * \brief FM Matrix register fix
 */
 #ifdef AUD_DEM_WR_FM_MATRIX__A
@@ -430,7 +430,7 @@ DEFINES
 #define AUD_DEM_WR_FM_MATRIX__A              0x105006F
 
 /*============================================================================*/
-/**
+/*
 * \brief Defines required for audio
 */
 #define AUD_VOLUME_ZERO_DB                      115
@@ -443,14 +443,14 @@ DEFINES
 #define AUD_I2S_FREQUENCY_MIN                   12000UL
 #define AUD_RDS_ARRAY_SIZE                      18
 
-/**
+/*
 * \brief Needed for calculation of prescale feature in AUD
 */
 #ifndef DRX_AUD_MAX_FM_DEVIATION
 #define DRX_AUD_MAX_FM_DEVIATION  (100)	/* kHz */
 #endif
 
-/**
+/*
 * \brief Needed for calculation of NICAM prescale feature in AUD
 */
 #ifndef DRX_AUD_MAX_NICAM_PRESCALE
@@ -478,7 +478,7 @@ DEFINES
 /*=== REGISTER ACCESS MACROS =================================================*/
 /*============================================================================*/
 
-/**
+/*
 * This macro is used to create byte arrays for block writes.
 * Block writes speed up I2C traffic between host and demod.
 * The macro takes care of the required byte order in a 16 bits word.
@@ -486,7 +486,7 @@ DEFINES
 */
 #define DRXJ_16TO8(x) ((u8) (((u16)x) & 0xFF)), \
 		       ((u8)((((u16)x)>>8)&0xFF))
-/**
+/*
 * This macro is used to convert byte array to 16 bit register value for block read.
 * Block read speed up I2C traffic between host and demod.
 * The macro takes care of the required byte order in a 16 bits word.
@@ -501,7 +501,7 @@ DEFINES
 /*=== HI COMMAND RELATED DEFINES =============================================*/
 /*============================================================================*/
 
-/**
+/*
 * \brief General maximum number of retries for ucode command interfaces
 */
 #define DRXJ_MAX_RETRIES (100)
@@ -807,7 +807,7 @@ static struct drxj_data drxj_data_g = {
 	 },
 };
 
-/**
+/*
 * \var drxj_default_addr_g
 * \brief Default I2C address and device identifier.
 */
@@ -816,7 +816,7 @@ static struct i2c_device_addr drxj_default_addr_g = {
 	DRXJ_DEF_DEMOD_DEV_ID	/* device id */
 };
 
-/**
+/*
 * \var drxj_default_comm_attr_g
 * \brief Default common attributes of a drxj demodulator instance.
 */
@@ -887,7 +887,7 @@ static struct drx_common_attr drxj_default_comm_attr_g = {
 	0			/* mfx */
 };
 
-/**
+/*
 * \var drxj_default_demod_g
 * \brief Default drxj demodulator instance.
 */
@@ -897,7 +897,7 @@ static struct drx_demod_instance drxj_default_demod_g = {
 	&drxj_data_g		/* demod device specific attributes */
 };
 
-/**
+/*
 * \brief Default audio data structure for DRK demodulator instance.
 *
 * This structure is DRXK specific.
@@ -997,7 +997,7 @@ struct drxj_hi_cmd {
 /*=== MICROCODE RELATED STRUCTURES ===========================================*/
 /*============================================================================*/
 
-/**
+/*
  * struct drxu_code_block_hdr - Structure of the microcode block headers
  *
  * @addr:	Destination address of the data in this block
@@ -1086,7 +1086,7 @@ static u32 frac28(u32 N, u32 D)
 	return Q1;
 }
 
-/**
+/*
 * \fn u32 log1_times100( u32 x)
 * \brief Compute: 100*log10(x)
 * \param x 32 bits
@@ -1198,7 +1198,7 @@ static u32 log1_times100(u32 x)
 
 }
 
-/**
+/*
 * \fn u32 frac_times1e6( u16 N, u32 D)
 * \brief Compute: (N/D) * 1000000.
 * \param N nominator 16-bits.
@@ -1235,7 +1235,7 @@ static u32 frac_times1e6(u32 N, u32 D)
 /*============================================================================*/
 
 
-/**
+/*
 * \brief Values for NICAM prescaler gain. Computed from dB to integer
 *        and rounded. For calc used formula: 16*10^(prescaleGain[dB]/20).
 *
@@ -1280,7 +1280,7 @@ static const u16 nicam_presc_table_val[43] = {
 #define DRXJ_DAP_AUDTRIF_TIMEOUT 80	/* millisec */
 /*============================================================================*/
 
-/**
+/*
 * \fn bool is_handled_by_aud_tr_if( u32 addr )
 * \brief Check if this address is handled by the audio token ring interface.
 * \param addr
@@ -1386,7 +1386,7 @@ int drxbsp_i2c_write_read(struct i2c_device_addr *w_dev_addr,
 
 /*============================================================================*/
 
-/******************************
+/*****************************
 *
 * int drxdap_fasi_read_block (
 *      struct i2c_device_addr *dev_addr,      -- address of I2C device
@@ -1498,7 +1498,7 @@ static int drxdap_fasi_read_block(struct i2c_device_addr *dev_addr,
 }
 
 
-/******************************
+/*****************************
 *
 * int drxdap_fasi_read_reg16 (
 *     struct i2c_device_addr *dev_addr, -- address of I2C device
@@ -1531,7 +1531,7 @@ static int drxdap_fasi_read_reg16(struct i2c_device_addr *dev_addr,
 	return rc;
 }
 
-/******************************
+/*****************************
 *
 * int drxdap_fasi_read_reg32 (
 *     struct i2c_device_addr *dev_addr, -- address of I2C device
@@ -1566,7 +1566,7 @@ static int drxdap_fasi_read_reg32(struct i2c_device_addr *dev_addr,
 	return rc;
 }
 
-/******************************
+/*****************************
 *
 * int drxdap_fasi_write_block (
 *      struct i2c_device_addr *dev_addr,    -- address of I2C device
@@ -1705,7 +1705,7 @@ static int drxdap_fasi_write_block(struct i2c_device_addr *dev_addr,
 	return first_err;
 }
 
-/******************************
+/*****************************
 *
 * int drxdap_fasi_write_reg16 (
 *     struct i2c_device_addr *dev_addr, -- address of I2C device
@@ -1734,7 +1734,7 @@ static int drxdap_fasi_write_reg16(struct i2c_device_addr *dev_addr,
 	return drxdap_fasi_write_block(dev_addr, addr, sizeof(data), buf, flags);
 }
 
-/******************************
+/*****************************
 *
 * int drxdap_fasi_read_modify_write_reg16 (
 *      struct i2c_device_addr *dev_addr,   -- address of I2C device
@@ -1778,7 +1778,7 @@ static int drxdap_fasi_read_modify_write_reg16(struct i2c_device_addr *dev_addr,
 	return rc;
 }
 
-/******************************
+/*****************************
 *
 * int drxdap_fasi_write_reg32 (
 *     struct i2c_device_addr *dev_addr, -- address of I2C device
@@ -1811,7 +1811,7 @@ static int drxdap_fasi_write_reg32(struct i2c_device_addr *dev_addr,
 
 /*============================================================================*/
 
-/**
+/*
 * \fn int drxj_dap_rm_write_reg16short
 * \brief Read modify write 16 bits audio register using short format only.
 * \param dev_addr
@@ -1890,7 +1890,7 @@ static int drxj_dap_read_modify_write_reg16(struct i2c_device_addr *dev_addr,
 
 /*============================================================================*/
 
-/**
+/*
 * \fn int drxj_dap_read_aud_reg16
 * \brief Read 16 bits audio register
 * \param dev_addr
@@ -1997,7 +1997,7 @@ static int drxj_dap_read_reg16(struct i2c_device_addr *dev_addr,
 }
 /*============================================================================*/
 
-/**
+/*
 * \fn int drxj_dap_write_aud_reg16
 * \brief Write 16 bits audio register
 * \param dev_addr
@@ -2086,7 +2086,7 @@ static int drxj_dap_write_reg16(struct i2c_device_addr *dev_addr,
 #define DRXJ_HI_ATOMIC_READ      SIO_HI_RA_RAM_PAR_3_ACP_RW_READ
 #define DRXJ_HI_ATOMIC_WRITE     SIO_HI_RA_RAM_PAR_3_ACP_RW_WRITE
 
-/**
+/*
 * \fn int drxj_dap_atomic_read_write_block()
 * \brief Basic access routine for atomic read or write access
 * \param dev_addr  pointer to i2c dev address
@@ -2168,7 +2168,7 @@ int drxj_dap_atomic_read_write_block(struct i2c_device_addr *dev_addr,
 
 /*============================================================================*/
 
-/**
+/*
 * \fn int drxj_dap_atomic_read_reg32()
 * \brief Atomic read of 32 bits words
 */
@@ -2215,7 +2215,7 @@ int drxj_dap_atomic_read_reg32(struct i2c_device_addr *dev_addr,
 /*============================================================================*/
 /*============================================================================*/
 
-/**
+/*
 * \fn int hi_cfg_command()
 * \brief Configure HI with settings stored in the demod structure.
 * \param demod Demodulator.
@@ -2258,7 +2258,7 @@ static int hi_cfg_command(const struct drx_demod_instance *demod)
 	return rc;
 }
 
-/**
+/*
 * \fn int hi_command()
 * \brief Configure HI with settings stored in the demod structure.
 * \param dev_addr I2C address.
@@ -2369,7 +2369,7 @@ hi_command(struct i2c_device_addr *dev_addr, const struct drxj_hi_cmd *cmd, u16
 	return rc;
 }
 
-/**
+/*
 * \fn int init_hi( const struct drx_demod_instance *demod )
 * \brief Initialise and configurate HI.
 * \param demod pointer to demod data.
@@ -2450,7 +2450,7 @@ static int init_hi(const struct drx_demod_instance *demod)
 /*============================================================================*/
 /*============================================================================*/
 
-/**
+/*
 * \fn int get_device_capabilities()
 * \brief Get and store device capabilities.
 * \param demod  Pointer to demodulator instance.
@@ -2656,7 +2656,7 @@ static int get_device_capabilities(struct drx_demod_instance *demod)
 	return rc;
 }
 
-/**
+/*
 * \fn int power_up_device()
 * \brief Power up device.
 * \param demod  Pointer to demodulator instance.
@@ -2710,7 +2710,7 @@ static int power_up_device(struct drx_demod_instance *demod)
 /*----------------------------------------------------------------------------*/
 /* MPEG Output Configuration Functions - begin                                */
 /*----------------------------------------------------------------------------*/
-/**
+/*
 * \fn int ctrl_set_cfg_mpeg_output()
 * \brief Set MPEG output configuration of the device.
 * \param devmod  Pointer to demodulator instance.
@@ -3356,7 +3356,7 @@ ctrl_set_cfg_mpeg_output(struct drx_demod_instance *demod, struct drx_cfg_mpeg_o
 /* miscellaneous configurations - begin                           */
 /*----------------------------------------------------------------------------*/
 
-/**
+/*
 * \fn int set_mpegtei_handling()
 * \brief Activate MPEG TEI handling settings.
 * \param devmod  Pointer to demodulator instance.
@@ -3429,7 +3429,7 @@ static int set_mpegtei_handling(struct drx_demod_instance *demod)
 }
 
 /*----------------------------------------------------------------------------*/
-/**
+/*
 * \fn int bit_reverse_mpeg_output()
 * \brief Set MPEG output bit-endian settings.
 * \param devmod  Pointer to demodulator instance.
@@ -3472,7 +3472,7 @@ static int bit_reverse_mpeg_output(struct drx_demod_instance *demod)
 }
 
 /*----------------------------------------------------------------------------*/
-/**
+/*
 * \fn int set_mpeg_start_width()
 * \brief Set MPEG start width.
 * \param devmod  Pointer to demodulator instance.
@@ -3522,7 +3522,7 @@ static int set_mpeg_start_width(struct drx_demod_instance *demod)
 /*----------------------------------------------------------------------------*/
 /* UIO Configuration Functions - begin                                        */
 /*----------------------------------------------------------------------------*/
-/**
+/*
 * \fn int ctrl_set_uio_cfg()
 * \brief Configure modus oprandi UIO.
 * \param demod Pointer to demodulator instance.
@@ -3659,7 +3659,7 @@ static int ctrl_set_uio_cfg(struct drx_demod_instance *demod, struct drxuio_cfg
 	return rc;
 }
 
-/**
+/*
 * \fn int ctrl_uio_write()
 * \brief Write to a UIO.
 * \param demod Pointer to demodulator instance.
@@ -3868,7 +3868,7 @@ ctrl_uio_write(struct drx_demod_instance *demod, struct drxuio_data *uio_data)
 /*----------------------------------------------------------------------------*/
 /* I2C Bridge Functions - begin                                               */
 /*----------------------------------------------------------------------------*/
-/**
+/*
 * \fn int ctrl_i2c_bridge()
 * \brief Open or close the I2C switch to tuner.
 * \param demod Pointer to demodulator instance.
@@ -3903,7 +3903,7 @@ ctrl_i2c_bridge(struct drx_demod_instance *demod, bool *bridge_closed)
 /*----------------------------------------------------------------------------*/
 /* Smart antenna Functions - begin                                            */
 /*----------------------------------------------------------------------------*/
-/**
+/*
 * \fn int smart_ant_init()
 * \brief Initialize Smart Antenna.
 * \param pointer to struct drx_demod_instance.
@@ -4116,7 +4116,7 @@ static int scu_command(struct i2c_device_addr *dev_addr, struct drxjscu_cmd *cmd
 	return rc;
 }
 
-/**
+/*
 * \fn int DRXJ_DAP_SCUAtomicReadWriteBlock()
 * \brief Basic access routine for SCU atomic read or write access
 * \param dev_addr  pointer to i2c dev address
@@ -4188,7 +4188,7 @@ int drxj_dap_scu_atomic_read_write_block(struct i2c_device_addr *dev_addr, u32 a
 
 /*============================================================================*/
 
-/**
+/*
 * \fn int DRXJ_DAP_AtomicReadReg16()
 * \brief Atomic read of 16 bits words
 */
@@ -4216,7 +4216,7 @@ int drxj_dap_scu_atomic_read_reg16(struct i2c_device_addr *dev_addr,
 }
 
 /*============================================================================*/
-/**
+/*
 * \fn int drxj_dap_scu_atomic_write_reg16()
 * \brief Atomic read of 16 bits words
 */
@@ -4237,7 +4237,7 @@ int drxj_dap_scu_atomic_write_reg16(struct i2c_device_addr *dev_addr,
 }
 
 /* -------------------------------------------------------------------------- */
-/**
+/*
 * \brief Measure result of ADC synchronisation
 * \param demod demod instance
 * \param count (returned) count
@@ -4297,7 +4297,7 @@ static int adc_sync_measurement(struct drx_demod_instance *demod, u16 *count)
 	return rc;
 }
 
-/**
+/*
 * \brief Synchronize analog and digital clock domains
 * \param demod demod instance
 * \return int.
@@ -4365,7 +4365,7 @@ static int adc_synchronization(struct drx_demod_instance *demod)
 /*==                8VSB & QAM COMMON DATAPATH FUNCTIONS                    ==*/
 /*============================================================================*/
 /*============================================================================*/
-/**
+/*
 * \fn int init_agc ()
 * \brief Initialize AGC for all standards.
 * \param demod instance of demodulator.
@@ -4741,7 +4741,7 @@ static int init_agc(struct drx_demod_instance *demod)
 	return rc;
 }
 
-/**
+/*
 * \fn int set_frequency ()
 * \brief Set frequency shift.
 * \param demod instance of demodulator.
@@ -4839,7 +4839,7 @@ set_frequency(struct drx_demod_instance *demod,
 	return rc;
 }
 
-/**
+/*
 * \fn int get_acc_pkt_err()
 * \brief Retrieve signal strength for VSB and QAM.
 * \param demod Pointer to demod instance
@@ -4891,7 +4891,7 @@ static int get_acc_pkt_err(struct drx_demod_instance *demod, u16 *packet_err)
 
 /*============================================================================*/
 
-/**
+/*
 * \fn int set_agc_rf ()
 * \brief Configure RF AGC
 * \param demod instance of demodulator.
@@ -5105,7 +5105,7 @@ set_agc_rf(struct drx_demod_instance *demod, struct drxj_cfg_agc *agc_settings,
 	return rc;
 }
 
-/**
+/*
 * \fn int set_agc_if ()
 * \brief Configure If AGC
 * \param demod instance of demodulator.
@@ -5334,7 +5334,7 @@ set_agc_if(struct drx_demod_instance *demod, struct drxj_cfg_agc *agc_settings,
 	return rc;
 }
 
-/**
+/*
 * \fn int set_iqm_af ()
 * \brief Configure IQM AF registers
 * \param demod instance of demodulator.
@@ -5380,7 +5380,7 @@ static int set_iqm_af(struct drx_demod_instance *demod, bool active)
 /*============================================================================*/
 /*============================================================================*/
 
-/**
+/*
 * \fn int power_down_vsb ()
 * \brief Powr down QAM related blocks.
 * \param demod instance of demodulator.
@@ -5478,7 +5478,7 @@ static int power_down_vsb(struct drx_demod_instance *demod, bool primary)
 	return rc;
 }
 
-/**
+/*
 * \fn int set_vsb_leak_n_gain ()
 * \brief Set ATSC demod.
 * \param demod instance of demodulator.
@@ -5694,7 +5694,7 @@ static int set_vsb_leak_n_gain(struct drx_demod_instance *demod)
 	return rc;
 }
 
-/**
+/*
 * \fn int set_vsb()
 * \brief Set 8VSB demod.
 * \param demod instance of demodulator.
@@ -6200,7 +6200,7 @@ static int set_vsb(struct drx_demod_instance *demod)
 	return rc;
 }
 
-/**
+/*
 * \fn static short get_vsb_post_rs_pck_err(struct i2c_device_addr *dev_addr, u16 *PckErrs)
 * \brief Get the values of packet error in 8VSB mode
 * \return Error code
@@ -6239,7 +6239,7 @@ static int get_vsb_post_rs_pck_err(struct i2c_device_addr *dev_addr,
 	return rc;
 }
 
-/**
+/*
 * \fn static short GetVSBBer(struct i2c_device_addr *dev_addr, u32 *ber)
 * \brief Get the values of ber in VSB mode
 * \return Error code
@@ -6284,7 +6284,7 @@ static int get_vs_bpost_viterbi_ber(struct i2c_device_addr *dev_addr,
 	return rc;
 }
 
-/**
+/*
 * \fn static short get_vs_bpre_viterbi_ber(struct i2c_device_addr *dev_addr, u32 *ber)
 * \brief Get the values of ber in VSB mode
 * \return Error code
@@ -6306,7 +6306,7 @@ static int get_vs_bpre_viterbi_ber(struct i2c_device_addr *dev_addr,
 	return 0;
 }
 
-/**
+/*
 * \fn static int get_vsbmer(struct i2c_device_addr *dev_addr, u16 *mer)
 * \brief Get the values of MER
 * \return Error code
@@ -6340,7 +6340,7 @@ static int get_vsbmer(struct i2c_device_addr *dev_addr, u16 *mer)
 /*============================================================================*/
 /*============================================================================*/
 
-/**
+/*
 * \fn int power_down_qam ()
 * \brief Powr down QAM related blocks.
 * \param demod instance of demodulator.
@@ -6444,7 +6444,7 @@ static int power_down_qam(struct drx_demod_instance *demod, bool primary)
 
 /*============================================================================*/
 
-/**
+/*
 * \fn int set_qam_measurement ()
 * \brief Setup of the QAM Measuremnt intervals for signal quality
 * \param demod instance of demod.
@@ -6656,7 +6656,7 @@ set_qam_measurement(struct drx_demod_instance *demod,
 
 /*============================================================================*/
 
-/**
+/*
 * \fn int set_qam16 ()
 * \brief QAM16 specific setup
 * \param demod instance of demod.
@@ -6891,7 +6891,7 @@ static int set_qam16(struct drx_demod_instance *demod)
 
 /*============================================================================*/
 
-/**
+/*
 * \fn int set_qam32 ()
 * \brief QAM32 specific setup
 * \param demod instance of demod.
@@ -7126,7 +7126,7 @@ static int set_qam32(struct drx_demod_instance *demod)
 
 /*============================================================================*/
 
-/**
+/*
 * \fn int set_qam64 ()
 * \brief QAM64 specific setup
 * \param demod instance of demod.
@@ -7362,7 +7362,7 @@ static int set_qam64(struct drx_demod_instance *demod)
 
 /*============================================================================*/
 
-/**
+/*
 * \fn int set_qam128 ()
 * \brief QAM128 specific setup
 * \param demod: instance of demod.
@@ -7597,7 +7597,7 @@ static int set_qam128(struct drx_demod_instance *demod)
 
 /*============================================================================*/
 
-/**
+/*
 * \fn int set_qam256 ()
 * \brief QAM256 specific setup
 * \param demod: instance of demod.
@@ -7835,7 +7835,7 @@ static int set_qam256(struct drx_demod_instance *demod)
 #define QAM_SET_OP_CONSTELLATION 0x2
 #define QAM_SET_OP_SPECTRUM 0X4
 
-/**
+/*
 * \fn int set_qam ()
 * \brief Set QAM demod.
 * \param demod:   instance of demod.
@@ -8845,7 +8845,7 @@ static int qam_flip_spec(struct drx_demod_instance *demod, struct drx_channel *c
 #define  DEMOD_LOCKED   0x1
 #define  SYNC_FLIPPED   0x2
 #define  SPEC_MIRRORED  0x4
-/**
+/*
 * \fn int qam64auto ()
 * \brief auto do sync pattern switching and mirroring.
 * \param demod:   instance of demod.
@@ -8993,7 +8993,7 @@ qam64auto(struct drx_demod_instance *demod,
 	return rc;
 }
 
-/**
+/*
 * \fn int qam256auto ()
 * \brief auto do sync pattern switching and mirroring.
 * \param demod:   instance of demod.
@@ -9077,7 +9077,7 @@ qam256auto(struct drx_demod_instance *demod,
 	return rc;
 }
 
-/**
+/*
 * \fn int set_qam_channel ()
 * \brief Set QAM channel according to the requested constellation.
 * \param demod:   instance of demod.
@@ -9284,7 +9284,7 @@ set_qam_channel(struct drx_demod_instance *demod,
 
 /*============================================================================*/
 
-/**
+/*
 * \fn static short get_qamrs_err_count(struct i2c_device_addr *dev_addr)
 * \brief Get RS error count in QAM mode (used for post RS BER calculation)
 * \return Error code
@@ -9355,7 +9355,7 @@ get_qamrs_err_count(struct i2c_device_addr *dev_addr,
 
 /*============================================================================*/
 
-/**
+/*
  * \fn int get_sig_strength()
  * \brief Retrieve signal strength for VSB and QAM.
  * \param demod Pointer to demod instance
@@ -9435,7 +9435,7 @@ static int get_sig_strength(struct drx_demod_instance *demod, u16 *sig_strength)
 	return rc;
 }
 
-/**
+/*
 * \fn int ctrl_get_qam_sig_quality()
 * \brief Retrieve QAM signal quality from device.
 * \param devmod Pointer to demodulator instance.
@@ -9721,7 +9721,7 @@ ctrl_get_qam_sig_quality(struct drx_demod_instance *demod)
 */
 /* -------------------------------------------------------------------------- */
 
-/**
+/*
 * \fn int power_down_atv ()
 * \brief Power down ATV.
 * \param demod instance of demodulator
@@ -9822,7 +9822,7 @@ power_down_atv(struct drx_demod_instance *demod, enum drx_standard standard, boo
 
 /*============================================================================*/
 
-/**
+/*
 * \brief Power up AUD.
 * \param demod instance of demodulator
 * \return int.
@@ -9850,7 +9850,7 @@ static int power_down_aud(struct drx_demod_instance *demod)
 	return rc;
 }
 
-/**
+/*
 * \fn int set_orx_nsu_aox()
 * \brief Configure OrxNsuAox for OOB
 * \param demod instance of demodulator.
@@ -9884,7 +9884,7 @@ static int set_orx_nsu_aox(struct drx_demod_instance *demod, bool active)
 	return rc;
 }
 
-/**
+/*
 * \fn int ctrl_set_oob()
 * \brief Set OOB channel to be used.
 * \param demod instance of demodulator
@@ -9986,9 +9986,9 @@ static int ctrl_set_oob(struct drx_demod_instance *demod, struct drxoob *oob_par
 		    20;
 	}
 
-   /*********/
+   /********/
 	/* Stop  */
-   /*********/
+   /********/
 	rc = drxj_dap_write_reg16(dev_addr, ORX_COMM_EXEC__A, ORX_COMM_EXEC_STOP, 0);
 	if (rc != 0) {
 		pr_err("error %d\n", rc);
@@ -10004,9 +10004,9 @@ static int ctrl_set_oob(struct drx_demod_instance *demod, struct drxoob *oob_par
 		pr_err("error %d\n", rc);
 		goto rw_error;
 	}
-   /*********/
+   /********/
 	/* Reset */
-   /*********/
+   /********/
 	scu_cmd.command = SCU_RAM_COMMAND_STANDARD_OOB
 	    | SCU_RAM_COMMAND_CMD_DEMOD_RESET;
 	scu_cmd.parameter_len = 0;
@@ -10017,9 +10017,9 @@ static int ctrl_set_oob(struct drx_demod_instance *demod, struct drxoob *oob_par
 		pr_err("error %d\n", rc);
 		goto rw_error;
 	}
-   /***********/
+   /**********/
 	/* SET_ENV */
-   /***********/
+   /**********/
 	/* set frequency, spectrum inversion and data rate */
 	scu_cmd.command = SCU_RAM_COMMAND_STANDARD_OOB
 	    | SCU_RAM_COMMAND_CMD_DEMOD_SET_ENV;
@@ -10376,9 +10376,9 @@ static int ctrl_set_oob(struct drx_demod_instance *demod, struct drxoob *oob_par
 		pr_err("error %d\n", rc);
 		goto rw_error;
 	}
-	/*********/
+	/********/
 	/* Start */
-	/*********/
+	/********/
 	scu_cmd.command = SCU_RAM_COMMAND_STANDARD_OOB
 	    | SCU_RAM_COMMAND_CMD_DEMOD_START;
 	scu_cmd.parameter_len = 0;
@@ -10419,7 +10419,7 @@ static int ctrl_set_oob(struct drx_demod_instance *demod, struct drxoob *oob_par
 /*=============================================================================
   ===== ctrl_set_channel() ==========================================================
   ===========================================================================*/
-/**
+/*
 * \fn int ctrl_set_channel()
 * \brief Select a new transmission channel.
 * \param demod instance of demod.
@@ -10652,7 +10652,7 @@ ctrl_set_channel(struct drx_demod_instance *demod, struct drx_channel *channel)
   ===== SigQuality() ==========================================================
   ===========================================================================*/
 
-/**
+/*
 * \fn int ctrl_sig_quality()
 * \brief Retrieve signal quality form device.
 * \param devmod Pointer to demodulator instance.
@@ -10768,7 +10768,7 @@ ctrl_sig_quality(struct drx_demod_instance *demod,
 
 /*============================================================================*/
 
-/**
+/*
 * \fn int ctrl_lock_status()
 * \brief Retrieve lock status .
 * \param dev_addr Pointer to demodulator device address.
@@ -10856,7 +10856,7 @@ ctrl_lock_status(struct drx_demod_instance *demod, enum drx_lock_status *lock_st
 
 /*============================================================================*/
 
-/**
+/*
 * \fn int ctrl_set_standard()
 * \brief Set modulation standard to be used.
 * \param standard Modulation standard.
@@ -11012,7 +11012,7 @@ static void drxj_reset_mode(struct drxj_data *ext_attr)
 	ext_attr->vsb_pre_saw_cfg.use_pre_saw = true;
 }
 
-/**
+/*
 * \fn int ctrl_power_mode()
 * \brief Set the power mode of the device to the specified power mode
 * \param demod Pointer to demodulator instance.
@@ -11171,7 +11171,7 @@ ctrl_power_mode(struct drx_demod_instance *demod, enum drx_power_mode *mode)
 /*== CTRL Set/Get Config related functions ===================================*/
 /*============================================================================*/
 
-/**
+/*
 * \fn int ctrl_set_cfg_pre_saw()
 * \brief Set Pre-saw reference.
 * \param demod demod instance
@@ -11234,7 +11234,7 @@ ctrl_set_cfg_pre_saw(struct drx_demod_instance *demod, struct drxj_cfg_pre_saw *
 
 /*============================================================================*/
 
-/**
+/*
 * \fn int ctrl_set_cfg_afe_gain()
 * \brief Set AFE Gain.
 * \param demod demod instance
@@ -11324,7 +11324,7 @@ static int drx_ctrl_u_code(struct drx_demod_instance *demod,
 		       enum drxu_code_action action);
 static int drxj_set_lna_state(struct drx_demod_instance *demod, bool state);
 
-/**
+/*
 * \fn drxj_open()
 * \brief Open the demod instance, configure device, configure drxdriver
 * \return Status_t Return status.
@@ -11543,7 +11543,7 @@ static int drxj_open(struct drx_demod_instance *demod)
 }
 
 /*============================================================================*/
-/**
+/*
 * \fn drxj_close()
 * \brief Close the demod instance, power down the device
 * \return Status_t Return status.
@@ -11594,7 +11594,7 @@ static int drxj_close(struct drx_demod_instance *demod)
  * Microcode related functions
  */
 
-/**
+/*
  * drx_u_code_compute_crc	- Compute CRC of block of microcode data.
  * @block_data: Pointer to microcode data.
  * @nr_words:   Size of microcode block (number of 16 bits words).
@@ -11622,7 +11622,7 @@ static u16 drx_u_code_compute_crc(u8 *block_data, u16 nr_words)
 	return (u16)(crc_word >> 16);
 }
 
-/**
+/*
  * drx_check_firmware - checks if the loaded firmware is valid
  *
  * @demod:	demod structure
@@ -11708,7 +11708,7 @@ static int drx_check_firmware(struct drx_demod_instance *demod, u8 *mc_data,
 	return -EINVAL;
 }
 
-/**
+/*
  * drx_ctrl_u_code - Handle microcode upload or verify.
  * @dev_addr: Address of device.
  * @mc_info:  Pointer to information about microcode data.
diff --git a/drivers/media/dvb-frontends/drxk_hard.c b/drivers/media/dvb-frontends/drxk_hard.c
index 48a8aad47a74..f59ac2e91c59 100644
--- a/drivers/media/dvb-frontends/drxk_hard.c
+++ b/drivers/media/dvb-frontends/drxk_hard.c
@@ -207,9 +207,9 @@ static inline u32 log10times100(u32 value)
 	return (100L * intlog10(value)) >> 24;
 }
 
-/****************************************************************************/
+/***************************************************************************/
 /* I2C **********************************************************************/
-/****************************************************************************/
+/***************************************************************************/
 
 static int drxk_i2c_lock(struct drxk_state *state)
 {
@@ -3444,7 +3444,7 @@ static int dvbt_ctrl_set_sqi_speed(struct drxk_state *state,
 
 /*============================================================================*/
 
-/**
+/*
 * \brief Activate DVBT specific presets
 * \param demod instance of demodulator.
 * \return DRXStatus_t.
@@ -3484,7 +3484,7 @@ static int dvbt_activate_presets(struct drxk_state *state)
 
 /*============================================================================*/
 
-/**
+/*
 * \brief Initialize channelswitch-independent settings for DVBT.
 * \param demod instance of demodulator.
 * \return DRXStatus_t.
@@ -3696,7 +3696,7 @@ static int set_dvbt_standard(struct drxk_state *state,
 }
 
 /*============================================================================*/
-/**
+/*
 * \brief start dvbt demodulating for channel.
 * \param demod instance of demodulator.
 * \return DRXStatus_t.
@@ -3732,7 +3732,7 @@ static int dvbt_start(struct drxk_state *state)
 
 /*============================================================================*/
 
-/**
+/*
 * \brief Set up dvbt demodulator for channel.
 * \param demod instance of demodulator.
 * \return DRXStatus_t.
@@ -4086,7 +4086,7 @@ static int set_dvbt(struct drxk_state *state, u16 intermediate_freqk_hz,
 
 /*============================================================================*/
 
-/**
+/*
 * \brief Retrieve lock status .
 * \param demod    Pointer to demodulator instance.
 * \param lockStat Pointer to lock status structure.
@@ -4148,7 +4148,7 @@ static int power_up_qam(struct drxk_state *state)
 }
 
 
-/** Power Down QAM */
+/* Power Down QAM */
 static int power_down_qam(struct drxk_state *state)
 {
 	u16 data = 0;
@@ -4186,7 +4186,7 @@ static int power_down_qam(struct drxk_state *state)
 
 /*============================================================================*/
 
-/**
+/*
 * \brief Setup of the QAM Measurement intervals for signal quality
 * \param demod instance of demod.
 * \param modulation current modulation.
@@ -4461,7 +4461,7 @@ static int set_qam16(struct drxk_state *state)
 
 /*============================================================================*/
 
-/**
+/*
 * \brief QAM32 specific setup
 * \param demod instance of demod.
 * \return DRXStatus_t.
@@ -4657,7 +4657,7 @@ static int set_qam32(struct drxk_state *state)
 
 /*============================================================================*/
 
-/**
+/*
 * \brief QAM64 specific setup
 * \param demod instance of demod.
 * \return DRXStatus_t.
@@ -4852,7 +4852,7 @@ static int set_qam64(struct drxk_state *state)
 
 /*============================================================================*/
 
-/**
+/*
 * \brief QAM128 specific setup
 * \param demod: instance of demod.
 * \return DRXStatus_t.
@@ -5049,7 +5049,7 @@ static int set_qam128(struct drxk_state *state)
 
 /*============================================================================*/
 
-/**
+/*
 * \brief QAM256 specific setup
 * \param demod: instance of demod.
 * \return DRXStatus_t.
@@ -5244,7 +5244,7 @@ static int set_qam256(struct drxk_state *state)
 
 
 /*============================================================================*/
-/**
+/*
 * \brief Reset QAM block.
 * \param demod:   instance of demod.
 * \param channel: pointer to channel data.
@@ -5272,7 +5272,7 @@ static int qam_reset_qam(struct drxk_state *state)
 
 /*============================================================================*/
 
-/**
+/*
 * \brief Set QAM symbolrate.
 * \param demod:   instance of demod.
 * \param channel: pointer to channel data.
@@ -5341,7 +5341,7 @@ static int qam_set_symbolrate(struct drxk_state *state)
 
 /*============================================================================*/
 
-/**
+/*
 * \brief Get QAM lock status.
 * \param demod:   instance of demod.
 * \param channel: pointer to channel data.
-- 
2.14.3
