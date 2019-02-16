Return-Path: <SRS0=NtRf=QX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95EFAC43381
	for <linux-media@archiver.kernel.org>; Sat, 16 Feb 2019 18:40:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 718672192D
	for <linux-media@archiver.kernel.org>; Sat, 16 Feb 2019 18:40:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731446AbfBPSkj (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 16 Feb 2019 13:40:39 -0500
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:59991 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726035AbfBPSkj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 16 Feb 2019 13:40:39 -0500
Received: from [192.168.2.10] ([212.251.195.8])
        by smtp-cloud8.xs4all.net with ESMTPA
        id v4t4gQam24HFnv4t7gvpT6; Sat, 16 Feb 2019 19:40:36 +0100
Subject: Re: v4l2 mem2mem compose support?
To:     Nicolas Dufresne <nicolas@ndufresne.ca>
Cc:     Tim Harvey <tharvey@gateworks.com>,
        linux-media <linux-media@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Carlos Rafael Giani <dv@pseudoterminal.org>,
        Discussion of the development of and with GStreamer 
        <gstreamer-devel@lists.freedesktop.org>
References: <CAJ+vNU2aA-RrQbHrVa7eV4nZjUsbA9z42Dm0iVeOuWbgO=PtfQ@mail.gmail.com>
 <1417dde5-ecd5-354e-2ed1-9be4d26ce104@xs4all.nl>
 <5cbdf827-cc3c-4b22-a7ed-31c44419b7b9@xs4all.nl>
 <CAKQmDh-9NG50r2WsJYief4QKpW_sVcWs3oK0RSz+9MGKbPamxQ@mail.gmail.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <70182eba-dd35-9ac3-b762-9a49ee017be9@xs4all.nl>
Date:   Sat, 16 Feb 2019 19:40:29 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <CAKQmDh-9NG50r2WsJYief4QKpW_sVcWs3oK0RSz+9MGKbPamxQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfN26P9JWJVHGQjGxoWymyXy48Q8U4G6yLYbAK97sMdBUgcCH6o+cx+oCkq47dm1pXrMj1Hos0tyqsc/Jo7jXh7CSEfy1PAEMO1qWnrvVGOWSt9VMcj4K
 6elJWnFruS7VeaLYVe8Thz6P0RsZ3rMLCLZgNscVLBNVpY1SLxirqqyaf0ozNFlTSfw3XS6QaYFEjvWbNCXjo0RniQdBU03G3a08UYLYR4QVMV/H9fIAuXC8
 nvnLQE1ZWlR+0KbAuVupsSLK2aBg9S14jS5SyPf5P+aKEwFssNz2ZNQEnOZni7LQg+f0hEbZG7MMc9cpaTr6yIBOtmymPhteMzrweOlTm0ZMSYC2D/OjQDsN
 lZfyBqPc1KwH5O+ruU+/cgFGi1ir/1i8qktHfmLIwTw4CoOf1B0+eoBTdskmD+Bjm8i31thVYh8enNs0JCqaP4ZrYlaLDA==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 2/16/19 4:42 PM, Nicolas Dufresne wrote:
> Le sam. 16 févr. 2019 à 04:48, Hans Verkuil <hverkuil@xs4all.nl> a écrit :
>>
>> On 2/16/19 10:42 AM, Hans Verkuil wrote:
>>> On 2/16/19 1:16 AM, Tim Harvey wrote:
>>>> Greetings,
>>>>
>>>> What is needed to be able to take advantage of hardware video
>>>> composing capabilities and make them available in something like
>>>> GStreamer?
>>>
>>> Are you talking about what is needed in a driver or what is needed in
>>> gstreamer? Or both?
>>>
>>> In any case, the driver needs to support the V4L2 selection API, specifically
>>> the compose target rectangle for the video capture.
>>
>> I forgot to mention that the driver should allow the compose rectangle to
>> be anywhere within the bounding rectangle as set by S_FMT(CAPTURE).
>>
>> In addition, this also means that the DMA has to be able to do scatter-gather,
>> which I believe is not the case for the imx m2m hardware.
> 
> I believe the 2D blitter can take an arbitrary source rectangle and
> compose it to an arbitrary destination rectangle (a lot of these will
> in fact use Q16 coordinate, allowing for subpixel rectangle, something
> that V4L2 does not support).

Not entirely true. I think this can be done through the selection API,
although it would require some updating of the spec and perhaps the
introduction of a field or flag. The original VIDIOC_CROPCAP and VIDIOC_CROP
ioctls actually could do this since with analog video (e.g. S-Video) you
did not really have the concept of a 'pixel'. It's an analog waveform after
all. In principle the selection API works in the same way, even though the
documentation always assumes that the selection rectangles map directly on
the digitized pixels. I'm not sure if there are still drivers that report
different crop bounds in CROPCAP compared to actual number of digitized pixels.
The bttv driver is most likely to do that, but I haven't checked.

Doing so made it very hard to understand, though.

 I don't think this driver exist in any
> form upstream on IMX side. The Rockchip dev tried to get one in
> recently, but the discussion didn't go so well with  the rejection of
> the proposed porter duff controls was probably devoting, as picking
> the right blending algorithm is the basic of such driver.

I tried to find the reason why the Porter Duff control was dropped in v8
of the rockchip RGA patch series back in 2017.

I can't find any discussion about it on the mailinglist, so perhaps it
was discussed on irc.

Do you remember why it was removed?

> 
> I believe a better approach for upstreaming such driver would be to
> write an M2M spec specific to that type of m2m drivers. That spec
> would cover scalers and rotators, since unlike the IPUv3 (which I
> believe you are referring too) a lot of the CSC and Scaler are
> blitters.

No, I was referring to the imx m2m driver that Phillip is working on.

> 
> Why we need a spec, this is because unlike most of our current driver,
> the buffers passed to CAPTURE aren't always empty buffers. This may
> have implementation that are ambiguous in current spec. The second is
> to avoid having to deal with legacy implementation, like we have with
> decoders.

Why would this be ambiguous? A driver that can do this can set the
COMPOSE rectangle for the CAPTURE queue basically anywhere within the
buffer and V4L2_SEL_TGT_COMPOSE_PADDED either does not exist or is
equal to the COMPOSE rectangle.

A driver that isn't able to do scatter-gather DMA will overwrite pixels,
and so COMPOSE_PADDED will be larger than the COMPOSE rectangle and
thus such a driver cannot be used for composing into a buffer that already
contains video data.

I might misunderstand you, though.

Regards,

	Hans

> 
>>
>> Regards,
>>
>>         Hans
>>
>>>
>>> Regards,
>>>
>>>       Hans
>>>
>>>>
>>>> Philipp's mem2mem driver [1] exposes the IMX IC and GStreamer's
>>>> v4l2convert element uses this nicely for hardware accelerated
>>>> scaling/csc/flip/rotate but what I'm looking for is something that
>>>> extends that concept and allows for composing frames from multiple
>>>> video capture devices into a single memory buffer which could then be
>>>> encoded as a single stream.
>>>>
>>>> This was made possible by Carlo's gstreamer-imx [2] GStreamer plugins
>>>> paired with the Freescale kernel that had some non-mainlined API's to
>>>> the IMX IPU and GPU. We have used this to take for example 8x analog
>>>> capture inputs, compose them into a single frame then H264 encode and
>>>> stream it. The gstreamer-imx elements used fairly compatible
>>>> properties as the GstCompositorPad element to provide a destination
>>>> rect within the compose output buffer as well as rotation/flip, alpha
>>>> blending and the ability to specify background fill.
>>>>
>>>> Is it possible that some of this capability might be available today
>>>> with the opengl GStreamer elements?
>>>>
>>>> Best Regards,
>>>>
>>>> Tim
>>>>
>>>> [1] https://patchwork.kernel.org/patch/10768463/
>>>> [2] https://github.com/Freescale/gstreamer-imx
>>>>
>>>
>>

