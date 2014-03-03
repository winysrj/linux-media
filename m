Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49506 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754257AbaCCKIQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Mar 2014 05:08:16 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 26/79] [media] drx-j: don't use parenthesis on return
Date: Mon,  3 Mar 2014 07:06:20 -0300
Message-Id: <1393841233-24840-27-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1393841233-24840-1-git-send-email-m.chehab@samsung.com>
References: <1393841233-24840-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

CodingStyle fix: don't use parenthesis on return, as it is not
a function.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 .../media/dvb-frontends/drx39xyj/drx39xxj_dummy.c  |   4 +-
 drivers/media/dvb-frontends/drx39xyj/drx_driver.c  |  20 +-
 drivers/media/dvb-frontends/drx39xyj/drxj.c        | 790 ++++++++++-----------
 3 files changed, 407 insertions(+), 407 deletions(-)

diff --git a/drivers/media/dvb-frontends/drx39xyj/drx39xxj_dummy.c b/drivers/media/dvb-frontends/drx39xyj/drx39xxj_dummy.c
index 2cedf7c90385..448558e1716e 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drx39xxj_dummy.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drx39xxj_dummy.c
@@ -50,12 +50,12 @@ u32 drxbsp_hst_clock(void)
 
 int drxbsp_hst_memcmp(void *s1, void *s2, u32 n)
 {
-	return (memcmp(s1, s2, (size_t) n));
+	return memcmp(s1, s2, (size_t)n);
 }
 
 void *drxbsp_hst_memcpy(void *to, void *from, u32 n)
 {
-	return (memcpy(to, from, (size_t) n));
+	return memcpy(to, from, (size_t)n);
 }
 
 int drxbsp_i2c_write_read(struct i2c_device_addr *w_dev_addr,
diff --git a/drivers/media/dvb-frontends/drx39xyj/drx_driver.c b/drivers/media/dvb-frontends/drx39xyj/drx_driver.c
index 1b55bb5c8df2..2c88e47c701d 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drx_driver.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drx_driver.c
@@ -373,7 +373,7 @@ scan_function_default(void *scan_context,
 
 	status = drx_ctrl(demod, DRX_CTRL_SET_CHANNEL, scan_channel);
 	if (status != DRX_STS_OK) {
-		return (status);
+		return status;
 	}
 
 	status = scan_wait_for_lock(demod, &is_locked);
@@ -688,7 +688,7 @@ static int ctrl_scan_next(struct drx_demod_instance *demod, u16 *scan_progress)
 
 			if (next_status != DRX_STS_OK) {
 				common_attr->scan_active = false;
-				return (next_status);
+				return next_status;
 			}
 		}
 		if (status != DRX_STS_BUSY) {
@@ -702,7 +702,7 @@ static int ctrl_scan_next(struct drx_demod_instance *demod, u16 *scan_progress)
 		/* End of scan reached: call stop-scan, ignore any error */
 		ctrl_scan_stop(demod);
 		common_attr->scan_active = false;
-		return (DRX_STS_READY);
+		return DRX_STS_READY;
 	}
 
 	common_attr->scan_active = false;
@@ -958,7 +958,7 @@ static u16 u_code_compute_crc(u8 *block_data, u16 nr_words)
 		i++;
 		block_data += (sizeof(u16));
 	}
-	return ((u16) (crc_word >> 16));
+	return (u16)(crc_word >> 16);
 }
 
 /*============================================================================*/
@@ -1110,7 +1110,7 @@ ctrl_u_code(struct drx_demod_instance *demod,
 							   mc_data,
 							   0x0000) !=
 					    DRX_STS_OK) {
-						return (DRX_STS_ERROR);
+						return DRX_STS_ERROR;
 					}	/* if */
 				};
 				break;
@@ -1151,7 +1151,7 @@ ctrl_u_code(struct drx_demod_instance *demod,
 								  mc_dataBuffer,
 								  0x0000) !=
 						    DRX_STS_OK) {
-							return (DRX_STS_ERROR);
+							return DRX_STS_ERROR;
 						}
 
 						result =
@@ -1315,7 +1315,7 @@ int drx_open(struct drx_demod_instance *demod)
 	    (demod->my_ext_attr == NULL) ||
 	    (demod->my_i2c_dev_addr == NULL) ||
 	    (demod->my_common_attr->is_opened == true)) {
-		return (DRX_STS_INVALID_ARG);
+		return DRX_STS_INVALID_ARG;
 	}
 
 	status = (*(demod->my_demod_funct->open_func)) (demod);
@@ -1392,13 +1392,13 @@ drx_ctrl(struct drx_demod_instance *demod, u32 ctrl, void *ctrl_data)
 	    (demod->my_common_attr == NULL) ||
 	    (demod->my_ext_attr == NULL) || (demod->my_i2c_dev_addr == NULL)
 	    ) {
-		return (DRX_STS_INVALID_ARG);
+		return DRX_STS_INVALID_ARG;
 	}
 
 	if (((demod->my_common_attr->is_opened == false) &&
 	     (ctrl != DRX_CTRL_PROBE_DEVICE) && (ctrl != DRX_CTRL_VERSION))
 	    ) {
-		return (DRX_STS_INVALID_ARG);
+		return DRX_STS_INVALID_ARG;
 	}
 
 	if ((DRX_ISPOWERDOWNMODE(demod->my_common_attr->current_power_mode) &&
@@ -1498,7 +1498,7 @@ drx_ctrl(struct drx_demod_instance *demod, u32 ctrl, void *ctrl_data)
 			return DRX_STS_FUNC_NOT_AVAILABLE;
 		}
 	} else {
-		return (status);
+		return status;
 	}
 
 	return DRX_STS_OK;
diff --git a/drivers/media/dvb-frontends/drx39xyj/drxj.c b/drivers/media/dvb-frontends/drx39xyj/drxj.c
index 13bb38193669..4e2059549dc1 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drxj.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drxj.c
@@ -1327,7 +1327,7 @@ static u32 log1_times100(u32 x)
 	u32 r = 0;
 
 	if (x == 0)
-		return (0);
+		return 0;
 
 	/* Scale x (normalize) */
 	/* computing y in log(x/y) = log(x) - log(y) */
@@ -1367,7 +1367,7 @@ static u32 log1_times100(u32 x)
 	if (y & ((u32) 1))
 		r++;
 
-	return (r);
+	return r;
 
 }
 
@@ -1403,7 +1403,7 @@ static u32 frac_times1e6(u32 N, u32 D)
 		frac++;
 	}
 
-	return (frac);
+	return frac;
 }
 
 /*============================================================================*/
@@ -1446,7 +1446,7 @@ static u32 d_b2lin_times100(u32 gd_b)
 	result *= remainder_fac;
 
 	/* conversion from 1e-4 to 1e-2 */
-	return ((result + 50) / 100);
+	return (result + 50) / 100;
 }
 
 #ifndef DRXJ_DIGITAL_ONLY
@@ -1474,7 +1474,7 @@ static u32 frac(u32 N, u32 D, u16 RC)
 		frac = 0;
 		remainder = 0;
 
-		return (frac);
+		return frac;
 	}
 
 	if (D > N) {
@@ -1507,7 +1507,7 @@ static u32 frac(u32 N, u32 D, u16 RC)
 		}
 	}
 
-	return (frac);
+	return frac;
 }
 #endif
 
@@ -1529,7 +1529,7 @@ static u16 u_code_read16(u8 *addr)
 	word <<= 8;
 	word |= ((u16) addr[1]);
 
-	return (word);
+	return word;
 }
 
 /*============================================================================*/
@@ -1553,7 +1553,7 @@ static u32 u_code_read32(u8 *addr)
 	word <<= 8;
 	word |= ((u16) addr[3]);
 
-	return (word);
+	return word;
 }
 
 /*============================================================================*/
@@ -1583,7 +1583,7 @@ static u16 u_code_compute_crc(u8 *block_data, u16 nr_words)
 		i++;
 		block_data += (sizeof(u16));
 	}
-	return ((u16) (crc_word >> 16));
+	return (u16)(crc_word >> 16);
 }
 #endif /* DRXJ_SPLIT_UCODE_UPLOAD */
 
@@ -1649,7 +1649,7 @@ bool is_handled_by_aud_tr_if(u32 addr)
 		retval = true;
 	}
 
-	return (retval);
+	return retval;
 }
 
 /*============================================================================*/
@@ -2051,7 +2051,7 @@ int drxj_dap_atomic_read_write_block(struct i2c_device_addr *dev_addr,
 	if ((data == NULL) ||
 	    (dev_addr == NULL) || ((datasize % 2) != 0) || ((datasize / 2) > 8)
 	    ) {
-		return (DRX_STS_INVALID_ARG);
+		return DRX_STS_INVALID_ARG;
 	}
 
 	/* Set up HI parameters to read or write n bytes */
@@ -2103,7 +2103,7 @@ int drxj_dap_atomic_read_write_block(struct i2c_device_addr *dev_addr,
 	return DRX_STS_OK;
 
 rw_error:
-	return (DRX_STS_ERROR);
+	return DRX_STS_ERROR;
 
 }
 
@@ -2194,10 +2194,10 @@ static int hi_cfg_command(const struct drx_demod_instance *demod)
 	/* Reset power down flag (set one call only) */
 	ext_attr->hi_cfg_ctrl &= (~(SIO_HI_RA_RAM_PAR_5_CFG_SLEEP_ZZZ));
 
-	return (DRX_STS_OK);
+	return DRX_STS_OK;
 
 rw_error:
-	return (DRX_STS_ERROR);
+	return DRX_STS_ERROR;
 }
 
 /**
@@ -2262,7 +2262,7 @@ hi_command(struct i2c_device_addr *dev_addr, const pdrxj_hi_cmd_t cmd, u16 *resu
 		break;
 
 	default:
-		return (DRX_STS_INVALID_ARG);
+		return DRX_STS_INVALID_ARG;
 		break;
 	}
 
@@ -2307,9 +2307,9 @@ hi_command(struct i2c_device_addr *dev_addr, const pdrxj_hi_cmd_t cmd, u16 *resu
 
 	}
 	/* if ( powerdown_cmd == true ) */
-	return (DRX_STS_OK);
+	return DRX_STS_OK;
 rw_error:
-	return (DRX_STS_ERROR);
+	return DRX_STS_ERROR;
 }
 
 /**
@@ -2379,10 +2379,10 @@ static int init_hi(const struct drx_demod_instance *demod)
 		goto rw_error;
 	}
 
-	return (DRX_STS_OK);
+	return DRX_STS_OK;
 
 rw_error:
-	return (DRX_STS_ERROR);
+	return DRX_STS_ERROR;
 }
 
 /*============================================================================*/
@@ -2458,7 +2458,7 @@ static int get_device_capabilities(struct drx_demod_instance *demod)
 		common_attr->osc_clock_freq = 4000;
 		break;
 	default:
-		return (DRX_STS_ERROR);
+		return DRX_STS_ERROR;
 	}
 
 	/*
@@ -2592,13 +2592,13 @@ static int get_device_capabilities(struct drx_demod_instance *demod)
 		break;
 	default:
 		/* Unknown device variant */
-		return (DRX_STS_ERROR);
+		return DRX_STS_ERROR;
 		break;
 	}
 
-	return (DRX_STS_OK);
+	return DRX_STS_OK;
 rw_error:
-	return (DRX_STS_ERROR);
+	return DRX_STS_ERROR;
 }
 
 /**
@@ -2647,10 +2647,10 @@ static int power_up_device(struct drx_demod_instance *demod)
 	drxbsp_hst_sleep(10);
 
 	if (retry_count == DRXJ_MAX_RETRIES_POWERUP) {
-		return (DRX_STS_ERROR);
+		return DRX_STS_ERROR;
 	}
 
-	return (DRX_STS_OK);
+	return DRX_STS_OK;
 }
 
 /*----------------------------------------------------------------------------*/
@@ -2689,7 +2689,7 @@ ctrl_set_cfg_mpeg_output(struct drx_demod_instance *demod, struct drx_cfg_mpeg_o
 
 	/* check arguments */
 	if ((demod == NULL) || (cfg_data == NULL)) {
-		return (DRX_STS_INVALID_ARG);
+		return DRX_STS_INVALID_ARG;
 	}
 
 	dev_addr = demod->my_i2c_dev_addr;
@@ -2720,7 +2720,7 @@ ctrl_set_cfg_mpeg_output(struct drx_demod_instance *demod, struct drx_cfg_mpeg_o
 			common_attr->mpeg_cfg.invert_clk = cfg_data->invert_clk;
 			common_attr->mpeg_cfg.static_clk = cfg_data->static_clk;
 			common_attr->mpeg_cfg.bitrate = cfg_data->bitrate;
-			return (DRX_STS_OK);
+			return DRX_STS_OK;
 		}
 
 		rc = DRXJ_DAP.write_reg16func(dev_addr, FEC_OC_OCR_INVERT__A, 0, 0);
@@ -2792,7 +2792,7 @@ ctrl_set_cfg_mpeg_output(struct drx_demod_instance *demod, struct drx_cfg_mpeg_o
 				nr_bits = 4;
 				break;
 			default:
-				return (DRX_STS_ERROR);
+				return DRX_STS_ERROR;
 			}	/* ext_attr->constellation */
 			/* max_bit_rate = symbol_rate * nr_bits * coef */
 			/* coef = 188/204                          */
@@ -2883,7 +2883,7 @@ ctrl_set_cfg_mpeg_output(struct drx_demod_instance *demod, struct drx_cfg_mpeg_o
 					rcn_rate = 0x005F64D4;
 					break;
 				default:
-					return (DRX_STS_ERROR);
+					return DRX_STS_ERROR;
 				}
 				break;
 			case DRX_STANDARD_ITU_A:
@@ -2896,7 +2896,7 @@ ctrl_set_cfg_mpeg_output(struct drx_demod_instance *demod, struct drx_cfg_mpeg_o
 				    188;
 				break;
 			default:
-				return (DRX_STS_ERROR);
+				return DRX_STS_ERROR;
 			}	/* ext_attr->standard */
 		} else {	/* insert_rs_byte == false */
 
@@ -2918,7 +2918,7 @@ ctrl_set_cfg_mpeg_output(struct drx_demod_instance *demod, struct drx_cfg_mpeg_o
 					rcn_rate = 0x005AEC1A;
 					break;
 				default:
-					return (DRX_STS_ERROR);
+					return DRX_STS_ERROR;
 				}
 				break;
 			case DRX_STANDARD_ITU_A:
@@ -2931,7 +2931,7 @@ ctrl_set_cfg_mpeg_output(struct drx_demod_instance *demod, struct drx_cfg_mpeg_o
 				    204;
 				break;
 			default:
-				return (DRX_STS_ERROR);
+				return DRX_STS_ERROR;
 			}	/* ext_attr->standard */
 		}
 
