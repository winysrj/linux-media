Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:40159 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752156AbdGBLGL (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 2 Jul 2017 07:06:11 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH 1/4] [media] rc-core: rename input_name to device_name
Date: Sun,  2 Jul 2017 12:06:08 +0100
Message-Id: <33c5263592b7de0782982429d2a1e2c0f07b3b58.1498992850.git.sean@mess.org>
In-Reply-To: <cover.1498992850.git.sean@mess.org>
References: <cover.1498992850.git.sean@mess.org>
In-Reply-To: <cover.1498992850.git.sean@mess.org>
References: <cover.1498992850.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When an ir-spi is registered, you get this message.

rc rc0: Unspecified device as /devices/platform/soc/3f215080.spi/spi_master/spi32766/spi32766.128/rc/rc0

"Unspecified device" refers to input_name, which makes no sense for IR
TX only devices. So, rename to device_name.

Also make driver_name const char* so that no casts are needed anywhere.

Now ir-spi reports:

rc rc0: IR SPI as /devices/platform/soc/3f215080.spi/spi_master/spi32766/spi32766.128/rc/rc0

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/cec/cec-core.c                |  4 ++--
 drivers/media/common/siano/smsir.c          |  4 ++--
 drivers/media/i2c/ir-kbd-i2c.c              |  2 +-
 drivers/media/pci/bt8xx/bttv-input.c        |  2 +-
 drivers/media/pci/cx23885/cx23885-input.c   |  2 +-
 drivers/media/pci/cx88/cx88-input.c         |  2 +-
 drivers/media/pci/dm1105/dm1105.c           |  2 +-
 drivers/media/pci/mantis/mantis_common.h    |  2 +-
 drivers/media/pci/mantis/mantis_input.c     |  4 ++--
 drivers/media/pci/saa7134/saa7134-input.c   |  2 +-
 drivers/media/pci/smipcie/smipcie-ir.c      |  4 ++--
 drivers/media/pci/smipcie/smipcie.h         |  2 +-
 drivers/media/pci/ttpci/budget-ci.c         |  2 +-
 drivers/media/rc/ati_remote.c               |  2 +-
 drivers/media/rc/ene_ir.c                   |  4 ++--
 drivers/media/rc/fintek-cir.c               |  2 +-
 drivers/media/rc/gpio-ir-recv.c             |  2 +-
 drivers/media/rc/igorplugusb.c              |  2 +-
 drivers/media/rc/iguanair.c                 |  2 +-
 drivers/media/rc/img-ir/img-ir-hw.c         |  2 +-
 drivers/media/rc/img-ir/img-ir-raw.c        |  2 +-
 drivers/media/rc/imon.c                     |  2 +-
 drivers/media/rc/ir-hix5hd2.c               |  2 +-
 drivers/media/rc/ir-spi.c                   |  1 +
 drivers/media/rc/ite-cir.c                  |  2 +-
 drivers/media/rc/mceusb.c                   |  2 +-
 drivers/media/rc/meson-ir.c                 |  2 +-
 drivers/media/rc/mtk-cir.c                  |  2 +-
 drivers/media/rc/nuvoton-cir.c              |  2 +-
 drivers/media/rc/rc-loopback.c              |  2 +-
 drivers/media/rc/rc-main.c                  |  8 ++++----
 drivers/media/rc/redrat3.c                  |  2 +-
 drivers/media/rc/serial_ir.c                | 10 +++++-----
 drivers/media/rc/sir_ir.c                   |  2 +-
 drivers/media/rc/st_rc.c                    |  2 +-
 drivers/media/rc/streamzap.c                |  2 +-
 drivers/media/rc/sunxi-cir.c                |  2 +-
 drivers/media/rc/ttusbir.c                  |  2 +-
 drivers/media/rc/winbond-cir.c              |  2 +-
 drivers/media/usb/au0828/au0828-input.c     |  2 +-
 drivers/media/usb/dvb-usb-v2/dvb_usb_core.c |  5 ++---
 drivers/media/usb/dvb-usb/dvb-usb-remote.c  |  2 +-
 drivers/media/usb/em28xx/em28xx-input.c     |  2 +-
 drivers/media/usb/tm6000/tm6000-input.c     |  2 +-
 include/media/cec.h                         |  2 +-
 include/media/rc-core.h                     |  6 +++---
 46 files changed, 61 insertions(+), 61 deletions(-)

diff --git a/drivers/media/cec/cec-core.c b/drivers/media/cec/cec-core.c
index b516d59..1d5087f 100644
--- a/drivers/media/cec/cec-core.c
+++ b/drivers/media/cec/cec-core.c
@@ -263,12 +263,12 @@ struct cec_adapter *cec_allocate_adapter(const struct cec_adap_ops *ops,
 		return ERR_PTR(-ENOMEM);
 	}
 
