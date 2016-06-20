Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f43.google.com ([209.85.215.43]:35331 "EHLO
	mail-lf0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501AbcFTOnf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jun 2016 10:43:35 -0400
Received: by mail-lf0-f43.google.com with SMTP id l188so39184992lfe.2
        for <linux-media@vger.kernel.org>; Mon, 20 Jun 2016 07:43:34 -0700 (PDT)
Date: Mon, 20 Jun 2016 17:37:38 +0300
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
	<louis-francis.ratte-boulianne@collabora.co.uk>,
	Quentin Glidic <sardemff7+wayland@sardemff7.net>
Subject: Re: [Mesa-dev] [RFC] New dma_buf -> EGLImage EGL extension - Final
 spec published!
Message-ID: <20160620173738.7e40a08e@eldfell>
In-Reply-To: <CAF6AEGvVBxcLWOv_TfUSZYBDEH-7a8zmnyntUVii7fzBoVt9vg@mail.gmail.com>
References: <512b52ab.02de420a.7040.7417SMTPIN_ADDED_BROKEN@mx.google.com>
	<CAF6AEGtG5h3z6b=+T1pSBpxSDS6r9Jz7UnaoGN4tVgU7RUZg6Q@mail.gmail.com>
	<20160617105950.1a909309@eldfell>
	<CAF6AEGtT8WXF=z883iB+9dS6rbS3RV3kJ=d-X+Eenv5MAcZ5Lg@mail.gmail.com>
	<20160617163109.68945359@eldfell>
	<CAF6AEGvAe8Q20B4rMcrrR+5Cqybdi=kwyBCR0187b9uc5X1mSQ@mail.gmail.com>
	<20160620153742.75b3e45b@eldfell>
	<CAF6AEGvVBxcLWOv_TfUSZYBDEH-7a8zmnyntUVii7fzBoVt9vg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/Cvq/QatanbsirBuj2USk8mN"; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Sig_/Cvq/QatanbsirBuj2USk8mN
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 20 Jun 2016 09:45:26 -0400
Rob Clark <robdclark@gmail.com> wrote:

> On Mon, Jun 20, 2016 at 8:37 AM, Pekka Paalanen <ppaalanen@gmail.com> wro=
te:
> > On Fri, 17 Jun 2016 11:44:34 -0400
> > Rob Clark <robdclark@gmail.com> wrote:
> > =20
> >> On Fri, Jun 17, 2016 at 9:31 AM, Pekka Paalanen <ppaalanen@gmail.com> =
wrote: =20
> >> > On Fri, 17 Jun 2016 08:26:04 -0400
> >> > Rob Clark <robdclark@gmail.com> wrote:
> >> > =20
> >> >> On Fri, Jun 17, 2016 at 3:59 AM, Pekka Paalanen <ppaalanen@gmail.co=
m> wrote: =20
> >> >> > On Thu, 16 Jun 2016 10:40:51 -0400
> >> >> > Rob Clark <robdclark@gmail.com> wrote:
> >> >> > =20
> >> >> >> So, if we wanted to extend this to support the fourcc-modifiers =
that
> >> >> >> we have on the kernel side for compressed/tiled/etc formats, what
> >> >> >> would be the right approach?
> >> >> >>
> >> >> >> A new version of the existing extension or a new
> >> >> >> EGL_EXT_image_dma_buf_import2 extension, or ?? =20
> >> >> >
> >> >> > Hi Rob,
> >> >> >
> >> >> > there are actually several things it might be nice to add:
> >> >> >
> >> >> > - a fourth plane, to match what DRM AddFB2 supports
> >> >> >
> >> >> > - the 64-bit fb modifiers
> >> >> >
> >> >> > - queries for which pixel formats are supported by EGL, so a disp=
lay
> >> >> >   server can tell the applications that before the application go=
es and
> >> >> >   tries with a random bunch of them, shooting in the dark
> >> >> >
> >> >> > - queries for which modifiers are supported for each pixel format=
, ditto
> >> >> >
> >> >> > I discussed these with Emil in the past, and it seems an appropri=
ate
> >> >> > approach might be the following.
> >> >> >
> >> >> > Adding the 4th plane can be done as revising the existing
> >> >> > EGL_EXT_image_dma_buf_import extension. The plane count is tied to
> >> >> > pixel formats (and modifiers?), so the user does not need to know
> >> >> > specifically whether the EGL implementation could handle a 4th pl=
ane or
> >> >> > not. It is implied by the pixel format.
> >> >> >
> >> >> > Adding the fb modifiers needs to be a new extension, so that user=
s can
> >> >> > tell if they are supported or not. This is to avoid the following=
 false
> >> >> > failure: if user assumes modifiers are always supported, it will =
(may?)
> >> >> > provide zero modifiers explicitly. If EGL implementation does not
> >> >> > handle modifiers this would be rejected as unrecognized attribute=
s,
> >> >> > while if the zero modifiers were not given explicitly, everything=
 would
> >> >> > just work. =20
> >> >>
> >> >> hmm, if we design it as "not passing modifier" =3D=3D "zero modifie=
r", and
> >> >> "never explicitly pass a zero modifier" then modifiers could be add=
ed
> >> >> without a new extension.  Although I agree that queries would need a
> >> >> new extension.. so perhaps not worth being clever. =20
> >> >
> >> > Indeed.
> >> > =20
> >> >> > The queries obviously(?) need a new extension. It might make sense
> >> >> > to bundle both modifier support and the queries in the same new
> >> >> > extension.
> >> >> >
> >> >> > We have some rough old WIP code at
> >> >> > https://git.collabora.com/cgit/user/lfrb/mesa.git/log/?h=3DT1410-=
modifiers
> >> >> > https://git.collabora.com/cgit/user/lfrb/egl-specs.git/log/?h=3DT=
1410
> >> >> >
> >> >> > =20
> >> >> >> On Mon, Feb 25, 2013 at 6:54 AM, Tom Cooksey <tom.cooksey@arm.co=
m> wrote: =20
> >> >> >> > Hi All,
> >> >> >> >
> >> >> >> > The final spec has had enum values assigned and been published=
 on Khronos:
> >> >> >> >
> >> >> >> > http://www.khronos.org/registry/egl/extensions/EXT/EGL_EXT_ima=
ge_dma_buf_import.txt
> >> >> >> >
> >> >> >> > Thanks to all who've provided input. =20
> >> >> >
> >> >> > May I also pull your attention to a detail with the existing spec=
 and
> >> >> > Mesa behaviour I am asking about in
> >> >> > https://lists.freedesktop.org/archives/mesa-dev/2016-June/120249.=
html
> >> >> > "What is EGL_EXT_image_dma_buf_import image orientation as a GL t=
exture?"
> >> >> > Doing a dmabuf import seems to imply an y-flip AFAICT. =20
> >> >>
> >> >> I would have expected that *any* egl external image (dma-buf or
> >> >> otherwise) should have native orientation rather than gl orientatio=
n.
> >> >> It's somewhat useless otherwise. =20
> >> >
> >> > In that case importing dmabuf works differently than importing a
> >> > wl_buffer (wl_drm), because for the latter, the y-invert flag is
> >> > returned such that the orientation will match GL. And the direct
> >> > scanout path goes through GBM since you have to import a wl_buffer, =
and
> >> > I haven't looked what GBM does wrt. y-flip if anything.
> >> > =20
> >> >> I didn't read it carefully yet (would need caffeine first ;-)) but
> >> >> EGL_KHR_image_base does say "This extension defines a new EGL resou=
rce
> >> >> type that is suitable for sharing 2D arrays of image data between
> >> >> client APIs" which to me implies native orientation.  So that just
> >> >> sounds like a mesa bug somehow? =20
> >> >
> >> > That specific sentence implies nothing about orientation to me.
> >> > Furthermore, the paragraph continues:
> >> >
> >> >         "Although the intended purpose is sharing 2D image data, the
> >> >         underlying interface makes no assumptions about the format or
> >> >         purpose of the resource being shared, leaving those decisions
> >> >         to the application and associated client APIs."
> >> >
> >> > Might "format" include orientation?
> >> >
> >> > How does "native orientation" connect with "GL texture coordinates"?
> >> > The latter have explicitly defined orientation and origin. For use in
> >> > GL, the right way up image is having the origin in the bottom-left
> >> > corner. An image right way up is an image right way up, regardless
> >> > which corner is the origin. The problem comes when you start using
> >> > coordinates.
> >> > =20
> >> >> Do you just get that w/ i965?  I know some linaro folks have been
> >> >> using this extension to import buffers from video decoder with
> >> >> freedreno/gallium and no one mentioned the video being upside down.=
 =20
> >> >
> >> > Intel, yes, but since this happens *only* for the GL import path and
> >> > direct scanout is fine without y-flipping, I bet people just flipped=
 y
> >> > and did not think twice, if there even was a problem. I just have a
> >> > habit of asking "why". ;-) =20
> >>
> >> well, if possible, try with one of the gallium drivers?
> >>
> >> I'm honestly not 100% sure what it is supposed to be according to the
> >> spec, but I do know some of the linaro folks were doing v4l2dec ->
> >> glimagesink with dmabuf with both mali (I think some ST platform?) and
> >> freedreno (snapdragon db410c), and no one complained to me that the
> >> video was upside down for one or the other.  So I guess at least
> >> gallium and mali are doing the same thing.  No idea if that is the
> >> same thing that i965 does. =20
> >
> > Hi,
> >
> > Quentin did some tests for me, and the results are... not what I would
> > have expected:
> > https://phabricator.freedesktop.org/T7475#88454
> >
> > RadeonSI works like Intel, but Nouveau does the opposite. I think the
> > Nouveau way is correct by the spec, which makes everyone else (intel,
> > radeonsi, weston-simple-dmabuf-v4l) get it wrong. Unfortunately, two
> > wrongs make a right, so when weston-simple-dmabuf-v4l hardcodes Y_INVERT
> > as set, it'll come out the right way on intel and radeon. =20
>=20
> oh, wow.. that seems quite odd that two different gallium drivers have
> different results, since I'd have expected this to be completely
> handled by mesa/st.. now I'm somewhat curious.

