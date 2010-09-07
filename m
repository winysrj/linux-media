Return-path: <mchehab@pedra>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:41696 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757500Ab0IGPuv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Sep 2010 11:50:51 -0400
Received: by wwi17 with SMTP id 17so110200wwi.1
        for <linux-media@vger.kernel.org>; Tue, 07 Sep 2010 08:50:50 -0700 (PDT)
From: pboettcher@kernellabs.com
To: linux-media@vger.kernel.org
Cc: Olivier Grenie <olivier.grenie@dibcom.fr>, stable@kernel.org,
	Patrick Boettcher <patrick.boettcher@dibcom.fr>
Subject: [PATCH 1/2] V4L/DVB: dib7770: enable the current mirror
Date: Tue,  7 Sep 2010 17:50:45 +0200
Message-Id: <1283874646-20770-1-git-send-email-Patrick.Boettcher@dibcom.fr>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

From: Olivier Grenie <olivier.grenie@dibcom.fr>

To improve performance on DiB7770-devices enabling the current mirror
is needed.

This patch adds an option to the dib7000p-driver to do that and it
creates a separate device-entry in dib0700-device to use those changes
on hardware which is using the DiB7770.

Cc: stable@kernel.org

Signed-off-by: Olivier Grenie <olivier.grenie@dibcom.fr>
Signed-off-by: Patrick Boettcher <patrick.boettcher@dibcom.fr>
---
 drivers/media/dvb/dvb-usb/dib0700_devices.c |   53 ++++++++++++++++++++++++++-
 drivers/media/dvb/frontends/dib7000p.c      |    2 +
 drivers/media/dvb/frontends/dib7000p.h      |    3 ++
 3 files changed, 57 insertions(+), 1 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/dib0700_devices.c b/drivers/media/dvb/dvb-usb/dib0700_devices.c
index f634d2e..f9766c7 100644
--- a/drivers/media/dvb/dvb-usb/dib0700_devices.c
+++ b/drivers/media/dvb/dvb-usb/dib0700_devices.c
@@ -940,6 +940,57 @@ static int stk7070p_frontend_attach(struct dvb_usb_adapter *adap)
 	return adap->fe == NULL ? -ENODEV : 0;
 }
 
+/* STK7770P */
+static struct dib7000p_config dib7770p_dib7000p_config = {
+	.output_mpeg2_in_188_bytes = 1,
+
+	.agc_config_count = 1,
+	.agc = &dib7070_agc_config,
+	.bw  = &dib7070_bw_config_12_mhz,
+	.tuner_is_baseband = 1,
+	.spur_protect = 1,
+
+	.gpio_dir = DIB7000P_GPIO_DEFAULT_DIRECTIONS,
+	.gpio_val = DIB7000P_GPIO_DEFAULT_VALUES,
+	.gpio_pwm_pos = DIB7000P_GPIO_DEFAULT_PWM_POS,
+
+	.hostbus_diversity = 1,
+	.enable_current_mirror = 1,
+};
+
+static int stk7770p_frontend_attach(struct dvb_usb_adapter *adap)
+{
+	struct usb_device_descriptor *p = &adap->dev->udev->descriptor;
+	if (p->idVendor  == cpu_to_le16(USB_VID_PINNACLE) &&
+	    p->idProduct == cpu_to_le16(USB_PID_PINNACLE_PCTV72E))
+		dib0700_set_gpio(adap->dev, GPIO6, GPIO_OUT, 0);
+	else
+		dib0700_set_gpio(adap->dev, GPIO6, GPIO_OUT, 1);
+	msleep(10);
+	dib0700_set_gpio(adap->dev, GPIO9, GPIO_OUT, 1);
+	dib0700_set_gpio(adap->dev, GPIO4, GPIO_OUT, 1);
+	dib0700_set_gpio(adap->dev, GPIO7, GPIO_OUT, 1);
+	dib0700_set_gpio(adap->dev, GPIO10, GPIO_OUT, 0);
+
+	dib0700_ctrl_clock(adap->dev, 72, 1);
+
+	msleep(10);
+	dib0700_set_gpio(adap->dev, GPIO10, GPIO_OUT, 1);
+	msleep(10);
+	dib0700_set_gpio(adap->dev, GPIO0, GPIO_OUT, 1);
+
+	if (dib7000p_i2c_enumeration(&adap->dev->i2c_adap, 1, 18,
+				     &dib7770p_dib7000p_config) != 0) {
+		err("%s: dib7000p_i2c_enumeration failed.  Cannot continue\n",
+		    __func__);
+		return -ENODEV;
+	}
+
+	adap->fe = dvb_attach(dib7000p_attach, &adap->dev->i2c_adap, 0x80,
+		&dib7770p_dib7000p_config);
+	return adap->fe == NULL ? -ENODEV : 0;
+}
+
 /* DIB807x generic */
 static struct dibx000_agc_config dib807x_agc_config[2] = {
 	{
@@ -2406,7 +2457,7 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 				.pid_filter_count = 32,
 				.pid_filter       = stk70x0p_pid_filter,
 				.pid_filter_ctrl  = stk70x0p_pid_filter_ctrl,
-				.frontend_attach  = stk7070p_frontend_attach,
+				.frontend_attach  = stk7770p_frontend_attach,
 				.tuner_attach     = dib7770p_tuner_attach,
 
 				DIB0700_DEFAULT_STREAMING_CONFIG(0x02),
diff --git a/drivers/media/dvb/frontends/dib7000p.c b/drivers/media/dvb/frontends/dib7000p.c
index 2e28b97..73f59ab 100644
--- a/drivers/media/dvb/frontends/dib7000p.c
+++ b/drivers/media/dvb/frontends/dib7000p.c
@@ -260,6 +260,8 @@ static void dib7000p_set_adc_state(struct dib7000p_state *state, enum dibx000_ad
 
 //	dprintk( "908: %x, 909: %x\n", reg_908, reg_909);
 
+	reg_908 |= (state->cfg.enable_current_mirror & 1) << 7;
+
 	dib7000p_write_word(state, 908, reg_908);
 	dib7000p_write_word(state, 909, reg_909);
 }
diff --git a/drivers/media/dvb/frontends/dib7000p.h b/drivers/media/dvb/frontends/dib7000p.h
index 805dd13..04a7449 100644
--- a/drivers/media/dvb/frontends/dib7000p.h
+++ b/drivers/media/dvb/frontends/dib7000p.h
@@ -33,6 +33,9 @@ struct dib7000p_config {
 	int (*agc_control) (struct dvb_frontend *, u8 before);
 
 	u8 output_mode;
+
+	u8 enable_current_mirror : 1;
+
 };
 
 #define DEFAULT_DIB7000P_I2C_ADDRESS 18
-- 
1.7.0.4

