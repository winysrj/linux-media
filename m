Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:56852 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754540Ab2JTLEX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Oct 2012 07:04:23 -0400
Date: Sat, 20 Oct 2012 13:04:12 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Steffen Trumtrar <s.trumtrar@pengutronix.de>
Cc: devicetree-discuss@lists.ozlabs.org, linux-fbdev@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	Rob Herring <robherring2@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 2/2 v6] of: add generic videomode description
Message-ID: <20121020110412.GD12545@avionic-0098.mockup.avionic-design.de>
References: <1349373560-11128-1-git-send-email-s.trumtrar@pengutronix.de>
 <1349373560-11128-3-git-send-email-s.trumtrar@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eqp4TxRxnD4KrmFZ"
Content-Disposition: inline
In-Reply-To: <1349373560-11128-3-git-send-email-s.trumtrar@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--eqp4TxRxnD4KrmFZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Oct 04, 2012 at 07:59:20PM +0200, Steffen Trumtrar wrote:
[...]
> diff --git a/drivers/of/of_videomode.c b/drivers/of/of_videomode.c
[...]
> +#if defined(CONFIG_DRM)

This should be:

	#if IS_ENABLED(CONFIG_DRM)

or the code below won't be included if DRM is built as a module. But see
my other replies as to how we can probably handle this better by moving
this into the DRM subsystem.

> +int videomode_to_display_mode(struct videomode *vm, struct drm_display_mode *dmode)
> +{
> +	memset(dmode, 0, sizeof(*dmode));

It appears the usual method to obtain a drm_display_mode to allocate it
using drm_mode_create(), which will allocate it and associate it with
the struct drm_device.

Now, if you do a memset() on the structure you'll overwrite a number of
fields that have previously been initialized and are actually required
to get everything cleaned up properly later on.

So I think we should remove the call to memset().

> +int of_get_fb_videomode(struct device_node *np, struct fb_videomode *fb,
> +			int index)
> +{
[...]
> +}
> +EXPORT_SYMBOL_GPL(of_get_drm_display_mode);

This should be:

	EXPORT_SYMBOL_GPL(of_get_fb_videomode);

Thierry

--eqp4TxRxnD4KrmFZ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQgoUsAAoJEN0jrNd/PrOhSFMP/jzAZPZ2siklUDSk+eZWzZ4L
XKOeI/Kc6B2Z7I1gnVCytWObdm94G7gh0dlolvc4SI14ROsgtjfxUBDMRzMYgCuY
l6sO7GQbZcYOGpU/ePO74quZq4IwRaso3/s8kBLlqvIaQEmxWQUnFRQhx8+gPtSJ
YKDXVVkm+PfoFl+Ahefc+94FGuUCvgnqeJ5MYMR+9vUj/HnvKKS16QJGOwkqanI8
n9fhYyGJQd7FBJxlC/5JgC5qEWfhLZZYPzbZblpcVVA8Nkz+quwTgaZ2Vvt+BvNv
PSS3jfJoWI5U6JFf/Q5kuvmL57DAnM9YRcbi3zEJA0UUyx3iSm/WTLDfElbJP5uw
27G8h6mxRFyh+zMLqSF80PKXyYh3HEdm+GYOmjuzIHcTvl5MJqSdIcr7rEhdbq53
GgPo2l6A0vYLRRvP159JvxJN9UpzDDJ1Pe/GaLwVMtIl+hMK60sXgX5peB+pIn9U
tYtMkY7FjMRA6oiI358DQSF+zX0XD0gVhx2rQmm1Cdh+F0pwspxMtlKqWkA/kJg3
GggPzeJmYfjhW1FJj/76QL4GRF6kfhUJgvvRxd+We33voYFQc3ZJ+ulUAoUedA7L
KQovyYJ6oVxy0bQMgnsIzlUSizNlD1DQ7P6hyqEIppCghX21Cf2krMOeB9XXNnqN
4KiUmxvamwX56h+wwRAj
=A2e0
-----END PGP SIGNATURE-----

--eqp4TxRxnD4KrmFZ--
