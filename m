Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49513 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753812AbaCCKIT (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Mar 2014 05:08:19 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 22/79] [media] drx-j: Get rid of typedefs on drxh.h
Date: Mon,  3 Mar 2014 07:06:16 -0300
Message-Id: <1393841233-24840-23-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1393841233-24840-1-git-send-email-m.chehab@samsung.com>
References: <1393841233-24840-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This were fixed with the help of this small perl script:

	#!/usr/bin/perl
	my $dir = shift or die "need a dir";
	my $type = shift or die "need type";
	my $var = shift or die "need var";
	sub handle_file {
		my $file = shift;
		my $out;
		open IN, $file or die "can't open $file";
		$out .= $_ while (<IN>);
		close IN;
		$out =~ s/\btypedef\s+($type)\s+\{([\d\D]+?)\s*\}\s+\b($var)[^\;]+\;/$type $var \{\2\};/;
		$out =~ s,\b($var)_t\s+,$type \1 ,g;
		$out =~ s,\bp_*($var)_t\s+,$type \1 *,g;
		$out =~ s,\b($var)_t\b,$type \1,g;
		$out =~ s,\bp_*($var)_t\b,$type \1 *,g;
		open OUT, ">$file" or die "can't open $file";
		print OUT $out;
		close OUT;
	}
	sub parse_dir {
		my $file = $File::Find::name;
		return if (!($file =~ /.[ch]$/));
		handle_file $file;
	}
	find({wanted => \&parse_dir, no_chdir => 1}, $dir);

Some manual work were needed.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/dvb-frontends/drx39xyj/drx39xxj.c |   8 +-
 drivers/media/dvb-frontends/drx39xyj/drxj.c     | 542 ++++++++++++------------
 drivers/media/dvb-frontends/drx39xyj/drxj.h     | 245 +++++------
 3 files changed, 379 insertions(+), 416 deletions(-)

diff --git a/drivers/media/dvb-frontends/drx39xyj/drx39xxj.c b/drivers/media/dvb-frontends/drx39xyj/drx39xxj.c
index 837bb64fa930..0d2ec9959969 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drx39xxj.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drx39xxj.c
@@ -327,7 +327,7 @@ struct dvb_frontend *drx39xxj_attach(struct i2c_adapter *i2c)
 
 	struct i2c_device_addr *demod_addr = NULL;
 	struct drx_common_attr *demod_comm_attr = NULL;
-	drxj_data_t *demod_ext_attr = NULL;
+	struct drxj_data *demod_ext_attr = NULL;
 	struct drx_demod_instance *demod = NULL;
 	struct drxuio_cfg uio_cfg;
 	struct drxuio_data uio_data;
@@ -350,7 +350,7 @@ struct dvb_frontend *drx39xxj_attach(struct i2c_adapter *i2c)
 	if (demod_comm_attr == NULL)
 		goto error;
 
-	demod_ext_attr = kmalloc(sizeof(drxj_data_t), GFP_KERNEL);
+	demod_ext_attr = kmalloc(sizeof(struct drxj_data), GFP_KERNEL);
 	if (demod_ext_attr == NULL)
 		goto error;
 
@@ -375,8 +375,8 @@ struct dvb_frontend *drx39xxj_attach(struct i2c_adapter *i2c)
 	demod->my_common_attr->intermediate_freq = 5000;
 
 	demod->my_ext_attr = demod_ext_attr;
-	memcpy(demod->my_ext_attr, &drxj_data_g, sizeof(drxj_data_t));
-	((drxj_data_t *)demod->my_ext_attr)->uio_sma_tx_mode =
+	memcpy(demod->my_ext_attr, &drxj_data_g, sizeof(struct drxj_data));
+	((struct drxj_data *)demod->my_ext_attr)->uio_sma_tx_mode =
 	    DRX_UIO_MODE_READWRITE;
 
 	demod->my_tuner = NULL;
diff --git a/drivers/media/dvb-frontends/drx39xyj/drxj.c b/drivers/media/dvb-frontends/drx39xyj/drxj.c
index fc727d9b99c3..14a87caa6842 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drxj.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drxj.c
@@ -688,7 +688,7 @@ struct drx_demod_func drxj_functions_g = {
 	drxj_ctrl
 };
 
