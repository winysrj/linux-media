Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:62155 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753345Ab2BLNDQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Feb 2012 08:03:16 -0500
Received: by werb13 with SMTP id b13so2943200wer.19
        for <linux-media@vger.kernel.org>; Sun, 12 Feb 2012 05:03:15 -0800 (PST)
Message-ID: <1329051786.2778.3.camel@tvbox>
Subject: [PATCH] it913x-fe ver 1.15 read signal strenght using reg
 VAR_P_INBAND.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: linux-media@vger.kernel.org
Date: Sun, 12 Feb 2012 13:03:06 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Read signal strength using VAR_P_INBAND and apply FEC preferred values.

Note this does not work on IT9137 devices even with dvb-usb-it9135-01.fw
firmware.

Config read_sl allows switch between read signal strength and signal
level.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/media/dvb/dvb-usb/it913x.c           |    3 +
 drivers/media/dvb/frontends/it913x-fe-priv.h |    5 ++
 drivers/media/dvb/frontends/it913x-fe.c      |   91 +++++++++++++++++++++++---
 drivers/media/dvb/frontends/it913x-fe.h      |    4 +
 4 files changed, 93 insertions(+), 10 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/it913x.c b/drivers/media/dvb/dvb-usb/it913x.c
index cfa415b..3b7b102 100644
--- a/drivers/media/dvb/dvb-usb/it913x.c
+++ b/drivers/media/dvb/dvb-usb/it913x.c
@@ -412,11 +412,13 @@ static int ite_firmware_select(struct usb_device *udev,
 	case IT9135_V1_FW:
 		it913x_config.firmware_ver = 1;
 		it913x_config.adc_x2 = 1;
+		it913x_config.read_slevel = false;
 		props->firmware = fw_it9135_v1;
 		break;
 	case IT9135_V2_FW:
 		it913x_config.firmware_ver = 1;
 		it913x_config.adc_x2 = 1;
+		it913x_config.read_slevel = false;
 		props->firmware = fw_it9135_v2;
 		switch (it913x_config.tuner_id_0) {
 		case IT9135_61:
@@ -432,6 +434,7 @@ static int ite_firmware_select(struct usb_device *udev,
 	default:
 		it913x_config.firmware_ver = 0;
 		it913x_config.adc_x2 = 0;
+		it913x_config.read_slevel = true;
 		props->firmware = fw_it9137;
 	}
 
diff --git a/drivers/media/dvb/frontends/it913x-fe-priv.h b/drivers/media/dvb/frontends/it913x-fe-priv.h
index 93b086e..eb6fd8a 100644
--- a/drivers/media/dvb/frontends/it913x-fe-priv.h
+++ b/drivers/media/dvb/frontends/it913x-fe-priv.h
@@ -201,6 +201,11 @@ fe_modulation_t fe_con[] = {
 	QAM_64,
 };
 
+enum {
+	PRIORITY_HIGH = 0,	/* High-priority stream */
+	PRIORITY_LOW,	/* Low-priority stream */
+};
+
 /* Standard demodulator functions */
 static struct it913xset set_solo_fe[] = {
 	{PRO_LINK, GPIOH5_EN, {0x01}, 0x01},
diff --git a/drivers/media/dvb/frontends/it913x-fe.c b/drivers/media/dvb/frontends/it913x-fe.c
index ccc36bf..84df03c 100644
--- a/drivers/media/dvb/frontends/it913x-fe.c
+++ b/drivers/media/dvb/frontends/it913x-fe.c
@@ -57,6 +57,7 @@ struct it913x_fe_state {
 	u32 frequency;
 	fe_modulation_t constellation;
 	fe_transmit_mode_t transmission_mode;
+	u8 priority;
 	u32 crystalFrequency;
 	u32 adcFrequency;
 	u8 tuner_type;
@@ -500,19 +501,87 @@ static int it913x_fe_read_status(struct dvb_frontend *fe, fe_status_t *status)
 	return 0;
 }
 
+/* FEC values based on fe_code_rate_t non supported values 0*/
+int it913x_qpsk_pval[] = {0, -93, -91, -90, 0, -89, -88};
+int it913x_16qam_pval[] = {0, -87, -85, -84, 0, -83, -82};
+int it913x_64qam_pval[] = {0, -82, -80, -78, 0, -77, -76};
+
+static int it913x_get_signal_strength(struct dvb_frontend *fe)
+{
+	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
+	struct it913x_fe_state *state = fe->demodulator_priv;
+	u8 code_rate;
+	int ret, temp;
+	u8 lna_gain_os;
+
+	ret = it913x_read_reg_u8(state, VAR_P_INBAND);
+	if (ret < 0)
+		return ret;
+
+	/* VHF/UHF gain offset */
+	if (state->frequency < 300000000)
+		lna_gain_os = 7;
+	else
+		lna_gain_os = 14;
+
+	temp = (ret - 100) - lna_gain_os;
+
+	if (state->priority == PRIORITY_HIGH)
+		code_rate = p->code_rate_HP;
+	else
+		code_rate = p->code_rate_LP;
+
+	if (code_rate >= ARRAY_SIZE(it913x_qpsk_pval))
+		return -EINVAL;
+
+	deb_info("Reg VAR_P_INBAND:%d Calc Offset Value:%d", ret, temp);
+
+	/* Apply FEC offset values*/
+	switch (p->modulation) {
+	case QPSK:
+		temp -= it913x_qpsk_pval[code_rate];
+		break;
+	case QAM_16:
+		temp -= it913x_16qam_pval[code_rate];
+		break;
+	case QAM_64:
+		temp -= it913x_64qam_pval[code_rate];
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	if (temp < -15)
+		ret = 0;
+	else if ((-15 <= temp) && (temp < 0))
+		ret = (2 * (temp + 15)) / 3;
+	else if ((0 <= temp) && (temp < 20))
+		ret = 4 * temp + 10;
+	else if ((20 <= temp) && (temp < 35))
+		ret = (2 * (temp - 20)) / 3 + 90;
+	else if (temp >= 35)
+		ret = 100;
+
+	deb_info("Signal Strength :%d", ret);
+
+	return ret;
+}
+
 static int it913x_fe_read_signal_strength(struct dvb_frontend *fe,
 		u16 *strength)
 {
 	struct it913x_fe_state *state = fe->demodulator_priv;
-	int ret = it913x_read_reg_u8(state, SIGNAL_LEVEL);
-	/*SIGNAL_LEVEL always returns 100%! so using FE_HAS_SIGNAL as switch*/
-	if (state->it913x_status & FE_HAS_SIGNAL)
-		ret = (ret * 0xff) / 0x64;
-	else
-		ret = 0x0;
-	ret |= ret << 0x8;
-	*strength = ret;
-	return 0;
+	int ret = 0;
+	if (state->config->read_slevel) {
+		if (state->it913x_status & FE_HAS_SIGNAL)
+			ret = it913x_read_reg_u8(state, SIGNAL_LEVEL);
+	} else
+		ret = it913x_get_signal_strength(fe);
+
+	if (ret >= 0)
+		*strength = (u16)((u32)ret * 0xffff / 0x64);
+
+	return (ret < 0) ? -ENODEV : 0;
 }
 
 static int it913x_fe_read_snr(struct dvb_frontend *fe, u16 *snr)
@@ -606,6 +675,8 @@ static int it913x_fe_get_frontend(struct dvb_frontend *fe)
 	if (reg[2] < 4)
 		p->hierarchy = fe_hi[reg[2]];
 
+	state->priority = reg[5];
+
 	p->code_rate_HP = (reg[6] < 6) ? fe_code[reg[6]] : FEC_NONE;
 	p->code_rate_LP = (reg[7] < 6) ? fe_code[reg[7]] : FEC_NONE;
 
@@ -972,5 +1043,5 @@ static struct dvb_frontend_ops it913x_fe_ofdm_ops = {
 
 MODULE_DESCRIPTION("it913x Frontend and it9137 tuner");
 MODULE_AUTHOR("Malcolm Priestley tvboxspy@gmail.com");
-MODULE_VERSION("1.13");
+MODULE_VERSION("1.15");
 MODULE_LICENSE("GPL");
diff --git a/drivers/media/dvb/frontends/it913x-fe.h b/drivers/media/dvb/frontends/it913x-fe.h
index c4a908e..07fa459 100644
--- a/drivers/media/dvb/frontends/it913x-fe.h
+++ b/drivers/media/dvb/frontends/it913x-fe.h
@@ -34,6 +34,8 @@ struct ite_config {
 	u8 tuner_id_1;
 	u8 dual_mode;
 	u8 adf;
+	/* option to read SIGNAL_LEVEL */
+	u8 read_slevel;
 };
 
 #if defined(CONFIG_DVB_IT913X_FE) || (defined(CONFIG_DVB_IT913X_FE_MODULE) && \
@@ -168,6 +170,8 @@ static inline struct dvb_frontend *it913x_fe_attach(
 #define EST_SIGNAL_LEVEL	0x004a
 #define FREE_BAND		0x004b
 #define SUSPEND_FLAG		0x004c
+#define VAR_P_INBAND		0x00f7
+
 /* Build in tuner types */
 #define IT9137 0x38
 #define IT9135_38 0x38
-- 
1.7.9


