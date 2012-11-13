Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:50852 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459Ab2KMLbl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Nov 2012 06:31:41 -0500
Date: Tue, 13 Nov 2012 12:31:14 +0100
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
Subject: Re: [PATCH v8 5/6] drm_modes: add videomode helpers
Message-ID: <20121113113114.GD30049@avionic-0098.mockup.avionic-design.de>
References: <1352734626-27412-1-git-send-email-s.trumtrar@pengutronix.de>
 <1352734626-27412-6-git-send-email-s.trumtrar@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hoZxPH4CaxYzWscb"
Content-Disposition: inline
In-Reply-To: <1352734626-27412-6-git-send-email-s.trumtrar@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--hoZxPH4CaxYzWscb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Nov 12, 2012 at 04:37:05PM +0100, Steffen Trumtrar wrote:
[...]
> diff --git a/drivers/gpu/drm/drm_modes.c b/drivers/gpu/drm/drm_modes.c
[...]
> +#if IS_ENABLED(CONFIG_VIDEOMODE)
> +int videomode_to_display_mode(struct videomode *vm, struct drm_display_mode *dmode)

This one as well may be more consistently named
drm_display_mode_from_videomode().

> diff --git a/include/drm/drmP.h b/include/drm/drmP.h
[...]
> +extern int videomode_to_display_mode(struct videomode *vm,
> +				     struct drm_display_mode *dmode);

And this also needs protection or a dummy.

Thierry

--hoZxPH4CaxYzWscb
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQoi+CAAoJEN0jrNd/PrOh7eEP/1UMe4mFQ4hylZL84gOC+gFV
urjbU7pSMMfg1z+pTabAq6g/fTlcCmzAW0tfdOjo78MCuyifOw/N9iTxOuWaCkUJ
VfMCyk5WIhRQWWjd66/FTuLjFRzMbb3bkKwIXxk9xLPDalWKBeBX3Cn79xxnWgEh
Zx9U4h+J6omaNhCgXyJEsZu8vdBSuXjTGzrnsVsCKYeHP7OUUDCH2YY7s8pWj7Sq
BuF6EN/Mhrk5vw+tJjXVuLVD57EvXnZyuRikvL3gF43Nvj0xKcPilRL1z1fWniyM
P3I7sQPB5W7gdxVQZM+KwLSiyX3D8y7apZJxlSaGD9/dXVC9YYiI+3qHbeDQnC/T
YkqSsiDvwFbg+PA4xN6eYOGNFjtDHmQhJ6cJUUAo7braP+CxYYO3tkrb4in89Dl/
CaPKtMUwFO3z8et0QkR7g7cAoSwN6EoeOLsFtVqaTWTNgz0VsvKm0pJSUdPRVQO1
IvdkH4XWke8gRGK6cHYru7g6NQMfl3Jnpf+VEAB96zYQaBELAZvwUFq15n2y4AMe
8CTsfEkbrpKHd547HhkWffijhX5ohPBgolMFUO7NKk9Sc1I+g1fdFYl25qiPba5w
I5BrSKfc4qwbPW6WC8ZbeBNzNGtp+nuyFn0hD9b2eLbo3qEavSwL+nfOdGUGSqSC
Qk5m+qY/BEv3W8VThjwO
=ul4+
-----END PGP SIGNATURE-----

--hoZxPH4CaxYzWscb--