-drxj_data_t drxj_data_g = {
+struct drxj_data drxj_data_g = {
 	false,			/* has_lna : true if LNA (aka PGA) present      */
 	false,			/* has_oob : true if OOB supported              */
 	false,			/* has_ntsc: true if NTSC supported             */
@@ -1165,10 +1165,10 @@ static int
 aud_ctrl_set_standard(struct drx_demod_instance *demod, enum drx_aud_standard *standard);
 
 static int
-ctrl_set_cfg_pre_saw(struct drx_demod_instance *demod, p_drxj_cfg_pre_saw_t pre_saw);
+ctrl_set_cfg_pre_saw(struct drx_demod_instance *demod, struct drxj_cfg_pre_saw *pre_saw);
 
 static int
-ctrl_set_cfg_afe_gain(struct drx_demod_instance *demod, p_drxj_cfg_afe_gain_t afe_gain);
+ctrl_set_cfg_afe_gain(struct drx_demod_instance *demod, struct drxj_cfg_afe_gain *afe_gain);
 
 #ifdef DRXJ_SPLIT_UCODE_UPLOAD
 static int
@@ -2221,11 +2221,11 @@ int drxj_dap_atomic_read_reg32(struct i2c_device_addr *dev_addr,
 */
 static int hi_cfg_command(const struct drx_demod_instance *demod)
 {
-	pdrxj_data_t ext_attr = (pdrxj_data_t) (NULL);
+	struct drxj_data *ext_attr = (struct drxj_data *) (NULL);
 	drxj_hi_cmd_t hi_cmd;
 	u16 result = 0;
 
-	ext_attr = (pdrxj_data_t) demod->my_ext_attr;
+	ext_attr = (struct drxj_data *) demod->my_ext_attr;
 
 	hi_cmd.cmd = SIO_HI_RA_RAM_CMD_CONFIG;
 	hi_cmd.param1 = SIO_HI_RA_RAM_PAR_1_PAR1_SEC_KEY;
@@ -2336,11 +2336,11 @@ rw_error:
 */
 static int init_hi(const struct drx_demod_instance *demod)
 {
-	pdrxj_data_t ext_attr = (pdrxj_data_t) (NULL);
+	struct drxj_data *ext_attr = (struct drxj_data *) (NULL);
 	struct drx_common_attr *common_attr = (struct drx_common_attr *) (NULL);
 	struct i2c_device_addr *dev_addr = (struct i2c_device_addr *)(NULL);
 
-	ext_attr = (pdrxj_data_t) demod->my_ext_attr;
+	ext_attr = (struct drxj_data *) demod->my_ext_attr;
 	common_attr = (struct drx_common_attr *) demod->my_common_attr;
 	dev_addr = demod->my_i2c_dev_addr;
 
@@ -2414,14 +2414,14 @@ rw_error:
 static int get_device_capabilities(struct drx_demod_instance *demod)
 {
 	struct drx_common_attr *common_attr = (struct drx_common_attr *) (NULL);
-	pdrxj_data_t ext_attr = (pdrxj_data_t) NULL;
+	struct drxj_data *ext_attr = (struct drxj_data *) NULL;
 	struct i2c_device_addr *dev_addr = (struct i2c_device_addr *)(NULL);
 	u16 sio_pdr_ohw_cfg = 0;
 	u32 sio_top_jtagid_lo = 0;
 	u16 bid = 0;
 
 	common_attr = (struct drx_common_attr *) demod->my_common_attr;
-	ext_attr = (pdrxj_data_t) demod->my_ext_attr;
+	ext_attr = (struct drxj_data *) demod->my_ext_attr;
 	dev_addr = demod->my_i2c_dev_addr;
 
 	WR16(dev_addr, SIO_TOP_COMM_KEY__A, SIO_TOP_COMM_KEY_KEY);
@@ -2639,7 +2639,7 @@ static int
 ctrl_set_cfg_mpeg_output(struct drx_demod_instance *demod, struct drx_cfg_mpeg_output *cfg_data)
 {
 	struct i2c_device_addr *dev_addr = (struct i2c_device_addr *)(NULL);
-	pdrxj_data_t ext_attr = (pdrxj_data_t) (NULL);
+	struct drxj_data *ext_attr = (struct drxj_data *) (NULL);
 	struct drx_common_attr *common_attr = (struct drx_common_attr *) (NULL);
 	u16 fec_oc_reg_mode = 0;
 	u16 fec_oc_reg_ipr_mode = 0;
@@ -2660,7 +2660,7 @@ ctrl_set_cfg_mpeg_output(struct drx_demod_instance *demod, struct drx_cfg_mpeg_o
 	}
 
 	dev_addr = demod->my_i2c_dev_addr;
-	ext_attr = (pdrxj_data_t) demod->my_ext_attr;
+	ext_attr = (struct drxj_data *) demod->my_ext_attr;
 	common_attr = (struct drx_common_attr *) demod->my_common_attr;
 
 	if (cfg_data->enable_mpeg_output == true) {
@@ -3097,14 +3097,14 @@ rw_error:
 */
 static int set_mpegtei_handling(struct drx_demod_instance *demod)
 {
-	pdrxj_data_t ext_attr = (pdrxj_data_t) (NULL);
+	struct drxj_data *ext_attr = (struct drxj_data *) (NULL);
 	struct i2c_device_addr *dev_addr = (struct i2c_device_addr *)(NULL);
 	u16 fec_oc_dpr_mode = 0;
 	u16 fec_oc_snc_mode = 0;
 	u16 fec_oc_ems_mode = 0;
 
 	dev_addr = demod->my_i2c_dev_addr;
-	ext_attr = (pdrxj_data_t) demod->my_ext_attr;
+	ext_attr = (struct drxj_data *) demod->my_ext_attr;
 
 	RR16(dev_addr, FEC_OC_DPR_MODE__A, &fec_oc_dpr_mode);
 	RR16(dev_addr, FEC_OC_SNC_MODE__A, &fec_oc_snc_mode);
@@ -3145,12 +3145,12 @@ rw_error:
 */
 static int bit_reverse_mpeg_output(struct drx_demod_instance *demod)
 {
-	pdrxj_data_t ext_attr = (pdrxj_data_t) (NULL);
+	struct drxj_data *ext_attr = (struct drxj_data *) (NULL);
 	struct i2c_device_addr *dev_addr = (struct i2c_device_addr *)(NULL);
 	u16 fec_oc_ipr_mode = 0;
 
 	dev_addr = demod->my_i2c_dev_addr;
-	ext_attr = (pdrxj_data_t) demod->my_ext_attr;
+	ext_attr = (struct drxj_data *) demod->my_ext_attr;
 
 	RR16(dev_addr, FEC_OC_IPR_MODE__A, &fec_oc_ipr_mode);
 
@@ -3181,11 +3181,11 @@ rw_error:
 */
 static int set_mpeg_output_clock_rate(struct drx_demod_instance *demod)
 {
-	pdrxj_data_t ext_attr = (pdrxj_data_t) (NULL);
+	struct drxj_data *ext_attr = (struct drxj_data *) (NULL);
 	struct i2c_device_addr *dev_addr = (struct i2c_device_addr *)(NULL);
 
 	dev_addr = demod->my_i2c_dev_addr;
-	ext_attr = (pdrxj_data_t) demod->my_ext_attr;
+	ext_attr = (struct drxj_data *) demod->my_ext_attr;
 
 	if (ext_attr->mpeg_output_clock_rate != DRXJ_MPEGOUTPUT_CLOCK_RATE_AUTO) {
 		WR16(dev_addr, FEC_OC_DTO_PERIOD__A,
@@ -3209,13 +3209,13 @@ rw_error:
 */
 static int set_mpeg_start_width(struct drx_demod_instance *demod)
 {
-	pdrxj_data_t ext_attr = (pdrxj_data_t) (NULL);
+	struct drxj_data *ext_attr = (struct drxj_data *) (NULL);
 	struct i2c_device_addr *dev_addr = (struct i2c_device_addr *)(NULL);
 	u16 fec_oc_comm_mb = 0;
 	struct drx_common_attr *common_attr = (struct drx_common_attr *) NULL;
 
 	dev_addr = demod->my_i2c_dev_addr;
-	ext_attr = (pdrxj_data_t) demod->my_ext_attr;
+	ext_attr = (struct drxj_data *) demod->my_ext_attr;
 	common_attr = demod->my_common_attr;
 
 	if ((common_attr->mpeg_cfg.static_clk == true)
@@ -3247,15 +3247,15 @@ rw_error:
 */
 static int
 ctrl_set_cfg_mpeg_output_misc(struct drx_demod_instance *demod,
-			      p_drxj_cfg_mpeg_output_misc_t cfg_data)
+			      struct drxj_cfg_mpeg_output_misc *cfg_data)
 {
-	pdrxj_data_t ext_attr = (pdrxj_data_t) (NULL);
+	struct drxj_data *ext_attr = (struct drxj_data *) (NULL);
 
 	if (cfg_data == NULL) {
 		return (DRX_STS_INVALID_ARG);
 	}
 
-	ext_attr = (pdrxj_data_t) demod->my_ext_attr;
+	ext_attr = (struct drxj_data *) demod->my_ext_attr;
 
 	/*
 	   Set disable TEI bit handling flag.
@@ -3297,16 +3297,16 @@ rw_error:
 */
 static int
 ctrl_get_cfg_mpeg_output_misc(struct drx_demod_instance *demod,
-			      p_drxj_cfg_mpeg_output_misc_t cfg_data)
+			      struct drxj_cfg_mpeg_output_misc *cfg_data)
 {
-	pdrxj_data_t ext_attr = (pdrxj_data_t) (NULL);
+	struct drxj_data *ext_attr = (struct drxj_data *) (NULL);
 	u16 data = 0;
 
 	if (cfg_data == NULL) {
 		return (DRX_STS_INVALID_ARG);
 	}
 
-	ext_attr = (pdrxj_data_t) demod->my_ext_attr;
+	ext_attr = (struct drxj_data *) demod->my_ext_attr;
 	cfg_data->disable_tei_handling = ext_attr->disable_te_ihandling;
 	cfg_data->bit_reverse_mpeg_outout = ext_attr->bit_reverse_mpeg_outout;
 	cfg_data->mpeg_start_width = ext_attr->mpeg_start_width;
@@ -3315,7 +3315,7 @@ ctrl_get_cfg_mpeg_output_misc(struct drx_demod_instance *demod,
 	} else {
 		RR16(demod->my_i2c_dev_addr, FEC_OC_DTO_PERIOD__A, &data);
 		cfg_data->mpeg_output_clock_rate =
-		    (drxj_mpeg_output_clock_rate_t) (data + 1);
+		    (enum drxj_mpeg_output_clock_rate) (data + 1);
 	}
 
 	return (DRX_STS_OK);
@@ -3338,7 +3338,7 @@ rw_error:
 *
 */
 static int
-ctrl_get_cfg_hw_cfg(struct drx_demod_instance *demod, p_drxj_cfg_hw_cfg_t cfg_data)
+ctrl_get_cfg_hw_cfg(struct drx_demod_instance *demod, struct drxj_cfg_hw_cfg *cfg_data)
 {
 	u16 data = 0;
 
@@ -3349,8 +3349,8 @@ ctrl_get_cfg_hw_cfg(struct drx_demod_instance *demod, p_drxj_cfg_hw_cfg_t cfg_da
 	RR16(demod->my_i2c_dev_addr, SIO_PDR_OHW_CFG__A, &data);
 	WR16(demod->my_i2c_dev_addr, SIO_TOP_COMM_KEY__A, 0x0000);
 
-	cfg_data->i2c_speed = (drxji2c_speed_t) ((data >> 6) & 0x1);
-	cfg_data->xtal_freq = (drxj_xtal_freq_t) (data & 0x3);
+	cfg_data->i2c_speed = (enum drxji2c_speed) ((data >> 6) & 0x1);
+	cfg_data->xtal_freq = (enum drxj_xtal_freq) (data & 0x3);
 
 	return (DRX_STS_OK);
 rw_error:
@@ -3373,12 +3373,12 @@ rw_error:
 */
 static int ctrl_set_uio_cfg(struct drx_demod_instance *demod, struct drxuio_cfg *uio_cfg)
 {
-	pdrxj_data_t ext_attr = (pdrxj_data_t) (NULL);
+	struct drxj_data *ext_attr = (struct drxj_data *) (NULL);
 
 	if ((uio_cfg == NULL) || (demod == NULL)) {
 		return DRX_STS_INVALID_ARG;
 	}
-	ext_attr = (pdrxj_data_t) demod->my_ext_attr;
+	ext_attr = (struct drxj_data *) demod->my_ext_attr;
 
 	/*  Write magic word to enable pdr reg write               */
 	WR16(demod->my_i2c_dev_addr, SIO_TOP_COMM_KEY__A, SIO_TOP_COMM_KEY_KEY);
@@ -3487,7 +3487,7 @@ rw_error:
 static int CtrlGetuio_cfg(struct drx_demod_instance *demod, struct drxuio_cfg *uio_cfg)
 {
 
-	pdrxj_data_t ext_attr = (pdrxj_data_t) NULL;
+	struct drxj_data *ext_attr = (struct drxj_data *) NULL;
 	enum drxuio_mode *uio_mode[4] = { NULL };
 	bool *uio_available[4] = { NULL };
 
@@ -3530,7 +3530,7 @@ static int CtrlGetuio_cfg(struct drx_demod_instance *demod, struct drxuio_cfg *u
 static int
 ctrl_uio_write(struct drx_demod_instance *demod, struct drxuio_data *uio_data)
 {
-	pdrxj_data_t ext_attr = (pdrxj_data_t) (NULL);
+	struct drxj_data *ext_attr = (struct drxj_data *) (NULL);
 	u16 pin_cfg_value = 0;
 	u16 value = 0;
 
@@ -3538,7 +3538,7 @@ ctrl_uio_write(struct drx_demod_instance *demod, struct drxuio_data *uio_data)
 		return DRX_STS_INVALID_ARG;
 	}
 
-	ext_attr = (pdrxj_data_t) demod->my_ext_attr;
+	ext_attr = (struct drxj_data *) demod->my_ext_attr;
 
 	/*  Write magic word to enable pdr reg write               */
 	WR16(demod->my_i2c_dev_addr, SIO_TOP_COMM_KEY__A, SIO_TOP_COMM_KEY_KEY);
@@ -3675,7 +3675,7 @@ rw_error:
 */
 static int ctrl_uio_read(struct drx_demod_instance *demod, struct drxuio_data *uio_data)
 {
-	pdrxj_data_t ext_attr = (pdrxj_data_t) (NULL);
+	struct drxj_data *ext_attr = (struct drxj_data *) (NULL);
 	u16 pin_cfg_value = 0;
 	u16 value = 0;
 
@@ -3683,7 +3683,7 @@ static int ctrl_uio_read(struct drx_demod_instance *demod, struct drxuio_data *u
 		return DRX_STS_INVALID_ARG;
 	}
 
-	ext_attr = (pdrxj_data_t) demod->my_ext_attr;
+	ext_attr = (struct drxj_data *) demod->my_ext_attr;
 
 	/*  Write magic word to enable pdr reg write               */
 	WR16(demod->my_i2c_dev_addr, SIO_TOP_COMM_KEY__A, SIO_TOP_COMM_KEY_KEY);
@@ -3858,12 +3858,12 @@ ctrl_i2c_bridge(struct drx_demod_instance *demod, bool *bridge_closed)
 static int smart_ant_init(struct drx_demod_instance *demod)
 {
 	u16 data = 0;
-	pdrxj_data_t ext_attr = NULL;
+	struct drxj_data *ext_attr = NULL;
 	struct i2c_device_addr *dev_addr = NULL;
 	struct drxuio_cfg uio_cfg = { DRX_UIO1, DRX_UIO_MODE_FIRMWARE_SMA };
 
 	dev_addr = demod->my_i2c_dev_addr;
-	ext_attr = (pdrxj_data_t) demod->my_ext_attr;
+	ext_attr = (struct drxj_data *) demod->my_ext_attr;
 
 	/*  Write magic word to enable pdr reg write               */
 	WR16(demod->my_i2c_dev_addr, SIO_TOP_COMM_KEY__A, SIO_TOP_COMM_KEY_KEY);
@@ -3894,21 +3894,21 @@ rw_error:
 /**
 * \fn int ctrl_set_cfg_smart_ant()
 * \brief Set Smart Antenna.
-* \param pointer to drxj_cfg_smart_ant_t.
+* \param pointer to struct drxj_cfg_smart_ant.
 * \return int.
 *
 */
 static int
-ctrl_set_cfg_smart_ant(struct drx_demod_instance *demod, p_drxj_cfg_smart_ant_t smart_ant)
+ctrl_set_cfg_smart_ant(struct drx_demod_instance *demod, struct drxj_cfg_smart_ant *smart_ant)
 {
-	pdrxj_data_t ext_attr = NULL;
+	struct drxj_data *ext_attr = NULL;
 	struct i2c_device_addr *dev_addr = NULL;
 	u16 data = 0;
 	u32 start_time = 0;
 	static bool bit_inverted;
 
 	dev_addr = demod->my_i2c_dev_addr;
-	ext_attr = (pdrxj_data_t) demod->my_ext_attr;
+	ext_attr = (struct drxj_data *) demod->my_ext_attr;
 
 	/* check arguments */
 	if (smart_ant == NULL) {
@@ -3986,7 +3986,7 @@ rw_error:
 	return (DRX_STS_ERROR);
 }
 
-static int scu_command(struct i2c_device_addr *dev_addr, p_drxjscu_cmd_t cmd)
+static int scu_command(struct i2c_device_addr *dev_addr, struct drxjscu_cmd *cmd)
 {
 	u16 cur_cmd = 0;
 	u32 start_time = 0;
@@ -4095,7 +4095,7 @@ static
 int drxj_dap_scu_atomic_read_write_block(struct i2c_device_addr *dev_addr, u32 addr, u16 datasize,	/* max 30 bytes because the limit of SCU parameter */
 					      u8 *data, bool read_flag)
 {
-	drxjscu_cmd_t scu_cmd;
+	struct drxjscu_cmd scu_cmd;
 	u16 set_param_parameters[15];
 	u16 cmd_result[15];
 
@@ -4323,7 +4323,7 @@ rw_error:
 
 /* -------------------------------------------------------------------------- */
 static int
-ctrl_set_cfg_atv_output(struct drx_demod_instance *demod, p_drxj_cfg_atv_output_t output_cfg);
+ctrl_set_cfg_atv_output(struct drx_demod_instance *demod, struct drxj_cfg_atv_output *output_cfg);
 
 /**
 * \brief set configuration of pin-safe mode
@@ -4334,14 +4334,14 @@ ctrl_set_cfg_atv_output(struct drx_demod_instance *demod, p_drxj_cfg_atv_output_
 static int
 ctrl_set_cfg_pdr_safe_mode(struct drx_demod_instance *demod, bool *enable)
 {
-	pdrxj_data_t ext_attr = NULL;
+	struct drxj_data *ext_attr = NULL;
 	struct i2c_device_addr *dev_addr = NULL;
 
 	if (enable == NULL)
 		return (DRX_STS_INVALID_ARG);
 
 	dev_addr = demod->my_i2c_dev_addr;
-	ext_attr = (pdrxj_data_t) demod->my_ext_attr;
+	ext_attr = (struct drxj_data *) demod->my_ext_attr;
 
 	/*  Write magic word to enable pdr reg write  */
 	WR16(dev_addr, SIO_TOP_COMM_KEY__A, SIO_TOP_COMM_KEY_KEY);
@@ -4457,13 +4457,13 @@ rw_error:
 static int
 ctrl_get_cfg_pdr_safe_mode(struct drx_demod_instance *demod, bool *enabled)
 {
-	pdrxj_data_t ext_attr = (pdrxj_data_t) NULL;
+	struct drxj_data *ext_attr = (struct drxj_data *) NULL;
 
 	if (enabled == NULL) {
 		return (DRX_STS_INVALID_ARG);
 	}
 
-	ext_attr = (pdrxj_data_t) demod->my_ext_attr;
+	ext_attr = (struct drxj_data *) demod->my_ext_attr;
 	*enabled = ext_attr->pdr_safe_mode;
 
 	return (DRX_STS_OK);
@@ -4526,9 +4526,9 @@ static int init_agc(struct drx_demod_instance *demod)
 {
 	struct i2c_device_addr *dev_addr = NULL;
 	struct drx_common_attr *common_attr = NULL;
-	pdrxj_data_t ext_attr = NULL;
-	p_drxj_cfg_agc_t p_agc_rf_settings = NULL;
-	p_drxj_cfg_agc_t p_agc_if_settings = NULL;
+	struct drxj_data *ext_attr = NULL;
+	struct drxj_cfg_agc *p_agc_rf_settings = NULL;
+	struct drxj_cfg_agc *p_agc_if_settings = NULL;
 	u16 ingain_tgt_max = 0;
 	u16 clp_dir_to = 0;
 	u16 sns_sum_max = 0;
@@ -4546,7 +4546,7 @@ static int init_agc(struct drx_demod_instance *demod)
 	u16 agc_if = 0;
 	dev_addr = demod->my_i2c_dev_addr;
 	common_attr = (struct drx_common_attr *) demod->my_common_attr;
-	ext_attr = (pdrxj_data_t) demod->my_ext_attr;
+	ext_attr = (struct drxj_data *) demod->my_ext_attr;
 
 	switch (ext_attr->standard) {
 	case DRX_STANDARD_8VSB:
@@ -4734,7 +4734,7 @@ set_frequency(struct drx_demod_instance *demod,
 	      struct drx_channel *channel, s32 tuner_freq_offset)
 {
 	struct i2c_device_addr *dev_addr = demod->my_i2c_dev_addr;
-	pdrxj_data_t ext_attr = demod->my_ext_attr;
+	struct drxj_data *ext_attr = demod->my_ext_attr;
 	s32 sampling_frequency = 0;
 	s32 frequency_shift = 0;
 	s32 if_freq_actual = 0;
@@ -4893,10 +4893,10 @@ static int get_acc_pkt_err(struct drx_demod_instance *demod, u16 *packet_err)
 	static u16 pkt_err;
 	static u16 last_pkt_err;
 	u16 data = 0;
-	pdrxj_data_t ext_attr = NULL;
+	struct drxj_data *ext_attr = NULL;
 	struct i2c_device_addr *dev_addr = NULL;
 
-	ext_attr = (pdrxj_data_t) demod->my_ext_attr;
+	ext_attr = (struct drxj_data *) demod->my_ext_attr;
 	dev_addr = demod->my_i2c_dev_addr;
 
 	RR16(dev_addr, SCU_RAM_FEC_ACCUM_PKT_FAILURES__A, &data);
@@ -4932,10 +4932,10 @@ rw_error:
 static int ctrl_set_cfg_reset_pkt_err(struct drx_demod_instance *demod)
 {
 #ifdef DRXJ_SIGNAL_ACCUM_ERR
-	pdrxj_data_t ext_attr = NULL;
+	struct drxj_data *ext_attr = NULL;
 	u16 packet_error = 0;
 
-	ext_attr = (pdrxj_data_t) demod->my_ext_attr;
+	ext_attr = (struct drxj_data *) demod->my_ext_attr;
 	ext_attr->reset_pkt_err_acc = true;
 	/* call to reset counter */
 	CHK_ERROR(get_acc_pkt_err(demod, &packet_error));
@@ -4957,7 +4957,7 @@ static int get_str_freq_offset(struct drx_demod_instance *demod, s32 *str_freq)
 	u32 symbol_nom_frequency_ratio = 0;
 
 	struct i2c_device_addr *dev_addr = demod->my_i2c_dev_addr;
-	pdrxj_data_t ext_attr = demod->my_ext_attr;
+	struct drxj_data *ext_attr = demod->my_ext_attr;
 
 	ARR32(dev_addr, IQM_RC_RATE_LO__A, &symbol_frequency_ratio);
 	symbol_nom_frequency_ratio = ext_attr->iqm_rc_rate_ofs;
@@ -4993,12 +4993,12 @@ static int get_ctl_freq_offset(struct drx_demod_instance *demod, s32 *ctl_freq)
 	s32 sign = 1;
 	u32 data64hi = 0;
 	u32 data64lo = 0;
-	pdrxj_data_t ext_attr = NULL;
+	struct drxj_data *ext_attr = NULL;
 	struct drx_common_attr *common_attr = NULL;
 	struct i2c_device_addr *dev_addr = NULL;
 
 	dev_addr = demod->my_i2c_dev_addr;
-	ext_attr = (pdrxj_data_t) demod->my_ext_attr;
+	ext_attr = (struct drxj_data *) demod->my_ext_attr;
 	common_attr = (struct drx_common_attr *) demod->my_common_attr;
 
 	sampling_frequency = common_attr->sys_clock_freq / 3;
@@ -5041,18 +5041,18 @@ rw_error:
 * \return int.
 */
 static int
-set_agc_rf(struct drx_demod_instance *demod, p_drxj_cfg_agc_t agc_settings, bool atomic)
+set_agc_rf(struct drx_demod_instance *demod, struct drxj_cfg_agc *agc_settings, bool atomic)
 {
 	struct i2c_device_addr *dev_addr = NULL;
-	pdrxj_data_t ext_attr = NULL;
-	p_drxj_cfg_agc_t p_agc_settings = NULL;
+	struct drxj_data *ext_attr = NULL;
+	struct drxj_cfg_agc *p_agc_settings = NULL;
 	struct drx_common_attr *common_attr = NULL;
 	drx_write_reg16func_t scu_wr16 = NULL;
 	drx_read_reg16func_t scu_rr16 = NULL;
 
 	common_attr = (struct drx_common_attr *) demod->my_common_attr;
 	dev_addr = demod->my_i2c_dev_addr;
-	ext_attr = (pdrxj_data_t) demod->my_ext_attr;
+	ext_attr = (struct drxj_data *) demod->my_ext_attr;
 
 	if (atomic) {
 		scu_rr16 = drxj_dap_scu_atomic_read_reg16;
@@ -5219,14 +5219,14 @@ rw_error:
 * \return int.
 */
 static int
-get_agc_rf(struct drx_demod_instance *demod, p_drxj_cfg_agc_t agc_settings)
+get_agc_rf(struct drx_demod_instance *demod, struct drxj_cfg_agc *agc_settings)
 {
 	struct i2c_device_addr *dev_addr = NULL;
-	pdrxj_data_t ext_attr = NULL;
+	struct drxj_data *ext_attr = NULL;
 	enum drx_standard standard = DRX_STANDARD_UNKNOWN;
 
 	dev_addr = demod->my_i2c_dev_addr;
-	ext_attr = (pdrxj_data_t) demod->my_ext_attr;
+	ext_attr = (struct drxj_data *) demod->my_ext_attr;
 
 	/* Return stored AGC settings */
 	standard = agc_settings->standard;
@@ -5280,18 +5280,18 @@ rw_error:
 * \return int.
 */
 static int
-set_agc_if(struct drx_demod_instance *demod, p_drxj_cfg_agc_t agc_settings, bool atomic)
+set_agc_if(struct drx_demod_instance *demod, struct drxj_cfg_agc *agc_settings, bool atomic)
 {
 	struct i2c_device_addr *dev_addr = NULL;
-	pdrxj_data_t ext_attr = NULL;
-	p_drxj_cfg_agc_t p_agc_settings = NULL;
+	struct drxj_data *ext_attr = NULL;
+	struct drxj_cfg_agc *p_agc_settings = NULL;
 	struct drx_common_attr *common_attr = NULL;
 	drx_write_reg16func_t scu_wr16 = NULL;
 	drx_read_reg16func_t scu_rr16 = NULL;
 
 	common_attr = (struct drx_common_attr *) demod->my_common_attr;
 	dev_addr = demod->my_i2c_dev_addr;
-	ext_attr = (pdrxj_data_t) demod->my_ext_attr;
+	ext_attr = (struct drxj_data *) demod->my_ext_attr;
 
 	if (atomic) {
 		scu_rr16 = drxj_dap_scu_atomic_read_reg16;
@@ -5471,14 +5471,14 @@ rw_error:
 * \return int.
 */
 static int
-get_agc_if(struct drx_demod_instance *demod, p_drxj_cfg_agc_t agc_settings)
+get_agc_if(struct drx_demod_instance *demod, struct drxj_cfg_agc *agc_settings)
 {
 	struct i2c_device_addr *dev_addr = NULL;
-	pdrxj_data_t ext_attr = NULL;
+	struct drxj_data *ext_attr = NULL;
 	enum drx_standard standard = DRX_STANDARD_UNKNOWN;
 
 	dev_addr = demod->my_i2c_dev_addr;
-	ext_attr = (pdrxj_data_t) demod->my_ext_attr;
+	ext_attr = (struct drxj_data *) demod->my_ext_attr;
 
 	/* Return stored ATV AGC settings */
 	standard = agc_settings->standard;
@@ -5583,7 +5583,7 @@ rw_error:
 static int power_down_vsb(struct drx_demod_instance *demod, bool primary)
 {
 	struct i2c_device_addr *dev_addr = demod->my_i2c_dev_addr;
-	drxjscu_cmd_t cmd_scu = { /* command     */ 0,
+	struct drxjscu_cmd cmd_scu = { /* command     */ 0,
 		/* parameter_len */ 0,
 		/* result_len    */ 0,
 		/* *parameter   */ NULL,
@@ -5848,8 +5848,8 @@ static int set_vsb(struct drx_demod_instance *demod)
 	u16 cmd_result = 0;
 	u16 cmd_param = 0;
 	struct drx_common_attr *common_attr = NULL;
-	drxjscu_cmd_t cmd_scu;
-	pdrxj_data_t ext_attr = NULL;
+	struct drxjscu_cmd cmd_scu;
+	struct drxj_data *ext_attr = NULL;
 	const u8 vsb_taps_re[] = {
 		DRXJ_16TO8(-2),	/* re0  */
 		DRXJ_16TO8(4),	/* re1  */
@@ -5883,7 +5883,7 @@ static int set_vsb(struct drx_demod_instance *demod)
 
 	dev_addr = demod->my_i2c_dev_addr;
 	common_attr = (struct drx_common_attr *) demod->my_common_attr;
-	ext_attr = (pdrxj_data_t) demod->my_ext_attr;
+	ext_attr = (struct drxj_data *) demod->my_ext_attr;
 
 	/* stop all comm_exec */
 	WR16(dev_addr, FEC_COMM_EXEC__A, FEC_COMM_EXEC_STOP);
@@ -5987,9 +5987,9 @@ static int set_vsb(struct drx_demod_instance *demod)
 	CHK_ERROR(set_agc_if(demod, &(ext_attr->vsb_if_agc_cfg), false));
 	CHK_ERROR(set_agc_rf(demod, &(ext_attr->vsb_rf_agc_cfg), false));
 	{
-		/* TODO fix this, store a drxj_cfg_afe_gain_t structure in drxj_data_t instead
+		/* TODO fix this, store a struct drxj_cfg_afe_gain structure in struct drxj_data instead
 		   of only the gain */
-		drxj_cfg_afe_gain_t vsb_pga_cfg = { DRX_STANDARD_8VSB, 0 };
+		struct drxj_cfg_afe_gain vsb_pga_cfg = { DRX_STANDARD_8VSB, 0 };
 
 		vsb_pga_cfg.gain = ext_attr->vsb_pga_cfg;
 		CHK_ERROR(ctrl_set_cfg_afe_gain(demod, &vsb_pga_cfg));
@@ -6268,7 +6268,7 @@ rw_error:
 */
 static int power_down_qam(struct drx_demod_instance *demod, bool primary)
 {
-	drxjscu_cmd_t cmd_scu = { /* command      */ 0,
+	struct drxjscu_cmd cmd_scu = { /* command      */ 0,
 		/* parameter_len */ 0,
 		/* result_len    */ 0,
 		/* *parameter   */ NULL,
@@ -6337,7 +6337,7 @@ set_qam_measurement(struct drx_demod_instance *demod,
 		    enum drx_modulation constellation, u32 symbol_rate)
 {
 	struct i2c_device_addr *dev_addr = NULL;	/* device address for I2C writes */
-	pdrxj_data_t ext_attr = NULL;	/* Global data container for DRXJ specif data */
+	struct drxj_data *ext_attr = NULL;	/* Global data container for DRXJ specif data */
 	u32 fec_bits_desired = 0;	/* BER accounting period */
 	u16 fec_rs_plen = 0;	/* defines RS BER measurement period */
 	u16 fec_rs_prescale = 0;	/* ReedSolomon Measurement Prescale */
@@ -6350,7 +6350,7 @@ set_qam_measurement(struct drx_demod_instance *demod,
 	u16 qam_vd_prescale = 0;	/* Viterbi Measurement Prescale */
 
 	dev_addr = demod->my_i2c_dev_addr;
-	ext_attr = (pdrxj_data_t) demod->my_ext_attr;
+	ext_attr = (struct drxj_data *) demod->my_ext_attr;
 
 	fec_bits_desired = ext_attr->fec_bits_desired;
 	fec_rs_prescale = ext_attr->fec_rs_prescale;
@@ -6904,7 +6904,7 @@ set_qam(struct drx_demod_instance *demod,
 	struct drx_channel *channel, s32 tuner_freq_offset, u32 op)
 {
 	struct i2c_device_addr *dev_addr = NULL;
-	pdrxj_data_t ext_attr = NULL;
+	struct drxj_data *ext_attr = NULL;
 	struct drx_common_attr *common_attr = NULL;
 	u16 cmd_result = 0;
 	u32 adc_frequency = 0;
@@ -6913,7 +6913,7 @@ set_qam(struct drx_demod_instance *demod,
 	u16 iqm_rc_stretch = 0;
 	u16 set_env_parameters = 0;
 	u16 set_param_parameters[2] = { 0 };
-	drxjscu_cmd_t cmd_scu = { /* command      */ 0,
+	struct drxjscu_cmd cmd_scu = { /* command      */ 0,
 		/* parameter_len */ 0,
 		/* result_len    */ 0,
 		/* parameter    */ NULL,
@@ -7041,7 +7041,7 @@ set_qam(struct drx_demod_instance *demod,
 	};
 
 	dev_addr = demod->my_i2c_dev_addr;
-	ext_attr = (pdrxj_data_t) demod->my_ext_attr;
+	ext_attr = (struct drxj_data *) demod->my_ext_attr;
 	common_attr = (struct drx_common_attr *) demod->my_common_attr;
 
 	if ((op & QAM_SET_OP_ALL) || (op & QAM_SET_OP_CONSTELLATION)) {
@@ -7247,9 +7247,9 @@ set_qam(struct drx_demod_instance *demod,
 		CHK_ERROR(set_agc_if(demod, &(ext_attr->qam_if_agc_cfg), false));
 		CHK_ERROR(set_agc_rf(demod, &(ext_attr->qam_rf_agc_cfg), false));
 		{
-			/* TODO fix this, store a drxj_cfg_afe_gain_t structure in drxj_data_t instead
+			/* TODO fix this, store a struct drxj_cfg_afe_gain structure in struct drxj_data instead
 			   of only the gain */
-			drxj_cfg_afe_gain_t qam_pga_cfg = { DRX_STANDARD_ITU_B, 0 };
+			struct drxj_cfg_afe_gain qam_pga_cfg = { DRX_STANDARD_ITU_B, 0 };
 
 			qam_pga_cfg.gain = ext_attr->qam_pga_cfg;
 			CHK_ERROR(ctrl_set_cfg_afe_gain(demod, &qam_pga_cfg));
@@ -7375,10 +7375,10 @@ static int qam_flip_spec(struct drx_demod_instance *demod, struct drx_channel *c
 	int i = 0;
 	int ofsofs = 0;
 	struct i2c_device_addr *dev_addr = NULL;
-	pdrxj_data_t ext_attr = NULL;
+	struct drxj_data *ext_attr = NULL;
 
 	dev_addr = demod->my_i2c_dev_addr;
-	ext_attr = (pdrxj_data_t) demod->my_ext_attr;
+	ext_attr = (struct drxj_data *) demod->my_ext_attr;
 
 	/* Silence the controlling of lc, equ, and the acquisition state machine */
 	RR16(dev_addr, SCU_RAM_QAM_CTL_ENA__A, &qam_ctl_ena);
@@ -7470,11 +7470,11 @@ qam64auto(struct drx_demod_instance *demod,
 	u32 state = NO_LOCK;
 	u32 start_time = 0;
 	u32 d_locked_time = 0;
-	pdrxj_data_t ext_attr = NULL;
+	struct drxj_data *ext_attr = NULL;
 	u32 timeout_ofs = 0;
 
 	/* external attributes for storing aquired channel constellation */
-	ext_attr = (pdrxj_data_t) demod->my_ext_attr;
+	ext_attr = (struct drxj_data *) demod->my_ext_attr;
 	*lock_status = DRX_NOT_LOCKED;
 	start_time = drxbsp_hst_clock();
 	state = NO_LOCK;
@@ -7583,11 +7583,11 @@ qam256auto(struct drx_demod_instance *demod,
 	u32 state = NO_LOCK;
 	u32 start_time = 0;
 	u32 d_locked_time = 0;
-	pdrxj_data_t ext_attr = NULL;
+	struct drxj_data *ext_attr = NULL;
 	u32 timeout_ofs = DRXJ_QAM_DEMOD_LOCK_EXT_WAITTIME;
 
 	/* external attributes for storing aquired channel constellation */
-	ext_attr = (pdrxj_data_t) demod->my_ext_attr;
+	ext_attr = (struct drxj_data *) demod->my_ext_attr;
 	*lock_status = DRX_NOT_LOCKED;
 	start_time = drxbsp_hst_clock();
 	state = NO_LOCK;
@@ -7648,11 +7648,11 @@ set_qamChannel(struct drx_demod_instance *demod,
 	       struct drx_channel *channel, s32 tuner_freq_offset)
 {
 	enum drx_lock_status lock_status = DRX_NOT_LOCKED;
-	pdrxj_data_t ext_attr = NULL;
+	struct drxj_data *ext_attr = NULL;
 	bool auto_flag = false;
 
 	/* external attributes for storing aquired channel constellation */
-	ext_attr = (pdrxj_data_t) demod->my_ext_attr;
+	ext_attr = (struct drxj_data *) demod->my_ext_attr;
 
 	/* set QAM channel constellation */
 	switch (channel->constellation) {
@@ -7794,7 +7794,7 @@ rw_error:
 *
 */
 static int
-GetQAMRSErr_count(struct i2c_device_addr *dev_addr, p_drxjrs_errors_t rs_errors)
+GetQAMRSErr_count(struct i2c_device_addr *dev_addr, struct drxjrs_errors *rs_errors)
 {
 	u16 nr_bit_errors = 0,
 	    nr_symbol_errors = 0,
@@ -7851,9 +7851,9 @@ static int
 ctrl_get_qam_sig_quality(struct drx_demod_instance *demod, struct drx_sig_quality *sig_quality)
 {
 	struct i2c_device_addr *dev_addr = NULL;
-	pdrxj_data_t ext_attr = NULL;
+	struct drxj_data *ext_attr = NULL;
 	enum drx_modulation constellation = DRX_CONSTELLATION_UNKNOWN;
-	DRXJrs_errors_t measuredrs_errors = { 0, 0, 0, 0, 0 };
+	struct drxjrs_errors measuredrs_errors = { 0, 0, 0, 0, 0 };
 
 	u32 pre_bit_err_rs = 0;	/* pre RedSolomon Bit Error Rate */
 	u32 post_bit_err_rs = 0;	/* post RedSolomon Bit Error Rate */
@@ -7881,7 +7881,7 @@ ctrl_get_qam_sig_quality(struct drx_demod_instance *demod, struct drx_sig_qualit
 
 	/* get device basic information */
 	dev_addr = demod->my_i2c_dev_addr;
-	ext_attr = (pdrxj_data_t) demod->my_ext_attr;
+	ext_attr = (struct drxj_data *) demod->my_ext_attr;
 	constellation = ext_attr->constellation;
 
 	/* read the physical registers */
@@ -8223,10 +8223,10 @@ static int
 atv_update_config(struct drx_demod_instance *demod, bool force_update)
 {
 	struct i2c_device_addr *dev_addr = NULL;
-	pdrxj_data_t ext_attr = NULL;
+	struct drxj_data *ext_attr = NULL;
 
 	dev_addr = demod->my_i2c_dev_addr;
-	ext_attr = (pdrxj_data_t) demod->my_ext_attr;
+	ext_attr = (struct drxj_data *) demod->my_ext_attr;
 
 	/* equalizer coefficients */
 	if (force_update ||
@@ -8328,16 +8328,16 @@ rw_error:
 *
 */
 static int
-ctrl_set_cfg_atv_output(struct drx_demod_instance *demod, p_drxj_cfg_atv_output_t output_cfg)
+ctrl_set_cfg_atv_output(struct drx_demod_instance *demod, struct drxj_cfg_atv_output *output_cfg)
 {
-	pdrxj_data_t ext_attr = NULL;
+	struct drxj_data *ext_attr = NULL;
 
 	/* Check arguments */
 	if (output_cfg == NULL) {
 		return (DRX_STS_INVALID_ARG);
 	}
 
-	ext_attr = (pdrxj_data_t) demod->my_ext_attr;
+	ext_attr = (struct drxj_data *) demod->my_ext_attr;
 	if (output_cfg->enable_sif_output) {
 		switch (output_cfg->sif_attenuation) {
 		case DRXJ_SIF_ATTENUATION_0DB:	/* fallthrough */
@@ -8385,12 +8385,12 @@ rw_error:
 *
 */
 static int
-ctrl_set_cfg_atv_equ_coef(struct drx_demod_instance *demod, p_drxj_cfg_atv_equ_coef_t coef)
+ctrl_set_cfg_atv_equ_coef(struct drx_demod_instance *demod, struct drxj_cfg_atv_equ_coef *coef)
 {
-	pdrxj_data_t ext_attr = NULL;
+	struct drxj_data *ext_attr = NULL;
 	int index;
 
-	ext_attr = (pdrxj_data_t) demod->my_ext_attr;
+	ext_attr = (struct drxj_data *) demod->my_ext_attr;
 
 	/* current standard needs to be an ATV standard */
 	if (!DRXJ_ISATVSTD(ext_attr->standard)) {
@@ -8439,12 +8439,12 @@ rw_error:
 *
 */
 static int
-ctrl_get_cfg_atv_equ_coef(struct drx_demod_instance *demod, p_drxj_cfg_atv_equ_coef_t coef)
+ctrl_get_cfg_atv_equ_coef(struct drx_demod_instance *demod, struct drxj_cfg_atv_equ_coef *coef)
 {
-	pdrxj_data_t ext_attr = NULL;
+	struct drxj_data *ext_attr = NULL;
 	int index = 0;
 
-	ext_attr = (pdrxj_data_t) demod->my_ext_attr;
+	ext_attr = (struct drxj_data *) demod->my_ext_attr;
 
 	/* current standard needs to be an ATV standard */
 	if (!DRXJ_ISATVSTD(ext_attr->standard)) {
@@ -8477,9 +8477,9 @@ rw_error:
 *
 */
 static int
-ctrl_set_cfg_atv_misc(struct drx_demod_instance *demod, p_drxj_cfg_atv_misc_t settings)
+ctrl_set_cfg_atv_misc(struct drx_demod_instance *demod, struct drxj_cfg_atv_misc *settings)
 {
-	pdrxj_data_t ext_attr = NULL;
+	struct drxj_data *ext_attr = NULL;
 
 	/* Check arguments */
 	if ((settings == NULL) ||
@@ -8489,7 +8489,7 @@ ctrl_set_cfg_atv_misc(struct drx_demod_instance *demod, p_drxj_cfg_atv_misc_t se
 		return (DRX_STS_INVALID_ARG);
 	}
 	/* if */
-	ext_attr = (pdrxj_data_t) demod->my_ext_attr;
+	ext_attr = (struct drxj_data *) demod->my_ext_attr;
 
 	if (settings->peak_filter != ext_attr->atv_top_vid_peak) {
 		ext_attr->atv_top_vid_peak = settings->peak_filter;
@@ -8522,16 +8522,16 @@ rw_error:
 * regitsers.
 */
 static int
-ctrl_get_cfg_atv_misc(struct drx_demod_instance *demod, p_drxj_cfg_atv_misc_t settings)
+ctrl_get_cfg_atv_misc(struct drx_demod_instance *demod, struct drxj_cfg_atv_misc *settings)
 {
-	pdrxj_data_t ext_attr = NULL;
+	struct drxj_data *ext_attr = NULL;
 
 	/* Check arguments */
 	if (settings == NULL) {
 		return DRX_STS_INVALID_ARG;
 	}
 
-	ext_attr = (pdrxj_data_t) demod->my_ext_attr;
+	ext_attr = (struct drxj_data *) demod->my_ext_attr;
 
 	settings->peak_filter = ext_attr->atv_top_vid_peak;
 	settings->noise_filter = ext_attr->atv_top_noise_th;
@@ -8551,7 +8551,7 @@ ctrl_get_cfg_atv_misc(struct drx_demod_instance *demod, p_drxj_cfg_atv_misc_t se
 *
 */
 static int
-ctrl_get_cfg_atv_output(struct drx_demod_instance *demod, p_drxj_cfg_atv_output_t output_cfg)
+ctrl_get_cfg_atv_output(struct drx_demod_instance *demod, struct drxj_cfg_atv_output *output_cfg)
 {
 	u16 data = 0;
 
@@ -8572,7 +8572,7 @@ ctrl_get_cfg_atv_output(struct drx_demod_instance *demod, p_drxj_cfg_atv_output_
 	} else {
 		output_cfg->enable_sif_output = true;
 		RR16(demod->my_i2c_dev_addr, ATV_TOP_AF_SIF_ATT__A, &data);
-		output_cfg->sif_attenuation = (drxjsif_attenuation_t) data;
+		output_cfg->sif_attenuation = (enum drxjsif_attenuation) data;
 	}
 
 	return (DRX_STS_OK);
@@ -8591,7 +8591,7 @@ rw_error:
 */
 static int
 ctrl_get_cfg_atv_agc_status(struct drx_demod_instance *demod,
-			    p_drxj_cfg_atv_agc_status_t agc_status)
+			    struct drxj_cfg_atv_agc_status *agc_status)
 {
 	struct i2c_device_addr *dev_addr = NULL;
 	u16 data = 0;
@@ -8728,7 +8728,7 @@ static int
 power_down_atv(struct drx_demod_instance *demod, enum drx_standard standard, bool primary)
 {
 	struct i2c_device_addr *dev_addr = demod->my_i2c_dev_addr;
-	drxjscu_cmd_t cmd_scu = { /* command      */ 0,
+	struct drxjscu_cmd cmd_scu = { /* command      */ 0,
 		/* parameter_len */ 0,
 		/* result_len    */ 0,
 		/* *parameter   */ NULL,
@@ -9043,7 +9043,7 @@ trouble ?
 	};
 
 	struct i2c_device_addr *dev_addr = NULL;
-	drxjscu_cmd_t cmd_scu = { /* command      */ 0,
+	struct drxjscu_cmd cmd_scu = { /* command      */ 0,
 		/* parameter_len */ 0,
 		/* result_len    */ 0,
 		/* *parameter   */ NULL,
@@ -9055,9 +9055,9 @@ trouble ?
 	struct drxu_code_info ucode_info;
 	struct drx_common_attr *common_attr = NULL;
 #endif /* DRXJ_SPLIT_UCODE_UPLOAD */
-	pdrxj_data_t ext_attr = NULL;
+	struct drxj_data *ext_attr = NULL;
 
-	ext_attr = (pdrxj_data_t) demod->my_ext_attr;
+	ext_attr = (struct drxj_data *) demod->my_ext_attr;
 	dev_addr = demod->my_i2c_dev_addr;
 
 #ifdef DRXJ_SPLIT_UCODE_UPLOAD
@@ -9402,18 +9402,18 @@ set_atv_channel(struct drx_demod_instance *demod,
 		s32 tuner_freq_offset,
 	      struct drx_channel *channel, enum drx_standard standard)
 {
-	drxjscu_cmd_t cmd_scu = { /* command      */ 0,
+	struct drxjscu_cmd cmd_scu = { /* command      */ 0,
 		/* parameter_len */ 0,
 		/* result_len    */ 0,
 		/* parameter    */ NULL,
 		/* result       */ NULL
 	};
 	u16 cmd_result = 0;
-	pdrxj_data_t ext_attr = NULL;
+	struct drxj_data *ext_attr = NULL;
 	struct i2c_device_addr *dev_addr = NULL;
 
 	dev_addr = demod->my_i2c_dev_addr;
-	ext_attr = (pdrxj_data_t) demod->my_ext_attr;
+	ext_attr = (struct drxj_data *) demod->my_ext_attr;
 
 	/*
 	   Program frequency shifter
@@ -9472,7 +9472,7 @@ get_atv_channel(struct drx_demod_instance *demod,
 	struct i2c_device_addr *dev_addr = demod->my_i2c_dev_addr;
 
 	/* Bandwidth */
-	channel->bandwidth = ((pdrxj_data_t) demod->my_ext_attr)->curr_bandwidth;
+	channel->bandwidth = ((struct drxj_data *) demod->my_ext_attr)->curr_bandwidth;
 
 	switch (standard) {
 	case DRX_STANDARD_NTSC:
@@ -9551,7 +9551,7 @@ static int
 get_atv_sig_strength(struct drx_demod_instance *demod, u16 *sig_strength)
 {
 	struct i2c_device_addr *dev_addr = NULL;
-	pdrxj_data_t ext_attr = NULL;
+	struct drxj_data *ext_attr = NULL;
 
 	/* All weights must add up to 100 (%)
 	   TODO: change weights when IF ctrl is available */
@@ -9574,7 +9574,7 @@ get_atv_sig_strength(struct drx_demod_instance *demod, u16 *sig_strength)
 	u32 if_strength = 0;	/* 0.. 100 */
 
 	dev_addr = demod->my_i2c_dev_addr;
-	ext_attr = (pdrxj_data_t) demod->my_ext_attr;
+	ext_attr = (struct drxj_data *) demod->my_ext_attr;
 
 	*sig_strength = 0;
 
@@ -9747,10 +9747,10 @@ rw_error:
 static int power_down_aud(struct drx_demod_instance *demod)
 {
 	struct i2c_device_addr *dev_addr = NULL;
-	pdrxj_data_t ext_attr = NULL;
+	struct drxj_data *ext_attr = NULL;
 
 	dev_addr = (struct i2c_device_addr *)demod->my_i2c_dev_addr;
-	ext_attr = (pdrxj_data_t) demod->my_ext_attr;
+	ext_attr = (struct drxj_data *) demod->my_ext_attr;
 
 	WR16(dev_addr, AUD_COMM_EXEC__A, AUD_COMM_EXEC_STOP);
 
@@ -9772,7 +9772,7 @@ rw_error:
 static int aud_get_modus(struct drx_demod_instance *demod, u16 *modus)
 {
 	struct i2c_device_addr *dev_addr = NULL;
-	pdrxj_data_t ext_attr = NULL;
+	struct drxj_data *ext_attr = NULL;
 
 	u16 r_modus = 0;
 	u16 r_modusHi = 0;
@@ -9783,7 +9783,7 @@ static int aud_get_modus(struct drx_demod_instance *demod, u16 *modus)
 	}
 
 	dev_addr = (struct i2c_device_addr *)demod->my_i2c_dev_addr;
-	ext_attr = (pdrxj_data_t) demod->my_ext_attr;
+	ext_attr = (struct drxj_data *) demod->my_ext_attr;
 
 	/* power up */
 	if (ext_attr->aud_data.audio_is_active == false) {
@@ -9817,7 +9817,7 @@ static int
 aud_ctrl_get_cfg_rds(struct drx_demod_instance *demod, struct drx_cfg_aud_rds *status)
 {
 	struct i2c_device_addr *addr = NULL;
-	pdrxj_data_t ext_attr = NULL;
+	struct drxj_data *ext_attr = NULL;
 
 	u16 r_rds_array_cnt_init = 0;
 	u16 r_rds_array_cnt_check = 0;
@@ -9825,7 +9825,7 @@ aud_ctrl_get_cfg_rds(struct drx_demod_instance *demod, struct drx_cfg_aud_rds *s
 	u16 rds_data_cnt = 0;
 
 	addr = (struct i2c_device_addr *)demod->my_i2c_dev_addr;
-	ext_attr = (pdrxj_data_t) demod->my_ext_attr;
+	ext_attr = (struct drxj_data *) demod->my_ext_attr;
 
 	if (status == NULL) {
 		return DRX_STS_INVALID_ARG;
@@ -9886,7 +9886,7 @@ rw_error:
 static int
 aud_ctrl_get_carrier_detect_status(struct drx_demod_instance *demod, struct drx_aud_status *status)
 {
-	pdrxj_data_t ext_attr = NULL;
+	struct drxj_data *ext_attr = NULL;
 	struct i2c_device_addr *dev_addr = NULL;
 
 	u16 r_data = 0;
@@ -9896,7 +9896,7 @@ aud_ctrl_get_carrier_detect_status(struct drx_demod_instance *demod, struct drx_
 	}
 
 	dev_addr = (struct i2c_device_addr *)demod->my_i2c_dev_addr;
-	ext_attr = (pdrxj_data_t) demod->my_ext_attr;
+	ext_attr = (struct drxj_data *) demod->my_ext_attr;
 
 	/* power up */
 	if (ext_attr->aud_data.audio_is_active == false) {
@@ -9964,7 +9964,7 @@ rw_error:
 static int
 aud_ctrl_get_status(struct drx_demod_instance *demod, struct drx_aud_status *status)
 {
-	pdrxj_data_t ext_attr = NULL;
+	struct drxj_data *ext_attr = NULL;
 	struct i2c_device_addr *dev_addr = NULL;
 	struct drx_cfg_aud_rds rds = { false, {0} };
 	u16 r_data = 0;
@@ -9974,7 +9974,7 @@ aud_ctrl_get_status(struct drx_demod_instance *demod, struct drx_aud_status *sta
 	}
 
 	dev_addr = (struct i2c_device_addr *)demod->my_i2c_dev_addr;
-	ext_attr = (pdrxj_data_t) demod->my_ext_attr;
+	ext_attr = (struct drxj_data *) demod->my_ext_attr;
 
 	/* carrier detection */
 	CHK_ERROR(aud_ctrl_get_carrier_detect_status(demod, status));
@@ -10005,7 +10005,7 @@ static int
 aud_ctrl_get_cfg_volume(struct drx_demod_instance *demod, struct drx_cfg_aud_volume *volume)
 {
 	struct i2c_device_addr *dev_addr = NULL;
-	pdrxj_data_t ext_attr = NULL;
+	struct drxj_data *ext_attr = NULL;
 
 	u16 r_volume = 0;
 	u16 r_avc = 0;
@@ -10017,7 +10017,7 @@ aud_ctrl_get_cfg_volume(struct drx_demod_instance *demod, struct drx_cfg_aud_vol
 	}
 
 	dev_addr = (struct i2c_device_addr *)demod->my_i2c_dev_addr;
-	ext_attr = (pdrxj_data_t) demod->my_ext_attr;
+	ext_attr = (struct drxj_data *) demod->my_ext_attr;
 
 	/* power up */
 	if (ext_attr->aud_data.audio_is_active == false) {
@@ -10138,7 +10138,7 @@ static int
 aud_ctrl_set_cfg_volume(struct drx_demod_instance *demod, struct drx_cfg_aud_volume *volume)
 {
 	struct i2c_device_addr *dev_addr = NULL;
-	pdrxj_data_t ext_attr = NULL;
+	struct drxj_data *ext_attr = NULL;
 
 	u16 w_volume = 0;
 	u16 w_avc = 0;
@@ -10148,7 +10148,7 @@ aud_ctrl_set_cfg_volume(struct drx_demod_instance *demod, struct drx_cfg_aud_vol
 	}
 
 	dev_addr = (struct i2c_device_addr *)demod->my_i2c_dev_addr;
-	ext_attr = (pdrxj_data_t) demod->my_ext_attr;
+	ext_attr = (struct drxj_data *) demod->my_ext_attr;
 
 	/* power up */
 	if (ext_attr->aud_data.audio_is_active == false) {
@@ -10272,7 +10272,7 @@ static int
 aud_ctrl_get_cfg_output_i2s(struct drx_demod_instance *demod, struct drx_cfg_i2s_output *output)
 {
 	struct i2c_device_addr *dev_addr = NULL;
-	pdrxj_data_t ext_attr = NULL;
+	struct drxj_data *ext_attr = NULL;
 
 	u16 w_i2s_config = 0;
 	u16 r_i2s_freq = 0;
@@ -10282,7 +10282,7 @@ aud_ctrl_get_cfg_output_i2s(struct drx_demod_instance *demod, struct drx_cfg_i2s
 	}
 
 	dev_addr = (struct i2c_device_addr *)demod->my_i2c_dev_addr;
-	ext_attr = (pdrxj_data_t) demod->my_ext_attr;
+	ext_attr = (struct drxj_data *) demod->my_ext_attr;
 
 	/* power up */
 	if (ext_attr->aud_data.audio_is_active == false) {
@@ -10374,7 +10374,7 @@ static int
 aud_ctrl_set_cfg_output_i2s(struct drx_demod_instance *demod, struct drx_cfg_i2s_output *output)
 {
 	struct i2c_device_addr *dev_addr = NULL;
-	pdrxj_data_t ext_attr = NULL;
+	struct drxj_data *ext_attr = NULL;
 
 	u16 w_i2s_config = 0;
 	u16 w_i2s_pads_data_da = 0;
@@ -10387,7 +10387,7 @@ aud_ctrl_set_cfg_output_i2s(struct drx_demod_instance *demod, struct drx_cfg_i2s
 	}
 
 	dev_addr = (struct i2c_device_addr *)demod->my_i2c_dev_addr;
-	ext_attr = (pdrxj_data_t) demod->my_ext_attr;
+	ext_attr = (struct drxj_data *) demod->my_ext_attr;
 
 	/* power up */
 	if (ext_attr->aud_data.audio_is_active == false) {
@@ -10529,13 +10529,13 @@ static int
 aud_ctrl_get_cfg_auto_sound(struct drx_demod_instance *demod,
 			    enum drx_cfg_aud_auto_sound *auto_sound)
 {
-	pdrxj_data_t ext_attr = NULL;
+	struct drxj_data *ext_attr = NULL;
 	u16 r_modus = 0;
 
 	if (auto_sound == NULL)
 		return DRX_STS_INVALID_ARG;
 
-	ext_attr = (pdrxj_data_t) demod->my_ext_attr;
+	ext_attr = (struct drxj_data *) demod->my_ext_attr;
 
 	/* power up */
 	if (ext_attr->aud_data.audio_is_active == false) {
@@ -10583,7 +10583,7 @@ aud_ctr_setl_cfg_auto_sound(struct drx_demod_instance *demod,
 			    enum drx_cfg_aud_auto_sound *auto_sound)
 {
 	struct i2c_device_addr *dev_addr = (struct i2c_device_addr *)NULL;
-	pdrxj_data_t ext_attr = (pdrxj_data_t) NULL;
+	struct drxj_data *ext_attr = (struct drxj_data *) NULL;
 
 	u16 r_modus = 0;
 	u16 w_modus = 0;
@@ -10593,7 +10593,7 @@ aud_ctr_setl_cfg_auto_sound(struct drx_demod_instance *demod,
 	}
 
 	dev_addr = demod->my_i2c_dev_addr;
-	ext_attr = (pdrxj_data_t) demod->my_ext_attr;
+	ext_attr = (struct drxj_data *) demod->my_ext_attr;
 
 	/* power up */
 	if (ext_attr->aud_data.audio_is_active == false) {
@@ -10648,7 +10648,7 @@ static int
 aud_ctrl_get_cfg_ass_thres(struct drx_demod_instance *demod, struct drx_cfg_aud_ass_thres *thres)
 {
 	struct i2c_device_addr *dev_addr = (struct i2c_device_addr *)NULL;
-	pdrxj_data_t ext_attr = (pdrxj_data_t) NULL;
+	struct drxj_data *ext_attr = (struct drxj_data *) NULL;
 
 	u16 thres_a2 = 0;
 	u16 thres_btsc = 0;
@@ -10659,7 +10659,7 @@ aud_ctrl_get_cfg_ass_thres(struct drx_demod_instance *demod, struct drx_cfg_aud_
 	}
 
 	dev_addr = demod->my_i2c_dev_addr;
-	ext_attr = (pdrxj_data_t) demod->my_ext_attr;
+	ext_attr = (struct drxj_data *) demod->my_ext_attr;
 
 	/* power up */
 	if (ext_attr->aud_data.audio_is_active == false) {
@@ -10692,14 +10692,14 @@ static int
 aud_ctrl_set_cfg_ass_thres(struct drx_demod_instance *demod, struct drx_cfg_aud_ass_thres *thres)
 {
 	struct i2c_device_addr *dev_addr = (struct i2c_device_addr *)NULL;
-	pdrxj_data_t ext_attr = (pdrxj_data_t) NULL;
+	struct drxj_data *ext_attr = (struct drxj_data *) NULL;
 
 	if (thres == NULL) {
 		return DRX_STS_INVALID_ARG;
 	}
 
 	dev_addr = demod->my_i2c_dev_addr;
-	ext_attr = (pdrxj_data_t) demod->my_ext_attr;
+	ext_attr = (struct drxj_data *) demod->my_ext_attr;
 
 	/* power up */
 	if (ext_attr->aud_data.audio_is_active == false) {
@@ -10730,7 +10730,7 @@ static int
 aud_ctrl_get_cfg_carrier(struct drx_demod_instance *demod, struct drx_cfg_aud_carriers *carriers)
 {
 	struct i2c_device_addr *dev_addr = (struct i2c_device_addr *)NULL;
-	pdrxj_data_t ext_attr = (pdrxj_data_t) NULL;
+	struct drxj_data *ext_attr = (struct drxj_data *) NULL;
 
 	u16 w_modus = 0;
 
@@ -10753,7 +10753,7 @@ aud_ctrl_get_cfg_carrier(struct drx_demod_instance *demod, struct drx_cfg_aud_ca
 	}
 
 	dev_addr = demod->my_i2c_dev_addr;
-	ext_attr = (pdrxj_data_t) demod->my_ext_attr;
+	ext_attr = (struct drxj_data *) demod->my_ext_attr;
 
 	/* power up */
 	if (ext_attr->aud_data.audio_is_active == false) {
@@ -10834,7 +10834,7 @@ static int
 aud_ctrl_set_cfg_carrier(struct drx_demod_instance *demod, struct drx_cfg_aud_carriers *carriers)
 {
 	struct i2c_device_addr *dev_addr = (struct i2c_device_addr *)NULL;
-	pdrxj_data_t ext_attr = (pdrxj_data_t) NULL;
+	struct drxj_data *ext_attr = (struct drxj_data *) NULL;
 
 	u16 w_modus = 0;
 	u16 r_modus = 0;
@@ -10852,7 +10852,7 @@ aud_ctrl_set_cfg_carrier(struct drx_demod_instance *demod, struct drx_cfg_aud_ca
 	}
 
 	dev_addr = demod->my_i2c_dev_addr;
-	ext_attr = (pdrxj_data_t) demod->my_ext_attr;
+	ext_attr = (struct drxj_data *) demod->my_ext_attr;
 
 	/* power up */
 	if (ext_attr->aud_data.audio_is_active == false) {
@@ -10934,7 +10934,7 @@ static int
 aud_ctrl_get_cfg_mixer(struct drx_demod_instance *demod, struct drx_cfg_aud_mixer *mixer)
 {
 	struct i2c_device_addr *dev_addr = (struct i2c_device_addr *)NULL;
-	pdrxj_data_t ext_attr = (pdrxj_data_t) NULL;
+	struct drxj_data *ext_attr = (struct drxj_data *) NULL;
 
 	u16 src_i2s_matr = 0;
 	u16 fm_matr = 0;
@@ -10944,7 +10944,7 @@ aud_ctrl_get_cfg_mixer(struct drx_demod_instance *demod, struct drx_cfg_aud_mixe
 	}
 
 	dev_addr = demod->my_i2c_dev_addr;
-	ext_attr = (pdrxj_data_t) demod->my_ext_attr;
+	ext_attr = (struct drxj_data *) demod->my_ext_attr;
 
 	/* power up */
 	if (ext_attr->aud_data.audio_is_active == false) {
@@ -11029,7 +11029,7 @@ static int
 aud_ctrl_set_cfg_mixer(struct drx_demod_instance *demod, struct drx_cfg_aud_mixer *mixer)
 {
 	struct i2c_device_addr *dev_addr = (struct i2c_device_addr *)NULL;
-	pdrxj_data_t ext_attr = (pdrxj_data_t) NULL;
+	struct drxj_data *ext_attr = (struct drxj_data *) NULL;
 
 	u16 src_i2s_matr = 0;
 	u16 fm_matr = 0;
@@ -11039,7 +11039,7 @@ aud_ctrl_set_cfg_mixer(struct drx_demod_instance *demod, struct drx_cfg_aud_mixe
 	}
 
 	dev_addr = demod->my_i2c_dev_addr;
-	ext_attr = (pdrxj_data_t) demod->my_ext_attr;
+	ext_attr = (struct drxj_data *) demod->my_ext_attr;
 
 	/* power up */
 	if (ext_attr->aud_data.audio_is_active == false) {
@@ -11137,7 +11137,7 @@ static int
 aud_ctrl_set_cfg_av_sync(struct drx_demod_instance *demod, enum drx_cfg_aud_av_sync *av_sync)
 {
 	struct i2c_device_addr *dev_addr = (struct i2c_device_addr *)NULL;
-	pdrxj_data_t ext_attr = (pdrxj_data_t) NULL;
+	struct drxj_data *ext_attr = (struct drxj_data *) NULL;
 
 	u16 w_aud_vid_sync = 0;
 
@@ -11146,7 +11146,7 @@ aud_ctrl_set_cfg_av_sync(struct drx_demod_instance *demod, enum drx_cfg_aud_av_s
 	}
 
 	dev_addr = demod->my_i2c_dev_addr;
-	ext_attr = (pdrxj_data_t) demod->my_ext_attr;
+	ext_attr = (struct drxj_data *) demod->my_ext_attr;
 
 	/* power up */
 	if (ext_attr->aud_data.audio_is_active == false) {
@@ -11202,7 +11202,7 @@ static int
 aud_ctrl_get_cfg_av_sync(struct drx_demod_instance *demod, enum drx_cfg_aud_av_sync *av_sync)
 {
 	struct i2c_device_addr *dev_addr = (struct i2c_device_addr *)NULL;
-	pdrxj_data_t ext_attr = (pdrxj_data_t) NULL;
+	struct drxj_data *ext_attr = (struct drxj_data *) NULL;
 
 	u16 w_aud_vid_sync = 0;
 
@@ -11211,7 +11211,7 @@ aud_ctrl_get_cfg_av_sync(struct drx_demod_instance *demod, enum drx_cfg_aud_av_s
 	}
 
 	dev_addr = demod->my_i2c_dev_addr;
-	ext_attr = (pdrxj_data_t) demod->my_ext_attr;
+	ext_attr = (struct drxj_data *) demod->my_ext_attr;
 
 	/* power up */
 	if (ext_attr->aud_data.audio_is_active == false) {
@@ -11291,7 +11291,7 @@ static int
 aud_ctrl_set_cfg_dev(struct drx_demod_instance *demod, enum drx_cfg_aud_deviation *dev)
 {
 	struct i2c_device_addr *dev_addr = (struct i2c_device_addr *)NULL;
-	pdrxj_data_t ext_attr = (pdrxj_data_t) NULL;
+	struct drxj_data *ext_attr = (struct drxj_data *) NULL;
 
 	u16 w_modus = 0;
 	u16 r_modus = 0;
@@ -11300,7 +11300,7 @@ aud_ctrl_set_cfg_dev(struct drx_demod_instance *demod, enum drx_cfg_aud_deviatio
 		return DRX_STS_INVALID_ARG;
 	}
 
-	ext_attr = (pdrxj_data_t) demod->my_ext_attr;
+	ext_attr = (struct drxj_data *) demod->my_ext_attr;
 	dev_addr = demod->my_i2c_dev_addr;
 
 	CHK_ERROR(aud_get_modus(demod, &r_modus));
@@ -11343,7 +11343,7 @@ static int
 aud_ctrl_get_cfg_prescale(struct drx_demod_instance *demod, struct drx_cfg_aud_prescale *presc)
 {
 	struct i2c_device_addr *dev_addr = (struct i2c_device_addr *)NULL;
-	pdrxj_data_t ext_attr = (pdrxj_data_t) NULL;
+	struct drxj_data *ext_attr = (struct drxj_data *) NULL;
 
 	u16 r_max_fm_deviation = 0;
 	u16 r_nicam_prescaler = 0;
@@ -11353,7 +11353,7 @@ aud_ctrl_get_cfg_prescale(struct drx_demod_instance *demod, struct drx_cfg_aud_p
 	}
 
 	dev_addr = demod->my_i2c_dev_addr;
-	ext_attr = (pdrxj_data_t) demod->my_ext_attr;
+	ext_attr = (struct drxj_data *) demod->my_ext_attr;
 
 	/* power up */
 	if (ext_attr->aud_data.audio_is_active == false) {
@@ -11417,7 +11417,7 @@ static int
 aud_ctrl_set_cfg_prescale(struct drx_demod_instance *demod, struct drx_cfg_aud_prescale *presc)
 {
 	struct i2c_device_addr *dev_addr = (struct i2c_device_addr *)NULL;
-	pdrxj_data_t ext_attr = (pdrxj_data_t) NULL;
+	struct drxj_data *ext_attr = (struct drxj_data *) NULL;
 
 	u16 w_max_fm_deviation = 0;
 	u16 nicam_prescaler;
@@ -11427,7 +11427,7 @@ aud_ctrl_set_cfg_prescale(struct drx_demod_instance *demod, struct drx_cfg_aud_p
 	}
 
 	dev_addr = demod->my_i2c_dev_addr;
-	ext_attr = (pdrxj_data_t) demod->my_ext_attr;
+	ext_attr = (struct drxj_data *) demod->my_ext_attr;
 
 	/* power up */
 	if (ext_attr->aud_data.audio_is_active == false) {
@@ -11498,7 +11498,7 @@ rw_error:
 static int aud_ctrl_beep(struct drx_demod_instance *demod, struct drx_aud_beep *beep)
 {
 	struct i2c_device_addr *dev_addr = (struct i2c_device_addr *)NULL;
-	pdrxj_data_t ext_attr = (pdrxj_data_t) NULL;
+	struct drxj_data *ext_attr = (struct drxj_data *) NULL;
 
 	u16 the_beep = 0;
 	u16 volume = 0;
@@ -11509,7 +11509,7 @@ static int aud_ctrl_beep(struct drx_demod_instance *demod, struct drx_aud_beep *
 	}
 
 	dev_addr = demod->my_i2c_dev_addr;
-	ext_attr = (pdrxj_data_t) demod->my_ext_attr;
+	ext_attr = (struct drxj_data *) demod->my_ext_attr;
 
 	/* power up */
 	if (ext_attr->aud_data.audio_is_active == false) {
@@ -11556,7 +11556,7 @@ static int
 aud_ctrl_set_standard(struct drx_demod_instance *demod, enum drx_aud_standard *standard)
 {
 	struct i2c_device_addr *dev_addr = NULL;
-	pdrxj_data_t ext_attr = NULL;
+	struct drxj_data *ext_attr = NULL;
 	enum drx_standard current_standard = DRX_STANDARD_UNKNOWN;
 
 	u16 w_standard = 0;
@@ -11572,7 +11572,7 @@ aud_ctrl_set_standard(struct drx_demod_instance *demod, enum drx_aud_standard *s
 	}
 
 	dev_addr = (struct i2c_device_addr *)demod->my_i2c_dev_addr;
-	ext_attr = (pdrxj_data_t) demod->my_ext_attr;
+	ext_attr = (struct drxj_data *) demod->my_ext_attr;
 
 	/* power up */
 	if (ext_attr->aud_data.audio_is_active == false) {
@@ -11733,7 +11733,7 @@ static int
 aud_ctrl_get_standard(struct drx_demod_instance *demod, enum drx_aud_standard *standard)
 {
 	struct i2c_device_addr *dev_addr = NULL;
-	pdrxj_data_t ext_attr = NULL;
+	struct drxj_data *ext_attr = NULL;
 
 	u16 r_data = 0;
 
@@ -11741,7 +11741,7 @@ aud_ctrl_get_standard(struct drx_demod_instance *demod, enum drx_aud_standard *s
 		return DRX_STS_INVALID_ARG;
 	}
 
-	ext_attr = (pdrxj_data_t) demod->my_ext_attr;
+	ext_attr = (struct drxj_data *) demod->my_ext_attr;
 	dev_addr = (struct i2c_device_addr *)demod->my_i2c_dev_addr;
 
 	/* power up */
@@ -11912,7 +11912,7 @@ static int
 get_oob_lock_status(struct drx_demod_instance *demod,
 		    struct i2c_device_addr *dev_addr, enum drx_lock_status *oob_lock)
 {
-	drxjscu_cmd_t scu_cmd;
+	struct drxjscu_cmd scu_cmd;
 	u16 cmd_result[2];
 	u16 oob_lock_state;
 
@@ -12385,11 +12385,11 @@ static int ctrl_set_oob(struct drx_demod_instance *demod, struct drxoob *oob_par
 #ifndef DRXJ_DIGITAL_ONLY
 	s32 freq = 0;	/* KHz */
 	struct i2c_device_addr *dev_addr = NULL;
-	pdrxj_data_t ext_attr = NULL;
+	struct drxj_data *ext_attr = NULL;
 	u16 i = 0;
 	bool mirror_freq_spectOOB = false;
 	u16 trk_filter_value = 0;
-	drxjscu_cmd_t scu_cmd;
+	struct drxjscu_cmd scu_cmd;
 	u16 set_param_parameters[3];
 	u16 cmd_result[2] = { 0, 0 };
 	s16 nyquist_coeffs[4][(NYQFILTERLEN + 1) / 2] = {
@@ -12408,7 +12408,7 @@ static int ctrl_set_oob(struct drx_demod_instance *demod, struct drxoob *oob_par
 	u16 mode_index;
 
 	dev_addr = demod->my_i2c_dev_addr;
-	ext_attr = (pdrxj_data_t) demod->my_ext_attr;
+	ext_attr = (struct drxj_data *) demod->my_ext_attr;
 	mirror_freq_spectOOB = ext_attr->mirror_freq_spectOOB;
 
 	/* Check parameters */
@@ -12657,11 +12657,11 @@ ctrl_get_oob(struct drx_demod_instance *demod, struct drxoob_status *oob_status)
 {
 #ifndef DRXJ_DIGITAL_ONLY
 	struct i2c_device_addr *dev_addr = NULL;
-	pdrxj_data_t ext_attr = NULL;
+	struct drxj_data *ext_attr = NULL;
 	u16 data = 0;
 
 	dev_addr = demod->my_i2c_dev_addr;
-	ext_attr = (pdrxj_data_t) demod->my_ext_attr;
+	ext_attr = (struct drxj_data *) demod->my_ext_attr;
 
 	/* check arguments */
 	if (oob_status == NULL) {
@@ -12700,13 +12700,13 @@ static int
 ctrl_set_cfg_oob_pre_saw(struct drx_demod_instance *demod, u16 *cfg_data)
 {
 	struct i2c_device_addr *dev_addr = NULL;
-	pdrxj_data_t ext_attr = NULL;
+	struct drxj_data *ext_attr = NULL;
 
 	if (cfg_data == NULL) {
 		return (DRX_STS_INVALID_ARG);
 	}
 	dev_addr = demod->my_i2c_dev_addr;
-	ext_attr = (pdrxj_data_t) demod->my_ext_attr;
+	ext_attr = (struct drxj_data *) demod->my_ext_attr;
 
 	WR16(dev_addr, ORX_NSU_AOX_STHR_W__A, *cfg_data);
 	ext_attr->oob_pre_saw = *cfg_data;
@@ -12726,12 +12726,12 @@ rw_error:
 static int
 ctrl_get_cfg_oob_pre_saw(struct drx_demod_instance *demod, u16 *cfg_data)
 {
-	pdrxj_data_t ext_attr = NULL;
+	struct drxj_data *ext_attr = NULL;
 
 	if (cfg_data == NULL) {
 		return (DRX_STS_INVALID_ARG);
 	}
-	ext_attr = (pdrxj_data_t) demod->my_ext_attr;
+	ext_attr = (struct drxj_data *) demod->my_ext_attr;
 
 	*cfg_data = ext_attr->oob_pre_saw;
 
@@ -12742,21 +12742,20 @@ ctrl_get_cfg_oob_pre_saw(struct drx_demod_instance *demod, u16 *cfg_data)
 /**
 * \fn int ctrl_set_cfg_oob_lo_power()
 * \brief Configure LO Power value
-* \param cfg_data Pointer to p_drxj_cfg_oob_lo_power_t
-* \return Error code
+* \param cfg_data Pointer to enum drxj_cfg_oob_lo_power ** \return Error code
 */
 #ifndef DRXJ_DIGITAL_ONLY
 static int
-ctrl_set_cfg_oob_lo_power(struct drx_demod_instance *demod, p_drxj_cfg_oob_lo_power_t cfg_data)
+ctrl_set_cfg_oob_lo_power(struct drx_demod_instance *demod, enum drxj_cfg_oob_lo_power *cfg_data)
 {
 	struct i2c_device_addr *dev_addr = NULL;
-	pdrxj_data_t ext_attr = NULL;
+	struct drxj_data *ext_attr = NULL;
 
 	if (cfg_data == NULL) {
 		return (DRX_STS_INVALID_ARG);
 	}
 	dev_addr = demod->my_i2c_dev_addr;
-	ext_attr = (pdrxj_data_t) demod->my_ext_attr;
+	ext_attr = (struct drxj_data *) demod->my_ext_attr;
 
 	WR16(dev_addr, ORX_NSU_AOX_LOPOW_W__A, *cfg_data);
 	ext_attr->oob_lo_pow = *cfg_data;
@@ -12769,19 +12768,18 @@ rw_error:
 /**
 * \fn int ctrl_get_cfg_oob_lo_power()
 * \brief Configure LO Power value
-* \param cfg_data Pointer to p_drxj_cfg_oob_lo_power_t
-* \return Error code
+* \param cfg_data Pointer to enum drxj_cfg_oob_lo_power ** \return Error code
 */
 #ifndef DRXJ_DIGITAL_ONLY
 static int
-ctrl_get_cfg_oob_lo_power(struct drx_demod_instance *demod, p_drxj_cfg_oob_lo_power_t cfg_data)
+ctrl_get_cfg_oob_lo_power(struct drx_demod_instance *demod, enum drxj_cfg_oob_lo_power *cfg_data)
 {
-	pdrxj_data_t ext_attr = NULL;
+	struct drxj_data *ext_attr = NULL;
 
 	if (cfg_data == NULL) {
 		return (DRX_STS_INVALID_ARG);
 	}
-	ext_attr = (pdrxj_data_t) demod->my_ext_attr;
+	ext_attr = (struct drxj_data *) demod->my_ext_attr;
 
 	*cfg_data = ext_attr->oob_lo_pow;
 
@@ -12818,7 +12816,7 @@ ctrl_set_channel(struct drx_demod_instance *demod, struct drx_channel *channel)
 	s32 tuner_get_freq = 0;
 	s32 tuner_freq_offset = 0;
 	s32 intermediate_freq = 0;
-	pdrxj_data_t ext_attr = NULL;
+	struct drxj_data *ext_attr = NULL;
 	struct i2c_device_addr *dev_addr = NULL;
 	enum drx_standard standard = DRX_STANDARD_UNKNOWN;
 	u32 tuner_mode = 0;
@@ -12837,7 +12835,7 @@ ctrl_set_channel(struct drx_demod_instance *demod, struct drx_channel *channel)
 
 	common_attr = (struct drx_common_attr *) demod->my_common_attr;
 	dev_addr = demod->my_i2c_dev_addr;
-	ext_attr = (pdrxj_data_t) demod->my_ext_attr;
+	ext_attr = (struct drxj_data *) demod->my_ext_attr;
 	standard = ext_attr->standard;
 
 	/* check valid standards */
@@ -13196,7 +13194,7 @@ static int
 ctrl_get_channel(struct drx_demod_instance *demod, struct drx_channel *channel)
 {
 	struct i2c_device_addr *dev_addr = NULL;
-	pdrxj_data_t ext_attr = NULL;
+	struct drxj_data *ext_attr = NULL;
 	enum drx_lock_status lock_status = DRX_NOT_LOCKED;
 	enum drx_standard standard = DRX_STANDARD_UNKNOWN;
 	struct drx_common_attr *common_attr = NULL;
@@ -13215,7 +13213,7 @@ ctrl_get_channel(struct drx_demod_instance *demod, struct drx_channel *channel)
 	}
 
 	dev_addr = demod->my_i2c_dev_addr;
-	ext_attr = (pdrxj_data_t) demod->my_ext_attr;
+	ext_attr = (struct drxj_data *) demod->my_ext_attr;
 	standard = ext_attr->standard;
 	common_attr = (struct drx_common_attr *) demod->my_common_attr;
 
@@ -13323,7 +13321,7 @@ ctrl_get_channel(struct drx_demod_instance *demod, struct drx_channel *channel)
 				}	/* if (standard == DRX_STANDARD_ITU_B) */
 
 				{
-					drxjscu_cmd_t cmd_scu =
+					struct drxjscu_cmd cmd_scu =
 					    { /* command      */ 0,
 						/* parameter_len */ 0,
 						/* result_len    */ 0,
@@ -13447,7 +13445,7 @@ static int
 ctrl_sig_quality(struct drx_demod_instance *demod, struct drx_sig_quality *sig_quality)
 {
 	struct i2c_device_addr *dev_addr = NULL;
-	pdrxj_data_t ext_attr = NULL;
+	struct drxj_data *ext_attr = NULL;
 	enum drx_standard standard = DRX_STANDARD_UNKNOWN;
 	enum drx_lock_status lock_status = DRX_NOT_LOCKED;
 	u16 min_mer = 0;
@@ -13459,7 +13457,7 @@ ctrl_sig_quality(struct drx_demod_instance *demod, struct drx_sig_quality *sig_q
 		return (DRX_STS_INVALID_ARG);
 	}
 
-	ext_attr = (pdrxj_data_t) demod->my_ext_attr;
+	ext_attr = (struct drxj_data *) demod->my_ext_attr;
 	standard = ext_attr->standard;
 
 	/* get basic information */
@@ -13581,9 +13579,9 @@ static int
 ctrl_lock_status(struct drx_demod_instance *demod, enum drx_lock_status *lock_stat)
 {
 	enum drx_standard standard = DRX_STANDARD_UNKNOWN;
-	pdrxj_data_t ext_attr = NULL;
+	struct drxj_data *ext_attr = NULL;
 	struct i2c_device_addr *dev_addr = NULL;
-	drxjscu_cmd_t cmd_scu = { /* command      */ 0,
+	struct drxjscu_cmd cmd_scu = { /* command      */ 0,
 		/* parameter_len */ 0,
 		/* result_len    */ 0,
 		/* *parameter   */ NULL,
@@ -13598,7 +13596,7 @@ ctrl_lock_status(struct drx_demod_instance *demod, enum drx_lock_status *lock_st
 	}
 
 	dev_addr = demod->my_i2c_dev_addr;
-	ext_attr = (pdrxj_data_t) demod->my_ext_attr;
+	ext_attr = (struct drxj_data *) demod->my_ext_attr;
 	standard = ext_attr->standard;
 
 	*lock_stat = DRX_NOT_LOCKED;
@@ -13686,7 +13684,7 @@ ctrl_constel(struct drx_demod_instance *demod, struct drx_complex *complex_nr)
 	}
 
 	/* read device info */
-	standard = ((pdrxj_data_t) demod->my_ext_attr)->standard;
+	standard = ((struct drxj_data *) demod->my_ext_attr)->standard;
 
 	/* Read constellation point  */
 	switch (standard) {
@@ -13725,7 +13723,7 @@ rw_error:
 static int
 ctrl_set_standard(struct drx_demod_instance *demod, enum drx_standard *standard)
 {
-	pdrxj_data_t ext_attr = NULL;
+	struct drxj_data *ext_attr = NULL;
 	enum drx_standard prev_standard;
 
 	/* check arguments */
@@ -13733,7 +13731,7 @@ ctrl_set_standard(struct drx_demod_instance *demod, enum drx_standard *standard)
 		return (DRX_STS_INVALID_ARG);
 	}
 
-	ext_attr = (pdrxj_data_t) demod->my_ext_attr;
+	ext_attr = (struct drxj_data *) demod->my_ext_attr;
 	prev_standard = ext_attr->standard;
 
 	/*
@@ -13825,8 +13823,8 @@ rw_error:
 static int
 ctrl_get_standard(struct drx_demod_instance *demod, enum drx_standard *standard)
 {
-	pdrxj_data_t ext_attr = NULL;
-	ext_attr = (pdrxj_data_t) demod->my_ext_attr;
+	struct drxj_data *ext_attr = NULL;
+	ext_attr = (struct drxj_data *) demod->my_ext_attr;
 
 	/* check arguments */
 	if (standard == NULL) {
@@ -13853,13 +13851,13 @@ static int
 ctrl_get_cfg_symbol_clock_offset(struct drx_demod_instance *demod, s32 *rate_offset)
 {
 	enum drx_standard standard = DRX_STANDARD_UNKNOWN;
-	pdrxj_data_t ext_attr = NULL;
+	struct drxj_data *ext_attr = NULL;
 
 	/* check arguments */
 	if (rate_offset == NULL)
 		return (DRX_STS_INVALID_ARG);
 
-	ext_attr = (pdrxj_data_t) demod->my_ext_attr;
+	ext_attr = (struct drxj_data *) demod->my_ext_attr;
 	standard = ext_attr->standard;
 
 	switch (standard) {
@@ -13900,12 +13898,12 @@ static int
 ctrl_power_mode(struct drx_demod_instance *demod, enum drx_power_mode *mode)
 {
 	struct drx_common_attr *common_attr = (struct drx_common_attr *) NULL;
-	pdrxj_data_t ext_attr = (pdrxj_data_t) NULL;
+	struct drxj_data *ext_attr = (struct drxj_data *) NULL;
 	struct i2c_device_addr *dev_addr = (struct i2c_device_addr *)NULL;
 	u16 sio_cc_pwd_mode = 0;
 
 	common_attr = (struct drx_common_attr *) demod->my_common_attr;
-	ext_attr = (pdrxj_data_t) demod->my_ext_attr;
+	ext_attr = (struct drxj_data *) demod->my_ext_attr;
 	dev_addr = demod->my_i2c_dev_addr;
 
 	/* Check arguments */
@@ -14027,7 +14025,7 @@ rw_error:
 static int
 ctrl_version(struct drx_demod_instance *demod, struct drx_version_list **version_list)
 {
-	pdrxj_data_t ext_attr = (pdrxj_data_t) (NULL);
+	struct drxj_data *ext_attr = (struct drxj_data *) (NULL);
 	struct i2c_device_addr *dev_addr = (struct i2c_device_addr *)(NULL);
 	struct drx_common_attr *common_attr = (struct drx_common_attr *) (NULL);
 	u16 ucode_major_minor = 0;	/* BCD Ma:Ma:Ma:Mi */
@@ -14046,7 +14044,7 @@ ctrl_version(struct drx_demod_instance *demod, struct drx_version_list **version
 	static char device_name[] = "Device";
 
 	dev_addr = demod->my_i2c_dev_addr;
-	ext_attr = (pdrxj_data_t) demod->my_ext_attr;
+	ext_attr = (struct drxj_data *) demod->my_ext_attr;
 	common_attr = (struct drx_common_attr *) demod->my_common_attr;
 
 	/* Microcode version *************************************** */
@@ -14282,10 +14280,10 @@ ctrl_u_codeUpload(struct drx_demod_instance *demod,
 	u16 mc_magic_word = 0;
 	u8 *mc_data = (u8 *)(NULL);
 	struct i2c_device_addr *dev_addr = (struct i2c_device_addr *)(NULL);
-	pdrxj_data_t ext_attr = (pdrxj_data_t) (NULL);
+	struct drxj_data *ext_attr = (struct drxj_data *) (NULL);
 
 	dev_addr = demod->my_i2c_dev_addr;
-	ext_attr = (pdrxj_data_t) demod->my_ext_attr;
+	ext_attr = (struct drxj_data *) demod->my_ext_attr;
 
 	/* Check arguments */
 	if ((mc_info == NULL) ||
@@ -14456,7 +14454,7 @@ ctrl_u_codeUpload(struct drx_demod_instance *demod,
 static int
 ctrl_sig_strength(struct drx_demod_instance *demod, u16 *sig_strength)
 {
-	pdrxj_data_t ext_attr = NULL;
+	struct drxj_data *ext_attr = NULL;
 	enum drx_standard standard = DRX_STANDARD_UNKNOWN;
 
 	/* Check arguments */
@@ -14464,7 +14462,7 @@ ctrl_sig_strength(struct drx_demod_instance *demod, u16 *sig_strength)
 		return (DRX_STS_INVALID_ARG);
 	}
 
-	ext_attr = (pdrxj_data_t) demod->my_ext_attr;
+	ext_attr = (struct drxj_data *) demod->my_ext_attr;
 	standard = ext_attr->standard;
 	*sig_strength = 0;
 
@@ -14505,13 +14503,13 @@ rw_error:
 /**
 * \fn int ctrl_get_cfg_oob_misc()
 * \brief Get current state information of OOB.
-* \param pointer to drxj_cfg_oob_misc_t.
+* \param pointer to struct drxj_cfg_oob_misc.
 * \return int.
 *
 */
 #ifndef DRXJ_DIGITAL_ONLY
 static int
-ctrl_get_cfg_oob_misc(struct drx_demod_instance *demod, p_drxj_cfg_oob_misc_t misc)
+ctrl_get_cfg_oob_misc(struct drx_demod_instance *demod, struct drxj_cfg_oob_misc *misc)
 {
 	struct i2c_device_addr *dev_addr = NULL;
 	u16 lock = 0U;
@@ -14558,12 +14556,12 @@ rw_error:
 /**
 * \fn int ctrl_get_cfg_vsb_misc()
 * \brief Get current state information of OOB.
-* \param pointer to drxj_cfg_oob_misc_t.
+* \param pointer to struct drxj_cfg_oob_misc.
 * \return int.
 *
 */
 static int
-ctrl_get_cfg_vsb_misc(struct drx_demod_instance *demod, p_drxj_cfg_vsb_misc_t misc)
+ctrl_get_cfg_vsb_misc(struct drx_demod_instance *demod, struct drxj_cfg_vsb_misc *misc)
 {
 	struct i2c_device_addr *dev_addr = NULL;
 
@@ -14594,7 +14592,7 @@ rw_error:
 *
 */
 static int
-ctrl_set_cfg_agc_if(struct drx_demod_instance *demod, p_drxj_cfg_agc_t agc_settings)
+ctrl_set_cfg_agc_if(struct drx_demod_instance *demod, struct drxj_cfg_agc *agc_settings)
 {
 	/* check arguments */
 	if (agc_settings == NULL) {
@@ -14650,7 +14648,7 @@ ctrl_set_cfg_agc_if(struct drx_demod_instance *demod, p_drxj_cfg_agc_t agc_setti
 *
 */
 static int
-ctrl_get_cfg_agc_if(struct drx_demod_instance *demod, p_drxj_cfg_agc_t agc_settings)
+ctrl_get_cfg_agc_if(struct drx_demod_instance *demod, struct drxj_cfg_agc *agc_settings)
 {
 	/* check arguments */
 	if (agc_settings == NULL) {
@@ -14697,7 +14695,7 @@ ctrl_get_cfg_agc_if(struct drx_demod_instance *demod, p_drxj_cfg_agc_t agc_setti
 *
 */
 static int
-ctrl_set_cfg_agc_rf(struct drx_demod_instance *demod, p_drxj_cfg_agc_t agc_settings)
+ctrl_set_cfg_agc_rf(struct drx_demod_instance *demod, struct drxj_cfg_agc *agc_settings)
 {
 	/* check arguments */
 	if (agc_settings == NULL) {
@@ -14753,7 +14751,7 @@ ctrl_set_cfg_agc_rf(struct drx_demod_instance *demod, p_drxj_cfg_agc_t agc_setti
 *
 */
 static int
-ctrl_get_cfg_agc_rf(struct drx_demod_instance *demod, p_drxj_cfg_agc_t agc_settings)
+ctrl_get_cfg_agc_rf(struct drx_demod_instance *demod, struct drxj_cfg_agc *agc_settings)
 {
 	/* check arguments */
 	if (agc_settings == NULL) {
@@ -14804,7 +14802,7 @@ ctrl_get_cfg_agc_internal(struct drx_demod_instance *demod, u16 *agc_internal)
 {
 	struct i2c_device_addr *dev_addr = NULL;
 	enum drx_lock_status lock_status = DRX_NOT_LOCKED;
-	pdrxj_data_t ext_attr = NULL;
+	struct drxj_data *ext_attr = NULL;
 	u16 iqm_cf_scale_sh = 0;
 	u16 iqm_cf_power = 0;
 	u16 iqm_cf_amp = 0;
@@ -14815,7 +14813,7 @@ ctrl_get_cfg_agc_internal(struct drx_demod_instance *demod, u16 *agc_internal)
 		return (DRX_STS_INVALID_ARG);
 	}
 	dev_addr = demod->my_i2c_dev_addr;
-	ext_attr = (pdrxj_data_t) demod->my_ext_attr;
+	ext_attr = (struct drxj_data *) demod->my_ext_attr;
 
 	CHK_ERROR(ctrl_lock_status(demod, &lock_status));
 	if (lock_status != DRXJ_DEMOD_LOCK && lock_status != DRX_LOCKED) {
@@ -14883,13 +14881,13 @@ rw_error:
 *
 */
 static int
-ctrl_set_cfg_pre_saw(struct drx_demod_instance *demod, p_drxj_cfg_pre_saw_t pre_saw)
+ctrl_set_cfg_pre_saw(struct drx_demod_instance *demod, struct drxj_cfg_pre_saw *pre_saw)
 {
 	struct i2c_device_addr *dev_addr = NULL;
-	pdrxj_data_t ext_attr = NULL;
+	struct drxj_data *ext_attr = NULL;
 
 	dev_addr = demod->my_i2c_dev_addr;
-	ext_attr = (pdrxj_data_t) demod->my_ext_attr;
+	ext_attr = (struct drxj_data *) demod->my_ext_attr;
 
 	/* check arguments */
 	if ((pre_saw == NULL) || (pre_saw->reference > IQM_AF_PDREF__M)
@@ -14952,10 +14950,10 @@ rw_error:
 *
 */
 static int
-ctrl_set_cfg_afe_gain(struct drx_demod_instance *demod, p_drxj_cfg_afe_gain_t afe_gain)
+ctrl_set_cfg_afe_gain(struct drx_demod_instance *demod, struct drxj_cfg_afe_gain *afe_gain)
 {
 	struct i2c_device_addr *dev_addr = NULL;
-	pdrxj_data_t ext_attr = NULL;
+	struct drxj_data *ext_attr = NULL;
 	u8 gain = 0;
 
 	/* check arguments */
@@ -14964,7 +14962,7 @@ ctrl_set_cfg_afe_gain(struct drx_demod_instance *demod, p_drxj_cfg_afe_gain_t af
 	}
 
 	dev_addr = demod->my_i2c_dev_addr;
-	ext_attr = (pdrxj_data_t) demod->my_ext_attr;
+	ext_attr = (struct drxj_data *) demod->my_ext_attr;
 
 	switch (afe_gain->standard) {
 	case DRX_STANDARD_8VSB:	/* fallthrough */
@@ -15028,15 +15026,15 @@ rw_error:
 *
 */
 static int
-ctrl_get_cfg_pre_saw(struct drx_demod_instance *demod, p_drxj_cfg_pre_saw_t pre_saw)
+ctrl_get_cfg_pre_saw(struct drx_demod_instance *demod, struct drxj_cfg_pre_saw *pre_saw)
 {
-	pdrxj_data_t ext_attr = NULL;
+	struct drxj_data *ext_attr = NULL;
 
 	/* check arguments */
 	if (pre_saw == NULL)
 		return (DRX_STS_INVALID_ARG);
 
-	ext_attr = (pdrxj_data_t) demod->my_ext_attr;
+	ext_attr = (struct drxj_data *) demod->my_ext_attr;
 
 	switch (pre_saw->standard) {
 	case DRX_STANDARD_8VSB:
@@ -15085,9 +15083,9 @@ ctrl_get_cfg_pre_saw(struct drx_demod_instance *demod, p_drxj_cfg_pre_saw_t pre_
 *
 */
 static int
-ctrl_get_cfg_afe_gain(struct drx_demod_instance *demod, p_drxj_cfg_afe_gain_t afe_gain)
+ctrl_get_cfg_afe_gain(struct drx_demod_instance *demod, struct drxj_cfg_afe_gain *afe_gain)
 {
-	pdrxj_data_t ext_attr = NULL;
+	struct drxj_data *ext_attr = NULL;
 
 	/* check arguments */
 	if (afe_gain == NULL)
@@ -15192,18 +15190,18 @@ static int ctrl_set_cfg(struct drx_demod_instance *demod, struct drx_cfg *config
 	case DRX_CFG_PINS_SAFE_MODE:
 		return ctrl_set_cfg_pdr_safe_mode(demod, (bool *)config->cfg_data);
 	case DRXJ_CFG_AGC_RF:
-		return ctrl_set_cfg_agc_rf(demod, (p_drxj_cfg_agc_t) config->cfg_data);
+		return ctrl_set_cfg_agc_rf(demod, (struct drxj_cfg_agc *) config->cfg_data);
 	case DRXJ_CFG_AGC_IF:
-		return ctrl_set_cfg_agc_if(demod, (p_drxj_cfg_agc_t) config->cfg_data);
+		return ctrl_set_cfg_agc_if(demod, (struct drxj_cfg_agc *) config->cfg_data);
 	case DRXJ_CFG_PRE_SAW:
 		return ctrl_set_cfg_pre_saw(demod,
-					(p_drxj_cfg_pre_saw_t) config->cfg_data);
+					(struct drxj_cfg_pre_saw *) config->cfg_data);
 	case DRXJ_CFG_AFE_GAIN:
 		return ctrl_set_cfg_afe_gain(demod,
-					 (p_drxj_cfg_afe_gain_t) config->cfg_data);
+					 (struct drxj_cfg_afe_gain *) config->cfg_data);
 	case DRXJ_CFG_SMART_ANT:
 		return ctrl_set_cfg_smart_ant(demod,
-					  (p_drxj_cfg_smart_ant_t) (config->
+					  (struct drxj_cfg_smart_ant *) (config->
 								cfg_data));
 	case DRXJ_CFG_RESET_PACKET_ERR:
 		return ctrl_set_cfg_reset_pkt_err(demod);
@@ -15212,23 +15210,23 @@ static int ctrl_set_cfg(struct drx_demod_instance *demod, struct drx_cfg *config
 		return ctrl_set_cfg_oob_pre_saw(demod, (u16 *)(config->cfg_data));
 	case DRXJ_CFG_OOB_LO_POW:
 		return ctrl_set_cfg_oob_lo_power(demod,
-					    (p_drxj_cfg_oob_lo_power_t) (config->
+					    (enum drxj_cfg_oob_lo_power *) (config->
 								    cfg_data));
 	case DRXJ_CFG_ATV_MISC:
 		return ctrl_set_cfg_atv_misc(demod,
-					 (p_drxj_cfg_atv_misc_t) config->cfg_data);
+					 (struct drxj_cfg_atv_misc *) config->cfg_data);
 	case DRXJ_CFG_ATV_EQU_COEF:
 		return ctrl_set_cfg_atv_equ_coef(demod,
-					    (p_drxj_cfg_atv_equ_coef_t) config->
+					    (struct drxj_cfg_atv_equ_coef *) config->
 					    cfg_data);
 	case DRXJ_CFG_ATV_OUTPUT:
 		return ctrl_set_cfg_atv_output(demod,
-					   (p_drxj_cfg_atv_output_t) config->
+					   (struct drxj_cfg_atv_output *) config->
 					   cfg_data);
 #endif
 	case DRXJ_CFG_MPEG_OUTPUT_MISC:
 		return ctrl_set_cfg_mpeg_output_misc(demod,
-						(p_drxj_cfg_mpeg_output_misc_t)
+						(struct drxj_cfg_mpeg_output_misc *)
 						config->cfg_data);
 #ifndef DRXJ_EXCLUDE_AUDIO
 	case DRX_CFG_AUD_VOLUME:
@@ -15301,60 +15299,60 @@ static int ctrl_get_cfg(struct drx_demod_instance *demod, struct drx_cfg *config
 	case DRX_CFG_PINS_SAFE_MODE:
 		return ctrl_get_cfg_pdr_safe_mode(demod, (bool *)config->cfg_data);
 	case DRXJ_CFG_AGC_RF:
-		return ctrl_get_cfg_agc_rf(demod, (p_drxj_cfg_agc_t) config->cfg_data);
+		return ctrl_get_cfg_agc_rf(demod, (struct drxj_cfg_agc *) config->cfg_data);
 	case DRXJ_CFG_AGC_IF:
-		return ctrl_get_cfg_agc_if(demod, (p_drxj_cfg_agc_t) config->cfg_data);
+		return ctrl_get_cfg_agc_if(demod, (struct drxj_cfg_agc *) config->cfg_data);
 	case DRXJ_CFG_AGC_INTERNAL:
 		return ctrl_get_cfg_agc_internal(demod, (u16 *)config->cfg_data);
 	case DRXJ_CFG_PRE_SAW:
 		return ctrl_get_cfg_pre_saw(demod,
-					(p_drxj_cfg_pre_saw_t) config->cfg_data);
+					(struct drxj_cfg_pre_saw *) config->cfg_data);
 	case DRXJ_CFG_AFE_GAIN:
 		return ctrl_get_cfg_afe_gain(demod,
-					 (p_drxj_cfg_afe_gain_t) config->cfg_data);
+					 (struct drxj_cfg_afe_gain *) config->cfg_data);
 	case DRXJ_CFG_ACCUM_CR_RS_CW_ERR:
 		return ctrl_get_accum_cr_rs_cw_err(demod, (u32 *)config->cfg_data);
 	case DRXJ_CFG_FEC_MERS_SEQ_COUNT:
 		return ctrl_get_fec_meas_seq_count(demod, (u16 *)config->cfg_data);
 	case DRXJ_CFG_VSB_MISC:
 		return ctrl_get_cfg_vsb_misc(demod,
-					 (p_drxj_cfg_vsb_misc_t) config->cfg_data);
+					 (struct drxj_cfg_vsb_misc *) config->cfg_data);
 	case DRXJ_CFG_SYMBOL_CLK_OFFSET:
 		return ctrl_get_cfg_symbol_clock_offset(demod,
 						   (s32 *)config->cfg_data);
 #ifndef DRXJ_DIGITAL_ONLY
 	case DRXJ_CFG_OOB_MISC:
 		return ctrl_get_cfg_oob_misc(demod,
-					 (p_drxj_cfg_oob_misc_t) config->cfg_data);
+					 (struct drxj_cfg_oob_misc *) config->cfg_data);
 	case DRXJ_CFG_OOB_PRE_SAW:
 		return ctrl_get_cfg_oob_pre_saw(demod, (u16 *)(config->cfg_data));
 	case DRXJ_CFG_OOB_LO_POW:
 		return ctrl_get_cfg_oob_lo_power(demod,
-					    (p_drxj_cfg_oob_lo_power_t) (config->
+					    (enum drxj_cfg_oob_lo_power *) (config->
 								    cfg_data));
 	case DRXJ_CFG_ATV_EQU_COEF:
 		return ctrl_get_cfg_atv_equ_coef(demod,
-					    (p_drxj_cfg_atv_equ_coef_t) config->
+					    (struct drxj_cfg_atv_equ_coef *) config->
 					    cfg_data);
 	case DRXJ_CFG_ATV_MISC:
 		return ctrl_get_cfg_atv_misc(demod,
-					 (p_drxj_cfg_atv_misc_t) config->cfg_data);
+					 (struct drxj_cfg_atv_misc *) config->cfg_data);
 	case DRXJ_CFG_ATV_OUTPUT:
 		return ctrl_get_cfg_atv_output(demod,
-					   (p_drxj_cfg_atv_output_t) config->
+					   (struct drxj_cfg_atv_output *) config->
 					   cfg_data);
 	case DRXJ_CFG_ATV_AGC_STATUS:
 		return ctrl_get_cfg_atv_agc_status(demod,
-					      (p_drxj_cfg_atv_agc_status_t) config->
+					      (struct drxj_cfg_atv_agc_status *) config->
 					      cfg_data);
 #endif
 	case DRXJ_CFG_MPEG_OUTPUT_MISC:
 		return ctrl_get_cfg_mpeg_output_misc(demod,
-						(p_drxj_cfg_mpeg_output_misc_t)
+						(struct drxj_cfg_mpeg_output_misc *)
 						config->cfg_data);
 	case DRXJ_CFG_HW_CFG:
 		return ctrl_get_cfg_hw_cfg(demod,
-				       (p_drxj_cfg_hw_cfg_t) config->cfg_data);
+				       (struct drxj_cfg_hw_cfg *) config->cfg_data);
 #ifndef DRXJ_EXCLUDE_AUDIO
 	case DRX_CFG_AUD_VOLUME:
 		return aud_ctrl_get_cfg_volume(demod,
@@ -15421,7 +15419,7 @@ rw_error:
 int drxj_open(struct drx_demod_instance *demod)
 {
 	struct i2c_device_addr *dev_addr = NULL;
-	pdrxj_data_t ext_attr = NULL;
+	struct drxj_data *ext_attr = NULL;
 	struct drx_common_attr *common_attr = NULL;
 	u32 driver_version = 0;
 	struct drxu_code_info ucode_info;
@@ -15433,7 +15431,7 @@ int drxj_open(struct drx_demod_instance *demod)
 	}
 
 	dev_addr = demod->my_i2c_dev_addr;
-	ext_attr = (pdrxj_data_t) demod->my_ext_attr;
+	ext_attr = (struct drxj_data *) demod->my_ext_attr;
 	common_attr = (struct drx_common_attr *) demod->my_common_attr;
 
 	CHK_ERROR(power_up_device(demod));
diff --git a/drivers/media/dvb-frontends/drx39xyj/drxj.h b/drivers/media/dvb-frontends/drx39xyj/drxj.h
index 91272f100128..f41a61e49594 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drxj.h
+++ b/drivers/media/dvb-frontends/drx39xyj/drxj.h
@@ -1,3 +1,4 @@
+
 /*
   Copyright (c), 2004-2005,2007-2010 Trident Microsystems, Inc.
   All rights reserved.
@@ -74,7 +75,7 @@ TYPEDEFS
 /*============================================================================*/
 /*============================================================================*/
 
-	typedef struct {
+	struct drxjscu_cmd {
 		u16 command;
 			/**< Command number */
 		u16 parameter_len;
@@ -84,8 +85,7 @@ TYPEDEFS
 		u16 *parameter;
 			/**< General purpous param */
 		u16 *result;
-			/**< General purpous param */
-	} drxjscu_cmd_t, *p_drxjscu_cmd_t;
+			/**< General purpous param */};
 
 /*============================================================================*/
 /*============================================================================*/
@@ -111,7 +111,7 @@ TYPEDEFS
 /*#define DRX_CTRL_BASE         (0x0000)*/
 
 #define DRXJ_CTRL_CFG_BASE    (0x1000)
-	typedef enum {
+	enum drxj_cfg_type {
 		DRXJ_CFG_AGC_RF = DRXJ_CTRL_CFG_BASE,
 		DRXJ_CFG_AGC_IF,
 		DRXJ_CFG_AGC_INTERNAL,
@@ -136,96 +136,85 @@ TYPEDEFS
 		DRXJ_CFG_HW_CFG,
 		DRXJ_CFG_OOB_LO_POW,
 
-		DRXJ_CFG_MAX	/* dummy, never to be used */
-	} drxj_cfg_type_t, *pdrxj_cfg_type_t;
+		DRXJ_CFG_MAX	/* dummy, never to be used */};
 
 /**
-* /struct drxj_cfg_smart_ant_io_t
-* smart antenna i/o.
+* /struct enum drxj_cfg_smart_ant_io * smart antenna i/o.
 */
-	typedef enum drxj_cfg_smart_ant_io_t {
-		DRXJ_SMT_ANT_OUTPUT = 0,
-		DRXJ_SMT_ANT_INPUT
-	} drxj_cfg_smart_ant_io_t, *pdrxj_cfg_smart_ant_io_t;
+enum drxj_cfg_smart_ant_io {
+	DRXJ_SMT_ANT_OUTPUT = 0,
+	DRXJ_SMT_ANT_INPUT
+};
 
 /**
-* /struct drxj_cfg_smart_ant_t
-* Set smart antenna.
+* /struct struct drxj_cfg_smart_ant * Set smart antenna.
 */
-	typedef struct {
-		drxj_cfg_smart_ant_io_t io;
+	struct drxj_cfg_smart_ant {
+		enum drxj_cfg_smart_ant_io io;
 		u16 ctrl_data;
-	} drxj_cfg_smart_ant_t, *p_drxj_cfg_smart_ant_t;
+	};
 
 /**
 * /struct DRXJAGCSTATUS_t
 * AGC status information from the DRXJ-IQM-AF.
 */
-	typedef struct {
-		u16 IFAGC;
-		u16 RFAGC;
-		u16 digital_agc;
-	} drxj_agc_status_t, *pdrxj_agc_status_t;
+struct drxj_agc_status {
+	u16 IFAGC;
+	u16 RFAGC;
+	u16 digital_agc;
+};
 
 /* DRXJ_CFG_AGC_RF, DRXJ_CFG_AGC_IF */
 
 /**
-* /struct drxj_agc_ctrl_mode_t
-* Available AGCs modes in the DRXJ.
+* /struct enum drxj_agc_ctrl_mode * Available AGCs modes in the DRXJ.
 */
-	typedef enum {
+	enum drxj_agc_ctrl_mode {
 		DRX_AGC_CTRL_AUTO = 0,
 		DRX_AGC_CTRL_USER,
-		DRX_AGC_CTRL_OFF
-	} drxj_agc_ctrl_mode_t, *pdrxj_agc_ctrl_mode_t;
+		DRX_AGC_CTRL_OFF};
 
 /**
-* /struct drxj_cfg_agc_t
-* Generic interface for all AGCs present on the DRXJ.
+* /struct struct drxj_cfg_agc * Generic interface for all AGCs present on the DRXJ.
 */
-	typedef struct {
+	struct drxj_cfg_agc {
 		enum drx_standard standard;	/* standard for which these settings apply */
-		drxj_agc_ctrl_mode_t ctrl_mode;	/* off, user, auto          */
+		enum drxj_agc_ctrl_mode ctrl_mode;	/* off, user, auto          */
 		u16 output_level;	/* range dependent on AGC   */
 		u16 min_output_level;	/* range dependent on AGC   */
 		u16 max_output_level;	/* range dependent on AGC   */
 		u16 speed;	/* range dependent on AGC   */
 		u16 top;	/* rf-agc take over point   */
 		u16 cut_off_current;	/* rf-agc is accelerated if output current
-					   is below cut-off current                */
-	} drxj_cfg_agc_t, *p_drxj_cfg_agc_t;
+					   is below cut-off current                */};
 
 /* DRXJ_CFG_PRE_SAW */
 
 /**
-* /struct drxj_cfg_pre_saw_t
-* Interface to configure pre SAW sense.
+* /struct struct drxj_cfg_pre_saw * Interface to configure pre SAW sense.
 */
-	typedef struct {
+	struct drxj_cfg_pre_saw {
 		enum drx_standard standard;	/* standard to which these settings apply */
 		u16 reference;	/* pre SAW reference value, range 0 .. 31 */
-		bool use_pre_saw;	/* true algorithms must use pre SAW sense */
-	} drxj_cfg_pre_saw_t, *p_drxj_cfg_pre_saw_t;
+		bool use_pre_saw;	/* true algorithms must use pre SAW sense */};
 
 /* DRXJ_CFG_AFE_GAIN */
 
 /**
-* /struct drxj_cfg_afe_gain_t
-* Interface to configure gain of AFE (LNA + PGA).
+* /struct struct drxj_cfg_afe_gain * Interface to configure gain of AFE (LNA + PGA).
 */
-	typedef struct {
+	struct drxj_cfg_afe_gain {
 		enum drx_standard standard;	/* standard to which these settings apply */
-		u16 gain;	/* gain in 0.1 dB steps, DRXJ range 140 .. 335 */
-	} drxj_cfg_afe_gain_t, *p_drxj_cfg_afe_gain_t;
+		u16 gain;	/* gain in 0.1 dB steps, DRXJ range 140 .. 335 */};
 
 /**
-* /struct DRXJrs_errors_t
+* /struct drxjrs_errors
 * Available failure information in DRXJ_FEC_RS.
 *
 * Container for errors that are received in the most recently finished measurment period
 *
 */
-	typedef struct {
+	struct drxjrs_errors {
 		u16 nr_bit_errors;
 				/**< no of pre RS bit errors          */
 		u16 nr_symbol_errors;
@@ -236,41 +225,35 @@ TYPEDEFS
 				/**< no of post RS failures to decode */
 		u16 nr_snc_par_fail_count;
 				/**< no of post RS bit erros          */
-	} DRXJrs_errors_t, *p_drxjrs_errors_t;
+	};
 
 /**
-* /struct drxj_cfg_vsb_misc_t
-* symbol error rate
+* /struct struct drxj_cfg_vsb_misc * symbol error rate
 */
-	typedef struct {
+	struct drxj_cfg_vsb_misc {
 		u32 symb_error;
-			      /**< symbol error rate sps */
-	} drxj_cfg_vsb_misc_t, *p_drxj_cfg_vsb_misc_t;
+			      /**< symbol error rate sps */};
 
 /**
-* /enum drxj_mpeg_output_clock_rate_t
-* Mpeg output clock rate.
+* /enum enum drxj_mpeg_output_clock_rate * Mpeg output clock rate.
 *
 */
-	typedef enum {
+	enum drxj_mpeg_start_width {
 		DRXJ_MPEG_START_WIDTH_1CLKCYC,
-		DRXJ_MPEG_START_WIDTH_8CLKCYC
-	} drxj_mpeg_start_width_t, *pdrxj_mpeg_start_width_t;
+		DRXJ_MPEG_START_WIDTH_8CLKCYC};
 
 /**
-* /enum drxj_mpeg_output_clock_rate_t
-* Mpeg output clock rate.
+* /enum enum drxj_mpeg_output_clock_rate * Mpeg output clock rate.
 *
 */
-	typedef enum {
+	enum drxj_mpeg_output_clock_rate {
 		DRXJ_MPEGOUTPUT_CLOCK_RATE_AUTO,
 		DRXJ_MPEGOUTPUT_CLOCK_RATE_75973K,
 		DRXJ_MPEGOUTPUT_CLOCK_RATE_50625K,
 		DRXJ_MPEGOUTPUT_CLOCK_RATE_37968K,
 		DRXJ_MPEGOUTPUT_CLOCK_RATE_30375K,
 		DRXJ_MPEGOUTPUT_CLOCK_RATE_25313K,
-		DRXJ_MPEGOUTPUT_CLOCK_RATE_21696K
-	} drxj_mpeg_output_clock_rate_t, *pdrxj_mpeg_output_clock_rate_t;
+		DRXJ_MPEGOUTPUT_CLOCK_RATE_21696K};
 
 /**
 * /struct DRXJCfgMisc_t
@@ -278,56 +261,47 @@ TYPEDEFS
 * reverse MPEG output bit order
 * set MPEG output clock rate
 */
-	typedef struct {
+	struct drxj_cfg_mpeg_output_misc {
 		bool disable_tei_handling;	      /**< if true pass (not change) TEI bit */
 		bool bit_reverse_mpeg_outout;	      /**< if true, parallel: msb on MD0; serial: lsb out first */
-		drxj_mpeg_output_clock_rate_t mpeg_output_clock_rate;
+		enum drxj_mpeg_output_clock_rate mpeg_output_clock_rate;
 						      /**< set MPEG output clock rate that overwirtes the derived one from symbol rate */
-		drxj_mpeg_start_width_t mpeg_start_width;  /**< set MPEG output start width */
-	} drxj_cfg_mpeg_output_misc_t, *p_drxj_cfg_mpeg_output_misc_t;
+		enum drxj_mpeg_start_width mpeg_start_width;  /**< set MPEG output start width */};
 
 /**
-* /enum drxj_xtal_freq_t
-* Supported external crystal reference frequency.
+* /enum enum drxj_xtal_freq * Supported external crystal reference frequency.
 */
-	typedef enum {
+	enum drxj_xtal_freq {
 		DRXJ_XTAL_FREQ_RSVD,
 		DRXJ_XTAL_FREQ_27MHZ,
 		DRXJ_XTAL_FREQ_20P25MHZ,
-		DRXJ_XTAL_FREQ_4MHZ
-	} drxj_xtal_freq_t, *pdrxj_xtal_freq_t;
+		DRXJ_XTAL_FREQ_4MHZ};
 
 /**
-* /enum drxj_xtal_freq_t
-* Supported external crystal reference frequency.
+* /enum enum drxj_xtal_freq * Supported external crystal reference frequency.
 */
-	typedef enum {
+	enum drxji2c_speed {
 		DRXJ_I2C_SPEED_400KBPS,
-		DRXJ_I2C_SPEED_100KBPS
-	} drxji2c_speed_t, *pdrxji2c_speed_t;
+		DRXJ_I2C_SPEED_100KBPS};
 
 /**
-* /struct drxj_cfg_hw_cfg_t
-* Get hw configuration, such as crystal reference frequency, I2C speed, etc...
+* /struct struct drxj_cfg_hw_cfg * Get hw configuration, such as crystal reference frequency, I2C speed, etc...
 */
-	typedef struct {
-		drxj_xtal_freq_t xtal_freq;
+	struct drxj_cfg_hw_cfg {
+		enum drxj_xtal_freq xtal_freq;
 				   /**< crystal reference frequency */
-		drxji2c_speed_t i2c_speed;
-				   /**< 100 or 400 kbps */
-	} drxj_cfg_hw_cfg_t, *p_drxj_cfg_hw_cfg_t;
+		enum drxji2c_speed i2c_speed;
+				   /**< 100 or 400 kbps */};
 
 /*
  *  DRXJ_CFG_ATV_MISC
  */
-	typedef struct {
+	struct drxj_cfg_atv_misc {
 		s16 peak_filter;	/* -8 .. 15 */
-		u16 noise_filter;	/* 0 .. 15 */
-	} drxj_cfg_atv_misc_t, *p_drxj_cfg_atv_misc_t;
+		u16 noise_filter;	/* 0 .. 15 */};
 
 /*
- *  drxj_cfg_oob_misc_t
- */
+ *  struct drxj_cfg_oob_misc */
 #define   DRXJ_OOB_STATE_RESET                                        0x0
 #define   DRXJ_OOB_STATE_AGN_HUNT                                     0x1
 #define   DRXJ_OOB_STATE_DGN_HUNT                                     0x2
@@ -339,42 +313,40 @@ TYPEDEFS
 #define   DRXJ_OOB_STATE_EQT_HUNT                                     0x30
 #define   DRXJ_OOB_STATE_SYNC                                         0x40
 
-	typedef struct {
-		drxj_agc_status_t agc;
-		bool eq_lock;
-		bool sym_timing_lock;
-		bool phase_lock;
-		bool freq_lock;
-		bool dig_gain_lock;
-		bool ana_gain_lock;
-		u8 state;
-	} drxj_cfg_oob_misc_t, *p_drxj_cfg_oob_misc_t;
+struct drxj_cfg_oob_misc {
+	struct drxj_agc_status agc;
+	bool eq_lock;
+	bool sym_timing_lock;
+	bool phase_lock;
+	bool freq_lock;
+	bool dig_gain_lock;
+	bool ana_gain_lock;
+	u8 state;
+ };
 
 /*
  *  Index of in array of coef
  */
-	typedef enum {
+	enum drxj_cfg_oob_lo_power {
 		DRXJ_OOB_LO_POW_MINUS0DB = 0,
 		DRXJ_OOB_LO_POW_MINUS5DB,
 		DRXJ_OOB_LO_POW_MINUS10DB,
 		DRXJ_OOB_LO_POW_MINUS15DB,
-		DRXJ_OOB_LO_POW_MAX
-	} drxj_cfg_oob_lo_power_t, *p_drxj_cfg_oob_lo_power_t;
+		DRXJ_OOB_LO_POW_MAX};
 
 /*
  *  DRXJ_CFG_ATV_EQU_COEF
  */
-	typedef struct {
+	struct drxj_cfg_atv_equ_coef {
 		s16 coef0;	/* -256 .. 255 */
 		s16 coef1;	/* -256 .. 255 */
 		s16 coef2;	/* -256 .. 255 */
-		s16 coef3;	/* -256 .. 255 */
-	} drxj_cfg_atv_equ_coef_t, *p_drxj_cfg_atv_equ_coef_t;
+		s16 coef3;	/* -256 .. 255 */};
 
 /*
  *  Index of in array of coef
  */
-	typedef enum {
+	enum drxj_coef_array_index {
 		DRXJ_COEF_IDX_MN = 0,
 		DRXJ_COEF_IDX_FM,
 		DRXJ_COEF_IDX_L,
@@ -382,8 +354,7 @@ TYPEDEFS
 		DRXJ_COEF_IDX_BG,
 		DRXJ_COEF_IDX_DK,
 		DRXJ_COEF_IDX_I,
-		DRXJ_COEF_IDX_MAX
-	} drxj_coef_array_index_t, *pdrxj_coef_array_index_t;
+		DRXJ_COEF_IDX_MAX};
 
 /*
  *  DRXJ_CFG_ATV_OUTPUT
@@ -394,37 +365,34 @@ TYPEDEFS
 * Attenuation setting for SIF AGC.
 *
 */
-	typedef enum {
+	enum drxjsif_attenuation {
 		DRXJ_SIF_ATTENUATION_0DB,
 		DRXJ_SIF_ATTENUATION_3DB,
 		DRXJ_SIF_ATTENUATION_6DB,
-		DRXJ_SIF_ATTENUATION_9DB
-	} drxjsif_attenuation_t, *pdrxjsif_attenuation_t;
+		DRXJ_SIF_ATTENUATION_9DB};
 
 /**
-* /struct drxj_cfg_atv_output_t
-* SIF attenuation setting.
+* /struct struct drxj_cfg_atv_output * SIF attenuation setting.
 *
 */
-	typedef struct {
-		bool enable_cvbs_output;	/* true= enabled */
-		bool enable_sif_output;	/* true= enabled */
-		drxjsif_attenuation_t sif_attenuation;
-	} drxj_cfg_atv_output_t, *p_drxj_cfg_atv_output_t;
+struct drxj_cfg_atv_output {
+	bool enable_cvbs_output;	/* true= enabled */
+	bool enable_sif_output;	/* true= enabled */
+	enum drxjsif_attenuation sif_attenuation;
+};
 
 /*
    DRXJ_CFG_ATV_AGC_STATUS (get only)
 */
 /* TODO : AFE interface not yet finished, subject to change */
-	typedef struct {
+	struct drxj_cfg_atv_agc_status {
 		u16 rf_agc_gain;	/* 0 .. 877 uA */
 		u16 if_agc_gain;	/* 0 .. 877  uA */
 		s16 video_agc_gain;	/* -75 .. 1972 in 0.1 dB steps */
 		s16 audio_agc_gain;	/* -4 .. 1020 in 0.1 dB steps */
 		u16 rf_agc_loop_gain;	/* 0 .. 7 */
 		u16 if_agc_loop_gain;	/* 0 .. 7 */
-		u16 video_agc_loop_gain;	/* 0 .. 7 */
-	} drxj_cfg_atv_agc_status_t, *p_drxj_cfg_atv_agc_status_t;
+		u16 video_agc_loop_gain;	/* 0 .. 7 */};
 
 /*============================================================================*/
 /*============================================================================*/
@@ -439,13 +407,12 @@ TYPEDEFS
 
 /*========================================*/
 /**
-* /struct drxj_data_t
-* DRXJ specific attributes.
+* /struct struct drxj_data * DRXJ specific attributes.
 *
 * Global data container for DRXJ specific data.
 *
 */
-	typedef struct {
+	struct drxj_data {
 		/* device capabilties (determined during drx_open()) */
 		bool has_lna;		  /**< true if LNA (aka PGA) present */
 		bool has_oob;		  /**< true if OOB supported */
@@ -511,22 +478,22 @@ TYPEDEFS
 		u16 atv_top_noise_th;	  /**< shadow of ATV_TOP_NOISE_TH__A */
 		bool enable_cvbs_output;  /**< flag CVBS ouput enable */
 		bool enable_sif_output;	  /**< flag SIF ouput enable */
-		 drxjsif_attenuation_t sif_attenuation;
+		 enum drxjsif_attenuation sif_attenuation;
 					  /**< current SIF att setting */
 		/* Agc configuration for QAM and VSB */
-		drxj_cfg_agc_t qam_rf_agc_cfg; /**< qam RF AGC config */
-		drxj_cfg_agc_t qam_if_agc_cfg; /**< qam IF AGC config */
-		drxj_cfg_agc_t vsb_rf_agc_cfg; /**< vsb RF AGC config */
-		drxj_cfg_agc_t vsb_if_agc_cfg; /**< vsb IF AGC config */
+		struct drxj_cfg_agc qam_rf_agc_cfg; /**< qam RF AGC config */
+		struct drxj_cfg_agc qam_if_agc_cfg; /**< qam IF AGC config */
+		struct drxj_cfg_agc vsb_rf_agc_cfg; /**< vsb RF AGC config */
+		struct drxj_cfg_agc vsb_if_agc_cfg; /**< vsb IF AGC config */
 
 		/* PGA gain configuration for QAM and VSB */
 		u16 qam_pga_cfg;	  /**< qam PGA config */
 		u16 vsb_pga_cfg;	  /**< vsb PGA config */
 
 		/* Pre SAW configuration for QAM and VSB */
-		drxj_cfg_pre_saw_t qam_pre_saw_cfg;
+		struct drxj_cfg_pre_saw qam_pre_saw_cfg;
 					  /**< qam pre SAW config */
-		drxj_cfg_pre_saw_t vsb_pre_saw_cfg;
+		struct drxj_cfg_pre_saw vsb_pre_saw_cfg;
 					  /**< qam pre SAW config */
 
 		/* Version information */
@@ -546,16 +513,16 @@ TYPEDEFS
 		u32 mpeg_ts_static_bitrate;  /**< bitrate static MPEG output */
 		bool disable_te_ihandling;  /**< MPEG TS TEI handling */
 		bool bit_reverse_mpeg_outout;/**< MPEG output bit order */
-		 drxj_mpeg_output_clock_rate_t mpeg_output_clock_rate;
+		 enum drxj_mpeg_output_clock_rate mpeg_output_clock_rate;
 					    /**< MPEG output clock rate */
-		 drxj_mpeg_start_width_t mpeg_start_width;
+		 enum drxj_mpeg_start_width mpeg_start_width;
 					    /**< MPEG Start width */
 
 		/* Pre SAW & Agc configuration for ATV */
-		drxj_cfg_pre_saw_t atv_pre_saw_cfg;
+		struct drxj_cfg_pre_saw atv_pre_saw_cfg;
 					  /**< atv pre SAW config */
-		drxj_cfg_agc_t atv_rf_agc_cfg; /**< atv RF AGC config */
-		drxj_cfg_agc_t atv_if_agc_cfg; /**< atv IF AGC config */
+		struct drxj_cfg_agc atv_rf_agc_cfg; /**< atv RF AGC config */
+		struct drxj_cfg_agc atv_if_agc_cfg; /**< atv IF AGC config */
 		u16 atv_pga_cfg;	  /**< atv pga config    */
 
 		u32 curr_symbol_rate;
@@ -569,12 +536,10 @@ TYPEDEFS
 
 		/* OOB pre-saw value */
 		u16 oob_pre_saw;
-		drxj_cfg_oob_lo_power_t oob_lo_pow;
+		enum drxj_cfg_oob_lo_power oob_lo_pow;
 
 		struct drx_aud_data aud_data;
-				    /**< audio storage                  */
-
-	} drxj_data_t, *pdrxj_data_t;
+				    /**< audio storage                  */};
 
 /*-------------------------------------------------------------------------
 Access MACROS
@@ -591,7 +556,7 @@ Access MACROS
 */
 
 #define DRXJ_ATTR_BTSC_DETECT(d)                       \
-			(((pdrxj_data_t)(d)->my_ext_attr)->aud_data.btsc_detect)
+			(((struct drxj_data *)(d)->my_ext_attr)->aud_data.btsc_detect)
 
 /**
 * \brief Actual access macros
@@ -733,7 +698,7 @@ Exported GLOBAL VARIABLES
 -------------------------------------------------------------------------*/
 	extern struct drx_access_func drx_dap_drxj_funct_g;
 	extern struct drx_demod_func drxj_functions_g;
-	extern drxj_data_t drxj_data_g;
+	extern struct drxj_data drxj_data_g;
 	extern struct i2c_device_addr drxj_default_addr_g;
 	extern struct drx_common_attr drxj_default_comm_attr_g;
 	extern struct drx_demod_instance drxj_default_demod_g;
-- 
1.8.5.3