@@ -3015,7 +3015,7 @@ ctrl_set_cfg_mpeg_output(struct drx_demod_instance *demod, struct drx_cfg_mpeg_o
 				}
 				break;
 			default:
-				return (DRX_STS_ERROR);
+				return DRX_STS_ERROR;
 			}
 			bit_rate =
 			    common_attr->sys_clock_freq * 1000 / (fec_oc_dto_period +
@@ -3318,9 +3318,9 @@ ctrl_set_cfg_mpeg_output(struct drx_demod_instance *demod, struct drx_cfg_mpeg_o
 	common_attr->mpeg_cfg.static_clk = cfg_data->static_clk;
 	common_attr->mpeg_cfg.bitrate = cfg_data->bitrate;
 
-	return (DRX_STS_OK);
+	return DRX_STS_OK;
 rw_error:
-	return (DRX_STS_ERROR);
+	return DRX_STS_ERROR;
 }
 
 /*----------------------------------------------------------------------------*/
@@ -3347,7 +3347,7 @@ ctrl_get_cfg_mpeg_output(struct drx_demod_instance *demod, struct drx_cfg_mpeg_o
 	u32 data64lo = 0;
 
 	if (cfg_data == NULL) {
-		return (DRX_STS_INVALID_ARG);
+		return DRX_STS_INVALID_ARG;
 	}
 	dev_addr = demod->my_i2c_dev_addr;
 	common_attr = demod->my_common_attr;
@@ -3380,9 +3380,9 @@ ctrl_get_cfg_mpeg_output(struct drx_demod_instance *demod, struct drx_cfg_mpeg_o
 		cfg_data->bitrate = (data64hi << 7) | (data64lo >> 25);
 	}
 
-	return (DRX_STS_OK);
+	return DRX_STS_OK;
 rw_error:
-	return (DRX_STS_ERROR);
+	return DRX_STS_ERROR;
 }
 
 /*----------------------------------------------------------------------------*/
@@ -3460,9 +3460,9 @@ static int set_mpegtei_handling(struct drx_demod_instance *demod)
 		goto rw_error;
 	}
 
-	return (DRX_STS_OK);
+	return DRX_STS_OK;
 rw_error:
-	return (DRX_STS_ERROR);
+	return DRX_STS_ERROR;
 }
 
 /*----------------------------------------------------------------------------*/
@@ -3505,9 +3505,9 @@ static int bit_reverse_mpeg_output(struct drx_demod_instance *demod)
 		goto rw_error;
 	}
 
-	return (DRX_STS_OK);
+	return DRX_STS_OK;
 rw_error:
-	return (DRX_STS_ERROR);
+	return DRX_STS_ERROR;
 }
 
 /*----------------------------------------------------------------------------*/
@@ -3537,9 +3537,9 @@ static int set_mpeg_output_clock_rate(struct drx_demod_instance *demod)
 		}
 	}
 
-	return (DRX_STS_OK);
+	return DRX_STS_OK;
 rw_error:
-	return (DRX_STS_ERROR);
+	return DRX_STS_ERROR;
 }
 
 /*----------------------------------------------------------------------------*/
@@ -3582,9 +3582,9 @@ static int set_mpeg_start_width(struct drx_demod_instance *demod)
 		}
 	}
 
-	return (DRX_STS_OK);
+	return DRX_STS_OK;
 rw_error:
-	return (DRX_STS_ERROR);
+	return DRX_STS_ERROR;
 }
 
 /*----------------------------------------------------------------------------*/
@@ -3607,7 +3607,7 @@ ctrl_set_cfg_mpeg_output_misc(struct drx_demod_instance *demod,
 	int rc;
 
 	if (cfg_data == NULL) {
-		return (DRX_STS_INVALID_ARG);
+		return DRX_STS_INVALID_ARG;
 	}
 
 	ext_attr = (struct drxj_data *) demod->my_ext_attr;
@@ -3647,9 +3647,9 @@ ctrl_set_cfg_mpeg_output_misc(struct drx_demod_instance *demod,
 		goto rw_error;
 	}
 
-	return (DRX_STS_OK);
+	return DRX_STS_OK;
 rw_error:
-	return (DRX_STS_ERROR);
+	return DRX_STS_ERROR;
 }
 
 /*----------------------------------------------------------------------------*/
@@ -3675,7 +3675,7 @@ ctrl_get_cfg_mpeg_output_misc(struct drx_demod_instance *demod,
 	u16 data = 0;
 
 	if (cfg_data == NULL) {
-		return (DRX_STS_INVALID_ARG);
+		return DRX_STS_INVALID_ARG;
 	}
 
 	ext_attr = (struct drxj_data *) demod->my_ext_attr;
@@ -3694,9 +3694,9 @@ ctrl_get_cfg_mpeg_output_misc(struct drx_demod_instance *demod,
 		    (enum drxj_mpeg_output_clock_rate) (data + 1);
 	}
 
-	return (DRX_STS_OK);
+	return DRX_STS_OK;
 rw_error:
-	return (DRX_STS_ERROR);
+	return DRX_STS_ERROR;
 }
 
 /*----------------------------------------------------------------------------*/
@@ -3720,7 +3720,7 @@ ctrl_get_cfg_hw_cfg(struct drx_demod_instance *demod, struct drxj_cfg_hw_cfg *cf
 	u16 data = 0;
 
 	if (cfg_data == NULL)
-		return (DRX_STS_INVALID_ARG);
+		return DRX_STS_INVALID_ARG;
 
 	rc = DRXJ_DAP.write_reg16func(demod->my_i2c_dev_addr, SIO_TOP_COMM_KEY__A, 0xFABA, 0);
 	if (rc != DRX_STS_OK) {
@@ -3741,9 +3741,9 @@ ctrl_get_cfg_hw_cfg(struct drx_demod_instance *demod, struct drxj_cfg_hw_cfg *cf
 	cfg_data->i2c_speed = (enum drxji2c_speed) ((data >> 6) & 0x1);
 	cfg_data->xtal_freq = (enum drxj_xtal_freq) (data & 0x3);
 
-	return (DRX_STS_OK);
+	return DRX_STS_OK;
 rw_error:
-	return (DRX_STS_ERROR);
+	return DRX_STS_ERROR;
 }
 
 /*----------------------------------------------------------------------------*/
@@ -3885,9 +3885,9 @@ static int ctrl_set_uio_cfg(struct drx_demod_instance *demod, struct drxuio_cfg
 		goto rw_error;
 	}
 
-	return (DRX_STS_OK);
+	return DRX_STS_OK;
 rw_error:
-	return (DRX_STS_ERROR);
+	return DRX_STS_ERROR;
 }
 
 /*============================================================================*/
@@ -4132,9 +4132,9 @@ ctrl_uio_write(struct drx_demod_instance *demod, struct drxuio_data *uio_data)
 		goto rw_error;
 	}
 
-	return (DRX_STS_OK);
+	return DRX_STS_OK;
 rw_error:
-	return (DRX_STS_ERROR);
+	return DRX_STS_ERROR;
 }
 
 /**
@@ -4311,9 +4311,9 @@ static int ctrl_uio_read(struct drx_demod_instance *demod, struct drxuio_data *u
 		goto rw_error;
 	}
 
-	return (DRX_STS_OK);
+	return DRX_STS_OK;
 rw_error:
-	return (DRX_STS_ERROR);
+	return DRX_STS_ERROR;
 }
 
 /*---------------------------------------------------------------------------*/
@@ -4339,7 +4339,7 @@ ctrl_i2c_bridge(struct drx_demod_instance *demod, bool *bridge_closed)
 
 	/* check arguments */
 	if (bridge_closed == NULL) {
-		return (DRX_STS_INVALID_ARG);
+		return DRX_STS_INVALID_ARG;
 	}
 
 	hi_cmd.cmd = SIO_HI_RA_RAM_CMD_BRDCTRL;
@@ -4431,9 +4431,9 @@ static int smart_ant_init(struct drx_demod_instance *demod)
 		goto rw_error;
 	}
 
-	return (DRX_STS_OK);
+	return DRX_STS_OK;
 rw_error:
-	return (DRX_STS_ERROR);
+	return DRX_STS_ERROR;
 }
 
 /**
@@ -4458,7 +4458,7 @@ ctrl_set_cfg_smart_ant(struct drx_demod_instance *demod, struct drxj_cfg_smart_a
 
 	/* check arguments */
 	if (smart_ant == NULL) {
-		return (DRX_STS_INVALID_ARG);
+		return DRX_STS_INVALID_ARG;
 	}
 
 	if (bit_inverted != ext_attr->smart_ant_inverted
@@ -4497,7 +4497,7 @@ ctrl_set_cfg_smart_ant(struct drx_demod_instance *demod, struct drxj_cfg_smart_a
 			     DRXJ_MAX_WAITTIME));
 
 		if (data & SIO_SA_TX_STATUS_BUSY__M) {
-			return (DRX_STS_ERROR);
+			return DRX_STS_ERROR;
 		}
 
 		/* write to smart antenna configuration register */
@@ -4537,7 +4537,7 @@ ctrl_set_cfg_smart_ant(struct drx_demod_instance *demod, struct drxj_cfg_smart_a
 		   WR16( dev_addr, SIO_SA_TX_COMMAND__A, data & (~SIO_SA_TX_COMMAND_TX_ENABLE__M) );
 		 */
 	default:
-		return (DRX_STS_INVALID_ARG);
+		return DRX_STS_INVALID_ARG;
 	}
 	/*  Write magic word to enable pdr reg write               */
 	rc = DRXJ_DAP.write_reg16func(demod->my_i2c_dev_addr, SIO_TOP_COMM_KEY__A, 0x0000, 0);
@@ -4546,9 +4546,9 @@ ctrl_set_cfg_smart_ant(struct drx_demod_instance *demod, struct drxj_cfg_smart_a
 		goto rw_error;
 	}
 
-	return (DRX_STS_OK);
+	return DRX_STS_OK;
 rw_error:
-	return (DRX_STS_ERROR);
+	return DRX_STS_ERROR;
 }
 
 static int scu_command(struct i2c_device_addr *dev_addr, struct drxjscu_cmd *cmd)
@@ -4559,7 +4559,7 @@ static int scu_command(struct i2c_device_addr *dev_addr, struct drxjscu_cmd *cmd
 
 	/* Check param */
 	if (cmd == NULL)
-		return (DRX_STS_INVALID_ARG);
+		return DRX_STS_INVALID_ARG;
 
 	/* Wait until SCU command interface is ready to receive command */
 	rc = DRXJ_DAP.read_reg16func(dev_addr, SCU_RAM_COMMAND__A, &cur_cmd, 0);
@@ -4568,7 +4568,7 @@ static int scu_command(struct i2c_device_addr *dev_addr, struct drxjscu_cmd *cmd
 		goto rw_error;
 	}
 	if (cur_cmd != DRX_SCU_READY) {
-		return (DRX_STS_ERROR);
+		return DRX_STS_ERROR;
 	}
 
 	switch (cmd->parameter_len) {
@@ -4607,7 +4607,7 @@ static int scu_command(struct i2c_device_addr *dev_addr, struct drxjscu_cmd *cmd
 		break;
 	default:
 		/* this number of parameters is not supported */
-		return (DRX_STS_ERROR);
+		return DRX_STS_ERROR;
 	}
 	rc = DRXJ_DAP.write_reg16func(dev_addr, SCU_RAM_COMMAND__A, cmd->command, 0);
 	if (rc != DRX_STS_OK) {
@@ -4627,7 +4627,7 @@ static int scu_command(struct i2c_device_addr *dev_addr, struct drxjscu_cmd *cmd
 		 && ((drxbsp_hst_clock() - start_time) < DRXJ_MAX_WAITTIME));
 
 	if (cur_cmd != DRX_SCU_READY) {
-		return (DRX_STS_ERROR);
+		return DRX_STS_ERROR;
 	}
 
 	/* read results */
@@ -4664,7 +4664,7 @@ static int scu_command(struct i2c_device_addr *dev_addr, struct drxjscu_cmd *cmd
 			break;
 		default:
 			/* this number of parameters is not supported */
-			return (DRX_STS_ERROR);
+			return DRX_STS_ERROR;
 		}
 
 		/* Check if an error was reported by SCU */
@@ -4686,10 +4686,10 @@ static int scu_command(struct i2c_device_addr *dev_addr, struct drxjscu_cmd *cmd
 		}
 	}
 
-	return (DRX_STS_OK);
+	return DRX_STS_OK;
 
 rw_error:
-	return (DRX_STS_ERROR);
+	return DRX_STS_ERROR;
 }
 
 /**
@@ -4718,7 +4718,7 @@ int drxj_dap_scu_atomic_read_write_block(struct i2c_device_addr *dev_addr, u32 a
 	if ((data == NULL) ||
 	    (dev_addr == NULL) || ((datasize % 2) != 0) || ((datasize / 2) > 16)
 	    ) {
-		return (DRX_STS_INVALID_ARG);
+		return DRX_STS_INVALID_ARG;
 	}
 
 	set_param_parameters[1] = (u16) ADDR_AT_SCU_SPACE(addr);
@@ -4761,7 +4761,7 @@ int drxj_dap_scu_atomic_read_write_block(struct i2c_device_addr *dev_addr, u32 a
 	return DRX_STS_OK;
 
 rw_error:
-	return (DRX_STS_ERROR);
+	return DRX_STS_ERROR;
 
 }
 
@@ -4819,7 +4819,7 @@ int drxj_dap_scu_atomic_write_reg16(struct i2c_device_addr *dev_addr,
 static int
 ctrl_i2c_write_read(struct drx_demod_instance *demod, struct drxi2c_data *i2c_data)
 {
-	return (DRX_STS_FUNC_NOT_AVAILABLE);
+	return DRX_STS_FUNC_NOT_AVAILABLE;
 }
 
 /* -------------------------------------------------------------------------- */
@@ -4885,9 +4885,9 @@ static int adc_sync_measurement(struct drx_demod_instance *demod, u16 *count)
 		*count = *count + 1;
 	}
 
