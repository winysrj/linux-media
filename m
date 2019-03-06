Return-Path: <SRS0=KHCC=RJ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80787C43381
	for <linux-media@archiver.kernel.org>; Wed,  6 Mar 2019 10:57:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 55D2520675
	for <linux-media@archiver.kernel.org>; Wed,  6 Mar 2019 10:57:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730187AbfCFK5N (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 6 Mar 2019 05:57:13 -0500
Received: from relay7-d.mail.gandi.net ([217.70.183.200]:57393 "EHLO
        relay7-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730171AbfCFK5N (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 6 Mar 2019 05:57:13 -0500
X-Originating-IP: 90.88.150.179
Received: from localhost (aaubervilliers-681-1-31-179.w90-88.abo.wanadoo.fr [90.88.150.179])
        (Authenticated sender: maxime.ripard@bootlin.com)
        by relay7-d.mail.gandi.net (Postfix) with ESMTPSA id D185F20003;
        Wed,  6 Mar 2019 10:57:08 +0000 (UTC)
Date:   Wed, 6 Mar 2019 11:57:08 +0100
From:   Maxime Ripard <maxime.ripard@bootlin.com>
To:     Jernej =?utf-8?Q?=C5=A0krabec?= <jernej.skrabec@gmail.com>
Cc:     hans.verkuil@cisco.com, acourbot@chromium.org,
        sakari.ailus@linux.intel.com,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        tfiga@chromium.org, posciak@chromium.org,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        nicolas.dufresne@collabora.com, jenskuske@gmail.com,
        jonas@kwiboo.se, ezequiel@collabora.com,
        linux-sunxi@googlegroups.com,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [PATCH v4 2/2] media: cedrus: Add H264 decoding support
Message-ID: <20190306105708.kjp7xjom42azhl6y@flea>
References: <cover.1862a43851950ddee041d53669f8979aba863c38.1550672228.git-series.maxime.ripard@bootlin.com>
 <1717029.ugS2kBEt89@jernej-laptop>
 <20190305101732.3eylxubiiboygjc5@flea>
 <7218484.YqF67YIo71@jernej-laptop>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="5oodpt76mqik6m2b"
Content-Disposition: inline
In-Reply-To: <7218484.YqF67YIo71@jernej-laptop>
User-Agent: NeoMutt/20180716
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--5oodpt76mqik6m2b
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Mar 05, 2019 at 06:05:08PM +0100, Jernej =C5=A0krabec wrote:
> Dne torek, 05. marec 2019 ob 11:17:32 CET je Maxime Ripard napisal(a):
> > Hi Jernej,
> >=20
> > On Wed, Feb 20, 2019 at 06:50:54PM +0100, Jernej =C5=A0krabec wrote:
> > > I really wanted to do another review on previous series but got distr=
acted
> > > by analyzing one particulary troublesome H264 sample. It still doesn't
> > > work correctly, so I would ask you if you can test it with your stack=
 (it
> > > might be userspace issue):
> > >=20
> > > http://jernej.libreelec.tv/videos/problematic/test.mkv
> > >=20
> > > Please take a look at my comments below.
> >=20
> > I'd really prefer to focus on getting this merged at this point, and
> > then fixing odd videos and / or setups we can find later
> > on. Especially when new stacks are going to be developped on top of
> > this, I'm sure we're going to have plenty of bugs to address :)
>=20
> I forgot to mention, you can add:
> Reviewed-by: Jernej Skrabec <jernej.skrabec@siol.net>
>=20
> once you fix issues.

Great, thanks :)

> > > > +	for (i =3D 0; i < ARRAY_SIZE(pred_weight->weight_factors); i++) {
> > > > +		const struct v4l2_h264_weight_factors *factors =3D
> > > > +			&pred_weight->weight_factors[i];
> > > > +
> > > > +		for (j =3D 0; j < ARRAY_SIZE(factors->luma_weight); j++)=20
> {
> > > > +			u32 val;
> > > > +
> > > > +			val =3D ((factors->luma_offset[j] & 0x1ff) <<=20
> 16)
> > > >=20
> > > > +				(factors->luma_weight[j] & 0x1ff);
> > > > +			cedrus_write(dev, VE_AVC_SRAM_PORT_DATA,
> > >=20
> > > val);
> > >=20
> > > You should cast offset varible to wider type. Currently some videos w=
hich
> > > use prediction weight table don't work for me, unless offset is caste=
d to
> > > u32 first. Shifting 8 bit variable for 16 places gives you 0 every ti=
me.
> >=20
> > I'll do it.
> >=20
> > > Luma offset and weight are defined as s8, so having wider mask doesn't
> > > really make sense. However, I think weight should be s16 anyway, beca=
use
> > > standard says that it's value could be 2^denominator for default valu=
e or
> > > in range -128..127. Worst case would be 2^7 =3D 128 and -128. To cove=
r both
> > > values you need at least 9 bits.
> >=20
> > But if I understood the spec right, in that case you would just have
> > the denominator set, and not the offset, while the offset is used if
> > you don't use the default formula (and therefore remains in the -128
> > 127 range which is covered by the s8), right?
>=20
> Yeah, default offset is 0 and s8 is sufficient for that. I'm talking abou=
t=20
> weight. Default weight is "1 << denominator", which might be 1 << 7 or 12=
8.
>=20
> We could also add a flag, which would signal default table. In that case =
we=20
> could just set a bit to tell VPU to use default values. Even if some VPUs=
 need=20
> default table to be set explicitly, it's very easy to calculate values as=
=20
> mentioned in previous paragraph.

Yeah, sorry, I meant weight. Would that make any difference? Can we
have situations where both the denominator and the weight would be
set, with the weight set to 128?

I've checked in the libva and ffmpeg, and libva uses a short, while
ffmpeg uses an int, both for the weight and offset. For consistency I
guess we could change both to shorts just like libva?

What do you think?

Maxime

--=20
Maxime Ripard, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

--5oodpt76mqik6m2b
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCXH+nhAAKCRDj7w1vZxhR
xY4fAP9lDiwgT+3oYdujG6kE1Qyw1W4wyCTqTi0jgm7oujeTagD/U74819AYc2pA
7h2l8gSdhU9KRQ2Xg8ChzPaFgR1v1ww=
=/2so
-----END PGP SIGNATURE-----

--5oodpt76mqik6m2b--
