Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:48521 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752512Ab2FLGHL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Jun 2012 02:07:11 -0400
Received: by vbbff1 with SMTP id ff1so2721590vbb.19
        for <linux-media@vger.kernel.org>; Mon, 11 Jun 2012 23:07:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FD5EBE9.509@gmail.com>
References: <1339409634-13657-1-git-send-email-sachin.kamat@linaro.org>
	<1339409634-13657-3-git-send-email-sachin.kamat@linaro.org>
	<4FD5EBE9.509@gmail.com>
Date: Tue, 12 Jun 2012 11:37:10 +0530
Message-ID: <CAK9yfHy=uS3r7BvFR9JuxhdDZ=Pg0LKWjtKucmPDi4h76A5r_A@mail.gmail.com>
Subject: Re: [PATCH 3/3] [media] s5p-fimc: Replace printk with pr_* functions
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Sylwester Nawrocki <snjw23@gmail.com>
Cc: linux-media@vger.kernel.org, t.stanislaws@samsung.com,
	k.debski@samsung.com, s.nawrocki@samsung.com,
	kyungmin.park@samsung.com, mchehab@infradead.org,
	patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On 11/06/2012, Sylwester Nawrocki <snjw23@gmail.com> wrote:
> Hi Sachin,
>
> On 06/11/2012 12:13 PM, Sachin Kamat wrote:
>> Replace printk with pr_* functions to silence checkpatch warnings.
>>
>> Signed-off-by: Sachin Kamat<sachin.kamat@linaro.org>
>> ---
>>   drivers/media/video/s5p-fimc/fimc-core.h |    2 +-
>>   1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/media/video/s5p-fimc/fimc-core.h
>> b/drivers/media/video/s5p-fimc/fimc-core.h
>> index 95b27ae..c22fb0a 100644
>> --- a/drivers/media/video/s5p-fimc/fimc-core.h
>> +++ b/drivers/media/video/s5p-fimc/fimc-core.h
>> @@ -28,7 +28,7 @@
>>   #include<media/s5p_fimc.h>
>>
>>   #define err(fmt, args...) \
>> -	printk(KERN_ERR "%s:%d: " fmt "\n", __func__, __LINE__, ##args)
>> +	pr_err("%s:%d: " fmt "\n", __func__, __LINE__, ##args)
>
> I don't think it's worth the effort. If you really want to get rid
> of that warnings, please remove the err() macro altogether and
> do something like this instead:

Sounds reasonable. Will do that.

>
> 8<----------------------------------------------------------------
>
> diff --git a/drivers/media/video/s5p-fimc/fimc-core.h
> b/drivers/media/video/s5p-fimc/fimc-core.h
> index 95b27ae..808ccc6 100644
> --- a/drivers/media/video/s5p-fimc/fimc-core.h
> +++ b/drivers/media/video/s5p-fimc/fimc-core.h
> @@ -27,9 +27,6 @@
>  #include <media/v4l2-mediabus.h>
>  #include <media/s5p_fimc.h>
>
> -#define err(fmt, args...) \
> -       printk(KERN_ERR "%s:%d: " fmt "\n", __func__, __LINE__, ##args)
> -
>  #define dbg(fmt, args...) \
>         pr_debug("%s:%d: " fmt "\n", __func__, __LINE__, ##args)
>
> diff --git a/drivers/media/video/s5p-fimc/fimc-reg.c
> b/drivers/media/video/s5p-fimc/fimc-reg.c
> index 1fc4ce8..74a2fba 100644
> --- a/drivers/media/video/s5p-fimc/fimc-reg.c
> +++ b/drivers/media/video/s5p-fimc/fimc-reg.c
> @@ -683,8 +683,8 @@ int fimc_hw_set_camera_type(struct fimc_dev *fimc,
>                         cfg |= FIMC_REG_CIGCTRL_CAM_JPEG;
>                         break;
>                 default:
> -                       v4l2_err(fimc->vid_cap.vfd,
> -                                "Not supported camera pixel format: %d",
> +                       v4l2_err(vid_cap->vfd,
> +                                "Not supported camera pixel format:
> %#x\n",
>                                  vid_cap->mf.code);
>                         return -EINVAL;
>                 }
> @@ -699,7 +699,7 @@ int fimc_hw_set_camera_type(struct fimc_dev *fimc,
>         } else if (cam->bus_type == FIMC_LCD_WB) {
>                 cfg |= FIMC_REG_CIGCTRL_CAMIF_SELWB;
>         } else {
> -               err("invalid camera bus type selected\n");
> +               v4l2_err(vid_cap->vfd, "Invalid camera bus type
> selected\n");
>                 return -EINVAL;
>         }
>         writel(cfg, fimc->regs + FIMC_REG_CIGCTRL);
>
> 8>----------------------------------------------------------------
>
>
> Thanks!
>
> Sylwester
>


-- 
With warm regards,
Sachin
