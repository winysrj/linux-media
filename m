Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw1-f65.google.com ([209.85.161.65]:46284 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726469AbeJOR6n (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 15 Oct 2018 13:58:43 -0400
Received: by mail-yw1-f65.google.com with SMTP id j202-v6so7295499ywa.13
        for <linux-media@vger.kernel.org>; Mon, 15 Oct 2018 03:14:07 -0700 (PDT)
Received: from mail-yw1-f49.google.com (mail-yw1-f49.google.com. [209.85.161.49])
        by smtp.gmail.com with ESMTPSA id f194-v6sm3350275ywb.53.2018.10.15.03.14.04
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 15 Oct 2018 03:14:05 -0700 (PDT)
Received: by mail-yw1-f49.google.com with SMTP id m129-v6so7321451ywc.1
        for <linux-media@vger.kernel.org>; Mon, 15 Oct 2018 03:14:04 -0700 (PDT)
MIME-Version: 1.0
References: <20180724140621.59624-1-tfiga@chromium.org> <20180724140621.59624-2-tfiga@chromium.org>
 <37a8faea-a226-2d52-36d4-f9df194623cc@xs4all.nl> <CAAFQd5BgGEBmd8gNGc-qqtUtLo=Mh8U+TVTWRsKYMv1LmeBQMA@mail.gmail.com>
 <a6af3dc9-1d09-a414-ce31-bc1b3e69894f@xs4all.nl> <CAAFQd5AnC+hWy4QUGE-s+qgRvvgGC7rMhH6x8koTfYJzTLw8Cg@mail.gmail.com>
 <f0aa7c84-08e3-9b04-8d1b-95f741d6817b@xs4all.nl> <CAAFQd5ACWO0FxzZdxf-N-GStCMOSWzxKxhcpCRUh=BqT7jLJWw@mail.gmail.com>
In-Reply-To: <CAAFQd5ACWO0FxzZdxf-N-GStCMOSWzxKxhcpCRUh=BqT7jLJWw@mail.gmail.com>
From: Tomasz Figa <tfiga@chromium.org>
Date: Mon, 15 Oct 2018 19:13:51 +0900
Message-ID: <CAAFQd5ASZU-tSadEbE5NuD3aiNeZakPe-UT7oXdBxASqCpujWw@mail.gmail.com>
Subject: Re: [PATCH 1/2] media: docs-rst: Document memory-to-memory video
 decoder interface
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Pawel Osciak <posciak@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>, kamil@wypas.org,
        a.hajda@samsung.com, Kyungmin Park <kyungmin.park@samsung.com>,
        jtp.park@samsung.com, Philipp Zabel <p.zabel@pengutronix.de>,
        =?UTF-8?B?VGlmZmFueSBMaW4gKOael+aFp+ePiik=?=
        <tiffany.lin@mediatek.com>,
        =?UTF-8?B?QW5kcmV3LUNUIENoZW4gKOmZs+aZuui/qik=?=
        <andrew-ct.chen@mediatek.com>, todor.tomov@linaro.org,
        nicolas@ndufresne.ca,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        dave.stevenson@raspberrypi.org,
        Ezequiel Garcia <ezequiel@collabora.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Aug 8, 2018 at 11:55 AM Tomasz Figa <tfiga@chromium.org> wrote:
>
> On Tue, Aug 7, 2018 at 4:37 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:
> >
> > On 08/07/2018 09:05 AM, Tomasz Figa wrote:
> > > On Thu, Jul 26, 2018 at 7:57 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:
> > >>>> I wonder if we should make these min buffer controls required. It might be easier
> > >>>> that way.
> > >>>
> > >>> Agreed. Although userspace is still free to ignore it, because REQBUFS
> > >>> would do the right thing anyway.
> > >>
> > >> It's never been entirely clear to me what the purpose of those min buffers controls
> > >> is. REQBUFS ensures that the number of buffers is at least the minimum needed to
> > >> make the HW work. So why would you need these controls? It only makes sense if they
> > >> return something different from REQBUFS.
> > >>
> > >
> > > The purpose of those controls is to let the client allocate a number
> > > of buffers bigger than minimum, without the need to allocate the
> > > minimum number of buffers first (to just learn the number), free them
> > > and then allocate a bigger number again.
> >
> > I don't feel this is particularly useful. One problem with the minimum number
> > of buffers as used in the kernel is that it is often the minimum number of
> > buffers required to make the hardware work, but it may not be optimal. E.g.
> > quite a few capture drivers set the minimum to 2, which is enough for the
> > hardware, but it will likely lead to dropped frames. You really need 3
> > (one is being DMAed, one is queued and linked into the DMA engine and one is
> > being processed by userspace).
> >
> > I would actually prefer this to be the recommended minimum number of buffers,
> > which is >= the minimum REQBUFS uses.
> >
> > I.e., if you use this number and you have no special requirements, then you'll
> > get good performance.
>
> I guess we could make it so. It would make existing user space request
> more buffers than it used to with the original meaning, but I guess it
> shouldn't be a big problem.

I gave it a bit more thought and I feel like kernel is not the right
place to put any assumptions on what the userspace expects "good
performance" to be. Actually, having these controls return the minimum
number of buffers as REQBUFS would allocate makes it very well
specified - with this number you can only process frame by frame and
the number of buffers added by userspace defines exactly the queue
depth. It leaves no space for driver-specific quirks, because the
driver doesn't decide what's "good performance" anymore.

Best regards,
Tomasz