-	return (DRX_STS_OK);
+	return DRX_STS_OK;
 rw_error:
-	return (DRX_STS_ERROR);
+	return DRX_STS_ERROR;
 }
 
 /**
@@ -4942,12 +4942,12 @@ static int adc_synchronization(struct drx_demod_instance *demod)
 
 	if (count < 2) {
 		/* TODO: implement fallback scenarios */
-		return (DRX_STS_ERROR);
+		return DRX_STS_ERROR;
 	}
 
-	return (DRX_STS_OK);
+	return DRX_STS_OK;
 rw_error:
-	return (DRX_STS_ERROR);
+	return DRX_STS_ERROR;
 }
 
 /**
@@ -4988,9 +4988,9 @@ static int iqm_set_af(struct drx_demod_instance *demod, bool active)
 		goto rw_error;
 	}
 
-	return (DRX_STS_OK);
+	return DRX_STS_OK;
 rw_error:
-	return (DRX_STS_ERROR);
+	return DRX_STS_ERROR;
 }
 
 /* -------------------------------------------------------------------------- */
@@ -5011,7 +5011,7 @@ ctrl_set_cfg_pdr_safe_mode(struct drx_demod_instance *demod, bool *enable)
 	int rc;
 
 	if (enable == NULL)
-		return (DRX_STS_INVALID_ARG);
+		return DRX_STS_INVALID_ARG;
 
 	dev_addr = demod->my_i2c_dev_addr;
 	ext_attr = (struct drxj_data *) demod->my_ext_attr;
@@ -5245,10 +5245,10 @@ ctrl_set_cfg_pdr_safe_mode(struct drx_demod_instance *demod, bool *enable)
 	}
 	ext_attr->pdr_safe_mode = *enable;
 
-	return (DRX_STS_OK);
+	return DRX_STS_OK;
 
 rw_error:
-	return (DRX_STS_ERROR);
+	return DRX_STS_ERROR;
 }
 
 /* -------------------------------------------------------------------------- */
@@ -5265,13 +5265,13 @@ ctrl_get_cfg_pdr_safe_mode(struct drx_demod_instance *demod, bool *enabled)
 	struct drxj_data *ext_attr = (struct drxj_data *) NULL;
 
 	if (enabled == NULL) {
-		return (DRX_STS_INVALID_ARG);
+		return DRX_STS_INVALID_ARG;
 	}
 
 	ext_attr = (struct drxj_data *) demod->my_ext_attr;
 	*enabled = ext_attr->pdr_safe_mode;
 
-	return (DRX_STS_OK);
+	return DRX_STS_OK;
 }
 
 /**
@@ -5589,7 +5589,7 @@ static int init_agc(struct drx_demod_instance *demod)
 		break;
 #endif
 	default:
-		return (DRX_STS_INVALID_ARG);
+		return DRX_STS_INVALID_ARG;
 	}
 
 	/* for new AGC interface */
@@ -5759,9 +5759,9 @@ static int init_agc(struct drx_demod_instance *demod)
 		goto rw_error;
 	}
 
-	return (DRX_STS_OK);
+	return DRX_STS_OK;
 rw_error:
-	return (DRX_STS_ERROR);
+	return DRX_STS_ERROR;
 }
 
 /**
@@ -5820,7 +5820,7 @@ set_frequency(struct drx_demod_instance *demod,
 		select_pos_image = false;
 		break;
 	default:
-		return (DRX_STS_INVALID_ARG);
+		return DRX_STS_INVALID_ARG;
 	}
 	intermediate_freq = demod->my_common_attr->intermediate_freq;
 	sampling_frequency = demod->my_common_attr->sys_clock_freq / 3;
@@ -5861,9 +5861,9 @@ set_frequency(struct drx_demod_instance *demod,
 	ext_attr->iqm_fs_rate_ofs = iqm_fs_rate_ofs;
 	ext_attr->pos_image = (bool) (rf_mirror ^ tuner_mirror ^ select_pos_image);
 
-	return (DRX_STS_OK);
+	return DRX_STS_OK;
 rw_error:
-	return (DRX_STS_ERROR);
+	return DRX_STS_ERROR;
 }
 
 /**
@@ -5938,9 +5938,9 @@ static int get_sig_strength(struct drx_demod_instance *demod, u16 *sig_strength)
 		*sig_strength = (20 * if_gain / if_agc_sns);
 	}
 
-	return (DRX_STS_OK);
+	return DRX_STS_OK;
 rw_error:
-	return (DRX_STS_ERROR);
+	return DRX_STS_ERROR;
 }
 
 /**
@@ -5986,9 +5986,9 @@ static int get_acc_pkt_err(struct drx_demod_instance *demod, u16 *packet_err)
 	*packet_err = pkt_err;
 	last_pkt_err = data;
 
-	return (DRX_STS_OK);
+	return DRX_STS_OK;
 rw_error:
-	return (DRX_STS_ERROR);
+	return DRX_STS_ERROR;
 }
 #endif
 
@@ -6016,10 +6016,10 @@ static int ctrl_set_cfg_reset_pkt_err(struct drx_demod_instance *demod)
 		goto rw_error;
 	}
 
-	return (DRX_STS_OK);
+	return DRX_STS_OK;
 rw_error:
 #endif
-	return (DRX_STS_ERROR);
+	return DRX_STS_ERROR;
 }
 
 /**
@@ -6055,9 +6055,9 @@ static int get_str_freq_offset(struct drx_demod_instance *demod, s32 *str_freq)
 				  symbol_frequency_ratio),
 				 (symbol_frequency_ratio + (1 << 23)));
 
-	return (DRX_STS_OK);
+	return DRX_STS_OK;
 rw_error:
-	return (DRX_STS_ERROR);
+	return DRX_STS_ERROR;
 }
 
 /**
@@ -6112,9 +6112,9 @@ static int get_ctl_freq_offset(struct drx_demod_instance *demod, s32 *ctl_freq)
 	*ctl_freq =
 	    (s32) ((((data64lo >> 28) & 0xf) | (data64hi << 4)) * sign);
 
-	return (DRX_STS_OK);
+	return DRX_STS_OK;
 rw_error:
-	return (DRX_STS_ERROR);
+	return DRX_STS_ERROR;
 }
 
 /*============================================================================*/
@@ -6219,7 +6219,7 @@ set_agc_rf(struct drx_demod_instance *demod, struct drxj_cfg_agc *agc_settings,
 			else if (DRXJ_ISATVSTD(agc_settings->standard))
 				p_agc_settings = &(ext_attr->atv_if_agc_cfg);
 			else
-				return (DRX_STS_INVALID_ARG);
+				return DRX_STS_INVALID_ARG;
 
 			/* Set TOP, only if IF-AGC is in AUTO mode */
 			if (p_agc_settings->ctrl_mode == DRX_AGC_CTRL_AUTO) {
@@ -6311,7 +6311,7 @@ set_agc_rf(struct drx_demod_instance *demod, struct drxj_cfg_agc *agc_settings,
 			}
 			break;
 		default:
-			return (DRX_STS_INVALID_ARG);
+			return DRX_STS_INVALID_ARG;
 		}		/* switch ( agcsettings->ctrl_mode ) */
 	}
 
@@ -6339,12 +6339,12 @@ set_agc_rf(struct drx_demod_instance *demod, struct drxj_cfg_agc *agc_settings,
 		break;
 #endif
 	default:
-		return (DRX_STS_ERROR);
+		return DRX_STS_ERROR;
 	}
 
-	return (DRX_STS_OK);
+	return DRX_STS_OK;
 rw_error:
-	return (DRX_STS_ERROR);
+	return DRX_STS_ERROR;
 }
 
 /**
@@ -6390,7 +6390,7 @@ get_agc_rf(struct drx_demod_instance *demod, struct drxj_cfg_agc *agc_settings)
 		break;
 #endif
 	default:
-		return (DRX_STS_ERROR);
+		return DRX_STS_ERROR;
 	}
 	agc_settings->standard = standard;
 
@@ -6407,9 +6407,9 @@ get_agc_rf(struct drx_demod_instance *demod, struct drxj_cfg_agc *agc_settings)
 		}
 	}
 
-	return (DRX_STS_OK);
+	return DRX_STS_OK;
 rw_error:
-	return (DRX_STS_ERROR);
+	return DRX_STS_ERROR;
 }
 
 /**
@@ -6512,7 +6512,7 @@ set_agc_if(struct drx_demod_instance *demod, struct drxj_cfg_agc *agc_settings,
 			else if (DRXJ_ISATVSTD(agc_settings->standard))
 				p_agc_settings = &(ext_attr->atv_rf_agc_cfg);
 			else
-				return (DRX_STS_INVALID_ARG);
+				return DRX_STS_INVALID_ARG;
 
 			/* Restore TOP */
 			if (p_agc_settings->ctrl_mode == DRX_AGC_CTRL_AUTO) {
@@ -6612,7 +6612,7 @@ set_agc_if(struct drx_demod_instance *demod, struct drxj_cfg_agc *agc_settings,
 			}
 			break;
 		default:
-			return (DRX_STS_INVALID_ARG);
+			return DRX_STS_INVALID_ARG;
 		}		/* switch ( agcsettings->ctrl_mode ) */
 
 		/* always set the top to support configurations without if-loop */
@@ -6647,12 +6647,12 @@ set_agc_if(struct drx_demod_instance *demod, struct drxj_cfg_agc *agc_settings,
 		break;
 #endif
 	default:
-		return (DRX_STS_ERROR);
+		return DRX_STS_ERROR;
 	}
 
-	return (DRX_STS_OK);
+	return DRX_STS_OK;
 rw_error:
-	return (DRX_STS_ERROR);
+	return DRX_STS_ERROR;
 }
 
 /**
@@ -6698,7 +6698,7 @@ get_agc_if(struct drx_demod_instance *demod, struct drxj_cfg_agc *agc_settings)
 		break;
 #endif
 	default:
-		return (DRX_STS_ERROR);
+		return DRX_STS_ERROR;
 	}
 	agc_settings->standard = standard;
 
@@ -6716,9 +6716,9 @@ get_agc_if(struct drx_demod_instance *demod, struct drxj_cfg_agc *agc_settings)
 		}
 	}
 
-	return (DRX_STS_OK);
+	return DRX_STS_OK;
 rw_error:
-	return (DRX_STS_ERROR);
+	return DRX_STS_ERROR;
 }
 
 /**
@@ -6763,9 +6763,9 @@ static int set_iqm_af(struct drx_demod_instance *demod, bool active)
 		goto rw_error;
 	}
 
-	return (DRX_STS_OK);
+	return DRX_STS_OK;
 rw_error:
-	return (DRX_STS_ERROR);
+	return DRX_STS_ERROR;
 }
 
 /*============================================================================*/
@@ -6871,9 +6871,9 @@ static int power_down_vsb(struct drx_demod_instance *demod, bool primary)
 		goto rw_error;
 	}
 
-	return (DRX_STS_OK);
+	return DRX_STS_OK;
 rw_error:
-	return (DRX_STS_ERROR);
+	return DRX_STS_ERROR;
 }
 
 /**
@@ -7087,9 +7087,9 @@ static int set_vsb_leak_n_gain(struct drx_demod_instance *demod)
 		goto rw_error;
 	}
 
-	return (DRX_STS_OK);
+	return DRX_STS_OK;
 rw_error:
-	return (DRX_STS_ERROR);
+	return DRX_STS_ERROR;
 }
 
 /**
@@ -7600,9 +7600,9 @@ static int set_vsb(struct drx_demod_instance *demod)
 		goto rw_error;
 	}
 
-	return (DRX_STS_OK);
+	return DRX_STS_OK;
 rw_error:
-	return (DRX_STS_ERROR);
+	return DRX_STS_ERROR;
 }
 
 /**
@@ -7639,9 +7639,9 @@ static int get_vsb_post_rs_pck_err(struct i2c_device_addr *dev_addr, u16 *pck_er
 	    (u16) frac_times1e6(packet_errorsMant * (1 << packet_errorsExp),
 				 (period * prescale * 77));
 
-	return (DRX_STS_OK);
+	return DRX_STS_OK;
 rw_error:
-	return (DRX_STS_ERROR);
+	return DRX_STS_ERROR;
 }
 
 /**
@@ -7685,9 +7685,9 @@ static int get_vs_bpost_viterbi_ber(struct i2c_device_addr *dev_addr, u32 *ber)
 				 ((bit_errors_exp > 2) ? 1 : 8));
 	}
 
-	return (DRX_STS_OK);
+	return DRX_STS_OK;
 rw_error:
-	return (DRX_STS_ERROR);
+	return DRX_STS_ERROR;
 }
 
 /**
@@ -7709,9 +7709,9 @@ static int get_vs_bpre_viterbi_ber(struct i2c_device_addr *dev_addr, u32 *ber)
 	    frac_times1e6(data,
 			 VSB_TOP_MEASUREMENT_PERIOD * SYMBOLS_PER_SEGMENT);
 
-	return (DRX_STS_OK);
+	return DRX_STS_OK;
 rw_error:
-	return (DRX_STS_ERROR);
+	return DRX_STS_ERROR;
 }
 
 /**
@@ -7747,9 +7747,9 @@ static int get_vsb_symb_err(struct i2c_device_addr *dev_addr, u32 *ser)
 	*ser = (u32) frac_times1e6((symb_errors_mant << symb_errors_exp) * 1000,
 				    (period * prescale * 77318));
 
-	return (DRX_STS_OK);
+	return DRX_STS_OK;
 rw_error:
-	return (DRX_STS_ERROR);
+	return DRX_STS_ERROR;
 }
 
 /**
@@ -7770,9 +7770,9 @@ static int get_vsbmer(struct i2c_device_addr *dev_addr, u16 *mer)
 	*mer =
 	    (u16) (log1_times100(21504) - log1_times100((data_hi << 6) / 52));
 
-	return (DRX_STS_OK);
+	return DRX_STS_OK;
 rw_error:
-	return (DRX_STS_ERROR);
+	return DRX_STS_ERROR;
 }
 
 /*============================================================================*/