-	snprintf(adap->input_name, sizeof(adap->input_name),
+	snprintf(adap->device_name, sizeof(adap->device_name),
 		 "RC for %s", name);
 	snprintf(adap->input_phys, sizeof(adap->input_phys),
 		 "%s/input0", name);
 
-	adap->rc->input_name = adap->input_name;
+	adap->rc->device_name = adap->device_name;
 	adap->rc->input_phys = adap->input_phys;
 	adap->rc->input_id.bustype = BUS_CEC;
 	adap->rc->input_id.vendor = 0;
diff --git a/drivers/media/common/siano/smsir.c b/drivers/media/common/siano/smsir.c
index 7c898b0..941c342 100644
--- a/drivers/media/common/siano/smsir.c
+++ b/drivers/media/common/siano/smsir.c
@@ -73,7 +73,7 @@ int sms_ir_init(struct smscore_device_t *coredev)
 	strlcpy(coredev->ir.phys, coredev->devpath, sizeof(coredev->ir.phys));
 	strlcat(coredev->ir.phys, "/ir0", sizeof(coredev->ir.phys));
 
-	dev->input_name = coredev->ir.name;
+	dev->device_name = coredev->ir.name;
 	dev->input_phys = coredev->ir.phys;
 	dev->dev.parent = coredev->device;
 
@@ -91,7 +91,7 @@ int sms_ir_init(struct smscore_device_t *coredev)
 	dev->driver_name = MODULE_NAME;
 
 	pr_debug("Input device (IR) %s is set for key events\n",
-		 dev->input_name);
+		 dev->device_name);
 
 	err = rc_register_device(dev);
 	if (err < 0) {
diff --git a/drivers/media/i2c/ir-kbd-i2c.c b/drivers/media/i2c/ir-kbd-i2c.c
index cee7fd9..af909bf 100644
--- a/drivers/media/i2c/ir-kbd-i2c.c
+++ b/drivers/media/i2c/ir-kbd-i2c.c
@@ -452,7 +452,7 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	 */
 	rc->input_id.bustype = BUS_I2C;
 	rc->input_phys       = ir->phys;
-	rc->input_name	     = ir->name;
+	rc->device_name	     = ir->name;
 
 	/*
 	 * Initialize the other fields of rc_dev
diff --git a/drivers/media/pci/bt8xx/bttv-input.c b/drivers/media/pci/bt8xx/bttv-input.c
index 2fd07a8..bb8eda5 100644
--- a/drivers/media/pci/bt8xx/bttv-input.c
+++ b/drivers/media/pci/bt8xx/bttv-input.c
@@ -535,7 +535,7 @@ int bttv_input_init(struct bttv *btv)
 	snprintf(ir->phys, sizeof(ir->phys), "pci-%s/ir0",
 		 pci_name(btv->c.pci));
 
-	rc->input_name = ir->name;
+	rc->device_name = ir->name;
 	rc->input_phys = ir->phys;
 	rc->input_id.bustype = BUS_PCI;
 	rc->input_id.version = 1;
diff --git a/drivers/media/pci/cx23885/cx23885-input.c b/drivers/media/pci/cx23885/cx23885-input.c
index 4367cb3..c9b8e3f 100644
--- a/drivers/media/pci/cx23885/cx23885-input.c
+++ b/drivers/media/pci/cx23885/cx23885-input.c
@@ -351,7 +351,7 @@ int cx23885_input_init(struct cx23885_dev *dev)
 	}
 
 	kernel_ir->rc = rc;
-	rc->input_name = kernel_ir->name;
+	rc->device_name = kernel_ir->name;
 	rc->input_phys = kernel_ir->phys;
 	rc->input_id.bustype = BUS_PCI;
 	rc->input_id.version = 1;
diff --git a/drivers/media/pci/cx88/cx88-input.c b/drivers/media/pci/cx88/cx88-input.c
index 01f2e47..a5dbee7 100644
--- a/drivers/media/pci/cx88/cx88-input.c
+++ b/drivers/media/pci/cx88/cx88-input.c
@@ -464,7 +464,7 @@ int cx88_ir_init(struct cx88_core *core, struct pci_dev *pci)
 	snprintf(ir->name, sizeof(ir->name), "cx88 IR (%s)", core->board.name);
 	snprintf(ir->phys, sizeof(ir->phys), "pci-%s/ir0", pci_name(pci));
 
-	dev->input_name = ir->name;
+	dev->device_name = ir->name;
 	dev->input_phys = ir->phys;
 	dev->input_id.bustype = BUS_PCI;
 	dev->input_id.version = 1;
diff --git a/drivers/media/pci/dm1105/dm1105.c b/drivers/media/pci/dm1105/dm1105.c
index 1d41934..e69ec33 100644
--- a/drivers/media/pci/dm1105/dm1105.c
+++ b/drivers/media/pci/dm1105/dm1105.c
@@ -748,7 +748,7 @@ static int dm1105_ir_init(struct dm1105_dev *dm1105)
 
 	dev->driver_name = MODULE_NAME;
 	dev->map_name = RC_MAP_DM1105_NEC;
-	dev->input_name = "DVB on-card IR receiver";
+	dev->device_name = "DVB on-card IR receiver";
 	dev->input_phys = dm1105->ir.input_phys;
 	dev->input_id.bustype = BUS_PCI;
 	dev->input_id.version = 1;
diff --git a/drivers/media/pci/mantis/mantis_common.h b/drivers/media/pci/mantis/mantis_common.h
index d48778a..a664c31 100644
--- a/drivers/media/pci/mantis/mantis_common.h
+++ b/drivers/media/pci/mantis/mantis_common.h
@@ -176,7 +176,7 @@ struct mantis_pci {
 	struct work_struct	uart_work;
 
 	struct rc_dev		*rc;
-	char			input_name[80];
+	char			device_name[80];
 	char			input_phys[80];
 	char			*rc_map_name;
 };
diff --git a/drivers/media/pci/mantis/mantis_input.c b/drivers/media/pci/mantis/mantis_input.c
index 50d10cb..001b7f8 100644
--- a/drivers/media/pci/mantis/mantis_input.c
+++ b/drivers/media/pci/mantis/mantis_input.c
@@ -46,12 +46,12 @@ int mantis_input_init(struct mantis_pci *mantis)
 		goto out;
 	}
 
-	snprintf(mantis->input_name, sizeof(mantis->input_name),
+	snprintf(mantis->device_name, sizeof(mantis->device_name),
 		 "Mantis %s IR receiver", mantis->hwconfig->model_name);
 	snprintf(mantis->input_phys, sizeof(mantis->input_phys),
 		 "pci-%s/ir0", pci_name(mantis->pdev));
 
-	dev->input_name         = mantis->input_name;
+	dev->device_name        = mantis->device_name;
 	dev->input_phys         = mantis->input_phys;
 	dev->input_id.bustype   = BUS_PCI;
 	dev->input_id.vendor    = mantis->vendor_id;
diff --git a/drivers/media/pci/saa7134/saa7134-input.c b/drivers/media/pci/saa7134/saa7134-input.c
index 78849c1..ba1fc77 100644
--- a/drivers/media/pci/saa7134/saa7134-input.c
+++ b/drivers/media/pci/saa7134/saa7134-input.c
@@ -870,7 +870,7 @@ int saa7134_input_init1(struct saa7134_dev *dev)
 	if (raw_decode)
 		rc->driver_type = RC_DRIVER_IR_RAW;
 
-	rc->input_name = ir->name;
+	rc->device_name = ir->name;
 	rc->input_phys = ir->phys;
 	rc->input_id.bustype = BUS_PCI;
 	rc->input_id.version = 1;
diff --git a/drivers/media/pci/smipcie/smipcie-ir.c b/drivers/media/pci/smipcie/smipcie-ir.c
index d2730c3..fc33757 100644
--- a/drivers/media/pci/smipcie/smipcie-ir.c
+++ b/drivers/media/pci/smipcie/smipcie-ir.c
@@ -188,14 +188,14 @@ int smi_ir_init(struct smi_dev *dev)
 		return -ENOMEM;
 
 	/* init input device */
-	snprintf(ir->input_name, sizeof(ir->input_name), "IR (%s)",
+	snprintf(ir->device_name, sizeof(ir->device_name), "IR (%s)",
 		 dev->info->name);
 	snprintf(ir->input_phys, sizeof(ir->input_phys), "pci-%s/ir0",
 		 pci_name(dev->pci_dev));
 
 	rc_dev->driver_name = "SMI_PCIe";
 	rc_dev->input_phys = ir->input_phys;
-	rc_dev->input_name = ir->input_name;
+	rc_dev->device_name = ir->device_name;
 	rc_dev->input_id.bustype = BUS_PCI;
 	rc_dev->input_id.version = 1;
 	rc_dev->input_id.vendor = dev->pci_dev->subsystem_vendor;
diff --git a/drivers/media/pci/smipcie/smipcie.h b/drivers/media/pci/smipcie/smipcie.h
index 611e4f0..c8368c7 100644
--- a/drivers/media/pci/smipcie/smipcie.h
+++ b/drivers/media/pci/smipcie/smipcie.h
@@ -240,7 +240,7 @@ struct smi_rc {
 	struct smi_dev *dev;
 	struct rc_dev *rc_dev;
 	char input_phys[64];
-	char input_name[64];
+	char device_name[64];
 	struct work_struct work;
 	u8 irData[256];
 
diff --git a/drivers/media/pci/ttpci/budget-ci.c b/drivers/media/pci/ttpci/budget-ci.c
index 11b9227..cd4e63b 100644
--- a/drivers/media/pci/ttpci/budget-ci.c
+++ b/drivers/media/pci/ttpci/budget-ci.c
@@ -186,7 +186,7 @@ static int msp430_ir_init(struct budget_ci *budget_ci)
 		 "pci-%s/ir0", pci_name(saa->pci));
 
 	dev->driver_name = MODULE_NAME;
-	dev->input_name = budget_ci->ir.name;
+	dev->device_name = budget_ci->ir.name;
 	dev->input_phys = budget_ci->ir.phys;
 	dev->input_id.bustype = BUS_PCI;
 	dev->input_id.version = 1;
diff --git a/drivers/media/rc/ati_remote.c b/drivers/media/rc/ati_remote.c
index a4c6ad4..a7f7600 100644
--- a/drivers/media/rc/ati_remote.c
+++ b/drivers/media/rc/ati_remote.c
@@ -766,7 +766,7 @@ static void ati_remote_rc_init(struct ati_remote *ati_remote)
 	rdev->open = ati_remote_rc_open;
 	rdev->close = ati_remote_rc_close;
 
-	rdev->input_name = ati_remote->rc_name;
+	rdev->device_name = ati_remote->rc_name;
 	rdev->input_phys = ati_remote->rc_phys;
 
 	usb_to_input_id(ati_remote->udev, &rdev->input_id);
diff --git a/drivers/media/rc/ene_ir.c b/drivers/media/rc/ene_ir.c
index 60da963..41f6b1c 100644
--- a/drivers/media/rc/ene_ir.c
+++ b/drivers/media/rc/ene_ir.c
@@ -1060,7 +1060,7 @@ static int ene_probe(struct pnp_dev *pnp_dev, const struct pnp_device_id *id)
 	rdev->s_idle = ene_set_idle;
 	rdev->driver_name = ENE_DRIVER_NAME;
 	rdev->map_name = RC_MAP_RC6_MCE;
-	rdev->input_name = "ENE eHome Infrared Remote Receiver";
+	rdev->device_name = "ENE eHome Infrared Remote Receiver";
 
 	if (dev->hw_learning_and_tx_capable) {
 		rdev->s_learning_mode = ene_set_learning_mode;
@@ -1070,7 +1070,7 @@ static int ene_probe(struct pnp_dev *pnp_dev, const struct pnp_device_id *id)
 		rdev->s_tx_carrier = ene_set_tx_carrier;
 		rdev->s_tx_duty_cycle = ene_set_tx_duty_cycle;
 		rdev->s_carrier_report = ene_set_carrier_report;
-		rdev->input_name = "ENE eHome Infrared Remote Transceiver";
+		rdev->device_name = "ENE eHome Infrared Remote Transceiver";
 	}
 
 	dev->rdev = rdev;
diff --git a/drivers/media/rc/fintek-cir.c b/drivers/media/rc/fintek-cir.c
index 0d35627..57155e4 100644
--- a/drivers/media/rc/fintek-cir.c
+++ b/drivers/media/rc/fintek-cir.c
@@ -532,7 +532,7 @@ static int fintek_probe(struct pnp_dev *pdev, const struct pnp_device_id *dev_id
 	rdev->allowed_protocols = RC_BIT_ALL_IR_DECODER;
 	rdev->open = fintek_open;
 	rdev->close = fintek_close;
-	rdev->input_name = FINTEK_DESCRIPTION;
+	rdev->device_name = FINTEK_DESCRIPTION;
 	rdev->input_phys = "fintek/cir0";
 	rdev->input_id.bustype = BUS_HOST;
 	rdev->input_id.vendor = VENDOR_ID_FINTEK;
diff --git a/drivers/media/rc/gpio-ir-recv.c b/drivers/media/rc/gpio-ir-recv.c
index b4f773b..561c27a 100644
--- a/drivers/media/rc/gpio-ir-recv.c
+++ b/drivers/media/rc/gpio-ir-recv.c
@@ -150,7 +150,7 @@ static int gpio_ir_recv_probe(struct platform_device *pdev)
 	}
 
 	rcdev->priv = gpio_dev;
-	rcdev->input_name = GPIO_IR_DEVICE_NAME;
+	rcdev->device_name = GPIO_IR_DEVICE_NAME;
 	rcdev->input_phys = GPIO_IR_DEVICE_NAME "/input0";
 	rcdev->input_id.bustype = BUS_HOST;
 	rcdev->input_id.vendor = 0x0001;
diff --git a/drivers/media/rc/igorplugusb.c b/drivers/media/rc/igorplugusb.c
index cb6d4f1..5babc63 100644
--- a/drivers/media/rc/igorplugusb.c
+++ b/drivers/media/rc/igorplugusb.c
@@ -194,7 +194,7 @@ static int igorplugusb_probe(struct usb_interface *intf,
 	if (!rc)
 		goto fail;
 
-	rc->input_name = DRIVER_DESC;
+	rc->device_name = DRIVER_DESC;
 	rc->input_phys = ir->phys;
 	usb_to_input_id(udev, &rc->input_id);
 	rc->dev.parent = &intf->dev;
diff --git a/drivers/media/rc/iguanair.c b/drivers/media/rc/iguanair.c
index 8711a7f..4357dd3 100644
--- a/drivers/media/rc/iguanair.c
+++ b/drivers/media/rc/iguanair.c
@@ -487,7 +487,7 @@ static int iguanair_probe(struct usb_interface *intf,
 
 	usb_make_path(ir->udev, ir->phys, sizeof(ir->phys));
 
-	rc->input_name = ir->name;
+	rc->device_name = ir->name;
 	rc->input_phys = ir->phys;
 	usb_to_input_id(ir->udev, &rc->input_id);
 	rc->dev.parent = &intf->dev;
diff --git a/drivers/media/rc/img-ir/img-ir-hw.c b/drivers/media/rc/img-ir/img-ir-hw.c
index 8d14396..dd46973 100644
--- a/drivers/media/rc/img-ir/img-ir-hw.c
+++ b/drivers/media/rc/img-ir/img-ir-hw.c
@@ -1083,7 +1083,7 @@ int img_ir_probe_hw(struct img_ir_priv *priv)
 	rdev->priv = priv;
 	rdev->map_name = RC_MAP_EMPTY;
 	rdev->allowed_protocols = img_ir_allowed_protos(priv);
-	rdev->input_name = "IMG Infrared Decoder";
+	rdev->device_name = "IMG Infrared Decoder";
 	rdev->s_filter = img_ir_set_normal_filter;
 	rdev->s_wakeup_filter = img_ir_set_wakeup_filter;
 
diff --git a/drivers/media/rc/img-ir/img-ir-raw.c b/drivers/media/rc/img-ir/img-ir-raw.c
index 8d2f8e2..7f23a86 100644
--- a/drivers/media/rc/img-ir/img-ir-raw.c
+++ b/drivers/media/rc/img-ir/img-ir-raw.c
@@ -117,7 +117,7 @@ int img_ir_probe_raw(struct img_ir_priv *priv)
 	}
 	rdev->priv = priv;
 	rdev->map_name = RC_MAP_EMPTY;
-	rdev->input_name = "IMG Infrared Decoder Raw";
+	rdev->device_name = "IMG Infrared Decoder Raw";
 
 	/* Register raw decoder */
 	error = rc_register_device(rdev);
diff --git a/drivers/media/rc/imon.c b/drivers/media/rc/imon.c
index bd76534..46e1419 100644
--- a/drivers/media/rc/imon.c
+++ b/drivers/media/rc/imon.c
@@ -2063,7 +2063,7 @@ static struct rc_dev *imon_init_rdev(struct imon_context *ictx)
 		      sizeof(ictx->phys_rdev));
 	strlcat(ictx->phys_rdev, "/input0", sizeof(ictx->phys_rdev));
 
-	rdev->input_name = ictx->name_rdev;
+	rdev->device_name = ictx->name_rdev;
 	rdev->input_phys = ictx->phys_rdev;
 	usb_to_input_id(ictx->usbdev_intf0, &rdev->input_id);
 	rdev->dev.parent = ictx->dev;
diff --git a/drivers/media/rc/ir-hix5hd2.c b/drivers/media/rc/ir-hix5hd2.c
index 50951f6..0e639fb 100644
--- a/drivers/media/rc/ir-hix5hd2.c
+++ b/drivers/media/rc/ir-hix5hd2.c
@@ -249,7 +249,7 @@ static int hix5hd2_ir_probe(struct platform_device *pdev)
 	rdev->driver_name = IR_HIX5HD2_NAME;
 	map_name = of_get_property(node, "linux,rc-map-name", NULL);
 	rdev->map_name = map_name ?: RC_MAP_EMPTY;
-	rdev->input_name = IR_HIX5HD2_NAME;
+	rdev->device_name = IR_HIX5HD2_NAME;
 	rdev->input_phys = IR_HIX5HD2_NAME "/input0";
 	rdev->input_id.bustype = BUS_HOST;
 	rdev->input_id.vendor = 0x0001;
diff --git a/drivers/media/rc/ir-spi.c b/drivers/media/rc/ir-spi.c
index 7e383b3..29ed063 100644
--- a/drivers/media/rc/ir-spi.c
+++ b/drivers/media/rc/ir-spi.c
@@ -155,6 +155,7 @@ static int ir_spi_probe(struct spi_device *spi)
 	idata->rc->tx_ir           = ir_spi_tx;
 	idata->rc->s_tx_carrier    = ir_spi_set_tx_carrier;
 	idata->rc->s_tx_duty_cycle = ir_spi_set_duty_cycle;
+	idata->rc->device_name	   = "IR SPI";
 	idata->rc->driver_name     = IR_SPI_DRIVER_NAME;
 	idata->rc->priv            = idata;
 	idata->spi                 = spi;
diff --git a/drivers/media/rc/ite-cir.c b/drivers/media/rc/ite-cir.c
index e9e4bef..c8eea30 100644
--- a/drivers/media/rc/ite-cir.c
+++ b/drivers/media/rc/ite-cir.c
@@ -1576,7 +1576,7 @@ static int ite_probe(struct pnp_dev *pdev, const struct pnp_device_id
 		rdev->s_tx_duty_cycle = ite_set_tx_duty_cycle;
 	}
 
-	rdev->input_name = dev_desc->model;
+	rdev->device_name = dev_desc->model;
 	rdev->input_id.bustype = BUS_HOST;
 	rdev->input_id.vendor = PCI_VENDOR_ID_ITE;
 	rdev->input_id.product = 0;
diff --git a/drivers/media/rc/mceusb.c b/drivers/media/rc/mceusb.c
index eb13069..d9c7bbd 100644
--- a/drivers/media/rc/mceusb.c
+++ b/drivers/media/rc/mceusb.c
@@ -1264,7 +1264,7 @@ static struct rc_dev *mceusb_init_rc_dev(struct mceusb_dev *ir)
 
 	usb_make_path(ir->usbdev, ir->phys, sizeof(ir->phys));
 
-	rc->input_name = ir->name;
+	rc->device_name = ir->name;
 	rc->input_phys = ir->phys;
 	usb_to_input_id(ir->usbdev, &rc->input_id);
 	rc->dev.parent = dev;
diff --git a/drivers/media/rc/meson-ir.c b/drivers/media/rc/meson-ir.c
index 65566d5..dfe3da4 100644
--- a/drivers/media/rc/meson-ir.c
+++ b/drivers/media/rc/meson-ir.c
@@ -138,7 +138,7 @@ static int meson_ir_probe(struct platform_device *pdev)
 	}
 
 	ir->rc->priv = ir;
-	ir->rc->input_name = DRIVER_NAME;
+	ir->rc->device_name = DRIVER_NAME;
 	ir->rc->input_phys = DRIVER_NAME "/input0";
 	ir->rc->input_id.bustype = BUS_HOST;
 	map_name = of_get_property(node, "linux,rc-map-name", NULL);
diff --git a/drivers/media/rc/mtk-cir.c b/drivers/media/rc/mtk-cir.c
index f1e164e..a008953 100644
--- a/drivers/media/rc/mtk-cir.c
+++ b/drivers/media/rc/mtk-cir.c
@@ -228,7 +228,7 @@ static int mtk_ir_probe(struct platform_device *pdev)
 	}
 
 	ir->rc->priv = ir;
