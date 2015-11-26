Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qg0-f47.google.com ([209.85.192.47]:34502 "EHLO
	mail-qg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753500AbbKZVAc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Nov 2015 16:00:32 -0500
Received: by qgeb1 with SMTP id b1so61775928qge.1
        for <linux-media@vger.kernel.org>; Thu, 26 Nov 2015 13:00:31 -0800 (PST)
Date: Thu, 26 Nov 2015 18:00:28 -0300
From: Nicolas Sugino <nsugino@3way.com.ar>
To: mchehab@osg.samsung.com
Cc: stefanr@s5r6.in-berlin.de, nsugino@3way.com.ar,
	luis@debethencourt.com, treitmayr@devbase.at,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] dib8000: Add support for Mygica/Geniatech S2870
Message-ID: <20151126210024.GA26745@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

MyGica/Geniatech S2870 is very similar to the S870 but with dual tuner. The card is recognised as Geniatech STK8096-PVR.

Signed-off-by: Nicolas Sugino <nsugino@3way.com.ar>
---
 drivers/media/dvb-core/dvb-usb-ids.h        |  1 +
 drivers/media/usb/dvb-usb/dib0700_devices.c | 77 ++++++++++++++++++++++++++++-
 2 files changed, 76 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb-core/dvb-usb-ids.h b/drivers/media/dvb-core/dvb-usb-ids.h
index 0a46580..29eae14 100644
--- a/drivers/media/dvb-core/dvb-usb-ids.h
+++ b/drivers/media/dvb-core/dvb-usb-ids.h
@@ -118,6 +118,7 @@
 #define USB_PID_DIBCOM_STK807XP				0x1f90
 #define USB_PID_DIBCOM_STK807XPVR			0x1f98
 #define USB_PID_DIBCOM_STK8096GP                        0x1fa0
+#define USB_PID_DIBCOM_STK8096PVR                       0x1faa
 #define USB_PID_DIBCOM_NIM8096MD                        0x1fa8
 #define USB_PID_DIBCOM_TFE8096P				0x1f9C
 #define USB_PID_DIBCOM_ANCHOR_2135_COLD			0x2131
diff --git a/drivers/media/usb/dvb-usb/dib0700_devices.c b/drivers/media/usb/dvb-usb/dib0700_devices.c
index 7ed4964..9e4e75e 100644
--- a/drivers/media/usb/dvb-usb/dib0700_devices.c
+++ b/drivers/media/usb/dvb-usb/dib0700_devices.c
@@ -1736,8 +1736,13 @@ static int dib809x_tuner_attach(struct dvb_usb_adapter *adap)
 	struct dib0700_adapter_state *st = adap->priv;
 	struct i2c_adapter *tun_i2c = st->dib8000_ops.get_i2c_master(adap->fe_adap[0].fe, DIBX000_I2C_INTERFACE_TUNER, 1);
 
-	if (dvb_attach(dib0090_register, adap->fe_adap[0].fe, tun_i2c, &dib809x_dib0090_config) == NULL)
-		return -ENODEV;
+	if(adap->id == 0) {
+		if (dvb_attach(dib0090_register, adap->fe_adap[0].fe, tun_i2c, &dib809x_dib0090_config) == NULL)
+			return -ENODEV;
+	} else {
+		if (dvb_attach(dib0090_register, adap->fe_adap[0].fe, tun_i2c, &dib809x_dib0090_config) == NULL)
+			return -ENODEV;
+	}
 
 	st->set_param_save = adap->fe_adap[0].fe->ops.tuner_ops.set_params;
 	adap->fe_adap[0].fe->ops.tuner_ops.set_params = dib8096_set_param_override;
@@ -1773,6 +1778,20 @@ static int stk809x_frontend_attach(struct dvb_usb_adapter *adap)
 	return adap->fe_adap[0].fe == NULL ?  -ENODEV : 0;
 }
 
