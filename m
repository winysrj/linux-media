Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:59826 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752169AbdGDUR5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 4 Jul 2017 16:17:57 -0400
Date: Tue, 4 Jul 2017 22:17:55 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Yong <yong.deng@magewell.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, mchehab@kernel.org,
        robh+dt@kernel.org, mark.rutland@arm.com, wens@csie.org,
        hans.verkuil@cisco.com, peter.griffin@linaro.org,
        hugues.fruchet@st.com, krzk@kernel.org, bparrot@ti.com,
        arnd@arndb.de, jean-christophe.trotin@st.com,
        benjamin.gaignard@linaro.org, tiffany.lin@mediatek.com,
        kamil@wypas.org, kieran+renesas@ksquared.org.uk,
        andrew-ct.chen@mediatek.com, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com
Subject: Re: [PATCH RFC 1/2] media: V3s: Add support for Allwinner CSI.
Message-ID: <20170704201755.fuktyr2nyrhvndas@flea>
References: <1498561654-14658-1-git-send-email-yong.deng@magewell.com>
 <1498561654-14658-2-git-send-email-yong.deng@magewell.com>
 <667c858b-2655-88c5-6bbc-9d70d06c1ff1@xs4all.nl>
 <20170703185952.18a97e9b7b05cbe321cb1268@magewell.com>
 <20170703112521.ca253erguut5v7se@flea>
 <20170704152545.4a70f04db2c984d4d54bf9dd@magewell.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="skryaxsyrlhsg3yt"
Content-Disposition: inline
In-Reply-To: <20170704152545.4a70f04db2c984d4d54bf9dd@magewell.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--skryaxsyrlhsg3yt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 04, 2017 at 03:25:45PM +0800, Yong wrote:
> On Mon, 3 Jul 2017 13:25:21 +0200
> Maxime Ripard <maxime.ripard@free-electrons.com> wrote:
>=20
> > Hi,
> >=20
> > On Mon, Jul 03, 2017 at 06:59:52PM +0800, Yong wrote:
> > > > > +	select VIDEOBUF2_DMA_CONTIG
> > > > > +	select REGMAP_MMIO
> > > > > +	---help---
> > > > > +	   Support for the Allwinner Camera Sensor Interface Controller.
> > > >=20
> > > > This controller is the same for all Allwinner SoC models?
> > >=20
> > > No.
> > > I will change the Kconfig and Makefile.
> >=20
> > This is basically a design that has been introduced in the A31 (sun6i
> > family). I guess we should just call the driver and Kconfig symbols
> > sun6i_csi (even though we don't support it yet). It also used on the
> > A23, A33, A80, A83T, H3, and probably the H5 and A64.
>=20
> Thanks for the advice. That's good.
> My purpose is to make the code reusable. People working on other
> Allwinner SoC could easily make their CSI working by just filling the
> SoC specific code. But I'm not familiar with other Allwinner SoCs=20
> except V3s. I hope to get more advice.

Right, of course we don't expect you to do all that work, and we
should definitely focus on the V3s that you have for now. My comment
was only about the driver name and Kconfig option.

For the rest of the code, see the other comments :)

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

--skryaxsyrlhsg3yt
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJZW/fzAAoJEBx+YmzsjxAgdasP/2Z2P87KFrFsL5TckAremzRN
tuJkwbp/pn689nhJNTFqAyInYOinaULabtix/kBcYtqMhf8+GpP3PAe3/WOyceYo
WgcysnHLs46NloTv+lBP2WhV/CAFCFwhUXbFmDsuX1rmmlNOADKOOqeXKc2dJ2pE
0lvKF0XkhKcTv2dMQmDMkb0LRk8r80d39GOLl021Qj/8TV/Lg2b/rlulVB5wrZlZ
RHKiJVCmYP1qMogGsCIYrZiGODoYRYUnqg2zfqUL43y97YCfna+QiKw0dP3YJ+Il
yvXT6xfeNCRbH3aVEdTzhQYc474JsBvujM/8UjTGEjmyWbyvZas5RIvReo4gCPry
+UAW/d33kFews+HZkYxKGLL9eSbvRg3pc8jxCQFz3Auz6GOC7C4ZUrCwIgzSc8Zi
OzvVbeA33mlOmrllKZbBUDSnB1tFcQrIVxjOz+Xn1zXSX0JBLTRpG8QpZxPGH8n5
Ecv78j5Dv66AFDNJApKt1HtcLEofq/ReZrhr2qXpgyPLgTiz+3PYKgaTnVKH8gza
rvocKNXdv0Y0yrbGBI7CVwv9GeZ//CrPg5Y+5T1uh64i6dwrLWvAHSZlrJk/sx5Z
1DMnwCWKMRGFjC3v8MDQnzmkC6guVNPqsjIm/ebkTO29dOeDylOoYp1BNfbUpJW6
Ykl38J1TjBsS8sj4t0e7
=imwt
-----END PGP SIGNATURE-----

--skryaxsyrlhsg3yt--
