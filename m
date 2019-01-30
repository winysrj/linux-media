Return-Path: <SRS0=BdY7=QG=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABE19C282D4
	for <linux-media@archiver.kernel.org>; Wed, 30 Jan 2019 06:28:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7BFCE20863
	for <linux-media@archiver.kernel.org>; Wed, 30 Jan 2019 06:28:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725873AbfA3G2E convert rfc822-to-8bit (ORCPT
        <rfc822;linux-media@archiver.kernel.org>);
        Wed, 30 Jan 2019 01:28:04 -0500
Received: from kozue.soulik.info ([108.61.200.231]:35848 "EHLO
        kozue.soulik.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725791AbfA3G2D (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 30 Jan 2019 01:28:03 -0500
Received: from [192.168.10.231] (unknown [103.29.142.67])
        by kozue.soulik.info (Postfix) with ESMTPSA id 41C5810106E;
        Wed, 30 Jan 2019 15:29:09 +0900 (JST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (1.0)
Subject: Re: [linux-sunxi] [PATCH v2 1/2] media: v4l: Add definitions for the HEVC slice format and controls
From:   Ayaka <ayaka@soulik.info>
X-Mailer: iPad Mail (16A404)
In-Reply-To: <CAAFQd5BJ6_eQ2QiQLdmkkkeWEiVQ_yo86QccOn9176ZRDQxc=Q@mail.gmail.com>
Date:   Wed, 30 Jan 2019 14:27:54 +0800
Cc:     Alexandre Courbot <acourbot@chromium.org>,
        Nicolas Dufresne <nicolas@ndufresne.ca>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Randy Li <randy.li@rock-chips.com>,
        =?utf-8?Q?Jernej_=C5=A0krabec?= <jernej.skrabec@gmail.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, devel@driverdev.osuosl.org,
        "list@263.net:IOMMU DRIVERS <iommu@lists.linux-foundation.org>, Joerg
        Roedel <joro@8bytes.org>," <linux-arm-kernel@lists.infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <5F14507E-1BE2-4A74-A59C-1DB3C3E07DBA@soulik.info>
References: <20181123130209.11696-1-paul.kocialkowski@bootlin.com> <20181123130209.11696-2-paul.kocialkowski@bootlin.com> <5515174.7lFZcYkk85@jernej-laptop> <ffe9c81db34b599f675ca5bbf02de360bf0a1608.camel@bootlin.com> <776e63c9-d4a5-342a-e0f7-200ef144ffc4@rock-chips.com> <64c793e08d61181b78125b3956ec38623fa5d261.camel@bootlin.com> <D8005130-F7FD-4CBD-8396-1BB08BB08E81@soulik.info> <f982ef378a8ade075bc7077b93640e20ecebf9f4.camel@bootlin.com> <82FA0C3F-BC54-4D89-AECB-90D81B89B1CE@soulik.info> <c3619a00-17e7-fb92-a427-a7478b96f356@soulik.info> <bdf14f97e98f2fd06307545ab9038ac3c2086ae7.camel@bootlin.com> <42520087-4EAE-4F7F-BCA0-42E422170E91@soulik.info> <ab8ca098ad60f209fe97f79bb93b2d1e898da524.camel@bootlin.com> <CAPBb6MUJu3cX9A-E32bSSjxc1cvGP83ayzZzUxa5_QMf6niK4g@mail.gmail.com> <2442b23d3b0a00c1bd441298a712888e016acf92.camel@ndufresne.ca> <CAPBb6MUsbdXvkomtkiq0ygTqj58h4yqVR0PotT=ft94Ai0nbhw@mail.gmail.com> <CAAFQd5BJ6_eQ2QiQLdmkkkeWEiVQ_yo86QccOn9176ZRDQxc=Q@mail.gmail.com>
To:     Tomasz Figa <tfiga@chromium.org>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org



Sent from my iPad

> On Jan 30, 2019, at 11:35 AM, Tomasz Figa <tfiga@chromium.org> wrote:
> 
> On Wed, Jan 30, 2019 at 11:29 AM Alexandre Courbot
> <acourbot@chromium.org> wrote:
>> 
>>> On Wed, Jan 30, 2019 at 6:41 AM Nicolas Dufresne <nicolas@ndufresne.ca> wrote:
>>> 
>>>> Le mardi 29 janvier 2019 à 16:44 +0900, Alexandre Courbot a écrit :
>>>> On Fri, Jan 25, 2019 at 10:04 PM Paul Kocialkowski
>>>> <paul.kocialkowski@bootlin.com> wrote:
>>>>> Hi,
>>>>> 
>>>>>> On Thu, 2019-01-24 at 20:23 +0800, Ayaka wrote:
>>>>>> Sent from my iPad
>>>>>> 
>>>>>>> On Jan 24, 2019, at 6:27 PM, Paul Kocialkowski <paul.kocialkowski@bootlin.com> wrote:
>>>>>>> 
>>>>>>> Hi,
>>>>>>> 
>>>>>>>> On Thu, 2019-01-10 at 21:32 +0800, ayaka wrote:
>>>>>>>> I forget a important thing, for the rkvdec and rk hevc decoder, it would
>>>>>>>> requests cabac table, scaling list, picture parameter set and reference
>>>>>>>> picture storing in one or various of DMA buffers. I am not talking about
>>>>>>>> the data been parsed, the decoder would requests a raw data.
>>>>>>>> 
>>>>>>>> For the pps and rps, it is possible to reuse the slice header, just let
>>>>>>>> the decoder know the offset from the bitstream bufer, I would suggest to
>>>>>>>> add three properties(with sps) for them. But I think we need a method to
>>>>>>>> mark a OUTPUT side buffer for those aux data.
>>>>>>> 
>>>>>>> I'm quite confused about the hardware implementation then. From what
>>>>>>> you're saying, it seems that it takes the raw bitstream elements rather
>>>>>>> than parsed elements. Is it really a stateless implementation?
>>>>>>> 
>>>>>>> The stateless implementation was designed with the idea that only the
>>>>>>> raw slice data should be passed in bitstream form to the decoder. For
>>>>>>> H.264, it seems that some decoders also need the slice header in raw
>>>>>>> bitstream form (because they take the full slice NAL unit), see the
>>>>>>> discussions in this thread:
>>>>>>> media: docs-rst: Document m2m stateless video decoder interface
>>>>>> 
>>>>>> Stateless just mean it won’t track the previous result, but I don’t
>>>>>> think you can define what a date the hardware would need. Even you
>>>>>> just build a dpb for the decoder, it is still stateless, but parsing
>>>>>> less or more data from the bitstream doesn’t stop a decoder become a
>>>>>> stateless decoder.
>>>>> 
>>>>> Yes fair enough, the format in which the hardware decoder takes the
>>>>> bitstream parameters does not make it stateless or stateful per-se.
>>>>> It's just that stateless decoders should have no particular reason for
>>>>> parsing the bitstream on their own since the hardware can be designed
>>>>> with registers for each relevant bitstream element to configure the
>>>>> decoding pipeline. That's how GPU-based decoder implementations are
>>>>> implemented (VAAPI/VDPAU/NVDEC, etc).
>>>>> 
>>>>> So the format we have agreed on so far for the stateless interface is
>>>>> to pass parsed elements via v4l2 control structures.
>>>>> 
>>>>> If the hardware can only work by parsing the bitstream itself, I'm not
>>>>> sure what the best solution would be. Reconstructing the bitstream in
>>>>> the kernel is a pretty bad option, but so is parsing in the kernel or
>>>>> having the data both in parsed and raw forms. Do you see another
>>>>> possibility?
>>>> 
>>>> Is reconstructing the bitstream so bad? The v4l2 controls provide a
>>>> generic interface to an encoded format which the driver needs to
>>>> convert into a sequence that the hardware can understand. Typically
>>>> this is done by populating hardware-specific structures. Can't we
>>>> consider that in this specific instance, the hardware-specific
>>>> structure just happens to be identical to the original bitstream
>>>> format?
>>> 
>>> At maximum allowed bitrate for let's say HEVC (940MB/s iirc), yes, it
>>> would be really really bad. In GStreamer project we have discussed for
>>> a while (but have never done anything about) adding the ability through
>>> a bitmask to select which part of the stream need to be parsed, as
>>> parsing itself was causing some overhead. Maybe similar thing applies,
>>> though as per our new design, it's the fourcc that dictate the driver
>>> behaviour, we'd need yet another fourcc for drivers that wants the full
>>> bitstream (which seems odd if you have already parsed everything, I
>>> think this need some clarification).
>> 
>> Note that I am not proposing to rebuild the *entire* bitstream
>> in-kernel. What I am saying is that if the hardware interprets some
>> structures (like SPS/PPS) in their raw format, this raw format could
>> be reconstructed from the structures passed by userspace at negligible
>> cost. Such manipulation would only happen on a small amount of data.
>> 
>> Exposing finer-grained driver requirements through a bitmask may
>> deserve more exploring. Maybe we could end with a spectrum of
>> capabilities that would allow us to cover the range from fully
>> stateless to fully stateful IPs more smoothly. Right now we have two
>> specifications that only consider the extremes of that range.
> 
> I gave it a bit more thought and if we combine what Nicolas suggested
> about the bitmask control with the userspace providing the full
> bitstream in the OUTPUT buffers, split into some logical units and
> "tagged" with their type (e.g. SPS, PPS, slice, etc.), we could
> potentially get an interface that would work for any kind of decoder I
> can think of, actually eliminating the boundary between stateful and
> stateless decoders.
I agree with this idea, that is what I want calling memory region description while I am still struggling with userspace to post my driver demo.
> 
> For example, a fully stateful decoder would have the bitmask control
> set to 0 and accept data from all the OUTPUT buffers as they come. A
> decoder that doesn't do any parsing on its own would have all the
> valid bits in the bitmask set and ignore the data in OUTPUT buffers
> tagged as any kind of metadata. And then, we could have any cases in
> between, including stateful decoders which just can't parse the stream
> on their own, but still manage anything else themselves, or stateless
> ones which can parse parts of the stream, like the rk3399 vdec can
> parse the H.264 slice headers on its own.
> 
Actually not, the rkvdec and rkhevc can parse most but not all syntax sections.
Besides the vp9 decoder of rkvdec won’t parse most of the syntax.

I talked to some rockchip staff about the performance problem of reconstruction bitstream after yesterday arguing with tfiga at IRC yesterday. Although 1ms looks small to those decoder which can decode a picture of a UHD 4K HEVC videos in 9ms, it is enough for 60fps. But how about a higher frame rate like 120fps or 240fps and when it comes to 8K which is used in Japan broadcast.

I would bring more detail in the FOSDEM 2019, I may stay at graphics devroom at Saturday.
> That could potentially let us completely eliminate the distinction
> between the stateful and stateless interfaces and just have one that
> covers both.
> 
> Thoughts?
> 
> Best regards,
> Tomasz

