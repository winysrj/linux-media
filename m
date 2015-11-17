Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw02.mediatek.com ([210.61.82.184]:53410 "EHLO
	mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753490AbbKQMzW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Nov 2015 07:55:22 -0500
From: Tiffany Lin <tiffany.lin@mediatek.com>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will.deacon@arm.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Daniel Kurtz <djkurtz@chromium.org>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Hongzhou Yang <hongzhou.yang@mediatek.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>,
	Fabien Dessenne <fabien.dessenne@st.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Darren Etheridge <detheridge@ti.com>,
	Peter Griffin <peter.griffin@linaro.org>,
	Benoit Parrot <bparrot@ti.com>
CC: Tiffany Lin <tiffany.lin@mediatek.com>,
	Andrew-CT Chen <andrew-ct.chen@mediatek.com>,
	Eddie Huang <eddie.huang@mediatek.com>,
	Yingjoe Chen <yingjoe.chen@mediatek.com>,
	James Liao <jamesjj.liao@mediatek.com>,
	Daniel Hsiao <daniel.hsiao@mediatek.com>,
	<devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>,
	<linux-media@vger.kernel.org>, <linux-mediatek@lists.infradead.org>
Subject: [RESEND RFC/PATCH 6/8] media: platform: mtk-vcodec: Add Mediatek V4L2 Video Encoder Driver
Date: Tue, 17 Nov 2015 20:54:43 +0800
Message-ID: <1447764885-23100-7-git-send-email-tiffany.lin@mediatek.com>
In-Reply-To: <1447764885-23100-1-git-send-email-tiffany.lin@mediatek.com>
References: <1447764885-23100-1-git-send-email-tiffany.lin@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Tiffany Lin <tiffany.lin@mediatek.com>
Signed-off-by: Andrew-CT Chen <andrew-ct.chen@mediatek.com>
---
 drivers/media/platform/Kconfig                     |   13 +
 drivers/media/platform/Makefile                    |    3 +
 drivers/media/platform/mtk-vcodec/Kconfig          |    5 +
 drivers/media/platform/mtk-vcodec/Makefile         |   12 +
 drivers/media/platform/mtk-vcodec/common/Makefile  |    8 +
 .../media/platform/mtk-vcodec/common/venc_drv_if.c |  152 ++
 .../platform/mtk-vcodec/include/venc_drv_base.h    |   68 +
 .../platform/mtk-vcodec/include/venc_drv_if.h      |  187 +++
 .../platform/mtk-vcodec/include/venc_ipi_msg.h     |  212 +++
 drivers/media/platform/mtk-vcodec/mtk_vcodec_drv.h |  441 +++++
 drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c | 1773 ++++++++++++++++++++
 drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.h |   28 +
 .../media/platform/mtk-vcodec/mtk_vcodec_enc_drv.c |  535 ++++++
 .../media/platform/mtk-vcodec/mtk_vcodec_enc_pm.c  |  122 ++
 .../media/platform/mtk-vcodec/mtk_vcodec_intr.c    |  110 ++
 .../media/platform/mtk-vcodec/mtk_vcodec_intr.h    |   30 +
 drivers/media/platform/mtk-vcodec/mtk_vcodec_pm.h  |   26 +
 .../media/platform/mtk-vcodec/mtk_vcodec_util.c    |  106 ++
 .../media/platform/mtk-vcodec/mtk_vcodec_util.h    |   66 +
 19 files changed, 3897 insertions(+)
 create mode 100644 drivers/media/platform/mtk-vcodec/Kconfig
 create mode 100644 drivers/media/platform/mtk-vcodec/Makefile
 create mode 100644 drivers/media/platform/mtk-vcodec/common/Makefile
 create mode 100644 drivers/media/platform/mtk-vcodec/common/venc_drv_if.c
 create mode 100644 drivers/media/platform/mtk-vcodec/include/venc_drv_base.h
 create mode 100644 drivers/media/platform/mtk-vcodec/include/venc_drv_if.h
 create mode 100644 drivers/media/platform/mtk-vcodec/include/venc_ipi_msg.h
 create mode 100644 drivers/media/platform/mtk-vcodec/mtk_vcodec_drv.h
 create mode 100644 drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c
 create mode 100644 drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.h
 create mode 100644 drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_drv.c
 create mode 100644 drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_pm.c
 create mode 100644 drivers/media/platform/mtk-vcodec/mtk_vcodec_intr.c
 create mode 100644 drivers/media/platform/mtk-vcodec/mtk_vcodec_intr.h
 create mode 100644 drivers/media/platform/mtk-vcodec/mtk_vcodec_pm.h
 create mode 100644 drivers/media/platform/mtk-vcodec/mtk_vcodec_util.c
 create mode 100644 drivers/media/platform/mtk-vcodec/mtk_vcodec_util.h

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index f98eb47..b66cf1f 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -154,6 +154,19 @@ config MEDIATEK_VPU
 	    This driver provides downloading firmware vpu and
 	    communicating with vpu.
 
+config VIDEO_MEDIATEK_VCODEC
+        tristate "Mediatek Video Codec driver"
+        depends on VIDEO_DEV && VIDEO_V4L2
+        depends on ARCH_MEDIATEK || COMPILE_TEST
+        select VIDEOBUF2_DMA_CONTIG
+        select V4L2_MEM2MEM_DEV
+        select MEDIATEK_VPU
+        default n
+        ---help---
+            Mediatek video codec driver for V4L2
+
+source "drivers/media/platform/mtk-vcodec/Kconfig"
+
 config VIDEO_MEM2MEM_DEINTERLACE
 	tristate "Deinterlace support"
 	depends on VIDEO_DEV && VIDEO_V4L2 && DMA_ENGINE
diff --git a/drivers/media/platform/Makefile b/drivers/media/platform/Makefile
index 1b4c539..423b9f6 100644
--- a/drivers/media/platform/Makefile
+++ b/drivers/media/platform/Makefile
@@ -57,3 +57,6 @@ obj-$(CONFIG_VIDEO_XILINX)		+= xilinx/
 ccflags-y += -I$(srctree)/drivers/media/i2c
 
 obj-$(CONFIG_MEDIATEK_VPU)		+= mtk-vpu/
+
+obj-$(CONFIG_VIDEO_MEDIATEK_VCODEC)		+= mtk-vcodec/
+
diff --git a/drivers/media/platform/mtk-vcodec/Kconfig b/drivers/media/platform/mtk-vcodec/Kconfig
new file mode 100644
index 0000000..1c0b935
--- /dev/null
+++ b/drivers/media/platform/mtk-vcodec/Kconfig
@@ -0,0 +1,5 @@
+config MEDIATEK_VPU
+	bool
+	---help---
+	  This driver provides downloading firmware vpu (video processor unit)
+	  and communicating with vpu.
diff --git a/drivers/media/platform/mtk-vcodec/Makefile b/drivers/media/platform/mtk-vcodec/Makefile
new file mode 100644
index 0000000..c7f7174
--- /dev/null
+++ b/drivers/media/platform/mtk-vcodec/Makefile
@@ -0,0 +1,12 @@
+obj-$(CONFIG_VIDEO_MEDIATEK_VCODEC) += mtk_vcodec_intr.o \
+				       mtk_vcodec_util.o \
+				       mtk_vcodec_enc_drv.o \
+				       mtk_vcodec_enc.o \
+				       mtk_vcodec_enc_pm.o
+
+obj-$(CONFIG_VIDEO_MEDIATEK_VCODEC) += common/
+
+ccflags-y += -I$(srctree)/drivers/media/platform/mtk-vcodec/include \
+	     -I$(srctree)/drivers/media/platform/mtk-vcodec \
+	     -I$(srctree)/drivers/media/platform/mtk-vpu
+
diff --git a/drivers/media/platform/mtk-vcodec/common/Makefile b/drivers/media/platform/mtk-vcodec/common/Makefile
new file mode 100644
index 0000000..477ab80
--- /dev/null
+++ b/drivers/media/platform/mtk-vcodec/common/Makefile
@@ -0,0 +1,8 @@
+obj-y += \
+    venc_drv_if.o
+
+ccflags-y += \
+    -I$(srctree)/include/ \
+    -I$(srctree)/drivers/media/platform/mtk-vcodec \
+    -I$(srctree)/drivers/media/platform/mtk-vcodec/include \
+    -I$(srctree)/drivers/media/platform/mtk-vpu
\ No newline at end of file
diff --git a/drivers/media/platform/mtk-vcodec/common/venc_drv_if.c b/drivers/media/platform/mtk-vcodec/common/venc_drv_if.c
new file mode 100644
index 0000000..9b3f025
--- /dev/null
+++ b/drivers/media/platform/mtk-vcodec/common/venc_drv_if.c
@@ -0,0 +1,152 @@
+/*
+ * Copyright (c) 2015 MediaTek Inc.
+ * Author: Daniel Hsiao <daniel.hsiao@mediatek.com>
+ *         Jungchang Tsao <jungchang.tsao@mediatek.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/interrupt.h>
+#include <linux/kernel.h>
+#include <linux/slab.h>
+
+#include "mtk_vcodec_drv.h"
+#include "mtk_vcodec_enc.h"
+#include "mtk_vcodec_pm.h"
+#include "mtk_vcodec_util.h"
+#include "mtk_vpu_core.h"
+
+#include "venc_drv_if.h"
+#include "venc_drv_base.h"
+
+
+int venc_if_create(void *ctx, unsigned int fourcc, unsigned long *handle)
+{
+	struct venc_handle *h;
+	char str[10];
+
+	mtk_vcodec_fmt2str(fourcc, str);
+
+	h = kzalloc(sizeof(*h), GFP_KERNEL);
+	if (!h)
+		return -ENOMEM;
+
+	h->fourcc = fourcc;
+	h->ctx = ctx;
+	mtk_vcodec_debug(h, "fmt = %s handle = %p", str, h);
+
+	switch (fourcc) {
+	default:
+		mtk_vcodec_err(h, "invalid format %s", str);
+		goto err_out;
+	}
+
+	*handle = (unsigned long)h;
+	return 0;
+
+err_out:
+	kfree(h);
+	return -EINVAL;
+}
+
+int venc_if_init(unsigned long handle)
+{
+	int ret = 0;
+	struct venc_handle *h = (struct venc_handle *)handle;
+
+	mtk_vcodec_debug_enter(h);
+
+	mtk_venc_lock(h->ctx);
+	mtk_vcodec_enc_clock_on();
+	vpu_enable_clock(vpu_get_plat_device(h->ctx->dev->plat_dev));
+	ret = h->enc_if->init(h->ctx, (unsigned long *)&h->drv_handle);
+	vpu_disable_clock(vpu_get_plat_device(h->ctx->dev->plat_dev));
+	mtk_vcodec_enc_clock_off();
+	mtk_venc_unlock(h->ctx);
+
+	return ret;
+}
+
+int venc_if_set_param(unsigned long handle,
+		      enum venc_set_param_type type, void *in)
+{
+	int ret = 0;
+	struct venc_handle *h = (struct venc_handle *)handle;
+
+	mtk_vcodec_debug(h, "type=%d", type);
+
+	mtk_venc_lock(h->ctx);
+	mtk_vcodec_enc_clock_on();
+	vpu_enable_clock(vpu_get_plat_device(h->ctx->dev->plat_dev));
+	ret = h->enc_if->set_param(h->drv_handle, type, in);
+	vpu_disable_clock(vpu_get_plat_device(h->ctx->dev->plat_dev));
+	mtk_vcodec_enc_clock_off();
+	mtk_venc_unlock(h->ctx);
+
+	return ret;
+}
+
+int venc_if_encode(unsigned long handle,
+		   enum venc_start_opt opt, struct venc_frm_buf *frm_buf,
+		   struct mtk_vcodec_mem *bs_buf,
+		   struct venc_done_result *result)
+{
+	int ret = 0;
+	struct venc_handle *h = (struct venc_handle *)handle;
+	char str[10];
+
+	mtk_vcodec_fmt2str(h->fourcc, str);
+	mtk_vcodec_debug(h, "fmt=%s", str);
+
+	mtk_venc_lock(h->ctx);
+	mtk_vcodec_enc_clock_on();
+	vpu_enable_clock(vpu_get_plat_device(h->ctx->dev->plat_dev));
+	enable_irq((h->fourcc == V4L2_PIX_FMT_H264) ?
+		h->ctx->dev->enc_irq : h->ctx->dev->enc_lt_irq);
+	ret = h->enc_if->encode(h->drv_handle, opt, frm_buf, bs_buf, result);
+	disable_irq((h->fourcc == V4L2_PIX_FMT_H264) ?
+		h->ctx->dev->enc_irq : h->ctx->dev->enc_lt_irq);
+	vpu_disable_clock(vpu_get_plat_device(h->ctx->dev->plat_dev));
+	mtk_vcodec_enc_clock_off();
+	mtk_venc_unlock(h->ctx);
+
+	mtk_vcodec_debug(h, "ret=%d", ret);
+
+	return ret;
+}
+
+int venc_if_deinit(unsigned long handle)
+{
+	int ret = 0;
+	struct venc_handle *h = (struct venc_handle *)handle;
+
+	mtk_vcodec_debug_enter(h);
+
+	mtk_venc_lock(h->ctx);
+	mtk_vcodec_enc_clock_on();
+	vpu_enable_clock(vpu_get_plat_device(h->ctx->dev->plat_dev));
+	ret = h->enc_if->deinit(h->drv_handle);
+	vpu_disable_clock(vpu_get_plat_device(h->ctx->dev->plat_dev));
+	mtk_vcodec_enc_clock_off();
+	mtk_venc_unlock(h->ctx);
+
+	return ret;
+}
+
+int venc_if_release(unsigned long handle)
+{
+	struct venc_handle *h = (struct venc_handle *)handle;
+
+	mtk_vcodec_debug_enter(h);
+	kfree(h);
+
+	return 0;
+}
diff --git a/drivers/media/platform/mtk-vcodec/include/venc_drv_base.h b/drivers/media/platform/mtk-vcodec/include/venc_drv_base.h
new file mode 100644
index 0000000..8828294
--- /dev/null
+++ b/drivers/media/platform/mtk-vcodec/include/venc_drv_base.h
@@ -0,0 +1,68 @@
+/*
+ * Copyright (c) 2015 MediaTek Inc.
+ * Author: Daniel Hsiao <daniel.hsiao@mediatek.com>
+ *         Jungchang Tsao <jungchang.tsao@mediatek.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef _VENC_DRV_BASE_
+#define _VENC_DRV_BASE_
+
+#include "mtk_vcodec_drv.h"
+
+#include "venc_drv_if.h"
+
+struct venc_common_if {
+	/**
+	 * (*init)() - initialize driver
+	 * @ctx:	[in] mtk v4l2 context
+	 * @handle: [out] driver handle
+	 */
+	int (*init)(struct mtk_vcodec_ctx *ctx, unsigned long *handle);
+
+	/**
+	 * (*encode)() - trigger encode
+	 * @handle: [in] driver handle
+	 * @opt: [in] encode option
+	 * @frm_buf: [in] frame buffer to store input frame
+	 * @bs_buf: [in] bitstream buffer to store output bitstream
+	 * @result: [out] encode result
+	 */
+	int (*encode)(unsigned long handle, enum venc_start_opt opt,
+		      struct venc_frm_buf *frm_buf,
+		      struct mtk_vcodec_mem *bs_buf,
+		      struct venc_done_result *result);
+
+	/**
+	 * (*set_param)() - set driver's parameter
+	 * @handle: [in] driver handle
+	 * @type: [in] parameter type
+	 * @in: [in] buffer to store the parameter
+	 */
+	int (*set_param)(unsigned long handle, enum venc_set_param_type type,
+			 void *in);
+
+	/**
+	 * (*deinit)() - deinitialize driver.
+	 * @handle: [in] driver handle
+	 */
+	int (*deinit)(unsigned long handle);
+};
+
+struct venc_handle {
+	unsigned int fourcc;
+	struct venc_common_if *enc_if;
+	unsigned long drv_handle;
+	struct mtk_vcodec_ctx *ctx;
+};
+
+#endif
diff --git a/drivers/media/platform/mtk-vcodec/include/venc_drv_if.h b/drivers/media/platform/mtk-vcodec/include/venc_drv_if.h
new file mode 100644
index 0000000..ef0b0b9
--- /dev/null
+++ b/drivers/media/platform/mtk-vcodec/include/venc_drv_if.h
@@ -0,0 +1,187 @@
+/*
+ * Copyright (c) 2015 MediaTek Inc.
+ * Author: Daniel Hsiao <daniel.hsiao@mediatek.com>
+ *         Jungchang Tsao <jungchang.tsao@mediatek.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef _VENC_DRV_IF_H_
+#define _VENC_DRV_IF_H_
+
+#include "mtk_vcodec_util.h"
+
+/*
+ * enum venc_yuv_fmt - The type of input yuv format
+ * (VPU related: If you change the order, you must also update the VPU codes.)
+ * @VENC_YUV_FORMAT_420: 420 YUV format
+ * @VENC_YUV_FORMAT_YV12: YV12 YUV format
+ * @VENC_YUV_FORMAT_NV12: NV12 YUV format
+ * @VENC_YUV_FORMAT_NV21: NV21 YUV format
+ */
+enum venc_yuv_fmt {
+	VENC_YUV_FORMAT_420 = 3,
+	VENC_YUV_FORMAT_YV12 = 5,
+	VENC_YUV_FORMAT_NV12 = 6,
+	VENC_YUV_FORMAT_NV21 = 7,
+};
+
+/*
+ * enum venc_start_opt - encode frame option used in venc_if_encode()
+ * @VENC_START_OPT_ENCODE_SEQUENCE_HEADER: encode SPS/PPS for H264
+ * @VENC_START_OPT_ENCODE_FRAME: encode normal frame
+ */
+enum venc_start_opt {
+	VENC_START_OPT_ENCODE_SEQUENCE_HEADER,
+	VENC_START_OPT_ENCODE_FRAME,
+};
+
+/*
+ * enum venc_drv_msg - The type of encode frame status used in venc_if_encode()
+ * @VENC_MESSAGE_OK: encode ok
+ * @VENC_MESSAGE_ERR: encode error
+ */
+enum venc_drv_msg {
+	VENC_MESSAGE_OK,
+	VENC_MESSAGE_ERR,
+};
+
+/*
+ * enum venc_set_param_type - The type of set parameter used in venc_if_set_param()
+ * (VPU related: If you change the order, you must also update the VPU codes.)
+ * @VENC_SET_PARAM_ENC: set encoder parameters
+ * @VENC_SET_PARAM_FORCE_INTRA: set force intra frame
+ * @VENC_SET_PARAM_ADJUST_BITRATE: set to adjust bitrate (in bps)
+ * @VENC_SET_PARAM_ADJUST_FRAMERATE: set frame rate
+ * @VENC_SET_PARAM_I_FRAME_INTERVAL: set I frame interval
+ * @VENC_SET_PARAM_SKIP_FRAME: set H264 skip one frame
+ * @VENC_SET_PARAM_PREPEND_HEADER: set H264 prepend SPS/PPS before IDR
+ * @VENC_SET_PARAM_TS_MODE: set VP8 temporal scalability mode
+ */
+enum venc_set_param_type {
+	VENC_SET_PARAM_ENC,
+	VENC_SET_PARAM_FORCE_INTRA,
+	VENC_SET_PARAM_ADJUST_BITRATE,
+	VENC_SET_PARAM_ADJUST_FRAMERATE,
+	VENC_SET_PARAM_I_FRAME_INTERVAL,
+	VENC_SET_PARAM_SKIP_FRAME,
+	VENC_SET_PARAM_PREPEND_HEADER,
+	VENC_SET_PARAM_TS_MODE,
+};
+
+/*
+ * struct venc_enc_prm - encoder settings for VENC_SET_PARAM_ENC used in venc_if_set_param()
+ * @input_fourcc: input fourcc
+ * @h264_profile: V4L2 defined H.264 profile
+ * @h264_level: V4L2 defined H.264 level
+ * @width: image width
+ * @height: image height
+ * @buf_width: buffer width
+ * @buf_height: buffer height
+ * @frm_rate: frame rate
+ * @intra_period: intra frame period
+ * @bitrate: target bitrate in kbps
+ */
+struct venc_enc_prm {
+	enum venc_yuv_fmt input_fourcc;
+	unsigned int h264_profile;
+	unsigned int h264_level;
+	unsigned int width;
+	unsigned int height;
+	unsigned int buf_width;
+	unsigned int buf_height;
+	unsigned int frm_rate;
+	unsigned int intra_period;
+	unsigned int bitrate;
+};
+
+/*
+ * struct venc_frm_buf - frame buffer information used in venc_if_encode()
+ * @fb_addr: plane 0 frame buffer address
+ * @fb_addr1: plane 1 frame buffer address
+ * @fb_addr2: plane 2 frame buffer address
+ */
+struct venc_frm_buf {
+	struct mtk_vcodec_mem fb_addr;
+	struct mtk_vcodec_mem fb_addr1;
+	struct mtk_vcodec_mem fb_addr2;
+};
+
+/*
+ * struct venc_done_result - This is return information used in venc_if_encode()
+ * @msg: message, such as success or error code
+ * @bs_size: output bitstream size
+ * @is_key_frm: output is key frame or not
+ */
+struct venc_done_result {
+	enum venc_drv_msg msg;
+	unsigned int bs_size;
+	bool is_key_frm;
+};
+
+/*
+ * venc_if_create - Create the driver handle
+ * @ctx: device context
+ * @fourcc: encoder output format
+ * @handle: driver handle
+ * Return: 0 if creating handle successfully, otherwise it is failed.
+ */
+int venc_if_create(void *ctx, unsigned int fourcc, unsigned long *handle);
+
+/*
+ * venc_if_release - Release the driver handle
+ * @handle: driver handle
+ * Return: 0 if releasing handle successfully, otherwise it is failed.
+ */
+int venc_if_release(unsigned long handle);
+
+/*
+ * venc_if_init - Init the driver setting, alloc working memory ... etc.
+ * @handle: driver handle
+ * Return: 0 if init handle successfully, otherwise it is failed.
+ */
+int venc_if_init(unsigned long handle);
+
+/*
+ * venc_if_deinit - DeInit the driver setting, free working memory ... etc.
+ * @handle: driver handle
+ * Return: 0 if deinit handle successfully, otherwise it is failed.
+ */
+int venc_if_deinit(unsigned long handle);
+
+/*
+ * venc_if_set_param - Set parameter to driver
+ * @handle: driver handle
+ * @type: set type
+ * @in: input parameter
+ * @out: output parameter
+ * Return: 0 if setting param successfully, otherwise it is failed.
+ */
+int venc_if_set_param(unsigned long handle,
+		      enum venc_set_param_type type,
+		      void *in);
+
+/*
+ * venc_if_encode - Encode frame
+ * @handle: driver handle
+ * @opt: encode frame option
+ * @frm_buf: input frame buffer information
+ * @bs_buf: output bitstream buffer infomraiton
+ * @result: encode result
+ * Return: 0 if encoding frame successfully, otherwise it is failed.
+ */
+int venc_if_encode(unsigned long handle,
+		   enum venc_start_opt opt,
+		   struct venc_frm_buf *frm_buf,
+		   struct mtk_vcodec_mem *bs_buf,
+		   struct venc_done_result *result);
+
+#endif /* _VENC_DRV_IF_H_ */
diff --git a/drivers/media/platform/mtk-vcodec/include/venc_ipi_msg.h b/drivers/media/platform/mtk-vcodec/include/venc_ipi_msg.h
new file mode 100644
index 0000000..a345b98
--- /dev/null
+++ b/drivers/media/platform/mtk-vcodec/include/venc_ipi_msg.h
@@ -0,0 +1,212 @@
+/*
+ * Copyright (c) 2015 MediaTek Inc.
+ * Author: Jungchang Tsao <jungchang.tsao@mediatek.com>
+ *         Daniel Hsiao <daniel.hsiao@mediatek.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef _VENC_IPI_MSG_H_
+#define _VENC_IPI_MSG_H_
+
+#define IPIMSG_H264_ENC_ID 0x100
+#define IPIMSG_VP8_ENC_ID 0x200
+
+#define AP_IPIMSG_VENC_BASE 0x20000
+#define VPU_IPIMSG_VENC_BASE 0x30000
+
+/**
+ * enum venc_ipi_msg_id - message id between AP and VPU
+ * (ipi stands for inter-processor interrupt)
+ * @AP_IPIMSG_XXX:		AP to VPU cmd message id
+ * @VPU_IPIMSG_XXX_DONE:	VPU ack AP cmd message id
+ */
+enum venc_ipi_msg_id {
+	AP_IPIMSG_H264_ENC_INIT = AP_IPIMSG_VENC_BASE +
+				  IPIMSG_H264_ENC_ID,
+	AP_IPIMSG_H264_ENC_SET_PARAM,
+	AP_IPIMSG_H264_ENC_ENCODE,
+	AP_IPIMSG_H264_ENC_DEINIT,
+
+	AP_IPIMSG_VP8_ENC_INIT = AP_IPIMSG_VENC_BASE +
+				 IPIMSG_VP8_ENC_ID,
+	AP_IPIMSG_VP8_ENC_SET_PARAM,
+	AP_IPIMSG_VP8_ENC_ENCODE,
+	AP_IPIMSG_VP8_ENC_DEINIT,
+
+	VPU_IPIMSG_H264_ENC_INIT_DONE = VPU_IPIMSG_VENC_BASE +
+					IPIMSG_H264_ENC_ID,
+	VPU_IPIMSG_H264_ENC_SET_PARAM_DONE,
+	VPU_IPIMSG_H264_ENC_ENCODE_DONE,
+	VPU_IPIMSG_H264_ENC_DEINIT_DONE,
+
+	VPU_IPIMSG_VP8_ENC_INIT_DONE = VPU_IPIMSG_VENC_BASE +
+				       IPIMSG_VP8_ENC_ID,
+	VPU_IPIMSG_VP8_ENC_SET_PARAM_DONE,
+	VPU_IPIMSG_VP8_ENC_ENCODE_DONE,
+	VPU_IPIMSG_VP8_ENC_DEINIT_DONE,
+};
+
+/**
+ * struct venc_ap_ipi_msg_init - AP to VPU init cmd structure
+ * @msg_id:	message id (AP_IPIMSG_XXX_ENC_INIT)
+ * @venc_inst:	AP encoder instance (struct venc_vp8_handle/venc_h264_handle *)
+ */
+struct venc_ap_ipi_msg_init {
+	uint32_t msg_id;
+	uint32_t reserved;
+	uint64_t venc_inst;
+};
+
+/**
+ * struct venc_ap_ipi_msg_set_param - AP to VPU set_param cmd structure
+ * @msg_id:	message id (AP_IPIMSG_XXX_ENC_SET_PARAM)
+ * @inst_id:	VPU encoder instance id (struct venc_vp8_vpu_drv/venc_h264_vpu_drv *)
+ * @param_id:	parameter id (venc_set_param_type)
+ * @data_item:	number of items in the data array
+ * @data[8]:	data array to store the set parameters
+ */
+struct venc_ap_ipi_msg_set_param {
+	uint32_t msg_id;
+	uint32_t inst_id;
+	uint32_t param_id;
+	uint32_t data_item;
+	uint32_t data[8];
+};
+
+/**
+ * struct venc_ap_ipi_msg_enc - AP to VPU enc cmd structure
+ * @msg_id:	message id (AP_IPIMSG_XXX_ENC_ENCODE)
+ * @inst_id:	VPU encoder instance id (struct venc_vp8_vpu_drv/venc_h264_vpu_drv *)
+ * @bs_mode:	bitstream mode for h264
+ *		(H264_BS_MODE_SPS/H264_BS_MODE_PPS/H264_BS_MODE_FRAME)
+ * @input_addr:	pointer to input image buffer plane
+ * @bs_addr:	pointer to output bit stream buffer
+ * @bs_size:	bit stream buffer size
+ */
+struct venc_ap_ipi_msg_enc {
+	uint32_t msg_id;
+	uint32_t inst_id;
+	uint32_t bs_mode;
+	uint32_t input_addr[3];
+	uint32_t bs_addr;
+	uint32_t bs_size;
+};
+
+/**
+ * struct venc_ap_ipi_msg_deinit - AP to VPU deinit cmd structure
+ * @msg_id:	message id (AP_IPIMSG_XXX_ENC_DEINIT)
+ * @inst_id:	VPU encoder instance id (struct venc_vp8_vpu_drv/venc_h264_vpu_drv *)
+ */
+struct venc_ap_ipi_msg_deinit {
+	uint32_t msg_id;
+	uint32_t inst_id;
+};
+
+/**
+ * enum venc_ipi_msg_status - VPU ack AP cmd status
+ */
+enum venc_ipi_msg_status {
+	VENC_IPI_MSG_STATUS_OK,
+	VENC_IPI_MSG_STATUS_FAIL,
+};
+
+/**
+ * struct venc_vpu_ipi_msg_common - VPU ack AP cmd common structure
+ * @msg_id:	message id (VPU_IPIMSG_XXX_DONE)
+ * @status:	cmd status (venc_ipi_msg_status)
+ * @venc_inst:	AP encoder instance (struct venc_vp8_handle/venc_h264_handle *)
+ */
+struct venc_vpu_ipi_msg_common {
+	uint32_t msg_id;
+	uint32_t status;
+	uint64_t venc_inst;
+};
+
+/**
+ * struct venc_vpu_ipi_msg_init - VPU ack AP init cmd structure
+ * @msg_id:	message id (VPU_IPIMSG_XXX_ENC_SET_PARAM_DONE)
+ * @status:	cmd status (venc_ipi_msg_status)
+ * @venc_inst:	AP encoder instance (struct venc_vp8_handle/venc_h264_handle *)
+ * @inst_id:	VPU encoder instance id (struct venc_vp8_vpu_drv/venc_h264_vpu_drv *)
+ */
+struct venc_vpu_ipi_msg_init {
+	uint32_t msg_id;
+	uint32_t status;
+	uint64_t venc_inst;
+	uint32_t inst_id;
+	uint32_t reserved;
+};
+
+/**
+ * struct venc_vpu_ipi_msg_set_param - VPU ack AP set_param cmd structure
+ * @msg_id:	message id (VPU_IPIMSG_XXX_ENC_SET_PARAM_DONE)
+ * @status:	cmd status (venc_ipi_msg_status)
+ * @venc_inst:	AP encoder instance (struct venc_vp8_handle/venc_h264_handle *)
+ * @param_id:	parameter id (venc_set_param_type)
+ * @data_item:	number of items in the data array
+ * @data[6]:	data array to store the return result
+ */
+struct venc_vpu_ipi_msg_set_param {
+	uint32_t msg_id;
+	uint32_t status;
+	uint64_t venc_inst;
+	uint32_t param_id;
+	uint32_t data_item;
+	uint32_t data[6];
+};
+
+/**
+ * enum venc_ipi_msg_enc_state - Type of encode state
+ * VEN_IPI_MSG_ENC_STATE_FRAME:	one frame being encoded
+ * VEN_IPI_MSG_ENC_STATE_PART:	bit stream buffer full
+ * VEN_IPI_MSG_ENC_STATE_SKIP:	encoded skip frame
+ * VEN_IPI_MSG_ENC_STATE_ERROR:	encounter error
+ */
+enum venc_ipi_msg_enc_state {
+	VEN_IPI_MSG_ENC_STATE_FRAME,
+	VEN_IPI_MSG_ENC_STATE_PART,
+	VEN_IPI_MSG_ENC_STATE_SKIP,
+	VEN_IPI_MSG_ENC_STATE_ERROR,
+};
+
+/**
+ * struct venc_vpu_ipi_msg_enc - VPU ack AP enc cmd structure
+ * @msg_id:	message id (VPU_IPIMSG_XXX_ENC_ENCODE_DONE)
+ * @status:	cmd status (venc_ipi_msg_status)
+ * @venc_inst:	AP encoder instance (struct venc_vp8_handle/venc_h264_handle *)
+ * @state:	encode state (venc_ipi_msg_enc_state)
+ * @key_frame:	whether the encoded frame is key frame
+ * @bs_size:	encoded bitstream size
+ */
+struct venc_vpu_ipi_msg_enc {
+	uint32_t msg_id;
+	uint32_t status;
+	uint64_t venc_inst;
+	uint32_t state;
+	uint32_t key_frame;
+	uint32_t bs_size;
+	uint32_t reserved;
+};
+
+/**
+ * struct venc_vpu_ipi_msg_deinit - VPU ack AP deinit cmd structure
+ * @msg_id:   message id (VPU_IPIMSG_XXX_ENC_DEINIT_DONE)
+ * @status:   cmd status (venc_ipi_msg_status)
+ * @venc_inst:	AP encoder instance (struct venc_vp8_handle/venc_h264_handle *)
+ */
+struct venc_vpu_ipi_msg_deinit {
+	uint32_t msg_id;
+	uint32_t status;
+	uint64_t venc_inst;
+};
+
+#endif /* _VENC_IPI_MSG_H_ */
diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_drv.h b/drivers/media/platform/mtk-vcodec/mtk_vcodec_drv.h
new file mode 100644
index 0000000..22239f8
--- /dev/null
+++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_drv.h
@@ -0,0 +1,441 @@
+/*
+* Copyright (c) 2015 MediaTek Inc.
+* Author: PC Chen <pc.chen@mediatek.com>
+*         Tiffany Lin <tiffany.lin@mediatek.com>
+*
+* This program is free software; you can redistribute it and/or modify
+* it under the terms of the GNU General Public License version 2 as
+* published by the Free Software Foundation.
+*
+* This program is distributed in the hope that it will be useful,
+* but WITHOUT ANY WARRANTY; without even the implied warranty of
+* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+* GNU General Public License for more details.
+*/
+
+#ifndef _MTK_VCODEC_DRV_H_
+#define _MTK_VCODEC_DRV_H_
+
+#include <linux/platform_device.h>
+#include <linux/videodev2.h>
+#include <media/v4l2-ctrls.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-ioctl.h>
+#include <media/videobuf2-core.h>
+#include <media/videobuf2-v4l2.h>
+
+#include "venc_drv_if.h"
+
+#define MTK_VCODEC_MAX_INSTANCES	32
+#define MTK_VCODEC_MAX_FRAME_SIZE	0x800000
+#define MTK_VIDEO_MAX_FRAME		32
+#define MTK_MAX_CTRLS			10
+
+#define MTK_VCODEC_DRV_NAME		"mtk_vcodec_drv"
+#define MTK_VCODEC_ENC_NAME		"mtk-vcodec-enc"
+
+#define MTK_VENC_IRQ_STATUS_SPS          0x1
+#define MTK_VENC_IRQ_STATUS_PPS          0x2
+#define MTK_VENC_IRQ_STATUS_FRM          0x4
+#define MTK_VENC_IRQ_STATUS_DRAM         0x8
+#define MTK_VENC_IRQ_STATUS_PAUSE        0x10
+#define MTK_VENC_IRQ_STATUS_SWITCH       0x20
+
+#define MTK_VENC_IRQ_STATUS_OFFSET       0x05C
+#define MTK_VENC_IRQ_ACK_OFFSET          0x060
+
+#define MTK_VCODEC_MAX_PLANES		3
+
+#define VDEC_HW_ACTIVE	0x10
+#define VDEC_IRQ_CFG    0x11
+#define VDEC_IRQ_CLR    0x10
+
+#define VDEC_IRQ_CFG_REG	0xa4
+#define NUM_MAX_ALLOC_CTX  4
+#define MTK_V4L2_BENCHMARK 0
+#define USE_ENCODE_THREAD  1
+
+/**
+ * enum mtk_hw_reg_idx - MTK hw register base index
+ */
+enum mtk_hw_reg_idx {
+	VDEC_SYS,
+	VDEC_MISC,
+	VDEC_LD,
+	VDEC_TOP,
+	VDEC_CM,
+	VDEC_AD,
+	VDEC_AV,
+	VDEC_PP,
+	VDEC_HWD,
+	VDEC_HWQ,
+	VDEC_HWB,
+	VDEC_HWG,
+	NUM_MAX_VDEC_REG_BASE,
+	VENC_SYS = NUM_MAX_VDEC_REG_BASE,
+	VENC_LT_SYS,
+	NUM_MAX_VCODEC_REG_BASE
+};
+
+/**
+ * enum mtk_instance_type - The type of an MTK Vcodec instance.
+ */
+enum mtk_instance_type {
+	MTK_INST_DECODER		= 0,
+	MTK_INST_ENCODER		= 1,
+};
+
+/**
+ * enum mtk_instance_state - The state of an MTK Vcodec instance.
+ * @MTK_STATE_FREE - default state when instance create
+ * @MTK_STATE_CREATE - vdec instance is create
+ * @MTK_STATE_INIT - vdec instance is init
+ * @MTK_STATE_CONFIG - reserved for encoder
+ * @MTK_STATE_HEADER - vdec had sps/pps header parsed
+ * @MTK_STATE_RUNNING - vdec is decoding
+ * @MTK_STATE_FLUSH - vdec is flushing
+ * @MTK_STATE_RES_CHANGE - vdec detect resolution change
+ * @MTK_STATE_FINISH - ctx instance is stopped streaming
+ * @MTK_STATE_DEINIT - before release ctx instance
+ * @MTK_STATE_ERROR - vdec has something wrong
+ * @MTK_STATE_ABORT - abort work in working thread
+ */
+enum mtk_instance_state {
+	MTK_STATE_FREE		= 0,
+	MTK_STATE_CREATE	= (1 << 0),
+	MTK_STATE_INIT		= (1 << 1),
+	MTK_STATE_CONFIG	= (1 << 2),
+	MTK_STATE_HEADER	= (1 << 3),
+	MTK_STATE_RUNNING	= (1 << 4),
+	MTK_STATE_FLUSH		= (1 << 5),
+	MTK_STATE_RES_CHANGE	= (1 << 6),
+	MTK_STATE_FINISH	= (1 << 7),
+	MTK_STATE_DEINIT	= (1 << 8),
+	MTK_STATE_ERROR		= (1 << 9),
+	MTK_STATE_ABORT		= (1 << 10),
+};
+
+/**
+ * struct mtk_param_change - General encoding parameters type
+ */
+enum mtk_encode_param {
+	MTK_ENCODE_PARAM_NONE = 0,
+	MTK_ENCODE_PARAM_BITRATE = (1 << 0),
+	MTK_ENCODE_PARAM_FRAMERATE = (1 << 1),
+	MTK_ENCODE_PARAM_INTRA_PERIOD = (1 << 2),
+	MTK_ENCODE_PARAM_FRAME_TYPE = (1 << 3),
+	MTK_ENCODE_PARAM_SKIP_FRAME = (1 << 4),
+};
+
+/**
+ * enum mtk_fmt_type - Type of the pixelformat
+ * @MTK_FMT_FRAME - mtk vcodec raw frame
+ */
+enum mtk_fmt_type {
+	MTK_FMT_DEC		= 0,
+	MTK_FMT_ENC		= 1,
+	MTK_FMT_FRAME		= 2,
+};
+
+/**
+ * struct mtk_video_fmt - Structure used to store information about pixelformats
+ */
+struct mtk_video_fmt {
+	char *name;
+	u32 fourcc;
+	enum mtk_fmt_type type;
+	u32 num_planes;
+};
+
+/**
+ * struct mtk_codec_framesizes - Structure used to store information about framesizes
+ */
+struct mtk_codec_framesizes {
+	u32 fourcc;
+	struct	v4l2_frmsize_stepwise	stepwise;
+};
+
+/**
+ * struct mtk_q_type - Type of queue
+ */
+enum mtk_q_type {
+	MTK_Q_DATA_SRC		= 0,
+	MTK_Q_DATA_DST		= 1,
+};
+
+/**
+ * struct mtk_q_data - Structure used to store information about queue
+ * @colorspace	reserved for encoder
+ * @field		reserved for encoder
+ */
+struct mtk_q_data {
+	unsigned int		width;
+	unsigned int		height;
+	enum v4l2_field		field;
+	enum v4l2_colorspace	colorspace;
+	unsigned int		bytesperline[MTK_VCODEC_MAX_PLANES];
+	unsigned int		sizeimage[MTK_VCODEC_MAX_PLANES];
+	struct mtk_video_fmt	*fmt;
+};
+
+/**
+ * struct mtk_enc_params - General encoding parameters
+ * @bitrate - target bitrate
+ * @num_b_frame - number of b frames between p-frame
+ * @rc_frame - frame based rate control
+ * @rc_mb - macroblock based rate control
+ * @seq_hdr_mode - H.264 sequence header is encoded separately or joined with the first frame
+ * @gop_size - group of picture size, it's used as the intra frame period
+ * @framerate_num - frame rate numerator
+ * @framerate_denom - frame rate denominator
+ * @h264_max_qp - Max value for H.264 quantization parameter
+ * @h264_profile - V4L2 defined H.264 profile
+ * @h264_level - V4L2 defined H.264 level
+ * @force_intra - force/insert intra frame
+ * @skip_frame - encode in skip frame mode that use minimum number of bits
+ */
+struct mtk_enc_params {
+	unsigned int	bitrate;
+	unsigned int	num_b_frame;
+	unsigned int	rc_frame;
+	unsigned int	rc_mb;
+	unsigned int	seq_hdr_mode;
+	unsigned int	gop_size;
+	unsigned int	framerate_num;
+	unsigned int	framerate_denom;
+	unsigned int	h264_max_qp;
+	unsigned int	h264_profile;
+	unsigned int	h264_level;
+	unsigned int	force_intra;
+	unsigned int	skip_frame;
+};
+
+/**
+ * struct mtk_vcodec_pm - Power management data structure
+ */
+struct mtk_vcodec_pm {
+	struct clk	*mmpll;
+	struct clk	*vcodecpll;
+	struct clk	*univpll_d2;
+	struct clk	*clk_cci400_sel;
+	struct clk	*vdecpll;
+	struct clk	*vdec_sel;
+	struct clk	*vencpll;
+	struct clk	*venc_lt_sel;
+	struct clk	*vcodecpll_370p5_ck;
+	struct device	*larbvdec;
+	struct device	*larbvenc;
+	struct device	*larbvenclt;
+	struct device	*dev;
+	struct mtk_vcodec_dev *mtkdev;
+};
+
+/**
+ * struct mtk_video_enc_buf - Private data related to each VB2 buffer.
+ * @b:			Pointer to related VB2 buffer.
+ * @param_change:	Types of encode parameter change before encode this
+ *			buffer
+ * @enc_params		Encode parameters changed before encode this buffer
+ */
+struct mtk_video_enc_buf {
+	struct vb2_v4l2_buffer b;
+	struct list_head list;
+
+	enum mtk_encode_param param_change;
+	struct mtk_enc_params enc_params;
+};
+
+/**
+ * struct mtk_vcodec_ctx - Context (instance) private data.
+ *
+ * @type:		type of the instance - decoder or encoder
+ * @dev:		pointer to the mtk_vcodec_dev of the device
+ * @fh:			struct v4l2_fh
+ * @m2m_ctx:		pointer to the v4l2_m2m_ctx of the context
+ * @q_data:		store information of input and output queue
+ *			of the context
+ * @idx:			index of the context that this structure describes
+ * @state:		state of the context
+ * @aborting:
+ * @param_change:
+ * @param_change_mutex:
+ * @enc_params:		encoding parameters
+ * @colorspace:
+ *
+ * @h_enc:		encoder handler
+ * @picinfo:		store width/height of image and buffer and planes' size for decoder
+ *			and encoder
+ * @pb_count:		count of the DPB buffers required by MTK Vcodec hw
+ * @hdr:
+ *
+ * @int_cond:		variable used by the waitqueue
+ * @int_type:		type of the last interrupt
+ * @queue:		waitqueue that can be used to wait for this context to
+ *			finish
+ * @irq_status:
+ *
+ * @display_time_info:	display time for destination buffers
+ * @in_time_idx:	latest insert display time index
+ * @out_time_idx:	first remove display time index
+ *
+ * @ctrl_hdl:		handler for v4l2 framework
+ * @ctrls:		array of controls, used when adding controls to the
+ *			v4l2 control framework
+ *
+ * @encode_work:	worker for the encoding
+ */
+struct mtk_vcodec_ctx {
+	enum mtk_instance_type type;
+	struct mtk_vcodec_dev *dev;
+	struct v4l2_fh fh;
+	struct v4l2_m2m_ctx *m2m_ctx;
+	struct mtk_q_data q_data[2];
+	int idx;
+	enum mtk_instance_state state;
+	int aborting;
+	enum mtk_encode_param param_change;
+	struct mutex encode_param_mutex;
+	struct mutex vb2_mutex;
+	struct mtk_enc_params enc_params;
+
+	unsigned long h_enc;
+	int hdr;
+
+	int int_cond;
+	int int_type;
+	wait_queue_head_t queue;
+	unsigned int irq_status;
+
+	struct v4l2_ctrl_handler ctrl_hdl;
+	struct v4l2_ctrl *ctrls[MTK_MAX_CTRLS];
+
+	struct work_struct encode_work;
+
+#if MTK_V4L2_BENCHMARK
+	unsigned int total_enc_dec_cnt;
+	unsigned int total_enc_dec_time;
+	unsigned int total_enc_hdr_time;
+	unsigned int total_enc_dec_init_time;
+
+	unsigned int total_qbuf_out_time;
+	unsigned int total_qbuf_cap_time;
+	unsigned int total_qbuf_out_cnt;
+	unsigned int total_qbuf_cap_cnt;
+	unsigned int total_dqbuf_out_time;
+	unsigned int total_dqbuf_cap_time;
+	unsigned int total_dqbuf_out_cnt;
+	unsigned int total_dqbuf_cap_cnt;
+	unsigned int total_dqbuf_cnt;
+	unsigned int total_expbuf_time;
+#endif
+
+};
+
+/**
+ * struct mtk_vcodec_dev - driver data
+ * @v4l2_dev:		V4L2 device to register video devices for.
+ * @vfd_enc:		Video device for encoder.
+ *
+ * @m2m_dev_enc:	m2m device for encoder.
+ * @plat_dev:		platform device
+ * @alloc_ctx:		VB2 allocator context
+ *			(for allocations without kernel mapping).
+ * @ctx:			array of driver contexts
+ *
+ * @curr_ctx:		The context that is waiting for codec hardware
+ *
+ * @reg_base:		Mapped address of MTK Vcodec registers.
+ *
+ * @instance_mask:	used to mark which contexts are opened
+ * @num_instances:	counter of active MTK Vcodec instances
+ *
+ * @encode_workqueue:	encode work queue
+ *
+ * @int_cond:		used to identify interrupt condition happen
+ * @int_type:		used to identify what kind of interrupt condition happen
+ * @dev_mutex:		video_device lock
+ * @queue:		waitqueue for waiting for completion of device commands
+ *
+ * @enc_irq:		encoder irq resource.
+ * @enc_lt_irq:		encoder lt irq resource.
+ *
+ * @enc_mutex:		encoder hardware lock.
+ *
+ * @pm:			power management control
+ * @dec_capability:	used to identify decode capability, ex: 4k
+ * @enc_capability:     used to identify encode capability
+ */
+struct mtk_vcodec_dev {
+	struct v4l2_device	v4l2_dev;
+	struct video_device	*vfd_enc;
+
+	struct v4l2_m2m_dev	*m2m_dev_enc;
+	struct platform_device	*plat_dev;
+	struct vb2_alloc_ctx	*alloc_ctx;
+	struct mtk_vcodec_ctx	*ctx[MTK_VCODEC_MAX_INSTANCES];
+	int curr_ctx;
+	void __iomem		*reg_base[NUM_MAX_VCODEC_REG_BASE];
+
+	unsigned long	instance_mask[BITS_TO_LONGS(MTK_VCODEC_MAX_INSTANCES)];
+	int			num_instances;
+
+	struct workqueue_struct *encode_workqueue;
+
+	int			int_cond;
+	int			int_type;
+	struct mutex		dev_mutex;
+	wait_queue_head_t	queue;
+
+	int			enc_irq;
+	int			enc_lt_irq;
+
+	struct mutex		enc_mutex;
+	unsigned long		enter_suspend;
+
+	struct mtk_vcodec_pm	pm;
+	unsigned int		dec_capability;
+	unsigned int		enc_capability;
+};
+
+/**
+ * struct mtk_vcodec_ctrl - information about controls to be registered.
+ * @id:			Control ID.
+ * @type:			Type of the control.
+ * @name:		Human readable name of the control.
+ * @minimum:		Minimum value of the control.
+ * @maximum:		Maximum value of the control.
+ * @step:			Control value increase step.
+ * @menu_skip_mask:	Mask of invalid menu positions.
+ * @default_value:		Initial value of the control.
+ * @is_volatile:		Control is volatile.
+ *
+ * See also struct v4l2_ctrl_config.
+ */
+struct mtk_vcodec_ctrl {
+	u32			id;
+	enum v4l2_ctrl_type	type;
+	u8			name[32];
+	s32			minimum;
+	s32			maximum;
+	s32			step;
+	u32			menu_skip_mask;
+	s32			default_value;
+	u8			is_volatile;
+};
+
+static inline struct mtk_vcodec_ctx *fh_to_ctx(struct v4l2_fh *fh)
+{
+	return container_of(fh, struct mtk_vcodec_ctx, fh);
+}
+
+static inline struct mtk_vcodec_ctx *ctrl_to_ctx(struct v4l2_ctrl *ctrl)
+{
+	return container_of(ctrl->handler, struct mtk_vcodec_ctx, ctrl_hdl);
+}
+
+extern const struct v4l2_ioctl_ops mtk_vdec_ioctl_ops;
+extern const struct v4l2_m2m_ops mtk_vdec_m2m_ops;
+extern const struct v4l2_ioctl_ops mtk_venc_ioctl_ops;
+extern const struct v4l2_m2m_ops mtk_venc_m2m_ops;
+
+#endif /* _MTK_VCODEC_DRV_H_ */
diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c b/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c
new file mode 100644
index 0000000..8e1b6f0
--- /dev/null
+++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c
@@ -0,0 +1,1773 @@
+/*
+* Copyright (c) 2015 MediaTek Inc.
+* Author: PC Chen <pc.chen@mediatek.com>
+*         Tiffany Lin <tiffany.lin@mediatek.com>
+*
+* This program is free software; you can redistribute it and/or modify
+* it under the terms of the GNU General Public License version 2 as
+* published by the Free Software Foundation.
+*
+* This program is distributed in the hope that it will be useful,
+* but WITHOUT ANY WARRANTY; without even the implied warranty of
+* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+* GNU General Public License for more details.
+*/
+
+#include <media/videobuf2-dma-contig.h>
+#include <media/videobuf2-core.h>
+#include <media/v4l2-event.h>
+#include <media/v4l2-mem2mem.h>
+
+#include "mtk_vcodec_drv.h"
+#include "mtk_vcodec_enc.h"
+#include "mtk_vcodec_intr.h"
+#include "mtk_vcodec_util.h"
+#include "venc_drv_if.h"
+
+static void mtk_venc_worker(struct work_struct *work);
+
+static struct mtk_video_fmt mtk_video_formats[] = {
+	{
+		.name		= "4:2:0 3 Planes Y/Cb/Cr",
+		.fourcc		= V4L2_PIX_FMT_YUV420,
+		.type		= MTK_FMT_FRAME,
+		.num_planes	= 3,
+	},
+	{
+		.name		= "4:2:0 3 Planes Y/Cr/Cb",
+		.fourcc		= V4L2_PIX_FMT_YVU420,
+		.type		= MTK_FMT_FRAME,
+		.num_planes	= 3,
+	},
+	{
+		.name		= "4:2:0 2 Planes Y/CbCr",
+		.fourcc		= V4L2_PIX_FMT_NV12,
+		.type		= MTK_FMT_FRAME,
+		.num_planes	= 2,
+	},
+	{
+		.name		= "4:2:0 2 Planes Y/CrCb",
+		.fourcc		= V4L2_PIX_FMT_NV21,
+		.type		= MTK_FMT_FRAME,
+		.num_planes	= 2,
+	},
+	{
+		.name		= "4:2:0 3 none contiguous Planes Y/Cb/Cr",
+		.fourcc		= V4L2_PIX_FMT_YUV420M,
+		.type		= MTK_FMT_FRAME,
+		.num_planes	= 3,
+	},
+	{
+		.name		= "4:2:0 3 none contiguous Planes Y/Cr/Cb",
+		.fourcc		= V4L2_PIX_FMT_YVU420M,
+		.type		= MTK_FMT_FRAME,
+		.num_planes	= 3,
+	},
+	{
+		.name		= "4:2:0 2 none contiguous Planes Y/CbCr",
+		.fourcc 	= V4L2_PIX_FMT_NV12M,
+		.type		= MTK_FMT_FRAME,
+		.num_planes	= 2,
+	},
+	{
+		.name		= "4:2:0 2 none contiguous Planes Y/CrCb",
+		.fourcc		= V4L2_PIX_FMT_NV21M,
+		.type		= MTK_FMT_FRAME,
+		.num_planes	= 2,
+	},
+	{
+		.name		= "H264 Encoded Stream",
+		.fourcc		= V4L2_PIX_FMT_H264,
+		.type		= MTK_FMT_ENC,
+		.num_planes	= 1,
+	},
+	{
+		.name		= "VP8 Encoded Stream",
+		.fourcc		= V4L2_PIX_FMT_VP8,
+		.type		= MTK_FMT_ENC,
+		.num_planes	= 1,
+	},
+};
+
+#define NUM_FORMATS ARRAY_SIZE(mtk_video_formats)
+
+static struct mtk_vcodec_ctrl controls[] = {
+	{
+		.id = V4L2_CID_MPEG_VIDEO_BITRATE,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.minimum = 1,
+		.maximum = (1 << 30) - 1,
+		.step = 1,
+		.default_value = 4000000,
+	},
+	{
+		.id = V4L2_CID_MPEG_VIDEO_B_FRAMES,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.minimum = 0,
+		.maximum = 2,
+		.step = 1,
+		.default_value = 0,
+	},
+	{
+		.id = V4L2_CID_MPEG_VIDEO_FRAME_RC_ENABLE,
+		.type = V4L2_CTRL_TYPE_BOOLEAN,
+		.minimum = 0,
+		.maximum = 1,
+		.step = 1,
+		.default_value = 1,
+	},
+	{
+		.id = V4L2_CID_MPEG_VIDEO_H264_MAX_QP,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.minimum = 0,
+		.maximum = 51,
+		.step = 1,
+		.default_value = 51,
+	},
+	{
+		.id = V4L2_CID_MPEG_VIDEO_HEADER_MODE,
+		.type = V4L2_CTRL_TYPE_MENU,
+		.minimum = V4L2_MPEG_VIDEO_HEADER_MODE_SEPARATE,
+		.maximum = V4L2_MPEG_VIDEO_HEADER_MODE_JOINED_WITH_1ST_FRAME,
+		.default_value = V4L2_MPEG_VIDEO_HEADER_MODE_SEPARATE,
+		.menu_skip_mask = 0,
+	},
+	{
+		.id = V4L2_CID_MPEG_VIDEO_MB_RC_ENABLE,
+		.type = V4L2_CTRL_TYPE_BOOLEAN,
+		.minimum = 0,
+		.maximum = 1,
+		.step = 1,
+		.default_value = 0,
+	},
+	{
+		.id = V4L2_CID_MPEG_VIDEO_H264_PROFILE,
+		.type = V4L2_CTRL_TYPE_MENU,
+		.minimum = V4L2_MPEG_VIDEO_H264_PROFILE_BASELINE,
+		.maximum = V4L2_MPEG_VIDEO_H264_PROFILE_HIGH,
+		.default_value = V4L2_MPEG_VIDEO_H264_PROFILE_MAIN,
+	},
+	{
+		.id = V4L2_CID_MPEG_VIDEO_H264_LEVEL,
+		.type = V4L2_CTRL_TYPE_MENU,
+		.minimum = V4L2_MPEG_VIDEO_H264_LEVEL_1_0,
+		.maximum = V4L2_MPEG_VIDEO_H264_LEVEL_4_2,
+		.default_value = V4L2_MPEG_VIDEO_H264_LEVEL_4_0,
+	},
+	{
+		.id = V4L2_CID_MPEG_VIDEO_H264_I_PERIOD,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.minimum = 0,
+		.maximum = (1 << 16) - 1,
+		.step = 1,
+		.default_value = 30,
+	},
+	{
+		.id = V4L2_CID_MPEG_VIDEO_GOP_SIZE,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.minimum = 0,
+		.maximum = (1 << 16) - 1,
+		.step = 1,
+		.default_value = 30,
+	},
+	{
+		.id = V4L2_CID_MPEG_MFC51_VIDEO_FORCE_FRAME_TYPE,
+		.type = V4L2_CTRL_TYPE_MENU,
+		.minimum = V4L2_MPEG_MFC51_VIDEO_FORCE_FRAME_TYPE_DISABLED,
+		.maximum = V4L2_MPEG_MFC51_VIDEO_FORCE_FRAME_TYPE_NOT_CODED,
+		.default_value =
+			V4L2_MPEG_MFC51_VIDEO_FORCE_FRAME_TYPE_DISABLED,
+		.menu_skip_mask = 0,
+	},
+	{
+		.id = V4L2_CID_MPEG_MFC51_VIDEO_FRAME_SKIP_MODE,
+		.type = V4L2_CTRL_TYPE_MENU,
+		.minimum = V4L2_MPEG_MFC51_VIDEO_FRAME_SKIP_MODE_DISABLED,
+		.maximum = V4L2_MPEG_MFC51_VIDEO_FRAME_SKIP_MODE_BUF_LIMIT,
+		.default_value = V4L2_MPEG_MFC51_VIDEO_FRAME_SKIP_MODE_DISABLED,
+		.menu_skip_mask = 0,
+	},
+};
+
+#define NUM_CTRLS ARRAY_SIZE(controls)
+
+static const struct mtk_codec_framesizes mtk_venc_framesizes[] = {
+	{
+		.fourcc	= V4L2_PIX_FMT_H264,
+		.stepwise = {  160, 1920, 16, 128, 1088, 16 },
+	},
+	{
+		.fourcc = V4L2_PIX_FMT_VP8,
+		.stepwise = {  160, 1920, 16, 128, 1088, 16 },
+	},
+};
+
+#define NUM_SUPPORTED_FRAMESIZE ARRAY_SIZE(mtk_venc_framesizes)
+
+static int vidioc_venc_s_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct mtk_vcodec_ctx *ctx = ctrl_to_ctx(ctrl);
+	struct mtk_vcodec_dev *dev = ctx->dev;
+	struct mtk_enc_params *p = &ctx->enc_params;
+	int ret = 0;
+
+	mtk_v4l2_debug(1, "[%d] id = %d/%d, val = %d", ctrl->id,
+			ctx->idx, ctrl->id - V4L2_CID_MPEG_BASE, ctrl->val);
+
+	switch (ctrl->id) {
+	case V4L2_CID_MPEG_VIDEO_BITRATE:
+
+		mtk_v4l2_debug(1, "V4L2_CID_MPEG_VIDEO_BITRATE val = %d",
+			ctrl->val);
+
+		mutex_lock(&ctx->encode_param_mutex);
+		p->bitrate = ctrl->val;
+		ctx->param_change |= MTK_ENCODE_PARAM_BITRATE;
+		mutex_unlock(&ctx->encode_param_mutex);
+		break;
+
+	case V4L2_CID_MPEG_VIDEO_B_FRAMES:
+		mtk_v4l2_debug(1, "V4L2_CID_MPEG_VIDEO_B_FRAMES val = %d",
+			ctrl->val);
+		p->num_b_frame = ctrl->val;
+		break;
+
+	case V4L2_CID_MPEG_VIDEO_FRAME_RC_ENABLE:
+		mtk_v4l2_debug(1, "V4L2_CID_MPEG_VIDEO_FRAME_RC_ENABLE val = %d",
+			ctrl->val);
+		p->rc_frame = ctrl->val;
+		break;
+
+	case V4L2_CID_MPEG_VIDEO_H264_MAX_QP:
+		mtk_v4l2_debug(1, "V4L2_CID_MPEG_VIDEO_H264_MAX_QP val = %d",
+			ctrl->val);
+		p->h264_max_qp = ctrl->val;
+		break;
+
+	case V4L2_CID_MPEG_VIDEO_HEADER_MODE:
+		mtk_v4l2_debug(1, "V4L2_CID_MPEG_VIDEO_HEADER_MODE val = %d",
+			ctrl->val);
+		p->seq_hdr_mode = ctrl->val;
+		break;
+
+	case V4L2_CID_MPEG_VIDEO_MB_RC_ENABLE:
+		mtk_v4l2_debug(1, "V4L2_CID_MPEG_VIDEO_MB_RC_ENABLE val = %d",
+			ctrl->val);
+		p->rc_mb = ctrl->val;
+		break;
+
+	case V4L2_CID_MPEG_VIDEO_H264_PROFILE:
+		mtk_v4l2_debug(1, "V4L2_CID_MPEG_VIDEO_H264_PROFILE val = %d",
+			ctrl->val);
+		p->h264_profile = ctrl->val;
+		break;
+
+	case V4L2_CID_MPEG_VIDEO_H264_LEVEL:
+		mtk_v4l2_debug(1, "V4L2_CID_MPEG_VIDEO_H264_LEVEL val = %d",
+			ctrl->val);
+		p->h264_level = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_H264_I_PERIOD:
+		mtk_v4l2_debug(1, "V4L2_CID_MPEG_VIDEO_H264_I_PERIOD val = %d",
+			ctrl->val);
+	case V4L2_CID_MPEG_VIDEO_GOP_SIZE:
+		mtk_v4l2_debug(1, "V4L2_CID_MPEG_VIDEO_GOP_SIZE val = %d",
+			ctrl->val);
+
+		mutex_lock(&ctx->encode_param_mutex);
+		p->gop_size = ctrl->val;
+		ctx->param_change |= MTK_ENCODE_PARAM_INTRA_PERIOD;
+		mutex_unlock(&ctx->encode_param_mutex);
+		break;
+	case V4L2_CID_MPEG_MFC51_VIDEO_FORCE_FRAME_TYPE:
+		mtk_v4l2_debug(1, "V4L2_CID_MPEG_MFC51_VIDEO_FORCE_FRAME_TYPE val = %d",
+			ctrl->val);
+		if (ctrl->val ==
+			V4L2_MPEG_MFC51_VIDEO_FORCE_FRAME_TYPE_NOT_CODED) {
+			v4l2_err(&dev->v4l2_dev, "unsupported frame type %x\n",
+				 ctrl->val);
+			ret = -EINVAL;
+			break;
+		}
+		mutex_lock(&ctx->encode_param_mutex);
+		if (ctrl->val == V4L2_MPEG_MFC51_VIDEO_FORCE_FRAME_TYPE_I_FRAME)
+			p->force_intra = 1;
+		else if (ctrl->val ==
+			V4L2_MPEG_MFC51_VIDEO_FORCE_FRAME_TYPE_DISABLED)
+			p->force_intra = 0;
+		/* always allow user to insert I frame */
+		ctrl->val = V4L2_MPEG_MFC51_VIDEO_FORCE_FRAME_TYPE_DISABLED;
+		ctx->param_change |= MTK_ENCODE_PARAM_FRAME_TYPE;
+		mutex_unlock(&ctx->encode_param_mutex);
+		break;
+
+	case V4L2_CID_MPEG_MFC51_VIDEO_FRAME_SKIP_MODE:
+		mtk_v4l2_debug(1, "V4L2_CID_MPEG_MFC51_VIDEO_FRAME_SKIP_MODE val = %d",
+			ctrl->val);
+
+		mutex_lock(&ctx->encode_param_mutex);
+		if (ctrl->val == V4L2_MPEG_MFC51_VIDEO_FRAME_SKIP_MODE_DISABLED)
+			p->skip_frame = 0;
+		else
+			p->skip_frame = 1;
+		/* always allow user to skip frame */
+		ctrl->val = V4L2_MPEG_MFC51_VIDEO_FRAME_SKIP_MODE_DISABLED;
+		ctx->param_change |= MTK_ENCODE_PARAM_SKIP_FRAME;
+		mutex_unlock(&ctx->encode_param_mutex);
+		break;
+
+	default:
+		mtk_v4l2_err("Invalid control, id=%d, val=%d\n",
+				ctrl->id, ctrl->val);
+		ret = -EINVAL;
+		break;
+	}
+
+	return ret;
+}
+
+static const struct v4l2_ctrl_ops mtk_vcodec_enc_ctrl_ops = {
+	.s_ctrl = vidioc_venc_s_ctrl,
+};
+
+static int vidioc_enum_fmt(struct file *file, struct v4l2_fmtdesc *f,
+			   bool out)
+{
+	struct mtk_video_fmt *fmt;
+	int i, j = 0;
+
+	for (i = 0; i < NUM_FORMATS; ++i) {
+		if (out && mtk_video_formats[i].type != MTK_FMT_FRAME)
+			continue;
+		else if (!out && mtk_video_formats[i].type != MTK_FMT_ENC)
+			continue;
+
+		if (j == f->index) {
+			fmt = &mtk_video_formats[i];
+			strlcpy(f->description, fmt->name,
+				sizeof(f->description));
+			f->pixelformat = fmt->fourcc;
+			mtk_v4l2_debug(1, "f->index=%d i=%d fmt->name=%s",
+					 f->index, i, fmt->name);
+			return 0;
+		}
+		++j;
+	}
+
+	return -EINVAL;
+}
+
+static int vidioc_enum_framesizes(struct file *file, void *fh,
+				  struct v4l2_frmsizeenum *fsize)
+{
+	int i = 0;
+
+	for (i = 0; i < NUM_SUPPORTED_FRAMESIZE; ++i) {
+		if (fsize->pixel_format != mtk_venc_framesizes[i].fourcc)
+			continue;
+
+		if (!fsize->index) {
+			fsize->type = V4L2_FRMSIZE_TYPE_STEPWISE;
+			fsize->stepwise = mtk_venc_framesizes[i].stepwise;
+			mtk_v4l2_debug(1, "%d %d %d %d %d %d",
+					 fsize->stepwise.min_width,
+					 fsize->stepwise.max_width,
+					 fsize->stepwise.step_width,
+					 fsize->stepwise.min_height,
+					 fsize->stepwise.max_height,
+					 fsize->stepwise.step_height);
+			return 0;
+		}
+	}
+
+	return -EINVAL;
+}
+
+static int vidioc_enum_fmt_vid_cap_mplane(struct file *file, void *pirv,
+					  struct v4l2_fmtdesc *f)
+{
+	return vidioc_enum_fmt(file, f, false);
+}
+
+static int vidioc_enum_fmt_vid_out_mplane(struct file *file, void *prov,
+					  struct v4l2_fmtdesc *f)
+{
+	return vidioc_enum_fmt(file, f, true);
+}
+
+static int vidioc_venc_streamon(struct file *file, void *priv,
+				enum v4l2_buf_type type)
+{
+	struct mtk_vcodec_ctx *ctx = fh_to_ctx(priv);
+
+	return v4l2_m2m_streamon(file, ctx->m2m_ctx, type);
+}
+
+static int vidioc_venc_streamoff(struct file *file, void *priv,
+				 enum v4l2_buf_type type)
+{
+	struct mtk_vcodec_ctx *ctx = fh_to_ctx(priv);
+
+	return v4l2_m2m_streamoff(file, ctx->m2m_ctx, type);
+}
+
+static int vidioc_venc_reqbufs(struct file *file, void *priv,
+			       struct v4l2_requestbuffers *reqbufs)
+{
+	struct mtk_vcodec_ctx *ctx = fh_to_ctx(priv);
+
+	mtk_v4l2_debug(1, "[%d]-> type=%d count=%d",
+			 ctx->idx, reqbufs->type, reqbufs->count);
+
+	return v4l2_m2m_reqbufs(file, ctx->m2m_ctx, reqbufs);
+}
+
+static int vidioc_venc_querybuf(struct file *file, void *priv,
+				struct v4l2_buffer *buf)
+{
+	struct mtk_vcodec_ctx *ctx = fh_to_ctx(priv);
+
+	return v4l2_m2m_querybuf(file, ctx->m2m_ctx, buf);
+}
+
+static int vidioc_venc_qbuf(struct file *file, void *priv,
+			    struct v4l2_buffer *buf)
+{
+	struct mtk_vcodec_ctx *ctx = fh_to_ctx(priv);
+	int ret;
+#if MTK_V4L2_BENCHMARK
+	struct timeval begin, end;
+
+	do_gettimeofday(&begin);
+#endif
+
+	ret = v4l2_m2m_qbuf(file, ctx->m2m_ctx, buf);
+
+#if MTK_V4L2_BENCHMARK
+	do_gettimeofday(&end);
+
+	if (buf->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
+		ctx->total_qbuf_cap_cnt++;
+		ctx->total_qbuf_cap_time +=
+			((end.tv_sec - begin.tv_sec) * 1000000 +
+				end.tv_usec - begin.tv_usec);
+	}
+
+	if (buf->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
+		ctx->total_qbuf_out_cnt++;
+		ctx->total_qbuf_out_time +=
+			((end.tv_sec - begin.tv_sec) * 1000000 +
+				end.tv_usec - begin.tv_usec);
+	}
+
+#endif
+
+	return ret;
+}
+
+static int vidioc_venc_dqbuf(struct file *file, void *priv,
+			     struct v4l2_buffer *buf)
+{
+	struct mtk_vcodec_ctx *ctx = fh_to_ctx(priv);
+	int ret;
+#if MTK_V4L2_BENCHMARK
+	struct timeval begin, end;
+
+	do_gettimeofday(&begin);
+#endif
+
+	ret = v4l2_m2m_dqbuf(file, ctx->m2m_ctx, buf);
+#if MTK_V4L2_BENCHMARK
+
+	do_gettimeofday(&end);
+	if (buf->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
+		ctx->total_dqbuf_cap_cnt++;
+		ctx->total_dqbuf_cap_time +=
+			((end.tv_sec - begin.tv_sec) * 1000000 +
+				end.tv_usec - begin.tv_usec);
+	}
+
+	if (buf->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
+		ctx->total_dqbuf_out_cnt++;
+		ctx->total_dqbuf_out_time +=
+			((end.tv_sec - begin.tv_sec) * 1000000 +
+				end.tv_usec - begin.tv_usec);
+	}
+
+#endif
+	return ret;
+}
+static int vidioc_venc_expbuf(struct file *file, void *priv,
+			      struct v4l2_exportbuffer *eb)
+{
+	struct mtk_vcodec_ctx *ctx = fh_to_ctx(priv);
+	int ret;
+#if MTK_V4L2_BENCHMARK
+	struct timeval begin, end;
+
+	do_gettimeofday(&begin);
+#endif
+
+	ret = v4l2_m2m_expbuf(file, ctx->m2m_ctx, eb);
+
+#if MTK_V4L2_BENCHMARK
+	do_gettimeofday(&end);
+	ctx->total_expbuf_time +=
+		((end.tv_sec - begin.tv_sec) * 1000000 +
+			end.tv_usec - begin.tv_usec);
+#endif
+	return ret;
+}
+
+static int vidioc_venc_querycap(struct file *file, void *priv,
+				struct v4l2_capability *cap)
+{
+	strncpy(cap->driver, MTK_VCODEC_ENC_NAME, sizeof(cap->driver) - 1);
+	cap->bus_info[0] = 0;
+	cap->version = KERNEL_VERSION(1, 0, 0);
+	/*
+	 * This is only a mem-to-mem video device. The capture and output
+	 * device capability flags are left only for backward compatibility
+	 * and are scheduled for removal.
+	 */
+	cap->capabilities = V4L2_CAP_VIDEO_M2M_MPLANE | V4L2_CAP_STREAMING |
+			    V4L2_CAP_VIDEO_CAPTURE_MPLANE |
+			    V4L2_CAP_VIDEO_OUTPUT_MPLANE;
+
+	return 0;
+}
+
+static int vidioc_venc_subscribe_event(struct v4l2_fh *fh,
+		       const struct v4l2_event_subscription *sub)
+{
+	return v4l2_event_subscribe(fh, sub, 0, NULL);
+}
+
+static int vidioc_venc_s_parm(struct file *file, void *priv,
+			      struct v4l2_streamparm *a)
+{
+	struct mtk_vcodec_ctx *ctx = fh_to_ctx(priv);
+
+	if (a->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
+		mutex_lock(&ctx->encode_param_mutex);
+		ctx->enc_params.framerate_num =
+			a->parm.output.timeperframe.denominator;
+		ctx->enc_params.framerate_denom =
+			a->parm.output.timeperframe.numerator;
+		ctx->param_change |= MTK_ENCODE_PARAM_FRAMERATE;
+		mutex_unlock(&ctx->encode_param_mutex);
+		mtk_v4l2_debug(1, "framerate = %d/%d",
+				 ctx->enc_params.framerate_num,
+				 ctx->enc_params.framerate_denom);
+	} else {
+		mtk_v4l2_err("Non support param type %d",
+			 a->type);
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static struct mtk_q_data *mtk_venc_get_q_data(struct mtk_vcodec_ctx *ctx,
+					      enum v4l2_buf_type type)
+{
+	switch (type) {
+	case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
+	case V4L2_BUF_TYPE_VIDEO_OUTPUT:
+		return &ctx->q_data[MTK_Q_DATA_SRC];
+	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
+	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
+		return &ctx->q_data[MTK_Q_DATA_DST];
+	default:
+		BUG();
+	}
+	return NULL;
+}
+
+static struct mtk_video_fmt *mtk_venc_find_format(struct v4l2_format *f)
+{
+	struct mtk_video_fmt *fmt;
+	unsigned int k;
+
+	for (k = 0; k < NUM_FORMATS; k++) {
+		fmt = &mtk_video_formats[k];
+		if (fmt->fourcc == f->fmt.pix.pixelformat)
+			return fmt;
+	}
+
+	return NULL;
+}
+
+static int vidioc_try_fmt(struct file *file, void *priv, struct v4l2_format *f)
+{
+	struct mtk_video_fmt *fmt;
+	char str[10];
+	struct v4l2_pix_format_mplane *pix_fmt_mp = &f->fmt.pix_mp;
+
+	mtk_vcodec_fmt2str(f->fmt.pix_mp.pixelformat, str);
+
+	if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
+		fmt = mtk_venc_find_format(f);
+		if (!fmt) {
+			mtk_v4l2_err("failed to try output format %s\n", str);
+			return -EINVAL;
+		}
+		if (pix_fmt_mp->plane_fmt[0].sizeimage == 0) {
+			mtk_v4l2_err("must be set encoding output size %s\n",
+				       str);
+			return -EINVAL;
+		}
+
+		pix_fmt_mp->plane_fmt[0].bytesperline =
+			pix_fmt_mp->plane_fmt[0].sizeimage;
+	} else if (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
+		fmt = mtk_venc_find_format(f);
+		if (!fmt) {
+			mtk_v4l2_err("failed to try output format %s\n", str);
+			return -EINVAL;
+		}
+
+		if (fmt->num_planes != pix_fmt_mp->num_planes) {
+			mtk_v4l2_err("failed to try output format %d %d %s\n",
+				       fmt->num_planes, pix_fmt_mp->num_planes,
+				       str);
+			return -EINVAL;
+		}
+
+		v4l_bound_align_image(&pix_fmt_mp->width, 8, 1920, 1,
+				      &pix_fmt_mp->height, 4, 1080, 1, 0);
+	} else {
+		pr_err("invalid buf type %d\n", f->type);
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static void mtk_vcodec_enc_calc_src_size(struct mtk_vcodec_ctx *ctx)
+{
+	struct mtk_video_fmt *fmt = ctx->q_data[MTK_Q_DATA_SRC].fmt;
+	struct mtk_q_data *q_data = &ctx->q_data[MTK_Q_DATA_SRC];
+
+	ctx->q_data[MTK_Q_DATA_SRC].sizeimage[0] =
+		((q_data->width + 15) / 16) *
+		((q_data->height + 15) / 16) * 256;
+	ctx->q_data[MTK_Q_DATA_SRC].bytesperline[0] = ALIGN(q_data->width, 16);
+
+	if (fmt->num_planes == 2) {
+		ctx->q_data[MTK_Q_DATA_SRC].sizeimage[1] =
+			((q_data->width + 15) / 16) *
+			((q_data->height + 15) / 16) * 128;
+		ctx->q_data[MTK_Q_DATA_SRC].sizeimage[2] = 0;
+		ctx->q_data[MTK_Q_DATA_SRC].bytesperline[1] =
+			ALIGN(q_data->width, 16);
+		ctx->q_data[MTK_Q_DATA_SRC].bytesperline[2] = 0;
+	} else {
+		ctx->q_data[MTK_Q_DATA_SRC].sizeimage[1] =
+			((q_data->width + 15) / 16) *
+			((q_data->height + 15) / 16) * 64;
+		ctx->q_data[MTK_Q_DATA_SRC].sizeimage[2] =
+			((q_data->width + 15) / 16) *
+			((q_data->height + 15) / 16) * 64;
+		ctx->q_data[MTK_Q_DATA_SRC].bytesperline[1] =
+			ALIGN(q_data->width, 16) / 2;
+		ctx->q_data[MTK_Q_DATA_SRC].bytesperline[2] =
+			ALIGN(q_data->width, 16) / 2;
+	}
+}
+
+static int vidioc_venc_s_fmt(struct file *file, void *priv,
+			     struct v4l2_format *f)
+{
+	struct mtk_vcodec_dev *dev = video_drvdata(file);
+	struct mtk_vcodec_ctx *ctx = fh_to_ctx(priv);
+	struct v4l2_pix_format_mplane *pix_fmt_mp = &f->fmt.pix_mp;
+	struct vb2_queue *vq;
+	struct mtk_q_data *q_data;
+	int i, ret;
+
+	ret = vidioc_try_fmt(file, priv, f);
+	if (ret)
+		return ret;
+
+	vq = v4l2_m2m_get_vq(ctx->m2m_ctx, f->type);
+	if (!vq) {
+		v4l2_err(&dev->v4l2_dev, "fail to get vq\n");
+		return -EINVAL;
+	}
+
+	if (vb2_is_busy(vq)) {
+		v4l2_err(&dev->v4l2_dev, "queue busy\n");
+		return -EBUSY;
+	}
+
+	q_data = mtk_venc_get_q_data(ctx, f->type);
+	if (!q_data) {
+		v4l2_err(&dev->v4l2_dev, "fail to get q data\n");
+		return -EINVAL;
+	}
+
+	q_data->fmt		= mtk_venc_find_format(f);
+	if (!q_data->fmt) {
+		v4l2_err(&dev->v4l2_dev, "q data null format\n");
+		return -EINVAL;
+	}
+
+	q_data->width		= f->fmt.pix_mp.width;
+	q_data->height		= f->fmt.pix_mp.height;
+	q_data->colorspace	= f->fmt.pix_mp.colorspace;
+	q_data->field		= f->fmt.pix_mp.field;
+
+	for (i = 0; i < f->fmt.pix_mp.num_planes; i++) {
+		struct v4l2_plane_pix_format	*plane_fmt;
+
+		plane_fmt = &f->fmt.pix_mp.plane_fmt[i];
+		q_data->bytesperline[i]	= plane_fmt->bytesperline;
+		q_data->sizeimage[i]	= plane_fmt->sizeimage;
+	}
+
+	if (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
+		q_data->width		= f->fmt.pix_mp.width;
+		q_data->height		= f->fmt.pix_mp.height;
+
+		mtk_vcodec_enc_calc_src_size(ctx);
+		pix_fmt_mp->plane_fmt[0].sizeimage = q_data->sizeimage[0];
+		pix_fmt_mp->plane_fmt[0].bytesperline =
+			ctx->q_data[MTK_Q_DATA_SRC].bytesperline[0];
+		pix_fmt_mp->plane_fmt[1].sizeimage = q_data->sizeimage[1];
+		pix_fmt_mp->plane_fmt[1].bytesperline =
+			ctx->q_data[MTK_Q_DATA_SRC].bytesperline[1];
+		pix_fmt_mp->plane_fmt[2].sizeimage = q_data->sizeimage[2];
+		pix_fmt_mp->plane_fmt[2].bytesperline =
+			ctx->q_data[MTK_Q_DATA_SRC].bytesperline[2];
+	}
+
+	mtk_v4l2_debug(1,
+			 "[%d]: t=%d wxh=%dx%d fmt=%c%c%c%c sz=0x%x-%x-%x",
+			 ctx->idx,
+			 f->type,
+			 q_data->width, q_data->height,
+			 (f->fmt.pix_mp.pixelformat & 0xff),
+			 (f->fmt.pix_mp.pixelformat >>  8) & 0xff,
+			 (f->fmt.pix_mp.pixelformat >> 16) & 0xff,
+			 (f->fmt.pix_mp.pixelformat >> 24) & 0xff,
+			 q_data->sizeimage[0],
+			 q_data->sizeimage[1],
+			 q_data->sizeimage[2]);
+
+	return 0;
+}
+
+static int vidioc_venc_g_fmt(struct file *file, void *priv,
+			     struct v4l2_format *f)
+{
+	struct v4l2_pix_format_mplane *pix = &f->fmt.pix_mp;
+	struct mtk_vcodec_ctx *ctx = fh_to_ctx(priv);
+	struct vb2_queue *vq;
+	struct mtk_q_data *q_data;
+	int i;
+
+	vq = v4l2_m2m_get_vq(ctx->m2m_ctx, f->type);
+	if (!vq)
+		return -EINVAL;
+
+	q_data = mtk_venc_get_q_data(ctx, f->type);
+
+	pix->width = q_data->width;
+	pix->height = q_data->height;
+	pix->pixelformat = q_data->fmt->fourcc;
+	pix->field = q_data->field;
+	pix->colorspace = q_data->colorspace;
+	pix->num_planes = q_data->fmt->num_planes;
+
+	for (i = 0; i < pix->num_planes; i++) {
+		pix->plane_fmt[i].bytesperline = q_data->bytesperline[i];
+		pix->plane_fmt[i].sizeimage = q_data->sizeimage[i];
+	}
+
+	mtk_v4l2_debug(1,
+			 "[%d]<- type=%d wxh=%dx%d fmt=%c%c%c%c sz[0]=0x%x sz[1]=0x%x",
+			 ctx->idx, f->type,
+			 pix->width, pix->height,
+			 (pix->pixelformat & 0xff),
+			 (pix->pixelformat >>  8) & 0xff,
+			 (pix->pixelformat >> 16) & 0xff,
+			 (pix->pixelformat >> 24) & 0xff,
+			 pix->plane_fmt[0].sizeimage,
+			 pix->plane_fmt[1].sizeimage);
+
+	return 0;
+}
+
+static int vidioc_venc_g_ctrl(struct file *file, void *fh,
+			      struct v4l2_control *ctrl)
+{
+	int ret = 0;
+
+	switch (ctrl->id) {
+	case V4L2_CID_MIN_BUFFERS_FOR_CAPTURE:
+	case V4L2_CID_MIN_BUFFERS_FOR_OUTPUT:
+		ctrl->value = 1;
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
+	return ret;
+}
+
+static int vidioc_venc_s_crop(struct file *file, void *fh,
+			      const struct v4l2_crop *a)
+{
+	struct mtk_vcodec_ctx *ctx = fh_to_ctx(fh);
+	struct mtk_q_data *q_data;
+
+	if (a->c.left || a->c.top)
+		return -EINVAL;
+
+	q_data = mtk_venc_get_q_data(ctx, a->type);
+	if (!q_data)
+		return -EINVAL;
+
+	if (a->c.width != q_data->width ||
+	    a->c.height != q_data->height) {
+		mtk_v4l2_err("crop right %d bottom %d w %d h %d\n",
+			 a->c.width, a->c.height, q_data->width,
+			 q_data->height);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int vidioc_venc_g_crop(struct file *file, void *fh,
+					struct v4l2_crop *a)
+{
+	struct mtk_vcodec_ctx *ctx = fh_to_ctx(fh);
+	struct mtk_q_data *q_data;
+
+	if (a->c.left || a->c.top)
+		return -EINVAL;
+
+	q_data = mtk_venc_get_q_data(ctx, a->type);
+	if (!q_data)
+		return -EINVAL;
+
+	a->c.width = q_data->width;
+	a->c.height = q_data->height;
+
+	return 0;
+}
+
+
+const struct v4l2_ioctl_ops mtk_venc_ioctl_ops = {
+	.vidioc_streamon		= vidioc_venc_streamon,
+	.vidioc_streamoff		= vidioc_venc_streamoff,
+
+	.vidioc_reqbufs			= vidioc_venc_reqbufs,
+	.vidioc_querybuf		= vidioc_venc_querybuf,
+	.vidioc_qbuf			= vidioc_venc_qbuf,
+	.vidioc_expbuf			= vidioc_venc_expbuf,
+	.vidioc_dqbuf			= vidioc_venc_dqbuf,
+
+	.vidioc_querycap		= vidioc_venc_querycap,
+	.vidioc_enum_fmt_vid_cap_mplane = vidioc_enum_fmt_vid_cap_mplane,
+	.vidioc_enum_fmt_vid_out_mplane = vidioc_enum_fmt_vid_out_mplane,
+	.vidioc_enum_framesizes = vidioc_enum_framesizes,
+
+	.vidioc_subscribe_event		= vidioc_venc_subscribe_event,
+
+	.vidioc_s_parm			= vidioc_venc_s_parm,
+
+	.vidioc_s_fmt_vid_cap_mplane	= vidioc_venc_s_fmt,
+	.vidioc_s_fmt_vid_out_mplane	= vidioc_venc_s_fmt,
+
+	.vidioc_g_fmt_vid_cap_mplane	= vidioc_venc_g_fmt,
+	.vidioc_g_fmt_vid_out_mplane	= vidioc_venc_g_fmt,
+
+	.vidioc_g_ctrl			= vidioc_venc_g_ctrl,
+
+	.vidioc_s_crop			= vidioc_venc_s_crop,
+	.vidioc_g_crop			= vidioc_venc_g_crop,
+
+};
+
+static int vb2ops_venc_queue_setup(struct vb2_queue *vq,
+				   const void *parg,
+				   unsigned int *nbuffers,
+				   unsigned int *nplanes,
+				   unsigned int sizes[], void *alloc_ctxs[])
+{
+	struct mtk_vcodec_ctx *ctx = vb2_get_drv_priv(vq);
+	struct mtk_q_data *q_data;
+
+	q_data = mtk_venc_get_q_data(ctx, vq->type);
+
+	if (*nbuffers < 1)
+		*nbuffers = 1;
+	if (*nbuffers > MTK_VIDEO_MAX_FRAME)
+		*nbuffers = MTK_VIDEO_MAX_FRAME;
+
+	*nplanes = q_data->fmt->num_planes;
+
+	if (vq->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
+		unsigned int i;
+
+		for (i = 0; i < *nplanes; i++) {
+			sizes[i] = q_data->sizeimage[i];
+			alloc_ctxs[i] = ctx->dev->alloc_ctx;
+		}
+	} else if (vq->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
+		sizes[0] = q_data->sizeimage[0];
+		alloc_ctxs[0] = ctx->dev->alloc_ctx;
+	} else {
+		BUG();
+	}
+
+	mtk_v4l2_debug(2,
+			"[%d]get %d buffer(s) of size 0x%x each",
+			ctx->idx, *nbuffers, sizes[0]);
+
+	return 0;
+}
+
+static int vb2ops_venc_buf_prepare(struct vb2_buffer *vb)
+{
+	struct mtk_vcodec_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
+	struct mtk_q_data *q_data;
+	int i;
+
+	q_data = mtk_venc_get_q_data(ctx, vb->vb2_queue->type);
+
+	for (i = 0; i < q_data->fmt->num_planes; i++) {
+		if (vb2_plane_size(vb, i) < q_data->sizeimage[i]) {
+			mtk_v4l2_debug(2,
+					"data will not fit into plane %d (%lu < %d)",
+					i, vb2_plane_size(vb, i),
+					q_data->sizeimage[i]);
+			return -EINVAL;
+		}
+	}
+
+	return 0;
+}
+
+static void vb2ops_venc_buf_queue(struct vb2_buffer *vb)
+{
+	struct mtk_vcodec_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
+	struct vb2_v4l2_buffer *v4l2_vb = to_vb2_v4l2_buffer(vb);
+	struct mtk_video_enc_buf *buf =
+			container_of(v4l2_vb, struct mtk_video_enc_buf, b);
+
+	mutex_lock(&ctx->encode_param_mutex);
+	if ((vb->vb2_queue->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) &&
+		(ctx->param_change != MTK_ENCODE_PARAM_NONE)) {
+		mtk_v4l2_debug(1,
+				"[%d] Before id=%d encode parameter change %x",
+				ctx->idx, vb->index,
+				ctx->param_change);
+		buf->param_change = ctx->param_change;
+		if (buf->param_change & MTK_ENCODE_PARAM_BITRATE) {
+			buf->enc_params.bitrate = ctx->enc_params.bitrate;
+			mtk_v4l2_debug(1, "change param br=%d",
+				 buf->enc_params.bitrate);
+		}
+		if (ctx->param_change & MTK_ENCODE_PARAM_FRAMERATE) {
+			buf->enc_params.framerate_num =
+				ctx->enc_params.framerate_num;
+			buf->enc_params.framerate_denom =
+				ctx->enc_params.framerate_denom;
+			mtk_v4l2_debug(1, "change param fr=%d",
+					buf->enc_params.framerate_num /
+					buf->enc_params.framerate_denom);
+		}
+		if (ctx->param_change & MTK_ENCODE_PARAM_INTRA_PERIOD) {
+			buf->enc_params.gop_size = ctx->enc_params.gop_size;
+			mtk_v4l2_debug(1, "change param intra period=%d",
+					 buf->enc_params.gop_size);
+		}
+		if (ctx->param_change & MTK_ENCODE_PARAM_FRAME_TYPE) {
+			buf->enc_params.force_intra =
+				ctx->enc_params.force_intra;
+			mtk_v4l2_debug(1, "change param force I=%d",
+					 buf->enc_params.force_intra);
+		}
+		if (ctx->param_change & MTK_ENCODE_PARAM_SKIP_FRAME) {
+			buf->enc_params.skip_frame =
+				ctx->enc_params.skip_frame;
+			mtk_v4l2_debug(1, "change param skip frame=%d",
+					 buf->enc_params.skip_frame);
+		}
+		ctx->param_change = MTK_ENCODE_PARAM_NONE;
+	}
+	mutex_unlock(&ctx->encode_param_mutex);
+	v4l2_m2m_buf_queue(ctx->m2m_ctx, to_vb2_v4l2_buffer(vb));
+}
+
+static void mtk_venc_set_param(struct mtk_vcodec_ctx *ctx, void *param)
+{
+	struct venc_enc_prm *p = (struct venc_enc_prm *)param;
+	struct mtk_q_data *q_data_src = &ctx->q_data[MTK_Q_DATA_SRC];
+	struct mtk_enc_params *enc_params = &ctx->enc_params;
+	unsigned int frame_rate;
+
+	mutex_lock(&ctx->encode_param_mutex);
+
+	frame_rate = enc_params->framerate_num / enc_params->framerate_denom;
+
+	switch (q_data_src->fmt->fourcc) {
+	case V4L2_PIX_FMT_YUV420:
+	case V4L2_PIX_FMT_YUV420M:
+		p->input_fourcc = VENC_YUV_FORMAT_420;
+		break;
+	case V4L2_PIX_FMT_YVU420:
+	case V4L2_PIX_FMT_YVU420M:
+		p->input_fourcc = VENC_YUV_FORMAT_YV12;
+		break;
+	case V4L2_PIX_FMT_NV12:
+	case V4L2_PIX_FMT_NV12M:
+		p->input_fourcc = VENC_YUV_FORMAT_NV12;
+		break;
+	case V4L2_PIX_FMT_NV21:
+	case V4L2_PIX_FMT_NV21M:
+		p->input_fourcc = VENC_YUV_FORMAT_NV21;
+		break;
+	}
+	p->h264_profile = enc_params->h264_profile;
+	p->h264_level = enc_params->h264_level;
+	p->width = q_data_src->width;
+	p->height = q_data_src->height;
+	p->buf_width = q_data_src->bytesperline[0];
+	p->buf_height = ((q_data_src->height + 0xf) & (~0xf));
+	p->frm_rate = frame_rate;
+	p->intra_period = enc_params->gop_size;
+	p->bitrate = enc_params->bitrate;
+
+	ctx->param_change = MTK_ENCODE_PARAM_NONE;
+	mutex_unlock(&ctx->encode_param_mutex);
+
+	mtk_v4l2_debug(1,
+			"fmt 0x%x P/L %d/%d w/h %d/%d buf %d/%d fps/bps %d/%d gop %d",
+			p->input_fourcc, p->h264_profile, p->h264_level, p->width,
+			p->height, p->buf_width, p->buf_height, p->frm_rate,
+			p->bitrate, p->intra_period);
+}
+
+static int vb2ops_venc_start_streaming(struct vb2_queue *q, unsigned int count)
+{
+	struct mtk_vcodec_ctx *ctx = vb2_get_drv_priv(q);
+	struct v4l2_device *v4l2_dev = &ctx->dev->v4l2_dev;
+	int ret;
+#if MTK_V4L2_BENCHMARK
+	struct timeval begin, end;
+
+	do_gettimeofday(&begin);
+#endif
+
+	if (!(vb2_start_streaming_called(&ctx->m2m_ctx->out_q_ctx.q) &
+	      vb2_start_streaming_called(&ctx->m2m_ctx->cap_q_ctx.q))) {
+		mtk_v4l2_debug(1, "[%d]-> out=%d cap=%d",
+		 ctx->idx,
+		 vb2_start_streaming_called(&ctx->m2m_ctx->out_q_ctx.q),
+		 vb2_start_streaming_called(&ctx->m2m_ctx->cap_q_ctx.q));
+		return 0;
+	}
+
+	if ((ctx->state & (MTK_STATE_ERROR | MTK_STATE_ABORT)))
+		return -EINVAL;
+
+	if (ctx->state == MTK_STATE_FREE) {
+		ret = venc_if_create(ctx,
+				     ctx->q_data[MTK_Q_DATA_DST].fmt->fourcc,
+				     &ctx->h_enc);
+
+		if (ret != 0) {
+			ctx->state |= MTK_STATE_ERROR;
+			v4l2_err(v4l2_dev, "invalid codec type=%x\n",
+				 ctx->q_data[MTK_Q_DATA_DST].fmt->fourcc);
+			v4l2_err(v4l2_dev, "venc_if_create failed=%d\n", ret);
+			return -EINVAL;
+		}
+
+		if (ctx->q_data[MTK_Q_DATA_DST].fmt->fourcc ==
+			V4L2_PIX_FMT_H264)
+			ctx->hdr = 1;
+
+		ctx->state |= MTK_STATE_CREATE;
+	}
+
+	if ((ctx->state & MTK_STATE_CREATE) && !(ctx->state & MTK_STATE_INIT)) {
+		ret = venc_if_init(ctx->h_enc);
+		if (ret != 0) {
+			ctx->state |= MTK_STATE_ERROR;
+			v4l2_err(v4l2_dev, "venc_if_init failed=%d\n", ret);
+			return -EINVAL;
+		}
+		INIT_WORK(&ctx->encode_work, mtk_venc_worker);
+		ctx->state |= MTK_STATE_INIT;
+	}
+
+	if ((ctx->state & MTK_STATE_INIT) && !(ctx->state & MTK_STATE_CONFIG)) {
+		struct venc_enc_prm param;
+
+		mtk_venc_set_param(ctx, &param);
+		ret = venc_if_set_param(ctx->h_enc,
+					VENC_SET_PARAM_ENC, &param);
+		if (ret != 0) {
+			ctx->state |= MTK_STATE_ERROR;
+			v4l2_err(v4l2_dev, "venc_if_set_param failed=%d\n",
+				 ret);
+			return -EINVAL;
+		}
+		if (ctx->hdr) {
+			if (ctx->enc_params.seq_hdr_mode ==
+				V4L2_MPEG_VIDEO_HEADER_MODE_SEPARATE) {
+				ctx->state |= MTK_STATE_CONFIG;
+			} else {
+				ret = venc_if_set_param(ctx->h_enc,
+						VENC_SET_PARAM_PREPEND_HEADER,
+						0);
+				if (ret != 0) {
+					ctx->state |= MTK_STATE_ERROR;
+					v4l2_err(v4l2_dev,
+						 "venc_if_set_param failed=%d\n",
+						 ret);
+					return -EINVAL;
+				}
+				ctx->state |= (MTK_STATE_CONFIG |
+					MTK_STATE_HEADER);
+			}
+		} else {
+			ctx->state |= (MTK_STATE_CONFIG | MTK_STATE_HEADER);
+		}
+	}
+
+#if MTK_V4L2_BENCHMARK
+	do_gettimeofday(&end);
+	ctx->total_enc_dec_init_time =
+		((end.tv_sec - begin.tv_sec) * 1000000 +
+			end.tv_usec - begin.tv_usec);
+
+#endif
+	if ((ctx->state & MTK_STATE_HEADER))
+		return 0;
+
+	if (!(ctx->state & MTK_STATE_CONFIG)) {
+		ctx->state |= MTK_STATE_ERROR;
+		mtk_v4l2_err("not configured, state=0x%x\n", ctx->state);
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static void vb2ops_venc_stop_streaming(struct vb2_queue *q)
+{
+	struct mtk_vcodec_ctx *ctx = vb2_get_drv_priv(q);
+	struct v4l2_device *v4l2_dev = &ctx->dev->v4l2_dev;
+	struct vb2_buffer *src_buf, *dst_buf;
+	int retry;
+	int ret;
+
+	mtk_v4l2_debug(2, "[%d]-> type=%d", ctx->idx, q->type);
+
+	retry = 0;
+	while ((ctx->state & MTK_STATE_RUNNING) && (retry < 10)) {
+		mtk_vcodec_clean_ctx_int_flags(ctx);
+		ctx->state |= MTK_STATE_ABORT;
+		ret = mtk_vcodec_wait_for_done_ctx(ctx,
+					   MTK_INST_WORK_THREAD_ABORT_DONE,
+					   200, true);
+		mtk_v4l2_debug(1, "[%d] (%d) state=%d, retry=%d",
+				 ctx->idx, q->type, ctx->state, retry);
+		retry++;
+	}
+
+	if (q->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
+		while ((dst_buf = v4l2_m2m_dst_buf_remove(ctx->m2m_ctx))) {
+			dst_buf->planes[0].bytesused = 0;
+			v4l2_m2m_buf_done(to_vb2_v4l2_buffer(dst_buf), VB2_BUF_STATE_DONE);
+		}
+	} else {
+		while ((src_buf = v4l2_m2m_src_buf_remove(ctx->m2m_ctx)))
+			v4l2_m2m_buf_done(to_vb2_v4l2_buffer(src_buf), VB2_BUF_STATE_DONE);
+	}
+
+	/* todo : stop HW encoder and flush all buffers*/
+	if ((q->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE &&
+	     vb2_is_streaming(&ctx->m2m_ctx->out_q_ctx.q)) ||
+	     (q->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE &&
+	     vb2_is_streaming(&ctx->m2m_ctx->cap_q_ctx.q))) {
+		mtk_v4l2_debug(1, "[%d]-> q type %d out=%d cap=%d",
+				 ctx->idx, q->type,
+				 vb2_is_streaming(&ctx->m2m_ctx->out_q_ctx.q),
+				 vb2_is_streaming(&ctx->m2m_ctx->cap_q_ctx.q));
+		return;
+	}
+
+	ctx->state |= MTK_STATE_FINISH;
+
+	if ((ctx->state & MTK_STATE_INIT) && !(ctx->state & MTK_STATE_DEINIT)) {
+		ret = venc_if_deinit(ctx->h_enc);
+		if (ret != 0) {
+			ctx->state |= MTK_STATE_ERROR;
+			v4l2_err(v4l2_dev, "venc_if_deinit failed=%d\n", ret);
+			return;
+		}
+		ctx->state |= MTK_STATE_DEINIT;
+	}
+
+	if ((ctx->state & MTK_STATE_CREATE)) {
+		ret = 0;
+		switch (ctx->q_data[MTK_Q_DATA_DST].fmt->fourcc) {
+		case V4L2_PIX_FMT_H264:
+		case V4L2_PIX_FMT_VP8:
+			ret = venc_if_release(ctx->h_enc);
+			ctx->h_enc = 0;
+			break;
+		default:
+			ctx->state |= MTK_STATE_ERROR;
+			v4l2_err(v4l2_dev, "invalid codec type=%x\n",
+				 ctx->q_data[MTK_Q_DATA_DST].fmt->fourcc);
+			break;
+		}
+		if (ret != 0) {
+			ctx->state |= MTK_STATE_ERROR;
+			v4l2_err(v4l2_dev, "venc_if_release failed=%d\n", ret);
+			return;
+		}
+	}
+
+	mtk_v4l2_debug(2, "[%d]-> state=0x%x", ctx->idx, ctx->state);
+
+	ctx->state = MTK_STATE_FREE;
+}
+
+static struct vb2_ops mtk_venc_vb2_ops = {
+	.queue_setup			= vb2ops_venc_queue_setup,
+	.buf_prepare			= vb2ops_venc_buf_prepare,
+	.buf_queue			= vb2ops_venc_buf_queue,
+	.wait_prepare			= vb2_ops_wait_prepare,
+	.wait_finish			= vb2_ops_wait_finish,
+	.start_streaming		= vb2ops_venc_start_streaming,
+	.stop_streaming			= vb2ops_venc_stop_streaming,
+};
+
+static int mtk_venc_encode_header(void *priv)
+{
+	struct mtk_vcodec_ctx *ctx = priv;
+	struct v4l2_device *v4l2_dev = &ctx->dev->v4l2_dev;
+	int ret;
+	struct vb2_buffer *dst_buf;
+	struct mtk_vcodec_mem bs_buf;
+	struct venc_done_result enc_result;
+	int i;
+
+	dst_buf = v4l2_m2m_dst_buf_remove(ctx->m2m_ctx);
+	if (!dst_buf) {
+		ctx->state |= MTK_STATE_ERROR;
+		mtk_v4l2_debug(1, "No dst buffer");
+		return -EINVAL;
+	}
+
+	bs_buf.va = vb2_plane_vaddr(dst_buf, 0);
+	bs_buf.dma_addr = vb2_dma_contig_plane_dma_addr(dst_buf, 0);
+	bs_buf.size = (unsigned int)dst_buf->planes[0].length;
+
+	mtk_v4l2_debug(1,
+			"buf idx=%d va=0x%p dma_addr=0x%llx size=0x%lx",
+			dst_buf->index, bs_buf.va,
+			(u64)bs_buf.dma_addr, bs_buf.size);
+
+	ret = venc_if_encode(ctx->h_enc,
+			VENC_START_OPT_ENCODE_SEQUENCE_HEADER,
+			0, &bs_buf, &enc_result);
+
+	if (ret != 0) {
+		dst_buf->planes[0].bytesused = 0;
+		ctx->state |= MTK_STATE_ERROR;
+		v4l2_m2m_buf_done(to_vb2_v4l2_buffer(dst_buf), VB2_BUF_STATE_ERROR);
+		v4l2_err(v4l2_dev, "venc_if_encode failed=%d", ret);
+		return -EINVAL;
+	}
+
+	ctx->state |= MTK_STATE_HEADER;
+	dst_buf->planes[0].bytesused = enc_result.bs_size;
+
+	mtk_v4l2_debug(1, "venc_if_encode header len=%d",
+			enc_result.bs_size);
+	for (i = 0; i < enc_result.bs_size; i++) {
+		unsigned char *p = (unsigned char *)bs_buf.va;
+
+		mtk_v4l2_debug(1, "buf[%d]=0x%2x", i, p[i]);
+	}
+
+	v4l2_m2m_buf_done(to_vb2_v4l2_buffer(dst_buf), VB2_BUF_STATE_DONE);
+
+	return 0;
+}
+
+static int mtk_venc_param_change(struct mtk_vcodec_ctx *ctx, void *priv)
+{
+	struct vb2_buffer *vb = priv;
+	struct vb2_v4l2_buffer *v4l2_vb = to_vb2_v4l2_buffer(vb);
+	struct mtk_video_enc_buf *buf =
+			container_of(v4l2_vb, struct mtk_video_enc_buf, b);
+	int ret = 0;
+
+	if (buf->param_change == MTK_ENCODE_PARAM_NONE)
+		return 0;
+
+	mtk_v4l2_debug(1, "encode parameters change id=%d", vb->index);
+	if (buf->param_change & MTK_ENCODE_PARAM_BITRATE) {
+		struct venc_enc_prm enc_prm;
+
+		enc_prm.bitrate = buf->enc_params.bitrate;
+		mtk_v4l2_debug(1, "change param br=%d",
+				 enc_prm.bitrate);
+		ret |= venc_if_set_param(ctx->h_enc,
+					 VENC_SET_PARAM_ADJUST_BITRATE,
+					 &enc_prm);
+	}
+	if (buf->param_change & MTK_ENCODE_PARAM_FRAMERATE) {
+		struct venc_enc_prm enc_prm;
+
+		enc_prm.frm_rate = buf->enc_params.framerate_num /
+				   buf->enc_params.framerate_denom;
+		mtk_v4l2_debug(1, "change param fr=%d",
+				 enc_prm.frm_rate);
+		ret |= venc_if_set_param(ctx->h_enc,
+					 VENC_SET_PARAM_ADJUST_FRAMERATE,
+					 &enc_prm);
+	}
+	if (buf->param_change & MTK_ENCODE_PARAM_INTRA_PERIOD) {
+		mtk_v4l2_debug(1, "change param intra period=%d",
+				 buf->enc_params.gop_size);
+		ret |= venc_if_set_param(ctx->h_enc,
+					 VENC_SET_PARAM_I_FRAME_INTERVAL,
+					 &buf->enc_params.gop_size);
+	}
+	if (buf->param_change & MTK_ENCODE_PARAM_FRAME_TYPE) {
+		mtk_v4l2_debug(1, "change param force I=%d",
+				 buf->enc_params.force_intra);
+		if (buf->enc_params.force_intra)
+			ret |= venc_if_set_param(ctx->h_enc,
+						 VENC_SET_PARAM_FORCE_INTRA,
+						 0);
+	}
+	if (buf->param_change & MTK_ENCODE_PARAM_SKIP_FRAME) {
+		mtk_v4l2_debug(1, "change param skip frame=%d",
+				 buf->enc_params.skip_frame);
+		if (buf->enc_params.skip_frame)
+			ret |= venc_if_set_param(ctx->h_enc,
+						 VENC_SET_PARAM_SKIP_FRAME,
+						 0);
+	}
+	buf->param_change = MTK_ENCODE_PARAM_NONE;
+
+	if (ret != 0) {
+		ctx->state |= MTK_STATE_ERROR;
+		mtk_v4l2_err("venc_if_set_param failed=%d\n", ret);
+		return -1;
+	}
+
+	return 0;
+}
+
+static void mtk_venc_worker(struct work_struct *work)
+{
+	struct mtk_vcodec_ctx *ctx = container_of(work, struct mtk_vcodec_ctx,
+				    encode_work);
+	struct vb2_buffer *src_buf, *dst_buf;
+	struct vb2_v4l2_buffer *v4l2_vb;
+	struct venc_frm_buf frm_buf;
+	struct mtk_vcodec_mem bs_buf;
+	struct venc_done_result enc_result;
+	int ret;
+
+#if MTK_V4L2_BENCHMARK
+	struct timeval begin, end;
+	struct timeval begin1, end1;
+
+	do_gettimeofday(&begin);
+#endif
+
+	ctx->state |= MTK_STATE_RUNNING;
+
+	if (!(ctx->state & MTK_STATE_HEADER)) {
+#if MTK_V4L2_BENCHMARK
+		do_gettimeofday(&begin1);
+#endif
+		mtk_venc_encode_header(ctx);
+#if MTK_V4L2_BENCHMARK
+		do_gettimeofday(&end1);
+		ctx->total_enc_hdr_time +=
+			((end1.tv_sec - begin1.tv_sec) * 1000000 +
+				end1.tv_usec - begin1.tv_usec);
+#endif
+
+		ctx->state &= ~MTK_STATE_RUNNING;
+		v4l2_m2m_job_finish(ctx->dev->m2m_dev_enc, ctx->m2m_ctx);
+		return;
+	}
+
+	if (ctx->state & MTK_STATE_ABORT) {
+		ctx->state &= ~MTK_STATE_RUNNING;
+		v4l2_m2m_job_finish(ctx->dev->m2m_dev_enc, ctx->m2m_ctx);
+		mtk_v4l2_debug(1, "[%d] [MTK_INST_ABORT]", ctx->idx);
+		ctx->int_cond = 1;
+		ctx->int_type = MTK_INST_WORK_THREAD_ABORT_DONE;
+		wake_up_interruptible(&ctx->queue);
+		return;
+	}
+
+	src_buf = v4l2_m2m_next_src_buf(ctx->m2m_ctx);
+	if (!src_buf)
+		return;
+
+	mtk_venc_param_change(ctx, src_buf);
+
+	dst_buf = v4l2_m2m_dst_buf_remove(ctx->m2m_ctx);
+	if (!dst_buf)
+		return;
+
+	frm_buf.fb_addr.va = vb2_plane_vaddr(src_buf, 0);
+	frm_buf.fb_addr.dma_addr = vb2_dma_contig_plane_dma_addr(src_buf, 0);
+	frm_buf.fb_addr.size = (unsigned int)src_buf->planes[0].length;
+	frm_buf.fb_addr1.va = vb2_plane_vaddr(src_buf, 1);
+	frm_buf.fb_addr1.dma_addr = vb2_dma_contig_plane_dma_addr(src_buf, 1);
+	frm_buf.fb_addr1.size = (unsigned int)src_buf->planes[1].length;
+	if (src_buf->num_planes == 3) {
+		frm_buf.fb_addr2.va = vb2_plane_vaddr(src_buf, 2);
+		frm_buf.fb_addr2.dma_addr =
+			vb2_dma_contig_plane_dma_addr(src_buf, 2);
+		frm_buf.fb_addr2.size =
+			(unsigned int)src_buf->planes[2].length;
+	}
+	bs_buf.va = vb2_plane_vaddr(dst_buf, 0);
+	bs_buf.dma_addr = vb2_dma_contig_plane_dma_addr(dst_buf, 0);
+	bs_buf.size = (unsigned int)dst_buf->planes[0].length;
+
+	mtk_v4l2_debug(1,
+			"Framebuf VA=%p PA=%llx Size=0x%lx;VA=%p PA=0x%llx Size=0x%lx;VA=%p PA=0x%llx Size=0x%lx",
+			frm_buf.fb_addr.va,
+			(u64)frm_buf.fb_addr.dma_addr,
+			frm_buf.fb_addr.size,
+			frm_buf.fb_addr1.va,
+			(u64)frm_buf.fb_addr1.dma_addr,
+			frm_buf.fb_addr1.size,
+			frm_buf.fb_addr2.va,
+			(u64)frm_buf.fb_addr2.dma_addr,
+			frm_buf.fb_addr2.size);
+
+	ret = venc_if_encode(ctx->h_enc, VENC_START_OPT_ENCODE_FRAME,
+			     &frm_buf, &bs_buf, &enc_result);
+
+	switch (enc_result.msg) {
+	case VENC_MESSAGE_OK:
+		src_buf = v4l2_m2m_src_buf_remove(ctx->m2m_ctx);
+		v4l2_m2m_buf_done(to_vb2_v4l2_buffer(src_buf), VB2_BUF_STATE_DONE);
+		dst_buf->planes[0].bytesused = enc_result.bs_size;
+		break;
+	default:
+		src_buf = v4l2_m2m_src_buf_remove(ctx->m2m_ctx);
+		v4l2_m2m_buf_done(to_vb2_v4l2_buffer(src_buf), VB2_BUF_STATE_ERROR);
+		dst_buf->planes[0].bytesused = 0;
+		break;
+	}
+	if (enc_result.is_key_frm) {
+	        v4l2_vb = to_vb2_v4l2_buffer(dst_buf);
+		v4l2_vb->flags |= V4L2_BUF_FLAG_KEYFRAME;
+	}
+
+	if (ret != 0) {
+		ctx->state |= MTK_STATE_ERROR;
+		v4l2_m2m_buf_done(to_vb2_v4l2_buffer(dst_buf), VB2_BUF_STATE_ERROR);
+		mtk_v4l2_err("venc_if_encode failed=%d", ret);
+	} else {
+		v4l2_m2m_buf_done(to_vb2_v4l2_buffer(dst_buf), VB2_BUF_STATE_DONE);
+		mtk_v4l2_debug(1, "venc_if_encode bs size=%d",
+				 enc_result.bs_size);
+	}
+
+#if MTK_V4L2_BENCHMARK
+	do_gettimeofday(&end);
+	ctx->total_enc_dec_cnt++;
+	ctx->total_enc_dec_time +=
+		((end.tv_sec - begin.tv_sec) * 1000000 +
+			end.tv_usec - begin.tv_usec);
+#endif
+
+	ctx->state &= ~MTK_STATE_RUNNING;
+	v4l2_m2m_job_finish(ctx->dev->m2m_dev_enc, ctx->m2m_ctx);
+
+	mtk_v4l2_debug(1, "<=== src_buf[%d] dst_buf[%d] venc_if_encode ret=%d Size=%u===>",
+			src_buf->index, dst_buf->index, ret,
+			enc_result.bs_size);
+
+}
+
+static void m2mops_venc_device_run(void *priv)
+{
+	struct mtk_vcodec_ctx *ctx = priv;
+#ifdef USE_ENCODE_THREAD
+	queue_work(ctx->dev->encode_workqueue, &ctx->encode_work);
+#else
+	mtk_venc_worker(&ctx->encode_work);
+#endif
+}
+
+static int m2mops_venc_job_ready(void *m2m_priv)
+{
+	struct mtk_vcodec_ctx *ctx = m2m_priv;
+
+	if (!v4l2_m2m_num_dst_bufs_ready(ctx->m2m_ctx)) {
+		mtk_v4l2_debug(3,
+				"[%d]Not ready: not enough video dst buffers.",
+				ctx->idx);
+		return 0;
+	}
+
+	if (!v4l2_m2m_num_src_bufs_ready(ctx->m2m_ctx)) {
+		if ((ctx->state & MTK_STATE_HEADER)) {
+			mtk_v4l2_debug(3,
+					"[%d]Not ready: not enough video src buffers.",
+					ctx->idx);
+			return 0;
+		}
+	}
+
+	if ((ctx->state & (MTK_STATE_ERROR | MTK_STATE_ABORT))) {
+		mtk_v4l2_debug(3,
+				"[%d]Not ready: state=0x%x.",
+				ctx->idx, ctx->state);
+		return 0;
+	}
+
+	if (!(ctx->state & MTK_STATE_CONFIG)) {
+		mtk_v4l2_debug(3,
+				"[%d]Not ready: state=0x%x.",
+				ctx->idx, ctx->state);
+		return 0;
+	}
+
+	mtk_v4l2_debug(3, "[%d]ready!", ctx->idx);
+
+	return 1;
+}
+
+static void m2mops_venc_job_abort(void *priv)
+{
+	struct mtk_vcodec_ctx *ctx = priv;
+
+	mtk_v4l2_debug(3, "[%d]type=%d", ctx->idx, ctx->type);
+
+	ctx->aborting = 1;
+	ctx->state |= MTK_STATE_ABORT;
+
+	v4l2_m2m_job_finish(ctx->dev->m2m_dev_enc, ctx->m2m_ctx);
+}
+
+static void m2mops_venc_lock(void *m2m_priv)
+{
+	struct mtk_vcodec_ctx *ctx = m2m_priv;
+
+	mutex_lock(&ctx->dev->dev_mutex);
+}
+
+static void m2mops_venc_unlock(void *m2m_priv)
+{
+	struct mtk_vcodec_ctx *ctx = m2m_priv;
+
+	mutex_unlock(&ctx->dev->dev_mutex);
+}
+
+const struct v4l2_m2m_ops mtk_venc_m2m_ops = {
+	.device_run			= m2mops_venc_device_run,
+	.job_ready			= m2mops_venc_job_ready,
+	.job_abort			= m2mops_venc_job_abort,
+	.lock				= m2mops_venc_lock,
+	.unlock				= m2mops_venc_unlock,
+};
+
+#define IS_MTK_VENC_PRIV(x) ((V4L2_CTRL_ID2CLASS(x) == V4L2_CTRL_CLASS_MPEG) &&\
+			     V4L2_CTRL_DRIVER_PRIV(x))
+
+static const char *const *mtk_vcodec_enc_get_menu(u32 id)
+{
+	static const char *const mtk_vcodec_enc_video_frame_skip[] = {
+		"Disabled",
+		"Level Limit",
+		"VBV/CPB Limit",
+		NULL,
+	};
+	static const char *const mtk_vcodec_enc_video_force_frame[] = {
+		"Disabled",
+		"I Frame",
+		"Not Coded",
+		NULL,
+	};
+	switch (id) {
+	case V4L2_CID_MPEG_MFC51_VIDEO_FRAME_SKIP_MODE:
+		return mtk_vcodec_enc_video_frame_skip;
+	case V4L2_CID_MPEG_MFC51_VIDEO_FORCE_FRAME_TYPE:
+		return mtk_vcodec_enc_video_force_frame;
+	}
+	return NULL;
+}
+
+int mtk_venc_ctrls_setup(struct mtk_vcodec_ctx *ctx)
+{
+	struct v4l2_ctrl_config cfg;
+	int i;
+
+	v4l2_ctrl_handler_init(&ctx->ctrl_hdl, NUM_CTRLS);
+	if (ctx->ctrl_hdl.error) {
+		v4l2_err(&ctx->dev->v4l2_dev, "Init control handler fail %d\n",
+			 ctx->ctrl_hdl.error);
+		return ctx->ctrl_hdl.error;
+	}
+	for (i = 0; i < NUM_CTRLS; i++) {
+		if (IS_MTK_VENC_PRIV(controls[i].id)) {
+			memset(&cfg, 0, sizeof(struct v4l2_ctrl_config));
+			cfg.ops = &mtk_vcodec_enc_ctrl_ops;
+			cfg.id = controls[i].id;
+			cfg.min = controls[i].minimum;
+			cfg.max = controls[i].maximum;
+			cfg.def = controls[i].default_value;
+			cfg.name = controls[i].name;
+			cfg.type = controls[i].type;
+			cfg.flags = 0;
+			if (cfg.type == V4L2_CTRL_TYPE_MENU) {
+				cfg.step = 0;
+				cfg.menu_skip_mask = cfg.menu_skip_mask;
+				cfg.qmenu = mtk_vcodec_enc_get_menu(cfg.id);
+			} else {
+				cfg.step = controls[i].step;
+				cfg.menu_skip_mask = 0;
+			}
+			v4l2_ctrl_new_custom(&ctx->ctrl_hdl, &cfg, NULL);
+		} else {
+			if ((controls[i].type == V4L2_CTRL_TYPE_MENU) ||
+			    (controls[i].type == V4L2_CTRL_TYPE_INTEGER_MENU)) {
+				v4l2_ctrl_new_std_menu(
+					&ctx->ctrl_hdl,
+					&mtk_vcodec_enc_ctrl_ops,
+					controls[i].id,
+					controls[i].maximum, 0,
+					controls[i].default_value);
+			} else {
+				v4l2_ctrl_new_std(
+					&ctx->ctrl_hdl,
+					&mtk_vcodec_enc_ctrl_ops,
+					controls[i].id,
+					controls[i].minimum,
+					controls[i].maximum,
+					controls[i].step,
+					controls[i].default_value);
+			}
+		}
+
+		if (ctx->ctrl_hdl.error) {
+			v4l2_err(&ctx->dev->v4l2_dev,
+				"Adding control (%d) failed %d\n",
+				i, ctx->ctrl_hdl.error);
+			return ctx->ctrl_hdl.error;
+		}
+	}
+
+	v4l2_ctrl_handler_setup(&ctx->ctrl_hdl);
+	return 0;
+}
+
+void mtk_venc_ctrls_free(struct mtk_vcodec_ctx *ctx)
+{
+	v4l2_ctrl_handler_free(&ctx->ctrl_hdl);
+}
+
+int m2mctx_venc_queue_init(void *priv, struct vb2_queue *src_vq,
+			   struct vb2_queue *dst_vq)
+{
+	struct mtk_vcodec_ctx *ctx = priv;
+	int ret;
+
+	src_vq->type		= V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
+	src_vq->io_modes	= VB2_DMABUF | VB2_MMAP | VB2_USERPTR;
+	src_vq->drv_priv	= ctx;
+	src_vq->buf_struct_size = sizeof(struct mtk_video_enc_buf);
+	src_vq->ops		= &mtk_venc_vb2_ops;
+	src_vq->mem_ops		= &vb2_dma_contig_memops;
+	src_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
+	src_vq->lock = &ctx->vb2_mutex;
+
+	ret = vb2_queue_init(src_vq);
+	if (ret)
+		return ret;
+
+	dst_vq->type		= V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
+	dst_vq->io_modes	= VB2_DMABUF | VB2_MMAP | VB2_USERPTR;
+	dst_vq->drv_priv	= ctx;
+	dst_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
+	dst_vq->ops		= &mtk_venc_vb2_ops;
+	dst_vq->mem_ops		= &vb2_dma_contig_memops;
+	dst_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
+	dst_vq->lock = &ctx->vb2_mutex;
+
+	return vb2_queue_init(dst_vq);
+}
+
+int mtk_venc_unlock(struct mtk_vcodec_ctx *ctx)
+{
+	struct mtk_vcodec_dev *dev = ctx->dev;
+
+	mutex_unlock(&dev->enc_mutex);
+	return 0;
+}
+
+int mtk_venc_lock(struct mtk_vcodec_ctx *ctx)
+{
+	struct mtk_vcodec_dev *dev = ctx->dev;
+
+	mutex_lock(&dev->enc_mutex);
+	dev->curr_ctx = ctx->idx;
+	return 0;
+}
+
+void mtk_vcodec_venc_release(struct mtk_vcodec_ctx *ctx)
+{
+	if (ctx->h_enc) {
+		venc_if_deinit(ctx->h_enc);
+		venc_if_release(ctx->h_enc);
+	}
+
+#if MTK_V4L2_BENCHMARK
+	mtk_v4l2_debug(0, "\n\nMTK_V4L2_BENCHMARK");
+
+	mtk_v4l2_debug(0, "  total_enc_dec_cnt: %d ", ctx->total_enc_dec_cnt);
+	mtk_v4l2_debug(0, "  total_enc_dec_time: %d us",
+				ctx->total_enc_dec_time);
+	mtk_v4l2_debug(0, "  total_enc_dec_init_time: %d us",
+				ctx->total_enc_dec_init_time);
+	mtk_v4l2_debug(0, "  total_enc_hdr_time: %d us",
+				ctx->total_enc_hdr_time);
+	mtk_v4l2_debug(0, "  total_qbuf_out_time: %d us",
+				ctx->total_qbuf_out_time);
+	mtk_v4l2_debug(0, "  total_qbuf_out_cnt: %d ",
+				ctx->total_qbuf_out_cnt);
+	mtk_v4l2_debug(0, "  total_qbuf_cap_time: %d us",
+				ctx->total_qbuf_cap_time);
+	mtk_v4l2_debug(0, "  total_qbuf_cap_cnt: %d ",
+				ctx->total_qbuf_cap_cnt);
+
+	mtk_v4l2_debug(0, "  total_dqbuf_out_time: %d us",
+				ctx->total_dqbuf_out_time);
+	mtk_v4l2_debug(0, "  total_dqbuf_out_cnt: %d ",
+				ctx->total_dqbuf_out_cnt);
+	mtk_v4l2_debug(0, "  total_dqbuf_cap_time: %d us",
+				ctx->total_dqbuf_cap_time);
+	mtk_v4l2_debug(0, "  total_dqbuf_cap_cnt: %d ",
+				ctx->total_dqbuf_cap_cnt);
+
+	mtk_v4l2_debug(0, "  total_expbuf_time: %d us",
+				ctx->total_expbuf_time);
+
+#endif
+
+}
diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.h b/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.h
new file mode 100644
index 0000000..6802c93
--- /dev/null
+++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.h
@@ -0,0 +1,28 @@
+/*
+* Copyright (c) 2015 MediaTek Inc.
+* Author: PC Chen <pc.chen@mediatek.com>
+*         Tiffany Lin <tiffany.lin@mediatek.com>
+*
+* This program is free software; you can redistribute it and/or modify
+* it under the terms of the GNU General Public License version 2 as
+* published by the Free Software Foundation.
+*
+* This program is distributed in the hope that it will be useful,
+* but WITHOUT ANY WARRANTY; without even the implied warranty of
+* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+* GNU General Public License for more details.
+*/
+
+
+#ifndef _MTK_VCODEC_ENC_H_
+#define _MTK_VCODEC_ENC_H_
+
+int mtk_venc_unlock(struct mtk_vcodec_ctx *ctx);
+int mtk_venc_lock(struct mtk_vcodec_ctx *ctx);
+int m2mctx_venc_queue_init(void *priv, struct vb2_queue *src_vq,
+	struct vb2_queue *dst_vq);
+void mtk_vcodec_venc_release(struct mtk_vcodec_ctx *ctx);
+int mtk_venc_ctrls_setup(struct mtk_vcodec_ctx *ctx);
+void mtk_venc_ctrls_free(struct mtk_vcodec_ctx *ctx);
+
+#endif /* _MTK_VCODEC_ENC_H_ */
diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_drv.c b/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_drv.c
new file mode 100644
index 0000000..0f89880
--- /dev/null
+++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_drv.c
@@ -0,0 +1,535 @@
+/*
+* Copyright (c) 2015 MediaTek Inc.
+* Author: PC Chen <pc.chen@mediatek.com>
+*         Tiffany Lin <tiffany.lin@mediatek.com>
+*
+* This program is free software; you can redistribute it and/or modify
+* it under the terms of the GNU General Public License version 2 as
+* published by the Free Software Foundation.
+*
+* This program is distributed in the hope that it will be useful,
+* but WITHOUT ANY WARRANTY; without even the implied warranty of
+* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+* GNU General Public License for more details.
+*/
+
+#include <linux/interrupt.h>
+#include <linux/irq.h>
+#include <linux/module.h>
+#include <linux/of_device.h>
+#include <linux/of.h>
+#include <media/v4l2-event.h>
+#include <media/v4l2-mem2mem.h>
+#include <media/videobuf2-dma-contig.h>
+#include <linux/pm_runtime.h>
+
+#include "mtk_vcodec_drv.h"
+#include "mtk_vcodec_enc.h"
+#include "mtk_vcodec_pm.h"
+#include "mtk_vcodec_intr.h"
+#include "mtk_vcodec_util.h"
+#include "mtk_vpu_core.h"
+
+static irqreturn_t mtk_vcodec_enc_irq_handler(int irq, void *priv);
+
+static void vpu_enc_capability_ipi_handler(void *data, unsigned int len, void *priv)
+{
+	struct mtk_vcodec_dev *dev  = (struct mtk_vcodec_dev *)priv;
+
+	dev->enc_capability = *((u32 *)data);
+	mtk_v4l2_debug(0, "IPI=%d encoder capability %x",
+			IPI_VENC_CAPABILITY, dev->enc_capability);
+}
+
+
+/* Wake up context wait_queue */
+static void wake_up_ctx(struct mtk_vcodec_ctx *ctx, unsigned int reason)
+{
+	ctx->int_cond = 1;
+	ctx->int_type = reason;
+	wake_up_interruptible(&ctx->queue);
+}
+
+static irqreturn_t mtk_vcodec_enc_irq_handler(int irq, void *priv)
+{
+	struct mtk_vcodec_dev *dev = priv;
+	struct mtk_vcodec_ctx *ctx;
+	unsigned int irq_status;
+
+	ctx = dev->ctx[dev->curr_ctx];
+	if (ctx == NULL) {
+		mtk_v4l2_err("ctx==NULL");
+		return IRQ_HANDLED;
+	}
+	mtk_v4l2_debug(1, "idx=%d", ctx->idx);
+	irq_status = readl(dev->reg_base[VENC_SYS] +
+				(MTK_VENC_IRQ_STATUS_OFFSET));
+	if (irq_status & MTK_VENC_IRQ_STATUS_PAUSE)
+		writel((MTK_VENC_IRQ_STATUS_PAUSE),
+		       dev->reg_base[VENC_SYS] + (MTK_VENC_IRQ_ACK_OFFSET));
+
+	if (irq_status & MTK_VENC_IRQ_STATUS_SWITCH)
+		writel((MTK_VENC_IRQ_STATUS_SWITCH),
+		       dev->reg_base[VENC_SYS] + (MTK_VENC_IRQ_ACK_OFFSET));
+
+	if (irq_status & MTK_VENC_IRQ_STATUS_DRAM)
+		writel((MTK_VENC_IRQ_STATUS_DRAM),
+		       dev->reg_base[VENC_SYS] + (MTK_VENC_IRQ_ACK_OFFSET));
+
+	if (irq_status & MTK_VENC_IRQ_STATUS_SPS)
+		writel((MTK_VENC_IRQ_STATUS_SPS),
+		       dev->reg_base[VENC_SYS] + (MTK_VENC_IRQ_ACK_OFFSET));
+
+	if (irq_status & MTK_VENC_IRQ_STATUS_PPS)
+		writel((MTK_VENC_IRQ_STATUS_PPS),
+		       dev->reg_base[VENC_SYS] + (MTK_VENC_IRQ_ACK_OFFSET));
+
+	if (irq_status & MTK_VENC_IRQ_STATUS_FRM)
+		writel((MTK_VENC_IRQ_STATUS_FRM),
+		       dev->reg_base[VENC_SYS] + (MTK_VENC_IRQ_ACK_OFFSET));
+
+	ctx->irq_status = irq_status;
+	wake_up_ctx(ctx, MTK_INST_IRQ_RECEIVED);
+	return IRQ_HANDLED;
+}
+
+#if 1 /* VENC_LT */
+static irqreturn_t mtk_vcodec_enc_irq_handler2(int irq, void *priv)
+{
+	struct mtk_vcodec_dev *dev = priv;
+	struct mtk_vcodec_ctx *ctx;
+	unsigned int irq_status;
+
+	ctx = dev->ctx[dev->curr_ctx];
+	if (ctx == NULL) {
+		mtk_v4l2_err("ctx==NULL");
+		return IRQ_HANDLED;
+	}
+	mtk_v4l2_debug(1, "idx=%d", ctx->idx);
+	irq_status = readl(dev->reg_base[VENC_LT_SYS] +
+				(MTK_VENC_IRQ_STATUS_OFFSET));
+	if (irq_status & MTK_VENC_IRQ_STATUS_PAUSE)
+		writel((MTK_VENC_IRQ_STATUS_PAUSE),
+		       dev->reg_base[VENC_LT_SYS] + (MTK_VENC_IRQ_ACK_OFFSET));
+
+	if (irq_status & MTK_VENC_IRQ_STATUS_SWITCH)
+		writel((MTK_VENC_IRQ_STATUS_SWITCH),
+		       dev->reg_base[VENC_LT_SYS] + (MTK_VENC_IRQ_ACK_OFFSET));
+
+	if (irq_status & MTK_VENC_IRQ_STATUS_DRAM)
+		writel((MTK_VENC_IRQ_STATUS_DRAM),
+		       dev->reg_base[VENC_LT_SYS] + (MTK_VENC_IRQ_ACK_OFFSET));
+
+	if (irq_status & MTK_VENC_IRQ_STATUS_SPS)
+		writel((MTK_VENC_IRQ_STATUS_SPS),
+		       dev->reg_base[VENC_LT_SYS] + (MTK_VENC_IRQ_ACK_OFFSET));
+
+	if (irq_status & MTK_VENC_IRQ_STATUS_PPS)
+		writel((MTK_VENC_IRQ_STATUS_PPS),
+		       dev->reg_base[VENC_LT_SYS] + (MTK_VENC_IRQ_ACK_OFFSET));
+
+	if (irq_status & MTK_VENC_IRQ_STATUS_FRM)
+		writel((MTK_VENC_IRQ_STATUS_FRM),
+		       dev->reg_base[VENC_LT_SYS] + (MTK_VENC_IRQ_ACK_OFFSET));
+
+	ctx->irq_status = irq_status;
+	wake_up_ctx(ctx, MTK_INST_IRQ_RECEIVED);
+	return IRQ_HANDLED;
+}
+#endif
+
+static int fops_vcodec_open(struct file *file)
+{
+	struct video_device *vfd = video_devdata(file);
+	struct mtk_vcodec_dev *dev = video_drvdata(file);
+	struct mtk_vcodec_ctx *ctx = NULL;
+	int ret = 0;
+
+	mtk_v4l2_debug(0, "%s encoder", dev_name(&dev->plat_dev->dev));
+	mutex_lock(&dev->dev_mutex);
+
+	ctx = devm_kzalloc(&dev->plat_dev->dev, sizeof(*ctx), GFP_KERNEL);
+	if (!ctx) {
+		ret = -ENOMEM;
+		goto err_alloc;
+	}
+
+	if (dev->num_instances >= MTK_VCODEC_MAX_INSTANCES) {
+		mtk_v4l2_err("Too many open contexts\n");
+		ret = -EBUSY;
+		goto err_no_ctx;
+	}
+
+	ctx->idx = ffz(dev->instance_mask[0]);
+	v4l2_fh_init(&ctx->fh, video_devdata(file));
+	file->private_data = &ctx->fh;
+	v4l2_fh_add(&ctx->fh);
+	ctx->dev = dev;
+	mutex_init(&ctx->encode_param_mutex);
+	mutex_init(&ctx->vb2_mutex);
+	if (vfd == dev->vfd_enc) {
+		ctx->type = MTK_INST_ENCODER;
+		ret = mtk_venc_ctrls_setup(ctx);
+		if (ret) {
+			mtk_v4l2_err("Failed to setup controls() (%d)\n",
+				       ret);
+			goto err_ctrls_setup;
+		}
+		ctx->m2m_ctx = v4l2_m2m_ctx_init(dev->m2m_dev_enc, ctx,
+						 &m2mctx_venc_queue_init);
+		if (IS_ERR(ctx->m2m_ctx)) {
+			ret = PTR_ERR(ctx->m2m_ctx);
+			mtk_v4l2_err("Failed to v4l2_m2m_ctx_init() (%d)\n",
+				       ret);
+			goto err_ctx_init;
+		}
+		ctx->fh.ctrl_handler = &ctx->ctrl_hdl;
+	} else {
+		mtk_v4l2_err("Invalid vfd !\n");
+		ret = -ENOENT;
+		goto err_ctx_init;
+	}
+
+	init_waitqueue_head(&ctx->queue);
+	dev->num_instances++;
+
+	if (dev->num_instances == 1) {
+		ret = vpu_load_firmware(vpu_get_plat_device(dev->plat_dev));
+		if (ret < 0) {
+				mtk_v4l2_err("vpu_load_firmware failed!\n");
+			goto err_load_fw;
+		}
+		mtk_v4l2_debug(0, "encoder capability %x", dev->enc_capability);
+	}
+
+	mtk_v4l2_debug(2, "Create instance [%d]@%p m2m_ctx=%p type=%d\n",
+			 ctx->idx, ctx, ctx->m2m_ctx, ctx->type);
+	ctx->state = MTK_STATE_FREE;
+	mtk_vcodec_clean_ctx_int_flags(ctx);
+	set_bit(ctx->idx, &dev->instance_mask[0]);
+	dev->ctx[ctx->idx] = ctx;
+	vpu_enable_clock(vpu_get_plat_device(dev->plat_dev));
+
+	mutex_unlock(&dev->dev_mutex);
+	return ret;
+
+	/* Deinit when failure occurred */
+err_load_fw:
+	v4l2_m2m_ctx_release(ctx->m2m_ctx);
+	v4l2_fh_del(&ctx->fh);
+	v4l2_fh_exit(&ctx->fh);
+	dev->num_instances--;
+err_ctx_init:
+err_ctrls_setup:
+	mtk_venc_ctrls_free(ctx);
+err_no_ctx:
+	devm_kfree(&dev->plat_dev->dev, ctx);
+err_alloc:
+	mutex_unlock(&dev->dev_mutex);
+	return ret;
+}
+
+static int fops_vcodec_release(struct file *file)
+{
+	struct mtk_vcodec_dev *dev = video_drvdata(file);
+	struct mtk_vcodec_ctx *ctx = fh_to_ctx(file->private_data);
+
+	mtk_v4l2_debug(2, "[%d]\n", ctx->idx);
+	mutex_lock(&dev->dev_mutex);
+	v4l2_m2m_ctx_release(ctx->m2m_ctx);
+	mtk_vcodec_venc_release(ctx);
+	ctx->state = MTK_STATE_DEINIT;
+	mtk_venc_ctrls_free(ctx);
+	v4l2_fh_del(&ctx->fh);
+	v4l2_fh_exit(&ctx->fh);
+	dev->ctx[ctx->idx] = NULL;
+	dev->num_instances--;
+	if (dev->num_instances == 0) {
+		vpu_disable_clock(vpu_get_plat_device(dev->plat_dev));
+	}
+	clear_bit(ctx->idx, &dev->instance_mask[0]);
+	devm_kfree(&dev->plat_dev->dev, ctx);
+	mutex_unlock(&dev->dev_mutex);
+	return 0;
+}
+
+static unsigned int fops_vcodec_poll(struct file *file,
+				     struct poll_table_struct *wait)
+{
+	struct mtk_vcodec_ctx *ctx = fh_to_ctx(file->private_data);
+	struct mtk_vcodec_dev *dev = ctx->dev;
+	int ret;
+
+	mutex_lock(&dev->dev_mutex);
+	ret = v4l2_m2m_poll(file, ctx->m2m_ctx, wait);
+	mutex_unlock(&dev->dev_mutex);
+
+	return ret;
+}
+
+static int fops_vcodec_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	struct mtk_vcodec_ctx *ctx = fh_to_ctx(file->private_data);
+
+	return v4l2_m2m_mmap(file, ctx->m2m_ctx, vma);
+}
+
+static const struct v4l2_file_operations mtk_vcodec_fops = {
+	.owner				= THIS_MODULE,
+	.open				= fops_vcodec_open,
+	.release			= fops_vcodec_release,
+	.poll				= fops_vcodec_poll,
+	.unlocked_ioctl			= video_ioctl2,
+	.mmap				= fops_vcodec_mmap,
+};
+
+static int mtk_vcodec_probe(struct platform_device *pdev)
+{
+	struct mtk_vcodec_dev *dev;
+	struct video_device *vfd_enc;
+	struct resource *res;
+	int i, j, ret;
+	struct platform_device *vpu_pdev;
+
+	dev = devm_kzalloc(&pdev->dev, sizeof(*dev), GFP_KERNEL);
+	if (!dev)
+		return -ENOMEM;
+
+	dev->plat_dev = pdev;
+
+	vpu_pdev = vpu_get_plat_device(dev->plat_dev);
+	if (vpu_pdev == NULL) {
+		mtk_v4l2_err("[VPU] vpu device in not ready\n");
+		return -EPROBE_DEFER;
+	}
+
+	ret = vpu_ipi_register(vpu_pdev, IPI_VENC_CAPABILITY,
+			       vpu_enc_capability_ipi_handler,
+			       "vpu_init", dev);
+	if (ret != 0) {
+		mtk_v4l2_err("[VPU] failed to register IPI_VENC_CAPBILITY\n");
+		return ret;
+	}
+
+	ret = mtk_vcodec_init_enc_pm(dev);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "Failed to get mt vcodec clock source!\n");
+		return ret;
+	}
+
+	for (i = VENC_SYS, j = 0; i < NUM_MAX_VCODEC_REG_BASE; i++, j++) {
+		res = platform_get_resource(pdev, IORESOURCE_MEM, j);
+		if (res == NULL) {
+			dev_err(&pdev->dev, "get memory resource failed.\n");
+			ret = -ENXIO;
+			goto err_res;
+		}
+		dev->reg_base[i] = devm_ioremap_resource(&pdev->dev, res);
+		if (IS_ERR(dev->reg_base[i])) {
+			dev_err(&pdev->dev,
+				"devm_ioremap_resource %d failed.\n", i);
+			ret = PTR_ERR(dev->reg_base);
+			goto err_res;
+		}
+		mtk_v4l2_debug(2, "reg[%d] base=0x%p\n", i, dev->reg_base[i]);
+	}
+
+	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
+	if (res == NULL) {
+		dev_err(&pdev->dev, "failed to get irq resource\n");
+		ret = -ENOENT;
+		goto err_res;
+	}
+
+	dev->enc_irq = platform_get_irq(pdev, 0);
+	ret = devm_request_irq(&pdev->dev, dev->enc_irq,
+			       mtk_vcodec_enc_irq_handler,
+			       0, pdev->name, dev);
+	if (ret) {
+		dev_err(&pdev->dev, "Failed to install dev->enc_irq %d (%d)\n",
+			dev->enc_irq,
+			ret);
+		ret = -EINVAL;
+		goto err_res;
+	}
+
+	dev->enc_lt_irq = platform_get_irq(pdev, 1);
+	ret = devm_request_irq(&pdev->dev,
+			       dev->enc_lt_irq, mtk_vcodec_enc_irq_handler2,
+			       0, pdev->name, dev);
+	if (ret) {
+		dev_err(&pdev->dev,
+			"Failed to install dev->enc_lt_irq %d (%d)\n",
+			dev->enc_lt_irq, ret);
+		ret = -EINVAL;
+		goto err_res;
+	}
+
+	disable_irq(dev->enc_irq);
+	disable_irq(dev->enc_lt_irq); /* VENC_LT */
+	mutex_init(&dev->enc_mutex);
+	mutex_init(&dev->dev_mutex);
+
+	snprintf(dev->v4l2_dev.name, sizeof(dev->v4l2_dev.name), "%s",
+		 "[MTK_V4L2_VENC]");
+
+	ret = v4l2_device_register(&pdev->dev, &dev->v4l2_dev);
+	if (ret) {
+		mtk_v4l2_err("v4l2_device_register err=%d\n", ret);
+		return ret;
+	}
+
+	init_waitqueue_head(&dev->queue);
+
+	/* allocate video device for encoder and register it */
+	vfd_enc = video_device_alloc();
+	if (!vfd_enc) {
+		mtk_v4l2_err("Failed to allocate video device\n");
+		ret = -ENOMEM;
+		goto err_enc_alloc;
+	}
+	vfd_enc->fops           = &mtk_vcodec_fops;
+	vfd_enc->ioctl_ops      = &mtk_venc_ioctl_ops;
+	vfd_enc->release        = video_device_release;
+	vfd_enc->lock           = &dev->dev_mutex;
+	vfd_enc->v4l2_dev       = &dev->v4l2_dev;
+	vfd_enc->vfl_dir        = VFL_DIR_M2M;
+	snprintf(vfd_enc->name, sizeof(vfd_enc->name), "%s",
+		 MTK_VCODEC_ENC_NAME);
+	video_set_drvdata(vfd_enc, dev);
+	dev->vfd_enc = vfd_enc;
+	platform_set_drvdata(pdev, dev);
+	ret = video_register_device(vfd_enc, VFL_TYPE_GRABBER, 1);
+	if (ret) {
+		mtk_v4l2_err("Failed to register video device\n");
+		goto err_enc_reg;
+	}
+	mtk_v4l2_debug(0, "encoder registered as /dev/video%d\n",
+			 vfd_enc->num);
+
+	dev->alloc_ctx = vb2_dma_contig_init_ctx(&pdev->dev);
+	if (IS_ERR(dev->alloc_ctx)) {
+		mtk_v4l2_err("Failed to alloc vb2 dma context 0\n");
+		ret = PTR_ERR(dev->alloc_ctx);
+		goto err_vb2_ctx_init;
+	}
+
+	dev->m2m_dev_enc = v4l2_m2m_init(&mtk_venc_m2m_ops);
+	if (IS_ERR(dev->m2m_dev_enc)) {
+		mtk_v4l2_err("Failed to init mem2mem enc device\n");
+		ret = PTR_ERR(dev->m2m_dev_enc);
+		goto err_enc_mem_init;
+	}
+
+	dev->encode_workqueue =
+			create_singlethread_workqueue(MTK_VCODEC_ENC_NAME);
+	if (!dev->encode_workqueue) {
+		mtk_v4l2_err("Failed to create encode workqueue\n");
+		ret = -EINVAL;
+		goto err_event_workq;
+	}
+
+	return 0;
+
+err_event_workq:
+	v4l2_m2m_release(dev->m2m_dev_enc);
+err_enc_mem_init:
+	vb2_dma_contig_cleanup_ctx(dev->alloc_ctx);
+err_vb2_ctx_init:
+	video_unregister_device(vfd_enc);
+err_enc_reg:
+	video_device_release(vfd_enc);
+err_enc_alloc:
+	v4l2_device_unregister(&dev->v4l2_dev);
+err_res:
+	mtk_vcodec_release_enc_pm(dev);
+	return ret;
+}
+
+static const struct of_device_id mtk_vcodec_match[] = {
+	{.compatible = "mediatek,mt8173-vcodec-enc",},
+	{},
+};
+MODULE_DEVICE_TABLE(of, mtk_vcodec_match);
+
+static int mtk_vcodec_remove(struct platform_device *pdev)
+{
+	struct mtk_vcodec_dev *dev = platform_get_drvdata(pdev);
+
+	mtk_v4l2_debug_enter();
+	flush_workqueue(dev->encode_workqueue);
+	destroy_workqueue(dev->encode_workqueue);
+	if (dev->m2m_dev_enc)
+		v4l2_m2m_release(dev->m2m_dev_enc);
+	if (dev->alloc_ctx)
+		vb2_dma_contig_cleanup_ctx(dev->alloc_ctx);
+
+	if (dev->vfd_enc) {
+		video_unregister_device(dev->vfd_enc);
+		video_device_release(dev->vfd_enc);
+	}
+	v4l2_device_unregister(&dev->v4l2_dev);
+	mtk_vcodec_release_enc_pm(dev);
+	return 0;
+}
+
+static int mtk_vcodec_venc_suspend(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct mtk_vcodec_dev *m_dev = platform_get_drvdata(pdev);
+
+	mtk_v4l2_debug(0, "m_dev->num_instances=%d", m_dev->num_instances);
+	if (m_dev->num_instances == 0)
+		return 0;
+	mtk_vcodec_clean_dev_int_flags(m_dev);
+	if (test_and_set_bit(0, &m_dev->enter_suspend) != 0) {
+		mtk_v4l2_err("Error: going to suspend for a second time\n");
+		return -EIO;
+	}
+	mtk_vcodec_wait_for_done_dev(m_dev,
+				     MTK_INST_WORK_THREAD_SUSPEND_DONE,
+				     3000, true);
+
+	mutex_lock(&m_dev->enc_mutex);
+	mtk_vcodec_enc_clock_off();
+	mtk_v4l2_debug(0, "m_dev->num_instances=%d", m_dev->num_instances);
+	return 0;
+}
+
+static int mtk_vcodec_venc_resume(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct mtk_vcodec_dev *m_dev = platform_get_drvdata(pdev);
+
+	mtk_v4l2_debug(0, "m_dev->num_instances=%d", m_dev->num_instances);
+	if (m_dev->num_instances == 0)
+		return 0;
+
+	test_and_clear_bit(0, &m_dev->enter_suspend);
+	mtk_vcodec_enc_clock_on();
+	mutex_unlock(&m_dev->enc_mutex);
+	return 0;
+}
+
+
+static const struct dev_pm_ops mtk_vcodec_venc_pm_ops = {
+	SET_SYSTEM_SLEEP_PM_OPS(mtk_vcodec_venc_suspend,
+				mtk_vcodec_venc_resume)
+};
+
+static struct platform_driver mtk_vcodec_driver = {
+	.probe	= mtk_vcodec_probe,
+	.remove	= mtk_vcodec_remove,
+	.driver	= {
+		.name	= MTK_VCODEC_ENC_NAME,
+		.owner	= THIS_MODULE,
+		.of_match_table = mtk_vcodec_match,
+		.pm = &mtk_vcodec_venc_pm_ops,
+	},
+};
+
+module_platform_driver(mtk_vcodec_driver);
+
+
+MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION("Mediatek video codec V4L2 driver");
diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_pm.c b/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_pm.c
new file mode 100644
index 0000000..ba97344
--- /dev/null
+++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_pm.c
@@ -0,0 +1,122 @@
+/*
+* Copyright (c) 2015 MediaTek Inc.
+* Author: Tiffany Lin <tiffany.lin@mediatek.com>
+*
+* This program is free software; you can redistribute it and/or modify
+* it under the terms of the GNU General Public License version 2 as
+* published by the Free Software Foundation.
+*
+* This program is distributed in the hope that it will be useful,
+* but WITHOUT ANY WARRANTY; without even the implied warranty of
+* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+* GNU General Public License for more details.
+*/
+
+#include <linux/clk.h>
+#include <linux/of_address.h>
+#include <linux/of_platform.h>
+#include <linux/pm_runtime.h>
+#include <soc/mediatek/smi.h>
+
+#include "mtk_vcodec_pm.h"
+#include "mtk_vcodec_util.h"
+#include "mtk_vpu_core.h"
+
+static struct mtk_vcodec_pm *pm;
+
+int mtk_vcodec_init_enc_pm(struct mtk_vcodec_dev *mtkdev)
+{
+	struct device_node *node;
+	struct platform_device *pdev;
+	struct device *dev;
+	int ret = 0;
+
+	pdev = mtkdev->plat_dev;
+	pm = &mtkdev->pm;
+	memset(pm, 0, sizeof(struct mtk_vcodec_pm));
+	pm->mtkdev = mtkdev;
+	dev = &pdev->dev;
+
+	node = of_parse_phandle(dev->of_node, "larb", 0);
+	if (!node)
+		return -1;
+	pdev = of_find_device_by_node(node);
+	if (WARN_ON(!pdev)) {
+		of_node_put(node);
+		return -1;
+	}
+	pm->larbvenc = &pdev->dev;
+
+	node = of_parse_phandle(dev->of_node, "larb", 1);
+	if (!node)
+		return -1;
+
+	pdev = of_find_device_by_node(node);
+	if (WARN_ON(!pdev)) {
+		of_node_put(node);
+		return -EINVAL;
+	}
+	pm->larbvenclt = &pdev->dev;
+
+	pdev = mtkdev->plat_dev;
+	pm->dev = &pdev->dev;
+
+	pm->vencpll = devm_clk_get(&pdev->dev, "vencpll");
+	if (pm->vencpll == NULL) {
+		mtk_v4l2_err("devm_clk_get vencpll fail");
+		ret = -1;
+	}
+
+	pm->venc_lt_sel = devm_clk_get(&pdev->dev, "venc_lt_sel");
+	if (pm->venc_lt_sel == NULL) {
+		mtk_v4l2_err("devm_clk_get venc_lt_sel fail");
+		ret = -1;
+	}
+
+	pm->vcodecpll_370p5_ck = devm_clk_get(&pdev->dev, "vcodecpll_370p5_ck");
+	if (pm->vcodecpll_370p5_ck == NULL) {
+		mtk_v4l2_err("devm_clk_get vcodecpll_370p5_ck fail");
+		ret = -1;
+	}
+
+	return ret;
+}
+
+void mtk_vcodec_release_enc_pm(struct mtk_vcodec_dev *dev)
+{
+}
+
+
+void mtk_vcodec_enc_clock_on(void)
+{
+	int ret;
+
+	clk_set_rate(pm->vencpll, 800 * 1000000);
+
+	ret = clk_prepare_enable(pm->vcodecpll_370p5_ck);
+	if (ret)
+		mtk_v4l2_err("vcodecpll_370p5_ck fail %d", ret);
+
+	ret = clk_prepare_enable(pm->venc_lt_sel);
+	if (ret)
+		mtk_v4l2_err("venc_lt_sel fail %d", ret);
+
+	ret = clk_set_parent(pm->venc_lt_sel, pm->vcodecpll_370p5_ck);
+	if (ret)
+		mtk_v4l2_err("clk_set_parent fail %d", ret);
+
+	ret = mtk_smi_larb_get(pm->larbvenc);
+	if (ret)
+		mtk_v4l2_err("mtk_smi_larb_get larb3 fail %d\n", ret);
+
+	ret = mtk_smi_larb_get(pm->larbvenclt);
+	if (ret)
+		mtk_v4l2_err("mtk_smi_larb_get larb4 fail %d\n", ret);
+
+}
+
+void mtk_vcodec_enc_clock_off(void)
+{
+	mtk_smi_larb_put(pm->larbvenc);
+	mtk_smi_larb_put(pm->larbvenclt);
+}
diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_intr.c b/drivers/media/platform/mtk-vcodec/mtk_vcodec_intr.c
new file mode 100644
index 0000000..7a2cacf
--- /dev/null
+++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_intr.c
@@ -0,0 +1,110 @@
+/*
+* Copyright (c) 2015 MediaTek Inc.
+* Author: Tiffany Lin <tiffany.lin@mediatek.com>
+*
+* This program is free software; you can redistribute it and/or modify
+* it under the terms of the GNU General Public License version 2 as
+* published by the Free Software Foundation.
+*
+* This program is distributed in the hope that it will be useful,
+* but WITHOUT ANY WARRANTY; without even the implied warranty of
+* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+* GNU General Public License for more details.
+*/
+
+#include <linux/errno.h>
+#include <linux/wait.h>
+
+#include "mtk_vcodec_intr.h"
+#include "mtk_vcodec_drv.h"
+#include "mtk_vcodec_util.h"
+
+void mtk_vcodec_clean_ctx_int_flags(void *data)
+{
+	struct mtk_vcodec_ctx *ctx = (struct mtk_vcodec_ctx *)data;
+
+	ctx->int_cond = 0;
+	ctx->int_type = 0;
+}
+
+void mtk_vcodec_clean_dev_int_flags(void *data)
+{
+	struct mtk_vcodec_dev *dev = (struct mtk_vcodec_dev *)data;
+
+	dev->int_cond = 0;
+	dev->int_type = 0;
+}
+
+int mtk_vcodec_wait_for_done_ctx(void *data, int command,
+				 unsigned int timeout, int interrupt)
+{
+	wait_queue_head_t *waitqueue;
+	long timeout_jiff, ret;
+	int status = 0;
+	struct mtk_vcodec_ctx *ctx = (struct mtk_vcodec_ctx *)data;
+
+	waitqueue = (wait_queue_head_t *)&ctx->queue;
+	timeout_jiff = msecs_to_jiffies(timeout);
+	if (interrupt) {
+		ret = wait_event_interruptible_timeout(*waitqueue,
+				(ctx->int_cond &&
+				(ctx->int_type == command)),
+				timeout_jiff);
+	} else {
+		ret = wait_event_timeout(*waitqueue,
+				(ctx->int_cond &&
+				(ctx->int_type == command)),
+				 timeout_jiff);
+	}
+	if (0 == ret) {
+		status = -1;	/* timeout */
+		mtk_v4l2_err("[%d] cmd=%d, wait_event_interruptible_timeout time=%lu out %d %d!",
+				ctx->idx, command, timeout_jiff, ctx->int_cond,
+				ctx->int_type);
+	} else if (-ERESTARTSYS == ret) {
+		mtk_v4l2_err("[%d] cmd=%d, wait_event_interruptible_timeout interrupted by a signal %d %d",
+				ctx->idx, command, ctx->int_cond,
+				ctx->int_type);
+		status = -1;
+	}
+
+	ctx->int_cond = 0;
+	ctx->int_type = 0;
+
+	return status;
+}
+
+int mtk_vcodec_wait_for_done_dev(void *data, int command,
+				 unsigned int timeout, int interrupt)
+{
+	wait_queue_head_t *waitqueue;
+	long timeout_jiff, ret;
+	int status = 0;
+	struct mtk_vcodec_dev *dev = (struct mtk_vcodec_dev *)data;
+
+	waitqueue = (wait_queue_head_t *)&dev->queue;
+	timeout_jiff = msecs_to_jiffies(timeout);
+	if (interrupt) {
+		ret = wait_event_interruptible_timeout(*waitqueue,
+				(dev->int_cond &&
+				(dev->int_type == command)),
+				timeout_jiff);
+	} else {
+		ret = wait_event_timeout(*waitqueue,
+				(dev->int_cond &&
+				(dev->int_type == command)),
+				timeout_jiff);
+	}
+	if (0 == ret) {
+		status = -1;	/* timeout */
+		mtk_v4l2_err("wait_event_interruptible_timeout time=%lu out %d %d!",
+				timeout_jiff, dev->int_cond, dev->int_type);
+	} else if (-ERESTARTSYS == ret) {
+		mtk_v4l2_err("wait_event_interruptible_timeout interrupted by a signal %d %d",
+				dev->int_cond, dev->int_type);
+		status = -1;
+	}
+	dev->int_cond = 0;
+	dev->int_type = 0;
+	return status;
+}
diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_intr.h b/drivers/media/platform/mtk-vcodec/mtk_vcodec_intr.h
new file mode 100644
index 0000000..e2d2eaa
--- /dev/null
+++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_intr.h
@@ -0,0 +1,30 @@
+/*
+* Copyright (c) 2015 MediaTek Inc.
+* Author: Tiffany Lin <tiffany.lin@mediatek.com>
+*
+* This program is free software; you can redistribute it and/or modify
+* it under the terms of the GNU General Public License version 2 as
+* published by the Free Software Foundation.
+*
+* This program is distributed in the hope that it will be useful,
+* but WITHOUT ANY WARRANTY; without even the implied warranty of
+* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+* GNU General Public License for more details.
+*/
+
+#ifndef _MTK_VCODEC_INTR_H_
+#define _MTK_VCODEC_INTR_H_
+
+#define MTK_INST_IRQ_RECEIVED		0x1
+#define MTK_INST_WORK_THREAD_ABORT_DONE	0x2
+#define MTK_INST_WORK_THREAD_SUSPEND_DONE	0x3
+
+/* timeout is ms */
+int mtk_vcodec_wait_for_done_ctx(void *data, int command, unsigned int timeout,
+				 int interrupt);
+int mtk_vcodec_wait_for_done_dev(void *data, int command, unsigned int timeout,
+				 int interrupt);
+void mtk_vcodec_clean_ctx_int_flags(void *data);
+void mtk_vcodec_clean_dev_int_flags(void *data);
+
+#endif /* _MTK_VCODEC_INTR_H_ */
diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_pm.h b/drivers/media/platform/mtk-vcodec/mtk_vcodec_pm.h
new file mode 100644
index 0000000..a28bb7c
--- /dev/null
+++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_pm.h
@@ -0,0 +1,26 @@
+/*
+* Copyright (c) 2015 MediaTek Inc.
+* Author: Tiffany Lin <tiffany.lin@mediatek.com>
+*
+* This program is free software; you can redistribute it and/or modify
+* it under the terms of the GNU General Public License version 2 as
+* published by the Free Software Foundation.
+*
+* This program is distributed in the hope that it will be useful,
+* but WITHOUT ANY WARRANTY; without even the implied warranty of
+* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+* GNU General Public License for more details.
+*/
+
+#ifndef _MTK_VCODEC_PM_H_
+#define _MTK_VCODEC_PM_H_
+
+#include "mtk_vcodec_drv.h"
+
+int mtk_vcodec_init_enc_pm(struct mtk_vcodec_dev *dev);
+void mtk_vcodec_release_enc_pm(struct mtk_vcodec_dev *dev);
+
+void mtk_vcodec_enc_clock_on(void);
+void mtk_vcodec_enc_clock_off(void);
+
+#endif /* _MTK_VCODEC_PM_H_ */
diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_util.c b/drivers/media/platform/mtk-vcodec/mtk_vcodec_util.c
new file mode 100644
index 0000000..5b6943c
--- /dev/null
+++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_util.c
@@ -0,0 +1,106 @@
+/*
+* Copyright (c) 2015 MediaTek Inc.
+* Author: PC Chen <pc.chen@mediatek.com>
+*         Tiffany Lin <tiffany.lin@mediatek.com>
+*
+* This program is free software; you can redistribute it and/or modify
+* it under the terms of the GNU General Public License version 2 as
+* published by the Free Software Foundation.
+*
+* This program is distributed in the hope that it will be useful,
+* but WITHOUT ANY WARRANTY; without even the implied warranty of
+* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+* GNU General Public License for more details.
+*/
+
+#include <linux/module.h>
+
+#include "mtk_vcodec_drv.h"
+#include "mtk_vcodec_util.h"
+#include "mtk_vpu_core.h"
+
+bool mtk_vcodec_dbg = false;
+int mtk_v4l2_dbg_level = 0;
+
+module_param(mtk_v4l2_dbg_level, int, S_IRUGO | S_IWUSR);
+module_param(mtk_vcodec_dbg, bool, S_IRUGO | S_IWUSR);
+
+void __iomem *mtk_vcodec_get_reg_addr(void *data, unsigned int reg_idx)
+{
+	struct mtk_vcodec_ctx *ctx = (struct mtk_vcodec_ctx *)data;
+
+	if (!data || reg_idx >= NUM_MAX_VCODEC_REG_BASE) {
+		mtk_v4l2_err("Invalid arguments");
+		return NULL;
+	}
+	return ctx->dev->reg_base[reg_idx];
+}
+
+int mtk_vcodec_mem_alloc(void *data, struct mtk_vcodec_mem *mem)
+{
+	unsigned long size = mem->size;
+	struct mtk_vcodec_ctx *ctx = (struct mtk_vcodec_ctx *)data;
+	struct device *dev = &ctx->dev->plat_dev->dev;
+
+	mem->va = dma_alloc_coherent(dev, size, &mem->dma_addr, GFP_KERNEL);
+
+	if (!mem->va) {
+		mtk_v4l2_err("%s dma_alloc size=%ld failed!", dev_name(dev),
+			       size);
+		return -ENOMEM;
+	}
+
+	memset(mem->va, 0, size);
+
+	mtk_v4l2_debug(4, "[%d]  - va      = %p", ctx->idx, mem->va);
+	mtk_v4l2_debug(4, "[%d]  - dma     = 0x%lx", ctx->idx,
+			 (unsigned long)mem->dma_addr);
+	mtk_v4l2_debug(4, "[%d]    size = 0x%lx", ctx->idx, size);
+
+	return 0;
+}
+
+void mtk_vcodec_mem_free(void *data, struct mtk_vcodec_mem *mem)
+{
+	unsigned long size = mem->size;
+	struct mtk_vcodec_ctx *ctx = (struct mtk_vcodec_ctx *)data;
+	struct device *dev = &ctx->dev->plat_dev->dev;
+
+	dma_free_coherent(dev, size, mem->va, mem->dma_addr);
+	mem->va = NULL;
+
+	mtk_v4l2_debug(4, "[%d]  - va      = %p", ctx->idx, mem->va);
+	mtk_v4l2_debug(4, "[%d]  - dma     = 0x%lx", ctx->idx,
+			 (unsigned long)mem->dma_addr);
+	mtk_v4l2_debug(4, "[%d]    size = 0x%lx", ctx->idx, size);
+}
+
+int mtk_vcodec_get_ctx_id(void *data)
+{
+	struct mtk_vcodec_ctx *ctx = (struct mtk_vcodec_ctx *)data;
+
+	if (!ctx)
+		return -1;
+
+	return ctx->idx;
+}
+
+struct platform_device *mtk_vcodec_get_plat_dev(void *data)
+{
+	struct mtk_vcodec_ctx *ctx = (struct mtk_vcodec_ctx *)data;
+
+	if (!ctx)
+		return NULL;
+
+	return vpu_get_plat_device(ctx->dev->plat_dev);
+}
+
+void mtk_vcodec_fmt2str(u32 fmt, char *str)
+{
+	char a = fmt & 0xFF;
+	char b = (fmt >> 8) & 0xFF;
+	char c = (fmt >> 16) & 0xFF;
+	char d = (fmt >> 24) & 0xFF;
+
+	sprintf(str, "%c%c%c%c", a, b, c, d);
+}
diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_util.h b/drivers/media/platform/mtk-vcodec/mtk_vcodec_util.h
new file mode 100644
index 0000000..a8e683a
--- /dev/null
+++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_util.h
@@ -0,0 +1,66 @@
+/*
+* Copyright (c) 2015 MediaTek Inc.
+* Author: PC Chen <pc.chen@mediatek.com>
+*         Tiffany Lin <tiffany.lin@mediatek.com>
+*
+* This program is free software; you can redistribute it and/or modify
+* it under the terms of the GNU General Public License version 2 as
+* published by the Free Software Foundation.
+*
+* This program is distributed in the hope that it will be useful,
+* but WITHOUT ANY WARRANTY; without even the implied warranty of
+* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+* GNU General Public License for more details.
+*/
+
+#ifndef _MTK_VCODEC_UTIL_H_
+#define _MTK_VCODEC_UTIL_H_
+
+#include <linux/types.h>
+#include <linux/dma-direction.h>
+
+struct mtk_vcodec_mem {
+	size_t size;
+	void *va;
+	dma_addr_t dma_addr;
+};
+
+extern int mtk_v4l2_dbg_level;
+extern bool mtk_vcodec_dbg;
+
+#define mtk_v4l2_debug(level, fmt, args...)				 \
+	do {								 \
+		if (mtk_v4l2_dbg_level >= level)			 \
+			pr_info("[MTK_V4L2] level=%d %s(),%d: " fmt "\n",\
+				level, __func__, __LINE__, ##args);	 \
+	} while (0)
+
+#define mtk_v4l2_err(fmt, args...)                \
+	pr_err("[MTK_V4L2][ERROR] %s:%d: " fmt "\n", __func__, __LINE__, \
+	       ##args)
+
+#define mtk_v4l2_debug_enter()  mtk_v4l2_debug(5, "+\n")
+#define mtk_v4l2_debug_leave()  mtk_v4l2_debug(5, "-\n")
+
+#define mtk_vcodec_debug(h, fmt, args...)				\
+	do {								\
+		if (mtk_vcodec_dbg)					\
+			pr_info("[MTK_VCODEC][%d]: %s() " fmt "\n",	\
+				((struct mtk_vcodec_ctx *)h->ctx)->idx, \
+				__func__, ##args);			\
+	} while (0)
+
+#define mtk_vcodec_err(h, fmt, args...)					\
+	pr_err("[MTK_VCODEC][ERROR][%d]: %s() " fmt "\n",		\
+	       ((struct mtk_vcodec_ctx *)h->ctx)->idx, __func__, ##args)
+
+#define mtk_vcodec_debug_enter(h)  mtk_vcodec_debug(h, "+\n")
+#define mtk_vcodec_debug_leave(h)  mtk_vcodec_debug(h, "-\n")
+
+void __iomem *mtk_vcodec_get_reg_addr(void *data, unsigned int reg_idx);
+int mtk_vcodec_mem_alloc(void *data, struct mtk_vcodec_mem *mem);
+void mtk_vcodec_mem_free(void *data, struct mtk_vcodec_mem *mem);
+int mtk_vcodec_get_ctx_id(void *data);
+struct platform_device *mtk_vcodec_get_plat_dev(void *data);
+void mtk_vcodec_fmt2str(u32 fmt, char *str);
+#endif /* _MTK_VCODEC_UTIL_H_ */
-- 
1.7.9.5

