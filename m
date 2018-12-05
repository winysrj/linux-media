Return-Path: <SRS0=NzSx=OO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,URIBL_RHS_DOB,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21E1FC04EBF
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 11:07:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DACAF2082B
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 11:07:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DACAF2082B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=bootlin.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727718AbeLELHq (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 5 Dec 2018 06:07:46 -0500
Received: from mail.bootlin.com ([62.4.15.54]:48313 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727439AbeLELHp (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 5 Dec 2018 06:07:45 -0500
Received: by mail.bootlin.com (Postfix, from userid 110)
        id 2C68D20CDE; Wed,  5 Dec 2018 12:07:42 +0100 (CET)
Received: from localhost (aaubervilliers-681-1-79-44.w90-88.abo.wanadoo.fr [90.88.21.44])
        by mail.bootlin.com (Postfix) with ESMTPSA id 8F45620E1F;
        Wed,  5 Dec 2018 12:07:12 +0100 (CET)
Date:   Wed, 5 Dec 2018 12:07:12 +0100
From:   Maxime Ripard <maxime.ripard@bootlin.com>
To:     Chen-Yu Tsai <wens@csie.org>
Cc:     Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        devel@driverdev.osuosl.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        linux-sunxi <linux-sunxi@googlegroups.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: Re: [PATCH v2 00/15] Cedrus H5 and A64 support with A33 and H3
 updates
Message-ID: <20181205110712.dfzdkixpsayue5k7@flea>
References: <20181205092444.29497-1-paul.kocialkowski@bootlin.com>
 <CAGb2v64fjKbxET61S7NzTaPGJc7-XUG=Zb87_BOah9xWr5zpvg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="f7czaut6wahvetbb"
Content-Disposition: inline
In-Reply-To: <CAGb2v64fjKbxET61S7NzTaPGJc7-XUG=Zb87_BOah9xWr5zpvg@mail.gmail.com>
User-Agent: NeoMutt/20180716
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--f7czaut6wahvetbb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 05, 2018 at 05:48:34PM +0800, Chen-Yu Tsai wrote:
> On Wed, Dec 5, 2018 at 5:25 PM Paul Kocialkowski
> <paul.kocialkowski@bootlin.com> wrote:
> >
> > This series adds support for the Allwinner H5 and A64 platforms to the
> > cedrus stateless video codec driver, with minor updates to the A33 and
> > H3 platforms.
> >
> > It requires changes to the SRAM driver bindings and driver, to properly
> > support the H5 and the A64 C1 SRAM section. Because a H5-specific
> > system-control node is introduced, the dummy syscon node that was shared
> > between the H3 and H5 is removed in favor of each platform-specific nod=
e.
> > A few fixes are included to ensure that the EMAC clock configuration
> > register is still accessible through the sunxi SRAM driver (instead of =
the
> > dummy syscon node, that was there for this purpose) on the H3 and H5.
> >
> > The reserved memory nodes for the A33 and H3 are also removed in this
> > series, since they are not actually necessary.
> >
> > Changes since v1:
> > * Removed the reserved-memory nodes for the A64 and H5;
> > * Removed the reserved-memory nodes for the A33 and H3;
> > * Corrected the SRAM bases and sizes to the best of our knowledge;
> > * Dropped cosmetic dt changes already included in the sunxi tree.
> >
> > Paul Kocialkowski (15):
> >   ARM: dts: sun8i: h3: Fix the system-control register range
> >   ARM: dts: sun8i: a33: Remove unnecessary reserved memory node
> >   ARM: dts: sun8i: h3: Remove unnecessary reserved memory node
> >   soc: sunxi: sram: Enable EMAC clock access for H3 variant
> >   dt-bindings: sram: sunxi: Add bindings for the H5 with SRAM C1
> >   soc: sunxi: sram: Add support for the H5 SoC system control
> >   arm64: dts: allwinner: h5: Add system-control node with SRAM C1
> >   ARM/arm64: sunxi: Move H3/H5 syscon label over to soc-specific nodes
> >   dt-bindings: sram: sunxi: Add compatible for the A64 SRAM C1
> >   arm64: dts: allwinner: a64: Add support for the SRAM C1 section
> >   dt-bindings: media: cedrus: Add compatibles for the A64 and H5
> >   media: cedrus: Add device-tree compatible and variant for H5 support
> >   media: cedrus: Add device-tree compatible and variant for A64 support
> >   arm64: dts: allwinner: h5: Add Video Engine node
> >   arm64: dts: allwinner: a64: Add Video Engine node
>=20
> Other than the error in patch 7,
>=20
> Acked-by: Chen-Yu Tsai <wens@csie.org>

Applied all the patches but 11-13, with the changes discussed on patch 7 fi=
xed.

Thanks!
Maxime

--=20
Maxime Ripard, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

--f7czaut6wahvetbb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCXAexVQAKCRDj7w1vZxhR
xTQIAP9eScHqa/h3aoDUWpjYTZeZ8zmrhc865HzvWs9q0+AI1QD/TzgmpdfWEmzj
TGlTuSGLApWhDZ8SpQ3Dik0onLpBtg4=
=BZo1
-----END PGP SIGNATURE-----

--f7czaut6wahvetbb--