-	ir->rc->input_name = MTK_IR_DEV;
+	ir->rc->device_name = MTK_IR_DEV;
 	ir->rc->input_phys = MTK_IR_DEV "/input0";
 	ir->rc->input_id.bustype = BUS_HOST;
 	ir->rc->input_id.vendor = 0x0001;
diff --git a/drivers/media/rc/nuvoton-cir.c b/drivers/media/rc/nuvoton-cir.c
index ec4b25b..c44f723 100644
--- a/drivers/media/rc/nuvoton-cir.c
+++ b/drivers/media/rc/nuvoton-cir.c
@@ -1134,7 +1134,7 @@ static int nvt_probe(struct pnp_dev *pdev, const struct pnp_device_id *dev_id)
 	rdev->tx_ir = nvt_tx_ir;
 	rdev->s_tx_carrier = nvt_set_tx_carrier;
 	rdev->s_wakeup_filter = nvt_ir_raw_set_wakeup_filter;
-	rdev->input_name = "Nuvoton w836x7hg Infrared Remote Transceiver";
+	rdev->device_name = "Nuvoton w836x7hg Infrared Remote Transceiver";
 	rdev->input_phys = "nuvoton/cir0";
 	rdev->input_id.bustype = BUS_HOST;
 	rdev->input_id.vendor = PCI_VENDOR_ID_WINBOND2;
