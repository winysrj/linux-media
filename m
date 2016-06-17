Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f43.google.com ([209.85.215.43]:35310 "EHLO
	mail-lf0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755627AbcFQNbV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Jun 2016 09:31:21 -0400
Received: by mail-lf0-f43.google.com with SMTP id l188so58006089lfe.2
        for <linux-media@vger.kernel.org>; Fri, 17 Jun 2016 06:31:19 -0700 (PDT)
Date: Fri, 17 Jun 2016 16:31:09 +0300
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
Message-ID: <20160617163109.68945359@eldfell>
In-Reply-To: <CAF6AEGtT8WXF=z883iB+9dS6rbS3RV3kJ=d-X+Eenv5MAcZ5Lg@mail.gmail.com>
References: <512b52ab.02de420a.7040.7417SMTPIN_ADDED_BROKEN@mx.google.com>
	<CAF6AEGtG5h3z6b=+T1pSBpxSDS6r9Jz7UnaoGN4tVgU7RUZg6Q@mail.gmail.com>
	<20160617105950.1a909309@eldfell>
	<CAF6AEGtT8WXF=z883iB+9dS6rbS3RV3kJ=d-X+Eenv5MAcZ5Lg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/F1yuhtuGvNHw_88DLUvp5/I"; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Sig_/F1yuhtuGvNHw_88DLUvp5/I
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 17 Jun 2016 08:26:04 -0400
Rob Clark <robdclark@gmail.com> wrote:

> On Fri, Jun 17, 2016 at 3:59 AM, Pekka Paalanen <ppaalanen@gmail.com> wro=
te:
> > On Thu, 16 Jun 2016 10:40:51 -0400
> > Rob Clark <robdclark@gmail.com> wrote:
> > =20
> >> So, if we wanted to extend this to support the fourcc-modifiers that
> >> we have on the kernel side for compressed/tiled/etc formats, what
> >> would be the right approach?
> >>
> >> A new version of the existing extension or a new
> >> EGL_EXT_image_dma_buf_import2 extension, or ?? =20
> >
> > Hi Rob,
> >
> > there are actually several things it might be nice to add:
> >
> > - a fourth plane, to match what DRM AddFB2 supports
> >
> > - the 64-bit fb modifiers
> >
> > - queries for which pixel formats are supported by EGL, so a display
> >   server can tell the applications that before the application goes and
> >   tries with a random bunch of them, shooting in the dark
> >
> > - queries for which modifiers are supported for each pixel format, ditto
> >
> > I discussed these with Emil in the past, and it seems an appropriate
> > approach might be the following.
> >
> > Adding the 4th plane can be done as revising the existing
> > EGL_EXT_image_dma_buf_import extension. The plane count is tied to
> > pixel formats (and modifiers?), so the user does not need to know
> > specifically whether the EGL implementation could handle a 4th plane or
> > not. It is implied by the pixel format.
> >
> > Adding the fb modifiers needs to be a new extension, so that users can
> > tell if they are supported or not. This is to avoid the following false
> > failure: if user assumes modifiers are always supported, it will (may?)
> > provide zero modifiers explicitly. If EGL implementation does not
> > handle modifiers this would be rejected as unrecognized attributes,
> > while if the zero modifiers were not given explicitly, everything would
> > just work. =20
>=20
> hmm, if we design it as "not passing modifier" =3D=3D "zero modifier", and
> "never explicitly pass a zero modifier" then modifiers could be added
> without a new extension.  Although I agree that queries would need a
> new extension.. so perhaps not worth being clever.

Indeed.

> > The queries obviously(?) need a new extension. It might make sense
> > to bundle both modifier support and the queries in the same new
> > extension.
> >
> > We have some rough old WIP code at
> > https://git.collabora.com/cgit/user/lfrb/mesa.git/log/?h=3DT1410-modifi=
ers
> > https://git.collabora.com/cgit/user/lfrb/egl-specs.git/log/?h=3DT1410
> >
> > =20
> >> On Mon, Feb 25, 2013 at 6:54 AM, Tom Cooksey <tom.cooksey@arm.com> wro=
te: =20
> >> > Hi All,
> >> >
> >> > The final spec has had enum values assigned and been published on Kh=
ronos:
> >> >
> >> > http://www.khronos.org/registry/egl/extensions/EXT/EGL_EXT_image_dma=
_buf_import.txt
> >> >
> >> > Thanks to all who've provided input. =20
> >
> > May I also pull your attention to a detail with the existing spec and
> > Mesa behaviour I am asking about in
> > https://lists.freedesktop.org/archives/mesa-dev/2016-June/120249.html
> > "What is EGL_EXT_image_dma_buf_import image orientation as a GL texture=
?"
> > Doing a dmabuf import seems to imply an y-flip AFAICT. =20
>=20
> I would have expected that *any* egl external image (dma-buf or
> otherwise) should have native orientation rather than gl orientation.
> It's somewhat useless otherwise.

In that case importing dmabuf works differently than importing a
wl_buffer (wl_drm), because for the latter, the y-invert flag is
returned such that the orientation will match GL. And the direct
scanout path goes through GBM since you have to import a wl_buffer, and
I haven't looked what GBM does wrt. y-flip if anything.

> I didn't read it carefully yet (would need caffeine first ;-)) but
> EGL_KHR_image_base does say "This extension defines a new EGL resource
> type that is suitable for sharing 2D arrays of image data between
> client APIs" which to me implies native orientation.  So that just
> sounds like a mesa bug somehow?

That specific sentence implies nothing about orientation to me.
Furthermore, the paragraph continues:

	"Although the intended purpose is sharing 2D image data, the
	underlying interface makes no assumptions about the format or
	purpose of the resource being shared, leaving those decisions
	to the application and associated client APIs."

Might "format" include orientation?

How does "native orientation" connect with "GL texture coordinates"?
The latter have explicitly defined orientation and origin. For use in
GL, the right way up image is having the origin in the bottom-left
corner. An image right way up is an image right way up, regardless
which corner is the origin. The problem comes when you start using
coordinates.

> Do you just get that w/ i965?  I know some linaro folks have been
> using this extension to import buffers from video decoder with
> freedreno/gallium and no one mentioned the video being upside down.

Intel, yes, but since this happens *only* for the GL import path and
direct scanout is fine without y-flipping, I bet people just flipped y
and did not think twice, if there even was a problem. I just have a
habit of asking "why". ;-)

