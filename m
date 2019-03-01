Return-Path: <SRS0=+Qw+=RE=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CBEEC43381
	for <linux-media@archiver.kernel.org>; Fri,  1 Mar 2019 09:24:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 02D672085A
	for <linux-media@archiver.kernel.org>; Fri,  1 Mar 2019 09:24:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732086AbfCAJY3 convert rfc822-to-8bit (ORCPT
        <rfc822;linux-media@archiver.kernel.org>);
        Fri, 1 Mar 2019 04:24:29 -0500
Received: from kozue.soulik.info ([108.61.200.231]:55594 "EHLO
        kozue.soulik.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727993AbfCAJY3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 1 Mar 2019 04:24:29 -0500
Received: from [192.168.10.231] (unknown [103.29.142.67])
        by kozue.soulik.info (Postfix) with ESMTPSA id E12E6100F5F;
        Fri,  1 Mar 2019 18:24:42 +0900 (JST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (1.0)
Subject: Re: media: rockchip: the memory layout of multiplanes buffer for DMA address
From:   Ayaka <ayaka@soulik.info>
X-Mailer: iPad Mail (16A404)
In-Reply-To: <035fb03f524d58d3749ebad6ceaad10ff73ee911.camel@ndufresne.ca>
Date:   Fri, 1 Mar 2019 17:24:23 +0800
Cc:     linux-media@vger.kernel.org, hverkuil@xs4all.nl, myy@miouyouyou.fr,
        ezequiel@collabora.com, tfiga@chromium.org
Content-Transfer-Encoding: 8BIT
Message-Id: <D2720D44-296E-44A5-BCB9-34BD8CCAB09F@soulik.info>
References: <C5689C9D-5F00-41E2-B24F-5BC8D9BA88AF@soulik.info> <647793c24801de4fd464bac3414cff091c30facf.camel@ndufresne.ca> <1313497D-BE61-421C-93FA-0228F77F7FC5@soulik.info> <035fb03f524d58d3749ebad6ceaad10ff73ee911.camel@ndufresne.ca>
To:     Nicolas Dufresne <nicolas@ndufresne.ca>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org



Sent from my iPad

> On Mar 1, 2019, at 12:21 AM, Nicolas Dufresne <nicolas@ndufresne.ca> wrote:
> 
> Le jeudi 28 février 2019 à 09:12 +0800, Ayaka a écrit :
>>> On Feb 28, 2019, at 5:07 AM, Nicolas Dufresne <nicolas@ndufresne.ca> wrote:
>>> 
>>> Hi Ayaka,
>>> 
>>>> Le mercredi 27 février 2019 à 23:13 +0800, Ayaka a écrit :
>>>> Last time in FOSDEM, kwiboo and I talk some problems of the request
>>>> API and stateless decoder, I say the a method to describe a buffer
>>>> with many offsets as the buffer meta data would solve the most of 
>>>> problems we talked, but I have no idea on how to implement it. And I
>>>> think a buffer meta describing a buffer with many offsets would solve
>>>> this problem as well.
>>> 
>>> for single allocation case, the only supported in-between plane padding
>>> is an evenly distributed padding. This padding is communicated to
>>> userspace through S_FMT, by extending the width and height. Userspace
>>> then reads the display width/height through G_SELECTION API.
>> It can solve the partly problem, it is hard to use only width and height to describe a buffer. For hevc and rkvdec decoder in 128bytes mode, it is aligned with 128 bytes plus 128bytes. Sometimes, the padding data may. just less than a component. In that case, only offset would solve this problem.
>>> For anything else, the MPLANE structure with one of the multi-plane
>>> format can "express" such buffer, though from userspace they are
>>> exposed as two memory pointer or DMABuf FDs (which make importation
>> The video output(VOP) supports two address for luma and chroma and the new generation of rkvdec supports that as well. But for the general situation, we should think we can only set one DMA address to the device.
>>> complicated if the buffer should initially be within a single
>>> allocation). I'll leave to kernel dev the task to explain what is
>>> feasible there (e.g. sub-buffering, etc.)
>> I think it can use the same fd but with a different data_offset in struct v4l2_plane(with a larger number of byteused in the second plane).
> 
> I think Hans said there is problem (something against the spec) in
> using data_offset that way. The GStreamer implementation assumes that,
> but got told recently that this might not be correct. I'd like Hans to
> comment, since I haven't understood the reason yet.
> 
>> 
>> If I can find a solution to solve this problem, it would be hard to future develop on the stateless media device. Please help on this problem.
> 
> I don't think this is specific to state less CODEC. While more complex,
> when dealing with CMA, the kernel can do that math to figure-out if two
> memory pointers are from the same allocation. It quite easy if you know
> in advance the spacing.
> 
I check only the s5p-mfc use CMA only in media. Also there are two register for the luma and chroma start address. Which is different to the current problem in rockchip platform.
> Without being identical, the framework does similar things when trying
> to import USERPTR in a CMA based V4L2 driver.
> 
>>> Nicolas
>>> 

