Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49511 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754124AbaCCKIR (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Mar 2014 05:08:17 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 30/79] [media] drx-j: CodingStyle fixups on drxj.c
Date: Mon,  3 Mar 2014 07:06:24 -0300
Message-Id: <1393841233-24840-31-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1393841233-24840-1-git-send-email-m.chehab@samsung.com>
References: <1393841233-24840-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix almost all checkpatch.pl warnings/errors on drxj.c, except for:
- 80 cols whitespacing;
- too many leading tabs;
- a false positive at DRXJ_16TO8() macro.
- static char array declaration should probably be static const char
  as adding "const" would cause warnings.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 .../media/dvb-frontends/drx39xyj/drx_dap_fasi.c    |    6 +-
 drivers/media/dvb-frontends/drx39xyj/drx_driver.c  |   17 +-
 drivers/media/dvb-frontends/drx39xyj/drxj.c        | 1770 ++++++++------------
 3 files changed, 749 insertions(+), 1044 deletions(-)

diff --git a/drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c b/drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c
index 6053878a637c..4671dccfebb9 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c
@@ -284,9 +284,8 @@ static int drxdap_fasi_read_block(struct i2c_device_addr *dev_addr,
 		 * No special action is needed for write chunks here.
 		 */
 		rc = drxbsp_i2c_write_read(dev_addr, bufx, buf, 0, 0, 0);
-		if (rc == DRX_STS_OK) {
+		if (rc == DRX_STS_OK)
 			rc = drxbsp_i2c_write_read(0, 0, 0, dev_addr, todo, data);
-		}
 #else
 		/* In multi master mode, do everything in one RW action */
 		rc = drxbsp_i2c_write_read(dev_addr, bufx, buf, dev_addr, todo,
@@ -338,9 +337,8 @@ static int drxdap_fasi_read_modify_write_reg16(struct i2c_device_addr *dev_addr,
 	}
 
 	rc = drxdap_fasi_write_reg16(dev_addr, waddr, wdata, DRXDAP_FASI_RMW);
-	if (rc == DRX_STS_OK) {
+	if (rc == DRX_STS_OK)
 		rc = drxdap_fasi_read_reg16(dev_addr, raddr, rdata, 0);
-	}
 #endif
 
 	return rc;
diff --git a/drivers/media/dvb-frontends/drx39xyj/drx_driver.c b/drivers/media/dvb-frontends/drx39xyj/drx_driver.c
index d1d9ded65407..4234b7d46d18 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drx_driver.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drx_driver.c
@@ -186,9 +186,8 @@ static void *get_scan_context(struct drx_demod_instance *demod, void *scan_conte
 	common_attr = (struct drx_common_attr *) demod->my_common_attr;
 	scan_context = common_attr->scan_context;
 
-	if (scan_context == NULL) {
+	if (scan_context == NULL)
 		scan_context = (void *)demod;
-	}
 
 	return scan_context;
 }
@@ -482,10 +481,8 @@ ctrl_scan_init(struct drx_demod_instance *demod, struct drx_scan_param *scan_par
 					s32 n = 0;
 
 					n = (min_tuner_freq - first_freq) / step;
-					if (((min_tuner_freq -
-					      first_freq) % step) != 0) {
+					if (((min_tuner_freq - first_freq) % step) != 0)
 						n++;
-					}
 					min_freq = first_freq + n * step;
 				}
 
@@ -495,10 +492,8 @@ ctrl_scan_init(struct drx_demod_instance *demod, struct drx_scan_param *scan_par
 					s32 n = 0;
 
 					n = (last_freq - max_tuner_freq) / step;
-					if (((last_freq -
-					      max_tuner_freq) % step) != 0) {
+					if (((last_freq - max_tuner_freq) % step) != 0)
 						n++;
-					}
 					max_freq = last_freq - n * step;
 				}
 			}
@@ -950,9 +945,8 @@ static u16 u_code_compute_crc(u8 *block_data, u16 nr_words)
 		crc_word |= (u32) u_code_read16(block_data);
 		for (j = 0; j < 16; j++) {
 			crc_word <<= 1;
-			if (carry != 0) {
+			if (carry != 0)
 				crc_word ^= 0x80050000UL;
-			}
 			carry = crc_word & 0x80000000UL;
 		}
 		i++;
@@ -1320,9 +1314,8 @@ int drx_open(struct drx_demod_instance *demod)
 
 	status = (*(demod->my_demod_funct->open_func)) (demod);
 
-	if (status == DRX_STS_OK) {
+	if (status == DRX_STS_OK)
 		demod->my_common_attr->is_opened = true;
-	}
 
 	return status;
 }
diff --git a/drivers/media/dvb-frontends/drx39xyj/drxj.c b/drivers/media/dvb-frontends/drx39xyj/drxj.c
index c5def7d2bcba..f1fe3e3da338 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drxj.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drxj.c
@@ -26,14 +26,9 @@
   CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
   ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
   POSSIBILITY OF SUCH DAMAGE.
-*/
 
-/**
-* \file $Id: drxj.c,v 1.637 2010/01/18 17:21:10 dingtao Exp $
-*
-* \brief DRXJ specific implementation of DRX driver
-*
-* \author Dragan Savic, Milos Nikolic, Mihajlo Katona, Tao Ding, Paul Janssen
+  DRXJ specific implementation of DRX driver
+  authors: Dragan Savic, Milos Nikolic, Mihajlo Katona, Tao Ding, Paul Janssen
 */
 
 /*-----------------------------------------------------------------------------
@@ -487,7 +482,7 @@ DEFINES
 * x -> lowbyte(x), highbyte(x)
 */
 #define DRXJ_16TO8(x) ((u8) (((u16)x) & 0xFF)), \
-			((u8)((((u16)x)>>8)&0xFF))
+		       ((u8)((((u16)x)>>8)&0xFF))
 /**
 * This macro is used to convert byte array to 16 bit register value for block read.
 * Block read speed up I2C traffic between host and demod.
@@ -526,14 +521,6 @@ DEFINES
 			       (std == DRX_STANDARD_ITU_D))
 
 /*-----------------------------------------------------------------------------
-STATIC VARIABLES
-----------------------------------------------------------------------------*/
-int drxj_open(struct drx_demod_instance *demod);
-int drxj_close(struct drx_demod_instance *demod);
-int drxj_ctrl(struct drx_demod_instance *demod,
-		      u32 ctrl, void *ctrl_data);
-
-/*-----------------------------------------------------------------------------
 GLOBAL VARIABLES
 ----------------------------------------------------------------------------*/
 /*
@@ -1054,7 +1041,8 @@ struct drxjeq_stat {
 	u16 eq_mse;
 	u8 eq_mode;
 	u8 eq_ctrl;
-	u8 eq_stat;};
+	u8 eq_stat;
+};
 
 /* HI command */
 struct drxj_hi_cmd {
@@ -1064,7 +1052,8 @@ struct drxj_hi_cmd {
 	u16 param3;
 	u16 param4;
 	u16 param5;
-	u16 param6;};
+	u16 param6;
+};
 
 #ifdef DRXJ_SPLIT_UCODE_UPLOAD
 /*============================================================================*/
@@ -1077,7 +1066,8 @@ struct drxu_code_block_hdr {
 	u16 flags;		/* bit[15..2]=reserved,
 				   bit[1]= compression on/off
 				   bit[0]= CRC on/off */
-	u16 CRC;};
+	u16 CRC;
+};
 #endif /* DRXJ_SPLIT_UCODE_UPLOAD */
 
 /*-----------------------------------------------------------------------------
@@ -1361,7 +1351,7 @@ static u32 log1_times100(u32 x)
 	y /= 108853;		/* (log2(10) << scale) */
 	r = (y >> 1);
 	/* rounding */
-	if (y & ((u32) 1))
+	if (y & ((u32)1))
 		r++;
 
 	return r;
@@ -1396,9 +1386,8 @@ static u32 frac_times1e6(u32 N, u32 D)
 	remainder <<= 4;
 	frac += remainder / D;
 	remainder = remainder % D;
-	if ((remainder * 2) > D) {
+	if ((remainder * 2) > D)
 		frac++;
-	}
 
 	return frac;
 }
@@ -1589,8 +1578,8 @@ static u16 u_code_compute_crc(u8 *block_data, u16 nr_words)
 *        and rounded. For calc used formula: 16*10^(prescaleGain[dB]/20).
 *
 */
