Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:2799 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754144Ab3CKLrO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Mar 2013 07:47:14 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Volokh Konstantin <volokh84@gmail.com>,
	Pete Eberlein <pete@sensoray.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 37/42] saa7134-go7007: add support for this combination.
Date: Mon, 11 Mar 2013 12:46:15 +0100
Message-Id: <f8598fa09f062999b079c7f2ae5f9e4566d9725e.1363000605.git.hans.verkuil@cisco.com>
In-Reply-To: <1363002380-19825-1-git-send-email-hverkuil@xs4all.nl>
References: <1363002380-19825-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <38bc3cc42d0c021432afd29c2c1e22cf380b06e0.1363000605.git.hans.verkuil@cisco.com>
References: <38bc3cc42d0c021432afd29c2c1e22cf380b06e0.1363000605.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Pete Eberlein <pete@sensoray.com>

Add support for the Sensoray model 614 board, which is a saa7134
with a go7007 MPEG encoder.

Signed-off-by: Pete Eberlein <pete@sensoray.com>
[hans.verkuil@cisco.com: updated to make it merge correctly]
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/saa7134/saa7134-cards.c     |   29 ++++++
 drivers/media/pci/saa7134/saa7134-core.c      |   10 ++-
 drivers/media/pci/saa7134/saa7134.h           |    5 ++
 drivers/staging/media/go7007/Makefile         |    4 +-
 drivers/staging/media/go7007/saa7134-go7007.c |  117 +++++++++++++++----------
 5 files changed, 115 insertions(+), 50 deletions(-)

diff --git a/drivers/media/pci/saa7134/saa7134-cards.c b/drivers/media/pci/saa7134/saa7134-cards.c
index dc68cf1..9a53794 100644
--- a/drivers/media/pci/saa7134/saa7134-cards.c
+++ b/drivers/media/pci/saa7134/saa7134-cards.c
@@ -5790,6 +5790,29 @@ struct saa7134_board saa7134_boards[] = {
 			.gpio = 0x6010000,
 		} },
 	},
+	[SAA7134_BOARD_WIS_VOYAGER] = {
+		.name           = "WIS Voyager or compatible",
+		.audio_clock    = 0x00200000,
+		.tuner_type	= TUNER_PHILIPS_TDA8290,
+		.radio_type     = UNSET,
+		.tuner_addr     = ADDR_UNSET,
+		.radio_addr     = ADDR_UNSET,
+		.mpeg		= SAA7134_MPEG_GO7007,
+		.inputs		= { {
+			.name = name_comp1,
+			.vmux = 0,
+			.amux = LINE2,
+		}, {
+			.name = name_tv,
+			.vmux = 3,
+			.amux = TV,
+			.tv   = 1,
+		}, {
+			.name = name_svideo,
+			.vmux = 6,
+		.amux = LINE1,
+		} },
+	},
 
 };
 
