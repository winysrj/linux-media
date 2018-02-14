Return-path: <linux-media-owner@vger.kernel.org>
Received: from butterbrot.org ([176.9.106.16]:54110 "EHLO butterbrot.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S967450AbeBNM1P (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Feb 2018 07:27:15 -0500
Subject: Re: exposing a large-ish calibration table through V4L2?
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
References: <3b8e61f5-df31-8556-c9d1-2ab06c76bfab@butterbrot.org>
 <5c3a596e-df46-488e-4a15-c847dc699815@xs4all.nl>
From: Florian Echtler <floe@butterbrot.org>
Message-ID: <43eab066-0025-501d-60d9-beb20204ebdd@butterbrot.org>
Date: Wed, 14 Feb 2018 13:27:10 +0100
MIME-Version: 1.0
In-Reply-To: <5c3a596e-df46-488e-4a15-c847dc699815@xs4all.nl>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="WLKSNKuGRPrvzzrOrog6HXRQZ8vUt6hGi"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--WLKSNKuGRPrvzzrOrog6HXRQZ8vUt6hGi
Content-Type: multipart/mixed; boundary="FiL3u4kN1yk3uQKDK8eiJPwiq97USSRKJ";
 protected-headers="v1"
From: Florian Echtler <floe@butterbrot.org>
To: Hans Verkuil <hverkuil@xs4all.nl>,
 Linux Media Mailing List <linux-media@vger.kernel.org>
Message-ID: <43eab066-0025-501d-60d9-beb20204ebdd@butterbrot.org>
Subject: Re: exposing a large-ish calibration table through V4L2?
References: <3b8e61f5-df31-8556-c9d1-2ab06c76bfab@butterbrot.org>
 <5c3a596e-df46-488e-4a15-c847dc699815@xs4all.nl>
In-Reply-To: <5c3a596e-df46-488e-4a15-c847dc699815@xs4all.nl>

--FiL3u4kN1yk3uQKDK8eiJPwiq97USSRKJ
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable

Hello Hans,

On 14.02.2018 13:13, Hans Verkuil wrote:
>=20
> On 14/02/18 13:09, Florian Echtler wrote:
>>
>> The internal device memory contains a table with two bytes for each se=
nsor pixel
>> (i.e. 960x540x2 =3D 1036800 bytes) that basically provide individual b=
lack and
>> white levels per-pixel that are used in preprocessing. The table can e=
ither be
>> set externally, or the sensor can be covered with a black/white surfac=
e and a
>> custom command triggers an internal calibration.
>>
>> AFAICT the usual V4L2 controls are unsuitable for this sort of data; d=
o you have
>> any suggestions on how to approach this? Maybe something like a custom=
 IOCTL?
>=20
> So the table has a fixed size?
> You can use array controls for that, a V4L2_CTRL_TYPE_U16 in a two-dime=
nsional array
> would do it.

Good to know, thanks.

> See https://hverkuil.home.xs4all.nl/spec/uapi/v4l/vidioc-queryctrl.html=
 for more
> information on how this works.

This means I have to implement QUERY_EXT_CTRL, G_EXT_CTRLS and S_EXT_CTRL=
S,
correct? Will this work in parallel to the "regular" controls that use th=
e
control framework?

Best, Florian
--=20
SENT FROM MY DEC VT50 TERMINAL


--FiL3u4kN1yk3uQKDK8eiJPwiq97USSRKJ--

--WLKSNKuGRPrvzzrOrog6HXRQZ8vUt6hGi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlqEKx4ACgkQ7CzyshGvathaFgCfQbcd+EaPUN7od4SLP8lzb7RN
A+AAn0zU7aO3hj9v250P1LSLyBMi9h9+
=HvWt
-----END PGP SIGNATURE-----

--WLKSNKuGRPrvzzrOrog6HXRQZ8vUt6hGi--
