Return-path: <linux-media-owner@vger.kernel.org>
Received: from cinke.fazekas.hu ([195.199.244.225]:40900 "EHLO
	cinke.fazekas.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757122AbZDHUhF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Apr 2009 16:37:05 -0400
Date: Wed, 8 Apr 2009 22:36:53 +0200 (CEST)
From: Marton Balint <cus@fazekas.hu>
To: Miroslav =?utf-8?b?xaB1c3Rlaw==?= <sustmidown@centrum.cz>
cc: linux-media@vger.kernel.org, mchehab@infradead.org
Subject: Re: [PATCH] Re: cx88-dsp.c: missing =?utf-8?b?X19kaXZkaTM=?= on
 32bit kernel
In-Reply-To: <Pine.LNX.4.64.0904070208030.24672@cinke.fazekas.hu>
Message-ID: <Pine.LNX.4.64.0904082226230.15248@cinke.fazekas.hu>
References: <200904062233.30966@centrum.cz> <200904062234.8192@centrum.cz>
 <200904062235.15206@centrum.cz> <200904062236.31983@centrum.cz>
 <200904062237.27161@centrum.cz> <200904062238.10335@centrum.cz>
 <200904062239.877@centrum.cz> <200904062240.9520@centrum.cz>
 <200904062240.1773@centrum.cz> <loom.20090406T230214-297@post.gmane.org>
 <Pine.LNX.4.64.0904070208030.24672@cinke.fazekas.hu>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-943463948-1554240634-1239222686=:15248"
Content-ID: <Pine.LNX.4.64.0904082231390.15248@cinke.fazekas.hu>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---943463948-1554240634-1239222686=:15248
Content-Type: TEXT/PLAIN; CHARSET=ISO8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Content-ID: <Pine.LNX.4.64.0904082231391.15248@cinke.fazekas.hu>

On Tue, 7 Apr 2009, Marton Balint wrote:
> On Mon, 6 Apr 2009, Miroslav =A9ustek wrote:
>=20
> > Well this patch should solve it.
> >=20
> > I don't know how many samples are processed so:
> > First patch is for situation when N*N fits in s32.
> > Second one uses two divisions, but doesn't have any abnormal restrictio=
ns for N.
>=20
> Both patches are fine, beacuse in the current implementation N is not=20
> bigger than 576. Thanks for fixing this problem.

It seems that an #include is missing to math64.h. Below is a patch that=20
adds the missing include.

Regards,
   Marton

# HG changeset patch
# User Marton Balint <cus@fazekas.hu>
# Date 1239222228 -7200
# Node ID c07293f1b5e44a8614f8f84c6b4fc586a02e69eb
# Parent  202a1c7ec37968f35678980b5f3d9812e5961ef0
cx88: dsp: add missing include to math64.h

From: Marton Balint <cus@fazekas.hu>

This patch adds a missing include to math64.h and replaces div_s64_rem with
div_s64 since the remainder is not used anyway.

Priority: normal

Signed-off-by: Marton Balint <cus@fazekas.hu>

diff -r 202a1c7ec379 -r c07293f1b5e4 linux/drivers/media/video/cx88/cx88-ds=
p.c
--- a/linux/drivers/media/video/cx88/cx88-dsp.c=09Mon Apr 06 23:07:04 2009 =
+0000
+++ b/linux/drivers/media/video/cx88/cx88-dsp.c=09Wed Apr 08 22:23:48 2009 =
+0200
@@ -22,6 +22,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/jiffies.h>
+#include <linux/math64.h>
=20
 #include "cx88.h"
 #include "cx88-reg.h"
@@ -100,9 +101,7 @@
 =09s32 s_prev2 =3D 0;
 =09s32 coeff =3D 2*int_cos(freq);
 =09u32 i;
-
 =09s64 tmp;
-=09u32 remainder;
=20
 =09for (i =3D 0; i < N; i++) {
 =09=09s32 s =3D x[i] + ((s64)coeff*s_prev/32768) - s_prev2;
@@ -113,9 +112,8 @@
 =09tmp =3D (s64)s_prev2*s_prev2 + (s64)s_prev*s_prev -
 =09=09      (s64)coeff*s_prev2*s_prev/32768;
=20
-=09/* XXX: N must be low enough so that N*N fits in s32.
-=09 * Else we need two divisions. */
-=09return (u32) div_s64_rem(tmp, N*N, &remainder);
+=09/* N is low enough so N*N fits in s32. */
+=09return (u32) div_s64(tmp, N*N);
 }
=20
 static u32 freq_magnitude(s16 x[], u32 N, u32 freq)
---943463948-1554240634-1239222686=:15248--
