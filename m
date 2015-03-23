Return-path: <linux-media-owner@vger.kernel.org>
Received: from butterbrot.org ([176.9.106.16]:35268 "EHLO butterbrot.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752097AbbCWL5k (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Mar 2015 07:57:40 -0400
Message-ID: <550FFFB2.9020400@butterbrot.org>
Date: Mon, 23 Mar 2015 12:57:38 +0100
From: Florian Echtler <floe@butterbrot.org>
MIME-Version: 1.0
To: linux-input <linux-input@vger.kernel.org>,
	LMML <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Benjamin Tissoires <benjamin.tissoires@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [sur40] Debugging a race condition?
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="oPPxg8R8TTkaQLuKXcSWcgG4WgxwvBOPi"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--oPPxg8R8TTkaQLuKXcSWcgG4WgxwvBOPi
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hello everyone,

now that I'm using the newly merged sur40 video driver in a development
environment, I've noticed that a custom V4L2 application we've been
using in our lab will sometimes trigger a hard lockup of the machine
(_nothing_ works anymore, no VT switching, no network, not even Magic
SysRq).

This doesn't happen with plain old cheese or v4l2-compliance, only with
our custom application and only under X11, i.e. as far as I can tell,
when the input device is being polled at the same time. However, I have
a really hard time tracking this down, as even SysRq doesn't work
anymore. A console continuously dumping dmesg or strace of our tool
didn't really help, either.

I assume that somehow the input_polldev thread is put to sleep/waiting
for a lock due to the video functions and that causes the lockup, but I
can't really tell where that might happen. Can somebody with better
knowledge of the internals give some suggestions?

Thanks & best regards, Florian
--=20
SENT FROM MY DEC VT50 TERMINAL


--oPPxg8R8TTkaQLuKXcSWcgG4WgxwvBOPi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlUP/7IACgkQ7CzyshGvatjtBwCfXCjOWidGRK09OBHZI4LoxamV
kKYAoJtLqrrBJpJJmdUXlZrlfwD23Drn
=fDSX
-----END PGP SIGNATURE-----

--oPPxg8R8TTkaQLuKXcSWcgG4WgxwvBOPi--