diff --git a/drivers/media/rc/rc-loopback.c b/drivers/media/rc/rc-loopback.c
index 62195af..46cc9c2 100644
--- a/drivers/media/rc/rc-loopback.c
+++ b/drivers/media/rc/rc-loopback.c
@@ -219,7 +219,7 @@ static int __init loop_init(void)
 		return -ENOMEM;
 	}
 
-	rc->input_name		= "rc-core loopback device";
+	rc->device_name		= "rc-core loopback device";
 	rc->input_phys		= "rc-core/virtual";
 	rc->input_id.bustype	= BUS_VIRTUAL;
 	rc->input_id.version	= 1;
diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index a9eba00..a0f852d 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -530,7 +530,7 @@ u32 rc_g_keycode_from_table(struct rc_dev *dev, u32 scancode)
 
 	if (keycode != KEY_RESERVED)
 		IR_dprintk(1, "%s: scancode 0x%04x keycode 0x%02x\n",
-			   dev->input_name, scancode, keycode);
+			   dev->device_name, scancode, keycode);
 
 	return keycode;
 }
@@ -663,7 +663,7 @@ static void ir_do_keydown(struct rc_dev *dev, enum rc_type protocol,
 		dev->last_keycode = keycode;
 
 		IR_dprintk(1, "%s: key down event, key 0x%04x, protocol 0x%04x, scancode 0x%08x\n",
-			   dev->input_name, keycode, protocol, scancode);
+			   dev->device_name, keycode, protocol, scancode);
 		input_report_key(dev->input_dev, keycode, 1);
 
 		led_trigger_event(led_feedback, LED_FULL);
