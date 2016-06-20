Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f49.google.com ([209.85.215.49]:33170 "EHLO
	mail-lf0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665AbcFTIQE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jun 2016 04:16:04 -0400
Received: by mail-lf0-f49.google.com with SMTP id f6so32623966lfg.0
        for <linux-media@vger.kernel.org>; Mon, 20 Jun 2016 01:15:53 -0700 (PDT)
Date: Mon, 20 Jun 2016 11:15:50 +0300
From: Pekka Paalanen <ppaalanen@gmail.com>
To: Rob Clark <robdclark@gmail.com>
Cc: Tom Cooksey <tom.cooksey@arm.com>,
	"linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
	"mesa-dev@lists.freedesktop.org" <mesa-dev@lists.freedesktop.org>,
	"dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Daniel Stone <daniel@fooishbar.org>,
	Emil Velikov <emil.velikov@collabora.co.uk>,
	Louis-Francis =?UTF-8?B?UmF0dMOp?= =?UTF-8?B?LUJvdWxpYW5uZQ==?=
	<louis-francis.ratte-boulianne@collabora.co.uk>
Subject: Re: [Mesa-dev] [RFC] New dma_buf -> EGLImage EGL extension - Final
 spec published!
Message-ID: <20160620111550.22068169@eldfell>
In-Reply-To: <CAF6AEGvAe8Q20B4rMcrrR+5Cqybdi=kwyBCR0187b9uc5X1mSQ@mail.gmail.com>
References: <512b52ab.02de420a.7040.7417SMTPIN_ADDED_BROKEN@mx.google.com>
	<CAF6AEGtG5h3z6b=+T1pSBpxSDS6r9Jz7UnaoGN4tVgU7RUZg6Q@mail.gmail.com>
	<20160617105950.1a909309@eldfell>
	<CAF6AEGtT8WXF=z883iB+9dS6rbS3RV3kJ=d-X+Eenv5MAcZ5Lg@mail.gmail.com>
	<20160617163109.68945359@eldfell>
	<CAF6AEGvAe8Q20B4rMcrrR+5Cqybdi=kwyBCR0187b9uc5X1mSQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/9WsPuTMUONFD/646XCvOUrj"; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Sig_/9WsPuTMUONFD/646XCvOUrj
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 17 Jun 2016 11:44:34 -0400
Rob Clark <robdclark@gmail.com> wrote:

> On Fri, Jun 17, 2016 at 9:31 AM, Pekka Paalanen <ppaalanen@gmail.com> wro=
te:
> > On Fri, 17 Jun 2016 08:26:04 -0400
> > Rob Clark <robdclark@gmail.com> wrote:
> > =20
> >> On Fri, Jun 17, 2016 at 3:59 AM, Pekka Paalanen <ppaalanen@gmail.com> =
wrote: =20
> >> > On Thu, 16 Jun 2016 10:40:51 -0400
> >> > Rob Clark <robdclark@gmail.com> wrote:
> >> > =20

> >> >> On Mon, Feb 25, 2013 at 6:54 AM, Tom Cooksey <tom.cooksey@arm.com> =
wrote: =20
> >> >> > Hi All,
> >> >> >
> >> >> > The final spec has had enum values assigned and been published on=
 Khronos:
> >> >> >
> >> >> > http://www.khronos.org/registry/egl/extensions/EXT/EGL_EXT_image_=
dma_buf_import.txt
> >> >> >
> >> >> > Thanks to all who've provided input. =20
> >> >
> >> > May I also pull your attention to a detail with the existing spec and
> >> > Mesa behaviour I am asking about in
> >> > https://lists.freedesktop.org/archives/mesa-dev/2016-June/120249.html
> >> > "What is EGL_EXT_image_dma_buf_import image orientation as a GL text=
ure?"
> >> > Doing a dmabuf import seems to imply an y-flip AFAICT. =20
> >>
> >> I would have expected that *any* egl external image (dma-buf or
> >> otherwise) should have native orientation rather than gl orientation.
> >> It's somewhat useless otherwise. =20
> >
> > In that case importing dmabuf works differently than importing a
> > wl_buffer (wl_drm), because for the latter, the y-invert flag is
> > returned such that the orientation will match GL. And the direct
> > scanout path goes through GBM since you have to import a wl_buffer, and
> > I haven't looked what GBM does wrt. y-flip if anything.
> > =20
> >> I didn't read it carefully yet (would need caffeine first ;-)) but
> >> EGL_KHR_image_base does say "This extension defines a new EGL resource
> >> type that is suitable for sharing 2D arrays of image data between
> >> client APIs" which to me implies native orientation.  So that just
> >> sounds like a mesa bug somehow? =20
> >
> > That specific sentence implies nothing about orientation to me.
> > Furthermore, the paragraph continues:
> >
> >         "Although the intended purpose is sharing 2D image data, the
> >         underlying interface makes no assumptions about the format or
> >         purpose of the resource being shared, leaving those decisions
> >         to the application and associated client APIs."
> >
> > Might "format" include orientation?
> >
> > How does "native orientation" connect with "GL texture coordinates"?
> > The latter have explicitly defined orientation and origin. For use in
> > GL, the right way up image is having the origin in the bottom-left
> > corner. An image right way up is an image right way up, regardless
> > which corner is the origin. The problem comes when you start using
> > coordinates.
> > =20
> >> Do you just get that w/ i965?  I know some linaro folks have been
> >> using this extension to import buffers from video decoder with
> >> freedreno/gallium and no one mentioned the video being upside down. =20
> >
> > Intel, yes, but since this happens *only* for the GL import path and
> > direct scanout is fine without y-flipping, I bet people just flipped y
> > and did not think twice, if there even was a problem. I just have a
> > habit of asking "why". ;-) =20
>=20
> well, if possible, try with one of the gallium drivers?

