Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f68.google.com ([209.85.214.68]:53223 "EHLO
        mail-it0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728757AbeIQT6J (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Sep 2018 15:58:09 -0400
Received: by mail-it0-f68.google.com with SMTP id h3-v6so11383630ita.2
        for <linux-media@vger.kernel.org>; Mon, 17 Sep 2018 07:30:34 -0700 (PDT)
Subject: Re: [PATCH] venus: vdec: fix decoded data size
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Nicolas Dufresne <nicolas@ndufresne.ca>,
        Vikash Garodia <vgarodia@codeaurora.org>
Cc: linux-media@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, acourbot@chromium.org
References: <1530517447-29296-1-git-send-email-vgarodia@codeaurora.org>
 <01451f8e-aea3-b276-cb01-b0666a837d62@linaro.org>
 <4ce55726d810e308a2cae3f84bca7140bed48c7d.camel@ndufresne.ca>
 <92f6f79a-02ae-d23e-1b97-fc41fd921c89@linaro.org>
 <33e8d8e3-138e-0031-5b75-4bef114ac75e@xs4all.nl>
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Message-ID: <36b42952-982c-9048-77fb-72ca45cc7476@linaro.org>
Date: Mon, 17 Sep 2018 17:30:30 +0300
MIME-Version: 1.0
In-Reply-To: <33e8d8e3-138e-0031-5b75-4bef114ac75e@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On 09/17/2018 01:00 PM, Hans Verkuil wrote:
> On 07/18/2018 04:37 PM, Stanimir Varbanov wrote:
>> Hi,
>>
>> On 07/18/2018 04:26 PM, Nicolas Dufresne wrote:
>>> Le mercredi 18 juillet 2018 à 14:31 +0300, Stanimir Varbanov a écrit :
>>>> Hi Vikash,
>>>>
>>>> On 07/02/2018 10:44 AM, Vikash Garodia wrote:
>>>>> Exisiting code returns the max of the decoded
>>>>> size and buffer size. It turns out that buffer
>>>>> size is always greater due to hardware alignment
>>>>> requirement. As a result, payload size given to
>>>>> client is incorrect. This change ensures that
>>>>> the bytesused is assigned to actual payload size.
>>>>>
>>>>> Change-Id: Ie6f3429c0cb23f682544748d181fa4fa63ca2e28
>>>>> Signed-off-by: Vikash Garodia <vgarodia@codeaurora.org>
>>>>> ---
>>>>>  drivers/media/platform/qcom/venus/vdec.c | 2 +-
>>>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>>>
>>>>> diff --git a/drivers/media/platform/qcom/venus/vdec.c
>>>>> b/drivers/media/platform/qcom/venus/vdec.c
>>>>> index d079aeb..ada1d2f 100644
>>>>> --- a/drivers/media/platform/qcom/venus/vdec.c
>>>>> +++ b/drivers/media/platform/qcom/venus/vdec.c
>>>>> @@ -890,7 +890,7 @@ static void vdec_buf_done(struct venus_inst
>>>>> *inst, unsigned int buf_type,
>>>>>  
>>>>>  		vb = &vbuf->vb2_buf;
>>>>>  		vb->planes[0].bytesused =
>>>>> -			max_t(unsigned int, opb_sz, bytesused);
>>>>> +			min_t(unsigned int, opb_sz, bytesused);
>>>>
>>>> Most probably my intension was to avoid bytesused == 0, but that is
>>>> allowed from v4l2 driver -> userspace direction
>>>
>>> It remains bad practice since it was used by decoders to indicate the
>>> last buffer. Some userspace (some GStreamer versions) will stop working
>>> if you start returning 0.
>>
>> I think it is legal v4l2 driver to return bytesused = 0 when userspace
>> issues streamoff on both queues before EOS, no? Simply because the
>> capture buffers are empty.
>>
> 
> Going through some of the older pending patches I found this one:
> 
> So is this patch right or wrong?

I'm not sure either, let's not applying it for now (if Nicolas is right
this will break gstreamer plugin).

-- 
regards,
Stan
