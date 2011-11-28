Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:56069 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753498Ab1K1WEa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Nov 2011 17:04:30 -0500
Received: by wwp14 with SMTP id 14so9830167wwp.1
        for <linux-media@vger.kernel.org>; Mon, 28 Nov 2011 14:04:29 -0800 (PST)
Message-ID: <1322517861.2121.23.camel@tvbox>
Subject: PATCH] for 3.3 it913x support for different tuner regs.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: linux-media@vger.kernel.org
Date: Mon, 28 Nov 2011 22:04:21 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There appears to be differences in the tuner registers
on earlier IT9135 devices.

Using the current IT9137 settings cause corruptions on
some channels

This patch is in preparation for multi firmware loading and
current unsupported types.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/media/dvb/dvb-usb/it913x.c           |   37 ++++++++++++++++++++++++-
 drivers/media/dvb/frontends/it913x-fe-priv.h |   20 ++++++++++++++
 drivers/media/dvb/frontends/it913x-fe.c      |   23 ++++++++++++---
 drivers/media/dvb/frontends/it913x-fe.h      |    9 ++++++
 4 files changed, 82 insertions(+), 7 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/it913x.c b/drivers/media/dvb/dvb-usb/it913x.c
index 24f04b4..d57e062 100644
--- a/drivers/media/dvb/dvb-usb/it913x.c
+++ b/drivers/media/dvb/dvb-usb/it913x.c
@@ -338,6 +338,31 @@ static int it913x_rc_query(struct dvb_usb_device *d)
 	return ret;
 }
 
+static int ite_firmware_select(struct usb_device *udev,
+	struct dvb_usb_device_properties *props)
+{
+	int sw;
+	/* auto switch */
+	if (le16_to_cpu(udev->descriptor.idProduct) ==
+			USB_PID_ITETECH_IT9135)
+		sw = IT9135_V1_FW;
+	else
+		sw = IT9137_FW;
+
+	switch (sw) {
+	case IT9135_V1_FW:
+		it913x_config.firmware_ver = 0;
+		it913x_config.adc_x2 = 1;
+		break;
+	case IT9137_FW:
+	default:
+		it913x_config.firmware_ver = 0;
+		it913x_config.adc_x2 = 0;
+	}
+
+	return 0;
+}
+
 #define TS_MPEG_PKT_SIZE	188
 #define EP_LOW			21
 #define TS_BUFFER_SIZE_PID	(EP_LOW*TS_MPEG_PKT_SIZE)
