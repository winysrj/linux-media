Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:54171 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758061Ab3LFORk (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Dec 2013 09:17:40 -0500
Date: Fri, 6 Dec 2013 15:16:35 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Lucas Stach <l.stach@pengutronix.de>
Cc: Denis Carikli <denis@eukrea.com>, Marek Vasut <marex@denx.de>,
	Mark Rutland <mark.rutland@arm.com>,
	devel@driverdev.osuosl.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Eric =?utf-8?Q?B=C3=A9nard?= <eric@eukrea.com>,
	Pawel Moll <pawel.moll@arm.com>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Rob Herring <rob.herring@calxeda.com>,
	devicetree@vger.kernel.org, dri-devel@lists.freedesktop.org,
	Sascha Hauer <kernel@pengutronix.de>,
	linux-media@vger.kernel.org,
	driverdev-devel@linuxdriverproject.org,
	linux-arm-kernel@lists.infradead.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: Re: [PATCHv5][ 2/8] staging: imx-drm: Add RGB666 support for
 parallel display.
Message-ID: <20131206141635.GB32313@ulmo.nvidia.com>
References: <1386268092-21719-1-git-send-email-denis@eukrea.com>
 <1386268092-21719-2-git-send-email-denis@eukrea.com>
 <20131206131403.GA30960@ulmo.nvidia.com>
 <1386336562.4088.5.camel@weser.hi.pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WYTEVAkct0FjGQmd"
Content-Disposition: inline
In-Reply-To: <1386336562.4088.5.camel@weser.hi.pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--WYTEVAkct0FjGQmd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 06, 2013 at 02:29:22PM +0100, Lucas Stach wrote:
> Am Freitag, den 06.12.2013, 14:14 +0100 schrieb Thierry Reding:
> > On Thu, Dec 05, 2013 at 07:28:06PM +0100, Denis Carikli wrote:
> > [...]
> > > diff --git a/drivers/staging/imx-drm/ipu-v3/ipu-dc.c b/drivers/stagin=
g/imx-drm/ipu-v3/ipu-dc.c
> > [...]
> > > @@ -155,6 +156,8 @@ static int ipu_pixfmt_to_map(u32 fmt)
> > >  		return IPU_DC_MAP_BGR666;
> > >  	case V4L2_PIX_FMT_BGR24:
> > >  		return IPU_DC_MAP_BGR24;
> > > +	case V4L2_PIX_FMT_RGB666:
> > > +		return IPU_DC_MAP_RGB666;
> >=20
> > Why is this DRM driver even using V4L2 pixel formats in the first place?
> >=20
> Because imx-drm is actually a misnomer. The i.MX IPU is a multifunction
> device, which as one part has the display controllers, but also camera
> interfaces and mem-to-mem scaler devices, which are hooked up via the
> V4L2 interface.
>=20
> The generic IPU part, which is used for example for programming the DMA
> channels is using V4L2 pixel formats as a common base. We have patches
> to split this out and make this fact more visible. (The IPU core will be
> placed aside the Tegra host1x driver)

Have you considered splitting thing up further and move out the display
controller driver to DRM and the camera driver to V4L2? I mean, if that
is even possible with a reasonable amount of work.

Is the "mem-to-mem" the same as the "DMA channels" you mentioned? If it
only does DMA, why does it even need to worry about pixel formats?

Thierry

--WYTEVAkct0FjGQmd
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSodxCAAoJEN0jrNd/PrOh1DkP/ipc+rQpgEneNY0LjpNCfBvV
1tfUV1IMW53DSwezVzKwXZ0zEQMGet+0oaZTkq7tkBSZFDjTjfC31DIHwbcvSGCC
7FXE4O20l3jGekny2UCAbjMbyqZGQ9FOIQO7X/R7sq0LudaHnjZW1F5P1xhUGe7t
6P+ej1DyL6jkwBsG9PRiVDNwSJnSZV1MgPZ3I6/ihYsfO7AAuOKnitmAwNXAbRon
dDURlyjj9e6nFweNe1NNfVOj/4HdNv8uXme+jp5aoVpPj3sYvPLNDcemd/D7TmnA
JSo2MI7MG/8Vl4VurzmwrovewmCFySPsgyO1JNULl6BHeojDMv7xRjz7BED55FJr
O4KxNYm85xnQ8cBvWqiFSD9oiZdCRNPa3PbuUxD1xE+X+ZiLG6iPvAY8hztBAM9G
oTbIMUuyvtbC+6p9v1336o7jpzUburlZVji0MR4a2PEYt+tMKKY/DW1mUyo14N1C
5WlAcOo9Pijt3LSOga/rYQj34/KUEPIrE4APQWde+8x8u+DzuQXQFWp7Xz5W4/k2
GVO8XQGiRFTJ2MYRIdaA7Upww4/oZONcVeOw4Wu0K/iHfYnOhoDqSdTissSqqvlK
li0ZTlgRtwy/238X3Y8q3MDWHZxZaOqT5YtNEQzygr06Xe0qH8p9Tw2Bs29iUpkG
ESAEPRQ6CkK9eX20KllO
=OjnS
-----END PGP SIGNATURE-----

--WYTEVAkct0FjGQmd--
