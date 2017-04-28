Return-path: <linux-media-owner@vger.kernel.org>
Received: from fllnx209.ext.ti.com ([198.47.19.16]:19263 "EHLO
        fllnx209.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756328AbdD1LMU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 28 Apr 2017 07:12:20 -0400
Subject: Re: [PATCH 1/8] arm: omap4: enable CEC pin for Pandaboard A4 and ES
To: Hans Verkuil <hverkuil@xs4all.nl>, <linux-media@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>
References: <20170414102512.48834-1-hverkuil@xs4all.nl>
 <20170414102512.48834-2-hverkuil@xs4all.nl>
CC: <dri-devel@lists.freedesktop.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
Message-ID: <4355dab4-9c70-77f7-f89b-9a1cf24976cf@ti.com>
Date: Fri, 28 Apr 2017 14:11:23 +0300
MIME-Version: 1.0
In-Reply-To: <20170414102512.48834-2-hverkuil@xs4all.nl>
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature";
        boundary="aA1m4eAOcPaAD7cELsF8VswSLkEX7b62n"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--aA1m4eAOcPaAD7cELsF8VswSLkEX7b62n
Content-Type: multipart/mixed; boundary="08jbHHw09o1VHUQRSUiBkasSQVb4I9qPj";
 protected-headers="v1"
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
 Tony Lindgren <tony@atomide.com>
Cc: dri-devel@lists.freedesktop.org, Hans Verkuil <hans.verkuil@cisco.com>,
 "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Message-ID: <4355dab4-9c70-77f7-f89b-9a1cf24976cf@ti.com>
Subject: Re: [PATCH 1/8] arm: omap4: enable CEC pin for Pandaboard A4 and ES
References: <20170414102512.48834-1-hverkuil@xs4all.nl>
 <20170414102512.48834-2-hverkuil@xs4all.nl>
In-Reply-To: <20170414102512.48834-2-hverkuil@xs4all.nl>

--08jbHHw09o1VHUQRSUiBkasSQVb4I9qPj
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 14/04/17 13:25, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
>=20
> The CEC pin was always pulled up, making it impossible to use it.
>=20
> Change to PIN_INPUT so it can be used by the new CEC support.
>=20
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  arch/arm/boot/dts/omap4-panda-a4.dts | 2 +-
>  arch/arm/boot/dts/omap4-panda-es.dts | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/arch/arm/boot/dts/omap4-panda-a4.dts b/arch/arm/boot/dts/o=
map4-panda-a4.dts
> index 78d363177762..f1a6476af371 100644
> --- a/arch/arm/boot/dts/omap4-panda-a4.dts
> +++ b/arch/arm/boot/dts/omap4-panda-a4.dts
> @@ -13,7 +13,7 @@
>  /* Pandaboard Rev A4+ have external pullups on SCL & SDA */
>  &dss_hdmi_pins {
>  	pinctrl-single,pins =3D <
> -		OMAP4_IOPAD(0x09a, PIN_INPUT_PULLUP | MUX_MODE0)	/* hdmi_cec.hdmi_ce=
c */
> +		OMAP4_IOPAD(0x09a, PIN_INPUT | MUX_MODE0)		/* hdmi_cec.hdmi_cec */
>  		OMAP4_IOPAD(0x09c, PIN_INPUT | MUX_MODE0)		/* hdmi_scl.hdmi_scl */
>  		OMAP4_IOPAD(0x09e, PIN_INPUT | MUX_MODE0)		/* hdmi_sda.hdmi_sda */
>  		>;
> diff --git a/arch/arm/boot/dts/omap4-panda-es.dts b/arch/arm/boot/dts/o=
map4-panda-es.dts
> index 119f8e657edc..940fe4f7c5f6 100644
> --- a/arch/arm/boot/dts/omap4-panda-es.dts
> +++ b/arch/arm/boot/dts/omap4-panda-es.dts
> @@ -34,7 +34,7 @@
>  /* PandaboardES has external pullups on SCL & SDA */
>  &dss_hdmi_pins {
>  	pinctrl-single,pins =3D <
> -		OMAP4_IOPAD(0x09a, PIN_INPUT_PULLUP | MUX_MODE0)	/* hdmi_cec.hdmi_ce=
c */
> +		OMAP4_IOPAD(0x09a, PIN_INPUT | MUX_MODE0)		/* hdmi_cec.hdmi_cec */
>  		OMAP4_IOPAD(0x09c, PIN_INPUT | MUX_MODE0)		/* hdmi_scl.hdmi_scl */
>  		OMAP4_IOPAD(0x09e, PIN_INPUT | MUX_MODE0)		/* hdmi_sda.hdmi_sda */
>  		>;
>=20

Reviewed-by: Tomi Valkeinen <tomi.valkeinen@ti.com>

Tony, can you queue this? It's safe to apply separately from the rest of
the HDMI CEC work.

 Tomi


--08jbHHw09o1VHUQRSUiBkasSQVb4I9qPj--

--aA1m4eAOcPaAD7cELsF8VswSLkEX7b62n
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJZAyNbAAoJEPo9qoy8lh71GjkQAJQJm01MMCVyp6t2bcApilKk
CLWU52jT1wd/rm5yaFhiPFUJBiNFHYLUsYnAsCBELkJizF+LdU63lYXwFUlU+Og+
T6vlDhwoA9HX0mWIJNRWEcFYT3FBE8BO8G7S04H8iFmLCIBBsS0i+p/as7mqPbPy
CrSKWVaOhF5jOjf0aw2DweZhNlIwCKpLSFfPXNVtBY+M/JxT9PztC7h7Fwo7UD4G
vqkFy4ZqAkKzGJ4ezrIpQ5VxiurChDhtmqThG41HHhbbPUlxT7xVVLOux3ZFJb93
hbpOKapAJKF6k0WWZKe7BVqgxtTyOWyoTjJEO1FHbjpqPLXOb2I7O0x5N+hjRC/5
XG1TCatvcKwY+WqWqJ4D82w11iUUTJ47mD443/o5aAZsT+bWkADPwHlUZBcspSw9
5qLHHTt6xpbUqISeNUebrj9XZfbdHL77VnIN7a7Vtq51CIDTHEAxzXRj0HNsenkR
X3gYtk/g8OWIK7FFCskrOPFR1UPe3kwDISibp6O0GTtfK32ma6fqM8b/KE3EWQkU
Yofz8cau+H8RazEbLKhtpFEgbDsuQ0l4IBDfeHpThkgv8fTtVNECZvjFmXmztE58
XaUwicgrbPoTjObEYM2+kivQ9iMZ1kpSwY67TVT402/5uwcuhIeRcdgXBMk1v2wo
V5A2PhSZOT0SgIdk/wDv
=werg
-----END PGP SIGNATURE-----

--aA1m4eAOcPaAD7cELsF8VswSLkEX7b62n--
