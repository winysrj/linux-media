Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f171.google.com ([209.85.216.171]:62471 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744Ab3CHGHe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Mar 2013 01:07:34 -0500
Received: by mail-qc0-f171.google.com with SMTP id d1so441986qca.2
        for <linux-media@vger.kernel.org>; Thu, 07 Mar 2013 22:07:31 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <5138A967.8010203@samsung.com>
References: <1361447658-20793-1-git-send-email-shaik.ameer@samsung.com>
	<5138A967.8010203@samsung.com>
Date: Fri, 8 Mar 2013 11:37:33 +0530
Message-ID: <CAOD6AToW04FMcYqy6zgfrZSaHVrihEioz++j2O_Jiq-DdPPxFg@mail.gmail.com>
Subject: Re: [PATCH] [media] fimc-lite: Fix the variable type to avoid
 possible crash
From: Shaik Ameer Basha <shaik.samsung@gmail.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Mar 7, 2013 at 8:21 PM, Sylwester Nawrocki
<s.nawrocki@samsung.com> wrote:
> On 02/21/2013 12:54 PM, Shaik Ameer Basha wrote:
>> Changing the variable type to 'int' from 'unsigned int'. Driver
>> logic expects the variable type to be 'int'.
>>
>> Signed-off-by: Shaik Ameer Basha <shaik.ameer@samsung.com>
>> ---
>>  drivers/media/platform/s5p-fimc/fimc-lite-reg.c |    4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/media/platform/s5p-fimc/fimc-lite-reg.c b/drivers/media/platform/s5p-fimc/fimc-lite-reg.c
>> index f0af075..3c7dd65 100644
>> --- a/drivers/media/platform/s5p-fimc/fimc-lite-reg.c
>> +++ b/drivers/media/platform/s5p-fimc/fimc-lite-reg.c
>> @@ -128,7 +128,7 @@ static const u32 src_pixfmt_map[8][3] = {
>>  void flite_hw_set_source_format(struct fimc_lite *dev, struct flite_frame *f)
>>  {
>>       enum v4l2_mbus_pixelcode pixelcode = dev->fmt->mbus_code;
>> -     unsigned int i = ARRAY_SIZE(src_pixfmt_map);
>> +     int i = ARRAY_SIZE(src_pixfmt_map);
>>       u32 cfg;
>>
>>       while (i-- >= 0) {
>> @@ -224,7 +224,7 @@ static void flite_hw_set_out_order(struct fimc_lite *dev, struct flite_frame *f)
>>               { V4L2_MBUS_FMT_VYUY8_2X8, FLITE_REG_CIODMAFMT_CRYCBY },
>>       };
>>       u32 cfg = readl(dev->regs + FLITE_REG_CIODMAFMT);
>> -     unsigned int i = ARRAY_SIZE(pixcode);
>> +     int i = ARRAY_SIZE(pixcode);
>>
>>       while (i-- >= 0)
>>               if (pixcode[i][0] == dev->fmt->mbus_code)
>>
>
> There was a build warning like:
>
> drivers/media/platform/s5p-fimc/fimc-lite-reg.c: In function ‘flite_hw_set_output_dma’:
> drivers/media/platform/s5p-fimc/fimc-lite-reg.c:230: warning: array subscript is below array bounds
> drivers/media/platform/s5p-fimc/fimc-lite-reg.c: In function ‘flite_hw_set_source_format’:
> drivers/media/platform/s5p-fimc/fimc-lite-reg.c:135: warning: array subscript is below array bounds
>
> thus I squashed following change before applying this patch:

Thanks for that :)

-Shaik

>
> diff --git a/drivers/media/platform/s5p-fimc/fimc-lite-reg.c b/drivers/media/platform/s5p-fimc/fimc-lite-reg.c
> index 3c7dd65..ac9663c 100644
> --- a/drivers/media/platform/s5p-fimc/fimc-lite-reg.c
> +++ b/drivers/media/platform/s5p-fimc/fimc-lite-reg.c
> @@ -131,7 +131,7 @@ void flite_hw_set_source_format(struct fimc_lite *dev, struct flite_frame *f)
>         int i = ARRAY_SIZE(src_pixfmt_map);
>         u32 cfg;
>
> -       while (i-- >= 0) {
> +       while (--i >= 0) {
>                 if (src_pixfmt_map[i][0] == pixelcode)
>                         break;
>         }
> @@ -226,7 +226,7 @@ static void flite_hw_set_out_order(struct fimc_lite *dev, struct flite_frame *f)
>         u32 cfg = readl(dev->regs + FLITE_REG_CIODMAFMT);
>         int i = ARRAY_SIZE(pixcode);
>
> -       while (i-- >= 0)
> +       while (--i >= 0)
>                 if (pixcode[i][0] == dev->fmt->mbus_code)
>                         break;
>         cfg &= ~FLITE_REG_CIODMAFMT_YCBCR_ORDER_MASK;
>
> --
>
> Regards,
> Sylwester
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
