Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:3145 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773Ab3EWGu6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 May 2013 02:50:58 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [PATCH] mxl111sf: don't redefine pr_err/info/debug
Date: Thu, 23 May 2013 08:50:43 +0200
Cc: Michael Krufky <mkrufky@linuxtv.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201305230850.43199.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove the silly redefines of pr_err/info/debug.

This improves readability and it also gets rid of a bunch of warnings when
compiling this driver for older kernels using the compatibility media_build
system.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/dvb-usb-v2/mxl111sf-tuner.c |    8 +--
 drivers/media/usb/dvb-usb-v2/mxl111sf.c       |   90 ++++++++++++-------------
 2 files changed, 45 insertions(+), 53 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/mxl111sf-tuner.c b/drivers/media/usb/dvb-usb-v2/mxl111sf-tuner.c
index ef4c65f..879c529 100644
--- a/drivers/media/usb/dvb-usb-v2/mxl111sf-tuner.c
+++ b/drivers/media/usb/dvb-usb-v2/mxl111sf-tuner.c
@@ -31,8 +31,6 @@ MODULE_PARM_DESC(debug, "set debugging level (1=info (or-able)).");
 	if (mxl111sf_tuner_debug) \
 		mxl_printk(KERN_DEBUG, fmt, ##arg)
 
-#define err pr_err
-
 /* ------------------------------------------------------------------------ */
 
 struct mxl111sf_tuner_state {
@@ -113,7 +111,7 @@ static struct mxl111sf_reg_ctrl_info *mxl111sf_calc_phy_tune_regs(u32 freq,
 		filt_bw = 63;
 		break;
 	default:
-		err("%s: invalid bandwidth setting!", __func__);
+		pr_err("%s: invalid bandwidth setting!", __func__);
 		return NULL;
 	}
 
@@ -304,12 +302,12 @@ static int mxl111sf_tuner_set_params(struct dvb_frontend *fe)
 			bw = 8;
 			break;
 		default:
-			err("%s: bandwidth not set!", __func__);
+			pr_err("%s: bandwidth not set!", __func__);
 			return -EINVAL;
 		}
 		break;
 	default:
-		err("%s: modulation type not supported!", __func__);
+		pr_err("%s: modulation type not supported!", __func__);
 		return -EINVAL;
 	}
 	ret = mxl1x1sf_tune_rf(fe, c->frequency, bw);
diff --git a/drivers/media/usb/dvb-usb-v2/mxl111sf.c b/drivers/media/usb/dvb-usb-v2/mxl111sf.c
index efdcb15..e97964e 100644
--- a/drivers/media/usb/dvb-usb-v2/mxl111sf.c
+++ b/drivers/media/usb/dvb-usb-v2/mxl111sf.c
@@ -52,12 +52,6 @@ MODULE_PARM_DESC(rfswitch, "force rf switch position (0=auto, 1=ext, 2=int).");
 
 DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 
