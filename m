Return-path: <linux-media-owner@vger.kernel.org>
Received: from imr-db01.mx.aol.com ([205.188.91.95]:41333 "EHLO
	imr-db01.mx.aol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753222Ab2KHUYS (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Nov 2012 15:24:18 -0500
Received: from mtaout-mb06.r1000.mx.aol.com (mtaout-mb06.r1000.mx.aol.com [172.29.41.70])
	by imr-db01.mx.aol.com (Outbound Mail Relay) with ESMTP id D2D33380000E1
	for <linux-media@vger.kernel.org>; Thu,  8 Nov 2012 15:24:17 -0500 (EST)
Received: from [192.168.1.35] (unknown [190.50.16.77])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mtaout-mb06.r1000.mx.aol.com (MUA/Third Party Client Interface) with ESMTPSA id 56027E000218
	for <linux-media@vger.kernel.org>; Thu,  8 Nov 2012 15:24:15 -0500 (EST)
Message-ID: <509C0D01.9010203@netscape.net>
Date: Thu, 08 Nov 2012 16:50:25 -0300
From: =?ISO-8859-1?Q?Alfredo_Jes=FAs_Delaiti?=
	<alfredodelaiti@netscape.net>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: [PATCH 2/2] Add RC support for MyGica X8507 - add support card
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

add support card

Signed-off-by: Alfredo J. Delaiti <alfredodelaiti@netscape.net>


diff --git a/drivers/media/pci/cx23885/cx23885-cards.c b/drivers/media/pci/cx23885/cx23885-cards.c
index 6277e14..91eddc2 100644
--- a/drivers/media/pci/cx23885/cx23885-cards.c
+++ b/drivers/media/pci/cx23885/cx23885-cards.c
@@ -1366,30 +1366,31 @@ int cx23885_ir_init(struct cx23885_dev *dev)
                                 ir_rxtx_pin_cfg_count, ir_rxtx_pin_cfg);
                /*
                 * For these boards we need to invert the Tx output via the
                 * IR controller to have the LED off while idle
                 */
                v4l2_subdev_call(dev->sd_ir, ir, tx_g_parameters, &params);
                params.enable = false;
                params.shutdown = false;
                params.invert_level = true;
                v4l2_subdev_call(dev->sd_ir, ir, tx_s_parameters, &params);
                params.shutdown = true;
                v4l2_subdev_call(dev->sd_ir, ir, tx_s_parameters, &params);
                break;
        case CX23885_BOARD_TERRATEC_CINERGY_T_PCIE_DUAL:
        case CX23885_BOARD_TEVII_S470:
+       case CX23885_BOARD_MYGICA_X8507:
                if (!enable_885_ir)
                        break;
                dev->sd_ir = cx23885_find_hw(dev, CX23885_HW_AV_CORE);
                if (dev->sd_ir == NULL) {
                        ret = -ENODEV;
                        break;
                }
                v4l2_subdev_call(dev->sd_cx25840, core, s_io_pin_config,
                                 ir_rx_pin_cfg_count, ir_rx_pin_cfg);
                break;
        case CX23885_BOARD_HAUPPAUGE_HVR1250:
                if (!enable_885_ir)
                        break;
                dev->sd_ir = cx23885_find_hw(dev, CX23885_HW_AV_CORE);
                if (dev->sd_ir == NULL) {
@@ -1408,30 +1409,31 @@ int cx23885_ir_init(struct cx23885_dev *dev)
 }
 
 void cx23885_ir_fini(struct cx23885_dev *dev)
 {
        switch (dev->board) {
        case CX23885_BOARD_HAUPPAUGE_HVR1270:
        case CX23885_BOARD_HAUPPAUGE_HVR1850:
        case CX23885_BOARD_HAUPPAUGE_HVR1290:
                cx23885_irq_remove(dev, PCI_MSK_IR);
                cx23888_ir_remove(dev);
                dev->sd_ir = NULL;
                break;
        case CX23885_BOARD_TERRATEC_CINERGY_T_PCIE_DUAL:
        case CX23885_BOARD_TEVII_S470:
        case CX23885_BOARD_HAUPPAUGE_HVR1250:
+       case CX23885_BOARD_MYGICA_X8507:
                cx23885_irq_remove(dev, PCI_MSK_AV_CORE);
                /* sd_ir is a duplicate pointer to the AV Core, just clear it */
                dev->sd_ir = NULL;
                break;
        }
 }
 
 static int netup_jtag_io(void *device, int tms, int tdi, int read_tdo)
 {
        int data;
        int tdo = 0;
        struct cx23885_dev *dev = (struct cx23885_dev *)device;
        /*TMS*/
        data = ((cx_read(GP0_IO)) & (~0x00000002));
        data |= (tms ? 0x00020002 : 0x00020000);
@@ -1452,30 +1454,31 @@ static int netup_jtag_io(void *device, int tms, int tdi, int read_tdo)
        return tdo;
 }
 
 void cx23885_ir_pci_int_enable(struct cx23885_dev *dev)
 {
        switch (dev->board) {
        case CX23885_BOARD_HAUPPAUGE_HVR1270:
        case CX23885_BOARD_HAUPPAUGE_HVR1850:
        case CX23885_BOARD_HAUPPAUGE_HVR1290:
                if (dev->sd_ir)
                        cx23885_irq_add_enable(dev, PCI_MSK_IR);
                break;
        case CX23885_BOARD_TERRATEC_CINERGY_T_PCIE_DUAL:
        case CX23885_BOARD_TEVII_S470:
        case CX23885_BOARD_HAUPPAUGE_HVR1250:
+       case CX23885_BOARD_MYGICA_X8507:
                if (dev->sd_ir)
                        cx23885_irq_add_enable(dev, PCI_MSK_AV_CORE);
                break;
        }
 }
 
 void cx23885_card_setup(struct cx23885_dev *dev)
 {
        struct cx23885_tsport *ts1 = &dev->ts1;
        struct cx23885_tsport *ts2 = &dev->ts2;
 
        static u8 eeprom[256];
        if (dev->i2c_bus[0].i2c_rc == 0) {
                dev->i2c_bus[0].i2c_client.addr = 0xa0 >> 1;
diff --git a/drivers/media/pci/cx23885/cx23885-input.c b/drivers/media/pci/cx23885/cx23885-input.c
index 4f1055a..7875dfb 100644
--- a/drivers/media/pci/cx23885/cx23885-input.c
+++ b/drivers/media/pci/cx23885/cx23885-input.c
@@ -77,30 +77,31 @@ static void cx23885_input_process_measurements(struct cx23885_dev *dev,
 void cx23885_input_rx_work_handler(struct cx23885_dev *dev, u32 events)
 {
        struct v4l2_subdev_ir_parameters params;
        int overrun, data_available;
 
        if (dev->sd_ir == NULL || events == 0)
                return;
 
        switch (dev->board) {
        case CX23885_BOARD_HAUPPAUGE_HVR1270:
        case CX23885_BOARD_HAUPPAUGE_HVR1850:
        case CX23885_BOARD_HAUPPAUGE_HVR1290:
        case CX23885_BOARD_TERRATEC_CINERGY_T_PCIE_DUAL:
        case CX23885_BOARD_TEVII_S470:
        case CX23885_BOARD_HAUPPAUGE_HVR1250:
+       case CX23885_BOARD_MYGICA_X8507:
                /*
                 * The only boards we handle right now.  However other boards
                 * using the CX2388x integrated IR controller should be similar
                 */
                break;
        default:
                return;
        }
 
        overrun = events & (V4L2_SUBDEV_IR_RX_SW_FIFO_OVERRUN |
                            V4L2_SUBDEV_IR_RX_HW_FIFO_OVERRUN);
 
        data_available = events & (V4L2_SUBDEV_IR_RX_END_OF_RX_DETECTED |
                                   V4L2_SUBDEV_IR_RX_FIFO_SERVICE_REQ);
 
@@ -128,30 +129,31 @@ void cx23885_input_rx_work_handler(struct cx23885_dev *dev, u32 events)
 static int cx23885_input_ir_start(struct cx23885_dev *dev)
 {
        struct v4l2_subdev_ir_parameters params;
 
        if (dev->sd_ir == NULL)
                return -ENODEV;
 
        atomic_set(&dev->ir_input_stopping, 0);
 
        v4l2_subdev_call(dev->sd_ir, ir, rx_g_parameters, &params);
        switch (dev->board) {
        case CX23885_BOARD_HAUPPAUGE_HVR1270:
        case CX23885_BOARD_HAUPPAUGE_HVR1850:
        case CX23885_BOARD_HAUPPAUGE_HVR1290:
        case CX23885_BOARD_HAUPPAUGE_HVR1250:
+       case CX23885_BOARD_MYGICA_X8507:
                /*
                 * The IR controller on this board only returns pulse widths.
                 * Any other mode setting will fail to set up the device.
                */
                params.mode = V4L2_SUBDEV_IR_MODE_PULSE_WIDTH;
                params.enable = true;
                params.interrupt_enable = true;
                params.shutdown = false;
 
                /* Setup for baseband compatible with both RC-5 and RC-6A */
                params.modulation = false;
                /* RC-5:  2,222,222 ns = 1/36 kHz * 32 cycles * 2 marks * 1.25*/
                /* RC-6A: 3,333,333 ns = 1/36 kHz * 16 cycles * 6 marks * 1.25*/
                params.max_pulse_width = 3333333; /* ns */
                /* RC-5:    666,667 ns = 1/36 kHz * 32 cycles * 1 mark * 0.75 */
@@ -277,30 +279,37 @@ int cx23885_input_init(struct cx23885_dev *dev)
                break;
        case CX23885_BOARD_TERRATEC_CINERGY_T_PCIE_DUAL:
                /* Integrated CX23885 IR controller */
                driver_type = RC_DRIVER_IR_RAW;
                allowed_protos = RC_BIT_NEC;
                /* The grey Terratec remote with orange buttons */
                rc_map = RC_MAP_NEC_TERRATEC_CINERGY_XS;
                break;
        case CX23885_BOARD_TEVII_S470:
                /* Integrated CX23885 IR controller */
                driver_type = RC_DRIVER_IR_RAW;
                allowed_protos = RC_BIT_ALL;
                /* A guess at the remote */
                rc_map = RC_MAP_TEVII_NEC;
                break;
+       case CX23885_BOARD_MYGICA_X8507:
+               /* Integrated CX23885 IR controller */
+               driver_type = RC_DRIVER_IR_RAW;
+               allowed_protos = RC_BIT_ALL;
+               /* A guess at the remote */
+               rc_map = RC_MAP_TOTAL_MEDIA_IN_HAND_02;
+               break;
        default:
                return -ENODEV;
        }
 
        /* cx23885 board instance kernel IR state */
        kernel_ir = kzalloc(sizeof(struct cx23885_kernel_ir), GFP_KERNEL);
        if (kernel_ir == NULL)
                return -ENOMEM;
 
        kernel_ir->cx = dev;
        kernel_ir->name = kasprintf(GFP_KERNEL, "cx23885 IR (%s)",
                                    cx23885_boards[dev->board].name);
        kernel_ir->phys = kasprintf(GFP_KERNEL, "pci-%s/ir0",
                                    pci_name(dev->pci));
 

-- 
Dona tu voz
http://www.voxforge.org/es
