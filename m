Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:60233 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752463AbaJUIuK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Oct 2014 04:50:10 -0400
Received: by mail-wi0-f178.google.com with SMTP id r20so1152823wiv.5
        for <linux-media@vger.kernel.org>; Tue, 21 Oct 2014 01:50:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <11f401cfe2e2$46d42bf0$d47c83d0$%debski@samsung.com>
References: <1411707142-4881-1-git-send-email-avnd.kiran@samsung.com>
	<1411707142-4881-8-git-send-email-avnd.kiran@samsung.com>
	<11f401cfe2e2$46d42bf0$d47c83d0$%debski@samsung.com>
Date: Tue, 21 Oct 2014 14:20:08 +0530
Message-ID: <CALt3h7_q_7ripcz3Fhvej3AU1-16xiQwYpYJYt6q41TP26pj6g@mail.gmail.com>
Subject: Re: [PATCH v2 07/14] [media] s5p-mfc: Don't crash the kernel if the
 watchdog kicks in.
From: Arun Kumar K <arun.kk@samsung.com>
To: Kamil Debski <k.debski@samsung.com>
Cc: Kiran AVND <avnd.kiran@samsung.com>,
	LMML <linux-media@vger.kernel.org>, wuchengli@chromium.org,
	Pawel Osciak <posciak@chromium.org>,
	Arun Mankuzhi <arun.m@samsung.com>, ihf@chromium.org,
	prathyush.k@samsung.com, kiran@chromium.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kamil,

Kiran will not be available to handle review comments of these patches.
So I will be pushing the updated patchset rebased on media-tree.

I hope all patches are good to merge except
[media] s5p-mfc: Don't change the image size to smaller than the request.

I will drop this one patch and send all others in v3 version.

Regards
Arun

