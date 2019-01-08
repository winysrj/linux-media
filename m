Return-Path: <SRS0=gjtM=PQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D6CAC43387
	for <linux-media@archiver.kernel.org>; Tue,  8 Jan 2019 07:40:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5E9B1218A1
	for <linux-media@archiver.kernel.org>; Tue,  8 Jan 2019 07:40:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727633AbfAHHkP convert rfc822-to-8bit (ORCPT
        <rfc822;linux-media@archiver.kernel.org>);
        Tue, 8 Jan 2019 02:40:15 -0500
Received: from kozue.soulik.info ([108.61.200.231]:41258 "EHLO
        kozue.soulik.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727473AbfAHHkO (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 8 Jan 2019 02:40:14 -0500
Received: from [192.168.10.231] (unknown [103.29.142.67])
        by kozue.soulik.info (Postfix) with ESMTPSA id C55A5100F34;
        Tue,  8 Jan 2019 16:40:53 +0900 (JST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH 4/4] arm64: dts: rockchip: add video codec for rk3399
From:   Ayaka <ayaka@soulik.info>
X-Mailer: iPad Mail (16A404)
In-Reply-To: <CAAFQd5AaVonqn92F=Oa_s_5fkn566+xubO5ijqHmnjg7d4j-8A@mail.gmail.com>
Date:   Tue, 8 Jan 2019 15:40:08 +0800
Cc:     Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        myy@miouyouyou.fr,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media <linux-media@vger.kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Heiko Stuebner <heiko@sntech.de>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <F8ED7EBD-FC71-4E40-98A0-DD239EF9371D@soulik.info>
References: <20190105183150.20266-1-ayaka@soulik.info> <20190105183150.20266-5-ayaka@soulik.info> <50db3bc3faea97182b7fe18b4d9677f7e1563eaa.camel@collabora.com> <CAC7DE03-A74C-4154-9443-BC91E6CED02E@soulik.info> <f3dcd25bb1c3f0544cb7eedd0b27633d923c0d27.camel@collabora.com> <C53B5CFA-2F9C-41E1-BBA8-D63819D0AC3D@soulik.info> <CAAEAJfCLxvJWrC1CNiSyLV9y=pOjzUBik5SUD0ZVUcnA-+HobQ@mail.gmail.com> <85C6CA4D-CC54-422B-BC2B-25EA10701696@soulik.info> <CAAFQd5AaVonqn92F=Oa_s_5fkn566+xubO5ijqHmnjg7d4j-8A@mail.gmail.com>
To:     Tomasz Figa <tfiga@chromium.org>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org



Sent from my iPad

> On Jan 8, 2019, at 2:33 PM, Tomasz Figa <tfiga@chromium.org> wrote:
> 
>> On Mon, Jan 7, 2019 at 2:30 AM Ayaka <ayaka@soulik.info> wrote:
>> 
>> Hello Ezequiel
>> 
>> Sent from my iPad
>> 
>>>> On Jan 7, 2019, at 1:21 AM, Ezequiel Garcia <ezequiel@vanguardiasur.com.ar> wrote:
>>>> 
>>>> On Sun, 6 Jan 2019 at 13:16, Ayaka <ayaka@soulik.info> wrote:
>>>> 
>>>> 
>>>> 
>>>> Sent from my iPad
>>>> 
>>>>> On Jan 7, 2019, at 12:04 AM, Ezequiel Garcia <ezequiel@collabora.com> wrote:
>>>>> 
>>>>> On Sun, 2019-01-06 at 23:05 +0800, Ayaka wrote:
>>>>>>> On Jan 6, 2019, at 10:22 PM, Ezequiel Garcia <ezequiel@collabora.com> wrote:
>>>>>>> 
>>>>>>> Hi Randy,
>>>>>>> 
>>>>>>> Thanks a lot for this patches. They are really useful
>>>>>>> to provide more insight into the VPU hardware.
>>>>>>> 
>>>>>>> This change will make the vpu encoder and vpu decoder
>>>>>>> completely independent, can they really work in parallel?
>>>>>> As I said it depends on the platform, but with this patch, the user space would think they can work at the same time.
>>>>> 
>>>>> 
>>>>> I think there is some confusion.
>>>>> 
>>>>> The devicetree is one thing: it is a hardware representation,
>>>>> a way to describe the hardware, for the kernel/bootloader to
>>>>> parse.
>>>>> 
>>>>> The userspace view will depend on the driver implementation.
>>>>> 
>>>>> The current devicetree and driver (without your patches),
>>>>> model the VPU as a single piece of hardware, exposing a decoder
>>>>> and an encoder.
>>>>> 
>>>>> The V4L driver will then create two video devices, i.e. /dev/videoX
>>>>> and /dev/videoY. So userspace sees an independent view of the
>>>>> devices.
>>>>> 
>>>> I knew that, the problem is that the driver should not always create a decoder and encoder pair, they may not exist at some platforms, even some platforms doesn’t have a encoder. You may have a look on the rk3328 I post on the first email as example.
>>> 
>>> That is correct. But that still doesn't tackle my question: is the
>>> hardware able to run a decoding and an encoding job in parallel?
>>> 
>> For rk3328, yes, you see I didn’t draw them in the same box.
>>> If not, then it's wrong to describe them as independent entities.
>>> 
>>>>> However, they are internally connected, and thus we can
>>>>> easily avoid two jobs running in parallel.
>>>>> 
>>>> That is what the mpp service did in my patches, handing the relationship between each devices. And it is not a easy work, maybe a 4k decoder would be blocked by another high frame rate encoding work or another decoder session. The vendor kernel have more worry about this,  but not in this version.
>>> 
>>> Right. That is one way to design it. Another way is having a single
>>> devicetree node for the VPU encoder/decoder "complex".
>> No, you can’t assume which one is in the combo group, it can be various. you see, in the rk3328, the vdpu is paired with an avs+ decoder. That is why I use a virtual device standing for scheduler.
> 
> First of all, thanks for all the input. Having more understanding of
> the hardware and shortcomings of the current V4L2 APIs is really
> important to let us further evolve the API and make sure that it works
> for further use cases.
I replied the problems of the v4l2 request API in the other threads. I am waiting the feedback from those threads.
> 
> As for the Device Tree itself, it doesn't always describe the hardware
> in 100%.
Also please note the merged device tree for the video codec won’t fix for most of the rockchip platform.
> Most of the time it's just the necessary information to
> choose and instantiate the right drivers and bind to the right
> hardware resources. The information on which hardware instances on the
> SoC can work independently can of course be described in DT (e.g. by
> sub-nodes of a video-codec complex OR a set of phandles, e.g.
> rockchip,shared-instances), but it's also perfectly fine to defer this
> kind of knowledge to the drivers themselves.
I wish there is a common mechanism for those device would share some resources. Although there is a multiple functions framework,  but that is not I want. They are multiple functions but they are used at the same time not separately.
> 
> Best regards,
> Tomasz

