Return-path: <linux-media-owner@vger.kernel.org>
Received: from butterbrot.org ([176.9.106.16]:60908 "EHLO butterbrot.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751629AbcGFUwA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 6 Jul 2016 16:52:00 -0400
Subject: Re: [PATCH v2 1/3] sur40: properly report a single frame rate of 60
 FPS
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
References: <1464725733-22119-1-git-send-email-floe@butterbrot.org>
 <f5d84d25-eae4-df9b-819b-256565783c35@xs4all.nl>
 <577B5A2B.5060406@butterbrot.org>
 <cfd020d2-5834-11ac-1b1c-cb98aa872354@xs4all.nl> <577CC3FE.5080200@xs4all.nl>
Cc: linux-input@vger.kernel.org, Martin Kaltenbrunner <modin@yuri.at>
From: Florian Echtler <floe@butterbrot.org>
Message-ID: <577D6F6B.1050207@butterbrot.org>
Date: Wed, 6 Jul 2016 22:51:55 +0200
MIME-Version: 1.0
In-Reply-To: <577CC3FE.5080200@xs4all.nl>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="xXcbQNDmLmlVHHfCa471Hjd7wfX5e4ACL"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--xXcbQNDmLmlVHHfCa471Hjd7wfX5e4ACL
Content-Type: multipart/mixed; boundary="84SFwp5WFte230nDVHnaNFmVVSOUDaNK1"
From: Florian Echtler <floe@butterbrot.org>
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: linux-input@vger.kernel.org, Martin Kaltenbrunner <modin@yuri.at>
Message-ID: <577D6F6B.1050207@butterbrot.org>
Subject: Re: [PATCH v2 1/3] sur40: properly report a single frame rate of 60
 FPS
References: <1464725733-22119-1-git-send-email-floe@butterbrot.org>
 <f5d84d25-eae4-df9b-819b-256565783c35@xs4all.nl>
 <577B5A2B.5060406@butterbrot.org>
 <cfd020d2-5834-11ac-1b1c-cb98aa872354@xs4all.nl> <577CC3FE.5080200@xs4all.nl>
In-Reply-To: <577CC3FE.5080200@xs4all.nl>

--84SFwp5WFte230nDVHnaNFmVVSOUDaNK1
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 06.07.2016 10:40, Hans Verkuil wrote:
> On 07/05/16 09:06, Hans Verkuil wrote:
>> On 07/05/2016 08:56 AM, Florian Echtler wrote:
>>> On 05.07.2016 08:41, Hans Verkuil wrote:
>>>>
>>>> Why is s_parm added when you can't change the framerate?
>>>
>>> Oh, I thought it's mandatory to always have s_parm if you have g_parm=

>>> (even if it always returns the same values).
>>>
>>>> Same questions for the
>>>> enum_frameintervals function: it doesn't hurt to have it, but if the=
re is only
>>>> one unchangeable framerate, then it doesn't make much sense.
>>>
>>> If you don't have enum_frameintervals, how would you find out about t=
he
>>> framerate otherwise? Is g_parm itself enough already for all userspac=
e
>>> tools?
>>
>> It should be. The enum_frameintervals function is much newer than g_pa=
rm.
>>
>> Frankly, I have the same problem with enum_framesizes: it reports only=
 one
>> size. These two enum ioctls are normally only implemented if there are=
 at
>> least two choices. If there is no choice, then G_FMT will return the s=
ize
>> and G_PARM the framerate and there is no need to enumerate anything.
>>
>> The problem is that the spec is ambiguous as to the requirements if th=
ere
>> is only one choice for size and interval. Are the enum ioctls allowed =
in
>> that case? Personally I think there is nothing against that. But shoul=
d
>> S_PARM also be allowed even though it can't actually change the framep=
eriod?
>>
>> Don't bother making changes yet, let me think about this for a bit.
>=20
> OK, I came to the conclusion that if enum_frameintervals returns one or=

> more intervals, then s_parm should be present, even if there is only on=
e
> possible interval.
>=20
> I have updated the compliance utility to check for this.

AFAICT, the original patch does meet the requirements, then? Or do you
have any change requests?

Best, Florian
--=20
SENT FROM MY DEC VT50 TERMINAL


--84SFwp5WFte230nDVHnaNFmVVSOUDaNK1--

--xXcbQNDmLmlVHHfCa471Hjd7wfX5e4ACL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iEYEARECAAYFAld9b2sACgkQ7CzyshGvatiQ8ACgnv/gsSJYNNplTmyEEB29+vRn
+78An3/suLU0STIgCxrs8mGP6Hg8s3n2
=Jjld
-----END PGP SIGNATURE-----

--xXcbQNDmLmlVHHfCa471Hjd7wfX5e4ACL--
