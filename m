Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:48484 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754607Ab3KEMvO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 5 Nov 2013 07:51:14 -0500
Date: Tue, 5 Nov 2013 14:51:08 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Arun Kumar K <arun.kk@samsung.com>
Cc: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	devicetree@vger.kernel.org, s.nawrocki@samsung.com,
	hverkuil@xs4all.nl, swarren@wwwdotorg.org, mark.rutland@arm.com,
	Pawel.Moll@arm.com, galak@codeaurora.org, a.hajda@samsung.com,
	sachin.kamat@linaro.org, shaik.ameer@samsung.com,
	kilyeon.im@samsung.com, arunkk.samsung@gmail.com
Subject: Re: [PATCH v11 03/12] [media] exynos5-fimc-is: Add common driver
 header files
Message-ID: <20131105125108.GF23061@valkosipuli.retiisi.org.uk>
References: <1383631964-26514-1-git-send-email-arun.kk@samsung.com>
 <1383631964-26514-4-git-send-email-arun.kk@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383631964-26514-4-git-send-email-arun.kk@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Arun,

On Tue, Nov 05, 2013 at 11:42:34AM +0530, Arun Kumar K wrote:
> This patch adds all the common header files used by the fimc-is
> driver. It includes the commands for interfacing with the firmware
> and error codes from IS firmware, metadata and command parameter
> definitions.
> 
> Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
> Signed-off-by: Kilyeon Im <kilyeon.im@samsung.com>
> Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> ---
>  drivers/media/platform/exynos5-is/fimc-is-cmd.h    |  187 ++++
>  drivers/media/platform/exynos5-is/fimc-is-err.h    |  257 +++++
>  .../media/platform/exynos5-is/fimc-is-metadata.h   |  767 +++++++++++++
>  drivers/media/platform/exynos5-is/fimc-is-param.h  | 1159 ++++++++++++++++++++
>  4 files changed, 2370 insertions(+)
>  create mode 100644 drivers/media/platform/exynos5-is/fimc-is-cmd.h
>  create mode 100644 drivers/media/platform/exynos5-is/fimc-is-err.h
>  create mode 100644 drivers/media/platform/exynos5-is/fimc-is-metadata.h
>  create mode 100644 drivers/media/platform/exynos5-is/fimc-is-param.h
> 
> diff --git a/drivers/media/platform/exynos5-is/fimc-is-cmd.h b/drivers/media/platform/exynos5-is/fimc-is-cmd.h
> new file mode 100644
> index 0000000..6250280
> --- /dev/null
> +++ b/drivers/media/platform/exynos5-is/fimc-is-cmd.h
> @@ -0,0 +1,187 @@
> +/*
> + * Samsung Exynos5 SoC series FIMC-IS driver
> + *
> + * Copyright (c) 2013 Samsung Electronics Co., Ltd
> + * Kil-yeon Lim <kilyeon.im@samsung.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#ifndef FIMC_IS_CMD_H
> +#define FIMC_IS_CMD_H
> +
> +#define IS_COMMAND_VER 122 /* IS COMMAND VERSION 1.22 */
> +
> +enum is_cmd {
> +	/* HOST -> IS */
> +	HIC_PREVIEW_STILL = 0x1,
> +	HIC_PREVIEW_VIDEO,
> +	HIC_CAPTURE_STILL,
> +	HIC_CAPTURE_VIDEO,
> +	HIC_PROCESS_START,
> +	HIC_PROCESS_STOP,
> +	HIC_STREAM_ON,
> +	HIC_STREAM_OFF,
> +	HIC_SHOT,
> +	HIC_GET_STATIC_METADATA,
> +	HIC_SET_CAM_CONTROL,
> +	HIC_GET_CAM_CONTROL,
> +	HIC_SET_PARAMETER,
> +	HIC_GET_PARAMETER,
> +	HIC_SET_A5_MEM_ACCESS,
> +	RESERVED2,
> +	HIC_GET_STATUS,
> +	/* SENSOR PART*/
> +	HIC_OPEN_SENSOR,
> +	HIC_CLOSE_SENSOR,
> +	HIC_SIMMIAN_INIT,
> +	HIC_SIMMIAN_WRITE,
> +	HIC_SIMMIAN_READ,
> +	HIC_POWER_DOWN,
> +	HIC_GET_SET_FILE_ADDR,
> +	HIC_LOAD_SET_FILE,
> +	HIC_MSG_CONFIG,
> +	HIC_MSG_TEST,
> +	/* IS -> HOST */
> +	IHC_GET_SENSOR_NUMBER = 0x1000,
> +	/* Parameter1 : Address of space to copy a setfile */
> +	/* Parameter2 : Space szie */
> +	IHC_SET_SHOT_MARK,
> +	/* PARAM1 : a frame number */
> +	/* PARAM2 : confidence level(smile 0~100) */
> +	/* PARMA3 : confidence level(blink 0~100) */
> +	IHC_SET_FACE_MARK,
> +	/* PARAM1 : coordinate count */
> +	/* PARAM2 : coordinate buffer address */
> +	IHC_FRAME_DONE,
> +	/* PARAM1 : frame start number */
> +	/* PARAM2 : frame count */
> +	IHC_AA_DONE,
> +	IHC_NOT_READY,
> +	IHC_FLASH_READY
> +};
> +
> +enum is_reply {
> +	ISR_DONE	= 0x2000,
> +	ISR_NDONE
> +};
> +
> +enum is_scenario_id {
> +	ISS_PREVIEW_STILL,
> +	ISS_PREVIEW_VIDEO,
> +	ISS_CAPTURE_STILL,
> +	ISS_CAPTURE_VIDEO,
> +	ISS_END
> +};
> +
> +enum is_subscenario_id {
> +	ISS_SUB_SCENARIO_STILL,
> +	ISS_SUB_SCENARIO_VIDEO,
> +	ISS_SUB_SCENARIO_SCENE1,
> +	ISS_SUB_SCENARIO_SCENE2,
> +	ISS_SUB_SCENARIO_SCENE3,
> +	ISS_SUB_END
> +};
> +
> +struct is_setfile_header_element {
> +	u32 binary_addr;
> +	u32 binary_size;
> +};
> +
> +struct is_setfile_header {
> +	struct is_setfile_header_element isp[ISS_END];
> +	struct is_setfile_header_element drc[ISS_END];
> +	struct is_setfile_header_element fd[ISS_END];
> +};
> +
> +struct is_common_reg {
> +	u32 hicmd;
> +	u32 hic_sensorid;
> +	u32 hic_param[4];
> +
> +	u32 reserved1[3];
> +
> +	u32 ihcmd_iflag;
> +	u32 ihcmd;
> +	u32 ihc_sensorid;
> +	u32 ihc_param[4];
> +
> +	u32 reserved2[3];
> +
> +	u32 isp_bayer_iflag;
> +	u32 isp_bayer_sensor_id;
> +	u32 isp_bayer_param[2];
> +
> +	u32 reserved3[4];
> +
> +	u32 scc_iflag;
> +	u32 scc_sensor_id;
> +	u32 scc_param[3];
> +
> +	u32 reserved4[3];
> +
> +	u32 dnr_iflag;
> +	u32 dnr_sensor_id;
> +	u32 dnr_param[2];
> +
> +	u32 reserved5[4];
> +
> +	u32 scp_iflag;
> +	u32 scp_sensor_id;
> +	u32 scp_param[3];
> +
> +	u32 reserved6[1];
> +
> +	u32 isp_yuv_iflag;
> +	u32 isp_yuv_sensor_id;
> +	u32 isp_yuv_param[2];
> +
> +	u32 reserved7[1];
> +
> +	u32 shot_iflag;
> +	u32 shot_sensor_id;
> +	u32 shot_param[2];
> +
> +	u32 reserved8[1];
> +
> +	u32 meta_iflag;
> +	u32 meta_sensor_id;
> +	u32 meta_param1;
> +
> +	u32 reserved9[1];
> +
> +	u32 fcount;

If these structs define an interface that's not used by the driver only it
might be a good idea to use __packed to ensure no padding is added.

> +};
> +
> +struct is_mcuctl_reg {
> +	u32 mcuctl;
> +	u32 bboar;
> +
> +	u32 intgr0;
> +	u32 intcr0;
> +	u32 intmr0;
> +	u32 intsr0;
> +	u32 intmsr0;
> +
> +	u32 intgr1;
> +	u32 intcr1;
> +	u32 intmr1;
> +	u32 intsr1;
> +	u32 intmsr1;
> +
> +	u32 intcr2;
> +	u32 intmr2;
> +	u32 intsr2;
> +	u32 intmsr2;
> +
> +	u32 gpoctrl;
> +	u32 cpoenctlr;
> +	u32 gpictlr;
> +
> +	u32 pad[0xD];
> +
> +	struct is_common_reg common_reg;
> +};
> +#endif
...
> diff --git a/drivers/media/platform/exynos5-is/fimc-is-metadata.h b/drivers/media/platform/exynos5-is/fimc-is-metadata.h
> new file mode 100644
> index 0000000..02367c4
> --- /dev/null
> +++ b/drivers/media/platform/exynos5-is/fimc-is-metadata.h
> @@ -0,0 +1,767 @@
> +/*
> + * Samsung EXYNOS5 FIMC-IS (Imaging Subsystem) driver
> + *
> + * Copyright (C) 2013 Samsung Electronics Co., Ltd.
> + * Kil-yeon Lim <kilyeon.im@samsung.com>
> + * Arun Kumar K <arun.kk@samsung.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#ifndef FIMC_IS_METADATA_H_
> +#define FIMC_IS_METADATA_H_
> +
> +struct rational {
> +	uint32_t num;
> +	uint32_t den;
> +};
> +
> +#define CAMERA2_MAX_AVAILABLE_MODE	21
> +#define CAMERA2_MAX_FACES		16
> +
> +/*
> + * Controls/dynamic metadata
> + */
> +
> +enum metadata_mode {
> +	METADATA_MODE_NONE,
> +	METADATA_MODE_FULL
> +};
> +
> +struct camera2_request_ctl {
> +	uint32_t		id;
> +	enum metadata_mode	metadatamode;
> +	uint8_t			outputstreams[16];
> +	uint32_t		framecount;
> +};
> +
> +struct camera2_request_dm {
> +	uint32_t		id;
> +	enum metadata_mode	metadatamode;
> +	uint32_t		framecount;
> +};
> +
> +
> +
> +enum optical_stabilization_mode {
> +	OPTICAL_STABILIZATION_MODE_OFF,
> +	OPTICAL_STABILIZATION_MODE_ON
> +};
> +
> +enum lens_facing {
> +	LENS_FACING_BACK,
> +	LENS_FACING_FRONT
> +};
> +
> +struct camera2_lens_ctl {
> +	uint32_t				focus_distance;
> +	float					aperture;

Floating point numbers? Really? :-)

