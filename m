Return-path: <linux-media-owner@vger.kernel.org>
Received: from butterbrot.org ([176.9.106.16]:38819 "EHLO butterbrot.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751338AbbCPIgk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Mar 2015 04:36:40 -0400
Message-ID: <55069616.6040202@butterbrot.org>
Date: Mon, 16 Mar 2015 09:36:38 +0100
From: Florian Echtler <floe@butterbrot.org>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-input <linux-input@vger.kernel.org>,
	LMML <linux-media@vger.kernel.org>
Subject: Re: [PATCH v3][RFC] add raw video stream support for Samsung SUR40
References: <1423063842-6902-1-git-send-email-floe@butterbrot.org> <54DB4295.1080307@butterbrot.org> <54E1D71C.2000003@xs4all.nl> <54E7AB1E.3000401@butterbrot.org> <54E85C48.6070907@xs4all.nl> <54F98E51.8040204@butterbrot.org> <54F993ED.2060701@xs4all.nl> <54FB5715.2090103@butterbrot.org> <54FB6636.6050308@xs4all.nl> <54FD6CAD.9030600@butterbrot.org> <54FD713D.5050401@xs4all.nl> <54FDA3EA.9080006@butterbrot.org> <54FDA7E5.3010004@xs4all.nl> <5501EB0B.5020806@butterbrot.org> <5505B2C0.6090309@xs4all.nl>
In-Reply-To: <5505B2C0.6090309@xs4all.nl>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="GdwvKgWWaGbQ1WjIrEu9gLWom4lQaWq1K"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--GdwvKgWWaGbQ1WjIrEu9gLWom4lQaWq1K
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hello Hans,

On 15.03.2015 17:26, Hans Verkuil wrote:
> On 03/12/2015 08:37 PM, Florian Echtler wrote:
>> On 09.03.2015 15:02, Hans Verkuil wrote:
>>> On 03/09/2015 02:45 PM, Florian Echtler wrote:
>>>> On 09.03.2015 11:09, Hans Verkuil wrote:
>>>>> The error almost certainly comes from usb_submit_urb(). That functi=
on does some
>>>>> checks on the sgl:
>>>>>
>>>> I'll do my best to track this down. Do you think this is an error in=
 my
>>>> code, one in the USB subsystem, or some combination of both?
>>>
>>> If the USB core indeed requires scatter-gather segments of specific l=
engths
>>> (modulo max), then that explains the problems.
>>> So as suggested try to see if the usb core bails out in that check an=
d what the
>>> 'max' value is. It looks like only XHCI allows SG segments of any siz=
e, so I really
>>> suspect that's the problem. But I also need to know the 'max' value t=
o fully
>>> understand the implications.
>>
>> Finally managed to confirm your suspicions on a kernel with a patched
>> dev_err call at the location you mentioned:
>>
>> So the SG segments are expected in multiples of 512 bytes. I assume th=
is
>> is not something I can fix from within my driver?
>=20
> No, you can't. I would use dma-sg, but disable the USERPTR support.
> Also comment why USERPTR support is disabled.
>=20
> This was interesting :-)
>=20
Thanks again for your help, new patch is submitted. Just for my
understanding: is this a hardware limitation? And why does dma-sg select
such a weird segment size like 4080?

Best, Florian
--=20
SENT FROM MY DEC VT50 TERMINAL


--GdwvKgWWaGbQ1WjIrEu9gLWom4lQaWq1K
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlUGlhYACgkQ7CzyshGvatiPsACfVUhJlbeYWpL9of1YwJ5NPBaA
RIcAoMaLytYi3213vYK6yQ44/LsMINgx
=ykks
-----END PGP SIGNATURE-----

--GdwvKgWWaGbQ1WjIrEu9gLWom4lQaWq1K--