@@ -1663,7 +1663,7 @@ static int rc_prepare_rx_device(struct rc_dev *dev)
 	dev->input_dev->dev.parent = &dev->dev;
 	memcpy(&dev->input_dev->id, &dev->input_id, sizeof(dev->input_id));
 	dev->input_dev->phys = dev->input_phys;
-	dev->input_dev->name = dev->input_name;
+	dev->input_dev->name = dev->device_name;
 
 	return 0;
 
@@ -1759,7 +1759,7 @@ int rc_register_device(struct rc_dev *dev)
 
 	path = kobject_get_path(&dev->dev.kobj, GFP_KERNEL);
 	dev_info(&dev->dev, "%s as %s\n",
-		dev->input_name ?: "Unspecified device", path ?: "N/A");
+		 dev->device_name ?: "Unspecified device", path ?: "N/A");
 	kfree(path);
 
 	if (dev->driver_type != RC_DRIVER_IR_RAW_TX) {
diff --git a/drivers/media/rc/redrat3.c b/drivers/media/rc/redrat3.c
index 56d43be..29fa37b 100644
--- a/drivers/media/rc/redrat3.c
+++ b/drivers/media/rc/redrat3.c
@@ -951,7 +951,7 @@ static struct rc_dev *redrat3_init_rc_dev(struct redrat3_dev *rr3)
 
 	usb_make_path(rr3->udev, rr3->phys, sizeof(rr3->phys));
 
-	rc->input_name = rr3->name;
+	rc->device_name = rr3->name;
 	rc->input_phys = rr3->phys;
 	usb_to_input_id(rr3->udev, &rc->input_id);
 	rc->dev.parent = dev;
diff --git a/drivers/media/rc/serial_ir.c b/drivers/media/rc/serial_ir.c
index 77d5d4c..9a5e9fa 100644
--- a/drivers/media/rc/serial_ir.c
+++ b/drivers/media/rc/serial_ir.c
@@ -513,19 +513,19 @@ static int serial_ir_probe(struct platform_device *dev)
 
 	switch (type) {
 	case IR_HOMEBREW:
-		rcdev->input_name = "Serial IR type home-brew";
+		rcdev->device_name = "Serial IR type home-brew";
 		break;
 	case IR_IRDEO:
-		rcdev->input_name = "Serial IR type IRdeo";
+		rcdev->device_name = "Serial IR type IRdeo";
 		break;
 	case IR_IRDEO_REMOTE:
-		rcdev->input_name = "Serial IR type IRdeo remote";
+		rcdev->device_name = "Serial IR type IRdeo remote";
 		break;
 	case IR_ANIMAX:
-		rcdev->input_name = "Serial IR type AnimaX";
+		rcdev->device_name = "Serial IR type AnimaX";
 		break;
 	case IR_IGOR:
-		rcdev->input_name = "Serial IR type IgorPlug";
+		rcdev->device_name = "Serial IR type IgorPlug";
 		break;
 	}
 
diff --git a/drivers/media/rc/sir_ir.c b/drivers/media/rc/sir_ir.c
index 20234ba..221fce4 100644
--- a/drivers/media/rc/sir_ir.c
+++ b/drivers/media/rc/sir_ir.c
@@ -308,7 +308,7 @@ static int sir_ir_probe(struct platform_device *dev)
 	if (!rcdev)
 		return -ENOMEM;
 
-	rcdev->input_name = "SIR IrDA port";
+	rcdev->device_name = "SIR IrDA port";
 	rcdev->input_phys = KBUILD_MODNAME "/input0";
 	rcdev->input_id.bustype = BUS_HOST;
 	rcdev->input_id.vendor = 0x0001;
diff --git a/drivers/media/rc/st_rc.c b/drivers/media/rc/st_rc.c
index a08e1dd..272de9c 100644
--- a/drivers/media/rc/st_rc.c
+++ b/drivers/media/rc/st_rc.c
@@ -299,7 +299,7 @@ static int st_rc_probe(struct platform_device *pdev)
 	rdev->close = st_rc_close;
 	rdev->driver_name = IR_ST_NAME;
 	rdev->map_name = RC_MAP_EMPTY;
-	rdev->input_name = "ST Remote Control Receiver";
+	rdev->device_name = "ST Remote Control Receiver";
 
 	ret = rc_register_device(rdev);
 	if (ret < 0)
diff --git a/drivers/media/rc/streamzap.c b/drivers/media/rc/streamzap.c
index b09c45a..829f2b3 100644
--- a/drivers/media/rc/streamzap.c
+++ b/drivers/media/rc/streamzap.c
@@ -299,7 +299,7 @@ static struct rc_dev *streamzap_init_rc_dev(struct streamzap_ir *sz)
 	usb_make_path(sz->usbdev, sz->phys, sizeof(sz->phys));
 	strlcat(sz->phys, "/input0", sizeof(sz->phys));
 
-	rdev->input_name = sz->name;
+	rdev->device_name = sz->name;
 	rdev->input_phys = sz->phys;
 	usb_to_input_id(sz->usbdev, &rdev->input_id);
 	rdev->dev.parent = dev;
diff --git a/drivers/media/rc/sunxi-cir.c b/drivers/media/rc/sunxi-cir.c
index 4b785dd..87933eb 100644
--- a/drivers/media/rc/sunxi-cir.c
+++ b/drivers/media/rc/sunxi-cir.c
@@ -215,7 +215,7 @@ static int sunxi_ir_probe(struct platform_device *pdev)
 	}
 
 	ir->rc->priv = ir;
