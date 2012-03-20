Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:52660 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752456Ab2CTDuL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Mar 2012 23:50:11 -0400
Received: by qcqw6 with SMTP id w6so1590959qcq.19
        for <linux-media@vger.kernel.org>; Mon, 19 Mar 2012 20:50:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <000601cd05e5$b576bdc0$20643940$%p@samsung.com>
References: <1332156889-8175-1-git-send-email-sachin.kamat@linaro.org>
	<000601cd05e5$b576bdc0$20643940$%p@samsung.com>
Date: Tue, 20 Mar 2012 09:20:09 +0530
Message-ID: <CAK9yfHx_h2JJWBFxrEL_Q+x6e3h1a=Qn+=x=wBwzJAUnGPg3wA@mail.gmail.com>
Subject: Re: [PATCH] [media] s5p-jpeg: Make the output format setting conditional
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Cc: linux-media@vger.kernel.org, mchehab@infradead.org,
	patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andrzej,


On 19/03/2012, Andrzej Pietrasiewicz <andrzej.p@samsung.com> wrote:
> Hello,
>
> On March 19, 2012 12:35 PM Sachin Kamat wrote:
>
>> Subject: [PATCH] [media] s5p-jpeg: Make the output format setting
> conditional
>>
>> S5P-JPEG IP on Exynos4210 SoC supports YCbCr422 and YCbCr420
>> as decoded output formats. But the driver used to fix the output
>> format as YCbCr422. This is now made conditional depending upon
>> the requested output format.
>>
>> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
>> ---
>>  drivers/media/video/s5p-jpeg/jpeg-core.c |    5 ++++-
>
> <snip>
>
> This has already been submitted and been pulled by Mauro:
>
> http://git.linuxtv.org/media_tree.git/commit/fb6f8c0269644a19ee5e9bd6db080b3
> 64ab28ea7

Thanks for the update. I did not notice this patch.
Please ignore my patch.

>
> Andrzej
>
>
>
>


-- 
With warm regards,
Sachin
