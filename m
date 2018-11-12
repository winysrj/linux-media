Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm1-f68.google.com ([209.85.128.68]:55860 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729106AbeKLWN5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Nov 2018 17:13:57 -0500
Received: by mail-wm1-f68.google.com with SMTP id i73-v6so2962432wmd.5
        for <linux-media@vger.kernel.org>; Mon, 12 Nov 2018 04:20:53 -0800 (PST)
Subject: Re: [PATCH v1 5/5] media: venus: update number of bytes used field
 properly for EOS frames
To: Alexandre Courbot <acourbot@chromium.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>
Cc: sgorle@codeaurora.org, Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org, vgarodia@codeaurora.org
References: <1538222432-25894-1-git-send-email-sgorle@codeaurora.org>
 <1538222432-25894-6-git-send-email-sgorle@codeaurora.org>
 <a331a717-199d-6d6c-c88d-54f911b942d4@linaro.org>
 <CAPBb6MVio_kYK-P+eASFMzdxbvBMWwQC7-ZjPxP3aaqpMsnEdA@mail.gmail.com>
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Message-ID: <3097b9b9-e065-e42f-5b19-849313df38c2@linaro.org>
Date: Mon, 12 Nov 2018 14:20:50 +0200
MIME-Version: 1.0
In-Reply-To: <CAPBb6MVio_kYK-P+eASFMzdxbvBMWwQC7-ZjPxP3aaqpMsnEdA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Alex,

On 11/12/18 10:12 AM, Alexandre Courbot wrote:
> Hi Stan,
> 
> On Thu, Nov 8, 2018 at 7:16 PM Stanimir Varbanov
> <stanimir.varbanov@linaro.org> wrote:
>>
>> Hi,
>>
>> On 9/29/18 3:00 PM, Srinu Gorle wrote:
>>> - In video decoder session, update number of bytes used for
>>>   yuv buffers appropriately for EOS buffers.
>>>
>>> Signed-off-by: Srinu Gorle <sgorle@codeaurora.org>
>>> ---
>>>  drivers/media/platform/qcom/venus/vdec.c | 2 +-
>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> NACK, that was already discussed see:
>>
>> https://patchwork.kernel.org/patch/10630411/
> 
> I believe you are referring to this discussion?
> 
> https://lkml.org/lkml/2018/10/2/302
> 
> In this case, with https://patchwork.kernel.org/patch/10630411/
> applied, I am seeing the troublesome case of having the last (empty)
> buffer being returned with a payload of obs_sz, which I believe is
> incorrect. The present patch seems to restore the correct behavior.

Sorry, I thought that this solution was suggested (and tested on Venus
v4) by you, right?

> 
> An alternative would be to set the payload as follows:
> 
> vb2_set_plane_payload(vb, 0, bytesused);
> 
> This works for SDM845, but IIRC we weren't sure that this would
> display the correct behavior with all firmware versions?

OK if you are still seeing issues I think we can switch to
vb2_set_plane_payload(vb, 0, bytesused); for all buffers? I.e. not only
for buffers with flag V4L2_BUF_FLAG_LAST set.

> 
>>
>>>
>>> diff --git a/drivers/media/platform/qcom/venus/vdec.c b/drivers/media/platform/qcom/venus/vdec.c
>>> index 311f209..a48eed1 100644
>>> --- a/drivers/media/platform/qcom/venus/vdec.c
>>> +++ b/drivers/media/platform/qcom/venus/vdec.c
>>> @@ -978,7 +978,7 @@ static void vdec_buf_done(struct venus_inst *inst, unsigned int buf_type,
>>>
>>>               if (vbuf->flags & V4L2_BUF_FLAG_LAST) {
>>>                       const struct v4l2_event ev = { .type = V4L2_EVENT_EOS };
>>> -
>>> +                     vb->planes[0].bytesused = bytesused;

Is 'bytesused' != 0 in case of EoS ever?

i.e. shouldn't this be vb->planes[0].bytesused = 0 ?

>>>                       v4l2_event_queue_fh(&inst->fh, &ev);
>>>               }
>>>       } else {
>>>
>>
>> --
>> regards,
>> Stan

-- 
regards,
Stan
