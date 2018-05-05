Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:44278 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751684AbeEEHe3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 5 May 2018 03:34:29 -0400
Subject: Re: 4.17-rc3 regression in UVC driver
To: Sebastian Reichel <sre@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
References: <20180504181900.pm72mxyueqb3fu3z@earth.universe>
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
Message-ID: <3a5a32b0-a78d-571c-60af-416656f81e69@ideasonboard.com>
Date: Sat, 5 May 2018 08:34:23 +0100
MIME-Version: 1.0
In-Reply-To: <20180504181900.pm72mxyueqb3fu3z@earth.universe>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="YKKcJdQ08zHxxbJjuSHmkud0lpWPmtzzl"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--YKKcJdQ08zHxxbJjuSHmkud0lpWPmtzzl
Content-Type: multipart/mixed; boundary="0x9VZJI79S9k5Dn6A6pZmd7buvk2TDRoq";
 protected-headers="v1"
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
To: Sebastian Reichel <sre@kernel.org>,
 Linux Media Mailing List <linux-media@vger.kernel.org>,
 Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
 Mauro Carvalho Chehab <mchehab@kernel.org>
Message-ID: <3a5a32b0-a78d-571c-60af-416656f81e69@ideasonboard.com>
Subject: Re: 4.17-rc3 regression in UVC driver
References: <20180504181900.pm72mxyueqb3fu3z@earth.universe>
In-Reply-To: <20180504181900.pm72mxyueqb3fu3z@earth.universe>

--0x9VZJI79S9k5Dn6A6pZmd7buvk2TDRoq
Content-Type: text/plain; charset=windows-1252
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable

Hi Sebastian,

On 04/05/18 19:45, Sebastian Reichel wrote:
> Hi,
>=20
> I just got the following error message every ms with 4.17-rc3 after
> upgrading to for first ~192 seconds after system start (Debian
> 4.17~rc3-1~exp1 kernel) on my Thinkpad X250:
>=20
>> uvcvideo: Failed to query (GET_MIN) UVC control 2 on unit 1: -32 (exp.=
 1).

I have submitted a patch to fix this ... (and I thought it would have got=
 in by
now ... so I'll chase this up)


Please see : https://patchwork.linuxtv.org/patch/48043/ and apply the pat=
ch to
bring your system logs back to a reasonable state :D

Laurent, Mauro,

This is the second bug report I've had on this topic.
Can we aim to get this patch merged please?

> I see /dev/video0 and /dev/video1. The first one seems to be
> functional. The second one does not work and does not make
> sense to me (the system has only one webcam). I did not try to
> bisect anything. Here is some more information, that might
> be useful:

There are two device nodes now, as one is provided to output meta-data or=
 such.


>> sre@earth ~ % mpv /dev/video1=20
>> Playing: /dev/video1
>> [ffmpeg/demuxer] video4linux2,v4l2: ioctl(VIDIOC_G_INPUT): Inappropria=
te ioctl for device
>> [lavf] avformat_open_input() failed
>> Failed to recognize file format.
>> sre@earth ~ % udevadm info /dev/video0
>> P: /devices/pci0000:00/0000:00:14.0/usb1/1-8/1-8:1.0/video4linux/video=
0
>> N: video0
>> E: DEVNAME=3D/dev/video0
>> E: DEVPATH=3D/devices/pci0000:00/0000:00:14.0/usb1/1-8/1-8:1.0/video4l=
inux/video0
>> E: MAJOR=3D81
>> E: MINOR=3D0
>> E: SUBSYSTEM=3Dvideo4linux
>> sre@earth ~ % udevadm info /dev/video1
>> P: /devices/pci0000:00/0000:00:14.0/usb1/1-8/1-8:1.0/video4linux/video=
1
>> N: video1
>> E: DEVNAME=3D/dev/video1
>> E: DEVPATH=3D/devices/pci0000:00/0000:00:14.0/usb1/1-8/1-8:1.0/video4l=
inux/video1
>> E: MAJOR=3D81
>> E: MINOR=3D1
>> E: SUBSYSTEM=3Dvideo4linux
>> sre@earth ~ % lsusb -d 04ca:703c
>> Bus 001 Device 004: ID 04ca:703c Lite-On Technology Corp.=20
>=20
> -- Sebastian


Regards

Kieran


--0x9VZJI79S9k5Dn6A6pZmd7buvk2TDRoq--

--YKKcJdQ08zHxxbJjuSHmkud0lpWPmtzzl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEkC3XmD+9KP3jctR6oR5GchCkYf0FAlrtXn8ACgkQoR5GchCk
Yf0T7A/8C3rO96vBcrkUI+ZMO0UwBuzEZUAHfMfQHVgI9l4t7cK2u4bufYyudoUc
u0gGx5NDsdF0GqzGK7pR+fnGMCmapZg3zlKt+Bmv3zdqj23lOnvg+zaNDxqo96ZU
lP3h/KEBfBUxNdtcmVVxj1qpMAiLEO+UiQJa7dVr4Iso5nR95+fjYFXRe5rUWfuo
BfQz47VvxgzNpCgSCj6G0OAadJ+Idt+Iz38xiFIchJsNf9T6wTcJHF98Q1oEM567
llxitazBhiw8totvVKhBBV7kLQr4TXXpKL0OL/j2bP4YghXy7Pcv8Tg4O0C1DwOu
OgWUo9ZX4KDIqtmgnDmN5ynGlGVtiuvu7fjT8WNu88pMHjd+R2+wz6f4rVPkgTFk
4sDnL+OosovnoQ1kR46PrzUjakv97Bo6NYqgmi+AuBpNE3zwbJ46RblxtT0Yn2wF
Ia0Ve1MoH+h88fRucMvrDXlGNaEKMVg6FBAKEOOz7ND39Ys5YRJV/tnUXCI4vm82
jjbUFAp0/OtLpnSnMo+lPl5nfpgmIfPfNsCf6+UuyldN9Ctj/bZtduQOHKcUxCe8
Mu2kNx3xzMLjXFEak08NFIyvZ4s0xVJQiJryqjG5id+Kzkj2FAXOZfR9ecK4x0cr
mzHrIJB/DvekwaCvvMX3ICCvFKxiR7zohmcuFSDVAHTs/bF1u0U=
=Hcoe
-----END PGP SIGNATURE-----

--YKKcJdQ08zHxxbJjuSHmkud0lpWPmtzzl--
