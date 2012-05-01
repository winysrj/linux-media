Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:49271 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751321Ab2EAEMv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 May 2012 00:12:51 -0400
Received: by mail-vb0-f46.google.com with SMTP id ff1so2558685vbb.19
        for <linux-media@vger.kernel.org>; Mon, 30 Apr 2012 21:12:51 -0700 (PDT)
From: Michael Krufky <mkrufky@kernellabs.com>
To: linux-media <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Michael Krufky <mkrufky@linuxtv.org>
Subject: [PATCH 10/10] mxl111sf: add ATSC-MH support
Date: Tue,  1 May 2012 00:12:25 -0400
Message-Id: <1335845545-20879-10-git-send-email-mkrufky@linuxtv.org>
In-Reply-To: <1335845545-20879-1-git-send-email-mkrufky@linuxtv.org>
References: <1335845545-20879-1-git-send-email-mkrufky@linuxtv.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
---
 drivers/media/dvb/dvb-usb/Kconfig    |    1 +
 drivers/media/dvb/dvb-usb/mxl111sf.c |  871 ++++++++++++++++++++++++++++++++--
 2 files changed, 825 insertions(+), 47 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/Kconfig b/drivers/media/dvb/dvb-usb/Kconfig
index 63bf456..3164273 100644
--- a/drivers/media/dvb/dvb-usb/Kconfig
+++ b/drivers/media/dvb/dvb-usb/Kconfig
@@ -409,6 +409,7 @@ config DVB_USB_MXL111SF
 	tristate "MxL111SF DTV USB2.0 support"
 	depends on DVB_USB
 	select DVB_LGDT3305 if !DVB_FE_CUSTOMISE
+	select DVB_LG2160 if !DVB_FE_CUSTOMISE
 	select VIDEO_TVEEPROM
 	help
 	  Say Y here to support the MxL111SF USB2.0 DTV receiver.
diff --git a/drivers/media/dvb/dvb-usb/mxl111sf.c b/drivers/media/dvb/dvb-usb/mxl111sf.c
index 81305de..c518e86 100644
--- a/drivers/media/dvb/dvb-usb/mxl111sf.c
+++ b/drivers/media/dvb/dvb-usb/mxl111sf.c
@@ -21,6 +21,7 @@
 #include "mxl111sf-tuner.h"
 
 #include "lgdt3305.h"
+#include "lg2160.h"
 
 int dvb_usb_mxl111sf_debug;
 module_param_named(debug, dvb_usb_mxl111sf_debug, int, 0644);
@@ -31,6 +32,10 @@ int dvb_usb_mxl111sf_isoc;
 module_param_named(isoc, dvb_usb_mxl111sf_isoc, int, 0644);
 MODULE_PARM_DESC(isoc, "enable usb isoc xfer (0=bulk, 1=isoc).");
 
+int dvb_usb_mxl111sf_spi;
+module_param_named(spi, dvb_usb_mxl111sf_spi, int, 0644);
+MODULE_PARM_DESC(spi, "use spi rather than tp for data xfer (0=tp, 1=spi).");
+
 #define ANT_PATH_AUTO 0
 #define ANT_PATH_EXTERNAL 1
 #define ANT_PATH_INTERNAL 2
@@ -361,6 +366,33 @@ static int mxl111sf_ep6_streaming_ctrl(struct dvb_usb_adapter *adap, int onoff)
 	return ret;
 }
 
+static int mxl111sf_ep5_streaming_ctrl(struct dvb_usb_adapter *adap, int onoff)
+{
+	struct dvb_usb_device *d = adap->dev;
+	struct mxl111sf_state *state = d->priv;
+	int ret = 0;
+
+	deb_info("%s(%d)\n", __func__, onoff);
+
+	if (onoff) {
+		ret = mxl111sf_enable_usb_output(state);
+		mxl_fail(ret);
+
+		ret = mxl111sf_init_i2s_port(state, 200);
+		mxl_fail(ret);
+		ret = mxl111sf_config_i2s(state, 0, 15);
+		mxl_fail(ret);
+	} else {
+		ret = mxl111sf_disable_i2s_port(state);
+		mxl_fail(ret);
+	}
+	if (state->chip_rev > MXL111SF_V6)
+		ret = mxl111sf_config_spi(state, onoff);
+	mxl_fail(ret);
+
+	return ret;
+}
+
 static int mxl111sf_ep4_streaming_ctrl(struct dvb_usb_adapter *adap, int onoff)
 {
 	struct dvb_usb_device *d = adap->dev;
@@ -453,6 +485,255 @@ fail:
 	return ret;
 }
 
