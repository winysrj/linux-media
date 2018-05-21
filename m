Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:41683 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752725AbeEUObn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 May 2018 10:31:43 -0400
Received: by mail-wr0-f194.google.com with SMTP id w15-v6so8684444wrp.8
        for <linux-media@vger.kernel.org>; Mon, 21 May 2018 07:31:42 -0700 (PDT)
Subject: Re: [PATCH v2 03/29] venus: hfi: update sequence event to handle more
 properties
To: Tomasz Figa <tfiga@chromium.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        vgarodia@codeaurora.org
References: <20180515075859.17217-1-stanimir.varbanov@linaro.org>
 <20180515075859.17217-4-stanimir.varbanov@linaro.org>
 <CAAFQd5DVz-VcyR5DibXjRXCzy=w0PeoG0ru8Eadc4+thCX4f=A@mail.gmail.com>
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Message-ID: <b375ac04-8757-c5e4-1813-8adb17a8a3d5@linaro.org>
Date: Mon, 21 May 2018 17:31:40 +0300
MIME-Version: 1.0
In-Reply-To: <CAAFQd5DVz-VcyR5DibXjRXCzy=w0PeoG0ru8Eadc4+thCX4f=A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomasz,

On 05/18/2018 04:53 PM, Tomasz Figa wrote:
> On Tue, May 15, 2018 at 5:14 PM Stanimir Varbanov <
> stanimir.varbanov@linaro.org> wrote:
> 
>> HFI version 4xx can pass more properties in the sequence change
>> event, extend the event structure with them.
> 
>> Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
>> ---
>>   drivers/media/platform/qcom/venus/hfi.h      |  9 ++++++
>>   drivers/media/platform/qcom/venus/hfi_msgs.c | 46
> ++++++++++++++++++++++++++++
>>   2 files changed, 55 insertions(+)
> 
>> diff --git a/drivers/media/platform/qcom/venus/hfi.h
> b/drivers/media/platform/qcom/venus/hfi.h
>> index 5466b7d60dd0..21376d93170f 100644
>> --- a/drivers/media/platform/qcom/venus/hfi.h
>> +++ b/drivers/media/platform/qcom/venus/hfi.h
>> @@ -74,6 +74,15 @@ struct hfi_event_data {
>>          u32 tag;
>>          u32 profile;
>>          u32 level;
> 
> nit; Could we add a comment saying that it showed in 4xx?

Sure, I can add a comment.

> 
> [snip]
> 
>> +               case HFI_PROPERTY_CONFIG_VDEC_ENTROPY:
>> +                       data_ptr += sizeof(u32);
>> +                       entropy_mode = *(u32 *)data_ptr;
>> +                       event.entropy_mode = entropy_mode;
> 
> Is the |entropy_mode| local variable necessary?

Isn't GCC smart enough ;) Sure, I can drop entropy_mode local variable.

-- 
regards,
Stan
