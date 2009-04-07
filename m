Return-path: <linux-media-owner@vger.kernel.org>
Received: from cinke.fazekas.hu ([195.199.244.225]:48150 "EHLO
	cinke.fazekas.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857AbZDGA1c (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Apr 2009 20:27:32 -0400
Date: Tue, 7 Apr 2009 02:27:15 +0200 (CEST)
From: Marton Balint <cus@fazekas.hu>
To: Miroslav =?utf-8?b?xaB1c3Rlaw==?= <sustmidown@centrum.cz>
cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] Re: cx88-dsp.c: missing =?utf-8?b?X19kaXZkaTM=?= on
 32bit kernel
In-Reply-To: <loom.20090406T230214-297@post.gmane.org>
Message-ID: <Pine.LNX.4.64.0904070208030.24672@cinke.fazekas.hu>
References: <200904062233.30966@centrum.cz> <200904062234.8192@centrum.cz>
 <200904062235.15206@centrum.cz> <200904062236.31983@centrum.cz>
 <200904062237.27161@centrum.cz> <200904062238.10335@centrum.cz>
 <200904062239.877@centrum.cz> <200904062240.9520@centrum.cz>
 <200904062240.1773@centrum.cz> <loom.20090406T230214-297@post.gmane.org>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-943463948-1843581891-1239062926=:24672"
Content-ID: <Pine.LNX.4.64.0904070222390.24672@cinke.fazekas.hu>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---943463948-1843581891-1239062926=:24672
Content-Type: TEXT/PLAIN; CHARSET=ISO8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Content-ID: <Pine.LNX.4.64.0904070222391.24672@cinke.fazekas.hu>

On Mon, 6 Apr 2009, Miroslav =A9ustek wrote:

> Well this patch should solve it.
>=20
> I don't know how many samples are processed so:
> First patch is for situation when N*N fits in s32.
> Second one uses two divisions, but doesn't have any abnormal restrictions=
 for N.

Both patches are fine, beacuse in the current implementation N is not=20
bigger than 576. Thanks for fixing this problem.

Regards,
  Marton


>=20
> Personally I think that two divisions won't hurt. :)
>=20
>=20
>=20
> ----- FILE: cx88-dsp_64bit_math1.patch -----
>=20
> cx88-dsp: fixing 64bit math on 32bit kernels
>=20
> Note the limitation of N.
> Personally I know nothing about possible size of samples array.
>=20
> From: Miroslav Sustek <sustmidown@centrum.cz>
> Signed-off-by: Miroslav Sustek <sustmidown@centrum.cz>
>=20
> diff -r 8aa1d865373c linux/drivers/media/video/cx88/cx88-dsp.c
> --- a/linux/drivers/media/video/cx88/cx88-dsp.c=09Wed Apr 01 20:25:00 200=
9 +0000
> +++ b/linux/drivers/media/video/cx88/cx88-dsp.c=09Tue Apr 07 00:08:48 200=
9 +0200
> @@ -100,13 +100,22 @@
>  =09s32 s_prev2 =3D 0;
>  =09s32 coeff =3D 2*int_cos(freq);
>  =09u32 i;
> +
> +=09s64 tmp;
> +=09u32 remainder;
> +
>  =09for (i =3D 0; i < N; i++) {
>  =09=09s32 s =3D x[i] + ((s64)coeff*s_prev/32768) - s_prev2;
>  =09=09s_prev2 =3D s_prev;
>  =09=09s_prev =3D s;
>  =09}
> -=09return (u32)(((s64)s_prev2*s_prev2 + (s64)s_prev*s_prev -
> -=09=09      (s64)coeff*s_prev2*s_prev/32768)/N/N);
> +
> +=09tmp =3D (s64)s_prev2*s_prev2 + (s64)s_prev*s_prev -
> +=09=09      (s64)coeff*s_prev2*s_prev/32768;
> +
> +=09/* XXX: N must be low enough so that N*N fits in s32.
> +=09 * Else we need two divisions. */
> +=09return (u32) div_s64_rem(tmp, N*N, &remainder);
>  }
> =20
>  static u32 freq_magnitude(s16 x[], u32 N, u32 freq)
>=20
>=20
>=20
> ----- FILE: cx88-dsp_64bit_math2.patch -----
>=20
> cx88-dsp: fixing 64bit math on 32bit kernels
>=20
> From: Miroslav Sustek <sustmidown@centrum.cz>
> Signed-off-by: Miroslav Sustek <sustmidown@centrum.cz>
>=20
> diff -r 8aa1d865373c linux/drivers/media/video/cx88/cx88-dsp.c
> --- a/linux/drivers/media/video/cx88/cx88-dsp.c=09Wed Apr 01 20:25:00 200=
9 +0000
> +++ b/linux/drivers/media/video/cx88/cx88-dsp.c=09Tue Apr 07 00:26:10 200=
9 +0200
> @@ -100,13 +100,22 @@
>  =09s32 s_prev2 =3D 0;
>  =09s32 coeff =3D 2*int_cos(freq);
>  =09u32 i;
> +
> +=09s64 tmp;
> +=09u32 remainder;
> +
>  =09for (i =3D 0; i < N; i++) {
>  =09=09s32 s =3D x[i] + ((s64)coeff*s_prev/32768) - s_prev2;
>  =09=09s_prev2 =3D s_prev;
>  =09=09s_prev =3D s;
>  =09}
> -=09return (u32)(((s64)s_prev2*s_prev2 + (s64)s_prev*s_prev -
> -=09=09      (s64)coeff*s_prev2*s_prev/32768)/N/N);
> +
> +=09tmp =3D (s64)s_prev2*s_prev2 + (s64)s_prev*s_prev -
> +=09=09      (s64)coeff*s_prev2*s_prev/32768;
> +
> +=09tmp =3D div_s64_rem(tmp, N, &remainder);
> +
> +=09return (u32)div_s64_rem(tmp, N, &remainder);
>  }
> =20
>  static u32 freq_magnitude(s16 x[], u32 N, u32 freq)
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20
---943463948-1843581891-1239062926=:24672--
