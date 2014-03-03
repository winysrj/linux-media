Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49482 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754230AbaCCKIK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Mar 2014 05:08:10 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 27/79] [media] drx-j: Simplify logic expressions
Date: Mon,  3 Mar 2014 07:06:21 -0300
Message-Id: <1393841233-24840-28-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1393841233-24840-1-git-send-email-m.chehab@samsung.com>
References: <1393841233-24840-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Don't need to test boolean x == true or x == false.

That makes the code more compact.

patch generated with make coccicheck and manually reviewed.

While here, remove uneeded ';'.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/dvb-frontends/drx39xyj/drx_driver.c |  22 ++---
 drivers/media/dvb-frontends/drx39xyj/drxj.c       | 106 +++++++++++-----------
 2 files changed, 64 insertions(+), 64 deletions(-)

diff --git a/drivers/media/dvb-frontends/drx39xyj/drx_driver.c b/drivers/media/dvb-frontends/drx39xyj/drx_driver.c
index 2c88e47c701d..5974b7c12cbd 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drx_driver.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drx_driver.c
@@ -227,7 +227,7 @@ static int scan_wait_for_lock(struct drx_demod_instance *demod, bool *is_locked)
 	start_time_lock_stage = drxbsp_hst_clock();
 
 	/* Start polling loop, checking for lock & timeout */
-	while (done_waiting == false) {
+	while (!done_waiting) {
 
 		if (drx_ctrl(demod, DRX_CTRL_LOCK_STATUS, &lock_state) !=
 		    DRX_STS_OK) {
@@ -326,7 +326,7 @@ scan_prepare_next_scan(struct drx_demod_instance *demod, s32 skip)
 			common_attr->scan_ready = true;
 		}
 	} while ((next_frequency < tuner_min_frequency) &&
-		 (common_attr->scan_ready == false));
+		 (!common_attr->scan_ready));
 
 	/* Store new values */
 	common_attr->scan_freq_plan_index = table_index;
@@ -384,7 +384,7 @@ scan_function_default(void *scan_context,
 	/* done with this channel, move to next one */
 	*get_next_channel = true;
 
-	if (is_locked == false) {
+	if (!is_locked) {
 		/* no channel found */
 		return DRX_STS_BUSY;
 	}
@@ -634,7 +634,7 @@ static int ctrl_scan_next(struct drx_demod_instance *demod, u16 *scan_progress)
 	num_tries = common_attr->scan_param->num_tries;
 	scan_ready = &(common_attr->scan_ready);
 
-	for (i = 0; ((i < num_tries) && ((*scan_ready) == false)); i++) {
+	for (i = 0; ((i < num_tries) && (!(*scan_ready))); i++) {
 		struct drx_channel scan_channel = { 0 };
 		int status = DRX_STS_ERROR;
 		struct drx_frequency_plan *freq_plan = (struct drx_frequency_plan *) (NULL);
@@ -670,7 +670,7 @@ static int ctrl_scan_next(struct drx_demod_instance *demod, u16 *scan_progress)
 		     &next_channel);
 
 		/* Proceed to next channel if requested */
-		if (next_channel == true) {
+		if (next_channel) {
 			int next_status = DRX_STS_ERROR;
 			s32 skip = 0;
 
@@ -698,7 +698,7 @@ static int ctrl_scan_next(struct drx_demod_instance *demod, u16 *scan_progress)
 		}
 	}			/* for ( i = 0; i < ( ... num_tries); i++) */
 
-	if ((*scan_ready) == true) {
+	if ((*scan_ready)) {
 		/* End of scan reached: call stop-scan, ignore any error */
 		ctrl_scan_stop(demod);
 		common_attr->scan_active = false;
@@ -1112,7 +1112,7 @@ ctrl_u_code(struct drx_demod_instance *demod,
 					    DRX_STS_OK) {
 						return DRX_STS_ERROR;
 					}	/* if */
-				};
+				}
 				break;
 
 	    /*================================================================*/
@@ -1171,7 +1171,7 @@ ctrl_u_code(struct drx_demod_instance *demod,
 						bytes_left_to_compare -=
 						    ((u32) bytes_to_compare);
 					}	/* while( bytes_to_compare > DRX_UCODE_MAX_BUF_SIZE ) */
-				};
+				}
 				break;
 
 	    /*================================================================*/
@@ -1314,7 +1314,7 @@ int drx_open(struct drx_demod_instance *demod)
 	    (demod->my_common_attr == NULL) ||
 	    (demod->my_ext_attr == NULL) ||
 	    (demod->my_i2c_dev_addr == NULL) ||
-	    (demod->my_common_attr->is_opened == true)) {
+	    (demod->my_common_attr->is_opened)) {
 		return DRX_STS_INVALID_ARG;
 	}
 
