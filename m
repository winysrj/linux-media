Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:57473 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752555AbbEMVvf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 May 2015 17:51:35 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	James Harper <james.harper@ejbdigital.com.au>,
	Luis de Bethencourt <luis@debethencourt.com>,
	=?UTF-8?q?David=20H=C3=A4rdeman?= <david@hardeman.nu>,
	Thomas Reitmayr <treitmayr@devbase.at>
Subject: [PATCH] [media] dib0700: avoid the risk of forgetting to add the adapter's size
Date: Wed, 13 May 2015 18:51:19 -0300
Message-Id: <825deb5196fb69fb4f366f50cd4e1c1f9b0fd0cd.1431553863.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

For every frontend entry, we need to add the adapter's size. There
are already two patches fixing it. So, it doesn't seem trivial to
keep it there at the right place.

Also, currently, the indentation is wrong on all places.

So, it seems that keeping it right is not too trivial.

Better to use a macro that would do it for us, at least while
this is not converted to dvb-usb-v2.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/usb/dvb-usb/dib0700_devices.c b/drivers/media/usb/dvb-usb/dib0700_devices.c
index e87ce835dcbd..5a3dbb8c7658 100644
--- a/drivers/media/usb/dvb-usb/dib0700_devices.c
+++ b/drivers/media/usb/dvb-usb/dib0700_devices.c
@@ -3821,6 +3821,10 @@ MODULE_DEVICE_TABLE(usb, dib0700_usb_id_table);
 		} \
 	}
 