@@ -7852,9 +7852,9 @@ ctrl_get_vsb_constel(struct drx_demod_instance *demod, struct drx_complex *compl
 		goto rw_error;
 	}
 
-	return (DRX_STS_OK);
+	return DRX_STS_OK;
 rw_error:
-	return (DRX_STS_ERROR);
+	return DRX_STS_ERROR;
 }
 
 /*============================================================================*/
@@ -7961,9 +7961,9 @@ static int power_down_qam(struct drx_demod_instance *demod, bool primary)
 		goto rw_error;
 	}
 
-	return (DRX_STS_OK);
+	return DRX_STS_OK;
 rw_error:
-	return (DRX_STS_ERROR);
+	return DRX_STS_ERROR;
 }
 
 /*============================================================================*/
@@ -8026,7 +8026,7 @@ set_qam_measurement(struct drx_demod_instance *demod,
 		fec_bits_desired = 8 * symbol_rate;
 		break;
 	default:
-		return (DRX_STS_INVALID_ARG);
+		return DRX_STS_INVALID_ARG;
 	}
 
 	/* Parameters for Reed-Solomon Decoder */
@@ -8045,7 +8045,7 @@ set_qam_measurement(struct drx_demod_instance *demod,
 		fec_rs_plen = 128 * 7;
 		break;
 	default:
-		return (DRX_STS_INVALID_ARG);
+		return DRX_STS_INVALID_ARG;
 	}
 
 	ext_attr->fec_rs_plen = fec_rs_plen;	/* for getSigQual */
@@ -8078,11 +8078,11 @@ set_qam_measurement(struct drx_demod_instance *demod,
 			fec_oc_snc_fail_period = 25805;
 			break;
 		default:
-			return (DRX_STS_INVALID_ARG);
+			return DRX_STS_INVALID_ARG;
 		}
 		break;
 	default:
-		return (DRX_STS_INVALID_ARG);
+		return DRX_STS_INVALID_ARG;
 	}
 
 	rc = DRXJ_DAP.write_reg16func(dev_addr, FEC_OC_SNC_FAIL_PERIOD__A, (u16)fec_oc_snc_fail_period, 0);
@@ -8145,7 +8145,7 @@ set_qam_measurement(struct drx_demod_instance *demod,
 			    * (QAM_TOP_CONSTELLATION_QAM256 + 1);
 			break;
 		default:
-			return (DRX_STS_INVALID_ARG);
+			return DRX_STS_INVALID_ARG;
 		}
 		if (qam_vd_period == 0) {
 			pr_err("error: qam_vd_period is zero!\n");
@@ -8173,9 +8173,9 @@ set_qam_measurement(struct drx_demod_instance *demod,
 		ext_attr->qam_vd_prescale = qam_vd_prescale;
 	}
 
-	return (DRX_STS_OK);
+	return DRX_STS_OK;
 rw_error:
-	return (DRX_STS_ERROR);
+	return DRX_STS_ERROR;
 }
 
 /*============================================================================*/
@@ -8408,9 +8408,9 @@ static int set_qam16(struct drx_demod_instance *demod)
 		goto rw_error;
 	}
 
-	return (DRX_STS_OK);
+	return DRX_STS_OK;
 rw_error:
-	return (DRX_STS_ERROR);
+	return DRX_STS_ERROR;
 }
 
 /*============================================================================*/
@@ -8643,9 +8643,9 @@ static int set_qam32(struct drx_demod_instance *demod)
 		goto rw_error;
 	}
 
-	return (DRX_STS_OK);
+	return DRX_STS_OK;
 rw_error:
-	return (DRX_STS_ERROR);
+	return DRX_STS_ERROR;
 }
 
 /*============================================================================*/
@@ -8878,9 +8878,9 @@ static int set_qam64(struct drx_demod_instance *demod)
 		goto rw_error;
 	}
 
-	return (DRX_STS_OK);
+	return DRX_STS_OK;
 rw_error:
-	return (DRX_STS_ERROR);
+	return DRX_STS_ERROR;
 }
 
 /*============================================================================*/
@@ -9113,9 +9113,9 @@ static int set_qam128(struct drx_demod_instance *demod)
 		goto rw_error;
 	}
 
-	return (DRX_STS_OK);
+	return DRX_STS_OK;
 rw_error:
-	return (DRX_STS_ERROR);
+	return DRX_STS_ERROR;
 }
 
 /*============================================================================*/
@@ -9348,9 +9348,9 @@ static int set_qam256(struct drx_demod_instance *demod)
 		goto rw_error;
 	}
 
-	return (DRX_STS_OK);
+	return DRX_STS_OK;
 rw_error:
-	return (DRX_STS_ERROR);
+	return DRX_STS_ERROR;
 }
 
 /*============================================================================*/
@@ -9528,7 +9528,7 @@ set_qam(struct drx_demod_instance *demod,
 				iqm_rc_stretch = IQM_RC_STRETCH_QAM_B_64;
 				break;
 			default:
-				return (DRX_STS_INVALID_ARG);
+				return DRX_STS_INVALID_ARG;
 			}
 		} else {
 			adc_frequency = (common_attr->sys_clock_freq * 1000) / 3;
@@ -9565,7 +9565,7 @@ set_qam(struct drx_demod_instance *demod,
 			set_param_parameters[0] = channel->constellation;	/* constellation     */
 			set_param_parameters[1] = DRX_INTERLEAVEMODE_I12_J17;	/* interleave mode   */
 		} else {
-			return (DRX_STS_INVALID_ARG);
+			return DRX_STS_INVALID_ARG;
 		}
 	}
 
@@ -9831,7 +9831,7 @@ set_qam(struct drx_demod_instance *demod,
 				}
 				break;
 			default:
-				return (DRX_STS_ERROR);
+				return DRX_STS_ERROR;
 			}	/* switch */
 		}
 
@@ -10049,7 +10049,7 @@ set_qam(struct drx_demod_instance *demod,
 				}
 				break;
 			default:
-				return (DRX_STS_ERROR);
+				return DRX_STS_ERROR;
 			}
 		} else if (ext_attr->standard == DRX_STANDARD_ITU_C) {
 			rc = DRXJ_DAP.write_block_func(dev_addr, IQM_CF_TAP_RE0__A, sizeof(qam_c_taps), ((u8 *)qam_c_taps), 0);
@@ -10102,7 +10102,7 @@ set_qam(struct drx_demod_instance *demod,
 			}
 			break;
 		default:
-			return (DRX_STS_ERROR);
+			return DRX_STS_ERROR;
 		}		/* switch */
 	}
 
@@ -10187,9 +10187,9 @@ set_qam(struct drx_demod_instance *demod,
 		goto rw_error;
 	}
 
-	return (DRX_STS_OK);
+	return DRX_STS_OK;
 rw_error:
-	return (DRX_STS_ERROR);
+	return DRX_STS_ERROR;
 }
 
 /*============================================================================*/
@@ -10371,9 +10371,9 @@ static int qam_flip_spec(struct drx_demod_instance *demod, struct drx_channel *c
 		goto rw_error;
 	}
 
-	return (DRX_STS_OK);
+	return DRX_STS_OK;
 rw_error:
-	return (DRX_STS_ERROR);
+	return DRX_STS_ERROR;
 
 }
 
@@ -10523,9 +10523,9 @@ qam64auto(struct drx_demod_instance *demod,
 	    );
 	/* Returning control to apllication ... */
 
-	return (DRX_STS_OK);
+	return DRX_STS_OK;
 rw_error:
-	return (DRX_STS_ERROR);
+	return DRX_STS_ERROR;
 }
 
 /**
@@ -10606,9 +10606,9 @@ qam256auto(struct drx_demod_instance *demod,
 	     ((drxbsp_hst_clock() - start_time) <
 	      (DRXJ_QAM_MAX_WAITTIME + timeout_ofs)));
 
-	return (DRX_STS_OK);
+	return DRX_STS_OK;
 rw_error:
-	return (DRX_STS_ERROR);
+	return DRX_STS_ERROR;
 }
 
 /**
@@ -10784,19 +10784,19 @@ set_qamChannel(struct drx_demod_instance *demod,
 			channel->constellation = DRX_CONSTELLATION_AUTO;
 		} else {
 			channel->constellation = DRX_CONSTELLATION_AUTO;
-			return (DRX_STS_INVALID_ARG);
+			return DRX_STS_INVALID_ARG;
 		}
 		break;
 	default:
-		return (DRX_STS_INVALID_ARG);
+		return DRX_STS_INVALID_ARG;
 	}
 
-	return (DRX_STS_OK);
+	return DRX_STS_OK;
 rw_error:
 	/* restore starting value */
 	if (auto_flag)
 		channel->constellation = DRX_CONSTELLATION_AUTO;
-	return (DRX_STS_ERROR);
+	return DRX_STS_ERROR;
 }
 
 /*============================================================================*/
@@ -10819,7 +10819,7 @@ GetQAMRSErr_count(struct i2c_device_addr *dev_addr, struct drxjrs_errors *rs_err
 
 	/* check arguments */
 	if (dev_addr == NULL) {
-		return (DRX_STS_INVALID_ARG);
+		return DRX_STS_INVALID_ARG;
 	}
 
 	/* all reported errors are received in the  */
@@ -10865,9 +10865,9 @@ GetQAMRSErr_count(struct i2c_device_addr *dev_addr, struct drxjrs_errors *rs_err
 	rs_errors->nr_snc_par_fail_count =
 	    nr_snc_par_fail_count & FEC_OC_SNC_FAIL_COUNT__M;
 
-	return (DRX_STS_OK);
+	return DRX_STS_OK;
 rw_error:
-	return (DRX_STS_ERROR);
+	return DRX_STS_ERROR;
 }
 
 /*============================================================================*/
@@ -10968,7 +10968,7 @@ ctrl_get_qam_sig_quality(struct drx_demod_instance *demod, struct drx_sig_qualit
 		qam_sl_sig_power = DRXJ_QAM_SL_SIG_POWER_QAM256 << 2;
 		break;
 	default:
-		return (DRX_STS_ERROR);
+		return DRX_STS_ERROR;
 	}
 
 	/* ------------------------------ */
@@ -11074,9 +11074,9 @@ ctrl_get_qam_sig_quality(struct drx_demod_instance *demod, struct drx_sig_qualit
 	sig_quality->packet_error = ((u16) pkt_errs);
 #endif
 
-	return (DRX_STS_OK);
+	return DRX_STS_OK;
 rw_error:
-	return (DRX_STS_ERROR);
+	return DRX_STS_ERROR;
 }
 
 /**
@@ -11181,9 +11181,9 @@ ctrl_get_qam_constel(struct drx_demod_instance *demod, struct drx_complex *compl
 		goto rw_error;
 	}
 
-	return (DRX_STS_OK);
+	return DRX_STS_OK;
 rw_error:
-	return (DRX_STS_ERROR);
+	return DRX_STS_ERROR;
 }
 #endif /* #ifndef DRXJ_VSB_ONLY */
 
@@ -11445,9 +11445,9 @@ atv_update_config(struct drx_demod_instance *demod, bool force_update)
 
 	ext_attr->atv_cfg_changed_flags = 0;
 
-	return (DRX_STS_OK);
+	return DRX_STS_OK;
 rw_error:
-	return (DRX_STS_ERROR);
+	return DRX_STS_ERROR;
 }
 
 /* -------------------------------------------------------------------------- */
@@ -11467,7 +11467,7 @@ ctrl_set_cfg_atv_output(struct drx_demod_instance *demod, struct drxj_cfg_atv_ou
 
 	/* Check arguments */
 	if (output_cfg == NULL) {
-		return (DRX_STS_INVALID_ARG);
+		return DRX_STS_INVALID_ARG;
 	}
 
 	ext_attr = (struct drxj_data *) demod->my_ext_attr;
@@ -11506,9 +11506,9 @@ ctrl_set_cfg_atv_output(struct drx_demod_instance *demod, struct drxj_cfg_atv_ou
 		goto rw_error;
 	}
 
-	return (DRX_STS_OK);
+	return DRX_STS_OK;
 rw_error:
-	return (DRX_STS_ERROR);
+	return DRX_STS_ERROR;
 }
 
 /* -------------------------------------------------------------------------- */
@@ -11545,7 +11545,7 @@ ctrl_set_cfg_atv_equ_coef(struct drx_demod_instance *demod, struct drxj_cfg_atv_
 	    (coef->coef1 < ((s16) ~(ATV_TOP_EQU1_EQU_C1__M >> 1))) ||
 	    (coef->coef2 < ((s16) ~(ATV_TOP_EQU2_EQU_C2__M >> 1))) ||
 	    (coef->coef3 < ((s16) ~(ATV_TOP_EQU3_EQU_C3__M >> 1)))) {
-		return (DRX_STS_INVALID_ARG);
+		return DRX_STS_INVALID_ARG;
 	}
 
 	rc = atv_equ_coef_index(ext_attr->standard, &index);
