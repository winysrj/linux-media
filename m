Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:61604 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756017Ab2KOJ7O (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Nov 2012 04:59:14 -0500
Date: Thu, 15 Nov 2012 10:58:49 +0100
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
Subject: Re: [PATCH v10 6/6] drm_modes: add of_videomode helpers
Message-ID: <20121115095848.GA31538@avionic-0098.mockup.avionic-design.de>
References: <1352971437-29877-1-git-send-email-s.trumtrar@pengutronix.de>
 <1352971437-29877-7-git-send-email-s.trumtrar@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bg08WKrSYDhXBjb5"
Content-Disposition: inline
In-Reply-To: <1352971437-29877-7-git-send-email-s.trumtrar@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--bg08WKrSYDhXBjb5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Nov 15, 2012 at 10:23:57AM +0100, Steffen Trumtrar wrote:
[...]
> +int of_get_drm_display_mode(struct device_node *np,
> +			    struct drm_display_mode *dmode, unsigned int index)
> +{
> +	struct videomode vm;
> +	int ret;
> +
> +	ret = of_get_videomode(np, &vm, index);
> +	if (ret)
> +		return ret;
> +
> +	display_mode_from_videomode(&vm, dmode);

This function is now called drm_display_mode_from_videomode().

Thierry

--bg08WKrSYDhXBjb5
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQpLzYAAoJEN0jrNd/PrOhmfYP/0DHD7I1jSNkjQaYPc0hW9Sa
KlRgpp741fKnmaiFt9Jaqk3qPIoWp0HmqNBx4Gzsb2r3dIZgUkwocuHcuktYqMB3
1RGIn2UYFON0rLjKZ97ZIAlCEMPt6NVWjFWSjscLVW5CLkzfmgq88l4qSRRgCnm+
alE0QMFhCUs/ivJjQjRXRF+Jshg3rXtizj4Sa43AY/uadUQHZJQfVajKrzjYBfFS
rN103jy0iu2JLYBKydbSB7tvJRHJst4OOaHmegD8194LCDKaoabDYVWQZXQnKGJ+
mzj1CjYQdpzQVf4AJ+9DOu1BRqWLS1sNR7GoTREuhhoT/bs3Si1YnEAWu5kO2red
IH/0R5soALEfQJ/NTM5nA67n4B7KcA25KofdSO7XJYu+Gexp1VoFLbqR2ILGarnH
knDh1Z4wRTxOUpYkfNdNpA0eM8wdjbv3pUOb2wthA841nXtYLuKPd/t/v/4vLCeu
00bgdBbsvBJdd6Uw08IgBmJ73srBWUHBCmAW05H+Mo3cPb4qP4rhhR9BbkIewHUx
daiLb/L82bwwl+hE/mrIFQxvhHcCzRH0vJ1OijhRw6WPgPFoSjm1TTSbR8199YEE
NCcluqDvs58jMQNFUPZGXGw7Rk0uoONGeyC/vj5Uvbbf/cNPQr8B4UIFpsaZ61/a
Qi9gczL5lOYYM88xup7u
=NTSA
-----END PGP SIGNATURE-----

--bg08WKrSYDhXBjb5--
