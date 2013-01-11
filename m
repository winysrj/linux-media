Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([93.93.135.160]:33903 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755009Ab3AKLIs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Jan 2013 06:08:48 -0500
Message-ID: <1357902525.6914.139.camel@thor.lan>
Subject: Re: FIMC/CAMIF V4L2 driver
From: Sebastian =?ISO-8859-1?Q?Dr=F6ge?=
	<sebastian.droege@collabora.co.uk>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: sylvester.nawrocki@gmail.com, LMML <linux-media@vger.kernel.org>,
	linux-samsung-soc <linux-samsung-soc@vger.kernel.org>
Date: Fri, 11 Jan 2013 12:08:45 +0100
In-Reply-To: <50EFEBF7.4080801@samsung.com>
References: <1356685333.4296.92.camel@thor.lan>
	 <50EFEBF7.4080801@samsung.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-iokH9KH5og0QCgxmLBHd"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-iokH9KH5og0QCgxmLBHd
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fr, 2013-01-11 at 11:39 +0100, Sylwester Nawrocki wrote:
> Hi Sebastian,
>=20
> Cc: <linux-media@vger.kernel.org>
>=20
> On 12/28/2012 10:02 AM, Sebastian Dr=C3=B6ge wrote:
> > Hi Sylwester,
> >=20
> > Kamil Debski told me that you should be able to help me with any issues
> > about the FIMC/CAMIF V4L2 driver. I'm currently using it on Exynos 4
> > hardware and wrote a GStreamer plugin using it (and the MFC driver).
> >=20
> > So far everything works great but I found a bug in the driver. When
> > configuring the CAPTURE side to use the pixel format
> > V4L2_PIX_FMT_YUV420M the strides that are reported are wrong.
> >=20
> > I get them by setting a v4l2_format with VIDIOC_S_FMT and having the
> > fmt.pix_mp.plane_fmt[X].bytesperline set to zero. The value set there
> > after the ioctl is correct for the luma plane but has the same value fo=
r
> > the chroma planes while it should be the half.
> > By using a stride that is half the value I can get valid and usable
> > output.
> >=20
> > For V4L2_PIX_FMT_NV12MT and V4L2_PIX_FMT_NV12M these stride values are
> > correct, so maybe a check for V4L2_PIX_FMT_YUV420M is missing somewhere
> > to divide by two for the chroma planes.
>=20
> Thank you for the bug report. And sorry for the delay..
>=20
> The driver sets same bytesperline value for each plane, since I found
> definition of this parameter very vague for planar formats, especially
> the macro-block ones, e.g. [1]. So it's really a feature, not a bug ;)
>=20
> Nevertheless, what the documentation [2] says is:
>=20
> "\bytesperline\    Distance in bytes between the leftmost pixels in two
> adjacent lines."
> ...
>=20
> "When the image format is planar the bytesperline value applies to the
> largest plane and is divided by the same factor as the width field for
> any smaller planes. For example the Cb and Cr planes of a YUV 4:2:0 image
> have half as many padding bytes following each line as the Y plane. To
> avoid ambiguities drivers must return a bytesperline value rounded up to
> a multiple of the scale factor."
>=20
> Then, for V4L2_PIX_FMT_NV12M format bytesperline for both planes should b=
e
> same, since according to the format definition chroma and luma plane widt=
h
> are same.
>=20
> For V4L2_PIX_FMT_YUV420M the Cr and Cb plane is half the width and half
> the height of the image (Y plane). I agree the bytesperline of the chroma
> should be half of that of luma plane.
>=20
> Please let me know if this patch helps:
> http://patchwork.linuxtv.org/patch/16205

Thanks, especially for the long explanation of why it is like this :)

I can't test the patch right now but it should do almost the right
thing. IMHO for the chroma planes the bytesperline should be (width
+1)/2, otherwise you'll miss one chroma value per line for odd widths.


However I also noticed another bug. Currently S_FMT happily allows
V4L2_PIX_FMT_BGR32, V4L2_PIX_FMT_BGR24, V4L2_PIX_FMT_RGB24 and probably
others. But the output will be distorted and useless.
(V4L2_PIX_FMT_RGB32 works perfectly fine)


BR,
Sebastian

--=-iokH9KH5og0QCgxmLBHd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEABECAAYFAlDv8r0ACgkQBsBdh1vkHyE4LQCdGPzmurjeUOFqR7jIPWpIIQbd
NxYAn1NpRlGQFsxgbgsfGONjvnL/pCO3
=ALWH
-----END PGP SIGNATURE-----

--=-iokH9KH5og0QCgxmLBHd--

