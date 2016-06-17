Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f50.google.com ([209.85.215.50]:35502 "EHLO
	mail-lf0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754347AbcFQIAC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Jun 2016 04:00:02 -0400
Received: by mail-lf0-f50.google.com with SMTP id l188so52862714lfe.2
        for <linux-media@vger.kernel.org>; Fri, 17 Jun 2016 01:00:01 -0700 (PDT)
Date: Fri, 17 Jun 2016 10:59:50 +0300
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
Message-ID: <20160617105950.1a909309@eldfell>
In-Reply-To: <CAF6AEGtG5h3z6b=+T1pSBpxSDS6r9Jz7UnaoGN4tVgU7RUZg6Q@mail.gmail.com>
References: <512b52ab.02de420a.7040.7417SMTPIN_ADDED_BROKEN@mx.google.com>
	<CAF6AEGtG5h3z6b=+T1pSBpxSDS6r9Jz7UnaoGN4tVgU7RUZg6Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/lg0z1_94g+Ch.wjxO8LtS__"; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Sig_/lg0z1_94g+Ch.wjxO8LtS__
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 16 Jun 2016 10:40:51 -0400
Rob Clark <robdclark@gmail.com> wrote:

> So, if we wanted to extend this to support the fourcc-modifiers that
> we have on the kernel side for compressed/tiled/etc formats, what
> would be the right approach?
>=20
> A new version of the existing extension or a new
> EGL_EXT_image_dma_buf_import2 extension, or ??

Hi Rob,

there are actually several things it might be nice to add:

- a fourth plane, to match what DRM AddFB2 supports

- the 64-bit fb modifiers

- queries for which pixel formats are supported by EGL, so a display
  server can tell the applications that before the application goes and
  tries with a random bunch of them, shooting in the dark

- queries for which modifiers are supported for each pixel format, ditto

I discussed these with Emil in the past, and it seems an appropriate
approach might be the following.

Adding the 4th plane can be done as revising the existing
EGL_EXT_image_dma_buf_import extension. The plane count is tied to
pixel formats (and modifiers?), so the user does not need to know
specifically whether the EGL implementation could handle a 4th plane or
not. It is implied by the pixel format.

Adding the fb modifiers needs to be a new extension, so that users can
tell if they are supported or not. This is to avoid the following false
failure: if user assumes modifiers are always supported, it will (may?)
provide zero modifiers explicitly. If EGL implementation does not
handle modifiers this would be rejected as unrecognized attributes,
while if the zero modifiers were not given explicitly, everything would
just work.

The queries obviously(?) need a new extension. It might make sense
to bundle both modifier support and the queries in the same new
extension.

We have some rough old WIP code at
https://git.collabora.com/cgit/user/lfrb/mesa.git/log/?h=3DT1410-modifiers
https://git.collabora.com/cgit/user/lfrb/egl-specs.git/log/?h=3DT1410


> On Mon, Feb 25, 2013 at 6:54 AM, Tom Cooksey <tom.cooksey@arm.com> wrote:
> > Hi All,
> >
> > The final spec has had enum values assigned and been published on Khron=
os:
> >
> > http://www.khronos.org/registry/egl/extensions/EXT/EGL_EXT_image_dma_bu=
f_import.txt
> >
> > Thanks to all who've provided input.

May I also pull your attention to a detail with the existing spec and
Mesa behaviour I am asking about in
https://lists.freedesktop.org/archives/mesa-dev/2016-June/120249.html
"What is EGL_EXT_image_dma_buf_import image orientation as a GL texture?"
Doing a dmabuf import seems to imply an y-flip AFAICT.


Thanks,
pq

--Sig_/lg0z1_94g+Ch.wjxO8LtS__
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBV2Ot/SNf5bQRqqqnAQjM3g//c7NZh/CwNZiJMeC5SxCHqw+ubv114O05
Wqi83ESgDyIO+s0+eXdjkGw9UvfQiQOBRryrPOJtVI6psfkYHUMaLqh20jFxX5Di
ThufCHZMaq6IFIBAuIVR0++5AMLHS+BM9a5l5rebx4ZkKKKOOORqL4wLGdRQT3Vl
t36eJ2kyLJXjJ8yIIV482M65Gf/DYpNz3kADCYCL/IwwqGjXzV/R6ejkqF0K31Q+
oh1XMAJIs8zWumfXqv2qfgKq2JmnHYA+FkqV4akJ1cP23oPmx+81Gghr7vbHSnpE
Y4Wuh4KeRge7QSGPLLP4MEPiInzKUf//ZQZxRsaflUahgmMgsh7mTNLNQR/nSCSQ
2RMQd0DQAvtWWmNejub8DcXSoHHryBEpepqjWzeIuUTk+WbQdVrJBr2XuyfNZKxg
RdXMUH08xkU/FtOPvqxCAYcqUmS1B9kJUw+4lhuzCbDBA7+45i+FfxHW5Wt6/ye4
T3ms9g89hTxh0YIFsTI1Bzgni9HXys2QFruWrD/O9Xm0qKR5Rr4HgeXrbS0xKJ/V
RMoRSNEkdd8blk7HMs9GqoTQQ1gTDpiENconiE8aTGAqnkRxucy410erUAYSOV6q
wMFRWCe5p04hrdP58NlBTUUKnO4zcNkNZl8wHRMXTg8gbv+b2c/yEsQ5jL6IWkI3
BMnMDsUs7NY=
=VPBE
-----END PGP SIGNATURE-----

--Sig_/lg0z1_94g+Ch.wjxO8LtS__--
