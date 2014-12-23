Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:56324 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754025AbaLWVQS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Dec 2014 16:16:18 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 60/66] rtl28xxu: fix logging
Date: Tue, 23 Dec 2014 22:49:53 +0200
Message-Id: <1419367799-14263-60-git-send-email-crope@iki.fi>
In-Reply-To: <1419367799-14263-1-git-send-email-crope@iki.fi>
References: <1419367799-14263-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Pass correct device pointer to dev_* logging in order to print
module name and bus id correctly.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 90 +++++++++++++++------------------
 1 file changed, 42 insertions(+), 48 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index 57afcba..e3312a2 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -71,7 +71,7 @@ static int rtl28xxu_ctrl_msg(struct dvb_usb_device *d, struct rtl28xxu_req *req)
 
 	return ret;
 err:
-	dev_dbg(&d->udev->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&d->intf->dev, "failed=%d\n", ret);
 	return ret;
 }
 
@@ -276,7 +276,7 @@ static int rtl2831u_read_config(struct dvb_usb_device *d)
 	struct rtl28xxu_req req_mt2060 = {0x00c0, CMD_I2C_RD, 1, buf};
 	struct rtl28xxu_req req_qt1010 = {0x0fc4, CMD_I2C_RD, 1, buf};
 
-	dev_dbg(&d->udev->dev, "%s:\n", __func__);
+	dev_dbg(&d->intf->dev, "\n");
 
 	/*
 	 * RTL2831U GPIOs
@@ -338,11 +338,11 @@ static int rtl2831u_read_config(struct dvb_usb_device *d)
 	goto found;
 
 found:
-	dev_dbg(&d->udev->dev, "%s: tuner=%s\n", __func__, dev->tuner_name);
+	dev_dbg(&d->intf->dev, "tuner=%s\n", dev->tuner_name);
 
 	return 0;
 err:
-	dev_dbg(&d->udev->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&d->intf->dev, "failed=%d\n", ret);
 	return ret;
 }
 
@@ -371,7 +371,7 @@ static int rtl2832u_read_config(struct dvb_usb_device *d)
 	struct rtl28xxu_req req_mn88472 = {0xff38, CMD_I2C_RD, 1, buf};
 	struct rtl28xxu_req req_mn88473 = {0xff38, CMD_I2C_RD, 1, buf};
 
-	dev_dbg(&d->udev->dev, "%s:\n", __func__);
+	dev_dbg(&d->intf->dev, "\n");
 
 	/* enable GPIO3 and GPIO6 as output */
 	ret = rtl28xx_wr_reg_mask(d, SYS_GPIO_DIR, 0x00, 0x40);
@@ -491,7 +491,7 @@ static int rtl2832u_read_config(struct dvb_usb_device *d)
 	}
 
 tuner_found:
-	dev_dbg(&d->udev->dev, "%s: tuner=%s\n", __func__, dev->tuner_name);
+	dev_dbg(&d->intf->dev, "tuner=%s\n", dev->tuner_name);
 
 	/* probe slave demod */
 	if (dev->tuner == TUNER_RTL2832_R828D) {
@@ -511,14 +511,14 @@ tuner_found:
 		/* check MN88472 answers */
 		ret = rtl28xxu_ctrl_msg(d, &req_mn88472);
 		if (ret == 0 && buf[0] == 0x02) {
-			dev_dbg(&d->udev->dev, "%s: MN88472 found\n", __func__);
+			dev_dbg(&d->intf->dev, "MN88472 found\n");
 			dev->slave_demod = SLAVE_DEMOD_MN88472;
 			goto demod_found;
 		}
 
 		ret = rtl28xxu_ctrl_msg(d, &req_mn88473);
 		if (ret == 0 && buf[0] == 0x03) {
-			dev_dbg(&d->udev->dev, "%s: MN88473 found\n", __func__);
+			dev_dbg(&d->intf->dev, "MN88473 found\n");
 			dev->slave_demod = SLAVE_DEMOD_MN88473;
 			goto demod_found;
 		}
@@ -532,7 +532,7 @@ demod_found:
 
 	return 0;
 err:
-	dev_dbg(&d->udev->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&d->intf->dev, "failed=%d\n", ret);
 	return ret;
 }
 
