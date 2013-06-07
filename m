Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ve0-f182.google.com ([209.85.128.182]:45605 "EHLO
	mail-ve0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752202Ab3FGBiv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Jun 2013 21:38:51 -0400
Received: by mail-ve0-f182.google.com with SMTP id ox1so2660177veb.41
        for <linux-media@vger.kernel.org>; Thu, 06 Jun 2013 18:38:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1306051152540.19739@axis700.grange>
References: <1370425034-3648-1-git-send-email-wangwb@marvell.com>
	<Pine.LNX.4.64.1306051152540.19739@axis700.grange>
Date: Fri, 7 Jun 2013 09:38:50 +0800
Message-ID: <CAJZPFvFns5KSVjBHHNYk4_mzkTcnOWC8fnBXS_3B-RdDYMgdUw@mail.gmail.com>
Subject: Re: [PATCH] [media] soc_camera: error dev remove and v4l2 call
From: wenson <wenbing4375@gmail.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Wenbing Wang <wangwb@marvell.com>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi, Thanks very much for quick reply.
but I would like to push this patch early for 3.10 and even 3.8 since
we suppose to do s_power v4l2 callback for enable subdev self sepcial
power handle. in fact, we will have this requirement.
So if the uncorrect two functions callback order exists, we fail to do
it now. Thanks(sorry for reply again since previous email seems to be
rejected by vger.kernel.org)

2013/6/5 Guennadi Liakhovetski <g.liakhovetski@gmx.de>:
> Hi
>
> On Wed, 5 Jun 2013, Wenbing Wang wrote:
>
>> From: Wenbing Wang <wangwb@marvell.com>
>>
>> in soc_camera_close(), if ici->ops->remove() removes device firstly,
>> and then call __soc_camera_power_off(), it has logic error. Since
>> if remove device, it should disable subdev clk. but in __soc_camera_
>> power_off(), it will callback v4l2 s_power function which will
>> read/write subdev registers to control power by i2c. and then
>> i2c read/write will fail because of clk disable.
>> So suggest to re-sequence two functions call.
>
> Thanks for the patch. I agree, that the clock should be switched off after
> powering off the client. And this is also how it's done in the latest
> version of my v4l2-clk / v4l2-async patches: there in
> soc_camera_power_off() first power-off is performed and only then
> v4l2_clk_disable() is called to detach the client from the host and stop
> the master clock. So, if you need this fix for 3.10, we could push it
> upstream. Otherwise hopefully we'll manage to get v4l2-clk and -async in
> 3.11 and thus have this fixed there. Then this patch won't be needed.
>
> Thanks
> Guennadi
>
>> Change-Id: Iee7a6d4fc7c7c1addb5d342621eb8dcd00fa2745
>> Signed-off-by: Wenbing Wang <wangwb@marvell.com>
>> ---
>>  drivers/media/platform/soc_camera/soc_camera.c |    4 ++--
>>  1 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
>> index eea832c..3a4efbd 100644
>> --- a/drivers/media/platform/soc_camera/soc_camera.c
>> +++ b/drivers/media/platform/soc_camera/soc_camera.c
>> @@ -643,9 +643,9 @@ static int soc_camera_close(struct file *file)
>>
>>               if (ici->ops->init_videobuf2)
>>                       vb2_queue_release(&icd->vb2_vidq);
>> -             ici->ops->remove(icd);
>> -
>>               __soc_camera_power_off(icd);
>> +
>> +             ici->ops->remove(icd);
>>       }
>>
>>       if (icd->streamer == file)
>> --
>> 1.7.5.4
>>
>
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