Hi,

after a head-scratching session on #dri-devel and a little bit on
#wayland too, I'm ready to punt that off as a bad test.

It is quite possible the machine running nouveau had a webcam that
really produces upside-down images. weston-simple-dmabuf-v4l does not
understand that. Apparently mpv OTOH does. How, maybe there is an
answer in V4L2 API, but I haven't looked it up yet.

If we look at the Vivid tests, the results are consistent and expected.
All intel, nouveau and radeon work the same way.

> > And it is wrong for weston-simple-dmabuf-v4l to set Y_INVERT, that I
> > believe is clear. It is only there because of the "oops, it's
> > upside-down" syndrome, AFAIK.
> > =20
> >> > After all, using GL with windows and FBOs and stuff you very often f=
ind
> >> > yourself upside down, and I suspect people have got the habit of just
> >> > flipping it if it does not look right the first time. See e.g. the
> >> > row-order of data going into glTexImage2D...
> >> >
> >> > If the answer is "oops, well, dmabuf import is semantically y-flippi=
ng
> >> > when it should not, but we cannot fix it because that would break
> >> > everyone", I would be happy with that. I just want confirmation befo=
re
> >> > flipping the flip flag. :-) =20
> >
> > So many bugs that accidentally counter each other...

Seems like we can conclude this by saying that a dmabuf imported via
EGL as a GL texture will have the origin at top-left, instead of what
the GL spec says.