@@ -392,6 +417,8 @@ static int it913x_identify_state(struct usb_device *udev,
 		props->adapter[1].fe[0].stream.u.bulk.buffersize =
 			props->adapter[0].fe[0].stream.u.bulk.buffersize;
 
+	ret = ite_firmware_select(udev, props);
+
 	if (firm_no > 0) {
 		*cold = 0;
 		return 0;
@@ -421,10 +448,16 @@ static int it913x_identify_state(struct usb_device *udev,
 
 	if (it913x_config.dual_mode) {
 		ret |= it913x_wr_reg(udev, DEV_0, 0x4bfb, CHIP2_I2C_ADDR);
-		ret |= it913x_wr_reg(udev, DEV_0,  CLK_O_EN, 0x1);
+		if (it913x_config.firmware_ver == 1)
+			ret |= it913x_wr_reg(udev, DEV_0,  0xcfff, 0x1);
+		else
+			ret |= it913x_wr_reg(udev, DEV_0,  CLK_O_EN, 0x1);
 	} else {
 		ret |= it913x_wr_reg(udev, DEV_0, 0x4bfb, 0x0);
-		ret |= it913x_wr_reg(udev, DEV_0,  CLK_O_EN, 0x0);
+		if (it913x_config.firmware_ver == 1)
+			ret |= it913x_wr_reg(udev, DEV_0,  0xcfff, 0x0);
+		else
+			ret |= it913x_wr_reg(udev, DEV_0,  CLK_O_EN, 0x0);
 	}
 
 	*cold = 1;
diff --git a/drivers/media/dvb/frontends/it913x-fe-priv.h b/drivers/media/dvb/frontends/it913x-fe-priv.h
index 836a5b8..ad2b644 100644
--- a/drivers/media/dvb/frontends/it913x-fe-priv.h
+++ b/drivers/media/dvb/frontends/it913x-fe-priv.h
@@ -230,6 +230,7 @@ static struct it913xset init_1[] = {
 	{PRO_LINK, LOCK3_OUT, {0x01}, 0x01},
 	{PRO_LINK, PADMISCDRSR, {0x01}, 0x01},
 	{PRO_LINK, PADMISCDR2, {0x00}, 0x01},
+	{PRO_DMOD, 0xec57, {0x00, 0x00}, 0x02},
 	{PRO_LINK, PADMISCDR4, {0x00}, 0x01}, /* Power up */
 	{PRO_LINK, PADMISCDR8, {0x00}, 0x01},
 	{0xff, 0x0000, {0x00}, 0x00} /* Terminating Entry */
@@ -1010,10 +1011,29 @@ static struct it913xset it9137_tuner_off[] = {
 	{PRO_DMOD, 0xfba8, {0x01}, 0x01}, /* Tuner Clock Off  */
 	{PRO_DMOD, 0xec40, {0x00}, 0x01}, /* Power Down Tuner */
 	{PRO_DMOD, 0xec02, {0x3f, 0x1f, 0x3f, 0x3f}, 0x04},
+	{PRO_DMOD, 0xec06, {0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+				0x00, 0x00, 0x00, 0x00}, 0x0c},
+	{PRO_DMOD, 0xec12, {0x00, 0x00, 0x00, 0x00}, 0x04},
+	{PRO_DMOD, 0xec17, {0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+				0x00}, 0x09},
+	{PRO_DMOD, 0xec22, {0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+				0x00, 0x00}, 0x0a},
+	{PRO_DMOD, 0xec20, {0x00}, 0x01},
 	{PRO_DMOD, 0xec3f, {0x01}, 0x01},
 	{0xff, 0x0000, {0x00}, 0x00}, /* Terminating Entry */
 };
 
+static struct it913xset set_it9135_template[] = {
+	{PRO_DMOD, 0xee06, {0x00}, 0x01},
+	{PRO_DMOD, 0xec56, {0x00}, 0x01},
+	{PRO_DMOD, 0xec4c, {0x00}, 0x01},
+	{PRO_DMOD, 0xec4d, {0x00}, 0x01},
+	{PRO_DMOD, 0xec4e, {0x00}, 0x01},
+	{PRO_DMOD, 0x011e, {0x00}, 0x01}, /* Older Devices */
+	{PRO_DMOD, 0x011f, {0x00}, 0x01},
+	{0xff, 0x0000, {0x00}, 0x00}, /* Terminating Entry */
+};
+
 static struct it913xset set_it9137_template[] = {
 	{PRO_DMOD, 0xee06, {0x00}, 0x01},
 	{PRO_DMOD, 0xec56, {0x00}, 0x01},
diff --git a/drivers/media/dvb/frontends/it913x-fe.c b/drivers/media/dvb/frontends/it913x-fe.c
index e0cf881..8088e62 100644
--- a/drivers/media/dvb/frontends/it913x-fe.c
+++ b/drivers/media/dvb/frontends/it913x-fe.c
@@ -245,6 +245,11 @@ static int it9137_set_tuner(struct it913x_fe_state *state,
 	u8 lna_band;
 	u8 bw;
 
+	if (state->config->firmware_ver == 1)
+		set_tuner = set_it9135_template;
+	else
+		set_tuner = set_it9137_template;
+
 	deb_info("Tuner Frequency %d Bandwidth %d", frequency, bandwidth);
 
 	if (frequency >= 51000 && frequency <= 440000) {
@@ -774,8 +779,16 @@ static int it913x_fe_start(struct it913x_fe_state *state)
 	b[2] = (adc >> 16) & 0xff;
 	ret |= it913x_write(state, PRO_DMOD, ADC_FREQ, b, 3);
 
-	info("Crystal Frequency :%d Adc Frequency :%d",
-		state->crystalFrequency, state->adcFrequency);
+	if (state->config->adc_x2)
+		ret |= it913x_write_reg(state, PRO_DMOD, ADC_X_2, 0x01);
+	b[0] = 0;
+	b[1] = 0;
+	b[2] = 0;
+	ret |= it913x_write(state, PRO_DMOD, 0x0029, b, 3);
+
+	info("Crystal Frequency :%d Adc Frequency :%d ADC X2: %02x",
+		state->crystalFrequency, state->adcFrequency,
+			state->config->adc_x2);
 	deb_info("Xtal value :%04x Adc value :%04x", xtal, adc);
 
 	if (ret < 0)
@@ -840,10 +853,10 @@ static int it913x_fe_init(struct dvb_frontend *fe)
 	/* Power Up Tuner - common all versions */
 	ret = it913x_write_reg(state, PRO_DMOD, 0xec40, 0x1);
 
-	ret |= it913x_write_reg(state, PRO_DMOD, AFE_MEM0, 0x0);
-
 	ret |= it913x_fe_script_loader(state, init_1);
 
+	ret |= it913x_write_reg(state, PRO_DMOD, AFE_MEM0, 0x0);
+
 	ret |= it913x_write_reg(state, PRO_DMOD, 0xfba8, 0x0);
 
 	return (ret < 0) ? -ENODEV : 0;
@@ -938,5 +951,5 @@ static struct dvb_frontend_ops it913x_fe_ofdm_ops = {
 
 MODULE_DESCRIPTION("it913x Frontend and it9137 tuner");
 MODULE_AUTHOR("Malcolm Priestley tvboxspy@gmail.com");
-MODULE_VERSION("1.10");
+MODULE_VERSION("1.12");
 MODULE_LICENSE("GPL");
diff --git a/drivers/media/dvb/frontends/it913x-fe.h b/drivers/media/dvb/frontends/it913x-fe.h
index 43f879a..4143ef9 100644
--- a/drivers/media/dvb/frontends/it913x-fe.h
+++ b/drivers/media/dvb/frontends/it913x-fe.h
@@ -28,6 +28,8 @@ struct ite_config {
 	u8 chip_ver;
 	u16 chip_type;
 	u32 firmware;
+	u8 firmware_ver;
+	u8 adc_x2;
 	u8 tuner_id_0;
 	u8 tuner_id_1;
 	u8 dual_mode;
@@ -211,4 +213,11 @@ enum {
 	WRITE_CMD,
 };
 
+enum {
+	IT9135_AUTO = 0,
+	IT9137_FW,
+	IT9135_V1_FW,
+	IT9135_V2_FW,
+};
+
 #endif /* IT913X_FE_H */
-- 
1.7.7.1