On Wed, Oct 8, 2014 at 3:56 PM, Kamil Debski <k.debski@samsung.com> wrote:
> Hi,
>
> This patch does not apply to the current media tree.
>
> commit cf3167cf1e969b17671a4d3d956d22718a8ceb85)
> Author: Antti Palosaari <crope@iki.fi>
> Date:   Fri Sep 26 22:45:36 2014 -0300
>
>     [media] pt3: fix DTV FE I2C driver load error paths
>
> Best wishes,
> --
> Kamil Debski
> Samsung R&D Institute Poland
>
>
>> -----Original Message-----
>> From: Kiran AVND [mailto:avnd.kiran@samsung.com]
>> Sent: Friday, September 26, 2014 6:52 AM
>> To: linux-media@vger.kernel.org
>> Cc: k.debski@samsung.com; wuchengli@chromium.org; posciak@chromium.org;
>> arun.m@samsung.com; ihf@chromium.org; prathyush.k@samsung.com;
>> arun.kk@samsung.com; kiran@chromium.org
>> Subject: [PATCH v2 07/14] [media] s5p-mfc: Don't crash the kernel if
>> the watchdog kicks in.
>>
>> From: Pawel Osciak <posciak@chromium.org>
>>
>> If the software watchdog kicks in, the watchdog worker is not
>> synchronized with hardware interrupts and does not block other
>> instances. It's possible for it to clear the hw_lock, making other
>> instances trigger a BUG() on hw_lock checks. Since it's not fatal to
>> clear the hw_lock to zero twice, just WARN in those cases for now. We
>> should not explode, as firmware will return errors as needed for other
>> instances after it's reloaded, or they will time out.
>>
>> A clean fix should involve killing other instances when watchdog kicks
>> in, but requires a major redesign of locking in the driver.
>>
>> Signed-off-by: Pawel Osciak <posciak@chromium.org>
>> Signed-off-by: Kiran AVND <avnd.kiran@samsung.com>
>> ---
>>  drivers/media/platform/s5p-mfc/s5p_mfc.c |   25 +++++++---------------
>> ---
>>  1 file changed, 7 insertions(+), 18 deletions(-)
>>
>> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c
>> b/drivers/media/platform/s5p-mfc/s5p_mfc.c
>> index 3fc2f8a..8d5da0c 100644
>> --- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
>> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
>> @@ -337,8 +337,7 @@ static void s5p_mfc_handle_frame(struct s5p_mfc_ctx
>> *ctx,
>>               ctx->state = MFCINST_RES_CHANGE_INIT;
>>               s5p_mfc_hw_call(dev->mfc_ops, clear_int_flags, dev);
>>               wake_up_ctx(ctx, reason, err);
>> -             if (test_and_clear_bit(0, &dev->hw_lock) == 0)
>> -                     BUG();
>> +             WARN_ON(test_and_clear_bit(0, &dev->hw_lock) == 0);
>>               s5p_mfc_clock_off();
>>               s5p_mfc_hw_call(dev->mfc_ops, try_run, dev);
>>               return;
>> @@ -410,8 +409,7 @@ leave_handle_frame:
>>               clear_work_bit(ctx);
>>       s5p_mfc_hw_call(dev->mfc_ops, clear_int_flags, dev);
>>       wake_up_ctx(ctx, reason, err);
>> -     if (test_and_clear_bit(0, &dev->hw_lock) == 0)
>> -             BUG();
>> +     WARN_ON(test_and_clear_bit(0, &dev->hw_lock) == 0);
>>       s5p_mfc_clock_off();
>>       /* if suspending, wake up device and do not try_run again*/
>>       if (test_bit(0, &dev->enter_suspend))
>> @@ -458,8 +456,7 @@ static void s5p_mfc_handle_error(struct s5p_mfc_dev
>> *dev,
>>                       break;
>>               }
>>       }
>> -     if (test_and_clear_bit(0, &dev->hw_lock) == 0)
>> -             BUG();
>> +     WARN_ON(test_and_clear_bit(0, &dev->hw_lock) == 0);
>>       s5p_mfc_hw_call(dev->mfc_ops, clear_int_flags, dev);
>>       s5p_mfc_clock_off();
>>       wake_up_dev(dev, reason, err);
>> @@ -513,8 +510,7 @@ static void s5p_mfc_handle_seq_done(struct
>> s5p_mfc_ctx *ctx,
>>       }
>>       s5p_mfc_hw_call(dev->mfc_ops, clear_int_flags, dev);
>>       clear_work_bit(ctx);
>> -     if (test_and_clear_bit(0, &dev->hw_lock) == 0)
>> -             BUG();
>> +     WARN_ON(test_and_clear_bit(0, &dev->hw_lock) == 0);
>>       s5p_mfc_clock_off();
>>       s5p_mfc_hw_call(dev->mfc_ops, try_run, dev);
>>       wake_up_ctx(ctx, reason, err);
>> @@ -552,19 +548,13 @@ static void s5p_mfc_handle_init_buffers(struct
>> s5p_mfc_ctx *ctx,
>>               } else {
>>                       ctx->dpb_flush_flag = 0;
>>               }
>> -             if (test_and_clear_bit(0, &dev->hw_lock) == 0)
>> -                     BUG();
>> -
>> +             WARN_ON(test_and_clear_bit(0, &dev->hw_lock) == 0);
>>               s5p_mfc_clock_off();
>> -
>>               wake_up(&ctx->queue);
>>               s5p_mfc_hw_call(dev->mfc_ops, try_run, dev);
>>       } else {
>> -             if (test_and_clear_bit(0, &dev->hw_lock) == 0)
>> -                     BUG();
>> -
>> +             WARN_ON(test_and_clear_bit(0, &dev->hw_lock) == 0);
>>               s5p_mfc_clock_off();
>> -
>>               wake_up(&ctx->queue);
>>       }
>>  }
>> @@ -638,8 +628,7 @@ static irqreturn_t s5p_mfc_irq(int irq, void *priv)
>>                               mfc_err("post_frame_start() failed\n");
>>                       s5p_mfc_hw_call(dev->mfc_ops, clear_int_flags, dev);
>>                       wake_up_ctx(ctx, reason, err);
>> -                     if (test_and_clear_bit(0, &dev->hw_lock) == 0)
>> -                             BUG();
>> +                     WARN_ON(test_and_clear_bit(0, &dev->hw_lock) == 0);
>>                       s5p_mfc_clock_off();
>>                       s5p_mfc_hw_call(dev->mfc_ops, try_run, dev);
>>               } else {
>> --
>> 1.7.9.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
