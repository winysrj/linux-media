Return-path: <linux-media-owner@vger.kernel.org>
Received: from butterbrot.org ([176.9.106.16]:51711 "EHLO butterbrot.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751931AbbCINpQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Mar 2015 09:45:16 -0400
Message-ID: <54FDA3EA.9080006@butterbrot.org>
Date: Mon, 09 Mar 2015 14:45:14 +0100
From: Florian Echtler <floe@butterbrot.org>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-input <linux-input@vger.kernel.org>,
	LMML <linux-media@vger.kernel.org>
Subject: Re: [PATCH v3][RFC] add raw video stream support for Samsung SUR40
References: <1423063842-6902-1-git-send-email-floe@butterbrot.org> <54DB4295.1080307@butterbrot.org> <54E1D71C.2000003@xs4all.nl> <54E7AB1E.3000401@butterbrot.org> <54E85C48.6070907@xs4all.nl> <54F98E51.8040204@butterbrot.org> <54F993ED.2060701@xs4all.nl> <54FB5715.2090103@butterbrot.org> <54FB6636.6050308@xs4all.nl> <54FD6CAD.9030600@butterbrot.org> <54FD713D.5050401@xs4all.nl>
In-Reply-To: <54FD713D.5050401@xs4all.nl>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="EoiNKCeFCENHSWaaSb9X02Vm4B4j0K1n1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--EoiNKCeFCENHSWaaSb9X02Vm4B4j0K1n1
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 09.03.2015 11:09, Hans Verkuil wrote:
> Hi Florian,
>=20
> OK, the cause of this failure is this message:
>=20
> Mar  9 10:39:08 sur40 kernel: [ 1093.200960] sur40 2-1:1.0: error in us=
b_sg_wait
>=20
> So you need to print the error message here (sgr.status) so that I can =
see what
> it is.
I've amended the dev_debug call, the error returned from usb_sg_wait is
also -22 (EINVAL).

> The error almost certainly comes from usb_submit_urb(). That function d=
oes some
> checks on the sgl:
>=20
> I wonder it the code gets there. Perhaps a printk just before the retur=
n -EINVAL
> might help here (also print the 'max' value).
>
> So you will have to debug a bit here, trying to figure out which test i=
n the usb
> code causes the usb_sg_wait error.
I'll do my best to track this down. Do you think this is an error in my
code, one in the USB subsystem, or some combination of both?

Best, Florian
--=20
SENT FROM MY DEC VT50 TERMINAL


--EoiNKCeFCENHSWaaSb9X02Vm4B4j0K1n1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlT9o+oACgkQ7CzyshGvatiOSgCaAhyBBfGj84YG4MJmT04W/24W
5B4AoOu9SDXCpyJINAiJ/8vnEdG5i0ev
=nR4x
-----END PGP SIGNATURE-----

--EoiNKCeFCENHSWaaSb9X02Vm4B4j0K1n1--
