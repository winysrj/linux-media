Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f44.google.com ([209.85.214.44]:36425 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161424Ab3LFNPI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Dec 2013 08:15:08 -0500
Date: Fri, 6 Dec 2013 14:14:04 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Denis Carikli <denis@eukrea.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Marek Vasut <marex@denx.de>, devel@driverdev.osuosl.org,
	Rob Herring <rob.herring@calxeda.com>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	devicetree@vger.kernel.org, driverdev-devel@linuxdriverproject.org,
	David Airlie <airlied@linux.ie>,
	dri-devel@lists.freedesktop.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org, Sascha Hauer <kernel@pengutronix.de>,
	Shawn Guo <shawn.guo@linaro.org>,
	linux-arm-kernel@lists.infradead.org,
	Eric =?utf-8?Q?B=C3=A9nard?= <eric@eukrea.com>
Subject: Re: [PATCHv5][ 2/8] staging: imx-drm: Add RGB666 support for
 parallel display.
Message-ID: <20131206131403.GA30960@ulmo.nvidia.com>
References: <1386268092-21719-1-git-send-email-denis@eukrea.com>
 <1386268092-21719-2-git-send-email-denis@eukrea.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="u3/rZRmxL6MmkK24"
Content-Disposition: inline
In-Reply-To: <1386268092-21719-2-git-send-email-denis@eukrea.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--u3/rZRmxL6MmkK24
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Dec 05, 2013 at 07:28:06PM +0100, Denis Carikli wrote:
[...]
> diff --git a/drivers/staging/imx-drm/ipu-v3/ipu-dc.c b/drivers/staging/imx-drm/ipu-v3/ipu-dc.c
[...]
> @@ -155,6 +156,8 @@ static int ipu_pixfmt_to_map(u32 fmt)
>  		return IPU_DC_MAP_BGR666;
>  	case V4L2_PIX_FMT_BGR24:
>  		return IPU_DC_MAP_BGR24;
> +	case V4L2_PIX_FMT_RGB666:
> +		return IPU_DC_MAP_RGB666;

Why is this DRM driver even using V4L2 pixel formats in the first place?

Thierry

--u3/rZRmxL6MmkK24
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSoc2bAAoJEN0jrNd/PrOhHrwP/RHuIytU1Sx350RAonwEhjbe
hZZycaxb+1j5FPvcDhAW3Sx9+sTpqZlYFJMaT7YV5v87Wq0wfKN/oA3HYdOpJFwc
rmBcPw6Y+s4gXZPkdJcyD8y2rpaUZiyVKCNoTABuk3n+Ubpft9hqVsIX4Yry6Q/G
5Dn3okFO7CtIXbp4f45lJ14bCD+/g+akN8jOY3q3rwrfrgKkG2x+6LGEvxlKJbao
ZmitgdO1BrgkPNzJZIGU/odsIjLyPWXsCJa7Did3J5x5ajIoZq+LJkPkrvos7A4u
wIQZKjx9vMVgiVaaykLq8mgtbT0Q+68HVDad1Dw2XNuvbEmbpfsAbw/dcTVheSq3
7YHJLOCTM7vnW1BsxuQeKizRjJMg24tcNCqowD/oWEIZjDonoGruRBz5pC6y6csV
yg3m0pSkGkD25K5lZmAuJ/opLDUy4r7v9zTeMytqssyPeC6PjLKGdDzXXs79OHE+
DeXlnGA9xUt8fUx7SXy+MXspcGND/WQFsg1ZgPTv3/i21/uk7rmAuH0EijDJNh12
eXXqc6b7vLJ5n5wEPODRzn5j6wkTbDPn1kxe3oojWaLseda54uLZvVLfxBx/mOJG
cQ3GhkvL9tlRBtJ8Qp7AB+VIE5dSWLKa29c8A0tFKGlm5vR+fTCwWP9mfE85p3Pl
qSqMDDYRWZ9ML9/ZGffL
=pGqH
-----END PGP SIGNATURE-----

--u3/rZRmxL6MmkK24--
