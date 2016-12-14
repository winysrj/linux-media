Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:44279 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753821AbcLNOAu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Dec 2016 09:00:50 -0500
From: Andi Shyti <andi.shyti@samsung.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Sean Young <sean@mess.org>, Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        Jacek Anaszewski <j.anaszewski@samsung.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-leds@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andi Shyti <andi.shyti@samsung.com>,
        Andi Shyti <andi@etezian.org>
Subject: [PATCH v4 1/6] [media] rc-main: assign driver type during allocation
Date: Wed, 14 Dec 2016 23:00:25 +0900
Message-id: <20161214140030.28537-2-andi.shyti@samsung.com>
In-reply-to: <20161214140030.28537-1-andi.shyti@samsung.com>
References: <20161214140030.28537-1-andi.shyti@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The driver type can be assigned immediately when an RC device
requests to the framework to allocate the device.

This is an 'enum rc_driver_type' data type and specifies whether
the device is a raw receiver or scancode receiver. The type will
be given as parameter to the rc_allocate_device device.

Change accordingly all the drivers calling rc_allocate_device()
so that the device type is specified during the rc device
allocation. Whenever the device type is not specified, it will be
set as RC_DRIVER_SCANCODE which was the default '0' value.

Suggested-by: Sean Young <sean@mess.org>
Signed-off-by: Andi Shyti <andi.shyti@samsung.com>
Reviewed-by: Sean Young <sean@mess.org>
---
 drivers/hid/hid-picolcd_cir.c               |  3 +--
 drivers/media/cec/cec-core.c                |  3 +--
 drivers/media/common/siano/smsir.c          |  3 +--
 drivers/media/i2c/ir-kbd-i2c.c              |  2 +-
 drivers/media/pci/bt8xx/bttv-input.c        |  2 +-
 drivers/media/pci/cx23885/cx23885-input.c   | 11 +----------
 drivers/media/pci/cx88/cx88-input.c         |  3 +--
 drivers/media/pci/dm1105/dm1105.c           |  3 +--
 drivers/media/pci/mantis/mantis_input.c     |  2 +-
 drivers/media/pci/saa7134/saa7134-input.c   |  2 +-
 drivers/media/pci/smipcie/smipcie-ir.c      |  3 +--
 drivers/media/pci/ttpci/budget-ci.c         |  2 +-
 drivers/media/rc/ati_remote.c               |  3 +--
 drivers/media/rc/ene_ir.c                   |  3 +--
 drivers/media/rc/fintek-cir.c               |  3 +--
 drivers/media/rc/gpio-ir-recv.c             |  3 +--
 drivers/media/rc/igorplugusb.c              |  3 +--
 drivers/media/rc/iguanair.c                 |  3 +--
 drivers/media/rc/img-ir/img-ir-hw.c         |  2 +-
 drivers/media/rc/img-ir/img-ir-raw.c        |  3 +--
 drivers/media/rc/imon.c                     |  3 +--
 drivers/media/rc/ir-hix5hd2.c               |  3 +--
 drivers/media/rc/ite-cir.c                  |  3 +--
 drivers/media/rc/mceusb.c                   |  3 +--
 drivers/media/rc/meson-ir.c                 |  3 +--
 drivers/media/rc/nuvoton-cir.c              |  3 +--
 drivers/media/rc/rc-loopback.c              |  3 +--
 drivers/media/rc/rc-main.c                  |  9 ++++++---
 drivers/media/rc/redrat3.c                  |  3 +--
 drivers/media/rc/serial_ir.c                |  3 +--
 drivers/media/rc/st_rc.c                    |  3 +--
 drivers/media/rc/streamzap.c                |  3 +--
 drivers/media/rc/sunxi-cir.c                |  3 +--
 drivers/media/rc/ttusbir.c                  |  3 +--
 drivers/media/rc/winbond-cir.c              |  3 +--
 drivers/media/usb/au0828/au0828-input.c     |  3 +--
 drivers/media/usb/cx231xx/cx231xx-input.c   |  2 +-
 drivers/media/usb/dvb-usb-v2/dvb_usb_core.c |  3 +--
 drivers/media/usb/dvb-usb/dvb-usb-remote.c  |  3 +--
 drivers/media/usb/em28xx/em28xx-input.c     |  2 +-
 drivers/media/usb/tm6000/tm6000-input.c     |  3 +--
 include/media/rc-core.h                     |  6 ++++--
 42 files changed, 50 insertions(+), 85 deletions(-)

diff --git a/drivers/hid/hid-picolcd_cir.c b/drivers/hid/hid-picolcd_cir.c
index 9628651..38b0ea8 100644
--- a/drivers/hid/hid-picolcd_cir.c
+++ b/drivers/hid/hid-picolcd_cir.c
@@ -108,12 +108,11 @@ int picolcd_init_cir(struct picolcd_data *data, struct hid_report *report)
 	struct rc_dev *rdev;
 	int ret = 0;
 
-	rdev = rc_allocate_device();
+	rdev = rc_allocate_device(RC_DRIVER_IR_RAW);
 	if (!rdev)
 		return -ENOMEM;
 
 	rdev->priv             = data;
-	rdev->driver_type      = RC_DRIVER_IR_RAW;
 	rdev->allowed_protocols = RC_BIT_ALL;
 	rdev->open             = picolcd_cir_open;
 	rdev->close            = picolcd_cir_close;