-	ir->rc->input_name = SUNXI_IR_DEV;
+	ir->rc->device_name = SUNXI_IR_DEV;
 	ir->rc->input_phys = "sunxi-ir/input0";
 	ir->rc->input_id.bustype = BUS_HOST;
 	ir->rc->input_id.vendor = 0x0001;
diff --git a/drivers/media/rc/ttusbir.c b/drivers/media/rc/ttusbir.c
index 23be770..5002a91 100644
--- a/drivers/media/rc/ttusbir.c
+++ b/drivers/media/rc/ttusbir.c
@@ -309,7 +309,7 @@ static int ttusbir_probe(struct usb_interface *intf,
 
 	usb_make_path(tt->udev, tt->phys, sizeof(tt->phys));
 
-	rc->input_name = DRIVER_DESC;
+	rc->device_name = DRIVER_DESC;
 	rc->input_phys = tt->phys;
 	usb_to_input_id(tt->udev, &rc->input_id);
 	rc->dev.parent = &intf->dev;
diff --git a/drivers/media/rc/winbond-cir.c b/drivers/media/rc/winbond-cir.c
index 5a4d4a6..ea7be6d 100644
--- a/drivers/media/rc/winbond-cir.c
+++ b/drivers/media/rc/winbond-cir.c
@@ -1068,7 +1068,7 @@ wbcir_probe(struct pnp_dev *device, const struct pnp_device_id *dev_id)
 	}
 
 	data->dev->driver_name = DRVNAME;
