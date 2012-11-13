Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:54287 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752862Ab2KMLXC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Nov 2012 06:23:02 -0500
Date: Tue, 13 Nov 2012 12:22:58 +0100
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
Subject: Re: [PATCH v8 3/6] fbmon: add videomode helpers
Message-ID: <20121113112257.GB30049@avionic-0098.mockup.avionic-design.de>
References: <1352734626-27412-1-git-send-email-s.trumtrar@pengutronix.de>
 <1352734626-27412-4-git-send-email-s.trumtrar@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KFztAG8eRSV9hGtP"
Content-Disposition: inline
In-Reply-To: <1352734626-27412-4-git-send-email-s.trumtrar@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--KFztAG8eRSV9hGtP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 12, 2012 at 04:37:03PM +0100, Steffen Trumtrar wrote:
[...]
> +#if IS_ENABLED(CONFIG_VIDEOMODE)
> +int videomode_to_fb_videomode(struct videomode *vm, struct fb_videomode =
*fbmode)

The other helpers are named <destination-type>_from_<source-type>(),
maybe this should follow that example for consistency?

> +{
> +	fbmode->xres =3D vm->hactive;
> +	fbmode->left_margin =3D vm->hback_porch;
> +	fbmode->right_margin =3D vm->hfront_porch;
> +	fbmode->hsync_len =3D vm->hsync_len;
> +
> +	fbmode->yres =3D vm->vactive;
> +	fbmode->upper_margin =3D vm->vback_porch;
> +	fbmode->lower_margin =3D vm->vfront_porch;
> +	fbmode->vsync_len =3D vm->vsync_len;
> +
> +	fbmode->pixclock =3D KHZ2PICOS(vm->pixelclock / 1000);
> +
> +	fbmode->sync =3D 0;
> +	fbmode->vmode =3D 0;
> +	if (vm->hah)
> +		fbmode->sync |=3D FB_SYNC_HOR_HIGH_ACT;
> +	if (vm->vah)
> +		fbmode->sync |=3D FB_SYNC_VERT_HIGH_ACT;
> +	if (vm->interlaced)
> +		fbmode->vmode |=3D FB_VMODE_INTERLACED;
> +	if (vm->doublescan)
> +		fbmode->vmode |=3D FB_VMODE_DOUBLE;
> +	if (vm->de)
> +		fbmode->sync |=3D FB_SYNC_DATA_ENABLE_HIGH_ACT;
> +	fbmode->refresh =3D 60;

Can the refresh rate not be computed from the pixel clock and the
horizontal and vertical timings?

> +	fbmode->flag =3D 0;
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(videomode_to_fb_videomode);
> +#endif
> +
> +

There's a gratuitous blank line here.

>  #else
>  int fb_parse_edid(unsigned char *edid, struct fb_var_screeninfo *var)
>  {
> diff --git a/include/linux/fb.h b/include/linux/fb.h
> index c7a9571..46c665b 100644
> --- a/include/linux/fb.h
> +++ b/include/linux/fb.h
> @@ -714,6 +714,8 @@ extern void fb_destroy_modedb(struct fb_videomode *mo=
dedb);
>  extern int fb_find_mode_cvt(struct fb_videomode *mode, int margins, int =
rb);
>  extern unsigned char *fb_ddc_read(struct i2c_adapter *adapter);
> =20
> +extern int videomode_to_fb_videomode(struct videomode *vm, struct fb_vid=
eomode *fbmode);
> +

Should you provide a dummy in the !CONFIG_VIDEOMODE case?

Thierry

--KFztAG8eRSV9hGtP
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQoi2RAAoJEN0jrNd/PrOhQhEP/0ss30p/PXakRkp0f0Ghd+jA
dcak0RUWx2VT2NCDwuCmdIikymiNwRvoZFEcN1/H2UhkYfOvNa5PplmEGxp7LNdY
wDiJ0H24Rrak4rrA5G1CQ11kFGYAGBIN68S8/rM9vfWsNx7fuZJlKeLpKYeyy1W8
MQE4n7DpgAWUjpVKHkwObDjM57NIsjWg6fIUqIUm802hu5hFYqwSPntyjhmK2k8F
KdmWVnvFm7VBJNJniEkegbTjwgA9bpXfJq7muvheGHkmHc0CMUAJ6is0/58ORH8T
k7mkEpg3IEpnZyqkt/qcmELoHzARmCVwnyORsKv+KpGLgvKMDl/PR5tWI4Vu9Rhc
kClPnJsCdM52ahwMD277XoCC659BO4frgO9lYbp4D9JFnsJ5vttUlo1EzVSizWOh
CfkCFrlN38baPIl/6YBJSvL8KdeoKk/CL80TfP+NPU3+4YnqW5202QGO28QAI/I1
sX2PdMaTp7r0CpnxqAw7cZI8xxNDUVVR6O/2sOZz7cejwg0vMBAGGQeHS23pW1/+
J6apPWWJDQqldNApV/onessOOkunR2sywCXrlcbkWSLHQ62a9XwJUpN/SDWPDNFw
MpdeaQWDcU2ZWXYx4a9Tkrqg8qY8B4yZ+ReirZaJQOBuu69rKd02dY36Qjq/EcBZ
7hUGDjxZS9yUXlzj1ASk
=N6+0
-----END PGP SIGNATURE-----

--KFztAG8eRSV9hGtP--
