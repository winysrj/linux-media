Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f172.google.com ([209.85.192.172]:33680 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752319AbbDMO2X (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Apr 2015 10:28:23 -0400
From: Cheolhyun Park <pch851130@gmail.com>
To: mchehab@osg.samsung.com, shuah.kh@samsung.com,
	hans.verkuil@cisco.com, benoit.taine@lip6.fr,
	elfring@users.sourceforge.net, pch851130@gmail.com
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [media] drx-j: Misspelled comment corrected
Date: Mon, 13 Apr 2015 14:29:09 +0000
Message-Id: <1428935349-28765-1-git-send-email-pch851130@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Cheolhyun Park <pch851130@gmail.com>
---
 drivers/media/dvb-frontends/drx39xyj/drxj.c | 38 ++++++++++++++---------------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/media/dvb-frontends/drx39xyj/drxj.c b/drivers/media/dvb-frontends/drx39xyj/drxj.c
index 2bfa7a4..61f7603 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drxj.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drxj.c
@@ -210,7 +210,7 @@ DEFINES
 
 /**
 * \def DRXJ_DEF_I2C_ADDR
-* \brief Default I2C addres of a demodulator instance.
+* \brief Default I2C address of a demodulator instance.
 */
 #define DRXJ_DEF_I2C_ADDR (0x52)
 
@@ -336,7 +336,7 @@ DEFINES
  * MICROCODE RELATED DEFINES
  */
 
-/* Magic word for checking correct Endianess of microcode data */
+/* Magic word for checking correct Endianness of microcode data */
 #define DRX_UCODE_MAGIC_WORD         ((((u16)'H')<<8)+((u16)'L'))
 
 /* CRC flag in ucode header, flags field. */
@@ -847,9 +847,9 @@ static struct drx_common_attr drxj_default_comm_attr_g = {
 				   static clockrate is selected */
 	 DRX_MPEG_STR_WIDTH_1	/* MPEG Start width in clock cycles */
 	 },
-	/* Initilisations below can be ommited, they require no user input and
+	/* Initilisations below can be omitted, they require no user input and
 	   are initialy 0, NULL or false. The compiler will initialize them to these
-	   values when ommited.  */
+	   values when omitted.  */
 	false,			/* is_opened */
 
 	/* SCAN */
@@ -1175,7 +1175,7 @@ static u32 log1_times100(u32 x)
 	   Now x has binary point between bit[scale] and bit[scale-1]
 	   and 1.0 <= x < 2.0 */
 
-	/* correction for divison: log(x) = log(x/y)+log(y) */
+	/* correction for division: log(x) = log(x/y)+log(y) */
 	y = k * ((((u32) 1) << scale) * 200);
 
 	/* remove integer part */
@@ -1653,7 +1653,7 @@ static int drxdap_fasi_write_block(struct i2c_device_addr *dev_addr,
 		   sequense will be visible: (1) write address {i2c addr,
 		   4 bytes chip address} (2) write data {i2c addr, 4 bytes data }
 		   (3) write address (4) write data etc...
-		   Addres must be rewriten because HI is reset after data transport and
+		   Address must be rewriten because HI is reset after data transport and
 		   expects an address.
 		 */
 		todo = (block_size < datasize ? block_size : datasize);
@@ -2971,7 +2971,7 @@ ctrl_set_cfg_mpeg_output(struct drx_demod_instance *demod, struct drx_cfg_mpeg_o
 			}	/* ext_attr->standard */
 		}
 
-		if (cfg_data->enable_parallel == true) {	/* MPEG data output is paralel -> clear ipr_mode[0] */
+		if (cfg_data->enable_parallel == true) {	/* MPEG data output is parallel -> clear ipr_mode[0] */
 			fec_oc_reg_ipr_mode &= (~(FEC_OC_IPR_MODE_SERIAL__M));
 		} else {	/* MPEG data output is serial -> set ipr_mode[0] */
 			fec_oc_reg_ipr_mode |= FEC_OC_IPR_MODE_SERIAL__M;
@@ -3157,7 +3157,7 @@ ctrl_set_cfg_mpeg_output(struct drx_demod_instance *demod, struct drx_cfg_mpeg_o
 			pr_err("error %d\n", rc);
 			goto rw_error;
 		}
-		if (cfg_data->enable_parallel == true) {	/* MPEG data output is paralel -> set MD1 to MD7 to output mode */
+		if (cfg_data->enable_parallel == true) {	/* MPEG data output is parallel -> set MD1 to MD7 to output mode */
 			sio_pdr_md_cfg =
 			    MPEG_PARALLEL_OUTPUT_PIN_DRIVE_STRENGTH <<
 			    SIO_PDR_MD0_CFG_DRIVE__B | 0x03 <<
@@ -4320,7 +4320,7 @@ static int adc_synchronization(struct drx_demod_instance *demod)
 	}
 
 	if (count == 1) {
-		/* Try sampling on a diffrent edge */
+		/* Try sampling on a different edge */
 		u16 clk_neg = 0;
 
 		rc = drxj_dap_read_reg16(dev_addr, IQM_AF_CLKNEG__A, &clk_neg, 0);
@@ -6461,7 +6461,7 @@ set_qam_measurement(struct drx_demod_instance *demod,
 		    enum drx_modulation constellation, u32 symbol_rate)
 {
 	struct i2c_device_addr *dev_addr = NULL;	/* device address for I2C writes */
-	struct drxj_data *ext_attr = NULL;	/* Global data container for DRXJ specif data */
+	struct drxj_data *ext_attr = NULL;	/* Global data container for DRXJ specific data */
 	int rc;
 	u32 fec_bits_desired = 0;	/* BER accounting period */
 	u16 fec_rs_plen = 0;	/* defines RS BER measurement period */
@@ -8864,7 +8864,7 @@ qam64auto(struct drx_demod_instance *demod,
 	u32 timeout_ofs = 0;
 	u16 data = 0;
 
-	/* external attributes for storing aquired channel constellation */
+	/* external attributes for storing acquired channel constellation */
 	*lock_status = DRX_NOT_LOCKED;
 	start_time = jiffies_to_msecs(jiffies);
 	lck_state = NO_LOCK;
@@ -9011,7 +9011,7 @@ qam256auto(struct drx_demod_instance *demod,
 	u32 d_locked_time = 0;
 	u32 timeout_ofs = DRXJ_QAM_DEMOD_LOCK_EXT_WAITTIME;
 
-	/* external attributes for storing aquired channel constellation */
+	/* external attributes for storing acquired channel constellation */
 	*lock_status = DRX_NOT_LOCKED;
 	start_time = jiffies_to_msecs(jiffies);
 	lck_state = NO_LOCK;
@@ -9087,7 +9087,7 @@ set_qam_channel(struct drx_demod_instance *demod,
 	enum drx_lock_status lock_status = DRX_NOT_LOCKED;
 	bool auto_flag = false;
 
-	/* external attributes for storing aquired channel constellation */
+	/* external attributes for storing acquired channel constellation */
 	ext_attr = (struct drxj_data *) demod->my_ext_attr;
 
 	/* set QAM channel constellation */
@@ -9431,7 +9431,7 @@ rw_error:
 
 /**
 * \fn int ctrl_get_qam_sig_quality()
-* \brief Retreive QAM signal quality from device.
+* \brief Retrieve QAM signal quality from device.
 * \param devmod Pointer to demodulator instance.
 * \param sig_quality Pointer to signal quality data.
 * \return int.
@@ -10647,7 +10647,7 @@ rw_error:
 
 /**
 * \fn int ctrl_sig_quality()
-* \brief Retreive signal quality form device.
+* \brief Retrieve signal quality form device.
 * \param devmod Pointer to demodulator instance.
 * \param sig_quality Pointer to signal quality data.
 * \return int.
@@ -10763,7 +10763,7 @@ rw_error:
 
 /**
 * \fn int ctrl_lock_status()
-* \brief Retreive lock status .
+* \brief Retrieve lock status .
 * \param dev_addr Pointer to demodulator device address.
 * \param lock_stat Pointer to lock status structure.
 * \return int.
@@ -10815,7 +10815,7 @@ ctrl_lock_status(struct drx_demod_instance *demod, enum drx_lock_status *lock_st
 		return -EIO;
 	}
 
-	/* define the SCU command paramters and execute the command */
+	/* define the SCU command parameters and execute the command */
 	cmd_scu.parameter_len = 0;
 	cmd_scu.result_len = 2;
 	cmd_scu.parameter = NULL;
@@ -11489,7 +11489,7 @@ static int drxj_open(struct drx_demod_instance *demod)
 	}
 
 	/* Stamp driver version number in SCU data RAM in BCD code
-	   Done to enable field application engineers to retreive drxdriver version
+	   Done to enable field application engineers to retrieve drxdriver version
 	   via I2C from SCU RAM
 	 */
 	driver_version = (VERSION_MAJOR / 100) % 10;
@@ -11892,7 +11892,7 @@ release:
 	return rc;
 }
 
-/* caller is expeced to check if lna is supported before enabling */
+/* caller is expected to check if lna is supported before enabling */
 static int drxj_set_lna_state(struct drx_demod_instance *demod, bool state)
 {
 	struct drxuio_cfg uio_cfg;
-- 
1.9.1