-	data->dev->input_name = WBCIR_NAME;
+	data->dev->device_name = WBCIR_NAME;
 	data->dev->input_phys = "wbcir/cir0";
 	data->dev->input_id.bustype = BUS_HOST;
 	data->dev->input_id.vendor = PCI_VENDOR_ID_WINBOND;
diff --git a/drivers/media/usb/au0828/au0828-input.c b/drivers/media/usb/au0828/au0828-input.c
index 9d82ec0..9ae42eb 100644
--- a/drivers/media/usb/au0828/au0828-input.c
+++ b/drivers/media/usb/au0828/au0828-input.c
@@ -335,7 +335,7 @@ int au0828_rc_register(struct au0828_dev *dev)
 	usb_make_path(dev->usbdev, ir->phys, sizeof(ir->phys));
 	strlcat(ir->phys, "/input0", sizeof(ir->phys));
 
-	rc->input_name = ir->name;
+	rc->device_name = ir->name;
 	rc->input_phys = ir->phys;
 	rc->input_id.bustype = BUS_USB;
 	rc->input_id.version = 1;
diff --git a/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c b/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
index 955fb0d..096bb75 100644
--- a/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
+++ b/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
@@ -154,13 +154,12 @@ static int dvb_usbv2_remote_init(struct dvb_usb_device *d)
 	}
 
 	dev->dev.parent = &d->udev->dev;