diff --git a/drivers/media/cec/cec-core.c b/drivers/media/cec/cec-core.c
index b0137e2..09bc0ba 100644
--- a/drivers/media/cec/cec-core.c
+++ b/drivers/media/cec/cec-core.c
@@ -244,7 +244,7 @@ struct cec_adapter *cec_allocate_adapter(const struct cec_adap_ops *ops,
 
 #if IS_REACHABLE(CONFIG_RC_CORE)
 	/* Prepare the RC input device */
-	adap->rc = rc_allocate_device();
+	adap->rc = rc_allocate_device(RC_DRIVER_SCANCODE);
 	if (!adap->rc) {
 		pr_err("cec-%s: failed to allocate memory for rc_dev\n",
 		       name);
@@ -265,7 +265,6 @@ struct cec_adapter *cec_allocate_adapter(const struct cec_adap_ops *ops,
 	adap->rc->input_id.product = 0;
 	adap->rc->input_id.version = 1;
 	adap->rc->dev.parent = parent;
-	adap->rc->driver_type = RC_DRIVER_SCANCODE;
 	adap->rc->driver_name = CEC_NAME;
 	adap->rc->allowed_protocols = RC_BIT_CEC;
 	adap->rc->priv = adap;
diff --git a/drivers/media/common/siano/smsir.c b/drivers/media/common/siano/smsir.c
index 41f2a39..ee30c7b 100644
--- a/drivers/media/common/siano/smsir.c
+++ b/drivers/media/common/siano/smsir.c
@@ -58,7 +58,7 @@ int sms_ir_init(struct smscore_device_t *coredev)
 	struct rc_dev *dev;
 
 	pr_debug("Allocating rc device\n");
-	dev = rc_allocate_device();
+	dev = rc_allocate_device(RC_DRIVER_IR_RAW);
 	if (!dev)
 		return -ENOMEM;
 
@@ -86,7 +86,6 @@ int sms_ir_init(struct smscore_device_t *coredev)
 #endif
 
 	dev->priv = coredev;
-	dev->driver_type = RC_DRIVER_IR_RAW;
 	dev->allowed_protocols = RC_BIT_ALL;
 	dev->map_name = sms_get_board(board_id)->rc_codes;
 	dev->driver_name = MODULE_NAME;
diff --git a/drivers/media/i2c/ir-kbd-i2c.c b/drivers/media/i2c/ir-kbd-i2c.c
index cede397..5ad5167 100644
--- a/drivers/media/i2c/ir-kbd-i2c.c
+++ b/drivers/media/i2c/ir-kbd-i2c.c
@@ -428,7 +428,7 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 		 * If platform_data doesn't specify rc_dev, initialize it
 		 * internally
 		 */
-		rc = rc_allocate_device();
+		rc = rc_allocate_device(RC_DRIVER_SCANCODE);
 		if (!rc)
 			return -ENOMEM;
 	}
diff --git a/drivers/media/pci/bt8xx/bttv-input.c b/drivers/media/pci/bt8xx/bttv-input.c
index 4da720e..76daec7 100644
--- a/drivers/media/pci/bt8xx/bttv-input.c
+++ b/drivers/media/pci/bt8xx/bttv-input.c
@@ -424,7 +424,7 @@ int bttv_input_init(struct bttv *btv)
 		return -ENODEV;
 
 	ir = kzalloc(sizeof(*ir),GFP_KERNEL);
-	rc = rc_allocate_device();
+	rc = rc_allocate_device(RC_DRIVER_SCANCODE);
 	if (!ir || !rc)
 		goto err_out_free;
 
diff --git a/drivers/media/pci/cx23885/cx23885-input.c b/drivers/media/pci/cx23885/cx23885-input.c
index 1f092fe..c743317 100644
--- a/drivers/media/pci/cx23885/cx23885-input.c
+++ b/drivers/media/pci/cx23885/cx23885-input.c
@@ -267,7 +267,6 @@ int cx23885_input_init(struct cx23885_dev *dev)
 	struct cx23885_kernel_ir *kernel_ir;
 	struct rc_dev *rc;
 	char *rc_map;
-	enum rc_driver_type driver_type;
 	u64 allowed_protos;
 
 	int ret;
@@ -285,28 +284,24 @@ int cx23885_input_init(struct cx23885_dev *dev)
 	case CX23885_BOARD_HAUPPAUGE_HVR1290:
 	case CX23885_BOARD_HAUPPAUGE_HVR1250:
 		/* Integrated CX2388[58] IR controller */
-		driver_type = RC_DRIVER_IR_RAW;
 		allowed_protos = RC_BIT_ALL;
 		/* The grey Hauppauge RC-5 remote */
 		rc_map = RC_MAP_HAUPPAUGE;
 		break;
 	case CX23885_BOARD_TERRATEC_CINERGY_T_PCIE_DUAL:
 		/* Integrated CX23885 IR controller */
-		driver_type = RC_DRIVER_IR_RAW;
 		allowed_protos = RC_BIT_ALL;
 		/* The grey Terratec remote with orange buttons */
 		rc_map = RC_MAP_NEC_TERRATEC_CINERGY_XS;
 		break;
 	case CX23885_BOARD_TEVII_S470:
 		/* Integrated CX23885 IR controller */
-		driver_type = RC_DRIVER_IR_RAW;
 		allowed_protos = RC_BIT_ALL;
 		/* A guess at the remote */
 		rc_map = RC_MAP_TEVII_NEC;
 		break;
 	case CX23885_BOARD_MYGICA_X8507:
 		/* Integrated CX23885 IR controller */
-		driver_type = RC_DRIVER_IR_RAW;
 		allowed_protos = RC_BIT_ALL;
 		/* A guess at the remote */
 		rc_map = RC_MAP_TOTAL_MEDIA_IN_HAND_02;
@@ -314,7 +309,6 @@ int cx23885_input_init(struct cx23885_dev *dev)
 	case CX23885_BOARD_TBS_6980:
 	case CX23885_BOARD_TBS_6981:
 		/* Integrated CX23885 IR controller */
-		driver_type = RC_DRIVER_IR_RAW;
 		allowed_protos = RC_BIT_ALL;
 		/* A guess at the remote */
 		rc_map = RC_MAP_TBS_NEC;
@@ -326,13 +320,11 @@ int cx23885_input_init(struct cx23885_dev *dev)
 	case CX23885_BOARD_DVBSKY_S952:
 	case CX23885_BOARD_DVBSKY_T982:
 		/* Integrated CX23885 IR controller */
-		driver_type = RC_DRIVER_IR_RAW;
 		allowed_protos = RC_BIT_ALL;
 		rc_map = RC_MAP_DVBSKY;
 		break;
 	case CX23885_BOARD_TT_CT2_4500_CI:
 		/* Integrated CX23885 IR controller */
-		driver_type = RC_DRIVER_IR_RAW;
 		allowed_protos = RC_BIT_ALL;
 		rc_map = RC_MAP_TT_1500;
 		break;
@@ -352,7 +344,7 @@ int cx23885_input_init(struct cx23885_dev *dev)
 				    pci_name(dev->pci));
 
 	/* input device */
-	rc = rc_allocate_device();
+	rc = rc_allocate_device(RC_DRIVER_IR_RAW);
 	if (!rc) {
 		ret = -ENOMEM;
 		goto err_out_free;
@@ -371,7 +363,6 @@ int cx23885_input_init(struct cx23885_dev *dev)
 		rc->input_id.product = dev->pci->device;
 	}
 	rc->dev.parent = &dev->pci->dev;
-	rc->driver_type = driver_type;
 	rc->allowed_protocols = allowed_protos;
 	rc->priv = kernel_ir;
 	rc->open = cx23885_input_ir_open;
diff --git a/drivers/media/pci/cx88/cx88-input.c b/drivers/media/pci/cx88/cx88-input.c
index dcfea35..6e9f366e 100644
--- a/drivers/media/pci/cx88/cx88-input.c
+++ b/drivers/media/pci/cx88/cx88-input.c
@@ -276,7 +276,7 @@ int cx88_ir_init(struct cx88_core *core, struct pci_dev *pci)
 				 */
 
 	ir = kzalloc(sizeof(*ir), GFP_KERNEL);
-	dev = rc_allocate_device();
+	dev = rc_allocate_device(RC_DRIVER_IR_RAW);
 	if (!ir || !dev)
 		goto err_out_free;
 
@@ -486,7 +486,6 @@ int cx88_ir_init(struct cx88_core *core, struct pci_dev *pci)
 	dev->scancode_mask = hardware_mask;
 
 	if (ir->sampling) {
-		dev->driver_type = RC_DRIVER_IR_RAW;
 		dev->timeout = 10 * 1000 * 1000; /* 10 ms */
 	} else {
 		dev->driver_type = RC_DRIVER_SCANCODE;
diff --git a/drivers/media/pci/dm1105/dm1105.c b/drivers/media/pci/dm1105/dm1105.c
index a589aa7..76e07c7 100644
--- a/drivers/media/pci/dm1105/dm1105.c
+++ b/drivers/media/pci/dm1105/dm1105.c
@@ -743,7 +743,7 @@ static int dm1105_ir_init(struct dm1105_dev *dm1105)
 	struct rc_dev *dev;
 	int err = -ENOMEM;
 
-	dev = rc_allocate_device();
+	dev = rc_allocate_device(RC_DRIVER_SCANCODE);
 	if (!dev)
 		return -ENOMEM;
 
@@ -752,7 +752,6 @@ static int dm1105_ir_init(struct dm1105_dev *dm1105)
 
 	dev->driver_name = MODULE_NAME;
 	dev->map_name = RC_MAP_DM1105_NEC;
-	dev->driver_type = RC_DRIVER_SCANCODE;
 	dev->input_name = "DVB on-card IR receiver";
 	dev->input_phys = dm1105->ir.input_phys;
 	dev->input_id.bustype = BUS_PCI;
diff --git a/drivers/media/pci/mantis/mantis_input.c b/drivers/media/pci/mantis/mantis_input.c
index 7f7f1d4..50d10cb 100644
--- a/drivers/media/pci/mantis/mantis_input.c
+++ b/drivers/media/pci/mantis/mantis_input.c
@@ -39,7 +39,7 @@ int mantis_input_init(struct mantis_pci *mantis)
 	struct rc_dev *dev;
 	int err;
 
-	dev = rc_allocate_device();
+	dev = rc_allocate_device(RC_DRIVER_SCANCODE);
 	if (!dev) {
 		dprintk(MANTIS_ERROR, 1, "Remote device allocation failed");
 		err = -ENOMEM;
diff --git a/drivers/media/pci/saa7134/saa7134-input.c b/drivers/media/pci/saa7134/saa7134-input.c
index 823b75e..509caa86 100644
--- a/drivers/media/pci/saa7134/saa7134-input.c
+++ b/drivers/media/pci/saa7134/saa7134-input.c
@@ -846,7 +846,7 @@ int saa7134_input_init1(struct saa7134_dev *dev)
 	}
 
 	ir = kzalloc(sizeof(*ir), GFP_KERNEL);
-	rc = rc_allocate_device();
+	rc = rc_allocate_device(RC_DRIVER_SCANCODE);
 	if (!ir || !rc) {
 		err = -ENOMEM;
 		goto err_out_free;
diff --git a/drivers/media/pci/smipcie/smipcie-ir.c b/drivers/media/pci/smipcie/smipcie-ir.c
index 826c7c7..d2730c3 100644
--- a/drivers/media/pci/smipcie/smipcie-ir.c
+++ b/drivers/media/pci/smipcie/smipcie-ir.c
@@ -183,7 +183,7 @@ int smi_ir_init(struct smi_dev *dev)
 	struct rc_dev *rc_dev;
 	struct smi_rc *ir = &dev->ir;
 
-	rc_dev = rc_allocate_device();
+	rc_dev = rc_allocate_device(RC_DRIVER_SCANCODE);
 	if (!rc_dev)
 		return -ENOMEM;
 
@@ -202,7 +202,6 @@ int smi_ir_init(struct smi_dev *dev)
 	rc_dev->input_id.product = dev->pci_dev->subsystem_device;
 	rc_dev->dev.parent = &dev->pci_dev->dev;
 
-	rc_dev->driver_type = RC_DRIVER_SCANCODE;
 	rc_dev->map_name = dev->info->rc_map;
 
 	ir->rc_dev = rc_dev;
diff --git a/drivers/media/pci/ttpci/budget-ci.c b/drivers/media/pci/ttpci/budget-ci.c
index 20ad93b..0c0b733 100644
--- a/drivers/media/pci/ttpci/budget-ci.c
+++ b/drivers/media/pci/ttpci/budget-ci.c
@@ -177,7 +177,7 @@ static int msp430_ir_init(struct budget_ci *budget_ci)
 	struct rc_dev *dev;
 	int error;
 
-	dev = rc_allocate_device();
+	dev = rc_allocate_device(RC_DRIVER_SCANCODE);
 	if (!dev) {
 		printk(KERN_ERR "budget_ci: IR interface initialisation failed\n");
 		return -ENOMEM;
diff --git a/drivers/media/rc/ati_remote.c b/drivers/media/rc/ati_remote.c
index 0884b7d..7d0ee3d 100644
--- a/drivers/media/rc/ati_remote.c
+++ b/drivers/media/rc/ati_remote.c
@@ -764,7 +764,6 @@ static void ati_remote_rc_init(struct ati_remote *ati_remote)
 	struct rc_dev *rdev = ati_remote->rdev;
 
 	rdev->priv = ati_remote;
-	rdev->driver_type = RC_DRIVER_SCANCODE;
 	rdev->allowed_protocols = RC_BIT_OTHER;
 	rdev->driver_name = "ati_remote";
 
@@ -851,7 +850,7 @@ static int ati_remote_probe(struct usb_interface *interface,
 	}
 
 	ati_remote = kzalloc(sizeof (struct ati_remote), GFP_KERNEL);
-	rc_dev = rc_allocate_device();
+	rc_dev = rc_allocate_device(RC_DRIVER_SCANCODE);
 	if (!ati_remote || !rc_dev)
 		goto exit_free_dev_rdev;
 
diff --git a/drivers/media/rc/ene_ir.c b/drivers/media/rc/ene_ir.c
index bd5512e..3b7275f 100644
--- a/drivers/media/rc/ene_ir.c
+++ b/drivers/media/rc/ene_ir.c
@@ -1012,7 +1012,7 @@ static int ene_probe(struct pnp_dev *pnp_dev, const struct pnp_device_id *id)
 
 	/* allocate memory */
 	dev = kzalloc(sizeof(struct ene_device), GFP_KERNEL);
-	rdev = rc_allocate_device();
+	rdev = rc_allocate_device(RC_DRIVER_IR_RAW);
 	if (!dev || !rdev)
 		goto exit_free_dev_rdev;
 
@@ -1058,7 +1058,6 @@ static int ene_probe(struct pnp_dev *pnp_dev, const struct pnp_device_id *id)
 	if (!dev->hw_learning_and_tx_capable)
 		learning_mode_force = false;
 
-	rdev->driver_type = RC_DRIVER_IR_RAW;
 	rdev->allowed_protocols = RC_BIT_ALL;
 	rdev->priv = dev;
 	rdev->open = ene_open;
diff --git a/drivers/media/rc/fintek-cir.c b/drivers/media/rc/fintek-cir.c
index ecab69e..df125c2 100644
--- a/drivers/media/rc/fintek-cir.c
+++ b/drivers/media/rc/fintek-cir.c
@@ -492,7 +492,7 @@ static int fintek_probe(struct pnp_dev *pdev, const struct pnp_device_id *dev_id
 		return ret;
 
 	/* input device for IR remote (and tx) */
-	rdev = rc_allocate_device();
+	rdev = rc_allocate_device(RC_DRIVER_IR_RAW);
 	if (!rdev)
 		goto exit_free_dev_rdev;
 
@@ -534,7 +534,6 @@ static int fintek_probe(struct pnp_dev *pdev, const struct pnp_device_id *dev_id
 
 	/* Set up the rc device */
 	rdev->priv = fintek;
-	rdev->driver_type = RC_DRIVER_IR_RAW;
 	rdev->allowed_protocols = RC_BIT_ALL;
 	rdev->open = fintek_open;
 	rdev->close = fintek_close;
diff --git a/drivers/media/rc/gpio-ir-recv.c b/drivers/media/rc/gpio-ir-recv.c
index 5b63b1f..d5d2152 100644
--- a/drivers/media/rc/gpio-ir-recv.c
+++ b/drivers/media/rc/gpio-ir-recv.c
@@ -143,14 +143,13 @@ static int gpio_ir_recv_probe(struct platform_device *pdev)
 	if (!gpio_dev)
 		return -ENOMEM;
 
-	rcdev = rc_allocate_device();
+	rcdev = rc_allocate_device(RC_DRIVER_IR_RAW);
 	if (!rcdev) {
 		rc = -ENOMEM;
 		goto err_allocate_device;
 	}
 
 	rcdev->priv = gpio_dev;
-	rcdev->driver_type = RC_DRIVER_IR_RAW;
 	rcdev->input_name = GPIO_IR_DEVICE_NAME;
 	rcdev->input_phys = GPIO_IR_DEVICE_NAME "/input0";
 	rcdev->input_id.bustype = BUS_HOST;
diff --git a/drivers/media/rc/igorplugusb.c b/drivers/media/rc/igorplugusb.c
index 5cf983b..d770a62 100644
--- a/drivers/media/rc/igorplugusb.c
+++ b/drivers/media/rc/igorplugusb.c
@@ -190,7 +190,7 @@ static int igorplugusb_probe(struct usb_interface *intf,
 
 	usb_make_path(udev, ir->phys, sizeof(ir->phys));
 
-	rc = rc_allocate_device();
+	rc = rc_allocate_device(RC_DRIVER_IR_RAW);
 	if (!rc)
 		goto fail;
 
@@ -198,7 +198,6 @@ static int igorplugusb_probe(struct usb_interface *intf,
 	rc->input_phys = ir->phys;
 	usb_to_input_id(udev, &rc->input_id);
 	rc->dev.parent = &intf->dev;
-	rc->driver_type = RC_DRIVER_IR_RAW;
 	/*
 	 * This device can only store 36 pulses + spaces, which is not enough
 	 * for the NEC protocol and many others.
diff --git a/drivers/media/rc/iguanair.c b/drivers/media/rc/iguanair.c
index 5f63454..4cd1e6b 100644
--- a/drivers/media/rc/iguanair.c
+++ b/drivers/media/rc/iguanair.c
@@ -431,7 +431,7 @@ static int iguanair_probe(struct usb_interface *intf,
 	struct usb_host_interface *idesc;
 
 	ir = kzalloc(sizeof(*ir), GFP_KERNEL);
-	rc = rc_allocate_device();
+	rc = rc_allocate_device(RC_DRIVER_IR_RAW);
 	if (!ir || !rc) {
 		ret = -ENOMEM;
 		goto out;
@@ -494,7 +494,6 @@ static int iguanair_probe(struct usb_interface *intf,
 	rc->input_phys = ir->phys;
 	usb_to_input_id(ir->udev, &rc->input_id);
 	rc->dev.parent = &intf->dev;
-	rc->driver_type = RC_DRIVER_IR_RAW;
 	rc->allowed_protocols = RC_BIT_ALL;
 	rc->priv = ir;
 	rc->open = iguanair_open;
diff --git a/drivers/media/rc/img-ir/img-ir-hw.c b/drivers/media/rc/img-ir/img-ir-hw.c
index 7bb71bc..c87ae03 100644
--- a/drivers/media/rc/img-ir/img-ir-hw.c
+++ b/drivers/media/rc/img-ir/img-ir-hw.c
@@ -1071,7 +1071,7 @@ int img_ir_probe_hw(struct img_ir_priv *priv)
 	}
 
 	/* Allocate hardware decoder */
-	hw->rdev = rdev = rc_allocate_device();
+	hw->rdev = rdev = rc_allocate_device(RC_DRIVER_SCANCODE);
 	if (!rdev) {
 		dev_err(priv->dev, "cannot allocate input device\n");
 		error = -ENOMEM;
diff --git a/drivers/media/rc/img-ir/img-ir-raw.c b/drivers/media/rc/img-ir/img-ir-raw.c
index 33f37ed..8d2f8e2 100644
--- a/drivers/media/rc/img-ir/img-ir-raw.c
+++ b/drivers/media/rc/img-ir/img-ir-raw.c
@@ -110,7 +110,7 @@ int img_ir_probe_raw(struct img_ir_priv *priv)
 	setup_timer(&raw->timer, img_ir_echo_timer, (unsigned long)priv);
 
 	/* Allocate raw decoder */
-	raw->rdev = rdev = rc_allocate_device();
+	raw->rdev = rdev = rc_allocate_device(RC_DRIVER_IR_RAW);
 	if (!rdev) {
 		dev_err(priv->dev, "cannot allocate raw input device\n");
 		return -ENOMEM;
@@ -118,7 +118,6 @@ int img_ir_probe_raw(struct img_ir_priv *priv)
 	rdev->priv = priv;
 	rdev->map_name = RC_MAP_EMPTY;
 	rdev->input_name = "IMG Infrared Decoder Raw";
-	rdev->driver_type = RC_DRIVER_IR_RAW;
 
 	/* Register raw decoder */
 	error = rc_register_device(rdev);
diff --git a/drivers/media/rc/imon.c b/drivers/media/rc/imon.c
index 0785a24..4234ae6 100644
--- a/drivers/media/rc/imon.c
+++ b/drivers/media/rc/imon.c
@@ -1939,7 +1939,7 @@ static struct rc_dev *imon_init_rdev(struct imon_context *ictx)
 	const unsigned char fp_packet[] = { 0x40, 0x00, 0x00, 0x00,
 					    0x00, 0x00, 0x00, 0x88 };
 
-	rdev = rc_allocate_device();
+	rdev = rc_allocate_device(RC_DRIVER_SCANCODE);
 	if (!rdev) {
 		dev_err(ictx->dev, "remote control dev allocation failed\n");
 		goto out;
@@ -1957,7 +1957,6 @@ static struct rc_dev *imon_init_rdev(struct imon_context *ictx)
 	rdev->dev.parent = ictx->dev;
 
 	rdev->priv = ictx;
-	rdev->driver_type = RC_DRIVER_SCANCODE;
 	rdev->allowed_protocols = RC_BIT_OTHER | RC_BIT_RC6_MCE; /* iMON PAD or MCE */
 	rdev->change_protocol = imon_ir_change_protocol;
 	rdev->driver_name = MOD_NAME;
diff --git a/drivers/media/rc/ir-hix5hd2.c b/drivers/media/rc/ir-hix5hd2.c
index d26907e..dc3b959 100644
--- a/drivers/media/rc/ir-hix5hd2.c
+++ b/drivers/media/rc/ir-hix5hd2.c
@@ -229,7 +229,7 @@ static int hix5hd2_ir_probe(struct platform_device *pdev)
 		return priv->irq;
 	}
 
-	rdev = rc_allocate_device();
+	rdev = rc_allocate_device(RC_DRIVER_IR_RAW);
 	if (!rdev)
 		return -ENOMEM;
 
@@ -242,7 +242,6 @@ static int hix5hd2_ir_probe(struct platform_device *pdev)
 	clk_prepare_enable(priv->clock);
 	priv->rate = clk_get_rate(priv->clock);
 
-	rdev->driver_type = RC_DRIVER_IR_RAW;
 	rdev->allowed_protocols = RC_BIT_ALL;
 	rdev->priv = priv;
 	rdev->open = hix5hd2_ir_open;
diff --git a/drivers/media/rc/ite-cir.c b/drivers/media/rc/ite-cir.c
index 367b28b..92ed356 100644
--- a/drivers/media/rc/ite-cir.c
+++ b/drivers/media/rc/ite-cir.c
@@ -1470,7 +1470,7 @@ static int ite_probe(struct pnp_dev *pdev, const struct pnp_device_id
 		return ret;
 
 	/* input device for IR remote (and tx) */
-	rdev = rc_allocate_device();
+	rdev = rc_allocate_device(RC_DRIVER_IR_RAW);
 	if (!rdev)
 		goto exit_free_dev_rdev;
 	itdev->rdev = rdev;
@@ -1561,7 +1561,6 @@ static int ite_probe(struct pnp_dev *pdev, const struct pnp_device_id
 
 	/* set up ir-core props */
 	rdev->priv = itdev;
-	rdev->driver_type = RC_DRIVER_IR_RAW;
 	rdev->allowed_protocols = RC_BIT_ALL;
 	rdev->open = ite_open;
 	rdev->close = ite_close;
diff --git a/drivers/media/rc/mceusb.c b/drivers/media/rc/mceusb.c
index 9bf6917..ebcc82d 100644
--- a/drivers/media/rc/mceusb.c
+++ b/drivers/media/rc/mceusb.c
@@ -1181,7 +1181,7 @@ static struct rc_dev *mceusb_init_rc_dev(struct mceusb_dev *ir)
 	struct rc_dev *rc;
 	int ret;
 
-	rc = rc_allocate_device();
+	rc = rc_allocate_device(RC_DRIVER_IR_RAW);
 	if (!rc) {
 		dev_err(dev, "remote dev allocation failed");
 		goto out;
@@ -1201,7 +1201,6 @@ static struct rc_dev *mceusb_init_rc_dev(struct mceusb_dev *ir)
 	usb_to_input_id(ir->usbdev, &rc->input_id);
 	rc->dev.parent = dev;
 	rc->priv = ir;
-	rc->driver_type = RC_DRIVER_IR_RAW;
 	rc->allowed_protocols = RC_BIT_ALL;
 	rc->timeout = MS_TO_NS(100);
 	if (!ir->flags.no_tx) {
diff --git a/drivers/media/rc/meson-ir.c b/drivers/media/rc/meson-ir.c
index 7eb3f4f..8947dc6 100644
--- a/drivers/media/rc/meson-ir.c
+++ b/drivers/media/rc/meson-ir.c
@@ -131,7 +131,7 @@ static int meson_ir_probe(struct platform_device *pdev)
 		return ir->irq;
 	}
 
-	ir->rc = rc_allocate_device();
+	ir->rc = rc_allocate_device(RC_DRIVER_IR_RAW);
 	if (!ir->rc) {
 		dev_err(dev, "failed to allocate rc device\n");
 		return -ENOMEM;
@@ -144,7 +144,6 @@ static int meson_ir_probe(struct platform_device *pdev)
 	map_name = of_get_property(node, "linux,rc-map-name", NULL);
 	ir->rc->map_name = map_name ? map_name : RC_MAP_EMPTY;
 	ir->rc->dev.parent = dev;
-	ir->rc->driver_type = RC_DRIVER_IR_RAW;
 	ir->rc->allowed_protocols = RC_BIT_ALL;
 	ir->rc->rx_resolution = US_TO_NS(MESON_TRATE);
 	ir->rc->timeout = MS_TO_NS(200);
diff --git a/drivers/media/rc/nuvoton-cir.c b/drivers/media/rc/nuvoton-cir.c
index 4b78c89..d4cc880 100644
--- a/drivers/media/rc/nuvoton-cir.c
+++ b/drivers/media/rc/nuvoton-cir.c
@@ -998,7 +998,7 @@ static int nvt_probe(struct pnp_dev *pdev, const struct pnp_device_id *dev_id)
 		return -ENOMEM;
 
 	/* input device for IR remote (and tx) */
-	nvt->rdev = devm_rc_allocate_device(&pdev->dev);
+	nvt->rdev = devm_rc_allocate_device(&pdev->dev, RC_DRIVER_IR_RAW);
 	if (!nvt->rdev)
 		return -ENOMEM;
 	rdev = nvt->rdev;
@@ -1061,7 +1061,6 @@ static int nvt_probe(struct pnp_dev *pdev, const struct pnp_device_id *dev_id)
 
 	/* Set up the rc device */
 	rdev->priv = nvt;
-	rdev->driver_type = RC_DRIVER_IR_RAW;
 	rdev->allowed_protocols = RC_BIT_ALL;
 	rdev->open = nvt_open;
 	rdev->close = nvt_close;
diff --git a/drivers/media/rc/rc-loopback.c b/drivers/media/rc/rc-loopback.c
index 63dace8..36192ac 100644
--- a/drivers/media/rc/rc-loopback.c
+++ b/drivers/media/rc/rc-loopback.c
@@ -181,7 +181,7 @@ static int __init loop_init(void)
 	struct rc_dev *rc;
 	int ret;
 
-	rc = rc_allocate_device();
+	rc = rc_allocate_device(RC_DRIVER_IR_RAW);
 	if (!rc) {
 		printk(KERN_ERR DRIVER_NAME ": rc_dev allocation failed\n");
 		return -ENOMEM;
@@ -194,7 +194,6 @@ static int __init loop_init(void)
 	rc->driver_name		= DRIVER_NAME;
 	rc->map_name		= RC_MAP_EMPTY;
 	rc->priv		= &loopdev;
-	rc->driver_type		= RC_DRIVER_IR_RAW;
 	rc->allowed_protocols	= RC_BIT_ALL;
 	rc->timeout		= 100 * 1000 * 1000; /* 100 ms */
 	rc->min_timeout		= 1;
diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index dedaf38..a6bbceb 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -1357,7 +1357,7 @@ static struct device_type rc_dev_type = {
 	.uevent		= rc_dev_uevent,
 };
 
-struct rc_dev *rc_allocate_device(void)
+struct rc_dev *rc_allocate_device(enum rc_driver_type type)
 {
 	struct rc_dev *dev;
 
@@ -1384,6 +1384,8 @@ struct rc_dev *rc_allocate_device(void)
 	dev->dev.class = &rc_class;
 	device_initialize(&dev->dev);
 
+	dev->driver_type = type;
+
 	__module_get(THIS_MODULE);
 	return dev;
 }
@@ -1410,7 +1412,8 @@ static void devm_rc_alloc_release(struct device *dev, void *res)
 	rc_free_device(*(struct rc_dev **)res);
 }
 
-struct rc_dev *devm_rc_allocate_device(struct device *dev)
+struct rc_dev *devm_rc_allocate_device(struct device *dev,
+					enum rc_driver_type type)
 {
 	struct rc_dev **dr, *rc;
 
@@ -1418,7 +1421,7 @@ struct rc_dev *devm_rc_allocate_device(struct device *dev)
 	if (!dr)
 		return NULL;
 
-	rc = rc_allocate_device();
+	rc = rc_allocate_device(type);
 	if (!rc) {
 		devres_free(dr);
 		return NULL;
diff --git a/drivers/media/rc/redrat3.c b/drivers/media/rc/redrat3.c
index 2784f5d..2b6f828 100644
--- a/drivers/media/rc/redrat3.c
+++ b/drivers/media/rc/redrat3.c
@@ -945,7 +945,7 @@ static struct rc_dev *redrat3_init_rc_dev(struct redrat3_dev *rr3)
 	int ret;
 	u16 prod = le16_to_cpu(rr3->udev->descriptor.idProduct);
 
-	rc = rc_allocate_device();
+	rc = rc_allocate_device(RC_DRIVER_IR_RAW);
 	if (!rc)
 		return NULL;
 
@@ -960,7 +960,6 @@ static struct rc_dev *redrat3_init_rc_dev(struct redrat3_dev *rr3)
 	usb_to_input_id(rr3->udev, &rc->input_id);
 	rc->dev.parent = dev;
 	rc->priv = rr3;
-	rc->driver_type = RC_DRIVER_IR_RAW;
 	rc->allowed_protocols = RC_BIT_ALL;
 	rc->min_timeout = MS_TO_NS(RR3_RX_MIN_TIMEOUT);
 	rc->max_timeout = MS_TO_NS(RR3_RX_MAX_TIMEOUT);
diff --git a/drivers/media/rc/serial_ir.c b/drivers/media/rc/serial_ir.c
index 436bd58..640acc6 100644
--- a/drivers/media/rc/serial_ir.c
+++ b/drivers/media/rc/serial_ir.c
@@ -738,7 +738,7 @@ static int __init serial_ir_init_module(void)
 	if (result)
 		return result;
 
-	rcdev = devm_rc_allocate_device(&serial_ir.pdev->dev);
+	rcdev = devm_rc_allocate_device(&serial_ir.pdev->dev, RC_DRIVER_IR_RAW);
 	if (!rcdev) {
 		result = -ENOMEM;
 		goto serial_cleanup;
@@ -777,7 +777,6 @@ static int __init serial_ir_init_module(void)
 	rcdev->open = serial_ir_open;
 	rcdev->close = serial_ir_close;
 	rcdev->dev.parent = &serial_ir.pdev->dev;
-	rcdev->driver_type = RC_DRIVER_IR_RAW;
 	rcdev->allowed_protocols = RC_BIT_ALL;
 	rcdev->driver_name = KBUILD_MODNAME;
 	rcdev->map_name = RC_MAP_RC6_MCE;
diff --git a/drivers/media/rc/st_rc.c b/drivers/media/rc/st_rc.c
index 1fa0c9d..e6f6735 100644
--- a/drivers/media/rc/st_rc.c
+++ b/drivers/media/rc/st_rc.c
@@ -235,7 +235,7 @@ static int st_rc_probe(struct platform_device *pdev)
 	if (!rc_dev)
 		return -ENOMEM;
 
-	rdev = rc_allocate_device();
+	rdev = rc_allocate_device(RC_DRIVER_IR_RAW);
 
 	if (!rdev)
 		return -ENOMEM;
@@ -290,7 +290,6 @@ static int st_rc_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, rc_dev);
 	st_rc_hardware_init(rc_dev);
 
-	rdev->driver_type = RC_DRIVER_IR_RAW;
 	rdev->allowed_protocols = RC_BIT_ALL;
 	/* rx sampling rate is 10Mhz */
 	rdev->rx_resolution = 100;
diff --git a/drivers/media/rc/streamzap.c b/drivers/media/rc/streamzap.c
index 53f9b0a..f434e45 100644
--- a/drivers/media/rc/streamzap.c
+++ b/drivers/media/rc/streamzap.c
@@ -291,7 +291,7 @@ static struct rc_dev *streamzap_init_rc_dev(struct streamzap_ir *sz)
 	struct device *dev = sz->dev;
 	int ret;
 
-	rdev = rc_allocate_device();
+	rdev = rc_allocate_device(RC_DRIVER_IR_RAW);
 	if (!rdev) {
 		dev_err(dev, "remote dev allocation failed\n");
 		goto out;
@@ -308,7 +308,6 @@ static struct rc_dev *streamzap_init_rc_dev(struct streamzap_ir *sz)
 	usb_to_input_id(sz->usbdev, &rdev->input_id);
 	rdev->dev.parent = dev;
 	rdev->priv = sz;
-	rdev->driver_type = RC_DRIVER_IR_RAW;
 	rdev->allowed_protocols = RC_BIT_ALL;
 	rdev->driver_name = DRIVER_NAME;
 	rdev->map_name = RC_MAP_STREAMZAP;
diff --git a/drivers/media/rc/sunxi-cir.c b/drivers/media/rc/sunxi-cir.c
index eaadc08..5451f3d 100644
--- a/drivers/media/rc/sunxi-cir.c
+++ b/drivers/media/rc/sunxi-cir.c
@@ -212,7 +212,7 @@ static int sunxi_ir_probe(struct platform_device *pdev)
 		goto exit_clkdisable_clk;
 	}
 
-	ir->rc = rc_allocate_device();
+	ir->rc = rc_allocate_device(RC_DRIVER_IR_RAW);
 	if (!ir->rc) {
 		dev_err(dev, "failed to allocate device\n");
 		ret = -ENOMEM;
@@ -229,7 +229,6 @@ static int sunxi_ir_probe(struct platform_device *pdev)
 	ir->map_name = of_get_property(dn, "linux,rc-map-name", NULL);
 	ir->rc->map_name = ir->map_name ?: RC_MAP_EMPTY;
 	ir->rc->dev.parent = dev;
-	ir->rc->driver_type = RC_DRIVER_IR_RAW;
 	ir->rc->allowed_protocols = RC_BIT_ALL;
 	ir->rc->rx_resolution = SUNXI_IR_SAMPLE;
 	ir->rc->timeout = MS_TO_NS(SUNXI_IR_TIMEOUT);
diff --git a/drivers/media/rc/ttusbir.c b/drivers/media/rc/ttusbir.c
index bc214e2..6ff2cef 100644
--- a/drivers/media/rc/ttusbir.c
+++ b/drivers/media/rc/ttusbir.c
@@ -205,7 +205,7 @@ static int ttusbir_probe(struct usb_interface *intf,
 	int altsetting = -1;
 
 	tt = kzalloc(sizeof(*tt), GFP_KERNEL);
-	rc = rc_allocate_device();
+	rc = rc_allocate_device(RC_DRIVER_IR_RAW);
 	if (!tt || !rc) {
 		ret = -ENOMEM;
 		goto out;
@@ -317,7 +317,6 @@ static int ttusbir_probe(struct usb_interface *intf,
 	rc->input_phys = tt->phys;
 	usb_to_input_id(tt->udev, &rc->input_id);
 	rc->dev.parent = &intf->dev;
-	rc->driver_type = RC_DRIVER_IR_RAW;
 	rc->allowed_protocols = RC_BIT_ALL;
 	rc->priv = tt;
 	rc->driver_name = DRIVER_NAME;
diff --git a/drivers/media/rc/winbond-cir.c b/drivers/media/rc/winbond-cir.c
index 78491ed..bc95d22 100644
--- a/drivers/media/rc/winbond-cir.c
+++ b/drivers/media/rc/winbond-cir.c
@@ -1059,13 +1059,12 @@ wbcir_probe(struct pnp_dev *device, const struct pnp_device_id *dev_id)
 	if (err)
 		goto exit_free_data;
 
-	data->dev = rc_allocate_device();
+	data->dev = rc_allocate_device(RC_DRIVER_IR_RAW);
 	if (!data->dev) {
 		err = -ENOMEM;
 		goto exit_unregister_led;
 	}
 
-	data->dev->driver_type = RC_DRIVER_IR_RAW;
 	data->dev->driver_name = DRVNAME;
 	data->dev->input_name = WBCIR_NAME;
 	data->dev->input_phys = "wbcir/cir0";
diff --git a/drivers/media/usb/au0828/au0828-input.c b/drivers/media/usb/au0828/au0828-input.c
index 1e66e78..9ec919c 100644
--- a/drivers/media/usb/au0828/au0828-input.c
+++ b/drivers/media/usb/au0828/au0828-input.c
@@ -298,7 +298,7 @@ int au0828_rc_register(struct au0828_dev *dev)
 		return -ENODEV;
 
 	ir = kzalloc(sizeof(*ir), GFP_KERNEL);
-	rc = rc_allocate_device();
+	rc = rc_allocate_device(RC_DRIVER_IR_RAW);
 	if (!ir || !rc)
 		goto error;
 
@@ -343,7 +343,6 @@ int au0828_rc_register(struct au0828_dev *dev)
 	rc->input_id.product = le16_to_cpu(dev->usbdev->descriptor.idProduct);
 	rc->dev.parent = &dev->usbdev->dev;
 	rc->driver_name = "au0828-input";
-	rc->driver_type = RC_DRIVER_IR_RAW;
 	rc->allowed_protocols = RC_BIT_NEC | RC_BIT_NECX | RC_BIT_NEC32 |
 								RC_BIT_RC5;
 
diff --git a/drivers/media/usb/cx231xx/cx231xx-input.c b/drivers/media/usb/cx231xx/cx231xx-input.c
index 15d8d1b..6e80f3c 100644
--- a/drivers/media/usb/cx231xx/cx231xx-input.c
+++ b/drivers/media/usb/cx231xx/cx231xx-input.c
@@ -72,7 +72,7 @@ int cx231xx_ir_init(struct cx231xx *dev)
 
 	memset(&info, 0, sizeof(struct i2c_board_info));
 	memset(&dev->init_data, 0, sizeof(dev->init_data));
-	dev->init_data.rc_dev = rc_allocate_device();
+	dev->init_data.rc_dev = rc_allocate_device(RC_DRIVER_SCANCODE);
 	if (!dev->init_data.rc_dev)
 		return -ENOMEM;
 
diff --git a/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c b/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
index a8e6624..298c91a 100644
--- a/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
+++ b/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
@@ -147,7 +147,7 @@ static int dvb_usbv2_remote_init(struct dvb_usb_device *d)
 	if (!d->rc.map_name)
 		return 0;
 
-	dev = rc_allocate_device();
+	dev = rc_allocate_device(d->rc.driver_type);
 	if (!dev) {
 		ret = -ENOMEM;
 		goto err;
@@ -162,7 +162,6 @@ static int dvb_usbv2_remote_init(struct dvb_usb_device *d)
 	/* TODO: likely RC-core should took const char * */
 	dev->driver_name = (char *) d->props->driver_name;
 	dev->map_name = d->rc.map_name;
-	dev->driver_type = d->rc.driver_type;
 	dev->allowed_protocols = d->rc.allowed_protos;
 	dev->change_protocol = d->rc.change_protocol;
 	dev->priv = d;
diff --git a/drivers/media/usb/dvb-usb/dvb-usb-remote.c b/drivers/media/usb/dvb-usb/dvb-usb-remote.c
index c259f9e..059ded5 100644
--- a/drivers/media/usb/dvb-usb/dvb-usb-remote.c
+++ b/drivers/media/usb/dvb-usb/dvb-usb-remote.c
@@ -265,7 +265,7 @@ static int rc_core_dvb_usb_remote_init(struct dvb_usb_device *d)
 	int err, rc_interval;
 	struct rc_dev *dev;
 
-	dev = rc_allocate_device();
+	dev = rc_allocate_device(d->props.rc.core.driver_type);
 	if (!dev)
 		return -ENOMEM;
 
@@ -273,7 +273,6 @@ static int rc_core_dvb_usb_remote_init(struct dvb_usb_device *d)
 	dev->map_name = d->props.rc.core.rc_codes;
 	dev->change_protocol = d->props.rc.core.change_protocol;
 	dev->allowed_protocols = d->props.rc.core.allowed_protos;
-	dev->driver_type = d->props.rc.core.driver_type;
 	usb_to_input_id(d->udev, &dev->input_id);
 	dev->input_name = "IR-receiver inside an USB DVB receiver";
 	dev->input_phys = d->rc_phys;
diff --git a/drivers/media/usb/em28xx/em28xx-input.c b/drivers/media/usb/em28xx/em28xx-input.c
index a1904e2..4b0914d 100644
--- a/drivers/media/usb/em28xx/em28xx-input.c
+++ b/drivers/media/usb/em28xx/em28xx-input.c
@@ -717,7 +717,7 @@ static int em28xx_ir_init(struct em28xx *dev)
 	ir = kzalloc(sizeof(*ir), GFP_KERNEL);
 	if (!ir)
 		return -ENOMEM;
-	rc = rc_allocate_device();
+	rc = rc_allocate_device(RC_DRIVER_SCANCODE);
 	if (!rc)
 		goto error;
 
diff --git a/drivers/media/usb/tm6000/tm6000-input.c b/drivers/media/usb/tm6000/tm6000-input.c
index 26b2ebb..377a69b 100644
--- a/drivers/media/usb/tm6000/tm6000-input.c
+++ b/drivers/media/usb/tm6000/tm6000-input.c
@@ -429,7 +429,7 @@ int tm6000_ir_init(struct tm6000_core *dev)
 		return 0;
 
 	ir = kzalloc(sizeof(*ir), GFP_ATOMIC);
-	rc = rc_allocate_device();
+	rc = rc_allocate_device(RC_DRIVER_SCANCODE);
 	if (!ir || !rc)
 		goto out;
 
@@ -456,7 +456,6 @@ int tm6000_ir_init(struct tm6000_core *dev)
 		ir->polling = 50;
 		INIT_DELAYED_WORK(&ir->work, tm6000_ir_handle_key);
 	}
-	rc->driver_type = RC_DRIVER_SCANCODE;
 
 	snprintf(ir->name, sizeof(ir->name), "tm5600/60x0 IR (%s)",
 						dev->name);
diff --git a/include/media/rc-core.h b/include/media/rc-core.h
index 55281b9..ba92c86 100644
--- a/include/media/rc-core.h
+++ b/include/media/rc-core.h
@@ -200,17 +200,19 @@ struct rc_dev {
 /**
  * rc_allocate_device - Allocates a RC device
  *
+ * @rc_driver_type: specifies the type of the RC output to be allocated
  * returns a pointer to struct rc_dev.
  */
-struct rc_dev *rc_allocate_device(void);
+struct rc_dev *rc_allocate_device(enum rc_driver_type);
 
 /**
  * devm_rc_allocate_device - Managed RC device allocation
  *
  * @dev: pointer to struct device
+ * @rc_driver_type: specifies the type of the RC output to be allocated
  * returns a pointer to struct rc_dev.
  */
-struct rc_dev *devm_rc_allocate_device(struct device *dev);
+struct rc_dev *devm_rc_allocate_device(struct device *dev, enum rc_driver_type);
 
 /**
  * rc_free_device - Frees a RC device
-- 
2.10.2

