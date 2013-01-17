Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f41.google.com ([209.85.219.41]:44600 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752728Ab3AQLUL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Jan 2013 06:20:11 -0500
Received: by mail-oa0-f41.google.com with SMTP id k14so2528407oag.14
        for <linux-media@vger.kernel.org>; Thu, 17 Jan 2013 03:20:09 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <50F7DD7F.5030504@samsung.com>
References: <1358395638-26086-1-git-send-email-sachin.kamat@linaro.org>
	<50F7DD7F.5030504@samsung.com>
Date: Thu, 17 Jan 2013 16:50:07 +0530
Message-ID: <CAK9yfHzF7Zbu+p8mgUmJmVi58Bf9qNVYSG5ih+tfOaDiUCOq8A@mail.gmail.com>
Subject: Re: [PATCH v2] s5p-g2d: Add support for G2D H/W Rev.4.1
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: linux-media@vger.kernel.org, k.debski@samsung.com,
	patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On 17 January 2013 16:46, Sylwester Nawrocki <s.nawrocki@samsung.com> wrote:
> Hi Sachin,
>
> On 01/17/2013 05:07 AM, Sachin Kamat wrote:
>> Modified the G2D driver (which initially supported only H/W Rev.3)
>> to support H/W Rev.4.1 present on Exynos4x12 and Exynos52x0 SOCs.
>>
>> -- Set the SRC and DST type to 'memory' instead of using reset values.
>> -- FIMG2D v4.1 H/W uses different logic for stretching(scaling).
>> -- Use CACHECTL_REG only with FIMG2D v3.
>>
>> Signed-off-by: Ajay Kumar <ajaykumar.rs@samsung.com>
>> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
>> Acked-by: Kamil Debski <k.debski@samsung.com>
>> ---
>> Changes since v1:
>> Moved g2d_get_drv_data() to g2d.h as suggested by
>> Sylwester Nawrocki <s.nawrocki@samsung.com>.
>
> I have applied this patch for 3.9, thanks.
Thank you.

You may also need a patch
> adding DT support, since those new SoCs are in mainline DT only.

Yes. I have also created a patch adding DT support. I will post it shortly.

>
> --
>
> Regards,
> Sylwester



-- 
With warm regards,
Sachin