+static struct lg2160_config hauppauge_lg2160_config = {
+	.lg_chip            = LG2160,
+	.i2c_addr           = 0x1c >> 1,
+	.deny_i2c_rptr      = 1,
+	.spectral_inversion = 0,
+	.if_khz             = 6000,
+};
+
+static int mxl111sf_lg2160_frontend_attach(struct dvb_usb_adapter *adap)
+{
+	struct dvb_usb_device *d = adap->dev;
+	struct mxl111sf_state *state = d->priv;
+	int fe_id = adap->num_frontends_initialized;
+	struct mxl111sf_adap_state *adap_state = adap->fe_adap[fe_id].priv;
+	int ret;
+
+	deb_adv("%s()\n", __func__);
+
+	/* save a pointer to the dvb_usb_device in device state */
+	state->d = d;
+	adap_state->alt_mode = (dvb_usb_mxl111sf_isoc) ? 2 : 1;
+	state->alt_mode = adap_state->alt_mode;
+
+	if (usb_set_interface(adap->dev->udev, 0, state->alt_mode) < 0)
+		err("set interface failed");
+
+	state->gpio_mode = MXL111SF_GPIO_MOD_MH;
+	adap_state->gpio_mode = state->gpio_mode;
+	adap_state->device_mode = MXL_TUNER_MODE;
+	adap_state->ep6_clockphase = 1;
+
+	ret = mxl1x1sf_soft_reset(state);
+	if (mxl_fail(ret))
+		goto fail;
+	ret = mxl111sf_init_tuner_demod(state);
+	if (mxl_fail(ret))
+		goto fail;
+
+	ret = mxl1x1sf_set_device_mode(state, adap_state->device_mode);
+	if (mxl_fail(ret))
+		goto fail;
+
+	ret = mxl111sf_enable_usb_output(state);
+	if (mxl_fail(ret))
+		goto fail;
+	ret = mxl1x1sf_top_master_ctrl(state, 1);
+	if (mxl_fail(ret))
+		goto fail;
+
+	ret = mxl111sf_init_port_expander(state);
+	if (mxl_fail(ret))
+		goto fail;
+	ret = mxl111sf_gpio_mode_switch(state, state->gpio_mode);
+	if (mxl_fail(ret))
+		goto fail;
+
+	ret = get_chip_info(state);
+	if (mxl_fail(ret))
+		goto fail;
+
+	adap->fe_adap[fe_id].fe = dvb_attach(lg2160_attach,
+			      &hauppauge_lg2160_config,
+			      &adap->dev->i2c_adap);
+	if (adap->fe_adap[fe_id].fe) {
+		adap_state->fe_init = adap->fe_adap[fe_id].fe->ops.init;
+		adap->fe_adap[fe_id].fe->ops.init = mxl111sf_adap_fe_init;
+		adap_state->fe_sleep = adap->fe_adap[fe_id].fe->ops.sleep;
+		adap->fe_adap[fe_id].fe->ops.sleep = mxl111sf_adap_fe_sleep;
+		return 0;
+	}
+	ret = -EIO;
+fail:
+	return ret;
+}
+
+static struct lg2160_config hauppauge_lg2161_1019_config = {
+	.lg_chip            = LG2161_1019,
+	.i2c_addr           = 0x1c >> 1,
+	.deny_i2c_rptr      = 1,
+	.spectral_inversion = 0,
+	.if_khz             = 6000,
+	.output_if          = 2, /* LG2161_OIF_SPI_MAS */
+};
+
+static struct lg2160_config hauppauge_lg2161_1040_config = {
+	.lg_chip            = LG2161_1040,
+	.i2c_addr           = 0x1c >> 1,
+	.deny_i2c_rptr      = 1,
+	.spectral_inversion = 0,
+	.if_khz             = 6000,
+	.output_if          = 4, /* LG2161_OIF_SPI_MAS */
+};
+
+static int mxl111sf_lg2161_frontend_attach(struct dvb_usb_adapter *adap)
+{
+	struct dvb_usb_device *d = adap->dev;
+	struct mxl111sf_state *state = d->priv;
+	int fe_id = adap->num_frontends_initialized;
+	struct mxl111sf_adap_state *adap_state = adap->fe_adap[fe_id].priv;
+	int ret;
+
+	deb_adv("%s()\n", __func__);
+
+	/* save a pointer to the dvb_usb_device in device state */
+	state->d = d;
+	adap_state->alt_mode = (dvb_usb_mxl111sf_isoc) ? 2 : 1;
+	state->alt_mode = adap_state->alt_mode;
+
+	if (usb_set_interface(adap->dev->udev, 0, state->alt_mode) < 0)
+		err("set interface failed");
+
+	state->gpio_mode = MXL111SF_GPIO_MOD_MH;
+	adap_state->gpio_mode = state->gpio_mode;
+	adap_state->device_mode = MXL_TUNER_MODE;
+	adap_state->ep6_clockphase = 1;
+
+	ret = mxl1x1sf_soft_reset(state);
+	if (mxl_fail(ret))
+		goto fail;
+	ret = mxl111sf_init_tuner_demod(state);
+	if (mxl_fail(ret))
+		goto fail;
+
+	ret = mxl1x1sf_set_device_mode(state, adap_state->device_mode);
+	if (mxl_fail(ret))
+		goto fail;
+
+	ret = mxl111sf_enable_usb_output(state);
+	if (mxl_fail(ret))
+		goto fail;
+	ret = mxl1x1sf_top_master_ctrl(state, 1);
+	if (mxl_fail(ret))
+		goto fail;
+
+	ret = mxl111sf_init_port_expander(state);
+	if (mxl_fail(ret))
+		goto fail;
+	ret = mxl111sf_gpio_mode_switch(state, state->gpio_mode);
+	if (mxl_fail(ret))
+		goto fail;
+
+	ret = get_chip_info(state);
+	if (mxl_fail(ret))
+		goto fail;
+
+	adap->fe_adap[fe_id].fe = dvb_attach(lg2160_attach,
+			      (MXL111SF_V8_200 == state->chip_rev) ?
+			      &hauppauge_lg2161_1040_config :
+			      &hauppauge_lg2161_1019_config,
+			      &adap->dev->i2c_adap);
+	if (adap->fe_adap[fe_id].fe) {
+		adap_state->fe_init = adap->fe_adap[fe_id].fe->ops.init;
+		adap->fe_adap[fe_id].fe->ops.init = mxl111sf_adap_fe_init;
+		adap_state->fe_sleep = adap->fe_adap[fe_id].fe->ops.sleep;
+		adap->fe_adap[fe_id].fe->ops.sleep = mxl111sf_adap_fe_sleep;
+		return 0;
+	}
+	ret = -EIO;
+fail:
+	return ret;
+}
+
+static struct lg2160_config hauppauge_lg2161_1019_ep6_config = {
+	.lg_chip            = LG2161_1019,
+	.i2c_addr           = 0x1c >> 1,
+	.deny_i2c_rptr      = 1,
+	.spectral_inversion = 0,
+	.if_khz             = 6000,
+	.output_if          = 1, /* LG2161_OIF_SERIAL_TS */
+};
+
+static struct lg2160_config hauppauge_lg2161_1040_ep6_config = {
+	.lg_chip            = LG2161_1040,
+	.i2c_addr           = 0x1c >> 1,
+	.deny_i2c_rptr      = 1,
+	.spectral_inversion = 0,
+	.if_khz             = 6000,
+	.output_if          = 7, /* LG2161_OIF_SERIAL_TS */
+};
+
+static int mxl111sf_lg2161_ep6_frontend_attach(struct dvb_usb_adapter *adap)
+{
+	struct dvb_usb_device *d = adap->dev;
+	struct mxl111sf_state *state = d->priv;
+	int fe_id = adap->num_frontends_initialized;
+	struct mxl111sf_adap_state *adap_state = adap->fe_adap[fe_id].priv;
+	int ret;
+
+	deb_adv("%s()\n", __func__);
+
+	/* save a pointer to the dvb_usb_device in device state */
+	state->d = d;
+	adap_state->alt_mode = (dvb_usb_mxl111sf_isoc) ? 2 : 1;
+	state->alt_mode = adap_state->alt_mode;
+
+	if (usb_set_interface(adap->dev->udev, 0, state->alt_mode) < 0)
+		err("set interface failed");
+
+	state->gpio_mode = MXL111SF_GPIO_MOD_MH;
+	adap_state->gpio_mode = state->gpio_mode;
+	adap_state->device_mode = MXL_TUNER_MODE;
+	adap_state->ep6_clockphase = 0;
+
+	ret = mxl1x1sf_soft_reset(state);
+	if (mxl_fail(ret))
+		goto fail;
+	ret = mxl111sf_init_tuner_demod(state);
+	if (mxl_fail(ret))
+		goto fail;
+
+	ret = mxl1x1sf_set_device_mode(state, adap_state->device_mode);
+	if (mxl_fail(ret))
+		goto fail;
+
+	ret = mxl111sf_enable_usb_output(state);
+	if (mxl_fail(ret))
+		goto fail;
+	ret = mxl1x1sf_top_master_ctrl(state, 1);
+	if (mxl_fail(ret))
+		goto fail;
+
+	ret = mxl111sf_init_port_expander(state);
+	if (mxl_fail(ret))
+		goto fail;
+	ret = mxl111sf_gpio_mode_switch(state, state->gpio_mode);
+	if (mxl_fail(ret))
+		goto fail;
+
+	ret = get_chip_info(state);
+	if (mxl_fail(ret))
+		goto fail;
+
+	adap->fe_adap[fe_id].fe = dvb_attach(lg2160_attach,
+			      (MXL111SF_V8_200 == state->chip_rev) ?
+			      &hauppauge_lg2161_1040_ep6_config :
+			      &hauppauge_lg2161_1019_ep6_config,
+			      &adap->dev->i2c_adap);
+	if (adap->fe_adap[fe_id].fe) {
+		adap_state->fe_init = adap->fe_adap[fe_id].fe->ops.init;
+		adap->fe_adap[fe_id].fe->ops.init = mxl111sf_adap_fe_init;
+		adap_state->fe_sleep = adap->fe_adap[fe_id].fe->ops.sleep;
+		adap->fe_adap[fe_id].fe->ops.sleep = mxl111sf_adap_fe_sleep;
+		return 0;
+	}
+	ret = -EIO;
+fail:
+	return ret;
+}
+
 static struct mxl111sf_demod_config mxl_demod_config = {
 	.read_reg        = mxl111sf_read_reg,
 	.write_reg       = mxl111sf_write_reg,
@@ -650,6 +931,18 @@ static struct dvb_usb_device_properties mxl111sf_dvbt_bulk_properties;
 static struct dvb_usb_device_properties mxl111sf_dvbt_isoc_properties;
 static struct dvb_usb_device_properties mxl111sf_atsc_bulk_properties;
 static struct dvb_usb_device_properties mxl111sf_atsc_isoc_properties;
+static struct dvb_usb_device_properties mxl111sf_atsc_mh_bulk_properties;
+static struct dvb_usb_device_properties mxl111sf_atsc_mh_isoc_properties;
+static struct dvb_usb_device_properties mxl111sf_mh_bulk_properties;
+static struct dvb_usb_device_properties mxl111sf_mh_isoc_properties;
+static struct dvb_usb_device_properties mxl111sf_mercury_spi_bulk_properties;
+static struct dvb_usb_device_properties mxl111sf_mercury_spi_isoc_properties;
+static struct dvb_usb_device_properties mxl111sf_mercury_tp_bulk_properties;
+static struct dvb_usb_device_properties mxl111sf_mercury_tp_isoc_properties;
+static struct dvb_usb_device_properties mxl111sf_mercury_mh_spi_bulk_properties;
+static struct dvb_usb_device_properties mxl111sf_mercury_mh_spi_isoc_properties;
+static struct dvb_usb_device_properties mxl111sf_mercury_mh_tp_bulk_properties;
+static struct dvb_usb_device_properties mxl111sf_mercury_mh_tp_isoc_properties;
 
 static int mxl111sf_probe(struct usb_interface *intf,
 			  const struct usb_device_id *id)
@@ -664,12 +957,50 @@ static int mxl111sf_probe(struct usb_interface *intf,
 				       THIS_MODULE, &d, adapter_nr) ||
 	      0 == dvb_usb_device_init(intf,
 				       &mxl111sf_atsc_isoc_properties,
+				       THIS_MODULE, &d, adapter_nr) ||
+	      0 == dvb_usb_device_init(intf,
+				       &mxl111sf_atsc_mh_isoc_properties,
+				       THIS_MODULE, &d, adapter_nr) ||
+	      0 == dvb_usb_device_init(intf,
+				       &mxl111sf_mh_isoc_properties,
+				       THIS_MODULE, &d, adapter_nr) ||
+	      ((dvb_usb_mxl111sf_spi) &&
+	       (0 == dvb_usb_device_init(intf,
+					 &mxl111sf_mercury_spi_isoc_properties,
+					 THIS_MODULE, &d, adapter_nr) ||
+		0 == dvb_usb_device_init(intf,
+					 &mxl111sf_mercury_mh_spi_isoc_properties,
+					 THIS_MODULE, &d, adapter_nr))) ||
+	      0 == dvb_usb_device_init(intf,
+				       &mxl111sf_mercury_tp_isoc_properties,
+				       THIS_MODULE, &d, adapter_nr) ||
+	      0 == dvb_usb_device_init(intf,
+				       &mxl111sf_mercury_mh_tp_isoc_properties,
 				       THIS_MODULE, &d, adapter_nr))) ||
 	    0 == dvb_usb_device_init(intf,
 				     &mxl111sf_dvbt_bulk_properties,
 				     THIS_MODULE, &d, adapter_nr) ||
 	    0 == dvb_usb_device_init(intf,
 				     &mxl111sf_atsc_bulk_properties,
+				     THIS_MODULE, &d, adapter_nr) ||
+	    0 == dvb_usb_device_init(intf,
+				     &mxl111sf_atsc_mh_bulk_properties,
+				     THIS_MODULE, &d, adapter_nr) ||
+	    0 == dvb_usb_device_init(intf,
+				     &mxl111sf_mh_bulk_properties,
+				     THIS_MODULE, &d, adapter_nr) ||
+	    ((dvb_usb_mxl111sf_spi) &&
+	     (0 == dvb_usb_device_init(intf,
+				       &mxl111sf_mercury_spi_bulk_properties,
+				       THIS_MODULE, &d, adapter_nr) ||
+	      0 == dvb_usb_device_init(intf,
+				       &mxl111sf_mercury_mh_spi_bulk_properties,
+				       THIS_MODULE, &d, adapter_nr))) ||
+	    0 == dvb_usb_device_init(intf,
+				     &mxl111sf_mercury_tp_bulk_properties,
+				     THIS_MODULE, &d, adapter_nr) ||
+	    0 == dvb_usb_device_init(intf,
+				     &mxl111sf_mercury_mh_tp_bulk_properties,
 				     THIS_MODULE, &d, adapter_nr) || 0) {
 
 		struct mxl111sf_state *state = d->priv;
@@ -787,13 +1118,13 @@ MODULE_DEVICE_TABLE(usb, mxl111sf_table);
 		}					\
 	}
 
