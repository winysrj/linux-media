Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f178.google.com ([209.85.214.178]:55066 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752796Ab3ACCxW (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Jan 2013 21:53:22 -0500
Received: by mail-ob0-f178.google.com with SMTP id eh20so13323419obb.37
        for <linux-media@vger.kernel.org>; Wed, 02 Jan 2013 18:53:21 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <007301cde917$0c97b180$25c71480$%debski@samsung.com>
References: <1356689908-6866-1-git-send-email-sachin.kamat@linaro.org>
	<1356689908-6866-2-git-send-email-sachin.kamat@linaro.org>
	<007301cde917$0c97b180$25c71480$%debski@samsung.com>
Date: Thu, 3 Jan 2013 08:23:21 +0530
Message-ID: <CAK9yfHyoq=irmzjyiJnMK_f=-8jiQMKAEEakWLhy8TFKHsE7Jw@mail.gmail.com>
Subject: Re: [PATCH 2/3] [media] s5p-mfc: Remove redundant 'break'
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Kamil Debski <k.debski@samsung.com>
Cc: linux-media@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	sylvester.nawrocki@gmail.com, patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks Kamil.

I assume you have 'Acked' this patch as well :)

On 2 January 2013 23:59, Kamil Debski <k.debski@samsung.com> wrote:
> Hi Sachin,
>
> Thank you for your patch.
>
> Best wishes,
> --
> Kamil Debski
> Linux Platform Group
> Samsung Poland R&D Center
>
>> -----Original Message-----
>> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
>> owner@vger.kernel.org] On Behalf Of Sachin Kamat
>> Sent: Friday, December 28, 2012 11:18 AM
>> To: linux-media@vger.kernel.org
>> Cc: k.debski@samsung.com; s.nawrocki@samsung.com;
>> sylvester.nawrocki@gmail.com; sachin.kamat@linaro.org;
>> patches@linaro.org
>> Subject: [PATCH 2/3] [media] s5p-mfc: Remove redundant 'break'
>>
>> The code returns before this statement. Hence not required.
>> Silences the following smatch message:
>> drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c:525
>> s5p_mfc_set_dec_frame_buffer_v5() info: ignoring unreachable code.
>>
>> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
>> ---
>>  drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c |    1 -
>>  1 files changed, 0 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c
>> b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c
>> index bb99d3d..b0f277e 100644
>> --- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c
>> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c
>> @@ -522,7 +522,6 @@ int s5p_mfc_set_dec_frame_buffer_v5(struct
>> s5p_mfc_ctx *ctx)
>>               mfc_err("Unknown codec for decoding (%x)\n",
>>                       ctx->codec_mode);
>>               return -EINVAL;
>> -             break;
>>       }
>>       frame_size = ctx->luma_size;
>>       frame_size_ch = ctx->chroma_size;
>> --
>> 1.7.4.1
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media"
>> in the body of a message to majordomo@vger.kernel.org More majordomo
>> info at  http://vger.kernel.org/majordomo-info.html
>
>



-- 
With warm regards,
Sachin
