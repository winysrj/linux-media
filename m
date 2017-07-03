Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:42712 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752114AbdGCLZd (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 3 Jul 2017 07:25:33 -0400
Date: Mon, 3 Jul 2017 13:25:21 +0200
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
Message-ID: <20170703112521.ca253erguut5v7se@flea>
References: <1498561654-14658-1-git-send-email-yong.deng@magewell.com>
 <1498561654-14658-2-git-send-email-yong.deng@magewell.com>
 <667c858b-2655-88c5-6bbc-9d70d06c1ff1@xs4all.nl>
 <20170703185952.18a97e9b7b05cbe321cb1268@magewell.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="jeum2g7ncqcdbp47"
Content-Disposition: inline
In-Reply-To: <20170703185952.18a97e9b7b05cbe321cb1268@magewell.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--jeum2g7ncqcdbp47
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Jul 03, 2017 at 06:59:52PM +0800, Yong wrote:
> > > +	select VIDEOBUF2_DMA_CONTIG
> > > +	select REGMAP_MMIO
> > > +	---help---
> > > +	   Support for the Allwinner Camera Sensor Interface Controller.
> >=20
> > This controller is the same for all Allwinner SoC models?
>=20
> No.
> I will change the Kconfig and Makefile.

This is basically a design that has been introduced in the A31 (sun6i
family). I guess we should just call the driver and Kconfig symbols
sun6i_csi (even though we don't support it yet). It also used on the
A23, A33, A80, A83T, H3, and probably the H5 and A64.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

--jeum2g7ncqcdbp47
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJZWimhAAoJEBx+YmzsjxAgUCkP/1MHevXgOf3eOtYakzxABjM+
+da+5c+evjhqmdeCEPk8fGn42PrZdr3J6o5bbrtGEumzOHVdAFMsHEFpgthrzVp7
XNbeACxkSs1kjPzxPfOQoY73FMXcwNMqqbrxnwASfj/4gLHcsY4qF6cl4BseFmr4
XvnaMbAYpz2uvyXpMtvNj2qs/a6BsD6Xa8iWXeHqyOpDFurPMTqPLgQSCgAo4ZRB
m1DAHT2cpOUjy8fP5d+nLTkin2mqz2PKDwrQhv4O5qkfnVfcs7BpoIAiYRdCxiL6
JNx9q8EyAyI36lF2ahdFXKmgiQZhZIitSSNiPMTAYhMcP6IgJ4IgvnNrea1zlYCN
lZtGTTraxJzjtrxsxAit4QZwXwS8AbJTTF6GEJt+4tGBZNpd6qckVnTT4QLHaDKd
iEPmAGnhZqYWJbCbkXmP5w+bOIaIn3ywTB71cPSdEFeecMr27qt9IFaFfdjzcw7b
QgpjF6NeOMHuPB6ug8NWSbSbKyFtw7FJP584zaDfUCDLTLyU49zwaASFrzvscFYJ
2rBQLCsuzGdn7G6S0p4Q8WpxIc12Hlwv4QqZyf7p/MG5lAThLUjMucutz6aZjLNl
FBua4cdd6u0+YBR/gCHm2+ndptVkIhpdInjXA0aSZY4CWDrj9fMQ9766Vj1reGak
rrm1UPyIu2KgQ5rsWur6
=YfyO
-----END PGP SIGNATURE-----

--jeum2g7ncqcdbp47--
