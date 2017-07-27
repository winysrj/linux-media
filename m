Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:44865 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751122AbdG0MZx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 27 Jul 2017 08:25:53 -0400
Date: Thu, 27 Jul 2017 14:25:51 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Baruch Siach <baruch@tkos.co.il>
Cc: Yong Deng <yong.deng@magewell.com>,
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
Message-ID: <20170727122551.qca4atjeet6whfrs@flea.lan>
References: <1501131697-1359-1-git-send-email-yong.deng@magewell.com>
 <1501131697-1359-2-git-send-email-yong.deng@magewell.com>
 <20170727121644.jtpge4x432gfxhvw@tarshish>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="kjaywmgek52r2jvf"
Content-Disposition: inline
In-Reply-To: <20170727121644.jtpge4x432gfxhvw@tarshish>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--kjaywmgek52r2jvf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 27, 2017 at 03:16:44PM +0300, Baruch Siach wrote:
> Hi Yong,
>=20
> I managed to get the Frame Done interrupt with the previous version of th=
is=20
> driver on the A33 OLinuXino. No data yet (all zeros). I'm still working o=
n it.
>=20
> One comment below.
>=20
> On Thu, Jul 27, 2017 at 01:01:35PM +0800, Yong Deng wrote:
> > Allwinner V3s SoC have two CSI module. CSI0 is used for MIPI interface
> > and CSI1 is used for parallel interface. This is not documented in
> > datasheet but by testing and guess.
> >=20
> > This patch implement a v4l2 framework driver for it.
> >=20
> > Currently, the driver only support the parallel interface. MIPI-CSI2,
> > ISP's support are not included in this patch.
> >=20
> > Signed-off-by: Yong Deng <yong.deng@magewell.com>
> > ---
>=20
> [...]
>=20
> > +static int update_buf_addr(struct sun6i_csi *csi, dma_addr_t addr)
> > +{
> > +	struct sun6i_csi_dev *sdev =3D sun6i_csi_to_dev(csi);
> > +	/* transform physical address to bus address */
> > +	dma_addr_t bus_addr =3D addr - 0x40000000;
>=20
> What is the source of this magic number? Is it platform dependent? Are th=
ere=20
> other devices doing DMA that need this adjustment?

This is the RAM base address in most (but not all) Allwinner
SoCs. You'll want to use PHYS_OFFSET instead.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

--kjaywmgek52r2jvf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJZedvPAAoJEBx+YmzsjxAgP94P/1fQruY4FKlKe2YnwKC7rjlE
QHG/nsWmhbLNDCljxATG7kpe7784R2ec3Ib+HMUM+tAkWIQ50HM/ZTBalSHx5Im+
CDy6+PUL062QMfCY6FcueNtTNfq05SpFE9//KQThyR53DYyItTihoQUGFr5eaNmz
lQSFvGIkcv6cmlpFGwdVH8aZiYrgsaDq4nkmeuhjhwi7WUuaLDzVJ92H4i/Z4cg7
1rdo8GVz38j2vPJ2SlYqN+izrl9D+65wxH/HcY/tSgKhf5HF9IiNd4cDmcD7bWgJ
MMbjRjWU6N51ct5XXF6xIvs/vHvSZHVt0noc9EWfu633GbVe3LVQMzw09zU9DVF+
AE6WWVZUgSTRJZg08an+98Qam57ShbDrxJH6xMMOAxPpUY9jm94r0a1vX2a4DEzn
Dsw9FVrpP3y1ACWVPlqIIrVIOVlNIalrFvAm4d2zNAG+cvLjlkch8VAJgpO7mUmB
Qq1VGB6Mt9anODLJ71MSYAU1MXvdv22c4XR68F3xTl8e5Yqy6fsM96V0vHpEhk/+
6wws8N8cR7P4WzPwiawUHXdwPvyxyAzUk8Hpier34nySB71k/R8koVgpgFWSb36n
bL9mnDb3Yf6jRcS/5ZO4zN0hUYBqaJSuhdtegAdYx8l463FQ47llhIj5tYJt2qN6
M1qzGQrJJdQ03CkWDPR1
=EJEd
-----END PGP SIGNATURE-----

--kjaywmgek52r2jvf--
