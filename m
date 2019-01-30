Return-Path: <SRS0=BdY7=QG=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3336C282D0
	for <linux-media@archiver.kernel.org>; Wed, 30 Jan 2019 02:29:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 844D52175B
	for <linux-media@archiver.kernel.org>; Wed, 30 Jan 2019 02:29:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="HXWKsmgD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729826AbfA3C3E (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 29 Jan 2019 21:29:04 -0500
Received: from mail-ot1-f66.google.com ([209.85.210.66]:34372 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727990AbfA3C3B (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 29 Jan 2019 21:29:01 -0500
Received: by mail-ot1-f66.google.com with SMTP id t5so19872730otk.1
        for <linux-media@vger.kernel.org>; Tue, 29 Jan 2019 18:29:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=hthliATX6CStMo00A0vGtMXZYxXL92JFmTppLztuTQQ=;
        b=HXWKsmgDRaeLbn2+Gj5Rov/6M7vPWTbRmvH+xEpC3lJC2tMSP8IU6J9KWaMEuddh1E
         W/0B2txGN3CbFyPn3/D+ZE6k4+vhvbh66eUTcXppqxmPSR+OGowZkxt1hLwBUlAf96oS
         pm31rqSgTYAp4zfk2z/u2bSwxiFE9vCojgFRA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=hthliATX6CStMo00A0vGtMXZYxXL92JFmTppLztuTQQ=;
        b=Ns5ZaKgt8hmWut5K1Qbx7gxeLtTQ0aVrbyKzsGCcABjTh+dbC7tKrNcI7jsLBcNWjq
         IPn9mcN2NmHUBS2DasgkcVUkgz+C1kHzf4CQuBYyjp+pmS3Nz6bnx7jvfBYQBeEoyN4E
         l4HLUwznm+1Cs57Jsd30i/k8t5NOVxn+AJBQ+jSNF/6vU0dnmiakPwVxYcqYkR7nxcIa
         xEdryeq51kI+L4TvgnQo8//BD4gpcuPsDyRytLTJa/avMDBT93s0VasmUJElW4OfLAZc
         tlhtTIAxom9VPyNakupRj3PDFHPybgGO7XqjAE3ql40Lw58/PXQVmdM6cKK3BQ8dSc/I
         I6GQ==
X-Gm-Message-State: AHQUAuYosZ8S3jkQ4Mpdl8iufk6GJRgBaSkHTMcBa7hIDiFdUecisaYr
        8QNs4O5CFWknJHupAbASzdBBV3DUEYtpnA==
X-Google-Smtp-Source: AHgI3IbJKNsaJpxnusvdrPQ5m5LiQrlg4BmTpyAgmRXYFnzXlaDzaD8Y2SSEp3PUzF4syE4Yi5rdYw==
X-Received: by 2002:a9d:4a87:: with SMTP id i7mr31232otf.178.1548815340836;
        Tue, 29 Jan 2019 18:29:00 -0800 (PST)
Received: from mail-ot1-f46.google.com (mail-ot1-f46.google.com. [209.85.210.46])
        by smtp.gmail.com with ESMTPSA id m131sm109412oia.6.2019.01.29.18.28.57
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 29 Jan 2019 18:28:59 -0800 (PST)
Received: by mail-ot1-f46.google.com with SMTP id g16so15831941otg.11
        for <linux-media@vger.kernel.org>; Tue, 29 Jan 2019 18:28:57 -0800 (PST)
X-Received: by 2002:a9d:7319:: with SMTP id e25mr22328418otk.204.1548815337058;
 Tue, 29 Jan 2019 18:28:57 -0800 (PST)
MIME-Version: 1.0
References: <20181123130209.11696-1-paul.kocialkowski@bootlin.com>
 <20181123130209.11696-2-paul.kocialkowski@bootlin.com> <5515174.7lFZcYkk85@jernej-laptop>
 <ffe9c81db34b599f675ca5bbf02de360bf0a1608.camel@bootlin.com>
 <776e63c9-d4a5-342a-e0f7-200ef144ffc4@rock-chips.com> <64c793e08d61181b78125b3956ec38623fa5d261.camel@bootlin.com>
 <D8005130-F7FD-4CBD-8396-1BB08BB08E81@soulik.info> <f982ef378a8ade075bc7077b93640e20ecebf9f4.camel@bootlin.com>
 <82FA0C3F-BC54-4D89-AECB-90D81B89B1CE@soulik.info> <c3619a00-17e7-fb92-a427-a7478b96f356@soulik.info>
 <bdf14f97e98f2fd06307545ab9038ac3c2086ae7.camel@bootlin.com>
 <42520087-4EAE-4F7F-BCA0-42E422170E91@soulik.info> <ab8ca098ad60f209fe97f79bb93b2d1e898da524.camel@bootlin.com>
 <CAPBb6MUJu3cX9A-E32bSSjxc1cvGP83ayzZzUxa5_QMf6niK4g@mail.gmail.com> <2442b23d3b0a00c1bd441298a712888e016acf92.camel@ndufresne.ca>
In-Reply-To: <2442b23d3b0a00c1bd441298a712888e016acf92.camel@ndufresne.ca>
From:   Alexandre Courbot <acourbot@chromium.org>
Date:   Wed, 30 Jan 2019 11:28:45 +0900
X-Gmail-Original-Message-ID: <CAPBb6MUsbdXvkomtkiq0ygTqj58h4yqVR0PotT=ft94Ai0nbhw@mail.gmail.com>
Message-ID: <CAPBb6MUsbdXvkomtkiq0ygTqj58h4yqVR0PotT=ft94Ai0nbhw@mail.gmail.com>
Subject: Re: [linux-sunxi] [PATCH v2 1/2] media: v4l: Add definitions for the
 HEVC slice format and controls
To:     Nicolas Dufresne <nicolas@ndufresne.ca>
Cc:     Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Ayaka <ayaka@soulik.info>, Randy Li <randy.li@rock-chips.com>,
        =?UTF-8?Q?Jernej_=C5=A0krabec?= <jernej.skrabec@gmail.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, devel@driverdev.osuosl.org,
        linux-arm-kernel@lists.infradead.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        linux-rockchip@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Wed, Jan 30, 2019 at 6:41 AM Nicolas Dufresne <nicolas@ndufresne.ca> wro=
te:
>
> Le mardi 29 janvier 2019 =C3=A0 16:44 +0900, Alexandre Courbot a =C3=A9cr=
it :
> > On Fri, Jan 25, 2019 at 10:04 PM Paul Kocialkowski
> > <paul.kocialkowski@bootlin.com> wrote:
> > > Hi,
> > >
> > > On Thu, 2019-01-24 at 20:23 +0800, Ayaka wrote:
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
>
> At maximum allowed bitrate for let's say HEVC (940MB/s iirc), yes, it
> would be really really bad. In GStreamer project we have discussed for
> a while (but have never done anything about) adding the ability through
> a bitmask to select which part of the stream need to be parsed, as
> parsing itself was causing some overhead. Maybe similar thing applies,
> though as per our new design, it's the fourcc that dictate the driver
> behaviour, we'd need yet another fourcc for drivers that wants the full
> bitstream (which seems odd if you have already parsed everything, I
> think this need some clarification).

Note that I am not proposing to rebuild the *entire* bitstream
in-kernel. What I am saying is that if the hardware interprets some
structures (like SPS/PPS) in their raw format, this raw format could
be reconstructed from the structures passed by userspace at negligible
cost. Such manipulation would only happen on a small amount of data.

Exposing finer-grained driver requirements through a bitmask may
deserve more exploring. Maybe we could end with a spectrum of
capabilities that would allow us to cover the range from fully
stateless to fully stateful IPs more smoothly. Right now we have two
specifications that only consider the extremes of that range.