@@ -7037,6 +7060,12 @@ struct pci_device_id saa7134_pci_tbl[] = {
 		.subdevice    = 0x0911,
 		.driver_data  = SAA7134_BOARD_SENSORAY811_911,
 	}, {
+		.vendor       = PCI_VENDOR_ID_PHILIPS,
+		.device       = PCI_DEVICE_ID_PHILIPS_SAA7133,
+		.subvendor    = 0x1905, /* WIS */
+		.subdevice    = 0x7007,
+		.driver_data  = SAA7134_BOARD_WIS_VOYAGER,
+	}, {
 		/* --- boards without eeprom + subsystem ID --- */
 		.vendor       = PCI_VENDOR_ID_PHILIPS,
 		.device       = PCI_DEVICE_ID_PHILIPS_SAA7134,
diff --git a/drivers/media/pci/saa7134/saa7134-core.c b/drivers/media/pci/saa7134/saa7134-core.c
index 8fd24e7..0a849ea 100644
--- a/drivers/media/pci/saa7134/saa7134-core.c
+++ b/drivers/media/pci/saa7134/saa7134-core.c
@@ -156,6 +156,8 @@ static void request_module_async(struct work_struct *work){
 		request_module("saa7134-empress");
 	if (card_is_dvb(dev))
 		request_module("saa7134-dvb");
+	if (card_is_go7007(dev))
+		request_module("saa7134-go7007");
 	if (alsa) {
 		if (dev->pci->device != PCI_DEVICE_ID_PHILIPS_SAA7130)
 			request_module("saa7134-alsa");
@@ -557,8 +559,12 @@ static irqreturn_t saa7134_irq(int irq, void *dev_id)
 			saa7134_irq_vbi_done(dev,status);
 
 		if ((report & SAA7134_IRQ_REPORT_DONE_RA2) &&
-		    card_has_mpeg(dev))
-			saa7134_irq_ts_done(dev,status);
+		    card_has_mpeg(dev)) {
+			if (dev->mops->irq_ts_done != NULL)
+				dev->mops->irq_ts_done(dev, status);
+			else
+				saa7134_irq_ts_done(dev, status);
+		}
 
 		if (report & SAA7134_IRQ_REPORT_GPIO16) {
 			switch (dev->has_remote) {
diff --git a/drivers/media/pci/saa7134/saa7134.h b/drivers/media/pci/saa7134/saa7134.h
index 71eefef..e337e6c 100644
--- a/drivers/media/pci/saa7134/saa7134.h
+++ b/drivers/media/pci/saa7134/saa7134.h
@@ -334,6 +334,7 @@ struct saa7134_card_ir {
 #define SAA7134_BOARD_KWORLD_PC150U         189
 #define SAA7134_BOARD_ASUSTeK_PS3_100      190
 #define SAA7134_BOARD_HAWELL_HW_9004V1      191
+#define SAA7134_BOARD_WIS_VOYAGER           192
 
 #define SAA7134_MAXBOARDS 32
 #define SAA7134_INPUT_MAX 8
@@ -364,6 +365,7 @@ enum saa7134_mpeg_type {
 	SAA7134_MPEG_UNUSED,
 	SAA7134_MPEG_EMPRESS,
 	SAA7134_MPEG_DVB,
+	SAA7134_MPEG_GO7007,
 };
 
 enum saa7134_mpeg_ts_type {
@@ -403,6 +405,7 @@ struct saa7134_board {
 #define card_has_radio(dev)   (NULL != saa7134_boards[dev->board].radio.name)
 #define card_is_empress(dev)  (SAA7134_MPEG_EMPRESS == saa7134_boards[dev->board].mpeg)
 #define card_is_dvb(dev)      (SAA7134_MPEG_DVB     == saa7134_boards[dev->board].mpeg)
+#define card_is_go7007(dev)   (SAA7134_MPEG_GO7007  == saa7134_boards[dev->board].mpeg)
 #define card_has_mpeg(dev)    (SAA7134_MPEG_UNUSED  != saa7134_boards[dev->board].mpeg)
 #define card(dev)             (saa7134_boards[dev->board])
 #define card_in(dev,n)        (saa7134_boards[dev->board].inputs[n])
@@ -535,6 +538,8 @@ struct saa7134_mpeg_ops {
 	int                        (*init)(struct saa7134_dev *dev);
 	int                        (*fini)(struct saa7134_dev *dev);
 	void                       (*signal_change)(struct saa7134_dev *dev);
+	void                       (*irq_ts_done)(struct saa7134_dev *dev,
+						  unsigned long status);
 };
 
 /* global device status */
diff --git a/drivers/staging/media/go7007/Makefile b/drivers/staging/media/go7007/Makefile
index f9c8e0f..7885c21 100644
--- a/drivers/staging/media/go7007/Makefile
+++ b/drivers/staging/media/go7007/Makefile
@@ -8,8 +8,8 @@ go7007-y := go7007-v4l2.o go7007-driver.o go7007-i2c.o go7007-fw.o \
 s2250-y := s2250-board.o
 
 # Uncomment when the saa7134 patches get into upstream
-#obj-$(CONFIG_VIDEO_SAA7134) += saa7134-go7007.o
-#ccflags-$(CONFIG_VIDEO_SAA7134:m=y) += -Idrivers/media/video/saa7134 -DSAA7134_MPEG_GO7007=3
+obj-$(CONFIG_VIDEO_SAA7134) += saa7134-go7007.o
+ccflags-$(CONFIG_VIDEO_SAA7134:m=y) += -Idrivers/media/pci/saa7134
 
 # S2250 needs cypress ezusb loader from dvb-usb-v2
 ccflags-$(CONFIG_VIDEO_GO7007_USB_S2250_BOARD:m=y) += -Idrivers/media/usb/dvb-usb-v2
diff --git a/drivers/staging/media/go7007/saa7134-go7007.c b/drivers/staging/media/go7007/saa7134-go7007.c
index 752f1bd..f51f42e 100644
--- a/drivers/staging/media/go7007/saa7134-go7007.c
+++ b/drivers/staging/media/go7007/saa7134-go7007.c
@@ -28,12 +28,15 @@
 #include <linux/i2c.h>
 #include <asm/byteorder.h>
 #include <media/v4l2-common.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-subdev.h>
 
-#include "saa7134-reg.h"
 #include "saa7134.h"
+#include "saa7134-reg.h"
+#include "go7007.h"
 #include "go7007-priv.h"
 
-#define GO7007_HPI_DEBUG
+/*#define GO7007_HPI_DEBUG*/
 
 enum hpi_address {
 	HPI_ADDR_VIDEO_BUFFER = 0xe4,
@@ -57,6 +60,7 @@ enum gpio_command {
 };
 
 struct saa7134_go7007 {
+	struct v4l2_subdev sd;
 	struct saa7134_dev *dev;
 	u8 *top;
 	u8 *bottom;
@@ -64,6 +68,11 @@ struct saa7134_go7007 {
 	dma_addr_t bottom_dma;
 };
 
+static inline struct saa7134_go7007 *to_state(struct v4l2_subdev *sd)
+{
+	return container_of(sd, struct saa7134_go7007, sd);
+}
+
 static struct go7007_board_info board_voyager = {
 	.firmware	 = "go7007tv.bin",
 	.flags		 = 0,
@@ -84,7 +93,6 @@ static struct go7007_board_info board_voyager = {
 		},
 	},
 };
-MODULE_FIRMWARE("go7007tv.bin");
 
 /********************* Driver for GPIO HPI interface *********************/
 
@@ -380,47 +388,6 @@ static int saa7134_go7007_send_firmware(struct go7007 *go, u8 *data, int len)
 	return 0;
 }
 
-static int saa7134_go7007_send_command(struct go7007 *go, unsigned int cmd,
-					void *arg)
-{
-	struct saa7134_go7007 *saa = go->hpi_context;
-	struct saa7134_dev *dev = saa->dev;
-
-	switch (cmd) {
-	case VIDIOC_S_STD:
-	{
-		v4l2_std_id *std = arg;
-		return saa7134_s_std_internal(dev, NULL, std);
-	}
-	case VIDIOC_G_STD:
-	{
-		v4l2_std_id *std = arg;
-		*std = dev->tvnorm->id;
-		return 0;
-	}
-	case VIDIOC_QUERYCTRL:
-	{
-		struct v4l2_queryctrl *ctrl = arg;
-		if (V4L2_CTRL_ID2CLASS(ctrl->id) == V4L2_CTRL_CLASS_USER)
-			return saa7134_queryctrl(NULL, NULL, ctrl);
-	}
-	case VIDIOC_G_CTRL:
-	{
-		struct v4l2_control *ctrl = arg;
-		if (V4L2_CTRL_ID2CLASS(ctrl->id) == V4L2_CTRL_CLASS_USER)
-			return saa7134_g_ctrl_internal(dev, NULL, ctrl);
-	}
-	case VIDIOC_S_CTRL:
-	{
-		struct v4l2_control *ctrl = arg;
-		if (V4L2_CTRL_ID2CLASS(ctrl->id) == V4L2_CTRL_CLASS_USER)
-			return saa7134_s_ctrl_internal(dev, NULL, ctrl);
-	}
-	}
-	return -EINVAL;
-
-}
-
 static struct go7007_hpi_ops saa7134_go7007_hpi_ops = {
 	.interface_reset	= saa7134_go7007_interface_reset,
 	.write_interrupt	= saa7134_go7007_write_interrupt,
@@ -428,15 +395,62 @@ static struct go7007_hpi_ops saa7134_go7007_hpi_ops = {
 	.stream_start		= saa7134_go7007_stream_start,
 	.stream_stop		= saa7134_go7007_stream_stop,
 	.send_firmware		= saa7134_go7007_send_firmware,
-	.send_command		= saa7134_go7007_send_command,
 };
 
+/* --------------------------------------------------------------------------*/
+
+static int saa7134_go7007_s_std(struct v4l2_subdev *sd, v4l2_std_id norm)
+{
+	struct saa7134_go7007 *saa = to_state(sd);
+	struct saa7134_dev *dev = saa->dev;
+
+	return saa7134_s_std_internal(dev, NULL, &norm);
+}
+
+static int saa7134_go7007_queryctrl(struct v4l2_subdev *sd,
+				    struct v4l2_queryctrl *query)
+{
+	return saa7134_queryctrl(NULL, NULL, query);
+}
+static int saa7134_go7007_s_ctrl(struct v4l2_subdev *sd,
+				 struct v4l2_control *ctrl)
+{
+	struct saa7134_go7007 *saa = to_state(sd);
+	struct saa7134_dev *dev = saa->dev;
+	return saa7134_s_ctrl_internal(dev, NULL, ctrl);
+}
+
+static int saa7134_go7007_g_ctrl(struct v4l2_subdev *sd,
+				 struct v4l2_control *ctrl)
+{
+	struct saa7134_go7007 *saa = to_state(sd);
+	struct saa7134_dev *dev = saa->dev;
+	return saa7134_g_ctrl_internal(dev, NULL, ctrl);
+}
+
+/* --------------------------------------------------------------------------*/
+
+static const struct v4l2_subdev_core_ops saa7134_go7007_core_ops = {
+	.g_ctrl = saa7134_go7007_g_ctrl,
+	.s_ctrl = saa7134_go7007_s_ctrl,
+	.queryctrl = saa7134_go7007_queryctrl,
+	.s_std = saa7134_go7007_s_std,
+};
+
+static const struct v4l2_subdev_ops saa7134_go7007_sd_ops = {
+	.core = &saa7134_go7007_core_ops,
+};
+
+/* --------------------------------------------------------------------------*/
+
+
 /********************* Add/remove functions *********************/
 
 static int saa7134_go7007_init(struct saa7134_dev *dev)
 {
 	struct go7007 *go;
 	struct saa7134_go7007 *saa;
+	struct v4l2_subdev *sd;
 
 	printk(KERN_DEBUG "saa7134-go7007: probing new SAA713X board\n");
 
@@ -444,6 +458,12 @@ static int saa7134_go7007_init(struct saa7134_dev *dev)
 	if (saa == NULL)
 		return -ENOMEM;
 
+	/* Init the subdevice interface */
+	sd = &saa->sd;
+	v4l2_subdev_init(sd, &saa7134_go7007_sd_ops);
+	v4l2_set_subdevdata(sd, saa);
+	strncpy(sd->name, "saa7134-go7007", sizeof(sd->name));
+
 	/* Allocate a couple pages for receiving the compressed stream */
 	saa->top = (u8 *)get_zeroed_page(GFP_KERNEL);
 	if (!saa->top)
@@ -471,8 +491,12 @@ static int saa7134_go7007_init(struct saa7134_dev *dev)
 	 * V4L2 and ALSA interfaces */
 	if (go7007_register_encoder(go, go->board_info->num_i2c_devs) < 0)
 		goto initfail;
+
+	/* Register the subdevice interface with the go7007 device */
+	if (v4l2_device_register_subdev(&go->v4l2_dev, sd) < 0)
+		printk(KERN_INFO "saa7134-go7007: register subdev failed\n");
+
 	dev->empress_dev = &go->vdev;
-	video_set_drvdata(dev->empress_dev, go);
 
 	go->status = STATUS_ONLINE;
 	return 0;
@@ -506,6 +530,7 @@ static int saa7134_go7007_fini(struct saa7134_dev *dev)
 	go->status = STATUS_SHUTDOWN;
 	free_page((unsigned long)saa->top);
 	free_page((unsigned long)saa->bottom);
+	v4l2_device_unregister_subdev(&saa->sd);
 	kfree(saa);
 	video_unregister_device(&go->vdev);
 
-- 
1.7.10.4

