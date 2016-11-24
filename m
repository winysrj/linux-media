Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:38613 "EHLO
        mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S938700AbcKXNQx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 Nov 2016 08:16:53 -0500
Received: by mail-wm0-f52.google.com with SMTP id f82so60995375wmf.1
        for <linux-media@vger.kernel.org>; Thu, 24 Nov 2016 05:16:21 -0800 (PST)
Subject: Re: [PATCH v3 4/9] media: venus: vdec: add video decoder files
To: nicolas@ndufresne.ca,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
References: <1478540043-24558-1-git-send-email-stanimir.varbanov@linaro.org>
 <1478540043-24558-5-git-send-email-stanimir.varbanov@linaro.org>
 <63a91a5a-a97b-f3df-d16d-c8f76bf20c30@xs4all.nl>
 <4ec31084-1720-845a-30f6-60ddfe285ff1@linaro.org>
 <86442d1d-4a12-71c1-97fa-12bc73bb5045@linaro.org>
 <9ff4f3cf-f6d1-cebe-6f1a-e4209c55e4f4@xs4all.nl>
 <15975057-dd6a-6946-07ac-93a748b6a176@linaro.org>
 <aed4a795-3abe-2d5a-abc4-c638cd4f4d61@xs4all.nl>
 <113772f1-8eb9-dd44-42c6-4f109200dff7@linaro.org>
 <1479932682.29275.1.camel@ndufresne.ca>
Cc: Andy Gross <andy.gross@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Message-ID: <6d0d477f-22c7-5315-6eae-027a2525345c@linaro.org>
Date: Thu, 24 Nov 2016 15:16:16 +0200
MIME-Version: 1.0
In-Reply-To: <1479932682.29275.1.camel@ndufresne.ca>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Nicolas,

On 11/23/2016 10:24 PM, Nicolas Dufresne wrote:
> Le lundi 21 novembre 2016 à 18:09 +0200, Stanimir Varbanov a écrit :
>>>> Meanwhile I have found bigger obstacle - I cannot run multiple
>> instances
>>>> simultaneously. By m2m design it can execute only one job (m2m
>> context)
>>>> at a time per m2m device. Can you confirm that my observation is
>> correct?
>>>  
>>> The m2m framework assumes a single HW instance, yes. Do you have
>> multiple
>>> HW decoders? I might not understand what you mean...
>>>  
>>
>> I mean that I can start and execute up to 16 decoder sessions
>> simultaneously. Its a firmware responsibility how those sessions are
>> scheduled and how the hardware is shared between them. Of course
>> depending on the resolution the firmware can refuse to start the
>> session
>> because the hardware will be overloaded and will not be able to
>> satisfy
>> the bitrate requirements.
> 
> This is similar to S5P-MFC driver, which you may have notice not use
> m2m framework.

Thanks for the note.

I have started to look into m2m because Hans asked me to reuse the ioctl
helpers that it provides.

I have no problem with usage of the m2m API if they help me to reduce
code size and doesn't impact performance.


-- 
regards,
Stan
