Return-path: <linux-media-owner@vger.kernel.org>
Received: from butterbrot.org ([176.9.106.16]:49742 "EHLO butterbrot.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752135AbbCWPrV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Mar 2015 11:47:21 -0400
Message-ID: <55103587.3080901@butterbrot.org>
Date: Mon, 23 Mar 2015 16:47:19 +0100
From: Florian Echtler <floe@butterbrot.org>
MIME-Version: 1.0
To: linux-input <linux-input@vger.kernel.org>,
	LMML <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Benjamin Tissoires <benjamin.tissoires@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [sur40] Debugging a race condition?
References: <550FFFB2.9020400@butterbrot.org>
In-Reply-To: <550FFFB2.9020400@butterbrot.org>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="OTlnALC322I9njVa8P6pasxJMT6lOSEQN"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--OTlnALC322I9njVa8P6pasxJMT6lOSEQN
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Additional note: this happens almost never with the original code using
dma-contig, which is why I didn't catch it during testing. I've now
switched back and forth between the two versions multiple times, and
it's definitely a lot less stable with dma-sg and usb_sg_init/_wait.
Maybe that can help somebody in narrowing down the reason of the problem?=


Best, Florian

On 23.03.2015 12:57, Florian Echtler wrote:
> Hello everyone,
>=20
> now that I'm using the newly merged sur40 video driver in a development=

> environment, I've noticed that a custom V4L2 application we've been
> using in our lab will sometimes trigger a hard lockup of the machine
> (_nothing_ works anymore, no VT switching, no network, not even Magic
> SysRq).
>=20
> This doesn't happen with plain old cheese or v4l2-compliance, only with=

> our custom application and only under X11, i.e. as far as I can tell,
> when the input device is being polled at the same time. However, I have=

> a really hard time tracking this down, as even SysRq doesn't work
> anymore. A console continuously dumping dmesg or strace of our tool
> didn't really help, either.
>=20
> I assume that somehow the input_polldev thread is put to sleep/waiting
> for a lock due to the video functions and that causes the lockup, but I=

> can't really tell where that might happen. Can somebody with better
> knowledge of the internals give some suggestions?
>=20
> Thanks & best regards, Florian
>=20


--=20
SENT FROM MY DEC VT50 TERMINAL


--OTlnALC322I9njVa8P6pasxJMT6lOSEQN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlUQNYcACgkQ7CzyshGvatjfJwCgkykheDQW+3q6yx/vCWZwJvK8
8c8AoOY2tRaEMjWL51YrxyuIPBPbxqYb
=42fj
-----END PGP SIGNATURE-----

--OTlnALC322I9njVa8P6pasxJMT6lOSEQN--
