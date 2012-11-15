Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:51955 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423250Ab2KOKYV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Nov 2012 05:24:21 -0500
Date: Thu, 15 Nov 2012 11:24:11 +0100
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
Subject: Re: [PATCH v10 0/6] of: add display helper
Message-ID: <20121115102411.GA17272@avionic-0098.mockup.avionic-design.de>
References: <1352971437-29877-1-git-send-email-s.trumtrar@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3V7upXqbjpZ4EhLz"
Content-Disposition: inline
In-Reply-To: <1352971437-29877-1-git-send-email-s.trumtrar@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--3V7upXqbjpZ4EhLz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 15, 2012 at 10:23:51AM +0100, Steffen Trumtrar wrote:
> Hi!
>=20
> Changes since v9:
> 	- don't leak memory when previous timings were correct
> 	- CodingStyle fixes
> 	- move blank lines around
>=20
> Regards,
> Steffen
>=20
>=20
> Steffen Trumtrar (6):
>   video: add display_timing and videomode
>   video: add of helper for videomode
>   fbmon: add videomode helpers
>   fbmon: add of_videomode helpers
>   drm_modes: add videomode helpers
>   drm_modes: add of_videomode helpers
>=20
>  .../devicetree/bindings/video/display-timings.txt  |  107 ++++++++++
>  drivers/gpu/drm/drm_modes.c                        |   70 +++++++
>  drivers/video/Kconfig                              |   19 ++
>  drivers/video/Makefile                             |    4 +
>  drivers/video/display_timing.c                     |   24 +++
>  drivers/video/fbmon.c                              |   86 ++++++++
>  drivers/video/of_display_timing.c                  |  212 ++++++++++++++=
++++++
>  drivers/video/of_videomode.c                       |   47 +++++
>  drivers/video/videomode.c                          |   45 +++++
>  include/drm/drmP.h                                 |   12 ++
>  include/linux/display_timing.h                     |   69 +++++++
>  include/linux/fb.h                                 |   12 ++
>  include/linux/of_display_timings.h                 |   20 ++
>  include/linux/of_videomode.h                       |   17 ++
>  include/linux/videomode.h                          |   40 ++++
>  15 files changed, 784 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/video/display-timin=
gs.txt
>  create mode 100644 drivers/video/display_timing.c
>  create mode 100644 drivers/video/of_display_timing.c
>  create mode 100644 drivers/video/of_videomode.c
>  create mode 100644 drivers/video/videomode.c
>  create mode 100644 include/linux/display_timing.h
>  create mode 100644 include/linux/of_display_timings.h
>  create mode 100644 include/linux/of_videomode.h
>  create mode 100644 include/linux/videomode.h

With the one change that I pointed out, the whole series:

Reviewed-by: Thierry Reding <thierry.reding@avionic-design.de>
Acked-by: Thierry Reding <thierry.reding@avionic-design.de>

--3V7upXqbjpZ4EhLz
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQpMLLAAoJEN0jrNd/PrOhkDAP/RjTC5GwaxHO5Ry9OyHH1O39
yoBYhab3iNYiUAtjw//bZBxpsQuQoWb22MHzouE0eXEBn042UuTj06UBT/oEk4kb
Y+j45BWvXFmNsbBMSz4nJdi/ZzkU8bgBrhaSQ4U0j3mgKXuLkh7gzxJSYaksDzHk
lAkLf378mVx8tC5Fch65tJOAVuocGKh5Vie3wmSDOMJ7nBFFyYZoq7F6JhebfMRa
E24T5Pi7oOteqWrGFplAeVRLHmuMdqZC9s5BXBfffBenRzNjOuqAyw+dXQaSkY4l
lGLex9G6QBy0A65AWw7WTjp0qa53z6SVZwr+3ufO/zhBwrmEzp6JnBRfkh7lYzMl
XOmKFcgs5v0FsBNJCIbFtzcBainOCfxMgUTH5exbAH6l7xMTMtfoU+Oavpyc/H4k
zZpzlEvHihPIC+aoZnTnFld/UBEKw6K7z/Tvqu4iQEntxhQ2Xl9htH7Mv45vEaNT
1IAdJTZjs5HH/NxM4sHnru4T3pL4Prrorbx6ZaV+qI4exY803iWSunbRkngroZN2
0lRcaNJTRyEd4QvRiZLYwBxZe+ZhihRyGvQYVu/SnUes7mMWXRHcwnLQwWhovg1v
8tH2UnLUridwZsCH6NFA82z5MfHipmcVcYWcvF3LtCxw7KBSx7DqdV9oj9woz9Ou
4vNrW018Kl3rNvmAiLZj
=ayMQ
-----END PGP SIGNATURE-----

--3V7upXqbjpZ4EhLz--
