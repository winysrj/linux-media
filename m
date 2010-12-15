Return-path: <mchehab@gaivota>
Received: from smtp208.alice.it ([82.57.200.104]:35029 "EHLO smtp208.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755781Ab0LOXtw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Dec 2010 18:49:52 -0500
Date: Thu, 16 Dec 2010 00:49:27 +0100
From: Antonio Ospite <ospite@studenti.unina.it>
To: Hans de Goede <hdegoede@redhat.com>
Cc: linux-media@vger.kernel.org
Subject: Re: Question about libv4lconvert.
Message-Id: <20101216004927.48944e00.ospite@studenti.unina.it>
In-Reply-To: <4D0920CC.7060004@redhat.com>
References: <20101215171139.b6c1f03a.ospite@studenti.unina.it>
	<4D0920CC.7060004@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__16_Dec_2010_00_49_28_+0100_cdqjIKJ/R8.y5Tgg"
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

--Signature=_Thu__16_Dec_2010_00_49_28_+0100_cdqjIKJ/R8.y5Tgg
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, 15 Dec 2010 21:10:52 +0100
Hans de Goede <hdegoede@redhat.com> wrote:

> Hi,
>

Hi Hans, thanks for the quick reply.
=20
> On 12/15/2010 05:11 PM, Antonio Ospite wrote:
> > Hi,
> >
> > I am taking a look at libv4lconvert, and I have a question about the
> > logic in v4lconvert_convert_pixfmt(), in some conversion switches there
> > is code like this:
> >
> > 	case V4L2_PIX_FMT_GREY:
> > 		switch (dest_pix_fmt) {
> > 		case V4L2_PIX_FMT_RGB24:
> > 	        case V4L2_PIX_FMT_BGR24:
> > 			v4lconvert_grey_to_rgb24(src, dest, width, height);
> > 			break;
> > 		case V4L2_PIX_FMT_YUV420:
> > 		case V4L2_PIX_FMT_YVU420:
> > 			v4lconvert_grey_to_yuv420(src, dest, fmt);
> > 			break;
> > 		}
> > 		if (src_size<  (width * height)) {
> > 			V4LCONVERT_ERR("short grey data frame\n");
> > 			errno =3D EPIPE;
> > 			result =3D -1;
> > 		}
> > 		break;
> >
> > However the conversion routines which are going to be called seem to
> > assume that the buffers, in particular the source buffer, are of the
> > correct full frame size when looping over them.
> >
>=20
> Correct, because they trust that the kernel drivers have allocated large
> enough buffers to hold a valid frame which is a safe assumption.
>

Maybe this was the piece I was missing: even a partial (useful) frame
comes in a full size buffer, right? If so then the current logic is sane
indeed; and if the current assumption in conversion routines is
contradicted then it must be due to a defect related to the kernel
driver.

>  > My question is: shouldn't the size check now at the end of the case
>  > block be at the _beginning_ of it instead, so to detect a short frame
>  > before conversion and avoid a possible out of bound access inside the
>  > conversion routine?
>=20
> This is done this way deliberately, this has to do with how the EPIPE
> errno variable is used in a special way.
>=20
> An error return from v4lconvert_convert with an errno of EPIPE means
> I managed to get some data for you but not an entire frame. The upper
> layers of libv4l will respond to this by retrying (getting another frame),
> but only a limited number of times. Once the retries are exceeded they
> will simply pass along whatever they did manage to get.
>

Ah, that's why you do the conversion even on partial frames, I think I
see now.

> The reason for this is that there can be bus errors or vsync issues (*),
> which lead to a short frame, which are intermittent errors. So detecting
> them and getting another frame is a good thing to do because usually the
> next frame will be fine. However sometimes there are cases where every
> single frame is a short frame, for example the zc3xx driver used to
> deliver jpeg's with only 224 lines of data when running at 320x240 with
> some sensors. Now one can argue that this is a driver issue, and it is
> but it still happens in this case it is much better to pass along
> the 224 lines which we did get, then to make this a fatal error.
>=20
> Note that due to the retries the user will get a much lower framerate,
> which together with the missing lines at the bottom + printing
> of error messages will hopefully be enough for the user to report
> a bug to us, despite him/her getting some picture.
>=20
> I hope this explains.
>

It does, thanks a lot.

> Regards,
>=20
> Hans
>=20
>=20
> *) While starting the stream it may take several frames for vsync to
> properly lock in some cases.
>=20

Regards,
   Antonio.


--=20
Antonio Ospite
http://ao2.it

PGP public key ID: 0x4553B001

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?

--Signature=_Thu__16_Dec_2010_00_49_28_+0100_cdqjIKJ/R8.y5Tgg
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk0JVAgACgkQ5xr2akVTsAGqSwCgnGCojt56AZMCrecofESGVYFZ
1TQAnA8yQOx3M1aGAfIB6LnaXsqOv9zd
=unuB
-----END PGP SIGNATURE-----

--Signature=_Thu__16_Dec_2010_00_49_28_+0100_cdqjIKJ/R8.y5Tgg--
