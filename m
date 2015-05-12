Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:43213 "EHLO
	mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932857AbbELQCW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 May 2015 12:02:22 -0400
From: Fabien Dessenne <fabien.dessenne@st.com>
To: <linux-media@vger.kernel.org>
CC: Benjamin Gaignard <benjamin.gaignard@linaro.org>,
	<hugues.fruchet@st.com>
Subject: [PATCH v3 2/3] [media] bdisp: 2D blitter driver using v4l2 mem2mem framework
Date: Tue, 12 May 2015 18:02:10 +0200
Message-ID: <1431446531-11492-3-git-send-email-fabien.dessenne@st.com>
In-Reply-To: <1431446531-11492-1-git-send-email-fabien.dessenne@st.com>
References: <1431446531-11492-1-git-send-email-fabien.dessenne@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This v4l2 mem2mem driver is a 2D blitter for STMicroelectronics SoC.
It uses the v4l2 mem2mem framework.

The following features are supported and tested:
- Color format conversion (RGB32, RGB24, RGB16, NV12, YUV420P)
- Copy
- Scale
- Flip
- Deinterlace
- Wide (4K) picture support
- Crop

Signed-off-by: Fabien Dessenne <fabien.dessenne@st.com>
---
 drivers/media/platform/Kconfig                  |   10 +
 drivers/media/platform/Makefile                 |    2 +
 drivers/media/platform/sti/bdisp/Kconfig        |    9 +
 drivers/media/platform/sti/bdisp/Makefile       |    3 +
 drivers/media/platform/sti/bdisp/bdisp-filter.h |  346 ++++++
 drivers/media/platform/sti/bdisp/bdisp-hw.c     |  783 +++++++++++++
 drivers/media/platform/sti/bdisp/bdisp-reg.h    |  235 ++++
 drivers/media/platform/sti/bdisp/bdisp-v4l2.c   | 1404 +++++++++++++++++++++++
 drivers/media/platform/sti/bdisp/bdisp.h        |  186 +++
 9 files changed, 2978 insertions(+)
 create mode 100644 drivers/media/platform/sti/bdisp/Kconfig
 create mode 100644 drivers/media/platform/sti/bdisp/Makefile
 create mode 100644 drivers/media/platform/sti/bdisp/bdisp-filter.h
 create mode 100644 drivers/media/platform/sti/bdisp/bdisp-hw.c
 create mode 100644 drivers/media/platform/sti/bdisp/bdisp-reg.h
 create mode 100644 drivers/media/platform/sti/bdisp/bdisp-v4l2.c
 create mode 100644 drivers/media/platform/sti/bdisp/bdisp.h

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index 2e30be5..005be89 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -210,6 +210,16 @@ config VIDEO_SAMSUNG_EXYNOS_GSC
 	help
 	  This is a v4l2 driver for Samsung EXYNOS5 SoC G-Scaler.
 
+config VIDEO_STI_BDISP
+	tristate "STMicroelectronics BDISP 2D blitter driver"
+	depends on VIDEO_DEV && VIDEO_V4L2
+	depends on ARCH_STI || COMPILE_TEST
+	depends on HAS_DMA
+	select VIDEOBUF2_DMA_CONTIG
+	select V4L2_MEM2MEM_DEV
+	help
+	  This v4l2 mem2mem driver is a 2D blitter for STMicroelectronics SoC.
+
 config VIDEO_SH_VEU
 	tristate "SuperH VEU mem2mem video processing driver"
 	depends on VIDEO_DEV && VIDEO_V4L2 && HAS_DMA
diff --git a/drivers/media/platform/Makefile b/drivers/media/platform/Makefile
index 3ec1547..b1fc862 100644
--- a/drivers/media/platform/Makefile
+++ b/drivers/media/platform/Makefile
@@ -34,6 +34,8 @@ obj-$(CONFIG_VIDEO_SAMSUNG_S5P_TV)	+= s5p-tv/
 obj-$(CONFIG_VIDEO_SAMSUNG_S5P_G2D)	+= s5p-g2d/
 obj-$(CONFIG_VIDEO_SAMSUNG_EXYNOS_GSC)	+= exynos-gsc/
 
+obj-$(CONFIG_VIDEO_STI_BDISP)		+= sti/bdisp/
+
 obj-$(CONFIG_BLACKFIN)                  += blackfin/
 
 obj-$(CONFIG_ARCH_DAVINCI)		+= davinci/
