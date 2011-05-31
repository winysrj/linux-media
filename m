Return-path: <mchehab@pedra>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:58960 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368Ab1EaGt5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 31 May 2011 02:49:57 -0400
Received: by bwz15 with SMTP id 15so3372230bwz.19
        for <linux-media@vger.kernel.org>; Mon, 30 May 2011 23:49:55 -0700 (PDT)
Date: Tue, 31 May 2011 17:53:35 +1000
From: Dmitri Belimov <d.belimov@gmail.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [RFC] saa7134 + upd61151
Message-ID: <20110531175335.75b0ffaa@glory.local>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/ESviAueYelNPDQ+aBqIAFNE"
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

--MP_/ESviAueYelNPDQ+aBqIAFNE
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi

This is my test patch for saa7134 and MPEG2 encoder uPD61151.

My main problem is that saa7134 can has only one MPEG device attached.
Our tv card has DVB-T and MPEG2 encoder. And function mops_ops_attach discard second
MPEG device.

I try add same as MPEG device into saa7134 driver, but it's not work.

Who can help me??

[  212.641035] Linux video capture interface: v2.00
[  212.779837] IR NEC protocol handler initialized
[  212.801895] IR RC5(x) protocol handler initialized
[  212.835655] IR RC6 protocol handler initialized
[  212.862084] saa7130/34: v4l2 driver version 0.2.16 loaded
[  212.862123] saa7134 0000:04:01.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[  212.862129] saa7133[0]: found at 0000:04:01.0, rev: 209, irq: 19, latency: 32, mmio: 0xe5100000
[  212.862135] saa7133[0]: subsystem: 5ace:7595, board: Beholder BeholdTV X7 [card=171,autodetected]
[  212.862150] saa7133[0]: board init: gpio is 200000
[  212.862156] buffer_setup set psize = 188
[  212.875380] IR JVC protocol handler initialized
[  212.877367] IR Sony protocol handler initialized
[  212.880196] lirc_dev: IR Remote Control driver registered, major 252 
[  212.881252] IR LIRC bridge handler initialized
[  213.001012] saa7133[0]: i2c eeprom 00: ce 5a 95 75 54 20 00 00 00 00 00 00 00 00 00 01
[  213.001031] saa7133[0]: i2c eeprom 10: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[  213.001049] saa7133[0]: i2c eeprom 20: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[  213.001067] saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[  213.001084] saa7133[0]: i2c eeprom 40: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[  213.001101] saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[  213.001119] saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[  213.001136] saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[  213.001154] saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[  213.001171] saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[  213.001188] saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[  213.001208] saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[  213.001216] saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[  213.001224] saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[  213.001232] saa7133[0]: i2c eeprom e0: 00 00 00 00 ff ff ff ff ff ff ff ff ff ff ff ff
[  213.001241] saa7133[0]: i2c eeprom f0: 42 54 56 30 30 30 30 ff ff ff ff ff ff ff ff ff
[  213.014427] i2c-core: driver [tuner] using legacy suspend method
[  213.014430] i2c-core: driver [tuner] using legacy resume method
[  213.017060] tuner 7-0061: Tuner -1 found with type(s) Radio TV.
[  213.017185] xc5000 7-0061: creating new instance
[  213.020020] xc5000: Successfully identified at address 0x61
[  213.020024] xc5000: Firmware has not been loaded previously
[  213.020035] sap
[  214.827686] xc5000: I2C write failed (len=4)
[  214.827689] xc5000: xc_SetTVStandard failed
[  214.827698] sap
[  221.354013] Registered IR keymap rc-behold
[  221.354156] input: i2c IR (BeholdTV) as /devices/virtual/rc/rc0/input5
[  221.354219] rc0: i2c IR (BeholdTV) as /devices/virtual/rc/rc0
[  221.354223] ir-kbd-i2c: i2c IR (BeholdTV) detected at i2c-7/7-002d/ir0 [saa7133[0]]
[  221.354702] saa7134 0000:04:01.0: registered master spi32766 (dynamic)
[  221.354705] saa7134 0000:04:01.0: spi master registered: bus_num=32766 num_chipselect=1
[  221.354707] saa7133[0]: found muPD61151 MPEG encoder
[  221.375343] spi spi32766.0: spi_bitbang_setup, 20 nsec/bit
[  221.375350] spi spi32766.0: setup mode 0, 8 bits/w, 50000000 Hz max --> 0
[  221.375380] upd61151_probe function
[  221.375665] upd61151: MPEG2 core status 0
[  221.375666] upd61151: need reload firmware
[  221.375668] Start load firmware...
[  221.375669] DEBUG: upd61151_download_firmware
[  221.378088] DEBUG: upd61151_load_base_firmware
[  221.378091] upd61151: waiting for base firmware upload (D61151_PS_7133_v22_031031.bin)...
[  221.440224] upd61151: firmware read 97002 bytes.
[  221.440226] upd61151: base firmware uploading...
[  221.440434] upd61151: Transfer IRQ status 0x0
[  221.442098] fw upload start
[  239.219204] fw upload stop
[  239.219391] upd61151: Transfer IRQ status 0x1
[  239.219760] upd61151: base firmware upload complete...
[  239.219954] DEBUG: upd61151_load_audio_firmware
[  239.219955] upd61151: waiting for audio firmware upload (audrey_MPE_V1r51.bin)...
[  239.248638] upd61151: firmware read 40064 bytes.
[  239.248640] upd61151: audio firmware uploading...
[  239.249104] upd61151: Transfer IRQ status 0x1
[  239.250593] fw upload start
[  239.274165] upd61151: Transfer IRQ status 0x2
[  246.764126] upd61151: Transfer IRQ status 0x1
[  246.764312] fw upload stop
[  246.764496] upd61151: audio firmware upload complete...
[  246.764691] upd61151: IRQ status 0x19
[  246.764876] DEBUG uPD61151: upd61151_chip_command
[  246.765065] upd61151: IRQ error status 0x0
[  246.765441] upd61151: MPEG2 core status 0
[  246.765627] upd61151: IRQ error status 0x0
[  246.776267] upd61151: MPEG2 core status 1
[  246.776461] upd61151: IRQ status 0x8
[  246.776647] upd61151: SetState(1) SUCCESS!!! Delay [10 ms].
[  246.776649] upd61151_setup_video_frontend
[  246.776650]    0x0     0x0  
[  246.777791] upd61151_setup_audio_frontend
[  246.778210] upd61151_config_encoder
[  246.778212] Video attrib1 = 0x80
[  246.778587] upd61151_prepare_bitrates
[  246.780783] upd61151_set_state
[  246.780996] upd61151: IRQ error status 0x0
[  246.781448] upd61151: MPEG2 core status 1
[  246.781633] upd61151: IRQ error status 0x0
[  246.783822] upd61151: MPEG2 core status 1
[  246.784023] upd61151: IRQ error status 0x0
[  246.786210] upd61151: MPEG2 core status 1
[  246.786395] upd61151: IRQ error status 0x0
[  246.788608] upd61151: MPEG2 core status 1
[  246.788800] upd61151: IRQ error status 0x0
[  246.790990] upd61151: MPEG2 core status 1
[  246.791182] upd61151: IRQ error status 0x0
[  246.793369] upd61151: MPEG2 core status 1
[  246.793554] upd61151: IRQ error status 0x0
[  246.795740] upd61151: MPEG2 core status 1
[  246.795925] upd61151: IRQ error status 0x0
[  246.798114] upd61151: MPEG2 core status 1
[  246.798299] upd61151: IRQ error status 0x0
[  246.800486] upd61151: MPEG2 core status 1
[  246.800671] upd61151: IRQ error status 0x0
[  246.802863] upd61151: MPEG2 core status 1
[  246.803070] upd61151: IRQ error status 0x0
[  246.805261] upd61151: MPEG2 core status 2
[  246.805447] upd61151: IRQ status 0x28
[  246.805632] upd61151: MPEG2 SetState(0), SUCCESS! Delay(20 ms)
[  246.805633] DEBUG uPD61151: upd61151_chip_command
[  246.805818] upd61151: IRQ error status 0x0
[  246.806361] upd61151: MPEG2 core status 2
[  246.806546] upd61151: IRQ error status 0x0
[  246.817221] upd61151: MPEG2 core status 1
[  246.817419] upd61151: IRQ status 0x8
[  246.817604] upd61151: SetState(1) SUCCESS!!! Delay [10 ms].
[  246.817606] Firmware downloaded SUCCESS!!!
[  246.817613] saa7134 0000:04:01.0: registered child spi32766.0
[  246.818333] saa7133[0]: registered device video0 [v4l2]
[  246.818742] saa7133[0]: registered device vbi0
[  246.818932] saa7133[0]: registered device radio0
[  246.818934] befor request_submodules
[  246.818940] request_mod_async
[  246.818941] request mod empress
[  246.834515] sap
[  246.835857] sap
[  246.835995] sap
[  246.842066] xc5000: I2C write failed (len=4)
[  246.844303] saa7134_ts_register start
[  246.844306] SAA7134_MPEG_EMPRESS found
[  246.844307] mpeg_ops_attach start
[  246.844308] saa7134_ts_register stop
[  246.844399] dvb = 2
[  246.844400] request mod dvb
[  246.908378] call saa7134_ts_register
[  246.908381] saa7134_ts_register start
[  246.908382] SAA7134_MPEG_DVB found
[  246.908384] dvb_ops_attach start
[  246.908385] saa7134_ts_register stop
[  246.926959] saa7134 ALSA driver for DMA sound loaded
[  246.926989] saa7133[0]/alsa: saa7133[0] at 0xe5100000 irq 19 registered as card -1
[  246.943022] xc5000: I2C write failed (len=4)
[  246.943030] DEBUG uPD61151: upd61151_s_std
[  246.943032] DEBUG uPD61151: upd61151_s_std
[  246.944772] xc5000: I2C read failed
[  246.944780] xc5000: I2C read failed
[  246.944782] xc5000: waiting for firmware upload (dvb-fe-xc5000-1.6.114.fw)...
[  246.955952] sap
[  246.985343] xc5000: firmware read 12401 bytes.
[  246.985345] xc5000: firmware uploading...
[  249.048010] xc5000: firmware upload complete...
[  249.689016] DEBUG uPD61151: upd61151_s_std
[  249.689021] DEBUG uPD61151: upd61151_s_std
[  249.693931] sap
[  249.696850] sap
[  250.080015] DEBUG uPD61151: upd61151_s_std
[  250.080020] DEBUG uPD61151: upd61151_s_std
[  250.470016] DEBUG uPD61151: upd61151_s_std
[  250.470021] DEBUG uPD61151: upd61151_s_std


With my best regards, Dmitry.
--MP_/ESviAueYelNPDQ+aBqIAFNE
Content-Type: text/x-patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=saa7134_upd61151.diff

commit cb57f465d8c395b66898e49f1dc4f3e7bd01a2e8
Author: dimon <dimon@habar.ttk-chita.ru>
Date:   Tue May 31 08:27:47 2011 +1000

    test commit

