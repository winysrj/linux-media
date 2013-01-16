Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f44.google.com ([209.85.219.44]:60164 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758832Ab3APKXi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Jan 2013 05:23:38 -0500
Received: by mail-oa0-f44.google.com with SMTP id n5so1227632oag.3
        for <linux-media@vger.kernel.org>; Wed, 16 Jan 2013 02:23:37 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <50F67D4A.9010909@samsung.com>
References: <1357541069-7898-1-git-send-email-sachin.kamat@linaro.org>
	<50F67D4A.9010909@samsung.com>
Date: Wed, 16 Jan 2013 15:53:37 +0530
Message-ID: <CAK9yfHzaGgKrwbwbHjiciMWdD3dEqMctWj89pCSvUuotHBVG7Q@mail.gmail.com>
Subject: Re: [PATCH] s5p-g2d: Add support for G2D H/W Rev.4.1
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: linux-media@vger.kernel.org, ajaykumar.rs@samsung.com,
	patches@linaro.org, Kamil Debski <k.debski@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On 16 January 2013 15:43, Sylwester Nawrocki <s.nawrocki@samsung.com> wrote:
> Hi Sachin,
>
> I have just one small comment...
>
> On 01/07/2013 07:44 AM, Sachin Kamat wrote:
>> +static void *g2d_get_drv_data(struct platform_device *pdev)
>> +{
>> +     struct g2d_variant *driver_data = NULL;
>> +
>> +     driver_data = (struct g2d_variant *)
>> +             platform_get_device_id(pdev)->driver_data;
>> +
>> +     return driver_data;
>> +}
>
> How about adding this to g2d.h as:
>
> static inline struct g2d_variant *g2d_get_drv_data(struct platform_device *pdev)
> {
>         return (struct g2d_variant *)platform_get_device_id(pdev)->driver_data;
> }
>
> ?

OK. I will move it to g2d.h and resend the patch.

>
> Otherwise the patch looks OK to me.
>
> --
>
> Thanks,
> Sylwester



-- 
With warm regards,
Sachin
