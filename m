Return-path: <linux-media-owner@vger.kernel.org>
Received: from butterbrot.org ([176.9.106.16]:39182 "EHLO butterbrot.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752102AbbCYOKy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Mar 2015 10:10:54 -0400
Message-ID: <5512C1E4.7060903@butterbrot.org>
Date: Wed, 25 Mar 2015 15:10:44 +0100
From: Florian Echtler <floe@butterbrot.org>
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	linux-input <linux-input@vger.kernel.org>,
	LMML <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Benjamin Tissoires <benjamin.tissoires@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: input_polldev interval (was Re: [sur40] Debugging a race condition)?
References: <550FFFB2.9020400@butterbrot.org> <55103587.3080901@butterbrot.org> <43CDB224-5B10-4234-9054-7A7EC1EDA3BF@butterbrot.org> <DAFB1A9C-4AD7-4236-9945-6A456BEC7EDE@gmail.com>
In-Reply-To: <DAFB1A9C-4AD7-4236-9945-6A456BEC7EDE@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="LE0jLcbwgxAHoflE3Sf7QNEnuAsj7DdXc"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--LE0jLcbwgxAHoflE3Sf7QNEnuAsj7DdXc
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hello Dmitry,

On 25.03.2015 14:23, Dmitry Torokhov wrote:
> On March 24, 2015 11:52:54 PM PDT, Florian Echtler <floe@butterbrot.org=
> wrote:
>> Currently, I'm setting the interval for input_polldev to 10 ms.
>> However, with video data being retrieved at the same time, it's quite
>> possible that one iteration of poll() will take longer than that. Coul=
d
>> this ultimately be the reason? What happens if a new poll() call is
>> scheduled before the previous one completes?
>=20
> This can't happen as we schedule the next poll only after current one c=
ompletes.
>=20
Thanks - any other suggestions how to debug such a complete freeze? I
have the following options enabled in my kernel config:

CONFIG_LOCKUP_DETECTOR=3Dy
CONFIG_HARDLOCKUP_DETECTOR=3Dy
CONFIG_DETECT_HUNG_TASK=3Dy
CONFIG_EARLY_PRINTK=3Dy
CONFIG_EARLY_PRINTK_DBGP=3Dy
CONFIG_EARLY_PRINTK_EFI=3Dy

Unfortunately, even after the system is frozen for several minutes, I
never get to see a panic message. Maybe it's there on the console
somewhere, but the screen never switches away from X (and as mentioned
earlier, I think this bug can only be triggered from within X). Network
also freezes, so I don't think netconsole will help?

Best, Florian
--=20
SENT FROM MY DEC VT50 TERMINAL


--LE0jLcbwgxAHoflE3Sf7QNEnuAsj7DdXc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlUSwecACgkQ7CzyshGvatiHsQCg4S7V+4IqhRFX5SnMs/pVRYaT
Zj8An3mlIw0f/IghPznFJSbCvBEHA0fZ
=bOsu
-----END PGP SIGNATURE-----

--LE0jLcbwgxAHoflE3Sf7QNEnuAsj7DdXc--
