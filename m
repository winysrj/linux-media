Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:59774 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422711Ab2KNMuH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Nov 2012 07:50:07 -0500
Date: Wed, 14 Nov 2012 13:49:44 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Steffen Trumtrar <s.trumtrar@pengutronix.de>
Cc: devicetree-discuss@lists.ozlabs.org,
	Rob Herring <robherring2@gmail.com>,
	linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennady Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	Stephen Warren <swarren@wwwdotorg.org>, kernel@pengutronix.de
Subject: Re: [PATCH v9 5/6] drm_modes: add videomode helpers
Message-ID: <20121114124944.GF2803@avionic-0098.mockup.avionic-design.de>
References: <1352893403-21168-1-git-send-email-s.trumtrar@pengutronix.de>
 <1352893403-21168-6-git-send-email-s.trumtrar@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oPmsXEqKQNHCSXW7"
Content-Disposition: inline
In-Reply-To: <1352893403-21168-6-git-send-email-s.trumtrar@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--oPmsXEqKQNHCSXW7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 14, 2012 at 12:43:22PM +0100, Steffen Trumtrar wrote:
[...]
> diff --git a/drivers/gpu/drm/drm_modes.c b/drivers/gpu/drm/drm_modes.c
[...]
> @@ -504,6 +505,41 @@ drm_gtf_mode(struct drm_device *dev, int hdisplay, i=
nt vdisplay, int vrefresh,
>  }
>  EXPORT_SYMBOL(drm_gtf_mode);
> =20
> +#if IS_ENABLED(CONFIG_VIDEOMODE)
> +int display_mode_from_videomode(struct videomode *vm, struct drm_display=
_mode *dmode)

Given that this is still a DRM core function, maybe it should get a drm_
prefix? Also the line is too long, so you may want to wrap the argument
list.

Thierry

--oPmsXEqKQNHCSXW7
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQo5NoAAoJEN0jrNd/PrOhFRoQAKF/j89+6e4C2SmBB94S4u2p
d1UUxQK/eHjdYa295uNCDce3HKiq7jbY8WBTMpgo0Jubt4Y1R5swCxBTMHerVhzv
RvNa6bz3iUUu6vMf3xPXpib2QdE61vdrNSKS9jBHX1f8V0XdClCH51dNMQCWWz2X
AC34kr0y/4/iQKfMAq3q5E0MGAjglKCTF8VduudisKhiPMavC0ghykV0QYwsycYB
q+h9BDFZaYGWEjYNy7CoinR0fKHJwvWuLlppNiBDFcAqg5hEbvK2UnDdPD7fftgm
4Uumn09/i7HlSF+JsGk6JPx96QmXQVQXB0/2F6MdR72As3yzbsyBj30vDBo/DL+q
L0RdBu0JoNptivgXCcnx3q0a6eevYMDzA//d8Yqmqd9kQZrArAU/0FD4q+B+nwyO
xu/sAYl2xBvs8T5l8hP/8Jf+sgNAJ9d82CiH8n8e1GjHwMeG3uEMEu1mU4ENux/b
4B4RRco/3S/Cn83sy3RPccULFcZlBj5rauyHwl77/o04aOHVgzdZNziuYX5Zkg9b
LZOf0jzPI997/NIZdhJVVzIODkjOZyJ3xbj9NqFT2BQXv5+nOPXt4qcCjGschr2W
3nQpc+cVDEB99hAIcmm7skxkyAYBnLlunGtzxVXPXLpthGXBE1g0rs+yXOI6ZKXD
LawwaUis11jI1M6cutI+
=LI1y
-----END PGP SIGNATURE-----

--oPmsXEqKQNHCSXW7--