> +	float					focal_length;
> +	float					filter_density;
> +	enum optical_stabilization_mode		optical_stabilization_mode;
> +};
> +
> +struct camera2_lens_dm {
> +	uint32_t				focus_distance;
> +	float					aperture;
> +	float					focal_length;
> +	float					filter_density;
> +	enum optical_stabilization_mode		optical_stabilization_mode;
> +	float					focus_range[2];
> +};
> +
> +struct camera2_lens_sm {
> +	float				minimum_focus_distance;
> +	float				hyper_focal_distance;
> +	float				available_focal_length[2];
> +	float				available_apertures;
> +	/* assuming 1 aperture */
> +	float				available_filter_densities;
> +	/* assuming 1 ND filter value */
> +	enum optical_stabilization_mode	available_optical_stabilization;
> +	/* assuming 1 */
> +	uint32_t			shading_map_size;
> +	float				shading_map[3][40][30];
> +	uint32_t			geometric_correction_map_size;
> +	float				geometric_correction_map[2][3][40][30];
> +	enum lens_facing		facing;
> +	float				position[2];
> +};

...

> diff --git a/drivers/media/platform/exynos5-is/fimc-is-param.h b/drivers/media/platform/exynos5-is/fimc-is-param.h
> new file mode 100644
> index 0000000..015cc13
> --- /dev/null
> +++ b/drivers/media/platform/exynos5-is/fimc-is-param.h
...
> +struct param_control {
> +	u32 cmd;

You use uint32_t in some other headers. It's not wrong to use both C99 and
Linux types but I'd try to stick to either one.

> +	u32 bypass;
> +	u32 buffer_address;
> +	u32 buffer_number;
> +	/* 0: continuous, 1: single */
> +	u32 run_mode;
> +	u32 reserved[PARAMETER_MAX_MEMBER - 6];
> +	u32 err;
> +};

...

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