-	dev->input_name = d->name;
+	dev->device_name = d->name;
 	usb_make_path(d->udev, d->rc_phys, sizeof(d->rc_phys));
 	strlcat(d->rc_phys, "/ir0", sizeof(d->rc_phys));
 	dev->input_phys = d->rc_phys;
 	usb_to_input_id(d->udev, &dev->input_id);
-	/* TODO: likely RC-core should took const char * */
-	dev->driver_name = (char *) d->props->driver_name;
+	dev->driver_name = d->props->driver_name;
 	dev->map_name = d->rc.map_name;
 	dev->allowed_protocols = d->rc.allowed_protos;
 	dev->change_protocol = d->rc.change_protocol;
diff --git a/drivers/media/usb/dvb-usb/dvb-usb-remote.c b/drivers/media/usb/dvb-usb/dvb-usb-remote.c
index f05f1fc..0b03f9b 100644
--- a/drivers/media/usb/dvb-usb/dvb-usb-remote.c
+++ b/drivers/media/usb/dvb-usb/dvb-usb-remote.c
@@ -279,7 +279,7 @@ static int rc_core_dvb_usb_remote_init(struct dvb_usb_device *d)
 	dev->change_protocol = d->props.rc.core.change_protocol;
 	dev->allowed_protocols = d->props.rc.core.allowed_protos;
 	usb_to_input_id(d->udev, &dev->input_id);
-	dev->input_name = "IR-receiver inside an USB DVB receiver";
+	dev->device_name = "IR-receiver inside an USB DVB receiver";
 	dev->input_phys = d->rc_phys;
 	dev->dev.parent = &d->udev->dev;
 	dev->priv = d;
diff --git a/drivers/media/usb/em28xx/em28xx-input.c b/drivers/media/usb/em28xx/em28xx-input.c
index ca96739..d8746b9 100644
--- a/drivers/media/usb/em28xx/em28xx-input.c
+++ b/drivers/media/usb/em28xx/em28xx-input.c
@@ -807,7 +807,7 @@ static int em28xx_ir_init(struct em28xx *dev)
 	usb_make_path(udev, ir->phys, sizeof(ir->phys));
 	strlcat(ir->phys, "/input0", sizeof(ir->phys));
 
-	rc->input_name = ir->name;
+	rc->device_name = ir->name;
 	rc->input_phys = ir->phys;
 	rc->input_id.bustype = BUS_USB;
 	rc->input_id.version = 1;
diff --git a/drivers/media/usb/tm6000/tm6000-input.c b/drivers/media/usb/tm6000/tm6000-input.c
index 1a033f5..83e33ae 100644
--- a/drivers/media/usb/tm6000/tm6000-input.c
+++ b/drivers/media/usb/tm6000/tm6000-input.c
@@ -458,7 +458,7 @@ int tm6000_ir_init(struct tm6000_core *dev)
 	rc_type = RC_BIT_UNKNOWN;
 	tm6000_ir_change_protocol(rc, &rc_type);
 
-	rc->input_name = ir->name;
+	rc->device_name = ir->name;
 	rc->input_phys = ir->phys;
 	rc->input_id.bustype = BUS_USB;
 	rc->input_id.version = 1;
diff --git a/include/media/cec.h b/include/media/cec.h
index 56643b2..3aecd0d 100644
--- a/include/media/cec.h
+++ b/include/media/cec.h
@@ -184,7 +184,7 @@ struct cec_adapter {
 	u16 phys_addrs[15];
 	u32 sequence;
 
-	char input_name[32];
+	char device_name[32];
 	char input_phys[32];
 	char input_drv[32];
 };
diff --git a/include/media/rc-core.h b/include/media/rc-core.h
index 78dea39..16bd89c 100644
--- a/include/media/rc-core.h
+++ b/include/media/rc-core.h
@@ -72,7 +72,7 @@ enum rc_filter_type {
  * @dev: driver model's view of this device
  * @managed_alloc: devm_rc_allocate_device was used to create rc_dev
  * @sysfs_groups: sysfs attribute groups
- * @input_name: name of the input child device
+ * @device_name: name of the rc child device
  * @input_phys: physical path to the input child device
  * @input_id: id of the input child device (struct input_id)
  * @driver_name: name of the hardware driver which registered this device
@@ -138,10 +138,10 @@ struct rc_dev {
 	struct device			dev;
 	bool				managed_alloc;
 	const struct attribute_group	*sysfs_groups[5];
-	const char			*input_name;
+	const char			*device_name;
 	const char			*input_phys;
 	struct input_id			input_id;
-	char				*driver_name;
+	const char			*driver_name;
 	const char			*map_name;
 	struct rc_map			rc_map;
 	struct mutex			lock;
-- 
2.9.4
