Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:53269 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751376AbdGSGuV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Jul 2017 02:50:21 -0400
Date: Wed, 19 Jul 2017 08:50:19 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Baruch Siach <baruch@tkos.co.il>
Cc: Yong <yong.deng@magewell.com>, mchehab@kernel.org,
        robh+dt@kernel.org, mark.rutland@arm.com, wens@csie.org,
        hans.verkuil@cisco.com, peter.griffin@linaro.org,
        hugues.fruchet@st.com, krzk@kernel.org, bparrot@ti.com,
        arnd@arndb.de, jean-christophe.trotin@st.com,
        benjamin.gaignard@linaro.org, tiffany.lin@mediatek.com,
        kamil@wypas.org, kieran+renesas@ksquared.org.uk,
        andrew-ct.chen@mediatek.com, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC 2/2] dt-bindings: add binding documentation for
 Allwinner CSI
Message-ID: <20170719065019.sc2xivtm4d77vrzw@flea>
References: <1498561654-14658-1-git-send-email-yong.deng@magewell.com>
 <1498561654-14658-3-git-send-email-yong.deng@magewell.com>
 <20170718115530.ssy7g5vv4siqnfpo@tarshish>
 <20170719092249.2fb6ec720ba1b194cea320c8@magewell.com>
 <20170719044923.yae2ye4slvrmtyfe@sapphire.tkos.co.il>
 <20170719142120.d00469cf9fce844d40b9988e@magewell.com>
 <20170719063349.m5yg4n2radkvy74r@sapphire.tkos.co.il>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="v4g3dpjs7ofqle2n"
Content-Disposition: inline
In-Reply-To: <20170719063349.m5yg4n2radkvy74r@sapphire.tkos.co.il>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--v4g3dpjs7ofqle2n
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 19, 2017 at 09:33:49AM +0300, Baruch Siach wrote:
> Hi Yong,
>=20
> On Wed, Jul 19, 2017 at 02:21:20PM +0800, Yong wrote:
> > On Wed, 19 Jul 2017 07:49:23 +0300
> > Baruch Siach <baruch@tkos.co.il> wrote:
> > > On Wed, Jul 19, 2017 at 09:22:49AM +0800, Yong wrote:
> > > > I am waiting for more comments for the sunxi-csi.h. It's pleasure if
> > > > you have any suggestions about it.
> > >=20
> > > You mean sunxi_csi.h, right?
> >=20
> > Yes. My spelling mistake.
> >=20
> > > Why do you need the sunxi_csi_ops indirection? Do you expect to add=
=20
> > > alternative implementations of these ops at some point?
> >=20
> > I want to seperate the sunxi_video.c and sunxi_csi_v3s.c.=20
> > sunxi_csi_v3s.c is Soc specific. Maybe there will be sunxi_csi_r40.c
> > in the futrue. But the sunxi_video.c and sunxi_csi.c are common.
>=20
> I'd say it is a premature optimization. The file separation is fine, IMO,=
 but=20
> the added csi_ops indirection makes the code less readable. Someone with=
=20
> access to R40 hardware with CSI setup would be a better position to abstr=
act=20
> the platform specific code.

I agree

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

--v4g3dpjs7ofqle2n
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJZbwErAAoJEBx+YmzsjxAgkA8QAK3rocgwl+IIKUxE7K2LZ5Ex
mSGc7hHBl3UxAa4YdN/94h94LYoQiGh09ngGyBaIWsJHIS0RiGiqvdf80BDGh2Em
DZpUEznBMQl3SSNW5hCriLmmm1xrg9J/E9rLBpJutVJBDxjkQKZpEnjBzClIGGO0
ONu9BFsz+FJ914X5NwXNYI5twOcg2K21OmBBhyzthFkUPUvwrNVJ0BDvtg8xVKws
fbP0UJ0lUScWaOv1h+CYQuX4PfJkoZbEQN7ipnMUMNKUTsv1w7fA7kwxDrehfj/H
LGgDvyAbyTzPaQLF1mBv1Z1Bj4bvzUuwyBSQMTA3Mb1wj/qQqOHlriqIP+3O6yER
Dk0RtEdSrpGQtTr4U11/oMnCSV34+hA07TYzuajFtlFonBokm8wuFGj17lqFkkKW
D5ccTFGvhOAiUG02Sxb0UoLrU4xo4+OW2Gi09bs7WjXhFpbAELhjjrfZLhgjCjG7
HFN6Y2SE0hQFObQpmH+BIhn0Qa9AUDcTxZua/nInZQ04GGO+2OW2t/kr3lbhwDg8
/rXjC74hS9LXLt2GYC0RUyhwnRoVlXlhpQ+0FbOcnVlrxIpXEaLV2g1kDnBq+0Mw
qBvvrm1Oeg70a4DcJ0sCHvMKFMae3SpOJKBslqw2CMd2c0bBO9oZncMUWDaPMtHg
l8f00rTwmxRrpJXsphy4
=IFl6
-----END PGP SIGNATURE-----

--v4g3dpjs7ofqle2n--