-static const u16 nicam_presc_table_val[43] =
-    { 1, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3, 4, 4,
+static const u16 nicam_presc_table_val[43] = {
+	1, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3, 4, 4,
 	5, 5, 6, 6, 7, 8, 9, 10, 11, 13, 14, 16,
 	18, 20, 23, 25, 28, 32, 36, 40, 45,
 	51, 57, 64, 71, 80, 90, 101, 113, 127
@@ -1702,9 +1691,8 @@ static int drxj_dap_rm_write_reg16short(struct i2c_device_addr *dev_addr,
 {
 	int rc;
 
-	if (rdata == NULL) {
+	if (rdata == NULL)
 		return DRX_STS_INVALID_ARG;
-	}
 
 	/* Set RMW flag */
 	rc = drx_dap_fasi_funct_g.write_reg16func(dev_addr,
@@ -1814,9 +1802,8 @@ static int drxj_dap_read_aud_reg16(struct i2c_device_addr *dev_addr,
 							     SIO_HI_RA_RAM_S0_RMWBUF__A,
 							     0x0000, &tr_status);
 
-			if (stat != DRX_STS_OK) {
+			if (stat != DRX_STS_OK)
 				break;
-			}
 
 			current_timer = drxbsp_hst_clock();
 			delta_timer = current_timer - start_timer;
@@ -1840,9 +1827,8 @@ static int drxj_dap_read_aud_reg16(struct i2c_device_addr *dev_addr,
 			stat = drxj_dap_read_reg16(dev_addr,
 						  AUD_TOP_TR_CTR__A,
 						  &tr_status, 0x0000);
-			if (stat != DRX_STS_OK) {
+			if (stat != DRX_STS_OK)
 				break;
-			}
 
 			current_timer = drxbsp_hst_clock();
 			delta_timer = current_timer - start_timer;
@@ -1853,15 +1839,12 @@ static int drxj_dap_read_aud_reg16(struct i2c_device_addr *dev_addr,
 		}		/* while ( ... ) */
 	}
 
-	/* if { stat == DRX_STS_OK ) */
 	/* Read value */
-	if (stat == DRX_STS_OK) {
+	if (stat == DRX_STS_OK)
 		stat = drxj_dap_read_modify_write_reg16(dev_addr,
 						     AUD_TOP_TR_RD_REG__A,
 						     SIO_HI_RA_RAM_S0_RMWBUF__A,
 						     0x0000, data);
-	}
-	/* if { stat == DRX_STS_OK ) */
 	return stat;
 }
 
@@ -1874,16 +1857,14 @@ static int drxj_dap_read_reg16(struct i2c_device_addr *dev_addr,
 	int stat = DRX_STS_ERROR;
 
 	/* Check param */
-	if ((dev_addr == NULL) || (data == NULL)) {
+	if ((dev_addr == NULL) || (data == NULL))
 		return DRX_STS_INVALID_ARG;
-	}
 
-	if (is_handled_by_aud_tr_if(addr)) {
+	if (is_handled_by_aud_tr_if(addr))
 		stat = drxj_dap_read_aud_reg16(dev_addr, addr, data);
-	} else {
+	else
 		stat = drx_dap_fasi_funct_g.read_reg16func(dev_addr,
-						       addr, data, flags);
-	}
+							   addr, data, flags);
 
 	return stat;
 }
@@ -1956,9 +1937,8 @@ static int drxj_dap_write_aud_reg16(struct i2c_device_addr *dev_addr,
 							     addr,
 							     SIO_HI_RA_RAM_S0_RMWBUF__A,
 							     data, &tr_status);
-			if (stat != DRX_STS_OK) {
+			if (stat != DRX_STS_OK)
 				break;
-			}
 
 			current_timer = drxbsp_hst_clock();
 			delta_timer = current_timer - start_timer;
@@ -1986,16 +1966,14 @@ static int drxj_dap_write_reg16(struct i2c_device_addr *dev_addr,
 	int stat = DRX_STS_ERROR;
 
 	/* Check param */
-	if (dev_addr == NULL) {
+	if (dev_addr == NULL)
 		return DRX_STS_INVALID_ARG;
-	}
 
-	if (is_handled_by_aud_tr_if(addr)) {
+	if (is_handled_by_aud_tr_if(addr))
 		stat = drxj_dap_write_aud_reg16(dev_addr, addr, data);
-	} else {
+	else
 		stat = drx_dap_fasi_funct_g.write_reg16func(dev_addr,
-							addr, data, flags);
-	}
+							    addr, data, flags);
 
 	return stat;
 }
@@ -2045,11 +2023,8 @@ int drxj_dap_atomic_read_write_block(struct i2c_device_addr *dev_addr,
 	u16 i = 0;
 
 	/* Parameter check */
-	if ((data == NULL) ||
-	    (dev_addr == NULL) || ((datasize % 2) != 0) || ((datasize / 2) > 8)
-	    ) {
+	if (!data || !dev_addr || ((datasize % 2)) || ((datasize / 2) > 8))
 		return DRX_STS_INVALID_ARG;
-	}
 
 	/* Set up HI parameters to read or write n bytes */
 	hi_cmd.cmd = SIO_HI_RA_RAM_CMD_ATOMIC_COPY;
@@ -2059,11 +2034,10 @@ int drxj_dap_atomic_read_write_block(struct i2c_device_addr *dev_addr,
 	hi_cmd.param2 =
 	    (u16) DRXDAP_FASI_ADDR2OFFSET(DRXJ_HI_ATOMIC_BUF_START);
 	hi_cmd.param3 = (u16) ((datasize / 2) - 1);
-	if (!read_flag) {
+	if (!read_flag)
 		hi_cmd.param3 |= DRXJ_HI_ATOMIC_WRITE;
-	} else {
+	else
 		hi_cmd.param3 |= DRXJ_HI_ATOMIC_READ;
-	}
 	hi_cmd.param4 = (u16) ((DRXDAP_FASI_ADDR2BLOCK(addr) << 6) +
 				DRXDAP_FASI_ADDR2BANK(addr));
 	hi_cmd.param5 = (u16) DRXDAP_FASI_ADDR2OFFSET(addr);
@@ -2119,12 +2093,11 @@ int drxj_dap_atomic_read_reg32(struct i2c_device_addr *dev_addr,
 	int rc = DRX_STS_ERROR;
 	u32 word = 0;
 
-	if (!data) {
+	if (!data)
 		return DRX_STS_INVALID_ARG;
-	}
 
 	rc = drxj_dap_atomic_read_write_block(dev_addr, addr,
-					   sizeof(*data), buf, true);
+					      sizeof(*data), buf, true);
 
 	if (rc < 0)
 		return 0;
@@ -2270,10 +2243,8 @@ hi_command(struct i2c_device_addr *dev_addr, const struct drxj_hi_cmd *cmd, u16
 		goto rw_error;
 	}
 
-	if ((cmd->cmd) == SIO_HI_RA_RAM_CMD_RESET) {
-		/* Allow for HI to reset */
+	if ((cmd->cmd) == SIO_HI_RA_RAM_CMD_RESET)
 		drxbsp_hst_sleep(1);
-	}
 
 	/* Detect power down to ommit reading result */
 	powerdown_cmd = (bool) ((cmd->cmd == SIO_HI_RA_RAM_CMD_CONFIG) &&
@@ -2285,6 +2256,7 @@ hi_command(struct i2c_device_addr *dev_addr, const struct drxj_hi_cmd *cmd, u16
 		do {
 			nr_retries++;
 			if (nr_retries > DRXJ_MAX_RETRIES) {
+				pr_err("timeout\n");
 				goto rw_error;
 			}
 
@@ -2345,9 +2317,8 @@ static int init_hi(const struct drx_demod_instance *demod)
 	ext_attr->hi_cfg_timing_div =
 	    (u16) ((common_attr->sys_clock_freq / 1000) * HI_I2C_DELAY) / 1000;
 	/* Clipping */
-	if ((ext_attr->hi_cfg_timing_div) > SIO_HI_RA_RAM_PAR_2_CFG_DIV__M) {
+	if ((ext_attr->hi_cfg_timing_div) > SIO_HI_RA_RAM_PAR_2_CFG_DIV__M)
 		ext_attr->hi_cfg_timing_div = SIO_HI_RA_RAM_PAR_2_CFG_DIV__M;
-	}
 	/* Bridge delay, uses oscilator clock */
 	/* Delay = ( delay (nano seconds) * oscclk (kHz) )/ 1000 */
 	/* SDA brdige delay */
@@ -2355,9 +2326,8 @@ static int init_hi(const struct drx_demod_instance *demod)
 	    (u16) ((common_attr->osc_clock_freq / 1000) * HI_I2C_BRIDGE_DELAY) /
 	    1000;
 	/* Clipping */
-	if ((ext_attr->hi_cfg_bridge_delay) > SIO_HI_RA_RAM_PAR_3_CFG_DBL_SDA__M) {
+	if ((ext_attr->hi_cfg_bridge_delay) > SIO_HI_RA_RAM_PAR_3_CFG_DBL_SDA__M)
 		ext_attr->hi_cfg_bridge_delay = SIO_HI_RA_RAM_PAR_3_CFG_DBL_SDA__M;
-	}
 	/* SCL bridge delay, same as SDA for now */
 	ext_attr->hi_cfg_bridge_delay += ((ext_attr->hi_cfg_bridge_delay) <<
 				      SIO_HI_RA_RAM_PAR_3_CFG_DBL_SCL__B);
@@ -2643,9 +2613,8 @@ static int power_up_device(struct drx_demod_instance *demod)
 	/* Need some recovery time .... */
 	drxbsp_hst_sleep(10);
 
-	if (retry_count == DRXJ_MAX_RETRIES_POWERUP) {
+	if (retry_count == DRXJ_MAX_RETRIES_POWERUP)
 		return DRX_STS_ERROR;
-	}
 
 	return DRX_STS_OK;
 }
@@ -2685,9 +2654,8 @@ ctrl_set_cfg_mpeg_output(struct drx_demod_instance *demod, struct drx_cfg_mpeg_o
 	    FEC_OC_IPR_INVERT_MD1__M | FEC_OC_IPR_INVERT_MD0__M;
 
 	/* check arguments */
-	if ((demod == NULL) || (cfg_data == NULL)) {
+	if ((demod == NULL) || (cfg_data == NULL))
 		return DRX_STS_INVALID_ARG;
-	}
 
 	dev_addr = demod->my_i2c_dev_addr;
 	ext_attr = (struct drxj_data *) demod->my_ext_attr;
@@ -2939,35 +2907,30 @@ ctrl_set_cfg_mpeg_output(struct drx_demod_instance *demod, struct drx_cfg_mpeg_o
 		}
 
 		/* Control slective inversion of output bits */
-		if (cfg_data->invert_data == true) {
+		if (cfg_data->invert_data == true)
 			fec_oc_reg_ipr_invert |= invert_data_mask;
-		} else {
+		else
 			fec_oc_reg_ipr_invert &= (~(invert_data_mask));
-		}
 
-		if (cfg_data->invert_err == true) {
+		if (cfg_data->invert_err == true)
 			fec_oc_reg_ipr_invert |= FEC_OC_IPR_INVERT_MERR__M;
-		} else {
+		else
 			fec_oc_reg_ipr_invert &= (~(FEC_OC_IPR_INVERT_MERR__M));
-		}
 
-		if (cfg_data->invert_str == true) {
+		if (cfg_data->invert_str == true)
 			fec_oc_reg_ipr_invert |= FEC_OC_IPR_INVERT_MSTRT__M;
-		} else {
+		else
 			fec_oc_reg_ipr_invert &= (~(FEC_OC_IPR_INVERT_MSTRT__M));
-		}
 
-		if (cfg_data->invert_val == true) {
+		if (cfg_data->invert_val == true)
 			fec_oc_reg_ipr_invert |= FEC_OC_IPR_INVERT_MVAL__M;
-		} else {
+		else
 			fec_oc_reg_ipr_invert &= (~(FEC_OC_IPR_INVERT_MVAL__M));
-		}
 
-		if (cfg_data->invert_clk == true) {
+		if (cfg_data->invert_clk == true)
 			fec_oc_reg_ipr_invert |= FEC_OC_IPR_INVERT_MCLK__M;
-		} else {
+		else
 			fec_oc_reg_ipr_invert &= (~(FEC_OC_IPR_INVERT_MCLK__M));
-		}
 
 		if (cfg_data->static_clk == true) {	/* Static mode */
 			u32 dto_rate = 0;
@@ -2980,9 +2943,8 @@ ctrl_set_cfg_mpeg_output(struct drx_demod_instance *demod, struct drx_cfg_mpeg_o
 			switch (ext_attr->standard) {
 			case DRX_STANDARD_8VSB:
 				fec_oc_dto_period = 4;
-				if (cfg_data->insert_rs_byte == true) {
+				if (cfg_data->insert_rs_byte == true)
 					fec_oc_dto_burst_len = 208;
-				}
 				break;
 			case DRX_STANDARD_ITU_A:
 				{
@@ -3001,15 +2963,13 @@ ctrl_set_cfg_mpeg_output(struct drx_demod_instance *demod, struct drx_cfg_mpeg_o
 				break;
 			case DRX_STANDARD_ITU_B:
 				fec_oc_dto_period = 1;
-				if (cfg_data->insert_rs_byte == true) {
+				if (cfg_data->insert_rs_byte == true)
 					fec_oc_dto_burst_len = 128;
-				}
 				break;
 			case DRX_STANDARD_ITU_C:
 				fec_oc_dto_period = 1;
-				if (cfg_data->insert_rs_byte == true) {
+				if (cfg_data->insert_rs_byte == true)
 					fec_oc_dto_burst_len = 204;
-				}
 				break;
 			default:
 				return DRX_STS_ERROR;
@@ -3045,10 +3005,8 @@ ctrl_set_cfg_mpeg_output(struct drx_demod_instance *demod, struct drx_cfg_mpeg_o
 				pr_err("error %d\n", rc);
 				goto rw_error;
 			}
-			if (ext_attr->mpeg_output_clock_rate !=
-			    DRXJ_MPEGOUTPUT_CLOCK_RATE_AUTO)
-				fec_oc_dto_period =
-				    ext_attr->mpeg_output_clock_rate - 1;
+			if (ext_attr->mpeg_output_clock_rate != DRXJ_MPEGOUTPUT_CLOCK_RATE_AUTO)
+				fec_oc_dto_period = ext_attr->mpeg_output_clock_rate - 1;
 			rc = DRXJ_DAP.write_reg16func(dev_addr, FEC_OC_DTO_PERIOD__A, fec_oc_dto_period, 0);
 			if (rc != DRX_STS_OK) {
 				pr_err("error %d\n", rc);
@@ -3343,9 +3301,9 @@ ctrl_get_cfg_mpeg_output(struct drx_demod_instance *demod, struct drx_cfg_mpeg_o
 	u32 data64hi = 0;
 	u32 data64lo = 0;
 
-	if (cfg_data == NULL) {
+	if (cfg_data == NULL)
 		return DRX_STS_INVALID_ARG;
-	}
+
 	dev_addr = demod->my_i2c_dev_addr;
 	common_attr = demod->my_common_attr;
 
@@ -3491,10 +3449,8 @@ static int bit_reverse_mpeg_output(struct drx_demod_instance *demod)
 	/* reset to default (normal bit order) */
 	fec_oc_ipr_mode &= (~FEC_OC_IPR_MODE_REVERSE_ORDER__M);
 
-	if (ext_attr->bit_reverse_mpeg_outout) {
-		/* reverse bit order */
+	if (ext_attr->bit_reverse_mpeg_outout)
 		fec_oc_ipr_mode |= FEC_OC_IPR_MODE_REVERSE_ORDER__M;
-	}
 
 	rc = DRXJ_DAP.write_reg16func(dev_addr, FEC_OC_IPR_MODE__A, fec_oc_ipr_mode, 0);
 	if (rc != DRX_STS_OK) {
@@ -3569,9 +3525,8 @@ static int set_mpeg_start_width(struct drx_demod_instance *demod)
 			goto rw_error;
 		}
 		fec_oc_comm_mb &= ~FEC_OC_COMM_MB_CTL_ON;
-		if (ext_attr->mpeg_start_width == DRXJ_MPEG_START_WIDTH_8CLKCYC) {
+		if (ext_attr->mpeg_start_width == DRXJ_MPEG_START_WIDTH_8CLKCYC)
 			fec_oc_comm_mb |= FEC_OC_COMM_MB_CTL_ON;
-		}
 		rc = DRXJ_DAP.write_reg16func(dev_addr, FEC_OC_COMM_MB__A, fec_oc_comm_mb, 0);
 		if (rc != DRX_STS_OK) {
 			pr_err("error %d\n", rc);
@@ -3600,14 +3555,13 @@ static int
 ctrl_set_cfg_mpeg_output_misc(struct drx_demod_instance *demod,
 			      struct drxj_cfg_mpeg_output_misc *cfg_data)
 {
-	struct drxj_data *ext_attr = (struct drxj_data *) (NULL);
+	struct drxj_data *ext_attr = NULL;
 	int rc;
 
-	if (cfg_data == NULL) {
+	if (cfg_data == NULL)
 		return DRX_STS_INVALID_ARG;
-	}
 
-	ext_attr = (struct drxj_data *) demod->my_ext_attr;
+	ext_attr = demod->my_ext_attr;
 
 	/*
 	   Set disable TEI bit handling flag.
@@ -3667,13 +3621,12 @@ static int
 ctrl_get_cfg_mpeg_output_misc(struct drx_demod_instance *demod,
 			      struct drxj_cfg_mpeg_output_misc *cfg_data)
 {
-	struct drxj_data *ext_attr = (struct drxj_data *) (NULL);
+	struct drxj_data *ext_attr = NULL;
 	int rc;
 	u16 data = 0;
 
-	if (cfg_data == NULL) {
+	if (cfg_data == NULL)
 		return DRX_STS_INVALID_ARG;
-	}
 
 	ext_attr = (struct drxj_data *) demod->my_ext_attr;
 	cfg_data->disable_tei_handling = ext_attr->disable_te_ihandling;
@@ -3762,9 +3715,9 @@ static int ctrl_set_uio_cfg(struct drx_demod_instance *demod, struct drxuio_cfg
 	struct drxj_data *ext_attr = (struct drxj_data *) (NULL);
 	int rc;
 
-	if ((uio_cfg == NULL) || (demod == NULL)) {
+	if ((uio_cfg == NULL) || (demod == NULL))
 		return DRX_STS_INVALID_ARG;
-	}
+
 	ext_attr = (struct drxj_data *) demod->my_ext_attr;
 
 	/*  Write magic word to enable pdr reg write               */
@@ -3914,17 +3867,14 @@ static int ctrl_getuio_cfg(struct drx_demod_instance *demod, struct drxuio_cfg *
 	uio_available[DRX_UIO3] = &ext_attr->has_gpio;
 	uio_available[DRX_UIO4] = &ext_attr->has_irqn;
 
-	if (uio_cfg == NULL) {
+	if (uio_cfg == NULL)
 		return DRX_STS_INVALID_ARG;
-	}
 
-	if ((uio_cfg->uio > DRX_UIO4) || (uio_cfg->uio < DRX_UIO1)) {
+	if ((uio_cfg->uio > DRX_UIO4) || (uio_cfg->uio < DRX_UIO1))
 		return DRX_STS_INVALID_ARG;
-	}
 
-	if (!*uio_available[uio_cfg->uio]) {
+	if (!*uio_available[uio_cfg->uio])
 		return DRX_STS_ERROR;
-	}
 
 	uio_cfg->mode = *uio_mode[uio_cfg->uio];
 
@@ -3946,9 +3896,8 @@ ctrl_uio_write(struct drx_demod_instance *demod, struct drxuio_data *uio_data)
 	u16 pin_cfg_value = 0;
 	u16 value = 0;
 
-	if ((uio_data == NULL) || (demod == NULL)) {
+	if ((uio_data == NULL) || (demod == NULL))
 		return DRX_STS_INVALID_ARG;
-	}
 
 	ext_attr = (struct drxj_data *) demod->my_ext_attr;
 
@@ -3987,11 +3936,11 @@ ctrl_uio_write(struct drx_demod_instance *demod, struct drxuio_data *uio_data)
 			pr_err("error %d\n", rc);
 			goto rw_error;
 		}
-		if (uio_data->value == false) {
+		if (!uio_data->value)
 			value &= 0x7FFF;	/* write zero to 15th bit - 1st UIO */
-		} else {
+		else
 			value |= 0x8000;	/* write one to 15th bit - 1st UIO */
-		}
+
 		/* write back to io data output register */
 		rc = DRXJ_DAP.write_reg16func(demod->my_i2c_dev_addr, SIO_PDR_UIO_OUT_LO__A, value, 0);
 		if (rc != DRX_STS_OK) {
@@ -4004,9 +3953,9 @@ ctrl_uio_write(struct drx_demod_instance *demod, struct drxuio_data *uio_data)
 		/* DRX_UIO2: SMA_RX UIO-2 */
 		if (!ext_attr->has_smarx)
 			return DRX_STS_ERROR;
-		if (ext_attr->uio_sma_rx_mode != DRX_UIO_MODE_READWRITE) {
+		if (ext_attr->uio_sma_rx_mode != DRX_UIO_MODE_READWRITE)
 			return DRX_STS_ERROR;
-		}
+
 		pin_cfg_value = 0;
 		/* io_pad_cfg register (8 bit reg.) MSB bit is 1 (default value) */
 		pin_cfg_value |= 0x0113;
@@ -4026,11 +3975,11 @@ ctrl_uio_write(struct drx_demod_instance *demod, struct drxuio_data *uio_data)
 			pr_err("error %d\n", rc);
 			goto rw_error;
 		}
-		if (uio_data->value == false) {
+		if (!uio_data->value)
 			value &= 0xBFFF;	/* write zero to 14th bit - 2nd UIO */
-		} else {
+		else
 			value |= 0x4000;	/* write one to 14th bit - 2nd UIO */
-		}
+
 		/* write back to io data output register */
 		rc = DRXJ_DAP.write_reg16func(demod->my_i2c_dev_addr, SIO_PDR_UIO_OUT_LO__A, value, 0);
 		if (rc != DRX_STS_OK) {
@@ -4043,9 +3992,9 @@ ctrl_uio_write(struct drx_demod_instance *demod, struct drxuio_data *uio_data)
 		/* DRX_UIO3: ASEL UIO-3 */
 		if (!ext_attr->has_gpio)
 			return DRX_STS_ERROR;
-		if (ext_attr->uio_gpio_mode != DRX_UIO_MODE_READWRITE) {
+		if (ext_attr->uio_gpio_mode != DRX_UIO_MODE_READWRITE)
 			return DRX_STS_ERROR;
-		}
+
 		pin_cfg_value = 0;
 		/* io_pad_cfg register (8 bit reg.) MSB bit is 1 (default value) */
 		pin_cfg_value |= 0x0113;
@@ -4065,11 +4014,11 @@ ctrl_uio_write(struct drx_demod_instance *demod, struct drxuio_data *uio_data)
 			pr_err("error %d\n", rc);
 			goto rw_error;
 		}
-		if (uio_data->value == false) {
+		if (!uio_data->value)
 			value &= 0xFFFB;	/* write zero to 2nd bit - 3rd UIO */
-		} else {
+		else
 			value |= 0x0004;	/* write one to 2nd bit - 3rd UIO */
-		}
+
 		/* write back to io data output register */
 		rc = DRXJ_DAP.write_reg16func(demod->my_i2c_dev_addr, SIO_PDR_UIO_OUT_HI__A, value, 0);
 		if (rc != DRX_STS_OK) {
@@ -4083,9 +4032,9 @@ ctrl_uio_write(struct drx_demod_instance *demod, struct drxuio_data *uio_data)
 		if (!ext_attr->has_irqn)
 			return DRX_STS_ERROR;
 
-		if (ext_attr->uio_irqn_mode != DRX_UIO_MODE_READWRITE) {
+		if (ext_attr->uio_irqn_mode != DRX_UIO_MODE_READWRITE)
 			return DRX_STS_ERROR;
-		}
+
 		pin_cfg_value = 0;
 		/* io_pad_cfg register (8 bit reg.) MSB bit is 1 (default value) */
 		pin_cfg_value |= 0x0113;
@@ -4105,11 +4054,11 @@ ctrl_uio_write(struct drx_demod_instance *demod, struct drxuio_data *uio_data)
 			pr_err("error %d\n", rc);
 			goto rw_error;
 		}
-		if (uio_data->value == false) {
+		if (uio_data->value == false)
 			value &= 0xEFFF;	/* write zero to 12th bit - 4th UIO */
-		} else {
+		else
 			value |= 0x1000;	/* write one to 12th bit - 4th UIO */
-		}
+
 		/* write back to io data output register */
 		rc = DRXJ_DAP.write_reg16func(demod->my_i2c_dev_addr, SIO_PDR_UIO_OUT_LO__A, value, 0);
 		if (rc != DRX_STS_OK) {
@@ -4148,9 +4097,8 @@ static int ctrl_uio_read(struct drx_demod_instance *demod, struct drxuio_data *u
 	u16 pin_cfg_value = 0;
 	u16 value = 0;
 
-	if ((uio_data == NULL) || (demod == NULL)) {
+	if ((uio_data == NULL) || (demod == NULL))
 		return DRX_STS_INVALID_ARG;
-	}
 
 	ext_attr = (struct drxj_data *) demod->my_ext_attr;
 
@@ -4167,9 +4115,9 @@ static int ctrl_uio_read(struct drx_demod_instance *demod, struct drxuio_data *u
 		if (!ext_attr->has_smatx)
 			return DRX_STS_ERROR;
 
-		if (ext_attr->uio_sma_tx_mode != DRX_UIO_MODE_READWRITE) {
+		if (ext_attr->uio_sma_tx_mode != DRX_UIO_MODE_READWRITE)
 			return DRX_STS_ERROR;
-		}
+
 		pin_cfg_value = 0;
 		/* io_pad_cfg register (8 bit reg.) MSB bit is 1 (default value) */
 		pin_cfg_value |= 0x0110;
@@ -4200,9 +4148,9 @@ static int ctrl_uio_read(struct drx_demod_instance *demod, struct drxuio_data *u
 		if (!ext_attr->has_smarx)
 			return DRX_STS_ERROR;
 
-		if (ext_attr->uio_sma_rx_mode != DRX_UIO_MODE_READWRITE) {
+		if (ext_attr->uio_sma_rx_mode != DRX_UIO_MODE_READWRITE)
 			return DRX_STS_ERROR;
-		}
+
 		pin_cfg_value = 0;
 		/* io_pad_cfg register (8 bit reg.) MSB bit is 1 (default value) */
 		pin_cfg_value |= 0x0110;
@@ -4222,11 +4170,11 @@ static int ctrl_uio_read(struct drx_demod_instance *demod, struct drxuio_data *u
 			goto rw_error;
 		}
 
-		if ((value & 0x4000) != 0) {	/* check 14th bit - 2nd UIO */
+		if ((value & 0x4000) != 0)	/* check 14th bit - 2nd UIO */
 			uio_data->value = true;
-		} else {
+		else
 			uio_data->value = false;
-		}
+
 		break;
    /*=====================================================================*/
 	case DRX_UIO3:
@@ -4234,9 +4182,9 @@ static int ctrl_uio_read(struct drx_demod_instance *demod, struct drxuio_data *u
 		if (!ext_attr->has_gpio)
 			return DRX_STS_ERROR;
 
-		if (ext_attr->uio_gpio_mode != DRX_UIO_MODE_READWRITE) {
+		if (ext_attr->uio_gpio_mode != DRX_UIO_MODE_READWRITE)
 			return DRX_STS_ERROR;
-		}
+
 		pin_cfg_value = 0;
 		/* io_pad_cfg register (8 bit reg.) MSB bit is 1 (default value) */
 		pin_cfg_value |= 0x0110;
@@ -4268,9 +4216,9 @@ static int ctrl_uio_read(struct drx_demod_instance *demod, struct drxuio_data *u
 		if (!ext_attr->has_irqn)
 			return DRX_STS_ERROR;
 
-		if (ext_attr->uio_irqn_mode != DRX_UIO_MODE_READWRITE) {
+		if (ext_attr->uio_irqn_mode != DRX_UIO_MODE_READWRITE)
 			return DRX_STS_ERROR;
-		}
+
 		pin_cfg_value = 0;
 		/* io_pad_cfg register (8 bit reg.) MSB bit is 1 (default value) */
 		pin_cfg_value |= 0x0110;
@@ -4290,11 +4238,11 @@ static int ctrl_uio_read(struct drx_demod_instance *demod, struct drxuio_data *u
 			pr_err("error %d\n", rc);
 			goto rw_error;
 		}
-		if ((value & 0x1000) != 0) {	/* check 12th bit - 4th UIO */
+		if ((value & 0x1000) != 0)	/* check 12th bit - 4th UIO */
 			uio_data->value = true;
-		} else {
+		else
 			uio_data->value = false;
-		}
+
 		break;
       /*====================================================================*/
 	default:
@@ -4335,17 +4283,15 @@ ctrl_i2c_bridge(struct drx_demod_instance *demod, bool *bridge_closed)
 	u16 result = 0;
 
 	/* check arguments */
-	if (bridge_closed == NULL) {
+	if (bridge_closed == NULL)
 		return DRX_STS_INVALID_ARG;
-	}
 
 	hi_cmd.cmd = SIO_HI_RA_RAM_CMD_BRDCTRL;
 	hi_cmd.param1 = SIO_HI_RA_RAM_PAR_1_PAR1_SEC_KEY;
-	if (*bridge_closed) {
+	if (*bridge_closed)
 		hi_cmd.param2 = SIO_HI_RA_RAM_PAR_2_BRD_CFG_CLOSED;
-	} else {
+	else
 		hi_cmd.param2 = SIO_HI_RA_RAM_PAR_2_BRD_CFG_OPEN;
-	}
 
 	return hi_command(demod->my_i2c_dev_addr, &hi_cmd, &result);
 }
@@ -4387,22 +4333,19 @@ static int smart_ant_init(struct drx_demod_instance *demod)
 		pr_err("error %d\n", rc);
 		goto rw_error;
 	}
-	if (ext_attr->smart_ant_inverted){
-
-			rc = DRXJ_DAP.write_reg16func(dev_addr, SIO_SA_TX_COMMAND__A, (data | SIO_SA_TX_COMMAND_TX_INVERT__M) | SIO_SA_TX_COMMAND_TX_ENABLE__M, 0);
-			if (rc != DRX_STS_OK) {
-				pr_err("error %d\n", rc);
-				goto rw_error;
-			}
+	if (ext_attr->smart_ant_inverted) {
+		rc = DRXJ_DAP.write_reg16func(dev_addr, SIO_SA_TX_COMMAND__A, (data | SIO_SA_TX_COMMAND_TX_INVERT__M) | SIO_SA_TX_COMMAND_TX_ENABLE__M, 0);
+		if (rc != DRX_STS_OK) {
+			pr_err("error %d\n", rc);
+			goto rw_error;
 		}
-	else
-		{
-			rc = DRXJ_DAP.write_reg16func(dev_addr, SIO_SA_TX_COMMAND__A, (data & (~SIO_SA_TX_COMMAND_TX_INVERT__M)) | SIO_SA_TX_COMMAND_TX_ENABLE__M, 0);
-			if (rc != DRX_STS_OK) {
-				pr_err("error %d\n", rc);
-				goto rw_error;
-			}
+	} else {
+		rc = DRXJ_DAP.write_reg16func(dev_addr, SIO_SA_TX_COMMAND__A, (data & (~SIO_SA_TX_COMMAND_TX_INVERT__M)) | SIO_SA_TX_COMMAND_TX_ENABLE__M, 0);
+		if (rc != DRX_STS_OK) {
+			pr_err("error %d\n", rc);
+			goto rw_error;
 		}
+	}
 
 	/* config SMA_TX pin to smart antenna mode */
 	rc = ctrl_set_uio_cfg(demod, &uio_cfg);
@@ -4454,9 +4397,8 @@ ctrl_set_cfg_smart_ant(struct drx_demod_instance *demod, struct drxj_cfg_smart_a
 	ext_attr = (struct drxj_data *) demod->my_ext_attr;
 
 	/* check arguments */
-	if (smart_ant == NULL) {
+	if (smart_ant == NULL)
 		return DRX_STS_INVALID_ARG;
-	}
 
 	if (bit_inverted != ext_attr->smart_ant_inverted
 	    || ext_attr->uio_sma_tx_mode != DRX_UIO_MODE_FIRMWARE_SMA) {
@@ -4489,13 +4431,10 @@ ctrl_set_cfg_smart_ant(struct drx_demod_instance *demod, struct drxj_cfg_smart_a
 				pr_err("error %d\n", rc);
 				goto rw_error;
 			}
-		} while ((data & SIO_SA_TX_STATUS_BUSY__M)
-			 && ((drxbsp_hst_clock() - start_time) <
-			     DRXJ_MAX_WAITTIME));
+		} while ((data & SIO_SA_TX_STATUS_BUSY__M) && ((drxbsp_hst_clock() - start_time) < DRXJ_MAX_WAITTIME));
 
-		if (data & SIO_SA_TX_STATUS_BUSY__M) {
+		if (data & SIO_SA_TX_STATUS_BUSY__M)
 			return DRX_STS_ERROR;
-		}
 
 		/* write to smart antenna configuration register */
 		rc = DRXJ_DAP.write_reg16func(dev_addr, SIO_SA_TX_DATA0__A, 0x9200 | ((smart_ant->ctrl_data & 0x0001) << 8) | ((smart_ant->ctrl_data & 0x0002) << 10) | ((smart_ant->ctrl_data & 0x0004) << 12), 0);
@@ -4564,9 +4503,8 @@ static int scu_command(struct i2c_device_addr *dev_addr, struct drxjscu_cmd *cmd
 		pr_err("error %d\n", rc);
 		goto rw_error;
 	}
-	if (cur_cmd != DRX_SCU_READY) {
+	if (cur_cmd != DRX_SCU_READY)
 		return DRX_STS_ERROR;
-	}
 
 	switch (cmd->parameter_len) {
 	case 5:
@@ -4623,9 +4561,8 @@ static int scu_command(struct i2c_device_addr *dev_addr, struct drxjscu_cmd *cmd
 	} while (!(cur_cmd == DRX_SCU_READY)
 		 && ((drxbsp_hst_clock() - start_time) < DRXJ_MAX_WAITTIME));
 
-	if (cur_cmd != DRX_SCU_READY) {
+	if (cur_cmd != DRX_SCU_READY)
 		return DRX_STS_ERROR;
-	}
 
 	/* read results */
 	if ((cmd->result_len > 0) && (cmd->result != NULL)) {
@@ -4676,11 +4613,10 @@ static int scu_command(struct i2c_device_addr *dev_addr, struct drxjscu_cmd *cmd
 			return DRX_STS_INVALID_ARG;
 		}
 		/* here it is assumed that negative means error, and positive no error */
-		else if (err < 0) {
+		else if (err < 0)
 			return DRX_STS_ERROR;
-		} else {
+		else
 			return DRX_STS_OK;
-		}
 	}
 
 	return DRX_STS_OK;
@@ -4712,11 +4648,8 @@ int drxj_dap_scu_atomic_read_write_block(struct i2c_device_addr *dev_addr, u32 a
 	u16 cmd_result[15];
 
 	/* Parameter check */
-	if ((data == NULL) ||
-	    (dev_addr == NULL) || ((datasize % 2) != 0) || ((datasize / 2) > 16)
-	    ) {
+	if (!data || !dev_addr || (datasize % 2) || ((datasize / 2) > 16))
 		return DRX_STS_INVALID_ARG;
-	}
 
 	set_param_parameters[1] = (u16) ADDR_AT_SCU_SPACE(addr);
 	if (read_flag) {		/* read */
@@ -4777,9 +4710,8 @@ int drxj_dap_scu_atomic_read_reg16(struct i2c_device_addr *dev_addr,
 	int rc = DRX_STS_ERROR;
 	u16 word = 0;
 
-	if (!data) {
+	if (!data)
 		return DRX_STS_INVALID_ARG;
-	}
 
 	rc = drxj_dap_scu_atomic_read_write_block(dev_addr, addr, 2, buf, true);
 	if (rc < 0)
@@ -4862,25 +4794,22 @@ static int adc_sync_measurement(struct drx_demod_instance *demod, u16 *count)
 		pr_err("error %d\n", rc);
 		goto rw_error;
 	}
-	if (data == 127) {
+	if (data == 127)
 		*count = *count + 1;
-	}
 	rc = DRXJ_DAP.read_reg16func(dev_addr, IQM_AF_PHASE1__A, &data, 0);
 	if (rc != DRX_STS_OK) {
 		pr_err("error %d\n", rc);
 		goto rw_error;
 	}
-	if (data == 127) {
+	if (data == 127)
 		*count = *count + 1;
-	}
 	rc = DRXJ_DAP.read_reg16func(dev_addr, IQM_AF_PHASE2__A, &data, 0);
 	if (rc != DRX_STS_OK) {
 		pr_err("error %d\n", rc);
 		goto rw_error;
 	}
-	if (data == 127) {
+	if (data == 127)
 		*count = *count + 1;
-	}
 
 	return DRX_STS_OK;
 rw_error:
@@ -4937,10 +4866,9 @@ static int adc_synchronization(struct drx_demod_instance *demod)
 		}
 	}
 
-	if (count < 2) {
-		/* TODO: implement fallback scenarios */
+	/* TODO: implement fallback scenarios */
+	if (count < 2)
 		return DRX_STS_ERROR;
-	}
 
 	return DRX_STS_OK;
 rw_error:
@@ -4965,20 +4893,10 @@ static int iqm_set_af(struct drx_demod_instance *demod, bool active)
 		pr_err("error %d\n", rc);
 		goto rw_error;
 	}
-	if (!active) {
-		data &= ((~IQM_AF_STDBY_STDBY_ADC_A2_ACTIVE)
-			 & (~IQM_AF_STDBY_STDBY_AMP_A2_ACTIVE)
-			 & (~IQM_AF_STDBY_STDBY_PD_A2_ACTIVE)
-			 & (~IQM_AF_STDBY_STDBY_TAGC_IF_A2_ACTIVE)
-			 & (~IQM_AF_STDBY_STDBY_TAGC_RF_A2_ACTIVE)
-		    );
-	} else {		/* active */
-		data |= (IQM_AF_STDBY_STDBY_ADC_A2_ACTIVE
-			 | IQM_AF_STDBY_STDBY_AMP_A2_ACTIVE
-			 | IQM_AF_STDBY_STDBY_PD_A2_ACTIVE
-			 | IQM_AF_STDBY_STDBY_TAGC_IF_A2_ACTIVE
-			 | IQM_AF_STDBY_STDBY_TAGC_RF_A2_ACTIVE);
-	}
+	if (!active)
+		data &= ((~IQM_AF_STDBY_STDBY_ADC_A2_ACTIVE) & (~IQM_AF_STDBY_STDBY_AMP_A2_ACTIVE) & (~IQM_AF_STDBY_STDBY_PD_A2_ACTIVE) & (~IQM_AF_STDBY_STDBY_TAGC_IF_A2_ACTIVE) & (~IQM_AF_STDBY_STDBY_TAGC_RF_A2_ACTIVE));
+	else
+		data |= (IQM_AF_STDBY_STDBY_ADC_A2_ACTIVE | IQM_AF_STDBY_STDBY_AMP_A2_ACTIVE | IQM_AF_STDBY_STDBY_PD_A2_ACTIVE | IQM_AF_STDBY_STDBY_TAGC_IF_A2_ACTIVE | IQM_AF_STDBY_STDBY_TAGC_RF_A2_ACTIVE);
 	rc = DRXJ_DAP.write_reg16func(dev_addr, IQM_AF_STDBY__A, data, 0);
 	if (rc != DRX_STS_OK) {
 		pr_err("error %d\n", rc);
@@ -5261,9 +5179,8 @@ ctrl_get_cfg_pdr_safe_mode(struct drx_demod_instance *demod, bool *enabled)
 {
 	struct drxj_data *ext_attr = (struct drxj_data *) NULL;
 
-	if (enabled == NULL) {
+	if (enabled == NULL)
 		return DRX_STS_INVALID_ARG;
-	}
 
 	ext_attr = (struct drxj_data *) demod->my_ext_attr;
 	*enabled = ext_attr->pdr_safe_mode;
@@ -5722,14 +5639,12 @@ static int init_agc(struct drx_demod_instance *demod)
 	}
 
 	agc_rf = 0x800 + p_agc_rf_settings->cut_off_current;
-	if (common_attr->tuner_rf_agc_pol == true) {
+	if (common_attr->tuner_rf_agc_pol == true)
 		agc_rf = 0x87ff - agc_rf;
-	}
 
 	agc_if = 0x800;
-	if (common_attr->tuner_if_agc_pol == true) {
+	if (common_attr->tuner_if_agc_pol == true)
 		agc_rf = 0x87ff - agc_rf;
-	}
 
 	rc = DRXJ_DAP.write_reg16func(dev_addr, IQM_AF_AGC_RF__A, agc_rf, 0);
 	if (rc != DRX_STS_OK) {
@@ -5821,15 +5736,10 @@ set_frequency(struct drx_demod_instance *demod,
 	}
 	intermediate_freq = demod->my_common_attr->intermediate_freq;
 	sampling_frequency = demod->my_common_attr->sys_clock_freq / 3;
-	if (tuner_mirror) {
-		/* tuner doesn't mirror */
-		if_freq_actual =
-		    intermediate_freq + rf_freq_residual + fm_frequency_shift;
-	} else {
-		/* tuner mirrors */
-		if_freq_actual =
-		    intermediate_freq - rf_freq_residual - fm_frequency_shift;
-	}
+	if (tuner_mirror)
+		if_freq_actual = intermediate_freq + rf_freq_residual + fm_frequency_shift;
+	else
+		if_freq_actual = intermediate_freq - rf_freq_residual - fm_frequency_shift;
 	if (if_freq_actual > sampling_frequency / 2) {
 		/* adc mirrors */
 		adc_freq = sampling_frequency - if_freq_actual;
@@ -5913,7 +5823,7 @@ static int get_sig_strength(struct drx_demod_instance *demod, u16 *sig_strength)
 		else if (rf_gain > rf_agc_min) {
 			if (rf_agc_max == rf_agc_min) {
 				pr_err("error: rf_agc_max == rf_agc_min\n");
-				return DRX_STS_ERROR;;
+				return DRX_STS_ERROR;
 			}
 			*sig_strength =
 			    75 + 25 * (rf_gain - rf_agc_min) / (rf_agc_max -
@@ -5923,14 +5833,14 @@ static int get_sig_strength(struct drx_demod_instance *demod, u16 *sig_strength)
 	} else if (if_gain > if_agc_sns) {
 		if (if_agc_top == if_agc_sns) {
 			pr_err("error: if_agc_top == if_agc_sns\n");
-			return DRX_STS_ERROR;;
+			return DRX_STS_ERROR;
 		}
 		*sig_strength =
 		    20 + 55 * (if_gain - if_agc_sns) / (if_agc_top - if_agc_sns);
 	} else {
 		if (!if_agc_sns) {
 			pr_err("error: if_agc_sns is zero!\n");
-			return DRX_STS_ERROR;;
+			return DRX_STS_ERROR;
 		}
 		*sig_strength = (20 * if_gain / if_agc_sns);
 	}
@@ -6177,19 +6087,17 @@ set_agc_rf(struct drx_demod_instance *demod, struct drxj_cfg_agc *agc_settings,
 				goto rw_error;
 			}
 			data &= ~SCU_RAM_AGC_KI_RF__M;
-			if (ext_attr->standard == DRX_STANDARD_8VSB) {
+			if (ext_attr->standard == DRX_STANDARD_8VSB)
 				data |= (2 << SCU_RAM_AGC_KI_RF__B);
-			} else if (DRXJ_ISQAMSTD(ext_attr->standard)) {
+			else if (DRXJ_ISQAMSTD(ext_attr->standard))
 				data |= (5 << SCU_RAM_AGC_KI_RF__B);
-			} else {
+			else
 				data |= (4 << SCU_RAM_AGC_KI_RF__B);
-			}
 
-			if (common_attr->tuner_rf_agc_pol) {
+			if (common_attr->tuner_rf_agc_pol)
 				data |= SCU_RAM_AGC_KI_INV_RF_POL__M;
-			} else {
+			else
 				data &= ~SCU_RAM_AGC_KI_INV_RF_POL__M;
-			}
 			rc = (*scu_wr16)(dev_addr, SCU_RAM_AGC_KI__A, data, 0);
 			if (rc != DRX_STS_OK) {
 				pr_err("error %d\n", rc);
@@ -6203,7 +6111,7 @@ set_agc_rf(struct drx_demod_instance *demod, struct drxj_cfg_agc *agc_settings,
 				goto rw_error;
 			}
 			data &= ~SCU_RAM_AGC_KI_RED_RAGC_RED__M;
-			rc = (*scu_wr16) (dev_addr, SCU_RAM_AGC_KI_RED__A,(~(agc_settings->speed << SCU_RAM_AGC_KI_RED_RAGC_RED__B) & SCU_RAM_AGC_KI_RED_RAGC_RED__M) | data, 0);
+			rc = (*scu_wr16)(dev_addr, SCU_RAM_AGC_KI_RED__A, (~(agc_settings->speed << SCU_RAM_AGC_KI_RED_RAGC_RED__B) & SCU_RAM_AGC_KI_RED_RAGC_RED__M) | data, 0);
 			if (rc != DRX_STS_OK) {
 				pr_err("error %d\n", rc);
 				goto rw_error;
@@ -6261,11 +6169,10 @@ set_agc_rf(struct drx_demod_instance *demod, struct drxj_cfg_agc *agc_settings,
 				goto rw_error;
 			}
 			data &= ~SCU_RAM_AGC_KI_RF__M;
-			if (common_attr->tuner_rf_agc_pol) {
+			if (common_attr->tuner_rf_agc_pol)
 				data |= SCU_RAM_AGC_KI_INV_RF_POL__M;
-			} else {
+			else
 				data &= ~SCU_RAM_AGC_KI_INV_RF_POL__M;
-			}
 			rc = (*scu_wr16)(dev_addr, SCU_RAM_AGC_KI__A, data, 0);
 			if (rc != DRX_STS_OK) {
 				pr_err("error %d\n", rc);
@@ -6470,19 +6377,17 @@ set_agc_if(struct drx_demod_instance *demod, struct drxj_cfg_agc *agc_settings,
 			}
 			data &= ~SCU_RAM_AGC_KI_IF_AGC_DISABLE__M;
 			data &= ~SCU_RAM_AGC_KI_IF__M;
-			if (ext_attr->standard == DRX_STANDARD_8VSB) {
+			if (ext_attr->standard == DRX_STANDARD_8VSB)
 				data |= (3 << SCU_RAM_AGC_KI_IF__B);
-			} else if (DRXJ_ISQAMSTD(ext_attr->standard)) {
+			else if (DRXJ_ISQAMSTD(ext_attr->standard))
 				data |= (6 << SCU_RAM_AGC_KI_IF__B);
-			} else {
+			else
 				data |= (5 << SCU_RAM_AGC_KI_IF__B);
-			}
 
-			if (common_attr->tuner_if_agc_pol) {
+			if (common_attr->tuner_if_agc_pol)
 				data |= SCU_RAM_AGC_KI_INV_IF_POL__M;
-			} else {
+			else
 				data &= ~SCU_RAM_AGC_KI_INV_IF_POL__M;
-			}
 			rc = (*scu_wr16)(dev_addr, SCU_RAM_AGC_KI__A, data, 0);
 			if (rc != DRX_STS_OK) {
 				pr_err("error %d\n", rc);
@@ -6560,11 +6465,10 @@ set_agc_if(struct drx_demod_instance *demod, struct drxj_cfg_agc *agc_settings,
 			}
 			data &= ~SCU_RAM_AGC_KI_IF_AGC_DISABLE__M;
 			data |= SCU_RAM_AGC_KI_IF_AGC_DISABLE__M;
-			if (common_attr->tuner_if_agc_pol) {
+			if (common_attr->tuner_if_agc_pol)
 				data |= SCU_RAM_AGC_KI_INV_IF_POL__M;
-			} else {
+			else
 				data &= ~SCU_RAM_AGC_KI_INV_IF_POL__M;
-			}
 			rc = (*scu_wr16)(dev_addr, SCU_RAM_AGC_KI__A, data, 0);
 			if (rc != DRX_STS_OK) {
 				pr_err("error %d\n", rc);
@@ -6739,21 +6643,10 @@ static int set_iqm_af(struct drx_demod_instance *demod, bool active)
 		pr_err("error %d\n", rc);
 		goto rw_error;
 	}
-	if (!active) {
-		data &= ((~IQM_AF_STDBY_STDBY_ADC_A2_ACTIVE)
-			 & (~IQM_AF_STDBY_STDBY_AMP_A2_ACTIVE)
-			 & (~IQM_AF_STDBY_STDBY_PD_A2_ACTIVE)
-			 & (~IQM_AF_STDBY_STDBY_TAGC_IF_A2_ACTIVE)
-			 & (~IQM_AF_STDBY_STDBY_TAGC_RF_A2_ACTIVE)
-		    );
-	} else {		/* active */
-
-		data |= (IQM_AF_STDBY_STDBY_ADC_A2_ACTIVE
-			 | IQM_AF_STDBY_STDBY_AMP_A2_ACTIVE
-			 | IQM_AF_STDBY_STDBY_PD_A2_ACTIVE
-			 | IQM_AF_STDBY_STDBY_TAGC_IF_A2_ACTIVE
-			 | IQM_AF_STDBY_STDBY_TAGC_RF_A2_ACTIVE);
-	}
+	if (!active)
+		data &= ((~IQM_AF_STDBY_STDBY_ADC_A2_ACTIVE) & (~IQM_AF_STDBY_STDBY_AMP_A2_ACTIVE) & (~IQM_AF_STDBY_STDBY_PD_A2_ACTIVE) & (~IQM_AF_STDBY_STDBY_TAGC_IF_A2_ACTIVE) & (~IQM_AF_STDBY_STDBY_TAGC_RF_A2_ACTIVE));
+	else
+		data |= (IQM_AF_STDBY_STDBY_ADC_A2_ACTIVE | IQM_AF_STDBY_STDBY_AMP_A2_ACTIVE | IQM_AF_STDBY_STDBY_PD_A2_ACTIVE | IQM_AF_STDBY_STDBY_TAGC_IF_A2_ACTIVE | IQM_AF_STDBY_STDBY_TAGC_RF_A2_ACTIVE);
 	rc = DRXJ_DAP.write_reg16func(dev_addr, IQM_AF_STDBY__A, data, 0);
 	if (rc != DRX_STS_OK) {
 		pr_err("error %d\n", rc);
@@ -7630,7 +7523,7 @@ static int get_vsb_post_rs_pck_err(struct i2c_device_addr *dev_addr, u16 *pck_er
 	/* 77.3 us is time for per packet */
 	if (period * prescale == 0) {
 		pr_err("error: period and/or prescale is zero!\n");
-		return DRX_STS_ERROR;;
+		return DRX_STS_ERROR;
 	}
 	*pck_errs =
 	    (u16) frac_times1e6(packet_errors_mant * (1 << packet_errors_exp),
@@ -7672,7 +7565,7 @@ static int get_vs_bpost_viterbi_ber(struct i2c_device_addr *dev_addr, u32 *ber)
 	else {
 		if (period * prescale == 0) {
 			pr_err("error: period and/or prescale is zero!\n");
-			return DRX_STS_ERROR;;
+			return DRX_STS_ERROR;
 		}
 		*ber =
 		    frac_times1e6(bit_errors_mant <<
@@ -7739,7 +7632,7 @@ static int get_vsb_symb_err(struct i2c_device_addr *dev_addr, u32 *ser)
 
 	if (period * prescale == 0) {
 		pr_err("error: period and/or prescale is zero!\n");
-		return DRX_STS_ERROR;;
+		return DRX_STS_ERROR;
 	}
 	*ser = (u32) frac_times1e6((symb_errors_mant << symb_errors_exp) * 1000,
 				    (period * prescale * 77318));
@@ -7836,9 +7729,8 @@ ctrl_get_vsb_constel(struct drx_demod_instance *demod, struct drx_complex *compl
 		goto rw_error;
 	}
 	re = (u16) (((data >> 10) & 0x300) | ((data >> 2) & 0xff));
-	if (re & 0x0200) {
+	if (re & 0x0200)
 		re |= 0xfc00;
-	}
 	complex_nr->re = re;
 	complex_nr->im = 0;
 
@@ -8049,7 +7941,7 @@ set_qam_measurement(struct drx_demod_instance *demod,
 	fec_rs_bit_cnt = fec_rs_prescale * fec_rs_plen;	/* temp storage   */
 	if (fec_rs_bit_cnt == 0) {
 		pr_err("error: fec_rs_bit_cnt is zero!\n");
-		return DRX_STS_ERROR;;
+		return DRX_STS_ERROR;
 	}
 	fec_rs_period = fec_bits_desired / fec_rs_bit_cnt + 1;	/* ceil */
 	if (ext_attr->standard != DRX_STANDARD_ITU_B)
@@ -8146,7 +8038,7 @@ set_qam_measurement(struct drx_demod_instance *demod,
 		}
 		if (qam_vd_period == 0) {
 			pr_err("error: qam_vd_period is zero!\n");
-			return DRX_STS_ERROR;;
+			return DRX_STS_ERROR;
 		}
 		qam_vd_period = fec_bits_desired / qam_vd_period;
 		/* limit to max 16 bit value (I2C register width) if needed */
@@ -9531,7 +9423,7 @@ set_qam(struct drx_demod_instance *demod,
 			adc_frequency = (common_attr->sys_clock_freq * 1000) / 3;
 			if (channel->symbolrate == 0) {
 				pr_err("error: channel symbolrate is zero!\n");
-				return DRX_STS_ERROR;;
+				return DRX_STS_ERROR;
 			}
 			iqm_rc_rate =
 			    (adc_frequency / channel->symbolrate) * (1 << 21) +
@@ -10635,11 +10527,10 @@ set_qam_channel(struct drx_demod_instance *demod,
 	case DRX_CONSTELLATION_QAM128:
 	case DRX_CONSTELLATION_QAM256:
 		ext_attr->constellation = channel->constellation;
-		if (channel->mirror == DRX_MIRROR_AUTO) {
+		if (channel->mirror == DRX_MIRROR_AUTO)
 			ext_attr->mirror = DRX_MIRROR_NO;
-		} else {
+		else
 			ext_attr->mirror = channel->mirror;
-		}
 		rc = set_qam(demod, channel, tuner_freq_offset, QAM_SET_OP_ALL);
 		if (rc != DRX_STS_OK) {
 			pr_err("error %d\n", rc);
@@ -10671,11 +10562,10 @@ set_qam_channel(struct drx_demod_instance *demod,
 			/* try to lock default QAM constellation: QAM64 */
 			channel->constellation = DRX_CONSTELLATION_QAM256;
 			ext_attr->constellation = DRX_CONSTELLATION_QAM256;
-			if (channel->mirror == DRX_MIRROR_AUTO) {
+			if (channel->mirror == DRX_MIRROR_AUTO)
 				ext_attr->mirror = DRX_MIRROR_NO;
-			} else {
+			else
 				ext_attr->mirror = channel->mirror;
-			}
 			rc = set_qam(demod, channel, tuner_freq_offset, QAM_SET_OP_ALL);
 			if (rc != DRX_STS_OK) {
 				pr_err("error %d\n", rc);
@@ -10693,11 +10583,10 @@ set_qam_channel(struct drx_demod_instance *demod,
 				    DRX_CONSTELLATION_QAM64;
 				ext_attr->constellation =
 				    DRX_CONSTELLATION_QAM64;
-				if (channel->mirror == DRX_MIRROR_AUTO) {
+				if (channel->mirror == DRX_MIRROR_AUTO)
 					ext_attr->mirror = DRX_MIRROR_NO;
-				} else {
+				else
 					ext_attr->mirror = channel->mirror;
-				}
 				{
 					u16 qam_ctl_ena = 0;
 					rc = DRXJ_DAP.read_reg16func(demod->my_i2c_dev_addr, SCU_RAM_QAM_CTL_ENA__A, &qam_ctl_ena, 0);
@@ -10739,11 +10628,10 @@ set_qam_channel(struct drx_demod_instance *demod,
 			ext_attr->constellation = DRX_CONSTELLATION_QAM64;
 			auto_flag = true;
 
-			if (channel->mirror == DRX_MIRROR_AUTO) {
+			if (channel->mirror == DRX_MIRROR_AUTO)
 				ext_attr->mirror = DRX_MIRROR_NO;
-			} else {
+			else
 				ext_attr->mirror = channel->mirror;
-			}
 			{
 				u16 qam_ctl_ena = 0;
 				rc = DRXJ_DAP.read_reg16func(demod->my_i2c_dev_addr, SCU_RAM_QAM_CTL_ENA__A, &qam_ctl_ena, 0);
@@ -10815,9 +10703,8 @@ get_qamrs_err_count(struct i2c_device_addr *dev_addr, struct drxjrs_errors *rs_e
 	    nr_packet_errors = 0, nr_failures = 0, nr_snc_par_fail_count = 0;
 
 	/* check arguments */
-	if (dev_addr == NULL) {
+	if (dev_addr == NULL)
 		return DRX_STS_INVALID_ARG;
-	}
 
 	/* all reported errors are received in the  */
 	/* most recently finished measurment period */
@@ -10977,9 +10864,7 @@ ctrl_get_qam_sig_quality(struct drx_demod_instance *demod, struct drx_sig_qualit
 	if (qam_sl_err_power == 0)
 		qam_sl_mer = 0;
 	else
-		qam_sl_mer =
-		    log1_times100(qam_sl_sig_power) -
-		    log1_times100((u32) qam_sl_err_power);
+		qam_sl_mer = log1_times100(qam_sl_sig_power) - log1_times100((u32)qam_sl_err_power);
 
 	/* ----------------------------------------- */
 	/* Pre Viterbi Symbol Error Rate Calculation */
@@ -11000,13 +10885,10 @@ ctrl_get_qam_sig_quality(struct drx_demod_instance *demod, struct drx_sig_qualit
 	m = (qsym_err_vd & QAM_VD_NR_SYMBOL_ERRORS_FIXED_MANT__M) >>
 	    QAM_VD_NR_SYMBOL_ERRORS_FIXED_MANT__B;
 
-	if ((m << e) >> 3 > 549752) {	/* the max of frac_times1e6 */
-		qam_vd_ser = 500000;	/* clip BER 0.5 */
-	} else {
-		qam_vd_ser =
-		    frac_times1e6(m << ((e > 2) ? (e - 3) : e),
-				 vd_bit_cnt * ((e > 2) ? 1 : 8) / 8);
-	}
+	if ((m << e) >> 3 > 549752)
+		qam_vd_ser = 500000;
+	else
+		qam_vd_ser = frac_times1e6(m << ((e > 2) ? (e - 3) : e), vd_bit_cnt * ((e > 2) ? 1 : 8) / 8);
 
 	/* --------------------------------------- */
 	/* pre and post RedSolomon BER Calculation */
@@ -11027,11 +10909,10 @@ ctrl_get_qam_sig_quality(struct drx_demod_instance *demod, struct drx_sig_qualit
 	ber_cnt = m << e;
 
 	/*qam_pre_rs_ber = frac_times1e6( ber_cnt, rs_bit_cnt ); */
-	if (m > (rs_bit_cnt >> (e + 1)) || (rs_bit_cnt >> e) == 0) {
-		qam_pre_rs_ber = 500000;	/* clip BER 0.5 */
-	} else {
+	if (m > (rs_bit_cnt >> (e + 1)) || (rs_bit_cnt >> e) == 0)
+		qam_pre_rs_ber = 500000;
+	else
 		qam_pre_rs_ber = frac_times1e6(m, rs_bit_cnt >> e);
-	}
 
 	/* post RS BER = 1000000* (11.17 * FEC_OC_SNC_FAIL_COUNT__A) /  */
 	/*               (1504.0 * FEC_OC_SNC_FAIL_PERIOD__A)  */
@@ -11053,11 +10934,10 @@ ctrl_get_qam_sig_quality(struct drx_demod_instance *demod, struct drx_sig_qualit
 
 	/* fill signal quality data structure */
 	sig_quality->MER = ((u16) qam_sl_mer);
-	if (ext_attr->standard == DRX_STANDARD_ITU_B) {
+	if (ext_attr->standard == DRX_STANDARD_ITU_B)
 		sig_quality->pre_viterbi_ber = qam_vd_ser;
-	} else {
+	else
 		sig_quality->pre_viterbi_ber = qam_pre_rs_ber;
-	}
 	sig_quality->post_viterbi_ber = qam_pre_rs_ber;
 	sig_quality->post_reed_solomon_ber = qam_post_rs_ber;
 	sig_quality->scale_factor_ber = ((u32) 1000000);
@@ -11162,12 +11042,10 @@ ctrl_get_qam_constel(struct drx_demod_instance *demod, struct drx_complex *compl
 	/* interpret data (re & im) according to the Monitor bus mapping ?? */
 
 	/* sign extension, 10th bit is sign bit */
-	if ((re & 0x0200) == 0x0200) {
+	if ((re & 0x0200) == 0x0200)
 		re |= 0xFC00;
-	}
-	if ((im & 0x0200) == 0x0200) {
+	if ((im & 0x0200) == 0x0200)
 		im |= 0xFC00;
-	}
 	complex_nr->re = ((s16) re);
 	complex_nr->im = ((s16) im);
 
@@ -11351,11 +11229,10 @@ atv_update_config(struct drx_demod_instance *demod, bool force_update)
 			goto rw_error;
 		}
 		data &= (~((u16) IQM_RT_ROT_BP_ROT_OFF__M));
-		if (ext_attr->phase_correction_bypass) {
+		if (ext_attr->phase_correction_bypass)
 			data |= IQM_RT_ROT_BP_ROT_OFF_OFF;
-		} else {
+		else
 			data |= IQM_RT_ROT_BP_ROT_OFF_ACTIVE;
-		}
 		rc = DRXJ_DAP.write_reg16func(dev_addr, IQM_RT_ROT_BP__A, data, 0);
 		if (rc != DRX_STS_OK) {
 			pr_err("error %d\n", rc);
@@ -11422,17 +11299,15 @@ atv_update_config(struct drx_demod_instance *demod, bool force_update)
 			pr_err("error %d\n", rc);
 			goto rw_error;
 		}
-		if (ext_attr->enable_cvbs_output) {
+		if (ext_attr->enable_cvbs_output)
 			data |= ATV_TOP_STDBY_CVBS_STDBY_A2_ACTIVE;
-		} else {
+		else
 			data &= (~ATV_TOP_STDBY_CVBS_STDBY_A2_ACTIVE);
-		}
 
-		if (ext_attr->enable_sif_output) {
+		if (ext_attr->enable_sif_output)
 			data &= (~ATV_TOP_STDBY_SIF_STDBY_STANDBY);
-		} else {
+		else
 			data |= ATV_TOP_STDBY_SIF_STDBY_STANDBY;
-		}
 		rc = DRXJ_DAP.write_reg16func(dev_addr, ATV_TOP_STDBY__A, data, 0);
 		if (rc != DRX_STS_OK) {
 			pr_err("error %d\n", rc);
@@ -11463,9 +11338,8 @@ ctrl_set_cfg_atv_output(struct drx_demod_instance *demod, struct drxj_cfg_atv_ou
 	int rc;
 
 	/* Check arguments */
-	if (output_cfg == NULL) {
+	if (output_cfg == NULL)
 		return DRX_STS_INVALID_ARG;
-	}
 
 	ext_attr = (struct drxj_data *) demod->my_ext_attr;
 	if (output_cfg->enable_sif_output) {
@@ -11528,9 +11402,8 @@ ctrl_set_cfg_atv_equ_coef(struct drx_demod_instance *demod, struct drxj_cfg_atv_
 	ext_attr = (struct drxj_data *) demod->my_ext_attr;
 
 	/* current standard needs to be an ATV standard */
-	if (!DRXJ_ISATVSTD(ext_attr->standard)) {
+	if (!DRXJ_ISATVSTD(ext_attr->standard))
 		return DRX_STS_ERROR;
-	}
 
 	/* Check arguments */
 	if ((coef == NULL) ||
@@ -11591,14 +11464,12 @@ ctrl_get_cfg_atv_equ_coef(struct drx_demod_instance *demod, struct drxj_cfg_atv_
 	ext_attr = (struct drxj_data *) demod->my_ext_attr;
 
 	/* current standard needs to be an ATV standard */
-	if (!DRXJ_ISATVSTD(ext_attr->standard)) {
+	if (!DRXJ_ISATVSTD(ext_attr->standard))
 		return DRX_STS_ERROR;
-	}
 
 	/* Check arguments */
-	if (coef == NULL) {
+	if (coef == NULL)
 		return DRX_STS_INVALID_ARG;
-	}
 
 	rc = atv_equ_coef_index(ext_attr->standard, &index);
 	if (rc != DRX_STS_OK) {
@@ -11709,20 +11580,18 @@ ctrl_get_cfg_atv_output(struct drx_demod_instance *demod, struct drxj_cfg_atv_ou
 	u16 data = 0;
 
 	/* Check arguments */
-	if (output_cfg == NULL) {
+	if (output_cfg == NULL)
 		return DRX_STS_INVALID_ARG;
-	}
 
 	rc = DRXJ_DAP.read_reg16func(demod->my_i2c_dev_addr, ATV_TOP_STDBY__A, &data, 0);
 	if (rc != DRX_STS_OK) {
 		pr_err("error %d\n", rc);
 		goto rw_error;
 	}
-	if (data & ATV_TOP_STDBY_CVBS_STDBY_A2_ACTIVE) {
+	if (data & ATV_TOP_STDBY_CVBS_STDBY_A2_ACTIVE)
 		output_cfg->enable_cvbs_output = true;
-	} else {
+	else
 		output_cfg->enable_cvbs_output = false;
-	}
 
 	if (data & ATV_TOP_STDBY_SIF_STDBY_STANDBY) {
 		output_cfg->enable_sif_output = false;
@@ -11779,9 +11648,8 @@ ctrl_get_cfg_atv_agc_status(struct drx_demod_instance *demod,
 	tmp = ((u32) data) * 27 - ((u32) (data >> 2));	/* nA */
 	agc_status->rf_agc_gain = (u16) (tmp / 1000);	/* uA */
 	/* rounding */
-	if (tmp % 1000 >= 500) {
+	if (tmp % 1000 >= 500)
 		(agc_status->rf_agc_gain)++;
-	}
 
 	/*
 	   IFgain = (IQM_AF_AGC_IF__A * 26.75)/1000 (uA)
@@ -11797,9 +11665,8 @@ ctrl_get_cfg_atv_agc_status(struct drx_demod_instance *demod,
 	tmp = ((u32) data) * 27 - ((u32) (data >> 2));	/* nA */
 	agc_status->if_agc_gain = (u16) (tmp / 1000);	/* uA */
 	/* rounding */
-	if (tmp % 1000 >= 500) {
+	if (tmp % 1000 >= 500)
 		(agc_status->if_agc_gain)++;
-	}
 
 	/*
 	   videoGain = (ATV_TOP_SFR_VID_GAIN__A/16 -150)* 0.05 (dB)
@@ -11816,9 +11683,8 @@ ctrl_get_cfg_atv_agc_status(struct drx_demod_instance *demod,
 	}
 	/* dividing by 32 inclusive rounding */
 	data >>= 4;
-	if ((data & 1) != 0) {
+	if ((data & 1) != 0)
 		data++;
-	}
 	data >>= 1;
 	agc_status->video_agc_gain = ((s16) data) - 75;	/* 0.1 dB */
 
@@ -11837,9 +11703,8 @@ ctrl_get_cfg_atv_agc_status(struct drx_demod_instance *demod,
 	}
 	data &= SCU_RAM_ATV_SIF_GAIN__M;
 	/* dividing by 2 inclusive rounding */
-	if ((data & 1) != 0) {
+	if ((data & 1) != 0)
 		data++;
-	}
 	data >>= 1;
 	agc_status->audio_agc_gain = ((s16) data) - 4;	/* 0.1 dB */
 
@@ -12334,33 +12199,33 @@ trouble ?
 
 	rc = DRXJ_DAP.write_reg16func(dev_addr, ATV_COMM_EXEC__A, ATV_COMM_EXEC_STOP, 0);
 	if (rc != DRX_STS_OK) {
-	pr_err("error %d\n", rc);
-	goto rw_error;
+		pr_err("error %d\n", rc);
+		goto rw_error;
 	}
 	rc = DRXJ_DAP.write_reg16func(dev_addr, IQM_FS_COMM_EXEC__A, IQM_FS_COMM_EXEC_STOP, 0);
 	if (rc != DRX_STS_OK) {
-	pr_err("error %d\n", rc);
-	goto rw_error;
+		pr_err("error %d\n", rc);
+		goto rw_error;
 	}
 	rc = DRXJ_DAP.write_reg16func(dev_addr, IQM_FD_COMM_EXEC__A, IQM_FD_COMM_EXEC_STOP, 0);
 	if (rc != DRX_STS_OK) {
-	pr_err("error %d\n", rc);
-	goto rw_error;
+		pr_err("error %d\n", rc);
+		goto rw_error;
 	}
 	rc = DRXJ_DAP.write_reg16func(dev_addr, IQM_RC_COMM_EXEC__A, IQM_RC_COMM_EXEC_STOP, 0);
 	if (rc != DRX_STS_OK) {
-	pr_err("error %d\n", rc);
-	goto rw_error;
+		pr_err("error %d\n", rc);
+		goto rw_error;
 	}
 	rc = DRXJ_DAP.write_reg16func(dev_addr, IQM_RT_COMM_EXEC__A, IQM_RT_COMM_EXEC_STOP, 0);
 	if (rc != DRX_STS_OK) {
-	pr_err("error %d\n", rc);
-	goto rw_error;
+		pr_err("error %d\n", rc);
+		goto rw_error;
 	}
 	rc = DRXJ_DAP.write_reg16func(dev_addr, IQM_CF_COMM_EXEC__A, IQM_CF_COMM_EXEC_STOP, 0);
 	if (rc != DRX_STS_OK) {
-	pr_err("error %d\n", rc);
-	goto rw_error;
+		pr_err("error %d\n", rc);
+		goto rw_error;
 	}
 	/* Reset ATV SCU */
 	cmd_scu.command = SCU_RAM_COMMAND_STANDARD_ATV |
@@ -12377,8 +12242,8 @@ trouble ?
 
 	rc = DRXJ_DAP.write_reg16func(dev_addr, ATV_TOP_MOD_CONTROL__A, ATV_TOP_MOD_CONTROL__PRE, 0);
 	if (rc != DRX_STS_OK) {
-	pr_err("error %d\n", rc);
-	goto rw_error;
+		pr_err("error %d\n", rc);
+		goto rw_error;
 	}
 
 	/* TODO remove AUTO/OFF patches after ucode fix. */
@@ -12389,70 +12254,70 @@ trouble ?
 
 		rc = DRXJ_DAP.write_reg16func(dev_addr, IQM_RT_LO_INCR__A, IQM_RT_LO_INCR_MN, 0);
 		if (rc != DRX_STS_OK) {
-		pr_err("error %d\n", rc);
-		goto rw_error;
+			pr_err("error %d\n", rc);
+			goto rw_error;
 		}
 		rc = DRXJ_DAP.write_reg16func(dev_addr, IQM_CF_MIDTAP__A, IQM_CF_MIDTAP_RE__M, 0);
 		if (rc != DRX_STS_OK) {
-		pr_err("error %d\n", rc);
-		goto rw_error;
+			pr_err("error %d\n", rc);
+			goto rw_error;
 		}
 		rc = DRXJ_DAP.write_block_func(dev_addr, IQM_CF_TAP_RE0__A, sizeof(ntsc_taps_re), ((u8 *)ntsc_taps_re), 0);
 		if (rc != DRX_STS_OK) {
-		pr_err("error %d\n", rc);
-		goto rw_error;
+			pr_err("error %d\n", rc);
+			goto rw_error;
 		}
 		rc = DRXJ_DAP.write_block_func(dev_addr, IQM_CF_TAP_IM0__A, sizeof(ntsc_taps_im), ((u8 *)ntsc_taps_im), 0);
 		if (rc != DRX_STS_OK) {
-		pr_err("error %d\n", rc);
-		goto rw_error;
+			pr_err("error %d\n", rc);
+			goto rw_error;
 		}
 
 		rc = DRXJ_DAP.write_reg16func(dev_addr, ATV_TOP_CR_AMP_TH__A, ATV_TOP_CR_AMP_TH_MN, 0);
 		if (rc != DRX_STS_OK) {
-		pr_err("error %d\n", rc);
-		goto rw_error;
+			pr_err("error %d\n", rc);
+			goto rw_error;
 		}
 		rc = DRXJ_DAP.write_reg16func(dev_addr, ATV_TOP_CR_CONT__A, (ATV_TOP_CR_CONT_CR_P_MN | ATV_TOP_CR_CONT_CR_D_MN | ATV_TOP_CR_CONT_CR_I_MN), 0);
 		if (rc != DRX_STS_OK) {
-		pr_err("error %d\n", rc);
-		goto rw_error;
+			pr_err("error %d\n", rc);
+			goto rw_error;
 		}
 		rc = DRXJ_DAP.write_reg16func(dev_addr, ATV_TOP_CR_OVM_TH__A, ATV_TOP_CR_OVM_TH_MN, 0);
 		if (rc != DRX_STS_OK) {
-		pr_err("error %d\n", rc);
-		goto rw_error;
+			pr_err("error %d\n", rc);
+			goto rw_error;
 		}
 		rc = DRXJ_DAP.write_reg16func(dev_addr, ATV_TOP_STD__A, (ATV_TOP_STD_MODE_MN | ATV_TOP_STD_VID_POL_MN), 0);
 		if (rc != DRX_STS_OK) {
-		pr_err("error %d\n", rc);
-		goto rw_error;
+			pr_err("error %d\n", rc);
+			goto rw_error;
 		}
 		rc = DRXJ_DAP.write_reg16func(dev_addr, ATV_TOP_VID_AMP__A, ATV_TOP_VID_AMP_MN, 0);
 		if (rc != DRX_STS_OK) {
-		pr_err("error %d\n", rc);
-		goto rw_error;
+			pr_err("error %d\n", rc);
+			goto rw_error;
 		}
 
 		rc = DRXJ_DAP.write_reg16func(dev_addr, SCU_RAM_ATV_AGC_MODE__A, (SCU_RAM_ATV_AGC_MODE_SIF_STD_SIF_AGC_FM | SCU_RAM_ATV_AGC_MODE_FAST_VAGC_EN_FAGC_ENABLE), 0);
 		if (rc != DRX_STS_OK) {
-		pr_err("error %d\n", rc);
-		goto rw_error;
+			pr_err("error %d\n", rc);
+			goto rw_error;
 		}
 		rc = DRXJ_DAP.write_reg16func(dev_addr, SCU_RAM_ATV_VID_GAIN_HI__A, 0x1000, 0);
 		if (rc != DRX_STS_OK) {
-		pr_err("error %d\n", rc);
-		goto rw_error;
+			pr_err("error %d\n", rc);
+			goto rw_error;
 		}
 		rc = DRXJ_DAP.write_reg16func(dev_addr, SCU_RAM_ATV_VID_GAIN_LO__A, 0x0000, 0);
 		if (rc != DRX_STS_OK) {
-		pr_err("error %d\n", rc);
-		goto rw_error;
+			pr_err("error %d\n", rc);
+			goto rw_error;
 		}
 		rc = DRXJ_DAP.write_reg16func(dev_addr, SCU_RAM_ATV_AMS_MAX_REF__A, SCU_RAM_ATV_AMS_MAX_REF_AMS_MAX_REF_BG_MN, 0);
 		if (rc != DRX_STS_OK) {
-		pr_err("error %d\n", rc);
-		goto rw_error;
+			pr_err("error %d\n", rc);
+			goto rw_error;
 		}
 		ext_attr->phase_correction_bypass = false;
 		ext_attr->enable_cvbs_output = true;
@@ -12463,49 +12328,49 @@ trouble ?
 
 		rc = DRXJ_DAP.write_reg16func(dev_addr, IQM_RT_LO_INCR__A, 2994, 0);
 		if (rc != DRX_STS_OK) {
-		pr_err("error %d\n", rc);
-		goto rw_error;
+			pr_err("error %d\n", rc);
+			goto rw_error;
 		}
 		rc = DRXJ_DAP.write_reg16func(dev_addr, IQM_CF_MIDTAP__A, 0, 0);
 		if (rc != DRX_STS_OK) {
-		pr_err("error %d\n", rc);
-		goto rw_error;
+			pr_err("error %d\n", rc);
+			goto rw_error;
 		}
 		rc = DRXJ_DAP.write_block_func(dev_addr, IQM_CF_TAP_RE0__A, sizeof(fm_taps_re), ((u8 *)fm_taps_re), 0);
 		if (rc != DRX_STS_OK) {
-		pr_err("error %d\n", rc);
-		goto rw_error;
+			pr_err("error %d\n", rc);
+			goto rw_error;
 		}
 		rc = DRXJ_DAP.write_block_func(dev_addr, IQM_CF_TAP_IM0__A, sizeof(fm_taps_im), ((u8 *)fm_taps_im), 0);
 		if (rc != DRX_STS_OK) {
-		pr_err("error %d\n", rc);
-		goto rw_error;
+			pr_err("error %d\n", rc);
+			goto rw_error;
 		}
 		rc = DRXJ_DAP.write_reg16func(dev_addr, ATV_TOP_STD__A, (ATV_TOP_STD_MODE_FM | ATV_TOP_STD_VID_POL_FM), 0);
 		if (rc != DRX_STS_OK) {
-		pr_err("error %d\n", rc);
-		goto rw_error;
+			pr_err("error %d\n", rc);
+			goto rw_error;
 		}
 		rc = DRXJ_DAP.write_reg16func(dev_addr, ATV_TOP_MOD_CONTROL__A, 0, 0);
 		if (rc != DRX_STS_OK) {
-		pr_err("error %d\n", rc);
-		goto rw_error;
+			pr_err("error %d\n", rc);
+			goto rw_error;
 		}
 		rc = DRXJ_DAP.write_reg16func(dev_addr, ATV_TOP_CR_CONT__A, 0, 0);
 		if (rc != DRX_STS_OK) {
-		pr_err("error %d\n", rc);
-		goto rw_error;
+			pr_err("error %d\n", rc);
+			goto rw_error;
 		}
 
 		rc = DRXJ_DAP.write_reg16func(dev_addr, SCU_RAM_ATV_AGC_MODE__A, (SCU_RAM_ATV_AGC_MODE_VAGC_VEL_AGC_SLOW | SCU_RAM_ATV_AGC_MODE_SIF_STD_SIF_AGC_FM), 0);
 		if (rc != DRX_STS_OK) {
-		pr_err("error %d\n", rc);
-		goto rw_error;
+			pr_err("error %d\n", rc);
+			goto rw_error;
 		}
 		rc = DRXJ_DAP.write_reg16func(dev_addr, IQM_RT_ROT_BP__A, IQM_RT_ROT_BP_ROT_OFF_OFF, 0);
 		if (rc != DRX_STS_OK) {
-		pr_err("error %d\n", rc);
-		goto rw_error;
+			pr_err("error %d\n", rc);
+			goto rw_error;
 		}
 		ext_attr->phase_correction_bypass = true;
 		ext_attr->enable_cvbs_output = false;
@@ -12516,68 +12381,68 @@ trouble ?
 
 		rc = DRXJ_DAP.write_reg16func(dev_addr, IQM_RT_LO_INCR__A, 1820, 0);
 		if (rc != DRX_STS_OK) {
-		pr_err("error %d\n", rc);
-		goto rw_error;
+			pr_err("error %d\n", rc);
+			goto rw_error;
 		}	/* TODO check with IS */
 		rc = DRXJ_DAP.write_reg16func(dev_addr, IQM_CF_MIDTAP__A, IQM_CF_MIDTAP_RE__M, 0);
 		if (rc != DRX_STS_OK) {
-		pr_err("error %d\n", rc);
-		goto rw_error;
+			pr_err("error %d\n", rc);
+			goto rw_error;
 		}
 		rc = DRXJ_DAP.write_block_func(dev_addr, IQM_CF_TAP_RE0__A, sizeof(bg_taps_re), ((u8 *)bg_taps_re), 0);
 		if (rc != DRX_STS_OK) {
-		pr_err("error %d\n", rc);
-		goto rw_error;
+			pr_err("error %d\n", rc);
+			goto rw_error;
 		}
 		rc = DRXJ_DAP.write_block_func(dev_addr, IQM_CF_TAP_IM0__A, sizeof(bg_taps_im), ((u8 *)bg_taps_im), 0);
 		if (rc != DRX_STS_OK) {
-		pr_err("error %d\n", rc);
-		goto rw_error;
+			pr_err("error %d\n", rc);
+			goto rw_error;
 		}
 		rc = DRXJ_DAP.write_reg16func(dev_addr, ATV_TOP_VID_AMP__A, ATV_TOP_VID_AMP_BG, 0);
 		if (rc != DRX_STS_OK) {
-		pr_err("error %d\n", rc);
-		goto rw_error;
+			pr_err("error %d\n", rc);
+			goto rw_error;
 		}
 		rc = DRXJ_DAP.write_reg16func(dev_addr, ATV_TOP_CR_AMP_TH__A, ATV_TOP_CR_AMP_TH_BG, 0);
 		if (rc != DRX_STS_OK) {
-		pr_err("error %d\n", rc);
-		goto rw_error;
+			pr_err("error %d\n", rc);
+			goto rw_error;
 		}
 		rc = DRXJ_DAP.write_reg16func(dev_addr, ATV_TOP_CR_CONT__A, (ATV_TOP_CR_CONT_CR_P_BG | ATV_TOP_CR_CONT_CR_D_BG | ATV_TOP_CR_CONT_CR_I_BG), 0);
 		if (rc != DRX_STS_OK) {
-		pr_err("error %d\n", rc);
-		goto rw_error;
+			pr_err("error %d\n", rc);
+			goto rw_error;
 		}
 		rc = DRXJ_DAP.write_reg16func(dev_addr, ATV_TOP_CR_OVM_TH__A, ATV_TOP_CR_OVM_TH_BG, 0);
 		if (rc != DRX_STS_OK) {
-		pr_err("error %d\n", rc);
-		goto rw_error;
+			pr_err("error %d\n", rc);
+			goto rw_error;
 		}
 		rc = DRXJ_DAP.write_reg16func(dev_addr, ATV_TOP_STD__A, (ATV_TOP_STD_MODE_BG | ATV_TOP_STD_VID_POL_BG), 0);
 		if (rc != DRX_STS_OK) {
-		pr_err("error %d\n", rc);
-		goto rw_error;
+			pr_err("error %d\n", rc);
+			goto rw_error;
 		}
 		rc = DRXJ_DAP.write_reg16func(dev_addr, SCU_RAM_ATV_AGC_MODE__A, (SCU_RAM_ATV_AGC_MODE_SIF_STD_SIF_AGC_FM | SCU_RAM_ATV_AGC_MODE_FAST_VAGC_EN_FAGC_ENABLE), 0);
 		if (rc != DRX_STS_OK) {
-		pr_err("error %d\n", rc);
-		goto rw_error;
+			pr_err("error %d\n", rc);
+			goto rw_error;
 		}
 		rc = DRXJ_DAP.write_reg16func(dev_addr, SCU_RAM_ATV_VID_GAIN_HI__A, 0x1000, 0);
 		if (rc != DRX_STS_OK) {
-		pr_err("error %d\n", rc);
-		goto rw_error;
+			pr_err("error %d\n", rc);
+			goto rw_error;
 		}
 		rc = DRXJ_DAP.write_reg16func(dev_addr, SCU_RAM_ATV_VID_GAIN_LO__A, 0x0000, 0);
 		if (rc != DRX_STS_OK) {
-		pr_err("error %d\n", rc);
-		goto rw_error;
+			pr_err("error %d\n", rc);
+			goto rw_error;
 		}
 		rc = DRXJ_DAP.write_reg16func(dev_addr, SCU_RAM_ATV_AMS_MAX_REF__A, SCU_RAM_ATV_AMS_MAX_REF_AMS_MAX_REF_BG_MN, 0);
 		if (rc != DRX_STS_OK) {
-		pr_err("error %d\n", rc);
-		goto rw_error;
+			pr_err("error %d\n", rc);
+			goto rw_error;
 		}
 		ext_attr->phase_correction_bypass = false;
 		ext_attr->atv_if_agc_cfg.ctrl_mode = DRX_AGC_CTRL_AUTO;
@@ -12589,68 +12454,68 @@ trouble ?
 
 		rc = DRXJ_DAP.write_reg16func(dev_addr, IQM_RT_LO_INCR__A, 2225, 0);
 		if (rc != DRX_STS_OK) {
-		pr_err("error %d\n", rc);
-		goto rw_error;
+			pr_err("error %d\n", rc);
+			goto rw_error;
 		}	/* TODO check with IS */
 		rc = DRXJ_DAP.write_reg16func(dev_addr, IQM_CF_MIDTAP__A, IQM_CF_MIDTAP_RE__M, 0);
 		if (rc != DRX_STS_OK) {
-		pr_err("error %d\n", rc);
-		goto rw_error;
+			pr_err("error %d\n", rc);
+			goto rw_error;
 		}
 		rc = DRXJ_DAP.write_block_func(dev_addr, IQM_CF_TAP_RE0__A, sizeof(dk_i_l_lp_taps_re), ((u8 *)dk_i_l_lp_taps_re), 0);
 		if (rc != DRX_STS_OK) {
-		pr_err("error %d\n", rc);
-		goto rw_error;
+			pr_err("error %d\n", rc);
+			goto rw_error;
 		}
 		rc = DRXJ_DAP.write_block_func(dev_addr, IQM_CF_TAP_IM0__A, sizeof(dk_i_l_lp_taps_im), ((u8 *)dk_i_l_lp_taps_im), 0);
 		if (rc != DRX_STS_OK) {
-		pr_err("error %d\n", rc);
-		goto rw_error;
+			pr_err("error %d\n", rc);
+			goto rw_error;
 		}
 		rc = DRXJ_DAP.write_reg16func(dev_addr, ATV_TOP_CR_AMP_TH__A, ATV_TOP_CR_AMP_TH_DK, 0);
 		if (rc != DRX_STS_OK) {
-		pr_err("error %d\n", rc);
-		goto rw_error;
+			pr_err("error %d\n", rc);
+			goto rw_error;
 		}
 		rc = DRXJ_DAP.write_reg16func(dev_addr, ATV_TOP_VID_AMP__A, ATV_TOP_VID_AMP_DK, 0);
 		if (rc != DRX_STS_OK) {
-		pr_err("error %d\n", rc);
-		goto rw_error;
+			pr_err("error %d\n", rc);
+			goto rw_error;
 		}
 		rc = DRXJ_DAP.write_reg16func(dev_addr, ATV_TOP_CR_CONT__A, (ATV_TOP_CR_CONT_CR_P_DK | ATV_TOP_CR_CONT_CR_D_DK | ATV_TOP_CR_CONT_CR_I_DK), 0);
 		if (rc != DRX_STS_OK) {
-		pr_err("error %d\n", rc);
-		goto rw_error;
+			pr_err("error %d\n", rc);
+			goto rw_error;
 		}
 		rc = DRXJ_DAP.write_reg16func(dev_addr, ATV_TOP_CR_OVM_TH__A, ATV_TOP_CR_OVM_TH_DK, 0);
 		if (rc != DRX_STS_OK) {
-		pr_err("error %d\n", rc);
-		goto rw_error;
+			pr_err("error %d\n", rc);
+			goto rw_error;
 		}
 		rc = DRXJ_DAP.write_reg16func(dev_addr, ATV_TOP_STD__A, (ATV_TOP_STD_MODE_DK | ATV_TOP_STD_VID_POL_DK), 0);
 		if (rc != DRX_STS_OK) {
-		pr_err("error %d\n", rc);
-		goto rw_error;
+			pr_err("error %d\n", rc);
+			goto rw_error;
 		}
 		rc = DRXJ_DAP.write_reg16func(dev_addr, SCU_RAM_ATV_AGC_MODE__A, (SCU_RAM_ATV_AGC_MODE_SIF_STD_SIF_AGC_FM | SCU_RAM_ATV_AGC_MODE_FAST_VAGC_EN_FAGC_ENABLE), 0);
 		if (rc != DRX_STS_OK) {
-		pr_err("error %d\n", rc);
-		goto rw_error;
+			pr_err("error %d\n", rc);
+			goto rw_error;
 		}
 		rc = DRXJ_DAP.write_reg16func(dev_addr, SCU_RAM_ATV_VID_GAIN_HI__A, 0x1000, 0);
 		if (rc != DRX_STS_OK) {
-		pr_err("error %d\n", rc);
-		goto rw_error;
+			pr_err("error %d\n", rc);
+			goto rw_error;
 		}
 		rc = DRXJ_DAP.write_reg16func(dev_addr, SCU_RAM_ATV_VID_GAIN_LO__A, 0x0000, 0);
 		if (rc != DRX_STS_OK) {
-		pr_err("error %d\n", rc);
-		goto rw_error;
+			pr_err("error %d\n", rc);
+			goto rw_error;
 		}
 		rc = DRXJ_DAP.write_reg16func(dev_addr, SCU_RAM_ATV_AMS_MAX_REF__A, SCU_RAM_ATV_AMS_MAX_REF_AMS_MAX_REF_DK, 0);
 		if (rc != DRX_STS_OK) {
-		pr_err("error %d\n", rc);
-		goto rw_error;
+			pr_err("error %d\n", rc);
+			goto rw_error;
 		}
 		ext_attr->phase_correction_bypass = false;
 		ext_attr->atv_if_agc_cfg.ctrl_mode = DRX_AGC_CTRL_AUTO;
@@ -12662,68 +12527,68 @@ trouble ?
 
 		rc = DRXJ_DAP.write_reg16func(dev_addr, IQM_RT_LO_INCR__A, 2225, 0);
 		if (rc != DRX_STS_OK) {
-		pr_err("error %d\n", rc);
-		goto rw_error;
+			pr_err("error %d\n", rc);
+			goto rw_error;
 		}	/* TODO check with IS */
 		rc = DRXJ_DAP.write_reg16func(dev_addr, IQM_CF_MIDTAP__A, IQM_CF_MIDTAP_RE__M, 0);
 		if (rc != DRX_STS_OK) {
-		pr_err("error %d\n", rc);
-		goto rw_error;
+			pr_err("error %d\n", rc);
+			goto rw_error;
 		}
 		rc = DRXJ_DAP.write_block_func(dev_addr, IQM_CF_TAP_RE0__A, sizeof(dk_i_l_lp_taps_re), ((u8 *)dk_i_l_lp_taps_re), 0);
 		if (rc != DRX_STS_OK) {
-		pr_err("error %d\n", rc);
-		goto rw_error;
+			pr_err("error %d\n", rc);
+			goto rw_error;
 		}
 		rc = DRXJ_DAP.write_block_func(dev_addr, IQM_CF_TAP_IM0__A, sizeof(dk_i_l_lp_taps_im), ((u8 *)dk_i_l_lp_taps_im), 0);
 		if (rc != DRX_STS_OK) {
-		pr_err("error %d\n", rc);
-		goto rw_error;
+			pr_err("error %d\n", rc);
+			goto rw_error;
 		}
 		rc = DRXJ_DAP.write_reg16func(dev_addr, ATV_TOP_CR_AMP_TH__A, ATV_TOP_CR_AMP_TH_I, 0);
 		if (rc != DRX_STS_OK) {
-		pr_err("error %d\n", rc);
-		goto rw_error;
+			pr_err("error %d\n", rc);
+			goto rw_error;
 		}
 		rc = DRXJ_DAP.write_reg16func(dev_addr, ATV_TOP_VID_AMP__A, ATV_TOP_VID_AMP_I, 0);
 		if (rc != DRX_STS_OK) {
-		pr_err("error %d\n", rc);
-		goto rw_error;
+			pr_err("error %d\n", rc);
+			goto rw_error;
 		}
 		rc = DRXJ_DAP.write_reg16func(dev_addr, ATV_TOP_CR_CONT__A, (ATV_TOP_CR_CONT_CR_P_I | ATV_TOP_CR_CONT_CR_D_I | ATV_TOP_CR_CONT_CR_I_I), 0);
 		if (rc != DRX_STS_OK) {
-		pr_err("error %d\n", rc);
-		goto rw_error;
+			pr_err("error %d\n", rc);
+			goto rw_error;
 		}
 		rc = DRXJ_DAP.write_reg16func(dev_addr, ATV_TOP_CR_OVM_TH__A, ATV_TOP_CR_OVM_TH_I, 0);
 		if (rc != DRX_STS_OK) {
-		pr_err("error %d\n", rc);
-		goto rw_error;
+			pr_err("error %d\n", rc);
+			goto rw_error;
 		}
 		rc = DRXJ_DAP.write_reg16func(dev_addr, ATV_TOP_STD__A, (ATV_TOP_STD_MODE_I | ATV_TOP_STD_VID_POL_I), 0);
 		if (rc != DRX_STS_OK) {
-		pr_err("error %d\n", rc);
-		goto rw_error;
+			pr_err("error %d\n", rc);
+			goto rw_error;
 		}
 		rc = DRXJ_DAP.write_reg16func(dev_addr, SCU_RAM_ATV_AGC_MODE__A, (SCU_RAM_ATV_AGC_MODE_SIF_STD_SIF_AGC_FM | SCU_RAM_ATV_AGC_MODE_FAST_VAGC_EN_FAGC_ENABLE), 0);
 		if (rc != DRX_STS_OK) {
-		pr_err("error %d\n", rc);
-		goto rw_error;
+			pr_err("error %d\n", rc);
+			goto rw_error;
 		}
 		rc = DRXJ_DAP.write_reg16func(dev_addr, SCU_RAM_ATV_VID_GAIN_HI__A, 0x1000, 0);
 		if (rc != DRX_STS_OK) {
-		pr_err("error %d\n", rc);
-		goto rw_error;
+			pr_err("error %d\n", rc);
+			goto rw_error;
 		}
 		rc = DRXJ_DAP.write_reg16func(dev_addr, SCU_RAM_ATV_VID_GAIN_LO__A, 0x0000, 0);
 		if (rc != DRX_STS_OK) {
-		pr_err("error %d\n", rc);
-		goto rw_error;
+			pr_err("error %d\n", rc);
+			goto rw_error;
 		}
 		rc = DRXJ_DAP.write_reg16func(dev_addr, SCU_RAM_ATV_AMS_MAX_REF__A, SCU_RAM_ATV_AMS_MAX_REF_AMS_MAX_REF_I, 0);
 		if (rc != DRX_STS_OK) {
-		pr_err("error %d\n", rc);
-		goto rw_error;
+			pr_err("error %d\n", rc);
+			goto rw_error;
 		}
 		ext_attr->phase_correction_bypass = false;
 		ext_attr->atv_if_agc_cfg.ctrl_mode = DRX_AGC_CTRL_AUTO;
@@ -12735,68 +12600,68 @@ trouble ?
 
 		rc = DRXJ_DAP.write_reg16func(dev_addr, IQM_RT_LO_INCR__A, 2225, 0);
 		if (rc != DRX_STS_OK) {
-		pr_err("error %d\n", rc);
-		goto rw_error;
+			pr_err("error %d\n", rc);
+			goto rw_error;
 		}	/* TODO check with IS */
 		rc = DRXJ_DAP.write_reg16func(dev_addr, ATV_TOP_VID_AMP__A, ATV_TOP_VID_AMP_L, 0);
 		if (rc != DRX_STS_OK) {
-		pr_err("error %d\n", rc);
-		goto rw_error;
+			pr_err("error %d\n", rc);
+			goto rw_error;
 		}
 		rc = DRXJ_DAP.write_reg16func(dev_addr, IQM_CF_MIDTAP__A, IQM_CF_MIDTAP_RE__M, 0);
 		if (rc != DRX_STS_OK) {
-		pr_err("error %d\n", rc);
-		goto rw_error;
+			pr_err("error %d\n", rc);
+			goto rw_error;
 		}
 		rc = DRXJ_DAP.write_block_func(dev_addr, IQM_CF_TAP_RE0__A, sizeof(dk_i_l_lp_taps_re), ((u8 *)dk_i_l_lp_taps_re), 0);
 		if (rc != DRX_STS_OK) {
-		pr_err("error %d\n", rc);
-		goto rw_error;
+			pr_err("error %d\n", rc);
+			goto rw_error;
 		}
 		rc = DRXJ_DAP.write_block_func(dev_addr, IQM_CF_TAP_IM0__A, sizeof(dk_i_l_lp_taps_im), ((u8 *)dk_i_l_lp_taps_im), 0);
 		if (rc != DRX_STS_OK) {
-		pr_err("error %d\n", rc);
-		goto rw_error;
+			pr_err("error %d\n", rc);
+			goto rw_error;
 		}
 		rc = DRXJ_DAP.write_reg16func(dev_addr, ATV_TOP_CR_AMP_TH__A, 0x2, 0);
 		if (rc != DRX_STS_OK) {
-		pr_err("error %d\n", rc);
-		goto rw_error;
+			pr_err("error %d\n", rc);
+			goto rw_error;
 		}	/* TODO check with IS */
 		rc = DRXJ_DAP.write_reg16func(dev_addr, ATV_TOP_CR_CONT__A, (ATV_TOP_CR_CONT_CR_P_L | ATV_TOP_CR_CONT_CR_D_L | ATV_TOP_CR_CONT_CR_I_L), 0);
 		if (rc != DRX_STS_OK) {
-		pr_err("error %d\n", rc);
-		goto rw_error;
+			pr_err("error %d\n", rc);
+			goto rw_error;
 		}
 		rc = DRXJ_DAP.write_reg16func(dev_addr, ATV_TOP_CR_OVM_TH__A, ATV_TOP_CR_OVM_TH_L, 0);
 		if (rc != DRX_STS_OK) {
-		pr_err("error %d\n", rc);
-		goto rw_error;
+			pr_err("error %d\n", rc);
+			goto rw_error;
 		}
 		rc = DRXJ_DAP.write_reg16func(dev_addr, ATV_TOP_STD__A, (ATV_TOP_STD_MODE_L | ATV_TOP_STD_VID_POL_L), 0);
 		if (rc != DRX_STS_OK) {
-		pr_err("error %d\n", rc);
-		goto rw_error;
+			pr_err("error %d\n", rc);
+			goto rw_error;
 		}
 		rc = DRXJ_DAP.write_reg16func(dev_addr, SCU_RAM_ATV_AGC_MODE__A, (SCU_RAM_ATV_AGC_MODE_SIF_STD_SIF_AGC_AM | SCU_RAM_ATV_AGC_MODE_BP_EN_BPC_ENABLE | SCU_RAM_ATV_AGC_MODE_VAGC_VEL_AGC_SLOW), 0);
 		if (rc != DRX_STS_OK) {
-		pr_err("error %d\n", rc);
-		goto rw_error;
+			pr_err("error %d\n", rc);
+			goto rw_error;
 		}
 		rc = DRXJ_DAP.write_reg16func(dev_addr, SCU_RAM_ATV_VID_GAIN_HI__A, 0x1000, 0);
 		if (rc != DRX_STS_OK) {
-		pr_err("error %d\n", rc);
-		goto rw_error;
+			pr_err("error %d\n", rc);
+			goto rw_error;
 		}
 		rc = DRXJ_DAP.write_reg16func(dev_addr, SCU_RAM_ATV_VID_GAIN_LO__A, 0x0000, 0);
 		if (rc != DRX_STS_OK) {
-		pr_err("error %d\n", rc);
-		goto rw_error;
+			pr_err("error %d\n", rc);
+			goto rw_error;
 		}
 		rc = DRXJ_DAP.write_reg16func(dev_addr, SCU_RAM_ATV_AMS_MAX_REF__A, SCU_RAM_ATV_AMS_MAX_REF_AMS_MAX_REF_LLP, 0);
 		if (rc != DRX_STS_OK) {
-		pr_err("error %d\n", rc);
-		goto rw_error;
+			pr_err("error %d\n", rc);
+			goto rw_error;
 		}
 		ext_attr->phase_correction_bypass = false;
 		ext_attr->atv_if_agc_cfg.ctrl_mode = DRX_AGC_CTRL_USER;
@@ -12809,68 +12674,68 @@ trouble ?
 
 		rc = DRXJ_DAP.write_reg16func(dev_addr, ATV_TOP_VID_AMP__A, ATV_TOP_VID_AMP_LP, 0);
 		if (rc != DRX_STS_OK) {
-		pr_err("error %d\n", rc);
-		goto rw_error;
+			pr_err("error %d\n", rc);
+			goto rw_error;
 		}
 		rc = DRXJ_DAP.write_reg16func(dev_addr, IQM_RT_LO_INCR__A, 2225, 0);
 		if (rc != DRX_STS_OK) {
-		pr_err("error %d\n", rc);
-		goto rw_error;
+			pr_err("error %d\n", rc);
+			goto rw_error;
 		}	/* TODO check with IS */
 		rc = DRXJ_DAP.write_reg16func(dev_addr, IQM_CF_MIDTAP__A, IQM_CF_MIDTAP_RE__M, 0);
 		if (rc != DRX_STS_OK) {
-		pr_err("error %d\n", rc);
-		goto rw_error;
+			pr_err("error %d\n", rc);
+			goto rw_error;
 		}
 		rc = DRXJ_DAP.write_block_func(dev_addr, IQM_CF_TAP_RE0__A, sizeof(dk_i_l_lp_taps_re), ((u8 *)dk_i_l_lp_taps_re), 0);
 		if (rc != DRX_STS_OK) {
-		pr_err("error %d\n", rc);
-		goto rw_error;
+			pr_err("error %d\n", rc);
+			goto rw_error;
 		}
 		rc = DRXJ_DAP.write_block_func(dev_addr, IQM_CF_TAP_IM0__A, sizeof(dk_i_l_lp_taps_im), ((u8 *)dk_i_l_lp_taps_im), 0);
 		if (rc != DRX_STS_OK) {
-		pr_err("error %d\n", rc);
-		goto rw_error;
+			pr_err("error %d\n", rc);
+			goto rw_error;
 		}
 		rc = DRXJ_DAP.write_reg16func(dev_addr, ATV_TOP_CR_AMP_TH__A, 0x2, 0);
 		if (rc != DRX_STS_OK) {
-		pr_err("error %d\n", rc);
-		goto rw_error;
+			pr_err("error %d\n", rc);
+			goto rw_error;
 		}	/* TODO check with IS */
 		rc = DRXJ_DAP.write_reg16func(dev_addr, ATV_TOP_CR_CONT__A, (ATV_TOP_CR_CONT_CR_P_LP | ATV_TOP_CR_CONT_CR_D_LP | ATV_TOP_CR_CONT_CR_I_LP), 0);
 		if (rc != DRX_STS_OK) {
-		pr_err("error %d\n", rc);
-		goto rw_error;
+			pr_err("error %d\n", rc);
+			goto rw_error;
 		}
 		rc = DRXJ_DAP.write_reg16func(dev_addr, ATV_TOP_CR_OVM_TH__A, ATV_TOP_CR_OVM_TH_LP, 0);
 		if (rc != DRX_STS_OK) {
-		pr_err("error %d\n", rc);
-		goto rw_error;
+			pr_err("error %d\n", rc);
+			goto rw_error;
 		}
 		rc = DRXJ_DAP.write_reg16func(dev_addr, ATV_TOP_STD__A, (ATV_TOP_STD_MODE_LP | ATV_TOP_STD_VID_POL_LP), 0);
 		if (rc != DRX_STS_OK) {
-		pr_err("error %d\n", rc);
-		goto rw_error;
+			pr_err("error %d\n", rc);
+			goto rw_error;
 		}
 		rc = DRXJ_DAP.write_reg16func(dev_addr, SCU_RAM_ATV_AGC_MODE__A, (SCU_RAM_ATV_AGC_MODE_SIF_STD_SIF_AGC_AM | SCU_RAM_ATV_AGC_MODE_BP_EN_BPC_ENABLE | SCU_RAM_ATV_AGC_MODE_VAGC_VEL_AGC_SLOW), 0);
 		if (rc != DRX_STS_OK) {
-		pr_err("error %d\n", rc);
-		goto rw_error;
+			pr_err("error %d\n", rc);
+			goto rw_error;
 		}
 		rc = DRXJ_DAP.write_reg16func(dev_addr, SCU_RAM_ATV_VID_GAIN_HI__A, 0x1000, 0);
 		if (rc != DRX_STS_OK) {
-		pr_err("error %d\n", rc);
-		goto rw_error;
+			pr_err("error %d\n", rc);
+			goto rw_error;
 		}
 		rc = DRXJ_DAP.write_reg16func(dev_addr, SCU_RAM_ATV_VID_GAIN_LO__A, 0x0000, 0);
 		if (rc != DRX_STS_OK) {
-		pr_err("error %d\n", rc);
-		goto rw_error;
+			pr_err("error %d\n", rc);
+			goto rw_error;
 		}
 		rc = DRXJ_DAP.write_reg16func(dev_addr, SCU_RAM_ATV_AMS_MAX_REF__A, SCU_RAM_ATV_AMS_MAX_REF_AMS_MAX_REF_LLP, 0);
 		if (rc != DRX_STS_OK) {
-		pr_err("error %d\n", rc);
-		goto rw_error;
+			pr_err("error %d\n", rc);
+			goto rw_error;
 		}
 		ext_attr->phase_correction_bypass = false;
 		ext_attr->atv_if_agc_cfg.ctrl_mode = DRX_AGC_CTRL_USER;
@@ -12885,30 +12750,30 @@ trouble ?
 	if (!ext_attr->has_lna) {
 		rc = DRXJ_DAP.write_reg16func(dev_addr, IQM_AF_AMUX__A, 0x01, 0);
 		if (rc != DRX_STS_OK) {
-		pr_err("error %d\n", rc);
-		goto rw_error;
+			pr_err("error %d\n", rc);
+			goto rw_error;
 		}
 	}
 
 	rc = DRXJ_DAP.write_reg16func(dev_addr, SCU_RAM_ATV_STANDARD__A, 0x002, 0);
 	if (rc != DRX_STS_OK) {
-	pr_err("error %d\n", rc);
-	goto rw_error;
+		pr_err("error %d\n", rc);
+		goto rw_error;
 	}
 	rc = DRXJ_DAP.write_reg16func(dev_addr, IQM_AF_CLP_LEN__A, IQM_AF_CLP_LEN_ATV, 0);
 	if (rc != DRX_STS_OK) {
-	pr_err("error %d\n", rc);
-	goto rw_error;
+		pr_err("error %d\n", rc);
+		goto rw_error;
 	}
 	rc = DRXJ_DAP.write_reg16func(dev_addr, IQM_AF_CLP_TH__A, IQM_AF_CLP_TH_ATV, 0);
 	if (rc != DRX_STS_OK) {
-	pr_err("error %d\n", rc);
-	goto rw_error;
+		pr_err("error %d\n", rc);
+		goto rw_error;
 	}
 	rc = DRXJ_DAP.write_reg16func(dev_addr, IQM_AF_SNS_LEN__A, IQM_AF_SNS_LEN_ATV, 0);
 	if (rc != DRX_STS_OK) {
-	pr_err("error %d\n", rc);
-	goto rw_error;
+		pr_err("error %d\n", rc);
+		goto rw_error;
 	}
 	rc = ctrl_set_cfg_pre_saw(demod, &(ext_attr->atv_pre_saw_cfg));
 	if (rc != DRX_STS_OK) {
@@ -12917,135 +12782,135 @@ trouble ?
 	}
 	rc = DRXJ_DAP.write_reg16func(dev_addr, IQM_AF_AGC_IF__A, 10248, 0);
 	if (rc != DRX_STS_OK) {
-	pr_err("error %d\n", rc);
-	goto rw_error;
+		pr_err("error %d\n", rc);
+		goto rw_error;
 	}
 
 	ext_attr->iqm_rc_rate_ofs = 0x00200000L;
 	rc = DRXJ_DAP.write_reg32func(dev_addr, IQM_RC_RATE_OFS_LO__A, ext_attr->iqm_rc_rate_ofs, 0);
 	if (rc != DRX_STS_OK) {
-	pr_err("error %d\n", rc);
-	goto rw_error;
+		pr_err("error %d\n", rc);
+		goto rw_error;
 	}
 	rc = DRXJ_DAP.write_reg16func(dev_addr, IQM_RC_ADJ_SEL__A, IQM_RC_ADJ_SEL_B_OFF, 0);
 	if (rc != DRX_STS_OK) {
-	pr_err("error %d\n", rc);
-	goto rw_error;
+		pr_err("error %d\n", rc);
+		goto rw_error;
 	}
 	rc = DRXJ_DAP.write_reg16func(dev_addr, IQM_RC_STRETCH__A, IQM_RC_STRETCH_ATV, 0);
 	if (rc != DRX_STS_OK) {
-	pr_err("error %d\n", rc);
-	goto rw_error;
+		pr_err("error %d\n", rc);
+		goto rw_error;
 	}
 
 	rc = DRXJ_DAP.write_reg16func(dev_addr, IQM_RT_ACTIVE__A, IQM_RT_ACTIVE_ACTIVE_RT_ATV_FCR_ON | IQM_RT_ACTIVE_ACTIVE_CR_ATV_CR_ON, 0);
 	if (rc != DRX_STS_OK) {
-	pr_err("error %d\n", rc);
-	goto rw_error;
+		pr_err("error %d\n", rc);
+		goto rw_error;
 	}
 
 	rc = DRXJ_DAP.write_reg16func(dev_addr, IQM_CF_OUT_ENA__A, IQM_CF_OUT_ENA_ATV__M, 0);
 	if (rc != DRX_STS_OK) {
-	pr_err("error %d\n", rc);
-	goto rw_error;
+		pr_err("error %d\n", rc);
+		goto rw_error;
 	}
 	rc = DRXJ_DAP.write_reg16func(dev_addr, IQM_CF_SYMMETRIC__A, IQM_CF_SYMMETRIC_IM__M, 0);
 	if (rc != DRX_STS_OK) {
-	pr_err("error %d\n", rc);
-	goto rw_error;
+		pr_err("error %d\n", rc);
+		goto rw_error;
 	}
 	/* default: SIF in standby */
 	rc = DRXJ_DAP.write_reg16func(dev_addr, ATV_TOP_SYNC_SLICE__A, ATV_TOP_SYNC_SLICE_MN, 0);
 	if (rc != DRX_STS_OK) {
-	pr_err("error %d\n", rc);
-	goto rw_error;
+		pr_err("error %d\n", rc);
+		goto rw_error;
 	}
 	rc = DRXJ_DAP.write_reg16func(dev_addr, ATV_TOP_MOD_ACCU__A, ATV_TOP_MOD_ACCU__PRE, 0);
 	if (rc != DRX_STS_OK) {
-	pr_err("error %d\n", rc);
-	goto rw_error;
+		pr_err("error %d\n", rc);
+		goto rw_error;
 	}
 
 	rc = DRXJ_DAP.write_reg16func(dev_addr, SCU_RAM_ATV_SIF_GAIN__A, 0x080, 0);
 	if (rc != DRX_STS_OK) {
-	pr_err("error %d\n", rc);
-	goto rw_error;
+		pr_err("error %d\n", rc);
+		goto rw_error;
 	}
 	rc = DRXJ_DAP.write_reg16func(dev_addr, SCU_RAM_ATV_FAGC_TH_RED__A, 10, 0);
 	if (rc != DRX_STS_OK) {
-	pr_err("error %d\n", rc);
-	goto rw_error;
+		pr_err("error %d\n", rc);
+		goto rw_error;
 	}
 	rc = DRXJ_DAP.write_reg16func(dev_addr, SCU_RAM_ATV_AAGC_CNT__A, 7, 0);
 	if (rc != DRX_STS_OK) {
-	pr_err("error %d\n", rc);
-	goto rw_error;
+		pr_err("error %d\n", rc);
+		goto rw_error;
 	}
 	rc = DRXJ_DAP.write_reg16func(dev_addr, SCU_RAM_ATV_NAGC_KI_MIN__A, 0x0225, 0);
 	if (rc != DRX_STS_OK) {
-	pr_err("error %d\n", rc);
-	goto rw_error;
+		pr_err("error %d\n", rc);
+		goto rw_error;
 	}
 	rc = DRXJ_DAP.write_reg16func(dev_addr, SCU_RAM_ATV_NAGC_KI_MAX__A, 0x0547, 0);
 	if (rc != DRX_STS_OK) {
-	pr_err("error %d\n", rc);
-	goto rw_error;
+		pr_err("error %d\n", rc);
+		goto rw_error;
 	}
 	rc = DRXJ_DAP.write_reg16func(dev_addr, SCU_RAM_ATV_KI_CHANGE_TH__A, 20, 0);
 	if (rc != DRX_STS_OK) {
-	pr_err("error %d\n", rc);
-	goto rw_error;
+		pr_err("error %d\n", rc);
+		goto rw_error;
 	}
 	rc = DRXJ_DAP.write_reg16func(dev_addr, SCU_RAM_ATV_LOCK__A, 0, 0);
 	if (rc != DRX_STS_OK) {
-	pr_err("error %d\n", rc);
-	goto rw_error;
+		pr_err("error %d\n", rc);
+		goto rw_error;
 	}
 
 	rc = DRXJ_DAP.write_reg16func(dev_addr, IQM_RT_DELAY__A, IQM_RT_DELAY__PRE, 0);
 	if (rc != DRX_STS_OK) {
-	pr_err("error %d\n", rc);
-	goto rw_error;
+		pr_err("error %d\n", rc);
+		goto rw_error;
 	}
 	rc = DRXJ_DAP.write_reg16func(dev_addr, SCU_RAM_ATV_BPC_KI_MIN__A, 531, 0);
 	if (rc != DRX_STS_OK) {
-	pr_err("error %d\n", rc);
-	goto rw_error;
+		pr_err("error %d\n", rc);
+		goto rw_error;
 	}
 	rc = DRXJ_DAP.write_reg16func(dev_addr, SCU_RAM_ATV_PAGC_KI_MIN__A, 1061, 0);
 	if (rc != DRX_STS_OK) {
-	pr_err("error %d\n", rc);
-	goto rw_error;
+		pr_err("error %d\n", rc);
+		goto rw_error;
 	}
 	rc = DRXJ_DAP.write_reg16func(dev_addr, SCU_RAM_ATV_BP_REF_MIN__A, 100, 0);
 	if (rc != DRX_STS_OK) {
-	pr_err("error %d\n", rc);
-	goto rw_error;
+		pr_err("error %d\n", rc);
+		goto rw_error;
 	}
 	rc = DRXJ_DAP.write_reg16func(dev_addr, SCU_RAM_ATV_BP_REF_MAX__A, 260, 0);
 	if (rc != DRX_STS_OK) {
-	pr_err("error %d\n", rc);
-	goto rw_error;
+		pr_err("error %d\n", rc);
+		goto rw_error;
 	}
 	rc = DRXJ_DAP.write_reg16func(dev_addr, SCU_RAM_ATV_BP_LVL__A, 0, 0);
 	if (rc != DRX_STS_OK) {
-	pr_err("error %d\n", rc);
-	goto rw_error;
+		pr_err("error %d\n", rc);
+		goto rw_error;
 	}
 	rc = DRXJ_DAP.write_reg16func(dev_addr, SCU_RAM_ATV_AMS_MAX__A, 0, 0);
 	if (rc != DRX_STS_OK) {
-	pr_err("error %d\n", rc);
-	goto rw_error;
+		pr_err("error %d\n", rc);
+		goto rw_error;
 	}
 	rc = DRXJ_DAP.write_reg16func(dev_addr, SCU_RAM_ATV_AMS_MIN__A, 2047, 0);
 	if (rc != DRX_STS_OK) {
-	pr_err("error %d\n", rc);
-	goto rw_error;
+		pr_err("error %d\n", rc);
+		goto rw_error;
 	}
 	rc = DRXJ_DAP.write_reg16func(dev_addr, SCU_RAM_GPIO__A, 0, 0);
 	if (rc != DRX_STS_OK) {
-	pr_err("error %d\n", rc);
-	goto rw_error;
+		pr_err("error %d\n", rc);
+		goto rw_error;
 	}
 
 	/* Override reset values with current shadow settings */
@@ -13094,19 +12959,19 @@ trouble ?
 	if (ext_attr->mfx == 0x03) {
 		rc = DRXJ_DAP.write_reg16func(dev_addr, SCU_RAM_ATV_ENABLE_IIR_WA__A, 0, 0);
 		if (rc != DRX_STS_OK) {
-		pr_err("error %d\n", rc);
-		goto rw_error;
+			pr_err("error %d\n", rc);
+			goto rw_error;
 		}
 	} else {
 		rc = DRXJ_DAP.write_reg16func(dev_addr, SCU_RAM_ATV_ENABLE_IIR_WA__A, 1, 0);
 		if (rc != DRX_STS_OK) {
-		pr_err("error %d\n", rc);
-		goto rw_error;
+			pr_err("error %d\n", rc);
+			goto rw_error;
 		}
 		rc = DRXJ_DAP.write_reg16func(dev_addr, SCU_RAM_ATV_IIR_CRIT__A, 225, 0);
 		if (rc != DRX_STS_OK) {
-		pr_err("error %d\n", rc);
-		goto rw_error;
+			pr_err("error %d\n", rc);
+			goto rw_error;
 		}
 	}
 
@@ -13154,11 +13019,10 @@ set_atv_channel(struct drx_demod_instance *demod,
 	   Program frequency shifter
 	   No need to account for mirroring on RF
 	 */
-	if (channel->mirror == DRX_MIRROR_AUTO) {
+	if (channel->mirror == DRX_MIRROR_AUTO)
 		ext_attr->mirror = DRX_MIRROR_NO;
-	} else {
+	else
 		ext_attr->mirror = channel->mirror;
-	}
 
 	rc = set_frequency(demod, channel, tuner_freq_offset);
 	if (rc != DRX_STS_OK) {
@@ -13238,10 +13102,8 @@ get_atv_channel(struct drx_demod_instance *demod,
 				goto rw_error;
 			}
 			/* Signed 8 bit register => sign extension needed */
-			if ((measured_offset & 0x0080) != 0) {
-				/* sign extension */
+			if ((measured_offset & 0x0080) != 0)
 				measured_offset |= 0xFF80;
-			}
 			offset +=
 			    (s32) (((s16) measured_offset) * 10);
 			break;
@@ -13257,10 +13119,8 @@ get_atv_channel(struct drx_demod_instance *demod,
 				goto rw_error;
 			}
 			/* Signed 8 bit register => sign extension needed */
-			if ((measured_offset & 0x0080) != 0) {
-				/* sign extension */
+			if ((measured_offset & 0x0080) != 0)
 				measured_offset |= 0xFF80;
-			}
 			offset -=
 			    (s32) (((s16) measured_offset) * 10);
 		}
@@ -13376,17 +13236,17 @@ get_atv_sig_strength(struct drx_demod_instance *demod, u16 *sig_strength)
 
 	/* clipping */
 	if (digital_curr_gain >= digital_max_gain)
-		digital_curr_gain = (u16) digital_max_gain;
+		digital_curr_gain = (u16)digital_max_gain;
 	if (digital_curr_gain <= digital_min_gain)
-		digital_curr_gain = (u16) digital_min_gain;
+		digital_curr_gain = (u16)digital_min_gain;
 	if (if_curr_gain <= if_max_gain)
-		if_curr_gain = (u16) if_max_gain;
+		if_curr_gain = (u16)if_max_gain;
 	if (if_curr_gain >= if_min_gain)
-		if_curr_gain = (u16) if_min_gain;
+		if_curr_gain = (u16)if_min_gain;
 	if (rf_curr_gain <= rf_max_gain)
-		rf_curr_gain = (u16) rf_max_gain;
+		rf_curr_gain = (u16)rf_max_gain;
 	if (rf_curr_gain >= rf_min_gain)
-		rf_curr_gain = (u16) rf_min_gain;
+		rf_curr_gain = (u16)rf_min_gain;
 
 	/* TODO: use SCU_RAM_ATV_RAGC_HR__A to shift max and min in case
 	   of clipping at ADC */
@@ -13462,13 +13322,10 @@ atv_sig_quality(struct drx_demod_instance *demod, struct drx_sig_quality *sig_qu
 	if (quality_indicator <= 0x80) {
 		sig_quality->indicator =
 		    80 + ((20 * (0x80 - quality_indicator)) / 0x80);
-	} else if (quality_indicator <= 0x700) {
-		sig_quality->indicator = 30 +
-		    ((50 * (0x700 - quality_indicator)) / (0x700 - 0x81));
-	} else {
-		sig_quality->indicator =
-		    (30 * (0x7FF - quality_indicator)) / (0x7FF - 0x701);
-	}
+	} else if (quality_indicator <= 0x700)
+		sig_quality->indicator = 30 + ((50 * (0x700 - quality_indicator)) / (0x700 - 0x81));
+	else
+		sig_quality->indicator = (30 * (0x7FF - quality_indicator)) / (0x7FF - 0x701);
 
 	return DRX_STS_OK;
 rw_error:
@@ -13579,9 +13436,8 @@ static int aud_get_modus(struct drx_demod_instance *demod, u16 *modus)
 	u16 r_modus_hi = 0;
 	u16 r_modus_lo = 0;
 
-	if (modus == NULL) {
+	if (modus == NULL)
 		return DRX_STS_INVALID_ARG;
-	}
 
 	dev_addr = (struct i2c_device_addr *)demod->my_i2c_dev_addr;
 	ext_attr = (struct drxj_data *) demod->my_ext_attr;
@@ -13641,9 +13497,8 @@ aud_ctrl_get_cfg_rds(struct drx_demod_instance *demod, struct drx_cfg_aud_rds *s
 	addr = (struct i2c_device_addr *)demod->my_i2c_dev_addr;
 	ext_attr = (struct drxj_data *) demod->my_ext_attr;
 
-	if (status == NULL) {
+	if (status == NULL)
 		return DRX_STS_INVALID_ARG;
-	}
 
 	/* power up */
 	if (ext_attr->aud_data.audio_is_active == false) {
@@ -13721,9 +13576,8 @@ aud_ctrl_get_carrier_detect_status(struct drx_demod_instance *demod, struct drx_
 	int rc;
 	u16 r_data = 0;
 
-	if (status == NULL) {
+	if (status == NULL)
 		return DRX_STS_INVALID_ARG;
-	}
 
 	dev_addr = (struct i2c_device_addr *)demod->my_i2c_dev_addr;
 	ext_attr = (struct drxj_data *) demod->my_ext_attr;
@@ -13753,38 +13607,28 @@ aud_ctrl_get_carrier_detect_status(struct drx_demod_instance *demod, struct drx_
 	}
 
 	/* carrier a detected */
-	if ((r_data & AUD_DEM_RD_STATUS_STAT_CARR_A__M) ==
-	    AUD_DEM_RD_STATUS_STAT_CARR_A_DETECTED) {
+	if ((r_data & AUD_DEM_RD_STATUS_STAT_CARR_A__M) == AUD_DEM_RD_STATUS_STAT_CARR_A_DETECTED)
 		status->carrier_a = true;
-	}
 
 	/* carrier b detected */
-	if ((r_data & AUD_DEM_RD_STATUS_STAT_CARR_B__M) ==
-	    AUD_DEM_RD_STATUS_STAT_CARR_B_DETECTED) {
+	if ((r_data & AUD_DEM_RD_STATUS_STAT_CARR_B__M) == AUD_DEM_RD_STATUS_STAT_CARR_B_DETECTED)
 		status->carrier_b = true;
-	}
 	/* nicam detected */
 	if ((r_data & AUD_DEM_RD_STATUS_STAT_NICAM__M) ==
 	    AUD_DEM_RD_STATUS_STAT_NICAM_NICAM_DETECTED) {
-		if ((r_data & AUD_DEM_RD_STATUS_BAD_NICAM__M) ==
-		    AUD_DEM_RD_STATUS_BAD_NICAM_OK) {
+		if ((r_data & AUD_DEM_RD_STATUS_BAD_NICAM__M) == AUD_DEM_RD_STATUS_BAD_NICAM_OK)
 			status->nicam_status = DRX_AUD_NICAM_DETECTED;
-		} else {
+		else
 			status->nicam_status = DRX_AUD_NICAM_BAD;
-		}
 	}
 
 	/* audio mode bilingual or SAP detected */
-	if ((r_data & AUD_DEM_RD_STATUS_STAT_BIL_OR_SAP__M) ==
-	    AUD_DEM_RD_STATUS_STAT_BIL_OR_SAP_SAP) {
+	if ((r_data & AUD_DEM_RD_STATUS_STAT_BIL_OR_SAP__M) == AUD_DEM_RD_STATUS_STAT_BIL_OR_SAP_SAP)
 		status->sap = true;
-	}
 
 	/* stereo detected */
-	if ((r_data & AUD_DEM_RD_STATUS_STAT_STEREO__M) ==
-	    AUD_DEM_RD_STATUS_STAT_STEREO_STEREO) {
+	if ((r_data & AUD_DEM_RD_STATUS_STAT_STEREO__M) == AUD_DEM_RD_STATUS_STAT_STEREO_STEREO)
 		status->stereo = true;
-	}
 
 	return DRX_STS_OK;
 rw_error:
@@ -13808,9 +13652,8 @@ aud_ctrl_get_status(struct drx_demod_instance *demod, struct drx_aud_status *sta
 	int rc;
 	u16 r_data = 0;
 
-	if (status == NULL) {
+	if (status == NULL)
 		return DRX_STS_INVALID_ARG;
-	}
 
 	dev_addr = (struct i2c_device_addr *)demod->my_i2c_dev_addr;
 	ext_attr = (struct drxj_data *) demod->my_ext_attr;
@@ -13864,9 +13707,8 @@ aud_ctrl_get_cfg_volume(struct drx_demod_instance *demod, struct drx_cfg_aud_vol
 	u16 r_strength_left = 0;
 	u16 r_strength_right = 0;
 
-	if (volume == NULL) {
+	if (volume == NULL)
 		return DRX_STS_INVALID_ARG;
-	}
 
 	dev_addr = (struct i2c_device_addr *)demod->my_i2c_dev_addr;
 	ext_attr = (struct drxj_data *) demod->my_ext_attr;
@@ -13896,12 +13738,10 @@ aud_ctrl_get_cfg_volume(struct drx_demod_instance *demod, struct drx_cfg_aud_vol
 		volume->volume = ((r_volume & AUD_DSP_WR_VOLUME_VOL_MAIN__M) >>
 				  AUD_DSP_WR_VOLUME_VOL_MAIN__B) -
 		    AUD_VOLUME_ZERO_DB;
-		if (volume->volume < AUD_VOLUME_DB_MIN) {
+		if (volume->volume < AUD_VOLUME_DB_MIN)
 			volume->volume = AUD_VOLUME_DB_MIN;
-		}
-		if (volume->volume > AUD_VOLUME_DB_MAX) {
+		if (volume->volume > AUD_VOLUME_DB_MAX)
 			volume->volume = AUD_VOLUME_DB_MAX;
-		}
 	}
 
 	/* automatic volume control */
@@ -13911,8 +13751,7 @@ aud_ctrl_get_cfg_volume(struct drx_demod_instance *demod, struct drx_cfg_aud_vol
 		goto rw_error;
 	}
 
-	if ((r_avc & AUD_DSP_WR_AVC_AVC_ON__M) == AUD_DSP_WR_AVC_AVC_ON_OFF)
-	{
+	if ((r_avc & AUD_DSP_WR_AVC_AVC_ON__M) == AUD_DSP_WR_AVC_AVC_ON_OFF) {
 		volume->avc_mode = DRX_AUD_AVC_OFF;
 	} else {
 		switch (r_avc & AUD_DSP_WR_AVC_AVC_DECAY__M) {
@@ -14016,9 +13855,8 @@ aud_ctrl_set_cfg_volume(struct drx_demod_instance *demod, struct drx_cfg_aud_vol
 	u16 w_volume = 0;
 	u16 w_avc = 0;
 
-	if (volume == NULL) {
+	if (volume == NULL)
 		return DRX_STS_INVALID_ARG;
-	}
 
 	dev_addr = (struct i2c_device_addr *)demod->my_i2c_dev_addr;
 	ext_attr = (struct drxj_data *) demod->my_ext_attr;
@@ -14036,9 +13874,8 @@ aud_ctrl_set_cfg_volume(struct drx_demod_instance *demod, struct drx_cfg_aud_vol
 	/* volume */
 	/* volume range from -60 to 12 (expressed in dB) */
 	if ((volume->volume < AUD_VOLUME_DB_MIN) ||
-	    (volume->volume > AUD_VOLUME_DB_MAX)) {
+	    (volume->volume > AUD_VOLUME_DB_MAX))
 		return DRX_STS_INVALID_ARG;
-	}
 
 	rc = DRXJ_DAP.read_reg16func(dev_addr, AUD_DSP_WR_VOLUME__A, &w_volume, 0);
 	if (rc != DRX_STS_OK) {
@@ -14048,15 +13885,10 @@ aud_ctrl_set_cfg_volume(struct drx_demod_instance *demod, struct drx_cfg_aud_vol
 
 	/* clear the volume mask */
 	w_volume &= (u16) ~AUD_DSP_WR_VOLUME_VOL_MAIN__M;
-	if (volume->mute == true) {
-		/* mute */
-		/* mute overrules volume */
-		w_volume |= (u16) (0);
-
-	} else {
-		w_volume |= (u16) ((volume->volume + AUD_VOLUME_ZERO_DB) <<
-				    AUD_DSP_WR_VOLUME_VOL_MAIN__B);
-	}
+	if (volume->mute == true)
+		w_volume |= (u16)(0);
+	else
+		w_volume |= (u16)((volume->volume + AUD_VOLUME_ZERO_DB) << AUD_DSP_WR_VOLUME_VOL_MAIN__B);
 
 	rc = DRXJ_DAP.write_reg16func(dev_addr, AUD_DSP_WR_VOLUME__A, w_volume, 0);
 	if (rc != DRX_STS_OK) {
@@ -14133,9 +13965,8 @@ aud_ctrl_set_cfg_volume(struct drx_demod_instance *demod, struct drx_cfg_aud_vol
 	}
 
 	/* avc reference level */
-	if (volume->avc_ref_level > AUD_MAX_AVC_REF_LEVEL) {
+	if (volume->avc_ref_level > AUD_MAX_AVC_REF_LEVEL)
 		return DRX_STS_INVALID_ARG;
-	}
 
 	w_avc &= (u16) ~AUD_DSP_WR_AVC_AVC_REF_LEV__M;
 	w_avc |= (u16) (volume->avc_ref_level << AUD_DSP_WR_AVC_AVC_REF_LEV__B);
@@ -14170,9 +14001,8 @@ aud_ctrl_get_cfg_output_i2s(struct drx_demod_instance *demod, struct drx_cfg_i2s
 	u16 w_i2s_config = 0;
 	u16 r_i2s_freq = 0;
 
-	if (output == NULL) {
+	if (output == NULL)
 		return DRX_STS_INVALID_ARG;
-	}
 
 	dev_addr = (struct i2c_device_addr *)demod->my_i2c_dev_addr;
 	ext_attr = (struct drxj_data *) demod->my_ext_attr;
@@ -14247,18 +14077,15 @@ aud_ctrl_get_cfg_output_i2s(struct drx_demod_instance *demod, struct drx_cfg_i2s
 	}
 
 	/* I2S output enabled */
-	if ((w_i2s_config & AUD_DEM_WR_I2S_CONFIG2_I2S_ENABLE__M)
-	    == AUD_DEM_WR_I2S_CONFIG2_I2S_ENABLE_ENABLE) {
+	if ((w_i2s_config & AUD_DEM_WR_I2S_CONFIG2_I2S_ENABLE__M) == AUD_DEM_WR_I2S_CONFIG2_I2S_ENABLE_ENABLE)
 		output->output_enable = true;
-	} else {
+	else
 		output->output_enable = false;
-	}
 
 	if (r_i2s_freq > 0) {
 		output->frequency = 6144UL * 48000 / r_i2s_freq;
-		if (output->word_length == DRX_I2S_WORDLENGTH_16) {
+		if (output->word_length == DRX_I2S_WORDLENGTH_16)
 			output->frequency *= 2;
-		}
 	} else {
 		output->frequency = AUD_I2S_FREQUENCY_MAX;
 	}
@@ -14287,9 +14114,8 @@ aud_ctrl_set_cfg_output_i2s(struct drx_demod_instance *demod, struct drx_cfg_i2s
 	u16 w_i2s_pads_data_ws = 0;
 	u32 w_i2s_freq = 0;
 
-	if (output == NULL) {
+	if (output == NULL)
 		return DRX_STS_INVALID_ARG;
-	}
 
 	dev_addr = (struct i2c_device_addr *)demod->my_i2c_dev_addr;
 	ext_attr = (struct drxj_data *) demod->my_ext_attr;
@@ -14367,11 +14193,10 @@ aud_ctrl_set_cfg_output_i2s(struct drx_demod_instance *demod, struct drx_cfg_i2s
 
 	/* I2S output enabled */
 	w_i2s_config &= (u16) ~AUD_DEM_WR_I2S_CONFIG2_I2S_ENABLE__M;
-	if (output->output_enable == true) {
+	if (output->output_enable == true)
 		w_i2s_config |= AUD_DEM_WR_I2S_CONFIG2_I2S_ENABLE_ENABLE;
-	} else {
+	else
 		w_i2s_config |= AUD_DEM_WR_I2S_CONFIG2_I2S_ENABLE_DISABLE;
-	}
 
 	/*
 	   I2S frequency
@@ -14389,9 +14214,8 @@ aud_ctrl_set_cfg_output_i2s(struct drx_demod_instance *demod, struct drx_cfg_i2s
 	w_i2s_freq = (6144UL * 48000UL) + (output->frequency >> 1);
 	w_i2s_freq /= output->frequency;
 
-	if (output->word_length == DRX_I2S_WORDLENGTH_16) {
+	if (output->word_length == DRX_I2S_WORDLENGTH_16)
 		w_i2s_freq *= 2;
-	}
 
 	rc = DRXJ_DAP.write_reg16func(dev_addr, AUD_DEM_WR_I2S_CONFIG2__A, w_i2s_config, 0);
 	if (rc != DRX_STS_OK) {
@@ -14538,9 +14362,8 @@ aud_ctr_setl_cfg_auto_sound(struct drx_demod_instance *demod,
 	u16 r_modus = 0;
 	u16 w_modus = 0;
 
-	if (auto_sound == NULL) {
+	if (auto_sound == NULL)
 		return DRX_STS_INVALID_ARG;
-	}
 
 	dev_addr = demod->my_i2c_dev_addr;
 	ext_attr = (struct drxj_data *) demod->my_ext_attr;
@@ -14616,9 +14439,8 @@ aud_ctrl_get_cfg_ass_thres(struct drx_demod_instance *demod, struct drx_cfg_aud_
 	u16 thres_btsc = 0;
 	u16 thres_nicam = 0;
 
-	if (thres == NULL) {
+	if (thres == NULL)
 		return DRX_STS_INVALID_ARG;
-	}
 
 	dev_addr = demod->my_i2c_dev_addr;
 	ext_attr = (struct drxj_data *) demod->my_ext_attr;
@@ -14672,9 +14494,8 @@ aud_ctrl_set_cfg_ass_thres(struct drx_demod_instance *demod, struct drx_cfg_aud_
 	struct i2c_device_addr *dev_addr = (struct i2c_device_addr *)NULL;
 	struct drxj_data *ext_attr = (struct drxj_data *) NULL;
 	int rc;
-	if (thres == NULL) {
+	if (thres == NULL)
 		return DRX_STS_INVALID_ARG;
-	}
 
 	dev_addr = demod->my_i2c_dev_addr;
 	ext_attr = (struct drxj_data *) demod->my_ext_attr;
@@ -14742,9 +14563,8 @@ aud_ctrl_get_cfg_carrier(struct drx_demod_instance *demod, struct drx_cfg_aud_ca
 	u16 cm_thes_a = 0;
 	u16 cm_thes_b = 0;
 
-	if (carriers == NULL) {
+	if (carriers == NULL)
 		return DRX_STS_INVALID_ARG;
-	}
 
 	dev_addr = demod->my_i2c_dev_addr;
 	ext_attr = (struct drxj_data *) demod->my_ext_attr;
@@ -14872,18 +14692,15 @@ aud_ctrl_set_cfg_carrier(struct drx_demod_instance *demod, struct drx_cfg_aud_ca
 	int rc;
 	u16 w_modus = 0;
 	u16 r_modus = 0;
-
 	u16 dco_a_hi = 0;
 	u16 dco_a_lo = 0;
 	u16 dco_b_hi = 0;
 	u16 dco_b_lo = 0;
-
 	s32 valA = 0;
 	s32 valB = 0;
 
-	if (carriers == NULL) {
+	if (carriers == NULL)
 		return DRX_STS_INVALID_ARG;
-	}
 
 	dev_addr = demod->my_i2c_dev_addr;
 	ext_attr = (struct drxj_data *) demod->my_ext_attr;
@@ -15009,9 +14826,8 @@ aud_ctrl_get_cfg_mixer(struct drx_demod_instance *demod, struct drx_cfg_aud_mixe
 	u16 src_i2s_matr = 0;
 	u16 fm_matr = 0;
 
-	if (mixer == NULL) {
+	if (mixer == NULL)
 		return DRX_STS_INVALID_ARG;
-	}
 
 	dev_addr = demod->my_i2c_dev_addr;
 	ext_attr = (struct drxj_data *) demod->my_ext_attr;
@@ -15116,9 +14932,8 @@ aud_ctrl_set_cfg_mixer(struct drx_demod_instance *demod, struct drx_cfg_aud_mixe
 	u16 src_i2s_matr = 0;
 	u16 fm_matr = 0;
 
-	if (mixer == NULL) {
+	if (mixer == NULL)
 		return DRX_STS_INVALID_ARG;
-	}
 
 	dev_addr = demod->my_i2c_dev_addr;
 	ext_attr = (struct drxj_data *) demod->my_ext_attr;
@@ -15243,9 +15058,8 @@ aud_ctrl_set_cfg_av_sync(struct drx_demod_instance *demod, enum drx_cfg_aud_av_s
 	int rc;
 	u16 w_aud_vid_sync = 0;
 
-	if (av_sync == NULL) {
+	if (av_sync == NULL)
 		return DRX_STS_INVALID_ARG;
-	}
 
 	dev_addr = demod->my_i2c_dev_addr;
 	ext_attr = (struct drxj_data *) demod->my_ext_attr;
@@ -15269,11 +15083,10 @@ aud_ctrl_set_cfg_av_sync(struct drx_demod_instance *demod, enum drx_cfg_aud_av_s
 
 	w_aud_vid_sync &= (u16) ~AUD_DSP_WR_AV_SYNC_AV_ON__M;
 
-	if (*av_sync == DRX_AUD_AVSYNC_OFF) {
+	if (*av_sync == DRX_AUD_AVSYNC_OFF)
 		w_aud_vid_sync |= AUD_DSP_WR_AV_SYNC_AV_ON_DISABLE;
-	} else {
+	else
 		w_aud_vid_sync |= AUD_DSP_WR_AV_SYNC_AV_ON_ENABLE;
-	}
 
 	w_aud_vid_sync &= (u16) ~AUD_DSP_WR_AV_SYNC_AV_STD_SEL__M;
 
@@ -15320,9 +15133,8 @@ aud_ctrl_get_cfg_av_sync(struct drx_demod_instance *demod, enum drx_cfg_aud_av_s
 	int rc;
 	u16 w_aud_vid_sync = 0;
 
-	if (av_sync == NULL) {
+	if (av_sync == NULL)
 		return DRX_STS_INVALID_ARG;
-	}
 
 	dev_addr = demod->my_i2c_dev_addr;
 	ext_attr = (struct drxj_data *) demod->my_ext_attr;
@@ -15423,9 +15235,8 @@ aud_ctrl_set_cfg_dev(struct drx_demod_instance *demod, enum drx_cfg_aud_deviatio
 	u16 w_modus = 0;
 	u16 r_modus = 0;
 
-	if (dev == NULL) {
+	if (dev == NULL)
 		return DRX_STS_INVALID_ARG;
-	}
 
 	ext_attr = (struct drxj_data *) demod->my_ext_attr;
 	dev_addr = demod->my_i2c_dev_addr;
@@ -15483,9 +15294,8 @@ aud_ctrl_get_cfg_prescale(struct drx_demod_instance *demod, struct drx_cfg_aud_p
 	u16 r_max_fm_deviation = 0;
 	u16 r_nicam_prescaler = 0;
 
-	if (presc == NULL) {
+	if (presc == NULL)
 		return DRX_STS_INVALID_ARG;
-	}
 
 	dev_addr = demod->my_i2c_dev_addr;
 	ext_attr = (struct drxj_data *) demod->my_ext_attr;
@@ -15537,16 +15347,10 @@ aud_ctrl_get_cfg_prescale(struct drx_demod_instance *demod, struct drx_cfg_aud_p
 
 	 */
 	r_nicam_prescaler >>= 8;
-	if (r_nicam_prescaler <= 1) {
+	if (r_nicam_prescaler <= 1)
 		presc->nicam_gain = -241;
-	} else {
-
-		presc->nicam_gain = (s16) (((s32)
-					     (log1_times100
-					      (10 * r_nicam_prescaler *
-					       r_nicam_prescaler)) - (s32)
-					     (log1_times100(10 * 16 * 16))));
-	}
+	else
+		presc->nicam_gain = (s16)(((s32)(log1_times100(10 * r_nicam_prescaler * r_nicam_prescaler)) - (s32)(log1_times100(10 * 16 * 16))));
 
 	return DRX_STS_OK;
 rw_error:
@@ -15569,9 +15373,8 @@ aud_ctrl_set_cfg_prescale(struct drx_demod_instance *demod, struct drx_cfg_aud_p
 	u16 w_max_fm_deviation = 0;
 	u16 nicam_prescaler;
 
-	if (presc == NULL) {
+	if (presc == NULL)
 		return DRX_STS_INVALID_ARG;
-	}
 
 	dev_addr = demod->my_i2c_dev_addr;
 	ext_attr = (struct drxj_data *) demod->my_ext_attr;
@@ -15589,11 +15392,8 @@ aud_ctrl_set_cfg_prescale(struct drx_demod_instance *demod, struct drx_cfg_aud_p
 	/* setting of max FM deviation */
 	w_max_fm_deviation = (u16) (frac(3600UL, presc->fm_deviation, 0));
 	w_max_fm_deviation <<= AUD_DSP_WR_FM_PRESC_FM_AM_PRESC__B;
-	if (w_max_fm_deviation >=
-	    AUD_DSP_WR_FM_PRESC_FM_AM_PRESC_28_KHZ_FM_DEVIATION) {
-		w_max_fm_deviation =
-		    AUD_DSP_WR_FM_PRESC_FM_AM_PRESC_28_KHZ_FM_DEVIATION;
-	}
+	if (w_max_fm_deviation >= AUD_DSP_WR_FM_PRESC_FM_AM_PRESC_28_KHZ_FM_DEVIATION)
+		w_max_fm_deviation = AUD_DSP_WR_FM_PRESC_FM_AM_PRESC_28_KHZ_FM_DEVIATION;
 
 	/* NICAM Prescaler */
 	if ((presc->nicam_gain >= -241) && (presc->nicam_gain <= 180)) {
@@ -15618,9 +15418,8 @@ aud_ctrl_set_cfg_prescale(struct drx_demod_instance *demod, struct drx_cfg_aud_p
 		    ((d_b2lin_times100(presc->nicam_gain + 241UL) + 50UL) / 100UL);
 
 		/* clip result */
-		if (nicam_prescaler > 127) {
+		if (nicam_prescaler > 127)
 			nicam_prescaler = 127;
-		}
 
 		/* shift before writing to register */
 		nicam_prescaler <<= 8;
@@ -15663,9 +15462,8 @@ static int aud_ctrl_beep(struct drx_demod_instance *demod, struct drx_aud_beep *
 	u16 volume = 0;
 	u32 frequency = 0;
 
-	if (beep == NULL) {
+	if (beep == NULL)
 		return DRX_STS_INVALID_ARG;
-	}
 
 	dev_addr = demod->my_i2c_dev_addr;
 	ext_attr = (struct drxj_data *) demod->my_ext_attr;
@@ -15680,26 +15478,22 @@ static int aud_ctrl_beep(struct drx_demod_instance *demod, struct drx_aud_beep *
 		ext_attr->aud_data.audio_is_active = true;
 	}
 
-	if ((beep->volume > 0) || (beep->volume < -127)) {
+	if ((beep->volume > 0) || (beep->volume < -127))
 		return DRX_STS_INVALID_ARG;
-	}
 
-	if (beep->frequency > 3000) {
+	if (beep->frequency > 3000)
 		return DRX_STS_INVALID_ARG;
-	}
 
 	volume = (u16) beep->volume + 127;
 	the_beep |= volume << AUD_DSP_WR_BEEPER_BEEP_VOLUME__B;
 
 	frequency = ((u32) beep->frequency) * 23 / 500;
-	if (frequency > AUD_DSP_WR_BEEPER_BEEP_FREQUENCY__M) {
+	if (frequency > AUD_DSP_WR_BEEPER_BEEP_FREQUENCY__M)
 		frequency = AUD_DSP_WR_BEEPER_BEEP_FREQUENCY__M;
-	}
 	the_beep |= (u16) frequency;
 
-	if (beep->mute == true) {
+	if (beep->mute == true)
 		the_beep = 0;
-	}
 
 	rc = DRXJ_DAP.write_reg16func(dev_addr, AUD_DSP_WR_BEEPER__A, the_beep, 0);
 	if (rc != DRX_STS_OK) {
@@ -15734,9 +15528,8 @@ aud_ctrl_set_standard(struct drx_demod_instance *demod, enum drx_aud_standard *s
 	s16 volume_buffer = 0;
 	u16 w_volume = 0;
 
-	if (standard == NULL) {
+	if (standard == NULL)
 		return DRX_STS_INVALID_ARG;
-	}
 
 	dev_addr = (struct i2c_device_addr *)demod->my_i2c_dev_addr;
 	ext_attr = (struct drxj_data *) demod->my_ext_attr;
@@ -15817,9 +15610,8 @@ aud_ctrl_set_standard(struct drx_demod_instance *demod, enum drx_aud_standard *s
 		break;
 	case DRX_AUD_STANDARD_BTSC:
 		w_standard = AUD_DEM_WR_STANDARD_SEL_STD_SEL_BTSC_STEREO;
-		if (ext_attr->aud_data.btsc_detect == DRX_BTSC_MONO_AND_SAP) {
+		if (ext_attr->aud_data.btsc_detect == DRX_BTSC_MONO_AND_SAP)
 			w_standard = AUD_DEM_WR_STANDARD_SEL_STD_SEL_BTSC_SAP;
-		}
 		break;
 	case DRX_AUD_STANDARD_A2:
 		w_standard = AUD_DEM_WR_STANDARD_SEL_STD_SEL_M_KOREA;
@@ -15867,40 +15659,32 @@ aud_ctrl_set_standard(struct drx_demod_instance *demod, enum drx_aud_standard *s
 
 		w_modus &= (u16) ~AUD_DEM_WR_MODUS_MOD_6_5MHZ__M;
 
-		if ((current_standard == DRX_STANDARD_PAL_SECAM_L) ||
-		    (current_standard == DRX_STANDARD_PAL_SECAM_LP)) {
+		if ((current_standard == DRX_STANDARD_PAL_SECAM_L) || (current_standard == DRX_STANDARD_PAL_SECAM_LP))
 			w_modus |= (AUD_DEM_WR_MODUS_MOD_6_5MHZ_SECAM);
-		} else {
+		else
 			w_modus |= (AUD_DEM_WR_MODUS_MOD_6_5MHZ_D_K);
-		}
 
 		w_modus &= (u16) ~AUD_DEM_WR_MODUS_MOD_4_5MHZ__M;
-		if (current_standard == DRX_STANDARD_NTSC) {
+		if (current_standard == DRX_STANDARD_NTSC)
 			w_modus |= (AUD_DEM_WR_MODUS_MOD_4_5MHZ_M_BTSC);
-
-		} else {	/* non USA, ignore standard M to save time */
-
+		else
 			w_modus |= (AUD_DEM_WR_MODUS_MOD_4_5MHZ_CHROMA);
-		}
 
 	}
 
 	w_modus &= (u16) ~AUD_DEM_WR_MODUS_MOD_FMRADIO__M;
 
 	/* just get hardcoded deemphasis and activate here */
-	if (ext_attr->aud_data.deemph == DRX_AUD_FM_DEEMPH_50US) {
+	if (ext_attr->aud_data.deemph == DRX_AUD_FM_DEEMPH_50US)
 		w_modus |= (AUD_DEM_WR_MODUS_MOD_FMRADIO_EU_50U);
-	} else {
+	else
 		w_modus |= (AUD_DEM_WR_MODUS_MOD_FMRADIO_US_75U);
-	}
 
 	w_modus &= (u16) ~AUD_DEM_WR_MODUS_MOD_BTSC__M;
-	if (ext_attr->aud_data.btsc_detect == DRX_BTSC_STEREO) {
+	if (ext_attr->aud_data.btsc_detect == DRX_BTSC_STEREO)
 		w_modus |= (AUD_DEM_WR_MODUS_MOD_BTSC_BTSC_STEREO);
-	} else {		/* DRX_BTSC_MONO_AND_SAP */
-
+	else
 		w_modus |= (AUD_DEM_WR_MODUS_MOD_BTSC_BTSC_SAP);
-	}
 
 	if (w_modus != r_modus) {
 		rc = DRXJ_DAP.write_reg16func(dev_addr, AUD_DEM_WR_MODUS__A, w_modus, 0);
@@ -15955,9 +15739,8 @@ aud_ctrl_get_standard(struct drx_demod_instance *demod, enum drx_aud_standard *s
 	int rc;
 	u16 r_data = 0;
 
-	if (standard == NULL) {
+	if (standard == NULL)
 		return DRX_STS_INVALID_ARG;
-	}
 
 	ext_attr = (struct drxj_data *) demod->my_ext_attr;
 	dev_addr = (struct i2c_device_addr *)demod->my_i2c_dev_addr;
@@ -16076,11 +15859,10 @@ fm_lock_status(struct drx_demod_instance *demod, enum drx_lock_status *lock_stat
 	}
 
 	/* locked if either primary or secondary carrier is detected */
-	if ((status.carrier_a == true) || (status.carrier_b == true)) {
+	if ((status.carrier_a == true) || (status.carrier_b == true))
 		*lock_stat = DRX_LOCKED;
-	} else {
+	else
 		*lock_stat = DRX_NOT_LOCKED;
-	}
 
 	return DRX_STS_OK;
 
@@ -16110,11 +15892,10 @@ fm_sig_quality(struct drx_demod_instance *demod, struct drx_sig_quality *sig_qua
 		pr_err("error %d\n", rc);
 		goto rw_error;
 	}
-	if (lock_status == DRX_LOCKED) {
+	if (lock_status == DRX_LOCKED)
 		sig_quality->indicator = 100;
-	} else {
+	else
 		sig_quality->indicator = 0;
-	}
 
 	return DRX_STS_OK;
 
@@ -16177,11 +15958,10 @@ get_oob_lock_status(struct drx_demod_instance *demod,
 		/* 0x80 DEMOD + OOB LOCKED (system lock) */
 		oob_lock_state = scu_cmd.result[1] & 0x00FF;
 
-		if (oob_lock_state & 0x0008) {
+		if (oob_lock_state & 0x0008)
 			*oob_lock = DRXJ_OOB_SYNC_LOCK;
-		} else if ((oob_lock_state & 0x0002) && (oob_lock_state & 0x0001)) {
+		else if ((oob_lock_state & 0x0002) && (oob_lock_state & 0x0001))
 			*oob_lock = DRXJ_OOB_AGC_LOCK;
-		}
 	} else {
 		/* 0xC0 NEVER LOCKED (system will never be able to lock to the signal) */
 		*oob_lock = DRX_NEVER_LOCK;
@@ -16230,8 +16010,8 @@ get_oob_symbol_rate_offset(struct i2c_device_addr *dev_addr, s32 *symbol_rate_of
 	/* read data rate */
 	rc = drxj_dap_scu_atomic_read_reg16(dev_addr, SCU_RAM_ORX_RF_RX_DATA_RATE__A, &data, 0);
 	if (rc != DRX_STS_OK) {
-	pr_err("error %d\n", rc);
-	goto rw_error;
+		pr_err("error %d\n", rc);
+		goto rw_error;
 	}
 	switch (data & SCU_RAM_ORX_RF_RX_DATA_RATE__M) {
 	case SCU_RAM_ORX_RF_RX_DATA_RATE_2048KBPS_REGSPEC:
@@ -16254,8 +16034,8 @@ get_oob_symbol_rate_offset(struct i2c_device_addr *dev_addr, s32 *symbol_rate_of
 
 	rc = DRXJ_DAP.read_reg16func(dev_addr, ORX_CON_CTI_DTI_R__A, &data, 0);
 	if (rc != DRX_STS_OK) {
-	pr_err("error %d\n", rc);
-	goto rw_error;
+		pr_err("error %d\n", rc);
+		goto rw_error;
 	}
 	/* convert data to positive and keep information about sign */
 	if ((data & 0x8000) == 0x8000) {
@@ -16313,9 +16093,8 @@ get_oob_freq_offset(struct drx_demod_instance *demod, s32 *freq_offset)
 	u32 temp_freq_offset = 0;
 
 	/* check arguments */
-	if ((demod == NULL) || (freq_offset == NULL)) {
+	if ((demod == NULL) || (freq_offset == NULL))
 		return DRX_STS_INVALID_ARG;
-	}
 
 	dev_addr = demod->my_i2c_dev_addr;
 	common_attr = (struct drx_common_attr *) demod->my_common_attr;
@@ -16614,27 +16393,10 @@ static int set_orx_nsu_aox(struct drx_demod_instance *demod, bool active)
 		pr_err("error %d\n", rc);
 		goto rw_error;
 	}
-	if (!active) {
-		data &= ((~ORX_NSU_AOX_STDBY_W_STDBYADC_A2_ON)
-			 & (~ORX_NSU_AOX_STDBY_W_STDBYAMP_A2_ON)
-			 & (~ORX_NSU_AOX_STDBY_W_STDBYBIAS_A2_ON)
-			 & (~ORX_NSU_AOX_STDBY_W_STDBYPLL_A2_ON)
-			 & (~ORX_NSU_AOX_STDBY_W_STDBYPD_A2_ON)
-			 & (~ORX_NSU_AOX_STDBY_W_STDBYTAGC_IF_A2_ON)
-			 & (~ORX_NSU_AOX_STDBY_W_STDBYTAGC_RF_A2_ON)
-			 & (~ORX_NSU_AOX_STDBY_W_STDBYFLT_A2_ON)
-		    );
-	} else {		/* active */
-
-		data |= (ORX_NSU_AOX_STDBY_W_STDBYADC_A2_ON
-			 | ORX_NSU_AOX_STDBY_W_STDBYAMP_A2_ON
-			 | ORX_NSU_AOX_STDBY_W_STDBYBIAS_A2_ON
-			 | ORX_NSU_AOX_STDBY_W_STDBYPLL_A2_ON
-			 | ORX_NSU_AOX_STDBY_W_STDBYPD_A2_ON
-			 | ORX_NSU_AOX_STDBY_W_STDBYTAGC_IF_A2_ON
-			 | ORX_NSU_AOX_STDBY_W_STDBYTAGC_RF_A2_ON
-			 | ORX_NSU_AOX_STDBY_W_STDBYFLT_A2_ON);
-	}
+	if (!active)
+		data &= ((~ORX_NSU_AOX_STDBY_W_STDBYADC_A2_ON) & (~ORX_NSU_AOX_STDBY_W_STDBYAMP_A2_ON) & (~ORX_NSU_AOX_STDBY_W_STDBYBIAS_A2_ON) & (~ORX_NSU_AOX_STDBY_W_STDBYPLL_A2_ON) & (~ORX_NSU_AOX_STDBY_W_STDBYPD_A2_ON) & (~ORX_NSU_AOX_STDBY_W_STDBYTAGC_IF_A2_ON) & (~ORX_NSU_AOX_STDBY_W_STDBYTAGC_RF_A2_ON) & (~ORX_NSU_AOX_STDBY_W_STDBYFLT_A2_ON));
+	else
+		data |= (ORX_NSU_AOX_STDBY_W_STDBYADC_A2_ON | ORX_NSU_AOX_STDBY_W_STDBYAMP_A2_ON | ORX_NSU_AOX_STDBY_W_STDBYBIAS_A2_ON | ORX_NSU_AOX_STDBY_W_STDBYPLL_A2_ON | ORX_NSU_AOX_STDBY_W_STDBYPD_A2_ON | ORX_NSU_AOX_STDBY_W_STDBYTAGC_IF_A2_ON | ORX_NSU_AOX_STDBY_W_STDBYTAGC_RF_A2_ON | ORX_NSU_AOX_STDBY_W_STDBYFLT_A2_ON);
 	rc = DRXJ_DAP.write_reg16func(dev_addr, ORX_NSU_AOX_STDBY_W__A, data, 0);
 	if (rc != DRX_STS_OK) {
 		pr_err("error %d\n", rc);
@@ -16722,8 +16484,8 @@ static int ctrl_set_oob(struct drx_demod_instance *demod, struct drxoob *oob_par
 		}
 		rc = DRXJ_DAP.write_reg16func(dev_addr, ORX_COMM_EXEC__A, ORX_COMM_EXEC_STOP, 0);
 		if (rc != DRX_STS_OK) {
-		pr_err("error %d\n", rc);
-		goto rw_error;
+			pr_err("error %d\n", rc);
+			goto rw_error;
 		}
 
 		ext_attr->oob_power_on = false;
@@ -16754,8 +16516,8 @@ static int ctrl_set_oob(struct drx_demod_instance *demod, struct drxoob *oob_par
    /*********/
 	rc = DRXJ_DAP.write_reg16func(dev_addr, ORX_COMM_EXEC__A, ORX_COMM_EXEC_STOP, 0);
 	if (rc != DRX_STS_OK) {
-	pr_err("error %d\n", rc);
-	goto rw_error;
+		pr_err("error %d\n", rc);
+		goto rw_error;
 	}
 	scu_cmd.command = SCU_RAM_COMMAND_STANDARD_OOB
 	    | SCU_RAM_COMMAND_CMD_DEMOD_STOP;
@@ -16859,289 +16621,289 @@ static int ctrl_set_oob(struct drx_demod_instance *demod, struct drxoob *oob_par
 
 	rc = DRXJ_DAP.write_reg16func(dev_addr, SIO_TOP_COMM_KEY__A, 0xFABA, 0);
 	if (rc != DRX_STS_OK) {
-	pr_err("error %d\n", rc);
-	goto rw_error;
+		pr_err("error %d\n", rc);
+		goto rw_error;
 	}	/*  Write magic word to enable pdr reg write  */
 	rc = DRXJ_DAP.write_reg16func(dev_addr, SIO_PDR_OOB_CRX_CFG__A, OOB_CRX_DRIVE_STRENGTH << SIO_PDR_OOB_CRX_CFG_DRIVE__B | 0x03 << SIO_PDR_OOB_CRX_CFG_MODE__B, 0);
 	if (rc != DRX_STS_OK) {
-	pr_err("error %d\n", rc);
-	goto rw_error;
+		pr_err("error %d\n", rc);
+		goto rw_error;
 	}
 	rc = DRXJ_DAP.write_reg16func(dev_addr, SIO_PDR_OOB_DRX_CFG__A, OOB_DRX_DRIVE_STRENGTH << SIO_PDR_OOB_DRX_CFG_DRIVE__B | 0x03 << SIO_PDR_OOB_DRX_CFG_MODE__B, 0);
 	if (rc != DRX_STS_OK) {
-	pr_err("error %d\n", rc);
-	goto rw_error;
+		pr_err("error %d\n", rc);
+		goto rw_error;
 	}
 	rc = DRXJ_DAP.write_reg16func(dev_addr, SIO_TOP_COMM_KEY__A, 0x0000, 0);
 	if (rc != DRX_STS_OK) {
-	pr_err("error %d\n", rc);
-	goto rw_error;
+		pr_err("error %d\n", rc);
+		goto rw_error;
 	}	/*  Write magic word to disable pdr reg write */
 
 	rc = DRXJ_DAP.write_reg16func(dev_addr, ORX_TOP_COMM_KEY__A, 0, 0);
 	if (rc != DRX_STS_OK) {
-	pr_err("error %d\n", rc);
-	goto rw_error;
+		pr_err("error %d\n", rc);
+		goto rw_error;
 	}
 	rc = DRXJ_DAP.write_reg16func(dev_addr, ORX_FWP_AAG_LEN_W__A, 16000, 0);
 	if (rc != DRX_STS_OK) {
-	pr_err("error %d\n", rc);
-	goto rw_error;
+		pr_err("error %d\n", rc);
+		goto rw_error;
 	}
 	rc = DRXJ_DAP.write_reg16func(dev_addr, ORX_FWP_AAG_THR_W__A, 40, 0);
 	if (rc != DRX_STS_OK) {
-	pr_err("error %d\n", rc);
-	goto rw_error;
+		pr_err("error %d\n", rc);
+		goto rw_error;
 	}
 
 	/* ddc */
 	rc = DRXJ_DAP.write_reg16func(dev_addr, ORX_DDC_OFO_SET_W__A, ORX_DDC_OFO_SET_W__PRE, 0);
 	if (rc != DRX_STS_OK) {
-	pr_err("error %d\n", rc);
-	goto rw_error;
+		pr_err("error %d\n", rc);
+		goto rw_error;
 	}
 
 	/* nsu */
 	rc = DRXJ_DAP.write_reg16func(dev_addr, ORX_NSU_AOX_LOPOW_W__A, ext_attr->oob_lo_pow, 0);
 	if (rc != DRX_STS_OK) {
-	pr_err("error %d\n", rc);
-	goto rw_error;
+		pr_err("error %d\n", rc);
+		goto rw_error;
 	}
 
 	/* initialization for target mode */
 	rc = DRXJ_DAP.write_reg16func(dev_addr, SCU_RAM_ORX_TARGET_MODE__A, SCU_RAM_ORX_TARGET_MODE_2048KBPS_SQRT, 0);
 	if (rc != DRX_STS_OK) {
-	pr_err("error %d\n", rc);
-	goto rw_error;
+		pr_err("error %d\n", rc);
+		goto rw_error;
 	}
 	rc = DRXJ_DAP.write_reg16func(dev_addr, SCU_RAM_ORX_FREQ_GAIN_CORR__A, SCU_RAM_ORX_FREQ_GAIN_CORR_2048KBPS, 0);
 	if (rc != DRX_STS_OK) {
-	pr_err("error %d\n", rc);
-	goto rw_error;
+		pr_err("error %d\n", rc);
+		goto rw_error;
 	}
 
 	/* Reset bits for timing and freq. recovery */
 	rc = DRXJ_DAP.write_reg16func(dev_addr, SCU_RAM_ORX_RST_CPH__A, 0x0001, 0);
 	if (rc != DRX_STS_OK) {
-	pr_err("error %d\n", rc);
-	goto rw_error;
+		pr_err("error %d\n", rc);
+		goto rw_error;
 	}
 	rc = DRXJ_DAP.write_reg16func(dev_addr, SCU_RAM_ORX_RST_CTI__A, 0x0002, 0);
 	if (rc != DRX_STS_OK) {
-	pr_err("error %d\n", rc);
-	goto rw_error;
+		pr_err("error %d\n", rc);
+		goto rw_error;
 	}
 	rc = DRXJ_DAP.write_reg16func(dev_addr, SCU_RAM_ORX_RST_KRN__A, 0x0004, 0);
 	if (rc != DRX_STS_OK) {
-	pr_err("error %d\n", rc);
-	goto rw_error;
+		pr_err("error %d\n", rc);
+		goto rw_error;
 	}
 	rc = DRXJ_DAP.write_reg16func(dev_addr, SCU_RAM_ORX_RST_KRP__A, 0x0008, 0);
 	if (rc != DRX_STS_OK) {
-	pr_err("error %d\n", rc);
-	goto rw_error;
+		pr_err("error %d\n", rc);
+		goto rw_error;
 	}
 
 	/* AGN_LOCK = {2048>>3, -2048, 8, -8, 0, 1}; */
 	rc = DRXJ_DAP.write_reg16func(dev_addr, SCU_RAM_ORX_AGN_LOCK_TH__A, 2048 >> 3, 0);
 	if (rc != DRX_STS_OK) {
-	pr_err("error %d\n", rc);
-	goto rw_error;
+		pr_err("error %d\n", rc);
+		goto rw_error;
 	}
 	rc = DRXJ_DAP.write_reg16func(dev_addr, SCU_RAM_ORX_AGN_LOCK_TOTH__A, (u16)(-2048), 0);
 	if (rc != DRX_STS_OK) {
-	pr_err("error %d\n", rc);
-	goto rw_error;
+		pr_err("error %d\n", rc);
+		goto rw_error;
 	}
 	rc = DRXJ_DAP.write_reg16func(dev_addr, SCU_RAM_ORX_AGN_ONLOCK_TTH__A, 8, 0);
 	if (rc != DRX_STS_OK) {
-	pr_err("error %d\n", rc);
-	goto rw_error;
+		pr_err("error %d\n", rc);
+		goto rw_error;
 	}
 	rc = DRXJ_DAP.write_reg16func(dev_addr, SCU_RAM_ORX_AGN_UNLOCK_TTH__A, (u16)(-8), 0);
 	if (rc != DRX_STS_OK) {
-	pr_err("error %d\n", rc);
-	goto rw_error;
+		pr_err("error %d\n", rc);
+		goto rw_error;
 	}
 	rc = DRXJ_DAP.write_reg16func(dev_addr, SCU_RAM_ORX_AGN_LOCK_MASK__A, 1, 0);
 	if (rc != DRX_STS_OK) {
-	pr_err("error %d\n", rc);
-	goto rw_error;
+		pr_err("error %d\n", rc);
+		goto rw_error;
 	}
 
 	/* DGN_LOCK = {10, -2048, 8, -8, 0, 1<<1}; */
 	rc = DRXJ_DAP.write_reg16func(dev_addr, SCU_RAM_ORX_DGN_LOCK_TH__A, 10, 0);
 	if (rc != DRX_STS_OK) {
-	pr_err("error %d\n", rc);
-	goto rw_error;
+		pr_err("error %d\n", rc);
+		goto rw_error;
 	}
 	rc = DRXJ_DAP.write_reg16func(dev_addr, SCU_RAM_ORX_DGN_LOCK_TOTH__A, (u16)(-2048), 0);
 	if (rc != DRX_STS_OK) {
-	pr_err("error %d\n", rc);
-	goto rw_error;
+		pr_err("error %d\n", rc);
+		goto rw_error;
 	}
 	rc = DRXJ_DAP.write_reg16func(dev_addr, SCU_RAM_ORX_DGN_ONLOCK_TTH__A, 8, 0);
 	if (rc != DRX_STS_OK) {
-	pr_err("error %d\n", rc);
-	goto rw_error;
+		pr_err("error %d\n", rc);
+		goto rw_error;
 	}
 	rc = DRXJ_DAP.write_reg16func(dev_addr, SCU_RAM_ORX_DGN_UNLOCK_TTH__A, (u16)(-8), 0);
 	if (rc != DRX_STS_OK) {
-	pr_err("error %d\n", rc);
-	goto rw_error;
+		pr_err("error %d\n", rc);
+		goto rw_error;
 	}
 	rc = DRXJ_DAP.write_reg16func(dev_addr, SCU_RAM_ORX_DGN_LOCK_MASK__A, 1 << 1, 0);
 	if (rc != DRX_STS_OK) {
-	pr_err("error %d\n", rc);
-	goto rw_error;
+		pr_err("error %d\n", rc);
+		goto rw_error;
 	}
 
 	/* FRQ_LOCK = {15,-2048, 8, -8, 0, 1<<2}; */
 	rc = DRXJ_DAP.write_reg16func(dev_addr, SCU_RAM_ORX_FRQ_LOCK_TH__A, 17, 0);
 	if (rc != DRX_STS_OK) {
-	pr_err("error %d\n", rc);
-	goto rw_error;
+		pr_err("error %d\n", rc);
+		goto rw_error;
 	}
 	rc = DRXJ_DAP.write_reg16func(dev_addr, SCU_RAM_ORX_FRQ_LOCK_TOTH__A, (u16)(-2048), 0);
 	if (rc != DRX_STS_OK) {
-	pr_err("error %d\n", rc);
-	goto rw_error;
+		pr_err("error %d\n", rc);
+		goto rw_error;
 	}
 	rc = DRXJ_DAP.write_reg16func(dev_addr, SCU_RAM_ORX_FRQ_ONLOCK_TTH__A, 8, 0);
 	if (rc != DRX_STS_OK) {
-	pr_err("error %d\n", rc);
-	goto rw_error;
+		pr_err("error %d\n", rc);
+		goto rw_error;
 	}
 	rc = DRXJ_DAP.write_reg16func(dev_addr, SCU_RAM_ORX_FRQ_UNLOCK_TTH__A, (u16)(-8), 0);
 	if (rc != DRX_STS_OK) {
-	pr_err("error %d\n", rc);
-	goto rw_error;
+		pr_err("error %d\n", rc);
+		goto rw_error;
 	}
 	rc = DRXJ_DAP.write_reg16func(dev_addr, SCU_RAM_ORX_FRQ_LOCK_MASK__A, 1 << 2, 0);
 	if (rc != DRX_STS_OK) {
-	pr_err("error %d\n", rc);
-	goto rw_error;
+		pr_err("error %d\n", rc);
+		goto rw_error;
 	}
 
 	/* PHA_LOCK = {5000, -2048, 8, -8, 0, 1<<3}; */
 	rc = DRXJ_DAP.write_reg16func(dev_addr, SCU_RAM_ORX_PHA_LOCK_TH__A, 3000, 0);
 	if (rc != DRX_STS_OK) {
-	pr_err("error %d\n", rc);
-	goto rw_error;
+		pr_err("error %d\n", rc);
+		goto rw_error;
 	}
 	rc = DRXJ_DAP.write_reg16func(dev_addr, SCU_RAM_ORX_PHA_LOCK_TOTH__A, (u16)(-2048), 0);
 	if (rc != DRX_STS_OK) {
-	pr_err("error %d\n", rc);
-	goto rw_error;
+		pr_err("error %d\n", rc);
+		goto rw_error;
 	}
 	rc = DRXJ_DAP.write_reg16func(dev_addr, SCU_RAM_ORX_PHA_ONLOCK_TTH__A, 8, 0);
 	if (rc != DRX_STS_OK) {
-	pr_err("error %d\n", rc);
-	goto rw_error;
+		pr_err("error %d\n", rc);
+		goto rw_error;
 	}
 	rc = DRXJ_DAP.write_reg16func(dev_addr, SCU_RAM_ORX_PHA_UNLOCK_TTH__A, (u16)(-8), 0);
 	if (rc != DRX_STS_OK) {
-	pr_err("error %d\n", rc);
-	goto rw_error;
+		pr_err("error %d\n", rc);
+		goto rw_error;
 	}
 	rc = DRXJ_DAP.write_reg16func(dev_addr, SCU_RAM_ORX_PHA_LOCK_MASK__A, 1 << 3, 0);
 	if (rc != DRX_STS_OK) {
-	pr_err("error %d\n", rc);
-	goto rw_error;
+		pr_err("error %d\n", rc);
+		goto rw_error;
 	}
 
 	/* TIM_LOCK = {300,      -2048, 8, -8, 0, 1<<4}; */
 	rc = DRXJ_DAP.write_reg16func(dev_addr, SCU_RAM_ORX_TIM_LOCK_TH__A, 400, 0);
 	if (rc != DRX_STS_OK) {
-	pr_err("error %d\n", rc);
-	goto rw_error;
+		pr_err("error %d\n", rc);
+		goto rw_error;
 	}
 	rc = DRXJ_DAP.write_reg16func(dev_addr, SCU_RAM_ORX_TIM_LOCK_TOTH__A, (u16)(-2048), 0);
 	if (rc != DRX_STS_OK) {
-	pr_err("error %d\n", rc);
-	goto rw_error;
+		pr_err("error %d\n", rc);
+		goto rw_error;
 	}
 	rc = DRXJ_DAP.write_reg16func(dev_addr, SCU_RAM_ORX_TIM_ONLOCK_TTH__A, 8, 0);
 	if (rc != DRX_STS_OK) {
-	pr_err("error %d\n", rc);
-	goto rw_error;
+		pr_err("error %d\n", rc);
+		goto rw_error;
 	}
 	rc = DRXJ_DAP.write_reg16func(dev_addr, SCU_RAM_ORX_TIM_UNLOCK_TTH__A, (u16)(-8), 0);
 	if (rc != DRX_STS_OK) {
-	pr_err("error %d\n", rc);
-	goto rw_error;
+		pr_err("error %d\n", rc);
+		goto rw_error;
 	}
 	rc = DRXJ_DAP.write_reg16func(dev_addr, SCU_RAM_ORX_TIM_LOCK_MASK__A, 1 << 4, 0);
 	if (rc != DRX_STS_OK) {
-	pr_err("error %d\n", rc);
-	goto rw_error;
+		pr_err("error %d\n", rc);
+		goto rw_error;
 	}
 
 	/* EQU_LOCK = {20,      -2048, 8, -8, 0, 1<<5}; */
 	rc = DRXJ_DAP.write_reg16func(dev_addr, SCU_RAM_ORX_EQU_LOCK_TH__A, 20, 0);
 	if (rc != DRX_STS_OK) {
-	pr_err("error %d\n", rc);
-	goto rw_error;
+		pr_err("error %d\n", rc);
+		goto rw_error;
 	}
 	rc = DRXJ_DAP.write_reg16func(dev_addr, SCU_RAM_ORX_EQU_LOCK_TOTH__A, (u16)(-2048), 0);
 	if (rc != DRX_STS_OK) {
-	pr_err("error %d\n", rc);
-	goto rw_error;
+		pr_err("error %d\n", rc);
+		goto rw_error;
 	}
 	rc = DRXJ_DAP.write_reg16func(dev_addr, SCU_RAM_ORX_EQU_ONLOCK_TTH__A, 4, 0);
 	if (rc != DRX_STS_OK) {
-	pr_err("error %d\n", rc);
-	goto rw_error;
+		pr_err("error %d\n", rc);
+		goto rw_error;
 	}
 	rc = DRXJ_DAP.write_reg16func(dev_addr, SCU_RAM_ORX_EQU_UNLOCK_TTH__A, (u16)(-4), 0);
 	if (rc != DRX_STS_OK) {
-	pr_err("error %d\n", rc);
-	goto rw_error;
+		pr_err("error %d\n", rc);
+		goto rw_error;
 	}
 	rc = DRXJ_DAP.write_reg16func(dev_addr, SCU_RAM_ORX_EQU_LOCK_MASK__A, 1 << 5, 0);
 	if (rc != DRX_STS_OK) {
-	pr_err("error %d\n", rc);
-	goto rw_error;
+		pr_err("error %d\n", rc);
+		goto rw_error;
 	}
 
 	/* PRE-Filter coefficients (PFI) */
 	rc = DRXJ_DAP.write_block_func(dev_addr, ORX_FWP_PFI_A_W__A, sizeof(pfi_coeffs[mode_index]), ((u8 *)pfi_coeffs[mode_index]), 0);
 	if (rc != DRX_STS_OK) {
-	pr_err("error %d\n", rc);
-	goto rw_error;
+		pr_err("error %d\n", rc);
+		goto rw_error;
 	}
 	rc = DRXJ_DAP.write_reg16func(dev_addr, ORX_TOP_MDE_W__A, mode_index, 0);
 	if (rc != DRX_STS_OK) {
-	pr_err("error %d\n", rc);
-	goto rw_error;
+		pr_err("error %d\n", rc);
+		goto rw_error;
 	}
 
 	/* NYQUIST-Filter coefficients (NYQ) */
 	for (i = 0; i < (NYQFILTERLEN + 1) / 2; i++) {
 		rc = DRXJ_DAP.write_reg16func(dev_addr, ORX_FWP_NYQ_ADR_W__A, i, 0);
 		if (rc != DRX_STS_OK) {
-		pr_err("error %d\n", rc);
-		goto rw_error;
+			pr_err("error %d\n", rc);
+			goto rw_error;
 		}
 		rc = DRXJ_DAP.write_reg16func(dev_addr, ORX_FWP_NYQ_COF_RW__A, nyquist_coeffs[mode_index][i], 0);
 		if (rc != DRX_STS_OK) {
-		pr_err("error %d\n", rc);
-		goto rw_error;
+			pr_err("error %d\n", rc);
+			goto rw_error;
 		}
 	}
 	rc = DRXJ_DAP.write_reg16func(dev_addr, ORX_FWP_NYQ_ADR_W__A, 31, 0);
 	if (rc != DRX_STS_OK) {
-	pr_err("error %d\n", rc);
-	goto rw_error;
+		pr_err("error %d\n", rc);
+		goto rw_error;
 	}
 	rc = DRXJ_DAP.write_reg16func(dev_addr, ORX_COMM_EXEC__A, ORX_COMM_EXEC_ACTIVE, 0);
 	if (rc != DRX_STS_OK) {
-	pr_err("error %d\n", rc);
-	goto rw_error;
+		pr_err("error %d\n", rc);
+		goto rw_error;
 	}
-   /*********/
+	/*********/
 	/* Start */
-   /*********/
+	/*********/
 	scu_cmd.command = SCU_RAM_COMMAND_STANDARD_OOB
 	    | SCU_RAM_COMMAND_CMD_DEMOD_START;
 	scu_cmd.parameter_len = 0;
@@ -17160,8 +16922,8 @@ static int ctrl_set_oob(struct drx_demod_instance *demod, struct drxoob *oob_par
 	}
 	rc = DRXJ_DAP.write_reg16func(dev_addr, ORX_NSU_AOX_STHR_W__A, ext_attr->oob_pre_saw, 0);
 	if (rc != DRX_STS_OK) {
-	pr_err("error %d\n", rc);
-	goto rw_error;
+		pr_err("error %d\n", rc);
+		goto rw_error;
 	}
 
 	ext_attr->oob_power_on = true;
@@ -17192,37 +16954,36 @@ ctrl_get_oob(struct drx_demod_instance *demod, struct drxoob_status *oob_status)
 	ext_attr = (struct drxj_data *) demod->my_ext_attr;
 
 	/* check arguments */
-	if (oob_status == NULL) {
+	if (oob_status == NULL)
 		return DRX_STS_INVALID_ARG;
-	}
 
 	if (!ext_attr->oob_power_on)
 		return DRX_STS_ERROR;
 
 	rc = DRXJ_DAP.read_reg16func(dev_addr, ORX_DDC_OFO_SET_W__A, &data, 0);
 	if (rc != DRX_STS_OK) {
-	pr_err("error %d\n", rc);
-	goto rw_error;
+		pr_err("error %d\n", rc);
+		goto rw_error;
 	}
 	rc = DRXJ_DAP.read_reg16func(dev_addr, ORX_NSU_TUN_RFGAIN_W__A, &data, 0);
 	if (rc != DRX_STS_OK) {
-	pr_err("error %d\n", rc);
-	goto rw_error;
+		pr_err("error %d\n", rc);
+		goto rw_error;
 	}
 	rc = DRXJ_DAP.read_reg16func(dev_addr, ORX_FWP_AAG_THR_W__A, &data, 0);
 	if (rc != DRX_STS_OK) {
-	pr_err("error %d\n", rc);
-	goto rw_error;
+		pr_err("error %d\n", rc);
+		goto rw_error;
 	}
 	rc = drxj_dap_scu_atomic_read_reg16(dev_addr, SCU_RAM_ORX_DGN_KI__A, &data, 0);
 	if (rc != DRX_STS_OK) {
-	pr_err("error %d\n", rc);
-	goto rw_error;
+		pr_err("error %d\n", rc);
+		goto rw_error;
 	}
 	rc = DRXJ_DAP.read_reg16func(dev_addr, ORX_FWP_SRC_DGN_W__A, &data, 0);
 	if (rc != DRX_STS_OK) {
-	pr_err("error %d\n", rc);
-	goto rw_error;
+		pr_err("error %d\n", rc);
+		goto rw_error;
 	}
 
 	rc = get_oob_lock_status(demod, dev_addr, &oob_status->lock);
@@ -17266,9 +17027,9 @@ ctrl_set_cfg_oob_pre_saw(struct drx_demod_instance *demod, u16 *cfg_data)
 	struct drxj_data *ext_attr = NULL;
 	int rc;
 
-	if (cfg_data == NULL) {
+	if (cfg_data == NULL)
 		return DRX_STS_INVALID_ARG;
-	}
+
 	dev_addr = demod->my_i2c_dev_addr;
 	ext_attr = (struct drxj_data *) demod->my_ext_attr;
 
@@ -17296,9 +17057,9 @@ ctrl_get_cfg_oob_pre_saw(struct drx_demod_instance *demod, u16 *cfg_data)
 {
 	struct drxj_data *ext_attr = NULL;
 
-	if (cfg_data == NULL) {
+	if (cfg_data == NULL)
 		return DRX_STS_INVALID_ARG;
-	}
+
 	ext_attr = (struct drxj_data *) demod->my_ext_attr;
 
 	*cfg_data = ext_attr->oob_pre_saw;
@@ -17320,9 +17081,9 @@ ctrl_set_cfg_oob_lo_power(struct drx_demod_instance *demod, enum drxj_cfg_oob_lo
 	struct drxj_data *ext_attr = NULL;
 	int rc;
 
-	if (cfg_data == NULL) {
+	if (cfg_data == NULL)
 		return DRX_STS_INVALID_ARG;
-	}
+
 	dev_addr = demod->my_i2c_dev_addr;
 	ext_attr = (struct drxj_data *) demod->my_ext_attr;
 
@@ -17349,9 +17110,9 @@ ctrl_get_cfg_oob_lo_power(struct drx_demod_instance *demod, enum drxj_cfg_oob_lo
 {
 	struct drxj_data *ext_attr = NULL;
 
-	if (cfg_data == NULL) {
+	if (cfg_data == NULL)
 		return DRX_STS_INVALID_ARG;
-	}
+
 	ext_attr = (struct drxj_data *) demod->my_ext_attr;
 
 	*cfg_data = ext_attr->oob_lo_pow;
@@ -17402,9 +17163,8 @@ ctrl_set_channel(struct drx_demod_instance *demod, struct drx_channel *channel)
 	int bandwidth = 0;
 #endif
    /*== check arguments ======================================================*/
-	if ((demod == NULL) || (channel == NULL)) {
+	if ((demod == NULL) || (channel == NULL))
 		return DRX_STS_INVALID_ARG;
-	}
 
 	common_attr = (struct drx_common_attr *) demod->my_common_attr;
 	dev_addr = demod->my_i2c_dev_addr;
@@ -17515,9 +17275,8 @@ ctrl_set_channel(struct drx_demod_instance *demod, struct drx_channel *channel)
 			bandwidth_temp = channel->symbolrate * bw_rolloff_factor;
 			bandwidth = bandwidth_temp / 100;
 
-			if ((bandwidth_temp % 100) >= 50) {
+			if ((bandwidth_temp % 100) >= 50)
 				bandwidth++;
-			}
 
 			if (bandwidth <= 6100000) {
 				channel->bandwidth = DRX_BANDWIDTH_6MHZ;
@@ -17709,11 +17468,10 @@ ctrl_set_channel(struct drx_demod_instance *demod, struct drx_channel *channel)
    /*== Setup demod for specific standard ====================================*/
 	switch (standard) {
 	case DRX_STANDARD_8VSB:
-		if (channel->mirror == DRX_MIRROR_AUTO) {
+		if (channel->mirror == DRX_MIRROR_AUTO)
 			ext_attr->mirror = DRX_MIRROR_NO;
-		} else {
+		else
 			ext_attr->mirror = channel->mirror;
-		}
 		rc = set_vsb(demod);
 		if (rc != DRX_STS_OK) {
 			pr_err("error %d\n", rc);
@@ -17733,11 +17491,10 @@ ctrl_set_channel(struct drx_demod_instance *demod, struct drx_channel *channel)
 	case DRX_STANDARD_PAL_SECAM_I:	/* fallthrough */
 	case DRX_STANDARD_PAL_SECAM_L:	/* fallthrough */
 	case DRX_STANDARD_PAL_SECAM_LP:
-		if (channel->mirror == DRX_MIRROR_AUTO) {
+		if (channel->mirror == DRX_MIRROR_AUTO)
 			ext_attr->mirror = DRX_MIRROR_NO;
-		} else {
+		else
 			ext_attr->mirror = channel->mirror;
-		}
 		rc = set_atv_channel(demod, tuner_freq_offset, channel, standard);
 		if (rc != DRX_STS_OK) {
 			pr_err("error %d\n", rc);
@@ -17832,9 +17589,8 @@ ctrl_get_channel(struct drx_demod_instance *demod, struct drx_channel *channel)
 #endif
 
 	/* check arguments */
-	if ((demod == NULL) || (channel == NULL)) {
+	if ((demod == NULL) || (channel == NULL))
 		return DRX_STS_INVALID_ARG;
-	}
 
 	dev_addr = demod->my_i2c_dev_addr;
 	ext_attr = (struct drxj_data *) demod->my_ext_attr;
@@ -17878,9 +17634,8 @@ ctrl_get_channel(struct drx_demod_instance *demod, struct drx_channel *channel)
 		}
 
 		/* Handle sound carrier offset in RF domain */
-		if (standard == DRX_STANDARD_FM) {
+		if (standard == DRX_STANDARD_FM)
 			channel->frequency -= DRXJ_FM_CARRIER_FREQ_OFFSET;
-		}
 	} else {
 		intermediate_freq = common_attr->intermediate_freq;
 	}
@@ -17935,17 +17690,15 @@ ctrl_get_channel(struct drx_demod_instance *demod, struct drx_channel *channel)
 
 					u32 roll_off = 113;	/* default annex C */
 
-					if (standard == DRX_STANDARD_ITU_A) {
+					if (standard == DRX_STANDARD_ITU_A)
 						roll_off = 115;
-					}
 
 					bandwidth_temp =
 					    channel->symbolrate * roll_off;
 					bandwidth = bandwidth_temp / 100;
 
-					if ((bandwidth_temp % 100) >= 50) {
+					if ((bandwidth_temp % 100) >= 50)
 						bandwidth++;
-					}
 
 					if (bandwidth <= 6000000) {
 						channel->bandwidth =
@@ -17961,13 +17714,7 @@ ctrl_get_channel(struct drx_demod_instance *demod, struct drx_channel *channel)
 				}	/* if (standard == DRX_STANDARD_ITU_B) */
 
 				{
-					struct drxjscu_cmd cmd_scu =
-					    { /* command      */ 0,
-						/* parameter_len */ 0,
-						/* result_len    */ 0,
-						/* parameter    */ NULL,
-						/* result       */ NULL
-					};
+					struct drxjscu_cmd cmd_scu = { 0, 0, NULL, NULL };
 					u16 cmd_result[3] = { 0, 0, 0 };
 
 					cmd_scu.command =
@@ -18037,9 +17784,8 @@ ctrl_get_channel(struct drx_demod_instance *demod, struct drx_channel *channel)
 			return DRX_STS_ERROR;
 		}		/* switch ( standard ) */
 
-		if (lock_status == DRX_LOCKED) {
+		if (lock_status == DRX_LOCKED)
 			channel->mirror = ext_attr->mirror;
-		}
 	}
 	/* if ( lock_status == DRX_LOCKED ) */
 	return DRX_STS_OK;
@@ -18059,18 +17805,13 @@ mer2indicator(u16 mer, u16 min_mer, u16 threshold_mer, u16 max_mer)
 	if (mer < min_mer) {
 		indicator = 0;
 	} else if (mer < threshold_mer) {
-		if ((threshold_mer - min_mer) != 0) {
-			indicator =
-			    25 * (mer - min_mer) / (threshold_mer - min_mer);
-		}
+		if ((threshold_mer - min_mer) != 0)
+			indicator = 25 * (mer - min_mer) / (threshold_mer - min_mer);
 	} else if (mer < max_mer) {
-		if ((max_mer - threshold_mer) != 0) {
-			indicator =
-			    25 + 75 * (mer - threshold_mer) / (max_mer -
-							      threshold_mer);
-		} else {
+		if ((max_mer - threshold_mer) != 0)
+			indicator = 25 + 75 * (mer - threshold_mer) / (max_mer - threshold_mer);
+		else
 			indicator = 25;
-		}
 	} else {
 		indicator = 100;
 	}
@@ -18102,9 +17843,8 @@ ctrl_sig_quality(struct drx_demod_instance *demod, struct drx_sig_quality *sig_q
 	u16 threshold_mer = 0;
 
 	/* Check arguments */
-	if ((sig_quality == NULL) || (demod == NULL)) {
+	if ((sig_quality == NULL) || (demod == NULL))
 		return DRX_STS_INVALID_ARG;
-	}
 
 	ext_attr = (struct drxj_data *) demod->my_ext_attr;
 	standard = ext_attr->standard;
@@ -18274,9 +18014,8 @@ ctrl_lock_status(struct drx_demod_instance *demod, enum drx_lock_status *lock_st
 	u16 demod_lock = SCU_RAM_PARAM_1_RES_DEMOD_GET_LOCK_DEMOD_LOCKED;
 
 	/* check arguments */
-	if ((demod == NULL) || (lock_stat == NULL)) {
+	if ((demod == NULL) || (lock_stat == NULL))
 		return DRX_STS_INVALID_ARG;
-	}
 
 	dev_addr = demod->my_i2c_dev_addr;
 	ext_attr = (struct drxj_data *) demod->my_ext_attr;
@@ -18367,9 +18106,8 @@ ctrl_constel(struct drx_demod_instance *demod, struct drx_complex *complex_nr)
 						     /**< active standard */
 
 	/* check arguments */
-	if ((demod == NULL) || (complex_nr == NULL)) {
+	if ((demod == NULL) || (complex_nr == NULL))
 		return DRX_STS_INVALID_ARG;
-	}
 
 	/* read device info */
 	standard = ((struct drxj_data *) demod->my_ext_attr)->standard;
@@ -18424,9 +18162,8 @@ ctrl_set_standard(struct drx_demod_instance *demod, enum drx_standard *standard)
 	enum drx_standard prev_standard;
 
 	/* check arguments */
-	if ((standard == NULL) || (demod == NULL)) {
+	if ((standard == NULL) || (demod == NULL))
 		return DRX_STS_INVALID_ARG;
-	}
 
 	ext_attr = (struct drxj_data *) demod->my_ext_attr;
 	prev_standard = ext_attr->standard;
@@ -18494,7 +18231,7 @@ ctrl_set_standard(struct drx_demod_instance *demod, enum drx_standard *standard)
 				pr_err("error %d\n", rc);
 				goto rw_error;
 			}
-		}while (0);
+		} while (0);
 		break;
 #endif
 	case DRX_STANDARD_8VSB:
@@ -18556,10 +18293,10 @@ ctrl_get_standard(struct drx_demod_instance *demod, enum drx_standard *standard)
 	ext_attr = (struct drxj_data *) demod->my_ext_attr;
 
 	/* check arguments */
-	if (standard == NULL) {
+	if (standard == NULL)
 		return DRX_STS_INVALID_ARG;
-	}
-	(*standard) = ext_attr->standard;
+
+	*standard = ext_attr->standard;
 	do {
 		u16 dummy;
 		rc = DRXJ_DAP.read_reg16func(demod->my_i2c_dev_addr, SCU_RAM_VERSION_HI__A, &dummy, 0);
@@ -18567,7 +18304,7 @@ ctrl_get_standard(struct drx_demod_instance *demod, enum drx_standard *standard)
 			pr_err("error %d\n", rc);
 			goto rw_error;
 		}
-	}while (0);
+	} while (0);
 
 	return DRX_STS_OK;
 rw_error:
@@ -18649,14 +18386,12 @@ ctrl_power_mode(struct drx_demod_instance *demod, enum drx_power_mode *mode)
 	dev_addr = demod->my_i2c_dev_addr;
 
 	/* Check arguments */
-	if (mode == NULL) {
+	if (mode == NULL)
 		return DRX_STS_INVALID_ARG;
-	}
 
 	/* If already in requested power mode, do nothing */
-	if (common_attr->current_power_mode == *mode) {
+	if (common_attr->current_power_mode == *mode)
 		return DRX_STS_OK;
-	}
 
 	switch (*mode) {
 	case DRX_POWER_UP:
@@ -18814,9 +18549,8 @@ ctrl_version(struct drx_demod_instance *demod, struct drx_version_list **version
 	u16 mfx = 0;
 	u16 bid = 0;
 	u16 key = 0;
-
-	static char ucode_name[] = "Microcode";
-	static char device_name[] = "Device";
+	static const char ucode_name[] = "Microcode";
+	static const char device_name[] = "Device";
 
 	dev_addr = demod->my_i2c_dev_addr;
 	ext_attr = (struct drxj_data *) demod->my_ext_attr;
@@ -18932,22 +18666,20 @@ ctrl_version(struct drx_demod_instance *demod, struct drx_version_list **version
 	subtype = (u16) ((jtag >> 12) & 0xFF);
 	mfx = (u16) (jtag >> 29);
 	ext_attr->v_version[1].v_minor = 1;
-	if (mfx == 0x03) {
+	if (mfx == 0x03)
 		ext_attr->v_version[1].v_patch = mfx + 2;
-	} else {
+	else
 		ext_attr->v_version[1].v_patch = mfx + 1;
-	}
 	ext_attr->v_version[1].v_string[6] = ((char)(subtype & 0xF)) + '0';
 	ext_attr->v_version[1].v_major = (subtype & 0x0F);
 	subtype >>= 4;
 	ext_attr->v_version[1].v_string[5] = ((char)(subtype & 0xF)) + '0';
 	ext_attr->v_version[1].v_major += 10 * subtype;
 	ext_attr->v_version[1].v_string[9] = 'A';
-	if (mfx == 0x03) {
+	if (mfx == 0x03)
 		ext_attr->v_version[1].v_string[10] = ((char)(mfx & 0xF)) + '2';
-	} else {
+	else
 		ext_attr->v_version[1].v_string[10] = ((char)(mfx & 0xF)) + '1';
-	}
 
 	ext_attr->v_list_elements[1].version = &(ext_attr->v_version[1]);
 	ext_attr->v_list_elements[1].next = (struct drx_version_list *) (NULL);
@@ -19060,7 +18792,7 @@ static int ctrl_probe_device(struct drx_demod_instance *demod)
 				pr_err("error %d\n", rc);
 				goto rw_error;
 			}
-		}while (0);
+		} while (0);
 	}
 
 	return ret_status;
@@ -19083,9 +18815,9 @@ rw_error:
 */
 bool is_mc_block_audio(u32 addr)
 {
-	if ((addr == AUD_XFP_PRAM_4K__A) || (addr == AUD_XDFP_PRAM_4K__A)) {
+	if ((addr == AUD_XFP_PRAM_4K__A) || (addr == AUD_XDFP_PRAM_4K__A))
 		return true;
-	}
+
 	return false;
 }
 
@@ -19203,16 +18935,10 @@ ctrl_u_code_upload(struct drx_demod_instance *demod,
 					curr_ptr = mc_data;
 
 					while (bytes_left_to_compare != 0) {
-						if (bytes_left_to_compare >
-						    ((u32)
-						     DRXJ_UCODE_MAX_BUF_SIZE)) {
-							bytes_to_compare =
-							    ((u32)
-							     DRXJ_UCODE_MAX_BUF_SIZE);
-						} else {
-							bytes_to_compare =
-							    bytes_left_to_compare;
-						}
+						if (bytes_left_to_compare > ((u32)DRXJ_UCODE_MAX_BUF_SIZE))
+							bytes_to_compare = ((u32)DRXJ_UCODE_MAX_BUF_SIZE);
+						else
+							bytes_to_compare = bytes_left_to_compare;
 
 						if (demod->my_access_funct->
 						    read_block_func(dev_addr,
@@ -19231,9 +18957,8 @@ ctrl_u_code_upload(struct drx_demod_instance *demod,
 								      mc_data_buffer,
 								      bytes_to_compare);
 
-						if (result != 0) {
+						if (result != 0)
 							return DRX_STS_ERROR;
-						}
 
 						curr_addr +=
 						    ((dr_xaddr_t)
@@ -19259,9 +18984,8 @@ ctrl_u_code_upload(struct drx_demod_instance *demod,
 		mc_data += mc_block_nr_bytes;
 	}			/* for( i = 0 ; i<mc_nr_of_blks ; i++ ) */
 
-	if (!upload_audio_mc) {
+	if (!upload_audio_mc)
 		ext_attr->flag_aud_mc_uploaded = false;
-	}
 
 	return DRX_STS_OK;
 }
@@ -19291,9 +19015,8 @@ ctrl_sig_strength(struct drx_demod_instance *demod, u16 *sig_strength)
 	int rc;
 
 	/* Check arguments */
-	if ((sig_strength == NULL) || (demod == NULL)) {
+	if ((sig_strength == NULL) || (demod == NULL))
 		return DRX_STS_INVALID_ARG;
-	}
 
 	ext_attr = (struct drxj_data *) demod->my_ext_attr;
 	standard = ext_attr->standard;
@@ -19361,9 +19084,9 @@ ctrl_get_cfg_oob_misc(struct drx_demod_instance *demod, struct drxj_cfg_oob_misc
 	u16 digital_agc_exp = 0U;
 
 	/* check arguments */
-	if (misc == NULL) {
+	if (misc == NULL)
 		return DRX_STS_INVALID_ARG;
-	}
+
 	dev_addr = demod->my_i2c_dev_addr;
 
 	/* TODO */
@@ -19429,9 +19152,9 @@ ctrl_get_cfg_vsb_misc(struct drx_demod_instance *demod, struct drxj_cfg_vsb_misc
 	int rc;
 
 	/* check arguments */
-	if (misc == NULL) {
+	if (misc == NULL)
 		return DRX_STS_INVALID_ARG;
-	}
+
 	dev_addr = demod->my_i2c_dev_addr;
 
 	rc = get_vsb_symb_err(dev_addr, &misc->symb_error);
@@ -19462,9 +19185,8 @@ static int
 ctrl_set_cfg_agc_if(struct drx_demod_instance *demod, struct drxj_cfg_agc *agc_settings)
 {
 	/* check arguments */
-	if (agc_settings == NULL) {
+	if (agc_settings == NULL)
 		return DRX_STS_INVALID_ARG;
-	}
 
 	switch (agc_settings->ctrl_mode) {
 	case DRX_AGC_CTRL_AUTO:	/* fallthrough */
@@ -19518,9 +19240,8 @@ static int
 ctrl_get_cfg_agc_if(struct drx_demod_instance *demod, struct drxj_cfg_agc *agc_settings)
 {
 	/* check arguments */
-	if (agc_settings == NULL) {
+	if (agc_settings == NULL)
 		return DRX_STS_INVALID_ARG;
-	}
 
 	/* Distpatch */
 	switch (agc_settings->standard) {
@@ -19565,9 +19286,8 @@ static int
 ctrl_set_cfg_agc_rf(struct drx_demod_instance *demod, struct drxj_cfg_agc *agc_settings)
 {
 	/* check arguments */
-	if (agc_settings == NULL) {
+	if (agc_settings == NULL)
 		return DRX_STS_INVALID_ARG;
-	}
 
 	switch (agc_settings->ctrl_mode) {
 	case DRX_AGC_CTRL_AUTO:	/* fallthrough */
@@ -19621,9 +19341,8 @@ static int
 ctrl_get_cfg_agc_rf(struct drx_demod_instance *demod, struct drxj_cfg_agc *agc_settings)
 {
 	/* check arguments */
-	if (agc_settings == NULL) {
+	if (agc_settings == NULL)
 		return DRX_STS_INVALID_ARG;
-	}
 
 	/* Distpatch */
 	switch (agc_settings->standard) {
@@ -19677,9 +19396,8 @@ ctrl_get_cfg_agc_internal(struct drx_demod_instance *demod, u16 *agc_internal)
 	u16 iqm_cf_gain = 0;
 
 	/* check arguments */
-	if (agc_internal == NULL) {
+	if (agc_internal == NULL)
 		return DRX_STS_INVALID_ARG;
-	}
 	dev_addr = demod->my_i2c_dev_addr;
 	ext_attr = (struct drxj_data *) demod->my_ext_attr;
 
@@ -19847,9 +19565,8 @@ ctrl_set_cfg_afe_gain(struct drx_demod_instance *demod, struct drxj_cfg_afe_gain
 	u8 gain = 0;
 
 	/* check arguments */
-	if (afe_gain == NULL) {
+	if (afe_gain == NULL)
 		return DRX_STS_INVALID_ARG;
-	}
 
 	dev_addr = demod->my_i2c_dev_addr;
 	ext_attr = (struct drxj_data *) demod->my_ext_attr;
@@ -19878,8 +19595,7 @@ ctrl_set_cfg_afe_gain(struct drx_demod_instance *demod, struct drxj_cfg_afe_gain
 		gain = (afe_gain->gain - 140 + 6) / 13;
 
 	/* Only if standard is currently active */
-	if (ext_attr->standard == afe_gain->standard){
-
+	if (ext_attr->standard == afe_gain->standard) {
 			rc = DRXJ_DAP.write_reg16func(dev_addr, IQM_AF_PGA_GAIN__A, gain, 0);
 			if (rc != DRX_STS_OK) {
 				pr_err("error %d\n", rc);
@@ -20025,9 +19741,8 @@ ctrl_get_fec_meas_seq_count(struct drx_demod_instance *demod, u16 *fec_meas_seq_
 {
 	int rc;
 	/* check arguments */
-	if (fec_meas_seq_count == NULL) {
+	if (fec_meas_seq_count == NULL)
 		return DRX_STS_INVALID_ARG;
-	}
 
 	rc = DRXJ_DAP.read_reg16func(demod->my_i2c_dev_addr, SCU_RAM_FEC_MEAS_COUNT__A, fec_meas_seq_count, 0);
 	if (rc != DRX_STS_OK) {
@@ -20057,9 +19772,8 @@ static int
 ctrl_get_accum_cr_rs_cw_err(struct drx_demod_instance *demod, u32 *accum_cr_rs_cw_err)
 {
 	int rc;
-	if (accum_cr_rs_cw_err == NULL) {
+	if (accum_cr_rs_cw_err == NULL)
 		return DRX_STS_INVALID_ARG;
-	}
 
 	rc = DRXJ_DAP.read_reg32func(demod->my_i2c_dev_addr, SCU_RAM_FEC_ACCUM_CW_CORRECTED_LO__A, accum_cr_rs_cw_err, 0);
 	if (rc != DRX_STS_OK) {
@@ -20094,7 +19808,7 @@ static int ctrl_set_cfg(struct drx_demod_instance *demod, struct drx_cfg *config
 			pr_err("error %d\n", rc);
 			goto rw_error;
 		}
-	}while (0);
+	} while (0);
 	switch (config->cfg_type) {
 	case DRX_CFG_MPEG_OUTPUT:
 		return ctrl_set_cfg_mpeg_output(demod,
@@ -20210,7 +19924,7 @@ static int ctrl_get_cfg(struct drx_demod_instance *demod, struct drx_cfg *config
 			pr_err("error %d\n", rc);
 			goto rw_error;
 		}
-	}while (0);
+	} while (0);
 
 	switch (config->cfg_type) {
 	case DRX_CFG_MPEG_OUTPUT:
-- 
1.8.5.3

