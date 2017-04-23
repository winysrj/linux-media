Return-path: <linux-media-owner@vger.kernel.org>
Received: from nereida.gnuservers.com.ar ([207.192.69.134]:49834 "EHLO
        nereida.gnuservers.com.ar" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1044697AbdDWJtN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 23 Apr 2017 05:49:13 -0400
Date: Sun, 23 Apr 2017 11:39:29 +0200
From: Maximiliano Curia <maxy@debian.org>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: linux-media@vger.kernel.org, David Fries <David@Fries.net>
Subject: [David@Fries.net: [PATCH] xawtv allow ./configure --disable-alsa to
 compile when alsa is available]
Message-ID: <20170423093929.5bvnf4zjhsg3rfub@gnuservers.com.ar>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="hvbobtahjamgifbf"
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--hvbobtahjamgifbf
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

I've received a patch for xawtv made by David Fries (I maintain xawtv in=20
Debian) that I think it would be nice to include in the xawtv3 [1] git repo=
sitory and in=20
the next bug fix release. Currently I don't have commit access and I'm=20
not subscribed to the linux-media mailing list because I haven't received a=
 reply=20
about my subscription request.

I'm contacting you (Mauro) as you committed the latest patches in=20
the git repository, could you please review and/or push the=20
patch below?

I'm also CCing the mailing list but I don't expect it to reach it. If the m=
ail=20
reaches the list, please cc me in the reply.

Please let me know if there is an easier way to contact the linux-media gro=
up.

Happy hacking,

[1]: https://git.linuxtv.org/xawtv3.git

----- Forwarded message from David Fries <David@Fries.net> -----

Date: Sat, 25 Mar 2017 13:25:54 -0500
=46rom: David Fries <David@Fries.net>
To: Maximiliano Curia <maxy@gnuservers.com.ar>
User-Agent: Mutt/1.5.23 (2014-03-12)
Subject: [PATCH] xawtv allow ./configure --disable-alsa to compile when als=
a is available

alsa_loopback is used outside of the HAVE_ALSA check, always define
it.  Disable alsa_stream.c or the alsa functions are missing symbols.
---
I'm debugging a webcam problem, the 'motion' program works once, then
fails, xawtv unwedges the camera so it can run again.  In trying to
figure out what xawtv is doing that motion isn't, I went to compile
without audio to cut down on the ioctls to look at and turns out
xawtv using audio IS what is unwedging the camera.  That's no good for
the uvc USB camera driver, or camera, to require audio be setup for it
to work properly.  Here's a patch to fixup xawtv to compile without
alsa.  Thanks for supporting this small little program, I would have
never thought to look at audio otherwise.

 common/alsa_stream.c | 2 +-
 console/radio.c      | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/common/alsa_stream.c b/common/alsa_stream.c
index 3e33b5e..85e10b4 100644
--- a/common/alsa_stream.c
+++ b/common/alsa_stream.c
@@ -28,7 +28,7 @@

 #include "config.h"

-#ifdef HAVE_ALSA_ASOUNDLIB_H
+#if defined(HAVE_ALSA_ASOUNDLIB_H) && defined(HAVE_ALSA)

 #include <stdio.h>
 #include <stdlib.h>
diff --git a/console/radio.c b/console/radio.c
index 186fd3c..d4f7d57 100644
--- a/console/radio.c
+++ b/console/radio.c
@@ -62,8 +62,8 @@
    USB radio devices benefit from a larger default latency */
 #define DEFAULT_LATENCY 500

-#if defined(HAVE_ALSA)
 int alsa_loopback =3D 1;
+#if defined(HAVE_ALSA)
 char *alsa_playback =3D NULL;
 char *alsa_capture =3D NULL;
 int alsa_latency =3D DEFAULT_LATENCY;
--=20
2.11.0

----- End forwarded message -----

--=20
"C makes it easy to shoot yourself in the foot; C++ makes it harder,
but when you do it blows your whole leg off."
-- Bjarne Stroustrup
 Saludos /\/\ /\ >< `/

--hvbobtahjamgifbf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE+JIdOnQEyG4RNSIVxxl2mbKbIyoFAlj8dksACgkQxxl2mbKb
IyqGog//SU+emnF5S8tUflo11ohk/a9UqG0q2wgn9Cl78xl2GRA5b6VZ4kYE/9Xr
BIOBf6ANuCKI1EnWGnACqZPis/Gpjitq//+YVNT/inYUsxqHiv6jDDEqNjjJvpYM
Mo35Yqf215oH/Nl8tOYRuv45LNoZ3XpSXbSjddCW4j5W8vJuVhc7tR+2Zl33QbgY
LCqHWKn7B9hBerYyNjGHLXqZJGlU4EF3KJQHvOHKovFdeVqxCs8C6H5oiERXObLN
Xe9yoDsSnhj48+r5/sD4IZUepTBwfc/UXc4IUxVAaycu1vPdEMh+Up547PEEW8RX
sAK/4hQWGVAuuBaws2Zwhaulkk8FX186n/9XYBs1egyhKzBS0YZH09jj7c+DJcGD
+cE8WHHXNf13J8Tjsfqwzz3bFIXDQHuCuDTaaHMy2+wwISRu+F4rG9poCxg1SAFr
Vx55XI7hU5mI25rdeq73xBNkvuxJb+0PjZUcYWxahXfRzvA9j67aizzChPz7pm18
ruicWO/ho2+hVgwYKJUr3FZopnJatlOCWO6NzmV0nip9bVgxgvGNcfP6wUDuERL7
hZIyuZtnJwfu14raiN3fC4qGMV/z/ObAKhNxm8Elyft2XL7DnXhhYplkHinWd/r1
bbCPQegQeQXj+6MGRRxsbDn2kWHGR1t4Bm3M5G2Tfqq7jx//gHY=
=t+aG
-----END PGP SIGNATURE-----

--hvbobtahjamgifbf--