diff --git a/drivers/media/platform/sti/bdisp/Kconfig b/drivers/media/platform/sti/bdisp/Kconfig
new file mode 100644
index 0000000..afaf4a6
--- /dev/null
+++ b/drivers/media/platform/sti/bdisp/Kconfig
@@ -0,0 +1,9 @@
+config VIDEO_STI_BDISP
+	tristate "STMicroelectronics BDISP 2D blitter driver"
+	depends on VIDEO_DEV && VIDEO_V4L2
+	select VIDEOBUF2_DMA_CONTIG
+	select V4L2_MEM2MEM_DEV
+	help
+	 This v4l2 mem2mem driver is a 2D blitter for STMicroelectronics SoC.
+	 To compile this driver as a module, choose M here: the module will
+	 be called bdisp.ko.
diff --git a/drivers/media/platform/sti/bdisp/Makefile b/drivers/media/platform/sti/bdisp/Makefile
new file mode 100644
index 0000000..2605094
--- /dev/null
+++ b/drivers/media/platform/sti/bdisp/Makefile
@@ -0,0 +1,3 @@
+obj-$(CONFIG_VIDEO_STI_BDISP) := bdisp.o
+
+bdisp-objs := bdisp-v4l2.o bdisp-hw.o
diff --git a/drivers/media/platform/sti/bdisp/bdisp-filter.h b/drivers/media/platform/sti/bdisp/bdisp-filter.h
new file mode 100644
index 0000000..fc8c54f
--- /dev/null
+++ b/drivers/media/platform/sti/bdisp/bdisp-filter.h
@@ -0,0 +1,346 @@
+/*
+ * Copyright (C) STMicroelectronics SA 2014
+ * Authors: Fabien Dessenne <fabien.dessenne@st.com> for STMicroelectronics.
+ * License terms:  GNU General Public License (GPL), version 2
+ */
+
+#define BDISP_HF_NB             64
+#define BDISP_VF_NB             40
+
+/**
+ * struct bdisp_filter_h_spec - Horizontal filter specification
+ *
+ * @min:        min scale factor for this filter (6.10 fixed point)
+ * @max:        max scale factor for this filter (6.10 fixed point)
+ * coef:        filter coefficients
+ */
+struct bdisp_filter_h_spec {
+	const u16 min;
+	const u16 max;
+	const u8 coef[BDISP_HF_NB];
+};
+
+static const struct bdisp_filter_h_spec bdisp_h_spec[] = {
+	{
+		.min = 0,
+		.max = 921,
+		.coef = {
+			0x00, 0x00, 0x00, 0x00, 0x40, 0x00, 0x00, 0x00,
+			0x00, 0x00, 0xff, 0x07, 0x3d, 0xfc, 0x01, 0x00,
+			0x00, 0x01, 0xfd, 0x11, 0x36, 0xf9, 0x02, 0x00,
+			0x00, 0x01, 0xfb, 0x1b, 0x2e, 0xf9, 0x02, 0x00,
+			0x00, 0x01, 0xf9, 0x26, 0x26, 0xf9, 0x01, 0x00,
+			0x00, 0x02, 0xf9, 0x30, 0x19, 0xfb, 0x01, 0x00,
+			0x00, 0x02, 0xf9, 0x39, 0x0e, 0xfd, 0x01, 0x00,
+			0x00, 0x01, 0xfc, 0x3e, 0x06, 0xff, 0x00, 0x00
+		}
+	},
+	{
+		.min = 921,
+		.max = 1024,
+		.coef = {
+			0x00, 0x00, 0x00, 0x00, 0x40, 0x00, 0x00, 0x00,
+			0xff, 0x03, 0xfd, 0x08, 0x3e, 0xf9, 0x04, 0xfe,
+			0xfd, 0x06, 0xf8, 0x13, 0x3b, 0xf4, 0x07, 0xfc,
+			0xfb, 0x08, 0xf5, 0x1f, 0x34, 0xf1, 0x09, 0xfb,
+			0xfb, 0x09, 0xf2, 0x2b, 0x2a, 0xf1, 0x09, 0xfb,
+			0xfb, 0x09, 0xf2, 0x35, 0x1e, 0xf4, 0x08, 0xfb,
+			0xfc, 0x07, 0xf5, 0x3c, 0x12, 0xf7, 0x06, 0xfd,
+			0xfe, 0x04, 0xfa, 0x3f, 0x07, 0xfc, 0x03, 0xff
+		}
+	},
+	{
+		.min = 1024,
+		.max = 1126,
+		.coef = {
+			0x00, 0x00, 0x00, 0x00, 0x40, 0x00, 0x00, 0x00,
+			0xff, 0x03, 0xfd, 0x08, 0x3e, 0xf9, 0x04, 0xfe,
+			0xfd, 0x06, 0xf8, 0x13, 0x3b, 0xf4, 0x07, 0xfc,
+			0xfb, 0x08, 0xf5, 0x1f, 0x34, 0xf1, 0x09, 0xfb,
+			0xfb, 0x09, 0xf2, 0x2b, 0x2a, 0xf1, 0x09, 0xfb,
+			0xfb, 0x09, 0xf2, 0x35, 0x1e, 0xf4, 0x08, 0xfb,
+			0xfc, 0x07, 0xf5, 0x3c, 0x12, 0xf7, 0x06, 0xfd,
+			0xfe, 0x04, 0xfa, 0x3f, 0x07, 0xfc, 0x03, 0xff
+		}
+	},
+	{
+		.min = 1126,
+		.max = 1228,
+		.coef = {
+			0x00, 0x00, 0x00, 0x00, 0x40, 0x00, 0x00, 0x00,
+			0xff, 0x03, 0xfd, 0x08, 0x3e, 0xf9, 0x04, 0xfe,
+			0xfd, 0x06, 0xf8, 0x13, 0x3b, 0xf4, 0x07, 0xfc,
+			0xfb, 0x08, 0xf5, 0x1f, 0x34, 0xf1, 0x09, 0xfb,
+			0xfb, 0x09, 0xf2, 0x2b, 0x2a, 0xf1, 0x09, 0xfb,
+			0xfb, 0x09, 0xf2, 0x35, 0x1e, 0xf4, 0x08, 0xfb,
+			0xfc, 0x07, 0xf5, 0x3c, 0x12, 0xf7, 0x06, 0xfd,
+			0xfe, 0x04, 0xfa, 0x3f, 0x07, 0xfc, 0x03, 0xff
+		}
+	},
+	{
+		.min = 1228,
+		.max = 1331,
+		.coef = {
+			0xfd, 0x04, 0xfc, 0x05, 0x39, 0x05, 0xfc, 0x04,
+			0xfc, 0x06, 0xf9, 0x0c, 0x39, 0xfe, 0x00, 0x02,
+			0xfb, 0x08, 0xf6, 0x17, 0x35, 0xf9, 0x02, 0x00,
+			0xfc, 0x08, 0xf4, 0x20, 0x30, 0xf4, 0x05, 0xff,
+			0xfd, 0x07, 0xf4, 0x29, 0x28, 0xf3, 0x07, 0xfd,
+			0xff, 0x05, 0xf5, 0x31, 0x1f, 0xf3, 0x08, 0xfc,
+			0x00, 0x02, 0xf9, 0x38, 0x14, 0xf6, 0x08, 0xfb,
+			0x02, 0x00, 0xff, 0x3a, 0x0b, 0xf8, 0x06, 0xfc
+		}
+	},
+	{
+		.min = 1331,
+		.max = 1433,
+		.coef = {
+			0xfc, 0x06, 0xf9, 0x09, 0x34, 0x09, 0xf9, 0x06,
+			0xfd, 0x07, 0xf7, 0x10, 0x32, 0x02, 0xfc, 0x05,
+			0xfe, 0x07, 0xf6, 0x17, 0x2f, 0xfc, 0xff, 0x04,
+			0xff, 0x06, 0xf5, 0x20, 0x2a, 0xf9, 0x01, 0x02,
+			0x00, 0x04, 0xf6, 0x27, 0x25, 0xf6, 0x04, 0x00,
+			0x02, 0x01, 0xf9, 0x2d, 0x1d, 0xf5, 0x06, 0xff,
+			0x04, 0xff, 0xfd, 0x31, 0x15, 0xf5, 0x07, 0xfe,
+			0x05, 0xfc, 0x02, 0x35, 0x0d, 0xf7, 0x07, 0xfd
+		}
+	},
+	{
+		.min = 1433,
+		.max = 1536,
+		.coef = {
+			0xfe, 0x06, 0xf8, 0x0b, 0x30, 0x0b, 0xf8, 0x06,
+			0xff, 0x06, 0xf7, 0x12, 0x2d, 0x05, 0xfa, 0x06,
+			0x00, 0x04, 0xf6, 0x18, 0x2c, 0x00, 0xfc, 0x06,
+			0x01, 0x02, 0xf7, 0x1f, 0x27, 0xfd, 0xff, 0x04,
+			0x03, 0x00, 0xf9, 0x24, 0x24, 0xf9, 0x00, 0x03,
+			0x04, 0xff, 0xfd, 0x29, 0x1d, 0xf7, 0x02, 0x01,
+			0x06, 0xfc, 0x00, 0x2d, 0x17, 0xf6, 0x04, 0x00,
+			0x06, 0xfa, 0x05, 0x30, 0x0f, 0xf7, 0x06, 0xff
+		}
+	},
+	{
+		.min = 1536,
+		.max = 2048,
+		.coef = {
+			0x05, 0xfd, 0xfb, 0x13, 0x25, 0x13, 0xfb, 0xfd,
+			0x05, 0xfc, 0xfd, 0x17, 0x24, 0x0f, 0xf9, 0xff,
+			0x04, 0xfa, 0xff, 0x1b, 0x24, 0x0b, 0xf9, 0x00,
+			0x03, 0xf9, 0x01, 0x1f, 0x23, 0x08, 0xf8, 0x01,
+			0x02, 0xf9, 0x04, 0x22, 0x20, 0x04, 0xf9, 0x02,
+			0x01, 0xf8, 0x08, 0x25, 0x1d, 0x01, 0xf9, 0x03,
+			0x00, 0xf9, 0x0c, 0x25, 0x1a, 0xfe, 0xfa, 0x04,
+			0xff, 0xf9, 0x10, 0x26, 0x15, 0xfc, 0xfc, 0x05
+		}
+	},
+	{
+		.min = 2048,
+		.max = 3072,
+		.coef = {
+			0xfc, 0xfd, 0x06, 0x13, 0x18, 0x13, 0x06, 0xfd,
+			0xfc, 0xfe, 0x08, 0x15, 0x17, 0x12, 0x04, 0xfc,
+			0xfb, 0xfe, 0x0a, 0x16, 0x18, 0x10, 0x03, 0xfc,
+			0xfb, 0x00, 0x0b, 0x18, 0x17, 0x0f, 0x01, 0xfb,
+			0xfb, 0x00, 0x0d, 0x19, 0x17, 0x0d, 0x00, 0xfb,
+			0xfb, 0x01, 0x0f, 0x19, 0x16, 0x0b, 0x00, 0xfb,
+			0xfc, 0x03, 0x11, 0x19, 0x15, 0x09, 0xfe, 0xfb,
+			0xfc, 0x04, 0x12, 0x1a, 0x12, 0x08, 0xfe, 0xfc
+		}
+	},
+	{
+		.min = 3072,
+		.max = 4096,
+		.coef = {
+			0xfe, 0x02, 0x09, 0x0f, 0x0e, 0x0f, 0x09, 0x02,
+			0xff, 0x02, 0x09, 0x0f, 0x10, 0x0e, 0x08, 0x01,
+			0xff, 0x03, 0x0a, 0x10, 0x10, 0x0d, 0x07, 0x00,
+			0x00, 0x04, 0x0b, 0x10, 0x0f, 0x0c, 0x06, 0x00,
+			0x00, 0x05, 0x0c, 0x10, 0x0e, 0x0c, 0x05, 0x00,
+			0x00, 0x06, 0x0c, 0x11, 0x0e, 0x0b, 0x04, 0x00,
+			0x00, 0x07, 0x0d, 0x11, 0x0f, 0x0a, 0x03, 0xff,
+			0x01, 0x08, 0x0e, 0x11, 0x0e, 0x09, 0x02, 0xff
+		}
+	},
+	{
+		.min = 4096,
+		.max = 5120,
+		.coef = {
+			0x00, 0x04, 0x09, 0x0c, 0x0e, 0x0c, 0x09, 0x04,
+			0x01, 0x05, 0x09, 0x0c, 0x0d, 0x0c, 0x08, 0x04,
+			0x01, 0x05, 0x0a, 0x0c, 0x0e, 0x0b, 0x08, 0x03,
+			0x02, 0x06, 0x0a, 0x0d, 0x0c, 0x0b, 0x07, 0x03,
+			0x02, 0x07, 0x0a, 0x0d, 0x0d, 0x0a, 0x07, 0x02,
+			0x03, 0x07, 0x0b, 0x0d, 0x0c, 0x0a, 0x06, 0x02,
+			0x03, 0x08, 0x0b, 0x0d, 0x0d, 0x0a, 0x05, 0x01,
+			0x04, 0x08, 0x0c, 0x0d, 0x0c, 0x09, 0x05, 0x01
+		}
+	},
+	{
+		.min = 5120,
+		.max = 65535,
+		.coef = {
+			0x03, 0x06, 0x09, 0x0b, 0x09, 0x0b, 0x09, 0x06,
+			0x03, 0x06, 0x09, 0x0b, 0x0c, 0x0a, 0x08, 0x05,
+			0x03, 0x06, 0x09, 0x0b, 0x0c, 0x0a, 0x08, 0x05,
+			0x04, 0x07, 0x09, 0x0b, 0x0b, 0x0a, 0x08, 0x04,
+			0x04, 0x07, 0x0a, 0x0b, 0x0b, 0x0a, 0x07, 0x04,
+			0x04, 0x08, 0x0a, 0x0b, 0x0b, 0x09, 0x07, 0x04,
+			0x05, 0x08, 0x0a, 0x0b, 0x0c, 0x09, 0x06, 0x03,
+			0x05, 0x08, 0x0a, 0x0b, 0x0c, 0x09, 0x06, 0x03
+		}
+	}
+};
+
+/**
+ * struct bdisp_filter_v_spec - Vertical filter specification
+ *
+ * @min:	min scale factor for this filter (6.10 fixed point)
+ * @max:	max scale factor for this filter (6.10 fixed point)
+ * coef:	filter coefficients
+ */
+struct bdisp_filter_v_spec {
+	const u16 min;
+	const u16 max;
+	const u8 coef[BDISP_VF_NB];
+};
+
+static const struct bdisp_filter_v_spec bdisp_v_spec[] = {
+	{
+		.min = 0,
+		.max = 1024,
+		.coef = {
+			0x00, 0x00, 0x40, 0x00, 0x00,
+			0x00, 0x06, 0x3d, 0xfd, 0x00,
+			0xfe, 0x0f, 0x38, 0xfb, 0x00,
+			0xfd, 0x19, 0x2f, 0xfb, 0x00,
+			0xfc, 0x24, 0x24, 0xfc, 0x00,
+			0xfb, 0x2f, 0x19, 0xfd, 0x00,
+			0xfb, 0x38, 0x0f, 0xfe, 0x00,
+			0xfd, 0x3d, 0x06, 0x00, 0x00
+		}
+	},
+	{
+		.min = 1024,
+		.max = 1331,
+		.coef = {
+			0xfc, 0x05, 0x3e, 0x05, 0xfc,
+			0xf8, 0x0e, 0x3b, 0xff, 0x00,
+			0xf5, 0x18, 0x38, 0xf9, 0x02,
+			0xf4, 0x21, 0x31, 0xf5, 0x05,
+			0xf4, 0x2a, 0x27, 0xf4, 0x07,
+			0xf6, 0x30, 0x1e, 0xf4, 0x08,
+			0xf9, 0x35, 0x15, 0xf6, 0x07,
+			0xff, 0x37, 0x0b, 0xf9, 0x06
+		}
+	},
+	{
+		.min = 1331,
+		.max = 1433,
+		.coef = {
+			0xf8, 0x0a, 0x3c, 0x0a, 0xf8,
+			0xf6, 0x12, 0x3b, 0x02, 0xfb,
+			0xf4, 0x1b, 0x35, 0xfd, 0xff,
+			0xf4, 0x23, 0x30, 0xf8, 0x01,
+			0xf6, 0x29, 0x27, 0xf6, 0x04,
+			0xf9, 0x2e, 0x1e, 0xf5, 0x06,
+			0xfd, 0x31, 0x16, 0xf6, 0x06,
+			0x02, 0x32, 0x0d, 0xf8, 0x07
+		}
+	},
+	{
+		.min = 1433,
+		.max = 1536,
+		.coef = {
+			0xf6, 0x0e, 0x38, 0x0e, 0xf6,
+			0xf5, 0x15, 0x38, 0x06, 0xf8,
+			0xf5, 0x1d, 0x33, 0x00, 0xfb,
+			0xf6, 0x23, 0x2d, 0xfc, 0xfe,
+			0xf9, 0x28, 0x26, 0xf9, 0x00,
+			0xfc, 0x2c, 0x1e, 0xf7, 0x03,
+			0x00, 0x2e, 0x18, 0xf6, 0x04,
+			0x05, 0x2e, 0x11, 0xf7, 0x05
+		}
+	},
+	{
+		.min = 1536,
+		.max = 2048,
+		.coef = {
+			0xfb, 0x13, 0x24, 0x13, 0xfb,
+			0xfd, 0x17, 0x23, 0x0f, 0xfa,
+			0xff, 0x1a, 0x23, 0x0b, 0xf9,
+			0x01, 0x1d, 0x22, 0x07, 0xf9,
+			0x04, 0x20, 0x1f, 0x04, 0xf9,
+			0x07, 0x22, 0x1c, 0x01, 0xfa,
+			0x0b, 0x24, 0x17, 0xff, 0xfb,
+			0x0f, 0x24, 0x14, 0xfd, 0xfc
+		}
+	},
+	{
+		.min = 2048,
+		.max = 3072,
+		.coef = {
+			0x05, 0x10, 0x16, 0x10, 0x05,
+			0x06, 0x11, 0x16, 0x0f, 0x04,
+			0x08, 0x13, 0x15, 0x0e, 0x02,
+			0x09, 0x14, 0x16, 0x0c, 0x01,
+			0x0b, 0x15, 0x15, 0x0b, 0x00,
+			0x0d, 0x16, 0x13, 0x0a, 0x00,
+			0x0f, 0x17, 0x13, 0x08, 0xff,
+			0x11, 0x18, 0x12, 0x07, 0xfe
+		}
+	},
+	{
+		.min = 3072,
+		.max = 4096,
+		.coef = {
+			0x09, 0x0f, 0x10, 0x0f, 0x09,
+			0x09, 0x0f, 0x12, 0x0e, 0x08,
+			0x0a, 0x10, 0x11, 0x0e, 0x07,
+			0x0b, 0x11, 0x11, 0x0d, 0x06,
+			0x0c, 0x11, 0x12, 0x0c, 0x05,
+			0x0d, 0x12, 0x11, 0x0c, 0x04,
+			0x0e, 0x12, 0x11, 0x0b, 0x04,
+			0x0f, 0x13, 0x11, 0x0a, 0x03
+		}
+	},
+	{
+		.min = 4096,
+		.max = 5120,
+		.coef = {
+			0x0a, 0x0e, 0x10, 0x0e, 0x0a,
+			0x0b, 0x0e, 0x0f, 0x0e, 0x0a,
+			0x0b, 0x0f, 0x10, 0x0d, 0x09,
+			0x0c, 0x0f, 0x10, 0x0d, 0x08,
+			0x0d, 0x0f, 0x0f, 0x0d, 0x08,
+			0x0d, 0x10, 0x10, 0x0c, 0x07,
+			0x0e, 0x10, 0x0f, 0x0c, 0x07,
+			0x0f, 0x10, 0x10, 0x0b, 0x06
+		}
+	},
+	{
+		.min = 5120,
+		.max = 65535,
+		.coef = {
+			0x0b, 0x0e, 0x0e, 0x0e, 0x0b,
+			0x0b, 0x0e, 0x0f, 0x0d, 0x0b,
+			0x0c, 0x0e, 0x0f, 0x0d, 0x0a,
+			0x0c, 0x0e, 0x0f, 0x0d, 0x0a,
+			0x0d, 0x0f, 0x0e, 0x0d, 0x09,
+			0x0d, 0x0f, 0x0f, 0x0c, 0x09,
+			0x0e, 0x0f, 0x0e, 0x0c, 0x09,
+			0x0e, 0x0f, 0x0f, 0x0c, 0x08
+		}
+	}
+};
+
+#define NB_H_FILTER ARRAY_SIZE(bdisp_h_spec)
+#define NB_V_FILTER ARRAY_SIZE(bdisp_v_spec)
+
+/* RGB YUV 601 standard conversion */
+static const u32 bdisp_rgb_to_yuv[] = {
+		0x0e1e8bee, 0x08420419, 0xfb5ed471, 0x08004080,
+};
+
+static const u32 bdisp_yuv_to_rgb[] = {
+		0x3324a800, 0xe604ab9c, 0x0004a957, 0x32121eeb,
+};
diff --git a/drivers/media/platform/sti/bdisp/bdisp-hw.c b/drivers/media/platform/sti/bdisp/bdisp-hw.c
new file mode 100644
index 0000000..9c288ac
--- /dev/null
+++ b/drivers/media/platform/sti/bdisp/bdisp-hw.c
@@ -0,0 +1,783 @@
+/*
+ * Copyright (C) STMicroelectronics SA 2014
+ * Authors: Fabien Dessenne <fabien.dessenne@st.com> for STMicroelectronics.
+ * License terms:  GNU General Public License (GPL), version 2
+ */
+
+#include <linux/delay.h>
+
+#include "bdisp.h"
+#include "bdisp-filter.h"
+#include "bdisp-reg.h"
+
+/* Max width of the source frame in a single node */
+#define MAX_SRC_WIDTH           2048
+
+/* Reset & boot poll config */
+#define POLL_RST_MAX            50
+#define POLL_RST_DELAY_MS       20
+
+enum bdisp_target_plan {
+	BDISP_RGB,
+	BDISP_Y,
+	BDISP_CBCR
+};
+
+struct bdisp_op_cfg {
+	bool cconv;          /* RGB - YUV conversion */
+	bool hflip;          /* Horizontal flip */
+	bool vflip;          /* Vertical flip */
+	bool wide;           /* Wide (>MAX_SRC_WIDTH) */
+	bool scale;          /* Scale */
+	u16  h_inc;          /* Horizontal increment in 6.10 format */
+	u16  v_inc;          /* Vertical increment in 6.10 format */
+	bool src_interlaced; /* is the src an interlaced buffer */
+	u8   src_nbp;        /* nb of planes of the src */
+	bool src_yuv;        /* is the src a YUV color format */
+	bool src_420;        /* is the src 4:2:0 chroma subsampled */
+	u8   dst_nbp;        /* nb of planes of the dst */
+	bool dst_yuv;        /* is the dst a YUV color format */
+	bool dst_420;        /* is the dst 4:2:0 chroma subsampled */
+};
+
+struct bdisp_filter_addr {
+	u16 min;             /* Filter min scale factor (6.10 fixed point) */
+	u16 max;             /* Filter max scale factor (6.10 fixed point) */
+	void *virt;          /* Virtual address for filter table */
+	dma_addr_t paddr;    /* Physical address for filter table */
+};
+
+static struct bdisp_filter_addr bdisp_h_filter[NB_H_FILTER];
+static struct bdisp_filter_addr bdisp_v_filter[NB_V_FILTER];
+
+/**
+ * bdisp_hw_reset
+ * @bdisp:      bdisp entity
+ *
+ * Resets HW
+ *
+ * RETURNS:
+ * 0 on success.
+ */
+int bdisp_hw_reset(struct bdisp_dev *bdisp)
+{
+	unsigned int i;
+
+	dev_dbg(bdisp->dev, "%s\n", __func__);
+
+	/* Mask Interrupt */
+	writel(0, bdisp->regs + BLT_ITM0);
+
+	/* Reset */
+	writel(readl(bdisp->regs + BLT_CTL) | BLT_CTL_RESET,
+	       bdisp->regs + BLT_CTL);
+	writel(0, bdisp->regs + BLT_CTL);
+
+	/* Wait for reset done */
+	for (i = 0; i < POLL_RST_MAX; i++) {
+		if (readl(bdisp->regs + BLT_STA1) & BLT_STA1_IDLE)
+			break;
+		msleep(POLL_RST_DELAY_MS);
+	}
+	if (i == POLL_RST_MAX)
+		dev_err(bdisp->dev, "Reset timeout\n");
+
+	return (i == POLL_RST_MAX) ? -EAGAIN : 0;
+}
+
+/**
+ * bdisp_hw_get_and_clear_irq
+ * @bdisp:      bdisp entity
+ *
+ * Read then reset interrupt status
+ *
+ * RETURNS:
+ * 0 if expected interrupt was raised.
+ */
+int bdisp_hw_get_and_clear_irq(struct bdisp_dev *bdisp)
+{
+	u32 its;
+
+	its = readl(bdisp->regs + BLT_ITS);
+
+	/* Check for the only expected IT: LastNode of AQ1 */
+	if (!(its & BLT_ITS_AQ1_LNA)) {
+		dev_dbg(bdisp->dev, "Unexpected IT status: 0x%08X\n", its);
+		writel(its, bdisp->regs + BLT_ITS);
+		return -1;
+	}
+
+	/* Clear and mask */
+	writel(its, bdisp->regs + BLT_ITS);
+	writel(0, bdisp->regs + BLT_ITM0);
+
+	return 0;
+}
+
+/**
+ * bdisp_hw_free_nodes
+ * @ctx:        bdisp context
+ *
+ * Free node memory
+ *
+ * RETURNS:
+ * None
+ */
+void bdisp_hw_free_nodes(struct bdisp_ctx *ctx)
+{
+	if (ctx && ctx->node[0]) {
+		DEFINE_DMA_ATTRS(attrs);
+
+		dma_set_attr(DMA_ATTR_WRITE_COMBINE, &attrs);
+		dma_free_attrs(ctx->bdisp_dev->dev,
+			       sizeof(struct bdisp_node) * MAX_NB_NODE,
+			       ctx->node[0], ctx->node_paddr[0], &attrs);
+	}
+}
+
+/**
+ * bdisp_hw_alloc_nodes
+ * @ctx:        bdisp context
+ *
+ * Allocate dma memory for nodes
+ *
+ * RETURNS:
+ * 0 on success
+ */
+int bdisp_hw_alloc_nodes(struct bdisp_ctx *ctx)
+{
+	struct device *dev = ctx->bdisp_dev->dev;
+	unsigned int i, node_size = sizeof(struct bdisp_node);
+	void *base;
+	dma_addr_t paddr;
+	DEFINE_DMA_ATTRS(attrs);
+
+	/* Allocate all the nodes within a single memory page */
+	dma_set_attr(DMA_ATTR_WRITE_COMBINE, &attrs);
+	base = dma_alloc_attrs(dev, node_size * MAX_NB_NODE, &paddr,
+			       GFP_KERNEL | GFP_DMA, &attrs);
+	if (!base) {
+		dev_err(dev, "%s no mem\n", __func__);
+		return -ENOMEM;
+	}
+
+	memset(base, 0, node_size * MAX_NB_NODE);
+
+	for (i = 0; i < MAX_NB_NODE; i++) {
+		ctx->node[i] = base;
+		ctx->node_paddr[i] = paddr;
+		dev_dbg(dev, "node[%d]=0x%p (paddr=%pad)\n", i, ctx->node[i],
+			&paddr);
+		base += node_size;
+		paddr += node_size;
+	}
+
+	return 0;
+}
+
+/**
+ * bdisp_hw_free_filters
+ * @dev:        device
+ *
+ * Free filters memory
+ *
+ * RETURNS:
+ * None
+ */
+void bdisp_hw_free_filters(struct device *dev)
+{
+	int size = (BDISP_HF_NB * NB_H_FILTER) + (BDISP_VF_NB * NB_V_FILTER);
+
+	if (bdisp_h_filter[0].virt) {
+		DEFINE_DMA_ATTRS(attrs);
+
+		dma_set_attr(DMA_ATTR_WRITE_COMBINE, &attrs);
+		dma_free_attrs(dev, size, bdisp_h_filter[0].virt,
+			       bdisp_h_filter[0].paddr, &attrs);
+	}
+}
+
+/**
+ * bdisp_hw_alloc_filters
+ * @dev:        device
+ *
+ * Allocate dma memory for filters
+ *
+ * RETURNS:
+ * 0 on success
+ */
+int bdisp_hw_alloc_filters(struct device *dev)
+{
+	unsigned int i, size;
+	void *base;
+	dma_addr_t paddr;
+	DEFINE_DMA_ATTRS(attrs);
+
+	/* Allocate all the filters within a single memory page */
+	size = (BDISP_HF_NB * NB_H_FILTER) + (BDISP_VF_NB * NB_V_FILTER);
+	dma_set_attr(DMA_ATTR_WRITE_COMBINE, &attrs);
+	base = dma_alloc_attrs(dev, size, &paddr, GFP_KERNEL | GFP_DMA, &attrs);
+	if (!base)
+		return -ENOMEM;
+
+	/* Setup filter addresses */
+	for (i = 0; i < NB_H_FILTER; i++) {
+		bdisp_h_filter[i].min = bdisp_h_spec[i].min;
+		bdisp_h_filter[i].max = bdisp_h_spec[i].max;
+		memcpy(base, bdisp_h_spec[i].coef, BDISP_HF_NB);
+		bdisp_h_filter[i].virt = base;
+		bdisp_h_filter[i].paddr = paddr;
+		base += BDISP_HF_NB;
+		paddr += BDISP_HF_NB;
+	}
+
+	for (i = 0; i < NB_V_FILTER; i++) {
+		bdisp_v_filter[i].min = bdisp_v_spec[i].min;
+		bdisp_v_filter[i].max = bdisp_v_spec[i].max;
+		memcpy(base, bdisp_v_spec[i].coef, BDISP_VF_NB);
+		bdisp_v_filter[i].virt = base;
+		bdisp_v_filter[i].paddr = paddr;
+		base += BDISP_VF_NB;
+		paddr += BDISP_VF_NB;
+	}
+
+	return 0;
+}
+
+/**
+ * bdisp_hw_get_hf_addr
+ * @inc:        resize increment
+ *
+ * Find the horizontal filter table that fits the resize increment
+ *
+ * RETURNS:
+ * table physical address
+ */
+static dma_addr_t bdisp_hw_get_hf_addr(u16 inc)
+{
+	unsigned int i;
+
+	for (i = NB_H_FILTER - 1; i > 0; i--)
+		if ((bdisp_h_filter[i].min < inc) &&
+		    (inc <= bdisp_h_filter[i].max))
+			break;
+
+	return bdisp_h_filter[i].paddr;
+}
+
+/**
+ * bdisp_hw_get_vf_addr
+ * @inc:        resize increment
+ *
+ * Find the vertical filter table that fits the resize increment
+ *
+ * RETURNS:
+ * table physical address
+ */
+static dma_addr_t bdisp_hw_get_vf_addr(u16 inc)
+{
+	unsigned int i;
+
+	for (i = NB_V_FILTER - 1; i > 0; i--)
+		if ((bdisp_v_filter[i].min < inc) &&
+		    (inc <= bdisp_v_filter[i].max))
+			break;
+
+	return bdisp_v_filter[i].paddr;
+}
+
+/**
+ * bdisp_hw_get_inc
+ * @from:       input size
+ * @to:         output size
+ * @inc:        resize increment in 6.10 format
+ *
+ * Computes the increment (inverse of scale) in 6.10 format
+ *
+ * RETURNS:
+ * 0 on success
+ */
+static int bdisp_hw_get_inc(u32 from, u32 to, u16 *inc)
+{
+	u32 tmp;
+
+	if (!to)
+		return -EINVAL;
+
+	if (to == from) {
+		*inc = 1 << 10;
+		return 0;
+	}
+
+	tmp = (from << 10) / to;
+	if ((tmp > 0xFFFF) || (!tmp))
+		/* overflow (downscale x 63) or too small (upscale x 1024) */
+		return -EINVAL;
+
+	*inc = (u16)tmp;
+
+	return 0;
+}
+
+/**
+ * bdisp_hw_get_hv_inc
+ * @ctx:        device context
+ * @h_inc:      horizontal increment
+ * @v_inc:      vertical increment
+ *
+ * Computes the horizontal & vertical increments (inverse of scale)
+ *
+ * RETURNS:
+ * 0 on success
+ */
+static int bdisp_hw_get_hv_inc(struct bdisp_ctx *ctx, u16 *h_inc, u16 *v_inc)
+{
+	u32 src_w, src_h, dst_w, dst_h;
+
+	src_w = ctx->src.crop.width;
+	src_h = ctx->src.crop.height;
+	dst_w = ctx->dst.width;
+	dst_h = ctx->dst.height;
+
+	if (bdisp_hw_get_inc(src_w, dst_w, h_inc) ||
+	    bdisp_hw_get_inc(src_h, dst_h, v_inc)) {
+		dev_err(ctx->bdisp_dev->dev,
+			"scale factors failed (%dx%d)->(%dx%d)\n",
+			src_w, src_h, dst_w, dst_h);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+/**
+ * bdisp_hw_get_op_cfg
+ * @ctx:        device context
+ * @c:          operation configuration
+ *
+ * Check which blitter operations are expected and sets the scaling increments
+ *
+ * RETURNS:
+ * 0 on success
+ */
+static int bdisp_hw_get_op_cfg(struct bdisp_ctx *ctx, struct bdisp_op_cfg *c)
+{
+	struct device *dev = ctx->bdisp_dev->dev;
+	struct bdisp_frame *src = &ctx->src;
+	struct bdisp_frame *dst = &ctx->dst;
+
+	if (src->width > MAX_SRC_WIDTH * MAX_VERTICAL_STRIDES) {
+		dev_err(dev, "Image width out of HW caps\n");
+		return -EINVAL;
+	}
+
+	c->wide = src->width > MAX_SRC_WIDTH;
+
+	c->hflip = ctx->hflip;
+	c->vflip = ctx->vflip;
+
+	c->src_interlaced = (src->field == V4L2_FIELD_INTERLACED);
+
+	c->src_nbp = src->fmt->nb_planes;
+	c->src_yuv = (src->fmt->pixelformat == V4L2_PIX_FMT_NV12) ||
+			(src->fmt->pixelformat == V4L2_PIX_FMT_YUV420);
+	c->src_420 = c->src_yuv;
+
+	c->dst_nbp = dst->fmt->nb_planes;
+	c->dst_yuv = (dst->fmt->pixelformat == V4L2_PIX_FMT_NV12) ||
+			(dst->fmt->pixelformat == V4L2_PIX_FMT_YUV420);
+	c->dst_420 = c->dst_yuv;
+
+	c->cconv = (c->src_yuv != c->dst_yuv);
+
+	if (bdisp_hw_get_hv_inc(ctx, &c->h_inc, &c->v_inc)) {
+		dev_err(dev, "Scale factor out of HW caps\n");
+		return -EINVAL;
+	}
+
+	/* Deinterlacing adjustment : stretch a field to a frame */
+	if (c->src_interlaced)
+		c->v_inc /= 2;
+
+	if ((c->h_inc != (1 << 10)) || (c->v_inc != (1 << 10)))
+		c->scale = true;
+	else
+		c->scale = false;
+
+	return 0;
+}
+
+/**
+ * bdisp_hw_color_format
+ * @pixelformat: v4l2 pixel format
+ *
+ * v4l2 to bdisp pixel format convert
+ *
+ * RETURNS:
+ * bdisp pixel format
+ */
+static u32 bdisp_hw_color_format(u32 pixelformat)
+{
+	u32 ret;
+
+	switch (pixelformat) {
+	case V4L2_PIX_FMT_YUV420:
+		ret = (BDISP_YUV_3B << BLT_TTY_COL_SHIFT);
+		break;
+	case V4L2_PIX_FMT_NV12:
+		ret = (BDISP_NV12 << BLT_TTY_COL_SHIFT) | BLT_TTY_BIG_END;
+		break;
+	case V4L2_PIX_FMT_RGB565:
+		ret = (BDISP_RGB565 << BLT_TTY_COL_SHIFT);
+		break;
+	case V4L2_PIX_FMT_XBGR32: /* This V4L format actually refers to xRGB */
+		ret = (BDISP_XRGB8888 << BLT_TTY_COL_SHIFT);
+		break;
+	case V4L2_PIX_FMT_RGB24:  /* RGB888 format */
+		ret = (BDISP_RGB888 << BLT_TTY_COL_SHIFT) | BLT_TTY_BIG_END;
+		break;
+	case V4L2_PIX_FMT_ABGR32: /* This V4L format actually refers to ARGB */
+
+	default:
+		ret = (BDISP_ARGB8888 << BLT_TTY_COL_SHIFT) | BLT_TTY_ALPHA_R;
+		break;
+	}
+
+	return ret;
+}
+
+/**
+ * bdisp_hw_build_node
+ * @ctx:        device context
+ * @cfg:        operation configuration
+ * @node:       node to be set
+ * @t_plan:     whether the node refers to a RGB/Y or a CbCr plane
+ * @src_x_offset: x offset in the source image
+ *
+ * Build a node
+ *
+ * RETURNS:
+ * None
+ */
+static void bdisp_hw_build_node(struct bdisp_ctx *ctx,
+				struct bdisp_op_cfg *cfg,
+				struct bdisp_node *node,
+				enum bdisp_target_plan t_plan, int src_x_offset)
+{
+	struct bdisp_frame *src = &ctx->src;
+	struct bdisp_frame *dst = &ctx->dst;
+	u16 h_inc, v_inc, yh_inc, yv_inc;
+	struct v4l2_rect src_rect = src->crop;
+	struct v4l2_rect dst_rect = dst->crop;
+	int dst_x_offset;
+	s32 dst_width = dst->crop.width;
+	u32 src_fmt, dst_fmt;
+	const u32 *ivmx;
+
+	dev_dbg(ctx->bdisp_dev->dev, "%s\n", __func__);
+
+	memset(node, 0, sizeof(*node));
+
+	/* Adjust src and dst areas wrt src_x_offset */
+	src_rect.left += src_x_offset;
+	src_rect.width -= src_x_offset;
+	src_rect.width = min_t(__s32, MAX_SRC_WIDTH, src_rect.width);
+
+	dst_x_offset = (src_x_offset * dst->width) / ctx->src.crop.width;
+	dst_rect.left += dst_x_offset;
+	dst_rect.width = (src_rect.width * dst->width) / ctx->src.crop.width;
+
+	/* General */
+	src_fmt = src->fmt->pixelformat;
+	dst_fmt = dst->fmt->pixelformat;
+
+	node->nip = 0;
+	node->cic = BLT_CIC_ALL_GRP;
+	node->ack = BLT_ACK_BYPASS_S2S3;
+
+	switch (cfg->src_nbp) {
+	case 1:
+		/* Src2 = RGB / Src1 = Src3 = off */
+		node->ins = BLT_INS_S1_OFF | BLT_INS_S2_MEM | BLT_INS_S3_OFF;
+		break;
+	case 2:
+		/* Src3 = Y
+		 * Src2 = CbCr or ColorFill if writing the Y plane
+		 * Src1 = off */
+		node->ins = BLT_INS_S1_OFF | BLT_INS_S3_MEM;
+		if (t_plan == BDISP_Y)
+			node->ins |= BLT_INS_S2_CF;
+		else
+			node->ins |= BLT_INS_S2_MEM;
+		break;
+	case 3:
+	default:
+		/* Src3 = Y
+		 * Src2 = Cb or ColorFill if writing the Y plane
+		 * Src1 = Cr or ColorFill if writing the Y plane */
+		node->ins = BLT_INS_S3_MEM;
+		if (t_plan == BDISP_Y)
+			node->ins |= BLT_INS_S2_CF | BLT_INS_S1_CF;
+		else
+			node->ins |= BLT_INS_S2_MEM | BLT_INS_S1_MEM;
+		break;
+	}
+
+	/* Color convert */
+	node->ins |= cfg->cconv ? BLT_INS_IVMX : 0;
+	/* Scale needed if scaling OR 4:2:0 up/downsampling */
+	node->ins |= (cfg->scale || cfg->src_420 || cfg->dst_420) ?
+			BLT_INS_SCALE : 0;
+
+	/* Target */
+	node->tba = (t_plan == BDISP_CBCR) ? dst->paddr[1] : dst->paddr[0];
+
+	node->tty = dst->bytesperline;
+	node->tty |= bdisp_hw_color_format(dst_fmt);
+	node->tty |= BLT_TTY_DITHER;
+	node->tty |= (t_plan == BDISP_CBCR) ? BLT_TTY_CHROMA : 0;
+	node->tty |= cfg->hflip ? BLT_TTY_HSO : 0;
+	node->tty |= cfg->vflip ? BLT_TTY_VSO : 0;
+
+	if (cfg->dst_420 && (t_plan == BDISP_CBCR)) {
+		/* 420 chroma downsampling */
+		dst_rect.height /= 2;
+		dst_rect.width /= 2;
+		dst_rect.left /= 2;
+		dst_rect.top /= 2;
+		dst_x_offset /= 2;
+		dst_width /= 2;
+	}
+
+	node->txy = cfg->vflip ? (dst_rect.height - 1) : dst_rect.top;
+	node->txy <<= 16;
+	node->txy |= cfg->hflip ? (dst_width - dst_x_offset - 1) :
+			dst_rect.left;
+
+	node->tsz = dst_rect.height << 16 | dst_rect.width;
+
+	if (cfg->src_interlaced) {
+		/* handle only the top field which is half height of a frame */
+		src_rect.top /= 2;
+		src_rect.height /= 2;
+	}
+
+	if (cfg->src_nbp == 1) {
+		/* Src 2 : RGB */
+		node->s2ba = src->paddr[0];
+
+		node->s2ty = src->bytesperline;
+		if (cfg->src_interlaced)
+			node->s2ty *= 2;
+
+		node->s2ty |= bdisp_hw_color_format(src_fmt);
+
+		node->s2xy = src_rect.top << 16 | src_rect.left;
+		node->s2sz = src_rect.height << 16 | src_rect.width;
+	} else {
+		/* Src 2 : Cb or CbCr */
+		if (cfg->src_420) {
+			/* 420 chroma upsampling */
+			src_rect.top /= 2;
+			src_rect.left /= 2;
+			src_rect.width /= 2;
+			src_rect.height /= 2;
+		}
+
+		node->s2ba = src->paddr[1];
+
+		node->s2ty = src->bytesperline;
+		if (cfg->src_nbp == 3)
+			node->s2ty /= 2;
+		if (cfg->src_interlaced)
+			node->s2ty *= 2;
+
+		node->s2ty |= bdisp_hw_color_format(src_fmt);
+
+		node->s2xy = src_rect.top << 16 | src_rect.left;
+		node->s2sz = src_rect.height << 16 | src_rect.width;
+
+		if (cfg->src_nbp == 3) {
+			/* Src 1 : Cr */
+			node->s1ba = src->paddr[2];
+
+			node->s1ty = node->s2ty;
+			node->s1xy = node->s2xy;
+		}
+
+		/* Src 3 : Y */
+		node->s3ba = src->paddr[0];
+
+		node->s3ty = src->bytesperline;
+		if (cfg->src_interlaced)
+			node->s3ty *= 2;
+		node->s3ty |= bdisp_hw_color_format(src_fmt);
+
+		if ((t_plan != BDISP_CBCR) && cfg->src_420) {
+			/* No chroma upsampling for output RGB / Y plane */
+			node->s3xy = node->s2xy * 2;
+			node->s3sz = node->s2sz * 2;
+		} else {
+			/* No need to read Y (Src3) when writing Chroma */
+			node->s3ty |= BLT_S3TY_BLANK_ACC;
+			node->s3xy = node->s2xy;
+			node->s3sz = node->s2sz;
+		}
+	}
+
+	/* Resize (scale OR 4:2:0: chroma up/downsampling) */
+	if (node->ins & BLT_INS_SCALE) {
+		/* no need to compute Y when writing CbCr from RGB input */
+		bool skip_y = (t_plan == BDISP_CBCR) && !cfg->src_yuv;
+
+		/* FCTL */
+		if (cfg->scale) {
+			node->fctl = BLT_FCTL_HV_SCALE;
+			if (!skip_y)
+				node->fctl |= BLT_FCTL_Y_HV_SCALE;
+		} else {
+			node->fctl = BLT_FCTL_HV_SAMPLE;
+			if (!skip_y)
+				node->fctl |= BLT_FCTL_Y_HV_SAMPLE;
+		}
+
+		/* RSF - Chroma may need to be up/downsampled */
+		h_inc = cfg->h_inc;
+		v_inc = cfg->v_inc;
+		if (!cfg->src_420 && cfg->dst_420 && (t_plan == BDISP_CBCR)) {
+			/* RGB to 4:2:0 for Chroma: downsample */
+			h_inc *= 2;
+			v_inc *= 2;
+		} else if (cfg->src_420 && !cfg->dst_420) {
+			/* 4:2:0: to RGB: upsample*/
+			h_inc /= 2;
+			v_inc /= 2;
+		}
+		node->rsf = v_inc << 16 | h_inc;
+
+		/* RZI */
+		node->rzi = BLT_RZI_DEFAULT;
+
+		/* Filter table physical addr */
+		node->hfp = bdisp_hw_get_hf_addr(h_inc);
+		node->vfp = bdisp_hw_get_vf_addr(v_inc);
+
+		/* Y version */
+		if (!skip_y) {
+			yh_inc = cfg->h_inc;
+			yv_inc = cfg->v_inc;
+
+			node->y_rsf = yv_inc << 16 | yh_inc;
+			node->y_rzi = BLT_RZI_DEFAULT;
+			node->y_hfp = bdisp_hw_get_hf_addr(yh_inc);
+			node->y_vfp = bdisp_hw_get_vf_addr(yv_inc);
+		}
+	}
+
+	/* Versatile matrix for RGB / YUV conversion */
+	if (cfg->cconv) {
+		ivmx = cfg->src_yuv ? bdisp_yuv_to_rgb : bdisp_rgb_to_yuv;
+
+		node->ivmx0 = ivmx[0];
+		node->ivmx1 = ivmx[1];
+		node->ivmx2 = ivmx[2];
+		node->ivmx3 = ivmx[3];
+	}
+}
+
+/**
+ * bdisp_hw_build_all_nodes
+ * @ctx:        device context
+ *
+ * Build all the nodes for the blitter operation
+ *
+ * RETURNS:
+ * 0 on success
+ */
+static int bdisp_hw_build_all_nodes(struct bdisp_ctx *ctx)
+{
+	struct bdisp_op_cfg cfg;
+	unsigned int i, nid = 0;
+	int src_x_offset = 0;
+
+	for (i = 0; i < MAX_NB_NODE; i++)
+		if (!ctx->node[i]) {
+			dev_err(ctx->bdisp_dev->dev, "node %d is null\n", i);
+			return -EINVAL;
+		}
+
+	/* Get configuration (scale, flip, ...) */
+	if (bdisp_hw_get_op_cfg(ctx, &cfg))
+		return -EINVAL;
+
+	/* Split source in vertical strides (HW constraint) */
+	for (i = 0; i < MAX_VERTICAL_STRIDES; i++) {
+		/* Build RGB/Y node and link it to the previous node */
+		bdisp_hw_build_node(ctx, &cfg, ctx->node[nid],
+				    cfg.dst_nbp == 1 ? BDISP_RGB : BDISP_Y,
+				    src_x_offset);
+		if (nid)
+			ctx->node[nid - 1]->nip = ctx->node_paddr[nid];
+		nid++;
+
+		/* Build additional Cb(Cr) node, link it to the previous one */
+		if (cfg.dst_nbp > 1) {
+			bdisp_hw_build_node(ctx, &cfg, ctx->node[nid],
+					    BDISP_CBCR, src_x_offset);
+			ctx->node[nid - 1]->nip = ctx->node_paddr[nid];
+			nid++;
+		}
+
+		/* Next stride until full width covered */
+		src_x_offset += MAX_SRC_WIDTH;
+		if (src_x_offset >= ctx->src.crop.width)
+			break;
+	}
+
+	/* Mark last node as the last */
+	ctx->node[nid - 1]->nip = 0;
+
+	return 0;
+}
+
+/**
+ * bdisp_hw_update
+ * @ctx:        device context
+ *
+ * Send the request to the HW
+ *
+ * RETURNS:
+ * 0 on success
+ */
+int bdisp_hw_update(struct bdisp_ctx *ctx)
+{
+	int ret;
+	struct bdisp_dev *bdisp = ctx->bdisp_dev;
+	struct device *dev = bdisp->dev;
+	unsigned int node_id;
+
+	dev_dbg(dev, "%s\n", __func__);
+
+	/* build nodes */
+	ret = bdisp_hw_build_all_nodes(ctx);
+	if (ret) {
+		dev_err(dev, "cannot build nodes (%d)\n", ret);
+		return ret;
+	}
+
+	/* Configure interrupt to 'Last Node Reached for AQ1' */
+	writel(BLT_AQ1_CTL_CFG, bdisp->regs + BLT_AQ1_CTL);
+	writel(BLT_ITS_AQ1_LNA, bdisp->regs + BLT_ITM0);
+
+	/* Write first node addr */
+	writel(ctx->node_paddr[0], bdisp->regs + BLT_AQ1_IP);
+
+	/* Find and write last node addr : this starts the HW processing */
+	for (node_id = 0; node_id < MAX_NB_NODE - 1; node_id++) {
+		if (!ctx->node[node_id]->nip)
+			break;
+	}
+	writel(ctx->node_paddr[node_id], bdisp->regs + BLT_AQ1_LNA);
+
+	return 0;
+}
diff --git a/drivers/media/platform/sti/bdisp/bdisp-reg.h b/drivers/media/platform/sti/bdisp/bdisp-reg.h
new file mode 100644
index 0000000..e7e1a42
--- /dev/null
+++ b/drivers/media/platform/sti/bdisp/bdisp-reg.h
@@ -0,0 +1,235 @@
+/*
+ * Copyright (C) STMicroelectronics SA 2014
+ * Authors: Fabien Dessenne <fabien.dessenne@st.com> for STMicroelectronics.
+ * License terms:  GNU General Public License (GPL), version 2
+ */
+
+struct bdisp_node {
+	/* 0 - General */
+	u32 nip;
+	u32 cic;
+	u32 ins;
+	u32 ack;
+	/* 1 - Target */
+	u32 tba;
+	u32 tty;
+	u32 txy;
+	u32 tsz;
+	/* 2 - Color Fill */
+	u32 s1cf;
+	u32 s2cf;
+	/* 3 - Source 1 */
+	u32 s1ba;
+	u32 s1ty;
+	u32 s1xy;
+	u32 s1sz_tsz;
+	/* 4 - Source 2 */
+	u32 s2ba;
+	u32 s2ty;
+	u32 s2xy;
+	u32 s2sz;
+	/* 5 - Source 3 */
+	u32 s3ba;
+	u32 s3ty;
+	u32 s3xy;
+	u32 s3sz;
+	/* 6 - Clipping */
+	u32 cwo;
+	u32 cws;
+	/* 7 - CLUT */
+	u32 cco;
+	u32 cml;
+	/* 8 - Filter & Mask */
+	u32 fctl;
+	u32 pmk;
+	/* 9 - Chroma Filter */
+	u32 rsf;
+	u32 rzi;
+	u32 hfp;
+	u32 vfp;
+	/* 10 - Luma Filter */
+	u32 y_rsf;
+	u32 y_rzi;
+	u32 y_hfp;
+	u32 y_vfp;
+	/* 11 - Flicker */
+	u32 ff0;
+	u32 ff1;
+	u32 ff2;
+	u32 ff3;
+	/* 12 - Color Key */
+	u32 key1;
+	u32 key2;
+	/* 14 - Static Address & User */
+	u32 sar;
+	u32 usr;
+	/* 15 - Input Versatile Matrix */
+	u32 ivmx0;
+	u32 ivmx1;
+	u32 ivmx2;
+	u32 ivmx3;
+	/* 16 - Output Versatile Matrix */
+	u32 ovmx0;
+	u32 ovmx1;
+	u32 ovmx2;
+	u32 ovmx3;
+	/* 17 - Pace */
+	u32 pace;
+	/* 18 - VC1R & DEI */
+	u32 vc1r;
+	u32 dei;
+	/* 19 - Gradient Fill */
+	u32 hgf;
+	u32 vgf;
+};
+
+/* HW registers : static */
+#define BLT_CTL                 0x0A00
+#define BLT_ITS                 0x0A04
+#define BLT_STA1                0x0A08
+#define BLT_AQ1_CTL             0x0A60
+#define BLT_AQ1_IP              0x0A64
+#define BLT_AQ1_LNA             0x0A68
+#define BLT_AQ1_STA             0x0A6C
+#define BLT_ITM0                0x0AD0
+/* HW registers : plugs */
+#define BLT_PLUGS1_OP2          0x0B04
+#define BLT_PLUGS1_CHZ          0x0B08
+#define BLT_PLUGS1_MSZ          0x0B0C
+#define BLT_PLUGS1_PGZ          0x0B10
+#define BLT_PLUGS2_OP2          0x0B24
+#define BLT_PLUGS2_CHZ          0x0B28
+#define BLT_PLUGS2_MSZ          0x0B2C
+#define BLT_PLUGS2_PGZ          0x0B30
+#define BLT_PLUGS3_OP2          0x0B44
+#define BLT_PLUGS3_CHZ          0x0B48
+#define BLT_PLUGS3_MSZ          0x0B4C
+#define BLT_PLUGS3_PGZ          0x0B50
+#define BLT_PLUGT_OP2           0x0B84
+#define BLT_PLUGT_CHZ           0x0B88
+#define BLT_PLUGT_MSZ           0x0B8C
+#define BLT_PLUGT_PGZ           0x0B90
+/* HW registers : node */
+#define BLT_NIP                 0x0C00
+#define BLT_CIC                 0x0C04
+#define BLT_INS                 0x0C08
+#define BLT_ACK                 0x0C0C
+#define BLT_TBA                 0x0C10
+#define BLT_TTY                 0x0C14
+#define BLT_TXY                 0x0C18
+#define BLT_TSZ                 0x0C1C
+#define BLT_S1BA                0x0C28
+#define BLT_S1TY                0x0C2C
+#define BLT_S1XY                0x0C30
+#define BLT_S2BA                0x0C38
+#define BLT_S2TY                0x0C3C
+#define BLT_S2XY                0x0C40
+#define BLT_S2SZ                0x0C44
+#define BLT_S3BA                0x0C48
+#define BLT_S3TY                0x0C4C
+#define BLT_S3XY                0x0C50
+#define BLT_S3SZ                0x0C54
+#define BLT_FCTL                0x0C68
+#define BLT_RSF                 0x0C70
+#define BLT_RZI                 0x0C74
+#define BLT_HFP                 0x0C78
+#define BLT_VFP                 0x0C7C
+#define BLT_Y_RSF               0x0C80
+#define BLT_Y_RZI               0x0C84
+#define BLT_Y_HFP               0x0C88
+#define BLT_Y_VFP               0x0C8C
+#define BLT_IVMX0               0x0CC0
+#define BLT_IVMX1               0x0CC4
+#define BLT_IVMX2               0x0CC8
+#define BLT_IVMX3               0x0CCC
+#define BLT_OVMX0               0x0CD0
+#define BLT_OVMX1               0x0CD4
+#define BLT_OVMX2               0x0CD8
+#define BLT_OVMX3               0x0CDC
+#define BLT_DEI                 0x0CEC
+/* HW registers : filters */
+#define BLT_HFC_N               0x0D00
+#define BLT_VFC_N               0x0D90
+#define BLT_Y_HFC_N             0x0E00
+#define BLT_Y_VFC_N             0x0E90
+#define BLT_NB_H_COEF           16
+#define BLT_NB_V_COEF           10
+
+/* Registers values */
+#define BLT_CTL_RESET           BIT(31)         /* Global soft reset */
+
+#define BLT_ITS_AQ1_LNA         BIT(12)         /* AQ1 LNA reached */
+
+#define BLT_STA1_IDLE           BIT(0)          /* BDISP idle */
+
+#define BLT_AQ1_CTL_CFG         0x80400003      /* Enable, P3, LNA reached */
+
+#define BLT_INS_S1_MASK         (BIT(0) | BIT(1) | BIT(2))
+#define BLT_INS_S1_OFF          0x00000000      /* src1 disabled */
+#define BLT_INS_S1_MEM          0x00000001      /* src1 fetched from memory */
+#define BLT_INS_S1_CF           0x00000003      /* src1 color fill */
+#define BLT_INS_S1_COPY         0x00000004      /* src1 direct copy */
+#define BLT_INS_S1_FILL         0x00000007      /* src1 firect fill */
+#define BLT_INS_S2_MASK         (BIT(3) | BIT(4))
+#define BLT_INS_S2_OFF          0x00000000      /* src2 disabled */
+#define BLT_INS_S2_MEM          0x00000008      /* src2 fetched from memory */
+#define BLT_INS_S2_CF           0x00000018      /* src2 color fill */
+#define BLT_INS_S3_MASK         BIT(5)
+#define BLT_INS_S3_OFF          0x00000000      /* src3 disabled */
+#define BLT_INS_S3_MEM          0x00000020      /* src3 fetched from memory */
+#define BLT_INS_IVMX            BIT(6)          /* Input versatile matrix */
+#define BLT_INS_CLUT            BIT(7)          /* Color Look Up Table */
+#define BLT_INS_SCALE           BIT(8)          /* Scaling */
+#define BLT_INS_FLICK           BIT(9)          /* Flicker filter */
+#define BLT_INS_CLIP            BIT(10)         /* Clipping */
+#define BLT_INS_CKEY            BIT(11)         /* Color key */
+#define BLT_INS_OVMX            BIT(12)         /* Output versatile matrix */
+#define BLT_INS_DEI             BIT(13)         /* Deinterlace */
+#define BLT_INS_PMASK           BIT(14)         /* Plane mask */
+#define BLT_INS_VC1R            BIT(17)         /* VC1 Range mapping */
+#define BLT_INS_ROTATE          BIT(18)         /* Rotation */
+#define BLT_INS_GRAD            BIT(19)         /* Gradient fill */
+#define BLT_INS_AQLOCK          BIT(29)         /* AQ lock */
+#define BLT_INS_PACE            BIT(30)         /* Pace down */
+#define BLT_INS_IRQ             BIT(31)         /* Raise IRQ when node done */
+#define BLT_CIC_ALL_GRP         0x000FDFFC      /* all valid groups present */
+#define BLT_ACK_BYPASS_S2S3     0x00000007      /* Bypass src2 and src3 */
+
+#define BLT_TTY_COL_SHIFT       16              /* Color format */
+#define BLT_TTY_COL_MASK        0x001F0000      /* Color format mask */
+#define BLT_TTY_ALPHA_R         BIT(21)         /* Alpha range */
+#define BLT_TTY_CR_NOT_CB       BIT(22)         /* CR not Cb */
+#define BLT_TTY_MB              BIT(23)         /* MB frame / field*/
+#define BLT_TTY_HSO             BIT(24)         /* H scan order */
+#define BLT_TTY_VSO             BIT(25)         /* V scan order */
+#define BLT_TTY_DITHER          BIT(26)         /* Dithering */
+#define BLT_TTY_CHROMA          BIT(27)         /* Write chroma / luma */
+#define BLT_TTY_BIG_END         BIT(30)         /* Big endianness */
+
+#define BLT_S1TY_A1_SUBSET      BIT(22)         /* A1 subset */
+#define BLT_S1TY_CHROMA_EXT     BIT(26)         /* Chroma Extended */
+#define BTL_S1TY_SUBBYTE        BIT(28)         /* Sub-byte fmt, pixel order */
+#define BLT_S1TY_RGB_EXP        BIT(29)         /* RGB expansion mode */
+
+#define BLT_S2TY_A1_SUBSET      BIT(22)         /* A1 subset */
+#define BLT_S2TY_CHROMA_EXT     BIT(26)         /* Chroma Extended */
+#define BTL_S2TY_SUBBYTE        BIT(28)         /* Sub-byte fmt, pixel order */
+#define BLT_S2TY_RGB_EXP        BIT(29)         /* RGB expansion mode */
+
+#define BLT_S3TY_BLANK_ACC      BIT(26)         /* Blank access */
+
+#define BLT_FCTL_HV_SCALE       0x00000055      /* H/V resize + color filter */
+#define BLT_FCTL_Y_HV_SCALE     0x33000000      /* Luma version */
+
+#define BLT_FCTL_HV_SAMPLE      0x00000044      /* H/V resize */
+#define BLT_FCTL_Y_HV_SAMPLE    0x22000000      /* Luma version */
+
+#define BLT_RZI_DEFAULT         0x20003000      /* H/VNB_repeat = 3/2 */
+
+/* Color format */
+#define BDISP_RGB565            0x00            /* RGB565 */
+#define BDISP_RGB888            0x01            /* RGB888 */
+#define BDISP_XRGB8888          0x02            /* RGB888_32 */
+#define BDISP_ARGB8888          0x05            /* ARGB888 */
+#define BDISP_NV12              0x16            /* YCbCr42x R2B */
+#define BDISP_YUV_3B            0x1E            /* YUV (3 buffer) */
diff --git a/drivers/media/platform/sti/bdisp/bdisp-v4l2.c b/drivers/media/platform/sti/bdisp/bdisp-v4l2.c
new file mode 100644
index 0000000..31badf5
--- /dev/null
+++ b/drivers/media/platform/sti/bdisp/bdisp-v4l2.c
@@ -0,0 +1,1404 @@
+/*
+ * Copyright (C) STMicroelectronics SA 2014
+ * Authors: Fabien Dessenne <fabien.dessenne@st.com> for STMicroelectronics.
+ * License terms:  GNU General Public License (GPL), version 2
+ */
+
+#include <linux/errno.h>
+#include <linux/interrupt.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/pm_runtime.h>
+
+#include <media/v4l2-event.h>
+#include <media/v4l2-ioctl.h>
+
+#include "bdisp.h"
+
+#define BDISP_MAX_CTRL_NUM      10
+
+#define BDISP_WORK_TIMEOUT      ((100 * HZ) / 1000)
+
+/* User configuration change */
+#define BDISP_PARAMS            BIT(0) /* Config updated */
+#define BDISP_SRC_FMT           BIT(1) /* Source set */
+#define BDISP_DST_FMT           BIT(2) /* Destination set */
+#define BDISP_CTX_STOP_REQ      BIT(3) /* Stop request */
+#define BDISP_CTX_ABORT         BIT(4) /* Abort while device run */
+
+#define BDISP_MIN_W             1
+#define BDISP_MAX_W             8191
+#define BDISP_MIN_H             1
+#define BDISP_MAX_H             8191
+
+#define fh_to_ctx(__fh) container_of(__fh, struct bdisp_ctx, fh)
+
+enum bdisp_dev_flags {
+	ST_M2M_OPEN,            /* Driver opened */
+	ST_M2M_RUNNING,         /* HW device running */
+	ST_M2M_SUSPENDED,       /* Driver suspended */
+	ST_M2M_SUSPENDING,      /* Driver being suspended */
+};
+
+static const struct bdisp_fmt bdisp_formats[] = {
+	/* ARGB888. [31:0] A:R:G:B 8:8:8:8 little endian */
+	{
+		.pixelformat    = V4L2_PIX_FMT_ABGR32, /* is actually ARGB */
+		.nb_planes      = 1,
+		.bpp            = 32,
+		.bpp_plane0     = 32,
+		.w_align        = 1,
+		.h_align        = 1
+	},
+	/* XRGB888. [31:0] x:R:G:B 8:8:8:8 little endian */
+	{
+		.pixelformat    = V4L2_PIX_FMT_XBGR32, /* is actually xRGB */
+		.nb_planes      = 1,
+		.bpp            = 32,
+		.bpp_plane0     = 32,
+		.w_align        = 1,
+		.h_align        = 1
+	},
+	/* RGB565. [15:0] R:G:B 5:6:5 little endian */
+	{
+		.pixelformat    = V4L2_PIX_FMT_RGB565,
+		.nb_planes      = 1,
+		.bpp            = 16,
+		.bpp_plane0     = 16,
+		.w_align        = 1,
+		.h_align        = 1
+	},
+	/* NV12. YUV420SP - 1 plane for Y + 1 plane for (CbCr) */
+	{
+		.pixelformat    = V4L2_PIX_FMT_NV12,
+		.nb_planes      = 2,
+		.bpp            = 12,
+		.bpp_plane0     = 8,
+		.w_align        = 2,
+		.h_align        = 2
+	},
+	/* RGB888. [23:0] B:G:R 8:8:8 little endian */
+	{
+		.pixelformat    = V4L2_PIX_FMT_RGB24,
+		.nb_planes      = 1,
+		.bpp            = 24,
+		.bpp_plane0     = 24,
+		.w_align        = 1,
+		.h_align        = 1
+	},
+	/* YU12. YUV420P - 1 plane for Y + 1 plane for Cb + 1 plane for Cr
+	 * To keep as the LAST element of this table (no support on capture)
+	 */
+	{
+		.pixelformat    = V4L2_PIX_FMT_YUV420,
+		.nb_planes      = 3,
+		.bpp            = 12,
+		.bpp_plane0     = 8,
+		.w_align        = 2,
+		.h_align        = 2
+	}
+};
+
+/* Default format : HD ARGB32*/
+#define BDISP_DEF_WIDTH         1920
+#define BDISP_DEF_HEIGHT        1080
+
+static const struct bdisp_frame bdisp_dflt_fmt = {
+		.width          = BDISP_DEF_WIDTH,
+		.height         = BDISP_DEF_HEIGHT,
+		.fmt            = &bdisp_formats[0],
+		.field          = V4L2_FIELD_NONE,
+		.bytesperline   = BDISP_DEF_WIDTH * 4,
+		.sizeimage      = BDISP_DEF_WIDTH * BDISP_DEF_HEIGHT * 4,
+		.colorspace     = V4L2_COLORSPACE_REC709,
+		.crop           = {0, 0, BDISP_DEF_WIDTH, BDISP_DEF_HEIGHT},
+		.paddr          = {0, 0, 0, 0}
+};
+
+static inline void bdisp_ctx_state_lock_set(u32 state, struct bdisp_ctx *ctx)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&ctx->bdisp_dev->slock, flags);
+	ctx->state |= state;
+	spin_unlock_irqrestore(&ctx->bdisp_dev->slock, flags);
+}
+
+static inline void bdisp_ctx_state_lock_clear(u32 state, struct bdisp_ctx *ctx)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&ctx->bdisp_dev->slock, flags);
+	ctx->state &= ~state;
+	spin_unlock_irqrestore(&ctx->bdisp_dev->slock, flags);
+}
+
+static inline bool bdisp_ctx_state_is_set(u32 mask, struct bdisp_ctx *ctx)
+{
+	unsigned long flags;
+	bool ret;
+
+	spin_lock_irqsave(&ctx->bdisp_dev->slock, flags);
+	ret = (ctx->state & mask) == mask;
+	spin_unlock_irqrestore(&ctx->bdisp_dev->slock, flags);
+
+	return ret;
+}
+
+static const struct bdisp_fmt *bdisp_find_fmt(u32 pixelformat)
+{
+	const struct bdisp_fmt *fmt;
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(bdisp_formats); i++) {
+		fmt = &bdisp_formats[i];
+		if (fmt->pixelformat == pixelformat)
+			return fmt;
+	}
+
+	return NULL;
+}
+
+static struct bdisp_frame *ctx_get_frame(struct bdisp_ctx *ctx,
+					 enum v4l2_buf_type type)
+{
+	switch (type) {
+	case V4L2_BUF_TYPE_VIDEO_OUTPUT:
+		return &ctx->src;
+	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
+		return &ctx->dst;
+	default:
+		dev_err(ctx->bdisp_dev->dev,
+			"Wrong buffer/video queue type (%d)\n", type);
+		break;
+	}
+
+	return ERR_PTR(-EINVAL);
+}
+
+static void bdisp_job_finish(struct bdisp_ctx *ctx, int vb_state)
+{
+	struct vb2_buffer *src_vb, *dst_vb;
+
+	if (WARN(!ctx || !ctx->fh.m2m_ctx, "Null hardware context\n"))
+		return;
+
+	dev_dbg(ctx->bdisp_dev->dev, "%s\n", __func__);
+
+	src_vb = v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx);
+	dst_vb = v4l2_m2m_dst_buf_remove(ctx->fh.m2m_ctx);
+
+	if (src_vb && dst_vb) {
+		dst_vb->v4l2_buf.timestamp = src_vb->v4l2_buf.timestamp;
+		dst_vb->v4l2_buf.timecode = src_vb->v4l2_buf.timecode;
+		dst_vb->v4l2_buf.flags &= ~V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
+		dst_vb->v4l2_buf.flags |= src_vb->v4l2_buf.flags &
+					  V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
+
+		v4l2_m2m_buf_done(src_vb, vb_state);
+		v4l2_m2m_buf_done(dst_vb, vb_state);
+
+		v4l2_m2m_job_finish(ctx->bdisp_dev->m2m.m2m_dev,
+				    ctx->fh.m2m_ctx);
+	}
+}
+
+static int bdisp_ctx_stop_req(struct bdisp_ctx *ctx)
+{
+	struct bdisp_ctx *curr_ctx;
+	struct bdisp_dev *bdisp = ctx->bdisp_dev;
+	int ret;
+
+	dev_dbg(ctx->bdisp_dev->dev, "%s\n", __func__);
+
+	cancel_delayed_work(&bdisp->timeout_work);
+
+	curr_ctx = v4l2_m2m_get_curr_priv(bdisp->m2m.m2m_dev);
+	if (!test_bit(ST_M2M_RUNNING, &bdisp->state) || (curr_ctx != ctx))
+		return 0;
+
+	bdisp_ctx_state_lock_set(BDISP_CTX_STOP_REQ, ctx);
+
+	ret = wait_event_timeout(bdisp->irq_queue,
+			!bdisp_ctx_state_is_set(BDISP_CTX_STOP_REQ, ctx),
+			BDISP_WORK_TIMEOUT);
+
+	if (!ret) {
+		dev_err(ctx->bdisp_dev->dev, "%s IRQ timeout\n", __func__);
+		return -ETIMEDOUT;
+	}
+
+	return 0;
+}
+
+static void __bdisp_job_abort(struct bdisp_ctx *ctx)
+{
+	int ret;
+
+	ret = bdisp_ctx_stop_req(ctx);
+	if ((ret == -ETIMEDOUT) || (ctx->state & BDISP_CTX_ABORT)) {
+		bdisp_ctx_state_lock_clear(BDISP_CTX_STOP_REQ | BDISP_CTX_ABORT,
+					   ctx);
+		bdisp_job_finish(ctx, VB2_BUF_STATE_ERROR);
+	}
+}
+
+static void bdisp_job_abort(void *priv)
+{
+	__bdisp_job_abort((struct bdisp_ctx *)priv);
+}
+
+static int bdisp_get_addr(struct bdisp_ctx *ctx, struct vb2_buffer *vb,
+			  struct bdisp_frame *frame, dma_addr_t *paddr)
+{
+	if (!vb || !frame)
+		return -EINVAL;
+
+	paddr[0] = vb2_dma_contig_plane_dma_addr(vb, 0);
+
+	if (frame->fmt->nb_planes > 1)
+		/* UV (NV12) or U (420P) */
+		paddr[1] = (dma_addr_t)(paddr[0] +
+				frame->bytesperline * frame->height);
+
+	if (frame->fmt->nb_planes > 2)
+		/* V (420P) */
+		paddr[2] = (dma_addr_t)(paddr[1] +
+				(frame->bytesperline * frame->height) / 4);
+
+	if (frame->fmt->nb_planes > 3)
+		dev_dbg(ctx->bdisp_dev->dev, "ignoring some planes\n");
+
+	dev_dbg(ctx->bdisp_dev->dev,
+		"%s plane[0]=%pad plane[1]=%pad plane[2]=%pad\n",
+		__func__, &paddr[0], &paddr[1], &paddr[2]);
+
+	return 0;
+}
+
+static int bdisp_get_bufs(struct bdisp_ctx *ctx)
+{
+	struct bdisp_frame *src, *dst;
+	struct vb2_buffer *src_vb, *dst_vb;
+	int ret;
+
+	src = &ctx->src;
+	dst = &ctx->dst;
+
+	src_vb = v4l2_m2m_next_src_buf(ctx->fh.m2m_ctx);
+	ret = bdisp_get_addr(ctx, src_vb, src, src->paddr);
+	if (ret)
+		return ret;
+
+	dst_vb = v4l2_m2m_next_dst_buf(ctx->fh.m2m_ctx);
+	ret = bdisp_get_addr(ctx, dst_vb, dst, dst->paddr);
+	if (ret)
+		return ret;
+
+	dst_vb->v4l2_buf.timestamp = src_vb->v4l2_buf.timestamp;
+
+	return 0;
+}
+
+static void bdisp_device_run(void *priv)
+{
+	struct bdisp_ctx *ctx = priv;
+	struct bdisp_dev *bdisp;
+	unsigned long flags;
+	int err = 0;
+
+	if (WARN(!ctx, "Null hardware context\n"))
+		return;
+
+	bdisp = ctx->bdisp_dev;
+	dev_dbg(bdisp->dev, "%s\n", __func__);
+	spin_lock_irqsave(&bdisp->slock, flags);
+
+	if (bdisp->m2m.ctx != ctx) {
+		dev_dbg(bdisp->dev, "ctx updated: %p -> %p\n",
+			bdisp->m2m.ctx, ctx);
+		ctx->state |= BDISP_PARAMS;
+		bdisp->m2m.ctx = ctx;
+	}
+
+	if (ctx->state & BDISP_CTX_STOP_REQ) {
+		ctx->state &= ~BDISP_CTX_STOP_REQ;
+		ctx->state |= BDISP_CTX_ABORT;
+		wake_up(&bdisp->irq_queue);
+		goto out;
+	}
+
+	err = bdisp_get_bufs(ctx);
+	if (err) {
+		dev_err(bdisp->dev, "cannot get address\n");
+		goto out;
+	}
+
+	err = bdisp_hw_reset(bdisp);
+	if (err) {
+		dev_err(bdisp->dev, "could not get HW ready\n");
+		goto out;
+	}
+
+	err = bdisp_hw_update(ctx);
+	if (err) {
+		dev_err(bdisp->dev, "could not send HW request\n");
+		goto out;
+	}
+
+	queue_delayed_work(bdisp->work_queue, &bdisp->timeout_work,
+			   BDISP_WORK_TIMEOUT);
+	set_bit(ST_M2M_RUNNING, &bdisp->state);
+out:
+	ctx->state &= ~BDISP_PARAMS;
+	spin_unlock_irqrestore(&bdisp->slock, flags);
+	if (err)
+		bdisp_job_finish(ctx, VB2_BUF_STATE_ERROR);
+}
+
+static struct v4l2_m2m_ops bdisp_m2m_ops = {
+	.device_run     = bdisp_device_run,
+	.job_abort      = bdisp_job_abort,
+};
+
+static int __bdisp_s_ctrl(struct bdisp_ctx *ctx, struct v4l2_ctrl *ctrl)
+{
+	if (ctrl->flags & V4L2_CTRL_FLAG_INACTIVE)
+		return 0;
+
+	switch (ctrl->id) {
+	case V4L2_CID_HFLIP:
+		ctx->hflip = ctrl->val;
+		break;
+	case V4L2_CID_VFLIP:
+		ctx->vflip = ctrl->val;
+		break;
+	default:
+		dev_err(ctx->bdisp_dev->dev, "unknown control %d\n", ctrl->id);
+		return -EINVAL;
+	}
+
+	ctx->state |= BDISP_PARAMS;
+
+	return 0;
+}
+
+static int bdisp_s_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct bdisp_ctx *ctx = container_of(ctrl->handler, struct bdisp_ctx,
+						ctrl_handler);
+	unsigned long flags;
+	int ret;
+
+	spin_lock_irqsave(&ctx->bdisp_dev->slock, flags);
+	ret = __bdisp_s_ctrl(ctx, ctrl);
+	spin_unlock_irqrestore(&ctx->bdisp_dev->slock, flags);
+
+	return ret;
+}
+
+static const struct v4l2_ctrl_ops bdisp_c_ops = {
+	.s_ctrl = bdisp_s_ctrl,
+};
+
+static int bdisp_ctrls_create(struct bdisp_ctx *ctx)
+{
+	if (ctx->ctrls_rdy)
+		return 0;
+
+	v4l2_ctrl_handler_init(&ctx->ctrl_handler, BDISP_MAX_CTRL_NUM);
+
+	ctx->bdisp_ctrls.hflip = v4l2_ctrl_new_std(&ctx->ctrl_handler,
+				&bdisp_c_ops, V4L2_CID_HFLIP, 0, 1, 1, 0);
+	ctx->bdisp_ctrls.vflip = v4l2_ctrl_new_std(&ctx->ctrl_handler,
+				&bdisp_c_ops, V4L2_CID_VFLIP, 0, 1, 1, 0);
+
+	if (ctx->ctrl_handler.error) {
+		int err = ctx->ctrl_handler.error;
+
+		v4l2_ctrl_handler_free(&ctx->ctrl_handler);
+		return err;
+	}
+
+	ctx->ctrls_rdy = true;
+
+	return 0;
+}
+
+static void bdisp_ctrls_delete(struct bdisp_ctx *ctx)
+{
+	if (ctx->ctrls_rdy) {
+		v4l2_ctrl_handler_free(&ctx->ctrl_handler);
+		ctx->ctrls_rdy = false;
+	}
+}
+
+static int bdisp_queue_setup(struct vb2_queue *vq,
+			     const struct v4l2_format *fmt,
+			     unsigned int *nb_buf, unsigned int *nb_planes,
+			     unsigned int sizes[], void *allocators[])
+{
+	struct bdisp_ctx *ctx = vb2_get_drv_priv(vq);
+	struct bdisp_frame *frame = ctx_get_frame(ctx, vq->type);
+
+	if (IS_ERR(frame)) {
+		dev_err(ctx->bdisp_dev->dev, "Invalid frame (%p)\n", frame);
+		return PTR_ERR(frame);
+	}
+
+	if (!frame->fmt) {
+		dev_err(ctx->bdisp_dev->dev, "Invalid format\n");
+		return -EINVAL;
+	}
+
+	if (fmt && fmt->fmt.pix.sizeimage < frame->sizeimage)
+		return -EINVAL;
+
+	*nb_planes = 1;
+	sizes[0] = fmt ? fmt->fmt.pix.sizeimage : frame->sizeimage;
+	allocators[0] = ctx->bdisp_dev->alloc_ctx;
+
+	return 0;
+}
+
+static int bdisp_buf_prepare(struct vb2_buffer *vb)
+{
+	struct bdisp_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
+	struct bdisp_frame *frame = ctx_get_frame(ctx, vb->vb2_queue->type);
+
+	if (IS_ERR(frame)) {
+		dev_err(ctx->bdisp_dev->dev, "Invalid frame (%p)\n", frame);
+		return PTR_ERR(frame);
+	}
+
+	if (vb->vb2_queue->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		vb2_set_plane_payload(vb, 0, frame->sizeimage);
+
+	return 0;
+}
+
+static void bdisp_buf_queue(struct vb2_buffer *vb)
+{
+	struct bdisp_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
+
+	/* return to V4L2 any 0-size buffer so it can be dequeued by user */
+	if (!vb2_get_plane_payload(vb, 0)) {
+		dev_dbg(ctx->bdisp_dev->dev, "0 data buffer, skip it\n");
+		vb2_buffer_done(vb, VB2_BUF_STATE_DONE);
+		return;
+	}
+
+	if (ctx->fh.m2m_ctx)
+		v4l2_m2m_buf_queue(ctx->fh.m2m_ctx, vb);
+}
+
+static int bdisp_start_streaming(struct vb2_queue *q, unsigned int count)
+{
+	struct bdisp_ctx *ctx = q->drv_priv;
+	struct vb2_buffer *buf;
+	int ret = pm_runtime_get_sync(ctx->bdisp_dev->dev);
+
+	if (ret < 0) {
+		dev_err(ctx->bdisp_dev->dev, "failed to set runtime PM\n");
+
+		if (q->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) {
+			while ((buf = v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx)))
+				v4l2_m2m_buf_done(buf, VB2_BUF_STATE_QUEUED);
+		} else {
+			while ((buf = v4l2_m2m_dst_buf_remove(ctx->fh.m2m_ctx)))
+				v4l2_m2m_buf_done(buf, VB2_BUF_STATE_QUEUED);
+		}
+
+		return ret;
+	}
+
+	return 0;
+}
+
+static void bdisp_stop_streaming(struct vb2_queue *q)
+{
+	struct bdisp_ctx *ctx = q->drv_priv;
+
+	__bdisp_job_abort(ctx);
+
+	pm_runtime_put(ctx->bdisp_dev->dev);
+}
+
+static struct vb2_ops bdisp_qops = {
+	.queue_setup     = bdisp_queue_setup,
+	.buf_prepare     = bdisp_buf_prepare,
+	.buf_queue       = bdisp_buf_queue,
+	.wait_prepare    = vb2_ops_wait_prepare,
+	.wait_finish     = vb2_ops_wait_finish,
+	.stop_streaming  = bdisp_stop_streaming,
+	.start_streaming = bdisp_start_streaming,
+};
+
+static int queue_init(void *priv,
+		      struct vb2_queue *src_vq, struct vb2_queue *dst_vq)
+{
+	struct bdisp_ctx *ctx = priv;
+	int ret;
+
+	memset(src_vq, 0, sizeof(*src_vq));
+	src_vq->type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
+	src_vq->io_modes = VB2_MMAP | VB2_DMABUF;
+	src_vq->drv_priv = ctx;
+	src_vq->ops = &bdisp_qops;
+	src_vq->mem_ops = &vb2_dma_contig_memops;
+	src_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
+	src_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
+	src_vq->lock = &ctx->bdisp_dev->lock;
+
+	ret = vb2_queue_init(src_vq);
+	if (ret)
+		return ret;
+
+	memset(dst_vq, 0, sizeof(*dst_vq));
+	dst_vq->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	dst_vq->io_modes = VB2_MMAP | VB2_DMABUF;
+	dst_vq->drv_priv = ctx;
+	dst_vq->ops = &bdisp_qops;
+	dst_vq->mem_ops = &vb2_dma_contig_memops;
+	dst_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
+	dst_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
+	dst_vq->lock = &ctx->bdisp_dev->lock;
+
+	return vb2_queue_init(dst_vq);
+}
+
+static int bdisp_open(struct file *file)
+{
+	struct bdisp_dev *bdisp = video_drvdata(file);
+	struct bdisp_ctx *ctx = NULL;
+	int ret;
+
+	if (mutex_lock_interruptible(&bdisp->lock))
+		return -ERESTARTSYS;
+
+	/* Allocate memory for both context and node */
+	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
+	if (!ctx) {
+		ret = -ENOMEM;
+		goto unlock;
+	}
+	ctx->bdisp_dev = bdisp;
+
+	if (bdisp_hw_alloc_nodes(ctx)) {
+		dev_err(bdisp->dev, "no memory for nodes\n");
+		ret = -ENOMEM;
+		goto mem_ctx;
+	}
+
+	v4l2_fh_init(&ctx->fh, bdisp->m2m.vdev);
+
+	ret = bdisp_ctrls_create(ctx);
+	if (ret) {
+		dev_err(bdisp->dev, "Failed to create control\n");
+		goto error_fh;
+	}
+
+	/* Use separate control handler per file handle */
+	ctx->fh.ctrl_handler = &ctx->ctrl_handler;
+	file->private_data = &ctx->fh;
+	v4l2_fh_add(&ctx->fh);
+
+	/* Default format */
+	ctx->src = bdisp_dflt_fmt;
+	ctx->dst = bdisp_dflt_fmt;
+
+	/* Setup the device context for mem2mem mode. */
+	ctx->fh.m2m_ctx = v4l2_m2m_ctx_init(bdisp->m2m.m2m_dev, ctx,
+					    queue_init);
+	if (IS_ERR(ctx->fh.m2m_ctx)) {
+		dev_err(bdisp->dev, "Failed to initialize m2m context\n");
+		ret = PTR_ERR(ctx->fh.m2m_ctx);
+		goto error_ctrls;
+	}
+
+	bdisp->m2m.refcnt++;
+	set_bit(ST_M2M_OPEN, &bdisp->state);
+
+	dev_dbg(bdisp->dev, "driver opened, ctx = 0x%p\n", ctx);
+
+	mutex_unlock(&bdisp->lock);
+
+	return 0;
+
+error_ctrls:
+	bdisp_ctrls_delete(ctx);
+error_fh:
+	v4l2_fh_del(&ctx->fh);
+	v4l2_fh_exit(&ctx->fh);
+	bdisp_hw_free_nodes(ctx);
+mem_ctx:
+	kfree(ctx);
+unlock:
+	mutex_unlock(&bdisp->lock);
+
+	return ret;
+}
+
+static int bdisp_release(struct file *file)
+{
+	struct bdisp_ctx *ctx = fh_to_ctx(file->private_data);
+	struct bdisp_dev *bdisp = ctx->bdisp_dev;
+
+	dev_dbg(bdisp->dev, "%s\n", __func__);
+
+	if (mutex_lock_interruptible(&bdisp->lock))
+		return -ERESTARTSYS;
+
+	v4l2_m2m_ctx_release(ctx->fh.m2m_ctx);
+
+	bdisp_ctrls_delete(ctx);
+
+	v4l2_fh_del(&ctx->fh);
+	v4l2_fh_exit(&ctx->fh);
+
+	if (--bdisp->m2m.refcnt <= 0)
+		clear_bit(ST_M2M_OPEN, &bdisp->state);
+
+	bdisp_hw_free_nodes(ctx);
+
+	kfree(ctx);
+
+	mutex_unlock(&bdisp->lock);
+
+	return 0;
+}
+
+static const struct v4l2_file_operations bdisp_fops = {
+	.owner          = THIS_MODULE,
+	.open           = bdisp_open,
+	.release        = bdisp_release,
+	.poll           = v4l2_m2m_fop_poll,
+	.unlocked_ioctl = video_ioctl2,
+	.mmap           = v4l2_m2m_fop_mmap,
+};
+
+static int bdisp_querycap(struct file *file, void *fh,
+			  struct v4l2_capability *cap)
+{
+	struct bdisp_ctx *ctx = fh_to_ctx(fh);
+	struct bdisp_dev *bdisp = ctx->bdisp_dev;
+
+	strlcpy(cap->driver, bdisp->pdev->name, sizeof(cap->driver));
+	strlcpy(cap->card, bdisp->pdev->name, sizeof(cap->card));
+	snprintf(cap->bus_info, sizeof(cap->bus_info), "platform:%s%d",
+		 BDISP_NAME, bdisp->id);
+
+	cap->device_caps = V4L2_CAP_STREAMING | V4L2_CAP_VIDEO_M2M;
+
+	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
+
+	return 0;
+}
+
+static int bdisp_enum_fmt(struct file *file, void *fh, struct v4l2_fmtdesc *f)
+{
+	struct bdisp_ctx *ctx = fh_to_ctx(fh);
+	const struct bdisp_fmt *fmt;
+
+	if (f->index >= ARRAY_SIZE(bdisp_formats))
+		return -EINVAL;
+
+	fmt = &bdisp_formats[f->index];
+
+	if ((fmt->pixelformat == V4L2_PIX_FMT_YUV420) &&
+	    (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)) {
+		dev_dbg(ctx->bdisp_dev->dev, "No YU12 on capture\n");
+		return -EINVAL;
+	}
+	f->pixelformat = fmt->pixelformat;
+
+	return 0;
+}
+
+static int bdisp_g_fmt(struct file *file, void *fh, struct v4l2_format *f)
+{
+	struct bdisp_ctx *ctx = fh_to_ctx(fh);
+	struct v4l2_pix_format *pix = &f->fmt.pix;
+	struct bdisp_frame *frame  = ctx_get_frame(ctx, f->type);
+
+	if (IS_ERR(frame)) {
+		dev_err(ctx->bdisp_dev->dev, "Invalid frame (%p)\n", frame);
+		return PTR_ERR(frame);
+	}
+
+	pix = &f->fmt.pix;
+	pix->width = frame->width;
+	pix->height = frame->height;
+	pix->pixelformat = frame->fmt->pixelformat;
+	pix->field = frame->field;
+	pix->bytesperline = frame->bytesperline;
+	pix->sizeimage = frame->sizeimage;
+	pix->colorspace = (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) ?
+				frame->colorspace : bdisp_dflt_fmt.colorspace;
+
+	return 0;
+}
+
+static int bdisp_try_fmt(struct file *file, void *fh, struct v4l2_format *f)
+{
+	struct bdisp_ctx *ctx = fh_to_ctx(fh);
+	struct v4l2_pix_format *pix = &f->fmt.pix;
+	const struct bdisp_fmt *format;
+	u32 in_w, in_h;
+
+	format = bdisp_find_fmt(pix->pixelformat);
+	if (!format) {
+		dev_dbg(ctx->bdisp_dev->dev, "Unknown format 0x%x\n",
+			pix->pixelformat);
+		return -EINVAL;
+	}
+
+	/* YUV420P only supported for VIDEO_OUTPUT */
+	if ((format->pixelformat == V4L2_PIX_FMT_YUV420) &&
+	    (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)) {
+		dev_dbg(ctx->bdisp_dev->dev, "No YU12 on capture\n");
+		return -EINVAL;
+	}
+
+	/* Field (interlaced only supported on OUTPUT) */
+	if ((f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE) ||
+	    (pix->field != V4L2_FIELD_INTERLACED))
+		pix->field = V4L2_FIELD_NONE;
+
+	/* Adjust width & height */
+	in_w = pix->width;
+	in_h = pix->height;
+	v4l_bound_align_image(&pix->width,
+			      BDISP_MIN_W, BDISP_MAX_W,
+			      ffs(format->w_align) - 1,
+			      &pix->height,
+			      BDISP_MIN_H, BDISP_MAX_H,
+			      ffs(format->h_align) - 1,
+			      0);
+	if ((pix->width != in_w) || (pix->height != in_h))
+		dev_dbg(ctx->bdisp_dev->dev,
+			"%s size updated: %dx%d -> %dx%d\n", __func__,
+			in_w, in_h, pix->width, pix->height);
+
+	pix->bytesperline = (pix->width * format->bpp_plane0) / 8;
+	pix->sizeimage = (pix->width * pix->height * format->bpp) / 8;
+
+	if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		pix->colorspace = bdisp_dflt_fmt.colorspace;
+
+	return 0;
+}
+
+static int bdisp_s_fmt(struct file *file, void *fh, struct v4l2_format *f)
+{
+	struct bdisp_ctx *ctx = fh_to_ctx(fh);
+	struct vb2_queue *vq;
+	struct bdisp_frame *frame;
+	struct v4l2_pix_format *pix;
+	int ret;
+	u32 state;
+
+	ret = bdisp_try_fmt(file, fh, f);
+	if (ret) {
+		dev_err(ctx->bdisp_dev->dev, "Cannot set format\n");
+		return ret;
+	}
+
+	vq = v4l2_m2m_get_vq(ctx->fh.m2m_ctx, f->type);
+	if (vb2_is_streaming(vq)) {
+		dev_err(ctx->bdisp_dev->dev, "queue (%d) busy\n", f->type);
+		return -EBUSY;
+	}
+
+	frame = (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) ?
+			&ctx->src : &ctx->dst;
+	pix = &f->fmt.pix;
+	frame->fmt = bdisp_find_fmt(pix->pixelformat);
+	if (!frame->fmt) {
+		dev_err(ctx->bdisp_dev->dev, "Unknown format 0x%x\n",
+			pix->pixelformat);
+		return -EINVAL;
+	}
+
+	frame->width = pix->width;
+	frame->height = pix->height;
+	frame->bytesperline = pix->bytesperline;
+	frame->sizeimage = pix->sizeimage;
+	frame->field = pix->field;
+	if (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT)
+		frame->colorspace = pix->colorspace;
+
+	frame->crop.width = frame->width;
+	frame->crop.height = frame->height;
+	frame->crop.left = 0;
+	frame->crop.top = 0;
+
+	state = BDISP_PARAMS;
+	state |= (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE) ?
+			BDISP_DST_FMT : BDISP_SRC_FMT;
+	bdisp_ctx_state_lock_set(state, ctx);
+
+	return 0;
+}
+
+static int bdisp_g_selection(struct file *file, void *fh,
+			     struct v4l2_selection *s)
+{
+	struct bdisp_frame *frame;
+	struct bdisp_ctx *ctx = fh_to_ctx(fh);
+
+	if (s->type != V4L2_BUF_TYPE_VIDEO_OUTPUT) {
+		/* Composing  / capture is not supported */
+		dev_dbg(ctx->bdisp_dev->dev, "Not supported for capture\n");
+		return -EINVAL;
+	}
+
+	frame = ctx_get_frame(ctx, s->type);
+	if (IS_ERR(frame)) {
+		dev_err(ctx->bdisp_dev->dev, "Invalid frame (%p)\n", frame);
+		return PTR_ERR(frame);
+	}
+
+	switch (s->target) {
+	case V4L2_SEL_TGT_CROP:
+		/* cropped frame */
+		s->r = frame->crop;
+		break;
+	case V4L2_SEL_TGT_CROP_DEFAULT:
+	case V4L2_SEL_TGT_CROP_BOUNDS:
+		/* complete frame */
+		s->r.left = 0;
+		s->r.top = 0;
+		s->r.width = frame->width;
+		s->r.height = frame->height;
+		break;
+	default:
+		dev_dbg(ctx->bdisp_dev->dev, "Invalid target\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int is_rect_enclosed(struct v4l2_rect *a, struct v4l2_rect *b)
+{
+	/* Return 1 if a is enclosed in b, or 0 otherwise. */
+
+	if (a->left < b->left || a->top < b->top)
+		return 0;
+
+	if (a->left + a->width > b->left + b->width)
+		return 0;
+
+	if (a->top + a->height > b->top + b->height)
+		return 0;
+
+	return 1;
+}
+
+static int bdisp_s_selection(struct file *file, void *fh,
+			     struct v4l2_selection *s)
+{
+	struct bdisp_frame *frame;
+	struct bdisp_ctx *ctx = fh_to_ctx(fh);
+	struct v4l2_rect *in, out;
+
+	if (s->type != V4L2_BUF_TYPE_VIDEO_OUTPUT) {
+		/* Composing  / capture is not supported */
+		dev_dbg(ctx->bdisp_dev->dev, "Not supported for capture\n");
+		return -EINVAL;
+	}
+
+	if (s->target != V4L2_SEL_TGT_CROP) {
+		dev_dbg(ctx->bdisp_dev->dev, "Invalid target\n");
+		return -EINVAL;
+	}
+
+	frame = ctx_get_frame(ctx, s->type);
+	if (IS_ERR(frame)) {
+		dev_err(ctx->bdisp_dev->dev, "Invalid frame (%p)\n", frame);
+		return PTR_ERR(frame);
+	}
+
+	in = &s->r;
+	out = *in;
+
+	/* Align and check origin */
+	out.left = ALIGN(in->left, frame->fmt->w_align);
+	out.top = ALIGN(in->top, frame->fmt->h_align);
+
+	if ((out.left < 0) || (out.left >= frame->width) ||
+	    (out.top < 0) || (out.top >= frame->height)) {
+		dev_err(ctx->bdisp_dev->dev,
+			"Invalid crop: %dx%d@(%d,%d) vs frame: %dx%d\n",
+			out.width, out.height, out.left, out.top,
+			frame->width, frame->height);
+		return -EINVAL;
+	}
+
+	/* Align and check size */
+	out.width = ALIGN(in->width, frame->fmt->w_align);
+	out.height = ALIGN(in->height, frame->fmt->w_align);
+
+	if ((out.width < 0) || (out.height < 0) ||
+	    ((out.left + out.width) > frame->width) ||
+	    ((out.top + out.height) > frame->height)) {
+		dev_err(ctx->bdisp_dev->dev,
+			"Invalid crop: %dx%d@(%d,%d) vs frame: %dx%d\n",
+			out.width, out.height, out.left, out.top,
+			frame->width, frame->height);
+		return -EINVAL;
+	}
+
+	/* Checks adjust constraints flags */
+	if (s->flags & V4L2_SEL_FLAG_LE && !is_rect_enclosed(&out, in))
+		return -ERANGE;
+
+	if (s->flags & V4L2_SEL_FLAG_GE && !is_rect_enclosed(in, &out))
+		return -ERANGE;
+
+	if ((out.left != in->left) || (out.top != in->top) ||
+	    (out.width != in->width) || (out.height != in->height)) {
+		dev_dbg(ctx->bdisp_dev->dev,
+			"%s crop updated: %dx%d@(%d,%d) -> %dx%d@(%d,%d)\n",
+			__func__, in->width, in->height, in->left, in->top,
+			out.width, out.height, out.left, out.top);
+		*in = out;
+	}
+
+	frame->crop = out;
+
+	bdisp_ctx_state_lock_set(BDISP_PARAMS, ctx);
+
+	return 0;
+}
+
+static int bdisp_streamon(struct file *file, void *fh, enum v4l2_buf_type type)
+{
+	struct bdisp_ctx *ctx = fh_to_ctx(fh);
+
+	if ((type == V4L2_BUF_TYPE_VIDEO_OUTPUT) &&
+	    !bdisp_ctx_state_is_set(BDISP_SRC_FMT, ctx)) {
+		dev_err(ctx->bdisp_dev->dev, "src not defined\n");
+		return -EINVAL;
+	}
+
+	if ((type == V4L2_BUF_TYPE_VIDEO_CAPTURE) &&
+	    !bdisp_ctx_state_is_set(BDISP_DST_FMT, ctx)) {
+		dev_err(ctx->bdisp_dev->dev, "dst not defined\n");
+		return -EINVAL;
+	}
+
+	return v4l2_m2m_streamon(file, ctx->fh.m2m_ctx, type);
+}
+
+static const struct v4l2_ioctl_ops bdisp_ioctl_ops = {
+	.vidioc_querycap                = bdisp_querycap,
+	.vidioc_enum_fmt_vid_cap        = bdisp_enum_fmt,
+	.vidioc_enum_fmt_vid_out        = bdisp_enum_fmt,
+	.vidioc_g_fmt_vid_cap           = bdisp_g_fmt,
+	.vidioc_g_fmt_vid_out           = bdisp_g_fmt,
+	.vidioc_try_fmt_vid_cap         = bdisp_try_fmt,
+	.vidioc_try_fmt_vid_out         = bdisp_try_fmt,
+	.vidioc_s_fmt_vid_cap           = bdisp_s_fmt,
+	.vidioc_s_fmt_vid_out           = bdisp_s_fmt,
+	.vidioc_g_selection		= bdisp_g_selection,
+	.vidioc_s_selection		= bdisp_s_selection,
+	.vidioc_reqbufs                 = v4l2_m2m_ioctl_reqbufs,
+	.vidioc_create_bufs             = v4l2_m2m_ioctl_create_bufs,
+	.vidioc_expbuf                  = v4l2_m2m_ioctl_expbuf,
+	.vidioc_querybuf                = v4l2_m2m_ioctl_querybuf,
+	.vidioc_qbuf                    = v4l2_m2m_ioctl_qbuf,
+	.vidioc_dqbuf                   = v4l2_m2m_ioctl_dqbuf,
+	.vidioc_streamon                = bdisp_streamon,
+	.vidioc_streamoff               = v4l2_m2m_ioctl_streamoff,
+	.vidioc_subscribe_event         = v4l2_ctrl_subscribe_event,
+	.vidioc_unsubscribe_event       = v4l2_event_unsubscribe,
+};
+
+static int bdisp_register_device(struct bdisp_dev *bdisp)
+{
+	struct platform_device *pdev;
+	int ret;
+
+	if (!bdisp)
+		return -ENODEV;
+
+	pdev = bdisp->pdev;
+
+	bdisp->vdev.fops        = &bdisp_fops;
+	bdisp->vdev.ioctl_ops   = &bdisp_ioctl_ops;
+	bdisp->vdev.release     = video_device_release_empty;
+	bdisp->vdev.lock        = &bdisp->lock;
+	bdisp->vdev.vfl_dir     = VFL_DIR_M2M;
+	bdisp->vdev.v4l2_dev    = &bdisp->v4l2_dev;
+	snprintf(bdisp->vdev.name, sizeof(bdisp->vdev.name), "%s.%d",
+		 BDISP_NAME, bdisp->id);
+
+	video_set_drvdata(&bdisp->vdev, bdisp);
+
+	bdisp->m2m.vdev = &bdisp->vdev;
+	bdisp->m2m.m2m_dev = v4l2_m2m_init(&bdisp_m2m_ops);
+	if (IS_ERR(bdisp->m2m.m2m_dev)) {
+		dev_err(bdisp->dev, "failed to initialize v4l2-m2m device\n");
+		return PTR_ERR(bdisp->m2m.m2m_dev);
+	}
+
+	ret = video_register_device(&bdisp->vdev, VFL_TYPE_GRABBER, -1);
+	if (ret) {
+		dev_err(bdisp->dev,
+			"%s(): failed to register video device\n", __func__);
+		v4l2_m2m_release(bdisp->m2m.m2m_dev);
+		return ret;
+	}
+
+	return 0;
+}
+
+static void bdisp_unregister_device(struct bdisp_dev *bdisp)
+{
+	if (!bdisp)
+		return;
+
+	if (bdisp->m2m.m2m_dev)
+		v4l2_m2m_release(bdisp->m2m.m2m_dev);
+
+	video_unregister_device(bdisp->m2m.vdev);
+}
+
+static irqreturn_t bdisp_irq_thread(int irq, void *priv)
+{
+	struct bdisp_dev *bdisp = priv;
+	struct bdisp_ctx *ctx;
+
+	spin_lock(&bdisp->slock);
+
+	cancel_delayed_work(&bdisp->timeout_work);
+
+	if (!test_and_clear_bit(ST_M2M_RUNNING, &bdisp->state))
+		goto isr_unlock;
+
+	if (test_and_clear_bit(ST_M2M_SUSPENDING, &bdisp->state)) {
+		set_bit(ST_M2M_SUSPENDED, &bdisp->state);
+		wake_up(&bdisp->irq_queue);
+		goto isr_unlock;
+	}
+
+	ctx = v4l2_m2m_get_curr_priv(bdisp->m2m.m2m_dev);
+	if (!ctx || !ctx->fh.m2m_ctx)
+		goto isr_unlock;
+
+	spin_unlock(&bdisp->slock);
+
+	bdisp_job_finish(ctx, VB2_BUF_STATE_DONE);
+
+	if (bdisp_ctx_state_is_set(BDISP_CTX_STOP_REQ, ctx)) {
+		bdisp_ctx_state_lock_clear(BDISP_CTX_STOP_REQ, ctx);
+		wake_up(&bdisp->irq_queue);
+	}
+
+	return IRQ_HANDLED;
+
+isr_unlock:
+	spin_unlock(&bdisp->slock);
+
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t bdisp_irq_handler(int irq, void *priv)
+{
+	if (bdisp_hw_get_and_clear_irq((struct bdisp_dev *)priv))
+		return IRQ_NONE;
+	else
+		return IRQ_WAKE_THREAD;
+}
+
+static void bdisp_irq_timeout(struct work_struct *ptr)
+{
+	struct delayed_work *twork = to_delayed_work(ptr);
+	struct bdisp_dev *bdisp = container_of(twork, struct bdisp_dev,
+			timeout_work);
+	struct bdisp_ctx *ctx;
+
+	ctx = v4l2_m2m_get_curr_priv(bdisp->m2m.m2m_dev);
+
+	dev_err(ctx->bdisp_dev->dev, "Device work timeout\n");
+
+	spin_lock(&bdisp->slock);
+	clear_bit(ST_M2M_RUNNING, &bdisp->state);
+	spin_unlock(&bdisp->slock);
+
+	bdisp_hw_reset(bdisp);
+
+	bdisp_job_finish(ctx, VB2_BUF_STATE_ERROR);
+}
+
+static int bdisp_m2m_suspend(struct bdisp_dev *bdisp)
+{
+	unsigned long flags;
+	int timeout;
+
+	spin_lock_irqsave(&bdisp->slock, flags);
+	if (!test_bit(ST_M2M_RUNNING, &bdisp->state)) {
+		spin_unlock_irqrestore(&bdisp->slock, flags);
+		return 0;
+	}
+	clear_bit(ST_M2M_SUSPENDED, &bdisp->state);
+	set_bit(ST_M2M_SUSPENDING, &bdisp->state);
+	spin_unlock_irqrestore(&bdisp->slock, flags);
+
+	timeout = wait_event_timeout(bdisp->irq_queue,
+				     test_bit(ST_M2M_SUSPENDED, &bdisp->state),
+				     BDISP_WORK_TIMEOUT);
+
+	clear_bit(ST_M2M_SUSPENDING, &bdisp->state);
+
+	if (!timeout) {
+		dev_err(bdisp->dev, "%s IRQ timeout\n", __func__);
+		return -EAGAIN;
+	}
+
+	return 0;
+}
+
+static int bdisp_m2m_resume(struct bdisp_dev *bdisp)
+{
+	struct bdisp_ctx *ctx;
+	unsigned long flags;
+
+	spin_lock_irqsave(&bdisp->slock, flags);
+	ctx = bdisp->m2m.ctx;
+	bdisp->m2m.ctx = NULL;
+	spin_unlock_irqrestore(&bdisp->slock, flags);
+
+	if (test_and_clear_bit(ST_M2M_SUSPENDED, &bdisp->state))
+		bdisp_job_finish(ctx, VB2_BUF_STATE_ERROR);
+
+	return 0;
+}
+
+static int bdisp_runtime_resume(struct device *dev)
+{
+	struct bdisp_dev *bdisp = dev_get_drvdata(dev);
+	int ret = clk_enable(bdisp->clock);
+
+	if (ret)
+		return ret;
+
+	return bdisp_m2m_resume(bdisp);
+}
+
+static int bdisp_runtime_suspend(struct device *dev)
+{
+	struct bdisp_dev *bdisp = dev_get_drvdata(dev);
+	int ret = bdisp_m2m_suspend(bdisp);
+
+	if (!ret)
+		clk_disable(bdisp->clock);
+
+	return ret;
+}
+
+static int bdisp_resume(struct device *dev)
+{
+	struct bdisp_dev *bdisp = dev_get_drvdata(dev);
+	unsigned long flags;
+	int opened;
+
+	spin_lock_irqsave(&bdisp->slock, flags);
+	opened = test_bit(ST_M2M_OPEN, &bdisp->state);
+	spin_unlock_irqrestore(&bdisp->slock, flags);
+
+	if (!opened)
+		return 0;
+
+	if (!pm_runtime_suspended(dev))
+		return bdisp_runtime_resume(dev);
+
+	return 0;
+}
+
+static int bdisp_suspend(struct device *dev)
+{
+	if (!pm_runtime_suspended(dev))
+		return bdisp_runtime_suspend(dev);
+
+	return 0;
+}
+
+static const struct dev_pm_ops bdisp_pm_ops = {
+	.suspend                = bdisp_suspend,
+	.resume                 = bdisp_resume,
+	.runtime_suspend        = bdisp_runtime_suspend,
+	.runtime_resume         = bdisp_runtime_resume,
+};
+
+static int bdisp_remove(struct platform_device *pdev)
+{
+	struct bdisp_dev *bdisp = platform_get_drvdata(pdev);
+
+	bdisp_unregister_device(bdisp);
+
+	bdisp_hw_free_filters(bdisp->dev);
+
+	vb2_dma_contig_cleanup_ctx(bdisp->alloc_ctx);
+
+	pm_runtime_disable(&pdev->dev);
+
+	v4l2_device_unregister(&bdisp->v4l2_dev);
+
+	if (!IS_ERR(bdisp->clock))
+		clk_unprepare(bdisp->clock);
+
+	dev_dbg(&pdev->dev, "%s driver unloaded\n", pdev->name);
+
+	return 0;
+}
+
+static int bdisp_probe(struct platform_device *pdev)
+{
+	struct bdisp_dev *bdisp;
+	struct resource *res;
+	struct device *dev = &pdev->dev;
+	int ret;
+
+	dev_dbg(dev, "%s\n", __func__);
+
+	bdisp = devm_kzalloc(dev, sizeof(struct bdisp_dev), GFP_KERNEL);
+	if (!bdisp)
+		return -ENOMEM;
+
+	bdisp->pdev = pdev;
+	bdisp->dev = dev;
+	platform_set_drvdata(pdev, bdisp);
+
+	if (dev->of_node)
+		bdisp->id = of_alias_get_id(pdev->dev.of_node, BDISP_NAME);
+	else
+		bdisp->id = pdev->id;
+
+	init_waitqueue_head(&bdisp->irq_queue);
+	INIT_DELAYED_WORK(&bdisp->timeout_work, bdisp_irq_timeout);
+	bdisp->work_queue = create_workqueue(BDISP_NAME);
+
+	spin_lock_init(&bdisp->slock);
+	mutex_init(&bdisp->lock);
+
+	/* get resources */
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	bdisp->regs = devm_ioremap_resource(dev, res);
+	if (IS_ERR(bdisp->regs)) {
+		dev_err(dev, "failed to get regs\n");
+		return PTR_ERR(bdisp->regs);
+	}
+
+	bdisp->clock = devm_clk_get(dev, BDISP_NAME);
+	if (IS_ERR(bdisp->clock)) {
+		dev_err(dev, "failed to get clock\n");
+		return PTR_ERR(bdisp->clock);
+	}
+
+	ret = clk_prepare(bdisp->clock);
+	if (ret < 0) {
+		dev_err(dev, "clock prepare failed\n");
+		bdisp->clock = ERR_PTR(-EINVAL);
+		return ret;
+	}
+
+	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
+	if (!res) {
+		dev_err(dev, "failed to get IRQ resource\n");
+		goto err_clk;
+	}
+
+	ret = devm_request_threaded_irq(dev, res->start, bdisp_irq_handler,
+					bdisp_irq_thread, IRQF_ONESHOT,
+					pdev->name, bdisp);
+	if (ret) {
+		dev_err(dev, "failed to install irq\n");
+		goto err_clk;
+	}
+
+	/* v4l2 register */
+	ret = v4l2_device_register(dev, &bdisp->v4l2_dev);
+	if (ret) {
+		dev_err(dev, "failed to register\n");
+		goto err_clk;
+	}
+
+	/* Power management */
+	pm_runtime_enable(dev);
+	ret = pm_runtime_get_sync(dev);
+	if (ret < 0) {
+		dev_err(dev, "failed to set PM\n");
+		goto err_v4l2;
+	}
+
+	/* Continuous memory allocator */
+	bdisp->alloc_ctx = vb2_dma_contig_init_ctx(dev);
+	if (IS_ERR(bdisp->alloc_ctx)) {
+		ret = PTR_ERR(bdisp->alloc_ctx);
+		goto err_pm;
+	}
+
+	/* Filters */
+	if (bdisp_hw_alloc_filters(bdisp->dev)) {
+		dev_err(bdisp->dev, "no memory for filters\n");
+		ret = -ENOMEM;
+		goto err_vb2_dma;
+	}
+
+	/* Register */
+	ret = bdisp_register_device(bdisp);
+	if (ret) {
+		dev_err(dev, "failed to register\n");
+		goto err_filter;
+	}
+
+	dev_info(dev, "%s%d registered as /dev/video%d\n", BDISP_NAME,
+		 bdisp->id, bdisp->vdev.num);
+
+	pm_runtime_put(dev);
+
+	return 0;
+
+err_filter:
+	bdisp_hw_free_filters(bdisp->dev);
+err_vb2_dma:
+	vb2_dma_contig_cleanup_ctx(bdisp->alloc_ctx);
+err_pm:
+	pm_runtime_put(dev);
+err_v4l2:
+	v4l2_device_unregister(&bdisp->v4l2_dev);
+err_clk:
+	if (!IS_ERR(bdisp->clock))
+		clk_unprepare(bdisp->clock);
+
+	return ret;
+}
+
+static const struct of_device_id bdisp_match_types[] = {
+	{
+		.compatible = "st,stih407-bdisp",
+	},
+	{ /* end node */ }
+};
+
+MODULE_DEVICE_TABLE(of, bdisp_match_types);
+
+static struct platform_driver bdisp_driver = {
+	.probe          = bdisp_probe,
+	.remove         = bdisp_remove,
+	.driver         = {
+		.name           = BDISP_NAME,
+		.of_match_table = bdisp_match_types,
+		.pm             = &bdisp_pm_ops,
+	},
+};
+
+module_platform_driver(bdisp_driver);
+
+MODULE_DESCRIPTION("2D blitter for STMicroelectronics SoC");
+MODULE_AUTHOR("Fabien Dessenne <fabien.dessenne@st.com>");
+MODULE_LICENSE("GPL");
diff --git a/drivers/media/platform/sti/bdisp/bdisp.h b/drivers/media/platform/sti/bdisp/bdisp.h
new file mode 100644
index 0000000..013678a
--- /dev/null
+++ b/drivers/media/platform/sti/bdisp/bdisp.h
@@ -0,0 +1,186 @@
+/*
+ * Copyright (C) STMicroelectronics SA 2014
+ * Authors: Fabien Dessenne <fabien.dessenne@st.com> for STMicroelectronics.
+ * License terms:  GNU General Public License (GPL), version 2
+ */
+
+#include <linux/clk.h>
+#include <linux/ktime.h>
+#include <linux/platform_device.h>
+#include <linux/spinlock.h>
+
+#include <media/v4l2-ctrls.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-mem2mem.h>
+
+#include <media/videobuf2-dma-contig.h>
+
+#define BDISP_NAME              "bdisp"
+
+/*
+ *  Max nb of nodes in node-list:
+ *   - 2 nodes to handle wide 4K pictures
+ *   - 2 nodes to handle two planes (Y & CbCr) */
+#define MAX_OUTPUT_PLANES       2
+#define MAX_VERTICAL_STRIDES    2
+#define MAX_NB_NODE             (MAX_OUTPUT_PLANES * MAX_VERTICAL_STRIDES)
+
+/* struct bdisp_ctrls - bdisp control set
+ * @hflip:      horizontal flip
+ * @vflip:      vertical flip
+ */
+struct bdisp_ctrls {
+	struct v4l2_ctrl        *hflip;
+	struct v4l2_ctrl        *vflip;
+};
+
+/**
+ * struct bdisp_fmt - driver's internal color format data
+ * @pixelformat:fourcc code for this format
+ * @nb_planes:  number of planes  (ex: [0]=RGB/Y - [1]=Cb/Cr, ...)
+ * @bpp:        bits per pixel (general)
+ * @bpp_plane0: byte per pixel for the 1st plane
+ * @w_align:    width alignment in pixel (multiple of)
+ * @h_align:    height alignment in pixel (multiple of)
+ */
+struct bdisp_fmt {
+	u32                     pixelformat;
+	u8                      nb_planes;
+	u8                      bpp;
+	u8                      bpp_plane0;
+	u8                      w_align;
+	u8                      h_align;
+};
+
+/**
+ * struct bdisp_frame - frame properties
+ *
+ * @width:      frame width (including padding)
+ * @height:     frame height (including padding)
+ * @fmt:        pointer to frame format descriptor
+ * @field:      frame / field type
+ * @bytesperline: stride of the 1st plane
+ * @sizeimage:  image size in bytes
+ * @colorspace: colorspace
+ * @crop:       crop area
+ * @paddr:      image physical addresses per plane ([0]=RGB/Y - [1]=Cb/Cr, ...)
+ */
+struct bdisp_frame {
+	u32                     width;
+	u32                     height;
+	const struct bdisp_fmt  *fmt;
+	enum v4l2_field         field;
+	u32                     bytesperline;
+	u32                     sizeimage;
+	enum v4l2_colorspace    colorspace;
+	struct v4l2_rect        crop;
+	dma_addr_t              paddr[4];
+};
+
+/**
+ * struct bdisp_request - bdisp request
+ *
+ * @src:        source frame properties
+ * @dst:        destination frame properties
+ * @hflip:      horizontal flip
+ * @vflip:      vertical flip
+ * @nb_req:     number of run request
+ */
+struct bdisp_request {
+	struct bdisp_frame      src;
+	struct bdisp_frame      dst;
+	unsigned int            hflip:1;
+	unsigned int            vflip:1;
+	int                     nb_req;
+};
+
+/**
+ * struct bdisp_ctx - device context data
+ *
+ * @src:        source frame properties
+ * @dst:        destination frame properties
+ * @state:      flags to keep track of user configuration
+ * @hflip:      horizontal flip
+ * @vflip:      vertical flip
+ * @bdisp_dev:  the device this context applies to
+ * @node:       node array
+ * @node_paddr: node physical address array
+ * @fh:         v4l2 file handle
+ * @ctrl_handler: v4l2 controls handler
+ * @bdisp_ctrls: bdisp control set
+ * @ctrls_rdy:  true if the control handler is initialized
+ */
+struct bdisp_ctx {
+	struct bdisp_frame      src;
+	struct bdisp_frame      dst;
+	u32                     state;
+	unsigned int            hflip:1;
+	unsigned int            vflip:1;
+	struct bdisp_dev        *bdisp_dev;
+	struct bdisp_node       *node[MAX_NB_NODE];
+	dma_addr_t              node_paddr[MAX_NB_NODE];
+	struct v4l2_fh          fh;
+	struct v4l2_ctrl_handler ctrl_handler;
+	struct bdisp_ctrls      bdisp_ctrls;
+	bool                    ctrls_rdy;
+};
+
+/**
+ * struct bdisp_m2m_device - v4l2 memory-to-memory device data
+ *
+ * @vdev:       video device node for v4l2 m2m mode
+ * @m2m_dev:    v4l2 m2m device data
+ * @ctx:        hardware context data
+ * @refcnt:     reference counter
+ */
+struct bdisp_m2m_device {
+	struct video_device     *vdev;
+	struct v4l2_m2m_dev     *m2m_dev;
+	struct bdisp_ctx        *ctx;
+	int                     refcnt;
+};
+
+/**
+ * struct bdisp_dev - abstraction for bdisp entity
+ *
+ * @v4l2_dev:   v4l2 device
+ * @vdev:       video device
+ * @pdev:       platform device
+ * @dev:        device
+ * @lock:       mutex protecting this data structure
+ * @slock:      spinlock protecting this data structure
+ * @id:         device index
+ * @m2m:        memory-to-memory V4L2 device information
+ * @state:      flags used to synchronize m2m and capture mode operation
+ * @alloc_ctx:  videobuf2 memory allocator context
+ * @clock:      IP clock
+ * @regs:       registers
+ * @irq_queue:  interrupt handler waitqueue
+ * @work_queue: workqueue to handle timeouts
+ * @timeout_work: IRQ timeout structure
+ */
+struct bdisp_dev {
+	struct v4l2_device      v4l2_dev;
+	struct video_device     vdev;
+	struct platform_device  *pdev;
+	struct device           *dev;
+	spinlock_t              slock;
+	struct mutex            lock;
+	u16                     id;
+	struct bdisp_m2m_device m2m;
+	unsigned long           state;
+	struct vb2_alloc_ctx    *alloc_ctx;
+	struct clk              *clock;
+	void __iomem            *regs;
+	wait_queue_head_t       irq_queue;
+	struct workqueue_struct *work_queue;
+	struct delayed_work     timeout_work;
+};
+
+void bdisp_hw_free_nodes(struct bdisp_ctx *ctx);
+int bdisp_hw_alloc_nodes(struct bdisp_ctx *ctx);
+void bdisp_hw_free_filters(struct device *dev);
+int bdisp_hw_alloc_filters(struct device *dev);
+int bdisp_hw_reset(struct bdisp_dev *bdisp);
+int bdisp_hw_get_and_clear_irq(struct bdisp_dev *bdisp);
+int bdisp_hw_update(struct bdisp_ctx *ctx);
-- 
1.9.1