@@ -11565,9 +11565,9 @@ ctrl_set_cfg_atv_equ_coef(struct drx_demod_instance *demod, struct drxj_cfg_atv_
 		goto rw_error;
 	}
 
-	return (DRX_STS_OK);
+	return DRX_STS_OK;
 rw_error:
-	return (DRX_STS_ERROR);
+	return DRX_STS_ERROR;
 }
 
 /* -------------------------------------------------------------------------- */
@@ -11613,9 +11613,9 @@ ctrl_get_cfg_atv_equ_coef(struct drx_demod_instance *demod, struct drxj_cfg_atv_
 	coef->coef2 = ext_attr->atv_top_equ2[index];
 	coef->coef3 = ext_attr->atv_top_equ3[index];
 
-	return (DRX_STS_OK);
+	return DRX_STS_OK;
 rw_error:
-	return (DRX_STS_ERROR);
+	return DRX_STS_ERROR;
 }
 
 /* -------------------------------------------------------------------------- */
@@ -11638,7 +11638,7 @@ ctrl_set_cfg_atv_misc(struct drx_demod_instance *demod, struct drxj_cfg_atv_misc
 	    ((settings->peak_filter) < (s16) (-8)) ||
 	    ((settings->peak_filter) > (s16) (15)) ||
 	    ((settings->noise_filter) > 15)) {
-		return (DRX_STS_INVALID_ARG);
+		return DRX_STS_INVALID_ARG;
 	}
 	/* if */
 	ext_attr = (struct drxj_data *) demod->my_ext_attr;
@@ -11659,9 +11659,9 @@ ctrl_set_cfg_atv_misc(struct drx_demod_instance *demod, struct drxj_cfg_atv_misc
 		goto rw_error;
 	}
 
-	return (DRX_STS_OK);
+	return DRX_STS_OK;
 rw_error:
-	return (DRX_STS_ERROR);
+	return DRX_STS_ERROR;
 }
 
 /* -------------------------------------------------------------------------- */
@@ -11691,7 +11691,7 @@ ctrl_get_cfg_atv_misc(struct drx_demod_instance *demod, struct drxj_cfg_atv_misc
 	settings->peak_filter = ext_attr->atv_top_vid_peak;
 	settings->noise_filter = ext_attr->atv_top_noise_th;
 
-	return (DRX_STS_OK);
+	return DRX_STS_OK;
 }
 
 /* -------------------------------------------------------------------------- */
@@ -11739,9 +11739,9 @@ ctrl_get_cfg_atv_output(struct drx_demod_instance *demod, struct drxj_cfg_atv_ou
 		output_cfg->sif_attenuation = (enum drxjsif_attenuation) data;
 	}
 
-	return (DRX_STS_OK);
+	return DRX_STS_OK;
 rw_error:
-	return (DRX_STS_ERROR);
+	return DRX_STS_ERROR;
 }
 
 /* -------------------------------------------------------------------------- */
@@ -11859,9 +11859,9 @@ ctrl_get_cfg_atv_agc_status(struct drx_demod_instance *demod,
 	agc_status->if_agc_loop_gain =
 	    ((data & SCU_RAM_AGC_KI_IF__M) >> SCU_RAM_AGC_KI_IF__B);
 
-	return (DRX_STS_OK);
+	return DRX_STS_OK;
 rw_error:
-	return (DRX_STS_ERROR);
+	return DRX_STS_ERROR;
 }
 
 /* -------------------------------------------------------------------------- */
@@ -11907,9 +11907,9 @@ static int power_up_atv(struct drx_demod_instance *demod, enum drx_standard stan
 
 	/* Audio, already done during set standard */
 
-	return (DRX_STS_OK);
+	return DRX_STS_OK;
 rw_error:
-	return (DRX_STS_ERROR);
+	return DRX_STS_ERROR;
 }
 #endif /* #ifndef DRXJ_DIGITAL_ONLY */
 
@@ -12009,9 +12009,9 @@ power_down_atv(struct drx_demod_instance *demod, enum drx_standard standard, boo
 		goto rw_error;
 	}
 
-	return (DRX_STS_OK);
+	return DRX_STS_OK;
 rw_error:
-	return (DRX_STS_ERROR);
+	return DRX_STS_ERROR;
 }
 
 /* -------------------------------------------------------------------------- */
@@ -12881,7 +12881,7 @@ trouble ?
 		ext_attr->enable_cvbs_output = true;
 		break;
 	default:
-		return (DRX_STS_ERROR);
+		return DRX_STS_ERROR;
 	}
 
 	/* Common initializations FM & NTSC & B/G & D/K & I & L & LP */
@@ -13113,9 +13113,9 @@ trouble ?
 		}
 	}
 
-	return (DRX_STS_OK);
+	return DRX_STS_OK;
 rw_error:
-	return (DRX_STS_ERROR);
+	return DRX_STS_ERROR;
 }
 #endif
 
@@ -13192,9 +13192,9 @@ set_atv_channel(struct drx_demod_instance *demod,
       ext_attr->detectedRDS = (bool)false;
    }*/
 
-	return (DRX_STS_OK);
+	return DRX_STS_OK;
 rw_error:
-	return (DRX_STS_ERROR);
+	return DRX_STS_ERROR;
 }
 #endif
 
@@ -13276,14 +13276,14 @@ get_atv_channel(struct drx_demod_instance *demod,
 		channel->bandwidth = DRX_BANDWIDTH_UNKNOWN;
 		break;
 	default:
-		return (DRX_STS_ERROR);
+		return DRX_STS_ERROR;
 	}
 
 	channel->frequency -= offset;
 
-	return (DRX_STS_OK);
+	return DRX_STS_OK;
 rw_error:
-	return (DRX_STS_ERROR);
+	return DRX_STS_ERROR;
 }
 
 /* -------------------------------------------------------------------------- */
@@ -13363,7 +13363,7 @@ get_atv_sig_strength(struct drx_demod_instance *demod, u16 *sig_strength)
 		digital_min_gain = 0;	/* taken from ucode */
 		break;
 	default:
-		return (DRX_STS_ERROR);
+		return DRX_STS_ERROR;
 		break;
 	}
 	rc = DRXJ_DAP.read_reg16func(dev_addr, IQM_AF_AGC_RF__A, &rf_curr_gain, 0);
@@ -13415,9 +13415,9 @@ get_atv_sig_strength(struct drx_demod_instance *demod, u16 *sig_strength)
 				rf_weight * rf_strength + if_weight * if_strength);
 	*sig_strength /= 100;
 
-	return (DRX_STS_OK);
+	return DRX_STS_OK;
 rw_error:
-	return (DRX_STS_ERROR);
+	return DRX_STS_ERROR;
 }
 
 /* -------------------------------------------------------------------------- */
@@ -13473,9 +13473,9 @@ atv_sig_quality(struct drx_demod_instance *demod, struct drx_sig_quality *sig_qu
 		    (30 * (0x7FF - quality_indicator)) / (0x7FF - 0x701);
 	}
 
-	return (DRX_STS_OK);
+	return DRX_STS_OK;
 rw_error:
-	return (DRX_STS_ERROR);
+	return DRX_STS_ERROR;
 }
 #endif /* DRXJ_DIGITAL_ONLY */
 
@@ -15628,7 +15628,7 @@ aud_ctrl_set_cfg_prescale(struct drx_demod_instance *demod, struct drx_cfg_aud_p
 		/* shift before writing to register */
 		nicam_prescaler <<= 8;
 	} else {
-		return (DRX_STS_INVALID_ARG);
+		return DRX_STS_INVALID_ARG;
 	}
 	/* end of setting NICAM Prescaler */
 
@@ -16085,10 +16085,10 @@ fm_lock_status(struct drx_demod_instance *demod, enum drx_lock_status *lock_stat
 		*lock_stat = DRX_NOT_LOCKED;
 	}
 
-	return (DRX_STS_OK);
+	return DRX_STS_OK;
 
 rw_error:
-	return (DRX_STS_ERROR);
+	return DRX_STS_ERROR;
 }
 
 /*============================================================================*/
@@ -16119,10 +16119,10 @@ fm_sig_quality(struct drx_demod_instance *demod, struct drx_sig_quality *sig_qua
 		sig_quality->indicator = 0;
 	}
 
-	return (DRX_STS_OK);
+	return DRX_STS_OK;
 
 rw_error:
-	return (DRX_STS_ERROR);
+	return DRX_STS_ERROR;
 }
 
 #endif
@@ -16192,9 +16192,9 @@ get_oob_lock_status(struct drx_demod_instance *demod,
 
 	/* *oob_lock = scu_cmd.result[1]; */
 
-	return (DRX_STS_OK);
+	return DRX_STS_OK;
 rw_error:
-	return (DRX_STS_ERROR);
+	return DRX_STS_ERROR;
 }
 
 /**
@@ -16252,7 +16252,7 @@ get_oob_symbol_rate_offset(struct i2c_device_addr *dev_addr, s32 *symbol_rate_of
 		symbol_rate = 1544000;	/* bps */
 		break;
 	default:
-		return (DRX_STS_ERROR);
+		return DRX_STS_ERROR;
 	}
 
 	rc = DRXJ_DAP.read_reg16func(dev_addr, ORX_CON_CTI_DTI_R__A, &data, 0);
@@ -16282,9 +16282,9 @@ get_oob_symbol_rate_offset(struct i2c_device_addr *dev_addr, s32 *symbol_rate_of
 
 	*symbol_rate_offset = timing_offset;
 
-	return (DRX_STS_OK);
+	return DRX_STS_OK;
 rw_error:
-	return (DRX_STS_ERROR);
+	return DRX_STS_ERROR;
 }
 
 /**
@@ -16372,7 +16372,7 @@ get_oob_freq_offset(struct drx_demod_instance *demod, s32 *freq_offset)
 		symbol_rate = 1544000;
 		break;
 	default:
-		return (DRX_STS_ERROR);
+		return DRX_STS_ERROR;
 	}
 
 	/* find FINE frequency offset */
@@ -16400,9 +16400,9 @@ get_oob_freq_offset(struct drx_demod_instance *demod, s32 *freq_offset)
 	else
 		*freq_offset = (coarse_freq_offset + fine_freq_offset);
 
-	return (DRX_STS_OK);
+	return DRX_STS_OK;
 rw_error:
-	return (DRX_STS_ERROR);
+	return DRX_STS_ERROR;
 }
 
 /**
@@ -16444,9 +16444,9 @@ get_oob_frequency(struct drx_demod_instance *demod, s32 *frequency)
 
 	*frequency = freq + freq_offset;
 
-	return (DRX_STS_OK);
+	return DRX_STS_OK;
 rw_error:
-	return (DRX_STS_ERROR);
+	return DRX_STS_ERROR;
 }
 
 /**
@@ -16592,9 +16592,9 @@ static int get_oobmer(struct i2c_device_addr *dev_addr, u32 *mer)
 		*mer = 0;
 		break;
 	}
-	return (DRX_STS_OK);
+	return DRX_STS_OK;
 rw_error:
-	return (DRX_STS_ERROR);
+	return DRX_STS_ERROR;
 }
 #endif /*#ifndef DRXJ_DIGITAL_ONLY */
 
@@ -16644,9 +16644,9 @@ static int set_orx_nsu_aox(struct drx_demod_instance *demod, bool active)
 		goto rw_error;
 	}
 
-	return (DRX_STS_OK);
+	return DRX_STS_OK;
 rw_error:
-	return (DRX_STS_ERROR);
+	return DRX_STS_ERROR;
 }
 
 /**
@@ -16730,12 +16730,12 @@ static int ctrl_set_oob(struct drx_demod_instance *demod, struct drxoob *oob_par
 		}
 
 		ext_attr->oob_power_on = false;
-		return (DRX_STS_OK);
+		return DRX_STS_OK;
 	}
 
 	freq = oob_param->frequency;
 	if ((freq < 70000) || (freq > 130000))
-		return (DRX_STS_ERROR);
+		return DRX_STS_ERROR;
 	freq = (freq - 50000) / 50;
 
 	{
@@ -17169,10 +17169,10 @@ static int ctrl_set_oob(struct drx_demod_instance *demod, struct drxoob *oob_par
 
 	ext_attr->oob_power_on = true;
 
-	return (DRX_STS_OK);
+	return DRX_STS_OK;
 rw_error:
 #endif
-	return (DRX_STS_ERROR);
+	return DRX_STS_ERROR;
 }
 
 /**
@@ -17196,11 +17196,11 @@ ctrl_get_oob(struct drx_demod_instance *demod, struct drxoob_status *oob_status)
 
 	/* check arguments */
 	if (oob_status == NULL) {
-		return (DRX_STS_INVALID_ARG);
+		return DRX_STS_INVALID_ARG;
 	}
 
 	if (ext_attr->oob_power_on == false)
-		return (DRX_STS_ERROR);
+		return DRX_STS_ERROR;
 
 	rc = DRXJ_DAP.read_reg16func(dev_addr, ORX_DDC_OFO_SET_W__A, &data, 0);
 	if (rc != DRX_STS_OK) {
@@ -17249,10 +17249,10 @@ ctrl_get_oob(struct drx_demod_instance *demod, struct drxoob_status *oob_status)
 		goto rw_error;
 	}
 
-	return (DRX_STS_OK);
+	return DRX_STS_OK;
 rw_error:
 #endif
