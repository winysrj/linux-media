Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f175.google.com ([209.85.217.175]:42871 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932065AbaAGD7Q (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Jan 2014 22:59:16 -0500
MIME-Version: 1.0
In-Reply-To: <20140102182532.715b427e@samsung.com>
References: <1380889594-10448-1-git-send-email-shaik.ameer@samsung.com>
	<1380889594-10448-3-git-send-email-shaik.ameer@samsung.com>
	<20140102182532.715b427e@samsung.com>
Date: Tue, 7 Jan 2014 09:29:12 +0530
Message-ID: <CAOD6ATpYUCqx5zdYTev4Us8paiX4WRB8P1Vma_9VuinX3dZ3UA@mail.gmail.com>
Subject: Re: [PATCH v4 2/4] [media] exynos-scaler: Add core functionality for
 the SCALER driver
From: Shaik Ameer Basha <shaik.samsung@gmail.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Shaik Ameer Basha <shaik.ameer@samsung.com>,
	LMML <linux-media@vger.kernel.org>,
	linux-samsung-soc@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Pawel Osciak <posciak@google.com>,
	Inki Dae <inki.dae@samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Thanks for the reveiw.

On Fri, Jan 3, 2014 at 1:55 AM, Mauro Carvalho Chehab
<m.chehab@samsung.com> wrote:
> Em Fri,  4 Oct 2013 17:56:32 +0530
> Shaik Ameer Basha <shaik.ameer@samsung.com> escreveu:
>
>> This patch adds the core functionality for the SCALER driver.
>>
>> Signed-off-by: Shaik Ameer Basha <shaik.ameer@samsung.com>
>> ---
>>  drivers/media/platform/exynos-scaler/scaler.c | 1238 +++++++++++++++++++++++++
>>  drivers/media/platform/exynos-scaler/scaler.h |  375 ++++++++
>>  2 files changed, 1613 insertions(+)
>>  create mode 100644 drivers/media/platform/exynos-scaler/scaler.c
>>  create mode 100644 drivers/media/platform/exynos-scaler/scaler.h
>>
>> diff --git a/drivers/media/platform/exynos-scaler/scaler.c b/drivers/media/platform/exynos-scaler/scaler.c
>> new file mode 100644
>> index 0000000..57635f2
>> --- /dev/null
>> +++ b/drivers/media/platform/exynos-scaler/scaler.c
>> @@ -0,0 +1,1238 @@
>> +/*
>> + * Copyright (c) 2013 Samsung Electronics Co., Ltd.
>> + *           http://www.samsung.com
>> + *
>> + * Samsung EXYNOS5 SoC series SCALER driver
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + */
>> +
>> +#include <linux/clk.h>
>> +#include <linux/interrupt.h>
>> +#include <linux/module.h>
>> +#include <linux/of_platform.h>
>> +#include <linux/pm_runtime.h>
>> +
>> +#include "scaler-regs.h"
>> +
>> +#define SCALER_CLOCK_GATE_NAME       "scaler"
>> +
>> +static const struct scaler_fmt scaler_formats[] = {
>> +     {
>> +             .name           = "YUV 4:2:0 non-contig. 2p, Y/CbCr",
>> +             .pixelformat    = V4L2_PIX_FMT_NV12M,
>> +             .depth          = { 8, 4 },
>> +             .color          = SCALER_YUV420,
>> +             .color_order    = SCALER_CBCR,
>> +             .num_planes     = 2,
>> +             .num_comp       = 2,
>> +             .scaler_color   = SCALER_YUV420_2P_Y_UV,
>> +             .flags          = (SCALER_FMT_SRC | SCALER_FMT_DST),
>
> Not a big deal, but you don't need parenthesis for any of those .flags
> initialization.
>

Ok. I will fix this. and all other comments given by you in this patch series.

Regards,
Shaik Ameer Basha


[...] Snip

>
> --
>
> Cheers,
> Mauro
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
