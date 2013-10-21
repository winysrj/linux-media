Return-path: <linux-media-owner@vger.kernel.org>
Received: from fep14.mx.upcmail.net ([62.179.121.34]:56523 "EHLO
	fep14.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930Ab3JUAea (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 20 Oct 2013 20:34:30 -0400
From: Jonathan McCrohan <jmccrohan@gmail.com>
To: linux-media@vger.kernel.org
Cc: Jonathan McCrohan <jmccrohan@gmail.com>
Subject: [PATCH] [TRIVIAL] [media] media_tree: Fix spelling errors
Date: Mon, 21 Oct 2013 01:34:01 +0100
Message-Id: <1382315641-886-1-git-send-email-jmccrohan@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix various spelling errors in strings and comments throughout the media
tree. The majority of these were found using Lucas De Marchi's codespell
tool.

Signed-off-by: Jonathan McCrohan <jmccrohan@gmail.com>
---
 drivers/media/common/siano/smscoreapi.h          |  4 ++--
 drivers/media/common/siano/smsdvb.h              |  2 +-
 drivers/media/dvb-core/dvb_demux.c               |  2 +-
 drivers/media/dvb-frontends/dib8000.c            |  4 ++--
 drivers/media/dvb-frontends/drxk_hard.c          | 18 +++++++++---------
 drivers/media/i2c/Kconfig                        |  2 +-
 drivers/media/i2c/adv7183.c                      |  2 +-
 drivers/media/i2c/adv7183_regs.h                 |  6 +++---
 drivers/media/i2c/adv7604.c                      |  2 +-
 drivers/media/i2c/adv7842.c                      |  2 +-
 drivers/media/i2c/ir-kbd-i2c.c                   |  2 +-
 drivers/media/i2c/m5mols/m5mols_controls.c       |  2 +-
 drivers/media/i2c/s5c73m3/s5c73m3-core.c         |  4 ++--
 drivers/media/i2c/s5c73m3/s5c73m3.h              |  2 +-
 drivers/media/i2c/saa7115.c                      |  2 +-
 drivers/media/i2c/soc_camera/ov5642.c            |  2 +-
 drivers/media/pci/cx18/cx18-driver.h             |  2 +-
 drivers/media/pci/cx23885/cx23885-417.c          |  2 +-
 drivers/media/pci/pluto2/pluto2.c                |  2 +-
 drivers/media/platform/coda.c                    |  2 +-
 drivers/media/platform/exynos4-is/fimc-core.c    |  2 +-
 drivers/media/platform/exynos4-is/media-dev.c    |  2 +-
 drivers/media/platform/omap3isp/isp.c            |  2 +-
 drivers/media/platform/s5p-mfc/regs-mfc.h        |  2 +-
 drivers/media/platform/s5p-mfc/s5p_mfc.c         | 12 ++++++------
 drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c    |  2 +-
 drivers/media/platform/s5p-tv/mixer.h            |  2 +-
 drivers/media/platform/s5p-tv/mixer_video.c      |  4 ++--
 drivers/media/platform/soc_camera/omap1_camera.c |  2 +-
 drivers/media/platform/vivi.c                    |  4 ++--
 drivers/media/platform/vsp1/vsp1_drv.c           |  2 +-
 drivers/media/radio/radio-si476x.c               |  4 ++--
 drivers/media/rc/imon.c                          |  2 +-
 drivers/media/rc/redrat3.c                       |  2 +-
 drivers/media/tuners/mt2063.c                    |  4 ++--
 drivers/media/tuners/tuner-xc2028-types.h        |  2 +-
 drivers/media/usb/dvb-usb-v2/mxl111sf.c          |  4 ++--
 drivers/media/usb/gspca/gl860/gl860.c            |  2 +-
 drivers/media/usb/gspca/pac207.c                 |  2 +-
 drivers/media/usb/gspca/pac7302.c                |  2 +-
 drivers/media/usb/gspca/stv0680.c                |  2 +-
 drivers/media/usb/gspca/zc3xx.c                  |  2 +-
 drivers/media/usb/pwc/pwc-if.c                   |  2 +-
 drivers/media/usb/uvc/uvc_video.c                |  2 +-
 drivers/media/v4l2-core/v4l2-ctrls.c             |  2 +-
 45 files changed, 68 insertions(+), 68 deletions(-)

diff --git a/drivers/media/common/siano/smscoreapi.h b/drivers/media/common/siano/smscoreapi.h
index d0799e3..9c9063c 100644
--- a/drivers/media/common/siano/smscoreapi.h
+++ b/drivers/media/common/siano/smscoreapi.h
@@ -955,7 +955,7 @@ struct sms_rx_stats {
 	u32 modem_state;		/* from SMSHOSTLIB_DVB_MODEM_STATE_ET */
 	s32 SNR;		/* dB */
 	u32 ber;		/* Post Viterbi ber [1E-5] */
-	u32 ber_error_count;	/* Number of erronous SYNC bits. */
+	u32 ber_error_count;	/* Number of erroneous SYNC bits. */
 	u32 ber_bit_count;	/* Total number of SYNC bits. */
 	u32 ts_per;		/* Transport stream PER,
 	0xFFFFFFFF indicate N/A */
@@ -981,7 +981,7 @@ struct sms_rx_stats_ex {
 	u32 modem_state;		/* from SMSHOSTLIB_DVB_MODEM_STATE_ET */
 	s32 SNR;		/* dB */
 	u32 ber;		/* Post Viterbi ber [1E-5] */
-	u32 ber_error_count;	/* Number of erronous SYNC bits. */
+	u32 ber_error_count;	/* Number of erroneous SYNC bits. */
 	u32 ber_bit_count;	/* Total number of SYNC bits. */
 	u32 ts_per;		/* Transport stream PER,
 	0xFFFFFFFF indicate N/A */
diff --git a/drivers/media/common/siano/smsdvb.h b/drivers/media/common/siano/smsdvb.h
index 92c413b..ae36d0a 100644
--- a/drivers/media/common/siano/smsdvb.h
+++ b/drivers/media/common/siano/smsdvb.h
@@ -95,7 +95,7 @@ struct RECEPTION_STATISTICS_PER_SLICES_S {
 	u32 is_demod_locked;	/* 0 - not locked, 1 - locked */
 
 	u32 ber_bit_count;	/* Total number of SYNC bits. */
-	u32 ber_error_count;	/* Number of erronous SYNC bits. */
+	u32 ber_error_count;	/* Number of erroneous SYNC bits. */
 
 	s32 MRC_SNR;		/* dB */
 	s32 mrc_in_band_pwr;	/* In band power in dBM */
diff --git a/drivers/media/dvb-core/dvb_demux.c b/drivers/media/dvb-core/dvb_demux.c
index 58de441..53ee319 100644
--- a/drivers/media/dvb-core/dvb_demux.c
+++ b/drivers/media/dvb-core/dvb_demux.c
@@ -435,7 +435,7 @@ static void dvb_dmx_swfilter_packet(struct dvb_demux *demux, const u8 *buf)
 		dprintk_tscheck("TEI detected. "
 				"PID=0x%x data1=0x%x\n",
 				pid, buf[1]);
-		/* data in this packet cant be trusted - drop it unless
+		/* data in this packet can't be trusted - drop it unless
 		 * module option dvb_demux_feed_err_pkts is set */
 		if (!dvb_demux_feed_err_pkts)
 			return;
diff --git a/drivers/media/dvb-frontends/dib8000.c b/drivers/media/dvb-frontends/dib8000.c
index 9053614..6dbbee4 100644
--- a/drivers/media/dvb-frontends/dib8000.c
+++ b/drivers/media/dvb-frontends/dib8000.c
@@ -3048,7 +3048,7 @@ static int dib8000_tune(struct dvb_frontend *fe)
 			dib8000_set_diversity_in(state->fe[0], state->diversity_onoff);
 
 			locks = (dib8000_read_word(state, 180) >> 6) & 0x3f; /* P_coff_winlen ? */
-			/* coff should lock over P_coff_winlen ofdm symbols : give 3 times this lenght to lock */
+			/* coff should lock over P_coff_winlen ofdm symbols : give 3 times this length to lock */
 			*timeout = dib8000_get_timeout(state, 2 * locks, SYMBOL_DEPENDENT_ON);
 			*tune_state = CT_DEMOD_STEP_5;
 			break;
@@ -3115,7 +3115,7 @@ static int dib8000_tune(struct dvb_frontend *fe)
 
 	case CT_DEMOD_STEP_9: /* 39 */
 			if ((state->revision == 0x8090) || ((dib8000_read_word(state, 1291) >> 9) & 0x1)) { /* fe capable of deinterleaving : esram */
-				/* defines timeout for mpeg lock depending on interleaver lenght of longest layer */
+				/* defines timeout for mpeg lock depending on interleaver length of longest layer */
 				for (i = 0; i < 3; i++) {
 					if (c->layer[i].interleaving >= deeper_interleaver) {
 						dprintk("layer%i: time interleaver = %d ", i, c->layer[i].interleaving);
diff --git a/drivers/media/dvb-frontends/drxk_hard.c b/drivers/media/dvb-frontends/drxk_hard.c
index d416c15..bf29a3f 100644
--- a/drivers/media/dvb-frontends/drxk_hard.c
+++ b/drivers/media/dvb-frontends/drxk_hard.c
@@ -1191,7 +1191,7 @@ static int mpegts_configure_pins(struct drxk_state *state, bool mpeg_enable)
 			goto error;
 
 		if (state->m_enable_parallel == true) {
-			/* paralel -> enable MD1 to MD7 */
+			/* parallel -> enable MD1 to MD7 */
 			status = write16(state, SIO_PDR_MD1_CFG__A,
 					 sio_pdr_mdx_cfg);
 			if (status < 0)
@@ -1428,7 +1428,7 @@ static int mpegts_stop(struct drxk_state *state)
 
 	dprintk(1, "\n");
 
-	/* Gracefull shutdown (byte boundaries) */
+	/* Graceful shutdown (byte boundaries) */
 	status = read16(state, FEC_OC_SNC_MODE__A, &fec_oc_snc_mode);
 	if (status < 0)
 		goto error;
@@ -2021,7 +2021,7 @@ static int mpegts_dto_setup(struct drxk_state *state,
 		fec_oc_dto_burst_len = 204;
 	}
 
-	/* Check serial or parrallel output */
+	/* Check serial or parallel output */
 	fec_oc_reg_ipr_mode &= (~(FEC_OC_IPR_MODE_SERIAL__M));
 	if (state->m_enable_parallel == false) {
 		/* MPEG data output is serial -> set ipr_mode[0] */
@@ -2908,7 +2908,7 @@ static int adc_synchronization(struct drxk_state *state)
 		goto error;
 
 	if (count == 1) {
-		/* Try sampling on a diffrent edge */
+		/* Try sampling on a different edge */
 		u16 clk_neg = 0;
 
 		status = read16(state, IQM_AF_CLKNEG__A, &clk_neg);
@@ -3306,7 +3306,7 @@ static int dvbt_sc_command(struct drxk_state *state,
 	if (status < 0)
 		goto error;
 
-	/* Retreive results parameters from SC */
+	/* Retrieve results parameters from SC */
 	switch (cmd) {
 		/* All commands yielding 5 results */
 		/* All commands yielding 4 results */
@@ -3849,7 +3849,7 @@ static int set_dvbt(struct drxk_state *state, u16 intermediate_freqk_hz,
 		break;
 	}
 #if 0
-	/* No hierachical channels support in BDA */
+	/* No hierarchical channels support in BDA */
 	/* Priority (only for hierarchical channels) */
 	switch (channel->priority) {
 	case DRX_PRIORITY_LOW:
@@ -4081,7 +4081,7 @@ error:
 /*============================================================================*/
 
 /**
-* \brief Retreive lock status .
+* \brief Retrieve lock status .
 * \param demod    Pointer to demodulator instance.
 * \param lockStat Pointer to lock status structure.
 * \return DRXStatus_t.
@@ -6174,7 +6174,7 @@ static int init_drxk(struct drxk_state *state)
 			goto error;
 
 		/* Stamp driver version number in SCU data RAM in BCD code
-			Done to enable field application engineers to retreive drxdriver version
+			Done to enable field application engineers to retrieve drxdriver version
 			via I2C from SCU RAM.
 			Not using SCU command interface for SCU register access since no
 			microcode may be present.
@@ -6399,7 +6399,7 @@ static int drxk_set_parameters(struct dvb_frontend *fe)
 	fe->ops.tuner_ops.get_if_frequency(fe, &IF);
 	start(state, 0, IF);
 
-	/* After set_frontend, stats aren't avaliable */
+	/* After set_frontend, stats aren't available */
 	p->strength.stat[0].scale = FE_SCALE_RELATIVE;
 	p->cnr.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
 	p->block_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
index d18be19..cbc9ee9 100644
--- a/drivers/media/i2c/Kconfig
+++ b/drivers/media/i2c/Kconfig
@@ -646,7 +646,7 @@ config VIDEO_UPD64083
 	  To compile this driver as a module, choose M here: the
 	  module will be called upd64083.
 
-comment "Miscelaneous helper chips"
+comment "Miscellaneous helper chips"
 
 config VIDEO_THS7303
 	tristate "THS7303/53 Video Amplifier"
diff --git a/drivers/media/i2c/adv7183.c b/drivers/media/i2c/adv7183.c
index 6f738d8..d45e0e3 100644
--- a/drivers/media/i2c/adv7183.c
+++ b/drivers/media/i2c/adv7183.c
@@ -178,7 +178,7 @@ static int adv7183_log_status(struct v4l2_subdev *sd)
 			adv7183_read(sd, ADV7183_VS_FIELD_CTRL_1),
 			adv7183_read(sd, ADV7183_VS_FIELD_CTRL_2),
 			adv7183_read(sd, ADV7183_VS_FIELD_CTRL_3));
-	v4l2_info(sd, "adv7183: Hsync positon control 1 2 and 3 = 0x%02x 0x%02x 0x%02x\n",
+	v4l2_info(sd, "adv7183: Hsync position control 1 2 and 3 = 0x%02x 0x%02x 0x%02x\n",
 			adv7183_read(sd, ADV7183_HS_POS_CTRL_1),
 			adv7183_read(sd, ADV7183_HS_POS_CTRL_2),
 			adv7183_read(sd, ADV7183_HS_POS_CTRL_3));
diff --git a/drivers/media/i2c/adv7183_regs.h b/drivers/media/i2c/adv7183_regs.h
index 4a5b7d2..b253d40 100644
--- a/drivers/media/i2c/adv7183_regs.h
+++ b/drivers/media/i2c/adv7183_regs.h
@@ -52,9 +52,9 @@
 #define ADV7183_VS_FIELD_CTRL_1    0x31 /* Vsync field control 1 */
 #define ADV7183_VS_FIELD_CTRL_2    0x32 /* Vsync field control 2 */
 #define ADV7183_VS_FIELD_CTRL_3    0x33 /* Vsync field control 3 */
-#define ADV7183_HS_POS_CTRL_1      0x34 /* Hsync positon control 1 */
-#define ADV7183_HS_POS_CTRL_2      0x35 /* Hsync positon control 2 */
-#define ADV7183_HS_POS_CTRL_3      0x36 /* Hsync positon control 3 */
+#define ADV7183_HS_POS_CTRL_1      0x34 /* Hsync position control 1 */
+#define ADV7183_HS_POS_CTRL_2      0x35 /* Hsync position control 2 */
+#define ADV7183_HS_POS_CTRL_3      0x36 /* Hsync position control 3 */
 #define ADV7183_POLARITY           0x37 /* Polarity */
 #define ADV7183_NTSC_COMB_CTRL     0x38 /* NTSC comb control */
 #define ADV7183_PAL_COMB_CTRL      0x39 /* PAL comb control */
diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index fbfdd2f..a324106b 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -877,7 +877,7 @@ static void configure_custom_video_timings(struct v4l2_subdev *sd,
 		break;
 	case ADV7604_MODE_HDMI:
 		/* set default prim_mode/vid_std for HDMI
-		   accoring to [REF_03, c. 4.2] */
+		   according to [REF_03, c. 4.2] */
 		io_write(sd, 0x00, 0x02); /* video std */
 		io_write(sd, 0x01, 0x06); /* prim mode */
 		break;
diff --git a/drivers/media/i2c/adv7842.c b/drivers/media/i2c/adv7842.c
index d174890..b50b073 100644
--- a/drivers/media/i2c/adv7842.c
+++ b/drivers/media/i2c/adv7842.c
@@ -1019,7 +1019,7 @@ static void configure_custom_video_timings(struct v4l2_subdev *sd,
 		break;
 	case ADV7842_MODE_HDMI:
 		/* set default prim_mode/vid_std for HDMI
-		   accoring to [REF_03, c. 4.2] */
+		   according to [REF_03, c. 4.2] */
 		io_write(sd, 0x00, 0x02); /* video std */
 		io_write(sd, 0x01, 0x06); /* prim mode */
 		break;
diff --git a/drivers/media/i2c/ir-kbd-i2c.c b/drivers/media/i2c/ir-kbd-i2c.c
index 82bf567..99ee456 100644
--- a/drivers/media/i2c/ir-kbd-i2c.c
+++ b/drivers/media/i2c/ir-kbd-i2c.c
@@ -394,7 +394,7 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 
 	if (!rc) {
 		/*
-		 * If platform_data doesn't specify rc_dev, initilize it
+		 * If platform_data doesn't specify rc_dev, initialize it
 		 * internally
 		 */
 		rc = rc_allocate_device();
diff --git a/drivers/media/i2c/m5mols/m5mols_controls.c b/drivers/media/i2c/m5mols/m5mols_controls.c
index f34429e..a60931e 100644
--- a/drivers/media/i2c/m5mols/m5mols_controls.c
+++ b/drivers/media/i2c/m5mols/m5mols_controls.c
@@ -544,7 +544,7 @@ int m5mols_init_controls(struct v4l2_subdev *sd)
 	u16 zoom_step;
 	int ret;
 
-	/* Determine the firmware dependant control range and step values */
+	/* Determine the firmware dependent control range and step values */
 	ret = m5mols_read_u16(sd, AE_MAX_GAIN_MON, &exposure_max);
 	if (ret < 0)
 		return ret;
diff --git a/drivers/media/i2c/s5c73m3/s5c73m3-core.c b/drivers/media/i2c/s5c73m3/s5c73m3-core.c
index b76ec0e..fa5913d 100644
--- a/drivers/media/i2c/s5c73m3/s5c73m3-core.c
+++ b/drivers/media/i2c/s5c73m3/s5c73m3-core.c
@@ -1460,7 +1460,7 @@ static int s5c73m3_oif_registered(struct v4l2_subdev *sd)
 	mutex_unlock(&state->lock);
 
 	v4l2_dbg(1, s5c73m3_dbg, sd, "%s: Booting %s (%d)\n",
-		 __func__, ret ? "failed" : "succeded", ret);
+		 __func__, ret ? "failed" : "succeeded", ret);
 
 	return ret;
 }
@@ -1651,7 +1651,7 @@ static int s5c73m3_probe(struct i2c_client *client,
 	if (ret < 0)
 		goto out_err;
 
-	v4l2_info(sd, "%s: completed succesfully\n", __func__);
+	v4l2_info(sd, "%s: completed successfully\n", __func__);
 	return 0;
 
 out_err:
diff --git a/drivers/media/i2c/s5c73m3/s5c73m3.h b/drivers/media/i2c/s5c73m3/s5c73m3.h
index 9d2c086..9dfa516 100644
--- a/drivers/media/i2c/s5c73m3/s5c73m3.h
+++ b/drivers/media/i2c/s5c73m3/s5c73m3.h
@@ -393,7 +393,7 @@ struct s5c73m3 {
 
 	/* External master clock frequency */
 	u32 mclk_frequency;
-	/* Video bus type - MIPI-CSI2/paralell */
+	/* Video bus type - MIPI-CSI2/parallel */
 	enum v4l2_mbus_type bus_type;
 
 	const struct s5c73m3_frame_size *sensor_pix_size[2];
diff --git a/drivers/media/i2c/saa7115.c b/drivers/media/i2c/saa7115.c
index 637d026..afdbcb0 100644
--- a/drivers/media/i2c/saa7115.c
+++ b/drivers/media/i2c/saa7115.c
@@ -1699,7 +1699,7 @@ static void saa711x_write_platform_data(struct saa711x_state *state,
  * the analog demod.
  * If the tuner is not found, it returns -ENODEV.
  * If auto-detection is disabled and the tuner doesn't match what it was
- *	requred, it returns -EINVAL and fills 'name'.
+ *	required, it returns -EINVAL and fills 'name'.
  * If the chip is found, it returns the chip ID and fills 'name'.
  */
 static int saa711x_detect_chip(struct i2c_client *client,
diff --git a/drivers/media/i2c/soc_camera/ov5642.c b/drivers/media/i2c/soc_camera/ov5642.c
index 0a5c5d4..d2daa6a 100644
--- a/drivers/media/i2c/soc_camera/ov5642.c
+++ b/drivers/media/i2c/soc_camera/ov5642.c
@@ -642,7 +642,7 @@ static const struct ov5642_datafmt
 static int reg_read(struct i2c_client *client, u16 reg, u8 *val)
 {
 	int ret;
-	/* We have 16-bit i2c addresses - care for endianess */
+	/* We have 16-bit i2c addresses - care for endianness */
 	unsigned char data[2] = { reg >> 8, reg & 0xff };
 
 	ret = i2c_master_send(client, data, 2);
diff --git a/drivers/media/pci/cx18/cx18-driver.h b/drivers/media/pci/cx18/cx18-driver.h
index 2767c64..57f4688 100644
--- a/drivers/media/pci/cx18/cx18-driver.h
+++ b/drivers/media/pci/cx18/cx18-driver.h
@@ -262,7 +262,7 @@ struct cx18_options {
 };
 
 /* per-mdl bit flags */
-#define CX18_F_M_NEED_SWAP  0	/* mdl buffer data must be endianess swapped */
+#define CX18_F_M_NEED_SWAP  0	/* mdl buffer data must be endianness swapped */
 
 /* per-stream, s_flags */
 #define CX18_F_S_CLAIMED 	3	/* this stream is claimed */
diff --git a/drivers/media/pci/cx23885/cx23885-417.c b/drivers/media/pci/cx23885/cx23885-417.c
index e3fc2c7..95666ee 100644
--- a/drivers/media/pci/cx23885/cx23885-417.c
+++ b/drivers/media/pci/cx23885/cx23885-417.c
@@ -427,7 +427,7 @@ int mc417_register_read(struct cx23885_dev *dev, u16 address, u32 *value)
 	cx_write(MC417_RWD, regval);
 
 	/* Transition RD to effect read transaction across bus.
-	 * Transtion 0x5000 -> 0x9000 correct (RD/RDY -> WR/RDY)?
+	 * Transition 0x5000 -> 0x9000 correct (RD/RDY -> WR/RDY)?
 	 * Should it be 0x9000 -> 0xF000 (also why is RDY being set, its
 	 * input only...)
 	 */
diff --git a/drivers/media/pci/pluto2/pluto2.c b/drivers/media/pci/pluto2/pluto2.c
index 8164d74..655d6854 100644
--- a/drivers/media/pci/pluto2/pluto2.c
+++ b/drivers/media/pci/pluto2/pluto2.c
@@ -401,7 +401,7 @@ static int pluto_hw_init(struct pluto *pluto)
 	/* set automatic LED control by FPGA */
 	pluto_rw(pluto, REG_MISC, MISC_ALED, MISC_ALED);
 
-	/* set data endianess */
+	/* set data endianness */
 #ifdef __LITTLE_ENDIAN
 	pluto_rw(pluto, REG_PIDn(0), PID0_END, PID0_END);
 #else
diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
index 449d2fe..53f2948 100644
--- a/drivers/media/platform/coda.c
+++ b/drivers/media/platform/coda.c
@@ -1357,7 +1357,7 @@ static void coda_buf_queue(struct vb2_buffer *vb)
 	if (q_data->fourcc == V4L2_PIX_FMT_H264 &&
 	    vb->vb2_queue->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) {
 		/*
-		 * For backwards compatiblity, queuing an empty buffer marks
+		 * For backwards compatibility, queuing an empty buffer marks
 		 * the stream end
 		 */
 		if (vb2_get_plane_payload(vb, 0) == 0)
diff --git a/drivers/media/platform/exynos4-is/fimc-core.c b/drivers/media/platform/exynos4-is/fimc-core.c
index 3d66d88..f791569 100644
--- a/drivers/media/platform/exynos4-is/fimc-core.c
+++ b/drivers/media/platform/exynos4-is/fimc-core.c
@@ -1039,7 +1039,7 @@ static int fimc_runtime_resume(struct device *dev)
 
 	dbg("fimc%d: state: 0x%lx", fimc->id, fimc->state);
 
-	/* Enable clocks and perform basic initalization */
+	/* Enable clocks and perform basic initialization */
 	clk_enable(fimc->clock[CLK_GATE]);
 	fimc_hw_reset(fimc);
 
diff --git a/drivers/media/platform/exynos4-is/media-dev.c b/drivers/media/platform/exynos4-is/media-dev.c
index a835112..d1b6626 100644
--- a/drivers/media/platform/exynos4-is/media-dev.c
+++ b/drivers/media/platform/exynos4-is/media-dev.c
@@ -759,7 +759,7 @@ static int fimc_md_register_platform_entity(struct fimc_md *fmd,
 		goto dev_unlock;
 
 	drvdata = dev_get_drvdata(dev);
-	/* Some subdev didn't probe succesfully id drvdata is NULL */
+	/* Some subdev didn't probe successfully id drvdata is NULL */
 	if (drvdata) {
 		switch (plat_entity) {
 		case IDX_FIMC:
diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index df3a0ec..7d9592c 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -1673,7 +1673,7 @@ void omap3isp_print_status(struct isp_device *isp)
  * ISP clocks get disabled in suspend(). Similarly, the clocks are reenabled in
  * resume(), and the the pipelines are restarted in complete().
  *
- * TODO: PM dependencies between the ISP and sensors are not modeled explicitly
+ * TODO: PM dependencies between the ISP and sensors are not modelled explicitly
  * yet.
  */
 static int isp_pm_prepare(struct device *dev)
diff --git a/drivers/media/platform/s5p-mfc/regs-mfc.h b/drivers/media/platform/s5p-mfc/regs-mfc.h
index 9319e93..6ccc3f8 100644
--- a/drivers/media/platform/s5p-mfc/regs-mfc.h
+++ b/drivers/media/platform/s5p-mfc/regs-mfc.h
@@ -382,7 +382,7 @@
 #define S5P_FIMV_R2H_CMD_EDFU_INIT_RET		16
 #define S5P_FIMV_R2H_CMD_ERR_RET		32
 
-/* Dummy definition for MFCv6 compatibilty */
+/* Dummy definition for MFCv6 compatibility */
 #define S5P_FIMV_CODEC_H264_MVC_DEC		-1
 #define S5P_FIMV_R2H_CMD_FIELD_DONE_RET		-1
 #define S5P_FIMV_MFC_RESET			-1
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index 084263d..e500718 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -239,7 +239,7 @@ static void s5p_mfc_handle_frame_copy_time(struct s5p_mfc_ctx *ctx)
 	frame_type = s5p_mfc_hw_call(dev->mfc_ops, get_dec_frame_type, dev);
 
 	/* Copy timestamp / timecode from decoded src to dst and set
-	   appropraite flags */
+	   appropriate flags */
 	src_buf = list_entry(ctx->src_queue.next, struct s5p_mfc_buf, list);
 	list_for_each_entry(dst_buf, &ctx->dst_queue, list) {
 		if (vb2_dma_contig_plane_dma_addr(dst_buf->b, 0) == dec_y_addr) {
@@ -424,7 +424,7 @@ static void s5p_mfc_handle_error(struct s5p_mfc_dev *dev,
 		case MFCINST_FINISHING:
 		case MFCINST_FINISHED:
 		case MFCINST_RUNNING:
-			/* It is higly probable that an error occured
+			/* It is highly probable that an error occurred
 			 * while decoding a frame */
 			clear_work_bit(ctx);
 			ctx->state = MFCINST_ERROR;
@@ -607,7 +607,7 @@ static irqreturn_t s5p_mfc_irq(int irq, void *priv)
 	mfc_debug(1, "Int reason: %d (err: %08x)\n", reason, err);
 	switch (reason) {
 	case S5P_MFC_R2H_CMD_ERR_RET:
-		/* An error has occured */
+		/* An error has occurred */
 		if (ctx->state == MFCINST_RUNNING &&
 			s5p_mfc_hw_call(dev->mfc_ops, err_dec, err) >=
 				dev->warn_start)
@@ -836,7 +836,7 @@ static int s5p_mfc_open(struct file *file)
 	mutex_unlock(&dev->mfc_mutex);
 	mfc_debug_leave();
 	return ret;
-	/* Deinit when failure occured */
+	/* Deinit when failure occurred */
 err_queue_init:
 	if (dev->num_inst == 1)
 		s5p_mfc_deinit_hw(dev);
@@ -877,14 +877,14 @@ static int s5p_mfc_release(struct file *file)
 	/* Mark context as idle */
 	clear_work_bit_irqsave(ctx);
 	/* If instance was initialised then
-	 * return instance and free reosurces */
+	 * return instance and free resources */
 	if (ctx->inst_no != MFC_NO_INSTANCE_SET) {
 		mfc_debug(2, "Has to free instance\n");
 		ctx->state = MFCINST_RETURN_INST;
 		set_work_bit_irqsave(ctx);
 		s5p_mfc_clean_ctx_int_flags(ctx);
 		s5p_mfc_hw_call(dev->mfc_ops, try_run, dev);
-		/* Wait until instance is returned or timeout occured */
+		/* Wait until instance is returned or timeout occurred */
 		if (s5p_mfc_wait_for_done_ctx
 		    (ctx, S5P_MFC_R2H_CMD_CLOSE_INSTANCE_RET, 0)) {
 			s5p_mfc_clock_off();
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c b/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c
index 7cab684..2475a3c 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c
@@ -69,7 +69,7 @@ int s5p_mfc_alloc_firmware(struct s5p_mfc_dev *dev)
 
 	} else {
 		/* In this case bank2 can point to the same address as bank1.
-		 * Firmware will always occupy the beggining of this area so it is
+		 * Firmware will always occupy the beginning of this area so it is
 		 * impossible having a video frame buffer with zero address. */
 		dev->bank2 = dev->bank1;
 	}
diff --git a/drivers/media/platform/s5p-tv/mixer.h b/drivers/media/platform/s5p-tv/mixer.h
index 04e6490..fb2acc5 100644
--- a/drivers/media/platform/s5p-tv/mixer.h
+++ b/drivers/media/platform/s5p-tv/mixer.h
@@ -65,7 +65,7 @@ struct mxr_format {
 	int num_subframes;
 	/** specifies to which subframe belong given plane */
 	int plane2subframe[MXR_MAX_PLANES];
-	/** internal code, driver dependant */
+	/** internal code, driver dependent */
 	unsigned long cookie;
 };
 
diff --git a/drivers/media/platform/s5p-tv/mixer_video.c b/drivers/media/platform/s5p-tv/mixer_video.c
index 641b1f0..81b97db 100644
--- a/drivers/media/platform/s5p-tv/mixer_video.c
+++ b/drivers/media/platform/s5p-tv/mixer_video.c
@@ -528,7 +528,7 @@ static int mxr_s_dv_timings(struct file *file, void *fh,
 	mutex_lock(&mdev->mutex);
 
 	/* timings change cannot be done while there is an entity
-	 * dependant on output configuration
+	 * dependent on output configuration
 	 */
 	if (mdev->n_output > 0) {
 		mutex_unlock(&mdev->mutex);
@@ -585,7 +585,7 @@ static int mxr_s_std(struct file *file, void *fh, v4l2_std_id norm)
 	mutex_lock(&mdev->mutex);
 
 	/* standard change cannot be done while there is an entity
-	 * dependant on output configuration
+	 * dependent on output configuration
 	 */
 	if (mdev->n_output > 0) {
 		mutex_unlock(&mdev->mutex);
diff --git a/drivers/media/platform/soc_camera/omap1_camera.c b/drivers/media/platform/soc_camera/omap1_camera.c
index 6769193..74ce8b6 100644
--- a/drivers/media/platform/soc_camera/omap1_camera.c
+++ b/drivers/media/platform/soc_camera/omap1_camera.c
@@ -1495,7 +1495,7 @@ static int omap1_cam_set_bus_param(struct soc_camera_device *icd)
 	if (ctrlclock & LCLK_EN)
 		CAM_WRITE(pcdev, CTRLCLOCK, ctrlclock);
 
-	/* select bus endianess */
+	/* select bus endianness */
 	xlate = soc_camera_xlate_by_fourcc(icd, pixfmt);
 	fmt = xlate->host_fmt;
 
diff --git a/drivers/media/platform/vivi.c b/drivers/media/platform/vivi.c
index 1d3f119..2d4e73b 100644
--- a/drivers/media/platform/vivi.c
+++ b/drivers/media/platform/vivi.c
@@ -1108,7 +1108,7 @@ static int vidioc_s_input(struct file *file, void *priv, unsigned int i)
 	return 0;
 }
 
-/* timeperframe is arbitrary and continous */
+/* timeperframe is arbitrary and continuous */
 static int vidioc_enum_frameintervals(struct file *file, void *priv,
 					     struct v4l2_frmivalenum *fival)
 {
@@ -1125,7 +1125,7 @@ static int vidioc_enum_frameintervals(struct file *file, void *priv,
 
 	fival->type = V4L2_FRMIVAL_TYPE_CONTINUOUS;
 
-	/* fill in stepwise (step=1.0 is requred by V4L2 spec) */
+	/* fill in stepwise (step=1.0 is required by V4L2 spec) */
 	fival->stepwise.min  = tpf_min;
 	fival->stepwise.max  = tpf_max;
 	fival->stepwise.step = (struct v4l2_fract) {1, 1};
diff --git a/drivers/media/platform/vsp1/vsp1_drv.c b/drivers/media/platform/vsp1/vsp1_drv.c
index 1c9e771..d16bf0f 100644
--- a/drivers/media/platform/vsp1/vsp1_drv.c
+++ b/drivers/media/platform/vsp1/vsp1_drv.c
@@ -323,7 +323,7 @@ static void vsp1_clocks_disable(struct vsp1_device *vsp1)
  * Increment the VSP1 reference count and initialize the device if the first
  * reference is taken.
  *
- * Return a pointer to the VSP1 device or NULL if an error occured.
+ * Return a pointer to the VSP1 device or NULL if an error occurred.
  */
 struct vsp1_device *vsp1_device_get(struct vsp1_device *vsp1)
 {
diff --git a/drivers/media/radio/radio-si476x.c b/drivers/media/radio/radio-si476x.c
index 9c9084c..2fd9009 100644
--- a/drivers/media/radio/radio-si476x.c
+++ b/drivers/media/radio/radio-si476x.c
@@ -268,8 +268,8 @@ struct si476x_radio;
  *
  * @tune_freq: Tune chip to a specific frequency
  * @seek_start: Star station seeking
- * @rsq_status: Get Recieved Signal Quality(RSQ) status
- * @rds_blckcnt: Get recived RDS blocks count
+ * @rsq_status: Get Received Signal Quality(RSQ) status
+ * @rds_blckcnt: Get received RDS blocks count
  * @phase_diversity: Change phase diversity mode of the tuner
  * @phase_div_status: Get phase diversity mode status
  * @acf_status: Get the status of Automatically Controlled
diff --git a/drivers/media/rc/imon.c b/drivers/media/rc/imon.c
index 72e3fa6..f329485 100644
--- a/drivers/media/rc/imon.c
+++ b/drivers/media/rc/imon.c
@@ -1370,7 +1370,7 @@ static void imon_pad_to_keys(struct imon_context *ictx, unsigned char *buf)
 	 * 0x68nnnnB7 to 0x6AnnnnB7, the left mouse button generates
 	 * 0x688301b7 and the right one 0x688481b7. All other keys generate
 	 * 0x2nnnnnnn. Position coordinate is encoded in buf[1] and buf[2] with
-	 * reversed endianess. Extract direction from buffer, rotate endianess,
+	 * reversed endianness. Extract direction from buffer, rotate endianness,
 	 * adjust sign and feed the values into stabilize(). The resulting codes
 	 * will be 0x01008000, 0x01007F00, which match the newer devices.
 	 */
diff --git a/drivers/media/rc/redrat3.c b/drivers/media/rc/redrat3.c
index 094484f..a5d4f88 100644
--- a/drivers/media/rc/redrat3.c
+++ b/drivers/media/rc/redrat3.c
@@ -118,7 +118,7 @@ static int debug;
 #define RR3_IR_IO_LENGTH_FUZZ	0x04
 /* Timeout for end of signal detection */
 #define RR3_IR_IO_SIG_TIMEOUT	0x05
-/* Minumum value for pause recognition. */
+/* Minimum value for pause recognition. */
 #define RR3_IR_IO_MIN_PAUSE	0x06
 
 /* Clock freq. of EZ-USB chip */
diff --git a/drivers/media/tuners/mt2063.c b/drivers/media/tuners/mt2063.c
index 2e1a02e..20cca40 100644
--- a/drivers/media/tuners/mt2063.c
+++ b/drivers/media/tuners/mt2063.c
@@ -1195,7 +1195,7 @@ static u32 mt2063_set_dnc_output_enable(struct mt2063_state *state,
  *   DNC Output is selected, the other is always off)
  *
  * @state:	ptr to mt2063_state structure
- * @Mode:	desired reciever delivery system
+ * @Mode:	desired receiver delivery system
  *
  * Note: Register cache must be valid for it to work
  */
@@ -2119,7 +2119,7 @@ static int mt2063_set_analog_params(struct dvb_frontend *fe,
 
 /*
  * As defined on EN 300 429, the DVB-C roll-off factor is 0.15.
- * So, the amount of the needed bandwith is given by:
+ * So, the amount of the needed bandwidth is given by:
  *	Bw = Symbol_rate * (1 + 0.15)
  * As such, the maximum symbol rate supported by 6 MHz is given by:
  *	max_symbol_rate = 6 MHz / 1.15 = 5217391 Bauds
diff --git a/drivers/media/tuners/tuner-xc2028-types.h b/drivers/media/tuners/tuner-xc2028-types.h
index 74dc46a..7e47987 100644
--- a/drivers/media/tuners/tuner-xc2028-types.h
+++ b/drivers/media/tuners/tuner-xc2028-types.h
@@ -119,7 +119,7 @@
 #define V4L2_STD_A2		(V4L2_STD_A2_A    | V4L2_STD_A2_B)
 #define V4L2_STD_NICAM		(V4L2_STD_NICAM_A | V4L2_STD_NICAM_B)
 
-/* To preserve backward compatibilty,
+/* To preserve backward compatibility,
    (std & V4L2_STD_AUDIO) = 0 means that ALL audio stds are supported
  */
 
diff --git a/drivers/media/usb/dvb-usb-v2/mxl111sf.c b/drivers/media/usb/dvb-usb-v2/mxl111sf.c
index e97964e..8d7abf6 100644
--- a/drivers/media/usb/dvb-usb-v2/mxl111sf.c
+++ b/drivers/media/usb/dvb-usb-v2/mxl111sf.c
@@ -258,7 +258,7 @@ static int mxl111sf_adap_fe_init(struct dvb_frontend *fe)
 	struct mxl111sf_adap_state *adap_state = &state->adap_state[fe->id];
 	int err;
 
-	/* exit if we didnt initialize the driver yet */
+	/* exit if we didn't initialize the driver yet */
 	if (!state->chip_id) {
 		mxl_debug("driver not yet initialized, exit.");
 		goto fail;
@@ -314,7 +314,7 @@ static int mxl111sf_adap_fe_sleep(struct dvb_frontend *fe)
 	struct mxl111sf_adap_state *adap_state = &state->adap_state[fe->id];
 	int err;
 
-	/* exit if we didnt initialize the driver yet */
+	/* exit if we didn't initialize the driver yet */
 	if (!state->chip_id) {
 		mxl_debug("driver not yet initialized, exit.");
 		goto fail;
diff --git a/drivers/media/usb/gspca/gl860/gl860.c b/drivers/media/usb/gspca/gl860/gl860.c
index cb1e64c..cea8d7f 100644
--- a/drivers/media/usb/gspca/gl860/gl860.c
+++ b/drivers/media/usb/gspca/gl860/gl860.c
@@ -438,7 +438,7 @@ static void sd_pkt_scan(struct gspca_dev *gspca_dev,
 	s32 nToSkip =
 		sd->swapRB * (gspca_dev->cam.cam_mode[mode].bytesperline + 1);
 
-	/* Test only against 0202h, so endianess does not matter */
+	/* Test only against 0202h, so endianness does not matter */
 	switch (*(s16 *) data) {
 	case 0x0202:		/* End of frame, start a new one */
 		gspca_frame_add(gspca_dev, LAST_PACKET, NULL, 0);
diff --git a/drivers/media/usb/gspca/pac207.c b/drivers/media/usb/gspca/pac207.c
index cd79c18..07529e5 100644
--- a/drivers/media/usb/gspca/pac207.c
+++ b/drivers/media/usb/gspca/pac207.c
@@ -416,7 +416,7 @@ static void sd_pkt_scan(struct gspca_dev *gspca_dev,
 #if IS_ENABLED(CONFIG_INPUT)
 static int sd_int_pkt_scan(struct gspca_dev *gspca_dev,
 			u8 *data,		/* interrupt packet data */
-			int len)		/* interrput packet length */
+			int len)		/* interrupt packet length */
 {
 	int ret = -EINVAL;
 
diff --git a/drivers/media/usb/gspca/pac7302.c b/drivers/media/usb/gspca/pac7302.c
index a915096..2fd1c5e 100644
--- a/drivers/media/usb/gspca/pac7302.c
+++ b/drivers/media/usb/gspca/pac7302.c
@@ -874,7 +874,7 @@ static int sd_dbg_s_register(struct gspca_dev *gspca_dev,
 #if IS_ENABLED(CONFIG_INPUT)
 static int sd_int_pkt_scan(struct gspca_dev *gspca_dev,
 			u8 *data,		/* interrupt packet data */
-			int len)		/* interrput packet length */
+			int len)		/* interrupt packet length */
 {
 	int ret = -EINVAL;
 	u8 data0, data1;
diff --git a/drivers/media/usb/gspca/stv0680.c b/drivers/media/usb/gspca/stv0680.c
index 9c08276..7f94ec7 100644
--- a/drivers/media/usb/gspca/stv0680.c
+++ b/drivers/media/usb/gspca/stv0680.c
@@ -139,7 +139,7 @@ static int sd_config(struct gspca_dev *gspca_dev,
 	struct sd *sd = (struct sd *) gspca_dev;
 	struct cam *cam = &gspca_dev->cam;
 
-	/* Give the camera some time to settle, otherwise initalization will
+	/* Give the camera some time to settle, otherwise initialization will
 	   fail on hotplug, and yes it really needs a full second. */
 	msleep(1000);
 
diff --git a/drivers/media/usb/gspca/zc3xx.c b/drivers/media/usb/gspca/zc3xx.c
index 7b95d8e..d3e1b6d 100644
--- a/drivers/media/usb/gspca/zc3xx.c
+++ b/drivers/media/usb/gspca/zc3xx.c
@@ -6905,7 +6905,7 @@ static int sd_get_jcomp(struct gspca_dev *gspca_dev,
 #if IS_ENABLED(CONFIG_INPUT)
 static int sd_int_pkt_scan(struct gspca_dev *gspca_dev,
 			u8 *data,		/* interrupt packet data */
-			int len)		/* interrput packet length */
+			int len)		/* interrupt packet length */
 {
 	if (len == 8 && data[4] == 1) {
 		input_report_key(gspca_dev->input_dev, KEY_CAMERA, 1);
diff --git a/drivers/media/usb/pwc/pwc-if.c b/drivers/media/usb/pwc/pwc-if.c
index 77bbf78..78c9bc8 100644
--- a/drivers/media/usb/pwc/pwc-if.c
+++ b/drivers/media/usb/pwc/pwc-if.c
@@ -1039,7 +1039,7 @@ static int usb_pwc_probe(struct usb_interface *intf, const struct usb_device_id
 	/* Set the leds off */
 	pwc_set_leds(pdev, 0, 0);
 
-	/* Setup intial videomode */
+	/* Setup initial videomode */
 	rc = pwc_set_video_mode(pdev, MAX_WIDTH, MAX_HEIGHT,
 				V4L2_PIX_FMT_YUV420, 30, &compression, 1);
 	if (rc)
diff --git a/drivers/media/usb/uvc/uvc_video.c b/drivers/media/usb/uvc/uvc_video.c
index 3394c34..97b3123 100644
--- a/drivers/media/usb/uvc/uvc_video.c
+++ b/drivers/media/usb/uvc/uvc_video.c
@@ -556,7 +556,7 @@ static u16 uvc_video_clock_host_sof(const struct uvc_clock_sample *sample)
  *
  * SOF = ((SOF2 - SOF1) * PTS + SOF1 * STC2 - SOF2 * STC1) / (STC2 - STC1)   (1)
  *
- * to avoid loosing precision in the division. Similarly, the host timestamp is
+ * to avoid losing precision in the division. Similarly, the host timestamp is
  * computed with
  *
  * TS = ((TS2 - TS1) * PTS + TS1 * SOF2 - TS2 * SOF1) / (SOF2 - SOF1)	     (2)
diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index 60dcc0f..fb46790 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -420,7 +420,7 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
 		"Advanced Simple",
 		"Core",
 		"Simple Scalable",
-		"Advanced Coding Efficency",
+		"Advanced Coding Efficiency",
 		NULL,
 	};
 
-- 
1.8.4