Thanks,
pq

--Sig_/Cvq/QatanbsirBuj2USk8mN
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBV2f/siNf5bQRqqqnAQj4wA//V5pIKW1FACL6vwVziMvFG6+n+0999FbR
yZZDYL7mkSPjPY8JWAZoL5CQV0Qbj4RaUjXwc+JPimci0unmHBZ7ER5OcvfB0hjy
YxcsPsJKUKkwfOHXgdRjQ4yH/v3k2qSBNvlejDygvs12Z8K1oSgCpnNIxy0MRTad
/+8UQ1jS/lqJhctM10X2C9ONP/NfP1SOKCbZzTn2breMEL1LvXfwxNxpzYOjpkxv
/J6jyj0XmRYbgkei0zw9l58mCmIX0SR7jyyo+rx5q4cxeTXXd0VUwBvKgzKrWvUh
znFEWUIEvjhZ8ixEzkLrzduphBHmZVTiuHj2RippESSROUkwxk3HvHB3O8C5fbT8
seUR+/GpiB4O0uPT4xtEvf1lBrNVBXUQgywND0IFTpgTVhcAQonZRPTQGYIaHlM2
5jKUD85odGPh2K7tnCLj2kbIDzGMyp0zBcK1fLb7bkD+9+eTtdggBuJK0YGhmcOG
7yH7ZLCoDZ0SmI1yK4NMoUcZ+f1+bBCrEcd6EoBSUk6tgrW2DausE8uQY3lLYyja
tLDRInGjSYdt2zCSMOYeLM5Qae4/XDG/vqeb/XbS7jaxCETZocV27mue+w1Gx4ym
TgPrwriJ6tue89DXKCRyt9RldA810WuYEluAR6jDN4IGTHdAD8q40KdLE3tHjOdv
zdqCmzt8YVo=
=78cf
-----END PGP SIGNATURE-----

--Sig_/Cvq/QatanbsirBuj2USk8mN--
