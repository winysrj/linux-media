Return-Path: <SRS0=gjtM=PQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D94CC43387
	for <linux-media@archiver.kernel.org>; Tue,  8 Jan 2019 09:59:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4C75A2087F
	for <linux-media@archiver.kernel.org>; Tue,  8 Jan 2019 09:59:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727939AbfAHJ7m (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 8 Jan 2019 04:59:42 -0500
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:52583 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727001AbfAHJ7m (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 8 Jan 2019 04:59:42 -0500
Received: from [IPv6:2001:420:44c1:2579:f814:526d:2d68:295f] ([IPv6:2001:420:44c1:2579:f814:526d:2d68:295f])
        by smtp-cloud9.xs4all.net with ESMTPA
        id goAXgD0F7MWvEgoAbgMt7v; Tue, 08 Jan 2019 10:59:39 +0100
Subject: Re: [GIT PULL FOR v5.1] vb2/cedrus: use timestamps to identify
 buffers
To:     =?UTF-8?B?5p2O5aSP5r2kIChSYW5keSBMaSk=?= <randy.li@rock-chips.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc:     Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Tomasz Figa <tfiga@chromium.org>
References: <b3bbcd9c-fcaf-4a13-2c46-7e2231e9e8e0@xs4all.nl>
 <4c7e839f-ae1b-35cd-df29-a7f6993f17d4@xs4all.nl>
 <1468691710.6518623.1546938541229.JavaMail.javamailuser@localhost>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <144ee69b-25cb-2943-a4c9-12ad35c7d877@xs4all.nl>
Date:   Tue, 8 Jan 2019 10:59:33 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
In-Reply-To: <1468691710.6518623.1546938541229.JavaMail.javamailuser@localhost>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfBMyvau6qLCDcnmUGyhLK9xoDdwaOoePAbcnikpooz1Vi86DukYQTApIkx8nmAhBPYbb2bZMXdb3/n2vKZJ4hZsK5GfAlx858zIrWJ/g9p3HqKtSDJqI
 NTpRJsI8E/Nca/aWa1Itsgj0fa8EkqTHw9b9mHYaGw4xB6DNITh7GM3s3dtCChLCqJUwo7Y2jpfNWpRs0jMhbsGcdRgPBxnUuN9BzcABWouprllHkQu5wnQM
 OrH9IUuhiMfb5yQg7dTrBYwF39p8cfawfGW9yfi8f9SMB3CkUfJZeEQ14Eh1W/xRXETQlbAkO0ksqs53Jb3QMtL3MG9Ch+kVtm+C6v6U1wLPh/apbjThojNR
 Z5QeAt8PcukKSXnKHd22lBVH+Vgs2MFBjduG8zkzFvwEJL40VsjQgvb6vVlm4rTDddBt/uMmypFjqyAOjbDuqdhbRikh3g==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 01/08/19 10:09, 李夏潤 (Randy Li) wrote:
> I sent the other talking about the disadvantage of using buffer tag in
> 
> Re: [PATCHv4 00/10] As was discussed here (among other places)
> 
> 
> I agree with the buffer tag. But coping from the OUTPUT side to CAPTURE side is a bad idea.
> 
> I think we need a method to refer any buffers when they are allocated.
> 
> When I push a slice with its parameters into the driver, its previous picture in decoded order may not ready yet, using the buffer index, the driver
> 
> is still able to generate the registers table for it. Although you may though it just an additional buffer assignment work before wrote it into the device,
> 
> a few times seeking a buffer in a list. But there is a mode in new generation Rockchip device, called the link mode, you can put a registers into a memory, device would process that register link. You can't interrupt it. That is pretty useful for those codec converting.
> 
> 
> Besides, I found it is little hard to refer a buffer with different offsets at the same time, it would be used for multiple slices and multiple CTU or filed picture which are not usual case nowadays.
> 
> 
> Please don't do that.

To be honest, I don't understand what the problem is. Can you explain in more
detail, perhaps with an example?

Does anyone else understand this? Tomasz, I think you've worked with rockchip before, do
you see what Randy is referring to?

Regards,

	Hans

> 
> 
> Randy Li
> 
> *From:* "Hans Verkuil <hverkuil@xs4all.nl>"
> 
> *To:* "Linux Media Mailing List <linux-media@vger.kernel.org>"
> 
> *CC:* "Paul Kocialkowski <paul.kocialkowski@bootlin.com>","Maxime Ripard <maxime.ripard@bootlin.com>","Tomasz Figa <tfiga@chromium.org>"
> 
> *Sent:* 2019-01-07 19:36
> 
> *Subject:* Re: [GIT PULL FOR v5.1] vb2/cedrus: use timestamps to identify buffers[Please note,mail behalf by linux-media-owner@vger.kernel.org]
> 
> On 01/07/2019 12:30 PM, Hans Verkuil wrote:
>> As was discussed here (among other places):
>>
>>https://lkml.org/lkml/2018/10/19/440
>>
>> using capture queue buffer indices to refer to reference frames is
>> not a good idea.
>>
>> Instead, after a long irc discussion:
>>
>>https://linuxtv.org/irc/irclogger_log/v4l?date=2018-12-12,Wed
>>
>> it was decided to use the timestamp in v4l2_buffer for this.
>>
>> However, struct timeval cannot be used in a compound control since
>> the size of struct timeval differs between 32 and 64 bit architectures,
>> and there are also changes upcoming for y2038 support.
>>
>> But internally the kernel converts the timeval to a u64 (nsecs since
>> boot). So we provide a helper function in videodev2.h that converts
>> the timeval to a u64, and that u64 can be used inside compound controls.
>>
>> In the not too distant future we want to create a new struct v4l2_buffer,
>> and then we'll use u64 from the start, so in that case the helper function
>> would no longer be needed.
>>
>> The first three patches add a new m2m helper function to correctly copy
>> the relevant data from an output buffer to a capture buffer. This will
>> simplify m2m drivers (in fact, many m2m drivers do not do this quite
>> right, so a helper function was really needed).
>>
>> The fourth patch clears up messy timecode documentation that I came
>> across while working on this.
>>
>> Patch 5 adds the new v4l2_timeval_to_ns helper function to videodev2.h.
>> The next patch adds the vb2_find_timestamp() function to find buffers
>> with a specific u64 timestamp.
>>
>> Finally the cedrus driver and documentation are updated to use a
>> timestamp as buffer identifier.
>>
>> I also removed the 'pad' fields from the mpeg2 control structs (it
>> should never been added in the first place) and aligned the structs
>> to a u32 boundary.
> 
> Note that this pull request corresponds with the v6 patch series.
> ("[PATCHv6 0/8] vb2/cedrus: use timestamps to identify buffers")
> 
> Regards,
> Hans
> 
>>
>> Regards,
>>
>>         Hans
>>
>> The following changes since commit 4bd46aa0353e022c2401a258e93b107880a66533:
>>
>>   media: cx23885: only reset DMA on problematic CPUs (2018-12-20 06:52:01 -0500)
>>
>> are available in the Git repository at:
>>
>>   git://linuxtv.org/hverkuil/media_tree.git tags/br-buftag
>>
>> for you to fetch changes up to 690da7b0ab96f6761e72bb0c5c861e1e13acb327:
>>
>>   extended-controls.rst: update the mpeg2 compound controls (2019-01-07 12:23:49 +0100)
>>
>> ----------------------------------------------------------------
>> Tag branch
>>
>> ----------------------------------------------------------------
>> Hans Verkuil (8):
>>       v4l2-mem2mem: add v4l2_m2m_buf_copy_data helper function
>>       vim2m: use v4l2_m2m_buf_copy_data
>>       vicodec: use v4l2_m2m_buf_copy_data
>>       buffer.rst: clean up timecode documentation
>>       videodev2.h: add v4l2_timeval_to_ns inline function
>>       vb2: add vb2_find_timestamp()
>>       cedrus: identify buffers by timestamp
>>       extended-controls.rst: update the mpeg2 compound controls
>>
>>  Documentation/media/uapi/v4l/buffer.rst            | 11 +++++------
>>  Documentation/media/uapi/v4l/extended-controls.rst | 28 +++++++++++++++++-----------
>>  drivers/media/common/videobuf2/videobuf2-v4l2.c    | 19 ++++++++++++++++++-
>>  drivers/media/platform/vicodec/vicodec-core.c      | 12 +-----------
>>  drivers/media/platform/vim2m.c                     | 12 +-----------
>>  drivers/media/v4l2-core/v4l2-ctrls.c               |  9 ---------
>>  drivers/media/v4l2-core/v4l2-mem2mem.c             | 20 ++++++++++++++++++++
>>  drivers/staging/media/sunxi/cedrus/cedrus.h        |  9 ++++++---
>>  drivers/staging/media/sunxi/cedrus/cedrus_dec.c    |  2 ++
>>  drivers/staging/media/sunxi/cedrus/cedrus_mpeg2.c  | 23 +++++++++++------------
>>  include/media/mpeg2-ctrls.h                        | 14 +++++---------
>>  include/media/v4l2-mem2mem.h                       | 20 ++++++++++++++++++++
>>  include/media/videobuf2-v4l2.h                     | 17 +++++++++++++++++
>>  include/uapi/linux/videodev2.h                     | 12 ++++++++++++
>>  14 files changed, 135 insertions(+), 73 deletions(-)
>>
> 