diff --git a/drivers/media/common/tuners/xc5000.c b/drivers/media/common/tuners/xc5000.c
index aa1b2e8..ab8c479 100644
--- a/drivers/media/common/tuners/xc5000.c
+++ b/drivers/media/common/tuners/xc5000.c
@@ -383,6 +383,7 @@ static int xc_SetTVStandard(struct xc5000_priv *priv,
 	u16 VideoMode, u16 AudioMode)
 {
 	int ret;
+	dprintk(1, "%s()\n", __func__);
 	dprintk(1, "%s(0x%04x,0x%04x)\n", __func__, VideoMode, AudioMode);
 	dprintk(1, "%s() Standard = %s\n",
 		__func__,
@@ -397,6 +398,7 @@ static int xc_SetTVStandard(struct xc5000_priv *priv,
 
 static int xc_SetSignalSource(struct xc5000_priv *priv, u16 rf_mode)
 {
+	dprintk(1, "%s()\n", __func__);
 	dprintk(1, "%s(%d) Source = %s\n", __func__, rf_mode,
 		rf_mode == XC_RF_MODE_AIR ? "ANTENNA" : "CABLE");
 
@@ -433,6 +435,7 @@ static int xc_set_RF_frequency(struct xc5000_priv *priv, u32 freq_hz)
 static int xc_set_IF_frequency(struct xc5000_priv *priv, u32 freq_khz)
 {
 	u32 freq_code = (freq_khz * 1024)/1000;
+	dprintk(1, "%s()\n", __func__);
 	dprintk(1, "%s(freq_khz = %d) freq_code = 0x%x\n",
 		__func__, freq_khz, freq_code);
 
@@ -442,6 +445,8 @@ static int xc_set_IF_frequency(struct xc5000_priv *priv, u32 freq_khz)
 
 static int xc_get_ADC_Envelope(struct xc5000_priv *priv, u16 *adc_envelope)
 {
+	dprintk(1, "%s()\n", __func__);
+
 	return xc5000_readreg(priv, XREG_ADC_ENV, adc_envelope);
 }
 
@@ -451,6 +456,8 @@ static int xc_get_frequency_error(struct xc5000_priv *priv, u32 *freq_error_hz)
 	u16 regData;
 	u32 tmp;
 
+	dprintk(1, "%s()\n", __func__);
+
 	result = xc5000_readreg(priv, XREG_FREQ_ERROR, &regData);
 	if (result != XC_RESULT_SUCCESS)
 		return result;
@@ -462,6 +469,8 @@ static int xc_get_frequency_error(struct xc5000_priv *priv, u32 *freq_error_hz)
 
 static int xc_get_lock_status(struct xc5000_priv *priv, u16 *lock_status)
 {
+	dprintk(1, "%s()\n", __func__);
+
 	return xc5000_readreg(priv, XREG_LOCK, lock_status);
 }
 
@@ -472,6 +481,8 @@ static int xc_get_version(struct xc5000_priv *priv,
 	u16 data;
 	int result;
 
+	dprintk(1, "%s()\n", __func__);
+
 	result = xc5000_readreg(priv, XREG_VERSION, &data);
 	if (result != XC_RESULT_SUCCESS)
 		return result;
@@ -486,6 +497,8 @@ static int xc_get_version(struct xc5000_priv *priv,
 
 static int xc_get_buildversion(struct xc5000_priv *priv, u16 *buildrev)
 {
+	dprintk(1, "%s()\n", __func__);
+
 	return xc5000_readreg(priv, XREG_BUILD, buildrev);
 }
 
@@ -494,6 +507,8 @@ static int xc_get_hsync_freq(struct xc5000_priv *priv, u32 *hsync_freq_hz)
 	u16 regData;
 	int result;
 
+	dprintk(1, "%s()\n", __func__);
+
 	result = xc5000_readreg(priv, XREG_HSYNC_FREQ, &regData);
 	if (result != XC_RESULT_SUCCESS)
 		return result;
@@ -504,11 +519,15 @@ static int xc_get_hsync_freq(struct xc5000_priv *priv, u32 *hsync_freq_hz)
 
 static int xc_get_frame_lines(struct xc5000_priv *priv, u16 *frame_lines)
 {
+	dprintk(1, "%s()\n", __func__);
+
 	return xc5000_readreg(priv, XREG_FRAME_LINES, frame_lines);
 }
 
 static int xc_get_quality(struct xc5000_priv *priv, u16 *quality)
 {
+	dprintk(1, "%s()\n", __func__);
+
 	return xc5000_readreg(priv, XREG_QUALITY, quality);
 }
 
@@ -517,6 +536,8 @@ static u16 WaitForLock(struct xc5000_priv *priv)
 	u16 lockState = 0;
 	int watchDogCount = 40;
 
+	dprintk(1, "%s()\n", __func__);
+
 	while ((lockState == 0) && (watchDogCount > 0)) {
 		xc_get_lock_status(priv, &lockState);
 		if (lockState != 1) {
@@ -552,7 +573,7 @@ static int xc5000_fwupload(struct dvb_frontend *fe)
 	struct xc5000_priv *priv = fe->tuner_priv;
 	const struct firmware *fw;
 	int ret;
-
+	dprintk(1, "%s()\n", __func__);
 	/* request the firmware, this will block and timeout */
 	printk(KERN_INFO "xc5000: waiting for firmware upload (%s)...\n",
 		XC5000_DEFAULT_FIRMWARE);
@@ -642,6 +663,8 @@ static int xc5000_set_params(struct dvb_frontend *fe,
 {
 	struct xc5000_priv *priv = fe->tuner_priv;
 	int ret;
+printk("sp\n");
+//	dprintk(1, "%s()\n", __func__);
 
 	if (xc5000_is_firmware_loaded(fe) != XC_RESULT_SUCCESS) {
 		if (xc_load_fw_and_init_tuner(fe) != XC_RESULT_SUCCESS) {
@@ -772,6 +795,8 @@ static int xc5000_is_firmware_loaded(struct dvb_frontend *fe)
 	int ret;
 	u16 id;
 
+//	dprintk(1, "%s()\n", __func__);
+
 	ret = xc5000_readreg(priv, XREG_PRODUCT_ID, &id);
 	if (ret == XC_RESULT_SUCCESS) {
 		if (id == XC_PRODUCT_ID_FW_NOT_LOADED)
@@ -790,7 +815,7 @@ static int xc5000_set_tv_freq(struct dvb_frontend *fe,
 {
 	struct xc5000_priv *priv = fe->tuner_priv;
 	int ret;
-
+	dprintk(1, "%s()\n", __func__);
 	dprintk(1, "%s() frequency=%d (in units of 62.5khz)\n",
 		__func__, params->frequency);
 
@@ -878,7 +903,7 @@ static int xc5000_set_radio_freq(struct dvb_frontend *fe,
 	struct xc5000_priv *priv = fe->tuner_priv;
 	int ret = -EINVAL;
 	u8 radio_input;
-
+	dprintk(1, "%s()\n", __func__);
 	dprintk(1, "%s() frequency=%d (in units of khz)\n",
 		__func__, params->frequency);
 
@@ -935,14 +960,17 @@ static int xc5000_set_analog_params(struct dvb_frontend *fe,
 {
 	struct xc5000_priv *priv = fe->tuner_priv;
 	int ret = -EINVAL;
+printk("sap\n");
+	mutex_lock(&xc5000_list_mutex);
+//	dprintk(1, "%s()\n", __func__);
 
 	if (priv->i2c_props.adap == NULL)
-		return -EINVAL;
+		goto errexit;
 
 	if (xc5000_is_firmware_loaded(fe) != XC_RESULT_SUCCESS) {
 		if (xc_load_fw_and_init_tuner(fe) != XC_RESULT_SUCCESS) {
 			dprintk(1, "Unable to load firmware and init tuner\n");
-			return -EINVAL;
+			goto errexit;
 		}
 	}
 
@@ -956,7 +984,12 @@ static int xc5000_set_analog_params(struct dvb_frontend *fe,
 		break;
 	}
 
+	mutex_unlock(&xc5000_list_mutex);
 	return ret;
+
+errexit:
+	mutex_unlock(&xc5000_list_mutex);
+	return -EINVAL;
 }
 
 
@@ -982,6 +1015,8 @@ static int xc5000_get_status(struct dvb_frontend *fe, u32 *status)
 	struct xc5000_priv *priv = fe->tuner_priv;
 	u16 lock_status = 0;
 
+	dprintk(1, "%s()\n", __func__);
+
 	xc_get_lock_status(priv, &lock_status);
 
 	dprintk(1, "%s() lock_status = 0x%08x\n", __func__, lock_status);
@@ -996,6 +1031,10 @@ static int xc_load_fw_and_init_tuner(struct dvb_frontend *fe)
 	struct xc5000_priv *priv = fe->tuner_priv;
 	int ret = 0;
 
+	dprintk(1, "%s()\n", __func__);
+
+//	mutex_lock(&xc5000_list_mutex);
+
 	if (xc5000_is_firmware_loaded(fe) != XC_RESULT_SUCCESS) {
 		ret = xc5000_fwupload(fe);
 		if (ret != XC_RESULT_SUCCESS)
@@ -1015,6 +1054,8 @@ static int xc_load_fw_and_init_tuner(struct dvb_frontend *fe)
 	/* Default to "CABLE" mode */
 	ret |= xc_write_reg(priv, XREG_SIGNALSOURCE, XC_RF_MODE_CABLE);
 
+//	mutex_unlock(&xc5000_list_mutex);
+
 	return ret;
 }
 
diff --git a/drivers/media/video/saa7134/Makefile b/drivers/media/video/saa7134/Makefile
index 8a5ff4d..d698ddc 100644
--- a/drivers/media/video/saa7134/Makefile
+++ b/drivers/media/video/saa7134/Makefile
@@ -1,10 +1,10 @@
 
 saa7134-y :=	saa7134-cards.o saa7134-core.o saa7134-i2c.o
 saa7134-y +=	saa7134-ts.o saa7134-tvaudio.o saa7134-vbi.o
-saa7134-y +=	saa7134-video.o
+saa7134-y +=	saa7134-video.o saa7134-spi.o
 saa7134-$(CONFIG_VIDEO_SAA7134_RC) += saa7134-input.o
 
-obj-$(CONFIG_VIDEO_SAA7134) +=  saa6752hs.o saa7134.o saa7134-empress.o
+obj-$(CONFIG_VIDEO_SAA7134) +=  saa6752hs.o saa7134.o saa7134-empress.o upd61151.o
 
 obj-$(CONFIG_VIDEO_SAA7134_ALSA) += saa7134-alsa.o
 
diff --git a/drivers/media/video/saa7134/saa7134-cards.c b/drivers/media/video/saa7134/saa7134-cards.c
index 61c6007..83a0622 100644
--- a/drivers/media/video/saa7134/saa7134-cards.c
+++ b/drivers/media/video/saa7134/saa7134-cards.c
@@ -5347,24 +5347,43 @@ struct saa7134_board saa7134_boards[] = {
 		.radio_type     = UNSET,
 		.tuner_addr     = ADDR_UNSET,
 		.radio_addr     = ADDR_UNSET,
-		.mpeg           = SAA7134_MPEG_DVB,
+		.mpeg           = (SAA7134_MPEG_EMPRESS | SAA7134_MPEG_DVB),
+		.encoder_type   = SAA7134_ENCODER_muPD61151,
+		.gpiomask       = 0x00860000,
 		.inputs         = { {
 			.name = name_tv,
 			.vmux = 2,
 			.amux = TV,
 			.tv   = 1,
+			.gpio = 0x00860000
 		}, {
 			.name = name_comp1,
 			.vmux = 0,
 			.amux = LINE1,
+			.gpio = 0x00860000
 		}, {
 			.name = name_svideo,
 			.vmux = 9,
 			.amux = LINE1,
+			.gpio = 0x00860000
 		} },
 		.radio = {
 			.name = name_radio,
 			.amux = TV,
+			.gpio = 0x00860000
+		},
+		.video_out = CCIR656,
+		.vid_port_opts  = (SET_T_CODE_POLARITY_NON_INVERTED |
+					SET_CLOCK_NOT_DELAYED |
+					SET_CLOCK_INVERTED |
+					SET_VSYNC_OFF),
+		.spi = {
+			.cs    = 17,
+			.clock = 18,
+			.mosi  = 23,
+			.miso  = 21,
+			.num_chipselect = 1,
+			.spi_enable = 1,
 		},
 	},
 	[SAA7134_BOARD_ZOLID_HYBRID_PCI] = {
diff --git a/drivers/media/video/saa7134/saa7134-core.c b/drivers/media/video/saa7134/saa7134-core.c
index 41f836f..b5bb0af 100644
--- a/drivers/media/video/saa7134/saa7134-core.c
+++ b/drivers/media/video/saa7134/saa7134-core.c
@@ -140,6 +140,17 @@ void saa7134_set_gpio(struct saa7134_dev *dev, int bit_no, int value)
 	}
 }
 
+u32 saa7134_get_gpio(struct saa7134_dev *dev)
+{
+	unsigned long status;
+
+	/* rising SAA7134_GPIO_GPRESCAN reads the status */
+	saa_andorb(SAA7134_GPIO_GPMODE3,SAA7134_GPIO_GPRESCAN,0);
+	saa_andorb(SAA7134_GPIO_GPMODE3,SAA7134_GPIO_GPRESCAN,SAA7134_GPIO_GPRESCAN);
+	status = saa_readl(SAA7134_GPIO_GPSTATUS0 >> 2) & 0xfffffff;
+	return status;
+}
+
 /* ------------------------------------------------------------------ */
 
 
@@ -150,10 +161,18 @@ void saa7134_set_gpio(struct saa7134_dev *dev, int bit_no, int value)
 
 static void request_module_async(struct work_struct *work){
 	struct saa7134_dev* dev = container_of(work, struct saa7134_dev, request_module_wk);
+printk("request_mod_async\n");
 	if (card_is_empress(dev))
+	{
+	printk("request mod empress\n");
 		request_module("saa7134-empress");
+	}
+printk("dvb = %d\n", card_is_dvb(dev));
 	if (card_is_dvb(dev))
+	{
+		printk("request mod dvb\n");
 		request_module("saa7134-dvb");
+	}
 	if (alsa) {
 		if (dev->pci->device != PCI_DEVICE_ID_PHILIPS_SAA7130)
 			request_module("saa7134-alsa");
@@ -836,15 +855,54 @@ static void mpeg_ops_attach(struct saa7134_mpeg_ops *ops,
 			    struct saa7134_dev *dev)
 {
 	int err;
-
+printk("mpeg_ops_attach start\n");
+#if 0
 	if (NULL != dev->mops)
+	{
+		printk("mpeg_ops_attach FAIL stop, mops already exist FAILURE\n");
 		return;
-	if (saa7134_boards[dev->board].mpeg != ops->type)
+	}
+	if ( !(saa7134_boards[dev->board].mpeg & ops->type))
+	{
+		printk("mpeg_ops_attach FAIL stop, type FAILURE\n");
 		return;
+	}
 	err = ops->init(dev);
 	if (0 != err)
+	{
+	printk("mpeg_ops_attach FAIL stop, init FAILURE\n");
 		return;
+	}
+printk("mpeg_ops_attach OK stop\n");
 	dev->mops = ops;
+#endif
+}
+
+static void dvb_ops_attach(struct saa7134_mpeg_ops *ops,
+			    struct saa7134_dev *dev)
+{
+	int err;
+printk("dvb_ops_attach start\n");
+#if 0
+	if (NULL != dev->dops)
+	{
+		printk("dvb_ops_attach FAIL stop, mops already exist FAILURE\n");
+		return;
+	}
+	if ( !(saa7134_boards[dev->board].mpeg & ops->type))
+	{
+		printk("dvb_ops_attach FAIL stop, type FAILURE\n");
+		return;
+	}
+	err = ops->init(dev);
+	if (0 != err)
+	{
+	printk("dvb_ops_attach FAIL stop, init FAILURE\n");
+		return;
+	}
+printk("dvb_ops_attach OK stop\n");
+	dev->dops = ops;
+#endif
 }
 
 static void mpeg_ops_detach(struct saa7134_mpeg_ops *ops,
@@ -858,13 +916,29 @@ static void mpeg_ops_detach(struct saa7134_mpeg_ops *ops,
 	dev->mops = NULL;
 }
 
+static void dvb_ops_detach(struct saa7134_mpeg_ops *ops,
+			    struct saa7134_dev *dev)
+{
+	if (NULL == dev->dops)
+		return;
+	if (dev->dops != ops)
+		return;
+	dev->dops->fini(dev);
+	dev->dops = NULL;
+}
+
 static int __devinit saa7134_initdev(struct pci_dev *pci_dev,
 				     const struct pci_device_id *pci_id)
 {
 	struct saa7134_dev *dev;
 	struct saa7134_mpeg_ops *mops;
+	struct saa7134_mpeg_ops *dops;
 	int err;
 
+#if defined(CONFIG_SPI) && (defined(CONFIG_SPI_BITBANG_MODULE) || defined(CONFIG_SPI_BITBANG))
+	struct spi_board_info   spi_conf;
+#endif
+
 	if (saa7134_devcount == SAA7134_MAXBOARDS)
 		return -ENOMEM;
 
@@ -1004,12 +1078,61 @@ static int __devinit saa7134_initdev(struct pci_dev *pci_dev,
 
 	saa7134_hwinit2(dev);
 
-	/* load i2c helpers */
+#if defined(CONFIG_SPI) && (defined(CONFIG_SPI_BITBANG_MODULE) || defined(CONFIG_SPI_BITBANG))
+	/* initialize software SPI bus */
+	if (saa7134_boards[dev->board].spi.spi_enable)
+	{
+		switch (dev->board)
+		{
+		case SAA7134_BOARD_BEHOLD_X7:
+			strlcpy(spi_conf.modalias, "upd61151", sizeof(spi_conf.modalias));
+			spi_conf.max_speed_hz = 50000000;
+			spi_conf.chip_select = 0;
+			spi_conf.mode = SPI_MODE_0;
+			spi_conf.controller_data = NULL;
+			spi_conf.platform_data = NULL;
+			break;
+		}
+
+		dev->spi = saa7134_boards[dev->board].spi;
+
+		/* register SPI master and SPI slave */
+		if (saa7134_spi_register(dev, &spi_conf))
+			saa7134_boards[dev->board].spi.spi_enable = 0;
+	}
+#endif
+
+	/* load bus helpers */
 	if (card_is_empress(dev)) {
-		struct v4l2_subdev *sd =
-			v4l2_i2c_new_subdev(&dev->v4l2_dev, &dev->i2c_adap,
+		struct v4l2_subdev *sd = NULL;
+
+		dev->encoder_type = saa7134_boards[dev->board].encoder_type;
+
+		switch (dev->encoder_type) {
+		case SAA7134_ENCODER_muPD61151:
+		{
+			printk(KERN_INFO "%s: found muPD61151 MPEG encoder\n", dev->name);
+
+#if defined(CONFIG_SPI) && (defined(CONFIG_SPI_BITBANG_MODULE) || defined(CONFIG_SPI_BITBANG))
+			if (saa7134_boards[dev->board].spi.spi_enable)
+				sd = v4l2_spi_new_subdev(&dev->v4l2_dev, dev->spi_adap, &spi_conf);
+#else
+			printk(KERN_INFO "%s: You can't use muPD61151 MPEG2 encoder. SPI subsystem not included into kernel.\n", dev->name);
+#endif
+
+		}
+			break;
+		case SAA7134_ENCODER_SAA6752HS:
+		{
+			sd = v4l2_i2c_new_subdev(&dev->v4l2_dev, &dev->i2c_adap,
 				"saa6752hs",
 				saa7134_boards[dev->board].empress_addr, NULL);
+		}
+			break;
+		default:
+			printk(KERN_INFO "%s: MPEG encoder is not configured\n", dev->name);
+		    break;
+		}
 
 		if (sd)
 			sd->grp_id = GRP_EMPRESS;
@@ -1032,6 +1155,9 @@ static int __devinit saa7134_initdev(struct pci_dev *pci_dev,
 	mutex_lock(&saa7134_devlist_lock);
 	list_for_each_entry(mops, &mops_list, next)
 		mpeg_ops_attach(mops, dev);
+//	list_add_tail(&dev->devlist, &saa7134_devlist);
+	list_for_each_entry(dops, &mops_list, next)
+		dvb_ops_attach(dops, dev);
 	list_add_tail(&dev->devlist, &saa7134_devlist);
 	mutex_unlock(&saa7134_devlist_lock);
 
@@ -1080,11 +1206,15 @@ static int __devinit saa7134_initdev(struct pci_dev *pci_dev,
 
 	if (saa7134_dmasound_init && !dev->dmasound.priv_data)
 		saa7134_dmasound_init(dev);
-
+printk("befor request_submodules\n");
 	request_submodules(dev);
 	return 0;
 
  fail4:
+#if defined(CONFIG_SPI) && (defined(CONFIG_SPI_BITBANG_MODULE) || defined(CONFIG_SPI_BITBANG))
+	if ((card_is_empress(dev)) && (dev->encoder_type == SAA7134_ENCODER_muPD61151))
+		saa7134_spi_unregister(dev);
+#endif
 	saa7134_unregister_video(dev);
 	saa7134_i2c_unregister(dev);
 	free_irq(pci_dev->irq, dev);
@@ -1106,6 +1236,7 @@ static void __devexit saa7134_finidev(struct pci_dev *pci_dev)
 	struct v4l2_device *v4l2_dev = pci_get_drvdata(pci_dev);
 	struct saa7134_dev *dev = container_of(v4l2_dev, struct saa7134_dev, v4l2_dev);
 	struct saa7134_mpeg_ops *mops;
+	struct saa7134_mpeg_ops *dops;
 
 	flush_request_submodules(dev);
 
@@ -1137,6 +1268,8 @@ static void __devexit saa7134_finidev(struct pci_dev *pci_dev)
 	list_del(&dev->devlist);
 	list_for_each_entry(mops, &mops_list, next)
 		mpeg_ops_detach(mops, dev);
+	list_for_each_entry(dops, &mops_list, next)
+		dvb_ops_detach(dops, dev);
 	mutex_unlock(&saa7134_devlist_lock);
 	saa7134_devcount--;
 
@@ -1293,12 +1426,24 @@ static int saa7134_resume(struct pci_dev *pci_dev)
 int saa7134_ts_register(struct saa7134_mpeg_ops *ops)
 {
 	struct saa7134_dev *dev;
-
-	mutex_lock(&saa7134_devlist_lock);
-	list_for_each_entry(dev, &saa7134_devlist, devlist)
-		mpeg_ops_attach(ops, dev);
-	list_add_tail(&ops->next,&mops_list);
-	mutex_unlock(&saa7134_devlist_lock);
+printk("saa7134_ts_register start\n");
+	if (ops -> type == SAA7134_MPEG_EMPRESS) {
+	printk("SAA7134_MPEG_EMPRESS found\n");
+		mutex_lock(&saa7134_devlist_lock);
+		list_for_each_entry(dev, &saa7134_devlist, devlist)
+			mpeg_ops_attach(ops, dev);
+		list_add_tail(&ops->next,&mops_list);
+		mutex_unlock(&saa7134_devlist_lock);
+	}
+	if (ops -> type == SAA7134_MPEG_DVB) {
+	printk("SAA7134_MPEG_DVB found\n");
+		mutex_lock(&saa7134_devlist_lock);
+		list_for_each_entry(dev, &saa7134_devlist, devlist)
+			dvb_ops_attach(ops, dev);
+		list_add_tail(&ops->next,&mops_list);
+		mutex_unlock(&saa7134_devlist_lock);
+	}
+printk("saa7134_ts_register stop\n");
 	return 0;
 }
 
@@ -1306,11 +1451,20 @@ void saa7134_ts_unregister(struct saa7134_mpeg_ops *ops)
 {
 	struct saa7134_dev *dev;
 
-	mutex_lock(&saa7134_devlist_lock);
-	list_del(&ops->next);
-	list_for_each_entry(dev, &saa7134_devlist, devlist)
-		mpeg_ops_detach(ops, dev);
-	mutex_unlock(&saa7134_devlist_lock);
+	if (ops -> type == SAA7134_MPEG_EMPRESS) {
+		mutex_lock(&saa7134_devlist_lock);
+		list_del(&ops->next);
+		list_for_each_entry(dev, &saa7134_devlist, devlist)
+			mpeg_ops_detach(ops, dev);
+		mutex_unlock(&saa7134_devlist_lock);
+	}
+	if (ops -> type == SAA7134_MPEG_DVB) {
+		mutex_lock(&saa7134_devlist_lock);
+		list_del(&ops->next);
+		list_for_each_entry(dev, &saa7134_devlist, devlist)
+			dvb_ops_detach(ops, dev);
+		mutex_unlock(&saa7134_devlist_lock);
+	}
 }
 
 EXPORT_SYMBOL(saa7134_ts_register);
@@ -1354,6 +1508,7 @@ module_exit(saa7134_fini);
 /* ----------------------------------------------------------- */
 
 EXPORT_SYMBOL(saa7134_set_gpio);
+EXPORT_SYMBOL(saa7134_get_gpio);
 EXPORT_SYMBOL(saa7134_boards);
 
 /* ----------------- for the DMA sound modules --------------- */
diff --git a/drivers/media/video/saa7134/saa7134-dvb.c b/drivers/media/video/saa7134/saa7134-dvb.c
index f65cad2..d9438e3 100644
--- a/drivers/media/video/saa7134/saa7134-dvb.c
+++ b/drivers/media/video/saa7134/saa7134-dvb.c
@@ -938,6 +938,41 @@ static struct zl10353_config behold_x7_config = {
 	.disable_i2c_gate_ctrl = 1,
 };
 
+static int zl10353_dvb_bus_ctrl_behold_x7(struct dvb_frontend *fe, int acquire) {
+	struct saa7134_dev *dev = fe->dvb->priv;
+	static u8 zl10353_ts_enable[]  = { 0x50, 0x03};
+	static u8 zl10353_ts_disable[] = { 0x50, 0x05};
+	struct i2c_msg zl10353_msg = {.addr = behold_x7_config.demod_address,
+					.flags = 0, .len = 2};
+
+printk("zl10353_dvb_bus_ctrl() acquire = %d\n",acquire);
+
+	if (acquire)
+	{
+		zl10353_msg.buf = zl10353_ts_enable;
+		dev->ts.mpeg = SAA7134_MPEG_DVB;
+		saa7134_boards[dev->board].ts_type = SAA7134_MPEG_TS_PARALLEL;
+printk("set SAA7134_MPEG_DVB\n");
+	}
+	else
+	{
+		zl10353_msg.buf = zl10353_ts_disable;
+		dev->ts.mpeg = SAA7134_MPEG_EMPRESS;
+		saa7134_boards[dev->board].ts_type = SAA7134_MPEG_PS_PARALLEL;
+printk("set SAA7134_MPEG_EMPRESS\n");
+	}
+
+	/* Switch TS bus of the zl10353 */
+	if (i2c_transfer(&dev->i2c_adap, &zl10353_msg, 1) != 1) {
+		wprintk("could not access zl10353 TS bus gate control\n");
+		return -EIO;
+	}
+
+	msleep(10);
+
+	return 0;
+}
+
 /* ==================================================================
  * tda10086 based DVB-S cards, helper functions
  */
@@ -1132,18 +1167,18 @@ static int dvb_init(struct saa7134_dev *dev)
 	int ret;
 	int attach_xc3028 = 0;
 	struct videobuf_dvb_frontend *fe0;
-
+printk("saa7134-dvb init start\n");
 	/* FIXME: add support for multi-frontend */
 	mutex_init(&dev->frontends.lock);
 	INIT_LIST_HEAD(&dev->frontends.felist);
-
+printk("befor dvb_alloc_frontend\n");
 	printk(KERN_INFO "%s() allocating 1 frontend\n", __func__);
 	fe0 = videobuf_dvb_alloc_frontend(&dev->frontends, 1);
 	if (!fe0) {
 		printk(KERN_ERR "%s() failed to alloc\n", __func__);
 		return -ENOMEM;
 	}
-
+printk("befor videobuf_dvb\n");
 	/* init struct videobuf_dvb */
 	dev->ts.nr_bufs    = 32;
 	dev->ts.nr_packets = 32*4;
@@ -1154,7 +1189,7 @@ static int dvb_init(struct saa7134_dev *dev)
 			    V4L2_FIELD_ALTERNATE,
 			    sizeof(struct saa7134_buf),
 			    dev, NULL);
-
+printk("befor switch dev->board\n");
 	switch (dev->board) {
 	case SAA7134_BOARD_PINNACLE_300I_DVBT_PAL:
 		dprintk("pinnacle 300i dvb setup\n");
@@ -1592,6 +1627,7 @@ static int dvb_init(struct saa7134_dev *dev)
 		fe0->dvb.frontend = dvb_attach(zl10353_attach,
 						&behold_x7_config,
 						&dev->i2c_adap);
+		printk("dvb.frontend = %p\n", fe0->dvb.frontend);
 		if (fe0->dvb.frontend) {
 			dvb_attach(xc5000_attach, fe0->dvb.frontend,
 				   &dev->i2c_adap, &behold_x7_tunerconfig);
@@ -1602,6 +1638,7 @@ static int dvb_init(struct saa7134_dev *dev)
 						&behold_x7_config,
 						&dev->i2c_adap);
 		if (fe0->dvb.frontend) {
+			fe0->dvb.frontend->ops.ts_bus_ctrl = zl10353_dvb_bus_ctrl_behold_x7;
 			dvb_attach(xc5000_attach, fe0->dvb.frontend,
 				   &dev->i2c_adap, &behold_x7_tunerconfig);
 		}
@@ -1719,10 +1756,12 @@ static int dvb_init(struct saa7134_dev *dev)
 		if (fe0->dvb.frontend->ops.tuner_ops.sleep)
 			fe0->dvb.frontend->ops.tuner_ops.sleep(fe0->dvb.frontend);
 	}
+printk("saa7134-dvb init OK stop\n");
 	return ret;
 
 dettach_frontend:
 	videobuf_dvb_dealloc_frontends(&dev->frontends);
+printk("saa7134-dvb init FAIL stop\n");
 	return -EINVAL;
 }
 
@@ -1774,6 +1813,7 @@ static struct saa7134_mpeg_ops dvb_ops = {
 
 static int __init dvb_register(void)
 {
+printk("call saa7134_ts_register\n");
 	return saa7134_ts_register(&dvb_ops);
 }
 
diff --git a/drivers/media/video/saa7134/saa7134-empress.c b/drivers/media/video/saa7134/saa7134-empress.c
index 18294db..2f9d4f8 100644
--- a/drivers/media/video/saa7134/saa7134-empress.c
+++ b/drivers/media/video/saa7134/saa7134-empress.c
@@ -51,6 +51,7 @@ MODULE_PARM_DESC(debug,"enable debug messages");
 
 static void ts_reset_encoder(struct saa7134_dev* dev)
 {
+printk("ts_reset_encoder() start\n");
 	if (!dev->empress_started)
 		return;
 
@@ -59,12 +60,13 @@ static void ts_reset_encoder(struct saa7134_dev* dev)
 	saa_writeb(SAA7134_SPECIAL_MODE, 0x01);
 	msleep(100);
 	dev->empress_started = 0;
+printk("ts_reset_encoder() stop\n");
 }
 
 static int ts_init_encoder(struct saa7134_dev* dev)
 {
 	u32 leading_null_bytes = 0;
-
+printk("ts_init_encoder() start\n");
 	/* If more cards start to need this, then this
 	   should probably be added to the card definitions. */
 	switch (dev->board) {
@@ -77,6 +79,7 @@ static int ts_init_encoder(struct saa7134_dev* dev)
 	ts_reset_encoder(dev);
 	saa_call_all(dev, core, init, leading_null_bytes);
 	dev->empress_started = 1;
+printk("ts_init_encoder() stop\n");
 	return 0;
 }
 
@@ -87,7 +90,7 @@ static int ts_open(struct file *file)
 	struct video_device *vdev = video_devdata(file);
 	struct saa7134_dev *dev = video_drvdata(file);
 	int err;
-
+printk("ts_open() start\n");
 	dprintk("open dev=%s\n", video_device_node_name(vdev));
 	err = -EBUSY;
 	if (!mutex_trylock(&dev->empress_tsq.vb_lock))
@@ -105,13 +108,14 @@ static int ts_open(struct file *file)
 
 done:
 	mutex_unlock(&dev->empress_tsq.vb_lock);
+printk("ts_open() stop\n");
 	return err;
 }
 
 static int ts_release(struct file *file)
 {
 	struct saa7134_dev *dev = file->private_data;
-
+printk("ts_release() start\n");
 	videobuf_stop(&dev->empress_tsq);
 	videobuf_mmap_free(&dev->empress_tsq);
 
@@ -123,7 +127,7 @@ static int ts_release(struct file *file)
 		saa_readb(SAA7134_AUDIO_MUTE_CTRL) | (1 << 6));
 
 	atomic_dec(&dev->empress_users);
-
+printk("ts_release() stop\n");
 	return 0;
 }
 
@@ -167,7 +171,7 @@ static int empress_querycap(struct file *file, void  *priv,
 					struct v4l2_capability *cap)
 {
 	struct saa7134_dev *dev = file->private_data;
-
+printk("empress_querycap() start\n");
 	strcpy(cap->driver, "saa7134");
 	strlcpy(cap->card, saa7134_boards[dev->board].name,
 		sizeof(cap->card));
@@ -177,44 +181,49 @@ static int empress_querycap(struct file *file, void  *priv,
 		V4L2_CAP_VIDEO_CAPTURE |
 		V4L2_CAP_READWRITE |
 		V4L2_CAP_STREAMING;
+printk("empress_querycap() stop\n");
 	return 0;
 }
 
 static int empress_enum_input(struct file *file, void *priv,
 					struct v4l2_input *i)
 {
+printk("empress_enum_input() start\n");
 	if (i->index != 0)
 		return -EINVAL;
 
 	i->type = V4L2_INPUT_TYPE_CAMERA;
 	strcpy(i->name, "CCIR656");
-
+printk("empress_enum_input() stop\n");
 	return 0;
 }
 
 static int empress_g_input(struct file *file, void *priv, unsigned int *i)
 {
 	*i = 0;
+printk("empress_g_input() start\n");
 	return 0;
 }
 
 static int empress_s_input(struct file *file, void *priv, unsigned int i)
 {
+printk("empress_s_input() start\n");
 	if (i != 0)
 		return -EINVAL;
-
+printk("empress_s_input() stop\n");
 	return 0;
 }
 
 static int empress_enum_fmt_vid_cap(struct file *file, void  *priv,
 					struct v4l2_fmtdesc *f)
 {
+printk("empress_enum_fmt_vid_cap() start\n");
 	if (f->index != 0)
 		return -EINVAL;
 
 	strlcpy(f->description, "MPEG TS", sizeof(f->description));
 	f->pixelformat = V4L2_PIX_FMT_MPEG;
-
+printk("empress_enum_fmt_vid_cap() stop\n");
 	return 0;
 }
 
@@ -223,13 +232,13 @@ static int empress_g_fmt_vid_cap(struct file *file, void *priv,
 {
 	struct saa7134_dev *dev = file->private_data;
 	struct v4l2_mbus_framefmt mbus_fmt;
-
+printk("empress_g_fmt_vid_cap() start\n");
 	saa_call_all(dev, video, g_mbus_fmt, &mbus_fmt);
 
 	v4l2_fill_pix_format(&f->fmt.pix, &mbus_fmt);
 	f->fmt.pix.pixelformat  = V4L2_PIX_FMT_MPEG;
 	f->fmt.pix.sizeimage    = TS_PACKET_SIZE * dev->ts.nr_packets;
-
+printk("empress_g_fmt_vid_cap() stop\n");
 	return 0;
 }
 
@@ -238,14 +247,14 @@ static int empress_s_fmt_vid_cap(struct file *file, void *priv,
 {
 	struct saa7134_dev *dev = file->private_data;
 	struct v4l2_mbus_framefmt mbus_fmt;
-
+printk("empress_s_fmt_vid_cap() start\n");
 	v4l2_fill_mbus_format(&mbus_fmt, &f->fmt.pix, V4L2_MBUS_FMT_FIXED);
 	saa_call_all(dev, video, s_mbus_fmt, &mbus_fmt);
 	v4l2_fill_pix_format(&f->fmt.pix, &mbus_fmt);
 
 	f->fmt.pix.pixelformat  = V4L2_PIX_FMT_MPEG;
 	f->fmt.pix.sizeimage    = TS_PACKET_SIZE * dev->ts.nr_packets;
-
+printk("empress_s_fmt_vid_cap() stop\n");
 	return 0;
 }
 
@@ -253,10 +262,10 @@ static int empress_try_fmt_vid_cap(struct file *file, void *priv,
 				struct v4l2_format *f)
 {
 	struct saa7134_dev *dev = file->private_data;
-
+printk("empress_try_fmt_vid_cap() start\n");
 	f->fmt.pix.pixelformat  = V4L2_PIX_FMT_MPEG;
 	f->fmt.pix.sizeimage    = TS_PACKET_SIZE * dev->ts.nr_packets;
-
+printk("empress_try_fmt_vid_cap() stop\n");
 	return 0;
 }
 
@@ -264,7 +273,7 @@ static int empress_reqbufs(struct file *file, void *priv,
 					struct v4l2_requestbuffers *p)
 {
 	struct saa7134_dev *dev = file->private_data;
-
+printk("empress_reqbufs()\n");
 	return videobuf_reqbufs(&dev->empress_tsq, p);
 }
 
@@ -272,21 +281,21 @@ static int empress_querybuf(struct file *file, void *priv,
 					struct v4l2_buffer *b)
 {
 	struct saa7134_dev *dev = file->private_data;
-
+printk("empress_querybuf()\n");
 	return videobuf_querybuf(&dev->empress_tsq, b);
 }
 
 static int empress_qbuf(struct file *file, void *priv, struct v4l2_buffer *b)
 {
 	struct saa7134_dev *dev = file->private_data;
-
+printk("empress_qbuf()\n");
 	return videobuf_qbuf(&dev->empress_tsq, b);
 }
 
 static int empress_dqbuf(struct file *file, void *priv, struct v4l2_buffer *b)
 {
 	struct saa7134_dev *dev = file->private_data;
-
+printk("empress_dqbuf()\n");
 	return videobuf_dqbuf(&dev->empress_tsq, b,
 				file->f_flags & O_NONBLOCK);
 }
@@ -295,7 +304,7 @@ static int empress_streamon(struct file *file, void *priv,
 					enum v4l2_buf_type type)
 {
 	struct saa7134_dev *dev = file->private_data;
-
+printk("empress_streamon()\n");
 	return videobuf_streamon(&dev->empress_tsq);
 }
 
@@ -303,7 +312,7 @@ static int empress_streamoff(struct file *file, void *priv,
 					enum v4l2_buf_type type)
 {
 	struct saa7134_dev *dev = file->private_data;
-
+printk("empress_streamoff()\n");
 	return videobuf_streamoff(&dev->empress_tsq);
 }
 
@@ -312,7 +321,7 @@ static int empress_s_ext_ctrls(struct file *file, void *priv,
 {
 	struct saa7134_dev *dev = file->private_data;
 	int err;
-
+printk("empress_s_ext_ctrls() start\n");
 	/* count == 0 is abused in saa6752hs.c, so that special
 		case is handled here explicitly. */
 	if (ctrls->count == 0)
@@ -323,7 +332,7 @@ static int empress_s_ext_ctrls(struct file *file, void *priv,
 
 	err = saa_call_empress(dev, core, s_ext_ctrls, ctrls);
 	ts_init_encoder(dev);
-
+printk("empress_s_ext_ctrls() stop\n");
 	return err;
 }
 
@@ -331,9 +340,10 @@ static int empress_g_ext_ctrls(struct file *file, void *priv,
 			       struct v4l2_ext_controls *ctrls)
 {
 	struct saa7134_dev *dev = file->private_data;
-
+printk("empress_g_ext_ctrls() start\n");
 	if (ctrls->ctrl_class != V4L2_CTRL_CLASS_MPEG)
 		return -EINVAL;
+printk("empress_g_ext_ctrls() stop\n");
 	return saa_call_empress(dev, core, g_ext_ctrls, ctrls);
 }
 
@@ -341,7 +351,7 @@ static int empress_g_ctrl(struct file *file, void *priv,
 					struct v4l2_control *c)
 {
 	struct saa7134_dev *dev = file->private_data;
-
+printk("empress_g_ctrl()\n");
 	return saa7134_g_ctrl_internal(dev, NULL, c);
 }
 
@@ -349,13 +359,14 @@ static int empress_s_ctrl(struct file *file, void *priv,
 					struct v4l2_control *c)
 {
 	struct saa7134_dev *dev = file->private_data;
-
+printk("empress_s_ctrl()\n");
 	return saa7134_s_ctrl_internal(dev, NULL, c);
 }
 
 static int empress_queryctrl(struct file *file, void *priv,
 					struct v4l2_queryctrl *c)
 {
+printk("empress_queryctrl() start\n");
 	/* Must be sorted from low to high control ID! */
 	static const u32 user_ctrls[] = {
 		V4L2_CID_USER_CLASS,
@@ -401,6 +412,7 @@ static int empress_queryctrl(struct file *file, void *priv,
 		return v4l2_ctrl_query_fill(c, 0, 0, 0, 0);
 	if (V4L2_CTRL_ID2CLASS(c->id) != V4L2_CTRL_CLASS_MPEG)
 		return saa7134_queryctrl(file, priv, c);
+printk("empress_queryctrl() stop\n");
 	return saa_call_empress(dev, core, queryctrl, c);
 }
 
@@ -408,9 +420,10 @@ static int empress_querymenu(struct file *file, void *priv,
 					struct v4l2_querymenu *c)
 {
 	struct saa7134_dev *dev = file->private_data;
-
+printk("empress_querymenu() start\n");
 	if (V4L2_CTRL_ID2CLASS(c->id) != V4L2_CTRL_CLASS_MPEG)
 		return -EINVAL;
+printk("empress_querymenu() stop\n");
 	return saa_call_empress(dev, core, querymenu, c);
 }
 
@@ -418,7 +431,7 @@ static int empress_g_chip_ident(struct file *file, void *fh,
 	       struct v4l2_dbg_chip_ident *chip)
 {
 	struct saa7134_dev *dev = file->private_data;
-
+printk("empress_g_chip_ident() start\n");
 	chip->ident = V4L2_IDENT_NONE;
 	chip->revision = 0;
 	if (chip->match.type == V4L2_CHIP_MATCH_I2C_DRIVER &&
@@ -426,20 +439,21 @@ static int empress_g_chip_ident(struct file *file, void *fh,
 		return saa_call_empress(dev, core, g_chip_ident, chip);
 	if (chip->match.type == V4L2_CHIP_MATCH_I2C_ADDR)
 		return saa_call_empress(dev, core, g_chip_ident, chip);
++printk("empress_g_chip_ident() stop FAIL\n");
 	return -EINVAL;
 }
 
 static int empress_s_std(struct file *file, void *priv, v4l2_std_id *id)
 {
 	struct saa7134_dev *dev = file->private_data;
-
+printk("empress_s_std()\n");
 	return saa7134_s_std_internal(dev, NULL, id);
 }
 
 static int empress_g_std(struct file *file, void *priv, v4l2_std_id *id)
 {
 	struct saa7134_dev *dev = file->private_data;
-
+printk("empress_g_std()\n");
 	*id = dev->tvnorm->id;
 	return 0;
 }
diff --git a/drivers/media/video/saa7134/saa7134-spi.c b/drivers/media/video/saa7134/saa7134-spi.c
new file mode 100644
index 0000000..35a1eaa
--- /dev/null
+++ b/drivers/media/video/saa7134/saa7134-spi.c
@@ -0,0 +1,159 @@
+/*
+ *
+ * Device driver for philips saa7134 based TV cards
+ * SPI software interface support
+ *
+ * (c) 2009 Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com>
+ *
+ *  Important: now support ONLY SPI_MODE_0, see FIXME
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+#if defined(CONFIG_SPI) && (defined(CONFIG_SPI_BITBANG_MODULE) || defined(CONFIG_SPI_BITBANG))
+
+#include "saa7134-reg.h"
+#include "saa7134.h"
+#include <media/v4l2-common.h>
+
+/* ----------------------------------------------------------- */
+
+static unsigned int spi_debug;
+module_param(spi_debug, int, 0644);
+MODULE_PARM_DESC(spi_debug,"enable debug messages [spi]");
+
+#define d1printk if (1 == spi_debug) printk
+#define d2printk if (2 == spi_debug) printk
+
+static inline void spidelay(unsigned d)
+{
+	ndelay(d);
+}
+
+static inline struct saa7134_spi_gpio *to_sb(struct spi_device *spi)
+{
+	return spi_master_get_devdata(spi->master);
+}
+
+static inline void setsck(struct spi_device *dev, int on)
+{
+	struct saa7134_spi_gpio *sb = to_sb(dev);
+
+	saa7134_set_gpio(sb->controller_data, sb->controller_data->spi.clock, on ? 1 : 0);
+}
+
+static inline void setmosi(struct spi_device *dev, int on)
+{
+	struct saa7134_spi_gpio *sb = to_sb(dev);
+
+	saa7134_set_gpio(sb->controller_data, sb->controller_data->spi.mosi, on ? 1 : 0);
+}
+
+static inline u32 getmiso(struct spi_device *dev)
+{
+	struct saa7134_spi_gpio *sb = to_sb(dev);
+	unsigned long status;
+
+	status = saa7134_get_gpio(sb->controller_data);
+	return !!( status & (1 << sb->controller_data->spi.miso));
+}
+
+#define EXPAND_BITBANG_TXRX 1
+#include <linux/spi/spi.h>
+#include <linux/spi/spi_bitbang.h>
+#include "spi_bitbang_txrx.h"
+
+static void saa7134_spi_gpio_chipsel(struct spi_device *dev, int on)
+{
+	struct saa7134_spi_gpio *sb = to_sb(dev);
+
+	if (on)
+	{
+		/* FIXME: set clock to zero by default, only SPI_MODE_0 compatible */
+		saa7134_set_gpio(sb->controller_data, sb->controller_data->spi.clock, 0);
+		saa7134_set_gpio(sb->controller_data, sb->controller_data->spi.cs, 0);
+	}
+	else
+		saa7134_set_gpio(sb->controller_data, sb->controller_data->spi.cs, 1);
+}
+
+/* Our actual bitbanger routine. */
+static u32 saa7134_txrx(struct spi_device *spi, unsigned nsecs, u32 word, u8 bits)
+{
+	return bitbang_txrx_be_cpha0(spi, nsecs, 0, 0, word, bits);
+}
+
+int saa7134_spi_register(struct saa7134_dev *dev, struct spi_board_info *info)
+{
+	struct spi_master *master = NULL;
+	struct saa7134_spi_gpio *sb = NULL;
+	int ret = 0;
+
+	master = spi_alloc_master(&dev->pci->dev, sizeof(struct saa7134_spi_gpio));
+
+	if (master == NULL) 
+	{
+		dev_err(&dev->pci->dev, "failed to allocate spi master\n");
+		ret = -ENOMEM;
+		goto err;
+	}
+
+	sb = spi_master_get_devdata(master);
+
+	master->num_chipselect = dev->spi.num_chipselect;
+	master->bus_num = -1;
+	sb->master = spi_master_get(master);
+	sb->bitbang.master = sb->master;
+	sb->bitbang.master->bus_num = -1;
+	sb->bitbang.master->num_chipselect = dev->spi.num_chipselect;
+	sb->bitbang.chipselect = saa7134_spi_gpio_chipsel;
+	sb->bitbang.txrx_word[SPI_MODE_0] = saa7134_txrx;
+
+	/* set state of spi pins */
+	saa7134_set_gpio(dev, dev->spi.cs, 1);
+	/* FIXME: set clock to zero by default, only SPI_MODE_0 compatible */
+	saa7134_set_gpio(dev, dev->spi.clock, 0);
+	saa7134_set_gpio(dev, dev->spi.mosi, 1);
+	saa7134_set_gpio(dev, dev->spi.miso, 3);
+
+	/* start SPI bitbang master */
+	ret = spi_bitbang_start(&sb->bitbang);
+	if (ret) {
+		dev_err(&dev->pci->dev, "Failed to register SPI master\n");
+		goto err_no_bitbang;
+	}
+	dev_info(&dev->pci->dev,
+		"spi master registered: bus_num=%d num_chipselect=%d\n",
+		master->bus_num, master->num_chipselect);
+
+	sb->controller_data = dev;
+	info->bus_num = sb->master->bus_num;
+	info->controller_data = master;
+	dev->spi_adap = master;
+
+err_no_bitbang:
+	spi_master_put(master);
+err:
+	return ret;
+}
+
+void saa7134_spi_unregister(struct saa7134_dev *dev)
+{
+	struct saa7134_spi_gpio *sb = spi_master_get_devdata(dev->spi_adap);
+
+	spi_bitbang_stop(&sb->bitbang);
+	spi_master_put(sb->master);
+}
+
+#endif
diff --git a/drivers/media/video/saa7134/saa7134-ts.c b/drivers/media/video/saa7134/saa7134-ts.c
index 2e3f4b4..9df27fb 100644
--- a/drivers/media/video/saa7134/saa7134-ts.c
+++ b/drivers/media/video/saa7134/saa7134-ts.c
@@ -85,6 +85,10 @@ static int buffer_prepare(struct videobuf_queue *q, struct videobuf_buffer *vb,
 	llength = TS_PACKET_SIZE;
 	lines = dev->ts.nr_packets;
 
+	if (saa7134_boards[dev->board].ts_type == SAA7134_MPEG_PS_PARALLEL)
+		llength = PS_PACKET_SIZE;
+printk("buffer_prepare set llength = %d\n", llength);
+
 	size = lines * llength;
 	if (0 != buf->vb.baddr  &&  buf->vb.bsize < size)
 		return -EINVAL;
@@ -129,8 +133,14 @@ static int
 buffer_setup(struct videobuf_queue *q, unsigned int *count, unsigned int *size)
 {
 	struct saa7134_dev *dev = q->priv_data;
+	unsigned int psize;
+
+	psize = TS_PACKET_SIZE;
+	if (saa7134_boards[dev->board].ts_type == SAA7134_MPEG_PS_PARALLEL)
+		psize = PS_PACKET_SIZE;
+printk("buffer_setup set psize = %d\n", psize);
+	*size = psize * dev->ts.nr_packets;
 
-	*size = TS_PACKET_SIZE * dev->ts.nr_packets;
 	if (0 == *count)
 		*count = dev->ts.nr_bufs;
 	*count = saa7134_buffer_count(*size,*count);
@@ -178,11 +188,18 @@ MODULE_PARM_DESC(ts_nr_packets,"size of a ts buffers (in ts packets)");
 
 int saa7134_ts_init_hw(struct saa7134_dev *dev)
 {
+	unsigned int psize;
+
+	psize = TS_PACKET_SIZE;
+	if (saa7134_boards[dev->board].ts_type == SAA7134_MPEG_PS_PARALLEL)
+		psize = PS_PACKET_SIZE;
+printk("buffer_setup set psize = %d\n", psize);
+
 	/* deactivate TS softreset */
 	saa_writeb(SAA7134_TS_SERIAL1, 0x00);
 	/* TSSOP high active, TSVAL high active, TSLOCK ignored */
 	saa_writeb(SAA7134_TS_PARALLEL, 0x6c);
-	saa_writeb(SAA7134_TS_PARALLEL_SERIAL, (TS_PACKET_SIZE-1));
+	saa_writeb(SAA7134_TS_PARALLEL_SERIAL, (psize - 1));
 	saa_writeb(SAA7134_TS_DMA0, ((dev->ts.nr_packets-1)&0xff));
 	saa_writeb(SAA7134_TS_DMA1, (((dev->ts.nr_packets-1)>>8)&0xff));
 	/* TSNOPIT=0, TSCOLAP=0 */
@@ -238,6 +255,11 @@ int saa7134_ts_stop(struct saa7134_dev *dev)
 		saa_writeb(SAA7134_TS_SERIAL0, 0x40);
 		dev->ts_started = 0;
 		break;
+	case SAA7134_MPEG_PS_PARALLEL:
+	printk("Stop SAA7134_MPEG_PS_PARALLEL\n");
+		saa_writeb(SAA7134_TS_PARALLEL, 0x5e);
+		dev->ts_started = 0;
+		break;
 	}
 	return 0;
 }
@@ -245,10 +267,16 @@ int saa7134_ts_stop(struct saa7134_dev *dev)
 /* Function for start TS */
 int saa7134_ts_start(struct saa7134_dev *dev)
 {
+	unsigned int psize;
 	dprintk("TS start\n");
 
 	BUG_ON(dev->ts_started);
 
+	psize = TS_PACKET_SIZE;
+	if (saa7134_boards[dev->board].ts_type == SAA7134_MPEG_PS_PARALLEL)
+		psize = PS_PACKET_SIZE;
+printk("buffer_setup set psize = %d\n", psize);
+
 	/* dma: setup channel 5 (= TS) */
 	saa_writeb(SAA7134_TS_DMA0, (dev->ts.nr_packets - 1) & 0xff);
 	saa_writeb(SAA7134_TS_DMA1,
@@ -256,7 +284,7 @@ int saa7134_ts_start(struct saa7134_dev *dev)
 	/* TSNOPIT=0, TSCOLAP=0 */
 	saa_writeb(SAA7134_TS_DMA2,
 		(((dev->ts.nr_packets - 1) >> 16) & 0x3f) | 0x00);
-	saa_writel(SAA7134_RS_PITCH(5), TS_PACKET_SIZE);
+	saa_writel(SAA7134_RS_PITCH(5), psize);
 	saa_writel(SAA7134_RS_CONTROL(5), SAA7134_RS_CONTROL_BURST_16 |
 					  SAA7134_RS_CONTROL_ME |
 					  (dev->ts.pt_ts.dma >> 12));
@@ -284,10 +312,19 @@ int saa7134_ts_start(struct saa7134_dev *dev)
 		saa_writeb(SAA7134_TS_PARALLEL_SERIAL, 0xbc);
 		saa_writeb(SAA7134_TS_SERIAL1, 0x02);
 		break;
+	case SAA7134_MPEG_PS_PARALLEL:
+	printk("Start SAA7134_MPEG_PS_PARALLEL\n");
+		/* TS clock inverted */
+		saa_writeb(SAA7134_TS_SERIAL1, 0x02);
+
+		saa_writeb(SAA7134_TS_SERIAL0, 0x40);
+		saa_writeb(SAA7134_TS_PARALLEL, 0xde |
+			(saa7134_boards[dev->board].ts_force_val << 4));
+		break;
 	}
 
 	dev->ts_started = 1;
-
+printk("start TS HERE \n");
 	return 0;
 }
 
diff --git a/drivers/media/video/saa7134/saa7134.h b/drivers/media/video/saa7134/saa7134.h
index f96cd5d..e2fc9e6 100644
--- a/drivers/media/video/saa7134/saa7134.h
+++ b/drivers/media/video/saa7134/saa7134.h
@@ -45,6 +45,11 @@
 #if defined(CONFIG_VIDEO_SAA7134_DVB) || defined(CONFIG_VIDEO_SAA7134_DVB_MODULE)
 #include <media/videobuf-dvb.h>
 #endif
+#if defined(CONFIG_SPI) && (defined(CONFIG_SPI_BITBANG_MODULE) || defined(CONFIG_SPI_BITBANG))
+#include <linux/spi/spi.h>
+#include <linux/spi/spi_gpio.h>
+#include <linux/spi/spi_bitbang.h>
+#endif
 
 #define UNSET (-1U)
 
@@ -355,14 +360,30 @@ struct saa7134_input {
 };
 
 enum saa7134_mpeg_type {
-	SAA7134_MPEG_UNUSED,
-	SAA7134_MPEG_EMPRESS,
-	SAA7134_MPEG_DVB,
+	SAA7134_MPEG_UNUSED  = 0,
+	SAA7134_MPEG_EMPRESS = 1,
+	SAA7134_MPEG_DVB     = 2,
 };
 
 enum saa7134_mpeg_ts_type {
 	SAA7134_MPEG_TS_PARALLEL = 0,
 	SAA7134_MPEG_TS_SERIAL,
+	SAA7134_MPEG_PS_PARALLEL,
+};
+
+enum saa7134_encoder_type {
+	SAA7134_ENCODER_UNUSED    = 0,
+	SAA7134_ENCODER_SAA6752HS = 1,
+	SAA7134_ENCODER_muPD61151 = 2,
+};
+
+struct saa7134_software_spi {
+	unsigned char cs:5;
+	unsigned char clock:5;
+	unsigned char mosi:5;
+	unsigned char miso:5;
+	unsigned char num_chipselect:3;
+	unsigned char spi_enable:1;
 };
 
 struct saa7134_board {
@@ -383,6 +404,9 @@ struct saa7134_board {
 	unsigned char		empress_addr;
 	unsigned char		rds_addr;
 
+	/* SPI info */
+	struct saa7134_software_spi	spi;
+
 	unsigned int            tda9887_conf;
 	unsigned int            tuner_config;
 
@@ -390,13 +414,14 @@ struct saa7134_board {
 	enum saa7134_video_out  video_out;
 	enum saa7134_mpeg_type  mpeg;
 	enum saa7134_mpeg_ts_type ts_type;
+	enum saa7134_encoder_type encoder_type;
 	unsigned int            vid_port_opts;
 	unsigned int            ts_force_val:1;
 };
 
 #define card_has_radio(dev)   (NULL != saa7134_boards[dev->board].radio.name)
-#define card_is_empress(dev)  (SAA7134_MPEG_EMPRESS == saa7134_boards[dev->board].mpeg)
-#define card_is_dvb(dev)      (SAA7134_MPEG_DVB     == saa7134_boards[dev->board].mpeg)
+#define card_is_empress(dev)  (SAA7134_MPEG_EMPRESS & saa7134_boards[dev->board].mpeg)
+#define card_is_dvb(dev)      (SAA7134_MPEG_DVB     & saa7134_boards[dev->board].mpeg)
 #define card_has_mpeg(dev)    (SAA7134_MPEG_UNUSED  != saa7134_boards[dev->board].mpeg)
 #define card(dev)             (saa7134_boards[dev->board])
 #define card_in(dev,n)        (saa7134_boards[dev->board].inputs[n])
@@ -519,6 +544,7 @@ struct saa7134_ts {
 	struct saa7134_pgtable     pt_ts;
 	int                        nr_packets;
 	int                        nr_bufs;
+	enum saa7134_mpeg_type     mpeg;
 };
 
 /* ts/mpeg ops */
@@ -530,6 +556,14 @@ struct saa7134_mpeg_ops {
 	void                       (*signal_change)(struct saa7134_dev *dev);
 };
 
+#if defined(CONFIG_SPI) && (defined(CONFIG_SPI_BITBANG_MODULE) || defined(CONFIG_SPI_BITBANG))
+struct saa7134_spi_gpio {
+	struct spi_bitbang         bitbang;
+	struct spi_master          *master;
+	struct saa7134_dev         *controller_data;
+};
+#endif
+
 /* global device status */
 struct saa7134_dev {
 	struct list_head           devlist;
@@ -578,6 +612,12 @@ struct saa7134_dev {
 	unsigned char              eedata[256];
 	int 			   has_rds;
 
+	/* software spi */
+	struct saa7134_software_spi spi;
+#if defined(CONFIG_SPI) && (defined(CONFIG_SPI_BITBANG_MODULE) || defined(CONFIG_SPI_BITBANG))
+	struct spi_master          *spi_adap;
+#endif
+
 	/* video overlay */
 	struct v4l2_framebuffer    ovbuf;
 	struct saa7134_format      *ovfmt;
@@ -637,9 +677,11 @@ struct saa7134_dev {
 	atomic_t 		   empress_users;
 	struct work_struct         empress_workqueue;
 	int                        empress_started;
+	enum saa7134_encoder_type  encoder_type;
 
 #if defined(CONFIG_VIDEO_SAA7134_DVB) || defined(CONFIG_VIDEO_SAA7134_DVB_MODULE)
 	/* SAA7134_MPEG_DVB only */
+	struct saa7134_mpeg_ops    *dops;
 	struct videobuf_dvb_frontends frontends;
 	int (*original_demod_sleep)(struct dvb_frontend *fe);
 	int (*original_set_voltage)(struct dvb_frontend *fe, fe_sec_voltage_t voltage);
@@ -703,6 +745,7 @@ extern int saa7134_no_overlay;
 
 void saa7134_track_gpio(struct saa7134_dev *dev, char *msg);
 void saa7134_set_gpio(struct saa7134_dev *dev, int bit_no, int value);
+u32 saa7134_get_gpio(struct saa7134_dev *dev);
 
 #define SAA7134_PGTABLE_SIZE 4096
 
@@ -748,6 +791,13 @@ int saa7134_tuner_callback(void *priv, int component, int command, int arg);
 int saa7134_i2c_register(struct saa7134_dev *dev);
 int saa7134_i2c_unregister(struct saa7134_dev *dev);
 
+/* ----------------------------------------------------------- */
+/* saa7134-spi.c                                               */
+
+#if defined(CONFIG_SPI) && (defined(CONFIG_SPI_BITBANG_MODULE) || defined(CONFIG_SPI_BITBANG))
+int saa7134_spi_register(struct saa7134_dev *dev, struct spi_board_info *info);
+void saa7134_spi_unregister(struct saa7134_dev *dev);
+#endif
 
 /* ----------------------------------------------------------- */
 /* saa7134-video.c                                             */
@@ -774,6 +824,7 @@ void saa7134_irq_video_done(struct saa7134_dev *dev, unsigned long status);
 /* saa7134-ts.c                                                */
 
 #define TS_PACKET_SIZE 188 /* TS packets 188 bytes */
+#define PS_PACKET_SIZE 128 /* PS packets 128 bytes */
 
 extern struct videobuf_queue_ops saa7134_ts_qops;
 
diff --git a/drivers/media/video/saa7134/upd61151.c b/drivers/media/video/saa7134/upd61151.c
new file mode 100644
index 0000000..3c792bd
--- /dev/null
+++ b/drivers/media/video/saa7134/upd61151.c
@@ -0,0 +1,1546 @@
+ /*
+    upd61151 - driver for the uPD61151 by NEC
+
+    Copyright (C) Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com>
+
+    Based on the saa6752s.c driver.
+    Copyright (C) 2004 Andrew de Quincey
+
+    This program is free software; you can redistribute it and/or modify
+    it under the terms of the GNU General Public License vs published by
+    the Free Software Foundation; either version 2 of the License, or
+    (at your option) any later version.
+
+    This program is distributed in the hope that it will be useful,
+    but WITHOUT ANY WARRANTY; without even the implied warranty of
+    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+    GNU General Public License for more details.
+
+    You should have received a copy of the GNU General Public License
+    along with this program; if not, write to the Free Software
+    Foundation, Inc., 675 Mvss Ave, Cambridge, MA 02139, USA.
+  */
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/device.h>
+#include <linux/sysfs.h>
+#include <linux/string.h>
+#include <linux/timer.h>
+#include <linux/delay.h>
+#include <linux/errno.h>
+#include <linux/slab.h>
+#include <linux/poll.h>
+#include <linux/spi/spi.h>
+#include <linux/types.h>
+//#include "compat.h"
+#include <linux/videodev2.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-common.h>
+#include <media/v4l2-chip-ident.h>
+#include <media/upd61151.h>
+
+#include <linux/crc32.h>
+#include "saa7134.h"
+
+#define DRVNAME		"upd61151"
+
+static unsigned int spi_debug;
+module_param(spi_debug, int, 0644);
+MODULE_PARM_DESC(spi_debug,"enable debug messages [spi]");
+
+#define d1printk_spi if (1 <= spi_debug) printk
+#define d2printk_spi if (2 <= spi_debug) printk
+
+static unsigned int core_debug;
+module_param(core_debug, int, 0644);
+MODULE_PARM_DESC(core_debug,"enable debug messages [core]");
+
+#define d1printk_core if (1 <= core_debug) printk
+#define d2printk_core if (2 <= core_debug) printk
+
+MODULE_DESCRIPTION("device driver for uPD61151 MPEG2 encoder");
+MODULE_AUTHOR("Dmitry V Belimov");
+MODULE_LICENSE("GPL");
+
+/* Result codes */
+#define RESULT_SUCCESS              0
+#define RESULT_FAILURE              1
+#define STATUS_DEVICE_NOT_READY     2
+#define STATUS_DEVICE_DATA_ERROR    3
+#define STATUS_INVALID_PARAMETER    4
+
+enum upd61151_videoformat {
+	UPD61151_VF_D1 = 0,    /* 720x480/720x576 */
+	UPD61151_VF_D2 = 1,    /* 704x480/704x576 */
+	UPD61151_VF_D3 = 2,    /* 352x480/352x576 */
+	UPD61151_VF_D4 = 3,    /* 352x240/352x288 */
+	UPD61151_VF_D5 = 4,    /* 544x480/544x576 */
+	UPD61151_VF_D6 = 5,    /* 480x480/480x576 */
+	UPD61151_VF_D7 = 6,    /* 352x240/352x288 */
+	UPD61151_VF_D8 = 8,    /* 640x480/640x576 */
+	UPD61151_VF_D9 = 9,    /* 320x480/320x576 */
+	UPD61151_VF_D10 = 10,  /* 320x240/320x288 */
+	UPD61151_VF_UNKNOWN,
+};
+
+struct upd61151_mpeg_params {
+	/* audio */
+	enum v4l2_mpeg_audio_sampling_freq au_sampling;
+	enum v4l2_mpeg_audio_encoding    au_encoding;
+	enum v4l2_mpeg_audio_l2_bitrate  au_l2_bitrate;
+
+	/* video */
+	enum v4l2_mpeg_video_aspect	vi_aspect;
+	enum v4l2_mpeg_video_bitrate_mode vi_bitrate_mode;
+	__u32 				vi_bitrate;
+	__u32 				vi_bitrate_peak;
+
+	/* encoder */
+	u8				video_gop_size;
+	u8				video_gop_closure;
+};
+
+static const struct v4l2_format v4l2_format_table[] =
+{
+	[UPD61151_VF_D1] =
+		{ .fmt = { .pix = { .width = 720, .height = 576 }}},
+	[UPD61151_VF_D2] =
+		{ .fmt = { .pix = { .width = 704, .height = 576 }}},
+	[UPD61151_VF_D3] =
+		{ .fmt = { .pix = { .width = 352, .height = 576 }}},
+	[UPD61151_VF_D4] =
+		{ .fmt = { .pix = { .width = 352, .height = 288 }}},
+	[UPD61151_VF_D5] =
+		{ .fmt = { .pix = { .width = 544, .height = 576 }}},
+	[UPD61151_VF_D6] =
+		{ .fmt = { .pix = { .width = 480, .height = 576 }}},
+	[UPD61151_VF_D7] =
+		{ .fmt = { .pix = { .width = 352, .height = 288 }}},
+	[UPD61151_VF_D8] =
+		{ .fmt = { .pix = { .width = 640, .height = 576 }}},
+	[UPD61151_VF_D9] =
+		{ .fmt = { .pix = { .width = 320, .height = 576 }}},
+	[UPD61151_VF_D10] =
+		{ .fmt = { .pix = { .width = 320, .height = 288 }}},
+	[UPD61151_VF_UNKNOWN] =
+		{ .fmt = { .pix = { .width = 0, .height = 0}}},
+};
+
+struct upd61151_state {
+	struct v4l2_subdev            sd;
+	struct upd61151_mpeg_params   params;
+	enum upd61151_videoformat     video_format;
+	v4l2_std_id                   standard;
+	enum upd61151_encode_state    enstate;
+};
+
+static struct upd61151_mpeg_params param_defaults =
+{
+	.vi_aspect       = V4L2_MPEG_VIDEO_ASPECT_4x3,
+	.vi_bitrate      = 4000,
+	.vi_bitrate_peak = 6000,
+	.vi_bitrate_mode = V4L2_MPEG_VIDEO_BITRATE_MODE_VBR,
+
+	.au_sampling     = V4L2_MPEG_AUDIO_SAMPLING_FREQ_32000,
+	.au_encoding     = V4L2_MPEG_AUDIO_ENCODING_LAYER_2,
+	.au_l2_bitrate   = V4L2_MPEG_AUDIO_L2_BITRATE_256K,
+
+	.video_gop_size  = 1,
+	.video_gop_closure = 0,
+};
+
+static int write_reg(struct spi_device *spi, u8 address, u8 data)
+{
+	u8 buf[2];
+
+	buf[0] = ((address >> 2) << 2);
+	buf[1] = data;
+
+	d2printk_spi(KERN_DEBUG "%s: spi data 0x%x <= 0x%x\n",spi->modalias,address,data);
+
+	return spi_write(spi, buf, ARRAY_SIZE(buf));
+}
+
+static void write_fw(struct spi_device *spi, u8 address, const struct firmware *fw)
+{
+	u8 buf[2];
+	u32 i;
+
+	buf[0] = ((address >> 2) << 2);
+
+	for (i=0; i < fw->size; i++)
+	{
+		buf[1] = *(fw->data+i);
+		spi_write(spi, buf, 2);
+	}
+}
+
+static int read_reg(struct spi_device *spi, unsigned char address, unsigned char *data)
+{
+	u8 buf[1];
+	int ret;
+
+	ret = 0;
+	buf[0] = ((address >> 2) << 2) | 0x02;
+	ret = spi_write_then_read(spi, buf, 1, data, 1);
+
+	d2printk_spi(KERN_DEBUG "%s: spi data 0x%x => 0x%x, status %d\n",spi->modalias, address, *data, ret);
+
+	return ret;
+}
+
+static void upd61151_reset_core(struct v4l2_subdev *sd)
+{
+	struct spi_device *spi = v4l2_get_subdevdata(sd);
+
+	write_reg(spi, UPD61151_SOFTWARE_RST, 0x01);
+}
+
+static void upd61151_set_dest_addr(struct v4l2_subdev *sd, u32 addr)
+{
+	struct spi_device *spi = v4l2_get_subdevdata(sd);
+
+	write_reg(spi, UPD61151_TRANSFER_ADDR1, (u8)((addr >> 16) & 0xFF));
+	write_reg(spi, UPD61151_TRANSFER_ADDR2, (u8)((addr >> 8) & 0xFF));
+	write_reg(spi, UPD61151_TRANSFER_ADDR3, (u8)(addr & 0xFF));
+}
+
+static void upd61151_set_data_size(struct v4l2_subdev *sd, u32 dsize)
+{
+	struct spi_device *spi = v4l2_get_subdevdata(sd);
+
+	write_reg(spi, UPD61151_DATA_COUNTER1, (u8)((dsize >> 16) & 0xFF));
+	write_reg(spi, UPD61151_DATA_COUNTER2, (u8)((dsize >> 8) & 0xFF));
+	write_reg(spi, UPD61151_DATA_COUNTER3, (u8)(dsize & 0xFF));
+}
+
+static u8 upd61151_clear_transfer_irq(struct v4l2_subdev *sd)
+{
+	struct spi_device *spi = v4l2_get_subdevdata(sd);
+	u8 rbyte = 0x00;
+
+	read_reg(spi, UPD61151_TRANSFER_IRQ, &rbyte);
+
+	d2printk_core(KERN_DEBUG "%s: Transfer IRQ status 0x%x\n", spi->modalias, rbyte);
+
+	if (rbyte)
+		write_reg(spi, UPD61151_IRQ, rbyte);
+
+	return rbyte;
+}
+
+static void upd61151_handle_transfer_err(struct v4l2_subdev *sd)
+{
+	struct spi_device *spi = v4l2_get_subdevdata(sd);
+	u8 rbyte;
+printk("upd61151_handle_transfer_err\n");
+	/* Set data transfer count size = 1 */
+	upd61151_set_data_size(sd, 0x01);
+
+	/* Set transfer mode SDRAM -> Host */
+	write_reg(spi, UPD61151_TRANSFER_MODE, 0x01);
+
+	/* Read one byte from SDRAM */
+	read_reg(spi, UPD61151_TRANSFER_DATA, &rbyte);
+
+	/* Release transfer mode */
+	write_reg(spi, UPD61151_TRANSFER_MODE, 0x00);
+
+	/* Clear IRQ */
+	upd61151_clear_transfer_irq(sd);
+
+	/* Set destination address to 0x000000 */
+	upd61151_set_dest_addr(sd, 0x000000);
+
+	/* Set data transfer count size = 3 */
+	upd61151_set_data_size(sd, 0x03);
+
+	/* Set transfer mode SDRAM -> Host */
+	write_reg(spi, UPD61151_TRANSFER_MODE, 0x01);
+
+	/* Clear IRQ */
+	upd61151_clear_transfer_irq(sd);
+
+	/* Read 3 byte from SDRAM */
+	read_reg(spi, UPD61151_TRANSFER_DATA, &rbyte);
+	read_reg(spi, UPD61151_TRANSFER_DATA, &rbyte);
+	read_reg(spi, UPD61151_TRANSFER_DATA, &rbyte);
+
+	/* Clear IRQ */
+	upd61151_clear_transfer_irq(sd);
+
+	/* Set transfer mode SDRAM -> Host */
+	write_reg(spi, UPD61151_TRANSFER_MODE, 0x00);
+
+	/* Clear IRQ */
+	upd61151_clear_transfer_irq(sd);
+}
+
+static int upd61151_wait_transfer_irq(struct v4l2_subdev *sd)
+{
+	u8 i, rstatus;
+
+	rstatus = 0;
+	/* Wait transfer interrupt */
+	for (i=0; i<5; i++)
+	{
+		rstatus = upd61151_clear_transfer_irq(sd);
+		if (rstatus)
+			break;
+		msleep(1);
+	}
+
+	if (!rstatus)
+		return STATUS_DEVICE_NOT_READY;
+
+	if (rstatus & 0x04)
+	{
+		/* Data transfer error */
+		upd61151_handle_transfer_err(sd);
+		return STATUS_DEVICE_DATA_ERROR;
+	}
+
+	return RESULT_SUCCESS;
+}
+
+static u8 upd61151_clear_info_irq(struct v4l2_subdev *sd)
+{
+	struct spi_device *spi = v4l2_get_subdevdata(sd);
+	u8 rbyte = 0x00;
+
+	read_reg(spi, UPD61151_IRQ, &rbyte);
+
+	d2printk_core(KERN_DEBUG "%s: IRQ status 0x%x\n", spi->modalias, rbyte);
+
+	if (rbyte)
+		write_reg(spi, UPD61151_IRQ, rbyte);
+
+	return rbyte;
+}
+
+static u8 upd61151_clear_error_irq(struct v4l2_subdev *sd)
+{
+	struct spi_device *spi = v4l2_get_subdevdata(sd);
+	u8 rbyte = 0x00;
+
+	read_reg(spi, UPD61151_ERROR_IRQ, &rbyte);
+
+	d2printk_core(KERN_DEBUG "%s: IRQ error status 0x%x\n", spi->modalias, rbyte);
+
+	if (rbyte)
+		write_reg(spi, UPD61151_ERROR_IRQ, rbyte);
+
+	return rbyte;
+}
+
+static u8 upd61151_clear_except_irq(struct v4l2_subdev *sd)
+{
+	struct spi_device *spi = v4l2_get_subdevdata(sd);
+	u8 rbyte = 0x00;
+
+	read_reg(spi, UPD61151_EXCEPT_IRQ, &rbyte);
+
+	d2printk_core(KERN_DEBUG "%s: IRQ exception status 0x%x\n", spi->modalias, rbyte);
+
+	if (rbyte)
+		write_reg(spi, UPD61151_EXCEPT_IRQ, rbyte);
+
+	return rbyte;
+}
+
+static u8 upd61151_get_state(struct v4l2_subdev *sd)
+{
+	struct spi_device *spi = v4l2_get_subdevdata(sd);
+	u8 rbyte = 0x00;
+
+	read_reg(spi, UPD61151_STATUS, &rbyte);
+
+	d2printk_core(KERN_DEBUG "%s: MPEG2 core status %d\n", spi->modalias, rbyte & 0x07);
+
+	return rbyte & 0x07;
+}
+
+static int upd61151_set_state(struct v4l2_subdev *sd, enum upd61151_config nstate)
+{
+	struct spi_device *spi = v4l2_get_subdevdata(sd);
+	u8 enstate, k, get_error;
+	enum upd61151_config wait_state;
+printk("upd61151_set_state\n");
+
+	enstate = (u8)(nstate) | (u8)(UPD61151_COMMAND_CONFIG);
+
+	/* Clear IRQ */
+	upd61151_clear_error_irq(sd);
+
+	/* Set state */
+	write_reg(spi, UPD61151_COMMAND, enstate);
+
+	/* Wait max 100ms */
+	for (k = 0; k < 200; k++)
+	{
+		wait_state = upd61151_get_state(sd);
+		if (wait_state == UPD61151_COMMAND_CONFIG)
+		{
+			/* Clear IRQ flags */
+			upd61151_clear_info_irq(sd);
+
+			d2printk_core(KERN_DEBUG "%s: MPEG2 SetState(%d), SUCCESS! Delay(%d ms)\n", spi->modalias, nstate, k << 1);
+
+			return RESULT_SUCCESS;
+		}
+
+		/* Check error interrupt */
+		get_error = upd61151_clear_error_irq(sd);
+		if (get_error & 0x01)
+		{
+			/* Invalid command found */
+			d2printk_core(KERN_DEBUG "%s: MPEG2 SetState(%d), FAIL! Invalid Command (IC)!!!\n", spi->modalias, nstate);
+			break;
+		}
+
+		if (get_error & 0x02)
+		{
+			/* Invalid parameter found */
+			d2printk_core(KERN_DEBUG "%s: MPEG2 SetState(%d), FAIL! Invalid Parameter (IP)!!!\n", spi->modalias, nstate);
+			break;
+		}
+
+		if (get_error & 0x04)
+		{
+			/* Invalid audio firmware download IADL */
+			d2printk_core(KERN_DEBUG "%s: MPEG2 SetState(%d), FAIL! Invalid Audio Firmware Download (IADL)!!!\n", spi->modalias, nstate);
+			break;
+		}
+
+		if (get_error & 0x08)
+		{
+			/* Invalid system bitrate */
+			d2printk_core(KERN_DEBUG "%s: MPEG2 SetState(%d), FAIL! Invalid System Bit Rate (ISBR)!!!\n", spi->modalias, nstate);
+			break;
+		}
+
+		mdelay(2);
+	}
+
+	if (k >= 100)
+	{
+		d2printk_core(KERN_DEBUG "%s: MPEG2 SetState(%d), FAIL! TIMEOUT(%d ms)\n", spi->modalias, nstate, k << 1);
+	}
+
+	return STATUS_DEVICE_NOT_READY;
+}
+
+static int upd61151_load_base_firmware(struct v4l2_subdev *sd)
+{
+	struct spi_device *spi = v4l2_get_subdevdata(sd);
+	u32 size;
+	const struct firmware *fw;
+	int ret = RESULT_SUCCESS;
+
+printk("DEBUG: upd61151_load_base_firmware\n");
+
+	size = UPD61151_DEFAULT_PS_FIRMWARE_SIZE / 4;
+
+	/* request the firmware, this will block and timeout */
+	printk(KERN_INFO "%s: waiting for base firmware upload (%s)...\n",
+		spi->modalias, UPD61151_DEFAULT_PS_FIRMWARE);
+
+	ret = request_firmware(&fw, UPD61151_DEFAULT_PS_FIRMWARE,
+		spi->dev.parent);
+	if (ret)
+	{
+		printk(KERN_ERR "%s: Upload failed. (file not found?)\n",spi->modalias);
+		ret = STATUS_INVALID_PARAMETER;
+		goto out;
+	}
+	else
+		printk(KERN_DEBUG "%s: firmware read %Zu bytes.\n", spi->modalias,
+		       fw->size);
+
+	if (fw->size != UPD61151_DEFAULT_PS_FIRMWARE_SIZE)
+	{
+		printk(KERN_ERR "%s: firmware incorrect size\n", spi->modalias);
+		ret = STATUS_INVALID_PARAMETER;
+		goto out;
+	}
+	printk(KERN_INFO "%s: base firmware uploading...\n", spi->modalias);
+
+	upd61151_clear_transfer_irq(sd);
+
+	/* CPU reset ON */
+	write_reg(spi, UPD61151_SOFTWARE_RST, 0x02);
+
+	/* Set destination address to 0x000000 */
+	upd61151_set_dest_addr(sd, 0x000000);
+
+	/* Set transfer data count to firmware size / 4 */
+	upd61151_set_data_size(sd, size);
+
+	/* Set transfer mode to Host -> iRAM */
+	write_reg(spi, UPD61151_TRANSFER_MODE, 0x80);
+printk("fw upload start\n");
+	write_fw(spi, UPD61151_TRANSFER_DATA, fw);
+printk("fw upload stop\n");
+
+	ret = upd61151_wait_transfer_irq(sd);
+	if (ret == RESULT_SUCCESS)
+	{
+		/* Release transfer mode */
+		write_reg(spi, UPD61151_TRANSFER_MODE, 0x00);
+		printk(KERN_INFO "%s: base firmware upload complete...\n", spi->modalias);
+	}
+	else
+		printk(KERN_INFO "%s: base firmware upload FAIL...\n", spi->modalias);
+
+out:
+	/* CPU reset OFF */
+	write_reg(spi, UPD61151_SOFTWARE_RST, 0x00);
+	release_firmware(fw);
+	return ret;
+}
+
+static int upd61151_load_audio_firmware(struct v4l2_subdev *sd)
+{
+	struct spi_device *spi = v4l2_get_subdevdata(sd);
+	const struct firmware *fw;
+	u32 addr, i;
+	int ret = RESULT_SUCCESS;
+
+printk("DEBUG: upd61151_load_audio_firmware\n");
+
+	/* request the firmware, this will block and timeout */
+	printk(KERN_INFO "%s: waiting for audio firmware upload (%s)...\n",
+		spi->modalias, UPD61151_DEFAULT_AUDIO_FIRMWARE);
+
+	ret = request_firmware(&fw, UPD61151_DEFAULT_AUDIO_FIRMWARE,
+		spi->dev.parent);
+	if (ret)
+	{
+		printk(KERN_ERR "%s: Upload failed. (file not found?)\n",spi->modalias);
+		ret = STATUS_INVALID_PARAMETER;
+		goto out;
+	}
+	else
+		printk(KERN_DEBUG "%s: firmware read %Zu bytes.\n", spi->modalias,
+		       fw->size);
+
+	if (fw->size != UPD61151_DEFAULT_AUDIO_FIRMWARE_SIZE)
+	{
+		printk(KERN_ERR "%s: firmware incorrect size\n", spi->modalias);
+		ret = STATUS_INVALID_PARAMETER;
+		goto out;
+	}
+	printk(KERN_INFO "%s: audio firmware uploading...\n", spi->modalias);
+
+	addr = 0x308F00;
+	addr >>= 5;
+
+	upd61151_clear_transfer_irq(sd);
+
+	/* Set destination address */
+	upd61151_set_dest_addr(sd, addr);
+
+	/* Set transfer data count to firmware size */
+	upd61151_set_data_size(sd, UPD61151_DEFAULT_AUDIO_FIRMWARE_SIZE);
+
+	/* Set transfer mode to Host -> SDRAM */
+	write_reg(spi, UPD61151_TRANSFER_MODE, 0x02);
+
+printk("fw upload start\n");
+
+	for (i = 0; i < UPD61151_DEFAULT_AUDIO_FIRMWARE_SIZE; i++)
+	{
+		write_reg(spi, UPD61151_TRANSFER_DATA, *(fw->data+i));
+
+		/* Check Transfer interrupt each 128 bytes */
+		if ( ((i+1) % 128) ==0 )
+		{
+			ret = upd61151_wait_transfer_irq(sd);
+			if (ret != RESULT_SUCCESS)
+				break;
+		}
+	}
+
+printk("fw upload stop\n");
+
+	if (ret == RESULT_SUCCESS)
+	{
+		/* Release transfer mode */
+		write_reg(spi, UPD61151_TRANSFER_MODE, 0x00);
+		printk(KERN_INFO "%s: audio firmware upload complete...\n", spi->modalias);
+	}
+	else
+		printk(KERN_INFO "%s: audio firmware upload FAIL...\n", spi->modalias);
+
+out:
+	release_firmware(fw);
+	return ret;
+}
+
+static int upd61151_chip_command(struct v4l2_subdev *sd, enum upd61151_command command)
+{
+	struct spi_device *spi = v4l2_get_subdevdata(sd);
+	u8 cycles, wait, i, irqerr;
+	enum upd61151_command want_state;
+
+printk("DEBUG uPD61151: upd61151_chip_command\n");
+
+	/* calculate delay */
+	cycles = 100;
+	wait = 10;
+
+	switch (command)
+	{
+	case UPD61151_COMMAND_STANDBY_STOP:
+	case UPD61151_COMMAND_PAUSE:
+		break;
+
+	case UPD61151_COMMAND_START_RESTART:
+		cycles = 100;
+		wait = 2;
+		break;
+
+	default:
+		return STATUS_INVALID_PARAMETER;
+	}
+
+	/* Clear IRQ */
+	upd61151_clear_error_irq(sd);
+
+	write_reg(spi, UPD61151_COMMAND, command);
+
+	for (i=0; i < cycles; i++)
+	{
+		/* Check state */
+		want_state = upd61151_get_state(sd);
+		if (want_state == command)
+		{
+			upd61151_clear_info_irq(sd);
+			d2printk_core(KERN_DEBUG "%s: SetState(%d) SUCCESS!!! Delay [%d ms].\n", spi->modalias, want_state, i*wait);
+			return RESULT_SUCCESS;
+		}
+
+		/* Check error interrupt */
+		irqerr = upd61151_clear_error_irq(sd);
+
+		if (irqerr & 0x01)
+		{
+			d2printk_core(KERN_DEBUG "%s: SetState(%d) FAIL!!! Invalid Command (IC).\n", spi->modalias, command);
+			break;
+		}
+
+		if (irqerr & 0x02)
+		{
+			d2printk_core(KERN_DEBUG "%s: SetState(%d) FAIL!!! Invalid Parameter (IP).\n", spi->modalias, command);
+			break;
+		}
+
+		if (irqerr & 0x04)
+		{
+			d2printk_core(KERN_DEBUG "%s: SetState(%d) FAIL!!! Invalid Audio Firmware Download (IADL).\n", spi->modalias, command);
+			break;
+		}
+
+		if (irqerr & 0x08)
+		{
+			d2printk_core(KERN_DEBUG "%s: SetState(%d) FAIL!!! Invalid System Bit Rate (ISBR).\n", spi->modalias, command);
+			break;
+		}
+
+		msleep(wait);
+	}
+
+	if (i >= cycles)
+	{
+		d2printk_core(KERN_DEBUG "%s: SetState(%d) FAIL!!! TIMEOUT [%d ms].\n", spi->modalias, command, cycles*wait);
+	}
+
+	return STATUS_DEVICE_NOT_READY;
+}
+
+static int upd61151_setup_video_frontend(struct v4l2_subdev *sd)
+{
+	struct spi_device *spi = v4l2_get_subdevdata(sd);
+	struct upd61151_state *h = spi_get_drvdata(spi);
+	u8 dbyte;
+
+printk("upd61151_setup_video_frontend\n");
+
+	dbyte = 0x00;
+	/* Update FIDT */
+	if (h->standard & V4L2_STD_625_50)
+		dbyte |= 0x10;
+printk("   0x%x  ",dbyte);
+	dbyte |= h->video_format;
+printk("   0x%x  \n",dbyte);
+	write_reg(spi, UPD61151_VIDEO_ATTRIBUTE, dbyte);
+
+	/* SAV/EAV (ITU-656), FID not inverted */
+	write_reg(spi, UPD61151_VIDEO_SYNC, 0x80);
+
+	/* Set H offset */
+	write_reg(spi, UPD61151_VIDEO_HOFFSET, 0x00);
+
+	/* Set V offset */
+	if (h->standard & V4L2_STD_625_50)
+		dbyte = 0x01;
+	else
+		dbyte = 0x03;
+	write_reg(spi, UPD61151_VIDEO_VOFFSET, dbyte);
+
+	/* Setup VBI */
+	/* SLCEN = 0, VBIOFFV = 4, VBIOFFH = 8*/
+	write_reg(spi, UPD61151_VBI_ADJ1, 0x48);
+
+	return 0;
+}
+
+static int upd61151_setup_audio_frontend(struct v4l2_subdev *sd)
+{
+	struct spi_device *spi = v4l2_get_subdevdata(sd);
+	struct upd61151_state *h = spi_get_drvdata(spi);
+	struct upd61151_mpeg_params *params = &h->params;
+	u8 dbyte;
+
+printk("upd61151_setup_audio_frontend\n");
+	dbyte = 0x00;
+	/* Setup AUDIO attribute 1 */
+	switch (params->au_sampling)
+	{
+	case V4L2_MPEG_AUDIO_SAMPLING_FREQ_32000:
+		dbyte |= 0x20;
+		break;
+	case V4L2_MPEG_AUDIO_SAMPLING_FREQ_44100:
+		dbyte |= 0x10;
+		break;
+	default:
+		break;
+	}
+
+	switch (params->au_l2_bitrate)
+	{
+	case V4L2_MPEG_AUDIO_L2_BITRATE_128K :
+		dbyte |= 0x05;
+		break;
+	case V4L2_MPEG_AUDIO_L2_BITRATE_160K :
+		dbyte |= 0x06;
+		break;
+	case V4L2_MPEG_AUDIO_L2_BITRATE_192K :
+		dbyte |= 0x07;
+		break;
+	case V4L2_MPEG_AUDIO_L2_BITRATE_224K :
+		dbyte |= 0x08;
+		break;
+	case V4L2_MPEG_AUDIO_L2_BITRATE_320K :
+		dbyte |= 0x0A;
+		break;
+	case V4L2_MPEG_AUDIO_L2_BITRATE_384K :
+		dbyte |= 0x0B;
+		break;
+	default:
+		dbyte |= 0x09;
+		break;
+	}
+
+	write_reg(spi, UPD61151_AUDIO_ATTRIBUTE2, dbyte);
+
+	/* PLLs = internal, AMCLK = 384fs, AQ = 16bit & 64bck, APCMI = I2S, APCMO = OFF*/
+	write_reg(spi, UPD61151_AUDIO_INTERFACE, 0x5B);
+	return 0;
+}
+
+static void upd61151_prepare_bitrates(struct v4l2_subdev *sd)
+{
+	struct spi_device *spi = v4l2_get_subdevdata(sd);
+	struct upd61151_state *h = spi_get_drvdata(spi);
+	u32 mindelta, minvbr;
+printk("upd61151_prepare_bitrates\n");
+
+	if (h->params.vi_bitrate_peak > 15000)
+		h->params.vi_bitrate_peak = 15000;
+
+
+	if (h->params.vi_bitrate_mode)
+	{
+		if (h->params.vi_bitrate_peak < 1200)
+			h->params.vi_bitrate_peak = 1200;
+
+		h->params.vi_bitrate = 0;
+		minvbr = 1000;
+	}
+	else
+	{
+		if (h->params.vi_bitrate_peak < 1500)
+			h->params.vi_bitrate_peak = 1500;
+
+		if (h->params.vi_bitrate < 1200)
+			h->params.vi_bitrate = 1200;
+
+		if (h->params.vi_bitrate <= 3000)
+			/* Min = Average - 20% */
+			mindelta = (h->params.vi_bitrate * 2) / 100;
+		else
+			/* Min = Average - 30% */
+			mindelta = (h->params.vi_bitrate * 3) / 100;
+
+		minvbr = h->params.vi_bitrate - mindelta;
+
+		if (minvbr < 1000)
+			minvbr = 1000;
+	}
+
+	/* Set Video bitrates */
+	write_reg(spi, UPD61151_VMAXRATE, (u8)(h->params.vi_bitrate_peak / 100));
+	write_reg(spi, UPD61151_VAVRATE, (u8)(h->params.vi_bitrate / 100));
+	write_reg(spi, UPD61151_VMINRATE, (u8)(minvbr / 100));
+
+	/* Set VMAXDEBT - 252Mbps */
+	write_reg(spi, UPD61151_VMAXDEBT, 0xFC);
+
+}
+
+static int upd61151_config_encoder(struct v4l2_subdev *sd)
+{
+	struct spi_device *spi = v4l2_get_subdevdata(sd);
+	struct upd61151_state *h = spi_get_drvdata(spi);
+	u8 video_attrib1, video_attrib2;
+	u8 audio_attrib1, audio_attrib2;
+	u8 mux, mute, aspr;
+
+printk("upd61151_config_encoder\n");
+
+	video_attrib1 = 0x00;
+	/* Set Video resolution*/
+	video_attrib1 |= h->video_format;
+	/* Set GOP */
+	/* for gop_size = 0, GOP M=3, N=15 */
+	/* for gop_size = 1, GOP M=1, N=15 */
+	if (!h->params.video_gop_size)
+		video_attrib1 |= 0x80;
+	/* Set TV system */
+	if (h->standard & V4L2_STD_625_50)
+		video_attrib1 |= 0x10;
+printk("Video attrib1 = 0x%x\n",video_attrib1);
+
+	video_attrib2 = 0x00;
+	/* Set Rate control */
+	if (!h->params.vi_bitrate_mode)
+		video_attrib2 |= 0x04;
+	/* Set GOP, Open GOP = 0, Closed GOP = 1 */
+	if (h->params.video_gop_closure)
+		video_attrib2 |= 0x10;
+	/* Set adaptive M control */
+	/* FIXME: hardcoded adaptive M to enabled */
+	video_attrib2 |= 0x20;
+	/* Set DC precision control */
+	/* FIXME: hardcoded 9 bit */
+	video_attrib2 |= 0x01;
+
+	/* Set Audio mode */
+	/* FIXME: hardcoded audio to MPEG layer 2, 2ch stereo */
+	audio_attrib1 = 0x41;
+
+	audio_attrib2 = 0x00;
+	switch (h->params.au_sampling)
+	{
+	case V4L2_MPEG_AUDIO_SAMPLING_FREQ_32000:
+		audio_attrib2 |= 0x20;
+		break;
+	case V4L2_MPEG_AUDIO_SAMPLING_FREQ_44100:
+		audio_attrib2 |= 0x10;
+		break;
+	default:
+		break;
+	}
+
+	/* Set audio bitrate */
+	switch (h->params.au_l2_bitrate)
+	{
+	case V4L2_MPEG_AUDIO_L2_BITRATE_128K :
+		audio_attrib2 |= 0x05;
+		break;
+	case V4L2_MPEG_AUDIO_L2_BITRATE_160K :
+		audio_attrib2 |= 0x06;
+		break;
+	case V4L2_MPEG_AUDIO_L2_BITRATE_192K :
+		audio_attrib2 |= 0x07;
+		break;
+	case V4L2_MPEG_AUDIO_L2_BITRATE_224K :
+		audio_attrib2 |= 0x08;
+		break;
+	case V4L2_MPEG_AUDIO_L2_BITRATE_320K :
+		audio_attrib2 |= 0x0A;
+		break;
+	case V4L2_MPEG_AUDIO_L2_BITRATE_384K :
+		audio_attrib2 |= 0x0B;
+		break;
+	default:
+		audio_attrib2 |= 0x09;
+		break;
+	}
+
+	/* Set aspect */
+	aspr = 0x00;
+	if (h->params.vi_aspect == V4L2_MPEG_VIDEO_ASPECT_16x9)
+		aspr = 0x20;
+
+	/* Enable Audio */
+	/* FIXME: hardcoded enable Audio at all time */
+	mux = 0x03;
+	write_reg(spi, UPD61151_MUX_CTRL, mux);
+
+	/* Enable Video or blue screen */
+	mute = 0x00;
+	/* FIXME: hardcoded enable Video at all time */
+	write_reg(spi, UPD61151_ENCODING_TYPE, mute);
+
+	/* Prepare bitrates */
+	upd61151_prepare_bitrates(sd);
+
+	write_reg(spi, UPD61151_VIDEO_ATTRIBUTE, video_attrib1);
+	write_reg(spi, UPD61151_VIDEO_MODE, video_attrib2);
+	write_reg(spi, UPD61151_AUDIO_ATTRIBUTE1, audio_attrib1);
+	write_reg(spi, UPD61151_AUDIO_ATTRIBUTE2, audio_attrib2);
+
+	/* FIXME: hardcoded value */
+	/* Set brightness noise reducer to level 1 */
+	/* Set color noise reducer to level 1 */
+	write_reg(spi, UPD61151_VIDEO_NOISE, 0x05);
+
+	write_reg(spi, UPD61151_ASPR, aspr);
+	return 0;
+}
+
+static int upd61151_download_firmware(struct v4l2_subdev *sd)
+{
+	struct spi_device *spi = v4l2_get_subdevdata(sd);
+	struct upd61151_state *h = spi_get_drvdata(spi);
+	int res_cmd;
+
+printk("DEBUG: upd61151_download_firmware\n");
+	h->enstate = UPD61151_ENCODE_STATE_IDLE;
+
+	upd61151_reset_core(sd);
+
+	udelay(1);
+
+	/* Init SDRAM */
+	write_reg(spi, UPD61151_SDRAM_IF_DELAY_ADJ, 0x01);
+	write_reg(spi, UPD61151_SDRAM_FCLK_SEL, 0xA0);
+
+	udelay(200);
+
+	/* Set SDRAM to STANDBY */
+	write_reg(spi, UPD61151_SDRAM_STANDBY, 0x01);
+
+	udelay(10);
+
+	/* Release SDRAM from STANDBY */
+	write_reg(spi, UPD61151_SDRAM_STANDBY, 0x00);
+
+	res_cmd = upd61151_load_base_firmware(sd);
+	if (res_cmd != RESULT_SUCCESS)
+		return res_cmd;
+
+	res_cmd = upd61151_load_audio_firmware(sd);
+	if (res_cmd != RESULT_SUCCESS)
+		return res_cmd;
+
+	/* Clear IRQ flags */
+	if ( !(upd61151_clear_info_irq(sd) & 0x10) )
+	{
+		/* INICM not running */
+		d1printk_core(KERN_DEBUG "%s: download firmware FAILED. INICM is not run.\n", spi->modalias);
+		return STATUS_DEVICE_NOT_READY;
+	}
+
+	/* Set STANDBY state */
+	res_cmd = upd61151_chip_command(sd, UPD61151_COMMAND_STANDBY_STOP);
+	if (res_cmd != RESULT_SUCCESS)
+		return res_cmd;
+
+	/* Setup video input frontend */
+	upd61151_setup_video_frontend(sd);
+
+	/* Setup audio input frontend */
+	upd61151_setup_audio_frontend(sd);
+
+	/* Config encoder params */
+	upd61151_config_encoder(sd);
+
+	/* Set all config and upload audio firmware */
+	res_cmd = upd61151_set_state(sd, UPD61151_CONFIG_ALL);
+	if (res_cmd != RESULT_SUCCESS)
+		return res_cmd;
+
+	/* Return to STANDBY state */
+	res_cmd = upd61151_chip_command(sd, UPD61151_COMMAND_STANDBY_STOP);
+	if (res_cmd != RESULT_SUCCESS)
+		return res_cmd;
+
+	return RESULT_SUCCESS;
+}
+
+static int upd61151_is_need_reload_fw(struct v4l2_subdev *sd)
+{
+	struct spi_device *spi = v4l2_get_subdevdata(sd);
+
+	if (upd61151_get_state(sd) == UPD61151_COMMAND_INITIAL)
+	{
+		d1printk_core(KERN_DEBUG "%s: need reload firmware\n", spi->modalias);
+		return 1;
+	}
+
+	if (upd61151_clear_except_irq(sd) & 0x04)
+	{
+		d1printk_core(KERN_DEBUG "%s: mainly buffer of encoder is overflowed\n", spi->modalias);
+		return 1;
+	}
+
+	return 0;
+}
+
+/* Prepare audio PLLs */
+static void upd61151_prepare_i2s(struct v4l2_subdev *sd)
+{
+printk("DEBUG uPD61151: upd61151_prepare_i2s\n");
+printk("WARNING: The function upd61151_prepare_i2s is EMPTY\n");
+}
+
+static int upd61151_init(struct v4l2_subdev *sd, u32 leading_null_bytes)
+{
+	int res;
+
+printk("DEBUG uPD61151: upd61151_init\n");
+
+	if (upd61151_is_need_reload_fw(sd))
+	{
+		printk("Start load firmware...\n");
+		if (!upd61151_download_firmware(sd))
+			printk("Firmware downloaded SUCCESS!!!\n");
+		else
+			printk("Firmware downloaded FAIL!!!\n");
+	}
+	else
+		printk("Firmware is OK\n");
+
+	/* Prepare bitrates */
+	upd61151_prepare_bitrates(sd);
+
+	/* Prepare audio PLLs */
+	upd61151_prepare_i2s(sd);
+printk("switch ON TS MGEP2\n");
+	/* FIXME: Hardcoded for SAA7134_BOARD_BEHOLD_X7 */
+	/* enable TS out via manipulation with GPIO5    */
+//	write_reg(spi, UPD61151_GPIO_CTRLS, 0x10);
+
+	res = upd61151_chip_command(sd, UPD61151_COMMAND_START_RESTART);
+	if (res != RESULT_SUCCESS)
+		return res;
+
+	return 0;
+}
+
+
+static int get_ctrl(struct upd61151_mpeg_params *params, struct v4l2_ext_control *ctrl)
+{
+	switch (ctrl->id) {
+	case V4L2_CID_MPEG_STREAM_TYPE:
+		ctrl->value = V4L2_MPEG_STREAM_TYPE_MPEG2_PS;
+		break;
+	case V4L2_CID_MPEG_AUDIO_ENCODING:
+		ctrl->value = params->au_encoding;
+		break;
+	case V4L2_CID_MPEG_AUDIO_L2_BITRATE:
+		ctrl->value = params->au_l2_bitrate;
+		break;
+	case V4L2_CID_MPEG_AUDIO_SAMPLING_FREQ:
+		ctrl->value = params->au_sampling;
+		break;
+	case V4L2_CID_MPEG_VIDEO_ENCODING:
+		ctrl->value = V4L2_MPEG_VIDEO_ENCODING_MPEG_2;
+		break;
+	case V4L2_CID_MPEG_VIDEO_ASPECT:
+		ctrl->value = params->vi_aspect;
+		break;
+	case V4L2_CID_MPEG_VIDEO_BITRATE:
+		ctrl->value = params->vi_bitrate * 1000;
+		break;
+	case V4L2_CID_MPEG_VIDEO_BITRATE_PEAK:
+		ctrl->value = params->vi_bitrate_peak * 1000;
+		break;
+	case V4L2_CID_MPEG_VIDEO_BITRATE_MODE:
+		ctrl->value = params->vi_bitrate_mode;
+		break;
+	case V4L2_CID_MPEG_VIDEO_GOP_SIZE:
+		ctrl->value = params->video_gop_size;
+		break;
+	case V4L2_CID_MPEG_VIDEO_GOP_CLOSURE:
+		ctrl->value = params->video_gop_closure;
+		break;
+	default:
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static int handle_ctrl(struct upd61151_mpeg_params *params, struct v4l2_ext_control *ctrl, int set)
+{
+	int old = 0, new;
+
+	new = ctrl->value;
+	switch (ctrl->id) {
+	case V4L2_CID_MPEG_STREAM_TYPE:
+		old = V4L2_MPEG_STREAM_TYPE_MPEG2_PS;
+		if (set && new != old)
+			return -ERANGE;
+		new = old;
+		break;
+	case V4L2_CID_MPEG_AUDIO_ENCODING:
+		old = params->au_encoding;
+		if (set && new != V4L2_MPEG_AUDIO_ENCODING_LAYER_2)
+			return -ERANGE;
+		params->au_encoding = new;
+		break;
+	case V4L2_CID_MPEG_AUDIO_L2_BITRATE:
+		old = params->au_l2_bitrate;
+		if (set && new < V4L2_MPEG_AUDIO_L2_BITRATE_128K &&
+			   new > V4L2_MPEG_AUDIO_L2_BITRATE_384K)
+			return -ERANGE;
+		params->au_l2_bitrate = new;
+		break;
+	case V4L2_CID_MPEG_AUDIO_SAMPLING_FREQ:
+		old = params->au_sampling;
+		if (set && new > V4L2_MPEG_AUDIO_SAMPLING_FREQ_32000 &&
+			    new < V4L2_MPEG_AUDIO_SAMPLING_FREQ_44100)
+			return -ERANGE;
+		params->au_sampling = new;
+		break;
+	case V4L2_CID_MPEG_VIDEO_ENCODING:
+		old = V4L2_MPEG_VIDEO_ENCODING_MPEG_2;
+		if (set && new != old)
+			return -ERANGE;
+		new = old;
+		break;
+	case V4L2_CID_MPEG_VIDEO_ASPECT:
+		old = params->vi_aspect;
+		if (set && new != V4L2_MPEG_VIDEO_ASPECT_16x9 &&
+			   new != V4L2_MPEG_VIDEO_ASPECT_4x3)
+			return -ERANGE;
+		if (new != V4L2_MPEG_VIDEO_ASPECT_16x9)
+			new = V4L2_MPEG_VIDEO_ASPECT_4x3;
+		params->vi_aspect = new;
+		break;
+	case V4L2_CID_MPEG_VIDEO_BITRATE:
+		old = params->vi_bitrate * 1000;
+		new = 1000 * (new / 1000);
+		if (set && new > MPEG_VIDEO_TARGET_BITRATE_MAX * 1000)
+			return -ERANGE;
+		if (new > MPEG_VIDEO_TARGET_BITRATE_MAX * 1000)
+			new = MPEG_VIDEO_TARGET_BITRATE_MAX * 1000;
+		params->vi_bitrate = new / 1000;
+		break;
+	case V4L2_CID_MPEG_VIDEO_BITRATE_PEAK:
+		old = params->vi_bitrate_peak * 1000;
+		new = 1000 * (new / 1000);
+		if (set && new > MPEG_VIDEO_TARGET_BITRATE_MAX * 1000)
+			return -ERANGE;
+		if (new > MPEG_VIDEO_TARGET_BITRATE_MAX * 1000)
+			new = MPEG_VIDEO_TARGET_BITRATE_MAX * 1000;
+		params->vi_bitrate_peak = new / 1000;
+		break;
+	case V4L2_CID_MPEG_VIDEO_BITRATE_MODE:
+		old = params->vi_bitrate_mode;
+		params->vi_bitrate_mode = new;
+		break;
+	case V4L2_CID_MPEG_VIDEO_GOP_SIZE:
+		old = params->video_gop_size;
+		if (set && new != 0 && new != 1)
+			return -ERANGE;
+		params->video_gop_size = new;
+		break;
+	case V4L2_CID_MPEG_VIDEO_GOP_CLOSURE:
+		old = params->video_gop_closure;
+		if (set && new != 0 && new != 1)
+			return -ERANGE;
+		params->video_gop_closure = new;
+		break;
+	default:
+		return -EINVAL;
+	}
+	ctrl->value = new;
+	return 0;
+}
+
+static int upd61151_queryctrl(struct v4l2_subdev *sd, struct v4l2_queryctrl *qctrl)
+{
+	struct spi_device *spi = v4l2_get_subdevdata(sd);
+	struct upd61151_state *h = spi_get_drvdata(spi);
+	struct upd61151_mpeg_params *params = &h->params;
+	int err;
+
+printk("DEBUG uPD61151: upd61151_queryctrl\n");
+	switch (qctrl->id) {
+	case V4L2_CID_MPEG_AUDIO_ENCODING:
+		return v4l2_ctrl_query_fill(qctrl,
+				V4L2_MPEG_AUDIO_ENCODING_LAYER_2,
+				V4L2_MPEG_AUDIO_ENCODING_LAYER_2,
+				1, V4L2_MPEG_AUDIO_ENCODING_LAYER_2);
+
+	case V4L2_CID_MPEG_AUDIO_L2_BITRATE:
+		return v4l2_ctrl_query_fill(qctrl, V4L2_MPEG_AUDIO_L2_BITRATE_128K,
+				V4L2_MPEG_AUDIO_L2_BITRATE_384K, 1,
+				V4L2_MPEG_AUDIO_L2_BITRATE_256K);
+
+	case V4L2_CID_MPEG_AUDIO_SAMPLING_FREQ:
+		return v4l2_ctrl_query_fill(qctrl,
+				V4L2_MPEG_AUDIO_SAMPLING_FREQ_44100,
+				V4L2_MPEG_AUDIO_SAMPLING_FREQ_32000, 3,
+				V4L2_MPEG_AUDIO_SAMPLING_FREQ_32000);
+
+	case V4L2_CID_MPEG_VIDEO_ENCODING:
+		return v4l2_ctrl_query_fill(qctrl,
+				V4L2_MPEG_VIDEO_ENCODING_MPEG_2,
+				V4L2_MPEG_VIDEO_ENCODING_MPEG_2, 1,
+				V4L2_MPEG_VIDEO_ENCODING_MPEG_2);
+
+	case V4L2_CID_MPEG_VIDEO_ASPECT:
+		return v4l2_ctrl_query_fill(qctrl,
+				V4L2_MPEG_VIDEO_ASPECT_4x3,
+				V4L2_MPEG_VIDEO_ASPECT_16x9, 1,
+				V4L2_MPEG_VIDEO_ASPECT_4x3);
+
+	case V4L2_CID_MPEG_VIDEO_BITRATE_PEAK:
+		err = v4l2_ctrl_query_fill(qctrl, 0, 27000000, 1, 8000000);
+		if (err == 0 &&
+		    params->vi_bitrate_mode ==
+				V4L2_MPEG_VIDEO_BITRATE_MODE_CBR)
+			qctrl->flags |= V4L2_CTRL_FLAG_INACTIVE;
+		return err;
+
+	case V4L2_CID_MPEG_STREAM_TYPE:
+		return v4l2_ctrl_query_fill(qctrl,
+				V4L2_MPEG_STREAM_TYPE_MPEG2_PS,
+				V4L2_MPEG_STREAM_TYPE_MPEG2_PS, 1,
+				V4L2_MPEG_STREAM_TYPE_MPEG2_PS);
+
+	case V4L2_CID_MPEG_VIDEO_BITRATE_MODE:
+		return v4l2_ctrl_query_fill(qctrl,
+				V4L2_MPEG_VIDEO_BITRATE_MODE_VBR,
+				V4L2_MPEG_VIDEO_BITRATE_MODE_CBR, 1,
+				V4L2_MPEG_VIDEO_BITRATE_MODE_VBR);
+	case V4L2_CID_MPEG_VIDEO_BITRATE:
+		return v4l2_ctrl_query_fill(qctrl, 0, 15000000, 1, 6000000);
+	case V4L2_CID_MPEG_VIDEO_GOP_SIZE:
+		return v4l2_ctrl_query_fill(qctrl, 0, 1, 1, 1);
+	case V4L2_CID_MPEG_VIDEO_GOP_CLOSURE:
+		return v4l2_ctrl_query_fill(qctrl, 0, 1, 1, 0);
+
+	default:
+		break;
+	}
+	return -EINVAL;
+}
+
+static int upd61151_querymenu(struct v4l2_subdev *sd, struct v4l2_querymenu *qmenu)
+{
+	static const u32 mpeg_audio_sampling[] = {
+		V4L2_MPEG_AUDIO_SAMPLING_FREQ_44100,
+		V4L2_MPEG_AUDIO_SAMPLING_FREQ_48000,
+		V4L2_MPEG_AUDIO_SAMPLING_FREQ_32000,
+		V4L2_CTRL_MENU_IDS_END
+	};
+	static const u32 mpeg_audio_encoding[] = {
+		V4L2_MPEG_AUDIO_ENCODING_LAYER_2,
+		V4L2_CTRL_MENU_IDS_END
+	};
+	static u32 mpeg_audio_l2_bitrate[] = {
+		V4L2_MPEG_AUDIO_L2_BITRATE_128K,
+		V4L2_MPEG_AUDIO_L2_BITRATE_160K,
+		V4L2_MPEG_AUDIO_L2_BITRATE_192K,
+		V4L2_MPEG_AUDIO_L2_BITRATE_224K,
+		V4L2_MPEG_AUDIO_L2_BITRATE_256K,
+		V4L2_MPEG_AUDIO_L2_BITRATE_320K,
+		V4L2_MPEG_AUDIO_L2_BITRATE_384K,
+		V4L2_CTRL_MENU_IDS_END
+	};
+	struct v4l2_queryctrl qctrl;
+	int err;
+printk("DEBUG uPD61151: upd61151_querymenu\n");
+	qctrl.id = qmenu->id;
+	err = upd61151_queryctrl(sd, &qctrl);
+	if (err)
+		return err;
+	switch (qmenu->id) {
+	case V4L2_CID_MPEG_AUDIO_L2_BITRATE:
+		return v4l2_ctrl_query_menu_valid_items(qmenu, mpeg_audio_l2_bitrate);
+	case V4L2_CID_MPEG_AUDIO_ENCODING:
+		return v4l2_ctrl_query_menu_valid_items(qmenu, mpeg_audio_encoding);
+	case V4L2_CID_MPEG_AUDIO_SAMPLING_FREQ:
+		return v4l2_ctrl_query_menu_valid_items(qmenu, mpeg_audio_sampling);
+	}
+	return v4l2_ctrl_query_menu(qmenu, &qctrl, NULL);
+}
+
+static int upd61151_do_ext_ctrls(struct v4l2_subdev *sd, struct v4l2_ext_controls *ctrls, int set)
+{
+	struct spi_device *spi = v4l2_get_subdevdata(sd);
+	struct upd61151_state *h = spi_get_drvdata(spi);
+	struct upd61151_mpeg_params params;
+	int i;
+printk("DEBUG uPD61151: upd61151_do_ext_ctrls\n");
+
+	if (ctrls->ctrl_class != V4L2_CTRL_CLASS_MPEG)
+		return -EINVAL;
+
+	params = h->params;
+	for (i = 0; i < ctrls->count; i++) {
+		int err = handle_ctrl(&params, ctrls->controls + i, set);
+
+		if (err) {
+			ctrls->error_idx = i;
+			return err;
+		}
+	}
+	if (set)
+		h->params = params;
+
+	return 0;
+}
+
+static int upd61151_s_ext_ctrls(struct v4l2_subdev *sd, struct v4l2_ext_controls *ctrls)
+{
+printk("DEBUG uPD61151: upd61151_s_ext_ctrls\n");
+	return upd61151_do_ext_ctrls(sd, ctrls, 1);
+}
+
+static int upd61151_try_ext_ctrls(struct v4l2_subdev *sd, struct v4l2_ext_controls *ctrls)
+{
+printk("DEBUG uPD61151: upd61151_s_ext_ctrls\n");
+	return upd61151_do_ext_ctrls(sd, ctrls, 0);
+}
+
+static int upd61151_g_ext_ctrls(struct v4l2_subdev *sd, struct v4l2_ext_controls *ctrls)
+{
+	struct spi_device *spi = v4l2_get_subdevdata(sd);
+	struct upd61151_state *h = spi_get_drvdata(spi);
+	int i;
+printk("DEBUG uPD61151: upd61151_g_ext_ctrls\n");
+
+	if (ctrls->ctrl_class != V4L2_CTRL_CLASS_MPEG)
+		return -EINVAL;
+
+	for (i = 0; i < ctrls->count; i++) {
+		int err = get_ctrl(&h->params, ctrls->controls + i);
+
+		if (err) {
+			ctrls->error_idx = i;
+			return err;
+		}
+	}
+	return 0;
+}
+
+static int upd61151_g_fmt(struct v4l2_subdev *sd, struct v4l2_format *f)
+{
+	struct spi_device *spi = v4l2_get_subdevdata(sd);
+	struct upd61151_state *h = spi_get_drvdata(spi);
+
+	if (h->video_format == UPD61151_VF_UNKNOWN)
+		h->video_format = UPD61151_VF_D1;
+	f->fmt.pix.width =
+		v4l2_format_table[h->video_format].fmt.pix.width;
+	f->fmt.pix.height =
+		v4l2_format_table[h->video_format].fmt.pix.height;
+
+printk("DEBUG uPD61151: upd61151_g_fmt\n");
+	return 0;
+}
+
+static int upd61151_s_fmt(struct v4l2_subdev *sd, struct v4l2_format *f)
+{
+	struct spi_device *spi = v4l2_get_subdevdata(sd);
+	struct upd61151_state *h = spi_get_drvdata(spi);
+
+printk("DEBUG uPD61151: upd61151_s_fmt\n");
+
+	if (f->fmt.pix.width <= 320)
+	{
+		if (f->fmt.pix.height <= 288)
+		{
+			f->fmt.pix.width = 320;
+			f->fmt.pix.height = 288;
+			h->video_format = UPD61151_VF_D10;
+			return 0;
+		}
+		else
+		{
+			f->fmt.pix.width = 320;
+			f->fmt.pix.height = 576;
+			h->video_format = UPD61151_VF_D9;
+			return 0;
+		}
+	}
+
+	if (f->fmt.pix.width <= 352)
+	{
+		if (f->fmt.pix.height <= 288)
+		{
+			f->fmt.pix.width = 352;
+			f->fmt.pix.height = 288;
+			h->video_format = UPD61151_VF_D4;
+			return 0;
+		}
+		else
+		{
+			f->fmt.pix.width = 352;
+			f->fmt.pix.height = 576;
+			h->video_format = UPD61151_VF_D3;
+			return 0;
+		}
+	}
+
+	if (f->fmt.pix.width <= 480)
+	{
+		f->fmt.pix.width = 480;
+		f->fmt.pix.height = 576;
+		h->video_format = UPD61151_VF_D6;
+		return 0;
+	}
+
+	if (f->fmt.pix.width <= 544)
+	{
+		f->fmt.pix.width = 544;
+		f->fmt.pix.height = 576;
+		h->video_format = UPD61151_VF_D5;
+		return 0;
+	}
+
+	if (f->fmt.pix.width <= 640)
+	{
+		f->fmt.pix.width = 640;
+		f->fmt.pix.height = 576;
+		h->video_format = UPD61151_VF_D8;
+		return 0;
+	}
+
+	if (f->fmt.pix.width <= 704)
+	{
+		f->fmt.pix.width = 704;
+		f->fmt.pix.height = 576;
+		h->video_format = UPD61151_VF_D2;
+		return 0;
+	}
+
+	f->fmt.pix.width = 720;
+	f->fmt.pix.height = 576;
+	h->video_format = UPD61151_VF_D1;
+	return 0;
+}
+
+static int upd61151_s_std(struct v4l2_subdev *sd, v4l2_std_id std)
+{
+	struct spi_device *spi = v4l2_get_subdevdata(sd);
+	struct upd61151_state *h = spi_get_drvdata(spi);
+printk("DEBUG uPD61151: upd61151_s_std\n");
+	h->standard = std;
+	return 0;
+}
+
+static int upd61151_g_chip_ident(struct v4l2_subdev *sd, struct v4l2_dbg_chip_ident *chip)
+{
+printk("DEBUG uPD61151: upd61151_g_chip_ident\n");
+	chip->ident	= V4L2_IDENT_UPD61161;
+	chip->revision	= 0;
+
+	return 0;
+}
+
+/* ----------------------------------------------------------------------- */
+
+static const struct v4l2_subdev_core_ops upd61151_core_ops = {
+	.g_chip_ident = upd61151_g_chip_ident,    /* done */
+	.init = upd61151_init,
+	.queryctrl = upd61151_queryctrl,          /* done */
+	.querymenu = upd61151_querymenu,          /* done */
+	.g_ext_ctrls = upd61151_g_ext_ctrls,      /* done */
+	.s_ext_ctrls = upd61151_s_ext_ctrls,      /* done */
+	.try_ext_ctrls = upd61151_try_ext_ctrls,  /* done */
+	.s_std = upd61151_s_std,                  /* done */
+};
+
+static const struct v4l2_subdev_video_ops upd61151_video_ops = {
+//	.s_fmt = upd61151_s_fmt,                  /* done */
+//	.g_fmt = upd61151_g_fmt,                  /* done */
+};
+
+static const struct v4l2_subdev_ops upd61151_ops = {
+	.core = &upd61151_core_ops,               /* done */
+	.video = &upd61151_video_ops,             /* done */
+};
+
+static int __devinit upd61151_probe(struct spi_device *spi)
+{
+	struct upd61151_state *h = kzalloc(sizeof(*h), GFP_KERNEL);
+	struct v4l2_subdev *sd;
+
+printk("upd61151_probe function\n");
+
+	if (h == NULL)
+		return -ENOMEM;
+	sd = &h->sd;
+
+	v4l2_spi_subdev_init(sd, spi, &upd61151_ops);
+
+	spi_set_drvdata(spi, h);
+#if 0
+	if (upd61151_is_need_reload_fw(sd))
+	{
+		printk("Start load firmware...\n");
+		if (!upd61151_download_firmware(sd))
+			printk("Firmware downloaded SUCCESS!!!\n");
+		else
+			printk("Firmware downloaded FAIL!!!\n");
+	}
+	else
+		printk("Firmware is OK\n");
+#endif
+	h->params = param_defaults;
+	h->standard = 0; /* Assume 625 input lines */
+	return 0;
+}
+
+static int __devexit upd61151_remove(struct spi_device *spi)
+{
+	struct upd61151_state *h = spi_get_drvdata(spi);
+printk("upd61151_remove function\n");
+	v4l2_device_unregister_subdev(&h->sd);
+	kfree(h);
+	spi_unregister_device(spi);
+	return 0;
+}
+
+static struct spi_driver upd61151_driver = {
+	.driver = {
+		.name   = DRVNAME,
+		.bus    = &spi_bus_type,
+		.owner  = THIS_MODULE,
+	},
+	.probe = upd61151_probe,
+	.remove = __devexit_p(upd61151_remove),
+};
+
+
+static int __init init_upd61151(void)
+{
+	return spi_register_driver(&upd61151_driver);
+}
+module_init(init_upd61151);
+
+static void __exit exit_upd61151(void)
+{
+	spi_unregister_driver(&upd61151_driver);
+}
+module_exit(exit_upd61151);
diff --git a/include/media/upd61151.h b/include/media/upd61151.h
new file mode 100644
index 0000000..49d2a30
--- /dev/null
+++ b/include/media/upd61151.h
@@ -0,0 +1,125 @@
+/*
+    upd61151.h - definition for NEC uPD61151 MPEG encoder
+
+    Copyright (C) Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com>
+
+    This program is free software; you can redistribute it and/or modify
+    it under the terms of the GNU General Public License as published by
+    the Free Software Foundation; either version 2 of the License, or
+    (at your option) any later version.
+
+    This program is distributed in the hope that it will be useful,
+    but WITHOUT ANY WARRANTY; without even the implied warranty of
+    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+    GNU General Public License for more details.
+
+    You should have received a copy of the GNU General Public License
+    along with this program; if not, write to the Free Software
+    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+*/
+#include <linux/firmware.h>
+
+#define UPD61151_DEFAULT_PS_FIRMWARE "D61151_PS_7133_v22_031031.bin"
+#define UPD61151_DEFAULT_PS_FIRMWARE_SIZE 97002
+
+#define UPD61151_DEFAULT_AUDIO_FIRMWARE "audrey_MPE_V1r51.bin"
+#define UPD61151_DEFAULT_AUDIO_FIRMWARE_SIZE 40064
+
+enum mpeg_audio_bitrate {
+	MPEG_AUDIO_BITRATE_128 = 5,  /* 128 kBit/sec */
+	MPEG_AUDIO_BITRATE_160 = 6,  /* 160 kBit/sec */
+	MPEG_AUDIO_BITRATE_192 = 7,  /* 192 kBit/sec */
+	MPEG_AUDIO_BITRATE_224 = 8,  /* 224 kBit/sec */
+	MPEG_AUDIO_BITRATE_256 = 9,  /* 256 kBit/sec */
+	MPEG_AUDIO_BITRATE_320 = 10, /* 320 kBit/sec */
+	MPEG_AUDIO_BITRATE_384 = 11, /* 384 kBit/sec */
+
+	MPEG_AUDIO_BITRATE_MAX
+};
+
+enum mpeg_video_format {
+	MPEG_VIDEO_FORMAT_D1 = 0,    /* 720x480/720x576 */
+	MPEG_VIDEO_FORMAT_D2 = 1,    /* 704x480/704x576 */
+	MPEG_VIDEO_FORMAT_D3 = 2,    /* 352x480/352x576 */
+	MPEG_VIDEO_FORMAT_D4 = 3,    /* 352x240/352x288 */
+	MPEG_VIDEO_FORMAT_D5 = 4,    /* 544x480/544x576 */
+	MPEG_VIDEO_FORMAT_D6 = 5,    /* 480x480/480x576 */
+	MPEG_VIDEO_FORMAT_D7 = 6,    /* 352x240/352x288 */
+	MPEG_VIDEO_FORMAT_D8 = 8,    /* 640x480/640x576 */
+	MPEG_VIDEO_FORMAT_D9 = 9,    /* 320x480/320x576 */
+	MPEG_VIDEO_FORMAT_D10 = 10,  /* 320x240/320x288 */
+
+	MPEG_VIDEO_FORMAT_MAX
+};
+
+#define MPEG_VIDEO_TARGET_BITRATE_MAX 15000
+#define MPEG_VIDEO_MAX_BITRATE_MAX 15000
+#define MPEG_TOTAL_BITRATE_MAX 15000
+#define MPEG_PID_MAX ((1 << 14) - 1)
+
+enum upd61151_command {
+	UPD61151_COMMAND_INITIAL           = 0x00,
+	UPD61151_COMMAND_STANDBY_STOP      = 0x01,
+	UPD61151_COMMAND_CONFIG            = 0x02,
+	UPD61151_COMMAND_START_RESTART     = 0x03,
+	UPD61151_COMMAND_PAUSE             = 0x04,
+	UPD61151_COMMAND_CHANGE            = 0x05,
+};
+
+enum upd61151_encode_state {
+	UPD61151_ENCODE_STATE_IDLE         = 0,
+	UPD61151_ENCODE_STATE_ENCODE       = 1,
+	UPD61151_ENCODE_STATE_PAUSE        = 2,
+};
+
+enum upd61151_config {
+	UPD61151_CONFIG_ALL                = 0x00,
+	UPD61151_CONFIG_AUDIO_FW           = 0x10,
+	UPD61151_CONFIG_VIDEO_INPUT        = 0x20,
+	UPD61151_CONFIG_VBI_INPUT          = 0x30,
+	UPD61151_CONFIG_AUDIO_INPUT        = 0x40,
+};
+
+#define UPD61151_COMMAND             0x00
+#define UPD61151_STATUS              0x04
+#define UPD61151_ENCODING_TYPE       0x08
+#define UPD61151_MUX_CTRL            0x0C
+#define UPD61151_VMAXRATE            0x10
+#define UPD61151_VAVRATE             0x14
+#define UPD61151_VIDEO_ATTRIBUTE     0x1C
+#define UPD61151_VIDEO_MODE          0x20
+#define UPD61151_VIDEO_NOISE         0x24
+#define UPD61151_AUDIO_ATTRIBUTE1    0x28
+#define UPD61151_AUDIO_ATTRIBUTE2    0x2C
+#define UPD61151_VMINRATE            0x30
+#define UPD61151_VMAXDEBT            0x34
+#define UPD61151_ASPR                0x38
+#define UPD61151_VIDEO_SYNC          0x54
+#define UPD61151_VIDEO_HOFFSET       0x58
+#define UPD61151_VIDEO_VOFFSET       0x5C
+#define UPD61151_AUDIO_INTERFACE     0x60
+#define UPD61151_VBI_ADJ1            0x74
+#define UPD61151_VBI_ADJ2            0x78
+#define UPD61151_TRANSFER_MODE       0x80
+#define UPD61151_TRANSFER_ADDR1      0x90
+#define UPD61151_TRANSFER_ADDR2      0x94
+#define UPD61151_TRANSFER_ADDR3      0x98
+#define UPD61151_DATA_COUNTER1       0x9C
+#define UPD61151_DATA_COUNTER2       0xA0
+#define UPD61151_DATA_COUNTER3       0xA4
+#define UPD61151_TRANSFER_IRQ        0xC0
+#define UPD61151_IRQ                 0xC4
+#define UPD61151_ERROR_IRQ           0xCC
+#define UPD61151_EXCEPT_IRQ          0xD0
+#define UPD61151_SDRAM_IF_DELAY_ADJ  0xDC
+#define UPD61151_SDRAM_FCLK_SEL      0xE0
+#define UPD61151_SDRAM_STANDBY       0xE8
+#define UPD61151_GPIO_CTRLS          0xF0
+#define UPD61151_SOFTWARE_RST        0xF8
+#define UPD61151_TRANSFER_DATA       0xFC
+
+/*
+ * Local variables:
+ * c-basic-offset: 8
+ * End:
+ */

--MP_/ESviAueYelNPDQ+aBqIAFNE--