@@ -570,7 +570,7 @@ static int rtl2831u_frontend_attach(struct dvb_usb_adapter *adap)
 	struct i2c_client *client;
 	int ret;
 
-	dev_dbg(&d->udev->dev, "%s:\n", __func__);
+	dev_dbg(&d->intf->dev, "\n");
 
 	switch (dev->tuner) {
 	case TUNER_RTL2830_QT1010:
@@ -583,8 +583,7 @@ static int rtl2831u_frontend_attach(struct dvb_usb_adapter *adap)
 		*pdata = rtl2830_mxl5005s_platform_data;
 		break;
 	default:
-		dev_err(&d->udev->dev, "%s: unknown tuner=%s\n",
-				KBUILD_MODNAME, dev->tuner_name);
+		dev_err(&d->intf->dev, "unknown tuner %s\n", dev->tuner_name);
 		ret = -ENODEV;
 		goto err;
 	}
@@ -614,7 +613,7 @@ static int rtl2831u_frontend_attach(struct dvb_usb_adapter *adap)
 
 	return 0;
 err:
-	dev_dbg(&d->udev->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&d->intf->dev, "failed=%d\n", ret);
 	return ret;
 }
 
@@ -649,7 +648,7 @@ static int rtl2832u_fc0012_tuner_callback(struct dvb_usb_device *d,
 	int ret;
 	u8 val;
 
-	dev_dbg(&d->udev->dev, "%s: cmd=%d arg=%d\n", __func__, cmd, arg);
+	dev_dbg(&d->intf->dev, "cmd=%d arg=%d\n", cmd, arg);
 
 	switch (cmd) {
 	case FC_FE_CALLBACK_VHF_ENABLE:
@@ -674,7 +673,7 @@ static int rtl2832u_fc0012_tuner_callback(struct dvb_usb_device *d,
 	}
 	return 0;
 err:
-	dev_dbg(&d->udev->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&d->intf->dev, "failed=%d\n", ret);
 	return ret;
 }
 
@@ -684,7 +683,7 @@ static int rtl2832u_tua9001_tuner_callback(struct dvb_usb_device *d,
 	int ret;
 	u8 val;
 
-	dev_dbg(&d->udev->dev, "%s: cmd=%d arg=%d\n", __func__, cmd, arg);
+	dev_dbg(&d->intf->dev, "cmd=%d arg=%d\n", cmd, arg);
 
 	/*
 	 * CEN     always enabled by hardware wiring
@@ -717,7 +716,7 @@ static int rtl2832u_tua9001_tuner_callback(struct dvb_usb_device *d,
 
 	return 0;
 err:
-	dev_dbg(&d->udev->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&d->intf->dev, "failed=%d\n", ret);
 	return ret;
 }
 
@@ -744,8 +743,8 @@ static int rtl2832u_frontend_callback(void *adapter_priv, int component,
 	d = i2c_get_adapdata(parent_adapter);
 	dev = d->priv;
 
-	dev_dbg(&d->udev->dev, "%s: component=%d cmd=%d arg=%d\n",
-			__func__, component, cmd, arg);
+	dev_dbg(&d->intf->dev, "component=%d cmd=%d arg=%d\n",
+		component, cmd, arg);
 
 	switch (component) {
 	case DVB_FRONTEND_COMPONENT_TUNER:
@@ -771,7 +770,7 @@ static int rtl2832u_frontend_attach(struct dvb_usb_adapter *adap)
 	struct i2c_client *client;
 	int ret;
 
-	dev_dbg(&d->udev->dev, "%s:\n", __func__);
+	dev_dbg(&d->intf->dev, "\n");
 
 	switch (dev->tuner) {
 	case TUNER_RTL2832_FC0012:
@@ -795,8 +794,7 @@ static int rtl2832u_frontend_attach(struct dvb_usb_adapter *adap)
 		*pdata = rtl2832_r820t_platform_data;
 		break;
 	default:
-		dev_err(&d->udev->dev, "%s: unknown tuner=%s\n",
-				KBUILD_MODNAME, dev->tuner_name);
+		dev_err(&d->intf->dev, "unknown tuner %s\n", dev->tuner_name);
 		ret = -ENODEV;
 		goto err;
 	}
@@ -888,7 +886,7 @@ static int rtl2832u_frontend_attach(struct dvb_usb_adapter *adap)
 	return 0;
 err_slave_demod_failed:
 err:
-	dev_dbg(&d->udev->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&d->intf->dev, "failed=%d\n", ret);
 	return ret;
 }
 
@@ -898,7 +896,7 @@ static int rtl2832u_frontend_detach(struct dvb_usb_adapter *adap)
 	struct rtl28xxu_dev *dev = d_to_priv(d);
 	struct i2c_client *client;
 
-	dev_dbg(&d->udev->dev, "%s:\n", __func__);
+	dev_dbg(&d->intf->dev, "\n");
 
 	/* remove I2C slave demod */
 	client = dev->i2c_client_slave_demod;
@@ -950,7 +948,7 @@ static int rtl2831u_tuner_attach(struct dvb_usb_adapter *adap)
 	struct rtl28xxu_dev *dev = d_to_priv(d);
 	struct dvb_frontend *fe;
 
-	dev_dbg(&d->udev->dev, "%s:\n", __func__);
+	dev_dbg(&d->intf->dev, "\n");
 
 	switch (dev->tuner) {
 	case TUNER_RTL2830_QT1010:
@@ -970,8 +968,7 @@ static int rtl2831u_tuner_attach(struct dvb_usb_adapter *adap)
 		break;
 	default:
 		fe = NULL;
-		dev_err(&d->udev->dev, "%s: unknown tuner=%d\n", KBUILD_MODNAME,
-				dev->tuner);
+		dev_err(&d->intf->dev, "unknown tuner %d\n", dev->tuner);
 	}
 
 	if (fe == NULL) {
@@ -981,7 +978,7 @@ static int rtl2831u_tuner_attach(struct dvb_usb_adapter *adap)
 
 	return 0;
 err:
-	dev_dbg(&d->udev->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&d->intf->dev, "failed=%d\n", ret);
 	return ret;
 }
 
@@ -1023,7 +1020,7 @@ static int rtl2832u_tuner_attach(struct dvb_usb_adapter *adap)
 	struct i2c_client *client;
 	struct v4l2_subdev *subdev = NULL;
 
-	dev_dbg(&d->udev->dev, "%s:\n", __func__);
+	dev_dbg(&d->intf->dev, "\n");
 
 	memset(&info, 0, sizeof(struct i2c_board_info));
 
@@ -1113,8 +1110,7 @@ static int rtl2832u_tuner_attach(struct dvb_usb_adapter *adap)
 		}
 		break;
 	default:
-		dev_err(&d->udev->dev, "%s: unknown tuner=%d\n", KBUILD_MODNAME,
-				dev->tuner);
+		dev_err(&d->intf->dev, "unknown tuner %d\n", dev->tuner);
 	}
 	if (fe == NULL && dev->i2c_client_tuner == NULL) {
 		ret = -ENODEV;
@@ -1151,12 +1147,12 @@ static int rtl2832u_tuner_attach(struct dvb_usb_adapter *adap)
 		dev->platform_device_sdr = pdev;
 		break;
 	default:
-		dev_dbg(&d->udev->dev, "no SDR for tuner=%d\n", dev->tuner);
+		dev_dbg(&d->intf->dev, "no SDR for tuner=%d\n", dev->tuner);
 	}
 
 	return 0;
 err:
