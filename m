Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:21642 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761234Ab3DBQGC (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Apr 2013 12:06:02 -0400
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: yhwan.joo@samsung.com, kyungmin.park@samsung.com,
	kgene.kim@samsung.com, myungjoo.ham@samsung.com,
	dh09.lee@samsung.com, linux-samsung-soc@vger.kernel.org,
	devicetree-discuss@lists.ozlabs.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH v4 1/7] exynos4-is: Add Exynos4x12 FIMC-IS driver
Date: Tue, 02 Apr 2013 18:03:33 +0200
Message-id: <1364918619-9118-2-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1364918619-9118-1-git-send-email-s.nawrocki@samsung.com>
References: <1364918619-9118-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds a set of core files of the Exynos4x12 FIMC-IS
V4L2 driver. This includes main functionality like allocating
memory, loading the firmware, FIMC-IS register interface and
host CPU <-> IS command and error code definitions.

The driver currently exposes a single subdev named FIMC-IS-ISP,
which corresponds to the FIMC-IS ISP and DRC IP blocks.

The FIMC-IS-ISP subdev currently supports only a subset of user
controls. For other controls we need several extensions at the
V4L2 API. The supported standard controls are:
brightness, contrast, saturation, hue, sharpness, 3a_lock,
exposure_time_absolute, white_balance_auto_preset,
iso_sensitivity, iso_sensitivity_auto, exposure_metering_mode.

Signed-off-by: Younghwan Joo <yhwan.joo@samsung.com>
Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---

Changes since v3:
 - dropped unused headers,  comments cleanup.
---
 .../media/platform/exynos4-is/fimc-is-command.h    |  147 +++
 drivers/media/platform/exynos4-is/fimc-is-errno.c  |  272 ++++++
 drivers/media/platform/exynos4-is/fimc-is-errno.h  |  248 +++++
 drivers/media/platform/exynos4-is/fimc-is-regs.c   |  242 +++++
 drivers/media/platform/exynos4-is/fimc-is-regs.h   |  164 ++++
 drivers/media/platform/exynos4-is/fimc-is.c        | 1009 ++++++++++++++++++++
 drivers/media/platform/exynos4-is/fimc-is.h        |  345 +++++++
 drivers/media/platform/exynos4-is/fimc-isp.c       |  702 ++++++++++++++
 drivers/media/platform/exynos4-is/fimc-isp.h       |  181 ++++
 9 files changed, 3310 insertions(+)
 create mode 100644 drivers/media/platform/exynos4-is/fimc-is-command.h
 create mode 100644 drivers/media/platform/exynos4-is/fimc-is-errno.c
 create mode 100644 drivers/media/platform/exynos4-is/fimc-is-errno.h
 create mode 100644 drivers/media/platform/exynos4-is/fimc-is-regs.c
 create mode 100644 drivers/media/platform/exynos4-is/fimc-is-regs.h
 create mode 100644 drivers/media/platform/exynos4-is/fimc-is.c
 create mode 100644 drivers/media/platform/exynos4-is/fimc-is.h
 create mode 100644 drivers/media/platform/exynos4-is/fimc-isp.c
 create mode 100644 drivers/media/platform/exynos4-is/fimc-isp.h

