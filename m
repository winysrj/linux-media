Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:49303 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S936016AbcLOMuK (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Dec 2016 07:50:10 -0500
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org, linux-input@vger.kernel.org
Cc: Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        =?UTF-8?q?Bruno=20Pr=C3=A9mont?= <bonbons@linux-vserver.org>
Subject: [PATCH v6 05/18] [media] rc: raw IR drivers cannot handle cec, unknown or other
Date: Thu, 15 Dec 2016 12:50:09 +0000
Message-Id: <7dedf7c731f2e027da6a8267ed47c61f14d46359.1481805635.git.sean@mess.org>
In-Reply-To: <cover.1481805635.git.sean@mess.org>
References: <cover.1481805635.git.sean@mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

unknown and other are for IR protocols for which we have no decoder,
so the raw IR drivers have no chance of generating them. cec is not
an IR protocol.

Signed-off-by: Sean Young <sean@mess.org>
Cc: Jiri Kosina <jikos@kernel.org>
Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc: Bruno Prémont <bonbons@linux-vserver.org>
---
 drivers/hid/hid-picolcd_cir.c              |  2 +-
 drivers/media/common/siano/smsir.c         |  2 +-
 drivers/media/pci/cx23885/cx23885-input.c  | 14 +++++++-------
 drivers/media/rc/ene_ir.c                  |  2 +-
 drivers/media/rc/fintek-cir.c              |  2 +-
 drivers/media/rc/gpio-ir-recv.c            |  2 +-
 drivers/media/rc/igorplugusb.c             |  4 ++--
 drivers/media/rc/iguanair.c                |  2 +-
 drivers/media/rc/ir-hix5hd2.c              |  2 +-
 drivers/media/rc/ite-cir.c                 |  2 +-
 drivers/media/rc/mceusb.c                  |  2 +-
 drivers/media/rc/meson-ir.c                |  2 +-
 drivers/media/rc/nuvoton-cir.c             |  2 +-
 drivers/media/rc/rc-loopback.c             |  2 +-
 drivers/media/rc/redrat3.c                 |  2 +-
 drivers/media/rc/serial_ir.c               |  2 +-
 drivers/media/rc/st_rc.c                   |  2 +-
 drivers/media/rc/streamzap.c               |  2 +-
 drivers/media/rc/sunxi-cir.c               |  2 +-
 drivers/media/rc/ttusbir.c                 |  2 +-
 drivers/media/rc/winbond-cir.c             |  2 +-
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c    |  2 +-
 drivers/media/usb/dvb-usb/technisat-usb2.c |  2 +-
 include/media/rc-map.h                     | 10 ++++++++++
 24 files changed, 40 insertions(+), 30 deletions(-)

diff --git a/drivers/hid/hid-picolcd_cir.c b/drivers/hid/hid-picolcd_cir.c
index 9628651..90add97 100644
--- a/drivers/hid/hid-picolcd_cir.c
+++ b/drivers/hid/hid-picolcd_cir.c
@@ -114,7 +114,7 @@ int picolcd_init_cir(struct picolcd_data *data, struct hid_report *report)
 
 	rdev->priv             = data;
 	rdev->driver_type      = RC_DRIVER_IR_RAW;
-	rdev->allowed_protocols = RC_BIT_ALL;
+	rdev->allowed_protocols = RC_BIT_ALL_IR_DECODER;
 	rdev->open             = picolcd_cir_open;
 	rdev->close            = picolcd_cir_close;
 	rdev->input_name       = data->hdev->name;
diff --git a/drivers/media/common/siano/smsir.c b/drivers/media/common/siano/smsir.c
index 41f2a39..480d8bf 100644
--- a/drivers/media/common/siano/smsir.c
+++ b/drivers/media/common/siano/smsir.c
@@ -87,7 +87,7 @@ int sms_ir_init(struct smscore_device_t *coredev)
 
 	dev->priv = coredev;
 	dev->driver_type = RC_DRIVER_IR_RAW;
-	dev->allowed_protocols = RC_BIT_ALL;
+	dev->allowed_protocols = RC_BIT_ALL_IR_DECODER;
 	dev->map_name = sms_get_board(board_id)->rc_codes;
 	dev->driver_name = MODULE_NAME;
 
diff --git a/drivers/media/pci/cx23885/cx23885-input.c b/drivers/media/pci/cx23885/cx23885-input.c
index 1f092fe..2d4e703 100644
--- a/drivers/media/pci/cx23885/cx23885-input.c
+++ b/drivers/media/pci/cx23885/cx23885-input.c
@@ -286,28 +286,28 @@ int cx23885_input_init(struct cx23885_dev *dev)
 	case CX23885_BOARD_HAUPPAUGE_HVR1250:
 		/* Integrated CX2388[58] IR controller */
 		driver_type = RC_DRIVER_IR_RAW;
-		allowed_protos = RC_BIT_ALL;
+		allowed_protos = RC_BIT_ALL_IR_DECODER;
 		/* The grey Hauppauge RC-5 remote */
 		rc_map = RC_MAP_HAUPPAUGE;
 		break;
 	case CX23885_BOARD_TERRATEC_CINERGY_T_PCIE_DUAL:
 		/* Integrated CX23885 IR controller */
 		driver_type = RC_DRIVER_IR_RAW;
-		allowed_protos = RC_BIT_ALL;
+		allowed_protos = RC_BIT_ALL_IR_DECODER;
 		/* The grey Terratec remote with orange buttons */
 		rc_map = RC_MAP_NEC_TERRATEC_CINERGY_XS;
 		break;
 	case CX23885_BOARD_TEVII_S470:
 		/* Integrated CX23885 IR controller */
 		driver_type = RC_DRIVER_IR_RAW;
-		allowed_protos = RC_BIT_ALL;
+		allowed_protos = RC_BIT_ALL_IR_DECODER;
 		/* A guess at the remote */
 		rc_map = RC_MAP_TEVII_NEC;
 		break;
 	case CX23885_BOARD_MYGICA_X8507:
 		/* Integrated CX23885 IR controller */
 		driver_type = RC_DRIVER_IR_RAW;
-		allowed_protos = RC_BIT_ALL;
+		allowed_protos = RC_BIT_ALL_IR_DECODER;
 		/* A guess at the remote */
 		rc_map = RC_MAP_TOTAL_MEDIA_IN_HAND_02;
 		break;
@@ -315,7 +315,7 @@ int cx23885_input_init(struct cx23885_dev *dev)
 	case CX23885_BOARD_TBS_6981:
 		/* Integrated CX23885 IR controller */
 		driver_type = RC_DRIVER_IR_RAW;
-		allowed_protos = RC_BIT_ALL;
+		allowed_protos = RC_BIT_ALL_IR_DECODER;
 		/* A guess at the remote */
 		rc_map = RC_MAP_TBS_NEC;
 		break;
@@ -327,13 +327,13 @@ int cx23885_input_init(struct cx23885_dev *dev)
 	case CX23885_BOARD_DVBSKY_T982:
 		/* Integrated CX23885 IR controller */
 		driver_type = RC_DRIVER_IR_RAW;
-		allowed_protos = RC_BIT_ALL;
+		allowed_protos = RC_BIT_ALL_IR_DECODER;
 		rc_map = RC_MAP_DVBSKY;
 		break;
 	case CX23885_BOARD_TT_CT2_4500_CI:
 		/* Integrated CX23885 IR controller */
 		driver_type = RC_DRIVER_IR_RAW;
-		allowed_protos = RC_BIT_ALL;
+		allowed_protos = RC_BIT_ALL_IR_DECODER;
 		rc_map = RC_MAP_TT_1500;
 		break;
 	default:
diff --git a/drivers/media/rc/ene_ir.c b/drivers/media/rc/ene_ir.c
index bd5512e..b7ce051 100644
--- a/drivers/media/rc/ene_ir.c
+++ b/drivers/media/rc/ene_ir.c
@@ -1059,7 +1059,7 @@ static int ene_probe(struct pnp_dev *pnp_dev, const struct pnp_device_id *id)
 		learning_mode_force = false;
 
 	rdev->driver_type = RC_DRIVER_IR_RAW;
-	rdev->allowed_protocols = RC_BIT_ALL;
+	rdev->allowed_protocols = RC_BIT_ALL_IR_DECODER;
 	rdev->priv = dev;
 	rdev->open = ene_open;
 	rdev->close = ene_close;
diff --git a/drivers/media/rc/fintek-cir.c b/drivers/media/rc/fintek-cir.c
index ecab69e..3de5e82 100644
--- a/drivers/media/rc/fintek-cir.c
+++ b/drivers/media/rc/fintek-cir.c
@@ -535,7 +535,7 @@ static int fintek_probe(struct pnp_dev *pdev, const struct pnp_device_id *dev_id
 	/* Set up the rc device */
 	rdev->priv = fintek;
 	rdev->driver_type = RC_DRIVER_IR_RAW;
-	rdev->allowed_protocols = RC_BIT_ALL;
+	rdev->allowed_protocols = RC_BIT_ALL_IR_DECODER;
 	rdev->open = fintek_open;
 	rdev->close = fintek_close;
 	rdev->input_name = FINTEK_DESCRIPTION;
diff --git a/drivers/media/rc/gpio-ir-recv.c b/drivers/media/rc/gpio-ir-recv.c
index 5b63b1f..0b5aec4 100644
--- a/drivers/media/rc/gpio-ir-recv.c
+++ b/drivers/media/rc/gpio-ir-recv.c
@@ -165,7 +165,7 @@ static int gpio_ir_recv_probe(struct platform_device *pdev)
 	if (pdata->allowed_protos)
 		rcdev->allowed_protocols = pdata->allowed_protos;
 	else
-		rcdev->allowed_protocols = RC_BIT_ALL;
+		rcdev->allowed_protocols = RC_BIT_ALL_IR_DECODER;
 	rcdev->map_name = pdata->map_name ?: RC_MAP_EMPTY;
 
 	gpio_dev->rcdev = rcdev;
diff --git a/drivers/media/rc/igorplugusb.c b/drivers/media/rc/igorplugusb.c
index 5cf983b..4c4827c 100644
--- a/drivers/media/rc/igorplugusb.c
+++ b/drivers/media/rc/igorplugusb.c
@@ -203,8 +203,8 @@ static int igorplugusb_probe(struct usb_interface *intf,
 	 * This device can only store 36 pulses + spaces, which is not enough
 	 * for the NEC protocol and many others.
 	 */
-	rc->allowed_protocols = RC_BIT_ALL & ~(RC_BIT_NEC | RC_BIT_NECX |
-			RC_BIT_NEC32 | RC_BIT_RC6_6A_20 |
+	rc->allowed_protocols = RC_BIT_ALL_IR_DECODER & ~(RC_BIT_NEC |
+			RC_BIT_NECX | RC_BIT_NEC32 | RC_BIT_RC6_6A_20 |
 			RC_BIT_RC6_6A_24 | RC_BIT_RC6_6A_32 | RC_BIT_RC6_MCE |
 			RC_BIT_SONY20 | RC_BIT_MCE_KBD | RC_BIT_SANYO);
 
diff --git a/drivers/media/rc/iguanair.c b/drivers/media/rc/iguanair.c
index 5f63454..e2fff1f 100644
--- a/drivers/media/rc/iguanair.c
+++ b/drivers/media/rc/iguanair.c
@@ -495,7 +495,7 @@ static int iguanair_probe(struct usb_interface *intf,
 	usb_to_input_id(ir->udev, &rc->input_id);
 	rc->dev.parent = &intf->dev;
 	rc->driver_type = RC_DRIVER_IR_RAW;
-	rc->allowed_protocols = RC_BIT_ALL;
+	rc->allowed_protocols = RC_BIT_ALL_IR_DECODER;
 	rc->priv = ir;
 	rc->open = iguanair_open;
 	rc->close = iguanair_close;
diff --git a/drivers/media/rc/ir-hix5hd2.c b/drivers/media/rc/ir-hix5hd2.c
index d26907e..d95056a 100644
--- a/drivers/media/rc/ir-hix5hd2.c
+++ b/drivers/media/rc/ir-hix5hd2.c
@@ -243,7 +243,7 @@ static int hix5hd2_ir_probe(struct platform_device *pdev)
 	priv->rate = clk_get_rate(priv->clock);
 
 	rdev->driver_type = RC_DRIVER_IR_RAW;
-	rdev->allowed_protocols = RC_BIT_ALL;
+	rdev->allowed_protocols = RC_BIT_ALL_IR_DECODER;
 	rdev->priv = priv;
 	rdev->open = hix5hd2_ir_open;
 	rdev->close = hix5hd2_ir_close;
diff --git a/drivers/media/rc/ite-cir.c b/drivers/media/rc/ite-cir.c
index 367b28b..01f6929 100644
--- a/drivers/media/rc/ite-cir.c
+++ b/drivers/media/rc/ite-cir.c
@@ -1562,7 +1562,7 @@ static int ite_probe(struct pnp_dev *pdev, const struct pnp_device_id
 	/* set up ir-core props */
 	rdev->priv = itdev;
 	rdev->driver_type = RC_DRIVER_IR_RAW;
-	rdev->allowed_protocols = RC_BIT_ALL;
+	rdev->allowed_protocols = RC_BIT_ALL_IR_DECODER;
 	rdev->open = ite_open;
 	rdev->close = ite_close;
 	rdev->s_idle = ite_s_idle;
diff --git a/drivers/media/rc/mceusb.c b/drivers/media/rc/mceusb.c
index 9bf6917..9fd8d44 100644
--- a/drivers/media/rc/mceusb.c
+++ b/drivers/media/rc/mceusb.c
@@ -1202,7 +1202,7 @@ static struct rc_dev *mceusb_init_rc_dev(struct mceusb_dev *ir)
 	rc->dev.parent = dev;
 	rc->priv = ir;
 	rc->driver_type = RC_DRIVER_IR_RAW;
-	rc->allowed_protocols = RC_BIT_ALL;
+	rc->allowed_protocols = RC_BIT_ALL_IR_DECODER;
 	rc->timeout = MS_TO_NS(100);
 	if (!ir->flags.no_tx) {
 		rc->s_tx_mask = mceusb_set_tx_mask;
diff --git a/drivers/media/rc/meson-ir.c b/drivers/media/rc/meson-ir.c
index 7eb3f4f..3e96e6f 100644
--- a/drivers/media/rc/meson-ir.c
+++ b/drivers/media/rc/meson-ir.c
@@ -145,7 +145,7 @@ static int meson_ir_probe(struct platform_device *pdev)
 	ir->rc->map_name = map_name ? map_name : RC_MAP_EMPTY;
 	ir->rc->dev.parent = dev;
 	ir->rc->driver_type = RC_DRIVER_IR_RAW;
-	ir->rc->allowed_protocols = RC_BIT_ALL;
+	ir->rc->allowed_protocols = RC_BIT_ALL_IR_DECODER;
 	ir->rc->rx_resolution = US_TO_NS(MESON_TRATE);
 	ir->rc->timeout = MS_TO_NS(200);
 	ir->rc->driver_name = DRIVER_NAME;
diff --git a/drivers/media/rc/nuvoton-cir.c b/drivers/media/rc/nuvoton-cir.c
index 4b78c89..9e04f41 100644
--- a/drivers/media/rc/nuvoton-cir.c
+++ b/drivers/media/rc/nuvoton-cir.c
@@ -1062,7 +1062,7 @@ static int nvt_probe(struct pnp_dev *pdev, const struct pnp_device_id *dev_id)
 	/* Set up the rc device */
 	rdev->priv = nvt;
 	rdev->driver_type = RC_DRIVER_IR_RAW;
-	rdev->allowed_protocols = RC_BIT_ALL;
+	rdev->allowed_protocols = RC_BIT_ALL_IR_DECODER;
 	rdev->open = nvt_open;
 	rdev->close = nvt_close;
 	rdev->tx_ir = nvt_tx_ir;
diff --git a/drivers/media/rc/rc-loopback.c b/drivers/media/rc/rc-loopback.c
index 63dace8..4bc3f01 100644
--- a/drivers/media/rc/rc-loopback.c
+++ b/drivers/media/rc/rc-loopback.c
@@ -195,7 +195,7 @@ static int __init loop_init(void)
 	rc->map_name		= RC_MAP_EMPTY;
 	rc->priv		= &loopdev;
 	rc->driver_type		= RC_DRIVER_IR_RAW;
-	rc->allowed_protocols	= RC_BIT_ALL;
+	rc->allowed_protocols	= RC_BIT_ALL_IR_DECODER;
 	rc->timeout		= 100 * 1000 * 1000; /* 100 ms */
 	rc->min_timeout		= 1;
 	rc->max_timeout		= UINT_MAX;
diff --git a/drivers/media/rc/redrat3.c b/drivers/media/rc/redrat3.c
index 2784f5d..ca878ac 100644
--- a/drivers/media/rc/redrat3.c
+++ b/drivers/media/rc/redrat3.c
@@ -961,7 +961,7 @@ static struct rc_dev *redrat3_init_rc_dev(struct redrat3_dev *rr3)
 	rc->dev.parent = dev;
 	rc->priv = rr3;
 	rc->driver_type = RC_DRIVER_IR_RAW;
-	rc->allowed_protocols = RC_BIT_ALL;
+	rc->allowed_protocols = RC_BIT_ALL_IR_DECODER;
 	rc->min_timeout = MS_TO_NS(RR3_RX_MIN_TIMEOUT);
 	rc->max_timeout = MS_TO_NS(RR3_RX_MAX_TIMEOUT);
 	rc->timeout = US_TO_NS(redrat3_get_timeout(rr3));
diff --git a/drivers/media/rc/serial_ir.c b/drivers/media/rc/serial_ir.c
index 436bd58..1faa1ae 100644
--- a/drivers/media/rc/serial_ir.c
+++ b/drivers/media/rc/serial_ir.c
@@ -778,7 +778,7 @@ static int __init serial_ir_init_module(void)
 	rcdev->close = serial_ir_close;
 	rcdev->dev.parent = &serial_ir.pdev->dev;
 	rcdev->driver_type = RC_DRIVER_IR_RAW;
-	rcdev->allowed_protocols = RC_BIT_ALL;
+	rcdev->allowed_protocols = RC_BIT_ALL_IR_DECODER;
 	rcdev->driver_name = KBUILD_MODNAME;
 	rcdev->map_name = RC_MAP_RC6_MCE;
 	rcdev->timeout = IR_DEFAULT_TIMEOUT;
diff --git a/drivers/media/rc/st_rc.c b/drivers/media/rc/st_rc.c
index 1fa0c9d..80a46e7 100644
--- a/drivers/media/rc/st_rc.c
+++ b/drivers/media/rc/st_rc.c
@@ -291,7 +291,7 @@ static int st_rc_probe(struct platform_device *pdev)
 	st_rc_hardware_init(rc_dev);
 
 	rdev->driver_type = RC_DRIVER_IR_RAW;
-	rdev->allowed_protocols = RC_BIT_ALL;
+	rdev->allowed_protocols = RC_BIT_ALL_IR_DECODER;
 	/* rx sampling rate is 10Mhz */
 	rdev->rx_resolution = 100;
 	rdev->timeout = US_TO_NS(MAX_SYMB_TIME);
diff --git a/drivers/media/rc/streamzap.c b/drivers/media/rc/streamzap.c
index 53f9b0a..359f928 100644
--- a/drivers/media/rc/streamzap.c
+++ b/drivers/media/rc/streamzap.c
@@ -309,7 +309,7 @@ static struct rc_dev *streamzap_init_rc_dev(struct streamzap_ir *sz)
 	rdev->dev.parent = dev;
 	rdev->priv = sz;
 	rdev->driver_type = RC_DRIVER_IR_RAW;
-	rdev->allowed_protocols = RC_BIT_ALL;
+	rdev->allowed_protocols = RC_BIT_ALL_IR_DECODER;
 	rdev->driver_name = DRIVER_NAME;
 	rdev->map_name = RC_MAP_STREAMZAP;
 
diff --git a/drivers/media/rc/sunxi-cir.c b/drivers/media/rc/sunxi-cir.c
index eaadc08..42bca8d 100644
--- a/drivers/media/rc/sunxi-cir.c
+++ b/drivers/media/rc/sunxi-cir.c
@@ -230,7 +230,7 @@ static int sunxi_ir_probe(struct platform_device *pdev)
 	ir->rc->map_name = ir->map_name ?: RC_MAP_EMPTY;
 	ir->rc->dev.parent = dev;
 	ir->rc->driver_type = RC_DRIVER_IR_RAW;
-	ir->rc->allowed_protocols = RC_BIT_ALL;
+	ir->rc->allowed_protocols = RC_BIT_ALL_IR_DECODER;
 	ir->rc->rx_resolution = SUNXI_IR_SAMPLE;
 	ir->rc->timeout = MS_TO_NS(SUNXI_IR_TIMEOUT);
 	ir->rc->driver_name = SUNXI_IR_DEV;
diff --git a/drivers/media/rc/ttusbir.c b/drivers/media/rc/ttusbir.c
index bc214e2..322e947 100644
--- a/drivers/media/rc/ttusbir.c
+++ b/drivers/media/rc/ttusbir.c
@@ -318,7 +318,7 @@ static int ttusbir_probe(struct usb_interface *intf,
 	usb_to_input_id(tt->udev, &rc->input_id);
 	rc->dev.parent = &intf->dev;
 	rc->driver_type = RC_DRIVER_IR_RAW;
-	rc->allowed_protocols = RC_BIT_ALL;
+	rc->allowed_protocols = RC_BIT_ALL_IR_DECODER;
 	rc->priv = tt;
 	rc->driver_name = DRIVER_NAME;
 	rc->map_name = RC_MAP_TT_1500;
diff --git a/drivers/media/rc/winbond-cir.c b/drivers/media/rc/winbond-cir.c
index 93ae1d2..e60c06d 100644
--- a/drivers/media/rc/winbond-cir.c
+++ b/drivers/media/rc/winbond-cir.c
@@ -1089,7 +1089,7 @@ wbcir_probe(struct pnp_dev *device, const struct pnp_device_id *dev_id)
 	data->dev->dev.parent = &device->dev;
 	data->dev->timeout = MS_TO_NS(100);
 	data->dev->rx_resolution = US_TO_NS(2);
-	data->dev->allowed_protocols = RC_BIT_ALL;
+	data->dev->allowed_protocols = RC_BIT_ALL_IR_DECODER;
 	data->dev->allowed_wakeup_protocols = RC_BIT_NEC | RC_BIT_NECX |
 			RC_BIT_NEC32 | RC_BIT_RC5 | RC_BIT_RC6_0 |
 			RC_BIT_RC6_6A_20 | RC_BIT_RC6_6A_24 |
diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index c583c63..e16ca07 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -1778,7 +1778,7 @@ static int rtl2832u_get_rc_config(struct dvb_usb_device *d,
 	/* load empty to enable rc */
 	if (!rc->map_name)
 		rc->map_name = RC_MAP_EMPTY;
-	rc->allowed_protos = RC_BIT_ALL;
+	rc->allowed_protos = RC_BIT_ALL_IR_DECODER;
 	rc->driver_type = RC_DRIVER_IR_RAW;
 	rc->query = rtl2832u_rc_query;
 	rc->interval = 200;
diff --git a/drivers/media/usb/dvb-usb/technisat-usb2.c b/drivers/media/usb/dvb-usb/technisat-usb2.c
index 02c3bee..1b21f1b 100644
--- a/drivers/media/usb/dvb-usb/technisat-usb2.c
+++ b/drivers/media/usb/dvb-usb/technisat-usb2.c
@@ -753,7 +753,7 @@ static struct dvb_usb_device_properties technisat_usb2_devices = {
 		.rc_codes    = RC_MAP_TECHNISAT_USB2,
 		.module_name = "technisat-usb2",
 		.rc_query    = technisat_usb2_rc_query,
-		.allowed_protos = RC_BIT_ALL,
+		.allowed_protos = RC_BIT_ALL_IR_DECODER,
 		.driver_type    = RC_DRIVER_IR_RAW,
 	}
 };
diff --git a/include/media/rc-map.h b/include/media/rc-map.h
index e1cc14c..b2af45d 100644
--- a/include/media/rc-map.h
+++ b/include/media/rc-map.h
@@ -95,6 +95,16 @@ enum rc_type {
 			 RC_BIT_RC6_6A_20 | RC_BIT_RC6_6A_24 | \
 			 RC_BIT_RC6_6A_32 | RC_BIT_RC6_MCE | RC_BIT_SHARP | \
 			 RC_BIT_XMP | RC_BIT_CEC)
+/* All rc protocols for which we have decoders */
+#define RC_BIT_ALL_IR_DECODER \
+			(RC_BIT_RC5 | RC_BIT_RC5X | RC_BIT_RC5_SZ | \
+			 RC_BIT_JVC | \
+			 RC_BIT_SONY12 | RC_BIT_SONY15 | RC_BIT_SONY20 | \
+			 RC_BIT_NEC | RC_BIT_NECX | RC_BIT_NEC32 | \
+			 RC_BIT_SANYO | RC_BIT_MCE_KBD | RC_BIT_RC6_0 | \
+			 RC_BIT_RC6_6A_20 | RC_BIT_RC6_6A_24 | \
+			 RC_BIT_RC6_6A_32 | RC_BIT_RC6_MCE | RC_BIT_SHARP | \
+			 RC_BIT_XMP)
 
 
 #define RC_SCANCODE_UNKNOWN(x)			(x)
-- 
2.9.3

