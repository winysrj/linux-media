Return-Path: <SRS0=PLMr=QB=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54C06C282C0
	for <linux-media@archiver.kernel.org>; Fri, 25 Jan 2019 15:51:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 17AE8218B0
	for <linux-media@archiver.kernel.org>; Fri, 25 Jan 2019 15:51:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726335AbfAYPvL (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 25 Jan 2019 10:51:11 -0500
Received: from mail.bootlin.com ([62.4.15.54]:54535 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726273AbfAYPvL (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 25 Jan 2019 10:51:11 -0500
Received: by mail.bootlin.com (Postfix, from userid 110)
        id A2F1020712; Fri, 25 Jan 2019 16:51:08 +0100 (CET)
Received: from localhost (aaubervilliers-681-1-87-206.w90-88.abo.wanadoo.fr [90.88.29.206])
        by mail.bootlin.com (Postfix) with ESMTPSA id 7253C206A6;
        Fri, 25 Jan 2019 16:51:08 +0100 (CET)
Date:   Fri, 25 Jan 2019 16:51:08 +0100
From:   Maxime Ripard <maxime.ripard@bootlin.com>
To:     Chen-Yu Tsai <wens@csie.org>
Cc:     Jernej =?utf-8?Q?=C5=A0krabec?= <jernej.skrabec@siol.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-sunxi <linux-sunxi@googlegroups.com>
Subject: Re: [PATCH 1/3] media: dt: bindings: sunxi-ir: Add A64 compatible
Message-ID: <20190125155108.op45cqrlssz6rw3t@flea>
References: <20190111173015.12119-1-jernej.skrabec@siol.net>
 <20190121095014.b6iq5dubfi7x2pi4@flea>
 <CAGb2v66d0wM8Yt2uS4MMhU6PP02h8CKwKjinasO6jtZ4ue1CAQ@mail.gmail.com>
 <2800701.S2xdS7azMu@jernej-laptop>
 <CAGb2v66wm3ZVjHxqBvU1EgBjj3Dn9keyG8jGrdiiXEFa_HD2kg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="xwltb647jb4hlhfl"
Content-Disposition: inline
In-Reply-To: <CAGb2v66wm3ZVjHxqBvU1EgBjj3Dn9keyG8jGrdiiXEFa_HD2kg@mail.gmail.com>
User-Agent: NeoMutt/20180716
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--xwltb647jb4hlhfl
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 25, 2019 at 10:49:58AM +0800, Chen-Yu Tsai wrote:
> On Fri, Jan 25, 2019 at 2:57 AM Jernej =C5=A0krabec <jernej.skrabec@siol.=
net> wrote:
> >
> > Dne ponedeljek, 21. januar 2019 ob 10:57:57 CET je Chen-Yu Tsai napisal=
(a):
> > > On Mon, Jan 21, 2019 at 5:50 PM Maxime Ripard <maxime.ripard@bootlin.=
com>
> > wrote:
> > > > Hi,
> > > >
> > > > I'm a bit late to the party, sorry for that.
> > > >
> > > > On Sat, Jan 12, 2019 at 09:56:11AM +0800, Chen-Yu Tsai wrote:
> > > > > On Sat, Jan 12, 2019 at 1:30 AM Jernej Skrabec <jernej.skrabec@si=
ol.net>
> > wrote:
> > > > > > A64 IR is compatible with A13, so add A64 compatible with A13 a=
s a
> > > > > > fallback.
> > > > >
> > > > > We ask people to add the SoC-specific compatible as a contigency,
> > > > > in case things turn out to be not so "compatible".
> > > > >
> > > > > To be consistent with all the other SoCs and other peripherals,
> > > > > unless you already spotted a "compatible" difference in the
> > > > > hardware, i.e. the hardware isn't completely the same, this
> > > > > patch isn't needed. On the other hand, if you did, please mention
> > > > > the differences in the commit log.
> > > >
> > > > Even if we don't spot things, since we have the stable DT now, if we
> > > > ever had that compatible in the DT from day 1, it's much easier to
> > > > deal with.
> > > >
> > > > I'd really like to have that pattern for all the IPs even if we did=
n't
> > > > spot any issue, since we can't really say that the datasheet are
> > > > complete, and one can always make a mistake and overlook something.
> > > >
> > > > I'm fine with this version, and can apply it as is if we all agree.
> > >
> > > I'm OK with having the fallback compatible. I'm just pointing out
> > > that there are and will be a whole bunch of them, and we don't need
> > > to document all of them unless we are actually doing something to
> > > support them.
> > >
> > > On the other hand, the compatible string situation for IR needs a
> > > bit of cleaning up at the moment. Right now we have sun4i-a10 and
> > > sun5i-a13. As Jernej pointed out, the A13's register definition is
> > > different from A64 (or any other SoCs later than sun6i). So we need
> > > someone with an A10s/A13 device that has IR to test it and see if
> > > the driver or the manual is wrong, and we'd likely add a compatible
> > > for the A20.
> > >
> > > Also, the earlier SoCs (A10/sun5i/A20) have IR TX capability. This
> > > was lost in A31, and also all of sun8i / sun50i. So we're going to
> > > need to add an A31 compatible that all later platforms would need
> > > to switch to.
> >
> > Actually, A13 also doesn't have IR TX capability. So I still think it's=
 best
> > having A13 compatible as a fallback and not A31. Unless A31 was released
> > before A13?
>=20
> No, but the A31 IR receiver has some additional bits in the FIFO control
> and status registers, as well as the config register (which controls
> sampling parameters). Looks like the A31 has an improved version. That
> would make it backward compatible, if not for the fact that the FIFO
> level bits are at a different offset, which might have been moved to
> make way for the extra bits. That would make them incompatible. But
> this should really be tested.
>=20
> So the fallback compatible should be the A31's, not the A13's.
>=20
> The A64's looks like the same hardware as the A31, with two extra bits:
>=20
>   - CGPO: register 0x00, bit offset 8. Controls output level of
>           "non-existing" TX pin
>=20
>   - DRQ_EN: register 0x2c, bit offset 5. Controls DRQ usage for DMA.
>             Not really useful as there isn't a DMA request line for
>             the hardware.
>=20
> Both bits are also togglable on the A31, but since actual hardware
> don't support these two features, I think we can ignore them.
>
> So it looks like for the A64 has the same IP block as the A31, in
> which case we won't need the per-SoC compatible as we've done the
> work to compare them.
>
> Maxime, what do you think?

Even though no hardware support those two features, I'd really prefer
to have an A64 compatible in addition to the A31's in the DT to be
future proof and being able to deal nicely with backward
compatibility. But of course, the driver can only use the A31 for now.

> And do you guys have any A10s/A13 hardware to test the FIFO level
> bits?

I don't think I have one with an IR receiver

Maxime

--=20
Maxime Ripard, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

--xwltb647jb4hlhfl
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCXEswbAAKCRDj7w1vZxhR
xTyeAQDnto6b9Er60BNXnIZMBEE23YGEyMhchSzYuHnBoQE5IAEA07vBJ+Wug7km
Z6GF5O5DpQTukNztjEXjk0znLD3+IA4=
=0mrN
-----END PGP SIGNATURE-----

--xwltb647jb4hlhfl--
