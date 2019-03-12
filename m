Return-Path: <SRS0=ZIWa=RP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8E54C43381
	for <linux-media@archiver.kernel.org>; Tue, 12 Mar 2019 11:39:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9CD772084F
	for <linux-media@archiver.kernel.org>; Tue, 12 Mar 2019 11:39:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726418AbfCLLjX (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 12 Mar 2019 07:39:23 -0400
Received: from kozue.soulik.info ([108.61.200.231]:43280 "EHLO
        kozue.soulik.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725844AbfCLLjX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Mar 2019 07:39:23 -0400
Received: from [IPv6:2001:470:b30d:2:c604:15ff:0:f0e] (unknown [IPv6:2001:470:b30d:2:c604:15ff:0:f0e])
        by kozue.soulik.info (Postfix) with ESMTPSA id 885E7100D65;
        Tue, 12 Mar 2019 20:39:31 +0900 (JST)
Subject: Re: media: rockchip: the memory layout of multiplanes buffer for DMA
 address
To:     Tomasz Figa <tfiga@chromium.org>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Nicolas Dufresne <nicolas@ndufresne.ca>, myy@miouyouyou.fr,
        Ezequiel Garcia <ezequiel@collabora.com>
References: <C5689C9D-5F00-41E2-B24F-5BC8D9BA88AF@soulik.info>
 <CAAFQd5DY0n0oDvE9o6rAXY5inL20wwAC=jPxN9EwrD1Ubv0iJg@mail.gmail.com>
From:   ayaka <ayaka@soulik.info>
Message-ID: <c2c7df27-4556-9bae-6809-cc5de872eacd@soulik.info>
Date:   Tue, 12 Mar 2019 19:39:16 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <CAAFQd5DY0n0oDvE9o6rAXY5inL20wwAC=jPxN9EwrD1Ubv0iJg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


On 3/12/19 4:22 PM, Tomasz Figa wrote:
> On Thu, Feb 28, 2019 at 12:13 AM Ayaka <ayaka@soulik.info> wrote:
>> Hello all
>>
>> I am writing the v4l2 decoder driver for rockchip. Although I hear the suggest from the Hans before, it is ok for decoder to use single plane buffer format, but I still decide to the multi planes format.
>>
>> There is not a register for vdpau1 and vdpau2 setting the chroma starting address in both pixel image output(it has one only applied for jpeg) and reference. And the second plane should follow the first plane. It sounds pretty fix for the single plane, but the single plane can’t describe offset of the second plane, which is not the result of bytes per line multiples the height.
>>
>> There are two different memory access steps in those rockchip device, 16bytes for vdpau1 and vdpau2, 64bytes for rkvdec and 128bytes for rkvdec with a high resolution. Although those access steps can be adjusted by the memory cache registers. So it is hard to describe the pixel format with the single plane formats or userspace would need to do more work.
> Why not just adjust the bytes per line to a multiple of 16/64/128
> bytes? Most of the platforms allocate buffers this way for performance
> reasons anyway.

I can't, it depends on the device design. Also I need extra empty 
line(128/256 bytes) in each lines for the rkvdec. Maybe the device for 
chrome only request an alignment with 16 bytes per line and at vertical 
line, it is ok for the H.264 under the 1920x1080 resolution,  but above 
that resolution would suffer a poor performance as well UHD.

I made a mistake in the previous mail, the current suggest alignment for 
rkvdec is 256 bytes and plus an extra line.

Also it requests  a different alignment way for those chroma subsample 
are not 4:2:0. And it is not easy to align with a width value while its 
bitdepth is large than 8 bits.

>> Currently, I use the dma-contig allocator in my driver, it would allocate the second plane first, which results that the second plane has a lower address than first plane, which device would request the second plane follows the first plane. I increase the sizeimage of the first plane to solve this problem now and let device can continue to run, but I need a way to solve this problem.
>>
>> Is there a way to control how does dma-contig allocate a buffer? I have not figured out the internal flow of the videobuf2. I know how to allocate two planes in different memory region which the s5p-mfc does with two alloc_devs, but that is not what I want.
>>
>> Last time in FOSDEM, kwiboo and I talk some problems of the request API and stateless decoder, I say the a method to describe a buffer with many offsets as the buffer meta data would solve the most of  problems we talked, but I have no idea on how to implement it. And I think a buffer meta describing a buffer with many offsets would solve this problem as well.
>>
>> Sent from my iPad
> P.S. Please fix your email client to properly wrap the lines around
> the ~75 column line.
Blame the thuderbird.
>
> Best regards,
> Tomasz
