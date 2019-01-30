Return-Path: <SRS0=BdY7=QG=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB040C282D4
	for <linux-media@archiver.kernel.org>; Wed, 30 Jan 2019 07:04:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C2FDE20855
	for <linux-media@archiver.kernel.org>; Wed, 30 Jan 2019 07:04:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729804AbfA3HD4 convert rfc822-to-8bit (ORCPT
        <rfc822;linux-media@archiver.kernel.org>);
        Wed, 30 Jan 2019 02:03:56 -0500
Received: from kozue.soulik.info ([108.61.200.231]:35876 "EHLO
        kozue.soulik.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725820AbfA3HD4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 30 Jan 2019 02:03:56 -0500
Received: from [192.168.10.231] (unknown [103.29.142.67])
        by kozue.soulik.info (Postfix) with ESMTPSA id 55AE210106E;
        Wed, 30 Jan 2019 16:05:05 +0900 (JST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (1.0)
Subject: Re: [linux-sunxi] [PATCH v2 1/2] media: v4l: Add definitions for the HEVC slice format and controls
From:   Ayaka <ayaka@soulik.info>
X-Mailer: iPad Mail (16A404)
In-Reply-To: <2442b23d3b0a00c1bd441298a712888e016acf92.camel@ndufresne.ca>
Date:   Wed, 30 Jan 2019 15:03:51 +0800
Cc:     Alexandre Courbot <acourbot@chromium.org>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Randy Li <randy.li@rock-chips.com>,
        =?utf-8?Q?Jernej_=C5=A0krabec?= <jernej.skrabec@gmail.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, devel@driverdev.osuosl.org,
        linux-arm-kernel@lists.infradead.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        linux-rockchip@lists.infradead.org
Content-Transfer-Encoding: 8BIT
Message-Id: <3E2E3087-B2C7-48A9-B465-C4BDFA1250A7@soulik.info>
References: <20181123130209.11696-1-paul.kocialkowski@bootlin.com> <20181123130209.11696-2-paul.kocialkowski@bootlin.com> <5515174.7lFZcYkk85@jernej-laptop> <ffe9c81db34b599f675ca5bbf02de360bf0a1608.camel@bootlin.com> <776e63c9-d4a5-342a-e0f7-200ef144ffc4@rock-chips.com> <64c793e08d61181b78125b3956ec38623fa5d261.camel@bootlin.com> <D8005130-F7FD-4CBD-8396-1BB08BB08E81@soulik.info> <f982ef378a8ade075bc7077b93640e20ecebf9f4.camel@bootlin.com> <82FA0C3F-BC54-4D89-AECB-90D81B89B1CE@soulik.info> <c3619a00-17e7-fb92-a427-a7478b96f356@soulik.info> <bdf14f97e98f2fd06307545ab9038ac3c2086ae7.camel@bootlin.com> <42520087-4EAE-4F7F-BCA0-42E422170E91@soulik.info> <ab8ca098ad60f209fe97f79bb93b2d1e898da524.camel@bootlin.com> <CAPBb6MUJu3cX9A-E32bSSjxc1cvGP83ayzZzUxa5_QMf6niK4g@mail.gmail.com> <2442b23d3b0a00c1bd441298a712888e016acf92.camel@ndufresne.ca>
To:     Nicolas Dufresne <nicolas@ndufresne.ca>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org



Sent from my iPad

> On Jan 30, 2019, at 5:41 AM, Nicolas Dufresne <nicolas@ndufresne.ca> wrote:
> 
>> Le mardi 29 janvier 2019 à 16:44 +0900, Alexandre Courbot a écrit :
>> On Fri, Jan 25, 2019 at 10:04 PM Paul Kocialkowski
>> <paul.kocialkowski@bootlin.com> wrote:
>>> Hi,
>>> 
>>>> On Thu, 2019-01-24 at 20:23 +0800, Ayaka wrote:
>>>> Sent from my iPad
>>>> 
>>>>> On Jan 24, 2019, at 6:27 PM, Paul Kocialkowski <paul.kocialkowski@bootlin.com> wrote:
>>>>> 
>>>>> Hi,
>>>>> 
>>>>>> On Thu, 2019-01-10 at 21:32 +0800, ayaka wrote:
>>>>>> I forget a important thing, for the rkvdec and rk hevc decoder, it would
>>>>>> requests cabac table, scaling list, picture parameter set and reference
>>>>>> picture storing in one or various of DMA buffers. I am not talking about
>>>>>> the data been parsed, the decoder would requests a raw data.
>>>>>> 
>>>>>> For the pps and rps, it is possible to reuse the slice header, just let
>>>>>> the decoder know the offset from the bitstream bufer, I would suggest to
>>>>>> add three properties(with sps) for them. But I think we need a method to
>>>>>> mark a OUTPUT side buffer for those aux data.
>>>>> 
>>>>> I'm quite confused about the hardware implementation then. From what
>>>>> you're saying, it seems that it takes the raw bitstream elements rather
>>>>> than parsed elements. Is it really a stateless implementation?
>>>>> 
>>>>> The stateless implementation was designed with the idea that only the
>>>>> raw slice data should be passed in bitstream form to the decoder. For
>>>>> H.264, it seems that some decoders also need the slice header in raw
>>>>> bitstream form (because they take the full slice NAL unit), see the
>>>>> discussions in this thread:
>>>>> media: docs-rst: Document m2m stateless video decoder interface
>>>> 
>>>> Stateless just mean it won’t track the previous result, but I don’t
>>>> think you can define what a date the hardware would need. Even you
>>>> just build a dpb for the decoder, it is still stateless, but parsing
>>>> less or more data from the bitstream doesn’t stop a decoder become a
>>>> stateless decoder.
>>> 
>>> Yes fair enough, the format in which the hardware decoder takes the
>>> bitstream parameters does not make it stateless or stateful per-se.
>>> It's just that stateless decoders should have no particular reason for
>>> parsing the bitstream on their own since the hardware can be designed
>>> with registers for each relevant bitstream element to configure the
>>> decoding pipeline. That's how GPU-based decoder implementations are
>>> implemented (VAAPI/VDPAU/NVDEC, etc).
>>> 
>>> So the format we have agreed on so far for the stateless interface is
>>> to pass parsed elements via v4l2 control structures.
>>> 
>>> If the hardware can only work by parsing the bitstream itself, I'm not
>>> sure what the best solution would be. Reconstructing the bitstream in
>>> the kernel is a pretty bad option, but so is parsing in the kernel or
>>> having the data both in parsed and raw forms. Do you see another
>>> possibility?
>> 
>> Is reconstructing the bitstream so bad? The v4l2 controls provide a
>> generic interface to an encoded format which the driver needs to
>> convert into a sequence that the hardware can understand. Typically
>> this is done by populating hardware-specific structures. Can't we
>> consider that in this specific instance, the hardware-specific
>> structure just happens to be identical to the original bitstream
>> format?
> 
> At maximum allowed bitrate for let's say HEVC (940MB/s iirc), yes, it
Lucky, most of hardware won’t be able to processing such a big buffer.
General speaking, the register is 24bits for stream length in bytes.
> would be really really bad. In GStreamer project we have discussed for
> a while (but have never done anything about) adding the ability through
> a bitmask to select which part of the stream need to be parsed, as
> parsing itself was causing some overhead. Maybe similar thing applies,
> though as per our new design, it's the fourcc that dictate the driver
> behaviour, we'd need yet another fourcc for drivers that wants the full
> bitstream (which seems odd if you have already parsed everything, I
> think this need some clarification).
> 
>> 
>> I agree that this is not strictly optimal for that particular
>> hardware, but such is the cost of abstractions, and in this specific
>> case I don't believe the cost would be particularly high?