After all, using GL with windows and FBOs and stuff you very often find
yourself upside down, and I suspect people have got the habit of just
flipping it if it does not look right the first time. See e.g. the
row-order of data going into glTexImage2D...

If the answer is "oops, well, dmabuf import is semantically y-flipping
when it should not, but we cannot fix it because that would break
everyone", I would be happy with that. I just want confirmation before
flipping the flip flag. :-)


Thanks,
pq

--Sig_/F1yuhtuGvNHw_88DLUvp5/I
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBV2P7oyNf5bQRqqqnAQjMqg//a07q0a8+JDRS0RQ3FpRwEY0mr0xmW8jG
hNOmkkfWceywyJdBEH1lMHIRdRd2MGRKdlWGK785AorXfs72lAIGkMy2x/efl3WA
Fj9vcs0Hx1wDXPuiBlY69UWdKAtViAS1ZZTY9XQ1ooIm4RGtd0+1kHuuYuJJ3u4R
WUBioshZ8782rp3Jviapg5CmmDD7G8tU8+YT5JV7Ylyvy/rJM4GLA+7x1Ef1+nkJ
wph5EzowYVMplZwiVd8Rsqsafuv9yFpBnVfOGxtP1Ntn1bDWEZnZZlTL6GVGtxDe
Lc4uVXCfzeE2YTvSSjzg4mpIvoQ/OtxUuFS2f8KakUxkGZsMViaO7n1sjruesG2Y
oE5NT1R1rHmNLimRmzKkd/4ExZcc0V+toUOE5skZKDqhqB/5osKg5eFoyXDvIz8u
6zPRciAGn7/drhkzERDMu8vtSzVapgHednBUVgSqf7LvzOYf/wZ3zzo+/1DmROIP
BL9kfw8RDowKoiOIhdzRP65fE8j7rhUnty9zi+Tw5lHpp9TljIr5OAGLOOIHbCT4
4Jt26rKkQDbu55CLf0d/X8uDOFpzMRm6gLO+1ucaa6omtyWEwFeTTQQ246J2lVzy
txjGGax4sg60k+DLLeG1MrT6SjyKKoeVjC5k1JPuPrRrhg70JR+I1ffWj8xf+0ER
jt3AVVRVi7k=
=zK4v
-----END PGP SIGNATURE-----

--Sig_/F1yuhtuGvNHw_88DLUvp5/I--
