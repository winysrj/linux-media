Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr1-f68.google.com ([209.85.221.68]:40057 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728781AbeIYPsg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 25 Sep 2018 11:48:36 -0400
Received: by mail-wr1-f68.google.com with SMTP id y8-v6so18964298wrh.7
        for <linux-media@vger.kernel.org>; Tue, 25 Sep 2018 02:41:53 -0700 (PDT)
Subject: Re: [PATCH] venus: vdec: fix decoded data size
To: Nicolas Dufresne <nicolas@ndufresne.ca>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: vgarodia@codeaurora.org,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
References: <1530517447-29296-1-git-send-email-vgarodia@codeaurora.org>
 <01451f8e-aea3-b276-cb01-b0666a837d62@linaro.org>
 <4ce55726d810e308a2cae3f84bca7140bed48c7d.camel@ndufresne.ca>
 <92f6f79a-02ae-d23e-1b97-fc41fd921c89@linaro.org>
 <33e8d8e3-138e-0031-5b75-4bef114ac75e@xs4all.nl>
 <36b42952-982c-9048-77fb-72ca45cc7476@linaro.org>
 <051af6fb-e0e8-4008-99c5-9685ac24e454@xs4all.nl>
 <CAPBb6MVupMsdhF6Rtk4fm8JeVurrK+ZsuxAQ-BwrTzdSP1xP0Q@mail.gmail.com>
 <6d65ac0d-80a0-88fe-ed19-4785f2675e36@linaro.org>
 <bec2edfda26ecbac928871ad14d768790e3175a8.camel@ndufresne.ca>
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Message-ID: <72bce7dc-ceef-cc81-1edb-8034495684ae@linaro.org>
Date: Tue, 25 Sep 2018 12:41:50 +0300
MIME-Version: 1.0
In-Reply-To: <bec2edfda26ecbac928871ad14d768790e3175a8.camel@ndufresne.ca>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Nicolas,

On 09/19/2018 06:53 PM, Nicolas Dufresne wrote:
> Le mercredi 19 septembre 2018 à 18:02 +0300, Stanimir Varbanov a
> écrit :
>>> --- a/drivers/media/platform/qcom/venus/vdec.c
>>> +++ b/drivers/media/platform/qcom/venus/vdec.c
>>> @@ -943,8 +943,7 @@ static void vdec_buf_done(struct venus_inst
>>> *inst,
>>> unsigned int buf_type,
>>>                 unsigned int opb_sz =
>>> venus_helper_get_opb_size(inst);
>>>
>>>                 vb = &vbuf->vb2_buf;
>>> -               vb->planes[0].bytesused =
>>> -                       max_t(unsigned int, opb_sz, bytesused);
>>> +                vb2_set_plane_payload(vb, 0, bytesused ? :
>>> opb_sz);
>>>                 vb->planes[0].data_offset = data_offset;
>>>                 vb->timestamp = timestamp_us * NSEC_PER_USEC;
>>>                 vbuf->sequence = inst->sequence_cap++;
>>>
>>> It works fine for me, and should not return 0 more often than it
>>> did
>>> before (i.e. never). In practice I also never see the firmware
>>> reporting a payload of zero on SDM845, but maybe older chips
>>> differ?
>>
>> yes, it looks fine. Let me test it with older versions.
> 
> What about removing the allow_zero_bytesused flag on this specific
> queue ? Then you can leave it to 0, and the framework will change it to
> the buffer size.

This is valid only for OUTPUT type buffers, but here we bother for
CAPTURE buffers.

-- 
regards,
Stan
