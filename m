Return-path: <linux-media-owner@vger.kernel.org>
Received: from butterbrot.org ([176.9.106.16]:37926 "EHLO butterbrot.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753825AbbAFKRj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 6 Jan 2015 05:17:39 -0500
Message-ID: <54ABB641.7050002@butterbrot.org>
Date: Tue, 06 Jan 2015 11:17:37 +0100
From: Florian Echtler <floe@butterbrot.org>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-input <linux-input@vger.kernel.org>,
	linux-media@vger.kernel.org
Subject: Re: [RFC] [Patch] implement video driver for sur40
References: <5492D7E8.504@butterbrot.org> <5492E091.1060404@xs4all.nl> <54943680.3020007@butterbrot.org> <549437DA.6090601@xs4all.nl> <54943CC2.6040803@butterbrot.org> <549443C9.6090900@xs4all.nl> <alpine.DEB.2.02.1501061018580.3223@butterbrot> <54ABAC8C.6020401@xs4all.nl>
In-Reply-To: <54ABAC8C.6020401@xs4all.nl>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="2Nm8MBqu77KAiXhBqxrfHEvXpDp2DNuMc"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--2Nm8MBqu77KAiXhBqxrfHEvXpDp2DNuMc
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 06.01.2015 10:36, Hans Verkuil wrote:
> On 01/06/2015 10:29 AM, Florian Echtler wrote:
>> There's only one failing test left, which is this one:
>>
>> Streaming ioctls:
>>  	test read/write: OK
>>  		fail: v4l2-test-buffers.cpp(284): g_field() =3D=3D V4L2_FIELD_ANY
>=20
> You're not filling in the 'field' field of struct v4l2_buffer when retu=
rning a
> frame. It should most likely be FIELD_NONE in your case.
>>  		fail: v4l2-test-buffers.cpp(611): buf.check(q, last_seq)
>>  		fail: v4l2-test-buffers.cpp(884): captureBufs(node, q, m2m_q, frame=
_count, false)
OK, easy to fix. This will also influence the other two warnings, I assum=
e?

>> On a different note, I'm getting occasional warnings in syslog when I =
run=20
>> a regular video streaming application (e.g. cheese):
>>
>> ------------[ cut here ]------------
=2E..
>> ---[ end trace 451ed974170f6e44 ]---
>>
>> Does this mean the driver consumes too much CPU resources?
>=20
> No, it means that your driver is not returning all buffers to vb2. Most=

> likely this is missing in the vb2 stop_streaming op. When that is calle=
d
> your driver must return all buffers it has back to vb2 by calling
> vb2_buffer_done with state ERROR. The same can happen in the start_stre=
aming
> op if that returns an error for some reason. In that case all buffers o=
wned
> by the driver should be returned to vb2 with state QUEUED. See also
> Documentation/video4linux/v4l2-pci-skeleton.c as reference code.
I did actually build my driver code based on v4l2-pci-skeleton.c, and
I'm calling the exact same return_all_buffers function (see below) with
VB2_BUF_STATE_ERROR from my stop_streaming ioctl.

static void return_all_buffers(struct sur40_state *sur40,
			       enum vb2_buffer_state state)
{
	struct sur40_buffer *buf, *node;

	spin_lock(&sur40->qlock);
	list_for_each_entry_safe(buf, node, &sur40->buf_list, list) {
		vb2_buffer_done(&buf->vb, state);
		list_del(&buf->list);
	}
	spin_unlock(&sur40->qlock);
}

Is there another possible explanation?

Thanks & best regards, Florian
--=20
SENT FROM MY DEC VT50 TERMINAL


--2Nm8MBqu77KAiXhBqxrfHEvXpDp2DNuMc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlSrtkEACgkQ7CzyshGvathSRwCbBc5KN3n0w6UcKyMq5wA3J1Ws
dzgAoLAu2VeXSJDAuIs5eXigjQzXf76V
=b46T
-----END PGP SIGNATURE-----

--2Nm8MBqu77KAiXhBqxrfHEvXpDp2DNuMc--
