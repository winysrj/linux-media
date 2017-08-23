Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:45457 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932405AbdHWTYP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 23 Aug 2017 15:24:15 -0400
Date: Wed, 23 Aug 2017 21:24:13 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Yong <yong.deng@magewell.com>
Cc: Baruch Siach <baruch@tkos.co.il>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Arnd Bergmann <arnd@arndb.de>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Yannick Fertre <yannick.fertre@st.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Benoit Parrot <bparrot@ti.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Jean-Christophe Trotin <jean-christophe.trotin@st.com>,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>,
        Minghsiu Tsai <minghsiu.tsai@mediatek.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com
Subject: Re: [PATCH v2 1/3] media: V3s: Add support for Allwinner CSI.
Message-ID: <20170823192413.y5psmcgd3ghvpkbz@flea.home>
References: <1501131697-1359-1-git-send-email-yong.deng@magewell.com>
 <1501131697-1359-2-git-send-email-yong.deng@magewell.com>
 <20170728160233.xooevio4hoqkgfaq@flea.lan>
 <20170730060801.bkc2kvm72ktixy74@tarshish>
 <20170821202145.kmxancepyq55v3o2@flea.lan>
 <20170823104118.b4524830e4bb767d7714772c@magewell.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="gpulx6hmx2kzzbcc"
Content-Disposition: inline
In-Reply-To: <20170823104118.b4524830e4bb767d7714772c@magewell.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--gpulx6hmx2kzzbcc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 23, 2017 at 10:41:18AM +0800, Yong wrote:
> > > > > +static irqreturn_t sun6i_csi_isr(int irq, void *dev_id)
> > > > > +{
> > > > > +	struct sun6i_csi_dev *sdev =3D (struct sun6i_csi_dev *)dev_id;
> > > > > +	struct regmap *regmap =3D sdev->regmap;
> > > > > +	u32 status;
> > > > > +
> > > > > +	regmap_read(regmap, CSI_CH_INT_STA_REG, &status);
> > > > > +
> > > > > +	if ((status & CSI_CH_INT_STA_FIFO0_OF_PD) ||
> > > > > +	    (status & CSI_CH_INT_STA_FIFO1_OF_PD) ||
> > > > > +	    (status & CSI_CH_INT_STA_FIFO2_OF_PD) ||
> > > > > +	    (status & CSI_CH_INT_STA_HB_OF_PD)) {
> > > > > +		regmap_write(regmap, CSI_CH_INT_STA_REG, status);
> > > > > +		regmap_update_bits(regmap, CSI_EN_REG, CSI_EN_CSI_EN, 0);
> > > > > +		regmap_update_bits(regmap, CSI_EN_REG, CSI_EN_CSI_EN,
> > > > > +				   CSI_EN_CSI_EN);
> > > >=20
> > > > You need to enable / disable it at every frame? How do you deal with
> > > > double buffering? (or did you choose to ignore it for now?)
> > >=20
> > > These *_OF_PD status bits indicate an overflow error condition.
> >=20
> > Shouldn't we return an error code then? The names of these flags could
> > be better too.
>=20
> Then, where and how to deal with the error coce.

If you want to deal with FIFO overflow, I'm not sure you have anything
to do. It means, you've been to slow to queue buffers, so I guess
stopping the pipeline until more buffers are queued would make
sense. And we should probably increase the sequence number while doing
so to notify the userspace that some frames were lost.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

--gpulx6hmx2kzzbcc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJZndZdAAoJEBx+YmzsjxAgxNMP/j4dG39peK/0A3yVi0cULJeZ
elrAmFZcV+zD7hvugBW1uvMUPJrE+wKYD7pn5Ku7zcqwE37mVTcnJHe2jtMNpWz7
WpxEau3zgHFUnoVQDuAOIukdC9YB1sp9ocsPNlUmEFpnFe84Lp7fSMGp5SRy4ae/
lA4vPMaxohiuNjAhKWB67zB/gOYP6L28gtAV4Y+xtAMii+5eT5aAheyGbjl4qi65
UcqyjKSl+wXutJJ4vzp2FwRdNHBgwhLNd6Bx7LTKdsMx3oQqhQGQOynRg0dApf3Y
wwDdCkrEXpjCPa/HOmCHM3mUV19QadeHrbufdhpn7CsqqE1sEfy/GkgbLBbb3gF9
3kJ941WwrBk0ea8Q6EIn65yy0IZNL4rEf3gQ+mOKWT4ueDhtiVS4+6lgoPS6GRuM
2i0jyc02tDn/4dIW75MOqXgAO+8k2esxPqO+Ok85KE72IBpRSrOknqQmbTGSZF5F
ICVRLAqhKZLiYAqottL73DFl51fO7fdUfFGUAmwAwtGcR1GrlnMQAVDyOABn2EfV
SgMYu2rifKYaTskdUfJe/KQ9WCxNJFVDBAwtedsdqbq1C+bv6PRrA2sCZMrtG+9e
jR0j/Jp4U9A9l/mTC8n0bq5T2JrLSvj9de09tchELP+dwUWZ8vYWdh6MYKI9Pc4H
ZoadvlBN3bQ8q91EUiMk
=43hd
-----END PGP SIGNATURE-----

--gpulx6hmx2kzzbcc--
