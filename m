Return-Path: <SRS0=1NWX=OQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7857C07E85
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 09:33:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A413020838
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 09:33:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="flVRg0VT"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A413020838
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726088AbeLGJdP (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 7 Dec 2018 04:33:15 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:39656 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725989AbeLGJdO (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 7 Dec 2018 04:33:14 -0500
Received: by mail-wm1-f67.google.com with SMTP id f81so3780560wmd.4
        for <linux-media@vger.kernel.org>; Fri, 07 Dec 2018 01:33:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=eMnf6ldCLzSIFExqElBpBbrF0a80ehzcW+zL1qWkQFI=;
        b=flVRg0VT8rf773axgJskOt6mEUkNuIav3OWtUev+VR6+9kCUHhD3g3pj0/HTPpnT3z
         bBhTTWDmGD5vM9g2SvRc1ZoQfTrTf92V4niKulYBCp7xqRVQ2IH3L2zlAcpCB/Y8j/V3
         AiIv7yEWETnT1S3aSofPvO3rg11PapadoELmQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=eMnf6ldCLzSIFExqElBpBbrF0a80ehzcW+zL1qWkQFI=;
        b=cLT32PfEYOal1JosT7pOZLnBnGvH8DshGqRifqdpUJdYPAah2hshn6hn0b7k2cvTC9
         QnXfeqwYlguoeXmgYQvKzMUT1J2DeZmM/l0rtTgfiW5n4CUmSXqAlS3vuRGV6PybcdFL
         ZIt2Kzt14s6PWfnhUBIXHPyKSwDDtRGJQJLYHtKvpHXuqyr3u2ltfm7ypfByUHC+laig
         4wsx4NdIlaxsDA93VA4HMgsXxOyul3nC7jotm28q/R3jPe5yszp1iIheZOAhxZ+notj3
         bUxC72JkoxlV0bgPTiDzzWFZ7hXIq642gw/QKChyMRLhnhVNWDVYQZhxfhVHJJkVU747
         nyqQ==
X-Gm-Message-State: AA+aEWZv+bsJ8vCtUl3G12w+J/3i0I2JpdZQGlUsB6cXE75ld3yScZAw
        ybtAjw7lUg2Up5J5+7RtdAmiIA==
X-Google-Smtp-Source: AFSGD/V8LYViCHAWSFzE+x9aAPgqaVHDnxTvmIm+FgCPVAuapeKQs8FRRTpoXcQsMPx9wkPNtG8gNQ==
X-Received: by 2002:a1c:b94b:: with SMTP id j72mr1534084wmf.11.1544175192459;
        Fri, 07 Dec 2018 01:33:12 -0800 (PST)
Received: from [192.168.27.209] ([37.157.136.206])
        by smtp.googlemail.com with ESMTPSA id z12sm3528581wrh.35.2018.12.07.01.33.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 07 Dec 2018 01:33:11 -0800 (PST)
Subject: Re: [PATCH v3] media: venus: add support for key frame
To:     Tomasz Figa <tfiga@chromium.org>, mgottam@codeaurora.org
Cc:     Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        vgarodia@codeaurora.org
References: <1541163476-23249-1-git-send-email-mgottam@codeaurora.org>
 <CAAFQd5D=hNdkEovonE6GOaYvq9dBbQwSZ=95V9a80e-sLp7cYg@mail.gmail.com>
 <4767b56f-420b-dc0c-0ae9-44dbf6dcd0b1@linaro.org>
 <6d765e0d7d6b873e087a3db823cb1b29@codeaurora.org>
 <CAAFQd5Ask-mw+uEE0OAEabjaAAYcJyCeexaofOAg1bp2NtvpKA@mail.gmail.com>
From:   Stanimir Varbanov <stanimir.varbanov@linaro.org>
Message-ID: <0e0cef43-0747-295f-0eef-3e52dc538523@linaro.org>
Date:   Fri, 7 Dec 2018 11:33:03 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <CAAFQd5Ask-mw+uEE0OAEabjaAAYcJyCeexaofOAg1bp2NtvpKA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Hans,

On 11/29/18 9:40 PM, Tomasz Figa wrote:
> On Thu, Nov 29, 2018 at 3:10 AM <mgottam@codeaurora.org> wrote:
>>
>>
>> Hi Stan,
>>
>> On 2018-11-29 16:01, Stanimir Varbanov wrote:
>>> Hi Tomasz,
>>>
>>> On 11/3/18 5:01 AM, Tomasz Figa wrote:
>>>> Hi Malathi,
>>>>
>>>> On Fri, Nov 2, 2018 at 9:58 PM Malathi Gottam <mgottam@codeaurora.org>
>>>> wrote:
>>>>>
>>>>> When client requests for a keyframe, set the property
>>>>> to hardware to generate the sync frame.
>>>>>
>>>>> Signed-off-by: Malathi Gottam <mgottam@codeaurora.org>
>>>>> ---
>>>>>  drivers/media/platform/qcom/venus/venc_ctrls.c | 20
>>>>> +++++++++++++++++++-
>>>>>  1 file changed, 19 insertions(+), 1 deletion(-)
>>>>>
>>>>> diff --git a/drivers/media/platform/qcom/venus/venc_ctrls.c
>>>>> b/drivers/media/platform/qcom/venus/venc_ctrls.c
>>>>> index 45910172..59fe7fc 100644
>>>>> --- a/drivers/media/platform/qcom/venus/venc_ctrls.c
>>>>> +++ b/drivers/media/platform/qcom/venus/venc_ctrls.c
>>>>> @@ -79,8 +79,10 @@ static int venc_op_s_ctrl(struct v4l2_ctrl *ctrl)
>>>>>  {
>>>>>         struct venus_inst *inst = ctrl_to_inst(ctrl);
>>>>>         struct venc_controls *ctr = &inst->controls.enc;
>>>>> +       struct hfi_enable en = { .enable = 1 };
>>>>>         u32 bframes;
>>>>>         int ret;
>>>>> +       u32 ptype;
>>>>>
>>>>>         switch (ctrl->id) {
>>>>>         case V4L2_CID_MPEG_VIDEO_BITRATE_MODE:
>>>>> @@ -173,6 +175,19 @@ static int venc_op_s_ctrl(struct v4l2_ctrl
>>>>> *ctrl)
>>>>>
>>>>>                 ctr->num_b_frames = bframes;
>>>>>                 break;
>>>>> +       case V4L2_CID_MPEG_VIDEO_FORCE_KEY_FRAME:
>>>>> +               mutex_lock(&inst->lock);
>>>>> +               if (inst->streamon_out && inst->streamon_cap) {
>>>>
>>>> We had a discussion on this in v2. I don't remember seeing any
>>>> conclusion.
>>>>
>>>> Obviously the hardware should generate a keyframe naturally when the
>>>> CAPTURE streaming starts, which is where the encoding starts, but the
>>>> state of the OUTPUT queue should not affect this.
>>>>
>>>> The application is free to stop and start streaming on the OUTPUT
>>>> queue as it goes and it shouldn't imply any side effects in the
>>>> encoded bitstream (e.g. a keyframe inserted). So:
>>>> - a sequence of STREAMOFF(OUTPUT),
>>>> S_CTRL(V4L2_CID_MPEG_VIDEO_FORCE_KEY_FRAME), STREAMON(OUTPUT) should
>>>> explicitly generate a keyframe,
>>>
>>> I agree with you, but presently we don't follow strictly the stateful
>>> encoder spec. In this spirit I think proposed patch is applicable to
>>> the
>>> current state of the encoder driver, and your comment should be
>>> addressed in the follow-up patches where we have to re-factor a bit
>>> start/stop_streaming according to the encoder documentation.
>>>
>>> But until then we have to get that patch.
>>
>> So I can see that this patch is good implementation of forcing sync
>> frame
>> under current encoder state.
>>
>> Can you please ack the same.
> 
> Okay, assuming that when you start streaming you naturally get a
> keyframe, I'm okay with this patch, since it actually fixes the
> missing key frame request, so from the general encoder interface point
> of view:
> 
> Acked-by: Tomasz Figa <tfiga@chromium.org>

Thanks Tomasz!

Acked-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>

-- 
regards,
Stan
