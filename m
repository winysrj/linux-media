Return-path: <linux-media-owner@vger.kernel.org>
Received: from butterbrot.org ([176.9.106.16]:34350 "EHLO butterbrot.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753156AbeBGIYW (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 7 Feb 2018 03:24:22 -0500
Subject: Re: [PATCH 1/5] add missing blob structure field for tag id
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: linux-input@vger.kernel.org, modin@yuri.at
References: <1517950905-5015-1-git-send-email-floe@butterbrot.org>
 <1517950905-5015-2-git-send-email-floe@butterbrot.org>
 <3219b5c2-2497-25a5-a22f-2f0f874692fe@xs4all.nl>
From: Florian Echtler <floe@butterbrot.org>
Message-ID: <bc0b894a-11b9-7d92-32ff-60e17d6f2064@butterbrot.org>
Date: Wed, 7 Feb 2018 09:24:18 +0100
MIME-Version: 1.0
In-Reply-To: <3219b5c2-2497-25a5-a22f-2f0f874692fe@xs4all.nl>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="i4EjCm5dZZNTItDN7Cd71OrV0DU5aFCa5"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--i4EjCm5dZZNTItDN7Cd71OrV0DU5aFCa5
Content-Type: multipart/mixed; boundary="2NoiEIStjZYgGOZe5v9di3L7gAoKSj6py";
 protected-headers="v1"
From: Florian Echtler <floe@butterbrot.org>
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: linux-input@vger.kernel.org, modin@yuri.at
Message-ID: <bc0b894a-11b9-7d92-32ff-60e17d6f2064@butterbrot.org>
Subject: Re: [PATCH 1/5] add missing blob structure field for tag id
References: <1517950905-5015-1-git-send-email-floe@butterbrot.org>
 <1517950905-5015-2-git-send-email-floe@butterbrot.org>
 <3219b5c2-2497-25a5-a22f-2f0f874692fe@xs4all.nl>
In-Reply-To: <3219b5c2-2497-25a5-a22f-2f0f874692fe@xs4all.nl>

--2NoiEIStjZYgGOZe5v9di3L7gAoKSj6py
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable

On 06.02.2018 22:22, Hans Verkuil wrote:
> On 02/06/2018 10:01 PM, Florian Echtler wrote:
>> The SUR40 can recognize specific printed patterns directly in hardware=
;
>> this information (i.e. the pattern id) is present but currently unused=

>> in the blob structure.
>>
>> =20
>>  	__le32 area;       /* size in pixels/pressure (?) */
>> =20
>> -	u8 padding[32];
>> +	u8 padding[24];
>> +
>> +	__le32 tag_id;     /* valid when type =3D=3D 0x04 (SUR40_TAG) */
>> +	__le32 unknown;
>> =20
>>  } __packed;
>> =20
> Usually new fields are added before the padding, not after.
>=20
> Unless there is a good reason for this I'd change this.

This is how the hardware sends it, so there's little choice in how to arr=
ange
the fields...

Best regards, Florian
--=20
SENT FROM MY DEC VT50 TERMINAL


--2NoiEIStjZYgGOZe5v9di3L7gAoKSj6py--

--i4EjCm5dZZNTItDN7Cd71OrV0DU5aFCa5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlp6t7IACgkQ7CzyshGvatgT2QCghB/IsdRUVCgrf5kNeeOg12c2
StcAniEsVLFnalF7tpG3dGrHnQayCWyH
=HKQ7
-----END PGP SIGNATURE-----

--i4EjCm5dZZNTItDN7Cd71OrV0DU5aFCa5--
