Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:60560 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933423AbeGBJfV (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 2 Jul 2018 05:35:21 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Mon, 02 Jul 2018 15:05:20 +0530
From: Vikash Garodia <vgarodia@codeaurora.org>
To: Alexandre Courbot <acourbot@chromium.org>
Cc: Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org, Tomasz Figa <tfiga@chromium.org>,
        linux-media-owner@vger.kernel.org
Subject: Re: [PATCH v4 24/27] venus: helpers: move frame size calculations on
 common place
In-Reply-To: <CAPBb6MVPrparfoAMaVwsDrwPO1K8cnWb24WdZFGeU5aoEqDt5w@mail.gmail.com>
References: <20180627152725.9783-1-stanimir.varbanov@linaro.org>
 <20180627152725.9783-25-stanimir.varbanov@linaro.org>
 <CAPBb6MVPrparfoAMaVwsDrwPO1K8cnWb24WdZFGeU5aoEqDt5w@mail.gmail.com>
Message-ID: <4e22af7d7ef9037996b606892ed25b36@codeaurora.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2018-07-02 14:16, Alexandre Courbot wrote:
> On Thu, Jun 28, 2018 at 12:28 AM Stanimir Varbanov
> <stanimir.varbanov@linaro.org> wrote:
>> 
>> This move the calculations of raw and compressed buffer sizes
>> on common helper and make it identical for encoder and decoder.
>> 
>> Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
>> ---
>>  drivers/media/platform/qcom/venus/helpers.c | 98 
>> +++++++++++++++++++++++++++++
>>  drivers/media/platform/qcom/venus/helpers.h |  2 +
>>  drivers/media/platform/qcom/venus/vdec.c    | 54 ++++------------
>>  drivers/media/platform/qcom/venus/venc.c    | 56 ++++-------------
>>  4 files changed, 126 insertions(+), 84 deletions(-)
>> 
>> diff --git a/drivers/media/platform/qcom/venus/helpers.c 
>> b/drivers/media/platform/qcom/venus/helpers.c
>> index 6b31c91528ed..a342472ae2f0 100644
>> --- a/drivers/media/platform/qcom/venus/helpers.c
>> +++ b/drivers/media/platform/qcom/venus/helpers.c
>> @@ -452,6 +452,104 @@ int venus_helper_get_bufreq(struct venus_inst 
>> *inst, u32 type,
>>  }
>>  EXPORT_SYMBOL_GPL(venus_helper_get_bufreq);
>> 
>> +static u32 get_framesize_raw_nv12(u32 width, u32 height)
>> +{
>> +       u32 y_stride, uv_stride, y_plane;
>> +       u32 y_sclines, uv_sclines, uv_plane;
>> +       u32 size;
>> +
>> +       y_stride = ALIGN(width, 128);
>> +       uv_stride = ALIGN(width, 128);
>> +       y_sclines = ALIGN(height, 32);
>> +       uv_sclines = ALIGN(((height + 1) >> 1), 16);
>> +
>> +       y_plane = y_stride * y_sclines;
>> +       uv_plane = uv_stride * uv_sclines + SZ_4K;
>> +       size = y_plane + uv_plane + SZ_8K;
> 
> Do you know the reason for this extra 8K at the end?

As explained about the hardware requirement over bug [1], 8k is not 
needed.
I am working on a patch to fix the alignment requirement for ubwc format 
as
well.
In downstream driver, this 8k was added to accomodate the video 
extradata.

[1] https://partnerissuetracker.corp.google.com/u/1/issues/110448791
