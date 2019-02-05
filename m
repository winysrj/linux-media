Return-Path: <SRS0=c0D3=QM=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D998C282D7
	for <linux-media@archiver.kernel.org>; Tue,  5 Feb 2019 09:00:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3A2232083B
	for <linux-media@archiver.kernel.org>; Tue,  5 Feb 2019 09:00:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728399AbfBEJAb (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 5 Feb 2019 04:00:31 -0500
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:33981 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725952AbfBEJAb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 5 Feb 2019 04:00:31 -0500
Received: from [IPv6:2001:983:e9a7:1:2989:f759:211b:c8a5] ([IPv6:2001:983:e9a7:1:2989:f759:211b:c8a5])
        by smtp-cloud7.xs4all.net with ESMTPA
        id qwaggb6AJBDyIqwaigB6XP; Tue, 05 Feb 2019 10:00:29 +0100
Subject: Re: [PATCH 10/10] venus: dec: make decoder compliant with stateful
 codec API
To:     Tomasz Figa <tfiga@chromium.org>,
        Nicolas Dufresne <nicolas@ndufresne.ca>
Cc:     Philipp Zabel <p.zabel@pengutronix.de>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        Vikash Garodia <vgarodia@codeaurora.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Malathi Gottam <mgottam@codeaurora.org>
References: <20190117162008.25217-1-stanimir.varbanov@linaro.org>
 <20190117162008.25217-11-stanimir.varbanov@linaro.org>
 <CAAFQd5Cm1zyPzJnixwNmWzxn2zh=63YrA+ZzH-arW-VZ_x-Awg@mail.gmail.com>
 <28069a44-b188-6b89-2687-542fa762c00e@linaro.org>
 <CAAFQd5BevOV2r1tqmGPnVtdwirGMWU=ZJU85HjfnH-qMyQiyEg@mail.gmail.com>
 <affce842d4f015e13912b2c3941c9bf02e84d194.camel@ndufresne.ca>
 <CAAFQd5Ahg4Di+SBd+-kKo4PLVyvqLwcuG6MphU5Rz1PFXVuamQ@mail.gmail.com>
 <e8a90694c306fde24928a569b7bcb231b86ec73b.camel@ndufresne.ca>
 <CAAFQd5DFfQRd1VoN7itVXnWGKW_WBKU-sm6vo5CdgjkzjEEkFg@mail.gmail.com>
 <57419418d377f32d0e6978f4e4171c0da7357cbb.camel@ndufresne.ca>
 <1548938556.4585.1.camel@pengutronix.de>
 <CAAFQd5Aih7cWu-cfwBvNdwhHHYEaMF0SFebrYfdNXD9qKu8fxw@mail.gmail.com>
 <1f8485785a21c0b0e071a3a766ed2cbc727e47f6.camel@ndufresne.ca>
 <CAAFQd5CPKm1ES8c9Lab63Lr8ZfWRckHmJ99SVRYi6Hpe7hzy+g@mail.gmail.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <f1e9dc99-4fcb-dee1-4279-ac0cf1d1fd6e@xs4all.nl>
Date:   Tue, 5 Feb 2019 10:00:26 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <CAAFQd5CPKm1ES8c9Lab63Lr8ZfWRckHmJ99SVRYi6Hpe7hzy+g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfNCn6NsNJjgMzHrAN5ujof5bBPSlSV0od8QQtNlDP2vh75KA1dpdOhkFnqUC8rp/D/3XBHUxeRMZwarYlOsoX9Ib5EpIA/03hvkTPtOQFEBWH3+vWlEU
 qcBIqJNuwfxivVfdI0fApYhjCHX2hZB8f/k0cWgzrZARpsm35lFwjIr1E2AhOLBrGrTuT1N4DV3ap/0+MJRS2ywhW2sLxx07/btCkYbgwu6iB9FTzTCt8V6I
 3TWqxrHE4ZikD7QpCPvHdXMSvSQaLRs8LjvLUcckRY/XgR483PZWXyxaY1UR6BecIDNrV9MHuxnhwPZw3bKuIbUCquUHU4fUGa6RcqzmPAOTUybHxz+/JFfq
 T1eCvfJwgAfrAiu8A1DQ4Lc8mGjjP9d27okBJlEf15068zAmDyOl9uz0aVDuk9SHKXePsiBN7cKEknRypyh5LmjeD0o0A3WLHQfsQJRt5tcd+za5BasnsCPO
 MfcTx24CNn7j3lp7dxCJxJjndi34q8wPw4xBMI9rz86cVuA5aZEBaYGua2HyRrfN0L85g04zmaCjvbwSSicisDTZ1TcUl1kwEoKX/x8IQQzWI8o/0fd4y7FH
 x3dXk5em9dqEJzKdu/XjMLIqtP3/M5DsBIxNgbieLAaCOQ==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 2/5/19 7:26 AM, Tomasz Figa wrote:
> On Fri, Feb 1, 2019 at 12:18 AM Nicolas Dufresne <nicolas@ndufresne.ca> wrote:
>>
>> Le jeudi 31 janvier 2019 à 22:34 +0900, Tomasz Figa a écrit :
>>> On Thu, Jan 31, 2019 at 9:42 PM Philipp Zabel <p.zabel@pengutronix.de> wrote:
>>>> Hi Nicolas,
>>>>
>>>> On Wed, 2019-01-30 at 10:32 -0500, Nicolas Dufresne wrote:
>>>>> Le mercredi 30 janvier 2019 à 15:17 +0900, Tomasz Figa a écrit :
>>>>>>> I don't remember saying that, maybe I meant to say there might be a
>>>>>>> workaround ?
>>>>>>>
>>>>>>> For the fact, here we queue the headers (or first frame):
>>>>>>>
>>>>>>> https://gitlab.freedesktop.org/gstreamer/gst-plugins-good/blob/master/sys/v4l2/gstv4l2videodec.c#L624
>>>>>>>
>>>>>>> Then few line below this helper does G_FMT internally:
>>>>>>>
>>>>>>> https://gitlab.freedesktop.org/gstreamer/gst-plugins-good/blob/master/sys/v4l2/gstv4l2videodec.c#L634
>>>>>>> https://gitlab.freedesktop.org/gstreamer/gst-plugins-good/blob/master/sys/v4l2/gstv4l2object.c#L3907
>>>>>>>
>>>>>>> And just plainly fails if G_FMT returns an error of any type. This was
>>>>>>> how Kamil designed it initially for MFC driver. There was no other
>>>>>>> alternative back then (no EAGAIN yet either).
>>>>>>
>>>>>> Hmm, was that ffmpeg then?
>>>>>>
>>>>>> So would it just set the OUTPUT width and height to 0? Does it mean
>>>>>> that gstreamer doesn't work with coda and mtk-vcodec, which don't have
>>>>>> such wait in their g_fmt implementations?
>>>>>
>>>>> I don't know for MTK, I don't have the hardware and didn't integrate
>>>>> their vendor pixel format. For the CODA, I know it works, if there is
>>>>> no wait in the G_FMT, then I suppose we are being really lucky with the
>>>>> timing (it would be that the drivers process the SPS/PPS synchronously,
>>>>> and a simple lock in the G_FMT call is enough to wait). Adding Philipp
>>>>> in CC, he could explain how this works, I know they use GStreamer in
>>>>> production, and he would have fixed GStreamer already if that was
>>>>> causing important issue.
>>>>
>>>> CODA predates the width/height=0 rule on the coded/OUTPUT queue.
>>>> It currently behaves more like a traditional mem2mem device.
>>>
>>> The rule in the latest spec is that if width/height is 0 then CAPTURE
>>> format is determined only after the stream is parsed. Otherwise it's
>>> instantly deduced from the OUTPUT resolution.
>>>
>>>> When width/height is set via S_FMT(OUT) or output crop selection, the
>>>> driver will believe it and set the same (rounded up to macroblock
>>>> alignment) on the capture queue without ever having seen the SPS.
>>>
>>> That's why I asked whether gstreamer sets width and height of OUTPUT
>>> to non-zero values. If so, there is no regression, as the specs mimic
>>> the coda behavior.
>>
>> I see, with Philipp's answer it explains why it works. Note that
>> GStreamer sets the display size on the OUTPUT format (in fact we pass
>> as much information as we have, because a) it's generic code and b) it
>> will be needed someday when we enable pre-allocation (REQBUFS before
>> SPS/PPS is passed, to avoid the setup delay introduce by allocation,
>> mostly seen with CMA base decoder). In any case, the driver reported
>> display size should always be ignored in GStreamer, the only
>> information we look at is the G_SELECTION for the case the x/y or the
>> cropping rectangle is non-zero.
>>
>> Note this can only work if the capture queue is not affected by the
>> coded size, or if the round-up made by the driver is bigger or equal to
>> that coded size. I believe CODA falls into the first category, since
>> the decoding happens in a separate set of buffers and are then de-tiled
>> into the capture buffers (if understood correctly).
> 
> Sounds like it would work only if coded size is equal to the visible
> size (that GStreamer sets) rounded up to full macroblocks. Non-zero x
> or y in the crop could be problematic too.
> 
> Hans, what's your view on this? Should we require G_FMT(CAPTURE) to
> wait until a format becomes available or the OUTPUT queue runs out of

You mean CAPTURE queue? If not, then I don't understand that part.

> buffers?

First see my comment here regarding G_FMT returning an error:

https://www.spinics.net/lists/linux-media/msg146505.html

In my view that is a bad idea.

What G_FMT should return between the time a resolution change was
detected and the CAPTURE queue being drained (i.e. the old or the new
resolution?) is something I am not sure about.

On the one hand it is desirable to have the new resolution asap, on
the other hand, returning the new resolution would mean that the
returned format is inconsistent with the capture buffer sizes.

I'm leaning towards either returning the new resolution.

Regards,

	Hans

> 
>>
>> I would say, best is just to test the updated Venus driver, which is in
>> my queue.
> 
> The updated Venus driver doesn't implement the behavior I referred to,
> but rather the legacy wait in G_FMT(CAPTURE) as in s5p-mfc.
> 

