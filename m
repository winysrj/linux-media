Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out26.alice.it ([85.33.2.26]:1703 "EHLO
	smtp-out26.alice.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750AbZJBTfg (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Oct 2009 15:35:36 -0400
Date: Fri, 2 Oct 2009 21:35:30 +0200
From: Antonio Ospite <ospite@studenti.unina.it>
To: linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Robert Jarzmik <robert.jarzmik@free.fr>
Subject: pxa_camera + mt9m1111:  Failed to configure for format 50323234
Message-Id: <20091002213530.104a5009.ospite@studenti.unina.it>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__2_Oct_2009_21_35_30_+0200_Q.XmY.lm/Xq_y536"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Signature=_Fri__2_Oct_2009_21_35_30_+0200_Q.XmY.lm/Xq_y536
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

after updating to 2.6.32-rc2 I can't capture anymore with the setup in the
subject.

Here's the message from userspace:
  # ./capture-example=20
  Cannot open '/dev/video0': 22, Invalid argument
which is from the very first open() call.

Here's the relevant snippet from dmesg with debug enabled:
[   15.613749] i2c /dev entries driver
[   15.626308] Linux video capture interface: v2.00
[   15.640834] pxa27x-camera pxa27x-camera.0: Limiting master clock to 2600=
0000
[   15.648696] pxa27x-camera pxa27x-camera.0: LCD clock 104000000Hz, target=
 freq 26000000Hz, divisor 1
[   15.656494] pxa27x-camera pxa27x-camera.0: got DMA channel 1
[   15.665398] pxa27x-camera pxa27x-camera.0: got DMA channel (U) 2
[   15.673461] pxa27x-camera pxa27x-camera.0: got DMA channel (V) 3
[   15.686771] camera 0-0: Probing 0-0
[   15.707545] pxa27x-camera pxa27x-camera.0: Registered platform device at=
 cc889380 data c03a1e98
[   15.715265] pxa27x-camera pxa27x-camera.0: pxa_camera_activate: Init gpi=
os
[   15.723488] pxa27x-camera pxa27x-camera.0: PXA Camera driver attached to=
 camera 0
[   15.739092] mt9m111 0-005d: read  reg.00d -> 0008
[   15.743812] mt9m111 0-005d: write reg.00d =3D 0008 -> 0
[   15.748702] mt9m111 0-005d: read  reg.00d -> 0008
[   15.753237] mt9m111 0-005d: write reg.00d =3D 0009 -> 0
[   15.757864] mt9m111 0-005d: read  reg.00d -> 0009
[   15.762386] mt9m111 0-005d: write reg.00d =3D 0029 -> 0
[   15.766938] mt9m111 0-005d: read  reg.00d -> 0029
[   15.771670] mt9m111 0-005d: write reg.00d =3D 0008 -> 0
[   15.776136] mt9m111 0-005d: write reg.0c8 =3D 970b -> 0
[   15.781325] mt9m111 0-005d: read  reg.106 -> 700e
[   15.785695] mt9m111 0-005d: write reg.106 =3D 700e -> 0
[   15.792896] mt9m111 0-005d: read  reg.000 -> 143a
[   15.796790] mt9m111 0-005d: Detected a MT9M11x chip ID 143a
[   15.805505] pxa27x-camera pxa27x-camera.0: Providing format Planar YUV42=
2 16 bit using CbYCrY 16 bit
[   15.813285] pxa27x-camera pxa27x-camera.0: Providing format CbYCrY 16 bi=
t packed
[   15.820729] pxa27x-camera pxa27x-camera.0: Providing format CrYCbY 16 bi=
t packed
[   15.828221] pxa27x-camera pxa27x-camera.0: Providing format YCbYCr 16 bi=
t packed
[   15.835484] pxa27x-camera pxa27x-camera.0: Providing format YCrYCb 16 bi=
t packed
[   15.842888] pxa27x-camera pxa27x-camera.0: Providing format RGB 565 pack=
ed
[   15.850455] pxa27x-camera pxa27x-camera.0: Providing format RGB 555 pack=
ed
[   15.858077] pxa27x-camera pxa27x-camera.0: Providing format Bayer (sRGB)=
 8 bit in pass-through mode
[   15.872455] pxa27x-camera pxa27x-camera.0: PXA Camera driver detached fr=
om camera 0
...
[   70.377781] pxa27x-camera pxa27x-camera.0: Registered platform device at=
 cc889380 data c03a1e98
[   70.377866] pxa27x-camera pxa27x-camera.0: pxa_camera_activate: Init gpi=
os
[   70.378259] pxa27x-camera pxa27x-camera.0: PXA Camera driver attached to=
 camera 0
[   70.378336] mt9m111 0-005d: mt9m111_s_fmt fmt=3D50323234 left=3D24, top=
=3D8, width=3D1280, height=3D1024
[   70.379630] mt9m111 0-005d: write reg.002 =3D 0018 -> 0
[   70.380589] mt9m111 0-005d: write reg.001 =3D 0008 -> 0
[   70.382382] mt9m111 0-005d: write reg.1a0 =3D 0500 -> 0
[   70.383347] mt9m111 0-005d: write reg.1a3 =3D 0400 -> 0
[   70.384312] mt9m111 0-005d: write reg.1a1 =3D 0500 -> 0
[   70.385267] mt9m111 0-005d: write reg.1a4 =3D 0400 -> 0
[   70.386227] mt9m111 0-005d: write reg.1a6 =3D 0500 -> 0
[   70.387188] mt9m111 0-005d: write reg.1a9 =3D 0400 -> 0
[   70.393180] mt9m111 0-005d: write reg.1a7 =3D 0500 -> 0
[   70.394155] mt9m111 0-005d: write reg.1aa =3D 0400 -> 0
[   70.394224] mt9m111 0-005d: Pixel format not handled : 50323234
[   70.394265] pxa27x-camera pxa27x-camera.0: Failed to configure for forma=
t 50323234
[   70.394310] pxa27x-camera pxa27x-camera.0: PXA Camera driver detached fr=
om camera 0

Format 50323234 is 422P, it looks like pxa-camera is trying to force
its native format to the sensor, but I am still investigating; I'll come
back when I find more or if I come up with a solution.

Thanks,
   Antonio

--=20
Antonio Ospite
http://ao2.it

PGP public key ID: 0x4553B001

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?
A: Top-posting.
Q: What is the most annoying thing in e-mail?

--Signature=_Fri__2_Oct_2009_21_35_30_+0200_Q.XmY.lm/Xq_y536
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkrGVgIACgkQ5xr2akVTsAH7rgCeLcNl0La0qVdo6QvQ7VpY5oaG
Np4An37n+KSwlz/uEBuhk/gUoCyLonF3
=X/S2
-----END PGP SIGNATURE-----

--Signature=_Fri__2_Oct_2009_21_35_30_+0200_Q.XmY.lm/Xq_y536--
