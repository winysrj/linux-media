Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:54552 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754783Ab2KMKmF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Nov 2012 05:42:05 -0500
Date: Tue, 13 Nov 2012 11:41:59 +0100
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
Message-ID: <20121113104159.GA18645@avionic-0098.mockup.avionic-design.de>
References: <1352734626-27412-1-git-send-email-s.trumtrar@pengutronix.de>
 <1352734626-27412-2-git-send-email-s.trumtrar@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="y0ulUmNC+osPPQO6"
Content-Disposition: inline
In-Reply-To: <1352734626-27412-2-git-send-email-s.trumtrar@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--y0ulUmNC+osPPQO6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 12, 2012 at 04:37:01PM +0100, Steffen Trumtrar wrote:
[...]
> diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
> index d08d799..2a23b18 100644
> --- a/drivers/video/Kconfig
> +++ b/drivers/video/Kconfig
> @@ -33,6 +33,12 @@ config VIDEO_OUTPUT_CONTROL
>  	  This framework adds support for low-level control of the video=20
>  	  output switch.
> =20
> +config DISPLAY_TIMING

DISPLAY_TIMINGS?

>  #video output switch sysfs driver
>  obj-$(CONFIG_VIDEO_OUTPUT_CONTROL) +=3D output.o
> +obj-$(CONFIG_DISPLAY_TIMING) +=3D display_timing.o

display_timings.o?

> +obj-$(CONFIG_VIDEOMODE) +=3D videomode.o
> diff --git a/drivers/video/display_timing.c b/drivers/video/display_timin=
g.c

display_timings.c?

> +int videomode_from_timing(struct display_timings *disp, struct videomode=
 *vm,
> +			  unsigned int index)

I find the indexing API a bit confusing. But that's perhaps just a
matter of personal preference.

Also the ordering of arguments seems a little off. I find it more
natural to have the destination pointer in the first argument, similar
to the memcpy() function, so this would be:

int videomode_from_timing(struct videomode *vm, struct display_timings *dis=
p,
			  unsigned int index);

Actually, when reading videomode_from_timing() I'd expect the argument
list to be:

int videomode_from_timing(struct videomode *vm, struct display_timing *timi=
ng);

Am I the only one confused by this?

> diff --git a/include/linux/display_timing.h b/include/linux/display_timin=
g.h

display_timings.h?

> +/* placeholder function until ranges are really needed=20

The above line has trailing whitespace. Also the block comment should
have the opening /* on a separate line.

> + * the index parameter should then be used to select one of [min typ max]

If index is supposed to select min, typ or max, then maybe an enum would
be a better candidate? Or alternatively provide separate accessors, like
display_timing_get_{minimum,typical,maximum}().

> + */
> +static inline u32 display_timing_get_value(struct timing_entry *te,
> +					   unsigned int index)
> +{
> +	return te->typ;
> +}
> +
> +static inline struct display_timing *display_timings_get(struct display_=
timings *disp,
> +							 unsigned int index)
> +{
> +	if (disp->num_timings > index)
> +		return disp->timings[index];
> +	else
> +		return NULL;
> +}
> +
> +void timings_release(struct display_timings *disp);

This function no longer exists.

Thierry

--y0ulUmNC+osPPQO6
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQoiP3AAoJEN0jrNd/PrOhtfgQALgmaNdfNzpfBJ/Jg/3kgWDh
TF3gGypoynS2vU0brqo8AkNJLcyxj1SpWLXbD/vOg7yoIMIrTphUilb/7zG2+jWr
9M8pPRLpjy8e67mSE6AE3bt/KIC8lo10sTambqLKlIUKLsJlyvsvx023xUVhgrOB
LV8y0uXiYms51ePH2+mgEDfVPE0W+szrbaJ9s9xW4J8FpnrwcMZM9yKT9eesVhdc
az8187GfyE/fqMB3sW6nShQbwF3rx/7CLIeQ8oiiUxeqLnW6vZ4jd6IVVj/3war7
wtYGOWXdbblBo9xi5UhMq+grO6i4uetFnf8G0RK4gs18eNEOSjorF0iUPcS6TcUE
Hd//uuyUboLhs/r5F8/g9hr8DCF7SuOVoWXmZOwqq3dgUGNNtenxsAZ171AiO3b0
hh04wX0oyGG53rk83Mw8L3Ek0hH11YlUaI2fHOldY23B9CCK3wxpNtbvBZNRpZjC
xOp4e9SQh9WouKjJpZWTBp7hQVxdUCtbrqcjF9Dmm2TddSEd0Q3EM08evr47YqMh
hszlG2Clz2UofdOq1SUTClxrL89Ta/b0OKgFoxJAfFKw+jV/3ofYCK/+Yzatpxl9
URyS/Uw9Wq1lRdDTPXhpuoci+1HPGd1Mnp9cxkyWtI8gLdVrr7uEwWLyDa3NlbKa
X/RvG8pcurYyfeE0F2wQ
=VsRp
-----END PGP SIGNATURE-----

--y0ulUmNC+osPPQO6--
