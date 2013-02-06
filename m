Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:50348 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755350Ab3BFPAp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 6 Feb 2013 10:00:45 -0500
Message-ID: <51127008.7050808@ti.com>
Date: Wed, 6 Feb 2013 17:00:24 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
MIME-Version: 1.0
To: Alex Deucher <alexdeucher@gmail.com>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	<linux-fbdev@vger.kernel.org>,
	Sebastien Guiriec <s-guiriec@ti.com>,
	<dri-devel@lists.freedesktop.org>,
	Jesse Barnes <jesse.barnes@intel.com>,
	Benjamin Gaignard <benjamin.gaignard@linaro.org>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Tom Gall <tom.gall@linaro.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	<linux-media@vger.kernel.org>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Thierry Reding <thierry.reding@avionic-desi.gn.de>,
	Mark Zhang <markz@nvidia.com>,
	<linaro-mm-sig@lists.linaro.org>,
	=?ISO-8859-1?Q?St=E9phane_Marchesin?=
	<stephane.marchesin@gmail.com>,
	Alexandre Courbot <acourbot@nvidia.com>,
	Ragesh Radhakrishnan <Ragesh.R@linaro.org>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	Sunil Joshi <joshi@samsung.com>,
	Maxime Ripard <maxime.ripard@free-electrons.com>,
	Vikas Sajjan <vikas.sajjan@linaro.org>
Subject: Re: CDF meeting @FOSDEM report
References: <1990856.qS9uisuiVF@avalon> <51123A5F.9050604@ti.com> <CADnq5_P1GFbAwoe9kTeARq8ZLP1tOBc9Rn1h2KrRYxkoLxLXfw@mail.gmail.com>
In-Reply-To: <CADnq5_P1GFbAwoe9kTeARq8ZLP1tOBc9Rn1h2KrRYxkoLxLXfw@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="------------enigA28ED1DA762A810046D2ACDF"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--------------enigA28ED1DA762A810046D2ACDF
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 2013-02-06 16:44, Alex Deucher wrote:
> On Wed, Feb 6, 2013 at 6:11 AM, Tomi Valkeinen <tomi.valkeinen@ti.com> =
wrote:

>> What is an encoder? Something that takes a video signal in, and lets t=
he
>> CPU store the received data to memory? Isn't that a decoder?
>>
>> Or do you mean something that takes a video signal in, and outputs a
>> video signal in another format? (transcoder?)
>=20
> In KMS parlance, we have two objects a crtc and an encoder.  A crtc
> reads data from memory and produces a data stream with display timing.
>  The encoder then takes that datastream and timing from the crtc and
> converts it some sort of physical signal (LVDS, TMDS, DP, etc.).  It's

Isn't the video stream between CRTC and encoder just as physical, it
just happens to be inside the GPU?

This is the case for OMAP, at least, where DISPC could be considered
CRTC, and DSI/HDMI/etc could be considered encoder. The stream between
DISPC and DSI/HDMI is plain parallel RGB signal. The video stream could
as well be outside OMAP.

> not always a perfect match to the hardware.  For example a lot of GPUs
> have a DVO encoder which feeds a secondary encoder like an sil164 DVO
> to TMDS encoder.

Right. I think mapping the DRM entities to CDF ones is one of the bigger
question marks we have with CDF. While I'm no expert on DRM, I think we
have the following options:

1. Force DRM's model to CDF, meaning one encoder.

2. Extend DRM to support multiple encoders in a chain.

3. Support multiple encoders in a chain in CDF, but somehow map them to
a single encoder in DRM side.

I really dislike the first option, as it would severely limit where CDF
can be used, or would force you to write some kind of combined drivers,
so that you can have one encoder driver running multiple encoder devices.=


 Tomi



--------------enigA28ED1DA762A810046D2ACDF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with undefined - http://www.enigmail.net/

iQIcBAEBAgAGBQJREnAIAAoJEPo9qoy8lh71tHQP/jTAXINjpdJdFARlTztAuSXG
EZQnQvKvdUEJz96N1avraDYZtTma96VonJFSucZ0NiSU/vfxV4qQv26A3Tqxb+Yr
PhzWgH9L5mMgtYA8aKY/EBFG4qWKpkHHJVp63WyNdnExRBf2fHT5AuooQ9FigSPD
EBczM0EdV/Cey5UJidv3URjYLgGgfuT2McVWflq5LQzE+6vAjPuDBpDcu7WAAjqV
dj7Cg2fRFSICnrNoRLu08oOCNqqIfn8kFM2xbYCNSkkbMoY2pHgvVL/KspC7HvVw
kHKDCactA1WZdAuA/DSqNJsbBUVgZiw5pJjHD8u1SvYOUoCZA3CaZm9vc4OHg9Gb
yEo7YOPCWcwljI0RFwZrhCCJ9aINKklPx2LOiJ+eJ7zyp/3qPNmxxVTksfzdY8YR
SfMcchw2yB8tTcZaH1xI+lR2QFrCk+R79fe/0fpjRLLbMcelR4JZNX1z+w8XLakH
rJRPN2uXhs3+xNAGrnlfG8TMFm/HYIR5AZ4+T26nNLidFqBO7jFaGtLoGukOHqXw
8i4sangPD072Sjp2am7U2ud6FouWEClny1PlzKx2z/XbS4aOcoJHzZGPJBCDyGj+
uujdOzAeOIHnWQ+/6jLrj0OoHMLMHVNjdLhgxKi5fLtzaIN2Laf4+n8yonr6w8s2
zcOkoe7TUYrS0CYvoflC
=6uuz
-----END PGP SIGNATURE-----

--------------enigA28ED1DA762A810046D2ACDF--
