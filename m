Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f196.google.com ([209.85.217.196]:36416 "EHLO
	mail-lb0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965995AbcAZOHP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Jan 2016 09:07:15 -0500
Received: by mail-lb0-f196.google.com with SMTP id ad5so7890318lbc.3
        for <linux-media@vger.kernel.org>; Tue, 26 Jan 2016 06:07:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1601241906070.16570@axis700.grange>
References: <1453119709-20940-1-git-send-email-rainyfeeling@gmail.com>
	<1453121545-27528-1-git-send-email-rainyfeeling@gmail.com>
	<1453121545-27528-2-git-send-email-rainyfeeling@gmail.com>
	<Pine.LNX.4.64.1601241906070.16570@axis700.grange>
Date: Tue, 26 Jan 2016 22:07:13 +0800
Message-ID: <CAJe_HAfYykQraPc81j5z4=kkKzntzwX+5iVWqbeDjjSkqHYSxw@mail.gmail.com>
Subject: Re: [PATCH 07/13] atmel-isi: move hw code into isi_hw_initialize()
From: Josh Wu <rainyfeeling@gmail.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Nicolas Ferre <nicolas.ferre@atmel.com>,
	linux-arm-kernel@lists.infradead.org,
	Ludovic Desroches <ludovic.desroches@atmel.com>,
	Songjun Wu <songjun.wu@atmel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, Guennadi

Thanks for the reivew.

2016-01-25 2:09 GMT+08:00 Guennadi Liakhovetski <g.liakhovetski@gmx.de>:
> On Mon, 18 Jan 2016, Josh Wu wrote:
>
>> That make hw operation code separate with general code.
>>
>> Also since reset action can be failed, so add a return value for
>> isi_hw_initialze().
>>
>> Signed-off-by: Josh Wu <rainyfeeling@gmail.com>
>> ---
>>
>>  drivers/media/platform/soc_camera/atmel-isi.c | 34 +++++++++++++++++----------
>>  1 file changed, 21 insertions(+), 13 deletions(-)
>>
>> diff --git a/drivers/media/platform/soc_camera/atmel-isi.c b/drivers/media/platform/soc_camera/atmel-isi.c
>> index 4ddc309..ed4d04b 100644
>> --- a/drivers/media/platform/soc_camera/atmel-isi.c
>> +++ b/drivers/media/platform/soc_camera/atmel-isi.c
>> @@ -203,10 +203,27 @@ static int isi_hw_wait_status(struct atmel_isi *isi, int status_flag,
>>       return 0;
>>  }
>>
>> -static void isi_hw_initialize(struct atmel_isi *isi)
>> +static int isi_hw_initialize(struct atmel_isi *isi)
>>  {
>>       u32 common_flags = isi->bus_param;
>>       u32 cfg1 = 0;
>> +     int ret;
>> +
>> +     /* Reset ISI */
>> +     isi_writel(isi, ISI_CTRL, ISI_CTRL_SRST);
>> +
>> +     /* Check Reset status */
>> +     ret  = isi_hw_wait_status(isi, ISI_CTRL_SRST, 500);
>
> You could also remove the superfluous space while at it.

sure, I'll fix the duplicated space here.

Best Regards,
Josh Wu

>
> Thanks
> Guennadi
>
>> +     if (ret) {
>> +             dev_err(isi->soc_host.icd->parent, "Reset ISI timed out\n");
>> +             return ret;
>> +     }
>> +
>> +     /* Disable all interrupts */
>> +     isi_writel(isi, ISI_INTDIS, (u32)~0UL);
>> +
>> +     /* Clear any pending interrupt */
>> +     isi_readl(isi, ISI_STATUS);
>>
>>       /* set bus param for ISI */
>>       if (common_flags & V4L2_MBUS_HSYNC_ACTIVE_LOW)
>> @@ -229,6 +246,8 @@ static void isi_hw_initialize(struct atmel_isi *isi)
>>
>>       isi_writel(isi, ISI_CTRL, ISI_CTRL_DIS);
>>       isi_writel(isi, ISI_CFG1, cfg1);
>> +
>> +     return 0;
>>  }
>>
>>  static irqreturn_t atmel_isi_handle_streaming(struct atmel_isi *isi)
>> @@ -453,27 +472,16 @@ static int start_streaming(struct vb2_queue *vq, unsigned int count)
>>
>>       pm_runtime_get_sync(ici->v4l2_dev.dev);
>>
>> -     /* Reset ISI */
>> -     isi_writel(isi, ISI_CTRL, ISI_CTRL_SRST);
>> -
>> -     /* Check Reset status */
>> -     ret  = isi_hw_wait_status(isi, ISI_CTRL_SRST, 500);
>> +     ret = isi_hw_initialize(isi);
>>       if (ret) {
>> -             dev_err(icd->parent, "Reset ISI timed out\n");
>>               pm_runtime_put(ici->v4l2_dev.dev);
>>               return ret;
>>       }
>> -     /* Disable all interrupts */
>> -     isi_writel(isi, ISI_INTDIS, (u32)~0UL);
>> -
>> -     isi_hw_initialize(isi);
>>
>>       configure_geometry(isi, icd->user_width, icd->user_height,
>>                               icd->current_fmt);
>>
>>       spin_lock_irq(&isi->lock);
>> -     /* Clear any pending interrupt */
>> -     isi_readl(isi, ISI_STATUS);
>>
>>       if (count)
>>               start_dma(isi, isi->active);
>> --
>> 1.9.1
>>