-	dev_dbg(&d->udev->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&d->intf->dev, "failed=%d\n", ret);
 	return ret;
 }
 
@@ -1167,7 +1163,7 @@ static int rtl2832u_tuner_detach(struct dvb_usb_adapter *adap)
 	struct i2c_client *client;
 	struct platform_device *pdev;
 
-	dev_dbg(&d->udev->dev, "%s:\n", __func__);
+	dev_dbg(&d->intf->dev, "\n");
 
 	/* remove platform SDR */
 	pdev = dev->platform_device_sdr;
@@ -1189,7 +1185,7 @@ static int rtl28xxu_init(struct dvb_usb_device *d)
 	int ret;
 	u8 val;
 
-	dev_dbg(&d->udev->dev, "%s:\n", __func__);
+	dev_dbg(&d->intf->dev, "\n");
 
 	/* init USB endpoints */
 	ret = rtl28xx_rd_reg(d, USB_SYSCTL_0, &val);
@@ -1214,7 +1210,7 @@ static int rtl28xxu_init(struct dvb_usb_device *d)
 
 	return ret;
 err:
-	dev_dbg(&d->udev->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&d->intf->dev, "failed=%d\n", ret);
 	return ret;
 }
 
@@ -1223,7 +1219,7 @@ static int rtl2831u_power_ctrl(struct dvb_usb_device *d, int onoff)
 	int ret;
 	u8 gpio, sys0, epa_ctl[2];
 