+static int stk809x_frontend1_attach(struct dvb_usb_adapter *adap)
+{
+	struct dib0700_adapter_state *state = adap->priv;
+
+	if (!dvb_attach(dib8000_attach, &state->dib8000_ops))
+		return -ENODEV;
+
+	state->dib8000_ops.i2c_enumeration(&adap->dev->i2c_adap, 1, 0x10, 0x82, 0);
+
+	adap->fe_adap[0].fe = state->dib8000_ops.init(&adap->dev->i2c_adap, 0x82, &dib809x_dib8000_config[1]);
+
+	return adap->fe_adap[0].fe == NULL ?  -ENODEV : 0;
+}
+
 static int nim8096md_tuner_attach(struct dvb_usb_adapter *adap)
 {
 	struct dib0700_adapter_state *st = adap->priv;
@@ -3794,6 +3813,7 @@ struct usb_device_id dib0700_usb_id_table[] = {
 /* 80 */{ USB_DEVICE(USB_VID_ELGATO,	USB_PID_ELGATO_EYETV_DTT_2) },
 	{ USB_DEVICE(USB_VID_PCTV,      USB_PID_PCTV_2002E) },
 	{ USB_DEVICE(USB_VID_PCTV,      USB_PID_PCTV_2002E_SE) },
+	{ USB_DEVICE(USB_VID_PCTV,      USB_PID_DIBCOM_STK8096PVR) },
 	{ 0 }		/* Terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, dib0700_usb_id_table);
@@ -4959,6 +4979,59 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 					    RC_BIT_NEC,
 			.change_protocol  = dib0700_change_protocol,
 		},
+	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
+		.num_adapters = 2,
+		.adapter = {
+			{
+				.num_frontends = 1,
+				.fe = {{
+					.caps  = DVB_USB_ADAP_HAS_PID_FILTER |
+						DVB_USB_ADAP_PID_FILTER_CAN_BE_TURNED_OFF,
+					.pid_filter_count = 32,
+					.pid_filter = stk80xx_pid_filter,
+					.pid_filter_ctrl = stk80xx_pid_filter_ctrl,
+					.frontend_attach  = stk809x_frontend_attach,
+					.tuner_attach     = dib809x_tuner_attach,
+
+					DIB0700_DEFAULT_STREAMING_CONFIG(0x02),
+				}},
+				.size_of_priv =
+					sizeof(struct dib0700_adapter_state),
+			}, {
+				.num_frontends = 1,
+				.fe = {{
+					.caps  = DVB_USB_ADAP_HAS_PID_FILTER |
+						DVB_USB_ADAP_PID_FILTER_CAN_BE_TURNED_OFF,
+					.pid_filter_count = 32,
+					.pid_filter = stk80xx_pid_filter,
+					.pid_filter_ctrl = stk80xx_pid_filter_ctrl,
+					.frontend_attach  = stk809x_frontend1_attach,
+					.tuner_attach     = dib809x_tuner_attach,
+
+					DIB0700_DEFAULT_STREAMING_CONFIG(0x03),
+				}},
+				.size_of_priv =
+					sizeof(struct dib0700_adapter_state),
+			},
+		},
+		.num_device_descs = 1,
+		.devices = {
+			{   "DiBcom STK8096-PVR reference design",
+				{ &dib0700_usb_id_table[83], NULL },
+				{ NULL },
+			},
+		},
+
+		.rc.core = {
+			.rc_interval      = DEFAULT_RC_INTERVAL,
+			.rc_codes         = RC_MAP_DIB0700_RC5_TABLE,
+			.module_name  = "dib0700",
+			.rc_query         = dib0700_rc_query_old_firmware,
+			.allowed_protos   = RC_BIT_RC5 |
+				RC_BIT_RC6_MCE |
+				RC_BIT_NEC,
+			.change_protocol  = dib0700_change_protocol,
+		},
 	},
 };
 
-- 
2.1.4

