Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:42813 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751682AbeAYK5c (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 25 Jan 2018 05:57:32 -0500
Date: Thu, 25 Jan 2018 11:57:20 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: dri-devel@lists.freedesktop.org,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-renesas-soc@vger.kernel.org, Ben Skeggs <bskeggs@redhat.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Alexandru Gheorghe <Alexandru_Gheorghe@mentor.com>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH/RFC 4/4] drm: rcar-du: Add support for color keying on
 Gen3
Message-ID: <20180125105720.zey6c67jf23hlg6z@flea.lan>
References: <20171217001724.1348-1-laurent.pinchart+renesas@ideasonboard.com>
 <20171217001724.1348-5-laurent.pinchart+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="n4koyawtsohwbygi"
Content-Disposition: inline
In-Reply-To: <20171217001724.1348-5-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--n4koyawtsohwbygi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Sun, Dec 17, 2017 at 02:17:24AM +0200, Laurent Pinchart wrote:
> +static const struct drm_prop_enum_list colorkey_modes[] =3D {
> +	{ 0, "disabled" },
> +	{ 1, "source" },
> +};
> +
>  int rcar_du_vsp_init(struct rcar_du_vsp *vsp, struct device_node *np,
>  		     unsigned int crtcs)
>  {
> @@ -441,6 +453,10 @@ int rcar_du_vsp_init(struct rcar_du_vsp *vsp, struct=
 device_node *np,
>  					   rcdu->props.alpha, 255);
>  		drm_plane_create_zpos_property(&plane->plane, 1, 1,
>  					       vsp->num_planes - 1);
> +		drm_plane_create_colorkey_properties(&plane->plane,
> +						     colorkey_modes,
> +						     ARRAY_SIZE(colorkey_modes),
> +						     true);

You seem to define the same list in your enumeration between your
patch 2 and this one. Can this be something made generic too?

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

--n4koyawtsohwbygi
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEE0VqZU19dR2zEVaqr0rTAlCFNr3QFAlppuA8ACgkQ0rTAlCFN
r3Qy+g/7B1jzNP8yUBb4/Yv05AF5kRfzAbVB01XaJWhUTXyK5L6gTrYD37N7YNES
LMulrX77o/DwacUiGoOt8iHZ0MDNJHdTDHUornPXKq2sxE6WTPBgDP100U5Cu0i2
On6clRVsqxpmKq5+hCs55Ux0OY9o6n+27tJ12Qsxi9f86qi1cFjkXmD/A2VDoiRm
I8K8lk8xDfbWImTAHe6TeOIziIAscpzaoU3wkvFIsGZh7ZQwgO5JZTXxsd4klQlI
UfrUrm5wxZ4m+mr+rLQjF1hjahgqmwZ+Jom01WZy+D/jSQu0TdzebnVn4YciQzdm
3HNwgkhKUkYNvmpc1fCd2WBy/h2ozZM+qywwiW1oFaz4ldyDtaJryA9aTX9UMnPQ
q8CzsWZo0FRU+WmDy2Fd1ODMShffeVul8pc/FHMlR3vZz9Deb/+sXGZurV1G0d4C
r2Plotuh/YCHbzJ6UjGx1NKpMW5+TtnQeklHKUr35gc5CJMm/jspts5Gm4apAv3o
MTc2jNtVLPfBumxODL/EKxC0LdSRHr7HJwMXprrrz510dXPnp46f3MNBG6ZS2BnZ
8WvYlRAGeSoqOjV0cM78TxUYBzHa9jY6gDUgQtsTiUtXiA1T7s7NqUy5X4ReBgx4
u9t+XvqZ9u9wA+DhykVXTJEOSNjtNmttVIB1dcl8gny+T3IvYIs=
=gf5T
-----END PGP SIGNATURE-----

--n4koyawtsohwbygi--