@@ -1351,7 +1351,7 @@ int drx_close(struct drx_demod_instance *demod)
 	    (demod->my_common_attr == NULL) ||
 	    (demod->my_ext_attr == NULL) ||
 	    (demod->my_i2c_dev_addr == NULL) ||
-	    (demod->my_common_attr->is_opened == false)) {
+	    (!demod->my_common_attr->is_opened)) {
 		return DRX_STS_INVALID_ARG;
 	}
 
@@ -1395,7 +1395,7 @@ drx_ctrl(struct drx_demod_instance *demod, u32 ctrl, void *ctrl_data)
 		return DRX_STS_INVALID_ARG;
 	}
 
-	if (((demod->my_common_attr->is_opened == false) &&
+	if (((!demod->my_common_attr->is_opened) &&
 	     (ctrl != DRX_CTRL_PROBE_DEVICE) && (ctrl != DRX_CTRL_VERSION))
 	    ) {
 		return DRX_STS_INVALID_ARG;
diff --git a/drivers/media/dvb-frontends/drx39xyj/drxj.c b/drivers/media/dvb-frontends/drx39xyj/drxj.c
index 4e2059549dc1..6e7ce7501e70 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drxj.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drxj.c
@@ -1819,14 +1819,14 @@ static int drxj_dap_read_aud_reg16(struct i2c_device_addr *dev_addr,
 
 			if (stat != DRX_STS_OK) {
 				break;
-			};
+			}
 
 			current_timer = drxbsp_hst_clock();
 			delta_timer = current_timer - start_timer;
 			if (delta_timer > DRXJ_DAP_AUDTRIF_TIMEOUT) {
 				stat = DRX_STS_ERROR;
 				break;
-			};
+			}
 
 		} while (((tr_status & AUD_TOP_TR_CTR_FIFO_LOCK__M) ==
 			  AUD_TOP_TR_CTR_FIFO_LOCK_LOCKED) ||
@@ -1845,14 +1845,14 @@ static int drxj_dap_read_aud_reg16(struct i2c_device_addr *dev_addr,
 						  &tr_status, 0x0000);
 			if (stat != DRX_STS_OK) {
 				break;
-			};
+			}
 
 			current_timer = drxbsp_hst_clock();
 			delta_timer = current_timer - start_timer;
 			if (delta_timer > DRXJ_DAP_AUDTRIF_TIMEOUT) {
 				stat = DRX_STS_ERROR;
 				break;
-			};
+			}
 		}		/* while ( ... ) */
 	}
 
