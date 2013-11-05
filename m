Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f170.google.com ([209.85.220.170]:63505 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754857Ab3KENQH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Nov 2013 08:16:07 -0500
MIME-Version: 1.0
In-Reply-To: <20131105125108.GF23061@valkosipuli.retiisi.org.uk>
References: <1383631964-26514-1-git-send-email-arun.kk@samsung.com>
	<1383631964-26514-4-git-send-email-arun.kk@samsung.com>
	<20131105125108.GF23061@valkosipuli.retiisi.org.uk>
Date: Tue, 5 Nov 2013 18:46:06 +0530
Message-ID: <CALt3h7_BCj7yJi6sy=KVOHoET4aWm_a-N=u63R8-bZ-uQ=AGag@mail.gmail.com>
Subject: Re: [PATCH v11 03/12] [media] exynos5-fimc-is: Add common driver
 header files
From: Arun Kumar K <arunkk.samsung@gmail.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: LMML <linux-media@vger.kernel.org>,
	linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Pawel Moll <Pawel.Moll@arm.com>,
	Kumar Gala <galak@codeaurora.org>,
	Andrzej Hajda <a.hajda@samsung.com>,
	Sachin Kamat <sachin.kamat@linaro.org>,
	Shaik Ameer Basha <shaik.ameer@samsung.com>,
	"kilyeon.im@samsung.com" <kilyeon.im@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thank you for the review.

On Tue, Nov 5, 2013 at 6:21 PM, Sakari Ailus <sakari.ailus@iki.fi> wrote:
> Hi Arun,
>
> On Tue, Nov 05, 2013 at 11:42:34AM +0530, Arun Kumar K wrote:
>> This patch adds all the common header files used by the fimc-is
>> driver. It includes the commands for interfacing with the firmware
>> and error codes from IS firmware, metadata and command parameter
>> definitions.
>>
>> Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
>> Signed-off-by: Kilyeon Im <kilyeon.im@samsung.com>
>> Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
>> ---
>>  drivers/media/platform/exynos5-is/fimc-is-cmd.h    |  187 ++++
>>  drivers/media/platform/exynos5-is/fimc-is-err.h    |  257 +++++
>>  .../media/platform/exynos5-is/fimc-is-metadata.h   |  767 +++++++++++++
>>  drivers/media/platform/exynos5-is/fimc-is-param.h  | 1159 ++++++++++++++++++++
>>  4 files changed, 2370 insertions(+)
>>  create mode 100644 drivers/media/platform/exynos5-is/fimc-is-cmd.h
>>  create mode 100644 drivers/media/platform/exynos5-is/fimc-is-err.h
>>  create mode 100644 drivers/media/platform/exynos5-is/fimc-is-metadata.h
>>  create mode 100644 drivers/media/platform/exynos5-is/fimc-is-param.h
>>
>> diff --git a/drivers/media/platform/exynos5-is/fimc-is-cmd.h b/drivers/media/platform/exynos5-is/fimc-is-cmd.h
>> new file mode 100644
>> index 0000000..6250280
>> --- /dev/null
>> +++ b/drivers/media/platform/exynos5-is/fimc-is-cmd.h
>> @@ -0,0 +1,187 @@
>> +/*

[snip]

>> +struct is_common_reg {
>> +     u32 hicmd;
>> +     u32 hic_sensorid;
>> +     u32 hic_param[4];
>> +
>> +     u32 reserved1[3];
>> +
>> +     u32 ihcmd_iflag;
>> +     u32 ihcmd;
>> +     u32 ihc_sensorid;
>> +     u32 ihc_param[4];
>> +
>> +     u32 reserved2[3];
>> +
>> +     u32 isp_bayer_iflag;
>> +     u32 isp_bayer_sensor_id;
>> +     u32 isp_bayer_param[2];
>> +
>> +     u32 reserved3[4];
>> +
>> +     u32 scc_iflag;
>> +     u32 scc_sensor_id;
>> +     u32 scc_param[3];
>> +
>> +     u32 reserved4[3];
>> +
>> +     u32 dnr_iflag;
>> +     u32 dnr_sensor_id;
>> +     u32 dnr_param[2];
>> +
>> +     u32 reserved5[4];
>> +
>> +     u32 scp_iflag;
>> +     u32 scp_sensor_id;
>> +     u32 scp_param[3];
>> +
>> +     u32 reserved6[1];
>> +
>> +     u32 isp_yuv_iflag;
>> +     u32 isp_yuv_sensor_id;
>> +     u32 isp_yuv_param[2];
>> +
>> +     u32 reserved7[1];
>> +
>> +     u32 shot_iflag;
>> +     u32 shot_sensor_id;
>> +     u32 shot_param[2];
>> +
>> +     u32 reserved8[1];
>> +
>> +     u32 meta_iflag;
>> +     u32 meta_sensor_id;
>> +     u32 meta_param1;
>> +
>> +     u32 reserved9[1];
>> +
>> +     u32 fcount;
>
> If these structs define an interface that's not used by the driver only it
> might be a good idea to use __packed to ensure no padding is added.
>

The same structure is used as is in the firmware code and so it is retained
in the driver.

>> +};
>> +
>> +struct is_mcuctl_reg {
>> +     u32 mcuctl;
>> +     u32 bboar;
>> +
>> +     u32 intgr0;
>> +     u32 intcr0;
>> +     u32 intmr0;
>> +     u32 intsr0;
>> +     u32 intmsr0;
>> +
>> +     u32 intgr1;
>> +     u32 intcr1;
>> +     u32 intmr1;
>> +     u32 intsr1;
>> +     u32 intmsr1;
>> +
>> +     u32 intcr2;
>> +     u32 intmr2;
>> +     u32 intsr2;
>> +     u32 intmsr2;
>> +
>> +     u32 gpoctrl;
>> +     u32 cpoenctlr;
>> +     u32 gpictlr;
>> +
>> +     u32 pad[0xD];
>> +
>> +     struct is_common_reg common_reg;
>> +};
>> +#endif
> ...
>> diff --git a/drivers/media/platform/exynos5-is/fimc-is-metadata.h b/drivers/media/platform/exynos5-is/fimc-is-metadata.h
>> new file mode 100644
>> index 0000000..02367c4
>> --- /dev/null
>> +++ b/drivers/media/platform/exynos5-is/fimc-is-metadata.h
>> @@ -0,0 +1,767 @@
>> +/*
>> + * Samsung EXYNOS5 FIMC-IS (Imaging Subsystem) driver
>> + *
>> + * Copyright (C) 2013 Samsung Electronics Co., Ltd.
>> + * Kil-yeon Lim <kilyeon.im@samsung.com>
>> + * Arun Kumar K <arun.kk@samsung.com>
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
>> +     uint32_t num;
>> +     uint32_t den;
>> +};
>> +
>> +#define CAMERA2_MAX_AVAILABLE_MODE   21
>> +#define CAMERA2_MAX_FACES            16
>> +
>> +/*
>> + * Controls/dynamic metadata
>> + */
>> +
>> +enum metadata_mode {
>> +     METADATA_MODE_NONE,
>> +     METADATA_MODE_FULL
>> +};
>> +
>> +struct camera2_request_ctl {
>> +     uint32_t                id;
>> +     enum metadata_mode      metadatamode;
>> +     uint8_t                 outputstreams[16];
>> +     uint32_t                framecount;
>> +};
>> +
>> +struct camera2_request_dm {
>> +     uint32_t                id;
>> +     enum metadata_mode      metadatamode;
>> +     uint32_t                framecount;
>> +};
>> +
>> +
>> +
>> +enum optical_stabilization_mode {
>> +     OPTICAL_STABILIZATION_MODE_OFF,
>> +     OPTICAL_STABILIZATION_MODE_ON
>> +};
>> +
>> +enum lens_facing {
>> +     LENS_FACING_BACK,
>> +     LENS_FACING_FRONT
>> +};
>> +
>> +struct camera2_lens_ctl {
>> +     uint32_t                                focus_distance;
>> +     float                                   aperture;
>
> Floating point numbers? Really? :-)
>

Yes as mentioned, the same structure is used by the firmware and
so it is used as is in the kernel.

Regards
Arun
