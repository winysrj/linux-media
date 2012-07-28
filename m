Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:48651 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752275Ab2G1NBk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Jul 2012 09:01:40 -0400
Received: by wgbdr13 with SMTP id dr13so3539971wgb.1
        for <linux-media@vger.kernel.org>; Sat, 28 Jul 2012 06:01:39 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 28 Jul 2012 15:01:38 +0200
Message-ID: <CAHZxpb8mp5Q=HYn5LF_Fp_fWbrkBn0wWahKH-TrjjoPrDW3W=A@mail.gmail.com>
Subject: [PATCH] Add support for the Terratec Cinergy T Dual PCIe IR remote
From: Djuri Baars <dsbaars@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following patch adds support for the infrared remote included in
the Terratec Cinergy T Dual PCIe card.

By making a contribution to this project, I certify that:

(a) The contribution was created in whole or in part by me and I
    have the right to submit it under the open source license
    indicated in the file; or

(b) The contribution is based upon previous work that, to the best
    of my knowledge, is covered under an appropriate open source
    license and I have the right under that license to submit that
    work with modifications, whether created in whole or in part
    by me, under the same open source license (unless I am
    permitted to submit under a different license), as indicated
    in the file; or

(c) The contribution was provided directly to me by some other
    person who certified (a), (b) or (c) and I have not modified
    it.

(d) I understand and agree that this project and the contribution
    are public and that a record of the contribution (including all
    personal information I submit with it, including my sign-off) is
    maintained indefinitely and may be redistributed consistent with
    this project or the open source license(s) involved.

Signed-off-by: Djuri Baars <dsbaars@gmail.com>

---
 drivers/media/video/cx23885/cx23885-cards.c |    4 ++++
 drivers/media/video/cx23885/cx23885-input.c |    9 +++++++++
 2 files changed, 13 insertions(+)

diff --git a/drivers/media/video/cx23885/cx23885-cards.c
b/drivers/media/video/cx23885/cx23885-cards.c
index 76b7563..0b80cf0 100644
--- a/drivers/media/video/cx23885/cx23885-cards.c
+++ b/drivers/media/video/cx23885/cx23885-cards.c
@@ -46,6 +46,7 @@ MODULE_PARM_DESC(enable_885_ir,
 		 "Enable integrated IR controller for supported\n"
 		 "\t\t    CX2388[57] boards that are wired for it:\n"
 		 "\t\t\tHVR-1250 (reported safe)\n"
+		 "\t\t\tTerraTec Cinergy T PCIe Dual (not well tested, appears to be safe)\n"
 		 "\t\t\tTeVii S470 (reported unsafe)\n"
 		 "\t\t    This can cause an interrupt storm with some cards.\n"
 		 "\t\t    Default: 0 [Disabled]");
@@ -1170,6 +1171,7 @@ int cx23885_ir_init(struct cx23885_dev *dev)
 		params.shutdown = true;
 		v4l2_subdev_call(dev->sd_ir, ir, tx_s_parameters, &params);
 		break;
+	case CX23885_BOARD_TERRATEC_CINERGY_T_PCIE_DUAL:	
 	case CX23885_BOARD_TEVII_S470:
 		if (!enable_885_ir)
 			break;
@@ -1210,6 +1212,7 @@ void cx23885_ir_fini(struct cx23885_dev *dev)
 		cx23888_ir_remove(dev);
 		dev->sd_ir = NULL;
 		break;
+	case CX23885_BOARD_TERRATEC_CINERGY_T_PCIE_DUAL:	
 	case CX23885_BOARD_TEVII_S470:
 	case CX23885_BOARD_HAUPPAUGE_HVR1250:
 		cx23885_irq_remove(dev, PCI_MSK_AV_CORE);
@@ -1253,6 +1256,7 @@ void cx23885_ir_pci_int_enable(struct cx23885_dev *dev)
 		if (dev->sd_ir)
 			cx23885_irq_add_enable(dev, PCI_MSK_IR);
 		break;
+	case CX23885_BOARD_TERRATEC_CINERGY_T_PCIE_DUAL:	
 	case CX23885_BOARD_TEVII_S470:
 	case CX23885_BOARD_HAUPPAUGE_HVR1250:
 		if (dev->sd_ir)
diff --git a/drivers/media/video/cx23885/cx23885-input.c
b/drivers/media/video/cx23885/cx23885-input.c
index ce765e3..bb1f7c8 100644
--- a/drivers/media/video/cx23885/cx23885-input.c
+++ b/drivers/media/video/cx23885/cx23885-input.c
@@ -85,6 +85,7 @@ void cx23885_input_rx_work_handler(struct
cx23885_dev *dev, u32 events)
 	case CX23885_BOARD_HAUPPAUGE_HVR1270:
 	case CX23885_BOARD_HAUPPAUGE_HVR1850:
 	case CX23885_BOARD_HAUPPAUGE_HVR1290:
+	case CX23885_BOARD_TERRATEC_CINERGY_T_PCIE_DUAL:
 	case CX23885_BOARD_TEVII_S470:
 	case CX23885_BOARD_HAUPPAUGE_HVR1250:
 		/*
@@ -162,6 +163,7 @@ static int cx23885_input_ir_start(struct cx23885_dev *dev)
 		 */
 		params.invert_level = true;
 		break;
+	case CX23885_BOARD_TERRATEC_CINERGY_T_PCIE_DUAL:	
 	case CX23885_BOARD_TEVII_S470:
 		/*
 		 * The IR controller on this board only returns pulse widths.
@@ -272,6 +274,13 @@ int cx23885_input_init(struct cx23885_dev *dev)
 		/* The grey Hauppauge RC-5 remote */
 		rc_map = RC_MAP_HAUPPAUGE;
 		break;
+	case CX23885_BOARD_TERRATEC_CINERGY_T_PCIE_DUAL:
+		/* Integrated CX23885 IR controller */
+		driver_type = RC_DRIVER_IR_RAW;
+		allowed_protos = RC_TYPE_NEC;
+		/* The grey Terratec remote with orange buttons */
+		rc_map = RC_MAP_NEC_TERRATEC_CINERGY_XS;
+		break;
 	case CX23885_BOARD_TEVII_S470:
 		/* Integrated CX23885 IR controller */
 		driver_type = RC_DRIVER_IR_RAW;