@@ -1961,14 +1961,14 @@ static int drxj_dap_write_aud_reg16(struct i2c_device_addr *dev_addr,
 							     data, &tr_status);
 			if (stat != DRX_STS_OK) {
 				break;
-			};
+			}
 
 			current_timer = drxbsp_hst_clock();
 			delta_timer = current_timer - start_timer;
 			if (delta_timer > DRXJ_DAP_AUDTRIF_TIMEOUT) {
 				stat = DRX_STS_ERROR;
 				break;
-			};
+			}
 
 		} while (((tr_status & AUD_TOP_TR_CTR_FIFO_LOCK__M) ==
 			  AUD_TOP_TR_CTR_FIFO_LOCK_LOCKED) ||
@@ -2062,7 +2062,7 @@ int drxj_dap_atomic_read_write_block(struct i2c_device_addr *dev_addr,
 	hi_cmd.param2 =
 	    (u16) DRXDAP_FASI_ADDR2OFFSET(DRXJ_HI_ATOMIC_BUF_START);
 	hi_cmd.param3 = (u16) ((datasize / 2) - 1);
-	if (read_flag == false) {
+	if (!read_flag) {
 		hi_cmd.param3 |= DRXJ_HI_ATOMIC_WRITE;
 	} else {
 		hi_cmd.param3 |= DRXJ_HI_ATOMIC_READ;
@@ -2071,7 +2071,7 @@ int drxj_dap_atomic_read_write_block(struct i2c_device_addr *dev_addr,
 				DRXDAP_FASI_ADDR2BANK(addr));
 	hi_cmd.param5 = (u16) DRXDAP_FASI_ADDR2OFFSET(addr);
 
-	if (read_flag == false) {
+	if (!read_flag) {
 		/* write data to buffer */
 		for (i = 0; i < (datasize / 2); i++) {
 
@@ -2089,7 +2089,7 @@ int drxj_dap_atomic_read_write_block(struct i2c_device_addr *dev_addr,
 		goto rw_error;
 	}
 
-	if (read_flag == true) {
+	if (read_flag) {
 		/* read data from buffer */
 		for (i = 0; i < (datasize / 2); i++) {
 			drxj_dap_read_reg16(dev_addr,
@@ -2283,13 +2283,13 @@ hi_command(struct i2c_device_addr *dev_addr, const pdrxj_hi_cmd_t cmd, u16 *resu
 				  (((cmd->
 				     param5) & SIO_HI_RA_RAM_PAR_5_CFG_SLEEP__M)
 				   == SIO_HI_RA_RAM_PAR_5_CFG_SLEEP_ZZZ));
-	if (powerdown_cmd == false) {
+	if (!powerdown_cmd) {
 		/* Wait until command rdy */
 		do {
 			nr_retries++;
 			if (nr_retries > DRXJ_MAX_RETRIES) {
 				goto rw_error;
-			};
+			}
 
 			rc = DRXJ_DAP.read_reg16func(dev_addr, SIO_HI_RA_RAM_CMD__A, &wait_cmd, 0);
 			if (rc != DRX_STS_OK) {
@@ -3436,7 +3436,7 @@ static int set_mpegtei_handling(struct drx_demod_instance *demod)
 			   FEC_OC_SNC_MODE_CORR_DISABLE__M));
 	fec_oc_ems_mode &= (~FEC_OC_EMS_MODE_MODE__M);
 
-	if (ext_attr->disable_te_ihandling == true) {
+	if (ext_attr->disable_te_ihandling) {
 		/* do not change TEI bit */
 		fec_oc_dpr_mode |= FEC_OC_DPR_MODE_ERR_DISABLE__M;
 		fec_oc_snc_mode |= FEC_OC_SNC_MODE_CORR_DISABLE__M |
@@ -3494,7 +3494,7 @@ static int bit_reverse_mpeg_output(struct drx_demod_instance *demod)
 	/* reset to default (normal bit order) */
 	fec_oc_ipr_mode &= (~FEC_OC_IPR_MODE_REVERSE_ORDER__M);
 
-	if (ext_attr->bit_reverse_mpeg_outout == true) {
+	if (ext_attr->bit_reverse_mpeg_outout) {
 		/* reverse bit order */
 		fec_oc_ipr_mode |= FEC_OC_IPR_MODE_REVERSE_ORDER__M;
 	}
@@ -3780,7 +3780,7 @@ static int ctrl_set_uio_cfg(struct drx_demod_instance *demod, struct drxuio_cfg
       /*====================================================================*/
 	case DRX_UIO1:
 		/* DRX_UIO1: SMA_TX UIO-1 */
-		if (ext_attr->has_smatx != true)
+		if (!ext_attr->has_smatx)
 			return DRX_STS_ERROR;
 		switch (uio_cfg->mode) {
 		case DRX_UIO_MODE_FIRMWARE_SMA:	/* falltrough */
@@ -3804,7 +3804,7 @@ static int ctrl_set_uio_cfg(struct drx_demod_instance *demod, struct drxuio_cfg
       /*====================================================================*/
 	case DRX_UIO2:
 		/* DRX_UIO2: SMA_RX UIO-2 */
-		if (ext_attr->has_smarx != true)
+		if (!ext_attr->has_smarx)
 			return DRX_STS_ERROR;
 		switch (uio_cfg->mode) {
 		case DRX_UIO_MODE_FIRMWARE0:	/* falltrough */
@@ -3828,7 +3828,7 @@ static int ctrl_set_uio_cfg(struct drx_demod_instance *demod, struct drxuio_cfg
       /*====================================================================*/
 	case DRX_UIO3:
 		/* DRX_UIO3: GPIO UIO-3 */
-		if (ext_attr->has_gpio != true)
+		if (!ext_attr->has_gpio)
 			return DRX_STS_ERROR;
 		switch (uio_cfg->mode) {
 		case DRX_UIO_MODE_FIRMWARE0:	/* falltrough */
@@ -3852,7 +3852,7 @@ static int ctrl_set_uio_cfg(struct drx_demod_instance *demod, struct drxuio_cfg
       /*====================================================================*/
 	case DRX_UIO4:
 		/* DRX_UIO4: IRQN UIO-4 */
-		if (ext_attr->has_irqn != true)
+		if (!ext_attr->has_irqn)
 			return DRX_STS_ERROR;
 		switch (uio_cfg->mode) {
 		case DRX_UIO_MODE_READWRITE:
@@ -3925,7 +3925,7 @@ static int CtrlGetuio_cfg(struct drx_demod_instance *demod, struct drxuio_cfg *u
 		return DRX_STS_INVALID_ARG;
 	}
 
-	if (*uio_available[uio_cfg->uio] == false) {
+	if (!*uio_available[uio_cfg->uio]) {
 		return DRX_STS_ERROR;
 	}
 
@@ -3965,7 +3965,7 @@ ctrl_uio_write(struct drx_demod_instance *demod, struct drxuio_data *uio_data)
       /*====================================================================*/
 	case DRX_UIO1:
 		/* DRX_UIO1: SMA_TX UIO-1 */
-		if (ext_attr->has_smatx != true)
+		if (!ext_attr->has_smatx)
 			return DRX_STS_ERROR;
 		if ((ext_attr->uio_sma_tx_mode != DRX_UIO_MODE_READWRITE)
 		    && (ext_attr->uio_sma_tx_mode != DRX_UIO_MODE_FIRMWARE_SAW)) {
@@ -4005,7 +4005,7 @@ ctrl_uio_write(struct drx_demod_instance *demod, struct drxuio_data *uio_data)
    /*======================================================================*/
 	case DRX_UIO2:
 		/* DRX_UIO2: SMA_RX UIO-2 */
-		if (ext_attr->has_smarx != true)
+		if (!ext_attr->has_smarx)
 			return DRX_STS_ERROR;
 		if (ext_attr->uio_sma_rx_mode != DRX_UIO_MODE_READWRITE) {
 			return DRX_STS_ERROR;
@@ -4044,7 +4044,7 @@ ctrl_uio_write(struct drx_demod_instance *demod, struct drxuio_data *uio_data)
    /*====================================================================*/
 	case DRX_UIO3:
 		/* DRX_UIO3: ASEL UIO-3 */
-		if (ext_attr->has_gpio != true)
+		if (!ext_attr->has_gpio)
 			return DRX_STS_ERROR;
 		if (ext_attr->uio_gpio_mode != DRX_UIO_MODE_READWRITE) {
 			return DRX_STS_ERROR;
@@ -4083,7 +4083,7 @@ ctrl_uio_write(struct drx_demod_instance *demod, struct drxuio_data *uio_data)
    /*=====================================================================*/
 	case DRX_UIO4:
 		/* DRX_UIO4: IRQN UIO-4 */
-		if (ext_attr->has_irqn != true)
+		if (!ext_attr->has_irqn)
 			return DRX_STS_ERROR;
 
 		if (ext_attr->uio_irqn_mode != DRX_UIO_MODE_READWRITE) {
@@ -4167,7 +4167,7 @@ static int ctrl_uio_read(struct drx_demod_instance *demod, struct drxuio_data *u
       /*====================================================================*/
 	case DRX_UIO1:
 		/* DRX_UIO1: SMA_TX UIO-1 */
-		if (ext_attr->has_smatx != true)
+		if (!ext_attr->has_smatx)
 			return DRX_STS_ERROR;
 
 		if (ext_attr->uio_sma_tx_mode != DRX_UIO_MODE_READWRITE) {
@@ -4200,7 +4200,7 @@ static int ctrl_uio_read(struct drx_demod_instance *demod, struct drxuio_data *u
    /*======================================================================*/
 	case DRX_UIO2:
 		/* DRX_UIO2: SMA_RX UIO-2 */
-		if (ext_attr->has_smarx != true)
+		if (!ext_attr->has_smarx)
 			return DRX_STS_ERROR;
 
 		if (ext_attr->uio_sma_rx_mode != DRX_UIO_MODE_READWRITE) {
@@ -4234,7 +4234,7 @@ static int ctrl_uio_read(struct drx_demod_instance *demod, struct drxuio_data *u
    /*=====================================================================*/
 	case DRX_UIO3:
 		/* DRX_UIO3: GPIO UIO-3 */
-		if (ext_attr->has_gpio != true)
+		if (!ext_attr->has_gpio)
 			return DRX_STS_ERROR;
 
 		if (ext_attr->uio_gpio_mode != DRX_UIO_MODE_READWRITE) {
@@ -4268,7 +4268,7 @@ static int ctrl_uio_read(struct drx_demod_instance *demod, struct drxuio_data *u
    /*=====================================================================*/
 	case DRX_UIO4:
 		/* DRX_UIO4: IRQN UIO-4 */
-		if (ext_attr->has_irqn != true)
+		if (!ext_attr->has_irqn)
 			return DRX_STS_ERROR;
 
 		if (ext_attr->uio_irqn_mode != DRX_UIO_MODE_READWRITE) {
@@ -4344,7 +4344,7 @@ ctrl_i2c_bridge(struct drx_demod_instance *demod, bool *bridge_closed)
 
 	hi_cmd.cmd = SIO_HI_RA_RAM_CMD_BRDCTRL;
 	hi_cmd.param1 = SIO_HI_RA_RAM_PAR_1_PAR1_SEC_KEY;
-	if (*bridge_closed == true) {
+	if (*bridge_closed) {
 		hi_cmd.param2 = SIO_HI_RA_RAM_PAR_2_BRD_CFG_CLOSED;
 	} else {
 		hi_cmd.param2 = SIO_HI_RA_RAM_PAR_2_BRD_CFG_OPEN;
@@ -4749,7 +4749,7 @@ int drxj_dap_scu_atomic_read_write_block(struct i2c_device_addr *dev_addr, u32 a
 		goto rw_error;
 	}
 
-	if (read_flag == true) {
+	if (read_flag) {
 		int i = 0;
 		/* read data from buffer */
 		for (i = 0; i < (datasize / 2); i++) {
@@ -5023,7 +5023,7 @@ ctrl_set_cfg_pdr_safe_mode(struct drx_demod_instance *demod, bool *enable)
 		goto rw_error;
 	}
 
-	if (*enable == true) {
+	if (*enable) {
 		bool bridge_enabled = false;
 
 		/* MPEG pins to input */
@@ -5824,7 +5824,7 @@ set_frequency(struct drx_demod_instance *demod,
 	}
 	intermediate_freq = demod->my_common_attr->intermediate_freq;
 	sampling_frequency = demod->my_common_attr->sys_clock_freq / 3;
-	if (tuner_mirror == true) {
+	if (tuner_mirror) {
 		/* tuner doesn't mirror */
 		if_freq_actual =
 		    intermediate_freq + rf_freq_residual + fm_frequency_shift;
@@ -5971,7 +5971,7 @@ static int get_acc_pkt_err(struct drx_demod_instance *demod, u16 *packet_err)
 		pr_err("error %d\n", rc);
 		goto rw_error;
 	}
-	if (ext_attr->reset_pkt_err_acc == true) {
+	if (ext_attr->reset_pkt_err_acc) {
 		last_pkt_err = data;
 		pkt_err = 0;
 		ext_attr->reset_pkt_err_acc = false;
@@ -6093,7 +6093,7 @@ static int get_ctl_freq_offset(struct drx_demod_instance *demod, s32 *ctl_freq)
 		goto rw_error;
 	}
 
-	if (ext_attr->pos_image == true) {
+	if (ext_attr->pos_image) {
 		/* negative image */
 		carrier_frequency_shift = nominal_frequency - current_frequency;
 	} else {
@@ -6825,7 +6825,7 @@ static int power_down_vsb(struct drx_demod_instance *demod, bool primary)
 		pr_err("error %d\n", rc);
 		goto rw_error;
 	}
-	if (primary == true) {
+	if (primary) {
 		rc = DRXJ_DAP.write_reg16func(dev_addr, IQM_COMM_EXEC__A, IQM_COMM_EXEC_STOP, 0);
 		if (rc != DRX_STS_OK) {
 			pr_err("error %d\n", rc);
@@ -7425,13 +7425,13 @@ static int set_vsb(struct drx_demod_instance *demod)
 		goto rw_error;
 	}
 	/* B-Input to ADC, PGA+filter in standby */
-	if (ext_attr->has_lna == false) {
+	if (!ext_attr->has_lna) {
 		rc = DRXJ_DAP.write_reg16func(dev_addr, IQM_AF_AMUX__A, 0x02, 0);
 		if (rc != DRX_STS_OK) {
 			pr_err("error %d\n", rc);
 			goto rw_error;
 		}
-	};
+	}
 
 	/* turn on IQMAF. It has to be in front of setAgc**() */
 	rc = set_iqm_af(demod, true);
@@ -7915,7 +7915,7 @@ static int power_down_qam(struct drx_demod_instance *demod, bool primary)
 		goto rw_error;
 	}
 
-	if (primary == true) {
+	if (primary) {
 		rc = DRXJ_DAP.write_reg16func(dev_addr, IQM_COMM_EXEC__A, IQM_COMM_EXEC_STOP, 0);
 		if (rc != DRX_STS_OK) {
 			pr_err("error %d\n", rc);
@@ -9694,7 +9694,7 @@ set_qam(struct drx_demod_instance *demod,
 	}
 
 	if (op & QAM_SET_OP_ALL) {
-		if (ext_attr->has_lna == false) {
+		if (!ext_attr->has_lna) {
 			rc = DRXJ_DAP.write_reg16func(dev_addr, IQM_AF_AMUX__A, 0x02, 0);
 			if (rc != DRX_STS_OK) {
 				pr_err("error %d\n", rc);
@@ -11965,7 +11965,7 @@ power_down_atv(struct drx_demod_instance *demod, enum drx_standard standard, boo
 		pr_err("error %d\n", rc);
 		goto rw_error;
 	}
-	if (primary == true) {
+	if (primary) {
 		rc = DRXJ_DAP.write_reg16func(dev_addr, IQM_COMM_EXEC__A, IQM_COMM_EXEC_STOP, 0);
 		if (rc != DRX_STS_OK) {
 			pr_err("error %d\n", rc);
@@ -12885,7 +12885,7 @@ trouble ?
 	}
 
 	/* Common initializations FM & NTSC & B/G & D/K & I & L & LP */
-	if (ext_attr->has_lna == false) {
+	if (!ext_attr->has_lna) {
 		rc = DRXJ_DAP.write_reg16func(dev_addr, IQM_AF_AMUX__A, 0x01, 0);
 		if (rc != DRX_STS_OK) {
 		pr_err("error %d\n", rc);
@@ -13521,7 +13521,7 @@ static int power_up_aud(struct drx_demod_instance *demod, bool set_standard)
 		goto rw_error;
 	}
 
-	if (set_standard == true) {
+	if (set_standard) {
 		rc = aud_ctrl_set_standard(demod, &aud_standard);
 		if (rc != DRX_STS_OK) {
 			pr_err("error %d\n", rc);
@@ -16797,12 +16797,12 @@ static int ctrl_set_oob(struct drx_demod_instance *demod, struct drxoob *oob_par
 			   /* signal is transmitted inverted */
 			   ((oob_param->spectrum_inverted == true) &
 			    /* and tuner is not mirroring the signal */
-			    (mirror_freq_spectOOB == false)) |
+			    (!mirror_freq_spectOOB)) |
 			   /* or */
 			   /* signal is transmitted noninverted */
 			   ((oob_param->spectrum_inverted == false) &
 			    /* and tuner is mirroring the signal */
-			    (mirror_freq_spectOOB == true))
+			    (mirror_freq_spectOOB))
 		    )
 			set_param_parameters[0] =
 			    SCU_RAM_ORX_RF_RX_DATA_RATE_2048KBPS_INVSPEC;
@@ -16815,12 +16815,12 @@ static int ctrl_set_oob(struct drx_demod_instance *demod, struct drxoob *oob_par
 			   /* signal is transmitted inverted */
 			   ((oob_param->spectrum_inverted == true) &
 			    /* and tuner is not mirroring the signal */
-			    (mirror_freq_spectOOB == false)) |
+			    (!mirror_freq_spectOOB)) |
 			   /* or */
 			   /* signal is transmitted noninverted */
 			   ((oob_param->spectrum_inverted == false) &
 			    /* and tuner is mirroring the signal */
-			    (mirror_freq_spectOOB == true))
+			    (mirror_freq_spectOOB))
 		    )
 			set_param_parameters[0] =
 			    SCU_RAM_ORX_RF_RX_DATA_RATE_1544KBPS_INVSPEC;
@@ -16834,12 +16834,12 @@ static int ctrl_set_oob(struct drx_demod_instance *demod, struct drxoob *oob_par
 			   /* signal is transmitted inverted */
 			   ((oob_param->spectrum_inverted == true) &
 			    /* and tuner is not mirroring the signal */
-			    (mirror_freq_spectOOB == false)) |
+			    (!mirror_freq_spectOOB)) |
 			   /* or */
 			   /* signal is transmitted noninverted */
 			   ((oob_param->spectrum_inverted == false) &
 			    /* and tuner is mirroring the signal */
-			    (mirror_freq_spectOOB == true))
+			    (mirror_freq_spectOOB))
 		    )
 			set_param_parameters[0] =
 			    SCU_RAM_ORX_RF_RX_DATA_RATE_3088KBPS_INVSPEC;
@@ -17199,7 +17199,7 @@ ctrl_get_oob(struct drx_demod_instance *demod, struct drxoob_status *oob_status)
 		return DRX_STS_INVALID_ARG;
 	}
 
-	if (ext_attr->oob_power_on == false)
+	if (!ext_attr->oob_power_on)
 		return DRX_STS_ERROR;
 
 	rc = DRXJ_DAP.read_reg16func(dev_addr, ORX_DDC_OFO_SET_W__A, &data, 0);
@@ -17872,7 +17872,7 @@ ctrl_get_channel(struct drx_demod_instance *demod, struct drx_channel *channel)
 			goto rw_error;
 		}
 		tuner_freq_offset = channel->frequency - ext_attr->frequency;
-		if (tuner_mirror == true) {
+		if (tuner_mirror) {
 			/* positive image */
 			channel->frequency += tuner_freq_offset;
 		} else {
@@ -19187,7 +19187,7 @@ ctrl_u_codeUpload(struct drx_demod_instance *demod,
 					    DRX_STS_OK) {
 						return DRX_STS_ERROR;
 					}
-				};
+				}
 				break;
 
 	    /*===================================================================*/
@@ -19236,7 +19236,7 @@ ctrl_u_codeUpload(struct drx_demod_instance *demod,
 
 						if (result != 0) {
 							return DRX_STS_ERROR;
-						};
+						}
 
 						curr_addr +=
 						    ((dr_xaddr_t)
@@ -19246,7 +19246,7 @@ ctrl_u_codeUpload(struct drx_demod_instance *demod,
 						bytes_left_to_compare -=
 						    ((u32) bytes_to_compare);
 					}	/* while( bytes_to_compare > DRXJ_UCODE_MAX_BUF_SIZE ) */
-				};
+				}
 				break;
 
 	    /*===================================================================*/
@@ -19262,7 +19262,7 @@ ctrl_u_codeUpload(struct drx_demod_instance *demod,
 		mc_data += mc_block_nr_bytes;
 	}			/* for( i = 0 ; i<mc_nr_of_blks ; i++ ) */
 
-	if (upload_audio_mc == false) {
+	if (!upload_audio_mc) {
 		ext_attr->flag_aud_mc_uploaded = false;
 	}
 
@@ -20680,7 +20680,7 @@ int drxj_close(struct drx_demod_instance *demod)
 				goto rw_error;
 			}
 		}
-	};
+	}
 
 	rc = DRXJ_DAP.write_reg16func(dev_addr, SCU_COMM_EXEC__A, SCU_COMM_EXEC_ACTIVE, 0);
 	if (rc != DRX_STS_OK) {
-- 
1.8.5.3

