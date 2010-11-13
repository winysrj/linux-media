Return-path: <mchehab@pedra>
Received: from smtp207.alice.it ([82.57.200.103]:33193 "EHLO smtp207.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754574Ab0KMPMP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Nov 2010 10:12:15 -0500
Date: Sat, 13 Nov 2010 16:12:05 +0100
From: Antonio Ospite <ospite@studenti.unina.it>
To: linux-media@vger.kernel.org
Cc: =?ISO-8859-1?Q?Jean-Fran=E7ois?= Moine <moinejf@free.fr>
Subject: gspca_ov534: Changing framerates, different behaviour in 2.6.36
Message-Id: <20101113161205.b94cb748.ospite@studenti.unina.it>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sat__13_Nov_2010_16_12_05_+0100_TbU/lAmskvPBM2Ud"
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

--Signature=_Sat__13_Nov_2010_16_12_05_+0100_TbU/lAmskvPBM2Ud
Content-Type: text/plain; charset=ISO-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

in 2.6.36 and later there is a change of behavior when changing
framerates with the gspca_ov534 driver, here's what happens using
guvcview:

If I:
 1. Go to the "Video & Files Tab"
 2. Change the "Frame Rate" value from the drop down menu

in 2.6.35:
 3a. dmesg shows the message: ov534: frame_rate: xx
 3b. The frame rate is changed and the guvcview preview window shows
     the different capture speed

since 2.6.36 + the regression fix in [1] (please apply it):
 3a. dmesg shows the message: ov534: frame_rate: xx
 3b. guvcviews gives some errors and the preview image halts:
       VIDIOC_QBUF - Unable to queue buffer: Invalid argument
       Could not grab image (select timeout):
                  Resource temporarily unavailable

Setting framerates works only once per device opening (tested with
"luvcview -i xx"), it's just changing it "live" that is broken in newer
kernels.

I am trying to spot what caused this, I guess it is something in
gspca_main, hopefully Jean-Fran=E7ois has some idea that can help me
narrowing down the search.

Note that AFAIK gspca_ov534 is the only gspca driver enumerating
framerates with VIDIOC_ENUM_FRAMEINTERVALS, but from a quick look
nothing changed in this area.

Thanks,
   Antonio

[1]
http://article.gmane.org/gmane.linux.drivers.video-input-infrastructure/248=
99

--=20
Antonio Ospite
http://ao2.it

PGP public key ID: 0x4553B001

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?

--Signature=_Sat__13_Nov_2010_16_12_05_+0100_TbU/lAmskvPBM2Ud
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkzeqsUACgkQ5xr2akVTsAEy/ACgloI6Q9F977u2h5iHPtyqqi+s
4R0AnimGuDmH6nFtoSa9BAyNgSbcv4N+
=UFqP
-----END PGP SIGNATURE-----

--Signature=_Sat__13_Nov_2010_16_12_05_+0100_TbU/lAmskvPBM2Ud--