A good idea, I just need to do it at home with nouveau... which means I
probably won't be getting there any time soon.

> I'm honestly not 100% sure what it is supposed to be according to the
> spec, but I do know some of the linaro folks were doing v4l2dec ->
> glimagesink with dmabuf with both mali (I think some ST platform?) and
> freedreno (snapdragon db410c), and no one complained to me that the
> video was upside down for one or the other.  So I guess at least
> gallium and mali are doing the same thing.  No idea if that is the
> same thing that i965 does.


Thanks,
pq

>=20
> BR,
> -R
>=20
> > After all, using GL with windows and FBOs and stuff you very often find
> > yourself upside down, and I suspect people have got the habit of just
> > flipping it if it does not look right the first time. See e.g. the
> > row-order of data going into glTexImage2D...
> >
> > If the answer is "oops, well, dmabuf import is semantically y-flipping
> > when it should not, but we cannot fix it because that would break
> > everyone", I would be happy with that. I just want confirmation before
> > flipping the flip flag. :-)
> >
> >
> > Thanks,
> > pq =20


--Sig_/9WsPuTMUONFD/646XCvOUrj
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBV2emNiNf5bQRqqqnAQi+Rw/9E29amIHAmz0o54++qgMRPbv+u8eAXFWB
wTmOnfW6bjkIGvI/CYyG3JnVsxgqvZc3dsL6ntUUVZEAK9fW1aLQfT6ac0I0ePGH
+Bb1xfrp/EzvpOPMuukeBK54CGuY6w/9cuvrJySf5XYq46cfc5FbUdkxwbNOCjWY
v2ZofmtvBIrJ8v0U36my/7N3oA1R8wq5vgvJyv8SW0x8y2XzLBXe2UFJ4I78eRoI
5hN/cfdDgcaT5YV7/pJjJlKOnCTrod3QW/Ep98sdjO+lQ4MjyHk/DKt5f4fidkfs
SDGRN/pCAMzNz90kMoI5b3TrdLmwtl9m/WfN7JD4JYJC73CyEH6UBmM6plrOgyej
kflcpq/+00pu94tRuElPFOHlNT0s5HRlS7x4axOly2VsNK/NSKuv26Be40wKeOxZ
LWOj7E3vYNIwgfwoI2lkqHQAAV39lu+UZ1zZ0tH3ZZ28oS/qWe9rHN67WVYAAfqO
QVwiMFfau2n1Sz1IQR1msTTn/JddSHb2MPYKwUCqhVGp/AwRTUGdPpVOo7SqWPhU
dKIPZZHEBTrSEuoMchLCSb4bZuu2jUvIOXzLqxgp9jd+XsfyuY3t9tUB047RrL11
qUZJxI72So0HAIu5+n55B6lRSj+aFJYqirTZxSWwF6GFZdkwUU0tLBAlbXltMPcH
DJRHWhNNfAY=
=m1B/
-----END PGP SIGNATURE-----

--Sig_/9WsPuTMUONFD/646XCvOUrj--
