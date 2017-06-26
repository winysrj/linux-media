Return-path: <linux-media-owner@vger.kernel.org>
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.217]:24326 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751413AbdFZJyj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Jun 2017 05:54:39 -0400
Subject: Re: omap3isp camera was Re: [PATCH v1 0/6] Add support of OV9655 camera
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: multipart/signed; boundary="Apple-Mail=_80F9AD7E-633A-439E-AB03-AC3CC83EB95D"; protocol="application/pgp-signature"; micalg=pgp-sha256
From: "H. Nikolaus Schaller" <hns@goldelico.com>
In-Reply-To: <20170626083927.GB9621@amd>
Date: Mon, 26 Jun 2017 11:53:34 +0200
Cc: Hugues Fruchet <hugues.fruchet@st.com>,
        Mark Rutland <mark.rutland@arm.com>,
        devicetree <devicetree@vger.kernel.org>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Rob Herring <robh+dt@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Yannick Fertre <yannick.fertre@st.com>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-media@vger.kernel.org,
        Discussions about the Letux Kernel
        <letux-kernel@openphoenux.org>
Message-Id: <5364AD62-5000-451E-B3F7-93D49A91EED5@goldelico.com>
References: <1498143942-12682-1-git-send-email-hugues.fruchet@st.com> <385A82AC-CC23-41BD-9F57-0232F713FED9@goldelico.com> <1E453955-0C1A-414B-BBB2-C64B6D0EF378@goldelico.com> <20170625091856.GA22791@amd> <EDFD663F-37F9-42C2-92A9-66C2508B361E@goldelico.com> <20170626083927.GB9621@amd>
To: Pavel Machek <pavel@ucw.cz>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--Apple-Mail=_80F9AD7E-633A-439E-AB03-AC3CC83EB95D
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

Hi Pavel,

> Am 26.06.2017 um 10:39 schrieb Pavel Machek <pavel@ucw.cz>:
>=20
> On Mon 2017-06-26 08:05:04, H. Nikolaus Schaller wrote:
>> Hi Pavel,
>>=20
>>> Am 25.06.2017 um 11:18 schrieb Pavel Machek <pavel@ucw.cz>:
>>>=20
>>> Hi!
>>>=20
>>>> * unfortunately we still get no image :(
>>>>=20
>>>> The latter is likely a setup issue of our camera interface (OMAP3 =
ISP =3D Image Signal Processor) which
>>>> we were not yet able to solve. Oscilloscoping signals on the =
interface indicated that signals and
>>>> sync are correct. But we do not know since mplayer only shows a =
green screen.
>>>=20
>>> What mplayer command line do you use? How did you set up the =
pipeline
>>> with media-ctl?
>>>=20
>>> On kernel.org, I have tree called camera-fw5-6 , where camera works
>>> for me on n900. On gitlab, there's modifed fcam-dev, which can be =
used
>>> for testing.
>>=20
>> We did have yet another (non-DT) camera driver and media-ctl working =
in with 3.12.37,
>> but had no success yet to update it to work with modern kernels or =
drivers. It
>> is either that the (newer) drivers missing something or the media-ctl =
has changed.
>>=20
>> Here is the log of our scripts with Hugues' driver and our latest =
setup:
>>=20
>> root@letux:~# ./camera-demo sxga
>> DISPLAY=3D:0
>> XAUTHORITY=3Dtcp
>> Camera: /dev/v4l-subdev8
>> Setting mode sxga
>> media-ctl -r
>> media-ctl -l '"ov965x":0 -> "OMAP3 ISP CCDC":0[1]'
>> media-ctl -l '"OMAP3 ISP CCDC":1 -> "OMAP3 ISP CCDC output":0[1]'
>> media-ctl -V '"ov965x":0 [UYVY2X8 1280x1024]'
>> media-ctl -V '"OMAP3 ISP CCDC":0 [UYVY2X8 1280x1024]'
>> media-ctl -V '"OMAP3 ISP CCDC":1 [UYVY 1280x1024]'
>=20
> Ok, so you are using capture, not preview.

Yes.

>=20
> You may want to try this one:
>=20
> commit 0eae9d2a8f096f703cbc8f9a0ab155cd3cc14cef
> Author: Pavel <pavel@ucw.cz>
> Date:   Mon Feb 13 21:26:51 2017 +0100
>=20
>    omap3isp: fix VP2SDR bit so capture (not preview) works
>=20
>    This is neccessary for capture (not preview) to work properly on
>        N900. Why is unknown.

Ah, interesting. I will give it a try.

Do you please have a link to the repo where this commit can be found?

BR and thanks,
Nikolaus

>=20
> 									=
Pavel
>=20
>> ### starting mplayer in sxga mode ###
>> mplayer tv:// -vf rotate=3D2 -tv =
driver=3Dv4l2:device=3D/dev/video2:outfmt=3Duyvy:width=3D1280:height=3D102=
4:fps=3D15 -vo x11
>> MPlayer2 2.0-728-g2c378c7-4+b1 (C) 2000-2012 MPlayer Team
>>=20
>> Playing tv://.
>> Detected file format: TV
>> Selected driver: v4l2
>> name: Video 4 Linux 2 input
>> author: Martin Olschewski <olschewski@zpr.uni-koeln.de>
>> comment: first try, more to come ;-)
>> v4l2: ioctl get standard failed: Invalid argument
>> Selected device: OMAP3 ISP CCDC output
>> Capabilities:  video capture  video output  streaming
>> supported norms:
>> inputs: 0 =3D camera;
>> Current input: 0
>> Current format: unknown (0x0)
>> tv.c: norm_from_string(pal): Bogus norm parameter, setting default.
>> v4l2: ioctl enum norm failed: Inappropriate ioctl for device
>> Error: Cannot set norm!
>> Selected input hasn't got a tuner!
>> v4l2: ioctl set mute failed: Inappropriate ioctl for device
>> v4l2: ioctl query control failed: Inappropriate ioctl for device
>> v4l2: ioctl query control failed: Inappropriate ioctl for device
>> v4l2: ioctl query control failed: Inappropriate ioctl for device
>> v4l2: ioctl query control failed: Inappropriate ioctl for device
>> v4l2: ioctl streamon failed: Broken pipe
>> [ass] auto-open
>> Opening video filter: [rotate=3D2]
>> VIDEO:  1280x1024  15.000 fps    0.0 kbps ( 0.0 kB/s)
>> Could not find matching colorspace - retrying with -vf scale...
>> Opening video filter: [scale]
>> [swscaler @ 0xb5ca9980]using unscaled uyvy422 -> yuv420p special =
converter
>> VO: [x11] 1024x1280 =3D> 1024x1280 Planar YV12
>> [swscaler @ 0xb5ca9980]No accelerated colorspace conversion found =
from yuv420p to bgra.
>> Colorspace details not fully supported by selected vo.
>> Selected video codec: RAW UYVY [raw]
>> Audio: no sound
>> Starting playback...
>> V:   0.0  10/ 10 ??% ??% ??,?% 0 0 $<3>
>>=20
>>=20
>> MPlayer interrupted by signal 2 in module: filter_video
>> V:   0.0  11/ 11 ??% ??% ??,?% 0 0 $<3>
>> v4l2: ioctl set mute failed: Inappropriate ioctl for device
>> v4l2: 0 frames successfully processed, 0 frames dropped.
>>=20
>> Exiting... (Quit)
>> root@letux:~#
>>=20
>> BR and thanks,
>> Nikolaus
>>=20
>=20
>=20
>=20
> --
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) =
http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html