-	return (DRX_STS_ERROR);
+	return DRX_STS_ERROR;
 }
 
 /**
@@ -17270,7 +17270,7 @@ ctrl_set_cfg_oob_pre_saw(struct drx_demod_instance *demod, u16 *cfg_data)
 	int rc;
 
 	if (cfg_data == NULL) {
-		return (DRX_STS_INVALID_ARG);
+		return DRX_STS_INVALID_ARG;
 	}
 	dev_addr = demod->my_i2c_dev_addr;
 	ext_attr = (struct drxj_data *) demod->my_ext_attr;
@@ -17281,9 +17281,9 @@ ctrl_set_cfg_oob_pre_saw(struct drx_demod_instance *demod, u16 *cfg_data)
 		goto rw_error;
 	}
 	ext_attr->oob_pre_saw = *cfg_data;
-	return (DRX_STS_OK);
+	return DRX_STS_OK;
 rw_error:
-	return (DRX_STS_ERROR);
+	return DRX_STS_ERROR;
 }
 #endif
 
@@ -17300,13 +17300,13 @@ ctrl_get_cfg_oob_pre_saw(struct drx_demod_instance *demod, u16 *cfg_data)
 	struct drxj_data *ext_attr = NULL;
 
 	if (cfg_data == NULL) {
-		return (DRX_STS_INVALID_ARG);
+		return DRX_STS_INVALID_ARG;
 	}
 	ext_attr = (struct drxj_data *) demod->my_ext_attr;
 
 	*cfg_data = ext_attr->oob_pre_saw;
 
-	return (DRX_STS_OK);
+	return DRX_STS_OK;
 }
 #endif
 
@@ -17324,7 +17324,7 @@ ctrl_set_cfg_oob_lo_power(struct drx_demod_instance *demod, enum drxj_cfg_oob_lo
 	int rc;
 
 	if (cfg_data == NULL) {
-		return (DRX_STS_INVALID_ARG);
+		return DRX_STS_INVALID_ARG;
 	}
 	dev_addr = demod->my_i2c_dev_addr;
 	ext_attr = (struct drxj_data *) demod->my_ext_attr;
@@ -17335,9 +17335,9 @@ ctrl_set_cfg_oob_lo_power(struct drx_demod_instance *demod, enum drxj_cfg_oob_lo
 		goto rw_error;
 	}
 	ext_attr->oob_lo_pow = *cfg_data;
-	return (DRX_STS_OK);
+	return DRX_STS_OK;
 rw_error:
-	return (DRX_STS_ERROR);
+	return DRX_STS_ERROR;
 }
 #endif
 
@@ -17353,13 +17353,13 @@ ctrl_get_cfg_oob_lo_power(struct drx_demod_instance *demod, enum drxj_cfg_oob_lo
 	struct drxj_data *ext_attr = NULL;
 
 	if (cfg_data == NULL) {
-		return (DRX_STS_INVALID_ARG);
+		return DRX_STS_INVALID_ARG;
 	}
 	ext_attr = (struct drxj_data *) demod->my_ext_attr;
 
 	*cfg_data = ext_attr->oob_lo_pow;
 
-	return (DRX_STS_OK);
+	return DRX_STS_OK;
 }
 #endif
 /*============================================================================*/
@@ -17434,7 +17434,7 @@ ctrl_set_channel(struct drx_demod_instance *demod, struct drx_channel *channel)
 		break;
 	case DRX_STANDARD_UNKNOWN:
 	default:
-		return (DRX_STS_INVALID_ARG);
+		return DRX_STS_INVALID_ARG;
 	}
 
 	/* check bandwidth QAM annex B, NTSC and 8VSB */
@@ -17449,7 +17449,7 @@ ctrl_set_channel(struct drx_demod_instance *demod, struct drx_channel *channel)
 		case DRX_BANDWIDTH_8MHZ:	/* fall through */
 		case DRX_BANDWIDTH_7MHZ:	/* fall through */
 		default:
-			return (DRX_STS_INVALID_ARG);
+			return DRX_STS_INVALID_ARG;
 		}
 	}
 #ifndef DRXJ_DIGITAL_ONLY
@@ -17462,7 +17462,7 @@ ctrl_set_channel(struct drx_demod_instance *demod, struct drx_channel *channel)
 		case DRX_BANDWIDTH_6MHZ:	/* fall through */
 		case DRX_BANDWIDTH_UNKNOWN:	/* fall through */
 		default:
-			return (DRX_STS_INVALID_ARG);
+			return DRX_STS_INVALID_ARG;
 		}
 	}
 	/* check bandwidth PAL/SECAM  */
@@ -17479,7 +17479,7 @@ ctrl_set_channel(struct drx_demod_instance *demod, struct drx_channel *channel)
 		case DRX_BANDWIDTH_6MHZ:	/* fall through */
 		case DRX_BANDWIDTH_7MHZ:	/* fall through */
 		default:
-			return (DRX_STS_INVALID_ARG);
+			return DRX_STS_INVALID_ARG;
 		}
 	}
 #endif
@@ -17506,7 +17506,7 @@ ctrl_set_channel(struct drx_demod_instance *demod, struct drx_channel *channel)
 
 		if (channel->symbolrate < min_symbol_rate ||
 		    channel->symbolrate > max_symbol_rate) {
-			return (DRX_STS_INVALID_ARG);
+			return DRX_STS_INVALID_ARG;
 		}
 
 		switch (channel->constellation) {
@@ -17532,7 +17532,7 @@ ctrl_set_channel(struct drx_demod_instance *demod, struct drx_channel *channel)
 			}
 			break;
 		default:
-			return (DRX_STS_INVALID_ARG);
+			return DRX_STS_INVALID_ARG;
 		}
 	}
 
@@ -17546,7 +17546,7 @@ ctrl_set_channel(struct drx_demod_instance *demod, struct drx_channel *channel)
 		case DRX_CONSTELLATION_QAM64:
 			break;
 		default:
-			return (DRX_STS_INVALID_ARG);
+			return DRX_STS_INVALID_ARG;
 		}
 
 		switch (channel->interleavemode) {
@@ -17571,7 +17571,7 @@ ctrl_set_channel(struct drx_demod_instance *demod, struct drx_channel *channel)
 		case DRX_INTERLEAVEMODE_AUTO:
 			break;
 		default:
-			return (DRX_STS_INVALID_ARG);
+			return DRX_STS_INVALID_ARG;
 		}
 	}
 
@@ -17591,7 +17591,7 @@ ctrl_set_channel(struct drx_demod_instance *demod, struct drx_channel *channel)
 			break;
 		case DRX_BANDWIDTH_UNKNOWN:
 		default:
-			return (DRX_STS_INVALID_ARG);
+			return DRX_STS_INVALID_ARG;
 		}
 
 		rc = ctrl_uio_write(demod, &uio1);
@@ -17641,7 +17641,7 @@ ctrl_set_channel(struct drx_demod_instance *demod, struct drx_channel *channel)
 			break;
 		case DRX_STANDARD_UNKNOWN:
 		default:
-			return (DRX_STS_ERROR);
+			return DRX_STS_ERROR;
 		}		/* switch(standard) */
 
 		tuner_mode |= TUNER_MODE_SWITCH;
@@ -17761,7 +17761,7 @@ ctrl_set_channel(struct drx_demod_instance *demod, struct drx_channel *channel)
 #endif
 	case DRX_STANDARD_UNKNOWN:
 	default:
-		return (DRX_STS_ERROR);
+		return DRX_STS_ERROR;
 	}
 
    /*== Re-tune, slow mode ===================================================*/
@@ -17801,9 +17801,9 @@ ctrl_set_channel(struct drx_demod_instance *demod, struct drx_channel *channel)
 	/* flag the packet error counter reset */
 	ext_attr->reset_pkt_err_acc = true;
 
-	return (DRX_STS_OK);
+	return DRX_STS_OK;
 rw_error:
-	return (DRX_STS_ERROR);
+	return DRX_STS_ERROR;
 }
 
 /*=============================================================================
@@ -18015,7 +18015,7 @@ ctrl_get_channel(struct drx_demod_instance *demod, struct drx_channel *channel)
 				default:
 					channel->constellation =
 					    DRX_CONSTELLATION_UNKNOWN;
-					return (DRX_STS_ERROR);
+					return DRX_STS_ERROR;
 				}
 			}
 			break;
@@ -18037,7 +18037,7 @@ ctrl_get_channel(struct drx_demod_instance *demod, struct drx_channel *channel)
 #endif
 		case DRX_STANDARD_UNKNOWN:	/* fall trough */
 		default:
-			return (DRX_STS_ERROR);
+			return DRX_STS_ERROR;
 		}		/* switch ( standard ) */
 
 		if (lock_status == DRX_LOCKED) {
@@ -18045,9 +18045,9 @@ ctrl_get_channel(struct drx_demod_instance *demod, struct drx_channel *channel)
 		}
 	}
 	/* if ( lock_status == DRX_LOCKED ) */
-	return (DRX_STS_OK);
+	return DRX_STS_OK;
 rw_error:
-	return (DRX_STS_ERROR);
+	return DRX_STS_ERROR;
 }
 
 /*=============================================================================
@@ -18106,7 +18106,7 @@ ctrl_sig_quality(struct drx_demod_instance *demod, struct drx_sig_quality *sig_q
 
 	/* Check arguments */
 	if ((sig_quality == NULL) || (demod == NULL)) {
-		return (DRX_STS_INVALID_ARG);
+		return DRX_STS_INVALID_ARG;
 	}
 
 	ext_attr = (struct drxj_data *) demod->my_ext_attr;
@@ -18193,7 +18193,7 @@ ctrl_sig_quality(struct drx_demod_instance *demod, struct drx_sig_quality *sig_q
 				break;
 			default:
 				sig_quality->MER = 0;
-				return (DRX_STS_ERROR);
+				return DRX_STS_ERROR;
 			}
 		}
 
@@ -18213,7 +18213,7 @@ ctrl_sig_quality(struct drx_demod_instance *demod, struct drx_sig_quality *sig_q
 		case DRX_CONSTELLATION_QAM16:
 			break;
 		default:
-			return (DRX_STS_ERROR);
+			return DRX_STS_ERROR;
 		}
 		sig_quality->indicator =
 		    mer2indicator(sig_quality->MER, min_mer, threshold_mer,
@@ -18242,12 +18242,12 @@ ctrl_sig_quality(struct drx_demod_instance *demod, struct drx_sig_quality *sig_q
 		break;
 #endif
 	default:
-		return (DRX_STS_ERROR);
+		return DRX_STS_ERROR;
 	}
 
-	return (DRX_STS_OK);
+	return DRX_STS_OK;
 rw_error:
-	return (DRX_STS_ERROR);
+	return DRX_STS_ERROR;
 }
 
 /*============================================================================*/
@@ -18278,7 +18278,7 @@ ctrl_lock_status(struct drx_demod_instance *demod, enum drx_lock_status *lock_st
 
 	/* check arguments */
 	if ((demod == NULL) || (lock_stat == NULL)) {
-		return (DRX_STS_INVALID_ARG);
+		return DRX_STS_INVALID_ARG;
 	}
 
 	dev_addr = demod->my_i2c_dev_addr;
@@ -18317,7 +18317,7 @@ ctrl_lock_status(struct drx_demod_instance *demod, enum drx_lock_status *lock_st
 #endif
 	case DRX_STANDARD_UNKNOWN:	/* fallthrough */
 	default:
-		return (DRX_STS_ERROR);
+		return DRX_STS_ERROR;
 	}
 
 	/* define the SCU command paramters and execute the command */
@@ -18347,9 +18347,9 @@ ctrl_lock_status(struct drx_demod_instance *demod, enum drx_lock_status *lock_st
 		*lock_stat = DRX_NEVER_LOCK;
 	}
 
-	return (DRX_STS_OK);
+	return DRX_STS_OK;
 rw_error:
-	return (DRX_STS_ERROR);
+	return DRX_STS_ERROR;
 }
 
 /*============================================================================*/
@@ -18371,7 +18371,7 @@ ctrl_constel(struct drx_demod_instance *demod, struct drx_complex *complex_nr)
 
 	/* check arguments */
 	if ((demod == NULL) || (complex_nr == NULL)) {
-		return (DRX_STS_INVALID_ARG);
+		return DRX_STS_INVALID_ARG;
 	}
 
 	/* read device info */
@@ -18399,12 +18399,12 @@ ctrl_constel(struct drx_demod_instance *demod, struct drx_complex *complex_nr)
 #endif
 	case DRX_STANDARD_UNKNOWN:
 	default:
-		return (DRX_STS_ERROR);
+		return DRX_STS_ERROR;
 	}
 
-	return (DRX_STS_OK);
+	return DRX_STS_OK;
 rw_error:
-	return (DRX_STS_ERROR);
+	return DRX_STS_ERROR;
 }
 
 /*============================================================================*/
@@ -18428,7 +18428,7 @@ ctrl_set_standard(struct drx_demod_instance *demod, enum drx_standard *standard)
 
 	/* check arguments */
 	if ((standard == NULL) || (demod == NULL)) {
-		return (DRX_STS_INVALID_ARG);
+		return DRX_STS_INVALID_ARG;
 	}
 
 	ext_attr = (struct drxj_data *) demod->my_ext_attr;
@@ -18476,7 +18476,7 @@ ctrl_set_standard(struct drx_demod_instance *demod, enum drx_standard *standard)
 		break;
 	case DRX_STANDARD_AUTO:	/* fallthrough */
 	default:
-		return (DRX_STS_INVALID_ARG);
+		return DRX_STS_INVALID_ARG;
 	}
 
 	/*
@@ -18529,15 +18529,15 @@ ctrl_set_standard(struct drx_demod_instance *demod, enum drx_standard *standard)
 #endif
 	default:
 		ext_attr->standard = DRX_STANDARD_UNKNOWN;
-		return (DRX_STS_INVALID_ARG);
+		return DRX_STS_INVALID_ARG;
 		break;
 	}
 
-	return (DRX_STS_OK);
+	return DRX_STS_OK;
 rw_error:
 	/* Don't know what the standard is now ... try again */
 	ext_attr->standard = DRX_STANDARD_UNKNOWN;
-	return (DRX_STS_ERROR);
+	return DRX_STS_ERROR;
 }
 
 /*============================================================================*/
@@ -18560,7 +18560,7 @@ ctrl_get_standard(struct drx_demod_instance *demod, enum drx_standard *standard)
 
 	/* check arguments */
 	if (standard == NULL) {
-		return (DRX_STS_INVALID_ARG);
+		return DRX_STS_INVALID_ARG;
 	}
 	(*standard) = ext_attr->standard;
 	do {
@@ -18572,9 +18572,9 @@ ctrl_get_standard(struct drx_demod_instance *demod, enum drx_standard *standard)
 		}
 	}while (0);
 
