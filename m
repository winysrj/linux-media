Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:57156 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750999AbeECLqG (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 3 May 2018 07:46:06 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date: Thu, 03 May 2018 17:16:05 +0530
From: Vikash Garodia <vgarodia@codeaurora.org>
To: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-media-owner@vger.kernel.org
Subject: Re: [PATCH 26/28] venus: implementing multi-stream support
In-Reply-To: <64b9d816-617a-0ecd-fc47-8676a595f972@linaro.org>
References: <20180424124436.26955-1-stanimir.varbanov@linaro.org>
 <20180424124436.26955-27-stanimir.varbanov@linaro.org>
 <d3611ce941e71fd901cce70da89f9ab4@codeaurora.org>
 <64b9d816-617a-0ecd-fc47-8676a595f972@linaro.org>
Message-ID: <26dd5ee8a6659dc8f86637516d60d01c@codeaurora.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Stanimir,

On 2018-05-03 12:42, Stanimir Varbanov wrote:
> Hi Vikash,
> 
> Please write the comments for the chunk of code for which they are 
> refer to.
I see that the patch was about handling multistream mode, but the code 
to handle
the dpb buffer response is missing. My comment is basically to add the 
required
code.

> On  2.05.2018 10:40, Vikash Garodia wrote:
>> Hello Stanimir,
>> 
>> On 2018-04-24 18:14, Stanimir Varbanov wrote:
>>> This is implementing a multi-stream decoder support. The multi
>>> stream gives an option to use the secondary decoder output
>>> with different raw format (or the same in case of crop).
>>> 
>>> Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
>>> ---
>>>  drivers/media/platform/qcom/venus/core.h    |   1 +
>>>  drivers/media/platform/qcom/venus/helpers.c | 204 
>>> +++++++++++++++++++++++++++-
>>>  drivers/media/platform/qcom/venus/helpers.h |   6 +
>>>  drivers/media/platform/qcom/venus/vdec.c    |  91 ++++++++++++-
>>>  drivers/media/platform/qcom/venus/venc.c    |   1 +
>>>  5 files changed, 299 insertions(+), 4 deletions(-)
>>> 
>>> diff --git a/drivers/media/platform/qcom/venus/core.h
>>> b/drivers/media/platform/qcom/venus/core.h
>>> index 4d6c05f156c4..85e66e2dd672 100644
>>> --- a/drivers/media/platform/qcom/venus/core.h
>>> +++ b/drivers/media/platform/qcom/venus/core.h
>>> @@ -259,6 +259,7 @@ struct venus_inst {
>>>      struct list_head list;
>>>      struct mutex lock;
>>>      struct venus_core *core;
>>> +    struct list_head dpbbufs;
>>>      struct list_head internalbufs;
>>>      struct list_head registeredbufs;
>>>      struct list_head delayed_process;
> 
> <snip>
> 
>> 
>> The dpb buffers queued to hardware will be returned back to host 
>> either during flush
>> or when the session is stopped. Host should not send these buffers to 
>> client.
> 
> That's correct.
> 
>> vdec_buf_done should be handling in a way to drop dpb buffers from 
>> sending to client.
> 
> That is also correct, vdec_buf_done is trying to find the buffer by
> index from a list of queued buffers from v4l2 clients. See
> venus_helper_vb2_buf_queue where it is calling v4l2_m2m_buf_queue.
> 
> So for the dpb buffers venus_helper_find_buf() will return NULL.

My bad, i could see that the DPB buffers are not sent to client in the 
existing patch.

Instead of bailing out on NULL, i was thinking it is better to keep 
explicit check for dpb
buffers and exit with a debug log.

> 
> regards,
> Stan
