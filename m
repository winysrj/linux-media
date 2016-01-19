Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:53415 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932414AbcASXAY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jan 2016 18:00:24 -0500
Message-ID: <1453244418.5933.55.camel@collabora.com>
Subject: Re: V4L2 Colorspace for RGB formats
From: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Reply-To: Nicolas Dufresne <nicolas.dufresne@collabora.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Dimitrios Katsaros <patcherwork@gmail.com>,
	linux-media@vger.kernel.org
Date: Tue, 19 Jan 2016 18:00:18 -0500
In-Reply-To: <569EAF04.802@xs4all.nl>
References: <1453226443.5933.7.camel@collabora.com> <569EAF04.802@xs4all.nl>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-A6ynmtRKcTe+aKJHGvOT"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-A6ynmtRKcTe+aKJHGvOT
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le mardi 19 janvier 2016 =C3=A0 22:47 +0100, Hans Verkuil a =C3=A9crit=C2=
=A0:
> On 01/19/2016 07:00 PM, Nicolas Dufresne wrote:
> > Hi Hans,
> >=20
> > we are having issues in GStreamer with the colorspace in V4L2. The
> > API
> > does not provide any encoding for RGB formats.
>=20
> Which API? GStreamer or V4L2?
>=20
> > The encoding matrix for
> > those is usually the identity matrix, anything else makes very
> > little
> > sense to me.
>=20
> While normally RGB formats use the sRGB colorspace, this is by no
> means
> always the case. HDMI for example also supports AdobeRGB and BT2020
> RGB.
>=20
> > For example, vivid will declare a stream with RGB based
> > pixel format as having the default for sRGB colorspace, which lead
> > to
> > non-identity syCC encoding.
>=20
> I don't follow. sYCC is for YCbCr formats. RGB formats do not contain
> any
> information about YCbCr (i.e. the ycbcr_enc field should be ignored).
>=20
> If gstreamer wants to convert RGB formats to YCbCr formats, then it
> can
> choose whatever RGB->YCbCr conversion it wants.
>=20
> The colorspace (i.e. the chromaticities), xfer_func and quantization
> fields
> as reported by V4L2 are all still valid for RGB pixelformats.
>=20
> You need those as well: take an HDMI receiver that converts Y'CbCr to
> R'G'B'
> (let's be precise here and use the quote). If the input is HDTV using
> Rec.709, then the colorspace is set to V4L2_COLORSPACE_REC709 and the
> other
> fields are all 0 (DEFAULT). These map to XFER_FUNC_709 for the
> transfer
> function, QUANTIZATION_FULL_RANGE for the quantization and ycbcr_enc
> is
> ignored since there is nothing to do here (the Y'CbCr to R'G'B'
> conversion
> is already done in hardware using the Rec. 709 Y'CbCr encoding).
>=20
> If you would just ignore all fields and use COLORSPACE_SRGB, then you
> would be using the wrong transfer function (XFER_FUNC_SRGB instead of
> XFER_FUNC_709).
>=20
> > Shall we simply ignore the encoding set by drivers when the pixel
> > format is RGB based ? To me it makes very little sense, but the
> > code in
> > GStreamer is very generic and this wrong information lead to errors
> > when the data is converted to YUV and back to RGB.
>=20
> It seems to me that for RGB formats GStreamer should just set cinfo-
> >matrix
> (which I assume is the Y'CbCr to R'G'B' matrix) to the unity matrix
> and
> everything else follows the normal rules.

So you are saying that from V4L2 we may receive weird R'G'B data, like
one using limited range ? I believe what is hard to understand from
V4L2 documentation is what transformation is left to be applied before
this R'G'B frame can be used with other normalized frame (for mixing,
or display, or anything). Where did the conversion stopped, basically
what our converter still need to do to get things right.

Nicolas

p.s. meanwhile we just removed the colorimetry information from non
Y'CbCr pixel formats, as this brings back the behaviour prior to this.
--=-A6ynmtRKcTe+aKJHGvOT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEABECAAYFAlaewAIACgkQcVMCLawGqBzs3QCdGplXOXc+7GFrpN3kuh/nqzis
46AAnRTCvxePeiFkP/CQmEbCRTevT2rJ
=BSKc
-----END PGP SIGNATURE-----

--=-A6ynmtRKcTe+aKJHGvOT--