-	return (DRX_STS_OK);
+	return DRX_STS_OK;
 rw_error:
-	return (DRX_STS_ERROR);
+	return DRX_STS_ERROR;
 }
 
 /*============================================================================*/
@@ -18595,7 +18595,7 @@ ctrl_get_cfg_symbol_clock_offset(struct drx_demod_instance *demod, s32 *rate_off
 
 	/* check arguments */
 	if (rate_offset == NULL)
-		return (DRX_STS_INVALID_ARG);
+		return DRX_STS_INVALID_ARG;
 
 	ext_attr = (struct drxj_data *) demod->my_ext_attr;
 	standard = ext_attr->standard;
@@ -18616,12 +18616,12 @@ ctrl_get_cfg_symbol_clock_offset(struct drx_demod_instance *demod, s32 *rate_off
 	case DRX_STANDARD_NTSC:
 	case DRX_STANDARD_UNKNOWN:
 	default:
-		return (DRX_STS_INVALID_ARG);
+		return DRX_STS_INVALID_ARG;
 	}
 
-	return (DRX_STS_OK);
+	return DRX_STS_OK;
 rw_error:
-	return (DRX_STS_ERROR);
+	return DRX_STS_ERROR;
 }
 
 /*============================================================================*/
@@ -18653,12 +18653,12 @@ ctrl_power_mode(struct drx_demod_instance *demod, enum drx_power_mode *mode)
 
 	/* Check arguments */
 	if (mode == NULL) {
-		return (DRX_STS_INVALID_ARG);
+		return DRX_STS_INVALID_ARG;
 	}
 
 	/* If already in requested power mode, do nothing */
 	if (common_attr->current_power_mode == *mode) {
-		return (DRX_STS_OK);
+		return DRX_STS_OK;
 	}
 
 	switch (*mode) {
@@ -18677,7 +18677,7 @@ ctrl_power_mode(struct drx_demod_instance *demod, enum drx_power_mode *mode)
 		break;
 	default:
 		/* Unknow sleep mode */
-		return (DRX_STS_INVALID_ARG);
+		return DRX_STS_INVALID_ARG;
 		break;
 	}
 
@@ -18739,7 +18739,7 @@ ctrl_power_mode(struct drx_demod_instance *demod, enum drx_power_mode *mode)
 			break;
 		case DRX_STANDARD_AUTO:	/* fallthrough */
 		default:
-			return (DRX_STS_ERROR);
+			return DRX_STS_ERROR;
 		}
 
 		if (*mode != DRXJ_POWER_DOWN_MAIN_PATH) {
@@ -18772,9 +18772,9 @@ ctrl_power_mode(struct drx_demod_instance *demod, enum drx_power_mode *mode)
 
 	common_attr->current_power_mode = *mode;
 
-	return (DRX_STS_OK);
+	return DRX_STS_OK;
 rw_error:
-	return (DRX_STS_ERROR);
+	return DRX_STS_ERROR;
 }
 
 /*============================================================================*/
@@ -18957,11 +18957,11 @@ ctrl_version(struct drx_demod_instance *demod, struct drx_version_list **version
 
 	*version_list = &(ext_attr->v_list_elements[0]);
 
-	return (DRX_STS_OK);
+	return DRX_STS_OK;
 
 rw_error:
 	*version_list = (struct drx_version_list *) (NULL);
-	return (DRX_STS_ERROR);
+	return DRX_STS_ERROR;
 
 }
 
@@ -19066,11 +19066,11 @@ static int ctrl_probe_device(struct drx_demod_instance *demod)
 		}while (0);
 	}
 
-	return (ret_status);
+	return ret_status;
 
 rw_error:
 	common_attr->current_power_mode = org_power_mode;
-	return (DRX_STS_ERROR);
+	return DRX_STS_ERROR;
 }
 
 #ifdef DRXJ_SPLIT_UCODE_UPLOAD
@@ -19087,9 +19087,9 @@ rw_error:
 bool is_mc_block_audio(u32 addr)
 {
 	if ((addr == AUD_XFP_PRAM_4K__A) || (addr == AUD_XDFP_PRAM_4K__A)) {
-		return (true);
+		return true;
 	}
-	return (false);
+	return false;
 }
 
 /*============================================================================*/
@@ -19185,7 +19185,7 @@ ctrl_u_codeUpload(struct drx_demod_instance *demod,
 							   mc_data,
 							   0x0000) !=
 					    DRX_STS_OK) {
-						return (DRX_STS_ERROR);
+						return DRX_STS_ERROR;
 					}
 				};
 				break;
@@ -19226,7 +19226,7 @@ ctrl_u_codeUpload(struct drx_demod_instance *demod,
 								  mc_dataBuffer,
 								  0x0000) !=
 						    DRX_STS_OK) {
-							return (DRX_STS_ERROR);
+							return DRX_STS_ERROR;
 						}
 
 						result =
@@ -19235,7 +19235,7 @@ ctrl_u_codeUpload(struct drx_demod_instance *demod,
 								      bytes_to_compare);
 
 						if (result != 0) {
-							return (DRX_STS_ERROR);
+							return DRX_STS_ERROR;
 						};
 
 						curr_addr +=
@@ -19266,7 +19266,7 @@ ctrl_u_codeUpload(struct drx_demod_instance *demod,
 		ext_attr->flag_aud_mc_uploaded = false;
 	}
 
-	return (DRX_STS_OK);
+	return DRX_STS_OK;
 }
 #endif /* DRXJ_SPLIT_UCODE_UPLOAD */
 
@@ -19295,7 +19295,7 @@ ctrl_sig_strength(struct drx_demod_instance *demod, u16 *sig_strength)
 
 	/* Check arguments */
 	if ((sig_strength == NULL) || (demod == NULL)) {
-		return (DRX_STS_INVALID_ARG);
+		return DRX_STS_INVALID_ARG;
 	}
 
 	ext_attr = (struct drxj_data *) demod->my_ext_attr;
@@ -19333,14 +19333,14 @@ ctrl_sig_strength(struct drx_demod_instance *demod, u16 *sig_strength)
 #endif
 	case DRX_STANDARD_UNKNOWN:	/* fallthrough */
 	default:
-		return (DRX_STS_INVALID_ARG);
+		return DRX_STS_INVALID_ARG;
 	}
 
 	/* TODO */
 	/* find out if signal strength is calculated in the same way for all standards */
-	return (DRX_STS_OK);
+	return DRX_STS_OK;
 rw_error:
-	return (DRX_STS_ERROR);
+	return DRX_STS_ERROR;
 }
 
 /*============================================================================*/
@@ -19365,7 +19365,7 @@ ctrl_get_cfg_oob_misc(struct drx_demod_instance *demod, struct drxj_cfg_oob_misc
 
 	/* check arguments */
 	if (misc == NULL) {
-		return (DRX_STS_INVALID_ARG);
+		return DRX_STS_INVALID_ARG;
 	}
 	dev_addr = demod->my_i2c_dev_addr;
 
@@ -19412,9 +19412,9 @@ ctrl_get_cfg_oob_misc(struct drx_demod_instance *demod, struct drxj_cfg_oob_misc
 	}
 	misc->state = (state >> 8) & 0xff;
 
-	return (DRX_STS_OK);
+	return DRX_STS_OK;
 rw_error:
-	return (DRX_STS_ERROR);
+	return DRX_STS_ERROR;
 }
 #endif
 
@@ -19433,7 +19433,7 @@ ctrl_get_cfg_vsb_misc(struct drx_demod_instance *demod, struct drxj_cfg_vsb_misc
 
 	/* check arguments */
 	if (misc == NULL) {
-		return (DRX_STS_INVALID_ARG);
+		return DRX_STS_INVALID_ARG;
 	}
 	dev_addr = demod->my_i2c_dev_addr;
 
@@ -19443,9 +19443,9 @@ ctrl_get_cfg_vsb_misc(struct drx_demod_instance *demod, struct drxj_cfg_vsb_misc
 		goto rw_error;
 	}
 
-	return (DRX_STS_OK);
+	return DRX_STS_OK;
 rw_error:
-	return (DRX_STS_ERROR);
+	return DRX_STS_ERROR;
 }
 
 /*============================================================================*/
