Return-Path: <SRS0=Cp5C=P2=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F12CAC43387
	for <linux-media@archiver.kernel.org>; Fri, 18 Jan 2019 13:37:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9C449208E4
	for <linux-media@archiver.kernel.org>; Fri, 18 Jan 2019 13:37:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727332AbfARNh0 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 18 Jan 2019 08:37:26 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:33089 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727123AbfARNh0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Jan 2019 08:37:26 -0500
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <mtr@pengutronix.de>)
        id 1gkUKq-0006SY-4F; Fri, 18 Jan 2019 14:37:24 +0100
Received: from mtr by dude.hi.pengutronix.de with local (Exim 4.92-RC4)
        (envelope-from <mtr@pengutronix.de>)
        id 1gkUKp-00018b-RQ; Fri, 18 Jan 2019 14:37:23 +0100
From:   Michael Tretter <m.tretter@pengutronix.de>
To:     linux-media@vger.kernel.org, devicetree@vger.kernel.org
Cc:     kernel@pengutronix.de, robh+dt@kernel.org, mchehab@kernel.org,
        tfiga@chromium.org, Michael Tretter <m.tretter@pengutronix.de>
Subject: [PATCH v2 2/3] [media] allegro: add Allegro DVT video IP core driver
Date:   Fri, 18 Jan 2019 14:37:15 +0100
Message-Id: <20190118133716.29288-3-m.tretter@pengutronix.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190118133716.29288-1-m.tretter@pengutronix.de>
References: <20190118133716.29288-1-m.tretter@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: mtr@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-media@vger.kernel.org
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Add a V4L2 mem-to-mem driver for Allegro DVT video IP cores as found in
the EV family of the Xilinx ZynqMP SoC. The Zynq UltraScale+ Device
Technical Reference Manual uses the term VCU (Video Codec Unit) for the
encoder, decoder and system integration block.

This driver takes care of interacting with the MicroBlaze MCU that
controls the actual IP cores. The IP cores and MCU are integrated in the
FPGA. The xlnx_vcu driver is responsible for configuring the clocks and
providing information about the codec configuration.

The driver currently only supports the H.264 video encoder.

Signed-off-by: Michael Tretter <m.tretter@pengutronix.de>
---
Changes since v1:
- clean up debug log levels
- fix unused variable in allegro_mbox_init
- fix uninitialized variable in allegro_mbox_write
- fix global module parameters
- fix Kconfig dependencies
- return h264 as default codec for mcu
- implement device reset as documented
- document why irq does not wait for clear
- rename ENCODE_ONE_FRM to ENCODE_FRAME
- allow error codes for mcu_channel_id
- move control handler to channel
- add fw version check
- add support for colorspaces
- enable configuration of H.264 levels
- enable configuration of frame size
- enable configuration of bit rate and CPB size
- enable configuration of GOP size
- rework response handling

---
 MAINTAINERS                                   |    6 +
 drivers/staging/media/Kconfig                 |    2 +
 drivers/staging/media/Makefile                |    1 +
 drivers/staging/media/allegro-dvt/Kconfig     |   16 +
 drivers/staging/media/allegro-dvt/Makefile    |    4 +
 .../staging/media/allegro-dvt/allegro-core.c  | 2648 +++++++++++++++++
 6 files changed, 2677 insertions(+)
 create mode 100644 drivers/staging/media/allegro-dvt/Kconfig
 create mode 100644 drivers/staging/media/allegro-dvt/Makefile
 create mode 100644 drivers/staging/media/allegro-dvt/allegro-core.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 17ad1d7b5510..6ccb298cd8a4 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -666,6 +666,12 @@ S:	Maintained
 F:	Documentation/i2c/busses/i2c-ali1563
 F:	drivers/i2c/busses/i2c-ali1563.c
 
+ALLEGRO DVT VIDEO IP CORE DRIVER
+M:	Michael Tretter <m.tretter@pengutronix.de>
+L:	linux-media@vger.kernel.org
+S:	Maintained
+F:	drivers/staging/media/allegro-dvt/
+
 ALLWINNER SECURITY SYSTEM
 M:	Corentin Labbe <clabbe.montjoie@gmail.com>
 L:	linux-crypto@vger.kernel.org
diff --git a/drivers/staging/media/Kconfig b/drivers/staging/media/Kconfig
index 19cadd17e542..0756c8669314 100644
--- a/drivers/staging/media/Kconfig
+++ b/drivers/staging/media/Kconfig
@@ -19,6 +19,8 @@ menuconfig STAGING_MEDIA
 if STAGING_MEDIA && MEDIA_SUPPORT
 
 # Please keep them in alphabetic order
+source "drivers/staging/media/allegro-dvt/Kconfig"
+
 source "drivers/staging/media/bcm2048/Kconfig"
 
 source "drivers/staging/media/davinci_vpfe/Kconfig"
diff --git a/drivers/staging/media/Makefile b/drivers/staging/media/Makefile
index edde1960b030..6578dfcbccb6 100644
--- a/drivers/staging/media/Makefile
+++ b/drivers/staging/media/Makefile
@@ -1,4 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0
+obj-$(CONFIG_VIDEO_ALLEGRO_DVT)	+= allegro-dvt/
 obj-$(CONFIG_I2C_BCM2048)	+= bcm2048/
 obj-$(CONFIG_VIDEO_IMX_MEDIA)	+= imx/
 obj-$(CONFIG_SOC_CAMERA_IMX074)	+= imx074/
