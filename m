Return-Path: <SRS0=BdY7=QG=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60461C282D4
	for <linux-media@archiver.kernel.org>; Wed, 30 Jan 2019 07:58:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2BB6D21873
	for <linux-media@archiver.kernel.org>; Wed, 30 Jan 2019 07:58:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727907AbfA3H6B (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 30 Jan 2019 02:58:01 -0500
Received: from relay2-d.mail.gandi.net ([217.70.183.194]:39081 "EHLO
        relay2-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725830AbfA3H6B (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 30 Jan 2019 02:58:01 -0500
X-Originating-IP: 90.88.147.226
Received: from localhost (aaubervilliers-681-1-27-226.w90-88.abo.wanadoo.fr [90.88.147.226])
        (Authenticated sender: maxime.ripard@bootlin.com)
        by relay2-d.mail.gandi.net (Postfix) with ESMTPSA id 627024000F;
        Wed, 30 Jan 2019 07:57:55 +0000 (UTC)
Date:   Wed, 30 Jan 2019 08:57:54 +0100
From:   Maxime Ripard <maxime.ripard@bootlin.com>
To:     Tomasz Figa <tfiga@chromium.org>
Cc:     Alexandre Courbot <acourbot@chromium.org>,
        Nicolas Dufresne <nicolas@ndufresne.ca>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Ayaka <ayaka@soulik.info>, Randy Li <randy.li@rock-chips.com>,
        Jernej =?utf-8?Q?=C5=A0krabec?= <jernej.skrabec@gmail.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, devel@driverdev.osuosl.org,
        "list@263.net:IOMMU DRIVERS <iommu@lists.linux-foundation.org>, Joerg
        Roedel <joro@8bytes.org>," <linux-arm-kernel@lists.infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>
Subject: Re: [linux-sunxi] [PATCH v2 1/2] media: v4l: Add definitions for the
 HEVC slice format and controls
Message-ID: <20190130075754.342fkmejsz3573te@flea>
References: <f982ef378a8ade075bc7077b93640e20ecebf9f4.camel@bootlin.com>
 <82FA0C3F-BC54-4D89-AECB-90D81B89B1CE@soulik.info>
 <c3619a00-17e7-fb92-a427-a7478b96f356@soulik.info>
 <bdf14f97e98f2fd06307545ab9038ac3c2086ae7.camel@bootlin.com>
 <42520087-4EAE-4F7F-BCA0-42E422170E91@soulik.info>
 <ab8ca098ad60f209fe97f79bb93b2d1e898da524.camel@bootlin.com>
 <CAPBb6MUJu3cX9A-E32bSSjxc1cvGP83ayzZzUxa5_QMf6niK4g@mail.gmail.com>
 <2442b23d3b0a00c1bd441298a712888e016acf92.camel@ndufresne.ca>
 <CAPBb6MUsbdXvkomtkiq0ygTqj58h4yqVR0PotT=ft94Ai0nbhw@mail.gmail.com>
 <CAAFQd5BJ6_eQ2QiQLdmkkkeWEiVQ_yo86QccOn9176ZRDQxc=Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="eo25urxmucyixr46"
Content-Disposition: inline
In-Reply-To: <CAAFQd5BJ6_eQ2QiQLdmkkkeWEiVQ_yo86QccOn9176ZRDQxc=Q@mail.gmail.com>
User-Agent: NeoMutt/20180716
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--eo25urxmucyixr46
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 30, 2019 at 12:35:41PM +0900, Tomasz Figa wrote:
> On Wed, Jan 30, 2019 at 11:29 AM Alexandre Courbot
> <acourbot@chromium.org> wrote:
> >
> > On Wed, Jan 30, 2019 at 6:41 AM Nicolas Dufresne <nicolas@ndufresne.ca>=
 wrote:
> > >
> > > Le mardi 29 janvier 2019 =C3=A0 16:44 +0900, Alexandre Courbot a =C3=
=A9crit :
> > > > On Fri, Jan 25, 2019 at 10:04 PM Paul Kocialkowski
> > > > <paul.kocialkowski@bootlin.com> wrote:
> > > > > Hi,
> > > > >
> > > > > On Thu, 2019-01-24 at 20:23 +0800, Ayaka wrote:
> > > > > > Sent from my iPad
> > > > > >
> > > > > > > On Jan 24, 2019, at 6:27 PM, Paul Kocialkowski <paul.kocialko=
wski@bootlin.com> wrote:
> > > > > > >
> > > > > > > Hi,
> > > > > > >
> > > > > > > > On Thu, 2019-01-10 at 21:32 +0800, ayaka wrote:
> > > > > > > > I forget a important thing, for the rkvdec and rk hevc deco=
der, it would
> > > > > > > > requests cabac table, scaling list, picture parameter set a=
nd reference
> > > > > > > > picture storing in one or various of DMA buffers. I am not =
talking about
> > > > > > > > the data been parsed, the decoder would requests a raw data.
> > > > > > > >
> > > > > > > > For the pps and rps, it is possible to reuse the slice head=
er, just let
> > > > > > > > the decoder know the offset from the bitstream bufer, I wou=
ld suggest to
> > > > > > > > add three properties(with sps) for them. But I think we nee=
d a method to
> > > > > > > > mark a OUTPUT side buffer for those aux data.
> > > > > > >
> > > > > > > I'm quite confused about the hardware implementation then. Fr=
om what
> > > > > > > you're saying, it seems that it takes the raw bitstream eleme=
nts rather
> > > > > > > than parsed elements. Is it really a stateless implementation?
> > > > > > >
> > > > > > > The stateless implementation was designed with the idea that =
only the
> > > > > > > raw slice data should be passed in bitstream form to the deco=
der. For
> > > > > > > H.264, it seems that some decoders also need the slice header=
 in raw
> > > > > > > bitstream form (because they take the full slice NAL unit), s=
ee the
> > > > > > > discussions in this thread:
> > > > > > > media: docs-rst: Document m2m stateless video decoder interfa=
ce
> > > > > >
> > > > > > Stateless just mean it won=E2=80=99t track the previous result,=
 but I don=E2=80=99t
> > > > > > think you can define what a date the hardware would need. Even =
you
> > > > > > just build a dpb for the decoder, it is still stateless, but pa=
rsing
> > > > > > less or more data from the bitstream doesn=E2=80=99t stop a dec=
oder become a
> > > > > > stateless decoder.
> > > > >
> > > > > Yes fair enough, the format in which the hardware decoder takes t=
he
> > > > > bitstream parameters does not make it stateless or stateful per-s=
e.
> > > > > It's just that stateless decoders should have no particular reaso=
n for
> > > > > parsing the bitstream on their own since the hardware can be desi=
gned
> > > > > with registers for each relevant bitstream element to configure t=
he
> > > > > decoding pipeline. That's how GPU-based decoder implementations a=
re
> > > > > implemented (VAAPI/VDPAU/NVDEC, etc).
> > > > >
> > > > > So the format we have agreed on so far for the stateless interfac=
e is
> > > > > to pass parsed elements via v4l2 control structures.
> > > > >
> > > > > If the hardware can only work by parsing the bitstream itself, I'=
m not
> > > > > sure what the best solution would be. Reconstructing the bitstrea=
m in
> > > > > the kernel is a pretty bad option, but so is parsing in the kerne=
l or
> > > > > having the data both in parsed and raw forms. Do you see another
> > > > > possibility?
> > > >
> > > > Is reconstructing the bitstream so bad? The v4l2 controls provide a
> > > > generic interface to an encoded format which the driver needs to
> > > > convert into a sequence that the hardware can understand. Typically
> > > > this is done by populating hardware-specific structures. Can't we
> > > > consider that in this specific instance, the hardware-specific
> > > > structure just happens to be identical to the original bitstream
> > > > format?
> > >
> > > At maximum allowed bitrate for let's say HEVC (940MB/s iirc), yes, it
> > > would be really really bad. In GStreamer project we have discussed for
> > > a while (but have never done anything about) adding the ability throu=
gh
> > > a bitmask to select which part of the stream need to be parsed, as
> > > parsing itself was causing some overhead. Maybe similar thing applies,
> > > though as per our new design, it's the fourcc that dictate the driver
> > > behaviour, we'd need yet another fourcc for drivers that wants the fu=
ll
> > > bitstream (which seems odd if you have already parsed everything, I
> > > think this need some clarification).
> >
> > Note that I am not proposing to rebuild the *entire* bitstream
> > in-kernel. What I am saying is that if the hardware interprets some
> > structures (like SPS/PPS) in their raw format, this raw format could
> > be reconstructed from the structures passed by userspace at negligible
> > cost. Such manipulation would only happen on a small amount of data.
> >
> > Exposing finer-grained driver requirements through a bitmask may
> > deserve more exploring. Maybe we could end with a spectrum of
> > capabilities that would allow us to cover the range from fully
> > stateless to fully stateful IPs more smoothly. Right now we have two
> > specifications that only consider the extremes of that range.
>=20
> I gave it a bit more thought and if we combine what Nicolas suggested
> about the bitmask control with the userspace providing the full
> bitstream in the OUTPUT buffers, split into some logical units and
> "tagged" with their type (e.g. SPS, PPS, slice, etc.), we could
> potentially get an interface that would work for any kind of decoder I
> can think of, actually eliminating the boundary between stateful and
> stateless decoders.
>=20
> For example, a fully stateful decoder would have the bitmask control
> set to 0 and accept data from all the OUTPUT buffers as they come. A
> decoder that doesn't do any parsing on its own would have all the
> valid bits in the bitmask set and ignore the data in OUTPUT buffers
> tagged as any kind of metadata. And then, we could have any cases in
> between, including stateful decoders which just can't parse the stream
> on their own, but still manage anything else themselves, or stateless
> ones which can parse parts of the stream, like the rk3399 vdec can
> parse the H.264 slice headers on its own.
>=20
> That could potentially let us completely eliminate the distinction
> between the stateful and stateless interfaces and just have one that
> covers both.
>=20
> Thoughts?

If we have to provide the whole bitstream in the buffers, then it
entirely breaks the sole software stack we have running and working
currently, for a use case and a driver that hasn't seen a single line
of code.

Seriously, this is a *private* API that we did that way so that we can
change it and only make it public. Why not do just that?

Maxime

--=20
Maxime Ripard, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

--eo25urxmucyixr46
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCXFFZAgAKCRDj7w1vZxhR
xT1mAP9JLhIY6z7t38NnYNSmnAKeY1JcWxNTBmCfPeLvutTXLQEAj1v+04mUKpzD
t4r+hI6ujxL88ldTMCmbAtnm5ugUKgQ=
=POMx
-----END PGP SIGNATURE-----

--eo25urxmucyixr46--