@@ -19466,7 +19466,7 @@ ctrl_set_cfg_agc_if(struct drx_demod_instance *demod, struct drxj_cfg_agc *agc_s
 {
 	/* check arguments */
 	if (agc_settings == NULL) {
-		return (DRX_STS_INVALID_ARG);
+		return DRX_STS_INVALID_ARG;
 	}
 
 	switch (agc_settings->ctrl_mode) {
@@ -19475,7 +19475,7 @@ ctrl_set_cfg_agc_if(struct drx_demod_instance *demod, struct drxj_cfg_agc *agc_s
 	case DRX_AGC_CTRL_OFF:	/* fallthrough */
 		break;
 	default:
-		return (DRX_STS_INVALID_ARG);
+		return DRX_STS_INVALID_ARG;
 	}
 
 	/* Distpatch */
@@ -19498,10 +19498,10 @@ ctrl_set_cfg_agc_if(struct drx_demod_instance *demod, struct drxj_cfg_agc *agc_s
 		return set_agc_if(demod, agc_settings, true);
 	case DRX_STANDARD_UNKNOWN:
 	default:
-		return (DRX_STS_INVALID_ARG);
+		return DRX_STS_INVALID_ARG;
 	}
 
-	return (DRX_STS_OK);
+	return DRX_STS_OK;
 }
 
 /*============================================================================*/
@@ -19522,7 +19522,7 @@ ctrl_get_cfg_agc_if(struct drx_demod_instance *demod, struct drxj_cfg_agc *agc_s
 {
 	/* check arguments */
 	if (agc_settings == NULL) {
-		return (DRX_STS_INVALID_ARG);
+		return DRX_STS_INVALID_ARG;
 	}
 
 	/* Distpatch */
@@ -19545,10 +19545,10 @@ ctrl_get_cfg_agc_if(struct drx_demod_instance *demod, struct drxj_cfg_agc *agc_s
 		return get_agc_if(demod, agc_settings);
 	case DRX_STANDARD_UNKNOWN:
 	default:
-		return (DRX_STS_INVALID_ARG);
+		return DRX_STS_INVALID_ARG;
 	}
 
-	return (DRX_STS_OK);
+	return DRX_STS_OK;
 }
 
 /*============================================================================*/
@@ -19569,7 +19569,7 @@ ctrl_set_cfg_agc_rf(struct drx_demod_instance *demod, struct drxj_cfg_agc *agc_s
 {
 	/* check arguments */
 	if (agc_settings == NULL) {
-		return (DRX_STS_INVALID_ARG);
+		return DRX_STS_INVALID_ARG;
 	}
 
 	switch (agc_settings->ctrl_mode) {
@@ -19578,7 +19578,7 @@ ctrl_set_cfg_agc_rf(struct drx_demod_instance *demod, struct drxj_cfg_agc *agc_s
 	case DRX_AGC_CTRL_OFF:
 		break;
 	default:
-		return (DRX_STS_INVALID_ARG);
+		return DRX_STS_INVALID_ARG;
 	}
 
 	/* Distpatch */
@@ -19601,10 +19601,10 @@ ctrl_set_cfg_agc_rf(struct drx_demod_instance *demod, struct drxj_cfg_agc *agc_s
 		return set_agc_rf(demod, agc_settings, true);
 	case DRX_STANDARD_UNKNOWN:
 	default:
-		return (DRX_STS_INVALID_ARG);
+		return DRX_STS_INVALID_ARG;
 	}
 
-	return (DRX_STS_OK);
+	return DRX_STS_OK;
 }
 
 /*============================================================================*/
@@ -19625,7 +19625,7 @@ ctrl_get_cfg_agc_rf(struct drx_demod_instance *demod, struct drxj_cfg_agc *agc_s
 {
 	/* check arguments */
 	if (agc_settings == NULL) {
-		return (DRX_STS_INVALID_ARG);
+		return DRX_STS_INVALID_ARG;
 	}
 
 	/* Distpatch */
@@ -19648,10 +19648,10 @@ ctrl_get_cfg_agc_rf(struct drx_demod_instance *demod, struct drxj_cfg_agc *agc_s
 		return get_agc_rf(demod, agc_settings);
 	case DRX_STANDARD_UNKNOWN:
 	default:
-		return (DRX_STS_INVALID_ARG);
+		return DRX_STS_INVALID_ARG;
 	}
 
-	return (DRX_STS_OK);
+	return DRX_STS_OK;
 }
 
 /*============================================================================*/
@@ -19681,7 +19681,7 @@ ctrl_get_cfg_agc_internal(struct drx_demod_instance *demod, u16 *agc_internal)
 
 	/* check arguments */
 	if (agc_internal == NULL) {
-		return (DRX_STS_INVALID_ARG);
+		return DRX_STS_INVALID_ARG;
 	}
 	dev_addr = demod->my_i2c_dev_addr;
 	ext_attr = (struct drxj_data *) demod->my_ext_attr;
@@ -19716,12 +19716,12 @@ ctrl_get_cfg_agc_internal(struct drx_demod_instance *demod, u16 *agc_internal)
 			iqm_cf_gain = 56;
 			break;
 		default:
-			return (DRX_STS_ERROR);
+			return DRX_STS_ERROR;
 		}
 		break;
 #endif
 	default:
-		return (DRX_STS_INVALID_ARG);
+		return DRX_STS_INVALID_ARG;
 	}
 
 	rc = DRXJ_DAP.read_reg16func(dev_addr, IQM_CF_POW__A, &iqm_cf_power, 0);
@@ -19749,9 +19749,9 @@ ctrl_get_cfg_agc_internal(struct drx_demod_instance *demod, u16 *agc_internal)
 				- 2 * log1_times100(iqm_cf_amp)
 				- iqm_cf_gain - 120 * iqm_cf_scale_sh + 781);
 
-	return (DRX_STS_OK);
+	return DRX_STS_OK;
 rw_error:
-	return (DRX_STS_ERROR);
+	return DRX_STS_ERROR;
 }
 
 /*============================================================================*/
@@ -19780,7 +19780,7 @@ ctrl_set_cfg_pre_saw(struct drx_demod_instance *demod, struct drxj_cfg_pre_saw *
 	/* check arguments */
 	if ((pre_saw == NULL) || (pre_saw->reference > IQM_AF_PDREF__M)
 	    ) {
-		return (DRX_STS_INVALID_ARG);
+		return DRX_STS_INVALID_ARG;
 	}
 
 	/* Only if standard is currently active */
@@ -19820,12 +19820,12 @@ ctrl_set_cfg_pre_saw(struct drx_demod_instance *demod, struct drxj_cfg_pre_saw *
 		break;
 #endif
 	default:
-		return (DRX_STS_INVALID_ARG);
+		return DRX_STS_INVALID_ARG;
 	}
 
-	return (DRX_STS_OK);
+	return DRX_STS_OK;
 rw_error:
-	return (DRX_STS_ERROR);
+	return DRX_STS_ERROR;
 }
 
 /*============================================================================*/
@@ -19851,7 +19851,7 @@ ctrl_set_cfg_afe_gain(struct drx_demod_instance *demod, struct drxj_cfg_afe_gain
 
 	/* check arguments */
 	if (afe_gain == NULL) {
-		return (DRX_STS_INVALID_ARG);
+		return DRX_STS_INVALID_ARG;
 	}
 
 	dev_addr = demod->my_i2c_dev_addr;
@@ -19867,7 +19867,7 @@ ctrl_set_cfg_afe_gain(struct drx_demod_instance *demod, struct drxj_cfg_afe_gain
 		/* Do nothing */
 		break;
 	default:
-		return (DRX_STS_INVALID_ARG);
+		return DRX_STS_INVALID_ARG;
 	}
 
 	/* TODO PGA gain is also written by microcode (at least by QAM and VSB)
@@ -19903,12 +19903,12 @@ ctrl_set_cfg_afe_gain(struct drx_demod_instance *demod, struct drxj_cfg_afe_gain
 		break;
 #endif
 	default:
-		return (DRX_STS_ERROR);
+		return DRX_STS_ERROR;
 	}
 
-	return (DRX_STS_OK);
+	return DRX_STS_OK;
 rw_error:
-	return (DRX_STS_ERROR);
+	return DRX_STS_ERROR;
 }
 
 /*============================================================================*/
@@ -19931,7 +19931,7 @@ ctrl_get_cfg_pre_saw(struct drx_demod_instance *demod, struct drxj_cfg_pre_saw *
 
 	/* check arguments */
 	if (pre_saw == NULL)
-		return (DRX_STS_INVALID_ARG);
+		return DRX_STS_INVALID_ARG;
 
 	ext_attr = (struct drxj_data *) demod->my_ext_attr;
 
@@ -19962,10 +19962,10 @@ ctrl_get_cfg_pre_saw(struct drx_demod_instance *demod, struct drxj_cfg_pre_saw *
 		break;
 #endif
 	default:
-		return (DRX_STS_INVALID_ARG);
+		return DRX_STS_INVALID_ARG;
 	}
 
-	return (DRX_STS_OK);
+	return DRX_STS_OK;
 }
 
 /*============================================================================*/
@@ -19988,7 +19988,7 @@ ctrl_get_cfg_afe_gain(struct drx_demod_instance *demod, struct drxj_cfg_afe_gain
 
 	/* check arguments */
 	if (afe_gain == NULL)
-		return (DRX_STS_INVALID_ARG);
+		return DRX_STS_INVALID_ARG;
 
 	ext_attr = demod->my_ext_attr;
 
@@ -20004,10 +20004,10 @@ ctrl_get_cfg_afe_gain(struct drx_demod_instance *demod, struct drxj_cfg_afe_gain
 		break;
 #endif
 	default:
-		return (DRX_STS_INVALID_ARG);
+		return DRX_STS_INVALID_ARG;
 	}
 
-	return (DRX_STS_OK);
+	return DRX_STS_OK;
 }
 
 /*============================================================================*/
@@ -20029,7 +20029,7 @@ ctrl_get_fec_meas_seq_count(struct drx_demod_instance *demod, u16 *fec_meas_seq_
 	int rc;
 	/* check arguments */
 	if (fec_meas_seq_count == NULL) {
-		return (DRX_STS_INVALID_ARG);
+		return DRX_STS_INVALID_ARG;
 	}
 
 	rc = DRXJ_DAP.read_reg16func(demod->my_i2c_dev_addr, SCU_RAM_FEC_MEAS_COUNT__A, fec_meas_seq_count, 0);
@@ -20038,9 +20038,9 @@ ctrl_get_fec_meas_seq_count(struct drx_demod_instance *demod, u16 *fec_meas_seq_
 		goto rw_error;
 	}
 
-	return (DRX_STS_OK);
+	return DRX_STS_OK;
 rw_error:
-	return (DRX_STS_ERROR);
+	return DRX_STS_ERROR;
 }
 
 /*============================================================================*/
@@ -20061,7 +20061,7 @@ ctrl_get_accum_cr_rs_cw_err(struct drx_demod_instance *demod, u32 *accum_cr_rs_c
 {
 	int rc;
 	if (accum_cr_rs_cw_err == NULL) {
-		return (DRX_STS_INVALID_ARG);
+		return DRX_STS_INVALID_ARG;
 	}
 
 	rc = DRXJ_DAP.read_reg32func(demod->my_i2c_dev_addr, SCU_RAM_FEC_ACCUM_CW_CORRECTED_LO__A, accum_cr_rs_cw_err, 0);
@@ -20070,9 +20070,9 @@ ctrl_get_accum_cr_rs_cw_err(struct drx_demod_instance *demod, u32 *accum_cr_rs_c
 		goto rw_error;
 	}
 
-	return (DRX_STS_OK);
+	return DRX_STS_OK;
 rw_error:
-	return (DRX_STS_ERROR);
+	return DRX_STS_ERROR;
 }
 
 /**
@@ -20088,7 +20088,7 @@ static int ctrl_set_cfg(struct drx_demod_instance *demod, struct drx_cfg *config
 	int rc;
 
 	if (config == NULL)
-		return (DRX_STS_INVALID_ARG);
+		return DRX_STS_INVALID_ARG;
 
 	do {
 		u16 dummy;
@@ -20181,12 +20181,12 @@ static int ctrl_set_cfg(struct drx_demod_instance *demod, struct drx_cfg *config
 
 #endif
 	default:
-		return (DRX_STS_INVALID_ARG);
+		return DRX_STS_INVALID_ARG;
 	}
 
-	return (DRX_STS_OK);
+	return DRX_STS_OK;
 rw_error:
-	return (DRX_STS_ERROR);
+	return DRX_STS_ERROR;
 }
 
 /*============================================================================*/
@@ -20204,7 +20204,7 @@ static int ctrl_get_cfg(struct drx_demod_instance *demod, struct drx_cfg *config
 	int rc;
 
 	if (config == NULL)
-		return (DRX_STS_INVALID_ARG);
+		return DRX_STS_INVALID_ARG;
 
 	do {
 		u16 dummy;
@@ -20320,12 +20320,12 @@ static int ctrl_get_cfg(struct drx_demod_instance *demod, struct drx_cfg *config
 #endif
 
 	default:
-		return (DRX_STS_INVALID_ARG);
+		return DRX_STS_INVALID_ARG;
 	}
 
-	return (DRX_STS_OK);
+	return DRX_STS_OK;
 rw_error:
-	return (DRX_STS_ERROR);
+	return DRX_STS_ERROR;
 }
 
 /*=============================================================================
@@ -20352,7 +20352,7 @@ int drxj_open(struct drx_demod_instance *demod)
 
 	/* Check arguments */
 	if (demod->my_ext_attr == NULL)
-		return (DRX_STS_INVALID_ARG);
+		return DRX_STS_INVALID_ARG;
 
 	dev_addr = demod->my_i2c_dev_addr;
 	ext_attr = (struct drxj_data *) demod->my_ext_attr;
@@ -20630,10 +20630,10 @@ int drxj_open(struct drx_demod_instance *demod)
 	/* refresh the audio data structure with default */
 	ext_attr->aud_data = drxj_default_aud_data_g;
 
-	return (DRX_STS_OK);
+	return DRX_STS_OK;
 rw_error:
 	common_attr->is_opened = false;
-	return (DRX_STS_ERROR);
+	return DRX_STS_ERROR;
 }
 
 /*============================================================================*/
@@ -20696,7 +20696,7 @@ int drxj_close(struct drx_demod_instance *demod)
 
 	return DRX_STS_OK;
 rw_error:
-	return (DRX_STS_ERROR);
+	return DRX_STS_ERROR;
 }
 
 /*============================================================================*/
@@ -20712,13 +20712,13 @@ drxj_ctrl(struct drx_demod_instance *demod, u32 ctrl, void *ctrl_data)
       /*======================================================================*/
 	case DRX_CTRL_SET_CHANNEL:
 		{
-			return ctrl_set_channel(demod, (struct drx_channel *) ctrl_data);
+			return ctrl_set_channel(demod, (struct drx_channel *)ctrl_data);
 		}
 		break;
       /*======================================================================*/
 	case DRX_CTRL_GET_CHANNEL:
 		{
-			return ctrl_get_channel(demod, (struct drx_channel *) ctrl_data);
+			return ctrl_get_channel(demod, (struct drx_channel *)ctrl_data);
 		}
 		break;
       /*======================================================================*/
@@ -20737,19 +20737,19 @@ drxj_ctrl(struct drx_demod_instance *demod, u32 ctrl, void *ctrl_data)
       /*======================================================================*/
 	case DRX_CTRL_CONSTEL:
 		{
-			return ctrl_constel(demod, (struct drx_complex *) ctrl_data);
+			return ctrl_constel(demod, (struct drx_complex *)ctrl_data);
 		}
 		break;
       /*======================================================================*/
 	case DRX_CTRL_SET_CFG:
 		{
-			return ctrl_set_cfg(demod, (struct drx_cfg *) ctrl_data);
+			return ctrl_set_cfg(demod, (struct drx_cfg *)ctrl_data);
 		}
 		break;
       /*======================================================================*/
 	case DRX_CTRL_GET_CFG:
 		{
-			return ctrl_get_cfg(demod, (struct drx_cfg *) ctrl_data);
+			return ctrl_get_cfg(demod, (struct drx_cfg *)ctrl_data);
 		}
 		break;
       /*======================================================================*/
@@ -20782,7 +20782,7 @@ drxj_ctrl(struct drx_demod_instance *demod, u32 ctrl, void *ctrl_data)
       /*======================================================================*/
 	case DRX_CTRL_POWER_MODE:
 		{
-			return ctrl_power_mode(demod, (enum drx_power_mode *) ctrl_data);
+			return ctrl_power_mode(demod, (enum drx_power_mode *)ctrl_data);
 		}
 		break;
       /*======================================================================*/
@@ -20801,37 +20801,37 @@ drxj_ctrl(struct drx_demod_instance *demod, u32 ctrl, void *ctrl_data)
       /*======================================================================*/
 	case DRX_CTRL_SET_OOB:
 		{
-			return ctrl_set_oob(demod, (struct drxoob *) ctrl_data);
+			return ctrl_set_oob(demod, (struct drxoob *)ctrl_data);
 		}
 		break;
       /*======================================================================*/
 	case DRX_CTRL_GET_OOB:
 		{
-			return ctrl_get_oob(demod, (struct drxoob_status *) ctrl_data);
+			return ctrl_get_oob(demod, (struct drxoob_status *)ctrl_data);
 		}
 		break;
       /*======================================================================*/
 	case DRX_CTRL_SET_UIO_CFG:
 		{
-			return ctrl_set_uio_cfg(demod, (struct drxuio_cfg *) ctrl_data);
+			return ctrl_set_uio_cfg(demod, (struct drxuio_cfg *)ctrl_data);
 		}
 		break;
       /*======================================================================*/
 	case DRX_CTRL_GET_UIO_CFG:
 		{
-			return CtrlGetuio_cfg(demod, (struct drxuio_cfg *) ctrl_data);
+			return CtrlGetuio_cfg(demod, (struct drxuio_cfg *)ctrl_data);
 		}
 		break;
       /*======================================================================*/
 	case DRX_CTRL_UIO_READ:
 		{
-			return ctrl_uio_read(demod, (struct drxuio_data *) ctrl_data);
+			return ctrl_uio_read(demod, (struct drxuio_data *)ctrl_data);
 		}
 		break;
       /*======================================================================*/
 	case DRX_CTRL_UIO_WRITE:
 		{
-			return ctrl_uio_write(demod, (struct drxuio_data *) ctrl_data);
+			return ctrl_uio_write(demod, (struct drxuio_data *)ctrl_data);
 		}
 		break;
       /*======================================================================*/
@@ -20858,7 +20858,7 @@ drxj_ctrl(struct drx_demod_instance *demod, u32 ctrl, void *ctrl_data)
       /*======================================================================*/
 	case DRX_CTRL_AUD_BEEP:
 		{
-			return aud_ctrl_beep(demod, (struct drx_aud_beep *) ctrl_data);
+			return aud_ctrl_beep(demod, (struct drx_aud_beep *)ctrl_data);
 		}
 		break;
 
@@ -20891,7 +20891,7 @@ drxj_ctrl(struct drx_demod_instance *demod, u32 ctrl, void *ctrl_data)
 		}
 		break;
 	default:
-		return (DRX_STS_FUNC_NOT_AVAILABLE);
+		return DRX_STS_FUNC_NOT_AVAILABLE;
 	}
-	return (DRX_STS_OK);
+	return DRX_STS_OK;
 }
-- 
1.8.5.3

