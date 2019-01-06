Return-Path: <SRS0=W9AE=PO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B925C43387
	for <linux-media@archiver.kernel.org>; Sun,  6 Jan 2019 17:21:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D059E2087F
	for <linux-media@archiver.kernel.org>; Sun,  6 Jan 2019 17:21:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=vanguardiasur-com-ar.20150623.gappssmtp.com header.i=@vanguardiasur-com-ar.20150623.gappssmtp.com header.b="epezfUhg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726041AbfAFRVu (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 6 Jan 2019 12:21:50 -0500
Received: from mail-vk1-f193.google.com ([209.85.221.193]:43709 "EHLO
        mail-vk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725931AbfAFRVu (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 6 Jan 2019 12:21:50 -0500
Received: by mail-vk1-f193.google.com with SMTP id o130so8931426vke.10
        for <linux-media@vger.kernel.org>; Sun, 06 Jan 2019 09:21:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vanguardiasur-com-ar.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=HPSHnGDRj6mLQSUv4JPQnsIrTLEbeoPCS38cByUX/n4=;
        b=epezfUhgmBqwhIhvIHE/lvh7L00rnGEJ3dPd8xdNuz6MwP341NTrbB+DPsfGgmTsR/
         VXiTWmHhYpN0/yYaCWb1xewj/cT2WWIr6oJtKBTNa1vgkPBasYlBN46PhIDqcUzFL64x
         CEKEShK9ndrbv2/AmjbV1LB5zEj9i8JsU3mjH8A6jq+cRkXcMN2p5hNEMoSJp6XMI8tl
         CU2IzYWumhFdtxM5grQBBJdjycUcxYTlb7AbQ8bdsFzBtO7FaAnYuQAkJ4sN1h1lbP8S
         4WoJKWHufP2Trg6Wp0+ZjFMZJGK7KSSRQRsRDr7Ko2bwSf2zO2q9TEeFhatfTIEgM03J
         cSjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=HPSHnGDRj6mLQSUv4JPQnsIrTLEbeoPCS38cByUX/n4=;
        b=GgMMwaFubFv7aA/ypmW3BHfhGPa7l+hMZeJXzBhaHyztB9k939YVKNi+Ci3hEtpHgN
         NY6xTTe4B1Xn4KUsxeV5QqM8yhTMhVt4UtCsxOYgcZ106JT16oZrgEEt83GB0UYp25a+
         CyLSfCXFJjMxdeR0Y6pbEL8dWyebb5CC15Im28MvA//vApWIL9ibkDDDnv9gli4oww1B
         l14t/j/GCclugQiNRrS28gRMoT+REeflYxM9gNYjYIAWAy4xrPMQsVcqvuYuYdMyJIfo
         d51Ql4qVsy2VP+g2yv7Gi+jiO3PtZzKB4e+criY1pQykZIk4h5vnNOw8wVKq+WJp9xaN
         PMGA==
X-Gm-Message-State: AJcUukdpgLdzQJXOHDPV/cUqqjq35icKNsR59BDueu4YACl5C0E+LQdt
        2Sj9wm/59v/qoLU36ZJJyrFRg2eOwtZ7vTyOB1ZKcw==
X-Google-Smtp-Source: ALg8bN6dWLKjXcz6owlu3QI98SxUgZf7RBVuQjj4QJmGYCoI4qPMYvwSsNCgMbYxnMnuZxXdM6+rlWPg+Ok6dZhwylE=
X-Received: by 2002:a1f:85d3:: with SMTP id h202mr21550444vkd.69.1546795308953;
 Sun, 06 Jan 2019 09:21:48 -0800 (PST)
MIME-Version: 1.0
References: <20190105183150.20266-1-ayaka@soulik.info> <20190105183150.20266-5-ayaka@soulik.info>
 <50db3bc3faea97182b7fe18b4d9677f7e1563eaa.camel@collabora.com>
 <CAC7DE03-A74C-4154-9443-BC91E6CED02E@soulik.info> <f3dcd25bb1c3f0544cb7eedd0b27633d923c0d27.camel@collabora.com>
 <C53B5CFA-2F9C-41E1-BBA8-D63819D0AC3D@soulik.info>
In-Reply-To: <C53B5CFA-2F9C-41E1-BBA8-D63819D0AC3D@soulik.info>
From:   Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Date:   Sun, 6 Jan 2019 14:21:37 -0300
Message-ID: <CAAEAJfCLxvJWrC1CNiSyLV9y=pOjzUBik5SUD0ZVUcnA-+HobQ@mail.gmail.com>
Subject: Re: [PATCH 4/4] arm64: dts: rockchip: add video codec for rk3399
To:     Ayaka <ayaka@soulik.info>
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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Sun, 6 Jan 2019 at 13:16, Ayaka <ayaka@soulik.info> wrote:
>
>
>
> Sent from my iPad
>
> > On Jan 7, 2019, at 12:04 AM, Ezequiel Garcia <ezequiel@collabora.com> w=
rote:
> >
> > On Sun, 2019-01-06 at 23:05 +0800, Ayaka wrote:
> >>> On Jan 6, 2019, at 10:22 PM, Ezequiel Garcia <ezequiel@collabora.com>=
 wrote:
> >>>
> >>> Hi Randy,
> >>>
> >>> Thanks a lot for this patches. They are really useful
> >>> to provide more insight into the VPU hardware.
> >>>
> >>> This change will make the vpu encoder and vpu decoder
> >>> completely independent, can they really work in parallel?
> >> As I said it depends on the platform, but with this patch, the user sp=
ace would think they can work at the same time.
> >
> >
> > I think there is some confusion.
> >
> > The devicetree is one thing: it is a hardware representation,
> > a way to describe the hardware, for the kernel/bootloader to
> > parse.
> >
> > The userspace view will depend on the driver implementation.
> >
> > The current devicetree and driver (without your patches),
> > model the VPU as a single piece of hardware, exposing a decoder
> > and an encoder.
> >
> > The V4L driver will then create two video devices, i.e. /dev/videoX
> > and /dev/videoY. So userspace sees an independent view of the
> > devices.
> >
> I knew that, the problem is that the driver should not always create a de=
coder and encoder pair, they may not exist at some platforms, even some pla=
tforms doesn=E2=80=99t have a encoder. You may have a look on the rk3328 I =
post on the first email as example.

That is correct. But that still doesn't tackle my question: is the
hardware able to run a decoding and an encoding job in parallel?

If not, then it's wrong to describe them as independent entities.

> > However, they are internally connected, and thus we can
> > easily avoid two jobs running in parallel.
> >
> That is what the mpp service did in my patches, handing the relationship =
between each devices. And it is not a easy work, maybe a 4k decoder would b=
e blocked by another high frame rate encoding work or another decoder sessi=
on. The vendor kernel have more worry about this,  but not in this version.

Right. That is one way to design it. Another way is having a single
devicetree node for the VPU encoder/decoder "complex".

Thanks for the input!
--=20
Ezequiel Garc=C3=ADa, VanguardiaSur
www.vanguardiasur.com.ar
