Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f181.google.com ([209.85.214.181]:60462 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752639Ab3EVLF3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 May 2013 07:05:29 -0400
Received: by mail-ob0-f181.google.com with SMTP id dn14so2048402obc.40
        for <linux-media@vger.kernel.org>; Wed, 22 May 2013 04:05:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201305211128.31301.hverkuil@xs4all.nl>
References: <CAK9yfHxBW4wF_sqyzW0+h1xycbDUyJLfWkSKBwZAjU00sh7akA@mail.gmail.com>
	<201305211128.31301.hverkuil@xs4all.nl>
Date: Wed, 22 May 2013 16:35:29 +0530
Message-ID: <CAK9yfHyPGdNBbn6o-GLaoeTuYLCEQdCjaw+r2T_UU7_TQLHk8Q@mail.gmail.com>
Subject: Re: Warnings related to anonymous unions in s5p-tv driver
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media <linux-media@vger.kernel.org>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	hans.verkuil@cisco.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 21 May 2013 14:58, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On Fri 17 May 2013 10:24:50 Sachin Kamat wrote:
>> Hi Hans,
>>
>> I noticed the following sparse warnings with S5P HDMI driver which I
>> think got introduced due to the following commit:
>> 5efb54b2b7b ([media] s5p-tv: add dv_timings support for hdmi)
>>
>> Warnings:
>> drivers/media/platform/s5p-tv/hdmi_drv.c:483:18: error: unknown field
>> name in initializer
>> drivers/media/platform/s5p-tv/hdmi_drv.c:484:18: error: unknown field
>> name in initializer
>> drivers/media/platform/s5p-tv/hdmi_drv.c:485:18: error: unknown field
>> name in initializer
>> drivers/media/platform/s5p-tv/hdmi_drv.c:486:18: error: unknown field
>> name in initializer
>> drivers/media/platform/s5p-tv/hdmi_drv.c:487:18: error: unknown field
>> name in initializer
>> drivers/media/platform/s5p-tv/hdmi_drv.c:488:18: error: unknown field
>> name in initializer
>> drivers/media/platform/s5p-tv/hdmi_drv.c:489:18: error: unknown field
>> name in initializer
>> drivers/media/platform/s5p-tv/hdmi_drv.c:490:18: error: unknown field
>> name in initializer
>> drivers/media/platform/s5p-tv/hdmi_drv.c:491:18: error: unknown field
>> name in initializer
>> drivers/media/platform/s5p-tv/hdmi_drv.c:492:18: error: unknown field
>> name in initializer
>>
>> This looks like the anonymous union initialization problem with GCC.
>> Surprisingly I get this with GCC 4.6, 4.7 and 4.8 as well.
>>
>> If I add additional braces to the macro V4L2_INIT_BT_TIMINGS like done
>> for GCC version < 4.6
>> like
>> { .bt = { _width , ## args } }
>>
>> or if I change the GNUC_MINOR comparison to 9 like (__GNUC_MINOR__ < 9)
>> I dont see this error.
>>
>> I am using the Linaro GCC toolchain.
>>
>> I am not sure if this has already been reported and/or fixed.
>>
>
> Could it be that a different compiler version is used when using sparse?
> I don't see these errors when running sparse during the daily build.

Please let me know your compiler version. I could probably try with it and see.


-- 
With warm regards,
Sachin