--Apple-Mail=_80F9AD7E-633A-439E-AB03-AC3CC83EB95D
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJZUNmfAAoJEIl79TGLgAm6H54P/jmXSvH/HuUERrbUtO5hHp8z
Ts8XYfuGh8WZ/8lAUn4Tkj/c98KcBRW1VfQd9ivzmL2Nc5SFBHh5l5RsDvajbf6Y
Zzv3LfzPZyogJt0Rwr3AxghuUNAFWXFz5TgwpVEL0avkwSeFDT878WOllVdhRfqd
P1E9eJXpkmwfjJP767RhKO+pOK9jYrIerZXxUeEoR0INDMkEQ/+oZvUkif3atnPx
rIQNGM11AHcLHL9IbIjG7OrtTIlLEJxpXunbi4pJ5qYldiqPURjZjY70cutTxokq
cmkecW2iwQPy1tkCpad0t73gOQHpev1jhNohGtYNvzlLKHaIapnrCSieKfBy6dDe
jxMYtriXOrrkxa7Ztvyu8MBZazJi0KCIqRhpeT2BrSZSf5VpNVbDFCc5g3ls0B/t
yw32XaaPgOuiZ/+7efDK2JaLmROVua6XTHBPgGbeYvxbyqwy+qn/c26/QeEmwP0x
aHfLUPqVcE64cm7AL5mgE/qu8BBXPyWmitWqpWeLPnGj8uXRWz7fgPqmchbn8Xi3
oBi8YZg/hlSWfn0DzjSsGyNajKsBjK53tM7SVGbmmELDUc6gpqe71wN5ug93Nm5e
RERBft1VIb8Cq9IcB+6DAPGJUQ7K+vdzaKEPeXJ0qvroNyJ22QuDWzc7BG/7c6Bq
1EJVXSdqrSbzDPSrDTA5
=06iB
-----END PGP SIGNATURE-----

--Apple-Mail=_80F9AD7E-633A-439E-AB03-AC3CC83EB95D--
