Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:52756 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752335Ab2KMLfd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Nov 2012 06:35:33 -0500
Date: Tue, 13 Nov 2012 12:35:18 +0100
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
Subject: Re: [PATCH v8 6/6] drm_modes: add of_videomode helpers
Message-ID: <20121113113518.GE30049@avionic-0098.mockup.avionic-design.de>
References: <1352734626-27412-1-git-send-email-s.trumtrar@pengutronix.de>
 <1352734626-27412-7-git-send-email-s.trumtrar@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wTWi5aaYRw9ix9vO"
Content-Disposition: inline
In-Reply-To: <1352734626-27412-7-git-send-email-s.trumtrar@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--wTWi5aaYRw9ix9vO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 12, 2012 at 04:37:06PM +0100, Steffen Trumtrar wrote:
[...]
> +#if IS_ENABLED(CONFIG_OF_VIDEOMODE)
> +static void dump_drm_displaymode(struct drm_display_mode *m)
> +{
> +	pr_debug("drm_displaymode =3D %d %d %d %d %d %d %d %d %d\n",
> +		 m->hdisplay, m->hsync_start, m->hsync_end, m->htotal,
> +		 m->vdisplay, m->vsync_start, m->vsync_end, m->vtotal,
> +		 m->clock);

I seem to remember a comment to an earlier version of this patch
requesting better formatting of this string. Alternatively you might
want to consider replacing it using drm_mode_debug_printmodeline().

> diff --git a/include/drm/drmP.h b/include/drm/drmP.h
[...]
> @@ -1457,6 +1458,10 @@ drm_mode_create_from_cmdline_mode(struct drm_devic=
e *dev,
> =20
>  extern int videomode_to_display_mode(struct videomode *vm,
>  				     struct drm_display_mode *dmode);
> +extern int of_get_drm_display_mode(struct device_node *np,
> +				   struct drm_display_mode *dmode,
> +				   int index);

Also requires either a dummy or protection.

Thierry

--wTWi5aaYRw9ix9vO
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQojB2AAoJEN0jrNd/PrOhgKEP/ApMZ4QWYnDY0Un0LZJl7xB1
AIBq5vHGG3JehdPpWnhPv00ygJ/3EUW5QfAulbXghP+/p6FXwBhPSEkyp68ALtUI
NgKib56DoWg1L0htQB7zbb/rzfypPHKKMWNRu50CiRt+aQ1FvGCvJJg3JrvPtmaQ
hPy26pPr36dbBNB2YZo2iEN+jMHqKfoXKd6H+5AN0fsn8fvUsOLyycUyH6fpX7TP
bzjh9hLTJrvrenII/IukfAwY1UPkq5v3RHfXD632kwTNKz3gVx3s5uPiAZqwIpSW
s/HIgXJxuJbgoWrs8ghPbTh5O2IwwC4mCUeUwWYzL9S4tDI2oZdEBIgi4HVXux0H
gpt5e3iip1f5vx3PYdw5qiWI0tnnemSiwTIJoNGuiM2L5BRkMUI/h5ni+CSKUprE
KkhDJ3qkfHjdcRri4NGHRM/Er7oOaRyz5Kl4Urxg5MN2xp53IvfjPDuJntIYpw8u
wO0nRvTjcASXJ4UjbKtZA6q1XsGDfiFHZa/lOokE1DMEDzDGOErITjEc92wIPGEs
/6w5iK8VZtEFC/sY2c8bNZE9tGfM530u+iUTrMLhYPmOAJfYpDOvfFlX+Bx40co2
HQbCa9zpl3iap/1ecmqm0A+nxSyRFzVdGgZBjeIyL80/J07qX0T9OqiotQRb+htY
z18U/Vqw8IoOeqn9WFuz
=FyzF
-----END PGP SIGNATURE-----

--wTWi5aaYRw9ix9vO--
