Return-path: <linux-media-owner@vger.kernel.org>
Received: from butterbrot.org ([176.9.106.16]:50799 "EHLO butterbrot.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932874AbcGEG4z (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 5 Jul 2016 02:56:55 -0400
Subject: Re: [PATCH v2 1/3] sur40: properly report a single frame rate of 60
 FPS
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
References: <1464725733-22119-1-git-send-email-floe@butterbrot.org>
 <f5d84d25-eae4-df9b-819b-256565783c35@xs4all.nl>
Cc: linux-input@vger.kernel.org, Martin Kaltenbrunner <modin@yuri.at>
From: Florian Echtler <floe@butterbrot.org>
Message-ID: <577B5A2B.5060406@butterbrot.org>
Date: Tue, 5 Jul 2016 08:56:43 +0200
MIME-Version: 1.0
In-Reply-To: <f5d84d25-eae4-df9b-819b-256565783c35@xs4all.nl>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="LmhQLMHr6gTQLE6p9w89nMC1u7vmeFA9V"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--LmhQLMHr6gTQLE6p9w89nMC1u7vmeFA9V
Content-Type: multipart/mixed; boundary="QfClaveok7nxHO37ADG22605Tp81lkIwO"
From: Florian Echtler <floe@butterbrot.org>
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: linux-input@vger.kernel.org, Martin Kaltenbrunner <modin@yuri.at>
Message-ID: <577B5A2B.5060406@butterbrot.org>
Subject: Re: [PATCH v2 1/3] sur40: properly report a single frame rate of 60
 FPS
References: <1464725733-22119-1-git-send-email-floe@butterbrot.org>
 <f5d84d25-eae4-df9b-819b-256565783c35@xs4all.nl>
In-Reply-To: <f5d84d25-eae4-df9b-819b-256565783c35@xs4all.nl>

--QfClaveok7nxHO37ADG22605Tp81lkIwO
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hello Hans,

On 05.07.2016 08:41, Hans Verkuil wrote:
> On 05/31/2016 10:15 PM, Florian Echtler wrote:
>> The device hardware is always running at 60 FPS, so report this both v=
ia
>> PARM_IOCTL and ENUM_FRAMEINTERVALS.
>>
>> Signed-off-by: Martin Kaltenbrunner <modin@yuri.at>
>> Signed-off-by: Florian Echtler <floe@butterbrot.org>
>> ---
>>  drivers/input/touchscreen/sur40.c | 20 ++++++++++++++++++--
>>  1 file changed, 18 insertions(+), 2 deletions(-)
>>
>> @@ -880,6 +893,9 @@ static const struct v4l2_ioctl_ops sur40_video_ioc=
tl_ops =3D {
>>  	.vidioc_enum_framesizes =3D sur40_vidioc_enum_framesizes,
>>  	.vidioc_enum_frameintervals =3D sur40_vidioc_enum_frameintervals,
>> =20
>> +	.vidioc_g_parm =3D sur40_ioctl_parm,
>> +	.vidioc_s_parm =3D sur40_ioctl_parm,
>=20
> Why is s_parm added when you can't change the framerate?

Oh, I thought it's mandatory to always have s_parm if you have g_parm
(even if it always returns the same values).

> Same questions for the
> enum_frameintervals function: it doesn't hurt to have it, but if there =
is only
> one unchangeable framerate, then it doesn't make much sense.

If you don't have enum_frameintervals, how would you find out about the
framerate otherwise? Is g_parm itself enough already for all userspace
tools?

> Sorry, missed this when I reviewed this the first time around.

No problem.

Best, Florian
--=20
SENT FROM MY DEC VT50 TERMINAL


--QfClaveok7nxHO37ADG22605Tp81lkIwO--

--LmhQLMHr6gTQLE6p9w89nMC1u7vmeFA9V
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iEYEARECAAYFAld7Wi0ACgkQ7CzyshGvatjqpgCgpZ/bGXypaCWDrU2uR8jCYiQR
0/4An11zkpOQsqvR9Mi4cbbjW2MgjOuc
=D+Fs
-----END PGP SIGNATURE-----

--LmhQLMHr6gTQLE6p9w89nMC1u7vmeFA9V--