-#define deb_info pr_debug
-#define deb_reg pr_debug
-#define deb_adv pr_debug
-#define err pr_err
-#define info pr_info
-
 int mxl111sf_ctrl_msg(struct dvb_usb_device *d,
 		      u8 cmd, u8 *wbuf, int wlen, u8 *rbuf, int rlen)
 {
@@ -65,7 +59,7 @@ int mxl111sf_ctrl_msg(struct dvb_usb_device *d,
 	int ret;
 	u8 sndbuf[1+wlen];
 
-	deb_adv("%s(wlen = %d, rlen = %d)\n", __func__, wlen, rlen);
+	pr_debug("%s(wlen = %d, rlen = %d)\n", __func__, wlen, rlen);
 
 	memset(sndbuf, 0, 1+wlen);
 
@@ -98,12 +92,12 @@ int mxl111sf_read_reg(struct mxl111sf_state *state, u8 addr, u8 *data)
 	if (buf[0] == addr)
 		*data = buf[1];
 	else {
-		err("invalid response reading reg: 0x%02x != 0x%02x, 0x%02x",
+		pr_err("invalid response reading reg: 0x%02x != 0x%02x, 0x%02x",
 		    addr, buf[0], buf[1]);
 		ret = -EINVAL;
 	}
 
-	deb_reg("R: (0x%02x, 0x%02x)\n", addr, *data);
+	pr_debug("R: (0x%02x, 0x%02x)\n", addr, *data);
 fail:
 	return ret;
 }
@@ -113,11 +107,11 @@ int mxl111sf_write_reg(struct mxl111sf_state *state, u8 addr, u8 data)
 	u8 buf[] = { addr, data };
 	int ret;
 
-	deb_reg("W: (0x%02x, 0x%02x)\n", addr, data);
+	pr_debug("W: (0x%02x, 0x%02x)\n", addr, data);
 
 	ret = mxl111sf_ctrl_msg(state->d, MXL_CMD_REG_WRITE, buf, 2, NULL, 0);
 	if (mxl_fail(ret))
-		err("error writing reg: 0x%02x, val: 0x%02x", addr, data);
+		pr_err("error writing reg: 0x%02x, val: 0x%02x", addr, data);
 	return ret;
 }
 
@@ -134,7 +128,7 @@ int mxl111sf_write_reg_mask(struct mxl111sf_state *state,
 #if 1
 		/* dont know why this usually errors out on the first try */
 		if (mxl_fail(ret))
-			err("error writing addr: 0x%02x, mask: 0x%02x, "
+			pr_err("error writing addr: 0x%02x, mask: 0x%02x, "
 			    "data: 0x%02x, retrying...", addr, mask, data);
 
 		ret = mxl111sf_read_reg(state, addr, &val);
@@ -167,7 +161,7 @@ int mxl111sf_ctrl_program_regs(struct mxl111sf_state *state,
 					      ctrl_reg_info[i].mask,
 					      ctrl_reg_info[i].data);
 		if (mxl_fail(ret)) {
-			err("failed on reg #%d (0x%02x)", i,
+			pr_err("failed on reg #%d (0x%02x)", i,
 			    ctrl_reg_info[i].addr);
 			break;
 		}
@@ -225,7 +219,7 @@ static int mxl1x1sf_get_chip_info(struct mxl111sf_state *state)
 		mxl_rev = "UNKNOWN REVISION";
 		break;
 	}
-	info("%s detected, %s (0x%x)", mxl_chip, mxl_rev, ver);
+	pr_info("%s detected, %s (0x%x)", mxl_chip, mxl_rev, ver);
 fail:
 	return ret;
 }
@@ -239,7 +233,7 @@ fail:
 			  " on first probe attempt");			\
 		___ret = mxl1x1sf_get_chip_info(state);			\
 		if (mxl_fail(___ret))					\
-			err("failed to get chip info during probe");	\
+			pr_err("failed to get chip info during probe");	\
 		else							\
 			mxl_debug("probe needed a retry "		\
 				  "in order to succeed.");		\
@@ -270,14 +264,14 @@ static int mxl111sf_adap_fe_init(struct dvb_frontend *fe)
 		goto fail;
 	}
 
-	deb_info("%s()\n", __func__);
+	pr_debug("%s()\n", __func__);
 
 	mutex_lock(&state->fe_lock);
 
 	state->alt_mode = adap_state->alt_mode;
 
 	if (usb_set_interface(d->udev, 0, state->alt_mode) < 0)
-		err("set interface failed");
+		pr_err("set interface failed");
 
 	err = mxl1x1sf_soft_reset(state);
 	mxl_fail(err);
@@ -326,7 +320,7 @@ static int mxl111sf_adap_fe_sleep(struct dvb_frontend *fe)
 		goto fail;
 	}
 
-	deb_info("%s()\n", __func__);
+	pr_debug("%s()\n", __func__);
 
 	err = (adap_state->fe_sleep) ? adap_state->fe_sleep(fe) : 0;
 
@@ -344,7 +338,7 @@ static int mxl111sf_ep6_streaming_ctrl(struct dvb_frontend *fe, int onoff)
 	struct mxl111sf_adap_state *adap_state = &state->adap_state[fe->id];
 	int ret = 0;
 
