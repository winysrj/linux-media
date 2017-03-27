Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:41707 "EHLO
        lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752459AbdC0IvV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 27 Mar 2017 04:51:21 -0400
Subject: Re: [PATCH v7 5/9] media: venus: vdec: add video decoder files
To: Nicolas Dufresne <nicolas@ndufresne.ca>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
References: <1489423058-12492-1-git-send-email-stanimir.varbanov@linaro.org>
 <1489423058-12492-6-git-send-email-stanimir.varbanov@linaro.org>
 <52b39f43-6f70-0cf6-abaf-4bb5bd2b3d86@xs4all.nl>
 <be41ccbd-3ff1-bcae-c423-1acc68f35694@mm-sol.com>
 <1490581130.25828.1.camel@ndufresne.ca>
Cc: Andy Gross <andy.gross@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <0c2e5cb8-249c-a9a2-12fb-68fafb4b9ad5@xs4all.nl>
Date: Mon, 27 Mar 2017 10:50:40 +0200
MIME-Version: 1.0
In-Reply-To: <1490581130.25828.1.camel@ndufresne.ca>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 27/03/17 04:18, Nicolas Dufresne wrote:
> Le dimanche 26 mars 2017 à 00:30 +0200, Stanimir Varbanov a écrit :
>>>> +            vb->planes[0].data_offset = data_offset;
>>>> +            vb->timestamp = timestamp_us * NSEC_PER_USEC;
>>>> +            vbuf->sequence = inst->sequence++;
>>>
>>> timestamp and sequence are only set for CAPTURE, not OUTPUT. Is
>>> that correct?
>>
>> Correct. I can add sequence for the OUTPUT queue too, but I have no idea 
>> how that sequence is used by userspace.
> 
> Neither GStreamer or Chromium seems to use it. What does that number
> means for a m2m driver ? Does it really means something ?

It can be used to detect dropped frame (the sequence counter will skip in that
case).

Unlikely to happen for m2m devices, and most apps ignore it as well. But you
still need to fill it in, it's a V4L2 requirement.

Regards,

	Hans
