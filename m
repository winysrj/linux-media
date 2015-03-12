Return-path: <linux-media-owner@vger.kernel.org>
Received: from butterbrot.org ([176.9.106.16]:55066 "EHLO butterbrot.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754855AbbCLThu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Mar 2015 15:37:50 -0400
Message-ID: <5501EB0B.5020806@butterbrot.org>
Date: Thu, 12 Mar 2015 20:37:47 +0100
From: Florian Echtler <floe@butterbrot.org>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-input <linux-input@vger.kernel.org>,
	LMML <linux-media@vger.kernel.org>
Subject: Re: [PATCH v3][RFC] add raw video stream support for Samsung SUR40
References: <1423063842-6902-1-git-send-email-floe@butterbrot.org> <54DB4295.1080307@butterbrot.org> <54E1D71C.2000003@xs4all.nl> <54E7AB1E.3000401@butterbrot.org> <54E85C48.6070907@xs4all.nl> <54F98E51.8040204@butterbrot.org> <54F993ED.2060701@xs4all.nl> <54FB5715.2090103@butterbrot.org> <54FB6636.6050308@xs4all.nl> <54FD6CAD.9030600@butterbrot.org> <54FD713D.5050401@xs4all.nl> <54FDA3EA.9080006@butterbrot.org> <54FDA7E5.3010004@xs4all.nl>
In-Reply-To: <54FDA7E5.3010004@xs4all.nl>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="9x7UqkhdwSIhi66Pomg6H5RiHr2uT2dvs"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--9x7UqkhdwSIhi66Pomg6H5RiHr2uT2dvs
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hello Hans,

On 09.03.2015 15:02, Hans Verkuil wrote:
> On 03/09/2015 02:45 PM, Florian Echtler wrote:
>> On 09.03.2015 11:09, Hans Verkuil wrote:
>>> The error almost certainly comes from usb_submit_urb(). That function=
 does some
>>> checks on the sgl:
>>>
>>> I wonder it the code gets there. Perhaps a printk just before the ret=
urn -EINVAL
>>> might help here (also print the 'max' value).
>>>
>>> So you will have to debug a bit here, trying to figure out which test=
 in the usb
>>> code causes the usb_sg_wait error.
>> I'll do my best to track this down. Do you think this is an error in m=
y
>> code, one in the USB subsystem, or some combination of both?
>=20
> If the USB core indeed requires scatter-gather segments of specific len=
gths
> (modulo max), then that explains the problems.
> So as suggested try to see if the usb core bails out in that check and =
what the
> 'max' value is. It looks like only XHCI allows SG segments of any size,=
 so I really
> suspect that's the problem. But I also need to know the 'max' value to =
fully
> understand the implications.
Finally managed to confirm your suspicions on a kernel with a patched
dev_err call at the location you mentioned:

Mar 12 20:33:51 sur40 kernel: [ 1159.509580]  (null): urb 0 length
mismatch: length 4080, max 512
Mar 12 20:33:51 sur40 kernel: [ 1159.509592] sur40 2-1:1.0: error -22 in
usb_sg_wait

So the SG segments are expected in multiples of 512 bytes. I assume this
is not something I can fix from within my driver?

Best regards, Florian
--=20
SENT FROM MY DEC VT50 TERMINAL


--9x7UqkhdwSIhi66Pomg6H5RiHr2uT2dvs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlUB6wsACgkQ7CzyshGvatgR7wCdGAW/+Y2LTdo7+0JZOTXOQaad
x0MAoPZly9/i3jceXbqn9z3UjfOaFzmi
=G6oY
-----END PGP SIGNATURE-----

--9x7UqkhdwSIhi66Pomg6H5RiHr2uT2dvs--
