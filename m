Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f43.google.com ([209.85.219.43]:61042 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751757Ab3EUHuh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 May 2013 03:50:37 -0400
Received: by mail-oa0-f43.google.com with SMTP id o6so397119oag.16
        for <linux-media@vger.kernel.org>; Tue, 21 May 2013 00:50:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAK9yfHxBW4wF_sqyzW0+h1xycbDUyJLfWkSKBwZAjU00sh7akA@mail.gmail.com>
References: <CAK9yfHxBW4wF_sqyzW0+h1xycbDUyJLfWkSKBwZAjU00sh7akA@mail.gmail.com>
Date: Tue, 21 May 2013 13:20:37 +0530
Message-ID: <CAK9yfHzpvru59t9NcEnuXbPRU-qrscSc3YMZB7FpE6F900W_aw@mail.gmail.com>
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

On 17 May 2013 13:54, Sachin Kamat <sachin.kamat@linaro.org> wrote:
> Hi Hans,
>
> I noticed the following sparse warnings with S5P HDMI driver which I
> think got introduced due to the following commit:
> 5efb54b2b7b ([media] s5p-tv: add dv_timings support for hdmi)
>
> Warnings:
> drivers/media/platform/s5p-tv/hdmi_drv.c:483:18: error: unknown field
> name in initializer
> drivers/media/platform/s5p-tv/hdmi_drv.c:484:18: error: unknown field
> name in initializer
> drivers/media/platform/s5p-tv/hdmi_drv.c:485:18: error: unknown field
> name in initializer
> drivers/media/platform/s5p-tv/hdmi_drv.c:486:18: error: unknown field
> name in initializer
> drivers/media/platform/s5p-tv/hdmi_drv.c:487:18: error: unknown field
> name in initializer
> drivers/media/platform/s5p-tv/hdmi_drv.c:488:18: error: unknown field
> name in initializer
> drivers/media/platform/s5p-tv/hdmi_drv.c:489:18: error: unknown field
> name in initializer
> drivers/media/platform/s5p-tv/hdmi_drv.c:490:18: error: unknown field
> name in initializer
> drivers/media/platform/s5p-tv/hdmi_drv.c:491:18: error: unknown field
> name in initializer
> drivers/media/platform/s5p-tv/hdmi_drv.c:492:18: error: unknown field
> name in initializer
>
> This looks like the anonymous union initialization problem with GCC.
> Surprisingly I get this with GCC 4.6, 4.7 and 4.8 as well.
>
> If I add additional braces to the macro V4L2_INIT_BT_TIMINGS like done
> for GCC version < 4.6
> like
> { .bt = { _width , ## args } }
>
> or if I change the GNUC_MINOR comparison to 9 like (__GNUC_MINOR__ < 9)
> I dont see this error.
>
> I am using the Linaro GCC toolchain.
>
> I am not sure if this has already been reported and/or fixed.

Ping Hans..


-- 
With warm regards,
Sachin
