Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f172.google.com ([209.85.215.172]:53261 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001Ab3CWOFt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 23 Mar 2013 10:05:49 -0400
Message-ID: <514DB6B7.1050304@gmail.com>
Date: Sat, 23 Mar 2013 15:05:43 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Arun Kumar K <arun.kk@samsung.com>
CC: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	devicetree-discuss@lists.ozlabs.org, s.nawrocki@samsung.com,
	kgene.kim@samsung.com, kilyeon.im@samsung.com,
	arunkk.samsung@gmail.com
Subject: Re: [RFC 04/12] exynos-fimc-is: Adds common driver header files
References: <1362754765-2651-1-git-send-email-arun.kk@samsung.com> <1362754765-2651-5-git-send-email-arun.kk@samsung.com>
In-Reply-To: <1362754765-2651-5-git-send-email-arun.kk@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/08/2013 03:59 PM, Arun Kumar K wrote:
> This patch adds all the common header files used by the fimc-is
> driver. It includes the commands for interfacing with the firmware
> and error codes from IS firmware, metadata and command parameter
> definitions.
>
> Signed-off-by: Arun Kumar K<arun.kk@samsung.com>
> Signed-off-by: Kilyeon Im<kilyeon.im@samsung.com>
> ---
>   drivers/media/platform/exynos5-is/fimc-is-cmd.h    |  211 ++
>   drivers/media/platform/exynos5-is/fimc-is-err.h    |  258 +++
>   .../media/platform/exynos5-is/fimc-is-metadata.h   |  771 +++++++
>   drivers/media/platform/exynos5-is/fimc-is-param.h  | 2163 ++++++++++++++++++++
>   4 files changed, 3403 insertions(+)
>   create mode 100644 drivers/media/platform/exynos5-is/fimc-is-cmd.h
>   create mode 100644 drivers/media/platform/exynos5-is/fimc-is-err.h
>   create mode 100644 drivers/media/platform/exynos5-is/fimc-is-metadata.h
>   create mode 100644 drivers/media/platform/exynos5-is/fimc-is-param.h
>
> diff --git a/drivers/media/platform/exynos5-is/fimc-is-cmd.h b/drivers/media/platform/exynos5-is/fimc-is-cmd.h
> new file mode 100644
> index 0000000..f117f41
> --- /dev/null
> +++ b/drivers/media/platform/exynos5-is/fimc-is-cmd.h
[...]
> +#define HOST_SET_INT_BIT	0x00000001
> +#define HOST_CLR_INT_BIT	0x00000001
> +#define IS_SET_INT_BIT		0x00000001
> +#define IS_CLR_INT_BIT		0x00000001
> +
> +#define HOST_SET_INTERRUPT(base)	(base->uiINTGR0 |= HOST_SET_INT_BIT)
> +#define HOST_CLR_INTERRUPT(base)	(base->uiINTCR0 |= HOST_CLR_INT_BIT)
> +#define IS_SET_INTERRUPT(base)		(base->uiINTGR1 |= IS_SET_INT_BIT)
> +#define IS_CLR_INTERRUPT(base)		(base->uiINTCR1 |= IS_CLR_INT_BIT)

These 8 appear to be all unused unused definitions. Probably can be removed.


> diff --git a/drivers/media/platform/exynos5-is/fimc-is-err.h b/drivers/media/platform/exynos5-is/fimc-is-err.h
> new file mode 100644
> index 0000000..76472a9
> --- /dev/null
> +++ b/drivers/media/platform/exynos5-is/fimc-is-err.h
> @@ -0,0 +1,258 @@
> +/*
> + * Samsung Exynos5 SoC series FIMC-IS driver
> + *
> + * Copyright (c) 2013 Samsung Electronics Co., Ltd
> + * Kil-yeon Lim<kilyeon.im@samsung.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#ifndef FIMC_IS_ERR_H
> +#define FIMC_IS_ERR_H
> +
> +#define IS_ERROR_VER 012 /* IS ERROR VERSION 0.07 */
> +
> +#define IS_ERROR_SUCCESS		0
> +/* General 1 ~ 100 */
> +#define IS_ERROR_INVALID_COMMAND        (IS_ERROR_SUCCESS+1)
> +#define IS_ERROR_REQUEST_FAIL           (IS_ERROR_INVALID_COMMAND+1)
> +#define IS_ERROR_INVALID_SCENARIO       (IS_ERROR_REQUEST_FAIL+1)
> +#define IS_ERROR_INVALID_SENSORID       (IS_ERROR_INVALID_SCENARIO+1)
> +#define IS_ERROR_INVALID_MODE_CHANGE    (IS_ERROR_INVALID_SENSORID+1)
> +#define IS_ERROR_INVALID_MAGIC_NUMBER	(IS_ERROR_INVALID_MODE_CHANGE+1)
> +#define IS_ERROR_INVALID_SETFILE_HDR	(IS_ERROR_INVALID_MAGIC_NUMBER+1)
> +#define IS_ERROR_ISP_SETFILE_VERSION_MISMATCH	(IS_ERROR_INVALID_SETFILE_HDR+1)
> +#define IS_ERROR_ISP_SETFILE_REVISION_MISMATCH\
> +				(IS_ERROR_ISP_SETFILE_VERSION_MISMATCH+1)
> +#define IS_ERROR_BUSY (IS_ERROR_ISP_SETFILE_REVISION_MISMATCH+1)
> +#define IS_ERROR_SET_PARAMETER          (IS_ERROR_BUSY+1)
> +#define IS_ERROR_INVALID_PATH           (IS_ERROR_SET_PARAMETER+1)
> +#define IS_ERROR_OPEN_SENSOR_FAIL       (IS_ERROR_INVALID_PATH+1)
> +#define IS_ERROR_ENTRY_MSG_THREAD_DOWN	(IS_ERROR_OPEN_SENSOR_FAIL+1)
> +#define IS_ERROR_ISP_FRAME_END_NOT_DONE	(IS_ERROR_ENTRY_MSG_THREAD_DOWN+1)
> +#define IS_ERROR_DRC_FRAME_END_NOT_DONE	(IS_ERROR_ISP_FRAME_END_NOT_DONE+1)
> +#define IS_ERROR_SCALERC_FRAME_END_NOT_DONE (IS_ERROR_DRC_FRAME_END_NOT_DONE+1)
> +#define IS_ERROR_ODC_FRAME_END_NOT_DONE (IS_ERROR_SCALERC_FRAME_END_NOT_DONE+1)
> +#define IS_ERROR_DIS_FRAME_END_NOT_DONE (IS_ERROR_ODC_FRAME_END_NOT_DONE+1)
> +#define IS_ERROR_TDNR_FRAME_END_NOT_DONE (IS_ERROR_DIS_FRAME_END_NOT_DONE+1)
> +#define IS_ERROR_SCALERP_FRAME_END_NOT_DONE (IS_ERROR_TDNR_FRAME_END_NOT_DONE+1)
> +#define IS_ERROR_WAIT_STREAM_OFF_NOT_DONE\
> +				(IS_ERROR_SCALERP_FRAME_END_NOT_DONE+1)
> +#define IS_ERROR_NO_MSG_IS_RECEIVED     (IS_ERROR_WAIT_STREAM_OFF_NOT_DONE+1)
> +#define IS_ERROR_SENSOR_MSG_FAIL	    (IS_ERROR_NO_MSG_IS_RECEIVED+1)
> +#define IS_ERROR_ISP_MSG_FAIL	        (IS_ERROR_SENSOR_MSG_FAIL+1)
> +#define IS_ERROR_DRC_MSG_FAIL	        (IS_ERROR_ISP_MSG_FAIL+1)
> +#define IS_ERROR_SCALERC_MSG_FAIL		(IS_ERROR_DRC_MSG_FAIL+1)
> +#define IS_ERROR_ODC_MSG_FAIL	        (IS_ERROR_SCALERC_MSG_FAIL+1)
> +#define IS_ERROR_DIS_MSG_FAIL	        (IS_ERROR_ODC_MSG_FAIL+1)
> +#define IS_ERROR_TDNR_MSG_FAIL	        (IS_ERROR_DIS_MSG_FAIL+1)
> +#define IS_ERROR_SCALERP_MSG_FAIL		(IS_ERROR_TDNR_MSG_FAIL+1)
> +#define IS_ERROR_LHFD_MSG_FAIL	        (IS_ERROR_SCALERP_MSG_FAIL+1)
> +#define IS_ERROR_INTERNAL_STOP          (IS_ERROR_LHFD_MSG_FAIL+1)
> +#define IS_ERROR_UNKNOWN                1000
> +#define IS_ERROR_TIME_OUT_FLAG          0x80000000
> +
> +/* Sensor 100 ~ 200 */
> +#define IS_ERROR_SENSOR_PWRDN_FAIL	100
> +#define IS_ERROR_SENSOR_STREAM_ON_FAIL	(IS_ERROR_SENSOR_PWRDN_FAIL+1)
> +#define IS_ERROR_SENSOR_STREAM_OFF_FAIL	(IS_ERROR_SENSOR_STREAM_ON_FAIL+1)
> +
> +/* ISP 200 ~ 300 */
> +#define IS_ERROR_ISP_PWRDN_FAIL		200
> +#define IS_ERROR_ISP_MULTIPLE_INPUT	(IS_ERROR_ISP_PWRDN_FAIL+1)
> +#define IS_ERROR_ISP_ABSENT_INPUT	(IS_ERROR_ISP_MULTIPLE_INPUT+1)
> +#define IS_ERROR_ISP_ABSENT_OUTPUT	(IS_ERROR_ISP_ABSENT_INPUT+1)
> +#define IS_ERROR_ISP_NONADJACENT_OUTPUT	(IS_ERROR_ISP_ABSENT_OUTPUT+1)
> +#define IS_ERROR_ISP_FORMAT_MISMATCH	(IS_ERROR_ISP_NONADJACENT_OUTPUT+1)
> +#define IS_ERROR_ISP_WIDTH_MISMATCH	(IS_ERROR_ISP_FORMAT_MISMATCH+1)
> +#define IS_ERROR_ISP_HEIGHT_MISMATCH	(IS_ERROR_ISP_WIDTH_MISMATCH+1)
> +#define IS_ERROR_ISP_BITWIDTH_MISMATCH	(IS_ERROR_ISP_HEIGHT_MISMATCH+1)
> +#define IS_ERROR_ISP_FRAME_END_TIME_OUT	(IS_ERROR_ISP_BITWIDTH_MISMATCH+1)
> +
> +/* DRC 300 ~ 400 */
> +#define IS_ERROR_DRC_PWRDN_FAIL		300
> +#define IS_ERROR_DRC_MULTIPLE_INPUT	(IS_ERROR_DRC_PWRDN_FAIL+1)
> +#define IS_ERROR_DRC_ABSENT_INPUT	(IS_ERROR_DRC_MULTIPLE_INPUT+1)
> +#define IS_ERROR_DRC_NONADJACENT_INTPUT	(IS_ERROR_DRC_ABSENT_INPUT+1)
> +#define IS_ERROR_DRC_ABSENT_OUTPUT	(IS_ERROR_DRC_NONADJACENT_INTPUT+1)
> +#define IS_ERROR_DRC_NONADJACENT_OUTPUT	(IS_ERROR_DRC_ABSENT_OUTPUT+1)
> +#define IS_ERROR_DRC_FORMAT_MISMATCH	(IS_ERROR_DRC_NONADJACENT_OUTPUT+1)
> +#define IS_ERROR_DRC_WIDTH_MISMATCH	(IS_ERROR_DRC_FORMAT_MISMATCH+1)
> +#define IS_ERROR_DRC_HEIGHT_MISMATCH	(IS_ERROR_DRC_WIDTH_MISMATCH+1)
> +#define IS_ERROR_DRC_BITWIDTH_MISMATCH	(IS_ERROR_DRC_HEIGHT_MISMATCH+1)
> +#define IS_ERROR_DRC_FRAME_END_TIME_OUT	(IS_ERROR_DRC_BITWIDTH_MISMATCH+1)
> +
> +/*SCALERC(400~500)*/
> +#define IS_ERROR_SCALERC_PWRDN_FAIL     400
> +
> +/*ODC(500~600)*/
> +#define IS_ERROR_ODC_PWRDN_FAIL         500
> +
> +/*DIS(600~700)*/
> +#define IS_ERROR_DIS_PWRDN_FAIL         600
> +
> +/*TDNR(700~800)*/
> +#define IS_ERROR_TDNR_PWRDN_FAIL        700
> +
> +/*SCALERP(800~900)*/
> +#define IS_ERROR_SCALERP_PWRDN_FAIL     800
> +
> +/*FD(900~1000)*/
> +#define IS_ERROR_FD_PWRDN_FAIL          900
> +#define IS_ERROR_FD_MULTIPLE_INPUT	(IS_ERROR_FD_PWRDN_FAIL+1)
> +#define IS_ERROR_FD_ABSENT_INPUT	(IS_ERROR_FD_MULTIPLE_INPUT+1)
> +#define IS_ERROR_FD_NONADJACENT_INPUT	(IS_ERROR_FD_ABSENT_INPUT+1)
> +#define IS_ERROR_LHFD_FRAME_END_TIME_OUT \
> +					(IS_ERROR_FD_NONADJACENT_INPUT+1)

nit: It feels an enum would be more appropriate for these.

> diff --git a/drivers/media/platform/exynos5-is/fimc-is-param.h b/drivers/media/platform/exynos5-is/fimc-is-param.h
> new file mode 100644
> index 0000000..63eb8d9
> --- /dev/null
> +++ b/drivers/media/platform/exynos5-is/fimc-is-param.h
> @@ -0,0 +1,2163 @@
> +/*
> + * Samsung Exynos5 SoC series FIMC-IS driver
> + *
> + * Copyright (c) 2013 Samsung Electronics Co., Ltd
> + * Kil-yeon Lim<kilyeon.im@samsung.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#ifndef FIMC_IS_PARAM_H
> +#define FIMC_IS_PARAM_H
> +
> +#define IS_REGION_VER 145  /* IS REGION VERSION 1.45 */
> +
> +/* MACROs */
> +#define IS_SET_PARAM_BIT(dev, num) \
> +	(num>= 32 ? set_bit((num-32),&dev->p_region_index2) \
> +		: set_bit(num,&dev->p_region_index1))
> +#define IS_INC_PARAM_NUM(dev)		atomic_inc(&dev->p_region_num)
> +
> +#define IS_PARAM_GLOBAL(dev)		(dev->is_p_region->parameter.global)
> +#define IS_PARAM_ISP(dev)		(dev->is_p_region->parameter.isp)
> +#define IS_PARAM_DRC(dev)		(dev->is_p_region->parameter.drc)
> +#define IS_PARAM_FD(dev)		(dev->is_p_region->parameter.fd)
> +#define IS_HEADER(dev)			(dev->is_p_region->header)
> +#define IS_FACE(dev)			(dev->is_p_region->face)
> +#define IS_SHARED(dev)			(dev->is_shared_region)
> +#define IS_PARAM_SIZE			(FIMC_IS_REGION_SIZE + 1)
> +
> +/* Global control */
> +#define IS_SET_PARAM_GLOBAL_SHOTMODE_CMD(dev, x) \
> +		(dev->is_p_region->parameter.global.shotmode.cmd = x)
> +#define IS_SET_PARAM_GLOBAL_SHOTMODE_SKIPFRAMES(dev, x) \
> +		(dev->is_p_region->parameter.global.shotmode.skip_frames = x)
> +
> +/* Sensor control */
> +#define IS_SENSOR_SET_FRAME_RATE(dev, x) \
> +		(dev->is_p_region->parameter.sensor.frame_rate.frame_rate = x)
> +
> +/* ISP Macros */
> +#define IS_ISP_SET_PARAM_CONTROL_CMD(dev, x) \
> +		(dev->is_p_region->parameter.isp.control.cmd = x)

Hmm, these macros look pretty ugly. They obfuscate what's really being done.
I would try to rewrite the code so we use pointers to target data structures
instead.

> +#ifndef BIT0
> +#define  BIT0     0x00000001
> +#define  BIT1     0x00000002
> +#define  BIT2     0x00000004
> +#define  BIT3     0x00000008
> +#define  BIT4     0x00000010
> +#define  BIT5     0x00000020
> +#define  BIT6     0x00000040
> +#define  BIT7     0x00000080
> +#define  BIT8     0x00000100
> +#define  BIT9     0x00000200
> +#define  BIT10    0x00000400
> +#define  BIT11    0x00000800
> +#define  BIT12    0x00001000
> +#define  BIT13    0x00002000
> +#define  BIT14    0x00004000
> +#define  BIT15    0x00008000
> +#define  BIT16    0x00010000
> +#define  BIT17    0x00020000
> +#define  BIT18    0x00040000
> +#define  BIT19    0x00080000
> +#define  BIT20    0x00100000
> +#define  BIT21    0x00200000
> +#define  BIT22    0x00400000
> +#define  BIT23    0x00800000
> +#define  BIT24    0x01000000
> +#define  BIT25    0x02000000
> +#define  BIT26    0x04000000
> +#define  BIT27    0x08000000
> +#define  BIT28    0x10000000
> +#define  BIT29    0x20000000
> +#define  BIT30    0x40000000
> +#define  BIT31    0x80000000
> +#define  BIT32    0x0000000100000000ULL
> +#define  BIT33    0x0000000200000000ULL
> +#define  BIT34    0x0000000400000000ULL
> +#define  BIT35    0x0000000800000000ULL
> +#define  BIT36    0x0000001000000000ULL
> +#define  BIT37    0x0000002000000000ULL
> +#define  BIT38    0x0000004000000000ULL
> +#define  BIT39    0x0000008000000000ULL
> +#define  BIT40    0x0000010000000000ULL
> +#define  BIT41    0x0000020000000000ULL
> +#define  BIT42    0x0000040000000000ULL
> +#define  BIT43    0x0000080000000000ULL
> +#define  BIT44    0x0000100000000000ULL
> +#define  BIT45    0x0000200000000000ULL
> +#define  BIT46    0x0000400000000000ULL
> +#define  BIT47    0x0000800000000000ULL
> +#define  BIT48    0x0001000000000000ULL
> +#define  BIT49    0x0002000000000000ULL
> +#define  BIT50    0x0004000000000000ULL
> +#define  BIT51    0x0008000000000000ULL
> +#define  BIT52    0x0010000000000000ULL
> +#define  BIT53    0x0020000000000000ULL
> +#define  BIT54    0x0040000000000000ULL
> +#define  BIT55    0x0080000000000000ULL
> +#define  BIT56    0x0100000000000000ULL
> +#define  BIT57    0x0200000000000000ULL
> +#define  BIT58    0x0400000000000000ULL
> +#define  BIT59    0x0800000000000000ULL
> +#define  BIT60    0x1000000000000000ULL
> +#define  BIT61    0x2000000000000000ULL
> +#define  BIT62    0x4000000000000000ULL
> +#define  BIT63    0x8000000000000000ULL

Are you sure this is a good idea ? What do you think BIT() macro available
in bitops.h does ? And are all these BIT definitions really used anywhere ?

> +#define  INC_BIT(bit) (bit<<1)
> +#define  INC_NUM(bit) (bit + 1)
> +#endif
> +
> +#define MAGIC_NUMBER 0x01020304
> +
> +#define PARAMETER_MAX_SIZE    128  /* in byte */
> +#define PARAMETER_MAX_MEMBER  (PARAMETER_MAX_SIZE/4)
> +
> +enum is_entry {
> +	ENTRY_GLOBAL,
> +	ENTRY_BUFFER,
> +	ENTRY_SENSOR,
> +	ENTRY_ISP,
> +	ENTRY_DRC,
> +	ENTRY_SCALERC,
> +	ENTRY_ODC,
> +	ENTRY_DIS,
> +	ENTRY_TDNR,
> +	ENTRY_SCALERP,
> +	ENTRY_LHFD, /* 10 */
> +	ENTRY_END

Are these used somewhere ?

> +};
> +
> +enum is_param_set_bit {
> +	PARAM_GLOBAL_SHOTMODE = 0,
> +	PARAM_SENSOR_CONTROL,
> +	PARAM_SENSOR_OTF_INPUT,
> +	PARAM_SENSOR_OTF_OUTPUT,
> +	PARAM_SENSOR_FRAME_RATE,
> +	PARAM_SENSOR_DMA_OUTPUT,
> +	PARAM_BUFFER_CONTROL,
> +	PARAM_BUFFER_OTF_INPUT,
> +	PARAM_BUFFER_OTF_OUTPUT,
> +	PARAM_ISP_CONTROL,
> +	PARAM_ISP_OTF_INPUT = 10,
> +	PARAM_ISP_DMA1_INPUT,
> +	PARAM_ISP_DMA2_INPUT,
> +	PARAM_ISP_AA,
> +	PARAM_ISP_FLASH,
> +	PARAM_ISP_AWB,
> +	PARAM_ISP_IMAGE_EFFECT,
> +	PARAM_ISP_ISO,
> +	PARAM_ISP_ADJUST,
> +	PARAM_ISP_METERING,
> +	PARAM_ISP_AFC = 20,
> +	PARAM_ISP_OTF_OUTPUT,
> +	PARAM_ISP_DMA1_OUTPUT,
> +	PARAM_ISP_DMA2_OUTPUT,
> +	PARAM_DRC_CONTROL,
> +	PARAM_DRC_OTF_INPUT,
> +	PARAM_DRC_DMA_INPUT,
> +	PARAM_DRC_OTF_OUTPUT,
> +	PARAM_SCALERC_CONTROL,
> +	PARAM_SCALERC_OTF_INPUT,
> +	PARAM_SCALERC_IMAGE_EFFECT = 30,
> +	PARAM_SCALERC_INPUT_CROP,
> +	PARAM_SCALERC_OUTPUT_CROP,
> +	PARAM_SCALERC_OTF_OUTPUT,
> +	PARAM_SCALERC_DMA_OUTPUT = 34,
> +	PARAM_ODC_CONTROL,
> +	PARAM_ODC_OTF_INPUT,
> +	PARAM_ODC_OTF_OUTPUT,
> +	PARAM_DIS_CONTROL,
> +	PARAM_DIS_OTF_INPUT,
> +	PARAM_DIS_OTF_OUTPUT = 40,
> +	PARAM_TDNR_CONTROL,
> +	PARAM_TDNR_OTF_INPUT,
> +	PARAM_TDNR_1ST_FRAME,
> +	PARAM_TDNR_OTF_OUTPUT,
> +	PARAM_TDNR_DMA_OUTPUT,
> +	PARAM_SCALERP_CONTROL,
> +	PARAM_SCALERP_OTF_INPUT,
> +	PARAM_SCALERP_IMAGE_EFFECT,
> +	PARAM_SCALERP_INPUT_CROP,
> +	PARAM_SCALERP_OUTPUT_CROP = 50,
> +	PARAM_SCALERP_ROTATION,
> +	PARAM_SCALERP_FLIP,
> +	PARAM_SCALERP_OTF_OUTPUT,
> +	PARAM_SCALERP_DMA_OUTPUT,
> +	PARAM_FD_CONTROL,
> +	PARAM_FD_OTF_INPUT,
> +	PARAM_FD_DMA_INPUT,
> +	PARAM_FD_CONFIG = 58,
> +	PARAM_END,
> +};
> +
> +#define ADDRESS_TO_OFFSET(start, end)	((uint32)end - (uint32)start)
> +#define OFFSET_TO_NUM(offset)		((offset)>>6)
> +#define IS_OFFSET_LOWBIT(offset)	(OFFSET_TO_NUM(offset)>= \
> +						32 ? false : true)
> +#define OFFSET_TO_BIT(offset) \
> +		{(IS_OFFSET_LOWBIT(offset) ? (1<<OFFSET_TO_NUM(offset)) \
> +			: (1<<(OFFSET_TO_NUM(offset)-32))}
> +#define LOWBIT_OF_NUM(num)		(num>= 32 ? 0 : BIT0<<num)
> +#define HIGHBIT_OF_NUM(num)		(num>= 32 ? BIT0<<(num-32) : 0)
> +
> +/* 0~31 */
> +#define PARAM_GLOBAL_SHOTMODE		0
> +#define PARAM_SENSOR_CONTROL		INC_NUM(PARAM_GLOBAL_SHOTMODE)
> +#define PARAM_SENSOR_OTF_INPUT		INC_NUM(PARAM_SENSOR_CONTROL)
> +#define PARAM_SENSOR_OTF_OUTPUT		INC_NUM(PARAM_SENSOR_OTF_INPUT)
> +#define PARAM_SENSOR_FRAME_RATE		INC_NUM(PARAM_SENSOR_OTF_OUTPUT)
> +#define PARAM_SENSOR_DMA_OUTPUT		INC_NUM(PARAM_SENSOR_FRAME_RATE)
> +#define PARAM_BUFFER_CONTROL		INC_NUM(PARAM_SENSOR_DMA_OUTPUT)
> +#define PARAM_BUFFER_OTF_INPUT		INC_NUM(PARAM_BUFFER_CONTROL)
> +#define PARAM_BUFFER_OTF_OUTPUT		INC_NUM(PARAM_BUFFER_OTF_INPUT)
> +#define PARAM_ISP_CONTROL		INC_NUM(PARAM_BUFFER_OTF_OUTPUT)
> +#define PARAM_ISP_OTF_INPUT		INC_NUM(PARAM_ISP_CONTROL)
> +#define PARAM_ISP_DMA1_INPUT		INC_NUM(PARAM_ISP_OTF_INPUT)
> +#define PARAM_ISP_DMA2_INPUT		INC_NUM(PARAM_ISP_DMA1_INPUT)
> +#define PARAM_ISP_AA			INC_NUM(PARAM_ISP_DMA2_INPUT)
> +#define PARAM_ISP_FLASH			INC_NUM(PARAM_ISP_AA)
> +#define PARAM_ISP_AWB			INC_NUM(PARAM_ISP_FLASH)
> +#define PARAM_ISP_IMAGE_EFFECT		INC_NUM(PARAM_ISP_AWB)
> +#define PARAM_ISP_ISO			INC_NUM(PARAM_ISP_IMAGE_EFFECT)
> +#define PARAM_ISP_ADJUST		INC_NUM(PARAM_ISP_ISO)
> +#define PARAM_ISP_METERING		INC_NUM(PARAM_ISP_ADJUST)
> +#define PARAM_ISP_AFC			INC_NUM(PARAM_ISP_METERING)
> +#define PARAM_ISP_OTF_OUTPUT		INC_NUM(PARAM_ISP_AFC)
> +#define PARAM_ISP_DMA1_OUTPUT		INC_NUM(PARAM_ISP_OTF_OUTPUT)
> +#define PARAM_ISP_DMA2_OUTPUT		INC_NUM(PARAM_ISP_DMA1_OUTPUT)
> +#define PARAM_DRC_CONTROL		INC_NUM(PARAM_ISP_DMA2_OUTPUT)
> +#define PARAM_DRC_OTF_INPUT		INC_NUM(PARAM_DRC_CONTROL)
> +#define PARAM_DRC_DMA_INPUT		INC_NUM(PARAM_DRC_OTF_INPUT)
> +#define PARAM_DRC_OTF_OUTPUT		INC_NUM(PARAM_DRC_DMA_INPUT)
> +#define PARAM_SCALERC_CONTROL		INC_NUM(PARAM_DRC_OTF_OUTPUT)
> +#define PARAM_SCALERC_OTF_INPUT		INC_NUM(PARAM_SCALERC_CONTROL)
> +#define PARAM_SCALERC_IMAGE_EFFECT	INC_NUM(PARAM_SCALERC_OTF_INPUT)
> +#define PARAM_SCALERC_INPUT_CROP	INC_NUM(PARAM_SCALERC_IMAGE_EFFECT)
> +#define PARAM_SCALERC_OUTPUT_CROP	INC_NUM(PARAM_SCALERC_INPUT_CROP)
> +#define PARAM_SCALERC_OTF_OUTPUT	INC_NUM(PARAM_SCALERC_OUTPUT_CROP)
>
> +/* 32~63 */
> +#define PARAM_SCALERC_DMA_OUTPUT	INC_NUM(PARAM_SCALERC_OTF_OUTPUT)
> +#define PARAM_ODC_CONTROL		INC_NUM(PARAM_SCALERC_DMA_OUTPUT)
> +#define PARAM_ODC_OTF_INPUT		INC_NUM(PARAM_ODC_CONTROL)
> +#define PARAM_ODC_OTF_OUTPUT		INC_NUM(PARAM_ODC_OTF_INPUT)
> +#define PARAM_DIS_CONTROL		INC_NUM(PARAM_ODC_OTF_OUTPUT)
> +#define PARAM_DIS_OTF_INPUT		INC_NUM(PARAM_DIS_CONTROL)
> +#define PARAM_DIS_OTF_OUTPUT		INC_NUM(PARAM_DIS_OTF_INPUT)
> +#define PARAM_TDNR_CONTROL		INC_NUM(PARAM_DIS_OTF_OUTPUT)
> +#define PARAM_TDNR_OTF_INPUT		INC_NUM(PARAM_TDNR_CONTROL)
> +#define PARAM_TDNR_1ST_FRAME		INC_NUM(PARAM_TDNR_OTF_INPUT)
> +#define PARAM_TDNR_OTF_OUTPUT		INC_NUM(PARAM_TDNR_1ST_FRAME)
> +#define PARAM_TDNR_DMA_OUTPUT		INC_NUM(PARAM_TDNR_OTF_OUTPUT)
> +#define PARAM_SCALERP_CONTROL		INC_NUM(PARAM_TDNR_DMA_OUTPUT)
> +#define PARAM_SCALERP_OTF_INPUT		INC_NUM(PARAM_SCALERP_CONTROL)
> +#define PARAM_SCALERP_IMAGE_EFFECT	INC_NUM(PARAM_SCALERP_OTF_INPUT)
> +#define PARAM_SCALERP_INPUT_CROP	INC_NUM(PARAM_SCALERP_IMAGE_EFFECT)
> +#define PARAM_SCALERP_OUTPUT_CROP	INC_NUM(PARAM_SCALERP_INPUT_CROP)
> +#define PARAM_SCALERP_ROTATION		INC_NUM(PARAM_SCALERP_OUTPUT_CROP)
> +#define PARAM_SCALERP_FLIP		INC_NUM(PARAM_SCALERP_ROTATION)
> +#define PARAM_SCALERP_OTF_OUTPUT	INC_NUM(PARAM_SCALERP_FLIP)
> +#define PARAM_SCALERP_DMA_OUTPUT	INC_NUM(PARAM_SCALERP_OTF_OUTPUT)
> +#define PARAM_FD_CONTROL		INC_NUM(PARAM_SCALERP_DMA_OUTPUT)
> +#define PARAM_FD_OTF_INPUT		INC_NUM(PARAM_FD_CONTROL)
> +#define PARAM_FD_DMA_INPUT		INC_NUM(PARAM_FD_OTF_INPUT)
> +#define PARAM_FD_CONFIG			INC_NUM(PARAM_FD_DMA_INPUT)
> +#define PARAM_END			INC_NUM(PARAM_FD_CONFIG)

Isn't it much easier to define these as enum ?

> +#define PARAM_STRNUM_GLOBAL		(PARAM_GLOBAL_SHOTMODE)
> +#define PARAM_RANGE_GLOBAL		1
> +#define PARAM_STRNUM_SENSOR		(PARAM_SENSOR_BYPASS)
> +#define PARAM_RANGE_SENSOR		5
> +#define PARAM_STRNUM_BUFFER		(PARAM_BUFFER_BYPASS)
> +#define PARAM_RANGE_BUFFER		3
> +#define PARAM_STRNUM_ISP		(PARAM_ISP_BYPASS)
> +#define PARAM_RANGE_ISP			15
> +#define PARAM_STRNUM_DRC		(PARAM_DRC_BYPASS)
> +#define PARAM_RANGE_DRC			4
> +#define PARAM_STRNUM_SCALERC		(PARAM_SCALERC_BYPASS)
> +#define PARAM_RANGE_SCALERC		7
> +#define PARAM_STRNUM_ODC		(PARAM_ODC_BYPASS)
> +#define PARAM_RANGE_ODC			3
> +#define PARAM_STRNUM_DIS		(PARAM_DIS_BYPASS)
> +#define PARAM_RANGE_DIS			3
> +#define PARAM_STRNUM_TDNR		(PARAM_TDNR_BYPASS)
> +#define PARAM_RANGE_TDNR		5
> +#define PARAM_STRNUM_SCALERP		(PARAM_SCALERP_BYPASS)
> +#define PARAM_RANGE_SCALERP		9
> +#define PARAM_STRNUM_LHFD		(PARAM_FD_BYPASS)
> +#define PARAM_RANGE_LHFD		4

Are these definitions used anywhere ?

> +#define PARAM_LOW_MASK		(0xFFFFFFFF)
> +#define PARAM_HIGH_MASK		(0x07FFFFFF)
> +
[...]
> +struct param_dma_input {
> +	u32	cmd;
> +	u32	width;
> +	u32	height;
> +	u32	format;
> +	u32	bitwidth;
> +	u32	plane;
> +	u32	order;
> +	u32	buffer_number;
> +	u32	buffer_address;
> +	u32	uibayercropoffsetx;
> +	u32	uibayercropoffsety;
> +	u32	uibayercropwidth;
> +	u32	uibayercropheight;
> +	u32	uidmacropoffsetx;
> +	u32	uidmacropoffsety;
> +	u32	uidmacropwidth;
> +	u32	uidmacropheight;
> +	u32	uiuserminframetime;
> +	u32	uiusermaxframetime;

That is really hard to read. Perhaps we can have some underscores
added so it looks like ui_user_max_frametime ?

> +	u32	uiwideframegap;
> +	u32	uiframegap;
> +	u32	uilinegap;
> +	u32	uireserved[PARAMETER_MAX_MEMBER-23];
> +	u32	err;
> +};
