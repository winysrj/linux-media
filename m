Return-Path: <SRS0=BdY7=QG=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA5FBC169C4
	for <linux-media@archiver.kernel.org>; Wed, 30 Jan 2019 03:35:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8060221473
	for <linux-media@archiver.kernel.org>; Wed, 30 Jan 2019 03:35:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="SpBSH8Mf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727720AbfA3Df4 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 29 Jan 2019 22:35:56 -0500
Received: from mail-oi1-f194.google.com ([209.85.167.194]:37048 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726947AbfA3Dfz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 29 Jan 2019 22:35:55 -0500
Received: by mail-oi1-f194.google.com with SMTP id y23so18113922oia.4
        for <linux-media@vger.kernel.org>; Tue, 29 Jan 2019 19:35:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=TcsyA1n6pBTmF1Y5oeefdi7XPYD4WXUfVM4aanxIPf4=;
        b=SpBSH8Mf4zPTp2y0b78sCsIPoZBvwdDBA7enAu5Y10R1062+fXZpzl+r8No+CW5FRC
         KSHqM8Af97BnqRFj7t07VBqY6SQJVWsR4NLhxw/Vjw9WCagOoiXtYm4RT+DK8dT4QnPJ
         IHkujlBB3kEBFc1/BOweHMC6JdstIC2rm2gQw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=TcsyA1n6pBTmF1Y5oeefdi7XPYD4WXUfVM4aanxIPf4=;
        b=IbZjYQgITXKH5kdXKH28460t1DAXaaO6uB4VNejk4DZ3JQyAVKnPr/T20oexXZgtTv
         DolSrA2diqAzbPDACDP+J0MFnlrS8UzZN9SzlXljF1/zVL/Pof45wdvZFHY/guuSv+tL
         wWI8u+yFxqCQ7qmQngZ5d2h26SY5FT+rqOKeTmZ0NA2hIqK16ke0ddH4RUDYLF4ZL82y
         jmLydyWGYW3JWfXSb+AhWJeyzcM0gMq7FmTvcYKHOnGz84LueI6woc5rR/KOAe10BADJ
         fp7/GKfd6UN5y6igjrArlL80nKiLS7lXQpGUOr0bFlwbu7kKkncSCgQtmJH/C8aRxSzx
         KcKg==
X-Gm-Message-State: AHQUAuYieaTrO2jfIlupZtr/QEch9QwMd776OWQGtD26Vgouo+McsCiC
        zJf1gQRk1opP9yl4luQQFWLEW+F/COQ=
X-Google-Smtp-Source: AHgI3IYD59qUnVV/e1i0zZy2dHB0/DjwRQoSow+qbgkZWyYw1ADecmEVeIl2TOGBtnCfZbp1fEQvIw==
X-Received: by 2002:aca:654a:: with SMTP id j10mr2605762oiw.301.1548819354647;
        Tue, 29 Jan 2019 19:35:54 -0800 (PST)
Received: from mail-oi1-f174.google.com (mail-oi1-f174.google.com. [209.85.167.174])
        by smtp.gmail.com with ESMTPSA id l9sm148443otj.9.2019.01.29.19.35.53
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 29 Jan 2019 19:35:54 -0800 (PST)
Received: by mail-oi1-f174.google.com with SMTP id y1so18056970oie.12
        for <linux-media@vger.kernel.org>; Tue, 29 Jan 2019 19:35:53 -0800 (PST)
X-Received: by 2002:aca:ea57:: with SMTP id i84mr11319499oih.346.1548819353475;
 Tue, 29 Jan 2019 19:35:53 -0800 (PST)
MIME-Version: 1.0
References: <20181123130209.11696-1-paul.kocialkowski@bootlin.com>
 <20181123130209.11696-2-paul.kocialkowski@bootlin.com> <5515174.7lFZcYkk85@jernej-laptop>
 <ffe9c81db34b599f675ca5bbf02de360bf0a1608.camel@bootlin.com>
 <776e63c9-d4a5-342a-e0f7-200ef144ffc4@rock-chips.com> <64c793e08d61181b78125b3956ec38623fa5d261.camel@bootlin.com>
 <D8005130-F7FD-4CBD-8396-1BB08BB08E81@soulik.info> <f982ef378a8ade075bc7077b93640e20ecebf9f4.camel@bootlin.com>
 <82FA0C3F-BC54-4D89-AECB-90D81B89B1CE@soulik.info> <c3619a00-17e7-fb92-a427-a7478b96f356@soulik.info>
 <bdf14f97e98f2fd06307545ab9038ac3c2086ae7.camel@bootlin.com>
 <42520087-4EAE-4F7F-BCA0-42E422170E91@soulik.info> <ab8ca098ad60f209fe97f79bb93b2d1e898da524.camel@bootlin.com>
 <CAPBb6MUJu3cX9A-E32bSSjxc1cvGP83ayzZzUxa5_QMf6niK4g@mail.gmail.com>
 <2442b23d3b0a00c1bd441298a712888e016acf92.camel@ndufresne.ca> <CAPBb6MUsbdXvkomtkiq0ygTqj58h4yqVR0PotT=ft94Ai0nbhw@mail.gmail.com>
In-Reply-To: <CAPBb6MUsbdXvkomtkiq0ygTqj58h4yqVR0PotT=ft94Ai0nbhw@mail.gmail.com>
From:   Tomasz Figa <tfiga@chromium.org>
Date:   Wed, 30 Jan 2019 12:35:41 +0900
X-Gmail-Original-Message-ID: <CAAFQd5BJ6_eQ2QiQLdmkkkeWEiVQ_yo86QccOn9176ZRDQxc=Q@mail.gmail.com>
Message-ID: <CAAFQd5BJ6_eQ2QiQLdmkkkeWEiVQ_yo86QccOn9176ZRDQxc=Q@mail.gmail.com>
Subject: Re: [linux-sunxi] [PATCH v2 1/2] media: v4l: Add definitions for the
 HEVC slice format and controls
To:     Alexandre Courbot <acourbot@chromium.org>
Cc:     Nicolas Dufresne <nicolas@ndufresne.ca>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Ayaka <ayaka@soulik.info>, Randy Li <randy.li@rock-chips.com>,
        =?UTF-8?Q?Jernej_=C5=A0krabec?= <jernej.skrabec@gmail.com>,
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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Wed, Jan 30, 2019 at 11:29 AM Alexandre Courbot
<acourbot@chromium.org> wrote:
>
> On Wed, Jan 30, 2019 at 6:41 AM Nicolas Dufresne <nicolas@ndufresne.ca> w=
rote:
> >
> > Le mardi 29 janvier 2019 =C3=A0 16:44 +0900, Alexandre Courbot a =C3=A9=
crit :
> > > On Fri, Jan 25, 2019 at 10:04 PM Paul Kocialkowski
> > > <paul.kocialkowski@bootlin.com> wrote:
> > > > Hi,
> > > >
> > > > On Thu, 2019-01-24 at 20:23 +0800, Ayaka wrote:
> > > > > Sent from my iPad
> > > > >
> > > > > > On Jan 24, 2019, at 6:27 PM, Paul Kocialkowski <paul.kocialkows=
ki@bootlin.com> wrote:
> > > > > >
> > > > > > Hi,
> > > > > >
> > > > > > > On Thu, 2019-01-10 at 21:32 +0800, ayaka wrote:
> > > > > > > I forget a important thing, for the rkvdec and rk hevc decode=
r, it would
> > > > > > > requests cabac table, scaling list, picture parameter set and=
 reference
> > > > > > > picture storing in one or various of DMA buffers. I am not ta=
lking about
> > > > > > > the data been parsed, the decoder would requests a raw data.
> > > > > > >
> > > > > > > For the pps and rps, it is possible to reuse the slice header=
, just let
> > > > > > > the decoder know the offset from the bitstream bufer, I would=
 suggest to
> > > > > > > add three properties(with sps) for them. But I think we need =
a method to
> > > > > > > mark a OUTPUT side buffer for those aux data.
> > > > > >
> > > > > > I'm quite confused about the hardware implementation then. From=
 what
> > > > > > you're saying, it seems that it takes the raw bitstream element=
s rather
> > > > > > than parsed elements. Is it really a stateless implementation?
> > > > > >
> > > > > > The stateless implementation was designed with the idea that on=
ly the
> > > > > > raw slice data should be passed in bitstream form to the decode=
r. For
> > > > > > H.264, it seems that some decoders also need the slice header i=
n raw
> > > > > > bitstream form (because they take the full slice NAL unit), see=
 the
> > > > > > discussions in this thread:
> > > > > > media: docs-rst: Document m2m stateless video decoder interface
> > > > >
> > > > > Stateless just mean it won=E2=80=99t track the previous result, b=
ut I don=E2=80=99t
> > > > > think you can define what a date the hardware would need. Even yo=
u
> > > > > just build a dpb for the decoder, it is still stateless, but pars=
ing
> > > > > less or more data from the bitstream doesn=E2=80=99t stop a decod=
er become a
> > > > > stateless decoder.
> > > >
> > > > Yes fair enough, the format in which the hardware decoder takes the
> > > > bitstream parameters does not make it stateless or stateful per-se.
> > > > It's just that stateless decoders should have no particular reason =
for
> > > > parsing the bitstream on their own since the hardware can be design=
ed
> > > > with registers for each relevant bitstream element to configure the
> > > > decoding pipeline. That's how GPU-based decoder implementations are
> > > > implemented (VAAPI/VDPAU/NVDEC, etc).
> > > >
> > > > So the format we have agreed on so far for the stateless interface =
is
> > > > to pass parsed elements via v4l2 control structures.
> > > >
> > > > If the hardware can only work by parsing the bitstream itself, I'm =
not
> > > > sure what the best solution would be. Reconstructing the bitstream =
in
> > > > the kernel is a pretty bad option, but so is parsing in the kernel =
or
> > > > having the data both in parsed and raw forms. Do you see another
> > > > possibility?
> > >
> > > Is reconstructing the bitstream so bad? The v4l2 controls provide a
> > > generic interface to an encoded format which the driver needs to
> > > convert into a sequence that the hardware can understand. Typically
> > > this is done by populating hardware-specific structures. Can't we
> > > consider that in this specific instance, the hardware-specific
> > > structure just happens to be identical to the original bitstream
> > > format?
> >
> > At maximum allowed bitrate for let's say HEVC (940MB/s iirc), yes, it
> > would be really really bad. In GStreamer project we have discussed for
> > a while (but have never done anything about) adding the ability through
> > a bitmask to select which part of the stream need to be parsed, as
> > parsing itself was causing some overhead. Maybe similar thing applies,
> > though as per our new design, it's the fourcc that dictate the driver
> > behaviour, we'd need yet another fourcc for drivers that wants the full
> > bitstream (which seems odd if you have already parsed everything, I
> > think this need some clarification).
>
> Note that I am not proposing to rebuild the *entire* bitstream
> in-kernel. What I am saying is that if the hardware interprets some
> structures (like SPS/PPS) in their raw format, this raw format could
> be reconstructed from the structures passed by userspace at negligible
> cost. Such manipulation would only happen on a small amount of data.
>
> Exposing finer-grained driver requirements through a bitmask may
> deserve more exploring. Maybe we could end with a spectrum of
> capabilities that would allow us to cover the range from fully
> stateless to fully stateful IPs more smoothly. Right now we have two
> specifications that only consider the extremes of that range.

I gave it a bit more thought and if we combine what Nicolas suggested
about the bitmask control with the userspace providing the full
bitstream in the OUTPUT buffers, split into some logical units and
"tagged" with their type (e.g. SPS, PPS, slice, etc.), we could
potentially get an interface that would work for any kind of decoder I
can think of, actually eliminating the boundary between stateful and
stateless decoders.

For example, a fully stateful decoder would have the bitmask control
set to 0 and accept data from all the OUTPUT buffers as they come. A
decoder that doesn't do any parsing on its own would have all the
valid bits in the bitmask set and ignore the data in OUTPUT buffers
tagged as any kind of metadata. And then, we could have any cases in
between, including stateful decoders which just can't parse the stream
on their own, but still manage anything else themselves, or stateless
ones which can parse parts of the stream, like the rk3399 vdec can
parse the H.264 slice headers on its own.

That could potentially let us completely eliminate the distinction
between the stateful and stateless interfaces and just have one that
covers both.

Thoughts?

Best regards,
Tomasz