diff --git a/drivers/media/platform/exynos4-is/fimc-is-command.h b/drivers/media/platform/exynos4-is/fimc-is-command.h
new file mode 100644
index 0000000..e3a1f4e
--- /dev/null
+++ b/drivers/media/platform/exynos4-is/fimc-is-command.h
@@ -0,0 +1,147 @@
+/*
+ * Samsung Exynos4x12 FIMC-IS (Imaging Subsystem) driver
+ *
+ * FIMC-IS command set definitions
+ *
+ * Copyright (C) 2013 Samsung Electronics Co., Ltd.
+ *
+ * Authors: Younghwan Joo <yhwan.joo@samsung.com>
+ *          Sylwester Nawrocki <s.nawrocki@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef FIMC_IS_CMD_H_
+#define FIMC_IS_CMD_H_
+
+#define FIMC_IS_COMMAND_VER 110	/* FIMC-IS command set version 1.10 */
+
+/* Enumeration of commands beetween the FIMC-IS and the host processor. */
+
+/* HOST to FIMC-IS */
+#define FIMC_IS_HIC_PREVIEW_STILL	0x0001
+#define FIMC_IS_HIC_PREVIEW_VIDEO	0x0002
+#define FIMC_IS_HIC_CAPTURE_STILL	0x0003
+#define FIMC_IS_HIC_CAPTURE_VIDEO	0x0004
+#define FIMC_IS_HIC_STREAM_ON		0x0005
+#define FIMC_IS_HIC_STREAM_OFF		0x0006
+#define FIMC_IS_HIC_SET_PARAMETER	0x0007
+#define FIMC_IS_HIC_GET_PARAMETER	0x0008
+#define FIMC_IS_HIC_SET_TUNE		0x0009
+#define FIMC_IS_HIC_GET_STATUS		0x000b
+/* Sensor part */
+#define FIMC_IS_HIC_OPEN_SENSOR		0x000c
+#define FIMC_IS_HIC_CLOSE_SENSOR	0x000d
+#define FIMC_IS_HIC_SIMMIAN_INIT	0x000e
+#define FIMC_IS_HIC_SIMMIAN_WRITE	0x000f
+#define FIMC_IS_HIC_SIMMIAN_READ	0x0010
+#define FIMC_IS_HIC_POWER_DOWN		0x0011
+#define FIMC_IS_HIC_GET_SET_FILE_ADDR	0x0012
+#define FIMC_IS_HIC_LOAD_SET_FILE	0x0013
+#define FIMC_IS_HIC_MSG_CONFIG		0x0014
+#define FIMC_IS_HIC_MSG_TEST		0x0015
+/* FIMC-IS to HOST */
+#define FIMC_IS_IHC_GET_SENSOR_NUM	0x1000
+#define FIMC_IS_IHC_SET_SHOT_MARK	0x1001
+/* parameter1: frame number */
+/* parameter2: confidence level (smile 0~100) */
+/* parameter3: confidence level (blink 0~100) */
+#define FIMC_IS_IHC_SET_FACE_MARK	0x1002
+/* parameter1: coordinate count */
+/* parameter2: coordinate buffer address */
+#define FIMC_IS_IHC_FRAME_DONE		0x1003
+/* parameter1: frame start number */
+/* parameter2: frame count */
+#define FIMC_IS_IHC_AA_DONE		0x1004
+#define FIMC_IS_IHC_NOT_READY		0x1005
+
+#define FIMC_IS_REPLY_DONE		0x2000
+#define FIMC_IS_REPLY_NOT_DONE		0x2001
+
+enum fimc_is_scenario {
+	IS_SC_PREVIEW_STILL,
+	IS_SC_PREVIEW_VIDEO,
+	IS_SC_CAPTURE_STILL,
+	IS_SC_CAPTURE_VIDEO,
+	IS_SC_MAX
+};
+
+enum fimc_is_sub_scenario {
+	IS_SC_SUB_DEFAULT,
+	IS_SC_SUB_PS_VTCALL,
+	IS_SC_SUB_CS_VTCALL,
+	IS_SC_SUB_PV_VTCALL,
+	IS_SC_SUB_CV_VTCALL,
+};
+
+struct fimc_is_capability {
+	u32 support_af;
+	u32 iso_gain;
+	u32 aperture;
+	u32 min_exposure;
+	u32 max_exposure;
+	u32 min_gain;
+	u32 max_gain;
+} __packed;
+
+struct is_common_reg {
+	u32 hicmd;
+	u32 hic_sensorid;
+	u32 hic_param[4];
+	u32 reserved1[4];
+
+	u32 ihcmd;
+	u32 ihc_sensorid;
+	u32 ihc_param[4];
+	u32 reserved2[4];
+
+	u32 isp_sensor_id;
+	u32 isp_param[2];
+	u32 reserved3[1];
+
+	u32 scc_sensor_id;
+	u32 scc_param[2];
+	u32 reserved4[1];
+
+	u32 dnr_sensor_id;
+	u32 dnr_param[2];
+	u32 reserved5[1];
+
+	u32 scp_sensor_id;
+	u32 scp_param[2];
+	u32 reserved6[29];
+} __packed;
+
+struct is_mcuctl_reg {
+	u32 mcuctl;
+	u32 bboar;
+
+	u32 intgr0;
+	u32 intcr0;
+	u32 intmr0;
+	u32 intsr0;
+	u32 intmsr0;
+
+	u32 intgr1;
+	u32 intcr1;
+	u32 intmr1;
+	u32 intsr1;
+	u32 intmsr1;
+
+	u32 intcr2;
+	u32 intmr2;
+	u32 intsr2;
+	u32 intmsr2;
+
+	u32 gpoctrl;
+	u32 cpoenctlr;
+	u32 gpictlr;
+
+	u32 pad[0xd];
+
+	struct is_common_reg common;
+} __packed;
+
+#endif /* FIMC_IS_CMD_H_ */
diff --git a/drivers/media/platform/exynos4-is/fimc-is-errno.c b/drivers/media/platform/exynos4-is/fimc-is-errno.c
new file mode 100644
index 0000000..e8519e1
--- /dev/null
+++ b/drivers/media/platform/exynos4-is/fimc-is-errno.c
@@ -0,0 +1,272 @@
+/*
+ * Samsung Exynos4 SoC series FIMC-IS slave interface driver
+ *
+ * Error log interface functions
+ *
+ * Copyright (C) 2011 - 2013 Samsung Electronics Co., Ltd.
+ *
+ * Authors: Younghwan Joo <yhwan.joo@samsung.com>
+ *          Sylwester Nawrocki <s.nawrocki@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include "fimc-is-errno.h"
+
+const char * const fimc_is_param_strerr(unsigned int error)
+{
+	switch (error) {
+	case ERROR_COMMON_CMD:
+		return "ERROR_COMMON_CMD: Invalid Command";
+	case ERROR_COMMON_PARAMETER:
+		return "ERROR_COMMON_PARAMETER: Invalid Parameter";
+	case ERROR_COMMON_SETFILE_LOAD:
+		return "ERROR_COMMON_SETFILE_LOAD: Illegal Setfile Loading";
+	case ERROR_COMMON_SETFILE_ADJUST:
+		return "ERROR_COMMON_SETFILE_ADJUST: Setfile isn't adjusted";
+	case ERROR_COMMON_SETFILE_INDEX:
+		return "ERROR_COMMON_SETFILE_INDEX: Invalid setfile index";
+	case ERROR_COMMON_INPUT_PATH:
+		return "ERROR_COMMON_INPUT_PATH: Input path can be changed in ready state";
+	case ERROR_COMMON_INPUT_INIT:
+		return "ERROR_COMMON_INPUT_INIT: IP can not start if input path is not set";
+	case ERROR_COMMON_OUTPUT_PATH:
+		return "ERROR_COMMON_OUTPUT_PATH: Output path can be changed in ready state (stop)";
+	case ERROR_COMMON_OUTPUT_INIT:
+		return "ERROR_COMMON_OUTPUT_INIT: IP can not start if output path is not set";
+	case ERROR_CONTROL_BYPASS:
+		return "ERROR_CONTROL_BYPASS";
+	case ERROR_OTF_INPUT_FORMAT:
+		return "ERROR_OTF_INPUT_FORMAT: Invalid format  (DRC: YUV444, FD: YUV444, 422, 420)";
+	case ERROR_OTF_INPUT_WIDTH:
+		return "ERROR_OTF_INPUT_WIDTH: Invalid width (DRC: 128~8192, FD: 32~8190)";
+	case ERROR_OTF_INPUT_HEIGHT:
+		return "ERROR_OTF_INPUT_HEIGHT: Invalid bit-width (DRC: 8~12bits, FD: 8bit)";
+	case ERROR_OTF_INPUT_BIT_WIDTH:
+		return "ERROR_OTF_INPUT_BIT_WIDTH: Invalid bit-width (DRC: 8~12bits, FD: 8bit)";
+	case ERROR_DMA_INPUT_WIDTH:
+		return "ERROR_DMA_INPUT_WIDTH: Invalid width (DRC: 128~8192, FD: 32~8190)";
+	case ERROR_DMA_INPUT_HEIGHT:
+		return "ERROR_DMA_INPUT_HEIGHT: Invalid height (DRC: 64~8192, FD: 16~8190)";
+	case ERROR_DMA_INPUT_FORMAT:
+		return "ERROR_DMA_INPUT_FORMAT: Invalid format (DRC: YUV444 or YUV422, FD: YUV444,422,420)";
+	case ERROR_DMA_INPUT_BIT_WIDTH:
+		return "ERROR_DMA_INPUT_BIT_WIDTH: Invalid bit-width (DRC: 8~12bits, FD: 8bit)";
+	case ERROR_DMA_INPUT_ORDER:
+		return "ERROR_DMA_INPUT_ORDER: Invalid order(DRC: YYCbCr,YCbYCr,FD:NO,YYCbCr,YCbYCr,CbCr,CrCb)";
+	case ERROR_DMA_INPUT_PLANE:
+		return "ERROR_DMA_INPUT_PLANE: Invalid palne (DRC: 3, FD: 1, 2, 3)";
+	case ERROR_OTF_OUTPUT_WIDTH:
+		return "ERROR_OTF_OUTPUT_WIDTH: Invalid width (DRC: 128~8192)";
+	case ERROR_OTF_OUTPUT_HEIGHT:
+		return "ERROR_OTF_OUTPUT_HEIGHT: Invalid height (DRC: 64~8192)";
+	case ERROR_OTF_OUTPUT_FORMAT:
+		return "ERROR_OTF_OUTPUT_FORMAT: Invalid format (DRC: YUV444)";
+	case ERROR_OTF_OUTPUT_BIT_WIDTH:
+		return "ERROR_OTF_OUTPUT_BIT_WIDTH: Invalid bit-width (DRC: 8~12bits, FD: 8bit)";
+	case ERROR_DMA_OUTPUT_WIDTH:
+		return "ERROR_DMA_OUTPUT_WIDTH";
+	case ERROR_DMA_OUTPUT_HEIGHT:
+		return "ERROR_DMA_OUTPUT_HEIGHT";
+	case ERROR_DMA_OUTPUT_FORMAT:
+		return "ERROR_DMA_OUTPUT_FORMAT";
+	case ERROR_DMA_OUTPUT_BIT_WIDTH:
+		return "ERROR_DMA_OUTPUT_BIT_WIDTH";
+	case ERROR_DMA_OUTPUT_PLANE:
+		return "ERROR_DMA_OUTPUT_PLANE";
+	case ERROR_DMA_OUTPUT_ORDER:
+		return "ERROR_DMA_OUTPUT_ORDER";
+
+	/* Sensor Error(100~199) */
+	case ERROR_SENSOR_I2C_FAIL:
+		return "ERROR_SENSOR_I2C_FAIL";
+	case ERROR_SENSOR_INVALID_FRAMERATE:
+		return "ERROR_SENSOR_INVALID_FRAMERATE";
+	case ERROR_SENSOR_INVALID_EXPOSURETIME:
+		return "ERROR_SENSOR_INVALID_EXPOSURETIME";
+	case ERROR_SENSOR_INVALID_SIZE:
+		return "ERROR_SENSOR_INVALID_SIZE";
+	case ERROR_SENSOR_INVALID_SETTING:
+		return "ERROR_SENSOR_INVALID_SETTING";
+	case ERROR_SENSOR_ACTURATOR_INIT_FAIL:
+		return "ERROR_SENSOR_ACTURATOR_INIT_FAIL";
+	case ERROR_SENSOR_INVALID_AF_POS:
+		return "ERROR_SENSOR_INVALID_AF_POS";
+	case ERROR_SENSOR_UNSUPPORT_FUNC:
+		return "ERROR_SENSOR_UNSUPPORT_FUNC";
+	case ERROR_SENSOR_UNSUPPORT_PERI:
+		return "ERROR_SENSOR_UNSUPPORT_PERI";
+	case ERROR_SENSOR_UNSUPPORT_AF:
+		return "ERROR_SENSOR_UNSUPPORT_AF";
+
+	/* ISP Error (200~299) */
+	case ERROR_ISP_AF_BUSY:
+		return "ERROR_ISP_AF_BUSY";
+	case ERROR_ISP_AF_INVALID_COMMAND:
+		return "ERROR_ISP_AF_INVALID_COMMAND";
+	case ERROR_ISP_AF_INVALID_MODE:
+		return "ERROR_ISP_AF_INVALID_MODE";
+
+	/* DRC Error (300~399) */
+	/* FD Error  (400~499) */
+	case ERROR_FD_CONFIG_MAX_NUMBER_STATE:
+		return "ERROR_FD_CONFIG_MAX_NUMBER_STATE";
+	case ERROR_FD_CONFIG_MAX_NUMBER_INVALID:
+		return "ERROR_FD_CONFIG_MAX_NUMBER_INVALID";
+	case ERROR_FD_CONFIG_YAW_ANGLE_STATE:
+		return "ERROR_FD_CONFIG_YAW_ANGLE_STATE";
+	case ERROR_FD_CONFIG_YAW_ANGLE_INVALID:
+		return "ERROR_FD_CONFIG_YAW_ANGLE_INVALID\n";
+	case ERROR_FD_CONFIG_ROLL_ANGLE_STATE:
+		return "ERROR_FD_CONFIG_ROLL_ANGLE_STATE";
+	case ERROR_FD_CONFIG_ROLL_ANGLE_INVALID:
+		return "ERROR_FD_CONFIG_ROLL_ANGLE_INVALID";
+	case ERROR_FD_CONFIG_SMILE_MODE_INVALID:
+		return "ERROR_FD_CONFIG_SMILE_MODE_INVALID";
+	case ERROR_FD_CONFIG_BLINK_MODE_INVALID:
+		return "ERROR_FD_CONFIG_BLINK_MODE_INVALID";
+	case ERROR_FD_CONFIG_EYES_DETECT_INVALID:
+		return "ERROR_FD_CONFIG_EYES_DETECT_INVALID";
+	case ERROR_FD_CONFIG_MOUTH_DETECT_INVALID:
+		return "ERROR_FD_CONFIG_MOUTH_DETECT_INVALID";
+	case ERROR_FD_CONFIG_ORIENTATION_STATE:
+		return "ERROR_FD_CONFIG_ORIENTATION_STATE";
+	case ERROR_FD_CONFIG_ORIENTATION_INVALID:
+		return "ERROR_FD_CONFIG_ORIENTATION_INVALID";
+	case ERROR_FD_CONFIG_ORIENTATION_VALUE_INVALID:
+		return "ERROR_FD_CONFIG_ORIENTATION_VALUE_INVALID";
+	case ERROR_FD_RESULT:
+		return "ERROR_FD_RESULT";
+	case ERROR_FD_MODE:
+		return "ERROR_FD_MODE";
+	default:
+		return "Unknown";
+	}
+}
+
+const char * const fimc_is_strerr(unsigned int error)
+{
+	error &= ~IS_ERROR_TIME_OUT_FLAG;
+
+	switch (error) {
+	/* General */
+	case IS_ERROR_INVALID_COMMAND:
+		return "IS_ERROR_INVALID_COMMAND";
+	case IS_ERROR_REQUEST_FAIL:
+		return "IS_ERROR_REQUEST_FAIL";
+	case IS_ERROR_INVALID_SCENARIO:
+		return "IS_ERROR_INVALID_SCENARIO";
+	case IS_ERROR_INVALID_SENSORID:
+		return "IS_ERROR_INVALID_SENSORID";
+	case IS_ERROR_INVALID_MODE_CHANGE:
+		return "IS_ERROR_INVALID_MODE_CHANGE";
+	case IS_ERROR_INVALID_MAGIC_NUMBER:
+		return "IS_ERROR_INVALID_MAGIC_NUMBER";
+	case IS_ERROR_INVALID_SETFILE_HDR:
+		return "IS_ERROR_INVALID_SETFILE_HDR";
+	case IS_ERROR_BUSY:
+		return "IS_ERROR_BUSY";
+	case IS_ERROR_SET_PARAMETER:
+		return "IS_ERROR_SET_PARAMETER";
+	case IS_ERROR_INVALID_PATH:
+		return "IS_ERROR_INVALID_PATH";
+	case IS_ERROR_OPEN_SENSOR_FAIL:
+		return "IS_ERROR_OPEN_SENSOR_FAIL";
+	case IS_ERROR_ENTRY_MSG_THREAD_DOWN:
+		return "IS_ERROR_ENTRY_MSG_THREAD_DOWN";
+	case IS_ERROR_ISP_FRAME_END_NOT_DONE:
+		return "IS_ERROR_ISP_FRAME_END_NOT_DONE";
+	case IS_ERROR_DRC_FRAME_END_NOT_DONE:
+		return "IS_ERROR_DRC_FRAME_END_NOT_DONE";
+	case IS_ERROR_SCALERC_FRAME_END_NOT_DONE:
+		return "IS_ERROR_SCALERC_FRAME_END_NOT_DONE";
+	case IS_ERROR_ODC_FRAME_END_NOT_DONE:
+		return "IS_ERROR_ODC_FRAME_END_NOT_DONE";
+	case IS_ERROR_DIS_FRAME_END_NOT_DONE:
+		return "IS_ERROR_DIS_FRAME_END_NOT_DONE";
+	case IS_ERROR_TDNR_FRAME_END_NOT_DONE:
+		return "IS_ERROR_TDNR_FRAME_END_NOT_DONE";
+	case IS_ERROR_SCALERP_FRAME_END_NOT_DONE:
+		return "IS_ERROR_SCALERP_FRAME_END_NOT_DONE";
+	case IS_ERROR_WAIT_STREAM_OFF_NOT_DONE:
+		return "IS_ERROR_WAIT_STREAM_OFF_NOT_DONE";
+	case IS_ERROR_NO_MSG_IS_RECEIVED:
+		return "IS_ERROR_NO_MSG_IS_RECEIVED";
+	case IS_ERROR_SENSOR_MSG_FAIL:
+		return "IS_ERROR_SENSOR_MSG_FAIL";
+	case IS_ERROR_ISP_MSG_FAIL:
+		return "IS_ERROR_ISP_MSG_FAIL";
+	case IS_ERROR_DRC_MSG_FAIL:
+		return "IS_ERROR_DRC_MSG_FAIL";
+	case IS_ERROR_LHFD_MSG_FAIL:
+		return "IS_ERROR_LHFD_MSG_FAIL";
+	case IS_ERROR_UNKNOWN:
+		return "IS_ERROR_UNKNOWN";
+
+	/* Sensor */
+	case IS_ERROR_SENSOR_PWRDN_FAIL:
+		return "IS_ERROR_SENSOR_PWRDN_FAIL";
+
+	/* ISP */
+	case IS_ERROR_ISP_PWRDN_FAIL:
+		return "IS_ERROR_ISP_PWRDN_FAIL";
+	case IS_ERROR_ISP_MULTIPLE_INPUT:
+		return "IS_ERROR_ISP_MULTIPLE_INPUT";
+	case IS_ERROR_ISP_ABSENT_INPUT:
+		return "IS_ERROR_ISP_ABSENT_INPUT";
+	case IS_ERROR_ISP_ABSENT_OUTPUT:
+		return "IS_ERROR_ISP_ABSENT_OUTPUT";
+	case IS_ERROR_ISP_NONADJACENT_OUTPUT:
+		return "IS_ERROR_ISP_NONADJACENT_OUTPUT";
+	case IS_ERROR_ISP_FORMAT_MISMATCH:
+		return "IS_ERROR_ISP_FORMAT_MISMATCH";
+	case IS_ERROR_ISP_WIDTH_MISMATCH:
+		return "IS_ERROR_ISP_WIDTH_MISMATCH";
+	case IS_ERROR_ISP_HEIGHT_MISMATCH:
+		return "IS_ERROR_ISP_HEIGHT_MISMATCH";
+	case IS_ERROR_ISP_BITWIDTH_MISMATCH:
+		return "IS_ERROR_ISP_BITWIDTH_MISMATCH";
+	case IS_ERROR_ISP_FRAME_END_TIME_OUT:
+		return "IS_ERROR_ISP_FRAME_END_TIME_OUT";
+
+	/* DRC */
+	case IS_ERROR_DRC_PWRDN_FAIL:
+		return "IS_ERROR_DRC_PWRDN_FAIL";
+	case IS_ERROR_DRC_MULTIPLE_INPUT:
+		return "IS_ERROR_DRC_MULTIPLE_INPUT";
+	case IS_ERROR_DRC_ABSENT_INPUT:
+		return "IS_ERROR_DRC_ABSENT_INPUT";
+	case IS_ERROR_DRC_NONADJACENT_INPUT:
+		return "IS_ERROR_DRC_NONADJACENT_INPUT";
+	case IS_ERROR_DRC_ABSENT_OUTPUT:
+		return "IS_ERROR_DRC_ABSENT_OUTPUT";
+	case IS_ERROR_DRC_NONADJACENT_OUTPUT:
+		return "IS_ERROR_DRC_NONADJACENT_OUTPUT";
+	case IS_ERROR_DRC_FORMAT_MISMATCH:
+		return "IS_ERROR_DRC_FORMAT_MISMATCH";
+	case IS_ERROR_DRC_WIDTH_MISMATCH:
+		return "IS_ERROR_DRC_WIDTH_MISMATCH";
+	case IS_ERROR_DRC_HEIGHT_MISMATCH:
+		return "IS_ERROR_DRC_HEIGHT_MISMATCH";
+	case IS_ERROR_DRC_BITWIDTH_MISMATCH:
+		return "IS_ERROR_DRC_BITWIDTH_MISMATCH";
+	case IS_ERROR_DRC_FRAME_END_TIME_OUT:
+		return "IS_ERROR_DRC_FRAME_END_TIME_OUT";
+
+	/* FD */
+	case IS_ERROR_FD_PWRDN_FAIL:
+		return "IS_ERROR_FD_PWRDN_FAIL";
+	case IS_ERROR_FD_MULTIPLE_INPUT:
+		return "IS_ERROR_FD_MULTIPLE_INPUT";
+	case IS_ERROR_FD_ABSENT_INPUT:
+		return "IS_ERROR_FD_ABSENT_INPUT";
+	case IS_ERROR_FD_NONADJACENT_INPUT:
+		return "IS_ERROR_FD_NONADJACENT_INPUT";
+	case IS_ERROR_LHFD_FRAME_END_TIME_OUT:
+		return "IS_ERROR_LHFD_FRAME_END_TIME_OUT";
+	default:
+		return "Unknown";
+	}
+}
diff --git a/drivers/media/platform/exynos4-is/fimc-is-errno.h b/drivers/media/platform/exynos4-is/fimc-is-errno.h
new file mode 100644
index 0000000..3de6f6d
--- /dev/null
+++ b/drivers/media/platform/exynos4-is/fimc-is-errno.h
@@ -0,0 +1,248 @@
+/*
+ * Samsung Exynos4 SoC series FIMC-IS slave interface driver
+ *
+ * FIMC-IS error code definition
+ *
+ * Copyright (C) 2011 - 2013 Samsung Electronics Co., Ltd.
+ *
+ * Authors: Younghwan Joo <yhwan.joo@samsung.com>
+ *          Sylwester Nawrocki <s.nawrocki@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+*/
+
+#ifndef FIMC_IS_ERR_H_
+#define FIMC_IS_ERR_H_
+
+#define IS_ERROR_VER			011 /* IS ERROR VERSION 0.11 */
+
+enum {
+	IS_ERROR_NONE,
+
+	/* General 1 ~ 99 */
+	IS_ERROR_INVALID_COMMAND,
+	IS_ERROR_REQUEST_FAIL,
+	IS_ERROR_INVALID_SCENARIO,
+	IS_ERROR_INVALID_SENSORID,
+	IS_ERROR_INVALID_MODE_CHANGE,
+	IS_ERROR_INVALID_MAGIC_NUMBER,
+	IS_ERROR_INVALID_SETFILE_HDR,
+	IS_ERROR_BUSY,
+	IS_ERROR_SET_PARAMETER,
+	IS_ERROR_INVALID_PATH,
+	IS_ERROR_OPEN_SENSOR_FAIL,
+	IS_ERROR_ENTRY_MSG_THREAD_DOWN,
+	IS_ERROR_ISP_FRAME_END_NOT_DONE,
+	IS_ERROR_DRC_FRAME_END_NOT_DONE,
+	IS_ERROR_SCALERC_FRAME_END_NOT_DONE,
+	IS_ERROR_ODC_FRAME_END_NOT_DONE,
+	IS_ERROR_DIS_FRAME_END_NOT_DONE,
+	IS_ERROR_TDNR_FRAME_END_NOT_DONE,
+	IS_ERROR_SCALERP_FRAME_END_NOT_DONE,
+	IS_ERROR_WAIT_STREAM_OFF_NOT_DONE,
+	IS_ERROR_NO_MSG_IS_RECEIVED,
+	IS_ERROR_SENSOR_MSG_FAIL,
+	IS_ERROR_ISP_MSG_FAIL,
+	IS_ERROR_DRC_MSG_FAIL,
+	IS_ERROR_SCALERC_MSG_FAIL,
+	IS_ERROR_ODC_MSG_FAIL,
+	IS_ERROR_DIS_MSG_FAIL,
+	IS_ERROR_TDNR_MSG_FAIL,
+	IS_ERROR_SCALERP_MSG_FAIL,
+	IS_ERROR_LHFD_MSG_FAIL,
+	IS_ERROR_LHFD_INTERNAL_STOP,
+
+	/* Sensor 100 ~ 199 */
+	IS_ERROR_SENSOR_PWRDN_FAIL	= 100,
+	IS_ERROR_SENSOR_STREAM_ON_FAIL,
+	IS_ERROR_SENSOR_STREAM_OFF_FAIL,
+
+	/* ISP 200 ~ 299 */
+	IS_ERROR_ISP_PWRDN_FAIL		= 200,
+	IS_ERROR_ISP_MULTIPLE_INPUT,
+	IS_ERROR_ISP_ABSENT_INPUT,
+	IS_ERROR_ISP_ABSENT_OUTPUT,
+	IS_ERROR_ISP_NONADJACENT_OUTPUT,
+	IS_ERROR_ISP_FORMAT_MISMATCH,
+	IS_ERROR_ISP_WIDTH_MISMATCH,
+	IS_ERROR_ISP_HEIGHT_MISMATCH,
+	IS_ERROR_ISP_BITWIDTH_MISMATCH,
+	IS_ERROR_ISP_FRAME_END_TIME_OUT,
+
+	/* DRC 300 ~ 399 */
+	IS_ERROR_DRC_PWRDN_FAIL		= 300,
+	IS_ERROR_DRC_MULTIPLE_INPUT,
+	IS_ERROR_DRC_ABSENT_INPUT,
+	IS_ERROR_DRC_NONADJACENT_INPUT,
+	IS_ERROR_DRC_ABSENT_OUTPUT,
+	IS_ERROR_DRC_NONADJACENT_OUTPUT,
+	IS_ERROR_DRC_FORMAT_MISMATCH,
+	IS_ERROR_DRC_WIDTH_MISMATCH,
+	IS_ERROR_DRC_HEIGHT_MISMATCH,
+	IS_ERROR_DRC_BITWIDTH_MISMATCH,
+	IS_ERROR_DRC_FRAME_END_TIME_OUT,
+
+	/* SCALERC 400 ~ 499 */
+	IS_ERROR_SCALERC_PWRDN_FAIL	= 400,
+
+	/* ODC 500 ~ 599 */
+	IS_ERROR_ODC_PWRDN_FAIL		= 500,
+
+	/* DIS 600 ~ 699 */
+	IS_ERROR_DIS_PWRDN_FAIL		= 600,
+
+	/* TDNR 700 ~ 799 */
+	IS_ERROR_TDNR_PWRDN_FAIL	= 700,
+
+	/* SCALERC 800 ~ 899 */
+	IS_ERROR_SCALERP_PWRDN_FAIL	= 800,
+
+	/* FD 900 ~ 999 */
+	IS_ERROR_FD_PWRDN_FAIL		= 900,
+	IS_ERROR_FD_MULTIPLE_INPUT,
+	IS_ERROR_FD_ABSENT_INPUT,
+	IS_ERROR_FD_NONADJACENT_INPUT,
+	IS_ERROR_LHFD_FRAME_END_TIME_OUT,
+
+	IS_ERROR_UNKNOWN		= 1000,
+};
+
+#define IS_ERROR_TIME_OUT_FLAG	0x80000000
+
+/* Set parameter error enum */
+enum fimc_is_error {
+	/* Common error (0~99) */
+	ERROR_COMMON_NONE		= 0,
+	ERROR_COMMON_CMD		= 1,	/* Invalid command */
+	ERROR_COMMON_PARAMETER		= 2,	/* Invalid parameter */
+	/* setfile is not loaded before adjusting */
+	ERROR_COMMON_SETFILE_LOAD	= 3,
+	/* setfile is not Adjusted before runnng. */
+	ERROR_COMMON_SETFILE_ADJUST	= 4,
+	/* Index of setfile is not valid (0~MAX_SETFILE_NUM-1) */
+	ERROR_COMMON_SETFILE_INDEX	= 5,
+	/* Input path can be changed in ready state(stop) */
+	ERROR_COMMON_INPUT_PATH		= 6,
+	/* IP can not start if input path is not set */
+	ERROR_COMMON_INPUT_INIT		= 7,
+	/* Output path can be changed in ready state (stop) */
+	ERROR_COMMON_OUTPUT_PATH	= 8,
+	/* IP can not start if output path is not set */
+	ERROR_COMMON_OUTPUT_INIT	= 9,
+
+	ERROR_CONTROL_NONE		= ERROR_COMMON_NONE,
+	ERROR_CONTROL_BYPASS		= 11,	/* Enable or Disable */
+
+	ERROR_OTF_INPUT_NONE		= ERROR_COMMON_NONE,
+	ERROR_OTF_INPUT_CMD		= 21,
+	/* invalid format  (DRC: YUV444, FD: YUV444, 422, 420) */
+	ERROR_OTF_INPUT_FORMAT		= 22,
+	/* invalid width (DRC: 128~8192, FD: 32~8190) */
+	ERROR_OTF_INPUT_WIDTH		= 23,
+	/* invalid height (DRC: 64~8192, FD: 16~8190) */
+	ERROR_OTF_INPUT_HEIGHT		= 24,
+	/* invalid bit-width (DRC: 8~12bits, FD: 8bit) */
+	ERROR_OTF_INPUT_BIT_WIDTH	= 25,
+	/* invalid FrameTime for ISP */
+	ERROR_OTF_INPUT_USER_FRAMETIIME	= 26,
+
+	ERROR_DMA_INPUT_NONE		= ERROR_COMMON_NONE,
+	/* invalid width (DRC: 128~8192, FD: 32~8190) */
+	ERROR_DMA_INPUT_WIDTH		= 31,
+	/* invalid height (DRC: 64~8192, FD: 16~8190) */
+	ERROR_DMA_INPUT_HEIGHT		= 32,
+	/* invalid format (DRC: YUV444 or YUV422, FD: YUV444, 422, 420) */
+	ERROR_DMA_INPUT_FORMAT		= 33,
+	/* invalid bit-width (DRC: 8~12bit, FD: 8bit) */
+	ERROR_DMA_INPUT_BIT_WIDTH	= 34,
+	/* invalid order(DRC: YYCbCrorYCbYCr, FD:NO,YYCbCr,YCbYCr,CbCr,CrCb) */
+	ERROR_DMA_INPUT_ORDER		= 35,
+	/* invalid palne (DRC: 3, FD: 1, 2, 3) */
+	ERROR_DMA_INPUT_PLANE		= 36,
+
+	ERROR_OTF_OUTPUT_NONE		= ERROR_COMMON_NONE,
+	/* invalid width (DRC: 128~8192) */
+	ERROR_OTF_OUTPUT_WIDTH		= 41,
+	/* invalid height (DRC: 64~8192) */
+	ERROR_OTF_OUTPUT_HEIGHT		= 42,
+	/* invalid format (DRC: YUV444) */
+	ERROR_OTF_OUTPUT_FORMAT		= 43,
+	/* invalid bit-width (DRC: 8~12bits) */
+	ERROR_OTF_OUTPUT_BIT_WIDTH	= 44,
+
+	ERROR_DMA_OUTPUT_NONE		= ERROR_COMMON_NONE,
+	ERROR_DMA_OUTPUT_WIDTH		= 51,	/* invalid width */
+	ERROR_DMA_OUTPUT_HEIGHT		= 52,	/* invalid height */
+	ERROR_DMA_OUTPUT_FORMAT		= 53,	/* invalid format */
+	ERROR_DMA_OUTPUT_BIT_WIDTH	= 54,	/* invalid bit-width */
+	ERROR_DMA_OUTPUT_PLANE		= 55,	/* invalid plane */
+	ERROR_DMA_OUTPUT_ORDER		= 56,	/* invalid order */
+
+	ERROR_GLOBAL_SHOTMODE_NONE	= ERROR_COMMON_NONE,
+
+	/* SENSOR Error(100~199) */
+	ERROR_SENSOR_NONE		= ERROR_COMMON_NONE,
+	ERROR_SENSOR_I2C_FAIL		= 101,
+	ERROR_SENSOR_INVALID_FRAMERATE,
+	ERROR_SENSOR_INVALID_EXPOSURETIME,
+	ERROR_SENSOR_INVALID_SIZE,
+	ERROR_SENSOR_INVALID_SETTING,
+	ERROR_SENSOR_ACTURATOR_INIT_FAIL,
+	ERROR_SENSOR_INVALID_AF_POS,
+	ERROR_SENSOR_UNSUPPORT_FUNC,
+	ERROR_SENSOR_UNSUPPORT_PERI,
+	ERROR_SENSOR_UNSUPPORT_AF,
+
+	/* ISP Error (200~299) */
+	ERROR_ISP_AF_NONE		= ERROR_COMMON_NONE,
+	ERROR_ISP_AF_BUSY		= 201,
+	ERROR_ISP_AF_INVALID_COMMAND	= 202,
+	ERROR_ISP_AF_INVALID_MODE	= 203,
+	ERROR_ISP_FLASH_NONE		= ERROR_COMMON_NONE,
+	ERROR_ISP_AWB_NONE		= ERROR_COMMON_NONE,
+	ERROR_ISP_IMAGE_EFFECT_NONE	= ERROR_COMMON_NONE,
+	ERROR_ISP_ISO_NONE		= ERROR_COMMON_NONE,
+	ERROR_ISP_ADJUST_NONE		= ERROR_COMMON_NONE,
+	ERROR_ISP_METERING_NONE		= ERROR_COMMON_NONE,
+	ERROR_ISP_AFC_NONE		= ERROR_COMMON_NONE,
+
+	/* DRC Error (300~399) */
+
+	/* FD Error  (400~499) */
+	ERROR_FD_NONE					= ERROR_COMMON_NONE,
+	/* Invalid max number (1~16) */
+	ERROR_FD_CONFIG_MAX_NUMBER_STATE		= 401,
+	ERROR_FD_CONFIG_MAX_NUMBER_INVALID		= 402,
+	ERROR_FD_CONFIG_YAW_ANGLE_STATE			= 403,
+	ERROR_FD_CONFIG_YAW_ANGLE_INVALID		= 404,
+	ERROR_FD_CONFIG_ROLL_ANGLE_STATE		= 405,
+	ERROR_FD_CONFIG_ROLL_ANGLE_INVALID		= 406,
+	ERROR_FD_CONFIG_SMILE_MODE_INVALID		= 407,
+	ERROR_FD_CONFIG_BLINK_MODE_INVALID		= 408,
+	ERROR_FD_CONFIG_EYES_DETECT_INVALID		= 409,
+	ERROR_FD_CONFIG_MOUTH_DETECT_INVALID		= 410,
+	ERROR_FD_CONFIG_ORIENTATION_STATE		= 411,
+	ERROR_FD_CONFIG_ORIENTATION_INVALID		= 412,
+	ERROR_FD_CONFIG_ORIENTATION_VALUE_INVALID	= 413,
+	/* PARAM_FdResultStr can be only applied in ready-state or stream off */
+	ERROR_FD_RESULT					= 414,
+	/* PARAM_FdModeStr can be only applied in ready-state or stream off */
+	ERROR_FD_MODE					= 415,
+	/* Scaler Error  (500 ~ 599) */
+	ERROR_SCALER_NO_NONE				= ERROR_COMMON_NONE,
+	ERROR_SCALER_DMA_OUTSEL				= 501,
+	ERROR_SCALER_H_RATIO				= 502,
+	ERROR_SCALER_V_RATIO				= 503,
+
+	ERROR_SCALER_IMAGE_EFFECT			= 510,
+
+	ERROR_SCALER_ROTATE				= 520,
+	ERROR_SCALER_FLIP				= 521,
+};
+
+const char * const fimc_is_strerr(unsigned int error);
+const char * const fimc_is_param_strerr(unsigned int error);
+
+#endif /* FIMC_IS_ERR_H_ */
diff --git a/drivers/media/platform/exynos4-is/fimc-is-regs.c b/drivers/media/platform/exynos4-is/fimc-is-regs.c
new file mode 100644
index 0000000..53f0250
--- /dev/null
+++ b/drivers/media/platform/exynos4-is/fimc-is-regs.c
@@ -0,0 +1,242 @@
+/*
+ * Samsung EXYNOS4x12 FIMC-IS (Imaging Subsystem) driver
+ *
+ * Copyright (C) 2012 - 2013 Samsung Electronics Co., Ltd.
+ *
+ * Authors: Younghwan Joo <yhwan.joo@samsung.com>
+ *          Sylwester Nawrocki <s.nawrocki@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <linux/delay.h>
+
+#include "fimc-is.h"
+#include "fimc-is-command.h"
+#include "fimc-is-regs.h"
+#include "fimc-is-sensor.h"
+
+void fimc_is_fw_clear_irq1(struct fimc_is *is, unsigned int nr)
+{
+	mcuctl_write(1UL << nr, is, MCUCTL_REG_INTCR1);
+}
+
+void fimc_is_fw_clear_irq2(struct fimc_is *is)
+{
+	u32 cfg = mcuctl_read(is, MCUCTL_REG_INTSR2);
+	mcuctl_write(cfg, is, MCUCTL_REG_INTCR2);
+}
+
+void fimc_is_hw_set_intgr0_gd0(struct fimc_is *is)
+{
+	mcuctl_write(INTGR0_INTGD(0), is, MCUCTL_REG_INTGR0);
+}
+
+int fimc_is_hw_wait_intsr0_intsd0(struct fimc_is *is)
+{
+	unsigned int timeout = 2000;
+	u32 cfg, status;
+
+	cfg = mcuctl_read(is, MCUCTL_REG_INTSR0);
+	status = INTSR0_GET_INTSD(0, cfg);
+
+	while (status) {
+		cfg = mcuctl_read(is, MCUCTL_REG_INTSR0);
+		status = INTSR0_GET_INTSD(0, cfg);
+		if (timeout == 0) {
+			dev_warn(&is->pdev->dev, "%s timeout\n",
+				 __func__);
+			return -ETIME;
+		}
+		timeout--;
+		udelay(1);
+	}
+	return 0;
+}
+
+int fimc_is_hw_wait_intmsr0_intmsd0(struct fimc_is *is)
+{
+	unsigned int timeout = 2000;
+	u32 cfg, status;
+
+	cfg = mcuctl_read(is, MCUCTL_REG_INTMSR0);
+	status = INTMSR0_GET_INTMSD(0, cfg);
+
+	while (status) {
+		cfg = mcuctl_read(is, MCUCTL_REG_INTMSR0);
+		status = INTMSR0_GET_INTMSD(0, cfg);
+		if (timeout == 0) {
+			dev_warn(&is->pdev->dev, "%s timeout\n",
+				 __func__);
+			return -ETIME;
+		}
+		timeout--;
+		udelay(1);
+	}
+	return 0;
+}
+
+int fimc_is_hw_set_param(struct fimc_is *is)
+{
+	struct is_config_param *cfg = &is->cfg_param[is->scenario_id];
+
+	fimc_is_hw_wait_intmsr0_intmsd0(is);
+
+	mcuctl_write(FIMC_IS_HIC_SET_PARAMETER, is, MCUCTL_REG_ISSR(0));
+	mcuctl_write(is->sensor_index, is, MCUCTL_REG_ISSR(1));
+	mcuctl_write(is->scenario_id, is, MCUCTL_REG_ISSR(2));
+
+	mcuctl_write(atomic_read(&cfg->p_region_num), is, MCUCTL_REG_ISSR(3));
+	mcuctl_write(cfg->p_region_index1, is, MCUCTL_REG_ISSR(4));
+	mcuctl_write(cfg->p_region_index2, is, MCUCTL_REG_ISSR(5));
+
+	fimc_is_hw_set_intgr0_gd0(is);
+	return 0;
+}
+
+int fimc_is_hw_set_tune(struct fimc_is *is)
+{
+	fimc_is_hw_wait_intmsr0_intmsd0(is);
+
+	mcuctl_write(FIMC_IS_HIC_SET_TUNE, is, MCUCTL_REG_ISSR(0));
+	mcuctl_write(is->sensor_index, is, MCUCTL_REG_ISSR(1));
+	mcuctl_write(is->h2i_cmd.entry_id, is, MCUCTL_REG_ISSR(2));
+
+	fimc_is_hw_set_intgr0_gd0(is);
+	return 0;
+}
+
+#define FIMC_IS_MAX_PARAMS	4
+
+int fimc_is_hw_get_params(struct fimc_is *is, unsigned int num_args)
+{
+	int i;
+
+	if (num_args > FIMC_IS_MAX_PARAMS)
+		return -EINVAL;
+
+	is->i2h_cmd.num_args = num_args;
+
+	for (i = 0; i < FIMC_IS_MAX_PARAMS; i++) {
+		if (i < num_args)
+			is->i2h_cmd.args[i] = mcuctl_read(is,
+					MCUCTL_REG_ISSR(12 + i));
+		else
+			is->i2h_cmd.args[i] = 0;
+	}
+	return 0;
+}
+
+void fimc_is_hw_set_sensor_num(struct fimc_is *is)
+{
+	pr_debug("setting sensor index to: %d\n", is->sensor_index);
+
+	mcuctl_write(FIMC_IS_REPLY_DONE, is, MCUCTL_REG_ISSR(0));
+	mcuctl_write(is->sensor_index, is, MCUCTL_REG_ISSR(1));
+	mcuctl_write(FIMC_IS_IHC_GET_SENSOR_NUM, is, MCUCTL_REG_ISSR(2));
+	mcuctl_write(FIMC_IS_SENSOR_NUM, is, MCUCTL_REG_ISSR(3));
+}
+
+void fimc_is_hw_close_sensor(struct fimc_is *is, unsigned int index)
+{
+	if (is->sensor_index != index)
+		return;
+
+	fimc_is_hw_wait_intmsr0_intmsd0(is);
+	mcuctl_write(FIMC_IS_HIC_CLOSE_SENSOR, is, MCUCTL_REG_ISSR(0));
+	mcuctl_write(is->sensor_index, is, MCUCTL_REG_ISSR(1));
+	mcuctl_write(is->sensor_index, is, MCUCTL_REG_ISSR(2));
+	fimc_is_hw_set_intgr0_gd0(is);
+}
+
+void fimc_is_hw_get_setfile_addr(struct fimc_is *is)
+{
+	fimc_is_hw_wait_intmsr0_intmsd0(is);
+	mcuctl_write(FIMC_IS_HIC_GET_SET_FILE_ADDR, is, MCUCTL_REG_ISSR(0));
+	mcuctl_write(is->sensor_index, is, MCUCTL_REG_ISSR(1));
+	fimc_is_hw_set_intgr0_gd0(is);
+}
+
+void fimc_is_hw_load_setfile(struct fimc_is *is)
+{
+	fimc_is_hw_wait_intmsr0_intmsd0(is);
+	mcuctl_write(FIMC_IS_HIC_LOAD_SET_FILE, is, MCUCTL_REG_ISSR(0));
+	mcuctl_write(is->sensor_index, is, MCUCTL_REG_ISSR(1));
+	fimc_is_hw_set_intgr0_gd0(is);
+}
+
+int fimc_is_hw_change_mode(struct fimc_is *is)
+{
+	const u8 cmd[] = {
+		FIMC_IS_HIC_PREVIEW_STILL, FIMC_IS_HIC_PREVIEW_VIDEO,
+		FIMC_IS_HIC_CAPTURE_STILL, FIMC_IS_HIC_CAPTURE_VIDEO,
+	};
+
+	if (WARN_ON(is->scenario_id > ARRAY_SIZE(cmd)))
+		return -EINVAL;
+
+	mcuctl_write(cmd[is->scenario_id], is, MCUCTL_REG_ISSR(0));
+	mcuctl_write(is->sensor_index, is, MCUCTL_REG_ISSR(1));
+	mcuctl_write(is->setfile.sub_index, is, MCUCTL_REG_ISSR(2));
+	fimc_is_hw_set_intgr0_gd0(is);
+	return 0;
+}
+
+void fimc_is_hw_stream_on(struct fimc_is *is)
+{
+	fimc_is_hw_wait_intmsr0_intmsd0(is);
+	mcuctl_write(FIMC_IS_HIC_STREAM_ON, is, MCUCTL_REG_ISSR(0));
+	mcuctl_write(is->sensor_index, is, MCUCTL_REG_ISSR(1));
+	mcuctl_write(0, is, MCUCTL_REG_ISSR(2));
+	fimc_is_hw_set_intgr0_gd0(is);
+}
+
+void fimc_is_hw_stream_off(struct fimc_is *is)
+{
+	fimc_is_hw_wait_intmsr0_intmsd0(is);
+	mcuctl_write(FIMC_IS_HIC_STREAM_OFF, is, MCUCTL_REG_ISSR(0));
+	mcuctl_write(is->sensor_index, is, MCUCTL_REG_ISSR(1));
+	fimc_is_hw_set_intgr0_gd0(is);
+}
+
+void fimc_is_hw_subip_power_off(struct fimc_is *is)
+{
+	fimc_is_hw_wait_intmsr0_intmsd0(is);
+	mcuctl_write(FIMC_IS_HIC_POWER_DOWN, is, MCUCTL_REG_ISSR(0));
+	mcuctl_write(is->sensor_index, is, MCUCTL_REG_ISSR(1));
+	fimc_is_hw_set_intgr0_gd0(is);
+}
+
+int fimc_is_itf_s_param(struct fimc_is *is, bool update)
+{
+	int ret;
+
+	if (update)
+		__is_hw_update_params(is);
+
+	fimc_is_mem_barrier();
+
+	clear_bit(IS_ST_BLOCK_CMD_CLEARED, &is->state);
+	fimc_is_hw_set_param(is);
+	ret = fimc_is_wait_event(is, IS_ST_BLOCK_CMD_CLEARED, 1,
+				FIMC_IS_CONFIG_TIMEOUT);
+	if (ret < 0)
+		dev_err(&is->pdev->dev, "%s() timeout\n", __func__);
+
+	return ret;
+}
+
+int fimc_is_itf_mode_change(struct fimc_is *is)
+{
+	int ret;
+
+	clear_bit(IS_ST_CHANGE_MODE, &is->state);
+	fimc_is_hw_change_mode(is);
+	ret = fimc_is_wait_event(is, IS_ST_CHANGE_MODE, 1,
+				FIMC_IS_CONFIG_TIMEOUT);
+	if (!ret < 0)
+		dev_err(&is->pdev->dev, "%s(): mode change (%d) timeout\n",
+			__func__, is->scenario_id);
+	return ret;
+}
diff --git a/drivers/media/platform/exynos4-is/fimc-is-regs.h b/drivers/media/platform/exynos4-is/fimc-is-regs.h
new file mode 100644
index 0000000..5fa2fda
--- /dev/null
+++ b/drivers/media/platform/exynos4-is/fimc-is-regs.h
@@ -0,0 +1,164 @@
+/*
+ * Samsung EXYNOS4x12 FIMC-IS (Imaging Subsystem) driver
+ *
+ * Copyright (C) 2013 Samsung Electronics Co., Ltd.
+ *
+ * Authors: Sylwester Nawrocki <s.nawrocki@samsung.com>
+ *          Younghwan Joo <yhwan.joo@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#ifndef FIMC_IS_REG_H_
+#define FIMC_IS_REG_H_
+
+/* WDT_ISP register */
+#define REG_WDT_ISP			0x00170000
+
+/* MCUCTL registers base offset */
+#define MCUCTL_BASE			0x00180000
+
+/* MCU Controller Register */
+#define MCUCTL_REG_MCUCTRL		(MCUCTL_BASE + 0x00)
+#define MCUCTRL_MSWRST			(1 << 0)
+
+/* Boot Base Offset Address Register */
+#define MCUCTL_REG_BBOAR		(MCUCTL_BASE + 0x04)
+
+/* Interrupt Generation Register 0 from Host CPU to VIC */
+#define MCUCTL_REG_INTGR0		(MCUCTL_BASE + 0x08)
+/* __n = 0...9 */
+#define INTGR0_INTGC(__n)		(1 << ((__n) + 16))
+/* __n = 0...5 */
+#define INTGR0_INTGD(__n)		(1 << (__n))
+
+/* Interrupt Clear Register 0 from Host CPU to VIC */
+#define MCUCTL_REG_INTCR0		(MCUCTL_BASE + 0x0c)
+/* __n = 0...9 */
+#define INTCR0_INTGC(__n)		(1 << ((__n) + 16))
+/* __n = 0...5 */
+#define INTCR0_INTCD(__n)		(1 << ((__n) + 16))
+
+/* Interrupt Mask Register 0 from Host CPU to VIC */
+#define MCUCTL_REG_INTMR0		(MCUCTL_BASE + 0x10)
+/* __n = 0...9 */
+#define INTMR0_INTMC(__n)		(1 << ((__n) + 16))
+/* __n = 0...5 */
+#define INTMR0_INTMD(__n)		(1 << (__n))
+
+/* Interrupt Status Register 0 from Host CPU to VIC */
+#define MCUCTL_REG_INTSR0		(MCUCTL_BASE + 0x14)
+/* __n (bit number) = 0...4 */
+#define INTSR0_GET_INTSD(x, __n)	(((x) >> (__n)) & 0x1)
+/* __n (bit number) = 0...9 */
+#define INTSR0_GET_INTSC(x, __n)	(((x) >> ((__n) + 16)) & 0x1)
+
+/* Interrupt Mask Status Register 0 from Host CPU to VIC */
+#define MCUCTL_REG_INTMSR0		(MCUCTL_BASE + 0x18)
+/* __n (bit number) = 0...4 */
+#define INTMSR0_GET_INTMSD(x, __n)	(((x) >> (__n)) & 0x1)
+/* __n (bit number) = 0...9 */
+#define INTMSR0_GET_INTMSC(x, __n)	(((x) >> ((__n) + 16)) & 0x1)
+
+/* Interrupt Generation Register 1 from ISP CPU to Host IC */
+#define MCUCTL_REG_INTGR1		(MCUCTL_BASE + 0x1c)
+/* __n = 0...9 */
+#define INTGR1_INTGC(__n)		(1 << (__n))
+
+/* Interrupt Clear Register 1 from ISP CPU to Host IC */
+#define MCUCTL_REG_INTCR1		(MCUCTL_BASE + 0x20)
+/* __n = 0...9 */
+#define INTCR1_INTCC(__n)		(1 << (__n))
+
+/* Interrupt Mask Register 1 from ISP CPU to Host IC */
+#define MCUCTL_REG_INTMR1		(MCUCTL_BASE + 0x24)
+/* __n = 0...9 */
+#define INTMR1_INTMC(__n)		(1 << (__n))
+
+/* Interrupt Status Register 1 from ISP CPU to Host IC */
+#define MCUCTL_REG_INTSR1		(MCUCTL_BASE + 0x28)
+/* Interrupt Mask Status Register 1 from ISP CPU to Host IC */
+#define MCUCTL_REG_INTMSR1		(MCUCTL_BASE + 0x2c)
+
+/* Interrupt Clear Register 2 from ISP BLK's interrupts to Host IC */
+#define MCUCTL_REG_INTCR2		(MCUCTL_BASE + 0x30)
+/* __n = 0...5 */
+#define INTCR2_INTCC(__n)		(1 << ((__n) + 16))
+
+/* Interrupt Mask Register 2 from ISP BLK's interrupts to Host IC */
+#define MCUCTL_REG_INTMR2		(MCUCTL_BASE + 0x34)
+/* __n = 0...25 */
+#define INTMR2_INTMCIS(__n)		(1 << (__n))
+
+/* Interrupt Status Register 2 from ISP BLK's interrupts to Host IC */
+#define MCUCTL_REG_INTSR2		(MCUCTL_BASE + 0x38)
+/* Interrupt Mask Status Register 2 from ISP BLK's interrupts to Host IC */
+#define MCUCTL_REG_INTMSR2		(MCUCTL_BASE + 0x3c)
+
+/* General Purpose Output Control Register (0~17) */
+#define MCUCTL_REG_GPOCTLR		(MCUCTL_BASE + 0x40)
+/* __n = 0...17 */
+#define GPOCTLR_GPOG(__n)		(1 << (__n))
+
+/* General Purpose Pad Output Enable Register (0~17) */
+#define MCUCTL_REG_GPOENCTLR		(MCUCTL_BASE + 0x44)
+/* __n = 0...17 */
+#define GPOENCTLR_GPOEN(__n)		(1 << (__n))
+
+/* General Purpose Input Control Register (0~17) */
+#define MCUCTL_REG_GPICTLR		(MCUCTL_BASE + 0x48)
+
+/* Shared registers between ISP CPU and the host CPU - ISSRxx */
+
+/* ISSR(1): Command Host -> IS */
+/* ISSR(1): Sensor ID for Command, ISSR2...5 = Parameter 1...4 */
+
+/* ISSR(10): Reply IS -> Host */
+/* ISSR(11): Sensor ID for Reply, ISSR12...15 = Parameter 1...4 */
+
+/* ISSR(20): ISP_FRAME_DONE : SENSOR ID */
+/* ISSR(21): ISP_FRAME_DONE : PARAMETER 1 */
+
+/* ISSR(24): SCALERC_FRAME_DONE : SENSOR ID */
+/* ISSR(25): SCALERC_FRAME_DONE : PARAMETER 1 */
+
+/* ISSR(28): 3DNR_FRAME_DONE : SENSOR ID */
+/* ISSR(29): 3DNR_FRAME_DONE : PARAMETER 1 */
+
+/* ISSR(32): SCALERP_FRAME_DONE : SENSOR ID */
+/* ISSR(33): SCALERP_FRAME_DONE : PARAMETER 1 */
+
+/* __n = 0...63 */
+#define MCUCTL_REG_ISSR(__n)		(MCUCTL_BASE + 0x80 + ((__n) * 4))
+
+/* PMU ISP register offsets */
+#define REG_CMU_RESET_ISP_SYS_PWR_REG	0x1174
+#define REG_CMU_SYSCLK_ISP_SYS_PWR_REG	0x13b8
+#define REG_PMU_ISP_ARM_SYS		0x1050
+#define REG_PMU_ISP_ARM_CONFIGURATION	0x2280
+#define REG_PMU_ISP_ARM_STATUS		0x2284
+#define REG_PMU_ISP_ARM_OPTION		0x2288
+
+void fimc_is_fw_clear_irq1(struct fimc_is *is, unsigned int bit);
+void fimc_is_fw_clear_irq2(struct fimc_is *is);
+int fimc_is_hw_get_params(struct fimc_is *is, unsigned int num);
+
+void fimc_is_hw_set_intgr0_gd0(struct fimc_is *is);
+int fimc_is_hw_wait_intsr0_intsd0(struct fimc_is *is);
+int fimc_is_hw_wait_intmsr0_intmsd0(struct fimc_is *is);
+void fimc_is_hw_set_sensor_num(struct fimc_is *is);
+void fimc_is_hw_stream_on(struct fimc_is *is);
+void fimc_is_hw_stream_off(struct fimc_is *is);
+int fimc_is_hw_set_param(struct fimc_is *is);
+int fimc_is_hw_change_mode(struct fimc_is *is);
+
+void fimc_is_hw_close_sensor(struct fimc_is *is, unsigned int index);
+void fimc_is_hw_get_setfile_addr(struct fimc_is *is);
+void fimc_is_hw_load_setfile(struct fimc_is *is);
+void fimc_is_hw_subip_power_off(struct fimc_is *is);
+
+int fimc_is_itf_s_param(struct fimc_is *is, bool update);
+int fimc_is_itf_mode_change(struct fimc_is *is);
+
+#endif /* FIMC_IS_REG_H_ */
diff --git a/drivers/media/platform/exynos4-is/fimc-is.c b/drivers/media/platform/exynos4-is/fimc-is.c
new file mode 100644
index 0000000..d9459a2e
--- /dev/null
+++ b/drivers/media/platform/exynos4-is/fimc-is.c
@@ -0,0 +1,1009 @@
+/*
+ * Samsung EXYNOS4x12 FIMC-IS (Imaging Subsystem) driver
+ *
+ * Copyright (C) 2013 Samsung Electronics Co., Ltd.
+ *
+ * Authors: Sylwester Nawrocki <s.nawrocki@samsung.com>
+ *          Younghwan Joo <yhwan.joo@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#define pr_fmt(fmt) "%s:%d " fmt, __func__, __LINE__
+
+#include <linux/device.h>
+#include <linux/debugfs.h>
+#include <linux/delay.h>
+#include <linux/dma-contiguous.h>
+#include <linux/errno.h>
+#include <linux/firmware.h>
+#include <linux/interrupt.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/of_i2c.h>
+#include <linux/of_irq.h>
+#include <linux/of_address.h>
+#include <linux/of_platform.h>
+#include <linux/platform_device.h>
+#include <linux/pm_runtime.h>
+#include <linux/slab.h>
+#include <linux/types.h>
+#include <linux/videodev2.h>
+#include <media/v4l2-of.h>
+#include <media/videobuf2-dma-contig.h>
+
+#include "media-dev.h"
+#include "fimc-is.h"
+#include "fimc-is-command.h"
+#include "fimc-is-errno.h"
+#include "fimc-is-i2c.h"
+#include "fimc-is-param.h"
+#include "fimc-is-regs.h"
+
+
+static char *fimc_is_clocks[ISS_CLKS_MAX] = {
+	[ISS_CLK_PPMUISPX]		= "ppmuispx",
+	[ISS_CLK_PPMUISPMX]		= "ppmuispmx",
+	[ISS_CLK_LITE0]			= "lite0",
+	[ISS_CLK_LITE1]			= "lite1",
+	[ISS_CLK_MPLL]			= "mpll",
+	[ISS_CLK_SYSREG]		= "sysreg",
+	[ISS_CLK_ISP]			= "isp",
+	[ISS_CLK_DRC]			= "drc",
+	[ISS_CLK_FD]			= "fd",
+	[ISS_CLK_MCUISP]		= "mcuisp",
+	[ISS_CLK_UART]			= "uart",
+	[ISS_CLK_ISP_DIV0]		= "ispdiv0",
+	[ISS_CLK_ISP_DIV1]		= "ispdiv1",
+	[ISS_CLK_MCUISP_DIV0]		= "mcuispdiv0",
+	[ISS_CLK_MCUISP_DIV1]		= "mcuispdiv1",
+	[ISS_CLK_ACLK200]		= "aclk200",
+	[ISS_CLK_ACLK200_DIV]		= "div_aclk200",
+	[ISS_CLK_ACLK400MCUISP]		= "aclk400mcuisp",
+	[ISS_CLK_ACLK400MCUISP_DIV]	= "div_aclk400mcuisp",
+};
+
+static void fimc_is_put_clocks(struct fimc_is *is)
+{
+	int i;
+
+	for (i = 0; i < ISS_CLKS_MAX; i++) {
+		if (IS_ERR(is->clocks[i]))
+			continue;
+		clk_unprepare(is->clocks[i]);
+		clk_put(is->clocks[i]);
+		is->clocks[i] = ERR_PTR(-EINVAL);
+	}
+}
+
+static int fimc_is_get_clocks(struct fimc_is *is)
+{
+	int i, ret;
+
+	for (i = 0; i < ISS_CLKS_MAX; i++)
+		is->clocks[i] = ERR_PTR(-EINVAL);
+
+	for (i = 0; i < ISS_CLKS_MAX; i++) {
+		is->clocks[i] = clk_get(&is->pdev->dev, fimc_is_clocks[i]);
+		if (IS_ERR(is->clocks[i])) {
+			ret = PTR_ERR(is->clocks[i]);
+			goto err;
+		}
+		ret = clk_prepare(is->clocks[i]);
+		if (ret < 0) {
+			clk_put(is->clocks[i]);
+			is->clocks[i] = ERR_PTR(-EINVAL);
+			goto err;
+		}
+	}
+
+	return 0;
+err:
+	fimc_is_put_clocks(is);
+	dev_err(&is->pdev->dev, "failed to get clock: %s\n",
+		fimc_is_clocks[i]);
+	return -ENXIO;
+}
+
+static int fimc_is_setup_clocks(struct fimc_is *is)
+{
+	int ret;
+
+	ret = clk_set_parent(is->clocks[ISS_CLK_ACLK200],
+					is->clocks[ISS_CLK_ACLK200_DIV]);
+	if (ret < 0)
+		return ret;
+
+	ret = clk_set_parent(is->clocks[ISS_CLK_ACLK400MCUISP],
+					is->clocks[ISS_CLK_ACLK400MCUISP_DIV]);
+	if (ret < 0)
+		return ret;
+
+	ret = clk_set_rate(is->clocks[ISS_CLK_ISP_DIV0], ACLK_AXI_FREQUENCY);
+	if (ret < 0)
+		return ret;
+
+	ret = clk_set_rate(is->clocks[ISS_CLK_ISP_DIV1], ACLK_AXI_FREQUENCY);
+	if (ret < 0)
+		return ret;
+
+	ret = clk_set_rate(is->clocks[ISS_CLK_MCUISP_DIV0],
+					ATCLK_MCUISP_FREQUENCY);
+	if (ret < 0)
+		return ret;
+
+	return clk_set_rate(is->clocks[ISS_CLK_MCUISP_DIV1],
+					ATCLK_MCUISP_FREQUENCY);
+}
+
+int fimc_is_enable_clocks(struct fimc_is *is)
+{
+	int i, ret;
+
+	for (i = 0; i < ISS_GATE_CLKS_MAX; i++) {
+		if (IS_ERR(is->clocks[i]))
+			continue;
+		ret = clk_enable(is->clocks[i]);
+		if (ret < 0) {
+			dev_err(&is->pdev->dev, "clock %s enable failed\n",
+				fimc_is_clocks[i]);
+			for (--i; i >= 0; i--)
+				clk_disable(is->clocks[i]);
+			return ret;
+		}
+		pr_debug("enabled clock: %s\n", fimc_is_clocks[i]);
+	}
+	return 0;
+}
+
+void fimc_is_disable_clocks(struct fimc_is *is)
+{
+	int i;
+
+	for (i = 0; i < ISS_GATE_CLKS_MAX; i++) {
+		if (!IS_ERR(is->clocks[i])) {
+			clk_disable(is->clocks[i]);
+			pr_debug("disabled clock: %s\n", fimc_is_clocks[i]);
+		}
+	}
+}
+
+static int fimc_is_parse_sensor_config(struct fimc_is_sensor *sensor,
+				       struct device_node *np)
+{
+	u32 tmp = 0;
+	int ret;
+
+	np = v4l2_of_get_next_endpoint(np, NULL);
+	if (!np)
+		return -ENXIO;
+	np = v4l2_of_get_remote_port(np);
+	if (!np)
+		return -ENXIO;
+
+	/* Use MIPI-CSIS channel id to determine the ISP I2C bus index. */
+	ret = of_property_read_u32(np, "reg", &tmp);
+	sensor->i2c_bus = tmp - FIMC_INPUT_MIPI_CSI2_0;
+
+	return ret;
+}
+
+static int fimc_is_register_subdevs(struct fimc_is *is)
+{
+	struct device_node *adapter, *child;
+	int ret;
+
+	ret = fimc_isp_subdev_create(&is->isp);
+	if (ret < 0)
+		return ret;
+
+	for_each_compatible_node(adapter, NULL, FIMC_IS_I2C_COMPATIBLE) {
+		if (!of_find_device_by_node(adapter)) {
+			of_node_put(adapter);
+			return -EPROBE_DEFER;
+		}
+
+		for_each_available_child_of_node(adapter, child) {
+			struct i2c_client *client;
+			struct v4l2_subdev *sd;
+
+			client = of_find_i2c_device_by_node(child);
+			if (!client)
+				goto e_retry;
+
+			sd = i2c_get_clientdata(client);
+			if (!sd)
+				goto e_retry;
+
+			/* FIXME: Add support for multiple sensors. */
+			if (WARN_ON(is->sensor))
+				continue;
+
+			is->sensor = v4l2_get_subdevdata(sd);
+
+			if (fimc_is_parse_sensor_config(is->sensor, child)) {
+				dev_warn(&is->pdev->dev, "DT parse error: %s\n",
+							 child->full_name);
+			}
+			pr_debug("%s(): registered subdev: %p\n",
+				 __func__, sd->name);
+		}
+	}
+	return 0;
+
+e_retry:
+	of_node_put(child);
+	return -EPROBE_DEFER;
+}
+
+static int fimc_is_unregister_subdevs(struct fimc_is *is)
+{
+	fimc_isp_subdev_destroy(&is->isp);
+	is->sensor = NULL;
+	return 0;
+}
+
+static int fimc_is_load_setfile(struct fimc_is *is, char *file_name)
+{
+	const struct firmware *fw;
+	void *buf;
+	int ret;
+
+	ret = request_firmware(&fw, file_name, &is->pdev->dev);
+	if (ret < 0) {
+		dev_err(&is->pdev->dev, "firmware request failed (%d)\n", ret);
+		return ret;
+	}
+	buf = is->memory.vaddr + is->setfile.base;
+	memcpy(buf, fw->data, fw->size);
+	fimc_is_mem_barrier();
+	is->setfile.size = fw->size;
+
+	pr_debug("mem vaddr: %p, setfile buf: %p\n", is->memory.vaddr, buf);
+
+	memcpy(is->fw.setfile_info,
+		fw->data + fw->size - FIMC_IS_SETFILE_INFO_LEN,
+		FIMC_IS_SETFILE_INFO_LEN - 1);
+
+	is->fw.setfile_info[FIMC_IS_SETFILE_INFO_LEN - 1] = '\0';
+	is->setfile.state = 1;
+
+	pr_debug("FIMC-IS setfile loaded: base: %#x, size: %zu B\n",
+		 is->setfile.base, fw->size);
+
+	release_firmware(fw);
+	return ret;
+}
+
+int fimc_is_cpu_set_power(struct fimc_is *is, int on)
+{
+	unsigned int timeout = FIMC_IS_POWER_ON_TIMEOUT;
+
+	if (on) {
+		/* Disable watchdog */
+		mcuctl_write(0, is, REG_WDT_ISP);
+
+		/* Cortex-A5 start address setting */
+		mcuctl_write(is->memory.paddr, is, MCUCTL_REG_BBOAR);
+
+		/* Enable and start Cortex-A5 */
+		pmuisp_write(0x18000, is, REG_PMU_ISP_ARM_OPTION);
+		pmuisp_write(0x1, is, REG_PMU_ISP_ARM_CONFIGURATION);
+	} else {
+		/* A5 power off */
+		pmuisp_write(0x10000, is, REG_PMU_ISP_ARM_OPTION);
+		pmuisp_write(0x0, is, REG_PMU_ISP_ARM_CONFIGURATION);
+
+		while (pmuisp_read(is, REG_PMU_ISP_ARM_STATUS) & 1) {
+			if (timeout == 0)
+				return -ETIME;
+			timeout--;
+			udelay(1);
+		}
+	}
+
+	return 0;
+}
+
+/* Wait until @bit of @is->state is set to @state in the interrupt handler. */
+int fimc_is_wait_event(struct fimc_is *is, unsigned long bit,
+		       unsigned int state, unsigned int timeout)
+{
+
+	int ret = wait_event_timeout(is->irq_queue,
+				     !state ^ test_bit(bit, &is->state),
+				     timeout);
+	if (ret == 0) {
+		dev_WARN(&is->pdev->dev, "%s() timed out\n", __func__);
+		return -ETIME;
+	}
+	return 0;
+}
+
+int fimc_is_start_firmware(struct fimc_is *is)
+{
+	struct device *dev = &is->pdev->dev;
+	int ret;
+
+	memcpy(is->memory.vaddr, is->fw.f_w->data, is->fw.f_w->size);
+	wmb();
+
+	ret = fimc_is_cpu_set_power(is, 1);
+	if (ret < 0)
+		return ret;
+
+	ret = fimc_is_wait_event(is, IS_ST_A5_PWR_ON, 1,
+				 msecs_to_jiffies(FIMC_IS_FW_LOAD_TIMEOUT));
+	if (ret < 0)
+		dev_err(dev, "FIMC-IS CPU power on failed\n");
+
+	return ret;
+}
+
+/* Allocate working memory for the FIMC-IS CPU. */
+static int fimc_is_alloc_cpu_memory(struct fimc_is *is)
+{
+	struct device *dev = &is->pdev->dev;
+
+	is->memory.vaddr = dma_alloc_coherent(dev, FIMC_IS_CPU_MEM_SIZE,
+					      &is->memory.paddr, GFP_KERNEL);
+	if (is->memory.vaddr == NULL)
+		return -ENOMEM;
+
+	is->memory.size = FIMC_IS_CPU_MEM_SIZE;
+	memset(is->memory.vaddr, 0, is->memory.size);
+
+	dev_info(dev, "FIMC-IS CPU memory base: %#x\n", (u32)is->memory.paddr);
+
+	if (((u32)is->memory.paddr) & FIMC_IS_FW_ADDR_MASK) {
+		dev_err(dev, "invalid firmware memory alignment: %#x\n",
+			(u32)is->memory.paddr);
+		dma_free_coherent(dev, is->memory.size, is->memory.vaddr,
+				  is->memory.paddr);
+		return -EIO;
+	}
+
+	is->is_p_region = (struct is_region *)(is->memory.vaddr +
+				FIMC_IS_CPU_MEM_SIZE - FIMC_IS_REGION_SIZE);
+
+	is->is_dma_p_region = is->memory.paddr +
+				FIMC_IS_CPU_MEM_SIZE - FIMC_IS_REGION_SIZE;
+
+	is->is_shared_region = (struct is_share_region *)(is->memory.vaddr +
+				FIMC_IS_SHARED_REGION_OFFSET);
+	return 0;
+}
+
+static void fimc_is_free_cpu_memory(struct fimc_is *is)
+{
+	struct device *dev = &is->pdev->dev;
+
+	dma_free_coherent(dev, is->memory.size, is->memory.vaddr,
+			  is->memory.paddr);
+}
+
+static void fimc_is_load_firmware(const struct firmware *fw, void *context)
+{
+	struct fimc_is *is = context;
+	struct device *dev = &is->pdev->dev;
+	void *buf;
+	int ret;
+
+	if (fw == NULL) {
+		dev_err(dev, "firmware request failed\n");
+		return;
+	}
+	mutex_lock(&is->lock);
+
+	if (fw->size < FIMC_IS_FW_SIZE_MIN || fw->size > FIMC_IS_FW_SIZE_MAX) {
+		dev_err(dev, "wrong firmware size: %d\n", fw->size);
+		goto done;
+	}
+
+	is->fw.size = fw->size;
+
+	ret = fimc_is_alloc_cpu_memory(is);
+	if (ret < 0) {
+		dev_err(dev, "failed to allocate FIMC-IS CPU memory\n");
+		goto done;
+	}
+
+	memcpy(is->memory.vaddr, fw->data, fw->size);
+	wmb();
+
+	/* Read firmware description. */
+	buf = (void *)(is->memory.vaddr + fw->size - FIMC_IS_FW_DESC_LEN);
+	memcpy(&is->fw.info, buf, FIMC_IS_FW_INFO_LEN);
+	is->fw.info[FIMC_IS_FW_INFO_LEN] = 0;
+
+	buf = (void *)(is->memory.vaddr + fw->size - FIMC_IS_FW_VER_LEN);
+	memcpy(&is->fw.version, buf, FIMC_IS_FW_VER_LEN);
+	is->fw.version[FIMC_IS_FW_VER_LEN - 1] = 0;
+
+	is->fw.state = 1;
+
+	dev_info(dev, "loaded firmware: %s, rev. %s\n",
+		 is->fw.info, is->fw.version);
+	dev_dbg(dev, "FW size: %d, paddr: %#x\n", fw->size, is->memory.paddr);
+
+	is->is_shared_region->chip_id = 0xe4412;
+	is->is_shared_region->chip_rev_no = 1;
+
+	fimc_is_mem_barrier();
+
+	/*
+	 * FIXME: The firmware is not being released for now, as it is
+	 * needed around for copying to the IS working memory every
+	 * time before the Cortex-A5 is restarted.
+	 */
+	if (is->fw.f_w)
+		release_firmware(is->fw.f_w);
+	is->fw.f_w = fw;
+done:
+	mutex_unlock(&is->lock);
+}
+
+static int fimc_is_request_firmware(struct fimc_is *is, const char *fw_name)
+{
+	return request_firmware_nowait(THIS_MODULE,
+				FW_ACTION_HOTPLUG, fw_name, &is->pdev->dev,
+				GFP_KERNEL, is, fimc_is_load_firmware);
+}
+
+/* General IS interrupt handler */
+static void fimc_is_general_irq_handler(struct fimc_is *is)
+{
+	is->i2h_cmd.cmd = mcuctl_read(is, MCUCTL_REG_ISSR(10));
+
+	switch (is->i2h_cmd.cmd) {
+	case FIMC_IS_IHC_GET_SENSOR_NUM:
+		fimc_is_hw_get_params(is, 1);
+		fimc_is_hw_wait_intmsr0_intmsd0(is);
+		fimc_is_hw_set_sensor_num(is);
+		pr_debug("ISP FW version: %#x\n", is->i2h_cmd.args[0]);
+		break;
+	case FIMC_IS_IHC_SET_FACE_MARK:
+	case FIMC_IS_IHC_FRAME_DONE:
+		fimc_is_hw_get_params(is, 2);
+		break;
+	case FIMC_IS_IHC_SET_SHOT_MARK:
+	case FIMC_IS_IHC_AA_DONE:
+	case FIMC_IS_REPLY_DONE:
+		fimc_is_hw_get_params(is, 3);
+		break;
+	case FIMC_IS_REPLY_NOT_DONE:
+		fimc_is_hw_get_params(is, 4);
+		break;
+	case FIMC_IS_IHC_NOT_READY:
+		break;
+	default:
+		pr_info("unknown command: %#x\n", is->i2h_cmd.cmd);
+	}
+
+	fimc_is_fw_clear_irq1(is, FIMC_IS_INT_GENERAL);
+
+	switch (is->i2h_cmd.cmd) {
+	case FIMC_IS_IHC_GET_SENSOR_NUM:
+		fimc_is_hw_set_intgr0_gd0(is);
+		set_bit(IS_ST_A5_PWR_ON, &is->state);
+		break;
+
+	case FIMC_IS_IHC_SET_SHOT_MARK:
+		break;
+
+	case FIMC_IS_IHC_SET_FACE_MARK:
+		is->fd_header.count = is->i2h_cmd.args[0];
+		is->fd_header.index = is->i2h_cmd.args[1];
+		is->fd_header.offset = 0;
+		break;
+
+	case FIMC_IS_IHC_FRAME_DONE:
+		break;
+
+	case FIMC_IS_IHC_AA_DONE:
+		pr_debug("AA_DONE - %d, %d, %d\n", is->i2h_cmd.args[0],
+			 is->i2h_cmd.args[1], is->i2h_cmd.args[2]);
+		break;
+
+	case FIMC_IS_REPLY_DONE:
+		pr_debug("ISR_DONE: args[0]: %#x\n", is->i2h_cmd.args[0]);
+
+		switch (is->i2h_cmd.args[0]) {
+		case FIMC_IS_HIC_PREVIEW_STILL...FIMC_IS_HIC_CAPTURE_VIDEO:
+			/* Get CAC margin */
+			set_bit(IS_ST_CHANGE_MODE, &is->state);
+			is->isp.cac_margin_x = is->i2h_cmd.args[1];
+			is->isp.cac_margin_y = is->i2h_cmd.args[2];
+			pr_debug("CAC margin (x,y): (%d,%d)\n",
+				 is->isp.cac_margin_x, is->isp.cac_margin_y);
+			break;
+
+		case FIMC_IS_HIC_STREAM_ON:
+			clear_bit(IS_ST_STREAM_OFF, &is->state);
+			set_bit(IS_ST_STREAM_ON, &is->state);
+			break;
+
+		case FIMC_IS_HIC_STREAM_OFF:
+			clear_bit(IS_ST_STREAM_ON, &is->state);
+			set_bit(IS_ST_STREAM_OFF, &is->state);
+			break;
+
+		case FIMC_IS_HIC_SET_PARAMETER:
+			is->cfg_param[is->scenario_id].p_region_index1 = 0;
+			is->cfg_param[is->scenario_id].p_region_index2 = 0;
+			atomic_set(&is->cfg_param[is->scenario_id].p_region_num, 0);
+			set_bit(IS_ST_BLOCK_CMD_CLEARED, &is->state);
+			pr_debug("HIC_SET_PARAMETER\n");
+			break;
+
+		case FIMC_IS_HIC_GET_PARAMETER:
+			break;
+
+		case FIMC_IS_HIC_SET_TUNE:
+			break;
+
+		case FIMC_IS_HIC_GET_STATUS:
+			break;
+
+		case FIMC_IS_HIC_OPEN_SENSOR:
+			set_bit(IS_ST_OPEN_SENSOR, &is->state);
+			pr_debug("data lanes: %d, settle line: %d\n",
+				 is->i2h_cmd.args[2], is->i2h_cmd.args[1]);
+			break;
+
+		case FIMC_IS_HIC_CLOSE_SENSOR:
+			clear_bit(IS_ST_OPEN_SENSOR, &is->state);
+			is->sensor_index = 0;
+			break;
+
+		case FIMC_IS_HIC_MSG_TEST:
+			pr_debug("config MSG level completed\n");
+			break;
+
+		case FIMC_IS_HIC_POWER_DOWN:
+			clear_bit(IS_ST_PWR_SUBIP_ON, &is->state);
+			break;
+
+		case FIMC_IS_HIC_GET_SET_FILE_ADDR:
+			is->setfile.base = is->i2h_cmd.args[1];
+			set_bit(IS_ST_SETFILE_LOADED, &is->state);
+			break;
+
+		case FIMC_IS_HIC_LOAD_SET_FILE:
+			set_bit(IS_ST_SETFILE_LOADED, &is->state);
+			break;
+		}
+		break;
+
+	case FIMC_IS_REPLY_NOT_DONE:
+		pr_err("ISR_NDONE: %d: %#x, %s\n", is->i2h_cmd.args[0],
+		       is->i2h_cmd.args[1],
+		       fimc_is_strerr(is->i2h_cmd.args[1]));
+
+		if (is->i2h_cmd.args[1] & IS_ERROR_TIME_OUT_FLAG)
+			pr_err("IS_ERROR_TIME_OUT\n");
+
+		switch (is->i2h_cmd.args[1]) {
+		case IS_ERROR_SET_PARAMETER:
+			fimc_is_mem_barrier();
+		}
+
+		switch (is->i2h_cmd.args[0]) {
+		case FIMC_IS_HIC_SET_PARAMETER:
+			is->cfg_param[is->scenario_id].p_region_index1 = 0;
+			is->cfg_param[is->scenario_id].p_region_index2 = 0;
+			atomic_set(&is->cfg_param[is->scenario_id].p_region_num, 0);
+			set_bit(IS_ST_BLOCK_CMD_CLEARED, &is->state);
+			break;
+		}
+		break;
+
+	case FIMC_IS_IHC_NOT_READY:
+		pr_err("IS control sequence error: Not Ready\n");
+		break;
+	}
+
+	wake_up(&is->irq_queue);
+}
+
+static irqreturn_t fimc_is_irq_handler(int irq, void *priv)
+{
+	struct fimc_is *is = priv;
+	unsigned long flags;
+	u32 status;
+
+	spin_lock_irqsave(&is->slock, flags);
+	status = mcuctl_read(is, MCUCTL_REG_INTSR1);
+
+	if (status & (1UL << FIMC_IS_INT_GENERAL))
+		fimc_is_general_irq_handler(is);
+
+	if (status & (1UL << FIMC_IS_INT_FRAME_DONE_ISP))
+		fimc_isp_irq_handler(is);
+
+	spin_unlock_irqrestore(&is->slock, flags);
+	return IRQ_HANDLED;
+}
+
+static int fimc_is_hw_open_sensor(struct fimc_is *is,
+				  struct fimc_is_sensor *sensor)
+{
+	struct sensor_open_extended *soe = (void *)&is->is_p_region->shared;
+
+	fimc_is_hw_wait_intmsr0_intmsd0(is);
+
+	soe->self_calibration_mode = 1;
+	soe->actuator_type = 0;
+	soe->mipi_lane_num = 0;
+	soe->mclk = 0;
+	soe->mipi_speed	= 0;
+	soe->fast_open_sensor = 0;
+	soe->i2c_sclk = 88000000;
+
+	fimc_is_mem_barrier();
+
+	mcuctl_write(FIMC_IS_HIC_OPEN_SENSOR, is, MCUCTL_REG_ISSR(0));
+	mcuctl_write(is->sensor_index, is, MCUCTL_REG_ISSR(1));
+	mcuctl_write(sensor->drvdata->id, is, MCUCTL_REG_ISSR(2));
+	mcuctl_write(sensor->i2c_bus, is, MCUCTL_REG_ISSR(3));
+	mcuctl_write(is->is_dma_p_region, is, MCUCTL_REG_ISSR(4));
+
+	fimc_is_hw_set_intgr0_gd0(is);
+
+	return fimc_is_wait_event(is, IS_ST_OPEN_SENSOR, 1,
+				  FIMC_IS_SENSOR_OPEN_TIMEOUT);
+}
+
+
+int fimc_is_hw_initialize(struct fimc_is *is)
+{
+	const int scenario_ids[] = {
+		IS_SC_PREVIEW_STILL, IS_SC_PREVIEW_VIDEO,
+		IS_SC_CAPTURE_STILL, IS_SC_CAPTURE_VIDEO
+	};
+	struct device *dev = &is->pdev->dev;
+	u32 prev_id;
+	int i, ret;
+
+	/* Sensor initialization. */
+	ret = fimc_is_hw_open_sensor(is, is->sensor);
+	if (ret < 0)
+		return ret;
+
+	/* Get the setfile address. */
+	fimc_is_hw_get_setfile_addr(is);
+
+	ret = fimc_is_wait_event(is, IS_ST_SETFILE_LOADED, 1,
+				 FIMC_IS_CONFIG_TIMEOUT);
+	if (ret < 0) {
+		dev_err(dev, "get setfile address timed out\n");
+		return ret;
+	}
+	pr_debug("setfile.base: %#x\n", is->setfile.base);
+
+	/* Load the setfile. */
+	fimc_is_load_setfile(is, FIMC_IS_SETFILE_6A3);
+	clear_bit(IS_ST_SETFILE_LOADED, &is->state);
+	fimc_is_hw_load_setfile(is);
+	ret = fimc_is_wait_event(is, IS_ST_SETFILE_LOADED, 1,
+				 FIMC_IS_CONFIG_TIMEOUT);
+	if (ret < 0) {
+		dev_err(dev, "loading setfile timed out\n");
+		return ret;
+	}
+
+	pr_debug("setfile: base: %#x, size: %d\n",
+		 is->setfile.base, is->setfile.size);
+	pr_info("FIMC-IS Setfile info: %s\n", is->fw.setfile_info);
+
+	/* Check magic number. */
+	if (is->is_p_region->shared[MAX_SHARED_COUNT - 1] !=
+	    FIMC_IS_MAGIC_NUMBER) {
+		dev_err(dev, "magic number error!\n");
+		return -EIO;
+	}
+
+	pr_debug("shared region: %#x, parameter region: %#x\n",
+		 is->memory.paddr + FIMC_IS_SHARED_REGION_OFFSET,
+		 is->is_dma_p_region);
+
+	is->setfile.sub_index = 0;
+
+	/* Stream off. */
+	fimc_is_hw_stream_off(is);
+	ret = fimc_is_wait_event(is, IS_ST_STREAM_OFF, 1,
+				 FIMC_IS_CONFIG_TIMEOUT);
+	if (ret < 0) {
+		dev_err(dev, "stream off timeout\n");
+		return ret;
+	}
+
+	/* Preserve previous mode. */
+	prev_id = is->scenario_id;
+
+	/* Set initial parameter values. */
+	for (i = 0; i < ARRAY_SIZE(scenario_ids); i++) {
+		is->scenario_id = scenario_ids[i];
+		fimc_is_set_initial_params(is);
+		ret = fimc_is_itf_s_param(is, true);
+		if (ret < 0) {
+			is->scenario_id = prev_id;
+			return ret;
+		}
+	}
+	is->scenario_id = prev_id;
+
+	set_bit(IS_ST_INIT_DONE, &is->state);
+	dev_info(dev, "initialization sequence completed (%d)\n",
+						is->scenario_id);
+	return 0;
+}
+
+static int fimc_is_log_show(struct seq_file *s, void *data)
+{
+	struct fimc_is *is = s->private;
+	const u8 *buf = is->memory.vaddr + FIMC_IS_DEBUG_REGION_OFFSET;
+
+	if (is->memory.vaddr == NULL) {
+		dev_err(&is->pdev->dev, "firmware memory is not initialized\n");
+		return -EIO;
+	}
+
+	seq_printf(s, "%s\n", buf);
+	return 0;
+}
+
+static int fimc_is_debugfs_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, fimc_is_log_show, inode->i_private);
+}
+
+static const struct file_operations fimc_is_debugfs_fops = {
+	.open		= fimc_is_debugfs_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+static void fimc_is_debugfs_remove(struct fimc_is *is)
+{
+	debugfs_remove(is->debugfs_entry);
+	is->debugfs_entry = NULL;
+}
+
+static int fimc_is_debugfs_create(struct fimc_is *is)
+{
+	struct dentry *dentry;
+
+	is->debugfs_entry = debugfs_create_dir("fimc_is", NULL);
+
+	dentry = debugfs_create_file("fw_log", S_IRUGO, is->debugfs_entry,
+				     is, &fimc_is_debugfs_fops);
+	if (!dentry)
+		fimc_is_debugfs_remove(is);
+
+	return is->debugfs_entry == NULL ? -EIO : 0;
+}
+
+static int fimc_is_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct fimc_is *is;
+	struct resource res;
+	struct device_node *node;
+	int ret;
+
+	is = devm_kzalloc(&pdev->dev, sizeof(*is), GFP_KERNEL);
+	if (!is)
+		return -ENOMEM;
+
+	is->pdev = pdev;
+	is->isp.pdev = pdev;
+
+	init_waitqueue_head(&is->irq_queue);
+	spin_lock_init(&is->slock);
+	mutex_init(&is->lock);
+
+	ret = of_address_to_resource(dev->of_node, 0, &res);
+	if (ret < 0)
+		return ret;
+
+	is->regs = devm_ioremap_resource(dev, &res);
+	if (IS_ERR(is->regs))
+		return PTR_ERR(is->regs);
+
+	node = of_get_child_by_name(dev->of_node, "pmu");
+	if (!node)
+		return -ENODEV;
+	is->pmu_regs = of_iomap(node, 0);
+	if (!is->pmu_regs)
+		return -ENOMEM;
+
+	is->irq = irq_of_parse_and_map(dev->of_node, 0);
+	if (is->irq < 0) {
+		dev_err(dev, "no irq found\n");
+		return is->irq;
+	}
+
+	ret = fimc_is_get_clocks(is);
+	if (ret < 0)
+		return ret;
+
+	platform_set_drvdata(pdev, is);
+
+	ret = request_irq(is->irq, fimc_is_irq_handler, 0, dev_name(dev), is);
+	if (ret < 0) {
+		dev_err(dev, "irq request failed\n");
+		goto err_clk;
+	}
+	pm_runtime_enable(dev);
+	/*
+	 * Enable only the ISP power domain, keep FIMC-IS clocks off until
+	 * the whole clock tree is configured. The ISP power domain needs
+	 * be active in order to acces any CMU_ISP clock registers.
+	 */
+	ret = pm_runtime_get_sync(dev);
+	if (ret < 0)
+		goto err_irq;
+
+	ret = fimc_is_setup_clocks(is);
+	if (ret < 0)
+		goto err_irq;
+
+	pm_runtime_put_sync(dev);
+	is->clk_init = true;
+
+	is->alloc_ctx = vb2_dma_contig_init_ctx(dev);
+	if (IS_ERR(is->alloc_ctx)) {
+		ret = PTR_ERR(is->alloc_ctx);
+		goto err_pm;
+	}
+	/*
+	 * Register FIMC-IS V4L2 subdevs to this driver. The video nodes
+	 * will be created within the subdev's registered() callback.
+	 */
+	ret = fimc_is_register_subdevs(is);
+	if (ret < 0)
+		goto err_vb;
+
+	ret = fimc_is_debugfs_create(is);
+	if (ret < 0)
+		goto err_sd;
+
+	ret = fimc_is_request_firmware(is, FIMC_IS_FW_FILENAME);
+	if (ret < 0)
+		goto err_dfs;
+
+	dev_dbg(dev, "FIMC-IS registered successfully\n");
+	return 0;
+
+err_dfs:
+	fimc_is_debugfs_remove(is);
+err_vb:
+	vb2_dma_contig_cleanup_ctx(is->alloc_ctx);
+err_sd:
+	fimc_is_unregister_subdevs(is);
+err_irq:
+	free_irq(is->irq, is);
+err_pm:
+	pm_runtime_put(dev);
+err_clk:
+	fimc_is_put_clocks(is);
+	return ret;
+}
+
+static int fimc_is_runtime_resume(struct device *dev)
+{
+	struct fimc_is *is = dev_get_drvdata(dev);
+
+	if (!is->clk_init)
+		return 0;
+
+	return fimc_is_enable_clocks(is);
+}
+
+static int fimc_is_runtime_suspend(struct device *dev)
+{
+	struct fimc_is *is = dev_get_drvdata(dev);
+
+	if (is->clk_init)
+		fimc_is_disable_clocks(is);
+
+	return 0;
+}
+
+#ifdef CONFIG_PM_SLEEP
+static int fimc_is_resume(struct device *dev)
+{
+	/* TODO: */
+	return 0;
+}
+
+static int fimc_is_suspend(struct device *dev)
+{
+	struct fimc_is *is = dev_get_drvdata(dev);
+
+	/* TODO: */
+	if (test_bit(IS_ST_A5_PWR_ON, &is->state))
+		return -EBUSY;
+
+	return 0;
+}
+#endif /* CONFIG_PM_SLEEP */
+
+static int fimc_is_remove(struct platform_device *pdev)
+{
+	struct fimc_is *is = platform_get_drvdata(pdev);
+
+	pm_runtime_disable(&pdev->dev);
+	pm_runtime_set_suspended(&pdev->dev);
+	free_irq(is->irq, is);
+	fimc_is_unregister_subdevs(is);
+	vb2_dma_contig_cleanup_ctx(is->alloc_ctx);
+	fimc_is_put_clocks(is);
+	fimc_is_debugfs_remove(is);
+	release_firmware(is->fw.f_w);
+	fimc_is_free_cpu_memory(is);
+
+	return 0;
+}
+
+static const struct of_device_id fimc_is_of_match[] = {
+	{ .compatible = "samsung,exynos4212-fimc-is" },
+	{ /* sentinel */ },
+};
+MODULE_DEVICE_TABLE(of, fimc_is_of_match);
+
+static const struct dev_pm_ops fimc_is_pm_ops = {
+	SET_SYSTEM_SLEEP_PM_OPS(fimc_is_suspend, fimc_is_resume)
+	SET_RUNTIME_PM_OPS(fimc_is_runtime_suspend, fimc_is_runtime_resume,
+			   NULL)
+};
+
+static struct platform_driver fimc_is_driver = {
+	.probe		= fimc_is_probe,
+	.remove		= fimc_is_remove,
+	.driver = {
+		.of_match_table	= fimc_is_of_match,
+		.name		= FIMC_IS_DRV_NAME,
+		.owner		= THIS_MODULE,
+		.pm		= &fimc_is_pm_ops,
+	}
+};
+
+static int fimc_is_module_init(void)
+{
+	int ret;
+
+	ret = fimc_is_register_sensor_driver();
+	if (ret < 0)
+		return ret;
+
+	ret = fimc_is_register_i2c_driver();
+	if (ret < 0)
+		goto err_sens;
+
+	ret = platform_driver_register(&fimc_is_driver);
+	if (!ret)
+		return ret;
+
+	fimc_is_unregister_i2c_driver();
+err_sens:
+	fimc_is_unregister_sensor_driver();
+	return ret;
+}
+
+static void fimc_is_module_exit(void)
+{
+	platform_driver_unregister(&fimc_is_driver);
+	fimc_is_unregister_i2c_driver();
+	fimc_is_unregister_sensor_driver();
+}
+
+module_init(fimc_is_module_init);
+module_exit(fimc_is_module_exit);
+
+MODULE_ALIAS("platform:" FIMC_IS_DRV_NAME);
+MODULE_AUTHOR("Younghwan Joo <yhwan.joo@samsung.com>");
+MODULE_AUTHOR("Sylwester Nawrocki <s.nawrocki@samsung.com>");
diff --git a/drivers/media/platform/exynos4-is/fimc-is.h b/drivers/media/platform/exynos4-is/fimc-is.h
new file mode 100644
index 0000000..936e2ca
--- /dev/null
+++ b/drivers/media/platform/exynos4-is/fimc-is.h
@@ -0,0 +1,345 @@
+/*
+ * Samsung EXYNOS4x12 FIMC-IS (Imaging Subsystem) driver
+ *
+ * Copyright (C) 2013 Samsung Electronics Co., Ltd.
+ *
+ * Authors: Younghwan Joo <yhwan.joo@samsung.com>
+ *          Sylwester Nawrocki <s.nawrocki@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#ifndef FIMC_IS_H_
+#define FIMC_IS_H_
+
+#include <asm/barrier.h>
+#include <linux/clk.h>
+#include <linux/device.h>
+#include <linux/kernel.h>
+#include <linux/pinctrl/consumer.h>
+#include <linux/platform_device.h>
+#include <linux/sizes.h>
+#include <linux/spinlock.h>
+#include <linux/types.h>
+#include <media/videobuf2-core.h>
+#include <media/v4l2-ctrls.h>
+
+#include "fimc-isp.h"
+#include "fimc-is-command.h"
+#include "fimc-is-sensor.h"
+#include "fimc-is-param.h"
+#include "fimc-is-regs.h"
+
+#define FIMC_IS_DRV_NAME		"exynos4-fimc-is"
+
+#define FIMC_IS_FW_FILENAME		"fimc_is_fw.bin"
+#define FIMC_IS_SETFILE_6A3		"setfile.bin"
+
+#define FIMC_IS_FW_LOAD_TIMEOUT		1000 /* ms */
+#define FIMC_IS_POWER_ON_TIMEOUT	1000 /* us */
+
+#define FIMC_IS_SENSOR_NUM		2
+
+/* Memory definitions */
+#define FIMC_IS_CPU_MEM_SIZE		(0xa00000)
+#define FIMC_IS_CPU_BASE_MASK		((1 << 26) - 1)
+#define FIMC_IS_REGION_SIZE		0x5000
+
+#define FIMC_IS_DEBUG_REGION_OFFSET	0x0084b000
+#define FIMC_IS_SHARED_REGION_OFFSET	0x008c0000
+#define FIMC_IS_FW_INFO_LEN		31
+#define FIMC_IS_FW_VER_LEN		7
+#define FIMC_IS_FW_DESC_LEN		(FIMC_IS_FW_INFO_LEN + \
+					 FIMC_IS_FW_VER_LEN)
+#define FIMC_IS_SETFILE_INFO_LEN	39
+
+#define FIMC_IS_EXTRA_MEM_SIZE		(FIMC_IS_EXTRA_FW_SIZE + \
+					 FIMC_IS_EXTRA_SETFILE_SIZE + 0x1000)
+#define FIMC_IS_EXTRA_FW_SIZE		0x180000
+#define FIMC_IS_EXTRA_SETFILE_SIZE	0x4b000
+
+/* TODO: revisit */
+#define FIMC_IS_FW_ADDR_MASK		((1 << 26) - 1)
+#define FIMC_IS_FW_SIZE_MAX		(SZ_4M)
+#define FIMC_IS_FW_SIZE_MIN		(SZ_32K)
+
+#define ATCLK_MCUISP_FREQUENCY		100000000UL
+#define ACLK_AXI_FREQUENCY		100000000UL
+
+enum {
+	ISS_CLK_PPMUISPX,
+	ISS_CLK_PPMUISPMX,
+	ISS_CLK_LITE0,
+	ISS_CLK_LITE1,
+	ISS_CLK_MPLL,
+	ISS_CLK_SYSREG,
+	ISS_CLK_ISP,
+	ISS_CLK_DRC,
+	ISS_CLK_FD,
+	ISS_CLK_MCUISP,
+	ISS_CLK_UART,
+	ISS_GATE_CLKS_MAX,
+	ISS_CLK_ISP_DIV0 = ISS_GATE_CLKS_MAX,
+	ISS_CLK_ISP_DIV1,
+	ISS_CLK_MCUISP_DIV0,
+	ISS_CLK_MCUISP_DIV1,
+	ISS_CLK_ACLK200,
+	ISS_CLK_ACLK200_DIV,
+	ISS_CLK_ACLK400MCUISP,
+	ISS_CLK_ACLK400MCUISP_DIV,
+	ISS_CLKS_MAX
+};
+
+/* The driver's internal state flags */
+enum {
+	IS_ST_IDLE,
+	IS_ST_PWR_ON,
+	IS_ST_A5_PWR_ON,
+	IS_ST_FW_LOADED,
+	IS_ST_OPEN_SENSOR,
+	IS_ST_SETFILE_LOADED,
+	IS_ST_INIT_DONE,
+	IS_ST_STREAM_ON,
+	IS_ST_STREAM_OFF,
+	IS_ST_CHANGE_MODE,
+	IS_ST_BLOCK_CMD_CLEARED,
+	IS_ST_SET_ZOOM,
+	IS_ST_PWR_SUBIP_ON,
+	IS_ST_END,
+};
+
+enum af_state {
+	FIMC_IS_AF_IDLE		= 0,
+	FIMC_IS_AF_SETCONFIG	= 1,
+	FIMC_IS_AF_RUNNING	= 2,
+	FIMC_IS_AF_LOCK		= 3,
+	FIMC_IS_AF_ABORT	= 4,
+	FIMC_IS_AF_FAILED	= 5,
+};
+
+enum af_lock_state {
+	FIMC_IS_AF_UNLOCKED	= 0,
+	FIMC_IS_AF_LOCKED	= 2
+};
+
+enum ae_lock_state {
+	FIMC_IS_AE_UNLOCKED	= 0,
+	FIMC_IS_AE_LOCKED	= 1
+};
+
+enum awb_lock_state {
+	FIMC_IS_AWB_UNLOCKED	= 0,
+	FIMC_IS_AWB_LOCKED	= 1
+};
+
+enum {
+	IS_METERING_CONFIG_CMD,
+	IS_METERING_CONFIG_WIN_POS_X,
+	IS_METERING_CONFIG_WIN_POS_Y,
+	IS_METERING_CONFIG_WIN_WIDTH,
+	IS_METERING_CONFIG_WIN_HEIGHT,
+	IS_METERING_CONFIG_MAX
+};
+
+struct is_setfile {
+	const struct firmware *info;
+	int state;
+	u32 sub_index;
+	u32 base;
+	size_t size;
+};
+
+struct is_fd_result_header {
+	u32 offset;
+	u32 count;
+	u32 index;
+	u32 curr_index;
+	u32 width;
+	u32 height;
+};
+
+struct is_af_info {
+	u16 mode;
+	u32 af_state;
+	u32 af_lock_state;
+	u32 ae_lock_state;
+	u32 awb_lock_state;
+	u16 pos_x;
+	u16 pos_y;
+	u16 prev_pos_x;
+	u16 prev_pos_y;
+	u16 use_af;
+};
+
+struct fimc_is_firmware {
+	const struct firmware *f_w;
+
+	dma_addr_t paddr;
+	void *vaddr;
+	unsigned int size;
+
+	char info[FIMC_IS_FW_INFO_LEN + 1];
+	char version[FIMC_IS_FW_VER_LEN + 1];
+	char setfile_info[FIMC_IS_SETFILE_INFO_LEN + 1];
+	u8 state;
+};
+
+struct fimc_is_memory {
+	/* physical base address */
+	dma_addr_t paddr;
+	/* virtual base address */
+	void *vaddr;
+	/* total length */
+	unsigned int size;
+};
+
+#define FIMC_IS_I2H_MAX_ARGS	12
+
+struct i2h_cmd {
+	u32 cmd;
+	u32 sensor_id;
+	u16 num_args;
+	u32 args[FIMC_IS_I2H_MAX_ARGS];
+};
+
+struct h2i_cmd {
+	u16 cmd_type;
+	u32 entry_id;
+};
+
+#define FIMC_IS_DEBUG_MSG	0x3f
+#define FIMC_IS_DEBUG_LEVEL	3
+
+struct fimc_is_setfile {
+	const struct firmware *info;
+	unsigned int state;
+	unsigned int size;
+	u32 sub_index;
+	u32 base;
+};
+
+struct is_config_param {
+	struct global_param	global;
+	struct sensor_param	sensor;
+	struct isp_param	isp;
+	struct drc_param	drc;
+	struct fd_param		fd;
+
+	atomic_t		p_region_num;
+	unsigned long		p_region_index1;
+	unsigned long		p_region_index2;
+};
+
+/**
+ * struct fimc_is - fimc-is data structure
+ * @pdev: pointer to FIMC-IS platform device
+ * @pctrl: pointer to pinctrl structure for this device
+ * @v4l2_dev: pointer to top the level v4l2_device
+ * @alloc_ctx: videobuf2 memory allocator context
+ * @lock: mutex serializing video device and the subdev operations
+ * @slock: spinlock protecting this data structure and the hw registers
+ * @clocks: FIMC-LITE gate clock
+ * @regs: MCUCTL mmapped registers region
+ * @pmu_regs: PMU ISP mmapped registers region
+ * @irq_queue: interrupt handling waitqueue
+ * @lpm: low power mode flag
+ * @state: internal driver's state flags
+ */
+struct fimc_is {
+	struct platform_device		*pdev;
+	struct pinctrl			*pctrl;
+	struct v4l2_device		*v4l2_dev;
+
+	struct fimc_is_firmware		fw;
+	struct fimc_is_memory		memory;
+	struct firmware			*f_w;
+
+	struct fimc_isp			isp;
+	struct fimc_is_sensor		*sensor;
+	struct fimc_is_setfile		setfile;
+
+	struct vb2_alloc_ctx		*alloc_ctx;
+	struct v4l2_ctrl_handler	ctrl_handler;
+
+	struct mutex			lock;
+	spinlock_t			slock;
+
+	struct clk			*clocks[ISS_CLKS_MAX];
+	bool				clk_init;
+	void __iomem			*regs;
+	void __iomem			*pmu_regs;
+	int				irq;
+	wait_queue_head_t		irq_queue;
+	u8				lpm;
+
+	unsigned long			state;
+	unsigned int			sensor_index;
+
+	struct i2h_cmd			i2h_cmd;
+	struct h2i_cmd			h2i_cmd;
+	struct is_fd_result_header	fd_header;
+
+	struct is_config_param		cfg_param[IS_SC_MAX];
+	struct is_region		*is_p_region;
+	dma_addr_t			is_dma_p_region;
+	struct is_share_region		*is_shared_region;
+	struct is_af_info		af;
+	u32				scenario_id;
+
+	struct dentry			*debugfs_entry;
+};
+
+static inline struct fimc_is *fimc_isp_to_is(struct fimc_isp *isp)
+{
+	return container_of(isp, struct fimc_is, isp);
+}
+
+static inline void fimc_is_mem_barrier(void)
+{
+	mb();
+}
+
+static inline void fimc_is_set_param_bit(struct fimc_is *is, int num)
+{
+	struct is_config_param *cfg = &is->cfg_param[is->scenario_id];
+
+	if (num >= 32)
+		set_bit(num - 32, &cfg->p_region_index2);
+	else
+		set_bit(num, &cfg->p_region_index1);
+}
+
+static inline void fimc_is_set_param_ctrl_cmd(struct fimc_is *is, int cmd)
+{
+	is->is_p_region->parameter.isp.control.cmd = cmd;
+}
+
+static inline void mcuctl_write(u32 v, struct fimc_is *is, unsigned int offset)
+{
+	writel(v, is->regs + offset);
+}
+
+static inline u32 mcuctl_read(struct fimc_is *is, unsigned int offset)
+{
+	return readl(is->regs + offset);
+}
+
+static inline void pmuisp_write(u32 v, struct fimc_is *is, unsigned int offset)
+{
+	writel(v, is->pmu_regs + offset);
+}
+
+static inline u32 pmuisp_read(struct fimc_is *is, unsigned int offset)
+{
+	return readl(is->pmu_regs + offset);
+}
+
+int fimc_is_wait_event(struct fimc_is *is, unsigned long bit,
+		       unsigned int state, unsigned int timeout);
+int fimc_is_cpu_set_power(struct fimc_is *is, int on);
+int fimc_is_start_firmware(struct fimc_is *is);
+int fimc_is_hw_initialize(struct fimc_is *is);
+void fimc_is_log_dump(const char *level, const void *buf, size_t len);
+
+#endif /* FIMC_IS_H_ */
diff --git a/drivers/media/platform/exynos4-is/fimc-isp.c b/drivers/media/platform/exynos4-is/fimc-isp.c
new file mode 100644
index 0000000..59502b1
--- /dev/null
+++ b/drivers/media/platform/exynos4-is/fimc-isp.c
@@ -0,0 +1,702 @@
+/*
+ * Samsung EXYNOS4x12 FIMC-IS (Imaging Subsystem) driver
+ *
+ * Copyright (C) 2013 Samsung Electronics Co., Ltd.
+ *
+ * Authors: Sylwester Nawrocki <s.nawrocki@samsung.com>
+ *          Younghwan Joo <yhwan.joo@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#define pr_fmt(fmt) "%s:%d " fmt, __func__, __LINE__
+
+#include <linux/device.h>
+#include <linux/errno.h>
+#include <linux/kernel.h>
+#include <linux/list.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/printk.h>
+#include <linux/pm_runtime.h>
+#include <linux/slab.h>
+#include <linux/types.h>
+#include <media/v4l2-device.h>
+
+#include "media-dev.h"
+#include "fimc-is-command.h"
+#include "fimc-is-param.h"
+#include "fimc-is-regs.h"
+#include "fimc-is.h"
+
+static int debug = 10;
+module_param_named(debug_isp, debug, int, S_IRUGO | S_IWUSR);
+
+static const struct fimc_fmt fimc_isp_formats[FIMC_ISP_NUM_FORMATS] = {
+	{
+		.name		= "RAW8 (GRBG)",
+		.fourcc		= V4L2_PIX_FMT_SGRBG8,
+		.depth		= { 8 },
+		.color		= FIMC_FMT_RAW8,
+		.memplanes	= 1,
+		.mbus_code	= V4L2_MBUS_FMT_SGRBG8_1X8,
+	}, {
+		.name		= "RAW10 (GRBG)",
+		.fourcc		= V4L2_PIX_FMT_SGRBG10,
+		.depth		= { 10 },
+		.color		= FIMC_FMT_RAW10,
+		.memplanes	= 1,
+		.mbus_code	= V4L2_MBUS_FMT_SGRBG10_1X10,
+	}, {
+		.name		= "RAW12 (GRBG)",
+		.fourcc		= V4L2_PIX_FMT_SGRBG12,
+		.depth		= { 12 },
+		.color		= FIMC_FMT_RAW12,
+		.memplanes	= 1,
+		.mbus_code	= V4L2_MBUS_FMT_SGRBG12_1X12,
+	},
+};
+
+/**
+ * fimc_isp_find_format - lookup color format by fourcc or media bus code
+ * @pixelformat: fourcc to match, ignored if null
+ * @mbus_code: media bus code to match, ignored if null
+ * @index: index to the fimc_isp_formats array, ignored if negative
+ */
+const struct fimc_fmt *fimc_isp_find_format(const u32 *pixelformat,
+					const u32 *mbus_code, int index)
+{
+	const struct fimc_fmt *fmt, *def_fmt = NULL;
+	unsigned int i;
+	int id = 0;
+
+	if (index >= (int)ARRAY_SIZE(fimc_isp_formats))
+		return NULL;
+
+	for (i = 0; i < ARRAY_SIZE(fimc_isp_formats); ++i) {
+		fmt = &fimc_isp_formats[i];
+		if (pixelformat && fmt->fourcc == *pixelformat)
+			return fmt;
+		if (mbus_code && fmt->mbus_code == *mbus_code)
+			return fmt;
+		if (index == id)
+			def_fmt = fmt;
+		id++;
+	}
+	return def_fmt;
+}
+
+void fimc_isp_irq_handler(struct fimc_is *is)
+{
+	is->i2h_cmd.args[0] = mcuctl_read(is, MCUCTL_REG_ISSR(20));
+	is->i2h_cmd.args[1] = mcuctl_read(is, MCUCTL_REG_ISSR(21));
+
+	fimc_is_fw_clear_irq1(is, FIMC_IS_INT_FRAME_DONE_ISP);
+
+	/* TODO: Complete ISP DMA interrupt handler */
+	wake_up(&is->irq_queue);
+}
+
+/* Capture subdev media entity operations */
+static int fimc_is_link_setup(struct media_entity *entity,
+				const struct media_pad *local,
+				const struct media_pad *remote, u32 flags)
+{
+	return 0;
+}
+
+static const struct media_entity_operations fimc_is_subdev_media_ops = {
+	.link_setup = fimc_is_link_setup,
+};
+
+static int fimc_is_subdev_enum_mbus_code(struct v4l2_subdev *sd,
+				struct v4l2_subdev_fh *fh,
+				struct v4l2_subdev_mbus_code_enum *code)
+{
+	const struct fimc_fmt *fmt;
+
+	fmt = fimc_isp_find_format(NULL, NULL, code->index);
+	if (!fmt)
+		return -EINVAL;
+	code->code = fmt->mbus_code;
+	return 0;
+}
+
+static int fimc_isp_subdev_get_fmt(struct v4l2_subdev *sd,
+				   struct v4l2_subdev_fh *fh,
+				   struct v4l2_subdev_format *fmt)
+{
+	struct fimc_isp *isp = v4l2_get_subdevdata(sd);
+	struct fimc_is *is = fimc_isp_to_is(isp);
+	struct v4l2_mbus_framefmt *mf = &fmt->format;
+	struct v4l2_mbus_framefmt cur_fmt;
+
+	if (fmt->which == V4L2_SUBDEV_FORMAT_TRY) {
+		mf = v4l2_subdev_get_try_format(fh, fmt->pad);
+		fmt->format = *mf;
+		return 0;
+	}
+
+	mf->colorspace = V4L2_COLORSPACE_JPEG;
+
+	mutex_lock(&isp->subdev_lock);
+	__is_get_frame_size(is, &cur_fmt);
+
+	if (fmt->pad == FIMC_ISP_SD_PAD_SINK) {
+		/* full camera input frame size */
+		mf->width = cur_fmt.width + FIMC_ISP_CAC_MARGIN_WIDTH;
+		mf->height = cur_fmt.height + FIMC_ISP_CAC_MARGIN_HEIGHT;
+		mf->code = V4L2_MBUS_FMT_SGRBG10_1X10;
+	} else {
+		/* crop size */
+		mf->width = cur_fmt.width;
+		mf->height = cur_fmt.height;
+		mf->code = V4L2_MBUS_FMT_YUV10_1X30;
+	}
+
+	mutex_unlock(&isp->subdev_lock);
+
+	v4l2_dbg(1, debug, sd, "%s: pad%d: fmt: 0x%x, %dx%d\n",
+		 __func__, fmt->pad, mf->code, mf->width, mf->height);
+
+	return 0;
+}
+
+static void __isp_subdev_try_format(struct fimc_isp *isp,
+				   struct v4l2_subdev_format *fmt)
+{
+	struct v4l2_mbus_framefmt *mf = &fmt->format;
+
+	if (fmt->pad == FIMC_ISP_SD_PAD_SINK) {
+		v4l_bound_align_image(&mf->width, FIMC_ISP_SINK_WIDTH_MIN,
+				FIMC_ISP_SINK_WIDTH_MAX, 0,
+				&mf->height, FIMC_ISP_SINK_HEIGHT_MIN,
+				FIMC_ISP_SINK_HEIGHT_MAX, 0, 0);
+		isp->subdev_fmt = *mf;
+	} else {
+		/* Allow changing format only on sink pad */
+		mf->width = isp->subdev_fmt.width - FIMC_ISP_CAC_MARGIN_WIDTH;
+		mf->height = isp->subdev_fmt.height - FIMC_ISP_CAC_MARGIN_HEIGHT;
+		mf->code = isp->subdev_fmt.code;
+	}
+}
+
+static int fimc_isp_subdev_set_fmt(struct v4l2_subdev *sd,
+				   struct v4l2_subdev_fh *fh,
+				   struct v4l2_subdev_format *fmt)
+{
+	struct fimc_isp *isp = v4l2_get_subdevdata(sd);
+	struct fimc_is *is = fimc_isp_to_is(isp);
+	struct v4l2_mbus_framefmt *mf = &fmt->format;
+	int ret = 0;
+
+	v4l2_dbg(1, debug, sd, "%s: pad%d: code: 0x%x, %dx%d\n",
+		 __func__, fmt->pad, mf->code, mf->width, mf->height);
+
+	mf->colorspace = V4L2_COLORSPACE_JPEG;
+
+	mutex_lock(&isp->subdev_lock);
+	__isp_subdev_try_format(isp, fmt);
+
+	if (fmt->which == V4L2_SUBDEV_FORMAT_TRY) {
+		mf = v4l2_subdev_get_try_format(fh, fmt->pad);
+		*mf = fmt->format;
+		mutex_unlock(&isp->subdev_lock);
+		return 0;
+	}
+
+	if (sd->entity.stream_count == 0)
+		__is_set_frame_size(is, mf);
+	else
+		ret = -EBUSY;
+	mutex_unlock(&isp->subdev_lock);
+
+	return ret;
+}
+
+static int fimc_isp_subdev_s_stream(struct v4l2_subdev *sd, int on)
+{
+	struct fimc_isp *isp = v4l2_get_subdevdata(sd);
+	struct fimc_is *is = fimc_isp_to_is(isp);
+	int ret;
+
+	v4l2_dbg(1, debug, sd, "%s: on: %d\n", __func__, on);
+
+	if (!test_bit(IS_ST_INIT_DONE, &is->state))
+		return -EBUSY;
+
+	fimc_is_mem_barrier();
+
+	if (on) {
+		if (atomic_read(&is->cfg_param[is->scenario_id].p_region_num))
+			ret = fimc_is_itf_s_param(is, true);
+
+		v4l2_dbg(1, debug, sd, "changing mode to %d\n",
+						is->scenario_id);
+		ret = fimc_is_itf_mode_change(is);
+		if (ret)
+			return -EINVAL;
+
+		clear_bit(IS_ST_STREAM_ON, &is->state);
+		fimc_is_hw_stream_on(is);
+		ret = fimc_is_wait_event(is, IS_ST_STREAM_ON, 1,
+					 FIMC_IS_CONFIG_TIMEOUT);
+		if (ret < 0) {
+			v4l2_err(sd, "stream on timeout\n");
+			return ret;
+		}
+	} else {
+		clear_bit(IS_ST_STREAM_OFF, &is->state);
+		fimc_is_hw_stream_off(is);
+		ret = fimc_is_wait_event(is, IS_ST_STREAM_OFF, 1,
+					 FIMC_IS_CONFIG_TIMEOUT);
+		if (ret < 0) {
+			v4l2_err(sd, "stream off timeout\n");
+			return ret;
+		}
+		is->setfile.sub_index = 0;
+	}
+
+	return 0;
+}
+
+static int fimc_isp_subdev_s_power(struct v4l2_subdev *sd, int on)
+{
+	struct fimc_isp *isp = v4l2_get_subdevdata(sd);
+	struct fimc_is *is = fimc_isp_to_is(isp);
+	int ret = 0;
+
+	pr_debug("on: %d\n", on);
+
+	if (on) {
+		ret = pm_runtime_get_sync(&is->pdev->dev);
+		if (ret < 0)
+			return ret;
+		set_bit(IS_ST_PWR_ON, &is->state);
+
+		ret = fimc_is_start_firmware(is);
+		if (ret < 0) {
+			v4l2_err(sd, "firmware booting failed\n");
+			pm_runtime_put(&is->pdev->dev);
+			return ret;
+		}
+		set_bit(IS_ST_PWR_SUBIP_ON, &is->state);
+
+		ret = fimc_is_hw_initialize(is);
+	} else {
+		/* Close sensor */
+		if (!test_bit(IS_ST_PWR_ON, &is->state)) {
+			fimc_is_hw_close_sensor(is, 0);
+
+			ret = fimc_is_wait_event(is, IS_ST_OPEN_SENSOR, 0,
+						 FIMC_IS_CONFIG_TIMEOUT);
+			if (ret < 0) {
+				v4l2_err(sd, "sensor close timeout\n");
+				return ret;
+			}
+		}
+
+		/* SUB IP power off */
+		if (test_bit(IS_ST_PWR_SUBIP_ON, &is->state)) {
+			fimc_is_hw_subip_power_off(is);
+			ret = fimc_is_wait_event(is, IS_ST_PWR_SUBIP_ON, 0,
+						 FIMC_IS_CONFIG_TIMEOUT);
+			if (ret < 0) {
+				v4l2_err(sd, "sub-IP power off timeout\n");
+				return ret;
+			}
+		}
+
+		fimc_is_cpu_set_power(is, 0);
+		pm_runtime_put_sync(&is->pdev->dev);
+
+		clear_bit(IS_ST_PWR_ON, &is->state);
+		clear_bit(IS_ST_INIT_DONE, &is->state);
+		is->state = 0;
+		is->cfg_param[is->scenario_id].p_region_index1 = 0;
+		is->cfg_param[is->scenario_id].p_region_index2 = 0;
+		set_bit(IS_ST_IDLE, &is->state);
+		wmb();
+	}
+
+	return ret;
+}
+
+static int fimc_isp_subdev_open(struct v4l2_subdev *sd,
+				struct v4l2_subdev_fh *fh)
+{
+	struct v4l2_mbus_framefmt fmt;
+	struct v4l2_mbus_framefmt *format;
+
+	format = v4l2_subdev_get_try_format(fh, FIMC_ISP_SD_PAD_SINK);
+
+	fmt.colorspace = V4L2_COLORSPACE_SRGB;
+	fmt.code = fimc_isp_formats[0].mbus_code;
+	fmt.width = DEFAULT_PREVIEW_STILL_WIDTH + FIMC_ISP_CAC_MARGIN_WIDTH;
+	fmt.height = DEFAULT_PREVIEW_STILL_HEIGHT + FIMC_ISP_CAC_MARGIN_HEIGHT;
+	fmt.field = V4L2_FIELD_NONE;
+	*format = fmt;
+
+	format = v4l2_subdev_get_try_format(fh, FIMC_ISP_SD_PAD_SRC_FIFO);
+	fmt.width = DEFAULT_PREVIEW_STILL_WIDTH;
+	fmt.height = DEFAULT_PREVIEW_STILL_HEIGHT;
+	*format = fmt;
+
+	format = v4l2_subdev_get_try_format(fh, FIMC_ISP_SD_PAD_SRC_DMA);
+	*format = fmt;
+
+	return 0;
+}
+
+static const struct v4l2_subdev_internal_ops fimc_is_subdev_internal_ops = {
+	.open = fimc_isp_subdev_open,
+};
+
+static const struct v4l2_subdev_pad_ops fimc_is_subdev_pad_ops = {
+	.enum_mbus_code = fimc_is_subdev_enum_mbus_code,
+	.get_fmt = fimc_isp_subdev_get_fmt,
+	.set_fmt = fimc_isp_subdev_set_fmt,
+};
+
+static const struct v4l2_subdev_video_ops fimc_is_subdev_video_ops = {
+	.s_stream = fimc_isp_subdev_s_stream,
+};
+
+static const struct v4l2_subdev_core_ops fimc_is_core_ops = {
+	.s_power = fimc_isp_subdev_s_power,
+};
+
+static struct v4l2_subdev_ops fimc_is_subdev_ops = {
+	.core = &fimc_is_core_ops,
+	.video = &fimc_is_subdev_video_ops,
+	.pad = &fimc_is_subdev_pad_ops,
+};
+
+static int __ctrl_set_white_balance(struct fimc_is *is, int value)
+{
+	switch (value) {
+	case V4L2_WHITE_BALANCE_AUTO:
+		__is_set_isp_awb(is, ISP_AWB_COMMAND_AUTO, 0);
+		break;
+	case V4L2_WHITE_BALANCE_DAYLIGHT:
+		__is_set_isp_awb(is, ISP_AWB_COMMAND_ILLUMINATION,
+					ISP_AWB_ILLUMINATION_DAYLIGHT);
+		break;
+	case V4L2_WHITE_BALANCE_CLOUDY:
+		__is_set_isp_awb(is, ISP_AWB_COMMAND_ILLUMINATION,
+					ISP_AWB_ILLUMINATION_CLOUDY);
+		break;
+	case V4L2_WHITE_BALANCE_INCANDESCENT:
+		__is_set_isp_awb(is, ISP_AWB_COMMAND_ILLUMINATION,
+					ISP_AWB_ILLUMINATION_TUNGSTEN);
+		break;
+	case V4L2_WHITE_BALANCE_FLUORESCENT:
+		__is_set_isp_awb(is, ISP_AWB_COMMAND_ILLUMINATION,
+					ISP_AWB_ILLUMINATION_FLUORESCENT);
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int __ctrl_set_aewb_lock(struct fimc_is *is,
+				      struct v4l2_ctrl *ctrl)
+{
+	bool awb_lock = ctrl->val & V4L2_LOCK_WHITE_BALANCE;
+	bool ae_lock = ctrl->val & V4L2_LOCK_EXPOSURE;
+	struct isp_param *isp = &is->is_p_region->parameter.isp;
+	int cmd, ret;
+
+	cmd = ae_lock ? ISP_AA_COMMAND_STOP : ISP_AA_COMMAND_START;
+	isp->aa.cmd = cmd;
+	isp->aa.target = ISP_AA_TARGET_AE;
+	fimc_is_set_param_bit(is, PARAM_ISP_AA);
+	fimc_is_inc_param_num(is);
+	is->af.ae_lock_state = ae_lock;
+	wmb();
+
+	ret = fimc_is_itf_s_param(is, false);
+	if (ret < 0)
+		return ret;
+
+	cmd = awb_lock ? ISP_AA_COMMAND_STOP : ISP_AA_COMMAND_START;
+	isp->aa.cmd = cmd;
+	isp->aa.target = ISP_AA_TARGET_AE;
+	fimc_is_set_param_bit(is, PARAM_ISP_AA);
+	fimc_is_inc_param_num(is);
+	is->af.awb_lock_state = awb_lock;
+	wmb();
+
+	return fimc_is_itf_s_param(is, false);
+}
+
+/* Supported manual ISO values */
+static const s64 iso_qmenu[] = {
+	50, 100, 200, 400, 800,
+};
+
+static int __ctrl_set_iso(struct fimc_is *is, int value)
+{
+	unsigned int idx, iso;
+
+	if (value == V4L2_ISO_SENSITIVITY_AUTO) {
+		__is_set_isp_iso(is, ISP_ISO_COMMAND_AUTO, 0);
+		return 0;
+	}
+	idx = is->isp.ctrls.iso->val;
+	if (idx >= ARRAY_SIZE(iso_qmenu))
+		return -EINVAL;
+
+	iso = iso_qmenu[idx];
+	__is_set_isp_iso(is, ISP_ISO_COMMAND_MANUAL, iso);
+	return 0;
+}
+
+static int __ctrl_set_metering(struct fimc_is *is, unsigned int value)
+{
+	unsigned int val;
+
+	switch (value) {
+	case V4L2_EXPOSURE_METERING_AVERAGE:
+		val = ISP_METERING_COMMAND_AVERAGE;
+		break;
+	case V4L2_EXPOSURE_METERING_CENTER_WEIGHTED:
+		val = ISP_METERING_COMMAND_CENTER;
+		break;
+	case V4L2_EXPOSURE_METERING_SPOT:
+		val = ISP_METERING_COMMAND_SPOT;
+		break;
+	case V4L2_EXPOSURE_METERING_MATRIX:
+		val = ISP_METERING_COMMAND_MATRIX;
+		break;
+	default:
+		return -EINVAL;
+	};
+
+	__is_set_isp_metering(is, IS_METERING_CONFIG_CMD, val);
+	return 0;
+}
+
+static int __ctrl_set_afc(struct fimc_is *is, int value)
+{
+	switch (value) {
+	case V4L2_CID_POWER_LINE_FREQUENCY_DISABLED:
+		__is_set_isp_afc(is, ISP_AFC_COMMAND_DISABLE, 0);
+		break;
+	case V4L2_CID_POWER_LINE_FREQUENCY_50HZ:
+		__is_set_isp_afc(is, ISP_AFC_COMMAND_MANUAL, 50);
+		break;
+	case V4L2_CID_POWER_LINE_FREQUENCY_60HZ:
+		__is_set_isp_afc(is, ISP_AFC_COMMAND_MANUAL, 60);
+		break;
+	case V4L2_CID_POWER_LINE_FREQUENCY_AUTO:
+		__is_set_isp_afc(is, ISP_AFC_COMMAND_AUTO, 0);
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int __ctrl_set_image_effect(struct fimc_is *is, int value)
+{
+	static const u8 effects[][2] = {
+		{ V4L2_COLORFX_NONE,	 ISP_IMAGE_EFFECT_DISABLE },
+		{ V4L2_COLORFX_BW,	 ISP_IMAGE_EFFECT_MONOCHROME },
+		{ V4L2_COLORFX_SEPIA,	 ISP_IMAGE_EFFECT_SEPIA },
+		{ V4L2_COLORFX_NEGATIVE, ISP_IMAGE_EFFECT_NEGATIVE_MONO },
+		{ 16 /* TODO */,	 ISP_IMAGE_EFFECT_NEGATIVE_COLOR },
+	};
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(effects); i++) {
+		if (effects[i][0] != value)
+			continue;
+
+		__is_set_isp_effect(is, effects[i][1]);
+		return 0;
+	}
+
+	return -EINVAL;
+}
+
+static int fimc_is_s_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct fimc_isp *isp = ctrl_to_fimc_isp(ctrl);
+	struct fimc_is *is = fimc_isp_to_is(isp);
+	bool set_param = true;
+	int ret = 0;
+
+	switch (ctrl->id) {
+	case V4L2_CID_CONTRAST:
+		__is_set_isp_adjust(is, ISP_ADJUST_COMMAND_MANUAL_CONTRAST,
+				    ctrl->val);
+		break;
+
+	case V4L2_CID_SATURATION:
+		__is_set_isp_adjust(is, ISP_ADJUST_COMMAND_MANUAL_SATURATION,
+				    ctrl->val);
+		break;
+
+	case V4L2_CID_SHARPNESS:
+		__is_set_isp_adjust(is, ISP_ADJUST_COMMAND_MANUAL_SHARPNESS,
+				    ctrl->val);
+		break;
+
+	case V4L2_CID_EXPOSURE_ABSOLUTE:
+		__is_set_isp_adjust(is, ISP_ADJUST_COMMAND_MANUAL_EXPOSURE,
+				    ctrl->val);
+		break;
+
+	case V4L2_CID_BRIGHTNESS:
+		__is_set_isp_adjust(is, ISP_ADJUST_COMMAND_MANUAL_BRIGHTNESS,
+				    ctrl->val);
+		break;
+
+	case V4L2_CID_HUE:
+		__is_set_isp_adjust(is, ISP_ADJUST_COMMAND_MANUAL_HUE,
+				    ctrl->val);
+		break;
+
+	case V4L2_CID_EXPOSURE_METERING:
+		ret = __ctrl_set_metering(is, ctrl->val);
+		break;
+
+	case V4L2_CID_AUTO_N_PRESET_WHITE_BALANCE:
+		ret = __ctrl_set_white_balance(is, ctrl->val);
+		break;
+
+	case V4L2_CID_3A_LOCK:
+		ret = __ctrl_set_aewb_lock(is, ctrl);
+		set_param = false;
+		break;
+
+	case V4L2_CID_ISO_SENSITIVITY_AUTO:
+		ret = __ctrl_set_iso(is, ctrl->val);
+		break;
+
+	case V4L2_CID_POWER_LINE_FREQUENCY:
+		ret = __ctrl_set_afc(is, ctrl->val);
+		break;
+
+	case V4L2_CID_COLORFX:
+		__ctrl_set_image_effect(is, ctrl->val);
+		break;
+
+	default:
+		ret = -EINVAL;
+		break;
+	}
+
+	if (ret < 0) {
+		v4l2_err(&isp->subdev, "Failed to set control: %s (%d)\n",
+						ctrl->name, ctrl->val);
+		return ret;
+	}
+
+	if (set_param && test_bit(IS_ST_STREAM_ON, &is->state))
+		return fimc_is_itf_s_param(is, true);
+
+	return 0;
+}
+
+static const struct v4l2_ctrl_ops fimc_isp_ctrl_ops = {
+	.s_ctrl	= fimc_is_s_ctrl,
+};
+
+int fimc_isp_subdev_create(struct fimc_isp *isp)
+{
+	const struct v4l2_ctrl_ops *ops = &fimc_isp_ctrl_ops;
+	struct v4l2_ctrl_handler *handler = &isp->ctrls.handler;
+	struct v4l2_subdev *sd = &isp->subdev;
+	struct fimc_isp_ctrls *ctrls = &isp->ctrls;
+	int ret;
+
+	mutex_init(&isp->subdev_lock);
+
+	v4l2_subdev_init(sd, &fimc_is_subdev_ops);
+	sd->grp_id = GRP_ID_FIMC_IS;
+	sd->flags = V4L2_SUBDEV_FL_HAS_DEVNODE;
+	snprintf(sd->name, sizeof(sd->name), "FIMC-IS-ISP");
+
+	isp->subdev_pads[FIMC_ISP_SD_PAD_SINK].flags = MEDIA_PAD_FL_SINK;
+	isp->subdev_pads[FIMC_ISP_SD_PAD_SRC_FIFO].flags = MEDIA_PAD_FL_SOURCE;
+	isp->subdev_pads[FIMC_ISP_SD_PAD_SRC_DMA].flags = MEDIA_PAD_FL_SOURCE;
+	ret = media_entity_init(&sd->entity, FIMC_ISP_SD_PADS_NUM,
+				isp->subdev_pads, 0);
+	if (ret)
+		return ret;
+
+	v4l2_ctrl_handler_init(handler, 20);
+
+	ctrls->saturation = v4l2_ctrl_new_std(handler, ops, V4L2_CID_SATURATION,
+						-2, 2, 1, 0);
+	ctrls->brightness = v4l2_ctrl_new_std(handler, ops, V4L2_CID_BRIGHTNESS,
+						-4, 4, 1, 0);
+	ctrls->contrast = v4l2_ctrl_new_std(handler, ops, V4L2_CID_CONTRAST,
+						-2, 2, 1, 0);
+	ctrls->sharpness = v4l2_ctrl_new_std(handler, ops, V4L2_CID_SHARPNESS,
+						-2, 2, 1, 0);
+	ctrls->hue = v4l2_ctrl_new_std(handler, ops, V4L2_CID_HUE,
+						-2, 2, 1, 0);
+
+	ctrls->auto_wb = v4l2_ctrl_new_std_menu(handler, ops,
+					V4L2_CID_AUTO_N_PRESET_WHITE_BALANCE,
+					8, ~0x14e, V4L2_WHITE_BALANCE_AUTO);
+
+	ctrls->exposure = v4l2_ctrl_new_std(handler, ops,
+					V4L2_CID_EXPOSURE_ABSOLUTE,
+					-4, 4, 1, 0);
+
+	ctrls->exp_metering = v4l2_ctrl_new_std_menu(handler, ops,
+					V4L2_CID_EXPOSURE_METERING, 3,
+					~0xf, V4L2_EXPOSURE_METERING_AVERAGE);
+
+	v4l2_ctrl_new_std_menu(handler, ops, V4L2_CID_POWER_LINE_FREQUENCY,
+					V4L2_CID_POWER_LINE_FREQUENCY_AUTO, 0,
+					V4L2_CID_POWER_LINE_FREQUENCY_AUTO);
+	/* ISO sensitivity */
+	ctrls->auto_iso = v4l2_ctrl_new_std_menu(handler, ops,
+			V4L2_CID_ISO_SENSITIVITY_AUTO, 1, 0,
+			V4L2_ISO_SENSITIVITY_AUTO);
+
+	ctrls->iso = v4l2_ctrl_new_int_menu(handler, ops,
+			V4L2_CID_ISO_SENSITIVITY, ARRAY_SIZE(iso_qmenu) - 1,
+			ARRAY_SIZE(iso_qmenu)/2 - 1, iso_qmenu);
+
+	ctrls->aewb_lock = v4l2_ctrl_new_std(handler, ops,
+					V4L2_CID_3A_LOCK, 0, 0x3, 0, 0);
+
+	/* TODO: Add support for NEGATIVE_COLOR option */
+	ctrls->colorfx = v4l2_ctrl_new_std_menu(handler, ops, V4L2_CID_COLORFX,
+			V4L2_COLORFX_SET_CBCR + 1, ~0x1000f, V4L2_COLORFX_NONE);
+
+	if (handler->error) {
+		media_entity_cleanup(&sd->entity);
+		return handler->error;
+	}
+
+	v4l2_ctrl_auto_cluster(2, &ctrls->auto_iso,
+			V4L2_ISO_SENSITIVITY_MANUAL, false);
+
+	sd->ctrl_handler = handler;
+	sd->internal_ops = &fimc_is_subdev_internal_ops;
+	sd->entity.ops = &fimc_is_subdev_media_ops;
+	v4l2_set_subdevdata(sd, isp);
+
+	return 0;
+}
+
+void fimc_isp_subdev_destroy(struct fimc_isp *isp)
+{
+	struct v4l2_subdev *sd = &isp->subdev;
+
+	v4l2_device_unregister_subdev(sd);
+	media_entity_cleanup(&sd->entity);
+	v4l2_ctrl_handler_free(&isp->ctrls.handler);
+	v4l2_set_subdevdata(sd, NULL);
+}
diff --git a/drivers/media/platform/exynos4-is/fimc-isp.h b/drivers/media/platform/exynos4-is/fimc-isp.h
new file mode 100644
index 0000000..800aba7
--- /dev/null
+++ b/drivers/media/platform/exynos4-is/fimc-isp.h
@@ -0,0 +1,181 @@
+/*
+ * Samsung EXYNOS4x12 FIMC-IS (Imaging Subsystem) driver
+ *
+ * Copyright (C) 2013 Samsung Electronics Co., Ltd.
+ *
+ * Authors: Sylwester Nawrocki <s.nawrocki@samsung.com>
+ *          Younghwan Joo <yhwan.joo@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#ifndef FIMC_ISP_H_
+#define FIMC_ISP_H_
+
+#include <linux/io.h>
+#include <linux/platform_device.h>
+#include <linux/sched.h>
+#include <linux/spinlock.h>
+#include <linux/types.h>
+#include <linux/videodev2.h>
+
+#include <media/media-entity.h>
+#include <media/videobuf2-core.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-mediabus.h>
+#include <media/s5p_fimc.h>
+
+/* FIXME: revisit these constraints */
+#define FIMC_ISP_SINK_WIDTH_MIN		(16 + 8)
+#define FIMC_ISP_SINK_HEIGHT_MIN	(12 + 8)
+#define FIMC_ISP_SOURCE_WIDTH_MIN	8
+#define FIMC_ISP_SOURC_HEIGHT_MIN	8
+#define FIMC_ISP_CAC_MARGIN_WIDTH	16
+#define FIMC_ISP_CAC_MARGIN_HEIGHT	12
+
+#define FIMC_ISP_SINK_WIDTH_MAX		(4000 - 16)
+#define FIMC_ISP_SINK_HEIGHT_MAX	(4000 + 12)
+#define FIMC_ISP_SOURCE_WIDTH_MAX	4000
+#define FIMC_ISP_SOURC_HEIGHT_MAX	4000
+
+#define FIMC_ISP_NUM_FORMATS		3
+#define FIMC_ISP_REQ_BUFS_MIN		2
+
+#define FIMC_ISP_SD_PAD_SINK		0
+#define FIMC_ISP_SD_PAD_SRC_FIFO	1
+#define FIMC_ISP_SD_PAD_SRC_DMA		2
+#define FIMC_ISP_SD_PADS_NUM		3
+#define FIMC_ISP_MAX_PLANES		1
+
+/**
+ * struct fimc_isp_frame - source/target frame properties
+ * @width: full image width
+ * @height: full image height
+ * @rect: crop/composition rectangle
+ */
+struct fimc_isp_frame {
+	u16 width;
+	u16 height;
+	struct v4l2_rect rect;
+};
+
+struct fimc_isp_ctrls {
+	struct v4l2_ctrl_handler handler;
+
+	/* Auto white balance */
+	struct v4l2_ctrl *auto_wb;
+	/* Auto ISO control cluster */
+	struct {
+		struct v4l2_ctrl *auto_iso;
+		struct v4l2_ctrl *iso;
+	};
+	/* Adjust - contrast */
+	struct v4l2_ctrl *contrast;
+	/* Adjust - saturation */
+	struct v4l2_ctrl *saturation;
+	/* Adjust - sharpness */
+	struct v4l2_ctrl *sharpness;
+	/* Adjust - brightness */
+	struct v4l2_ctrl *brightness;
+	/* Adjust - hue */
+	struct v4l2_ctrl *hue;
+
+	/* Auto/manual exposure */
+	struct v4l2_ctrl *auto_exp;
+	/* Manual exposure value */
+	struct v4l2_ctrl *exposure;
+	/* AE/AWB lock/unlock */
+	struct v4l2_ctrl *aewb_lock;
+	/* Exposure metering mode */
+	struct v4l2_ctrl *exp_metering;
+	/* AFC */
+	struct v4l2_ctrl *afc;
+	/* ISP image effect */
+	struct v4l2_ctrl *colorfx;
+};
+
+/**
+ * struct fimc_is_video - fimc-is video device structure
+ * @vdev: video_device structure
+ * @type: video device type (CAPTURE/OUTPUT)
+ * @pad: video device media (sink) pad
+ * @pending_buf_q: pending buffers queue head
+ * @active_buf_q: a queue head of buffers scheduled in hardware
+ * @vb_queue: vb2 buffer queue
+ * @active_buf_count: number of video buffers scheduled in hardware
+ * @frame_count: counter of frames dequeued to user space
+ * @reqbufs_count: number of buffers requested with REQBUFS ioctl
+ * @format: current pixel format
+ */
+struct fimc_is_video {
+	struct video_device	vdev;
+	enum v4l2_buf_type	type;
+	struct media_pad	pad;
+	struct list_head	pending_buf_q;
+	struct list_head	active_buf_q;
+	struct vb2_queue	vb_queue;
+	unsigned int		frame_count;
+	unsigned int		reqbufs_count;
+	int			streaming;
+	unsigned long		payload[FIMC_ISP_MAX_PLANES];
+	const struct fimc_fmt	*format;
+};
+
+/**
+ * struct fimc_isp - FIMC-IS ISP data structure
+ * @pdev: pointer to FIMC-IS platform device
+ * @alloc_ctx: videobuf2 memory allocator context
+ * @subdev: ISP v4l2_subdev
+ * @subdev_pads: the ISP subdev media pads
+ * @ctrl_handler: v4l2 controls handler
+ * @test_pattern: test pattern controls
+ * @pipeline: video capture pipeline data structure
+ * @video_lock: mutex serializing video device and the subdev operations
+ * @fmt: pointer to color format description structure
+ * @payload: image size in bytes (w x h x bpp)
+ * @inp_frame: camera input frame structure
+ * @out_frame: DMA output frame structure
+ * @source_subdev_grp_id: group id of remote source subdev
+ * @cac_margin_x: horizontal CAC margin in pixels
+ * @cac_margin_y: vertical CAC margin in pixels
+ * @state: driver state flags
+ * @video_capture: the ISP block video capture device
+ */
+struct fimc_isp {
+	struct platform_device		*pdev;
+	struct vb2_alloc_ctx		*alloc_ctx;
+	struct v4l2_subdev		subdev;
+	struct media_pad		subdev_pads[FIMC_ISP_SD_PADS_NUM];
+	struct v4l2_mbus_framefmt	subdev_fmt;
+	struct v4l2_ctrl		*test_pattern;
+	struct fimc_isp_ctrls		ctrls;
+
+	struct mutex			video_lock;
+	struct mutex			subdev_lock;
+
+	struct fimc_isp_frame		inp_frame;
+	struct fimc_isp_frame		out_frame;
+	unsigned int			source_subdev_grp_id;
+
+	unsigned int			cac_margin_x;
+	unsigned int			cac_margin_y;
+
+	unsigned long			state;
+
+	struct fimc_is_video		video_capture;
+};
+
+#define ctrl_to_fimc_isp(_ctrl) \
+	container_of(ctrl->handler, struct fimc_isp, ctrls.handler)
+
+struct fimc_is;
+
+int fimc_isp_subdev_create(struct fimc_isp *isp);
+void fimc_isp_subdev_destroy(struct fimc_isp *isp);
+void fimc_isp_irq_handler(struct fimc_is *is);
+int fimc_is_create_controls(struct fimc_isp *isp);
+int fimc_is_delete_controls(struct fimc_isp *isp);
+const struct fimc_fmt *fimc_isp_find_format(const u32 *pixelformat,
+					const u32 *mbus_code, int index);
+#endif /* FIMC_ISP_H_ */
-- 
1.7.9.5

