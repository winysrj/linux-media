Return-path: <linux-media-owner@vger.kernel.org>
Received: from butterbrot.org ([176.9.106.16]:46802 "EHLO butterbrot.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751137AbcE3MBk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 30 May 2016 08:01:40 -0400
Subject: Re: [PATCH 1/3] properly report a single frame rate of 60 FPS
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
References: <1463177957-8240-1-git-send-email-floe@butterbrot.org>
 <5742DF63.4010205@xs4all.nl>
Cc: Martin Kaltenbrunner <modin@yuri.at>
From: Florian Echtler <floe@butterbrot.org>
Message-ID: <574BF19D.9000003@butterbrot.org>
Date: Mon, 30 May 2016 09:54:05 +0200
MIME-Version: 1.0
In-Reply-To: <5742DF63.4010205@xs4all.nl>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="2cf1coS0SqpxPCdVQf52Ht3VvFWHWQbTR"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--2cf1coS0SqpxPCdVQf52Ht3VvFWHWQbTR
Content-Type: multipart/mixed; boundary="eC0wbhSfoHBDko3bLRni3Nraxx0Bi9nAT"
From: Florian Echtler <floe@butterbrot.org>
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: Martin Kaltenbrunner <modin@yuri.at>
Message-ID: <574BF19D.9000003@butterbrot.org>
Subject: Re: [PATCH 1/3] properly report a single frame rate of 60 FPS
References: <1463177957-8240-1-git-send-email-floe@butterbrot.org>
 <5742DF63.4010205@xs4all.nl>
In-Reply-To: <5742DF63.4010205@xs4all.nl>

--eC0wbhSfoHBDko3bLRni3Nraxx0Bi9nAT
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hello Hans,

On 23.05.2016 12:45, Hans Verkuil wrote:
>> +static int sur40_ioctl_parm(struct file *file, void *priv,
>> +			    struct v4l2_streamparm *p)
>> +{
>> +	if (p->type =3D=3D V4L2_BUF_TYPE_VIDEO_CAPTURE) {
>> +		p->parm.capture.timeperframe.numerator =3D 1;
>> +		p->parm.capture.timeperframe.denominator =3D 60;
>> +	}
>=20
> It should return -EINVAL if it is not of type VIDEO_CAPTURE. You should=
 also set the
> V4L2_CAP_TIMEPERFRAME capability for this to work. The readbuffers fiel=
d should also
> be set (typically to the minimum required number of buffers).

One question: should this be the same number of buffers as reported in
sur40_queue_setup (i.e. 3)? And is this still relevant with the pending
changes to alloc_ctx?

> Please check with v4l2-compliance! It would have warned about these iss=
ues.
Sorry for the noise (again ;-)

Best, Florian
--=20
SENT FROM MY DEC VT50 TERMINAL


--eC0wbhSfoHBDko3bLRni3Nraxx0Bi9nAT--

--2cf1coS0SqpxPCdVQf52Ht3VvFWHWQbTR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iEYEARECAAYFAldL8aAACgkQ7CzyshGvatg5fgCg0c+IVcAxyNXhYcHeES6BKg1q
rkgAnRzoQRPVOhcYKWHf75jkYwkvFIGK
=wDe6
-----END PGP SIGNATURE-----

--2cf1coS0SqpxPCdVQf52Ht3VvFWHWQbTR--
