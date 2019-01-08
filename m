Return-Path: <SRS0=gjtM=PQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82898C43387
	for <linux-media@archiver.kernel.org>; Tue,  8 Jan 2019 06:34:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3FA8A2089F
	for <linux-media@archiver.kernel.org>; Tue,  8 Jan 2019 06:34:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="EZlFwg9d"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727719AbfAHGeC (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 8 Jan 2019 01:34:02 -0500
Received: from mail-ot1-f68.google.com ([209.85.210.68]:34306 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727538AbfAHGeC (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 8 Jan 2019 01:34:02 -0500
Received: by mail-ot1-f68.google.com with SMTP id t5so2604895otk.1
        for <linux-media@vger.kernel.org>; Mon, 07 Jan 2019 22:34:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=5se9eY7y1Ym3hFdOMq25vpueA+u0CSGdgKEFNkPduC8=;
        b=EZlFwg9drOm9lYYarTO0yDRZt6A5nSZavlsxxTbNY3d2aFBHx6ettvSprbgLDWMMNc
         8Bh52f2GhPgxN+HDTg5UecEZ6ybhyrjGvLUd95D0BqSeGwuEEq3BP1Kc1MQbygRnh/MK
         XW4SlUit3Cfvq6zjlT/n/Xh85ZnOjwgnmNMOs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=5se9eY7y1Ym3hFdOMq25vpueA+u0CSGdgKEFNkPduC8=;
        b=sRUq4/UDzHi7rhSCKEvHI6erxT4/XUf24AyFqh7Ibc7YWE+TfBdij3P0Hwk/fPp/Vx
         F7DqBWAEAswBiq9XL7O9sW/voM402oW0BfnFJZQHRoEgiUHbe4+QoV06Tf07bPhX978z
         p+VB2/zoRR7gIIWRbBYYK8boODtCVk/561Am3gKBOssPmn1zFNIDd6Ra3EzZ2pVH8eHC
         txzQiUXqP8jdPTgSIbZ3vGWBtil3LBfj+f26OiC4nWcyK+05UV+An2ydAVsVaKnIiBps
         9B4MYmOp2vxIN4UxB2hQ7vWHdzdRlpCk/NbeIn9wfVoxa6U1ruh3zss9/8b4vTChq6cl
         Ei7w==
X-Gm-Message-State: AJcUukfgYebmOzDjZdvT6AGyiIUnH6KGKMjc+K+9nm2O6TtvWsvL+z+P
        9qGDYJRHoUeVFCwmJSmgmOMPQd6K/DJaaw==
X-Google-Smtp-Source: ALg8bN59QvIj9vh5lxyzL/dwjRyyrLDPLc+GQj0psitqbLUo4VvfGUNkKsvEAQm7CGsRXLtn7ZNyVg==
X-Received: by 2002:a9d:3ecb:: with SMTP id b69mr345695otc.329.1546929241089;
        Mon, 07 Jan 2019 22:34:01 -0800 (PST)
Received: from mail-oi1-f171.google.com (mail-oi1-f171.google.com. [209.85.167.171])
        by smtp.gmail.com with ESMTPSA id v20sm36131902otp.10.2019.01.07.22.33.59
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 07 Jan 2019 22:34:00 -0800 (PST)
Received: by mail-oi1-f171.google.com with SMTP id v6so2476475oif.2
        for <linux-media@vger.kernel.org>; Mon, 07 Jan 2019 22:33:59 -0800 (PST)
X-Received: by 2002:aca:b882:: with SMTP id i124mr369829oif.127.1546929239276;
 Mon, 07 Jan 2019 22:33:59 -0800 (PST)
MIME-Version: 1.0
References: <20190105183150.20266-1-ayaka@soulik.info> <20190105183150.20266-5-ayaka@soulik.info>
 <50db3bc3faea97182b7fe18b4d9677f7e1563eaa.camel@collabora.com>
 <CAC7DE03-A74C-4154-9443-BC91E6CED02E@soulik.info> <f3dcd25bb1c3f0544cb7eedd0b27633d923c0d27.camel@collabora.com>
 <C53B5CFA-2F9C-41E1-BBA8-D63819D0AC3D@soulik.info> <CAAEAJfCLxvJWrC1CNiSyLV9y=pOjzUBik5SUD0ZVUcnA-+HobQ@mail.gmail.com>
 <85C6CA4D-CC54-422B-BC2B-25EA10701696@soulik.info>
In-Reply-To: <85C6CA4D-CC54-422B-BC2B-25EA10701696@soulik.info>
From:   Tomasz Figa <tfiga@chromium.org>
Date:   Tue, 8 Jan 2019 15:33:48 +0900
X-Gmail-Original-Message-ID: <CAAFQd5AaVonqn92F=Oa_s_5fkn566+xubO5ijqHmnjg7d4j-8A@mail.gmail.com>
Message-ID: <CAAFQd5AaVonqn92F=Oa_s_5fkn566+xubO5ijqHmnjg7d4j-8A@mail.gmail.com>
Subject: Re: [PATCH 4/4] arm64: dts: rockchip: add video codec for rk3399
To:     Ayaka <ayaka@soulik.info>
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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Mon, Jan 7, 2019 at 2:30 AM Ayaka <ayaka@soulik.info> wrote:
>
> Hello Ezequiel
>
> Sent from my iPad
>
> > On Jan 7, 2019, at 1:21 AM, Ezequiel Garcia <ezequiel@vanguardiasur.com=
.ar> wrote:
> >
> >> On Sun, 6 Jan 2019 at 13:16, Ayaka <ayaka@soulik.info> wrote:
> >>
> >>
> >>
> >> Sent from my iPad
> >>
> >>> On Jan 7, 2019, at 12:04 AM, Ezequiel Garcia <ezequiel@collabora.com>=
 wrote:
> >>>
> >>> On Sun, 2019-01-06 at 23:05 +0800, Ayaka wrote:
> >>>>> On Jan 6, 2019, at 10:22 PM, Ezequiel Garcia <ezequiel@collabora.co=
m> wrote:
> >>>>>
> >>>>> Hi Randy,
> >>>>>
> >>>>> Thanks a lot for this patches. They are really useful
> >>>>> to provide more insight into the VPU hardware.
> >>>>>
> >>>>> This change will make the vpu encoder and vpu decoder
> >>>>> completely independent, can they really work in parallel?
> >>>> As I said it depends on the platform, but with this patch, the user =
space would think they can work at the same time.
> >>>
> >>>
> >>> I think there is some confusion.
> >>>
> >>> The devicetree is one thing: it is a hardware representation,
> >>> a way to describe the hardware, for the kernel/bootloader to
> >>> parse.
> >>>
> >>> The userspace view will depend on the driver implementation.
> >>>
> >>> The current devicetree and driver (without your patches),
> >>> model the VPU as a single piece of hardware, exposing a decoder
> >>> and an encoder.
> >>>
> >>> The V4L driver will then create two video devices, i.e. /dev/videoX
> >>> and /dev/videoY. So userspace sees an independent view of the
> >>> devices.
> >>>
> >> I knew that, the problem is that the driver should not always create a=
 decoder and encoder pair, they may not exist at some platforms, even some =
platforms doesn=E2=80=99t have a encoder. You may have a look on the rk3328=
 I post on the first email as example.
> >
> > That is correct. But that still doesn't tackle my question: is the
> > hardware able to run a decoding and an encoding job in parallel?
> >
> For rk3328, yes, you see I didn=E2=80=99t draw them in the same box.
> > If not, then it's wrong to describe them as independent entities.
> >
> >>> However, they are internally connected, and thus we can
> >>> easily avoid two jobs running in parallel.
> >>>
> >> That is what the mpp service did in my patches, handing the relationsh=
ip between each devices. And it is not a easy work, maybe a 4k decoder woul=
d be blocked by another high frame rate encoding work or another decoder se=
ssion. The vendor kernel have more worry about this,  but not in this versi=
on.
> >
> > Right. That is one way to design it. Another way is having a single
> > devicetree node for the VPU encoder/decoder "complex".
> No, you can=E2=80=99t assume which one is in the combo group, it can be v=
arious. you see, in the rk3328, the vdpu is paired with an avs+ decoder. Th=
at is why I use a virtual device standing for scheduler.

First of all, thanks for all the input. Having more understanding of
the hardware and shortcomings of the current V4L2 APIs is really
important to let us further evolve the API and make sure that it works
for further use cases.

As for the Device Tree itself, it doesn't always describe the hardware
in 100%. Most of the time it's just the necessary information to
choose and instantiate the right drivers and bind to the right
hardware resources. The information on which hardware instances on the
SoC can work independently can of course be described in DT (e.g. by
sub-nodes of a video-codec complex OR a set of phandles, e.g.
rockchip,shared-instances), but it's also perfectly fine to defer this
kind of knowledge to the drivers themselves.

Best regards,
Tomasz
