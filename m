Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:58801 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932179Ab2KNK4p (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Nov 2012 05:56:45 -0500
Date: Wed, 14 Nov 2012 11:56:34 +0100
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
Subject: Re: [PATCH v8 1/6] video: add display_timing and videomode
Message-ID: <20121114105634.GA31801@avionic-0098.mockup.avionic-design.de>
References: <1352734626-27412-1-git-send-email-s.trumtrar@pengutronix.de>
 <1352734626-27412-2-git-send-email-s.trumtrar@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sm4nu43k4a2Rpi4c"
Content-Disposition: inline
In-Reply-To: <1352734626-27412-2-git-send-email-s.trumtrar@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--sm4nu43k4a2Rpi4c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Nov 12, 2012 at 04:37:01PM +0100, Steffen Trumtrar wrote:
[...]
> diff --git a/drivers/video/display_timing.c b/drivers/video/display_timing.c
[...]
> +void display_timings_release(struct display_timings *disp)
> +{
> +	if (disp->timings) {
> +		unsigned int i;
> +
> +		for (i = 0; i < disp->num_timings; i++)
> +			kfree(disp->timings[i]);
> +		kfree(disp->timings);
> +	}
> +	kfree(disp);
> +}

I think this is still missing an EXPORT_SYMBOL_GPL. Otherwise it can't
be used from modules.

Thierry

--sm4nu43k4a2Rpi4c
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQo3jiAAoJEN0jrNd/PrOh95kQAIn0EHH7Wu1eAXFCwc8RGpjw
TW01XmpxWIPUTyWS4K/K+HsE+0SLe8lJlTuESo/QReCvvo1AtSysTkSINT3fQ4tR
6Vq5cZ4KAKBMjCmi+rFcSZUdP/vfZDxQU4ZFzUzWzjSnU/ljbHzhkk7OnWKtezeL
vP8y9ay45G4kPbyq/7RmfzAktVqZapW85s1HRaA47sB03HpQ71QWVdvPi6LJCQNy
P+QhHlvyiw0qSeTMqwYciD74OY1yz3AlmG6oVC/Et3M225NyzL33YpAwzXL1xsXw
ds8qbfBzoRgEWwD8Mb/9bd+A6RPLnriWCZ3OJACwXrSc1tCbxdxdHWYpsuSo/LNO
Wvtmykn26yhhLO1g+pOTaFXBetiOq2iY3n4DCG0OvjYgIbrLs2e6lIDuLQO+56SV
8WjZXz/yCspz/zHrqFZIibhZCt8k3ojeVo2x/a7v2kyFq4KLNLUSrl9zaXxHs2Xf
od82kefModuc+BRjRlK8Dy9gO3xEOWtGKa/EE598fzkupEKPsVJcSOKb8yL+6vz6
wlvnYv5mnip9rlhLzm68XpRTkfwM9Bi2hl/fpq0P6s1rQ5c5+Lb0xhX2lKO5Fw0R
Gxz8RuJ0KvHgs0cUeeFOcMj2Zg1WVOeFvDnvYw8bK5nXydMI7dt4tqoL4RbP8f88
EyamFvUFjnpgXmx2QlTV
=GZec
-----END PGP SIGNATURE-----

--sm4nu43k4a2Rpi4c--
