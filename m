Return-Path: <SRS0=kVnX=P5=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C413AC282DB
	for <linux-media@archiver.kernel.org>; Mon, 21 Jan 2019 09:50:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 977E4214DA
	for <linux-media@archiver.kernel.org>; Mon, 21 Jan 2019 09:50:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727553AbfAUJu2 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 21 Jan 2019 04:50:28 -0500
Received: from mail.bootlin.com ([62.4.15.54]:44008 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726133AbfAUJu1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 Jan 2019 04:50:27 -0500
Received: by mail.bootlin.com (Postfix, from userid 110)
        id DF83F207B2; Mon, 21 Jan 2019 10:50:24 +0100 (CET)
Received: from localhost (unknown [185.94.189.187])
        by mail.bootlin.com (Postfix) with ESMTPSA id 9925B206A7;
        Mon, 21 Jan 2019 10:50:14 +0100 (CET)
Date:   Mon, 21 Jan 2019 10:50:14 +0100
From:   Maxime Ripard <maxime.ripard@bootlin.com>
To:     Chen-Yu Tsai <wens@csie.org>
Cc:     Jernej Skrabec <jernej.skrabec@siol.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-sunxi <linux-sunxi@googlegroups.com>
Subject: Re: [PATCH 1/3] media: dt: bindings: sunxi-ir: Add A64 compatible
Message-ID: <20190121095014.b6iq5dubfi7x2pi4@flea>
References: <20190111173015.12119-1-jernej.skrabec@siol.net>
 <20190111173015.12119-2-jernej.skrabec@siol.net>
 <CAGb2v66DiqK9sL-hQev4Wy08d9T7f1Yc2DFWJ0gYOnqChJyBRw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="pod3s2auuikkj2ou"
Content-Disposition: inline
In-Reply-To: <CAGb2v66DiqK9sL-hQev4Wy08d9T7f1Yc2DFWJ0gYOnqChJyBRw@mail.gmail.com>
User-Agent: NeoMutt/20180716
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--pod3s2auuikkj2ou
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

I'm a bit late to the party, sorry for that.

On Sat, Jan 12, 2019 at 09:56:11AM +0800, Chen-Yu Tsai wrote:
> On Sat, Jan 12, 2019 at 1:30 AM Jernej Skrabec <jernej.skrabec@siol.net> =
wrote:
> >
> > A64 IR is compatible with A13, so add A64 compatible with A13 as a
> > fallback.
>=20
> We ask people to add the SoC-specific compatible as a contigency,
> in case things turn out to be not so "compatible".
>=20
> To be consistent with all the other SoCs and other peripherals,
> unless you already spotted a "compatible" difference in the
> hardware, i.e. the hardware isn't completely the same, this
> patch isn't needed. On the other hand, if you did, please mention
> the differences in the commit log.

Even if we don't spot things, since we have the stable DT now, if we
ever had that compatible in the DT from day 1, it's much easier to
deal with.

I'd really like to have that pattern for all the IPs even if we didn't
spot any issue, since we can't really say that the datasheet are
complete, and one can always make a mistake and overlook something.

I'm fine with this version, and can apply it as is if we all agree.

Maxime

--=20
Maxime Ripard, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

--pod3s2auuikkj2ou
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCXEWV1gAKCRDj7w1vZxhR
xdUhAPsFhFx24R8BcF1PZBKzZxawseM8u6EkLqiywLaJEW9KsgEA7IaQ769P9J/O
y0f1jGjSPd1ns0KF+bP144/jbr84RwA=
=oQXi
-----END PGP SIGNATURE-----

--pod3s2auuikkj2ou--
