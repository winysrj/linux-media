Return-Path: <SRS0=OvUS=QF=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C5ECC282C7
	for <linux-media@archiver.kernel.org>; Tue, 29 Jan 2019 09:39:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 203162082E
	for <linux-media@archiver.kernel.org>; Tue, 29 Jan 2019 09:39:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="ffxiBSYw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728475AbfA2JjU (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 29 Jan 2019 04:39:20 -0500
Received: from mail-oi1-f196.google.com ([209.85.167.196]:44093 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727412AbfA2JjT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 29 Jan 2019 04:39:19 -0500
Received: by mail-oi1-f196.google.com with SMTP id m6so15574014oig.11
        for <linux-media@vger.kernel.org>; Tue, 29 Jan 2019 01:39:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Nm1T119/ObMPWzlbIjDOJhaxurTOMjpaUAb/kBTk4so=;
        b=ffxiBSYwq/uNpoCkbvO9KLc1zr4H28VXciGMmTIaTzIhmwEObRT4vl2TPKOpBTLWlS
         234Nh/yOKNs+T510GOhT1amqWCH0mO2mMp8v12ILQqKnc5mA0ts+vOPPI6/1t8JgtVJC
         Jk8H9gh4jF//cLmvDPSkwjAQk0kFl0X6xppLs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Nm1T119/ObMPWzlbIjDOJhaxurTOMjpaUAb/kBTk4so=;
        b=qRUwN3bZfVzrrqoupbYDBMyVR6J16jBbe/VS4mHb6BXhNeIAacMsOLXbFF2BZRNSAI
         G2kgFu89GY/iO9MmjUKyyQ/p8q5faYMqsjaoQ5qvzolZ2u4IlQzdPdQGkVyRxKnLU1mE
         70Y60q4TaAOL1/R4ZP3/1QXtVA9L/rCrwOJ3QDcY8K9RTY1tXFH1Is3oJc/srwbqaoVV
         bYnypCguYal7YW6wnc/CERoRpWUIjMK7mN/JjZmGphs7eGRzQai7jUWAJp9JxMUFr5Su
         jQ++T/aLWynjNnTBgZYkpdDe3ZfYm0/+aArGw/imh7ILrPHDDtG61+uBdegbARuNHcfT
         JWcA==
X-Gm-Message-State: AHQUAuYHwFCXTHUnTVCGZ7YZVWqxIDbIKxMz8lIpqjHmTFJrzJuwTAZM
        yudDOgjv/N2sOBPRwMAzKT9I6c7iMnI=
X-Google-Smtp-Source: ALg8bN6U9OdiUtYFlVocqruPzKLP0CBmqzY1e4FLEPD1pzLaqlRVyHyAxeZGa0dj2EX9cKgVgQB+Wg==
X-Received: by 2002:aca:e544:: with SMTP id c65mr8980195oih.75.1548754758297;
        Tue, 29 Jan 2019 01:39:18 -0800 (PST)
Received: from mail-oi1-f173.google.com (mail-oi1-f173.google.com. [209.85.167.173])
        by smtp.gmail.com with ESMTPSA id v141sm6911332oia.25.2019.01.29.01.39.15
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 29 Jan 2019 01:39:15 -0800 (PST)
Received: by mail-oi1-f173.google.com with SMTP id w13so15575797oiw.9
        for <linux-media@vger.kernel.org>; Tue, 29 Jan 2019 01:39:15 -0800 (PST)
X-Received: by 2002:aca:ea57:: with SMTP id i84mr8842617oih.346.1548754754671;
 Tue, 29 Jan 2019 01:39:14 -0800 (PST)
MIME-Version: 1.0
References: <776e63c9-d4a5-342a-e0f7-200ef144ffc4@rock-chips.com>
 <64c793e08d61181b78125b3956ec38623fa5d261.camel@bootlin.com>
 <D8005130-F7FD-4CBD-8396-1BB08BB08E81@soulik.info> <f982ef378a8ade075bc7077b93640e20ecebf9f4.camel@bootlin.com>
 <82FA0C3F-BC54-4D89-AECB-90D81B89B1CE@soulik.info> <c3619a00-17e7-fb92-a427-a7478b96f356@soulik.info>
 <bdf14f97e98f2fd06307545ab9038ac3c2086ae7.camel@bootlin.com>
 <42520087-4EAE-4F7F-BCA0-42E422170E91@soulik.info> <ab8ca098ad60f209fe97f79bb93b2d1e898da524.camel@bootlin.com>
 <CAPBb6MUJu3cX9A-E32bSSjxc1cvGP83ayzZzUxa5_QMf6niK4g@mail.gmail.com> <20190129080944.pfhumtugsm7mzzcc@flea>
In-Reply-To: <20190129080944.pfhumtugsm7mzzcc@flea>
From:   Tomasz Figa <tfiga@chromium.org>
Date:   Tue, 29 Jan 2019 18:39:03 +0900
X-Gmail-Original-Message-ID: <CAAFQd5A=wT4RcVWmKR2vLA7e5P_mX5vDnOiaHSoA3odEqWvbDg@mail.gmail.com>
Message-ID: <CAAFQd5A=wT4RcVWmKR2vLA7e5P_mX5vDnOiaHSoA3odEqWvbDg@mail.gmail.com>
Subject: Re: [linux-sunxi] [PATCH v2 1/2] media: v4l: Add definitions for the
 HEVC slice format and controls
To:     Maxime Ripard <maxime.ripard@bootlin.com>
Cc:     Alexandre Courbot <acourbot@chromium.org>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Ayaka <ayaka@soulik.info>, Randy Li <randy.li@rock-chips.com>,
        =?UTF-8?Q?Jernej_=C5=A0krabec?= <jernej.skrabec@gmail.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, devel@driverdev.osuosl.org,
        "list@263.net:IOMMU DRIVERS <iommu@lists.linux-foundation.org>, Joerg
        Roedel <joro@8bytes.org>," <linux-arm-kernel@lists.infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
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

On Tue, Jan 29, 2019 at 5:09 PM Maxime Ripard <maxime.ripard@bootlin.com> w=
rote:
>
> On Tue, Jan 29, 2019 at 04:44:35PM +0900, Alexandre Courbot wrote:
> > On Fri, Jan 25, 2019 at 10:04 PM Paul Kocialkowski
> > > On Thu, 2019-01-24 at 20:23 +0800, Ayaka wrote:
> > > >
> > > > Sent from my iPad
> > > >
> > > > > On Jan 24, 2019, at 6:27 PM, Paul Kocialkowski <paul.kocialkowski=
@bootlin.com> wrote:
> > > > >
> > > > > Hi,
> > > > >
> > > > > > On Thu, 2019-01-10 at 21:32 +0800, ayaka wrote:
> > > > > > I forget a important thing, for the rkvdec and rk hevc decoder,=
 it would
> > > > > > requests cabac table, scaling list, picture parameter set and r=
eference
> > > > > > picture storing in one or various of DMA buffers. I am not talk=
ing about
> > > > > > the data been parsed, the decoder would requests a raw data.
> > > > > >
> > > > > > For the pps and rps, it is possible to reuse the slice header, =
just let
> > > > > > the decoder know the offset from the bitstream bufer, I would s=
uggest to
> > > > > > add three properties(with sps) for them. But I think we need a =
method to
> > > > > > mark a OUTPUT side buffer for those aux data.
> > > > >
> > > > > I'm quite confused about the hardware implementation then. From w=
hat
> > > > > you're saying, it seems that it takes the raw bitstream elements =
rather
> > > > > than parsed elements. Is it really a stateless implementation?
> > > > >
> > > > > The stateless implementation was designed with the idea that only=
 the
> > > > > raw slice data should be passed in bitstream form to the decoder.=
 For
> > > > > H.264, it seems that some decoders also need the slice header in =
raw
> > > > > bitstream form (because they take the full slice NAL unit), see t=
he
> > > > > discussions in this thread:
> > > > > media: docs-rst: Document m2m stateless video decoder interface
> > > >
> > > > Stateless just mean it won=E2=80=99t track the previous result, but=
 I don=E2=80=99t
> > > > think you can define what a date the hardware would need. Even you
> > > > just build a dpb for the decoder, it is still stateless, but parsin=
g
> > > > less or more data from the bitstream doesn=E2=80=99t stop a decoder=
 become a
> > > > stateless decoder.
> > >
> > > Yes fair enough, the format in which the hardware decoder takes the
> > > bitstream parameters does not make it stateless or stateful per-se.
> > > It's just that stateless decoders should have no particular reason fo=
r
> > > parsing the bitstream on their own since the hardware can be designed
> > > with registers for each relevant bitstream element to configure the
> > > decoding pipeline. That's how GPU-based decoder implementations are
> > > implemented (VAAPI/VDPAU/NVDEC, etc).
> > >
> > > So the format we have agreed on so far for the stateless interface is
> > > to pass parsed elements via v4l2 control structures.
> > >
> > > If the hardware can only work by parsing the bitstream itself, I'm no=
t
> > > sure what the best solution would be. Reconstructing the bitstream in
> > > the kernel is a pretty bad option, but so is parsing in the kernel or
> > > having the data both in parsed and raw forms. Do you see another
> > > possibility?
> >
> > Is reconstructing the bitstream so bad? The v4l2 controls provide a
> > generic interface to an encoded format which the driver needs to
> > convert into a sequence that the hardware can understand. Typically
> > this is done by populating hardware-specific structures. Can't we
> > consider that in this specific instance, the hardware-specific
> > structure just happens to be identical to the original bitstream
> > format?
> >
> > I agree that this is not strictly optimal for that particular
> > hardware, but such is the cost of abstractions, and in this specific
> > case I don't believe the cost would be particularly high?
>
> I mean, that argument can be made for the rockchip driver as well. If
> reconstructing the bitstream is something we can do, and if we don't
> care about being suboptimal for one particular hardware, then why the
> rockchip driver doesn't just recreate the bitstream from that API?
>
> After all, this is just a hardware specific header that happens to be
> identical to the original bitstream format

I think in another thread (about H.264 I believe), we realized that it
could be a good idea to just include the Slice NAL units in the
Annex.B format in the buffers and that should work for all the
hardware we could think of (given offsets to particular parts inside
of the buffer). Wouldn't something similar work here for HEVC?

I don't really get the meaning of "raw" for "cabac table, scaling
list, picture parameter set and reference picture", since those are
parts of the bitstream, which needs to be parsed to obtain those.

Best regards,
Tomasz
