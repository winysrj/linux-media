Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f175.google.com ([209.85.192.175]:56414 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571Ab3KEGNM (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Nov 2013 01:13:12 -0500
From: Arun Kumar K <arun.kk@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	devicetree@vger.kernel.org
Cc: s.nawrocki@samsung.com, hverkuil@xs4all.nl, swarren@wwwdotorg.org,
	mark.rutland@arm.com, Pawel.Moll@arm.com, galak@codeaurora.org,
	a.hajda@samsung.com, sachin.kamat@linaro.org,
	shaik.ameer@samsung.com, kilyeon.im@samsung.com,
	arunkk.samsung@gmail.com
Subject: [PATCH v11 03/12] [media] exynos5-fimc-is: Add common driver header files
Date: Tue,  5 Nov 2013 11:42:34 +0530
Message-Id: <1383631964-26514-4-git-send-email-arun.kk@samsung.com>
In-Reply-To: <1383631964-26514-1-git-send-email-arun.kk@samsung.com>
References: <1383631964-26514-1-git-send-email-arun.kk@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds all the common header files used by the fimc-is
driver. It includes the commands for interfacing with the firmware
and error codes from IS firmware, metadata and command parameter
definitions.

Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
Signed-off-by: Kilyeon Im <kilyeon.im@samsung.com>
Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
 drivers/media/platform/exynos5-is/fimc-is-cmd.h    |  187 ++++
 drivers/media/platform/exynos5-is/fimc-is-err.h    |  257 +++++
 .../media/platform/exynos5-is/fimc-is-metadata.h   |  767 +++++++++++++
 drivers/media/platform/exynos5-is/fimc-is-param.h  | 1159 ++++++++++++++++++++
 4 files changed, 2370 insertions(+)
 create mode 100644 drivers/media/platform/exynos5-is/fimc-is-cmd.h
 create mode 100644 drivers/media/platform/exynos5-is/fimc-is-err.h
 create mode 100644 drivers/media/platform/exynos5-is/fimc-is-metadata.h
 create mode 100644 drivers/media/platform/exynos5-is/fimc-is-param.h

diff --git a/drivers/media/platform/exynos5-is/fimc-is-cmd.h b/drivers/media/platform/exynos5-is/fimc-is-cmd.h
new file mode 100644
index 0000000..6250280
--- /dev/null
+++ b/drivers/media/platform/exynos5-is/fimc-is-cmd.h
@@ -0,0 +1,187 @@
+/*
+ * Samsung Exynos5 SoC series FIMC-IS driver
+ *
+ * Copyright (c) 2013 Samsung Electronics Co., Ltd
+ * Kil-yeon Lim <kilyeon.im@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef FIMC_IS_CMD_H
+#define FIMC_IS_CMD_H
+
+#define IS_COMMAND_VER 122 /* IS COMMAND VERSION 1.22 */
+
+enum is_cmd {
+	/* HOST -> IS */
+	HIC_PREVIEW_STILL = 0x1,
+	HIC_PREVIEW_VIDEO,
+	HIC_CAPTURE_STILL,
+	HIC_CAPTURE_VIDEO,
+	HIC_PROCESS_START,
+	HIC_PROCESS_STOP,
+	HIC_STREAM_ON,
+	HIC_STREAM_OFF,
+	HIC_SHOT,
+	HIC_GET_STATIC_METADATA,
+	HIC_SET_CAM_CONTROL,
+	HIC_GET_CAM_CONTROL,
+	HIC_SET_PARAMETER,
+	HIC_GET_PARAMETER,
+	HIC_SET_A5_MEM_ACCESS,
+	RESERVED2,
+	HIC_GET_STATUS,
+	/* SENSOR PART*/
+	HIC_OPEN_SENSOR,
+	HIC_CLOSE_SENSOR,
+	HIC_SIMMIAN_INIT,
+	HIC_SIMMIAN_WRITE,
+	HIC_SIMMIAN_READ,
+	HIC_POWER_DOWN,
+	HIC_GET_SET_FILE_ADDR,
+	HIC_LOAD_SET_FILE,
+	HIC_MSG_CONFIG,
+	HIC_MSG_TEST,
+	/* IS -> HOST */
+	IHC_GET_SENSOR_NUMBER = 0x1000,
+	/* Parameter1 : Address of space to copy a setfile */
+	/* Parameter2 : Space szie */
+	IHC_SET_SHOT_MARK,
+	/* PARAM1 : a frame number */
+	/* PARAM2 : confidence level(smile 0~100) */
+	/* PARMA3 : confidence level(blink 0~100) */
+	IHC_SET_FACE_MARK,
+	/* PARAM1 : coordinate count */
+	/* PARAM2 : coordinate buffer address */
+	IHC_FRAME_DONE,
+	/* PARAM1 : frame start number */
+	/* PARAM2 : frame count */
+	IHC_AA_DONE,
+	IHC_NOT_READY,
+	IHC_FLASH_READY
+};
+
+enum is_reply {
+	ISR_DONE	= 0x2000,
+	ISR_NDONE
+};
+
+enum is_scenario_id {
+	ISS_PREVIEW_STILL,
+	ISS_PREVIEW_VIDEO,
+	ISS_CAPTURE_STILL,
+	ISS_CAPTURE_VIDEO,
+	ISS_END
+};
+
+enum is_subscenario_id {
+	ISS_SUB_SCENARIO_STILL,
+	ISS_SUB_SCENARIO_VIDEO,
+	ISS_SUB_SCENARIO_SCENE1,
+	ISS_SUB_SCENARIO_SCENE2,
+	ISS_SUB_SCENARIO_SCENE3,
+	ISS_SUB_END
+};
+
+struct is_setfile_header_element {
+	u32 binary_addr;
+	u32 binary_size;
+};
+
+struct is_setfile_header {
+	struct is_setfile_header_element isp[ISS_END];
+	struct is_setfile_header_element drc[ISS_END];
+	struct is_setfile_header_element fd[ISS_END];
+};
+
+struct is_common_reg {
+	u32 hicmd;
+	u32 hic_sensorid;
+	u32 hic_param[4];
+
+	u32 reserved1[3];
+
+	u32 ihcmd_iflag;
+	u32 ihcmd;
+	u32 ihc_sensorid;
+	u32 ihc_param[4];
+
+	u32 reserved2[3];
+
+	u32 isp_bayer_iflag;
+	u32 isp_bayer_sensor_id;
+	u32 isp_bayer_param[2];
+
+	u32 reserved3[4];
+
+	u32 scc_iflag;
+	u32 scc_sensor_id;
+	u32 scc_param[3];
+
+	u32 reserved4[3];
+
+	u32 dnr_iflag;
+	u32 dnr_sensor_id;
+	u32 dnr_param[2];
+
+	u32 reserved5[4];
+
+	u32 scp_iflag;
+	u32 scp_sensor_id;
+	u32 scp_param[3];
+
+	u32 reserved6[1];
+
+	u32 isp_yuv_iflag;
+	u32 isp_yuv_sensor_id;
+	u32 isp_yuv_param[2];
+
+	u32 reserved7[1];
+
+	u32 shot_iflag;
+	u32 shot_sensor_id;
+	u32 shot_param[2];
+
+	u32 reserved8[1];
+
+	u32 meta_iflag;
+	u32 meta_sensor_id;
+	u32 meta_param1;
+
+	u32 reserved9[1];
+
+	u32 fcount;
+};
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
+	u32 pad[0xD];
+
+	struct is_common_reg common_reg;
+};
+#endif
diff --git a/drivers/media/platform/exynos5-is/fimc-is-err.h b/drivers/media/platform/exynos5-is/fimc-is-err.h
new file mode 100644
index 0000000..e19eced
--- /dev/null
+++ b/drivers/media/platform/exynos5-is/fimc-is-err.h
@@ -0,0 +1,257 @@
+/*
+ * Samsung Exynos5 SoC series FIMC-IS driver
+ *
+ * Copyright (c) 2013 Samsung Electronics Co., Ltd
+ * Arun Kumar K <arun.kk@samsung.com>
+ * Kil-yeon Lim <kilyeon.im@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef FIMC_IS_ERR_H
+#define FIMC_IS_ERR_H
+
+#define IS_ERROR_VER 012 /* IS ERROR VERSION 0.07 */
+
+/* IS error enum */
+enum is_error {
+
+	IS_ERROR_SUCCESS = 0,
+
+	/* General 1 ~ 100 */
+	IS_ERROR_INVALID_COMMAND = 1,
+	IS_ERROR_REQUEST_FAIL,
+	IS_ERROR_INVALID_SCENARIO,
+	IS_ERROR_INVALID_SENSORID,
+	IS_ERROR_INVALID_MODE_CHANGE,
+	IS_ERROR_INVALID_MAGIC_NUMBER,
+	IS_ERROR_INVALID_SETFILE_HDR,
+	IS_ERROR_ISP_SETFILE_VERSION_MISMATCH,
+	IS_ERROR_ISP_SETFILE_REVISION_MISMATCH,
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
+	IS_ERROR_INTERNAL_STOP,
+	IS_ERROR_UNKNOWN,
+	IS_ERROR_TIME_OUT_FLAG,
+
+	/* Sensor 100 ~ 200 */
+	IS_ERROR_SENSOR_PWRDN_FAIL = 100,
+	IS_ERROR_SENSOR_STREAM_ON_FAIL,
+	IS_ERROR_SENSOR_STREAM_OFF_FAIL,
+
+	/* ISP 200 ~ 300 */
+	IS_ERROR_ISP_PWRDN_FAIL = 200,
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
+	/* DRC 300 ~ 400 */
+	IS_ERROR_DRC_PWRDN_FAIL = 300,
+	IS_ERROR_DRC_MULTIPLE_INPUT,
+	IS_ERROR_DRC_ABSENT_INPUT,
+	IS_ERROR_DRC_NONADJACENT_INTPUT,
+	IS_ERROR_DRC_ABSENT_OUTPUT,
+	IS_ERROR_DRC_NONADJACENT_OUTPUT,
+	IS_ERROR_DRC_FORMAT_MISMATCH,
+	IS_ERROR_DRC_WIDTH_MISMATCH,
+	IS_ERROR_DRC_HEIGHT_MISMATCH,
+	IS_ERROR_DRC_BITWIDTH_MISMATCH,
+	IS_ERROR_DRC_FRAME_END_TIME_OUT,
+
+	/*SCALERC(400~500)*/
+	IS_ERROR_SCALERC_PWRDN_FAIL = 400,
+
+	/*ODC(500~600)*/
+	IS_ERROR_ODC_PWRDN_FAIL = 500,
+
+	/*DIS(600~700)*/
+	IS_ERROR_DIS_PWRDN_FAIL = 600,
+
+	/*TDNR(700~800)*/
+	IS_ERROR_TDNR_PWRDN_FAIL = 700,
+
+	/*SCALERP(800~900)*/
+	IS_ERROR_SCALERP_PWRDN_FAIL = 800,
+
+	/*FD(900~1000)*/
+	IS_ERROR_FD_PWRDN_FAIL = 900,
+	IS_ERROR_FD_MULTIPLE_INPUT,
+	IS_ERROR_FD_ABSENT_INPUT,
+	IS_ERROR_FD_NONADJACENT_INPUT,
+	IS_ERROR_LHFD_FRAME_END_TIME_OUT,
+};
+
+/* Set parameter error enum */
+enum error {
+	/* Common error (0~99) */
+	ERROR_COMMON_NONE		= 0,
+	ERROR_COMMON_CMD		= 1,	/* Invalid command*/
+	ERROR_COMMON_PARAMETER		= 2,	/* Invalid parameter*/
+	/* setfile is not loaded before adjusting */
+	ERROR_COMMON_SETFILE_LOAD	= 3,
+	/* setfile is not Adjusted before runnng. */
+	ERROR_COMMON_SETFILE_ADJUST	= 4,
+	/* index of setfile is not valid. */
+	ERROR_COMMON_SETFILE_INDEX = 5,
+	/* Input path can be changed in ready state(stop) */
+	ERROR_COMMON_INPUT_PATH		= 6,
+	/* IP can not start if input path is not set */
+	ERROR_COMMON_INPUT_INIT		= 7,
+	/* Output path can be changed in ready state(stop) */
+	ERROR_COMMON_OUTPUT_PATH	= 8,
+	/* IP can not start if output path is not set */
+	ERROR_COMMON_OUTPUT_INIT	= 9,
+
+	ERROR_CONTROL_NONE		= ERROR_COMMON_NONE,
+	ERROR_CONTROL_BYPASS		= 11,	/* Enable or Disable */
+	ERROR_CONTROL_BUF		= 12,	/* invalid buffer info */
+
+	ERROR_OTF_INPUT_NONE		= ERROR_COMMON_NONE,
+	/* invalid command */
+	ERROR_OTF_INPUT_CMD		= 21,
+	/* invalid format  (DRC: YUV444, FD: YUV444, 422, 420) */
+	ERROR_OTF_INPUT_FORMAT		= 22,
+	/* invalid width (DRC: 128~8192, FD: 32~8190) */
+	ERROR_OTF_INPUT_WIDTH		= 23,
+	/* invalid height (DRC: 64~8192, FD: 16~8190) */
+	ERROR_OTF_INPUT_HEIGHT		= 24,
+	/* invalid bit-width (DRC: 8~12bits, FD: 8bit) */
+	ERROR_OTF_INPUT_BIT_WIDTH	= 25,
+	/* invalid frame time for ISP */
+	ERROR_OTF_INPUT_USER_FRAMETILE = 26,
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
+	/* invalid crop size (ODC: left>2, right>10) */
+	ERROR_OTF_OUTPUT_CROP		= 45,
+
+	ERROR_DMA_OUTPUT_NONE		= ERROR_COMMON_NONE,
+	ERROR_DMA_OUTPUT_WIDTH		= 51,	/* invalid width */
+	ERROR_DMA_OUTPUT_HEIGHT		= 52,	/* invalid height */
+	ERROR_DMA_OUTPUT_FORMAT		= 53,	/* invalid format */
+	ERROR_DMA_OUTPUT_BIT_WIDTH	= 54,	/* invalid bit-width */
+	ERROR_DMA_OUTPUT_PLANE		= 55,	/* invalid plane */
+	ERROR_DMA_OUTPUT_ORDER		= 56,	/* invalid order */
+	ERROR_DMA_OUTPUT_BUF		= 57,	/* invalid buffer info */
+
+	ERROR_GLOBAL_SHOTMODE_NONE	= ERROR_COMMON_NONE,
+
+	/* SENSOR Error(100~199) */
+	ERROR_SENSOR_NONE		= ERROR_COMMON_NONE,
+	ERROR_SENSOR_I2C_FAIL		= 101,
+	ERROR_SENSOR_INVALID_FRAMERATE,
+	ERROR_SENSOR_INVALID_EXPOSURETIME,
+	ERROR_SENSOR_INVALID_SIZE,
+	ERROR_SENSOR_ACTURATOR_INIT_FAIL,
+	ERROR_SENSOR_INVALID_AF_POS,
+	ERROR_SENSOR_UNSUPPORT_FUNC,
+	ERROR_SENSOR_UNSUPPORT_PERI,
+	ERROR_SENSOR_UNSUPPORT_AF,
+	ERROR_SENSOR_FLASH_FAIL,
+	ERROR_SENSOR_START_FAIL,
+	ERROR_SENSOR_STOP_FAIL,
+
+	/* ISP Error (200~299) */
+	ERROR_ISP_AF_NONE		= ERROR_COMMON_NONE,
+	ERROR_ISP_AF_BUSY		= 201,
+	ERROR_ISP_AF_INVALID_COMMAND	= 202,
+	ERROR_ISP_AF_INVALID_MODE	= 203,
+	ERROR_ISP_FLASH_NONE		= ERROR_COMMON_NONE,
+	ERROR_ISP_AWB_NONE		= ERROR_COMMON_NONE,
+	ERROR_ISP_IMAGE_EFFECT_NONE	= ERROR_COMMON_NONE,
+	ERROR_ISP_IMAGE_EFFECT_INVALID	= 231,
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
+	/* PARAM_FdResultStr can be only applied
+	 * in ready-state or stream off */
+	ERROR_FD_RESULT				= 414,
+	/* PARAM_FdModeStr can be only applied
+	 * in ready-state or stream off */
+	ERROR_FD_MODE					= 415,
+
+	/*SCALER ERR(500~599)*/
+	ERROR_SCALER_NONE			= ERROR_COMMON_NONE,
+	ERROR_SCALER_DMA_OUTSEL			= 501,
+	ERROR_SCALER_H_RATIO			= 502,
+	ERROR_SCALER_V_RATIO			= 503,
+	ERROR_SCALER_FRAME_BUFFER_SEQ		= 504,
+
+	ERROR_SCALER_IMAGE_EFFECT		= 510,
+
+	ERROR_SCALER_ROTATE			= 520,
+	ERROR_SCALER_FLIP			= 521,
+
+};
+
+#endif
diff --git a/drivers/media/platform/exynos5-is/fimc-is-metadata.h b/drivers/media/platform/exynos5-is/fimc-is-metadata.h
new file mode 100644
index 0000000..02367c4
--- /dev/null
+++ b/drivers/media/platform/exynos5-is/fimc-is-metadata.h
@@ -0,0 +1,767 @@
+/*
+ * Samsung EXYNOS5 FIMC-IS (Imaging Subsystem) driver
+ *
+ * Copyright (C) 2013 Samsung Electronics Co., Ltd.
+ * Kil-yeon Lim <kilyeon.im@samsung.com>
+ * Arun Kumar K <arun.kk@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef FIMC_IS_METADATA_H_
+#define FIMC_IS_METADATA_H_
+
+struct rational {
+	uint32_t num;
+	uint32_t den;
+};
+
+#define CAMERA2_MAX_AVAILABLE_MODE	21
+#define CAMERA2_MAX_FACES		16
+
+/*
+ * Controls/dynamic metadata
+ */
+
+enum metadata_mode {
+	METADATA_MODE_NONE,
+	METADATA_MODE_FULL
+};
+
+struct camera2_request_ctl {
+	uint32_t		id;
+	enum metadata_mode	metadatamode;
+	uint8_t			outputstreams[16];
+	uint32_t		framecount;
+};
+
+struct camera2_request_dm {
+	uint32_t		id;
+	enum metadata_mode	metadatamode;
+	uint32_t		framecount;
+};
+
+
+
+enum optical_stabilization_mode {
+	OPTICAL_STABILIZATION_MODE_OFF,
+	OPTICAL_STABILIZATION_MODE_ON
+};
+
+enum lens_facing {
+	LENS_FACING_BACK,
+	LENS_FACING_FRONT
+};
+
+struct camera2_lens_ctl {
+	uint32_t				focus_distance;
+	float					aperture;
+	float					focal_length;
+	float					filter_density;
+	enum optical_stabilization_mode		optical_stabilization_mode;
+};
+
+struct camera2_lens_dm {
+	uint32_t				focus_distance;
+	float					aperture;
+	float					focal_length;
+	float					filter_density;
+	enum optical_stabilization_mode		optical_stabilization_mode;
+	float					focus_range[2];
+};
+
+struct camera2_lens_sm {
+	float				minimum_focus_distance;
+	float				hyper_focal_distance;
+	float				available_focal_length[2];
+	float				available_apertures;
+	/* assuming 1 aperture */
+	float				available_filter_densities;
+	/* assuming 1 ND filter value */
+	enum optical_stabilization_mode	available_optical_stabilization;
+	/* assuming 1 */
+	uint32_t			shading_map_size;
+	float				shading_map[3][40][30];
+	uint32_t			geometric_correction_map_size;
+	float				geometric_correction_map[2][3][40][30];
+	enum lens_facing		facing;
+	float				position[2];
+};
+
+enum sensor_colorfilter_arrangement {
+	SENSOR_COLORFILTER_ARRANGEMENT_RGGB,
+	SENSOR_COLORFILTER_ARRANGEMENT_GRBG,
+	SENSOR_COLORFILTER_ARRANGEMENT_GBRG,
+	SENSOR_COLORFILTER_ARRANGEMENT_BGGR,
+	SENSOR_COLORFILTER_ARRANGEMENT_RGB
+};
+
+enum sensor_ref_illuminant {
+	SENSOR_ILLUMINANT_DAYLIGHT = 1,
+	SENSOR_ILLUMINANT_FLUORESCENT = 2,
+	SENSOR_ILLUMINANT_TUNGSTEN = 3,
+	SENSOR_ILLUMINANT_FLASH = 4,
+	SENSOR_ILLUMINANT_FINE_WEATHER = 9,
+	SENSOR_ILLUMINANT_CLOUDY_WEATHER = 10,
+	SENSOR_ILLUMINANT_SHADE = 11,
+	SENSOR_ILLUMINANT_DAYLIGHT_FLUORESCENT = 12,
+	SENSOR_ILLUMINANT_DAY_WHITE_FLUORESCENT = 13,
+	SENSOR_ILLUMINANT_COOL_WHITE_FLUORESCENT = 14,
+	SENSOR_ILLUMINANT_WHITE_FLUORESCENT = 15,
+	SENSOR_ILLUMINANT_STANDARD_A = 17,
+	SENSOR_ILLUMINANT_STANDARD_B = 18,
+	SENSOR_ILLUMINANT_STANDARD_C = 19,
+	SENSOR_ILLUMINANT_D55 = 20,
+	SENSOR_ILLUMINANT_D65 = 21,
+	SENSOR_ILLUMINANT_D75 = 22,
+	SENSOR_ILLUMINANT_D50 = 23,
+	SENSOR_ILLUMINANT_ISO_STUDIO_TUNGSTEN = 24
+};
+
+struct camera2_sensor_ctl {
+	/* unit : nano */
+	uint64_t	exposure_time;
+	/* unit : nano(It's min frame duration */
+	uint64_t	frame_duration;
+	/* unit : percent(need to change ISO value?) */
+	uint32_t	sensitivity;
+};
+
+struct camera2_sensor_dm {
+	uint64_t	exposure_time;
+	uint64_t	frame_duration;
+	uint32_t	sensitivity;
+	uint64_t	timestamp;
+};
+
+struct camera2_sensor_sm {
+	uint32_t	exposure_time_range[2];
+	uint32_t	max_frame_duration;
+	/* list of available sensitivities. */
+	uint32_t	available_sensitivities[10];
+	enum sensor_colorfilter_arrangement colorfilter_arrangement;
+	float		physical_size[2];
+	uint32_t	pixel_array_size[2];
+	uint32_t	active_array_size[4];
+	uint32_t	white_level;
+	uint32_t	black_level_pattern[4];
+	struct rational	color_transform1[9];
+	struct rational	color_transform2[9];
+	enum sensor_ref_illuminant	reference_illuminant1;
+	enum sensor_ref_illuminant	reference_illuminant2;
+	struct rational	forward_matrix1[9];
+	struct rational	forward_matrix2[9];
+	struct rational	calibration_transform1[9];
+	struct rational	calibration_transform2[9];
+	struct rational	base_gain_factor;
+	uint32_t	max_analog_sensitivity;
+	float		noise_model_coefficients[2];
+	uint32_t	orientation;
+};
+
+
+
+enum flash_mode {
+	CAM2_FLASH_MODE_OFF = 1,
+	CAM2_FLASH_MODE_SINGLE,
+	CAM2_FLASH_MODE_TORCH,
+	CAM2_FLASH_MODE_BEST
+};
+
+struct camera2_flash_ctl {
+	enum flash_mode		flash_mode;
+	uint32_t		firing_power;
+	uint64_t		firing_time;
+};
+
+struct camera2_flash_dm {
+	enum flash_mode		flash_mode;
+	/* 10 is max power */
+	uint32_t		firing_power;
+	/* unit : microseconds */
+	uint64_t		firing_time;
+	/* 1 : stable, 0 : unstable */
+	uint32_t		firing_stable;
+	/* 1 : success, 0 : fail */
+	uint32_t		decision;
+};
+
+struct camera2_flash_sm {
+	uint32_t	available;
+	uint64_t	charge_duration;
+};
+
+enum processing_mode {
+	PROCESSING_MODE_OFF = 1,
+	PROCESSING_MODE_FAST,
+	PROCESSING_MODE_HIGH_QUALITY
+};
+
+
+struct camera2_hotpixel_ctl {
+	enum processing_mode	mode;
+};
+
+struct camera2_hotpixel_dm {
+	enum processing_mode	mode;
+};
+
+struct camera2_demosaic_ctl {
+	enum processing_mode	mode;
+};
+
+struct camera2_demosaic_dm {
+	enum processing_mode	mode;
+};
+
+struct camera2_noise_reduction_ctl {
+	enum processing_mode	mode;
+	uint32_t		strength;
+};
+
+struct camera2_noise_reduction_dm {
+	enum processing_mode	mode;
+	uint32_t		strength;
+};
+
+struct camera2_shading_ctl {
+	enum processing_mode	mode;
+};
+
+struct camera2_shading_dm {
+	enum processing_mode	mode;
+};
+
+struct camera2_geometric_ctl {
+	enum processing_mode	mode;
+};
+
+struct camera2_geometric_dm {
+	enum processing_mode	mode;
+};
+
+enum color_correction_mode {
+	COLOR_CORRECTION_MODE_FAST = 1,
+	COLOR_CORRECTION_MODE_HIGH_QUALITY,
+	COLOR_CORRECTION_MODE_TRANSFORM_MATRIX,
+	COLOR_CORRECTION_MODE_EFFECT_MONO,
+	COLOR_CORRECTION_MODE_EFFECT_NEGATIVE,
+	COLOR_CORRECTION_MODE_EFFECT_SOLARIZE,
+	COLOR_CORRECTION_MODE_EFFECT_SEPIA,
+	COLOR_CORRECTION_MODE_EFFECT_POSTERIZE,
+	COLOR_CORRECTION_MODE_EFFECT_WHITEBOARD,
+	COLOR_CORRECTION_MODE_EFFECT_BLACKBOARD,
+	COLOR_CORRECTION_MODE_EFFECT_AQUA
+};
+
+
+struct camera2_color_correction_ctl {
+	enum color_correction_mode	mode;
+	float				transform[9];
+	uint32_t			hue;
+	uint32_t			saturation;
+	uint32_t			brightness;
+};
+
+struct camera2_color_correction_dm {
+	enum color_correction_mode	mode;
+	float				transform[9];
+	uint32_t			hue;
+	uint32_t			saturation;
+	uint32_t			brightness;
+};
+
+struct camera2_color_correction_sm {
+	/* assuming 10 supported modes */
+	uint8_t			available_modes[CAMERA2_MAX_AVAILABLE_MODE];
+	uint32_t		hue_range[2];
+	uint32_t		saturation_range[2];
+	uint32_t		brightness_range[2];
+};
+
+enum tonemap_mode {
+	TONEMAP_MODE_FAST = 1,
+	TONEMAP_MODE_HIGH_QUALITY,
+	TONEMAP_MODE_CONTRAST_CURVE
+};
+
+struct camera2_tonemap_ctl {
+	enum tonemap_mode		mode;
+	/* assuming maxCurvePoints = 64 */
+	float				curve_red[64];
+	float				curve_green[64];
+	float				curve_blue[64];
+};
+
+struct camera2_tonemap_dm {
+	enum tonemap_mode		mode;
+	/* assuming maxCurvePoints = 64 */
+	float				curve_red[64];
+	float				curve_green[64];
+	float				curve_blue[64];
+};
+
+struct camera2_tonemap_sm {
+	uint32_t	max_curve_points;
+};
+
+struct camera2_edge_ctl {
+	enum processing_mode	mode;
+	uint32_t		strength;
+};
+
+struct camera2_edge_dm {
+	enum processing_mode	mode;
+	uint32_t		strength;
+};
+
+enum scaler_formats {
+	SCALER_FORMAT_BAYER_RAW,
+	SCALER_FORMAT_YV12,
+	SCALER_FORMAT_NV21,
+	SCALER_FORMAT_JPEG,
+	SCALER_FORMAT_UNKNOWN
+};
+
+struct camera2_scaler_ctl {
+	uint32_t	crop_region[3];
+};
+
+struct camera2_scaler_dm {
+	uint32_t	crop_region[3];
+};
+
+struct camera2_scaler_sm {
+	enum scaler_formats available_formats[4];
+	/* assuming # of availableFormats = 4 */
+	uint32_t	available_raw_sizes;
+	uint64_t	available_raw_min_durations;
+	/* needs check */
+	uint32_t	available_processed_sizes[8];
+	uint64_t	available_processed_min_durations[8];
+	uint32_t	available_jpeg_sizes[8][2];
+	uint64_t	available_jpeg_min_durations[8];
+	uint32_t	available_max_digital_zoom[8];
+};
+
+struct camera2_jpeg_ctl {
+	uint32_t	quality;
+	uint32_t	thumbnail_size[2];
+	uint32_t	thumbnail_quality;
+	double		gps_coordinates[3];
+	uint32_t	gps_processing_method;
+	uint64_t	gps_timestamp;
+	uint32_t	orientation;
+};
+
+struct camera2_jpeg_dm {
+	uint32_t	quality;
+	uint32_t	thumbnail_size[2];
+	uint32_t	thumbnail_quality;
+	double		gps_coordinates[3];
+	uint32_t	gps_processing_method;
+	uint64_t	gps_timestamp;
+	uint32_t	orientation;
+};
+
+struct camera2_jpeg_sm {
+	uint32_t	available_thumbnail_sizes[8][2];
+	uint32_t	maxsize;
+	/* assuming supported size=8 */
+};
+
+enum face_detect_mode {
+	FACEDETECT_MODE_OFF = 1,
+	FACEDETECT_MODE_SIMPLE,
+	FACEDETECT_MODE_FULL
+};
+
+enum stats_mode {
+	STATS_MODE_OFF = 1,
+	STATS_MODE_ON
+};
+
+struct camera2_stats_ctl {
+	enum face_detect_mode	face_detect_mode;
+	enum stats_mode		histogram_mode;
+	enum stats_mode		sharpness_map_mode;
+};
+
+
+struct camera2_stats_dm {
+	enum face_detect_mode	face_detect_mode;
+	uint32_t		face_rectangles[CAMERA2_MAX_FACES][4];
+	uint8_t			face_scores[CAMERA2_MAX_FACES];
+	uint32_t		face_landmarks[CAMERA2_MAX_FACES][6];
+	uint32_t		face_ids[CAMERA2_MAX_FACES];
+	enum stats_mode		histogram_mode;
+	uint32_t		histogram[3 * 256];
+	enum stats_mode		sharpness_map_mode;
+};
+
+
+struct camera2_stats_sm {
+	uint8_t		available_face_detect_modes[CAMERA2_MAX_AVAILABLE_MODE];
+	/* assuming supported modes = 3 */
+	uint32_t	max_face_count;
+	uint32_t	histogram_bucket_count;
+	uint32_t	max_histogram_count;
+	uint32_t	sharpness_map_size[2];
+	uint32_t	max_sharpness_map_value;
+};
+
+enum aa_capture_intent {
+	AA_CAPTURE_INTENT_CUSTOM = 0,
+	AA_CAPTURE_INTENT_PREVIEW,
+	AA_CAPTURE_INTENT_STILL_CAPTURE,
+	AA_CAPTURE_INTENT_VIDEO_RECORD,
+	AA_CAPTURE_INTENT_VIDEO_SNAPSHOT,
+	AA_CAPTURE_INTENT_ZERO_SHUTTER_LAG
+};
+
+enum aa_mode {
+	AA_CONTROL_OFF = 1,
+	AA_CONTROL_AUTO,
+	AA_CONTROL_USE_SCENE_MODE
+};
+
+enum aa_scene_mode {
+	AA_SCENE_MODE_UNSUPPORTED = 1,
+	AA_SCENE_MODE_FACE_PRIORITY,
+	AA_SCENE_MODE_ACTION,
+	AA_SCENE_MODE_PORTRAIT,
+	AA_SCENE_MODE_LANDSCAPE,
+	AA_SCENE_MODE_NIGHT,
+	AA_SCENE_MODE_NIGHT_PORTRAIT,
+	AA_SCENE_MODE_THEATRE,
+	AA_SCENE_MODE_BEACH,
+	AA_SCENE_MODE_SNOW,
+	AA_SCENE_MODE_SUNSET,
+	AA_SCENE_MODE_STEADYPHOTO,
+	AA_SCENE_MODE_FIREWORKS,
+	AA_SCENE_MODE_SPORTS,
+	AA_SCENE_MODE_PARTY,
+	AA_SCENE_MODE_CANDLELIGHT,
+	AA_SCENE_MODE_BARCODE,
+	AA_SCENE_MODE_NIGHT_CAPTURE
+};
+
+enum aa_effect_mode {
+	AA_EFFECT_OFF = 1,
+	AA_EFFECT_MONO,
+	AA_EFFECT_NEGATIVE,
+	AA_EFFECT_SOLARIZE,
+	AA_EFFECT_SEPIA,
+	AA_EFFECT_POSTERIZE,
+	AA_EFFECT_WHITEBOARD,
+	AA_EFFECT_BLACKBOARD,
+	AA_EFFECT_AQUA
+};
+
+enum aa_aemode {
+	AA_AEMODE_OFF = 1,
+	AA_AEMODE_LOCKED,
+	AA_AEMODE_ON,
+	AA_AEMODE_ON_AUTO_FLASH,
+	AA_AEMODE_ON_ALWAYS_FLASH,
+	AA_AEMODE_ON_AUTO_FLASH_REDEYE
+};
+
+enum aa_ae_flashmode {
+	/* all flash control stop */
+	AA_FLASHMODE_OFF = 1,
+	/* internal 3A can control flash */
+	AA_FLASHMODE_ON,
+	/* internal 3A can do auto flash algorithm */
+	AA_FLASHMODE_AUTO,
+	/* internal 3A can fire flash by auto result */
+	AA_FLASHMODE_CAPTURE,
+	/* internal 3A can control flash forced */
+	AA_FLASHMODE_ON_ALWAYS
+
+};
+
+enum aa_ae_antibanding_mode {
+	AA_AE_ANTIBANDING_OFF = 1,
+	AA_AE_ANTIBANDING_50HZ,
+	AA_AE_ANTIBANDING_60HZ,
+	AA_AE_ANTIBANDING_AUTO
+};
+
+enum aa_awbmode {
+	AA_AWBMODE_OFF = 1,
+	AA_AWBMODE_LOCKED,
+	AA_AWBMODE_WB_AUTO,
+	AA_AWBMODE_WB_INCANDESCENT,
+	AA_AWBMODE_WB_FLUORESCENT,
+	AA_AWBMODE_WB_WARM_FLUORESCENT,
+	AA_AWBMODE_WB_DAYLIGHT,
+	AA_AWBMODE_WB_CLOUDY_DAYLIGHT,
+	AA_AWBMODE_WB_TWILIGHT,
+	AA_AWBMODE_WB_SHADE
+};
+
+enum aa_afmode {
+	AA_AFMODE_OFF = 1,
+	AA_AFMODE_AUTO,
+	AA_AFMODE_MACRO,
+	AA_AFMODE_CONTINUOUS_VIDEO,
+	AA_AFMODE_CONTINUOUS_PICTURE,
+	AA_AFMODE_EDOF
+};
+
+enum aa_afstate {
+	AA_AFSTATE_INACTIVE = 1,
+	AA_AFSTATE_PASSIVE_SCAN,
+	AA_AFSTATE_ACTIVE_SCAN,
+	AA_AFSTATE_AF_ACQUIRED_FOCUS,
+	AA_AFSTATE_AF_FAILED_FOCUS
+};
+
+enum ae_state {
+	AE_STATE_INACTIVE = 1,
+	AE_STATE_SEARCHING,
+	AE_STATE_CONVERGED,
+	AE_STATE_LOCKED,
+	AE_STATE_FLASH_REQUIRED,
+	AE_STATE_PRECAPTURE
+};
+
+enum awb_state {
+	AWB_STATE_INACTIVE = 1,
+	AWB_STATE_SEARCHING,
+	AWB_STATE_CONVERGED,
+	AWB_STATE_LOCKED
+};
+
+enum aa_isomode {
+	AA_ISOMODE_AUTO = 1,
+	AA_ISOMODE_MANUAL,
+};
+
+struct camera2_aa_ctl {
+	enum aa_capture_intent		capture_intent;
+	enum aa_mode			mode;
+	enum aa_scene_mode		scene_mode;
+	uint32_t			video_stabilization_mode;
+	enum aa_aemode			ae_mode;
+	uint32_t			ae_regions[5];
+	/* 5 per region(x1,y1,x2,y2,weight). Currently assuming 1 region. */
+	int32_t				ae_exp_compensation;
+	uint32_t			ae_target_fps_range[2];
+	enum aa_ae_antibanding_mode	ae_anti_banding_mode;
+	enum aa_ae_flashmode		ae_flash_mode;
+	enum aa_awbmode			awb_mode;
+	uint32_t			awb_regions[5];
+	/* 5 per region(x1,y1,x2,y2,weight). Currently assuming 1 region. */
+	enum aa_afmode			af_mode;
+	uint32_t			af_regions[5];
+	/* 5 per region(x1,y1,x2,y2,weight). Currently assuming 1 region. */
+	uint32_t			af_trigger;
+	enum aa_isomode			iso_mode;
+	uint32_t			iso_value;
+
+};
+
+struct camera2_aa_dm {
+	enum aa_mode				mode;
+	enum aa_effect_mode			effect_mode;
+	enum aa_scene_mode			scene_mode;
+	uint32_t				video_stabilization_mode;
+	enum aa_aemode				ae_mode;
+	uint32_t				ae_regions[5];
+	/* 5 per region(x1,y1,x2,y2,weight). Currently assuming 1 region. */
+	enum ae_state				ae_state;
+	enum aa_ae_flashmode			ae_flash_mode;
+	enum aa_awbmode				awb_mode;
+	uint32_t				awb_regions[5];
+	enum awb_state				awb_state;
+	/* 5 per region(x1,y1,x2,y2,weight). Currently assuming 1 region. */
+	enum aa_afmode				af_mode;
+	uint32_t				af_regions[5];
+	/* 5 per region(x1,y1,x2,y2,weight). Currently assuming 1 region */
+	enum aa_afstate				af_state;
+	enum aa_isomode				iso_mode;
+	uint32_t				iso_value;
+};
+
+struct camera2_aa_sm {
+	uint8_t	available_scene_modes[CAMERA2_MAX_AVAILABLE_MODE];
+	uint8_t	available_effects[CAMERA2_MAX_AVAILABLE_MODE];
+	/* Assuming # of available scene modes = 10 */
+	uint32_t max_regions;
+	uint8_t ae_available_modes[CAMERA2_MAX_AVAILABLE_MODE];
+	/* Assuming # of available ae modes = 8 */
+	struct rational	ae_compensation_step;
+	int32_t	ae_compensation_range[2];
+	uint32_t ae_available_target_fps_ranges[CAMERA2_MAX_AVAILABLE_MODE][2];
+	uint8_t	 ae_available_antibanding_modes[CAMERA2_MAX_AVAILABLE_MODE];
+	uint8_t	awb_available_modes[CAMERA2_MAX_AVAILABLE_MODE];
+	/* Assuming # of awbAvailableModes = 10 */
+	uint8_t	af_available_modes[CAMERA2_MAX_AVAILABLE_MODE];
+	/* Assuming # of afAvailableModes = 4 */
+	uint8_t	available_video_stabilization_modes[4];
+	/* Assuming # of availableVideoStabilizationModes = 4 */
+	uint32_t iso_range[2];
+};
+
+struct camera2_lens_usm {
+	/* Frame delay between sending command and applying frame data */
+	uint32_t	focus_distance_frame_delay;
+};
+
+struct camera2_sensor_usm {
+	/* Frame delay between sending command and applying frame data */
+	uint32_t	exposure_time_frame_delay;
+	uint32_t	frame_duration_frame_delay;
+	uint32_t	sensitivity_frame_delay;
+};
+
+struct camera2_flash_usm {
+	/* Frame delay between sending command and applying frame data */
+	uint32_t	flash_mode_frame_delay;
+	uint32_t	firing_power_frame_delay;
+	uint64_t	firing_time_frame_delay;
+};
+
+struct camera2_ctl {
+	struct camera2_request_ctl		request;
+	struct camera2_lens_ctl			lens;
+	struct camera2_sensor_ctl		sensor;
+	struct camera2_flash_ctl		flash;
+	struct camera2_hotpixel_ctl		hotpixel;
+	struct camera2_demosaic_ctl		demosaic;
+	struct camera2_noise_reduction_ctl	noise;
+	struct camera2_shading_ctl		shading;
+	struct camera2_geometric_ctl		geometric;
+	struct camera2_color_correction_ctl	color;
+	struct camera2_tonemap_ctl		tonemap;
+	struct camera2_edge_ctl			edge;
+	struct camera2_scaler_ctl		scaler;
+	struct camera2_jpeg_ctl			jpeg;
+	struct camera2_stats_ctl		stats;
+	struct camera2_aa_ctl			aa;
+};
+
+struct camera2_dm {
+	struct camera2_request_dm		request;
+	struct camera2_lens_dm			lens;
+	struct camera2_sensor_dm		sensor;
+	struct camera2_flash_dm			flash;
+	struct camera2_hotpixel_dm		hotpixel;
+	struct camera2_demosaic_dm		demosaic;
+	struct camera2_noise_reduction_dm	noise;
+	struct camera2_shading_dm		shading;
+	struct camera2_geometric_dm		geometric;
+	struct camera2_color_correction_dm	color;
+	struct camera2_tonemap_dm		tonemap;
+	struct camera2_edge_dm			edge;
+	struct camera2_scaler_dm		scaler;
+	struct camera2_jpeg_dm			jpeg;
+	struct camera2_stats_dm			stats;
+	struct camera2_aa_dm			aa;
+};
+
+struct camera2_sm {
+	struct camera2_lens_sm			lens;
+	struct camera2_sensor_sm		sensor;
+	struct camera2_flash_sm			flash;
+	struct camera2_color_correction_sm	color;
+	struct camera2_tonemap_sm		tonemap;
+	struct camera2_scaler_sm		scaler;
+	struct camera2_jpeg_sm			jpeg;
+	struct camera2_stats_sm			stats;
+	struct camera2_aa_sm			aa;
+
+	/* User-defined(ispfw specific) static metadata. */
+	struct camera2_lens_usm			lensud;
+	struct camera2_sensor_usm		sensor_ud;
+	struct camera2_flash_usm		flash_ud;
+};
+
+/*
+ * User-defined control for lens.
+ */
+struct camera2_lens_uctl {
+	struct camera2_lens_ctl ctl;
+
+	/* It depends by af algorithm(normally 255 or 1023) */
+	uint32_t        max_pos;
+	/* Some actuator support slew rate control. */
+	uint32_t        slew_rate;
+};
+
+/*
+ * User-defined metadata for lens.
+ */
+struct camera2_lens_udm {
+	/* It depends by af algorithm(normally 255 or 1023) */
+	uint32_t        max_pos;
+	/* Some actuator support slew rate control. */
+	uint32_t        slew_rate;
+};
+
+/*
+ * User-defined control for sensor.
+ */
+struct camera2_sensor_uctl {
+	struct camera2_sensor_ctl ctl;
+	/* Dynamic frame duration.
+	 * This feature is decided to max. value between
+	 * 'sensor.exposureTime'+alpha and 'sensor.frameDuration'.
+	 */
+	uint64_t        dynamic_frame_duration;
+};
+
+struct camera2_scaler_uctl {
+	/* Target address for next frame.
+	 * [0] invalid address, stop
+	 * [others] valid address
+	 */
+	uint32_t scc_target_address[4];
+	uint32_t scp_target_address[4];
+};
+
+struct camera2_flash_uctl {
+	struct camera2_flash_ctl ctl;
+};
+
+struct camera2_uctl {
+	/* Set sensor, lens, flash control for next frame.
+	 * This flag can be combined.
+	 * [0 bit] lens
+	 * [1 bit] sensor
+	 * [2 bit] flash
+	 */
+	uint32_t u_update_bitmap;
+
+	/* For debugging */
+	uint32_t u_frame_number;
+
+	/* isp fw specific control (user-defined) of lens. */
+	struct camera2_lens_uctl	lens_ud;
+	/* isp fw specific control (user-defined) of sensor. */
+	struct camera2_sensor_uctl	sensor_ud;
+	/* isp fw specific control (user-defined) of flash. */
+	struct camera2_flash_uctl	flash_ud;
+
+	struct camera2_scaler_uctl	scaler_ud;
+};
+
+struct camera2_udm {
+	struct camera2_lens_udm		lens;
+};
+
+struct camera2_shot {
+	/* standard area */
+	struct camera2_ctl	ctl;
+	struct camera2_dm	dm;
+	/* user defined area */
+	struct camera2_uctl	uctl;
+	struct camera2_udm	udm;
+	/* magic : 23456789 */
+	uint32_t		magicnumber;
+};
+#endif
diff --git a/drivers/media/platform/exynos5-is/fimc-is-param.h b/drivers/media/platform/exynos5-is/fimc-is-param.h
new file mode 100644
index 0000000..015cc13
--- /dev/null
+++ b/drivers/media/platform/exynos5-is/fimc-is-param.h
@@ -0,0 +1,1159 @@
+/*
+ * Samsung Exynos5 SoC series FIMC-IS driver
+ *
+ * Copyright (c) 2013 Samsung Electronics Co., Ltd
+ * Kil-yeon Lim <kilyeon.im@samsung.com>
+ * Arun Kumar K <arun.kk@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef FIMC_IS_PARAM_H
+#define FIMC_IS_PARAM_H
+
+#define MAGIC_NUMBER 0x01020304
+
+#define PARAMETER_MAX_SIZE    128  /* in bytes */
+#define PARAMETER_MAX_MEMBER  (PARAMETER_MAX_SIZE / 4)
+
+enum is_param_set_bit {
+	PARAM_GLOBAL_SHOTMODE = 0,
+	PARAM_SENSOR_CONTROL,
+	PARAM_SENSOR_OTF_INPUT,
+	PARAM_SENSOR_OTF_OUTPUT,
+	PARAM_SENSOR_FRAME_RATE,
+	PARAM_SENSOR_DMA_OUTPUT,
+	PARAM_BUFFER_CONTROL,
+	PARAM_BUFFER_OTF_INPUT,
+	PARAM_BUFFER_OTF_OUTPUT,
+	PARAM_ISP_CONTROL,
+	PARAM_ISP_OTF_INPUT = 10,
+	PARAM_ISP_DMA1_INPUT,
+	PARAM_ISP_DMA2_INPUT,
+	PARAM_ISP_AA,
+	PARAM_ISP_FLASH,
+	PARAM_ISP_AWB,
+	PARAM_ISP_IMAGE_EFFECT,
+	PARAM_ISP_ISO,
+	PARAM_ISP_ADJUST,
+	PARAM_ISP_METERING,
+	PARAM_ISP_AFC = 20,
+	PARAM_ISP_OTF_OUTPUT,
+	PARAM_ISP_DMA1_OUTPUT,
+	PARAM_ISP_DMA2_OUTPUT,
+	PARAM_DRC_CONTROL,
+	PARAM_DRC_OTF_INPUT,
+	PARAM_DRC_DMA_INPUT,
+	PARAM_DRC_OTF_OUTPUT,
+	PARAM_SCALERC_CONTROL,
+	PARAM_SCALERC_OTF_INPUT,
+	PARAM_SCALERC_IMAGE_EFFECT = 30,
+	PARAM_SCALERC_INPUT_CROP,
+	PARAM_SCALERC_OUTPUT_CROP,
+	PARAM_SCALERC_OTF_OUTPUT,
+	PARAM_SCALERC_DMA_OUTPUT = 34,
+	PARAM_ODC_CONTROL,
+	PARAM_ODC_OTF_INPUT,
+	PARAM_ODC_OTF_OUTPUT,
+	PARAM_DIS_CONTROL,
+	PARAM_DIS_OTF_INPUT,
+	PARAM_DIS_OTF_OUTPUT = 40,
+	PARAM_TDNR_CONTROL,
+	PARAM_TDNR_OTF_INPUT,
+	PARAM_TDNR_1ST_FRAME,
+	PARAM_TDNR_OTF_OUTPUT,
+	PARAM_TDNR_DMA_OUTPUT,
+	PARAM_SCALERP_CONTROL,
+	PARAM_SCALERP_OTF_INPUT,
+	PARAM_SCALERP_IMAGE_EFFECT,
+	PARAM_SCALERP_INPUT_CROP,
+	PARAM_SCALERP_OUTPUT_CROP = 50,
+	PARAM_SCALERP_ROTATION,
+	PARAM_SCALERP_FLIP,
+	PARAM_SCALERP_OTF_OUTPUT,
+	PARAM_SCALERP_DMA_OUTPUT,
+	PARAM_FD_CONTROL,
+	PARAM_FD_OTF_INPUT,
+	PARAM_FD_DMA_INPUT,
+	PARAM_FD_CONFIG = 58,
+	PARAM_END,
+};
+
+/* ----------------------  Input  ----------------------------------- */
+enum control_command {
+	CONTROL_COMMAND_STOP	= 0,
+	CONTROL_COMMAND_START	= 1,
+	CONTROL_COMMAND_TEST	= 2
+};
+
+enum bypass_command {
+	CONTROL_BYPASS_DISABLE		= 0,
+	CONTROL_BYPASS_ENABLE		= 1
+};
+
+enum control_error {
+	CONTROL_ERROR_NONE		= 0
+};
+
+enum otf_input_command {
+	OTF_INPUT_COMMAND_DISABLE	= 0,
+	OTF_INPUT_COMMAND_ENABLE	= 1
+};
+
+enum otf_input_format {
+	OTF_INPUT_FORMAT_BAYER		= 0, /* 1 Channel */
+	OTF_INPUT_FORMAT_YUV444		= 1, /* 3 Channel */
+	OTF_INPUT_FORMAT_YUV422		= 2, /* 3 Channel */
+	OTF_INPUT_FORMAT_YUV420		= 3, /* 3 Channel */
+	OTF_INPUT_FORMAT_STRGEN_COLORBAR_BAYER = 10,
+	OTF_INPUT_FORMAT_BAYER_DMA	= 11,
+};
+
+enum otf_input_bitwidth {
+	OTF_INPUT_BIT_WIDTH_14BIT	= 14,
+	OTF_INPUT_BIT_WIDTH_12BIT	= 12,
+	OTF_INPUT_BIT_WIDTH_11BIT	= 11,
+	OTF_INPUT_BIT_WIDTH_10BIT	= 10,
+	OTF_INPUT_BIT_WIDTH_9BIT	= 9,
+	OTF_INPUT_BIT_WIDTH_8BIT	= 8
+};
+
+enum otf_input_order {
+	OTF_INPUT_ORDER_BAYER_GR_BG	= 0,
+	OTF_INPUT_ORDER_BAYER_RG_GB	= 1,
+	OTF_INPUT_ORDER_BAYER_BG_GR	= 2,
+	OTF_INPUT_ORDER_BAYER_GB_RG	= 3
+};
+
+enum otf_intput_error {
+	OTF_INPUT_ERROR_NONE		= 0 /* Input setting is done */
+};
+
+enum dma_input_command {
+	DMA_INPUT_COMMAND_DISABLE	= 0,
+	DMA_INPUT_COMMAND_ENABLE	= 1,
+	DMA_INPUT_COMMAND_BUF_MNGR	= 2,
+	DMA_INPUT_COMMAND_RUN_SINGLE	= 3,
+};
+
+enum dma_inut_format {
+	DMA_INPUT_FORMAT_BAYER		= 0,
+	DMA_INPUT_FORMAT_YUV444		= 1,
+	DMA_INPUT_FORMAT_YUV422		= 2,
+	DMA_INPUT_FORMAT_YUV420		= 3,
+};
+
+enum dma_input_bitwidth {
+	DMA_INPUT_BIT_WIDTH_14BIT	= 14,
+	DMA_INPUT_BIT_WIDTH_12BIT	= 12,
+	DMA_INPUT_BIT_WIDTH_11BIT	= 11,
+	DMA_INPUT_BIT_WIDTH_10BIT	= 10,
+	DMA_INPUT_BIT_WIDTH_9BIT	= 9,
+	DMA_INPUT_BIT_WIDTH_8BIT	= 8
+};
+
+enum dma_input_order {
+	DMA_INPUT_ORDER_NONE	= 0,
+	DMA_INPUT_ORDER_CBCR	= 1,
+	DMA_INPUT_ORDER_CRCB	= 2,
+	DMA_INPUT_ORDER_YCBCR	= 3,
+	DMA_INPUT_ORDER_YYCBCR	= 4,
+	DMA_INPUT_ORDER_YCBYCR	= 5,
+	DMA_INPUT_ORDER_YCRYCB	= 6,
+	DMA_INPUT_ORDER_CBYCRY	= 7,
+	DMA_INPUT_ORDER_CRYCBY	= 8,
+	DMA_INPUT_ORDER_GR_BG	= 9
+};
+
+enum dma_input_error {
+	DMA_INPUT_ERROR_NONE	= 0 /*  DMA input setting is done */
+};
+
+/* ----------------------  Output  ----------------------------------- */
+enum otf_output_crop {
+	OTF_OUTPUT_CROP_DISABLE		= 0,
+	OTF_OUTPUT_CROP_ENABLE		= 1
+};
+
+enum otf_output_command {
+	OTF_OUTPUT_COMMAND_DISABLE	= 0,
+	OTF_OUTPUT_COMMAND_ENABLE	= 1
+};
+
+enum orf_output_format {
+	OTF_OUTPUT_FORMAT_YUV444	= 1,
+	OTF_OUTPUT_FORMAT_YUV422	= 2,
+	OTF_OUTPUT_FORMAT_YUV420	= 3,
+	OTF_OUTPUT_FORMAT_RGB		= 4
+};
+
+enum otf_output_bitwidth {
+	OTF_OUTPUT_BIT_WIDTH_14BIT	= 14,
+	OTF_OUTPUT_BIT_WIDTH_12BIT	= 12,
+	OTF_OUTPUT_BIT_WIDTH_11BIT	= 11,
+	OTF_OUTPUT_BIT_WIDTH_10BIT	= 10,
+	OTF_OUTPUT_BIT_WIDTH_9BIT	= 9,
+	OTF_OUTPUT_BIT_WIDTH_8BIT	= 8
+};
+
+enum otf_output_order {
+	OTF_OUTPUT_ORDER_BAYER_GR_BG	= 0,
+};
+
+enum otf_output_error {
+	OTF_OUTPUT_ERROR_NONE = 0 /* Output Setting is done */
+};
+
+enum dma_output_command {
+	DMA_OUTPUT_COMMAND_DISABLE	= 0,
+	DMA_OUTPUT_COMMAND_ENABLE	= 1,
+	DMA_OUTPUT_COMMAND_BUF_MNGR	= 2,
+	DMA_OUTPUT_UPDATE_MASK_BITS	= 3
+};
+
+enum dma_output_format {
+	DMA_OUTPUT_FORMAT_BAYER		= 0,
+	DMA_OUTPUT_FORMAT_YUV444	= 1,
+	DMA_OUTPUT_FORMAT_YUV422	= 2,
+	DMA_OUTPUT_FORMAT_YUV420	= 3,
+	DMA_OUTPUT_FORMAT_RGB		= 4
+};
+
+enum dma_output_bitwidth {
+	DMA_OUTPUT_BIT_WIDTH_14BIT	= 14,
+	DMA_OUTPUT_BIT_WIDTH_12BIT	= 12,
+	DMA_OUTPUT_BIT_WIDTH_11BIT	= 11,
+	DMA_OUTPUT_BIT_WIDTH_10BIT	= 10,
+	DMA_OUTPUT_BIT_WIDTH_9BIT	= 9,
+	DMA_OUTPUT_BIT_WIDTH_8BIT	= 8
+};
+
+enum dma_output_order {
+	DMA_OUTPUT_ORDER_NONE		= 0,
+	DMA_OUTPUT_ORDER_CBCR		= 1,
+	DMA_OUTPUT_ORDER_CRCB		= 2,
+	DMA_OUTPUT_ORDER_YYCBCR		= 3,
+	DMA_OUTPUT_ORDER_YCBYCR		= 4,
+	DMA_OUTPUT_ORDER_YCRYCB		= 5,
+	DMA_OUTPUT_ORDER_CBYCRY		= 6,
+	DMA_OUTPUT_ORDER_CRYCBY		= 7,
+	DMA_OUTPUT_ORDER_YCBCR		= 8,
+	DMA_OUTPUT_ORDER_CRYCB		= 9,
+	DMA_OUTPUT_ORDER_CRCBY		= 10,
+	DMA_OUTPUT_ORDER_CBYCR		= 11,
+	DMA_OUTPUT_ORDER_YCRCB		= 12,
+	DMA_OUTPUT_ORDER_CBCRY		= 13,
+	DMA_OUTPUT_ORDER_BGR		= 14,
+	DMA_OUTPUT_ORDER_GB_BG		= 15
+};
+
+enum dma_output_notify_dma_done {
+	DMA_OUTPUT_NOTIFY_DMA_DONE_DISABLE	= 0,
+	DMA_OUTPUT_NOTIFY_DMA_DONE_ENBABLE	= 1,
+};
+
+enum dma_output_error {
+	DMA_OUTPUT_ERROR_NONE		= 0 /* DMA output setting is done */
+};
+
+/* ----------------------  Global  ----------------------------------- */
+enum global_shotmode_error {
+	GLOBAL_SHOTMODE_ERROR_NONE	= 0 /* shot-mode setting is done */
+};
+
+/* -------------------------  AA  ------------------------------------ */
+enum isp_lock_command {
+	ISP_AA_COMMAND_START	= 0,
+	ISP_AA_COMMAND_STOP	= 1
+};
+
+enum isp_lock_target {
+	ISP_AA_TARGET_AF	= 1,
+	ISP_AA_TARGET_AE	= 2,
+	ISP_AA_TARGET_AWB	= 4
+};
+
+enum isp_af_mode {
+	ISP_AF_MANUAL = 0,
+	ISP_AF_SINGLE,
+	ISP_AF_CONTINUOUS,
+	ISP_AF_REGION,
+	ISP_AF_SLEEP,
+	ISP_AF_INIT,
+	ISP_AF_SET_CENTER_WINDOW,
+	ISP_AF_SET_TOUCH_WINDOW,
+	ISP_AF_SET_FACE_WINDOW
+};
+
+enum isp_af_scene {
+	ISP_AF_SCENE_NORMAL		= 0,
+	ISP_AF_SCENE_MACRO		= 1
+};
+
+enum isp_af_touch {
+	ISP_AF_TOUCH_DISABLE = 0,
+	ISP_AF_TOUCH_ENABLE
+};
+
+enum isp_af_face {
+	ISP_AF_FACE_DISABLE = 0,
+	ISP_AF_FACE_ENABLE
+};
+
+enum isp_af_reponse {
+	ISP_AF_RESPONSE_PREVIEW = 0,
+	ISP_AF_RESPONSE_MOVIE
+};
+
+enum isp_af_sleep {
+	ISP_AF_SLEEP_OFF		= 0,
+	ISP_AF_SLEEP_ON			= 1
+};
+
+enum isp_af_continuous {
+	ISP_AF_CONTINUOUS_DISABLE	= 0,
+	ISP_AF_CONTINUOUS_ENABLE	= 1
+};
+
+enum isp_af_error {
+	ISP_AF_ERROR_NONE		= 0, /* AF mode change is done */
+	ISP_AF_EROOR_NO_LOCK_DONE	= 1  /* AF lock is done */
+};
+
+/* -------------------------  Flash  ------------------------------------- */
+enum isp_flash_command {
+	ISP_FLASH_COMMAND_DISABLE	= 0,
+	ISP_FLASH_COMMAND_MANUALON	= 1, /* (forced flash) */
+	ISP_FLASH_COMMAND_AUTO		= 2,
+	ISP_FLASH_COMMAND_TORCH		= 3,   /* 3 sec */
+	ISP_FLASH_COMMAND_FLASH_ON	= 4,
+	ISP_FLASH_COMMAND_CAPTURE	= 5,
+	ISP_FLASH_COMMAND_TRIGGER	= 6,
+	ISP_FLASH_COMMAND_CALIBRATION	= 7
+};
+
+enum isp_flash_redeye {
+	ISP_FLASH_REDEYE_DISABLE	= 0,
+	ISP_FLASH_REDEYE_ENABLE		= 1
+};
+
+enum isp_flash_error {
+	ISP_FLASH_ERROR_NONE		= 0 /* Flash setting is done */
+};
+
+/* --------------------------  AWB  ------------------------------------ */
+enum isp_awb_command {
+	ISP_AWB_COMMAND_AUTO		= 0,
+	ISP_AWB_COMMAND_ILLUMINATION	= 1,
+	ISP_AWB_COMMAND_MANUAL	= 2
+};
+
+enum isp_awb_illumination {
+	ISP_AWB_ILLUMINATION_DAYLIGHT		= 0,
+	ISP_AWB_ILLUMINATION_CLOUDY		= 1,
+	ISP_AWB_ILLUMINATION_TUNGSTEN		= 2,
+	ISP_AWB_ILLUMINATION_FLUORESCENT	= 3
+};
+
+enum isp_awb_error {
+	ISP_AWB_ERROR_NONE		= 0 /* AWB setting is done */
+};
+
+/* --------------------------  Effect  ----------------------------------- */
+enum isp_imageeffect_command {
+	ISP_IMAGE_EFFECT_DISABLE		= 0,
+	ISP_IMAGE_EFFECT_MONOCHROME		= 1,
+	ISP_IMAGE_EFFECT_NEGATIVE_MONO		= 2,
+	ISP_IMAGE_EFFECT_NEGATIVE_COLOR		= 3,
+	ISP_IMAGE_EFFECT_SEPIA			= 4,
+	ISP_IMAGE_EFFECT_AQUA			= 5,
+	ISP_IMAGE_EFFECT_EMBOSS			= 6,
+	ISP_IMAGE_EFFECT_EMBOSS_MONO		= 7,
+	ISP_IMAGE_EFFECT_SKETCH			= 8,
+	ISP_IMAGE_EFFECT_RED_YELLOW_POINT	= 9,
+	ISP_IMAGE_EFFECT_GREEN_POINT		= 10,
+	ISP_IMAGE_EFFECT_BLUE_POINT		= 11,
+	ISP_IMAGE_EFFECT_MAGENTA_POINT		= 12,
+	ISP_IMAGE_EFFECT_WARM_VINTAGE		= 13,
+	ISP_IMAGE_EFFECT_COLD_VINTAGE		= 14,
+	ISP_IMAGE_EFFECT_POSTERIZE		= 15,
+	ISP_IMAGE_EFFECT_SOLARIZE		= 16,
+	ISP_IMAGE_EFFECT_WASHED			= 17,
+	ISP_IMAGE_EFFECT_CCM			= 18,
+};
+
+enum isp_imageeffect_error {
+	ISP_IMAGE_EFFECT_ERROR_NONE	= 0 /* Image effect setting is done */
+};
+
+/* ---------------------------  ISO  ------------------------------------ */
+enum isp_iso_command {
+	ISP_ISO_COMMAND_AUTO		= 0,
+	ISP_ISO_COMMAND_MANUAL		= 1
+};
+
+enum iso_error {
+	ISP_ISO_ERROR_NONE		= 0 /* ISO setting is done */
+};
+
+/* --------------------------  Adjust  ----------------------------------- */
+enum iso_adjust_command {
+	ISP_ADJUST_COMMAND_AUTO			= 0,
+	ISP_ADJUST_COMMAND_MANUAL_CONTRAST	= (1 << 0),
+	ISP_ADJUST_COMMAND_MANUAL_SATURATION	= (1 << 1),
+	ISP_ADJUST_COMMAND_MANUAL_SHARPNESS	= (1 << 2),
+	ISP_ADJUST_COMMAND_MANUAL_EXPOSURE	= (1 << 3),
+	ISP_ADJUST_COMMAND_MANUAL_BRIGHTNESS	= (1 << 4),
+	ISP_ADJUST_COMMAND_MANUAL_HUE		= (1 << 5),
+	ISP_ADJUST_COMMAND_MANUAL_HOTPIXEL	= (1 << 6),
+	ISP_ADJUST_COMMAND_MANUAL_NOISEREDUCTION = (1 << 7),
+	ISP_ADJUST_COMMAND_MANUAL_SHADING	= (1 << 8),
+	ISP_ADJUST_COMMAND_MANUAL_GAMMA		= (1 << 9),
+	ISP_ADJUST_COMMAND_MANUAL_EDGEENHANCEMENT = (1 << 10),
+	ISP_ADJUST_COMMAND_MANUAL_SCENE		= (1 << 11),
+	ISP_ADJUST_COMMAND_MANUAL_FRAMETIME	= (1 << 12),
+	ISP_ADJUST_COMMAND_MANUAL_ALL		= 0x1fff
+};
+
+enum isp_adjust_scene_index {
+	ISP_ADJUST_SCENE_NORMAL			= 0,
+	ISP_ADJUST_SCENE_NIGHT_PREVIEW		= 1,
+	ISP_ADJUST_SCENE_NIGHT_CAPTURE		= 2
+};
+
+
+enum isp_adjust_error {
+	ISP_ADJUST_ERROR_NONE		= 0 /* Adjust setting is done */
+};
+
+/* -------------------------  Metering  ---------------------------------- */
+enum isp_metering_command {
+	ISP_METERING_COMMAND_AVERAGE		= 0,
+	ISP_METERING_COMMAND_SPOT		= 1,
+	ISP_METERING_COMMAND_MATRIX		= 2,
+	ISP_METERING_COMMAND_CENTER		= 3,
+	ISP_METERING_COMMAND_EXPOSURE_MODE	= (1 << 8)
+};
+
+enum isp_exposure_mode {
+	ISP_EXPOSUREMODE_OFF		= 1,
+	ISP_EXPOSUREMODE_AUTO		= 2
+};
+
+enum isp_metering_error {
+	ISP_METERING_ERROR_NONE	= 0 /* Metering setting is done */
+};
+
+/* --------------------------  AFC  ----------------------------------- */
+enum isp_afc_command {
+	ISP_AFC_COMMAND_DISABLE		= 0,
+	ISP_AFC_COMMAND_AUTO		= 1,
+	ISP_AFC_COMMAND_MANUAL		= 2
+};
+
+enum isp_afc_manual {
+	ISP_AFC_MANUAL_50HZ		= 50,
+	ISP_AFC_MANUAL_60HZ		= 60
+};
+
+enum isp_afc_error {
+	ISP_AFC_ERROR_NONE	= 0 /* AFC setting is done */
+};
+
+enum isp_scene_command {
+	ISP_SCENE_NONE		= 0,
+	ISP_SCENE_PORTRAIT	= 1,
+	ISP_SCENE_LANDSCAPE     = 2,
+	ISP_SCENE_SPORTS        = 3,
+	ISP_SCENE_PARTYINDOOR	= 4,
+	ISP_SCENE_BEACHSNOW	= 5,
+	ISP_SCENE_SUNSET	= 6,
+	ISP_SCENE_DAWN		= 7,
+	ISP_SCENE_FALL		= 8,
+	ISP_SCENE_NIGHT		= 9,
+	ISP_SCENE_AGAINSTLIGHTWLIGHT	= 10,
+	ISP_SCENE_AGAINSTLIGHTWOLIGHT	= 11,
+	ISP_SCENE_FIRE			= 12,
+	ISP_SCENE_TEXT			= 13,
+	ISP_SCENE_CANDLE		= 14
+};
+
+/* --------------------------  Scaler  --------------------------------- */
+enum scaler_imageeffect_command {
+	SCALER_IMAGE_EFFECT_COMMNAD_DISABLE	= 0,
+	SCALER_IMAGE_EFFECT_COMMNAD_SEPIA_CB	= 1,
+	SCALER_IMAGE_EFFECT_COMMAND_SEPIA_CR	= 2,
+	SCALER_IMAGE_EFFECT_COMMAND_NEGATIVE	= 3,
+	SCALER_IMAGE_EFFECT_COMMAND_ARTFREEZE	= 4,
+	SCALER_IMAGE_EFFECT_COMMAND_EMBOSSING	= 5,
+	SCALER_IMAGE_EFFECT_COMMAND_SILHOUETTE	= 6
+};
+
+enum scaler_imageeffect_error {
+	SCALER_IMAGE_EFFECT_ERROR_NONE		= 0
+};
+
+enum scaler_crop_command {
+	SCALER_CROP_COMMAND_DISABLE		= 0,
+	SCALER_CROP_COMMAND_ENABLE		= 1
+};
+
+enum scaler_crop_error {
+	SCALER_CROP_ERROR_NONE			= 0 /* crop setting is done */
+};
+
+enum scaler_scaling_command {
+	SCALER_SCALING_COMMNAD_DISABLE		= 0,
+	SCALER_SCALING_COMMAND_UP		= 1,
+	SCALER_SCALING_COMMAND_DOWN		= 2
+};
+
+enum scaler_scaling_error {
+	SCALER_SCALING_ERROR_NONE		= 0
+};
+
+enum scaler_rotation_command {
+	SCALER_ROTATION_COMMAND_DISABLE		= 0,
+	SCALER_ROTATION_COMMAND_CLOCKWISE90	= 1
+};
+
+enum scaler_rotation_error {
+	SCALER_ROTATION_ERROR_NONE		= 0
+};
+
+enum scaler_flip_command {
+	SCALER_FLIP_COMMAND_NORMAL		= 0,
+	SCALER_FLIP_COMMAND_X_MIRROR		= 1,
+	SCALER_FLIP_COMMAND_Y_MIRROR		= 2,
+	SCALER_FLIP_COMMAND_XY_MIRROR		= 3 /* (180 rotation) */
+};
+
+enum scaler_flip_error {
+	SCALER_FLIP_ERROR_NONE			= 0 /* flip setting is done */
+};
+
+/* --------------------------  3DNR  ----------------------------------- */
+enum tdnr_1st_frame_command {
+	TDNR_1ST_FRAME_COMMAND_NOPROCESSING	= 0,
+	TDNR_1ST_FRAME_COMMAND_2DNR		= 1
+};
+
+enum tdnr_1st_frame_error {
+	TDNR_1ST_FRAME_ERROR_NONE		= 0
+};
+
+/* ----------------------------  FD  ------------------------------------- */
+enum fd_config_command {
+	FD_CONFIG_COMMAND_MAXIMUM_NUMBER	= 0x1,
+	FD_CONFIG_COMMAND_ROLL_ANGLE		= 0x2,
+	FD_CONFIG_COMMAND_YAW_ANGLE		= 0x4,
+	FD_CONFIG_COMMAND_SMILE_MODE		= 0x8,
+	FD_CONFIG_COMMAND_BLINK_MODE		= 0x10,
+	FD_CONFIG_COMMAND_EYES_DETECT		= 0x20,
+	FD_CONFIG_COMMAND_MOUTH_DETECT		= 0x40,
+	FD_CONFIG_COMMAND_ORIENTATION		= 0x80,
+	FD_CONFIG_COMMAND_ORIENTATION_VALUE	= 0x100
+};
+
+enum fd_config_roll_angle {
+	FD_CONFIG_ROLL_ANGLE_BASIC		= 0,
+	FD_CONFIG_ROLL_ANGLE_PRECISE_BASIC	= 1,
+	FD_CONFIG_ROLL_ANGLE_SIDES		= 2,
+	FD_CONFIG_ROLL_ANGLE_PRECISE_SIDES	= 3,
+	FD_CONFIG_ROLL_ANGLE_FULL		= 4,
+	FD_CONFIG_ROLL_ANGLE_PRECISE_FULL	= 5,
+};
+
+enum fd_config_yaw_angle {
+	FD_CONFIG_YAW_ANGLE_0			= 0,
+	FD_CONFIG_YAW_ANGLE_45			= 1,
+	FD_CONFIG_YAW_ANGLE_90			= 2,
+	FD_CONFIG_YAW_ANGLE_45_90		= 3,
+};
+
+enum fd_config_smile_mode {
+	FD_CONFIG_SMILE_MODE_DISABLE		= 0,
+	FD_CONFIG_SMILE_MODE_ENABLE		= 1
+};
+
+enum fd_config_blink_mode {
+	FD_CONFIG_BLINK_MODE_DISABLE		= 0,
+	FD_CONFIG_BLINK_MODE_ENABLE		= 1
+};
+
+enum fd_config_eye_result {
+	FD_CONFIG_EYES_DETECT_DISABLE		= 0,
+	FD_CONFIG_EYES_DETECT_ENABLE		= 1
+};
+
+enum fd_config_mouth_result {
+	FD_CONFIG_MOUTH_DETECT_DISABLE		= 0,
+	FD_CONFIG_MOUTH_DETECT_ENABLE		= 1
+};
+
+enum fd_config_orientation {
+	FD_CONFIG_ORIENTATION_DISABLE		= 0,
+	FD_CONFIG_ORIENTATION_ENABLE		= 1
+};
+
+struct param_control {
+	u32 cmd;
+	u32 bypass;
+	u32 buffer_address;
+	u32 buffer_number;
+	/* 0: continuous, 1: single */
+	u32 run_mode;
+	u32 reserved[PARAMETER_MAX_MEMBER - 6];
+	u32 err;
+};
+
+struct param_otf_input {
+	u32 cmd;
+	u32 width;
+	u32 height;
+	u32 format;
+	u32 bitwidth;
+	u32 order;
+	u32 crop_offset_x;
+	u32 crop_offset_y;
+	u32 crop_width;
+	u32 crop_height;
+	u32 frametime_min;
+	u32 frametime_max;
+	u32 reserved[PARAMETER_MAX_MEMBER - 13];
+	u32 err;
+};
+
+struct param_dma_input {
+	u32 cmd;
+	u32 width;
+	u32 height;
+	u32 format;
+	u32 bitwidth;
+	u32 plane;
+	u32 order;
+	u32 buffer_number;
+	u32 buffer_address;
+	u32 bayer_crop_offset_x;
+	u32 bayer_crop_offset_y;
+	u32 bayer_crop_width;
+	u32 bayer_crop_height;
+	u32 dma_crop_offset_x;
+	u32 dma_crop_offset_y;
+	u32 dma_crop_width;
+	u32 dma_crop_height;
+	u32 user_min_frametime;
+	u32 user_max_frametime;
+	u32 wide_frame_gap;
+	u32 frame_gap;
+	u32 line_gap;
+	u32 reserved[PARAMETER_MAX_MEMBER - 23];
+	u32 err;
+};
+
+struct param_otf_output {
+	u32 cmd;
+	u32 width;
+	u32 height;
+	u32 format;
+	u32 bitwidth;
+	u32 order;
+	u32 crop_offset_x;
+	u32 crop_offset_y;
+	u32 reserved[PARAMETER_MAX_MEMBER - 9];
+	u32 err;
+};
+
+struct param_dma_output {
+	u32 cmd;
+	u32 width;
+	u32 height;
+	u32 format;
+	u32 bitwidth;
+	u32 plane;
+	u32 order;
+	u32 buffer_number;
+	u32 buffer_address;
+	u32 notify_dma_done;
+	u32 dma_out_mask;
+	u32 reserved[PARAMETER_MAX_MEMBER - 12];
+	u32 err;
+};
+
+struct param_global_shotmode {
+	u32 cmd;
+	u32 skip_frames;
+	u32 reserved[PARAMETER_MAX_MEMBER - 3];
+	u32 err;
+};
+
+struct param_sensor_framerate {
+	u32 frame_rate;
+	u32 reserved[PARAMETER_MAX_MEMBER - 2];
+	u32 err;
+};
+
+struct param_isp_aa {
+	u32 cmd;
+	u32 target;
+	u32 mode;
+	u32 scene;
+	u32 af_touch;
+	u32 af_face;
+	u32 af_response;
+	u32 sleep;
+	u32 touch_x;
+	u32 touch_y;
+	u32 manual_af_setting;
+	/* 0: Legacy, 1: Camera 2.0 */
+	u32 cam_api2p0;
+	/*
+	 * For android.control.afRegions in Camera 2.0,
+	 * Resolution based on YUV output size
+	 */
+	u32 af_region_left;
+	u32 af_region_top;
+	u32 af_region_right;
+	u32 af_region_bottom;
+	u32 reserved[PARAMETER_MAX_MEMBER - 17];
+	u32 err;
+};
+
+struct param_isp_flash {
+	u32 cmd;
+	u32 redeye;
+	u32 flash_intensity;
+	u32 reserved[PARAMETER_MAX_MEMBER - 4];
+	u32 err;
+};
+
+struct param_isp_awb {
+	u32 cmd;
+	u32 illumination;
+	u32 reserved[PARAMETER_MAX_MEMBER - 3];
+	u32 err;
+};
+
+struct param_isp_imageeffect {
+	u32 cmd;
+	u32 reserved[PARAMETER_MAX_MEMBER - 2];
+	u32 err;
+};
+
+struct param_isp_iso {
+	u32 cmd;
+	u32 value;
+	u32 reserved[PARAMETER_MAX_MEMBER - 3];
+	u32 err;
+};
+
+struct param_isp_adjust {
+	u32 cmd;
+	s32 contrast;
+	s32 saturation;
+	s32 sharpness;
+	s32 exposure;
+	s32 brightness;
+	s32 hue;
+	/* 0 or 1 */
+	u32 hotpixel_enable;
+	/* -127 ~ 127 */
+	s32 noise_reduction_strength;
+	/* 0 or 1 */
+	u32 shading_correction_enable;
+	/* 0 or 1 */
+	u32 user_gamma_enable;
+	/* -127 ~ 127 */
+	s32 edge_enhancement_strength;
+	u32 user_scene_mode;
+	u32 min_frametime;
+	u32 max_frametime;
+	u32 reserved[PARAMETER_MAX_MEMBER - 16];
+	u32 err;
+};
+
+struct param_isp_metering {
+	u32 cmd;
+	u32 win_pos_x;
+	u32 win_pos_y;
+	u32 win_width;
+	u32 win_height;
+	u32 exposure_mode;
+	/* 0: Legacy, 1: Camera 2.0 */
+	u32 cam_api2p0;
+	u32 reserved[PARAMETER_MAX_MEMBER - 8];
+	u32 err;
+};
+
+struct param_isp_afc {
+	u32 cmd;
+	u32 manual;
+	u32 reserved[PARAMETER_MAX_MEMBER - 3];
+	u32 err;
+};
+
+struct param_scaler_imageeffect {
+	u32 cmd;
+	u32 reserved[PARAMETER_MAX_MEMBER - 2];
+	u32 err;
+};
+
+struct param_scaler_input_crop {
+	u32  cmd;
+	u32  pos_x;
+	u32  pos_y;
+	u32  crop_width;
+	u32  crop_height;
+	u32  in_width;
+	u32  in_height;
+	u32  out_width;
+	u32  out_height;
+	u32  reserved[PARAMETER_MAX_MEMBER - 10];
+	u32  err;
+};
+
+struct param_scaler_output_crop {
+	u32  cmd;
+	u32  pos_x;
+	u32  pos_y;
+	u32  crop_width;
+	u32  crop_height;
+	u32  format;
+	u32  reserved[PARAMETER_MAX_MEMBER - 7];
+	u32  err;
+};
+
+struct param_scaler_rotation {
+	u32 cmd;
+	u32 reserved[PARAMETER_MAX_MEMBER - 2];
+	u32 err;
+};
+
+struct param_scaler_flip {
+	u32 cmd;
+	u32 reserved[PARAMETER_MAX_MEMBER - 2];
+	u32 err;
+};
+
+struct param_3dnr_1stframe {
+	u32 cmd;
+	u32 reserved[PARAMETER_MAX_MEMBER - 2];
+	u32 err;
+};
+
+struct param_fd_config {
+	u32 cmd;
+	u32 max_number;
+	u32 roll_angle;
+	u32 yaw_angle;
+	s32 smile_mode;
+	s32 blink_mode;
+	u32 eye_detect;
+	u32 mouth_detect;
+	u32 orientation;
+	u32 orientation_value;
+	u32 reserved[PARAMETER_MAX_MEMBER - 11];
+	u32 err;
+};
+
+struct global_param {
+	struct param_global_shotmode shotmode;
+};
+
+struct sensor_param {
+	struct param_control		control;
+	struct param_otf_input		otf_input;
+	struct param_otf_output		otf_output;
+	struct param_sensor_framerate	frame_rate;
+	struct param_dma_output		dma_output;
+};
+
+struct buffer_param {
+	struct param_control	control;
+	struct param_otf_input	otf_input;
+	struct param_otf_output	otf_output;
+};
+
+struct isp_param {
+	struct param_control		control;
+	struct param_otf_input		otf_input;
+	struct param_dma_input		dma1_input;
+	struct param_dma_input		dma2_input;
+	struct param_isp_aa		aa;
+	struct param_isp_flash		flash;
+	struct param_isp_awb		awb;
+	struct param_isp_imageeffect	effect;
+	struct param_isp_iso		iso;
+	struct param_isp_adjust		adjust;
+	struct param_isp_metering	metering;
+	struct param_isp_afc		afc;
+	struct param_otf_output		otf_output;
+	struct param_dma_output		dma1_output;
+	struct param_dma_output		dma2_output;
+};
+
+struct drc_param {
+	struct param_control		control;
+	struct param_otf_input		otf_input;
+	struct param_dma_input		dma_input;
+	struct param_otf_output		otf_output;
+};
+
+struct scalerc_param {
+	struct param_control		control;
+	struct param_otf_input		otf_input;
+	struct param_scaler_imageeffect	effect;
+	struct param_scaler_input_crop	input_crop;
+	struct param_scaler_output_crop	 output_crop;
+	struct param_otf_output		otf_output;
+	struct param_dma_output		dma_output;
+};
+
+struct odc_param {
+	struct param_control		control;
+	struct param_otf_input		otf_input;
+	struct param_otf_output		otf_output;
+};
+
+struct dis_param {
+	struct param_control		control;
+	struct param_otf_input		otf_input;
+	struct param_otf_output		otf_output;
+};
+
+struct tdnr_param {
+	struct param_control		control;
+	struct param_otf_input		otf_input;
+	struct param_3dnr_1stframe	frame;
+	struct param_otf_output		otf_output;
+	struct param_dma_output		dma_output;
+};
+
+struct scalerp_param {
+	struct param_control			control;
+	struct param_otf_input			otf_input;
+	struct param_scaler_imageeffect		effect;
+	struct param_scaler_input_crop		input_crop;
+	struct param_scaler_output_crop		output_crop;
+	struct param_scaler_rotation		rotation;
+	struct param_scaler_flip		flip;
+	struct param_otf_output			otf_output;
+	struct param_dma_output			dma_output;
+};
+
+struct fd_param {
+	struct param_control		control;
+	struct param_otf_input		otf_input;
+	struct param_dma_input		dma_input;
+	struct param_fd_config		config;
+};
+
+struct is_param_region {
+	struct global_param	global;
+	struct sensor_param	sensor;
+	struct buffer_param	buf;
+	struct isp_param	isp;
+	struct drc_param	drc;
+	struct scalerc_param	scalerc;
+	struct odc_param	odc;
+	struct dis_param	dis;
+	struct tdnr_param	tdnr;
+	struct scalerp_param	scalerp;
+	struct fd_param		fd;
+};
+
+#define	NUMBER_OF_GAMMA_CURVE_POINTS	32
+
+struct is_sensor_tune {
+	u32 exposure;
+	u32 analog_gain;
+	u32 frame_rate;
+	u32 actuator_pos;
+};
+
+struct is_tune_gammacurve {
+	u32 num_pts_x[NUMBER_OF_GAMMA_CURVE_POINTS];
+	u32 num_pts_y_r[NUMBER_OF_GAMMA_CURVE_POINTS];
+	u32 num_pts_y_g[NUMBER_OF_GAMMA_CURVE_POINTS];
+	u32 num_pts_y_b[NUMBER_OF_GAMMA_CURVE_POINTS];
+};
+
+struct is_isp_tune {
+	/* Brightness level: range 0~100, default: 7 */
+	u32 brightness_level;
+	/* Contrast level: range -127~127, default: 0 */
+	s32 contrast_level;
+	/* Saturation level: range -127~127, default: 0 */
+	s32 saturation_level;
+	s32 gamma_level;
+	struct is_tune_gammacurve gamma_curve[4];
+	/* Hue: range -127~127, default: 0 */
+	s32 hue;
+	/* Sharpness blur: range -127~127, default: 0 */
+	s32 sharpness_blur;
+	/* Despeckle: range -127~127, default: 0 */
+	s32 despeckle;
+	/* Edge color supression: range -127~127, default: 0 */
+	s32 edge_color_supression;
+	/* Noise reduction: range -127~127, default: 0 */
+	s32 noise_reduction;
+};
+
+struct is_tune_region {
+	struct is_sensor_tune sensor_tune;
+	struct is_isp_tune isp_tune;
+};
+
+struct rational_t {
+	u32 num;
+	u32 den;
+};
+
+struct srational_t {
+	s32 num;
+	s32 den;
+};
+
+#define FLASH_FIRED_SHIFT	0
+#define FLASH_NOT_FIRED		0
+#define FLASH_FIRED		1
+
+#define FLASH_STROBE_SHIFT				1
+#define FLASH_STROBE_NO_DETECTION			0
+#define FLASH_STROBE_RESERVED				1
+#define FLASH_STROBE_RETURN_LIGHT_NOT_DETECTED		2
+#define FLASH_STROBE_RETURN_LIGHT_DETECTED		3
+
+#define FLASH_MODE_SHIFT			3
+#define FLASH_MODE_UNKNOWN			0
+#define FLASH_MODE_COMPULSORY_FLASH_FIRING	1
+#define FLASH_MODE_COMPULSORY_FLASH_SUPPRESSION	2
+#define FLASH_MODE_AUTO_MODE			3
+
+#define FLASH_FUNCTION_SHIFT		5
+#define FLASH_FUNCTION_PRESENT		0
+#define FLASH_FUNCTION_NONE		1
+
+#define FLASH_RED_EYE_SHIFT		6
+#define FLASH_RED_EYE_DISABLED		0
+#define FLASH_RED_EYE_SUPPORTED		1
+
+struct exif_attribute {
+	struct rational_t exposure_time;
+	struct srational_t shutter_speed;
+	u32 iso_speed_rating;
+	u32 flash;
+	struct srational_t brightness;
+};
+
+struct is_frame_header {
+	u32 valid;
+	u32 bad_mark;
+	u32 captured;
+	u32 frame_number;
+	struct exif_attribute	exif;
+};
+
+struct is_face_marker {
+	u32 frame_number;
+	struct v4l2_rect face;
+	struct v4l2_rect left_eye;
+	struct v4l2_rect right_eye;
+	struct v4l2_rect mouth;
+	u32 roll_angle;
+	u32 yaw_angle;
+	u32 confidence;
+	u32 stracked;
+	u32 tracked_faceid;
+	u32 smile_level;
+	u32 blink_level;
+};
+
+#define MAX_FRAME_COUNT		8
+#define MAX_FRAME_COUNT_PREVIEW	4
+#define MAX_FRAME_COUNT_CAPTURE	1
+#define MAX_FACE_COUNT		16
+
+#define MAX_SHARED_COUNT	500
+
+struct is_region {
+	struct is_param_region	parameter;
+	struct is_tune_region	tune;
+	struct is_frame_header	header[MAX_FRAME_COUNT];
+	struct is_face_marker	face[MAX_FACE_COUNT];
+	u32			shared[MAX_SHARED_COUNT];
+};
+
+struct is_time_measure_us {
+	u32 min_time_us;
+	u32 max_time_us;
+	u32 avrg_time_us;
+	u32 current_time_us;
+};
+
+struct is_debug_frame_descriptor {
+	u32 sensor_frame_time;
+	u32 sensor_exposure_time;
+	u32 sensor_analog_gain;
+	u32 req_lei;
+};
+
+#define MAX_FRAMEDESCRIPTOR_CONTEXT_NUM	(30 * 20)	/* 600 frame */
+#define MAX_VERSION_DISPLAY_BUF		(32)
+
+struct is_share_region {
+	u32 frame_time;
+	u32 exposure_time;
+	u32 analog_gain;
+
+	u32 r_gain;
+	u32 g_gain;
+	u32 b_gain;
+
+	u32 af_position;
+	u32 af_status;
+	u32 af_scene_type;
+
+	u32 frame_descp_onoff_control;
+	u32 frame_descp_update_done;
+	u32 frame_descp_idx;
+	u32 frame_descp_max_idx;
+
+	struct is_debug_frame_descriptor
+		dbg_frame_descp_ctx[MAX_FRAMEDESCRIPTOR_CONTEXT_NUM];
+
+	u32 chip_id;
+	u32 chip_rev_no;
+	u8 ispfw_version_no[MAX_VERSION_DISPLAY_BUF];
+	u8 ispfw_version_date[MAX_VERSION_DISPLAY_BUF];
+	u8 sirc_sdk_version_no[MAX_VERSION_DISPLAY_BUF];
+	u8 sirc_sdk_revsion_no[MAX_VERSION_DISPLAY_BUF];
+	u8 sirc_sdk_version_date[MAX_VERSION_DISPLAY_BUF];
+
+	/* measure timing */
+	struct is_time_measure_us	isp_sdk_time;
+};
+
+struct is_debug_control {
+	u32 write_point;	/* 0~500KB boundary */
+	u32 assert_flag;	/* 0:Not Invoked, 1:Invoked */
+	u32 pabort_flag;	/* 0:Not Invoked, 1:Invoked */
+	u32 dabort_flag;	/* 0:Not Invoked, 1:Invoked */
+	u32 pd_ready_flag;	/* 0:Normal, 1:EnterIdle(Ready to power down) */
+	u32 isp_frame_err;	/* Frame Error Counters */
+	u32 drc_frame_err;
+	u32 scc_frame_err;
+	u32 odc_frame_err;
+	u32 dis_frame_err;
+	u32 tdnr_frame_err;
+	u32 scp_frame_err;
+	u32 fd_frame_err;
+	u32 isp_frame_drop;	/* Frame Drop Counters */
+	u32 drc_frame_drop;
+	u32 dis_frame_drop;
+	u32 uifdframedrop;
+};
+
+#endif
-- 
1.7.9.5