diff --git a/drivers/staging/media/allegro-dvt/Kconfig b/drivers/staging/media/allegro-dvt/Kconfig
new file mode 100644
index 000000000000..96921e506c5f
--- /dev/null
+++ b/drivers/staging/media/allegro-dvt/Kconfig
@@ -0,0 +1,16 @@
+config VIDEO_ALLEGRO_DVT
+	tristate "Allegro DVT Video IP Cores"
+	depends on V4L_MEM2MEM_DRIVERS
+	depends on ARCH_ZYNQMP || COMPILE_TEST
+	depends on VIDEO_DEV && VIDEO_V4L2
+	select REGMAP
+	select REGMAP_MMIO
+	select V4L2_MEM2MEM_DEV
+	default n
+	help
+	  Support for the encoder and decoder video IP cores by Allegro DVT.
+	  These cores are found for example on the Xilinx ZynqMP SoC in the EV
+	  family and are called VCU in the reference manual.
+
+	  To compile this driver as a module, choose M here: the module
+	  will be called allegro.
diff --git a/drivers/staging/media/allegro-dvt/Makefile b/drivers/staging/media/allegro-dvt/Makefile
new file mode 100644
index 000000000000..bc30addee47f
--- /dev/null
+++ b/drivers/staging/media/allegro-dvt/Makefile
@@ -0,0 +1,4 @@
+# SPDX-License-Identifier: GPL-2.0
+allegro-objs := allegro-core.o
+
+obj-$(CONFIG_VIDEO_ALLEGRO_DVT) += allegro.o
diff --git a/drivers/staging/media/allegro-dvt/allegro-core.c b/drivers/staging/media/allegro-dvt/allegro-core.c
new file mode 100644
index 000000000000..db48747b345c
--- /dev/null
+++ b/drivers/staging/media/allegro-dvt/allegro-core.c
@@ -0,0 +1,2648 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2019 Pengutronix, Michael Tretter <kernel@pengutronix.de>
+ *
+ * Allegro DVT encoder and decoder driver
+ */
+
+#include <linux/firmware.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/kernel.h>
+#include <linux/log2.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_device.h>
+#include <linux/platform_device.h>
+#include <linux/regmap.h>
+#include <linux/sizes.h>
+#include <linux/slab.h>
+#include <linux/videodev2.h>
+#include <media/v4l2-ctrls.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-event.h>
+#include <media/v4l2-ioctl.h>
+#include <media/v4l2-mem2mem.h>
+#include <media/videobuf2-dma-contig.h>
+#include <media/videobuf2-v4l2.h>
+
+/*
+ * PG252 June 6, 2018 (H.264/H.265 Video Codec Unit v1.1) Chapter 3
+ *
+ * Configurable resolution
+ * - picture width and height multiple of 8
+ * - minimum size: 128 × 64
+ * - maximum width or height: 16384
+ * - maximum size: 33.5 megapixel
+ *
+ * I cannot trust the 33.5 megapixel, yet, and I do not understand the memory
+ * requirements at higher resolutions. Therefore, I limit the resolution to
+ * full HD, for now.
+ */
+#define ALLEGRO_WIDTH_MIN 128
+#define ALLEGRO_WIDTH_DEFAULT 1920
+#define ALLEGRO_WIDTH_MAX 1920
+#define ALLEGRO_HEIGHT_MIN 64
+#define ALLEGRO_HEIGHT_DEFAULT 1080
+#define ALLEGRO_HEIGHT_MAX 1080
+
+#define ALLEGRO_GOP_SIZE_DEFAULT 25
+#define ALLEGRO_GOP_SIZE_MAX 1000
+
+/*
+ * TODO The mailbox addresses and size are only valid for the 2018.2 release
+ * of the firmware. Firmware release 2018.3 uses double the size and changes
+ * the base addresses accordingly.
+ */
+#define MAILBOX_CMD                     0x7800
+#define MAILBOX_STATUS                  0x7c00
+#define MAILBOX_SIZE                    (0x400 - 0x8)
+
+/*
+ * MCU Control Registers
+ *
+ * The Zynq UltraScale+ Devices Register Reference documents the registers
+ * with an offset of 0x9000, which equals the size of the SRAM and one page
+ * gap. The driver handles SRAM and registers separately and, therefore, is
+ * oblivious of the offset.
+ */
+#define AL5_MCU_RESET                   0x0000
+#define AL5_MCU_RESET_SOFT              BIT(0)
+#define AL5_MCU_RESET_REGS              BIT(1)
+#define AL5_MCU_RESET_MODE              0x0004
+#define AL5_MCU_RESET_MODE_SLEEP        BIT(0)
+#define AL5_MCU_RESET_MODE_HALT         BIT(1)
+#define AL5_MCU_STA                     0x0008
+#define AL5_MCU_STA_SLEEP               BIT(0)
+#define AL5_MCU_WAKEUP                  0x000c
+
+#define AL5_ICACHE_ADDR_OFFSET_MSB      0x0010
+#define AL5_ICACHE_ADDR_OFFSET_LSB      0x0014
+#define AL5_DCACHE_ADDR_OFFSET_MSB      0x0018
+#define AL5_DCACHE_ADDR_OFFSET_LSB      0x001c
+
+#define AL5_MCU_INTERRUPT               0x0100
+#define AL5_ITC_CPU_IRQ_MSK             0x0104
+#define AL5_ITC_CPU_IRQ_CLR             0x0108
+#define AL5_ITC_CPU_IRQ_STA             0x010C
+#define AL5_ITC_CPU_IRQ_STA_TRIGGERED	BIT(0)
+
+#define AXI_ADDR_OFFSET_IP              0x0208
+
+/*
+ * TODO It seems that the MCU accesses the system memory with a 2G offset
+ * compared to CPU physical addresses.
+ */
+#define MCU_CACHE_OFFSET SZ_2G
+
+/*
+ * TODO The hardware encoder does not write SPS/PPS NAL units, but relies on
+ * the driver to add these. Thus, we need to save some space in the beginning
+ * of the stream buffers for these NAL units.
+ *
+ * The encoder will add the offset before writing the stream data.
+ * Unfortunately, the data does not start exactly at that offset, but a bit
+ * later and we need to add a filler nal.
+ */
+#define ENCODER_STREAM_OFFSET SZ_64
+
+/*
+ * TODO The downstream driver version 2018.02 uses 16M for the suballocator.
+ * I don't know what this memory is used for and how much is actually
+ * required. Firmware version 2018.02 already uses 32M.
+ */
+#define MCU_SUBALLOCATOR_SIZE SZ_16M
+
+/*
+ * Copied from the downstream driver.
+ */
+#define AL_OPT_WPP			BIT(0)
+#define AL_OPT_TILE			BIT(1)
+#define AL_OPT_LF			BIT(2)
+#define AL_OPT_LF_X_SLICE		BIT(3)
+#define AL_OPT_LF_X_TILE		BIT(4)
+#define AL_OPT_SCL_LST			BIT(5)
+#define AL_OPT_CONST_INTRA_PRED		BIT(6)
+#define AL_OPT_QP_TAB_RELATIVE		BIT(7)
+#define AL_OPT_FIX_PREDICTOR		BIT(8)
+#define AL_OPT_CUSTOM_LDA		BIT(9)
+#define AL_OPT_ENABLE_AUTO_QP		BIT(10)
+#define AL_OPT_ADAPT_AUTO_QP		BIT(11)
+#define AL_OPT_TRANSFO_SKIP		BIT(13)
+#define AL_OPT_FORCE_REC		BIT(15)
+#define AL_OPT_FORCE_MV_OUT		BIT(16)
+#define AL_OPT_FORCE_MV_CLIP		BIT(17)
+#define AL_OPT_LOWLAT_SYNC		BIT(18)
+#define AL_OPT_LOWLAT_INT		BIT(19)
+#define AL_OPT_RDO_COST_MODE		BIT(20)
+
+/*
+ * Slice types reported in the mcu_msg_encode_frame_response message.
+ */
+#define AL_ENC_SLICE_TYPE_B             0
+#define AL_ENC_SLICE_TYPE_P             1
+#define AL_ENC_SLICE_TYPE_I             2
+
+#define SIZE_MACROBLOCK 16
+
+static int debug = 0;
+module_param(debug, int, 0644);
+MODULE_PARM_DESC(debug, "Debug level (0-2)");
+
+static bool poison_capture_buffers = false;
+module_param(poison_capture_buffers, bool, 0644);
+MODULE_PARM_DESC(poison_capture_buffers,
+		 "Poison capture buffer before writing stream data");
+
+struct allegro_buffer {
+	void *vaddr;
+	dma_addr_t paddr;
+	size_t size;
+	struct list_head head;
+};
+
+struct allegro_channel;
+
+struct allegro_mbox {
+	unsigned int head;
+	unsigned int tail;
+	unsigned int data;
+	size_t size;
+	/* protect mailbox from simultaneous accesses */
+	struct mutex lock;
+};
+
+struct allegro_dev {
+	struct v4l2_device v4l2_dev;
+	struct video_device video_dev;
+	struct v4l2_m2m_dev *m2m_dev;
+	struct platform_device *plat_dev;
+
+	/* mutex protecting vb2_queue structure */
+	struct mutex lock;
+
+	struct regmap *regmap;
+	struct regmap *sram;
+
+	struct allegro_buffer firmware;
+	struct allegro_buffer suballocator;
+
+	struct completion init_complete;
+
+	/* The mailbox interface */
+	struct allegro_mbox mbox_command;
+	struct allegro_mbox mbox_status;
+
+	/*
+	 * The downstream driver limits the users to 64 users, thus I can use
+	 * a bitfield for the user_ids that are in use. See also user_id in
+	 * struct allegro_channel.
+	 */
+	unsigned long channel_user_ids;
+	struct list_head channels;
+};
+
+static struct regmap_config allegro_regmap_config = {
+	.name = "regmap",
+	.reg_bits = 32,
+	.val_bits = 32,
+	.reg_stride = 4,
+	.max_register = 0xfff,
+	.cache_type = REGCACHE_NONE,
+};
+
+static struct regmap_config allegro_sram_config = {
+	.name = "sram",
+	.reg_bits = 32,
+	.val_bits = 32,
+	.reg_stride = 4,
+	.max_register = 0x7fff,
+	.cache_type = REGCACHE_NONE,
+};
+
+#define fh_to_channel(__fh) container_of(__fh, struct allegro_channel, fh)
+
+struct allegro_channel {
+	struct allegro_dev *dev;
+	struct v4l2_fh fh;
+	struct v4l2_ctrl_handler ctrl_handler;
+
+	unsigned int width;
+	unsigned int height;
+	unsigned int stride;
+
+	enum v4l2_colorspace colorspace;
+	enum v4l2_ycbcr_encoding ycbcr_enc;
+	enum v4l2_quantization quantization;
+	enum v4l2_xfer_func xfer_func;
+
+	u32 pixelformat;
+	unsigned int sizeimage_raw;
+
+	u32 codec;
+	enum v4l2_mpeg_video_h264_profile profile;
+	enum v4l2_mpeg_video_h264_level level;
+	unsigned int sizeimage_encoded;
+
+	enum v4l2_mpeg_video_bitrate_mode bitrate_mode;
+	unsigned int bitrate;
+	unsigned int bitrate_peak;
+	unsigned int cpb_size;
+	unsigned int gop_size;
+
+	/* user_id is used to identify the channel during CREATE_CHANNEL */
+	/* not sure, what to set here and if this is actually required */
+	int user_id;
+	/* channel_id is set by the mcu and used by all later commands */
+	int mcu_channel_id;
+
+	struct list_head buffers_reference;
+	struct list_head buffers_intermediate;
+
+	struct list_head list;
+	struct completion completion;
+
+	bool created;
+	bool stop;
+};
+
+struct fw_info {
+	unsigned int id;
+	char *version;
+};
+
+static const struct fw_info supported_firmware[] = {
+	{
+		.id = 18296,
+		.version = "v2018.2",
+	},
+};
+
+enum mcu_msg_type {
+	MCU_MSG_TYPE_INIT = 0x0000,
+	MCU_MSG_TYPE_CREATE_CHANNEL = 0x0005,
+	MCU_MSG_TYPE_DESTROY_CHANNEL = 0x0006,
+	MCU_MSG_TYPE_ENCODE_FRAME = 0x0007,
+	MCU_MSG_TYPE_PUT_STREAM_BUFFER = 0x0012,
+	MCU_MSG_TYPE_PUSH_BUFFER_INTERMEDIATE = 0x000e,
+	MCU_MSG_TYPE_PUSH_BUFFER_REFERENCE = 0x000f,
+};
+
+static const char *msg_type_name(enum mcu_msg_type type)
+{
+	static char buf[9];
+
+	switch (type) {
+	case MCU_MSG_TYPE_INIT:
+		return "INIT";
+	case MCU_MSG_TYPE_CREATE_CHANNEL:
+		return "CREATE_CHANNEL";
+	case MCU_MSG_TYPE_DESTROY_CHANNEL:
+		return "DESTROY_CHANNEL";
+	case MCU_MSG_TYPE_ENCODE_FRAME:
+		return "ENCODE_FRAME";
+	case MCU_MSG_TYPE_PUT_STREAM_BUFFER:
+		return "PUT_STREAM_BUFFER";
+	case MCU_MSG_TYPE_PUSH_BUFFER_INTERMEDIATE:
+		return "PUSH_BUFFER_INTERMEDIATE";
+	case MCU_MSG_TYPE_PUSH_BUFFER_REFERENCE:
+		return "PUSH_BUFFER_REFERENCE";
+	default:
+		snprintf(buf, sizeof(buf), "(0x%04x)", type);
+		return buf;
+	}
+}
+
+struct mcu_msg_header {
+	u16 length;		/* length of the body in bytes */
+	u16 type;
+} __attribute__ ((__packed__));
+
+struct mcu_msg_init_request {
+	struct mcu_msg_header header;
+	u32 reserved0;		/* maybe a unused channel id */
+	u32 suballoc_dma;
+	u32 suballoc_size;
+	s32 l2_cache[3];
+} __attribute__ ((__packed__));
+
+struct mcu_msg_init_reply {
+	struct mcu_msg_header header;
+	u32 reserved0;
+} __attribute__ ((__packed__));
+
+struct mcu_msg_create_channel {
+	struct mcu_msg_header header;
+	u32 user_id;
+	u16 width;
+	u16 height;
+	u32 format;
+	u32 colorspace;
+	u32 src_mode;
+	u8 profile;
+	u16 constraint_set_flags;
+	s8 codec;
+	u16 level;
+	u16 tier;
+	u32 sps_param;
+	u32 pps_param;
+	u32 enc_option;
+	s8 beta_offset;
+	s8 tc_offset;
+	u16 reserved10;
+	u32 unknown11;
+	u32 unknown12;
+	u16 num_slices;
+	u16 prefetch_auto;
+	u32 prefetch_mem_offset;
+	u32 prefetch_mem_size;
+	u16 clip_hrz_range;
+	u16 clip_vrt_range;
+	u16 me_range[4];
+	u8 max_cu_size;
+	u8 min_cu_size;
+	u8 max_tu_size;
+	u8 min_tu_size;
+	u8 max_transfo_depth_inter;
+	u8 max_transfo_depth_intra;
+	u16 reserved20;
+	u32 entropy_mode;
+	u32 wp_mode;
+	/* rate control param */
+	u32 rate_control_mode;
+	u32 initial_rem_delay;
+	u32 cpb_size;
+	u16 framerate;
+	u16 clk_ratio;
+	u32 target_bitrate;
+	u32 max_bitrate;
+	u16 initial_qp;
+	u16 min_qp;
+	u16 max_qp;
+	s16 ip_delta;
+	s16 pb_delta;
+	u16 golden_ref;
+	u16 golden_delta;
+	u16 golden_ref_frequency;
+	u32 rate_control_option;
+	/* gop param */
+	u32 gop_ctrl_mode;
+	u32 freq_ird;
+	u32 freq_lt;
+	u32 gdr_mode;
+	u32 gop_length;
+	u32 unknown39;
+	u32 subframe_latency;
+	u32 lda_control_mode;
+} __attribute__ ((__packed__));
+
+struct mcu_msg_create_channel_response {
+	struct mcu_msg_header header;
+	u32 channel_id;
+	u32 user_id;
+	u32 options;
+	u32 num_core;
+	u32 pps_param;
+	u32 int_buffers_count;
+	u32 int_buffers_size;
+	u32 rec_buffers_count;
+	u32 rec_buffers_size;
+	u32 reserved;
+	u32 error_code;
+} __attribute__ ((__packed__));
+
+struct mcu_msg_destroy_channel {
+	struct mcu_msg_header header;
+	u32 channel_id;
+} __attribute__ ((__packed__));
+
+struct mcu_msg_destroy_channel_response {
+	struct mcu_msg_header header;
+	u32 channel_id;
+} __attribute__ ((__packed__));
+
+struct mcu_msg_push_buffers_internal_buffer {
+	u32 dma_addr;
+	u32 mcu_addr;
+	u32 size;
+} __attribute__ ((__packed__));
+
+struct mcu_msg_push_buffers_internal {
+	struct mcu_msg_header header;
+	u32 channel_id;
+	/* variable length array of mcu_msg_put_internal_buffers_buffer */
+} __attribute__ ((__packed__));
+
+struct mcu_msg_put_stream_buffer {
+	struct mcu_msg_header header;
+	u32 channel_id;
+	u32 dma_addr;
+	u32 mcu_addr;
+	u32 size;
+	u32 offset;
+	u64 stream_id;
+} __attribute__ ((__packed__));
+
+struct mcu_msg_encode_frame {
+	struct mcu_msg_header header;
+	u32 channel_id;
+	u32 reserved;
+	u32 encoding_options;
+	s16 pps_qp;
+	u16 padding;
+	u64 user_param;
+	u64 src_handle;
+	u32 request_options;
+	/* u32 scene_change_delay (optional) */
+	/* rate control param (optional) */
+	/* gop param (optional) */
+	u32 src_y;
+	u32 src_uv;
+	u32 stride;
+	u32 ep2;
+	u64 ep2_v;
+} __attribute__ ((__packed__));
+
+struct mcu_msg_encode_frame_response {
+	struct mcu_msg_header header;
+	u32 channel_id;
+	u64 stream_id;		/* see mcu_msg_put_stream_buffer */
+	u64 user_param;		/* see mcu_msg_encode_frame */
+	u64 src_handle;		/* see mcu_msg_encode_frame */
+	u16 skip;
+	u16 is_ref;
+	u32 initial_removal_delay;
+	u32 dpb_output_delay;
+	u32 size;
+	u32 frame_tag_size;
+	s32 stuffing;
+	s32 filler;
+	u16 num_column;
+	u16 num_row;
+	u16 qp;
+	u8 num_ref_idx_l0;
+	u8 num_ref_idx_l1;
+	u32 partition_table_offset;
+	s32 partition_table_size;
+	u32 sum_complex;
+	s32 tile_width[4];	/* TODO AL_ENC_NUM_CORES = 4 */
+	s32 tile_height[22];	/* TODO AL_MAX_ROWS_TILE = 22 */
+	u32 error_code;
+	u32 slice_type;
+	u32 pic_struct;
+	u8 is_idr;
+	u8 is_first_slice;
+	u8 is_last_slice;
+	u8 reserved;
+	u16 pps_qp;
+	u16 reserved1;
+	u32 reserved2;
+} __attribute__ ((__packed__));
+
+/* Helper functions for channel and user operations */
+
+static unsigned long allegro_next_user_id(struct allegro_dev *dev)
+{
+	if (dev->channel_user_ids == ~0UL)
+		return -EBUSY;
+
+	return ffz(dev->channel_user_ids);
+}
+
+static struct allegro_channel *
+allegro_find_channel_by_user_id(struct allegro_dev *dev,
+				unsigned int user_id)
+{
+	struct allegro_channel *channel;
+
+	list_for_each_entry(channel, &dev->channels, list) {
+		if (channel->user_id == user_id)
+			return channel;
+	}
+
+	return ERR_PTR(-EINVAL);
+}
+
+static struct allegro_channel *
+allegro_find_channel_by_channel_id(struct allegro_dev *dev,
+				   unsigned int channel_id)
+{
+	struct allegro_channel *channel;
+
+	list_for_each_entry(channel, &dev->channels, list) {
+		if (channel->mcu_channel_id == channel_id)
+			return channel;
+	}
+
+	return ERR_PTR(-EINVAL);
+}
+
+static unsigned int estimate_stream_size(unsigned int width, unsigned int height)
+{
+	int num_blocks = DIV_ROUND_UP(width, 64) * DIV_ROUND_UP(height, 64);
+	int pcm_size = SZ_1K + SZ_512;
+	int offset = ENCODER_STREAM_OFFSET;
+	int partition_table = SZ_256;
+
+	return round_up(offset + num_blocks * pcm_size + partition_table, 32);
+}
+
+static enum v4l2_mpeg_video_h264_level
+select_minimum_h264_level(unsigned int width, unsigned int height)
+{
+	unsigned int pic_width_in_mb = DIV_ROUND_UP(width, SIZE_MACROBLOCK);
+	unsigned int frame_height_in_mb = DIV_ROUND_UP(height, SIZE_MACROBLOCK);
+	unsigned int frame_size_in_mb = pic_width_in_mb * frame_height_in_mb;
+	enum v4l2_mpeg_video_h264_level level = V4L2_MPEG_VIDEO_H264_LEVEL_4_0;
+
+	/*
+	 * TODO This a very rudimentary implementation of the level limits
+	 * specified in Annex A.3.1, which for now only respects the frame
+	 * size.
+	 */
+
+	if (frame_size_in_mb <= 99)
+		level = V4L2_MPEG_VIDEO_H264_LEVEL_1_0;
+	else if (frame_size_in_mb <= 396)
+		level = V4L2_MPEG_VIDEO_H264_LEVEL_1_1;
+	else if (frame_size_in_mb <= 792)
+		level = V4L2_MPEG_VIDEO_H264_LEVEL_2_1;
+	else if (frame_size_in_mb <= 1620)
+		level = V4L2_MPEG_VIDEO_H264_LEVEL_2_2;
+	else if (frame_size_in_mb <= 3600)
+		level = V4L2_MPEG_VIDEO_H264_LEVEL_3_1;
+	else if (frame_size_in_mb <= 5120)
+		level = V4L2_MPEG_VIDEO_H264_LEVEL_3_2;
+	else if (frame_size_in_mb <= 8192)
+		level = V4L2_MPEG_VIDEO_H264_LEVEL_4_0;
+	else if (frame_size_in_mb <= 8704)
+		level = V4L2_MPEG_VIDEO_H264_LEVEL_4_2;
+	else if (frame_size_in_mb <= 22080)
+		level = V4L2_MPEG_VIDEO_H264_LEVEL_5_0;
+	else
+		level = V4L2_MPEG_VIDEO_H264_LEVEL_5_1;
+
+	/*
+	 * The encoder supports maximum 4k resolution, which equals a frame
+	 * size of 32400 macro blocks and is supported by Level 5.1 (36864
+	 * macro blocks. Therefore, defaulting to Level 5.1 isn't that bad.
+	 */
+
+	return level;
+}
+
+static unsigned int maximum_bitrate(enum v4l2_mpeg_video_h264_level level)
+{
+	switch (level) {
+	case V4L2_MPEG_VIDEO_H264_LEVEL_1_0:
+		return 64000;
+	case V4L2_MPEG_VIDEO_H264_LEVEL_1B:
+		return 128000;
+	case V4L2_MPEG_VIDEO_H264_LEVEL_1_1:
+		return 192000;
+	case V4L2_MPEG_VIDEO_H264_LEVEL_1_2:
+		return 384000;
+	case V4L2_MPEG_VIDEO_H264_LEVEL_1_3:
+		return 768000;
+	case V4L2_MPEG_VIDEO_H264_LEVEL_2_0:
+		return 2000000;
+	case V4L2_MPEG_VIDEO_H264_LEVEL_2_1:
+		return 4000000;
+	case V4L2_MPEG_VIDEO_H264_LEVEL_2_2:
+		return 4000000;
+	case V4L2_MPEG_VIDEO_H264_LEVEL_3_0:
+		return 10000000;
+	case V4L2_MPEG_VIDEO_H264_LEVEL_3_1:
+		return 14000000;
+	case V4L2_MPEG_VIDEO_H264_LEVEL_3_2:
+		return 20000000;
+	case V4L2_MPEG_VIDEO_H264_LEVEL_4_0:
+		return 20000000;
+	case V4L2_MPEG_VIDEO_H264_LEVEL_4_1:
+		return 50000000;
+	case V4L2_MPEG_VIDEO_H264_LEVEL_4_2:
+		return 50000000;
+	case V4L2_MPEG_VIDEO_H264_LEVEL_5_0:
+		return 135000000;
+	case V4L2_MPEG_VIDEO_H264_LEVEL_5_1:
+	default:
+		return 240000000;
+	}
+}
+
+static unsigned int maximum_cpb_size(enum v4l2_mpeg_video_h264_level level)
+{
+	switch (level) {
+	case V4L2_MPEG_VIDEO_H264_LEVEL_1_0:
+		return 175;
+	case V4L2_MPEG_VIDEO_H264_LEVEL_1B:
+		return 350;
+	case V4L2_MPEG_VIDEO_H264_LEVEL_1_1:
+		return 500;
+	case V4L2_MPEG_VIDEO_H264_LEVEL_1_2:
+		return 1000;
+	case V4L2_MPEG_VIDEO_H264_LEVEL_1_3:
+		return 2000;
+	case V4L2_MPEG_VIDEO_H264_LEVEL_2_0:
+		return 2000;
+	case V4L2_MPEG_VIDEO_H264_LEVEL_2_1:
+		return 4000;
+	case V4L2_MPEG_VIDEO_H264_LEVEL_2_2:
+		return 4000;
+	case V4L2_MPEG_VIDEO_H264_LEVEL_3_0:
+		return 10000;
+	case V4L2_MPEG_VIDEO_H264_LEVEL_3_1:
+		return 14000;
+	case V4L2_MPEG_VIDEO_H264_LEVEL_3_2:
+		return 20000;
+	case V4L2_MPEG_VIDEO_H264_LEVEL_4_0:
+		return 25000;
+	case V4L2_MPEG_VIDEO_H264_LEVEL_4_1:
+		return 62500;
+	case V4L2_MPEG_VIDEO_H264_LEVEL_4_2:
+		return 62500;
+	case V4L2_MPEG_VIDEO_H264_LEVEL_5_0:
+		return 135000;
+	case V4L2_MPEG_VIDEO_H264_LEVEL_5_1:
+	default:
+		return 240000;
+	}
+}
+
+static const struct fw_info *allegro_get_firmware_info(struct allegro_dev *dev,
+						       const struct firmware *fw)
+{
+	int i;
+	unsigned int id = fw->size;
+
+	for (i = 0; i < ARRAY_SIZE(supported_firmware); i++)
+		if (supported_firmware[i].id == id)
+			return &supported_firmware[i];
+
+	return NULL;
+}
+
+/*
+ * Buffers that are used internally by the MCU.
+ */
+
+int allegro_alloc_buffer(struct allegro_dev *dev,
+			 struct allegro_buffer *buffer, size_t size)
+{
+	buffer->vaddr = dma_alloc_coherent(&dev->plat_dev->dev, size,
+					   &buffer->paddr, GFP_KERNEL);
+	if (!buffer->vaddr)
+		return -ENOMEM;
+	buffer->size = size;
+
+	return 0;
+}
+
+void allegro_free_buffer(struct allegro_dev *dev, struct allegro_buffer *buffer)
+{
+	if (buffer->vaddr) {
+		dma_free_coherent(&dev->plat_dev->dev, buffer->size,
+				  buffer->vaddr, buffer->paddr);
+		buffer->vaddr = NULL;
+		buffer->size = 0;
+	}
+}
+
+/*
+ * Mailbox interface to send messages to the MCU.
+ */
+
+static int allegro_mbox_init(struct allegro_dev *dev,
+			     struct allegro_mbox *mbox,
+			     unsigned int base, size_t size)
+{
+	if (!mbox)
+		return -EINVAL;
+
+	mbox->head = base;
+	mbox->tail = base + 0x4;
+	mbox->data = base + 0x8;
+	mbox->size = size;
+	mutex_init(&mbox->lock);
+
+	regmap_write(dev->sram, mbox->head, 0);
+	regmap_write(dev->sram, mbox->tail, 0);
+
+	return 0;
+}
+
+static int allegro_mbox_write(struct allegro_dev *dev,
+			      struct allegro_mbox *mbox, void *src, size_t size)
+{
+	struct mcu_msg_header *header = src;
+	unsigned int tail;
+	size_t size_no_wrap;
+	int err = 0;
+
+	if (!src)
+		return -EINVAL;
+
+	if (size > mbox->size) {
+		v4l2_err(&dev->v4l2_dev,
+			 "message (%lu bytes) to large for mailbox (%lu bytes)\n",
+			 size, mbox->size);
+		return -EINVAL;
+	}
+
+	if (header->length != size - sizeof(*header)) {
+		v4l2_err(&dev->v4l2_dev,
+			 "invalid message length: %u bytes (expected %lu bytes)\n",
+			 header->length, size - sizeof(*header));
+		return -EINVAL;
+	}
+
+	v4l2_dbg(2, debug, &dev->v4l2_dev,
+		"write command message: type %s, body length %d\n",
+		msg_type_name(header->type), header->length);
+
+	mutex_lock(&mbox->lock);
+	regmap_read(dev->sram, mbox->tail, &tail);
+	if (tail > mbox->size) {
+		v4l2_err(&dev->v4l2_dev,
+			 "invalid tail (0x%x): must be smaller than mailbox size (0x%lx)\n",
+			 tail, mbox->size);
+		err = -EIO;
+		goto out;
+	}
+	size_no_wrap = min(size, mbox->size - (size_t)tail);
+	regmap_bulk_write(dev->sram, mbox->data + tail, src, size_no_wrap / 4);
+	regmap_bulk_write(dev->sram, mbox->data,
+			  src + size_no_wrap, (size - size_no_wrap) / 4);
+	regmap_write(dev->sram, mbox->tail, (tail + size) % mbox->size);
+
+out:
+	mutex_unlock(&mbox->lock);
+
+	return err;
+}
+
+static ssize_t allegro_mbox_read(struct allegro_dev *dev,
+				 struct allegro_mbox *mbox,
+				 void *dst, size_t nbyte)
+{
+	struct mcu_msg_header *header;
+	unsigned int head;
+	ssize_t size;
+	size_t body_no_wrap;
+
+	regmap_read(dev->sram, mbox->head, &head);
+	if (head > mbox->size) {
+		v4l2_err(&dev->v4l2_dev,
+			 "invalid head (0x%x): must be smaller than mailbox size (0x%lx)\n",
+			 head, mbox->size);
+		return -EIO;
+	}
+
+	/* Assume that the header does not wrap. */
+	regmap_bulk_read(dev->sram, mbox->data + head,
+			 dst, sizeof(*header) / 4);
+	header = dst;
+	size = header->length + sizeof(*header);
+	if (size > mbox->size || size & 0x3) {
+		v4l2_err(&dev->v4l2_dev,
+			 "invalid message length: %lu bytes (maximum %lu bytes)\n",
+			 header->length + sizeof(*header), mbox->size);
+		return -EIO;
+	}
+	if (size > nbyte) {
+		v4l2_err(&dev->v4l2_dev,
+			 "destination buffer too small: %lu bytes (need %lu bytes)\n",
+			 nbyte, size);
+		return -EINVAL;
+	}
+
+	/*
+	 * The message might wrap within the mailbox. If the message does not
+	 * wrap, the first read will read the entire message, otherwise the
+	 * first read will read message until the end of the mailbox and the
+	 * second read will read the remaining bytes from the beginning of the
+	 * mailbox.
+	 *
+	 * Skip the header, as was already read to get the size of the body.
+	 */
+	body_no_wrap = min((size_t)header->length,
+			   (mbox->size - (head + sizeof(*header))));
+	regmap_bulk_read(dev->sram, mbox->data + head + sizeof(*header),
+			 dst + sizeof(*header), body_no_wrap / 4);
+	regmap_bulk_read(dev->sram, mbox->data,
+			 dst + sizeof(*header) + body_no_wrap,
+			 (header->length - body_no_wrap) / 4);
+
+	regmap_write(dev->sram, mbox->head, (head + size) % mbox->size);
+
+	v4l2_dbg(2, debug, &dev->v4l2_dev,
+		"read status message: type %s, body length %d\n",
+		msg_type_name(header->type), header->length);
+
+	return size;
+}
+
+static void allegro_mcu_interrupt(struct allegro_dev *dev)
+{
+	regmap_write(dev->regmap, AL5_MCU_INTERRUPT, BIT(0));
+}
+
+static void allegro_mcu_send_init(struct allegro_dev *dev,
+				  dma_addr_t suballoc_dma, size_t suballoc_size)
+{
+	struct mcu_msg_init_request msg;
+
+	msg.header.type = MCU_MSG_TYPE_INIT;
+	msg.header.length = sizeof(msg) - sizeof(msg.header);
+	msg.reserved0 = 0;
+	msg.suballoc_dma = lower_32_bits(suballoc_dma) | MCU_CACHE_OFFSET;
+	msg.suballoc_size = suballoc_size;
+
+	/* TODO Add L2 cache support. */
+	msg.l2_cache[0] = -1;
+	msg.l2_cache[1] = -1;
+	msg.l2_cache[2] = -1;
+
+	allegro_mbox_write(dev, &dev->mbox_command, &msg, sizeof(msg));
+	allegro_mcu_interrupt(dev);
+}
+
+static u32 v4l2_pixelformat_to_mcu_format(u32 pixelformat)
+{
+	switch (pixelformat) {
+	case V4L2_PIX_FMT_NV12:
+		/* AL_420_8BITS: 0x100 -> NV12, 0x88 -> 8 bit */
+		return 0x100 | 0x88;
+	default:
+		return -EINVAL;
+	}
+}
+
+static u32 v4l2_colorspace_to_mcu_colorspace(enum v4l2_colorspace colorspace)
+{
+	switch (colorspace) {
+	case V4L2_COLORSPACE_REC709:
+		return 2;
+	case V4L2_COLORSPACE_SMPTE170M:
+		return 3;
+	case V4L2_COLORSPACE_SMPTE240M:
+		return 4;
+	case V4L2_COLORSPACE_SRGB:
+		return 7;
+	default:
+		/* UNKNOWN */
+		return 0;
+	}
+}
+
+static s8 v4l2_pixelformat_to_mcu_codec(u32 pixelformat)
+{
+	switch (pixelformat) {
+	case V4L2_PIX_FMT_H264:
+	default:
+		return 1;
+	}
+}
+
+static u8 v4l2_profile_to_mcu_profile(enum v4l2_mpeg_video_h264_profile profile)
+{
+	switch (profile) {
+	case V4L2_MPEG_VIDEO_H264_PROFILE_BASELINE:
+	default:
+		return 66;
+	}
+}
+
+static u16 v4l2_level_to_mcu_level(enum v4l2_mpeg_video_h264_level level)
+{
+	switch (level) {
+	case V4L2_MPEG_VIDEO_H264_LEVEL_1_0:
+		return 10;
+	case V4L2_MPEG_VIDEO_H264_LEVEL_1_1:
+		return 11;
+	case V4L2_MPEG_VIDEO_H264_LEVEL_1_2:
+		return 12;
+	case V4L2_MPEG_VIDEO_H264_LEVEL_1_3:
+		return 13;
+	case V4L2_MPEG_VIDEO_H264_LEVEL_2_0:
+		return 20;
+	case V4L2_MPEG_VIDEO_H264_LEVEL_2_1:
+		return 21;
+	case V4L2_MPEG_VIDEO_H264_LEVEL_2_2:
+		return 22;
+	case V4L2_MPEG_VIDEO_H264_LEVEL_3_0:
+		return 30;
+	case V4L2_MPEG_VIDEO_H264_LEVEL_3_1:
+		return 31;
+	case V4L2_MPEG_VIDEO_H264_LEVEL_3_2:
+		return 32;
+	case V4L2_MPEG_VIDEO_H264_LEVEL_4_0:
+		return 40;
+	case V4L2_MPEG_VIDEO_H264_LEVEL_4_1:
+		return 41;
+	case V4L2_MPEG_VIDEO_H264_LEVEL_4_2:
+		return 42;
+	case V4L2_MPEG_VIDEO_H264_LEVEL_5_0:
+		return 50;
+	case V4L2_MPEG_VIDEO_H264_LEVEL_5_1:
+	default:
+		return 51;
+	}
+}
+
+static u32 v4l2_bitrate_mode_to_mcu_mode(enum v4l2_mpeg_video_bitrate_mode mode)
+{
+	switch (mode) {
+	case V4L2_MPEG_VIDEO_BITRATE_MODE_VBR:
+		return 2;
+	case V4L2_MPEG_VIDEO_BITRATE_MODE_CBR:
+	default:
+		return 1;
+	}
+}
+
+static void allegro_mcu_send_create_channel(struct allegro_dev *dev,
+					    struct allegro_channel *channel)
+{
+	struct mcu_msg_create_channel msg;
+
+	msg.header.type = MCU_MSG_TYPE_CREATE_CHANNEL;
+	msg.header.length = sizeof(msg) - sizeof(msg.header);
+
+	msg.user_id = channel->user_id;
+	msg.width = channel->width;
+	msg.height = channel->height;
+	msg.format = v4l2_pixelformat_to_mcu_format(channel->pixelformat);
+	msg.colorspace = v4l2_colorspace_to_mcu_colorspace(channel->colorspace);
+	msg.src_mode = 0x0;
+	msg.profile = v4l2_profile_to_mcu_profile(channel->profile);
+	msg.constraint_set_flags = BIT(1);
+	msg.codec = v4l2_pixelformat_to_mcu_codec(channel->codec);
+	msg.level = v4l2_level_to_mcu_level(channel->level);
+	msg.tier = 0;
+	msg.sps_param = BIT(20) | 0x4a;
+	msg.pps_param = BIT(2);
+	msg.enc_option = AL_OPT_RDO_COST_MODE | AL_OPT_LF_X_TILE |
+			 AL_OPT_LF_X_SLICE | AL_OPT_LF;
+	msg.beta_offset = -1;
+	msg.tc_offset = -1;
+	msg.reserved10 = 0x0000;
+	msg.unknown11 = 0x00000000;
+	msg.unknown12 = 0x00000000;
+	msg.num_slices = 1;
+	msg.prefetch_auto = 0x0000;	/* false */
+	msg.prefetch_mem_offset = 0x00000000;
+	msg.prefetch_mem_size = 0x00000000;
+	msg.clip_vrt_range = 0x0000;
+	msg.clip_hrz_range = 0x0000;
+	msg.me_range[0] = 8;
+	msg.me_range[1] = 8;
+	msg.me_range[2] = 16;
+	msg.me_range[3] = 16;
+	msg.max_cu_size = ilog2(SIZE_MACROBLOCK);
+	msg.min_cu_size = ilog2(8);
+	msg.max_tu_size = 2;
+	msg.min_tu_size = 2;
+	msg.max_transfo_depth_intra = 1;
+	msg.max_transfo_depth_inter = 1;
+	msg.reserved20 = 0x0000;
+	msg.entropy_mode = 0x00000000;
+	msg.wp_mode = 0x00000000;
+	msg.rate_control_mode = v4l2_bitrate_mode_to_mcu_mode(channel->bitrate_mode);
+	/* Shall be ]0;cpb_size in  90 kHz units]. Use maximum value for now. */
+	msg.initial_rem_delay = ((channel->cpb_size * 1000) / channel->bitrate_peak) * 90000;
+	/* Encoder expects cpb_size in units of a 90 kHz clock. */
+	msg.cpb_size = ((channel->cpb_size * 1000) / channel->bitrate_peak) * 90000;
+	msg.framerate = 25;
+	msg.clk_ratio = 1000;
+	msg.target_bitrate = channel->bitrate;
+	msg.max_bitrate = channel->bitrate_peak;
+	msg.initial_qp = 25;
+	msg.min_qp = 10;
+	msg.max_qp = 51;
+	msg.ip_delta = -1;
+	msg.pb_delta = -1;
+	msg.golden_ref = 0;
+	msg.golden_delta = 2;
+	msg.golden_ref_frequency = 10;
+	msg.rate_control_option = 0x00000000;
+	msg.gop_ctrl_mode = 0x00000000;
+	msg.freq_ird = 0x7fffffff;	/* MAX_INT??? */
+	msg.freq_lt = 0;
+	msg.gdr_mode = 0x00000000;
+	msg.gop_length = channel->gop_size;
+	msg.unknown39 = 0;
+	msg.subframe_latency = 0x00000000;	/* ??? */
+	msg.lda_control_mode = 0x700d0000;	/* ??? */
+
+	allegro_mbox_write(dev, &dev->mbox_command, &msg, sizeof(msg));
+	allegro_mcu_interrupt(dev);
+}
+
+static int allegro_mcu_send_destroy_channel(struct allegro_dev *dev,
+					    struct allegro_channel *channel)
+{
+	struct mcu_msg_destroy_channel msg;
+
+	msg.header.type = MCU_MSG_TYPE_DESTROY_CHANNEL;
+	msg.header.length = sizeof(msg) - sizeof(msg.header);
+
+	msg.channel_id = channel->mcu_channel_id;
+
+	allegro_mbox_write(dev, &dev->mbox_command, &msg, sizeof(msg));
+	allegro_mcu_interrupt(dev);
+
+	return 0;
+}
+
+static int allegro_mcu_send_put_stream_buffer(struct allegro_dev *dev,
+					      struct allegro_channel *channel,
+					      struct allegro_buffer buffer)
+{
+	struct mcu_msg_put_stream_buffer msg;
+	/*
+	 * TODO It seems that stream_id is not used, but allows to identify
+	 * the used stream buffer from the ENCODE_FRAME response.
+	 */
+	int stream_id = 0;
+
+	msg.header.type = MCU_MSG_TYPE_PUT_STREAM_BUFFER;
+	msg.header.length = sizeof(msg) - sizeof(msg.header);
+
+	msg.channel_id = channel->mcu_channel_id;
+	msg.dma_addr = buffer.paddr;
+	msg.mcu_addr = buffer.paddr | MCU_CACHE_OFFSET;
+	msg.size = buffer.size;
+	msg.offset = ENCODER_STREAM_OFFSET;
+	msg.stream_id = stream_id;
+
+	allegro_mbox_write(dev, &dev->mbox_command, &msg, sizeof(msg));
+	allegro_mcu_interrupt(dev);
+
+	return 0;
+}
+
+static void allegro_mcu_send_encode_frame(struct allegro_dev *dev,
+					  struct allegro_channel *channel,
+					  dma_addr_t src_y, dma_addr_t src_uv)
+{
+	struct mcu_msg_encode_frame msg;
+
+	msg.header.type = MCU_MSG_TYPE_ENCODE_FRAME;
+	/*
+	 * TODO Calculating the length of the message by using the struct size
+	 * breaks once the optional parameters are used.
+	 */
+	msg.header.length = sizeof(msg) - sizeof(msg.header);
+
+	msg.channel_id = channel->mcu_channel_id;
+	msg.encoding_options = 0x2;	/* AL_OPT_FORCE_LOAD */
+	msg.pps_qp = 26;	/* The SliceQP are relative to 26 */
+	msg.padding = 0x0;
+	/*
+	 * TODO It seems that user_param and src_handle are not used by the
+	 * mcu, but allow to relate the response message to the request.
+	 */
+	msg.user_param = 0;
+	msg.src_handle = 0;
+	msg.request_options = 0x0;	/* AL_NO_OPT */
+
+	msg.src_y = src_y;
+	msg.src_uv = src_uv;
+	msg.stride = channel->stride;
+	msg.ep2 = 0x0;
+	msg.ep2_v = msg.ep2 | MCU_CACHE_OFFSET;
+
+	allegro_mbox_write(dev, &dev->mbox_command, &msg, sizeof(msg));
+	allegro_mcu_interrupt(dev);
+}
+
+static int allegro_mcu_wait_for_init_timeout(struct allegro_dev *dev,
+					     unsigned long timeout_ms)
+{
+	unsigned long tmo;
+
+	tmo = wait_for_completion_timeout(&dev->init_complete,
+					  msecs_to_jiffies(timeout_ms));
+	if (tmo == 0)
+		return -ETIMEDOUT;
+
+	reinit_completion(&dev->init_complete);
+	return 0;
+}
+
+static int allegro_mcu_push_buffer_internal(struct allegro_channel *channel,
+					    enum mcu_msg_type type)
+{
+	struct allegro_dev *dev = channel->dev;
+	struct mcu_msg_push_buffers_internal *msg;
+	struct mcu_msg_push_buffers_internal_buffer *buffer;
+	unsigned int num_buffers = 0;
+	unsigned int size;
+	struct allegro_buffer *al_buffer;
+	struct list_head *list;
+	int err;
+
+	if (channel->created)
+		return -EINVAL;
+
+	switch (type) {
+	case MCU_MSG_TYPE_PUSH_BUFFER_REFERENCE:
+		list = &channel->buffers_reference;
+		break;
+	case MCU_MSG_TYPE_PUSH_BUFFER_INTERMEDIATE:
+		list = &channel->buffers_intermediate;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	list_for_each_entry(al_buffer, list, head) {
+		num_buffers++;
+	}
+
+	size = sizeof(*msg) + num_buffers * sizeof(*buffer);
+
+	msg = kmalloc(size, GFP_KERNEL);
+	if (!msg)
+		return -ENOMEM;
+
+	msg->header.length = size - sizeof(msg->header);
+	msg->header.type = type;
+	msg->channel_id = channel->mcu_channel_id;
+
+	buffer =
+	    (struct mcu_msg_push_buffers_internal_buffer *)((char *)msg +
+							    sizeof(*msg));
+	list_for_each_entry(al_buffer, list, head) {
+		buffer->dma_addr = lower_32_bits(al_buffer->paddr);
+		buffer->mcu_addr =
+		    lower_32_bits(al_buffer->paddr) | MCU_CACHE_OFFSET;
+		buffer->size = al_buffer->size;
+		buffer++;
+	}
+
+	err = allegro_mbox_write(dev, &dev->mbox_command, msg, size);
+	if (err)
+		goto out;
+	allegro_mcu_interrupt(dev);
+
+out:
+	kfree(msg);
+	return err;
+}
+
+static int allegro_mcu_push_buffer_intermediate(struct allegro_channel *channel)
+{
+	return allegro_mcu_push_buffer_internal(channel,
+						MCU_MSG_TYPE_PUSH_BUFFER_INTERMEDIATE);
+}
+
+static int allegro_mcu_push_buffer_reference(struct allegro_channel *channel)
+{
+	return allegro_mcu_push_buffer_internal(channel,
+						MCU_MSG_TYPE_PUSH_BUFFER_REFERENCE);
+}
+
+static int allocate_buffers_internal(struct allegro_channel *channel,
+				     struct list_head *list,
+				     size_t n, size_t size)
+{
+	struct allegro_dev *dev = channel->dev;
+	unsigned int i;
+	int err;
+	struct allegro_buffer *buffer, *tmp;
+
+	for (i = 0; i < n; i++) {
+		buffer = kmalloc(sizeof(*buffer), GFP_KERNEL);
+		if (!buffer) {
+			err = -ENOMEM;
+			goto err;
+		}
+		INIT_LIST_HEAD(&buffer->head);
+
+		err = allegro_alloc_buffer(dev, buffer, size);
+		if (err)
+			goto err;
+		list_add(&buffer->head, list);
+	}
+
+	return 0;
+
+err:
+	list_for_each_entry_safe(buffer, tmp, list, head) {
+		list_del(&buffer->head);
+		allegro_free_buffer(dev, buffer);
+		kfree(buffer);
+	}
+	return err;
+}
+
+static void destroy_buffers_internal(struct allegro_channel *channel,
+				     struct list_head *list)
+{
+	struct allegro_dev *dev = channel->dev;
+	struct allegro_buffer *buffer, *tmp;
+
+	list_for_each_entry_safe(buffer, tmp, list, head) {
+		list_del(&buffer->head);
+		allegro_free_buffer(dev, buffer);
+		kfree(buffer);
+	}
+}
+
+static void destroy_reference_buffers(struct allegro_channel *channel)
+{
+	return destroy_buffers_internal(channel, &channel->buffers_reference);
+}
+
+static void destroy_intermediate_buffers(struct allegro_channel *channel)
+{
+	return destroy_buffers_internal(channel,
+					&channel->buffers_intermediate);
+}
+
+static int allocate_intermediate_buffers(struct allegro_channel *channel,
+					 size_t n, size_t size)
+{
+	return allocate_buffers_internal(channel,
+					 &channel->buffers_intermediate,
+					 n, size);
+}
+
+static int allocate_reference_buffers(struct allegro_channel *channel,
+				      size_t n, size_t size)
+{
+	return allocate_buffers_internal(channel,
+					 &channel->buffers_reference,
+					 n, PAGE_ALIGN(size));
+}
+
+static void allegro_finish_frame(struct allegro_channel *channel,
+				 struct mcu_msg_encode_frame_response *msg)
+{
+	struct allegro_dev *dev = channel->dev;
+	struct vb2_v4l2_buffer *src_buf;
+	struct vb2_v4l2_buffer *dst_buf;
+	struct {
+		u32 offset;
+		u32 size;
+	} *partition;
+	enum vb2_buffer_state state = VB2_BUF_STATE_ERROR;
+
+	src_buf = v4l2_m2m_src_buf_remove(channel->fh.m2m_ctx);
+	v4l2_m2m_buf_done(src_buf, VB2_BUF_STATE_DONE);
+
+	dst_buf = v4l2_m2m_dst_buf_remove(channel->fh.m2m_ctx);
+
+	if (msg->error_code) {
+		v4l2_err(&dev->v4l2_dev,
+			 "channel %d: error while encoding frame: %x\n",
+			 channel->mcu_channel_id, msg->error_code);
+		goto err;
+	}
+
+	if (msg->partition_table_size != 1) {
+		v4l2_warn(&dev->v4l2_dev,
+			  "channel %d: only handling first partition table entry (%d entries)\n",
+			  channel->mcu_channel_id, msg->partition_table_size);
+	}
+
+	if (msg->partition_table_offset +
+	    msg->partition_table_size * sizeof(*partition) >
+	    vb2_plane_size(&dst_buf->vb2_buf, 0)) {
+		v4l2_err(&dev->v4l2_dev,
+			 "channel %d: partition table outside of dst_buf\n",
+			 channel->mcu_channel_id);
+		goto err;
+	}
+
+	partition =
+	    vb2_plane_vaddr(&dst_buf->vb2_buf, 0) + msg->partition_table_offset;
+	if (partition->offset + partition->size >
+	    vb2_plane_size(&dst_buf->vb2_buf, 0)) {
+		v4l2_err(&dev->v4l2_dev,
+			 "channel %d: encoded frame is outside of dst_buf (offset 0x%x, size 0x%x)\n",
+			 channel->mcu_channel_id, partition->offset,
+			 partition->size);
+		goto err;
+	}
+
+	v4l2_dbg(2, debug, &dev->v4l2_dev,
+		"channel %d: encoded frame of size %d is at offset 0x%x\n",
+		channel->mcu_channel_id, partition->size, partition->offset);
+
+	/*
+	 * TODO The partition->offset differs from the ENCODER_STREAM_OFFSET.
+	 * Does the encoder add any data before its configured offset that we
+	 * need to handle?
+	 */
+
+	vb2_set_plane_payload(&dst_buf->vb2_buf, 0,
+			      partition->offset + partition->size);
+
+	state = VB2_BUF_STATE_DONE;
+
+	v4l2_dbg(1, debug, &dev->v4l2_dev,
+		 "channel %d: encoded frame (%s%s, %d bytes)\n",
+		 channel->mcu_channel_id,
+		 msg->is_idr ? "IDR, " : "",
+		 msg->slice_type == AL_ENC_SLICE_TYPE_I ? "I slice" :
+		 msg->slice_type == AL_ENC_SLICE_TYPE_P ? "P slice" : "unknown",
+		 partition->size);
+
+err:
+	if (channel->stop) {
+		const struct v4l2_event eos_event = {
+			.type = V4L2_EVENT_EOS
+		};
+		dst_buf->flags |= V4L2_BUF_FLAG_LAST;
+		v4l2_event_queue_fh(&channel->fh, &eos_event);
+	}
+
+	v4l2_m2m_buf_done(dst_buf, state);
+	v4l2_m2m_job_finish(dev->m2m_dev, channel->fh.m2m_ctx);
+}
+
+static int allegro_handle_init(struct allegro_dev *dev,
+			       struct mcu_msg_init_reply *msg)
+{
+	complete(&dev->init_complete);
+
+	return 0;
+}
+
+static int
+allegro_handle_create_channel(struct allegro_dev *dev,
+			      struct mcu_msg_create_channel_response *msg)
+{
+	struct allegro_channel *channel;
+	int err = 0;
+
+	channel = allegro_find_channel_by_user_id(dev, msg->user_id);
+	if (IS_ERR(channel)) {
+		v4l2_warn(&dev->v4l2_dev,
+			  "received %s for unknown user %d\n",
+			  msg_type_name(msg->header.type),
+			  msg->user_id);
+		return -EINVAL;
+	}
+
+	if (msg->error_code) {
+		v4l2_err(&dev->v4l2_dev,
+			 "user %d: failed to create channel: error %d",
+			 channel->user_id, msg->error_code);
+		return -EINVAL;
+	}
+
+	channel->mcu_channel_id = msg->channel_id;
+	v4l2_dbg(1, debug, &dev->v4l2_dev,
+		 "user %d: channel has channel id %d\n",
+		 channel->user_id, channel->mcu_channel_id);
+
+	v4l2_dbg(1, debug, &dev->v4l2_dev,
+		 "channel %d: intermediate buffers: %d x %d bytes\n",
+		 channel->mcu_channel_id, msg->int_buffers_count,
+		 msg->int_buffers_size);
+	err = allocate_intermediate_buffers(channel, msg->int_buffers_count,
+					    msg->int_buffers_size);
+	if (err) {
+		v4l2_err(&dev->v4l2_dev,
+			 "channel %d: failed to allocate intermediate buffers",
+			 channel->mcu_channel_id);
+		goto out;
+	}
+	allegro_mcu_push_buffer_intermediate(channel);
+	if (err) {
+		v4l2_err(&dev->v4l2_dev,
+			 "channel %d: failed to push reference buffers",
+			 channel->mcu_channel_id);
+		goto out;
+	}
+
+	v4l2_dbg(1, debug, &dev->v4l2_dev,
+		 "channel %d: reference buffers: %d x %d bytes\n",
+		 channel->mcu_channel_id, msg->rec_buffers_count,
+		 msg->rec_buffers_size);
+	err = allocate_reference_buffers(channel, msg->rec_buffers_count,
+					 msg->rec_buffers_size);
+	if (err) {
+		v4l2_err(&dev->v4l2_dev,
+			 "channel %d: failed to allocate reference buffers",
+			 channel->mcu_channel_id);
+		goto out;
+	}
+	err = allegro_mcu_push_buffer_reference(channel);
+	if (err) {
+		v4l2_err(&dev->v4l2_dev,
+			 "channel %d: failed to push reference buffers",
+			 channel->mcu_channel_id);
+		goto out;
+	}
+
+	channel->created = true;
+
+	/*
+	 * FIXME Need to send CHANNEL_DESTROY if we fail to allocate the
+	 * intermediate or reference buffers?
+	 */
+out:
+	complete(&channel->completion);
+	return err;
+}
+
+static int
+allegro_handle_destroy_channel(struct allegro_dev *dev,
+		struct mcu_msg_destroy_channel_response *msg)
+{
+	struct allegro_channel *channel;
+
+	channel = allegro_find_channel_by_channel_id(dev, msg->channel_id);
+	if (IS_ERR(channel)) {
+		v4l2_err(&dev->v4l2_dev,
+			 "received %s for unknown channel %d\n",
+			 msg_type_name(msg->header.type),
+			 msg->channel_id);
+		return -EINVAL;
+	}
+
+	v4l2_dbg(2, debug, &dev->v4l2_dev,
+			"user %d: vcu destroyed channel %d\n",
+			channel->user_id, channel->mcu_channel_id);
+	complete(&channel->completion);
+
+	return 0;
+}
+
+static int
+allegro_handle_encode_frame(struct allegro_dev *dev,
+			    struct mcu_msg_encode_frame_response *msg)
+{
+	struct allegro_channel *channel;
+
+	channel = allegro_find_channel_by_channel_id(dev, msg->channel_id);
+	if (IS_ERR(channel)) {
+		v4l2_err(&dev->v4l2_dev,
+			 "received %s for unknown channel %d\n",
+			 msg_type_name(msg->header.type),
+			 msg->channel_id);
+		return -EINVAL;
+	}
+
+	/* TODO Not sure if I really want to call this from here */
+	allegro_finish_frame(channel, msg);
+
+	return 0;
+}
+
+static int allegro_receive_message(struct allegro_dev *dev)
+{
+	struct mcu_msg_header *header;
+	ssize_t size;
+	int err = 0;
+
+	/*
+	 * FIXME header is struct mcu_msg_header, but we are allocating memory
+	 * for a struct mcu_msg_encode_one_frm_response, because we only need
+	 * to parse the header before we can determine the type and size of
+	 * the actual message and struct mcu_msg_encode_one_frm_response is
+	 * currently the largest message.
+	 */
+	header = kmalloc(sizeof(struct mcu_msg_encode_frame_response),
+			 GFP_KERNEL);
+	if (!header)
+		return -ENOMEM;
+
+	size = allegro_mbox_read(dev, &dev->mbox_status, header,
+				 sizeof(struct mcu_msg_encode_frame_response));
+	if (size < sizeof(*header)) {
+		v4l2_err(&dev->v4l2_dev,
+			 "invalid mbox message (%ld): must be at least %lu\n",
+			 size, sizeof(*header));
+		err = -EINVAL;
+		goto out;
+	}
+
+	switch(header->type) {
+	case MCU_MSG_TYPE_INIT:
+		err = allegro_handle_init(dev,
+				(struct mcu_msg_init_reply *) header);
+		break;
+	case MCU_MSG_TYPE_CREATE_CHANNEL:
+		err = allegro_handle_create_channel(dev,
+				(struct mcu_msg_create_channel_response *)header);
+		break;
+	case MCU_MSG_TYPE_DESTROY_CHANNEL:
+		err = allegro_handle_destroy_channel(dev,
+				(struct mcu_msg_destroy_channel_response *)header);
+		break;
+	case MCU_MSG_TYPE_ENCODE_FRAME:
+		err = allegro_handle_encode_frame(dev,
+				(struct mcu_msg_encode_frame_response *)header);
+		break;
+	default:
+		v4l2_warn(&dev->v4l2_dev,
+			  "%s: unknown message %s\n",
+			  __func__, msg_type_name(header->type));
+		err = -EINVAL;
+		break;
+	}
+
+out:
+	kfree(header);
+
+	return err;
+}
+
+irqreturn_t allegro_hardirq(int irq, void *data)
+{
+	struct allegro_dev *dev = data;
+	unsigned int status;
+
+	regmap_read(dev->regmap, AL5_ITC_CPU_IRQ_STA, &status);
+	if (!(status & AL5_ITC_CPU_IRQ_STA_TRIGGERED))
+		return IRQ_NONE;
+
+	regmap_write(dev->regmap, AL5_ITC_CPU_IRQ_CLR, status);
+
+	/*
+	 * The downstream driver suggests to wait until the clear has
+	 * propagated through the hardware, i.e.,
+	 *
+	 * 	!(read(AL5_ITC_CPU_IRQ_STA) & AL5_ITC_CPU_IRQ_STA_TRIGGERED)
+	 *
+	 * I assume that waiting for the interrupt to be cleared is not
+	 * required and just continue execution.
+	 */
+
+	return IRQ_WAKE_THREAD;
+}
+
+irqreturn_t allegro_irq_thread(int irq, void *data)
+{
+	struct allegro_dev *dev = data;
+
+	allegro_receive_message(dev);
+
+	return IRQ_HANDLED;
+}
+
+static void allegro_copy_firmware(struct allegro_dev *dev,
+				  const u8 * const buf, size_t size)
+{
+	int err = 0;
+
+	v4l2_dbg(1, debug, &dev->v4l2_dev,
+		"copy mcu firmware (%lu B) to SRAM\n", size);
+	err = regmap_bulk_write(dev->sram, 0x0, buf, size / 4);
+	if (err)
+		v4l2_err(&dev->v4l2_dev,
+			 "failed to copy firmware: %d\n", err);
+}
+
+static void allegro_copy_fw_codec(struct allegro_dev *dev,
+				  const u8 * const buf, size_t size)
+{
+	int err;
+	dma_addr_t icache_offset, dcache_offset;
+
+	/*
+	 * The downstream allocates 600 KB for the codec firmware to have some
+	 * extra space for "possible extensions." My tests were fine with
+	 * allocating just enough memory for the actual firmware, but I am not
+	 * sure that the firmware really does not use the remaining space.
+	 */
+	err = allegro_alloc_buffer(dev, &dev->firmware, size);
+	if (err) {
+		v4l2_err(&dev->v4l2_dev,
+			 "failed to allocate %lu bytes for firmware\n", size);
+		return;
+	}
+
+	v4l2_dbg(1, debug, &dev->v4l2_dev,
+		"copy codec firmware (%ld B) to phys 0x%llx",
+		size, dev->firmware.paddr);
+	memcpy(dev->firmware.vaddr, buf, size);
+
+	regmap_write(dev->regmap, AXI_ADDR_OFFSET_IP,
+		     upper_32_bits(dev->firmware.paddr));
+
+	/*
+	 * TODO I am not sure what the icache and dcache offsets are doing.
+	 * Copy behavior from downstream driver for now.
+	 */
+	icache_offset = dev->firmware.paddr - MCU_CACHE_OFFSET;
+	v4l2_dbg(2, debug, &dev->v4l2_dev,
+		"icache_offset: msb = 0x%x, lsb = 0x%x\n",
+		upper_32_bits(icache_offset), lower_32_bits(icache_offset));
+	regmap_write(dev->regmap, AL5_ICACHE_ADDR_OFFSET_MSB,
+		     upper_32_bits(icache_offset));
+	regmap_write(dev->regmap, AL5_ICACHE_ADDR_OFFSET_LSB,
+		     lower_32_bits(icache_offset));
+
+	dcache_offset =
+	    (dev->firmware.paddr & 0xffffffff00000000) - MCU_CACHE_OFFSET;
+	v4l2_dbg(2, debug, &dev->v4l2_dev,
+		 "dcache_offset: msb = 0x%x, lsb = 0x%x\n",
+		 upper_32_bits(dcache_offset), lower_32_bits(dcache_offset));
+	regmap_write(dev->regmap, AL5_DCACHE_ADDR_OFFSET_MSB,
+		     upper_32_bits(dcache_offset));
+	regmap_write(dev->regmap, AL5_DCACHE_ADDR_OFFSET_LSB,
+		     lower_32_bits(dcache_offset));
+}
+
+/*
+ * Control functions for the MCU
+ */
+
+static void allegro_mcu_enable_interrupts(struct allegro_dev *dev)
+{
+	regmap_write(dev->regmap, AL5_ITC_CPU_IRQ_MSK, BIT(0));
+}
+
+static int allegro_mcu_wait_for_sleep(struct allegro_dev *dev)
+{
+	unsigned long timeout;
+	unsigned int status;
+
+	timeout = jiffies + msecs_to_jiffies(100);
+	while (regmap_read(dev->regmap, AL5_MCU_STA, &status) == 0 &&
+	       status != AL5_MCU_STA_SLEEP) {
+		if (time_after(jiffies, timeout))
+			return -ETIMEDOUT;
+		cpu_relax();
+	}
+
+	return 0;
+}
+
+static int allegro_mcu_start(struct allegro_dev *dev)
+{
+	unsigned long timeout;
+	unsigned int status;
+	int err;
+
+	err = regmap_write(dev->regmap, AL5_MCU_WAKEUP, BIT(0));
+	if (err)
+		return err;
+
+	timeout = jiffies + msecs_to_jiffies(100);
+	while (regmap_read(dev->regmap, AL5_MCU_STA, &status) == 0 &&
+	       status == AL5_MCU_STA_SLEEP) {
+		if (time_after(jiffies, timeout))
+			return -ETIMEDOUT;
+		cpu_relax();
+	}
+
+	err = regmap_write(dev->regmap, AL5_MCU_WAKEUP, 0);
+	if (err)
+		return err;
+
+	return 0;
+}
+
+static int allegro_mcu_reset(struct allegro_dev *dev)
+{
+	int err;
+
+	err = regmap_write(dev->regmap,
+			   AL5_MCU_RESET_MODE, AL5_MCU_RESET_MODE_SLEEP);
+	if (err < 0)
+		return err;
+
+	err = regmap_write(dev->regmap, AL5_MCU_RESET, AL5_MCU_RESET_SOFT);
+	if (err < 0)
+		return err;
+
+	return allegro_mcu_wait_for_sleep(dev);
+}
+
+/*
+ * Create the MCU channel
+ *
+ * After the channel has been created, the picture size, format, colorspace
+ * and framerate are fixed. Also the codec, profile, bitrate, etc. cannot be
+ * changed anymore.
+ *
+ * The channel can be created only once. The MCU will accept source buffers
+ * and stream buffers only after a channel has been created.
+ */
+static int allegro_create_channel(struct allegro_channel *channel)
+{
+	struct allegro_dev *dev = channel->dev;
+	unsigned long timeout;
+	int err;
+	enum v4l2_mpeg_video_h264_level min_level;
+
+	if (channel->created) {
+		v4l2_warn(&dev->v4l2_dev,
+			  "channel already has been created\n");
+		return 0;
+	}
+
+	channel->user_id = allegro_next_user_id(dev);
+	if (channel->user_id < 0) {
+		v4l2_err(&dev->v4l2_dev,
+			 "no free channels available\n");
+		return -EBUSY;
+	}
+	set_bit(channel->user_id, &dev->channel_user_ids);
+
+	v4l2_dbg(1, debug, &dev->v4l2_dev,
+		 "user %d: creating channel (%4.4s, %dx%d@%d) \n",
+		 channel->user_id,
+		 (char *)&channel->codec, channel->width, channel->height, 25);
+
+	min_level = select_minimum_h264_level(channel->width, channel->height);
+	if (channel->level < min_level) {
+		v4l2_warn(&dev->v4l2_dev,
+			  "user %d: selected Level %s too low: increasing to Level %s\n",
+			  channel->user_id,
+			  v4l2_ctrl_get_menu(V4L2_CID_MPEG_VIDEO_H264_LEVEL)[channel->level],
+			  v4l2_ctrl_get_menu(V4L2_CID_MPEG_VIDEO_H264_LEVEL)[min_level]);
+		channel->level = min_level;
+	}
+
+	reinit_completion(&channel->completion);
+	allegro_mcu_send_create_channel(dev, channel);
+	timeout = wait_for_completion_timeout(&channel->completion,
+					      msecs_to_jiffies(5000));
+	if (timeout == 0) {
+		err = -ETIMEDOUT;
+		goto err;
+	}
+	if (!channel->created) {
+		/* FIXME Return a proper error code */
+		err = -1;
+		goto err;
+	}
+
+	v4l2_dbg(1, debug, &dev->v4l2_dev,
+		 "channel %d: accepting buffers\n",
+		 channel->mcu_channel_id);
+
+	return 0;
+
+err:
+	clear_bit(channel->user_id, &dev->channel_user_ids);
+	channel->user_id = -1;
+	return err;
+}
+
+static void allegro_destroy_channel(struct allegro_channel *channel)
+{
+	struct allegro_dev *dev = channel->dev;
+	unsigned long timeout;
+
+	if (!channel->created) {
+		v4l2_warn(&dev->v4l2_dev,
+			  "cannot destroy channel: has not been created\n");
+		return;
+	}
+
+	reinit_completion(&channel->completion);
+	allegro_mcu_send_destroy_channel(dev, channel);
+	timeout = wait_for_completion_timeout(&channel->completion,
+					      msecs_to_jiffies(5000));
+	if (timeout == 0)
+		v4l2_warn(&dev->v4l2_dev,
+			  "timeout while destroying channel %d\n",
+			  channel->mcu_channel_id);
+
+	channel->mcu_channel_id = -1;
+	channel->created = false;
+	clear_bit(channel->user_id, &dev->channel_user_ids);
+	channel->user_id = -1;
+
+	destroy_intermediate_buffers(channel);
+	destroy_reference_buffers(channel);
+}
+
+static void allegro_set_default_params(struct allegro_channel *channel)
+{
+	channel->width = ALLEGRO_WIDTH_DEFAULT;
+	channel->height = ALLEGRO_HEIGHT_DEFAULT;
+	channel->stride = round_up(channel->width, 32);
+
+	channel->colorspace = V4L2_COLORSPACE_REC709;
+	channel->ycbcr_enc = V4L2_YCBCR_ENC_DEFAULT;
+	channel->quantization = V4L2_QUANTIZATION_DEFAULT;
+	channel->xfer_func = V4L2_XFER_FUNC_DEFAULT;
+
+	channel->pixelformat = V4L2_PIX_FMT_NV12;
+	channel->sizeimage_raw = channel->stride * channel->height * 3 / 2;
+
+	channel->codec = V4L2_PIX_FMT_H264;
+	channel->profile = V4L2_MPEG_VIDEO_H264_PROFILE_BASELINE;
+	channel->level =
+		select_minimum_h264_level(channel->width, channel->height);
+	channel->sizeimage_encoded =
+		estimate_stream_size(channel->width, channel->height);
+
+	channel->bitrate_mode = V4L2_MPEG_VIDEO_BITRATE_MODE_CBR;
+	channel->bitrate = maximum_bitrate(channel->level);
+	channel->bitrate_peak = maximum_bitrate(channel->level);
+	channel->cpb_size = maximum_cpb_size(channel->level);
+	channel->gop_size = ALLEGRO_GOP_SIZE_DEFAULT;
+}
+
+static int allegro_queue_setup(struct vb2_queue *vq,
+			       unsigned int *nbuffers, unsigned int *nplanes,
+			       unsigned int sizes[],
+			       struct device *alloc_devs[])
+{
+	struct allegro_channel *channel = vb2_get_drv_priv(vq);
+	struct allegro_dev *dev = channel->dev;
+
+	v4l2_dbg(2, debug, &dev->v4l2_dev,
+		 "%s: queue setup[%s]: nplanes = %d\n",
+		 vq->type == V4L2_BUF_TYPE_VIDEO_OUTPUT ? "output" : "capture",
+		 *nplanes == 0 ? "REQBUFS" : "CREATE_BUFS", *nplanes);
+
+	if (*nplanes != 0) {
+		if (vq->type == V4L2_BUF_TYPE_VIDEO_CAPTURE) {
+			if (*nplanes != 1 ||
+			    sizes[0] < channel->sizeimage_encoded)
+				return -EINVAL;
+
+		} else {
+			if (*nplanes != 1 || sizes[0] < channel->sizeimage_raw)
+				return -EINVAL;
+		}
+		return 0;
+	}
+
+	if (vq->type == V4L2_BUF_TYPE_VIDEO_CAPTURE) {
+		*nplanes = 1;
+		sizes[0] = channel->sizeimage_encoded;
+	} else {
+		*nplanes = 1;
+		sizes[0] = channel->sizeimage_raw;
+	}
+
+	return 0;
+}
+
+static void allegro_buf_queue(struct vb2_buffer *vb)
+{
+	struct allegro_channel *channel = vb2_get_drv_priv(vb->vb2_queue);
+	struct allegro_dev *dev = channel->dev;
+	struct vb2_queue *vq = vb->vb2_queue;
+	struct allegro_buffer al_buf;
+
+	if (vq->type == V4L2_BUF_TYPE_VIDEO_CAPTURE) {
+		al_buf.paddr = vb2_dma_contig_plane_dma_addr(vb, 0);
+		al_buf.size = vb2_plane_size(vb, 0);
+
+		if (poison_capture_buffers)
+			memset(vb2_plane_vaddr(vb, 0), 0x1a, vb2_plane_size(vb, 0));
+
+		v4l2_dbg(1, debug, &dev->v4l2_dev,
+			 "channel %d: queuing stream buffer: paddr: 0x%08llx, %ld bytes\n",
+			 channel->mcu_channel_id, al_buf.paddr, al_buf.size);
+		allegro_mcu_send_put_stream_buffer(dev, channel, al_buf);
+	} else {
+		v4l2_dbg(1, debug, &dev->v4l2_dev,
+			 "channel %d: queuing source buffer\n",
+			 channel->mcu_channel_id);
+	}
+
+	v4l2_m2m_buf_queue(channel->fh.m2m_ctx, to_vb2_v4l2_buffer(vb));
+}
+
+static int allegro_start_streaming(struct vb2_queue *q, unsigned int count)
+{
+	struct allegro_channel *channel = vb2_get_drv_priv(q);
+	struct allegro_dev *dev = channel->dev;
+
+	v4l2_dbg(2, debug, &dev->v4l2_dev,
+		 "%s: start streaming\n",
+		 q->type == V4L2_BUF_TYPE_VIDEO_OUTPUT ? "output" : "capture");
+
+	return 0;
+}
+
+static void allegro_stop_streaming(struct vb2_queue *q)
+{
+	struct allegro_channel *channel = vb2_get_drv_priv(q);
+	struct allegro_dev *dev = channel->dev;
+	struct vb2_v4l2_buffer *buffer;
+
+	v4l2_dbg(2, debug, &dev->v4l2_dev,
+		 "%s: stop streaming\n",
+		 q->type == V4L2_BUF_TYPE_VIDEO_OUTPUT ? "output" : "capture");
+
+	if (q->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) {
+		while ((buffer = v4l2_m2m_src_buf_remove(channel->fh.m2m_ctx)))
+			v4l2_m2m_buf_done(buffer, VB2_BUF_STATE_ERROR);
+	} else if (q->type == V4L2_BUF_TYPE_VIDEO_CAPTURE) {
+		/*
+		 * FIXME The channel is created during queue_setup().
+		 * Therefore, destroying it in stop_streaming might result in
+		 * a start_streaming() without a channel, which is really bad.
+		 */
+		allegro_destroy_channel(channel);
+		while ((buffer = v4l2_m2m_dst_buf_remove(channel->fh.m2m_ctx)))
+			v4l2_m2m_buf_done(buffer, VB2_BUF_STATE_ERROR);
+	}
+}
+
+static const struct vb2_ops allegro_queue_ops = {
+	.queue_setup = allegro_queue_setup,
+	.buf_queue = allegro_buf_queue,
+	.start_streaming = allegro_start_streaming,
+	.stop_streaming = allegro_stop_streaming,
+};
+
+static int allegro_queue_init(void *priv,
+			      struct vb2_queue *src_vq,
+			      struct vb2_queue *dst_vq)
+{
+	int err;
+	struct allegro_channel *channel = priv;
+
+	src_vq->dev = &channel->dev->plat_dev->dev;
+	src_vq->type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
+	src_vq->io_modes = VB2_DMABUF | VB2_MMAP;
+	src_vq->mem_ops = &vb2_dma_contig_memops;
+	src_vq->drv_priv = channel;
+	src_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
+	src_vq->ops = &allegro_queue_ops;
+	src_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
+	err = vb2_queue_init(src_vq);
+	if (err)
+		return err;
+
+	dst_vq->dev = &channel->dev->plat_dev->dev;
+	dst_vq->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	dst_vq->io_modes = VB2_DMABUF | VB2_MMAP;
+	dst_vq->mem_ops = &vb2_dma_contig_memops;
+	dst_vq->drv_priv = channel;
+	dst_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
+	dst_vq->ops = &allegro_queue_ops;
+	dst_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
+	err = vb2_queue_init(dst_vq);
+	if (err)
+		return err;
+
+	return 0;
+}
+
+static int allegro_s_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct allegro_channel *channel = container_of(ctrl->handler,
+						       struct allegro_channel,
+						       ctrl_handler);
+	struct allegro_dev *dev = channel->dev;
+
+	v4l2_dbg(1, debug, &dev->v4l2_dev,
+		 "s_ctrl: id = %d, val = %d\n", ctrl->id, ctrl->val);
+
+	switch (ctrl->id) {
+	case V4L2_CID_MPEG_VIDEO_H264_LEVEL:
+		channel->level = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_BITRATE_MODE:
+		channel->bitrate_mode = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_BITRATE:
+		channel->bitrate = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_BITRATE_PEAK:
+		channel->bitrate_peak = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_H264_CPB_SIZE:
+		channel->cpb_size = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_GOP_SIZE:
+		channel->gop_size = ctrl->val;
+		break;
+	}
+
+	return 0;
+}
+
+static const struct v4l2_ctrl_ops allegro_ctrl_ops = {
+	.s_ctrl = allegro_s_ctrl,
+};
+
+static int allegro_open(struct file *file)
+{
+	struct video_device *vdev = video_devdata(file);
+	struct allegro_dev *dev = video_get_drvdata(vdev);
+	struct allegro_channel *channel = NULL;
+	u64 mask;
+
+	channel = kzalloc(sizeof(*channel), GFP_KERNEL);
+	if (!channel)
+		return -ENOMEM;
+
+	v4l2_fh_init(&channel->fh, vdev);
+	file->private_data = &channel->fh;
+	v4l2_fh_add(&channel->fh);
+
+	init_completion(&channel->completion);
+
+	channel->dev = dev;
+
+	allegro_set_default_params(channel);
+
+	v4l2_ctrl_handler_init(&channel->ctrl_handler, 0);
+	v4l2_ctrl_new_std_menu(&channel->ctrl_handler, &allegro_ctrl_ops,
+			       V4L2_CID_MPEG_VIDEO_H264_PROFILE,
+			       V4L2_MPEG_VIDEO_H264_PROFILE_BASELINE, 0x0,
+			       V4L2_MPEG_VIDEO_H264_PROFILE_BASELINE);
+	mask = 1 << V4L2_MPEG_VIDEO_H264_LEVEL_1B;
+	v4l2_ctrl_new_std_menu(&channel->ctrl_handler, &allegro_ctrl_ops,
+			       V4L2_CID_MPEG_VIDEO_H264_LEVEL,
+			       V4L2_MPEG_VIDEO_H264_LEVEL_5_1, mask,
+			       V4L2_MPEG_VIDEO_H264_LEVEL_5_1);
+	v4l2_ctrl_new_std_menu(&channel->ctrl_handler, &allegro_ctrl_ops,
+			       V4L2_CID_MPEG_VIDEO_BITRATE_MODE,
+			       V4L2_MPEG_VIDEO_BITRATE_MODE_CBR, 0,
+			       channel->bitrate_mode);
+	v4l2_ctrl_new_std(&channel->ctrl_handler, &allegro_ctrl_ops,
+			  V4L2_CID_MPEG_VIDEO_BITRATE,
+			  0, maximum_bitrate(V4L2_MPEG_VIDEO_H264_LEVEL_5_1),
+			  1, channel->bitrate);
+	v4l2_ctrl_new_std(&channel->ctrl_handler, &allegro_ctrl_ops,
+			  V4L2_CID_MPEG_VIDEO_BITRATE_PEAK,
+			  0, maximum_bitrate(V4L2_MPEG_VIDEO_H264_LEVEL_5_1),
+			  1, channel->bitrate_peak);
+	v4l2_ctrl_new_std(&channel->ctrl_handler, &allegro_ctrl_ops,
+			  V4L2_CID_MPEG_VIDEO_H264_CPB_SIZE,
+			  0, maximum_cpb_size(V4L2_MPEG_VIDEO_H264_LEVEL_5_1),
+			  1, channel->cpb_size);
+	v4l2_ctrl_new_std(&channel->ctrl_handler, &allegro_ctrl_ops,
+			  V4L2_CID_MPEG_VIDEO_GOP_SIZE,
+			  0, ALLEGRO_GOP_SIZE_MAX,
+			  1, channel->gop_size);
+	channel->fh.ctrl_handler = &channel->ctrl_handler;
+
+	channel->mcu_channel_id = -1;
+	channel->user_id = -1;
+	channel->created = false;
+	channel->stop = false;
+
+	INIT_LIST_HEAD(&channel->buffers_reference);
+	INIT_LIST_HEAD(&channel->buffers_intermediate);
+
+	channel->fh.m2m_ctx = v4l2_m2m_ctx_init(dev->m2m_dev, channel,
+						allegro_queue_init);
+
+	list_add(&channel->list, &dev->channels);
+
+	return 0;
+}
+
+static int allegro_release(struct file *file)
+{
+	struct allegro_channel *channel = fh_to_channel(file->private_data);
+
+	list_del(&channel->list);
+
+	v4l2_m2m_ctx_release(channel->fh.m2m_ctx);
+
+	v4l2_ctrl_handler_free(&channel->ctrl_handler);
+
+	v4l2_fh_del(&channel->fh);
+	v4l2_fh_exit(&channel->fh);
+
+	kfree(channel);
+
+	return 0;
+}
+
+static int allegro_querycap(struct file *file, void *fh,
+			    struct v4l2_capability *cap)
+{
+	struct video_device *vdev = video_devdata(file);
+	struct allegro_dev *dev = video_get_drvdata(vdev);
+
+	strscpy(cap->driver, KBUILD_MODNAME, sizeof(cap->driver));
+	strscpy(cap->card, "Allegro DVT Video Encoder", sizeof(cap->card));
+	snprintf(cap->bus_info, sizeof(cap->bus_info), "platform:%s",
+		 dev_name(&dev->plat_dev->dev));
+
+	cap->device_caps = V4L2_CAP_VIDEO_M2M | V4L2_CAP_STREAMING;
+	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
+
+	return 0;
+}
+
+static int allegro_enum_fmt_vid(struct file *file, void *fh,
+				struct v4l2_fmtdesc *f)
+{
+	unsigned int num_formats = 1;
+
+	switch (f->type) {
+	case V4L2_BUF_TYPE_VIDEO_OUTPUT:
+		f->pixelformat = V4L2_PIX_FMT_NV12;
+		break;
+	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
+		f->pixelformat = V4L2_PIX_FMT_H264;
+		break;
+	default:
+		return -EINVAL;
+	}
+	if (f->index >= num_formats)
+		return -EINVAL;
+	return 0;
+}
+
+static int allegro_g_fmt_vid_cap(struct file *file, void *fh,
+				 struct v4l2_format *f)
+{
+	struct allegro_channel *channel = fh_to_channel(fh);
+
+	if (f->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		return -EINVAL;
+
+	f->fmt.pix.field = V4L2_FIELD_NONE;
+	f->fmt.pix.width = channel->width;
+	f->fmt.pix.height = channel->height;
+
+	f->fmt.pix.colorspace = channel->colorspace;
+	f->fmt.pix.ycbcr_enc = channel->ycbcr_enc;
+	f->fmt.pix.quantization = channel->quantization;
+	f->fmt.pix.xfer_func = channel->xfer_func;
+
+	f->fmt.pix.pixelformat = channel->codec;
+	f->fmt.pix.flags = V4L2_FMT_FLAG_COMPRESSED;
+	f->fmt.pix.bytesperline = channel->width;
+	f->fmt.pix.sizeimage = channel->sizeimage_encoded;
+
+	return 0;
+}
+
+static int allegro_try_fmt_vid_cap(struct file *file, void *fh,
+				   struct v4l2_format *f)
+{
+	f->fmt.pix.field = V4L2_FIELD_NONE;
+
+	f->fmt.pix.width = clamp_t(__u32, f->fmt.pix.width,
+				   ALLEGRO_WIDTH_MIN, ALLEGRO_WIDTH_MAX);
+	f->fmt.pix.height = clamp_t(__u32, f->fmt.pix.height,
+				    ALLEGRO_HEIGHT_MIN, ALLEGRO_HEIGHT_MAX);
+
+	f->fmt.pix.pixelformat = V4L2_PIX_FMT_H264;
+	f->fmt.pix.flags = V4L2_FMT_FLAG_COMPRESSED;
+	f->fmt.pix.bytesperline = f->fmt.pix.width;
+	f->fmt.pix.sizeimage =
+		estimate_stream_size(f->fmt.pix.width, f->fmt.pix.height);
+
+	return 0;
+}
+
+static int allegro_g_fmt_vid_out(struct file *file, void *fh,
+				 struct v4l2_format *f)
+{
+	struct allegro_channel *channel = fh_to_channel(fh);
+
+	if (f->type != V4L2_BUF_TYPE_VIDEO_OUTPUT)
+		return -EINVAL;
+
+	f->fmt.pix.field = V4L2_FIELD_NONE;
+
+	f->fmt.pix.width = channel->width;
+	f->fmt.pix.height = channel->height;
+
+	f->fmt.pix.colorspace = channel->colorspace;
+	f->fmt.pix.ycbcr_enc = channel->ycbcr_enc;
+	f->fmt.pix.quantization = channel->quantization;
+	f->fmt.pix.xfer_func = channel->xfer_func;
+
+	f->fmt.pix.pixelformat = channel->pixelformat;
+	f->fmt.pix.bytesperline = channel->stride;
+	f->fmt.pix.sizeimage = channel->sizeimage_raw;
+
+	return 0;
+}
+
+static int allegro_try_fmt_vid_out(struct file *file, void *fh,
+				   struct v4l2_format *f)
+{
+	f->fmt.pix.field = V4L2_FIELD_NONE;
+
+	f->fmt.pix.width = clamp_t(__u32, f->fmt.pix.width,
+				   ALLEGRO_WIDTH_MIN, ALLEGRO_WIDTH_MAX);
+	f->fmt.pix.height = clamp_t(__u32, f->fmt.pix.height,
+				    ALLEGRO_HEIGHT_MIN, ALLEGRO_HEIGHT_MAX);
+
+	f->fmt.pix.pixelformat = V4L2_PIX_FMT_NV12;
+	f->fmt.pix.bytesperline = round_up(f->fmt.pix.width, 32);
+	f->fmt.pix.sizeimage =
+		f->fmt.pix.bytesperline * f->fmt.pix.height * 3 / 2;
+
+	return 0;
+}
+
+static int allegro_s_fmt_vid_out(struct file *file, void *fh,
+				 struct v4l2_format *f)
+{
+	struct allegro_channel *channel = fh_to_channel(fh);
+	int err;
+
+	err = allegro_try_fmt_vid_out(file, fh, f);
+	if (err)
+		return err;
+
+	channel->width = f->fmt.pix.width;
+	channel->height = f->fmt.pix.height;
+	channel->stride = f->fmt.pix.bytesperline;
+	channel->sizeimage_raw = f->fmt.pix.sizeimage;
+
+	channel->colorspace = f->fmt.pix.colorspace;
+	channel->ycbcr_enc = f->fmt.pix.ycbcr_enc;
+	channel->quantization = f->fmt.pix.quantization;
+	channel->xfer_func = f->fmt.pix.xfer_func;
+
+	channel->level =
+		select_minimum_h264_level(channel->width, channel->height);
+	channel->sizeimage_encoded =
+		estimate_stream_size(channel->width, channel->height);
+
+	return 0;
+}
+
+static int allegro_try_encoder_cmd(struct file *file, void *fh,
+				   struct v4l2_encoder_cmd *cmd)
+{
+	if (cmd->cmd != V4L2_ENC_CMD_STOP)
+		return -EINVAL;
+
+	return 0;
+}
+
+static int allegro_encoder_cmd(struct file *file, void *fh,
+			       struct v4l2_encoder_cmd *cmd)
+{
+	struct allegro_channel *channel = fh_to_channel(fh);
+	struct allegro_dev *dev = channel->dev;
+	int err;
+
+	err = allegro_try_encoder_cmd(file, fh, cmd);
+	if (err)
+		return err;
+
+	v4l2_dbg(2, debug, &dev->v4l2_dev,
+		 "channel %d: stop encoder\n", channel->mcu_channel_id);
+
+	channel->stop = true;
+
+	return 0;
+}
+
+static int allegro_ioctl_streamon(struct file *file, void *priv,
+				  enum v4l2_buf_type type)
+{
+	struct v4l2_fh *fh = file->private_data;
+	struct allegro_channel *channel = fh_to_channel(fh);
+	struct allegro_dev *dev = channel->dev;
+	int err;
+
+	/*
+	 * The channel should be created as late as possible, but has to be
+	 * created before we queue stream buffers on capture. Therefore,
+	 * start_streaming() is already too late.
+	 */
+	if (type == V4L2_BUF_TYPE_VIDEO_CAPTURE) {
+		err = allegro_create_channel(channel);
+		if (err) {
+			v4l2_err(&dev->v4l2_dev, "failed to create channel");
+			return err;
+		}
+	}
+
+	return v4l2_m2m_streamon(file, fh->m2m_ctx, type);
+}
+
+static const struct v4l2_ioctl_ops allegro_ioctl_ops = {
+	.vidioc_querycap = allegro_querycap,
+	.vidioc_enum_fmt_vid_cap = allegro_enum_fmt_vid,
+	.vidioc_enum_fmt_vid_out = allegro_enum_fmt_vid,
+	.vidioc_g_fmt_vid_cap = allegro_g_fmt_vid_cap,
+	.vidioc_try_fmt_vid_cap = allegro_try_fmt_vid_cap,
+	.vidioc_s_fmt_vid_cap = allegro_try_fmt_vid_cap,
+	.vidioc_g_fmt_vid_out = allegro_g_fmt_vid_out,
+	.vidioc_try_fmt_vid_out = allegro_try_fmt_vid_out,
+	.vidioc_s_fmt_vid_out = allegro_s_fmt_vid_out,
+
+	.vidioc_create_bufs = v4l2_m2m_ioctl_create_bufs,
+	.vidioc_reqbufs = v4l2_m2m_ioctl_reqbufs,
+
+	.vidioc_expbuf = v4l2_m2m_ioctl_expbuf,
+	.vidioc_querybuf = v4l2_m2m_ioctl_querybuf,
+	.vidioc_qbuf = v4l2_m2m_ioctl_qbuf,
+	.vidioc_dqbuf = v4l2_m2m_ioctl_dqbuf,
+
+	.vidioc_streamon = allegro_ioctl_streamon,
+	.vidioc_streamoff = v4l2_m2m_ioctl_streamoff,
+
+	.vidioc_try_encoder_cmd = allegro_try_encoder_cmd,
+	.vidioc_encoder_cmd = allegro_encoder_cmd,
+
+	.vidioc_subscribe_event = v4l2_ctrl_subscribe_event,
+	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
+};
+
+static const struct v4l2_file_operations allegro_fops = {
+	.owner = THIS_MODULE,
+	.open = allegro_open,
+	.release = allegro_release,
+	.poll = v4l2_m2m_fop_poll,
+	.unlocked_ioctl = video_ioctl2,
+	.mmap = v4l2_m2m_fop_mmap,
+};
+
+static int allegro_register_device(struct allegro_dev *dev)
+{
+	struct video_device *video_dev = &dev->video_dev;
+
+	strscpy(video_dev->name, "allegro", sizeof(video_dev->name));
+	video_dev->fops = &allegro_fops;
+	video_dev->ioctl_ops = &allegro_ioctl_ops;
+	video_dev->release = video_device_release_empty;
+	video_dev->lock = &dev->lock;
+	video_dev->v4l2_dev = &dev->v4l2_dev;
+	video_dev->vfl_dir = VFL_DIR_M2M;
+	video_set_drvdata(video_dev, dev);
+
+	v4l2_disable_ioctl(video_dev, VIDIOC_CROPCAP);
+	v4l2_disable_ioctl(video_dev, VIDIOC_G_CROP);
+	v4l2_disable_ioctl(video_dev, VIDIOC_S_CROP);
+
+	return video_register_device(video_dev, VFL_TYPE_GRABBER, 0);
+}
+
+static void allegro_device_run(void *priv)
+{
+	struct allegro_channel *channel = priv;
+	struct allegro_dev *dev = channel->dev;
+	struct vb2_v4l2_buffer *src_buf;
+	dma_addr_t src_y;
+	dma_addr_t src_uv;
+
+	src_buf = v4l2_m2m_next_src_buf(channel->fh.m2m_ctx);
+
+	src_y = vb2_dma_contig_plane_dma_addr(&src_buf->vb2_buf, 0);
+	src_uv = src_y + (channel->stride * channel->height);
+
+	allegro_mcu_send_encode_frame(dev, channel, src_y, src_uv);
+}
+
+static int allegro_job_ready(void *priv)
+{
+	struct allegro_channel *channel = priv;
+	struct allegro_dev *dev = channel->dev;
+
+	if (v4l2_m2m_num_src_bufs_ready(channel->fh.m2m_ctx) == 0) {
+		v4l2_dbg(2, debug, &dev->v4l2_dev,
+			 "channel %d: no frame buffers\n",
+			 channel->mcu_channel_id);
+		return false;
+	}
+
+	if (v4l2_m2m_num_dst_bufs_ready(channel->fh.m2m_ctx) == 0) {
+		v4l2_dbg(2, debug, &dev->v4l2_dev,
+			 "channel %d: no stream buffers\n",
+			 channel->mcu_channel_id);
+		return false;
+	}
+
+	return true;
+}
+
+static void allegro_job_abort(void *priv)
+{
+	struct allegro_channel *channel = priv;
+	struct allegro_dev *dev = channel->dev;
+
+	v4l2_dbg(1, debug, &dev->v4l2_dev, "%s\n", __func__);
+}
+
+static const struct v4l2_m2m_ops allegro_m2m_ops = {
+	.device_run = allegro_device_run,
+	.job_ready = allegro_job_ready,
+	.job_abort = allegro_job_abort,
+};
+
+static void allegro_fw_callback(const struct firmware *fw, void *context)
+{
+	struct allegro_dev *dev = context;
+	const char *fw_codec_name = "al5e.fw";
+	const struct firmware *fw_codec;
+	int err;
+	const struct fw_info *info;
+
+	info = allegro_get_firmware_info(dev, fw);
+	if (!info) {
+		v4l2_err(&dev->v4l2_dev,
+			 "mcu firmware %s is not supported\n", fw_codec_name);
+		release_firmware(fw);
+		return;
+	}
+	v4l2_dbg(1, debug, &dev->v4l2_dev,
+		 "detected mcu firmware version '%s'\n", info->version);
+
+	allegro_mcu_reset(dev);
+
+	allegro_copy_firmware(dev, fw->data, fw->size);
+	release_firmware(fw);
+
+	v4l2_dbg(1, debug, &dev->v4l2_dev,
+		 "requesting firmware '%s'\n", fw_codec_name);
+	err = request_firmware(&fw_codec, fw_codec_name, &dev->plat_dev->dev);
+	if (err) {
+		v4l2_err(&dev->v4l2_dev,
+			 "cannot find codec firmware '%s'\n", fw_codec_name);
+		release_firmware(fw_codec);
+		return;
+	}
+	allegro_copy_fw_codec(dev, fw_codec->data, fw_codec->size);
+	release_firmware(fw_codec);
+
+	allegro_mbox_init(dev, &dev->mbox_command, MAILBOX_CMD, MAILBOX_SIZE);
+	allegro_mbox_init(dev, &dev->mbox_status, MAILBOX_STATUS, MAILBOX_SIZE);
+
+	allegro_mcu_enable_interrupts(dev);
+	allegro_mcu_start(dev);
+
+	/* The MCU sends an INIT message once it has started. */
+	err = allegro_mcu_wait_for_init_timeout(dev, 5000);
+	if (err == -ETIMEDOUT) {
+		v4l2_err(&dev->v4l2_dev,
+			 "no INIT from MCU after start\n");
+		return;
+	}
+
+	err =
+	    allegro_alloc_buffer(dev, &dev->suballocator,
+				 MCU_SUBALLOCATOR_SIZE);
+	if (err) {
+		v4l2_err(&dev->v4l2_dev,
+			 "failed to allocate %u bytes for suballocator\n",
+			 MCU_SUBALLOCATOR_SIZE);
+		return;
+	}
+
+	allegro_mcu_send_init(dev, dev->suballocator.paddr,
+			      dev->suballocator.size);
+	err = allegro_mcu_wait_for_init_timeout(dev, 5000);
+	if (err == -ETIMEDOUT) {
+		v4l2_err(&dev->v4l2_dev,
+			 "failed to configure sub-allocator\n");
+		return;
+	}
+
+	dev->m2m_dev = v4l2_m2m_init(&allegro_m2m_ops);
+	if (IS_ERR(dev->m2m_dev)) {
+		v4l2_err(&dev->v4l2_dev, "failed to init mem2mem device\n");
+		return;
+	}
+
+	err = allegro_register_device(dev);
+	if (err) {
+		v4l2_err(&dev->v4l2_dev,
+			 "Failed to register devices\n");
+		return;
+	}
+
+	v4l2_dbg(1, debug, &dev->v4l2_dev,
+		 "allegro codec registered as /dev/video%d\n",
+		 dev->video_dev.num);
+}
+
+static int allegro_firmware_request(struct allegro_dev *dev)
+{
+	const char *fw = "al5e_b.fw";
+
+	v4l2_dbg(1, debug, &dev->v4l2_dev,
+		 "requesting firmware '%s'\n", fw);
+	return request_firmware_nowait(THIS_MODULE, true, fw,
+				       &dev->plat_dev->dev, GFP_KERNEL, dev,
+				       allegro_fw_callback);
+}
+
+static int allegro_probe(struct platform_device *pdev)
+{
+	struct allegro_dev *dev;
+	struct resource *res, *sram_res;
+	int ret;
+	int irq;
+	void __iomem *regs, *sram_regs;
+
+	dev = devm_kzalloc(&pdev->dev, sizeof(*dev), GFP_KERNEL);
+	if (!dev)
+		return -ENOMEM;
+	dev->plat_dev = pdev;
+	init_completion(&dev->init_complete);
+	INIT_LIST_HEAD(&dev->channels);
+
+	mutex_init(&dev->lock);
+
+	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "regs");
+	if (!res) {
+		dev_err(&pdev->dev,
+			"regs resource missing from device tree\n");
+		return -EINVAL;
+	}
+	regs = devm_ioremap_nocache(&pdev->dev, res->start, resource_size(res));
+	if (IS_ERR(regs)) {
+		dev_err(&pdev->dev, "failed to map registers\n");
+		return PTR_ERR(regs);
+	}
+	dev->regmap = devm_regmap_init_mmio(&pdev->dev, regs,
+					    &allegro_regmap_config);
+	if (IS_ERR(dev->regmap)) {
+		dev_err(&pdev->dev, "failed to init regmap\n");
+		return PTR_ERR(dev->regmap);
+	}
+
+	sram_res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "sram");
+	if (!sram_res) {
+		dev_err(&pdev->dev,
+			"sram resource missing from device tree\n");
+		return -EINVAL;
+	}
+	sram_regs = devm_ioremap_nocache(&pdev->dev,
+					 sram_res->start,
+					 resource_size(sram_res));
+	if (IS_ERR(sram_regs)) {
+		dev_err(&pdev->dev, "failed to map sram\n");
+		return PTR_ERR(sram_regs);
+	}
+	dev->sram = devm_regmap_init_mmio(&pdev->dev, sram_regs,
+					  &allegro_sram_config);
+	if (IS_ERR(dev->sram)) {
+		dev_err(&pdev->dev, "failed to init sram\n");
+		return PTR_ERR(dev->sram);
+	}
+
+	irq = platform_get_irq(pdev, 0);
+	if (irq < 0) {
+		dev_err(&pdev->dev, "failed to get irq resource\n");
+		return irq;
+	}
+	ret = devm_request_threaded_irq(&pdev->dev, irq,
+					allegro_hardirq,
+					allegro_irq_thread,
+					IRQF_SHARED, dev_name(&pdev->dev), dev);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "failed to request irq: %d\n", ret);
+		return ret;
+	}
+
+	ret = v4l2_device_register(&pdev->dev, &dev->v4l2_dev);
+	if (ret)
+		return ret;
+
+	platform_set_drvdata(pdev, dev);
+
+	ret = allegro_firmware_request(dev);
+	if (ret < 0) {
+		v4l2_err(&dev->v4l2_dev,
+			 "failed to request firmware: %d\n", ret);
+		return ret;
+	}
+
+	return 0;
+}
+
+static int allegro_remove(struct platform_device *pdev)
+{
+	struct allegro_dev *dev = platform_get_drvdata(pdev);
+
+	allegro_free_buffer(dev, &dev->firmware);
+	allegro_free_buffer(dev, &dev->suballocator);
+
+	video_unregister_device(&dev->video_dev);
+
+	v4l2_m2m_release(dev->m2m_dev);
+
+	v4l2_device_unregister(&dev->v4l2_dev);
+
+	return 0;
+}
+
+static const struct of_device_id allegro_dt_ids[] = {
+	{ .compatible = "allegro,al5e-1.1" },
+	{ /* sentinel */ }
+};
+
+MODULE_DEVICE_TABLE(of, allegro_dt_ids);
+
+static struct platform_driver allegro_driver = {
+	.probe = allegro_probe,
+	.remove = allegro_remove,
+	.driver = {
+		.name = "allegro",
+		.of_match_table = of_match_ptr(allegro_dt_ids),
+	},
+};
+
+module_platform_driver(allegro_driver);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Michael Tretter <kernel@pengutronix.de>");
+MODULE_DESCRIPTION("Allegro DVT encoder and decoder driver");
-- 
2.20.1

