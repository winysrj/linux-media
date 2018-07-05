Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.220.in.ua ([89.184.67.205]:49571 "EHLO smtp.220.in.ua"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753935AbeGENfh (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 5 Jul 2018 09:35:37 -0400
Subject: Re: Video capturing
To: Nicolas Dufresne <nicolas@ndufresne.ca>
Cc: DVB_Linux_Media <linux-media@vger.kernel.org>
References: <7a41465a-483b-9ce5-4e8f-1f005e2060f9@kaa.org.ua>
 <CAKQmDh-ALkK+6HkzN1SjXgeoGsZNUZYkb__N4063M7U5aRsAnw@mail.gmail.com>
From: Oleh Kravchenko <oleg@kaa.org.ua>
Message-ID: <b1e0a06c-ee55-252a-ded5-22b421e2a7e5@kaa.org.ua>
Date: Thu, 5 Jul 2018 16:35:20 +0300
MIME-Version: 1.0
In-Reply-To: <CAKQmDh-ALkK+6HkzN1SjXgeoGsZNUZYkb__N4063M7U5aRsAnw@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="pzHxIRT0v1M9AJYAwK9PuZE5cAOATDs7F"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--pzHxIRT0v1M9AJYAwK9PuZE5cAOATDs7F
Content-Type: multipart/mixed; boundary="nQ5qY0QIaafWVuUerdiFbRrAOnZ7wSZw8";
 protected-headers="v1"
From: Oleh Kravchenko <oleg@kaa.org.ua>
To: Nicolas Dufresne <nicolas@ndufresne.ca>
Cc: DVB_Linux_Media <linux-media@vger.kernel.org>
Message-ID: <b1e0a06c-ee55-252a-ded5-22b421e2a7e5@kaa.org.ua>
Subject: Re: Video capturing
References: <7a41465a-483b-9ce5-4e8f-1f005e2060f9@kaa.org.ua>
 <CAKQmDh-ALkK+6HkzN1SjXgeoGsZNUZYkb__N4063M7U5aRsAnw@mail.gmail.com>
In-Reply-To: <CAKQmDh-ALkK+6HkzN1SjXgeoGsZNUZYkb__N4063M7U5aRsAnw@mail.gmail.com>

--nQ5qY0QIaafWVuUerdiFbRrAOnZ7wSZw8
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-GB

Hello Nicolas,

On 05.07.18 15:57, Nicolas Dufresne wrote:
>
>
> Le jeu. 5 juil. 2018 05:28, Oleh Kravchenko <oleg@kaa.org.ua
> <mailto:oleg@kaa.org.ua>> a =C3=A9crit=C2=A0:
>
>     Hello!
>
>     Yesterday I tried to capture video from old game console (PAL) and
>     got an image like this
>     https://www.kaa.org.ua/images/EvromediaUSBFullHybridFullHD/mplayer_=
nes.png
>
>
> Can you describe how this image was captured ? Can you give some
> details about your tv tuner? Do you also use GStreamer on RPi?

I have those TV tuners:
=C2=A0=C2=A0=C2=A0 AVerTV Hybrid Express Slim HC81R
=C2=A0=C2=A0=C2=A0 Evromedia USB Full Hybrid Full HD
=C2=A0=C2=A0=C2=A0 Astrometa T2hybrid

Here examples with mplayer and mpv:
=C2=A0=C2=A0=C2=A0 mplayer tv:///1 -tv
width=3D720:height=3D576:adevice=3Dhw.2:alsa=3D1:amode=3D0:forceaudio=3D1=
:immediatemode=3D0:norm=3Dpal
=C2=A0=C2=A0=C2=A0 mpv tv:///1 --tv-width=3D720 --tv-height=3D576 --tv-ad=
evice=3Dhw.2
--tv-alsa --tv-amode=3D0 --tv-forceaudio=3Dyes --tv-immediatemode=3Dno
--tv-norm=3Dpal

I didn't use GStreamer on RPi, because in my case RPi is a source of
video signal for TV tuner.

>
>
>
>     I tried different TV norms, but no success.
>     At the same time that video console works fine with my TV!
>     My TV tuners works fine with Nokia N900 (PAL, NTSC), Raspberry Pi
>     (PAL),
>     PlayStation 3 (PAL).
>
>     Any idea what it can be?
>
>     PS:
>     By the way, is allowed to send screenshots and photos as
>     attachments in
>     this mail list?
>
>     --=20
>     Best regards,
>     Oleh Kravchenko
>
>

--=20
Best regards,
Oleh Kravchenko



--nQ5qY0QIaafWVuUerdiFbRrAOnZ7wSZw8--

--pzHxIRT0v1M9AJYAwK9PuZE5cAOATDs7F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEC/TM5t+2NenFhW0Q0xNJm20pl4wFAls+HpsACgkQ0xNJm20p
l4zerQ/+Ma4EnhwgMPXamQ0f6CsKfhvVrv8U7QaLA2bx+C0+zn7/6PjquthjLkGd
tauiDlJUahtwyn4iHB2gGrucW+T/Dn+eYu0XEMj40h106ICtuJooJheH0tfrHBop
F18kqEiOFRW/f6zYP+9tMwk1ZOOKKTNh4iCebpOQ9zbnirpMfIIJHwq0AIPRMu32
kJrOIgNbZjetzF87p5x2c8ZN3DltycVD1CvJCfH7uO27xUjAf36YJ4WlyfDpehj3
EgVD96I3TTc6IxLcLpgzv21ueCmDAQX2d5HFoMbafC+9ZeAp56I/Y9FQ0WFKKa08
fCbknkOLRfOegMYjZmReuc8pfpMB+DrbMaiDRsVmxz5RbNrSFKb47xfWS69DiZBy
LiwQV8wpGoIkMFJ/jZUiRpY09TaVP/MJiXs1bcgdYgN9DxWsa2F4V6A4kiOR9K2g
ZL8m7P9pMmxsIaoMCPxHxvInT7E7o4PYO1kImVWFTihs89VtsguIsJrJV46XoF2a
y0t0bWAilTOAcBCg3T4h8orKMXB8KdNKGQis2+SV3b0BNzF6HUdJ0LiZFpqEUgc7
4M+HTAiq488FS6gnhfFXby06Ebz6pkJ82CJ1PUtG+IuX1s6g5QBYJDU6SFBpmvLJ
GuY4Z9c97KiJD+UvczYl3ODan8/7IKijFVZ44KoYXh71fBhpfbs=
=km+x
-----END PGP SIGNATURE-----

--pzHxIRT0v1M9AJYAwK9PuZE5cAOATDs7F--