-	dev_dbg(&d->udev->dev, "%s: onoff=%d\n", __func__, onoff);
+	dev_dbg(&d->intf->dev, "onoff=%d\n", onoff);
 
 	/* demod adc */
 	ret = rtl28xx_rd_reg(d, SYS_SYS0, &sys0);
@@ -1235,8 +1231,7 @@ static int rtl2831u_power_ctrl(struct dvb_usb_device *d, int onoff)
 	if (ret)
 		goto err;
 
-	dev_dbg(&d->udev->dev, "%s: RD SYS0=%02x GPIO_OUT_VAL=%02x\n", __func__,
-			sys0, gpio);
+	dev_dbg(&d->intf->dev, "RD SYS0=%02x GPIO_OUT_VAL=%02x\n", sys0, gpio);
 
 	if (onoff) {
 		gpio |= 0x01; /* GPIO0 = 1 */
@@ -1255,8 +1250,7 @@ static int rtl2831u_power_ctrl(struct dvb_usb_device *d, int onoff)
 		epa_ctl[1] = 0x02; /* set reset */
 	}
 
-	dev_dbg(&d->udev->dev, "%s: WR SYS0=%02x GPIO_OUT_VAL=%02x\n", __func__,
-			sys0, gpio);
+	dev_dbg(&d->intf->dev, "WR SYS0=%02x GPIO_OUT_VAL=%02x\n", sys0, gpio);
 
 	/* demod adc */
 	ret = rtl28xx_wr_reg(d, SYS_SYS0, sys0);
@@ -1278,7 +1272,7 @@ static int rtl2831u_power_ctrl(struct dvb_usb_device *d, int onoff)
 
 	return ret;
 err:
-	dev_dbg(&d->udev->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&d->intf->dev, "failed=%d\n", ret);
 	return ret;
 }
 
@@ -1286,7 +1280,7 @@ static int rtl2832u_power_ctrl(struct dvb_usb_device *d, int onoff)
 {
 	int ret;
 
-	dev_dbg(&d->udev->dev, "%s: onoff=%d\n", __func__, onoff);
+	dev_dbg(&d->intf->dev, "onoff=%d\n", onoff);
 
 	if (onoff) {
 		/* GPIO3=1, GPIO4=0 */
@@ -1336,7 +1330,7 @@ static int rtl2832u_power_ctrl(struct dvb_usb_device *d, int onoff)
 
 	return ret;
 err:
-	dev_dbg(&d->udev->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&d->intf->dev, "failed=%d\n", ret);
 	return ret;
 }
 
@@ -1348,7 +1342,7 @@ static int rtl2832u_frontend_ctrl(struct dvb_frontend *fe, int onoff)
 	int ret;
 	u8 val;
 
-	dev_dbg(&d->udev->dev, "%s: fe=%d onoff=%d\n", __func__, fe->id, onoff);
+	dev_dbg(&d->intf->dev, "fe=%d onoff=%d\n", fe->id, onoff);
 
 	/* control internal demod ADC */
 	if (fe->id == 0 && onoff)
@@ -1369,7 +1363,7 @@ static int rtl2832u_frontend_ctrl(struct dvb_frontend *fe, int onoff)
 
 	return 0;
 err:
-	dev_dbg(&d->udev->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&d->intf->dev, "failed=%d\n", ret);
 	return ret;
 }
 
@@ -1442,7 +1436,7 @@ static int rtl2831u_rc_query(struct dvb_usb_device *d)
 
 	return ret;
 err:
-	dev_dbg(&d->udev->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&d->intf->dev, "failed=%d\n", ret);
 	return ret;
 }
 
@@ -1541,7 +1535,7 @@ static int rtl2832u_rc_query(struct dvb_usb_device *d)
 exit:
 	return ret;
 err:
-	dev_dbg(&d->udev->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&d->intf->dev, "failed=%d\n", ret);
 	return ret;
 }
 
-- 
http://palosaari.fi/

