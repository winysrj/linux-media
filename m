Return-path: <linux-media-owner@vger.kernel.org>
Received: from butterbrot.org ([176.9.106.16]:49707 "EHLO butterbrot.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752655AbbC0JJH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Mar 2015 05:09:07 -0400
Message-ID: <55151E30.60305@butterbrot.org>
Date: Fri, 27 Mar 2015 10:09:04 +0100
From: Florian Echtler <floe@butterbrot.org>
MIME-Version: 1.0
To: Antonio Ospite <ao2@ao2.it>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	linux-input <linux-input@vger.kernel.org>,
	LMML <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Benjamin Tissoires <benjamin.tissoires@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: input_polldev interval (was Re: [sur40] Debugging a race condition)?
References: <550FFFB2.9020400@butterbrot.org>	<55103587.3080901@butterbrot.org>	<43CDB224-5B10-4234-9054-7A7EC1EDA3BF@butterbrot.org>	<DAFB1A9C-4AD7-4236-9945-6A456BEC7EDE@gmail.com>	<5512C1E4.7060903@butterbrot.org> <20150326221000.86b9c2181e699915ba91d009@ao2.it>
In-Reply-To: <20150326221000.86b9c2181e699915ba91d009@ao2.it>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="QXWwIt54DhPplekmpV1IccCoqxXmM6lDI"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--QXWwIt54DhPplekmpV1IccCoqxXmM6lDI
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hello Antonio,

On 26.03.2015 22:10, Antonio Ospite wrote:
> On Wed, 25 Mar 2015 15:10:44 +0100
> Florian Echtler <floe@butterbrot.org> wrote:
>>
>> Thanks - any other suggestions how to debug such a complete freeze? I
>> have the following options enabled in my kernel config:
>>
>> Unfortunately, even after the system is frozen for several minutes, I
>> never get to see a panic message. Maybe it's there on the console
>> somewhere, but the screen never switches away from X (and as mentioned=

>> earlier, I think this bug can only be triggered from within X). Networ=
k
>> also freezes, so I don't think netconsole will help?
>=20
> PSTORE + some EFI/ACPI mechanism, maybe?
> http://lwn.net/Articles/434821/
>=20
> However I have never tried that myself and I don't know if all the
> needed bits are in linux already.
>=20
> JFTR, on some embedded system I worked on in the past the RAM content
> was preserved across resets and, after a crash, we used to dump the RAM=

> from a second stage bootloader (i.e. before lading another linux
> instance) and then scrape the dump to look for the kernel messages, but=

> AFAIK this is not going to be reliable =E2=80=94or even possible=E2=80=94=
 on a more
> complex system.

thanks for your suggestions - however, this is a regular x86 system, so
what I will try next is to reproduce the crash in a Virtualbox instance
with the SUR40 device routed to the guest using USB passthrough and the
serial console routed to the host. Hope this will give some clues.

One more general question: what are possible reasons for a complete
freeze? Only a spinlock being held with interrupts disabled, or are
there other possibilities?

Best, Florian
--=20
SENT FROM MY DEC VT50 TERMINAL


--QXWwIt54DhPplekmpV1IccCoqxXmM6lDI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlUVHjAACgkQ7CzyshGvatgv9QCg0pzqsjbtdlQBfKIT20UrVqdh
4mQAoJCmjIwTmNX7A3Amy7Df/jnbI/fH
=xAdi
-----END PGP SIGNATURE-----

--QXWwIt54DhPplekmpV1IccCoqxXmM6lDI--
