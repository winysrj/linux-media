Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f175.google.com ([209.85.220.175]:39849 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202Ab3FGK1g (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Jun 2013 06:27:36 -0400
Received: by mail-vc0-f175.google.com with SMTP id hr11so2665406vcb.34
        for <linux-media@vger.kernel.org>; Fri, 07 Jun 2013 03:27:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAK9yfHxRtY=s42TpiPrWeb-+gbtoY9tp30x-u3TvdwXwyQu31g@mail.gmail.com>
References: <1370005408-10853-1-git-send-email-arun.kk@samsung.com>
	<1370005408-10853-5-git-send-email-arun.kk@samsung.com>
	<CAK9yfHxRtY=s42TpiPrWeb-+gbtoY9tp30x-u3TvdwXwyQu31g@mail.gmail.com>
Date: Fri, 7 Jun 2013 15:57:35 +0530
Message-ID: <CALt3h79HXcHgX3B4mOpdo9+LK8vzp2M+f5oE5BAxtKsEQV4yGw@mail.gmail.com>
Subject: Re: [RFC v2 04/10] exynos5-fimc-is: Adds the register definition and
 context header
From: Arun Kumar K <arunkk.samsung@gmail.com>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Arun Kumar K <arun.kk@samsung.com>,
	LMML <linux-media@vger.kernel.org>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	kilyeon.im@samsung.com, shaik.ameer@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sachin,

Its a leftover from old PMU register access which is now modified
to be DT based. Will remove it.

Thanks & Regards
Arun

On Thu, Jun 6, 2013 at 11:54 AM, Sachin Kamat <sachin.kamat@linaro.org> wrote:
> On 31 May 2013 18:33, Arun Kumar K <arun.kk@samsung.com> wrote:
>> This patch adds the register definition file for the fimc-is driver
>> and also the header file containing the main context for the driver.
>>
>> Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
>> Signed-off-by: Kilyeon Im <kilyeon.im@samsung.com>
>> ---
>>  drivers/media/platform/exynos5-is/fimc-is-regs.h |  107 +++++++++++++++
>>  drivers/media/platform/exynos5-is/fimc-is.h      |  151 ++++++++++++++++++++++
>>  2 files changed, 258 insertions(+)
>>  create mode 100644 drivers/media/platform/exynos5-is/fimc-is-regs.h
>>  create mode 100644 drivers/media/platform/exynos5-is/fimc-is.h
>>
>> diff --git a/drivers/media/platform/exynos5-is/fimc-is-regs.h b/drivers/media/platform/exynos5-is/fimc-is-regs.h
>> new file mode 100644
>> index 0000000..d00df7b
>> --- /dev/null
>> +++ b/drivers/media/platform/exynos5-is/fimc-is-regs.h
>> @@ -0,0 +1,107 @@
>> +/*
>> + * Samsung Exynos5 SoC series FIMC-IS driver
>> + *
>> + * Copyright (c) 2013 Samsung Electronics Co., Ltd
>> + * Arun Kumar K <arun.kk@samsung.com>
>> + * Kil-yeon Lim <kilyeon.im@samsung.com>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + */
>> +
>> +#ifndef FIMC_IS_REGS_H
>> +#define FIMC_IS_REGS_H
>> +
>> +#include <mach/map.h>
>
> Why do you need this?
>
>
> --
> With warm regards,
> Sachin