-	deb_info("%s(%d)\n", __func__, onoff);
+	pr_debug("%s(%d)\n", __func__, onoff);
 
 	if (onoff) {
 		ret = mxl111sf_enable_usb_output(state);
@@ -368,7 +362,7 @@ static int mxl111sf_ep5_streaming_ctrl(struct dvb_frontend *fe, int onoff)
 	struct mxl111sf_state *state = fe_to_priv(fe);
 	int ret = 0;
 
-	deb_info("%s(%d)\n", __func__, onoff);
+	pr_debug("%s(%d)\n", __func__, onoff);
 
 	if (onoff) {
 		ret = mxl111sf_enable_usb_output(state);
@@ -394,7 +388,7 @@ static int mxl111sf_ep4_streaming_ctrl(struct dvb_frontend *fe, int onoff)
 	struct mxl111sf_state *state = fe_to_priv(fe);
 	int ret = 0;
 
-	deb_info("%s(%d)\n", __func__, onoff);
+	pr_debug("%s(%d)\n", __func__, onoff);
 
 	if (onoff) {
 		ret = mxl111sf_enable_usb_output(state);
@@ -424,7 +418,7 @@ static int mxl111sf_lgdt3305_frontend_attach(struct dvb_usb_adapter *adap, u8 fe
 	struct mxl111sf_adap_state *adap_state = &state->adap_state[fe_id];
 	int ret;
 
-	deb_adv("%s()\n", __func__);
+	pr_debug("%s()\n", __func__);
 
 	/* save a pointer to the dvb_usb_device in device state */
 	state->d = d;
@@ -432,7 +426,7 @@ static int mxl111sf_lgdt3305_frontend_attach(struct dvb_usb_adapter *adap, u8 fe
 	state->alt_mode = adap_state->alt_mode;
 
 	if (usb_set_interface(d->udev, 0, state->alt_mode) < 0)
-		err("set interface failed");
+		pr_err("set interface failed");
 
 	state->gpio_mode = MXL111SF_GPIO_MOD_ATSC;
 	adap_state->gpio_mode = state->gpio_mode;
@@ -495,7 +489,7 @@ static int mxl111sf_lg2160_frontend_attach(struct dvb_usb_adapter *adap, u8 fe_i
 	struct mxl111sf_adap_state *adap_state = &state->adap_state[fe_id];
 	int ret;
 
-	deb_adv("%s()\n", __func__);
+	pr_debug("%s()\n", __func__);
 
 	/* save a pointer to the dvb_usb_device in device state */
 	state->d = d;
@@ -503,7 +497,7 @@ static int mxl111sf_lg2160_frontend_attach(struct dvb_usb_adapter *adap, u8 fe_i
 	state->alt_mode = adap_state->alt_mode;
 
 	if (usb_set_interface(d->udev, 0, state->alt_mode) < 0)
-		err("set interface failed");
+		pr_err("set interface failed");
 
 	state->gpio_mode = MXL111SF_GPIO_MOD_MH;
 	adap_state->gpio_mode = state->gpio_mode;
@@ -580,7 +574,7 @@ static int mxl111sf_lg2161_frontend_attach(struct dvb_usb_adapter *adap, u8 fe_i
 	struct mxl111sf_adap_state *adap_state = &state->adap_state[fe_id];
 	int ret;
 
-	deb_adv("%s()\n", __func__);
+	pr_debug("%s()\n", __func__);
 
 	/* save a pointer to the dvb_usb_device in device state */
 	state->d = d;
@@ -588,7 +582,7 @@ static int mxl111sf_lg2161_frontend_attach(struct dvb_usb_adapter *adap, u8 fe_i
 	state->alt_mode = adap_state->alt_mode;
 
 	if (usb_set_interface(d->udev, 0, state->alt_mode) < 0)
-		err("set interface failed");
+		pr_err("set interface failed");
 
 	state->gpio_mode = MXL111SF_GPIO_MOD_MH;
 	adap_state->gpio_mode = state->gpio_mode;
@@ -667,7 +661,7 @@ static int mxl111sf_lg2161_ep6_frontend_attach(struct dvb_usb_adapter *adap, u8
 	struct mxl111sf_adap_state *adap_state = &state->adap_state[fe_id];
 	int ret;
 
-	deb_adv("%s()\n", __func__);
+	pr_debug("%s()\n", __func__);
 
 	/* save a pointer to the dvb_usb_device in device state */
 	state->d = d;
@@ -675,7 +669,7 @@ static int mxl111sf_lg2161_ep6_frontend_attach(struct dvb_usb_adapter *adap, u8
 	state->alt_mode = adap_state->alt_mode;
 
 	if (usb_set_interface(d->udev, 0, state->alt_mode) < 0)
-		err("set interface failed");
+		pr_err("set interface failed");
 
 	state->gpio_mode = MXL111SF_GPIO_MOD_MH;
 	adap_state->gpio_mode = state->gpio_mode;
@@ -742,7 +736,7 @@ static int mxl111sf_attach_demod(struct dvb_usb_adapter *adap, u8 fe_id)
 	struct mxl111sf_adap_state *adap_state = &state->adap_state[fe_id];
 	int ret;
 
-	deb_adv("%s()\n", __func__);
+	pr_debug("%s()\n", __func__);
 
 	/* save a pointer to the dvb_usb_device in device state */
 	state->d = d;
@@ -750,7 +744,7 @@ static int mxl111sf_attach_demod(struct dvb_usb_adapter *adap, u8 fe_id)
 	state->alt_mode = adap_state->alt_mode;
 
 	if (usb_set_interface(d->udev, 0, state->alt_mode) < 0)
-		err("set interface failed");
+		pr_err("set interface failed");
 
 	state->gpio_mode = MXL111SF_GPIO_MOD_DVBT;
 	adap_state->gpio_mode = state->gpio_mode;
@@ -802,7 +796,7 @@ static inline int mxl111sf_set_ant_path(struct mxl111sf_state *state,
 }
 
 #define DbgAntHunt(x, pwr0, pwr1, pwr2, pwr3) \
-	err("%s(%d) FINAL input set to %s rxPwr:%d|%d|%d|%d\n", \
+	pr_err("%s(%d) FINAL input set to %s rxPwr:%d|%d|%d|%d\n", \
 	    __func__, __LINE__, \
 	    (ANT_PATH_EXTERNAL == x) ? "EXTERNAL" : "INTERNAL", \
 	    pwr0, pwr1, pwr2, pwr3)
@@ -868,7 +862,7 @@ static int mxl111sf_attach_tuner(struct dvb_usb_adapter *adap)
 	struct mxl111sf_state *state = adap_to_priv(adap);
 	int i;
 
-	deb_adv("%s()\n", __func__);
+	pr_debug("%s()\n", __func__);
 
 	for (i = 0; i < state->num_frontends; i++) {
 		if (dvb_attach(mxl111sf_tuner_attach, adap->fe[i], state,
@@ -902,7 +896,7 @@ static int mxl111sf_init(struct dvb_usb_device *d)
 
 	ret = get_chip_info(state);
 	if (mxl_fail(ret))
-		err("failed to get chip info during probe");
+		pr_err("failed to get chip info during probe");
 
 	mutex_init(&state->fe_lock);
 
@@ -950,7 +944,7 @@ static int mxl111sf_frontend_attach_mh(struct dvb_usb_adapter *adap)
 static int mxl111sf_frontend_attach_atsc_mh(struct dvb_usb_adapter *adap)
 {
 	int ret;
-	deb_info("%s\n", __func__);
+	pr_debug("%s\n", __func__);
 
 	ret = mxl111sf_lgdt3305_frontend_attach(adap, 0);
 	if (ret < 0)
@@ -970,7 +964,7 @@ static int mxl111sf_frontend_attach_atsc_mh(struct dvb_usb_adapter *adap)
 static int mxl111sf_frontend_attach_mercury(struct dvb_usb_adapter *adap)
 {
 	int ret;
-	deb_info("%s\n", __func__);
+	pr_debug("%s\n", __func__);
 
 	ret = mxl111sf_lgdt3305_frontend_attach(adap, 0);
 	if (ret < 0)
@@ -990,7 +984,7 @@ static int mxl111sf_frontend_attach_mercury(struct dvb_usb_adapter *adap)
 static int mxl111sf_frontend_attach_mercury_mh(struct dvb_usb_adapter *adap)
 {
 	int ret;
-	deb_info("%s\n", __func__);
+	pr_debug("%s\n", __func__);
 
 	ret = mxl111sf_attach_demod(adap, 0);
 	if (ret < 0)
@@ -1006,7 +1000,7 @@ static int mxl111sf_frontend_attach_mercury_mh(struct dvb_usb_adapter *adap)
 
 static void mxl111sf_stream_config_bulk(struct usb_data_stream_properties *stream, u8 endpoint)
 {
-	deb_info("%s: endpoint=%d size=8192\n", __func__, endpoint);
+	pr_debug("%s: endpoint=%d size=8192\n", __func__, endpoint);
 	stream->type = USB_BULK;
 	stream->count = 5;
 	stream->endpoint = endpoint;
@@ -1016,7 +1010,7 @@ static void mxl111sf_stream_config_bulk(struct usb_data_stream_properties *strea
 static void mxl111sf_stream_config_isoc(struct usb_data_stream_properties *stream,
 		u8 endpoint, int framesperurb, int framesize)
 {
-	deb_info("%s: endpoint=%d size=%d\n", __func__, endpoint,
+	pr_debug("%s: endpoint=%d size=%d\n", __func__, endpoint,
 			framesperurb * framesize);
 	stream->type = USB_ISOC;
 	stream->count = 5;
@@ -1035,7 +1029,7 @@ static void mxl111sf_stream_config_isoc(struct usb_data_stream_properties *strea
 static int mxl111sf_get_stream_config_dvbt(struct dvb_frontend *fe,
 		u8 *ts_type, struct usb_data_stream_properties *stream)
 {
-	deb_info("%s: fe=%d\n", __func__, fe->id);
+	pr_debug("%s: fe=%d\n", __func__, fe->id);
 
 	*ts_type = DVB_USB_FE_TS_TYPE_188;
 	if (dvb_usb_mxl111sf_isoc)
@@ -1076,7 +1070,7 @@ static struct dvb_usb_device_properties mxl111sf_props_dvbt = {
 static int mxl111sf_get_stream_config_atsc(struct dvb_frontend *fe,
 		u8 *ts_type, struct usb_data_stream_properties *stream)
 {
-	deb_info("%s: fe=%d\n", __func__, fe->id);
+	pr_debug("%s: fe=%d\n", __func__, fe->id);
 
 	*ts_type = DVB_USB_FE_TS_TYPE_188;
 	if (dvb_usb_mxl111sf_isoc)
@@ -1117,7 +1111,7 @@ static struct dvb_usb_device_properties mxl111sf_props_atsc = {
 static int mxl111sf_get_stream_config_mh(struct dvb_frontend *fe,
 		u8 *ts_type, struct usb_data_stream_properties *stream)
 {
-	deb_info("%s: fe=%d\n", __func__, fe->id);
+	pr_debug("%s: fe=%d\n", __func__, fe->id);
 
 	*ts_type = DVB_USB_FE_TS_TYPE_RAW;
 	if (dvb_usb_mxl111sf_isoc)
@@ -1158,7 +1152,7 @@ static struct dvb_usb_device_properties mxl111sf_props_mh = {
 static int mxl111sf_get_stream_config_atsc_mh(struct dvb_frontend *fe,
 		u8 *ts_type, struct usb_data_stream_properties *stream)
 {
-	deb_info("%s: fe=%d\n", __func__, fe->id);
+	pr_debug("%s: fe=%d\n", __func__, fe->id);
 
 	if (fe->id == 0) {
 		*ts_type = DVB_USB_FE_TS_TYPE_188;
@@ -1184,7 +1178,7 @@ static int mxl111sf_get_stream_config_atsc_mh(struct dvb_frontend *fe,
 
 static int mxl111sf_streaming_ctrl_atsc_mh(struct dvb_frontend *fe, int onoff)
 {
-	deb_info("%s: fe=%d onoff=%d\n", __func__, fe->id, onoff);
+	pr_debug("%s: fe=%d onoff=%d\n", __func__, fe->id, onoff);
 
 	if (fe->id == 0)
 		return mxl111sf_ep6_streaming_ctrl(fe, onoff);
@@ -1228,7 +1222,7 @@ static struct dvb_usb_device_properties mxl111sf_props_atsc_mh = {
 static int mxl111sf_get_stream_config_mercury(struct dvb_frontend *fe,
 		u8 *ts_type, struct usb_data_stream_properties *stream)
 {
-	deb_info("%s: fe=%d\n", __func__, fe->id);
+	pr_debug("%s: fe=%d\n", __func__, fe->id);
 
 	if (fe->id == 0) {
 		*ts_type = DVB_USB_FE_TS_TYPE_188;
@@ -1260,7 +1254,7 @@ static int mxl111sf_get_stream_config_mercury(struct dvb_frontend *fe,
 
 static int mxl111sf_streaming_ctrl_mercury(struct dvb_frontend *fe, int onoff)
 {
-	deb_info("%s: fe=%d onoff=%d\n", __func__, fe->id, onoff);
+	pr_debug("%s: fe=%d onoff=%d\n", __func__, fe->id, onoff);
 
 	if (fe->id == 0)
 		return mxl111sf_ep6_streaming_ctrl(fe, onoff);
@@ -1306,7 +1300,7 @@ static struct dvb_usb_device_properties mxl111sf_props_mercury = {
 static int mxl111sf_get_stream_config_mercury_mh(struct dvb_frontend *fe,
 		u8 *ts_type, struct usb_data_stream_properties *stream)
 {
-	deb_info("%s: fe=%d\n", __func__, fe->id);
+	pr_debug("%s: fe=%d\n", __func__, fe->id);
 
 	if (fe->id == 0) {
 		*ts_type = DVB_USB_FE_TS_TYPE_188;
@@ -1332,7 +1326,7 @@ static int mxl111sf_get_stream_config_mercury_mh(struct dvb_frontend *fe,
 
 static int mxl111sf_streaming_ctrl_mercury_mh(struct dvb_frontend *fe, int onoff)
 {
-	deb_info("%s: fe=%d onoff=%d\n", __func__, fe->id, onoff);
+	pr_debug("%s: fe=%d onoff=%d\n", __func__, fe->id, onoff);
 
 	if (fe->id == 0)
 		return mxl111sf_ep4_streaming_ctrl(fe, onoff);
-- 
1.7.10.4