-#define MXL111SF_EP6_BULK_STREAMING_CONFIG		\
+#define MXL111SF_EP5_BULK_STREAMING_CONFIG		\
 	.size_of_priv = sizeof(struct mxl111sf_adap_state), \
-	.streaming_ctrl = mxl111sf_ep6_streaming_ctrl,	\
+	.streaming_ctrl = mxl111sf_ep5_streaming_ctrl,	\
 	.stream = {					\
 		.type = USB_BULK,			\
 		.count = 5,				\
-		.endpoint = 0x06,			\
+		.endpoint = 0x05,			\
 		.u = {					\
 			.bulk = {			\
 				.buffersize = 8192,	\
@@ -801,25 +1132,55 @@ MODULE_DEVICE_TABLE(usb, mxl111sf_table);
 		}					\
 	}
 
-/* FIXME */
-#define MXL111SF_EP6_ISOC_STREAMING_CONFIG		\
+#define MXL111SF_EP5_ISOC_STREAMING_CONFIG		\
 	.size_of_priv = sizeof(struct mxl111sf_adap_state), \
-	.streaming_ctrl = mxl111sf_ep6_streaming_ctrl,	\
+	.streaming_ctrl = mxl111sf_ep5_streaming_ctrl,	\
 	.stream = {					\
 		.type = USB_ISOC,			\
 		.count = 5,				\
-		.endpoint = 0x06,			\
+		.endpoint = 0x05,			\
 		.u = {					\
 			.isoc = {			\
-				.framesperurb = 24,	\
-				.framesize = 3072,	\
+				.framesperurb = 96,	\
+				.framesize = 200,	\
 				.interval = 1,		\
 			}				\
 		}					\
 	}
 
-#define MXL111SF_DEFAULT_DEVICE_PROPERTIES			\
-	.caps = DVB_USB_IS_AN_I2C_ADAPTER,			\
+#define MXL111SF_EP6_BULK_STREAMING_CONFIG		\
+	.size_of_priv = sizeof(struct mxl111sf_adap_state), \
+	.streaming_ctrl = mxl111sf_ep6_streaming_ctrl,	\
+	.stream = {					\
+		.type = USB_BULK,			\
+		.count = 5,				\
+		.endpoint = 0x06,			\
+		.u = {					\
+			.bulk = {			\
+				.buffersize = 8192,	\
+			}				\
+		}					\
+	}
+
+/* FIXME */
+#define MXL111SF_EP6_ISOC_STREAMING_CONFIG		\
+	.size_of_priv = sizeof(struct mxl111sf_adap_state), \
+	.streaming_ctrl = mxl111sf_ep6_streaming_ctrl,	\
+	.stream = {					\
+		.type = USB_ISOC,			\
+		.count = 5,				\
+		.endpoint = 0x06,			\
+		.u = {					\
+			.isoc = {			\
+				.framesperurb = 24,	\
+				.framesize = 3072,	\
+				.interval = 1,		\
+			}				\
+		}					\
+	}
+
+#define MXL111SF_DEFAULT_DEVICE_PROPERTIES			\
+	.caps = DVB_USB_IS_AN_I2C_ADAPTER,			\
 	.usb_ctrl = DEVICE_SPECIFIC,				\
 	/* use usb alt setting 1 for EP4 ISOC transfer (dvb-t),	\
 				     EP6 BULK transfer (atsc/qam), \
@@ -848,7 +1209,7 @@ static struct dvb_usb_device_properties mxl111sf_dvbt_bulk_properties = {
 		} },
 		},
 	},
-	.num_device_descs = 4,
+	.num_device_descs = 3,
 	.devices = {
 		{   "Hauppauge 126xxx DVBT (bulk)",
 			{ NULL },
@@ -866,11 +1227,6 @@ static struct dvb_usb_device_properties mxl111sf_dvbt_bulk_properties = {
 			  &mxl111sf_table[24], &mxl111sf_table[26],
 			  NULL },
 		},
-		{   "Hauppauge 126xxx (tp-bulk)",
-			{ NULL },
-			{ &mxl111sf_table[28], &mxl111sf_table[30],
-			  NULL },
-		},
 	}
 };
 
@@ -890,7 +1246,7 @@ static struct dvb_usb_device_properties mxl111sf_dvbt_isoc_properties = {
 		} },
 		},
 	},
-	.num_device_descs = 4,
+	.num_device_descs = 3,
 	.devices = {
 		{   "Hauppauge 126xxx DVBT (isoc)",
 			{ NULL },
@@ -908,11 +1264,6 @@ static struct dvb_usb_device_properties mxl111sf_dvbt_isoc_properties = {
 			  &mxl111sf_table[24], &mxl111sf_table[26],
 			  NULL },
 		},
-		{   "Hauppauge 126xxx (tp-isoc)",
-			{ NULL },
-			{ &mxl111sf_table[28], &mxl111sf_table[30],
-			  NULL },
-		},
 	}
 };
 
@@ -923,33 +1274,159 @@ static struct dvb_usb_device_properties mxl111sf_atsc_bulk_properties = {
 	.adapter = {
 		{
 		.fe_ioctl_override = mxl111sf_fe_ioctl_override,
-		.num_frontends = 2,
+		.num_frontends = 1,
 		.fe = {{
 			.frontend_attach  = mxl111sf_lgdt3305_frontend_attach,
 			.tuner_attach     = mxl111sf_attach_tuner,
 
 			MXL111SF_EP6_BULK_STREAMING_CONFIG,
+		}},
 		},
+	},
+	.num_device_descs = 2,
+	.devices = {
+		{   "Hauppauge 126xxx ATSC (bulk)",
+			{ NULL },
+			{ &mxl111sf_table[1], &mxl111sf_table[5],
+			  NULL },
+		},
+		{   "Hauppauge 117xxx ATSC (bulk)",
+			{ NULL },
+			{ &mxl111sf_table[12],
+			  NULL },
+		},
+	}
+};
+
+static struct dvb_usb_device_properties mxl111sf_atsc_isoc_properties = {
+	MXL111SF_DEFAULT_DEVICE_PROPERTIES,
+
+	.num_adapters = 1,
+	.adapter = {
 		{
-			.frontend_attach  = mxl111sf_attach_demod,
+		.fe_ioctl_override = mxl111sf_fe_ioctl_override,
+		.num_frontends = 1,
+		.fe = {{
+			.frontend_attach  = mxl111sf_lgdt3305_frontend_attach,
 			.tuner_attach     = mxl111sf_attach_tuner,
 
-			MXL111SF_EP4_BULK_STREAMING_CONFIG,
+			MXL111SF_EP6_ISOC_STREAMING_CONFIG,
 		}},
 		},
 	},
-	.num_device_descs = 6,
+	.num_device_descs = 2,
 	.devices = {
-		{   "Hauppauge 126xxx ATSC (bulk)",
+		{   "Hauppauge 126xxx ATSC (isoc)",
 			{ NULL },
 			{ &mxl111sf_table[1], &mxl111sf_table[5],
 			  NULL },
 		},
-		{   "Hauppauge 117xxx ATSC (bulk)",
+		{   "Hauppauge 117xxx ATSC (isoc)",
 			{ NULL },
 			{ &mxl111sf_table[12],
 			  NULL },
 		},
+	}
+};
+
+static struct dvb_usb_device_properties mxl111sf_mh_bulk_properties = {
+	MXL111SF_DEFAULT_DEVICE_PROPERTIES,
+
+	.num_adapters = 1,
+	.adapter = {
+		{
+		.fe_ioctl_override = mxl111sf_fe_ioctl_override,
+		.num_frontends = 1,
+		.fe = {{
+			.caps = DVB_USB_ADAP_RECEIVES_RAW_PAYLOAD,
+
+			.frontend_attach  = mxl111sf_lg2160_frontend_attach,
+			.tuner_attach     = mxl111sf_attach_tuner,
+
+			MXL111SF_EP5_BULK_STREAMING_CONFIG,
+		}},
+		},
+	},
+	.num_device_descs = 2,
+	.devices = {
+		{   "HCW 126xxx (bulk)",
+			{ NULL },
+			{ &mxl111sf_table[2], &mxl111sf_table[6],
+			  NULL },
+		},
+		{   "HCW 117xxx (bulk)",
+			{ NULL },
+			{ &mxl111sf_table[13],
+			  NULL },
+		},
+	}
+};
+
+static struct dvb_usb_device_properties mxl111sf_mh_isoc_properties = {
+	MXL111SF_DEFAULT_DEVICE_PROPERTIES,
+
+	.num_adapters = 1,
+	.adapter = {
+		{
+		.fe_ioctl_override = mxl111sf_fe_ioctl_override,
+		.num_frontends = 1,
+		.fe = {{
+			.caps = DVB_USB_ADAP_RECEIVES_RAW_PAYLOAD,
+
+			.frontend_attach  = mxl111sf_lg2160_frontend_attach,
+			.tuner_attach     = mxl111sf_attach_tuner,
+
+			MXL111SF_EP5_ISOC_STREAMING_CONFIG,
+		}},
+		},
+	},
+	.num_device_descs = 2,
+	.devices = {
+		{   "HCW 126xxx (isoc)",
+			{ NULL },
+			{ &mxl111sf_table[2], &mxl111sf_table[6],
+			  NULL },
+		},
+		{   "HCW 117xxx (isoc)",
+			{ NULL },
+			{ &mxl111sf_table[13],
+			  NULL },
+		},
+	}
+};
+
+static struct dvb_usb_device_properties mxl111sf_atsc_mh_bulk_properties = {
+	MXL111SF_DEFAULT_DEVICE_PROPERTIES,
+
+	.num_adapters = 1,
+	.adapter = {
+		{
+		.fe_ioctl_override = mxl111sf_fe_ioctl_override,
+		.num_frontends = 3,
+		.fe = {{
+			.frontend_attach  = mxl111sf_lgdt3305_frontend_attach,
+			.tuner_attach     = mxl111sf_attach_tuner,
+
+			MXL111SF_EP6_BULK_STREAMING_CONFIG,
+		},
+		{
+			.frontend_attach  = mxl111sf_attach_demod,
+			.tuner_attach     = mxl111sf_attach_tuner,
+
+			MXL111SF_EP4_BULK_STREAMING_CONFIG,
+		},
+		{
+			.caps = DVB_USB_ADAP_RECEIVES_RAW_PAYLOAD,
+
+			.frontend_attach  = mxl111sf_lg2160_frontend_attach,
+			.tuner_attach     = mxl111sf_attach_tuner,
+
+			MXL111SF_EP5_BULK_STREAMING_CONFIG,
+		}},
+		},
+	},
+	.num_device_descs = 2,
+	.devices = {
 		{   "Hauppauge 126xxx ATSC+ (bulk)",
 			{ NULL },
 			{ &mxl111sf_table[0], &mxl111sf_table[3],
@@ -963,13 +1440,96 @@ static struct dvb_usb_device_properties mxl111sf_atsc_bulk_properties = {
 			  &mxl111sf_table[32], &mxl111sf_table[33],
 			  NULL },
 		},
-		{   "Hauppauge Mercury (tp-bulk)",
+	}
+};
+
+static struct dvb_usb_device_properties mxl111sf_atsc_mh_isoc_properties = {
+	MXL111SF_DEFAULT_DEVICE_PROPERTIES,
+
+	.num_adapters = 1,
+	.adapter = {
+		{
+		.fe_ioctl_override = mxl111sf_fe_ioctl_override,
+		.num_frontends = 3,
+		.fe = {{
+			.frontend_attach  = mxl111sf_lgdt3305_frontend_attach,
+			.tuner_attach     = mxl111sf_attach_tuner,
+
+			MXL111SF_EP6_ISOC_STREAMING_CONFIG,
+		},
+		{
+			.frontend_attach  = mxl111sf_attach_demod,
+			.tuner_attach     = mxl111sf_attach_tuner,
+
+			MXL111SF_EP4_ISOC_STREAMING_CONFIG,
+		},
+		{
+			.caps = DVB_USB_ADAP_RECEIVES_RAW_PAYLOAD,
+
+			.frontend_attach  = mxl111sf_lg2160_frontend_attach,
+			.tuner_attach     = mxl111sf_attach_tuner,
+
+			MXL111SF_EP5_ISOC_STREAMING_CONFIG,
+		}},
+		},
+	},
+	.num_device_descs = 2,
+	.devices = {
+		{   "Hauppauge 126xxx ATSC+ (isoc)",
+			{ NULL },
+			{ &mxl111sf_table[0], &mxl111sf_table[3],
+			  &mxl111sf_table[7], &mxl111sf_table[9],
+			  &mxl111sf_table[10], NULL },
+		},
+		{   "Hauppauge 117xxx ATSC+ (isoc)",
+			{ NULL },
+			{ &mxl111sf_table[11], &mxl111sf_table[14],
+			  &mxl111sf_table[16], &mxl111sf_table[17],
+			  &mxl111sf_table[32], &mxl111sf_table[33],
+			  NULL },
+		},
+	}
+};
+
+static struct dvb_usb_device_properties mxl111sf_mercury_spi_bulk_properties = {
+	MXL111SF_DEFAULT_DEVICE_PROPERTIES,
+
+	.num_adapters = 1,
+	.adapter = {
+		{
+		.fe_ioctl_override = mxl111sf_fe_ioctl_override,
+		.num_frontends = 3,
+		.fe = {{
+			.frontend_attach  = mxl111sf_lgdt3305_frontend_attach,
+			.tuner_attach     = mxl111sf_attach_tuner,
+
+			MXL111SF_EP6_BULK_STREAMING_CONFIG,
+		},
+		{
+			.frontend_attach  = mxl111sf_attach_demod,
+			.tuner_attach     = mxl111sf_attach_tuner,
+
+			MXL111SF_EP4_BULK_STREAMING_CONFIG,
+		},
+		{
+			.caps = DVB_USB_ADAP_RECEIVES_RAW_PAYLOAD,
+
+			.frontend_attach  = mxl111sf_lg2161_frontend_attach,
+			.tuner_attach     = mxl111sf_attach_tuner,
+
+			MXL111SF_EP5_BULK_STREAMING_CONFIG,
+		}},
+		},
+	},
+	.num_device_descs = 2,
+	.devices = {
+		{   "Hauppauge Mercury (spi-bulk)",
 			{ NULL },
 			{ &mxl111sf_table[19], &mxl111sf_table[21],
 			  &mxl111sf_table[23], &mxl111sf_table[25],
-			  &mxl111sf_table[27], NULL },
+			  NULL },
 		},
-		{   "Hauppauge WinTV-Aero-M",
+		{   "Hauppauge WinTV-Aero-M (spi-bulk)",
 			{ NULL },
 			{ &mxl111sf_table[29], &mxl111sf_table[31],
 			  NULL },
@@ -977,14 +1537,14 @@ static struct dvb_usb_device_properties mxl111sf_atsc_bulk_properties = {
 	}
 };
 
-static struct dvb_usb_device_properties mxl111sf_atsc_isoc_properties = {
+static struct dvb_usb_device_properties mxl111sf_mercury_spi_isoc_properties = {
 	MXL111SF_DEFAULT_DEVICE_PROPERTIES,
 
 	.num_adapters = 1,
 	.adapter = {
 		{
 		.fe_ioctl_override = mxl111sf_fe_ioctl_override,
-		.num_frontends = 2,
+		.num_frontends = 3,
 		.fe = {{
 			.frontend_attach  = mxl111sf_lgdt3305_frontend_attach,
 			.tuner_attach     = mxl111sf_attach_tuner,
@@ -996,34 +1556,111 @@ static struct dvb_usb_device_properties mxl111sf_atsc_isoc_properties = {
 			.tuner_attach     = mxl111sf_attach_tuner,
 
 			MXL111SF_EP4_ISOC_STREAMING_CONFIG,
+		},
+		{
+			.caps = DVB_USB_ADAP_RECEIVES_RAW_PAYLOAD,
+
+			.frontend_attach  = mxl111sf_lg2161_frontend_attach,
+			.tuner_attach     = mxl111sf_attach_tuner,
+
+			MXL111SF_EP5_ISOC_STREAMING_CONFIG,
 		}},
 		},
 	},
-	.num_device_descs = 6,
+	.num_device_descs = 2,
 	.devices = {
-		{   "Hauppauge 126xxx ATSC (isoc)",
+		{   "Hauppauge Mercury (spi-isoc)",
 			{ NULL },
-			{ &mxl111sf_table[1], &mxl111sf_table[5],
+			{ &mxl111sf_table[19], &mxl111sf_table[21],
+			  &mxl111sf_table[23], &mxl111sf_table[25],
 			  NULL },
 		},
-		{   "Hauppauge 117xxx ATSC (isoc)",
+		{   "Hauppauge WinTV-Aero-M (spi-isoc)",
 			{ NULL },
-			{ &mxl111sf_table[12],
+			{ &mxl111sf_table[29], &mxl111sf_table[31],
 			  NULL },
 		},
-		{   "Hauppauge 126xxx ATSC+ (isoc)",
+	}
+};
+
+static struct dvb_usb_device_properties mxl111sf_mercury_tp_bulk_properties = {
+	MXL111SF_DEFAULT_DEVICE_PROPERTIES,
+
+	.num_adapters = 1,
+	.adapter = {
+		{
+		.fe_ioctl_override = mxl111sf_fe_ioctl_override,
+		.num_frontends = 3,
+		.fe = {{
+			.frontend_attach  = mxl111sf_lgdt3305_frontend_attach,
+			.tuner_attach     = mxl111sf_attach_tuner,
+
+			MXL111SF_EP6_BULK_STREAMING_CONFIG,
+		},
+		{
+			.frontend_attach  = mxl111sf_attach_demod,
+			.tuner_attach     = mxl111sf_attach_tuner,
+
+			MXL111SF_EP4_BULK_STREAMING_CONFIG,
+		},
+		{
+			.caps = DVB_USB_ADAP_RECEIVES_RAW_PAYLOAD,
+
+			.frontend_attach  = mxl111sf_lg2161_ep6_frontend_attach,
+			.tuner_attach     = mxl111sf_attach_tuner,
+
+			MXL111SF_EP6_BULK_STREAMING_CONFIG,
+		}},
+		},
+	},
+	.num_device_descs = 2,
+	.devices = {
+		{   "Hauppauge Mercury (tp-bulk)",
 			{ NULL },
-			{ &mxl111sf_table[0], &mxl111sf_table[3],
-			  &mxl111sf_table[7], &mxl111sf_table[9],
-			  &mxl111sf_table[10], NULL },
+			{ &mxl111sf_table[19], &mxl111sf_table[21],
+			  &mxl111sf_table[23], &mxl111sf_table[25],
+			  &mxl111sf_table[27], NULL },
 		},
-		{   "Hauppauge 117xxx ATSC+ (isoc)",
+		{   "Hauppauge WinTV-Aero-M",
 			{ NULL },
-			{ &mxl111sf_table[11], &mxl111sf_table[14],
-			  &mxl111sf_table[16], &mxl111sf_table[17],
-			  &mxl111sf_table[32], &mxl111sf_table[33],
+			{ &mxl111sf_table[29], &mxl111sf_table[31],
 			  NULL },
 		},
+	}
+};
+
+static struct dvb_usb_device_properties mxl111sf_mercury_tp_isoc_properties = {
+	MXL111SF_DEFAULT_DEVICE_PROPERTIES,
+
+	.num_adapters = 1,
+	.adapter = {
+		{
+		.fe_ioctl_override = mxl111sf_fe_ioctl_override,
+		.num_frontends = 3,
+		.fe = {{
+			.frontend_attach  = mxl111sf_lgdt3305_frontend_attach,
+			.tuner_attach     = mxl111sf_attach_tuner,
+
+			MXL111SF_EP6_ISOC_STREAMING_CONFIG,
+		},
+		{
+			.frontend_attach  = mxl111sf_attach_demod,
+			.tuner_attach     = mxl111sf_attach_tuner,
+
+			MXL111SF_EP4_ISOC_STREAMING_CONFIG,
+		},
+		{
+			.caps = DVB_USB_ADAP_RECEIVES_RAW_PAYLOAD,
+
+			.frontend_attach  = mxl111sf_lg2161_ep6_frontend_attach,
+			.tuner_attach     = mxl111sf_attach_tuner,
+
+			MXL111SF_EP6_ISOC_STREAMING_CONFIG,
+		}},
+		},
+	},
+	.num_device_descs = 2,
+	.devices = {
 		{   "Hauppauge Mercury (tp-isoc)",
 			{ NULL },
 			{ &mxl111sf_table[19], &mxl111sf_table[21],
@@ -1038,6 +1675,146 @@ static struct dvb_usb_device_properties mxl111sf_atsc_isoc_properties = {
 	}
 };
 
+static
+struct dvb_usb_device_properties mxl111sf_mercury_mh_tp_bulk_properties = {
+	MXL111SF_DEFAULT_DEVICE_PROPERTIES,
+
+	.num_adapters = 1,
+	.adapter = {
+		{
+		.fe_ioctl_override = mxl111sf_fe_ioctl_override,
+		.num_frontends = 2,
+		.fe = {{
+			.frontend_attach  = mxl111sf_attach_demod,
+			.tuner_attach     = mxl111sf_attach_tuner,
+
+			MXL111SF_EP4_BULK_STREAMING_CONFIG,
+		},
+		{
+			.caps = DVB_USB_ADAP_RECEIVES_RAW_PAYLOAD,
+
+			.frontend_attach  = mxl111sf_lg2161_ep6_frontend_attach,
+			.tuner_attach     = mxl111sf_attach_tuner,
+
+			MXL111SF_EP6_BULK_STREAMING_CONFIG,
+		}},
+		},
+	},
+	.num_device_descs = 1,
+	.devices = {
+		{   "Hauppauge 126xxx (tp-bulk)",
+			{ NULL },
+			{ &mxl111sf_table[28], &mxl111sf_table[30],
+			  NULL },
+		},
+	}
+};
+
+static
+struct dvb_usb_device_properties mxl111sf_mercury_mh_tp_isoc_properties = {
+	MXL111SF_DEFAULT_DEVICE_PROPERTIES,
+
+	.num_adapters = 1,
+	.adapter = {
+		{
+		.fe_ioctl_override = mxl111sf_fe_ioctl_override,
+		.num_frontends = 2,
+		.fe = {{
+			.frontend_attach  = mxl111sf_attach_demod,
+			.tuner_attach     = mxl111sf_attach_tuner,
+
+			MXL111SF_EP4_ISOC_STREAMING_CONFIG,
+		},
+		{
+			.caps = DVB_USB_ADAP_RECEIVES_RAW_PAYLOAD,
+
+			.frontend_attach  = mxl111sf_lg2161_ep6_frontend_attach,
+			.tuner_attach     = mxl111sf_attach_tuner,
+
+			MXL111SF_EP6_ISOC_STREAMING_CONFIG,
+		}},
+		},
+	},
+	.num_device_descs = 1,
+	.devices = {
+		{   "Hauppauge 126xxx (tp-isoc)",
+			{ NULL },
+			{ &mxl111sf_table[28], &mxl111sf_table[30],
+			  NULL },
+		},
+	}
+};
+
+static
+struct dvb_usb_device_properties mxl111sf_mercury_mh_spi_bulk_properties = {
+	MXL111SF_DEFAULT_DEVICE_PROPERTIES,
+
+	.num_adapters = 1,
+	.adapter = {
+		{
+		.fe_ioctl_override = mxl111sf_fe_ioctl_override,
+		.num_frontends = 2,
+		.fe = {{
+			.frontend_attach  = mxl111sf_attach_demod,
+			.tuner_attach     = mxl111sf_attach_tuner,
+
+			MXL111SF_EP4_BULK_STREAMING_CONFIG,
+		},
+		{
+			.caps = DVB_USB_ADAP_RECEIVES_RAW_PAYLOAD,
+
+			.frontend_attach  = mxl111sf_lg2161_frontend_attach,
+			.tuner_attach     = mxl111sf_attach_tuner,
+
+			MXL111SF_EP5_BULK_STREAMING_CONFIG,
+		}},
+		},
+	},
+	.num_device_descs = 1,
+	.devices = {
+		{   "Hauppauge 126xxx (spi-bulk)",
+			{ NULL },
+			{ &mxl111sf_table[28], &mxl111sf_table[30],
+			  NULL },
+		},
+	}
+};
+
+static
+struct dvb_usb_device_properties mxl111sf_mercury_mh_spi_isoc_properties = {
+	MXL111SF_DEFAULT_DEVICE_PROPERTIES,
+
+	.num_adapters = 1,
+	.adapter = {
+		{
+		.fe_ioctl_override = mxl111sf_fe_ioctl_override,
+		.num_frontends = 2,
+		.fe = {{
+			.frontend_attach  = mxl111sf_attach_demod,
+			.tuner_attach     = mxl111sf_attach_tuner,
+
+			MXL111SF_EP4_ISOC_STREAMING_CONFIG,
+		},
+		{
+			.caps = DVB_USB_ADAP_RECEIVES_RAW_PAYLOAD,
+
+			.frontend_attach  = mxl111sf_lg2161_frontend_attach,
+			.tuner_attach     = mxl111sf_attach_tuner,
+
+			MXL111SF_EP5_ISOC_STREAMING_CONFIG,
+		}},
+		},
+	},
+	.num_device_descs = 1,
+	.devices = {
+		{   "Hauppauge 126xxx (spi-isoc)",
+			{ NULL },
+			{ &mxl111sf_table[28], &mxl111sf_table[30],
+			  NULL },
+		},
+	}
+};
+
 static struct usb_driver mxl111sf_driver = {
 	.name		= "dvb_usb_mxl111sf",
 	.probe		= mxl111sf_probe,
-- 
1.7.5.4

