Return-Path: <SRS0=W9AE=PO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5223BC43387
	for <linux-media@archiver.kernel.org>; Sun,  6 Jan 2019 17:30:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 22C192070D
	for <linux-media@archiver.kernel.org>; Sun,  6 Jan 2019 17:30:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726052AbfAFRaG convert rfc822-to-8bit (ORCPT
        <rfc822;linux-media@archiver.kernel.org>);
        Sun, 6 Jan 2019 12:30:06 -0500
Received: from kozue.soulik.info ([108.61.200.231]:41034 "EHLO
        kozue.soulik.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725931AbfAFRaG (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 6 Jan 2019 12:30:06 -0500
Received: from [192.168.0.49] (unknown [192.168.0.49])
        by kozue.soulik.info (Postfix) with ESMTPSA id A637B100F5C;
        Mon,  7 Jan 2019 02:30:42 +0900 (JST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH 4/4] arm64: dts: rockchip: add video codec for rk3399
From:   Ayaka <ayaka@soulik.info>
X-Mailer: iPad Mail (16A404)
In-Reply-To: <CAAEAJfCLxvJWrC1CNiSyLV9y=pOjzUBik5SUD0ZVUcnA-+HobQ@mail.gmail.com>
Date:   Mon, 7 Jan 2019 01:29:54 +0800
Cc:     Ezequiel Garcia <ezequiel@collabora.com>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Tomasz Figa <tfiga@chromium.org>,
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
Message-Id: <85C6CA4D-CC54-422B-BC2B-25EA10701696@soulik.info>
References: <20190105183150.20266-1-ayaka@soulik.info> <20190105183150.20266-5-ayaka@soulik.info> <50db3bc3faea97182b7fe18b4d9677f7e1563eaa.camel@collabora.com> <CAC7DE03-A74C-4154-9443-BC91E6CED02E@soulik.info> <f3dcd25bb1c3f0544cb7eedd0b27633d923c0d27.camel@collabora.com> <C53B5CFA-2F9C-41E1-BBA8-D63819D0AC3D@soulik.info> <CAAEAJfCLxvJWrC1CNiSyLV9y=pOjzUBik5SUD0ZVUcnA-+HobQ@mail.gmail.com>
To:     Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hello Ezequiel

Sent from my iPad

> On Jan 7, 2019, at 1:21 AM, Ezequiel Garcia <ezequiel@vanguardiasur.com.ar> wrote:
> 
>> On Sun, 6 Jan 2019 at 13:16, Ayaka <ayaka@soulik.info> wrote:
>> 
>> 
>> 
>> Sent from my iPad
>> 
>>> On Jan 7, 2019, at 12:04 AM, Ezequiel Garcia <ezequiel@collabora.com> wrote:
>>> 
>>> On Sun, 2019-01-06 at 23:05 +0800, Ayaka wrote:
>>>>> On Jan 6, 2019, at 10:22 PM, Ezequiel Garcia <ezequiel@collabora.com> wrote:
>>>>> 
>>>>> Hi Randy,
>>>>> 
>>>>> Thanks a lot for this patches. They are really useful
>>>>> to provide more insight into the VPU hardware.
>>>>> 
>>>>> This change will make the vpu encoder and vpu decoder
>>>>> completely independent, can they really work in parallel?
>>>> As I said it depends on the platform, but with this patch, the user space would think they can work at the same time.
>>> 
>>> 
>>> I think there is some confusion.
>>> 
>>> The devicetree is one thing: it is a hardware representation,
>>> a way to describe the hardware, for the kernel/bootloader to
>>> parse.
>>> 
>>> The userspace view will depend on the driver implementation.
>>> 
>>> The current devicetree and driver (without your patches),
>>> model the VPU as a single piece of hardware, exposing a decoder
>>> and an encoder.
>>> 
>>> The V4L driver will then create two video devices, i.e. /dev/videoX
>>> and /dev/videoY. So userspace sees an independent view of the
>>> devices.
>>> 
>> I knew that, the problem is that the driver should not always create a decoder and encoder pair, they may not exist at some platforms, even some platforms doesn’t have a encoder. You may have a look on the rk3328 I post on the first email as example.
> 
> That is correct. But that still doesn't tackle my question: is the
> hardware able to run a decoding and an encoding job in parallel?
> 
For rk3328, yes, you see I didn’t draw them in the same box.
> If not, then it's wrong to describe them as independent entities.
> 
>>> However, they are internally connected, and thus we can
>>> easily avoid two jobs running in parallel.
>>> 
>> That is what the mpp service did in my patches, handing the relationship between each devices. And it is not a easy work, maybe a 4k decoder would be blocked by another high frame rate encoding work or another decoder session. The vendor kernel have more worry about this,  but not in this version.
> 
> Right. That is one way to design it. Another way is having a single
> devicetree node for the VPU encoder/decoder "complex".
No, you can’t assume which one is in the combo group, it can be various. you see, in the rk3328, the vdpu is paired with an avs+ decoder. That is why I use a virtual device standing for scheduler.
> 
> Thanks for the input!
> -- 
> Ezequiel García, VanguardiaSur
> www.vanguardiasur.com.ar

