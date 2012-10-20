Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:41999 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753910Ab2JTKaD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Oct 2012 06:30:03 -0400
Received: by mail-ee0-f46.google.com with SMTP id b15so455317eek.19
        for <linux-media@vger.kernel.org>; Sat, 20 Oct 2012 03:30:02 -0700 (PDT)
Message-ID: <50827D27.7020000@gmail.com>
Date: Sat, 20 Oct 2012 12:29:59 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Wei Yongjun <weiyj.lk@gmail.com>
CC: kyungmin.park@samsung.com, t.stanislaws@samsung.com,
	yongjun_wei@trendmicro.com.cn,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Subject: Re: [PATCH] [media] s5p-tv: remove unused including <linux/version.h>
References: <CAPgLHd-0c4D0cSVQBZA=bbaDvcu4yHBj_2DPPGrQMKQZxxGqBg@mail.gmail.com>
In-Reply-To: <CAPgLHd-0c4D0cSVQBZA=bbaDvcu4yHBj_2DPPGrQMKQZxxGqBg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 10/08/2012 02:32 PM, Wei Yongjun wrote:
> From: Wei Yongjun<yongjun_wei@trendmicro.com.cn>
>
> Remove including<linux/version.h>  that don't need it.
>
> dpatch engine is used to auto generate this patch.
> (https://github.com/weiyj/dpatch)

Sorry, I have already applied similar patch:
http://patchwork.linuxtv.org/patch/15057

Thanks,
Sylwester

> Signed-off-by: Wei Yongjun<yongjun_wei@trendmicro.com.cn>
> ---
>   drivers/media/platform/s5p-tv/mixer_video.c | 1 -
>   1 file changed, 1 deletion(-)
>
> diff --git a/drivers/media/platform/s5p-tv/mixer_video.c b/drivers/media/platform/s5p-tv/mixer_video.c
> index 0c1cd89..9b52f3a 100644
> --- a/drivers/media/platform/s5p-tv/mixer_video.c
> +++ b/drivers/media/platform/s5p-tv/mixer_video.c
> @@ -19,7 +19,6 @@
>   #include<linux/videodev2.h>
>   #include<linux/mm.h>
>   #include<linux/module.h>
> -#include<linux/version.h>
>   #include<linux/timer.h>
>   #include<media/videobuf2-dma-contig.h>

