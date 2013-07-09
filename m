Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f54.google.com ([209.85.212.54]:51358 "EHLO
	mail-vb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554Ab3GILUO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Jul 2013 07:20:14 -0400
MIME-Version: 1.0
In-Reply-To: <51C3865A.4050701@gmail.com>
References: <1370005408-10853-1-git-send-email-arun.kk@samsung.com>
	<1370005408-10853-4-git-send-email-arun.kk@samsung.com>
	<51C3865A.4050701@gmail.com>
Date: Tue, 9 Jul 2013 16:50:13 +0530
Message-ID: <CALt3h78=JKU0AO++n3HgPw209pDRTpiXntdpGwejNXQ7X0z9gg@mail.gmail.com>
Subject: Re: [RFC v2 03/10] exynos5-fimc-is: Adds common driver header files
From: Arun Kumar K <arunkk.samsung@gmail.com>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: Arun Kumar K <arun.kk@samsung.com>,
	LMML <linux-media@vger.kernel.org>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	kilyeon.im@samsung.com, shaik.ameer@samsung.com,
	linux-samsung-soc <linux-samsung-soc@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

Thank you for the review.

On Fri, Jun 21, 2013 at 4:16 AM, Sylwester Nawrocki
<sylvester.nawrocki@gmail.com> wrote:
> On 05/31/2013 03:03 PM, Arun Kumar K wrote:
>>
>> This patch adds all the common header files used by the fimc-is
>> driver. It includes the commands for interfacing with the firmware
>> and error codes from IS firmware, metadata and command parameter
>> definitions.
>>
>> Signed-off-by: Arun Kumar K<arun.kk@samsung.com>
>> Signed-off-by: Kilyeon Im<kilyeon.im@samsung.com>
>> ---
>>   drivers/media/platform/exynos5-is/fimc-is-cmd.h    |  201 ++++
>>   drivers/media/platform/exynos5-is/fimc-is-err.h    |  261 ++++
>>   .../media/platform/exynos5-is/fimc-is-metadata.h   |  771 ++++++++++++
>>   drivers/media/platform/exynos5-is/fimc-is-param.h  | 1259
>> ++++++++++++++++++++
>>   4 files changed, 2492 insertions(+)
>>   create mode 100644 drivers/media/platform/exynos5-is/fimc-is-cmd.h
>>   create mode 100644 drivers/media/platform/exynos5-is/fimc-is-err.h
>>   create mode 100644 drivers/media/platform/exynos5-is/fimc-is-metadata.h
>>   create mode 100644 drivers/media/platform/exynos5-is/fimc-is-param.h
>>
>> diff --git a/drivers/media/platform/exynos5-is/fimc-is-cmd.h
>> b/drivers/media/platform/exynos5-is/fimc-is-cmd.h
>> new file mode 100644
>> index 0000000..4adf832
>> --- /dev/null
>> +++ b/drivers/media/platform/exynos5-is/fimc-is-cmd.h
>> @@ -0,0 +1,201 @@
>> +/*
>> + * Samsung Exynos5 SoC series FIMC-IS driver
>> + *
>> + * Copyright (c) 2013 Samsung Electronics Co., Ltd
>> + * Kil-yeon Lim<kilyeon.im@samsung.com>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + */
>> +
>> +#ifndef FIMC_IS_CMD_H
>> +#define FIMC_IS_CMD_H
>> +
>> +#define IS_COMMAND_VER 122 /* IS COMMAND VERSION 1.22 */
>> +
>> +enum is_cmd {
>> +       /* HOST ->  IS */
>> +       HIC_PREVIEW_STILL = 0x1,
>> +       HIC_PREVIEW_VIDEO,
>> +       HIC_CAPTURE_STILL,
>> +       HIC_CAPTURE_VIDEO,
>> +       HIC_PROCESS_START,
>> +       HIC_PROCESS_STOP,
>> +       HIC_STREAM_ON,
>> +       HIC_STREAM_OFF,
>> +       HIC_SHOT,
>> +       HIC_GET_STATIC_METADATA,
>> +       HIC_SET_CAM_CONTROL,
>> +       HIC_GET_CAM_CONTROL,
>> +       HIC_SET_PARAMETER,
>> +       HIC_GET_PARAMETER,
>> +       HIC_SET_A5_MEM_ACCESS,
>> +       RESERVED2,
>> +       HIC_GET_STATUS,
>> +       /* SENSOR PART*/
>> +       HIC_OPEN_SENSOR,
>> +       HIC_CLOSE_SENSOR,
>> +       HIC_SIMMIAN_INIT,
>> +       HIC_SIMMIAN_WRITE,
>> +       HIC_SIMMIAN_READ,
>> +       HIC_POWER_DOWN,
>> +       HIC_GET_SET_FILE_ADDR,
>> +       HIC_LOAD_SET_FILE,
>> +       HIC_MSG_CONFIG,
>> +       HIC_MSG_TEST,
>> +       /* IS ->  HOST */
>> +       IHC_GET_SENSOR_NUMBER = 0x1000,
>> +       /* Parameter1 : Address of space to copy a setfile */
>> +       /* Parameter2 : Space szie */
>> +       IHC_SET_SHOT_MARK,
>> +       /* PARAM1 : a frame number */
>> +       /* PARAM2 : confidence level(smile 0~100) */
>> +       /* PARMA3 : confidence level(blink 0~100) */
>> +       IHC_SET_FACE_MARK,
>> +       /* PARAM1 : coordinate count */
>> +       /* PARAM2 : coordinate buffer address */
>> +       IHC_FRAME_DONE,
>> +       /* PARAM1 : frame start number */
>> +       /* PARAM2 : frame count */
>> +       IHC_AA_DONE,
>> +       IHC_NOT_READY,
>> +       IHC_FLASH_READY
>> +};
>> +
>> +enum is_reply {
>> +       ISR_DONE        = 0x2000,
>> +       ISR_NDONE
>> +};
>> +
>> +enum is_scenario_id {
>> +       ISS_PREVIEW_STILL,
>> +       ISS_PREVIEW_VIDEO,
>> +       ISS_CAPTURE_STILL,
>> +       ISS_CAPTURE_VIDEO,
>> +       ISS_END
>> +};
>> +
>> +enum is_subscenario_id {
>> +       ISS_SUB_SCENARIO_STILL,
>> +       ISS_SUB_SCENARIO_VIDEO,
>> +       ISS_SUB_SCENARIO_SCENE1,
>> +       ISS_SUB_SCENARIO_SCENE2,
>> +       ISS_SUB_SCENARIO_SCENE3,
>> +       ISS_SUB_END
>> +};
>> +
>> +struct is_setfile_header_element {
>> +       u32 binary_addr;
>> +       u32 binary_size;
>> +};
>> +
>> +struct is_setfile_header {
>> +       struct is_setfile_header_element isp[ISS_END];
>> +       struct is_setfile_header_element drc[ISS_END];
>> +       struct is_setfile_header_element fd[ISS_END];
>> +};
>> +
>> +struct is_common_reg {
>> +       u32 hicmd;
>> +       u32 hic_sensorid;
>> +       u32 hic_param1;
>> +       u32 hic_param2;
>> +       u32 hic_param3;
>> +       u32 hic_param4;
>
>
> How about replacing the above 4 fields with
>
>         u32 hic_param[4];
>
> ?

Ok.

>>
>> +       u32 reserved1[3];
>> +
>> +       u32 ihcmd_iflag;
>> +       u32 ihcmd;
>> +       u32 ihc_sensorid;
>> +       u32 ihc_param1;
>> +       u32 ihc_param2;
>> +       u32 ihc_param3;
>> +       u32 ihc_param4;
>
>
> Similarly,
>
>         u32 ihc_param[4];
>
> and for other groups of fields below ?
>

Will make this change.

>> +
>> +       u32 reserved2[3];
>> +
>> +       u32 isp_bayer_iflag;
>> +       u32 isp_bayer_sensor_id;
>> diff --git a/drivers/media/platform/exynos5-is/fimc-is-err.h
>> b/drivers/media/platform/exynos5-is/fimc-is-err.h
>> new file mode 100644
>> index 0000000..49d7cf5
>> --- /dev/null
>> +++ b/drivers/media/platform/exynos5-is/fimc-is-err.h
>> @@ -0,0 +1,261 @@
>> +/*
>> + * Samsung Exynos5 SoC series FIMC-IS driver
>> + *
>> + * Copyright (c) 2013 Samsung Electronics Co., Ltd
>> + * Arun Kumar K<arun.kk@samsung.com>
>> + * Kil-yeon Lim<kilyeon.im@samsung.com>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + */
>> +
>> +#ifndef FIMC_IS_ERR_H
>> +#define FIMC_IS_ERR_H
>> +
>> +#define IS_ERROR_VER 012 /* IS ERROR VERSION 0.07 */
>> +
>> +/* IS error enum */
>> +enum is_error {
>> +
>> +       IS_ERROR_SUCCESS = 0,
>> +
>> +       /* General 1 ~ 100 */
>> +       IS_ERROR_INVALID_COMMAND = 1,
>> +       IS_ERROR_REQUEST_FAIL,
>> +       IS_ERROR_INVALID_SCENARIO,
>> +       IS_ERROR_INVALID_SENSORID,
>> +       IS_ERROR_INVALID_MODE_CHANGE,
>> +       IS_ERROR_INVALID_MAGIC_NUMBER,
>> +       IS_ERROR_INVALID_SETFILE_HDR,
>> +       IS_ERROR_ISP_SETFILE_VERSION_MISMATCH,
>> +       IS_ERROR_ISP_SETFILE_REVISION_MISMATCH,
>> +       IS_ERROR_BUSY,
>> +       IS_ERROR_SET_PARAMETER,
>> +       IS_ERROR_INVALID_PATH,
>> +       IS_ERROR_OPEN_SENSOR_FAIL,
>> +       IS_ERROR_ENTRY_MSG_THREAD_DOWN,
>> +       IS_ERROR_ISP_FRAME_END_NOT_DONE,
>> +       IS_ERROR_DRC_FRAME_END_NOT_DONE,
>> +       IS_ERROR_SCALERC_FRAME_END_NOT_DONE,
>> +       IS_ERROR_ODC_FRAME_END_NOT_DONE,
>> +       IS_ERROR_DIS_FRAME_END_NOT_DONE,
>> +       IS_ERROR_TDNR_FRAME_END_NOT_DONE,
>> +       IS_ERROR_SCALERP_FRAME_END_NOT_DONE,
>> +       IS_ERROR_WAIT_STREAM_OFF_NOT_DONE,
>> +       IS_ERROR_NO_MSG_IS_RECEIVED,
>> +       IS_ERROR_SENSOR_MSG_FAIL,
>> +       IS_ERROR_ISP_MSG_FAIL,
>> +       IS_ERROR_DRC_MSG_FAIL,
>> +       IS_ERROR_SCALERC_MSG_FAIL,
>> +       IS_ERROR_ODC_MSG_FAIL,
>> +       IS_ERROR_DIS_MSG_FAIL,
>> +       IS_ERROR_TDNR_MSG_FAIL,
>> +       IS_ERROR_SCALERP_MSG_FAIL,
>> +       IS_ERROR_LHFD_MSG_FAIL,
>> +       IS_ERROR_INTERNAL_STOP,
>> +       IS_ERROR_UNKNOWN,
>> +       IS_ERROR_TIME_OUT_FLAG,
>> +
>> +       /* Sensor 100 ~ 200 */
>> +       IS_ERROR_SENSOR_PWRDN_FAIL = 100,
>> +       IS_ERROR_SENSOR_STREAM_ON_FAIL,
>> +       IS_ERROR_SENSOR_STREAM_OFF_FAIL,
>> +
>> +       /* ISP 200 ~ 300 */
>> +       IS_ERROR_ISP_PWRDN_FAIL = 200,
>> +       IS_ERROR_ISP_MULTIPLE_INPUT,
>> +       IS_ERROR_ISP_ABSENT_INPUT,
>> +       IS_ERROR_ISP_ABSENT_OUTPUT,
>> +       IS_ERROR_ISP_NONADJACENT_OUTPUT,
>> +       IS_ERROR_ISP_FORMAT_MISMATCH,
>> +       IS_ERROR_ISP_WIDTH_MISMATCH,
>> +       IS_ERROR_ISP_HEIGHT_MISMATCH,
>> +       IS_ERROR_ISP_BITWIDTH_MISMATCH,
>> +       IS_ERROR_ISP_FRAME_END_TIME_OUT,
>> +
>> +       /* DRC 300 ~ 400 */
>> +       IS_ERROR_DRC_PWRDN_FAIL = 300,
>> +       IS_ERROR_DRC_MULTIPLE_INPUT,
>> +       IS_ERROR_DRC_ABSENT_INPUT,
>> +       IS_ERROR_DRC_NONADJACENT_INTPUT,
>> +       IS_ERROR_DRC_ABSENT_OUTPUT,
>> +       IS_ERROR_DRC_NONADJACENT_OUTPUT,
>> +       IS_ERROR_DRC_FORMAT_MISMATCH,
>> +       IS_ERROR_DRC_WIDTH_MISMATCH,
>> +       IS_ERROR_DRC_HEIGHT_MISMATCH,
>> +       IS_ERROR_DRC_BITWIDTH_MISMATCH,
>> +       IS_ERROR_DRC_FRAME_END_TIME_OUT,
>> +
>> +       /*SCALERC(400~500)*/
>> +       IS_ERROR_SCALERC_PWRDN_FAIL = 400,
>> +
>> +       /*ODC(500~600)*/
>> +       IS_ERROR_ODC_PWRDN_FAIL = 500,
>> +
>> +       /*DIS(600~700)*/
>> +       IS_ERROR_DIS_PWRDN_FAIL = 600,
>> +
>> +       /*TDNR(700~800)*/
>> +       IS_ERROR_TDNR_PWRDN_FAIL = 700,
>> +
>> +       /*SCALERP(800~900)*/
>> +       IS_ERROR_SCALERP_PWRDN_FAIL = 800,
>> +
>> +       /*FD(900~1000)*/
>> +       IS_ERROR_FD_PWRDN_FAIL = 900,
>> +       IS_ERROR_FD_MULTIPLE_INPUT,
>> +       IS_ERROR_FD_ABSENT_INPUT,
>> +       IS_ERROR_FD_NONADJACENT_INPUT,
>> +       IS_ERROR_LHFD_FRAME_END_TIME_OUT,
>> +};
>> +
>> +/* Set parameter error enum */
>> +enum error {
>> +       /* Common error (0~99) */
>> +       ERROR_COMMON_NO                 = 0,
>
>
> How about renaming all those ERROR_*_NO symbols to ERROR_*_NONE ?
>

Ok.


>> +       ERROR_COMMON_CMD                = 1,    /* Invalid command*/
>> +       ERROR_COMMON_PARAMETER          = 2,    /* Invalid parameter*/
>> +       /* setfile is not loaded before adjusting */

[snip]

>> diff --git a/drivers/media/platform/exynos5-is/fimc-is-metadata.h
>> b/drivers/media/platform/exynos5-is/fimc-is-metadata.h
>> new file mode 100644
>> index 0000000..9738d7d
>> --- /dev/null
>> +++ b/drivers/media/platform/exynos5-is/fimc-is-metadata.h
>> @@ -0,0 +1,771 @@
>> +/*
>> + * Samsung EXYNOS5 FIMC-IS (Imaging Subsystem) driver
>> + *
>> + * Copyright (C) 2013 Samsung Electronics Co., Ltd.
>> + * Kil-yeon Lim<kilyeon.im@samsung.com>
>> + * Arun Kumar K<arun.kk@samsung.com>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + */
>> +
>> +#ifndef FIMC_IS_METADATA_H_
>> +#define FIMC_IS_METADATA_H_
>> +
>> +struct rational {
>> +       uint32_t num;
>> +       uint32_t den;
>> +};
>> +
>> +#define CAMERA2_MAX_AVAILABLE_MODE     21
>> +#define CAMERA2_MAX_FACES              16
>> +
>> +/*
>> + *controls/dynamic metadata
>> +*/
>> +
>> +enum metadata_mode {
>> +       METADATA_MODE_NONE,
>> +       METADATA_MODE_FULL
>> +};
>> +
>> +struct camera2_request_ctl {
>> +       uint32_t                id;
>> +       enum metadata_mode      metadatamode;
>> +       uint8_t                 outputstreams[16];
>> +       uint32_t                framecount;
>> +};
>> +
>> +struct camera2_request_dm {
>> +       uint32_t                id;
>> +       enum metadata_mode      metadatamode;
>> +       uint32_t                framecount;
>> +};
>> +
>> +
>> +
>> +enum optical_stabilization_mode {
>> +       OPTICAL_STABILIZATION_MODE_OFF,
>> +       OPTICAL_STABILIZATION_MODE_ON
>> +};
>> +
>> +enum lens_facing {
>> +       LENS_FACING_BACK,
>> +       LENS_FACING_FRONT
>> +};
>> +
>> +struct camera2_lens_ctl {
>> +       uint32_t                                focusdistance;
>> +       float                                   aperture;
>> +       float                                   focallength;
>> +       float                                   filterdensity;
>> +       enum optical_stabilization_mode         opticalstabilizationmode;
>> +
>
>
> Unnecessary empty line.
>
> Huh, flat number in the kernel ? What are we going to do with those ?
> Is this structure going to be needed to be exposed to user space somehow ?
>

It was used like that in the reference driver from where this include is used
as it is. Will remove these as we no longer do that kind of stuff in this
re-worked driver.

>> +};
>> +
>> +struct camera2_lens_dm {
>> +       uint32_t                                focusdistance;
>> +       float                                   aperture;
>> +       float                                   focalilength;
>> +       float                                   filterdensity;
>> +       enum optical_stabilization_mode         opticalstabilizationmode;
>> +       float                                   focusrange[2];
>> +};
>> +
>> +struct camera2_lens_sm {
>> +       float                           minimumfocusdistance;
>> +       float                           hyperfocaldistance;
>> +       float                           availablefocalLength[2];
>> +       float                           availableapertures;
>> +       /*assuming 1 aperture*/
>> +       float                           availablefilterdensities;
>> +       /*assuming 1 ND filter value*/
>> +       enum optical_stabilization_mode availableopticalstabilization;
>> +       /*assuming 1*/
>> +       uint32_t                        shadingmapsize;
>> +       float                           shadingmap[3][40][30];
>> +       uint32_t                        geometriccorrectionmapsize;
>> +       float
>> geometriccorrectionmap[2][3][40][30];
>> +       enum lens_facing                facing;
>> +       float                           position[2];
>> +};
>> +
>> +enum sensor_colorfilterarrangement {
>> +       SENSOR_COLORFILTERARRANGEMENT_RGGB,
>> +       SENSOR_COLORFILTERARRANGEMENT_GRBG,
>> +       SENSOR_COLORFILTERARRANGEMENT_GBRG,
>> +       SENSOR_COLORFILTERARRANGEMENT_BGGR,
>> +       SENSOR_COLORFILTERARRANGEMENT_RGB
>
>
> Iwonderwhathappenedwithspacesinthoseenumdefinitions....
>

Will change it. Had a very good laugh by seeing your comment :)

[snip]
>> +
>> +struct camera2_edge_ctl {
>> +       enum processing_mode    mode;
>> +       uint32_t                strength;
>> +};
>> +
>> +struct camera2_edge_dm {
>> +       enum processing_mode    mode;
>> +       uint32_t                strength;
>> +};
>> +
>> +enum scaler_availableformats {
>
>
> Perhaps just 'enum scaler_formats' ?
>

Ok.

>> +       SCALER_FORMAT_BAYER_RAW,
>> +       SCALER_FORMAT_YV12,
>> +       SCALER_FORMAT_NV21,
>> +       SCALER_FORMAT_JPEG,
>> +       SCALER_FORMAT_UNKNOWN
>> +};
>> +
>> +struct camera2_scaler_ctl {
>> +       uint32_t        cropregion[3];
>> +};
>> +
>> +struct camera2_scaler_dm {
>> +       uint32_t        cropregion[3];
>> +};
>> +
>> +struct camera2_scaler_sm {
>> +       enum scaler_availableformats availableformats[4];
>> +       /*assuming # of availableFormats = 4*/
>
>
> nit: Can you please amend all comments in this driver so there are
>      spaces after '/*' and before '*/' ?
>

Yes will correct all these comments.

>> +       uint32_t        availablerawsizes;
>> +       uint64_t        availablerawmindurations;
>> +       /* needs check */
>> +       uint32_t        availableprocessedsizes[8];
>> +       uint64_t        availableprocessedmindurations[8];
>> +       uint32_t        availablejpegsizes[8][2];
>> +       uint64_t        availablejpegmindurations[8];
>> +       uint32_t        availablemaxdigitalzoom[8];
>> +};
>> +

[snip]

>> +
>> +/**
>> +       User-defined control for sensor.
>> +*/
>> +struct camera2_sensor_uctl {
>> +       struct camera2_sensor_ctl ctl;
>> +       /** Dynamic frame duration.
>> +       This feature is decided to max. value between
>> +       'sensor.exposureTime'+alpha and 'sensor.frameDuration'.
>> +       */
>
>
> Wrong comment style, should be:
>
> /*
>  * Dynamic frame duration....
>  * ...
>  */
>

Ok will change.

>> +       uint64_t        dynamicrrameduration;
>> +};
>> +
>> +struct camera2_scaler_uctl {
>> +       /* target address for next frame.
>> +       [0] invalid address, stop
>> +       [others] valid address
>> +       */
>> +       uint32_t scctargetaddress[4];
>> +       uint32_t scptargetaddress[4];
>> +};
>> +
>> +struct camera2_flash_uctl {
>> +       struct camera2_flash_ctl ctl;
>> +};
>> +
>> +struct camera2_uctl {
>> +       /* Set sensor, lens, flash control for next frame.
>> +       This flag can be combined.
>> +       [0 bit] lens
>> +       [1 bit] sensor
>> +       [2 bit] flash
>> +       */
>> +       uint32_t uupdatebitmap;
>> +
>> +       /** For debugging */
>> +       uint32_t uframenumber;
>> +
>> +       /** isp fw specific control(user-defined) of lens. */
>> +       struct camera2_lens_uctl        lensud;
>> +       /** isp fw specific control(user-defined) of sensor. */
>> +       struct camera2_sensor_uctl      sensorud;
>> +       /** isp fw specific control(user-defined) of flash. */
>> +       struct camera2_flash_uctl       flashud;
>> +
>> +       struct camera2_scaler_uctl      scalerud;
>> +};
>> +
>> +struct camera2_udm {
>> +       struct camera2_lens_udm         lens;
>> +};
>> +
>> +struct camera2_shot {
>> +       /*standard area*/
>> +       struct camera2_ctl      ctl;
>> +       struct camera2_dm       dm;
>> +       /*user defined area*/
>> +       struct camera2_uctl     uctl;
>> +       struct camera2_udm      udm;
>> +       /*magic : 23456789*/
>> +       uint32_t                magicnumber;
>> +};
>> +#endif
>> diff --git a/drivers/media/platform/exynos5-is/fimc-is-param.h
>> b/drivers/media/platform/exynos5-is/fimc-is-param.h
>> new file mode 100644
>> index 0000000..8eec772
>> --- /dev/null
>> +++ b/drivers/media/platform/exynos5-is/fimc-is-param.h
>> @@ -0,0 +1,1259 @@
>> +/*
>> + * Samsung Exynos5 SoC series FIMC-IS driver
>> + *
>> + * Copyright (c) 2013 Samsung Electronics Co., Ltd
>> + * Kil-yeon Lim<kilyeon.im@samsung.com>
>> + * Arun Kumar K<arun.kk@samsung.com>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + */
>> +
>> +#ifndef FIMC_IS_PARAM_H
>> +#define FIMC_IS_PARAM_H
>> +
>> +#define IS_REGION_VER 145  /* IS REGION VERSION 1.45 */
>> +
>> +/* MACROs */
>> +#define IS_SET_PARAM_BIT(dev, num) \
>> +       (num>= 32 ? set_bit((num-32),&dev->p_region_index2) \
>> +               : set_bit(num,&dev->p_region_index1))
>
>
> The bit operation could take a bitmask of arbitrary length, not only 32
> bits.
> Could you rework this parameter bitmask handling as is done in this patch
> http://git.linuxtv.org/media_tree.git/commitdiff/0e761b21b9d6c7a95a8e2b858af85d07f6c62d99
> ?
>
> Then some macros below could be removed.
>

Ok will do that.

>> +#define IS_INC_PARAM_NUM(dev)          atomic_inc(&dev->p_region_num)
>> +#define IS_PARAM_GLOBAL(dev)
>> (dev->is_p_region->parameter.global)
>> +#define IS_PARAM_ISP(dev)              (dev->is_p_region->parameter.isp)
>> +#define IS_PARAM_DRC(dev)              (dev->is_p_region->parameter.drc)
>> +#define IS_PARAM_FD(dev)               (dev->is_p_region->parameter.fd)
>> +#define IS_HEADER(dev)                 (dev->is_p_region->header)
>> +#define IS_FACE(dev)                   (dev->is_p_region->face)
>> +#define IS_SHARED(dev)                 (dev->is_shared_region)
>> +#define IS_PARAM_SIZE                  (FIMC_IS_REGION_SIZE + 1)
>
>
> All these are unused. Please double check for any unused code, this driver
> has already 8k LOC, and only subset of features are supported :/
>

Ok will remove un-used code.

>> +#define  INC_BIT(bit) (bit<<1)
>> +#define  INC_NUM(bit) (bit + 1)
>
>
> These two are unused, and a bit odd. Please remove.
>

Ok.

>> +#define MAGIC_NUMBER 0x01020304
>> +
>> +#define PARAMETER_MAX_SIZE    128  /* in byte */
>> +#define PARAMETER_MAX_MEMBER  (PARAMETER_MAX_SIZE/4)
>> +
>> +enum is_param_set_bit {
>> +       PARAM_GLOBAL_SHOTMODE = 0,
>> +       PARAM_SENSOR_CONTROL,
>> +       PARAM_SENSOR_OTF_INPUT,
>> +       PARAM_SENSOR_OTF_OUTPUT,
>> +       PARAM_SENSOR_FRAME_RATE,
>> +       PARAM_SENSOR_DMA_OUTPUT,
>> +       PARAM_BUFFER_CONTROL,
>> +       PARAM_BUFFER_OTF_INPUT,
>> +       PARAM_BUFFER_OTF_OUTPUT,
>> +       PARAM_ISP_CONTROL,
>> +       PARAM_ISP_OTF_INPUT = 10,
>> +       PARAM_ISP_DMA1_INPUT,
>> +       PARAM_ISP_DMA2_INPUT,
>> +       PARAM_ISP_AA,
>> +       PARAM_ISP_FLASH,
>> +       PARAM_ISP_AWB,
>> +       PARAM_ISP_IMAGE_EFFECT,
>> +       PARAM_ISP_ISO,
>> +       PARAM_ISP_ADJUST,
>> +       PARAM_ISP_METERING,
>> +       PARAM_ISP_AFC = 20,
>> +       PARAM_ISP_OTF_OUTPUT,
>> +       PARAM_ISP_DMA1_OUTPUT,
>> +       PARAM_ISP_DMA2_OUTPUT,
>> +       PARAM_DRC_CONTROL,
>> +       PARAM_DRC_OTF_INPUT,
>> +       PARAM_DRC_DMA_INPUT,
>> +       PARAM_DRC_OTF_OUTPUT,
>> +       PARAM_SCALERC_CONTROL,
>> +       PARAM_SCALERC_OTF_INPUT,
>> +       PARAM_SCALERC_IMAGE_EFFECT = 30,
>> +       PARAM_SCALERC_INPUT_CROP,
>> +       PARAM_SCALERC_OUTPUT_CROP,
>> +       PARAM_SCALERC_OTF_OUTPUT,
>> +       PARAM_SCALERC_DMA_OUTPUT = 34,
>> +       PARAM_ODC_CONTROL,
>> +       PARAM_ODC_OTF_INPUT,
>> +       PARAM_ODC_OTF_OUTPUT,
>> +       PARAM_DIS_CONTROL,
>> +       PARAM_DIS_OTF_INPUT,
>> +       PARAM_DIS_OTF_OUTPUT = 40,
>> +       PARAM_TDNR_CONTROL,
>> +       PARAM_TDNR_OTF_INPUT,
>> +       PARAM_TDNR_1ST_FRAME,
>> +       PARAM_TDNR_OTF_OUTPUT,
>> +       PARAM_TDNR_DMA_OUTPUT,
>> +       PARAM_SCALERP_CONTROL,
>> +       PARAM_SCALERP_OTF_INPUT,
>> +       PARAM_SCALERP_IMAGE_EFFECT,
>> +       PARAM_SCALERP_INPUT_CROP,
>> +       PARAM_SCALERP_OUTPUT_CROP = 50,
>> +       PARAM_SCALERP_ROTATION,
>> +       PARAM_SCALERP_FLIP,
>> +       PARAM_SCALERP_OTF_OUTPUT,
>> +       PARAM_SCALERP_DMA_OUTPUT,
>> +       PARAM_FD_CONTROL,
>> +       PARAM_FD_OTF_INPUT,
>> +       PARAM_FD_DMA_INPUT,
>> +       PARAM_FD_CONFIG = 58,
>> +       PARAM_END,
>> +};
>> +
>> +#define ADDRESS_TO_OFFSET(start, end)  ((uint32)end - (uint32)start)
>> +#define OFFSET_TO_NUM(offset)          ((offset)>>6)
>> +#define IS_OFFSET_LOWBIT(offset)       (OFFSET_TO_NUM(offset)>= \
>> +                                               32 ? false : true)
>> +#define OFFSET_TO_BIT(offset) \
>> +               {(IS_OFFSET_LOWBIT(offset) ? (1<<OFFSET_TO_NUM(offset)) \
>> +                       : (1<<(OFFSET_TO_NUM(offset)-32))}
>> +#define LOWBIT_OF_NUM(num)             (num>= 32 ? 0 : BIT0<<num)
>> +#define HIGHBIT_OF_NUM(num)            (num>= 32 ? BIT0<<(num-32) : 0)
>> +
>> +#define PARAM_LOW_MASK         (0xFFFFFFFF)
>> +#define PARAM_HIGH_MASK                (0x07FFFFFF)
>
>
> These guys are going to be redundant when you rework the parameter bitmask
> handling as suggested above.
>

Ok.

Regards
Arun