+#define DIB0700_NUM_FRONTENDS(n) \
+	.num_frontends = n, \
+	.size_of_priv     = sizeof(struct dib0700_adapter_state)
+
 struct dvb_usb_device_properties dib0700_devices[] = {
 	{
 		DIB0700_DEFAULT_DEVICE_PROPERTIES,
@@ -3828,7 +3832,7 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 		.num_adapters = 1,
 		.adapter = {
 			{
-			.num_frontends = 1,
+			DIB0700_NUM_FRONTENDS(1),
 			.fe = {{
 				.caps = DVB_USB_ADAP_HAS_PID_FILTER | DVB_USB_ADAP_PID_FILTER_CAN_BE_TURNED_OFF,
 				.pid_filter_count = 32,
@@ -3839,7 +3843,6 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 
 				DIB0700_DEFAULT_STREAMING_CONFIG(0x02),
 			}},
-				.size_of_priv     = sizeof(struct dib0700_adapter_state),
 			},
 		},
 
@@ -3893,7 +3896,7 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 		.num_adapters = 2,
 		.adapter = {
 			{
-			.num_frontends = 1,
+			DIB0700_NUM_FRONTENDS(1),
 			.fe = {{
 				.frontend_attach  = bristol_frontend_attach,
 				.tuner_attach     = bristol_tuner_attach,
@@ -3901,7 +3904,7 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 				DIB0700_DEFAULT_STREAMING_CONFIG(0x02),
 			}},
 			}, {
-			.num_frontends = 1,
+			DIB0700_NUM_FRONTENDS(1),
 			.fe = {{
 				.frontend_attach  = bristol_frontend_attach,
 				.tuner_attach     = bristol_tuner_attach,
@@ -3933,7 +3936,7 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 		.num_adapters = 2,
 		.adapter = {
 			{
-			.num_frontends = 1,
+			DIB0700_NUM_FRONTENDS(1),
 			.fe = {{
 				.caps = DVB_USB_ADAP_HAS_PID_FILTER | DVB_USB_ADAP_PID_FILTER_CAN_BE_TURNED_OFF,
 				.pid_filter_count = 32,
@@ -3944,10 +3947,8 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 
 				DIB0700_DEFAULT_STREAMING_CONFIG(0x02),
 			}},
-				.size_of_priv = sizeof(struct
-						dib0700_adapter_state),
 			}, {
-			.num_frontends = 1,
+			DIB0700_NUM_FRONTENDS(1),
 			.fe = {{
 				.caps = DVB_USB_ADAP_HAS_PID_FILTER | DVB_USB_ADAP_PID_FILTER_CAN_BE_TURNED_OFF,
 				.pid_filter_count = 32,
@@ -3958,8 +3959,6 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 
 				DIB0700_DEFAULT_STREAMING_CONFIG(0x03),
 			}},
-				.size_of_priv = sizeof(struct
-						dib0700_adapter_state),
 			}
 		},
 
@@ -4002,7 +4001,7 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 		.num_adapters = 1,
 		.adapter = {
 			{
-			.num_frontends = 1,
+			DIB0700_NUM_FRONTENDS(1),
 			.fe = {{
 				.caps = DVB_USB_ADAP_HAS_PID_FILTER | DVB_USB_ADAP_PID_FILTER_CAN_BE_TURNED_OFF,
 				.pid_filter_count = 32,
@@ -4013,8 +4012,6 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 
 				DIB0700_DEFAULT_STREAMING_CONFIG(0x02),
 			}},
-				.size_of_priv = sizeof(struct
-						dib0700_adapter_state),
 			},
 		},
 
@@ -4049,7 +4046,7 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 		.num_adapters = 1,
 		.adapter = {
 			{
-			.num_frontends = 1,
+			DIB0700_NUM_FRONTENDS(1),
 			.fe = {{
 				.caps = DVB_USB_ADAP_HAS_PID_FILTER | DVB_USB_ADAP_PID_FILTER_CAN_BE_TURNED_OFF,
 				.pid_filter_count = 32,
@@ -4060,7 +4057,6 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 
 				DIB0700_DEFAULT_STREAMING_CONFIG(0x02),
 			}},
-				.size_of_priv     = sizeof(struct dib0700_adapter_state),
 			},
 		},
 
@@ -4131,7 +4127,7 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 		.num_adapters = 1,
 		.adapter = {
 			{
-			.num_frontends = 1,
+			DIB0700_NUM_FRONTENDS(1),
 			.fe = {{
 				.caps = DVB_USB_ADAP_HAS_PID_FILTER | DVB_USB_ADAP_PID_FILTER_CAN_BE_TURNED_OFF,
 				.pid_filter_count = 32,
@@ -4142,7 +4138,6 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 
 				DIB0700_DEFAULT_STREAMING_CONFIG(0x02),
 			}},
-				.size_of_priv     = sizeof(struct dib0700_adapter_state),
 			},
 		},
 
@@ -4177,7 +4172,7 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 		.num_adapters = 2,
 		.adapter = {
 			{
-			.num_frontends = 1,
+			DIB0700_NUM_FRONTENDS(1),
 			.fe = {{
 				.caps = DVB_USB_ADAP_HAS_PID_FILTER | DVB_USB_ADAP_PID_FILTER_CAN_BE_TURNED_OFF,
 				.pid_filter_count = 32,
@@ -4188,9 +4183,8 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 
 				DIB0700_DEFAULT_STREAMING_CONFIG(0x02),
 			}},
-				.size_of_priv     = sizeof(struct dib0700_adapter_state),
 			}, {
-			.num_frontends = 1,
+			DIB0700_NUM_FRONTENDS(1),
 			.fe = {{
 				.caps = DVB_USB_ADAP_HAS_PID_FILTER | DVB_USB_ADAP_PID_FILTER_CAN_BE_TURNED_OFF,
 				.pid_filter_count = 32,
@@ -4201,7 +4195,6 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 
 				DIB0700_DEFAULT_STREAMING_CONFIG(0x03),
 			}},
-				.size_of_priv     = sizeof(struct dib0700_adapter_state),
 			}
 		},
 
@@ -4236,7 +4229,7 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 		.num_adapters = 2,
 		.adapter = {
 			{
-			.num_frontends = 1,
+			DIB0700_NUM_FRONTENDS(1),
 			.fe = {{
 				.caps = DVB_USB_ADAP_HAS_PID_FILTER | DVB_USB_ADAP_PID_FILTER_CAN_BE_TURNED_OFF,
 				.pid_filter_count = 32,
@@ -4247,9 +4240,8 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 
 				DIB0700_DEFAULT_STREAMING_CONFIG(0x02),
 			}},
-				.size_of_priv     = sizeof(struct dib0700_adapter_state),
 			}, {
-			.num_frontends = 1,
+			DIB0700_NUM_FRONTENDS(1),
 			.fe = {{
 				.caps = DVB_USB_ADAP_HAS_PID_FILTER | DVB_USB_ADAP_PID_FILTER_CAN_BE_TURNED_OFF,
 				.pid_filter_count = 32,
@@ -4260,7 +4252,6 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 
 				DIB0700_DEFAULT_STREAMING_CONFIG(0x03),
 			}},
-				.size_of_priv     = sizeof(struct dib0700_adapter_state),
 			}
 		},
 
@@ -4304,7 +4295,7 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 		.num_adapters = 2,
 		.adapter = {
 			{
-			.num_frontends = 1,
+			DIB0700_NUM_FRONTENDS(1),
 			.fe = {{
 				.caps = DVB_USB_ADAP_HAS_PID_FILTER | DVB_USB_ADAP_PID_FILTER_CAN_BE_TURNED_OFF,
 				.pid_filter_count = 32,
@@ -4315,9 +4306,8 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 
 				DIB0700_DEFAULT_STREAMING_CONFIG(0x02),
 			}},
-				.size_of_priv     = sizeof(struct dib0700_adapter_state),
 			}, {
-			.num_frontends = 1,
+			DIB0700_NUM_FRONTENDS(1),
 			.fe = {{
 				.caps = DVB_USB_ADAP_HAS_PID_FILTER | DVB_USB_ADAP_PID_FILTER_CAN_BE_TURNED_OFF,
 				.pid_filter_count = 32,
@@ -4328,7 +4318,6 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 
 				DIB0700_DEFAULT_STREAMING_CONFIG(0x03),
 			}},
-				.size_of_priv     = sizeof(struct dib0700_adapter_state),
 			}
 		},
 
@@ -4355,7 +4344,7 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 		.num_adapters = 1,
 		.adapter = {
 			{
-			.num_frontends = 1,
+			DIB0700_NUM_FRONTENDS(1),
 			.fe = {{
 				.caps = DVB_USB_ADAP_HAS_PID_FILTER | DVB_USB_ADAP_PID_FILTER_CAN_BE_TURNED_OFF,
 				.pid_filter_count = 32,
@@ -4366,8 +4355,6 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 
 				DIB0700_DEFAULT_STREAMING_CONFIG(0x02),
 			}},
-				.size_of_priv = sizeof(struct
-						dib0700_adapter_state),
 			},
 		},
 
@@ -4425,15 +4412,13 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 		.num_adapters = 1,
 		.adapter = {
 			{
-			.num_frontends = 1,
+			DIB0700_NUM_FRONTENDS(1),
 			.fe = {{
 				.frontend_attach  = s5h1411_frontend_attach,
 				.tuner_attach     = xc5000_tuner_attach,
 
 				DIB0700_DEFAULT_STREAMING_CONFIG(0x02),
 			}},
-				.size_of_priv = sizeof(struct
-						dib0700_adapter_state),
 			},
 		},
 
@@ -4463,15 +4448,13 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 		.num_adapters = 1,
 		.adapter = {
 			{
-			.num_frontends = 1,
+			DIB0700_NUM_FRONTENDS(1),
 			.fe = {{
 				.frontend_attach  = lgdt3305_frontend_attach,
 				.tuner_attach     = mxl5007t_tuner_attach,
 
 				DIB0700_DEFAULT_STREAMING_CONFIG(0x02),
 			}},
-				.size_of_priv = sizeof(struct
-						dib0700_adapter_state),
 			},
 		},
 
@@ -4491,7 +4474,7 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 		.num_adapters = 1,
 		.adapter = {
 			{
-			.num_frontends = 1,
+			DIB0700_NUM_FRONTENDS(1),
 			.fe = {{
 				.caps = DVB_USB_ADAP_HAS_PID_FILTER | DVB_USB_ADAP_PID_FILTER_CAN_BE_TURNED_OFF,
 				.pid_filter_count = 32,
@@ -4502,8 +4485,6 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 
 				DIB0700_DEFAULT_STREAMING_CONFIG(0x02),
 			}},
-				.size_of_priv =
-					sizeof(struct dib0700_adapter_state),
 			},
 		},
 
@@ -4543,7 +4524,7 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 		.num_adapters = 1,
 		.adapter = {
 			{
-			.num_frontends = 1,
+			DIB0700_NUM_FRONTENDS(1),
 			.fe = {{
 				.caps  = DVB_USB_ADAP_HAS_PID_FILTER | DVB_USB_ADAP_PID_FILTER_CAN_BE_TURNED_OFF,
 				.pid_filter_count = 32,
@@ -4554,8 +4535,6 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 
 				DIB0700_DEFAULT_STREAMING_CONFIG(0x02),
 			}},
-				.size_of_priv =
-					sizeof(struct dib0700_adapter_state),
 			},
 		},
 
@@ -4589,7 +4568,7 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 		.num_adapters = 2,
 		.adapter = {
 			{
-			.num_frontends = 1,
+			DIB0700_NUM_FRONTENDS(1),
 			.fe = {{
 				.caps  = DVB_USB_ADAP_HAS_PID_FILTER | DVB_USB_ADAP_PID_FILTER_CAN_BE_TURNED_OFF,
 				.pid_filter_count = 32,
@@ -4600,11 +4579,9 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 
 				DIB0700_DEFAULT_STREAMING_CONFIG(0x02),
 			}},
-				.size_of_priv =
-					sizeof(struct dib0700_adapter_state),
 			},
 			{
-			.num_frontends = 1,
+			DIB0700_NUM_FRONTENDS(1),
 			.fe = {{
 				.caps  = DVB_USB_ADAP_HAS_PID_FILTER | DVB_USB_ADAP_PID_FILTER_CAN_BE_TURNED_OFF,
 				.pid_filter_count = 32,
@@ -4615,8 +4592,6 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 
 				DIB0700_DEFAULT_STREAMING_CONFIG(0x03),
 			}},
-				.size_of_priv =
-					sizeof(struct dib0700_adapter_state),
 			},
 		},
 
@@ -4642,7 +4617,7 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 		.num_adapters = 1,
 		.adapter = {
 			{
-			.num_frontends = 1,
+			DIB0700_NUM_FRONTENDS(1),
 			.fe = {{
 				.caps  = DVB_USB_ADAP_HAS_PID_FILTER |
 					DVB_USB_ADAP_PID_FILTER_CAN_BE_TURNED_OFF,
@@ -4654,8 +4629,6 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 
 				DIB0700_DEFAULT_STREAMING_CONFIG(0x02),
 			}},
-				.size_of_priv =
-					sizeof(struct dib0700_adapter_state),
 			},
 		},
 
@@ -4681,7 +4654,7 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 		.num_adapters = 1,
 		.adapter = {
 			{
-			.num_frontends = 1,
+			DIB0700_NUM_FRONTENDS(1),
 			.fe = {{
 				.caps  = DVB_USB_ADAP_HAS_PID_FILTER |
 					DVB_USB_ADAP_PID_FILTER_CAN_BE_TURNED_OFF,
@@ -4693,8 +4666,6 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 
 				DIB0700_DEFAULT_STREAMING_CONFIG(0x02),
 			}},
-				.size_of_priv =
-					sizeof(struct dib0700_adapter_state),
 			},
 		},
 
@@ -4720,7 +4691,7 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 		.num_adapters = 1,
 		.adapter = {
 			{
-			.num_frontends = 1,
+			DIB0700_NUM_FRONTENDS(1),
 			.fe = {{
 				.caps  = DVB_USB_ADAP_HAS_PID_FILTER |
 					DVB_USB_ADAP_PID_FILTER_CAN_BE_TURNED_OFF,
@@ -4732,8 +4703,6 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 
 				DIB0700_DEFAULT_STREAMING_CONFIG(0x02),
 			}},
-				.size_of_priv =
-					sizeof(struct dib0700_adapter_state),
 			},
 		},
 
@@ -4759,7 +4728,7 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 		.num_adapters = 1,
 		.adapter = {
 			{
-			.num_frontends = 1,
+			DIB0700_NUM_FRONTENDS(1),
 			.fe = {{
 				.caps  = DVB_USB_ADAP_HAS_PID_FILTER |
 					DVB_USB_ADAP_PID_FILTER_CAN_BE_TURNED_OFF,
@@ -4771,8 +4740,6 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 
 				DIB0700_DEFAULT_STREAMING_CONFIG(0x02),
 			}},
-				.size_of_priv =
-					sizeof(struct dib0700_adapter_state),
 			},
 		},
 
@@ -4798,7 +4765,7 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 		.num_adapters = 1,
 		.adapter = {
 			{
-			.num_frontends = 1,
+			DIB0700_NUM_FRONTENDS(1),
 			.fe = {{
 				.caps  = DVB_USB_ADAP_HAS_PID_FILTER |
 					DVB_USB_ADAP_PID_FILTER_CAN_BE_TURNED_OFF,
@@ -4810,8 +4777,6 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 
 				DIB0700_DEFAULT_STREAMING_CONFIG(0x02),
 			}},
-				.size_of_priv =
-					sizeof(struct dib0700_adapter_state),
 			},
 		},
 
@@ -4837,7 +4802,7 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 		.num_adapters = 2,
 		.adapter = {
 			{
-			.num_frontends = 1,
+			DIB0700_NUM_FRONTENDS(1),
 			.fe = {{
 				.caps  = DVB_USB_ADAP_HAS_PID_FILTER |
 					DVB_USB_ADAP_PID_FILTER_CAN_BE_TURNED_OFF,
@@ -4849,11 +4814,9 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 
 				DIB0700_DEFAULT_STREAMING_CONFIG(0x03),
 			}},
-				.size_of_priv =
-					sizeof(struct dib0700_adapter_state),
 			},
 			{
-			.num_frontends = 1,
+			DIB0700_NUM_FRONTENDS(1),
 			.fe = {{
 				.caps  = DVB_USB_ADAP_HAS_PID_FILTER |
 					DVB_USB_ADAP_PID_FILTER_CAN_BE_TURNED_OFF,
@@ -4865,8 +4828,6 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 
 				DIB0700_DEFAULT_STREAMING_CONFIG(0x02),
 			}},
-				.size_of_priv =
-					sizeof(struct dib0700_adapter_state),
 			},
 		},
 
@@ -4892,15 +4853,13 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 		.num_adapters = 1,
 		.adapter = {
 			{
-			.num_frontends = 1,
+			DIB0700_NUM_FRONTENDS(1),
 			.fe = {{
 				.frontend_attach  = pctv340e_frontend_attach,
 				.tuner_attach     = xc4000_tuner_attach,
 
 				DIB0700_DEFAULT_STREAMING_CONFIG(0x02),
 			}},
-				.size_of_priv = sizeof(struct
-						dib0700_adapter_state),
 			},
 		},
 
@@ -4929,7 +4888,7 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 		.num_adapters = 1,
 		.adapter = {
 			{
-				.num_frontends = 1,
+				DIB0700_NUM_FRONTENDS(1),
 				.fe = {{
 					.caps  = DVB_USB_ADAP_HAS_PID_FILTER |
 						DVB_USB_ADAP_PID_FILTER_CAN_BE_TURNED_OFF,
@@ -4941,9 +4900,6 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 
 					DIB0700_DEFAULT_STREAMING_CONFIG(0x03),
 				} },
-
-				.size_of_priv =
-					sizeof(struct dib0700_adapter_state),
 			},
 		},
 
@@ -4969,7 +4925,7 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 		.num_adapters = 1,
 		.adapter = {
 			{
-				.num_frontends = 1,
+				DIB0700_NUM_FRONTENDS(1),
 				.fe = {{
 					.caps  = DVB_USB_ADAP_HAS_PID_FILTER |
 						DVB_USB_ADAP_PID_FILTER_CAN_BE_TURNED_OFF,
@@ -4982,9 +4938,6 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 					DIB0700_DEFAULT_STREAMING_CONFIG(0x02),
 
 				} },
-
-				.size_of_priv =
-					sizeof(struct dib0700_adapter_state),
 			},
 		},
 
-- 
2.1.0

