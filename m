Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:39737 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754100AbeEaIXg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 31 May 2018 04:23:36 -0400
Received: by mail-wm0-f65.google.com with SMTP id f8-v6so52501039wmc.4
        for <linux-media@vger.kernel.org>; Thu, 31 May 2018 01:23:35 -0700 (PDT)
Subject: Re: [PATCH v2 15/29] venus: helpers: rename a helper function and use
 buffer mode from caps
To: Tomasz Figa <tfiga@chromium.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        vgarodia@codeaurora.org
References: <20180515075859.17217-1-stanimir.varbanov@linaro.org>
 <20180515075859.17217-16-stanimir.varbanov@linaro.org>
 <CAAFQd5BgTB0s0Dp7rqAVqxrUA74KNZSCo67xwVBPoWnZHiudFQ@mail.gmail.com>
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Message-ID: <bd3deac5-c331-d069-ed1d-797da948db33@linaro.org>
Date: Thu, 31 May 2018 11:23:32 +0300
MIME-Version: 1.0
In-Reply-To: <CAAFQd5BgTB0s0Dp7rqAVqxrUA74KNZSCo67xwVBPoWnZHiudFQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomasz,

Thanks for the review!

On 05/31/2018 10:59 AM, Tomasz Figa wrote:
> On Tue, May 15, 2018 at 5:06 PM Stanimir Varbanov
> <stanimir.varbanov@linaro.org> wrote:
>>
>> Rename is_reg_unreg_needed() to better name is_dynamic_bufmode() and
>> use buffer mode from enumerated per codec capabilities.
>>
>> Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
>> ---
>>  drivers/media/platform/qcom/venus/helpers.c | 21 +++++++++++----------
>>  1 file changed, 11 insertions(+), 10 deletions(-)
>>
>> diff --git a/drivers/media/platform/qcom/venus/helpers.c b/drivers/media/platform/qcom/venus/helpers.c
>> index 2b21f6ed7502..1eda19adbf28 100644
>> --- a/drivers/media/platform/qcom/venus/helpers.c
>> +++ b/drivers/media/platform/qcom/venus/helpers.c
>> @@ -354,18 +354,19 @@ session_process_buf(struct venus_inst *inst, struct vb2_v4l2_buffer *vbuf)
>>         return 0;
>>  }
>>
>> -static inline int is_reg_unreg_needed(struct venus_inst *inst)
>> +static inline int is_dynamic_bufmode(struct venus_inst *inst)
> 
> nit: Could be made bool.

And drop inline I guess? :)

-- 
regards,
Stan
