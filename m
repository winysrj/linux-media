Return-path: <linux-media-owner@vger.kernel.org>
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.216]:35205 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751786AbdF0FuH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Jun 2017 01:50:07 -0400
Subject: Re: omap3isp camera was Re: [PATCH v1 0/6] Add support of OV9655 camera
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: multipart/signed; boundary="Apple-Mail=_E0510E08-BD15-4C3D-BE33-75F5B8827AC9"; protocol="application/pgp-signature"; micalg=pgp-sha256
From: "H. Nikolaus Schaller" <hns@goldelico.com>
In-Reply-To: <20170626111621.GC11688@amd>
Date: Tue, 27 Jun 2017 07:49:32 +0200
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
Message-Id: <A9421661-7E24-4B5D-A0FA-10838A0F12BD@goldelico.com>
References: <1498143942-12682-1-git-send-email-hugues.fruchet@st.com> <385A82AC-CC23-41BD-9F57-0232F713FED9@goldelico.com> <1E453955-0C1A-414B-BBB2-C64B6D0EF378@goldelico.com> <20170625091856.GA22791@amd> <EDFD663F-37F9-42C2-92A9-66C2508B361E@goldelico.com> <20170626083927.GB9621@amd> <5364AD62-5000-451E-B3F7-93D49A91EED5@goldelico.com> <20170626111621.GC11688@amd>
To: Pavel Machek <pavel@ucw.cz>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--Apple-Mail=_E0510E08-BD15-4C3D-BE33-75F5B8827AC9
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii


> Am 26.06.2017 um 13:16 schrieb Pavel Machek <pavel@ucw.cz>:
>=20
> Hi!
>=20
>>> You may want to try this one:
>>>=20
>>> commit 0eae9d2a8f096f703cbc8f9a0ab155cd3cc14cef
>>> Author: Pavel <pavel@ucw.cz>
>>> Date:   Mon Feb 13 21:26:51 2017 +0100
>>>=20
>>>   omap3isp: fix VP2SDR bit so capture (not preview) works
>>>=20
>>>   This is neccessary for capture (not preview) to work properly on
>>>       N900. Why is unknown.
>>=20
>> Ah, interesting. I will give it a try.
>>=20
>> Do you please have a link to the repo where this commit can be
>>> found?
>=20
> This branch, as mentioned before:
>=20
> =
https://git.kernel.org/pub/scm/linux/kernel/git/pavel/linux-n900.git/log/?=
h=3Dcamera-fw5-6

Thanks.

I have merged this patch but unfortunately, it does not make the green =
screen go away.

Neither with our own driver nor with the new one by Hugues (which turned =
out to not
support SXGA at all but I tried VGA).

I think we should postpone debugging this until Hugues proposed patches =
are better reviewed.

BR and thanks,
Nikolaus


--Apple-Mail=_E0510E08-BD15-4C3D-BE33-75F5B8827AC9
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJZUfHtAAoJEIl79TGLgAm6Jx4QAJQQZWav2tguF4n5heaBw/Sa
hxqN0cjdGv6cbQ+SwRQEW/SPb/4nTHjyHCLUeoJKl23mjJ+chFmdRdpI2mO0Iadk
BTpuFKZziKvWdcjSmMuGxe8aeimolgh6iOLZ1hQBD2w4Xq14/2X168nvX3u8I9oJ
A7T6vOF2U8UOZ16Zlmy2u9/um0a3NLXmaCb7tK9+j+5WtX9bEY9JwQu5z3llUjMM
53zkXZLqNBgy8PlhtOyPtrQAYg6PedGOeil1AMk/oraCTDdXZ6AHaHh76D4qrtGS
3XhVXmy+yBO/UqvdzsD6TVhbSmmvg+peczwu5RCD3gmoJHqPa69jNon1Nq4dJB1n
Cl00ApDrauhVjJfqU6G58bepbiQlEbhDXmAy/S8pocSuPv/4GIHHYhsW+j2//6TE
yOp6mPH5GB0pKqb8rMOZN6vpJX9c945PWKwe2VG5gSJPFrAWNmPe4tZ9tNeJSMqp
jsNtgkJiHIbfS9+R1xEXX66oH/Qz6P/EhEfPnPmqZ0V3hgQOqtFmZ8J95pKQV9Cj
bwoIoylCUXj0uphr6I5GDLx2Lz8KDsk0K1mFv12rzMDjA85ad1qKnP+rPU1gVBOZ
L6/d2qIZtn5YlVEuuiyJBDbtvSFMsxxWm0rr49s0/nU65gCPTwgSWvQlm7KVzyVR
s0puUtKkbc2fzrlDLm9L
=jMNU
-----END PGP SIGNATURE-----

--Apple-Mail=_E0510E08-BD15-4C3D-BE33-75F5B8827AC9--
