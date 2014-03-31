Return-path: <linux-media-owner@vger.kernel.org>
Received: from [217.156.133.130] ([217.156.133.130]:15067 "EHLO
	imgpgp01.kl.imgtec.org" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752161AbaCaOGu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Mar 2014 10:06:50 -0400
Message-ID: <53397666.8090806@imgtec.com>
Date: Mon, 31 Mar 2014 15:06:30 +0100
From: James Hogan <james.hogan@imgtec.com>
MIME-Version: 1.0
To: =?UTF-8?B?RGF2aWQgSMOkcmRlbWFu?= <david@hardeman.nu>
CC: <linux-media@vger.kernel.org>, <m.chehab@samsung.com>
Subject: Re: [PATCH 10/11] [RFC] rc-core: use the full 32 bits for NEC   scancodes
References: <20140329160705.13234.60349.stgit@zeus.muc.hardeman.nu> <20140329161136.13234.733.stgit@zeus.muc.hardeman.nu> <5339390B.6030709@imgtec.com> <4af025b742df648556360db390351166@hardeman.nu> <533949F5.3080001@imgtec.com> <37fcf3abf63e258ee29b23dc3b0f3f12@hardeman.nu>
In-Reply-To: <37fcf3abf63e258ee29b23dc3b0f3f12@hardeman.nu>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="iFlcMKnR1aHK8EC7ehDhQV6rKSxUsaFjB"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--iFlcMKnR1aHK8EC7ehDhQV6rKSxUsaFjB
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 31/03/14 14:22, David H=C3=A4rdeman wrote:
> On 2014-03-31 12:56, James Hogan wrote:
>> This would mean that if the data is put in the right bit order (first
>> bit received in BIT(0), last bit received in BIT(31)), then the scanco=
de
>> =3D raw, and if the data is received in the reverse bit order (like th=
e
>> raw decoder, shifting the data left and inserting the last bit in
>> BIT(0)) then the scancode =3D bitrev32(raw).
>>
>> Have I missed something?
>=20
> I just think we have to agree to disagree :)
>=20
> For me, storing/presenting the scancode as 0xAAaaDDdd is "obviously" th=
e
> clearest and least confusing interpretation. But I might have spent too=

> long time using that notation in code and mentally to be able to find
> anything else intuitive :)
>=20
> 0xAAaaDDdd means that you read/parse/print it left to right, just as yo=
u
> would if you drew a pulse-space chart showing the received IR pulse
> (time normally progresses to the right...modulo the per-byte bitrev).

Sure, but the NEC bit order is little endian, and the scancode is a
32bit value not an array of 4 bytes, so it's artificial to expect it to
make any sense when read as big endian. E.g. if you extended the
transmission to 48 bits you'd expect the hex printed scancode to extend
to the left not the right.

The bits in the 32-bit word also become discontinuous for no good
reason, especially considering the cases we're trying to take into
account (NEC-32 and NEC-24) both effectively have 16-bit fields.

> It kind of matches the other protocol scancodes as well (the "address"
> bits high, cmd bits low, the high bits tend to remain constant for one
> given remote, the low bits change, although it's not a hard rule) and i=
t

Very true, but you still have the low byte of the command in the 2nd
lowest byte, which is why my original suggestion was:
0xaaAAddDD

I.e. swap 16bit halves, each 16bit field intact.

> matches most software I've ever seen (AFAIK, LIRC represents NEC32
> scancodes this way, as does e.g. the Pronto software and protocol).
>=20
> That said...I think we at least agree that we need *a* representation
> and that it should be used consistently in all drivers, right?

Yes, that would be nice.

Cheers
James


--iFlcMKnR1aHK8EC7ehDhQV6rKSxUsaFjB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iQIcBAEBAgAGBQJTOXZsAAoJEGwLaZPeOHZ6PgUP/3XueZTRL+DdPtoXRSK8XI7o
69c7tXejncQ1y1eHox/OvszFKJJir7xT0LftJi9ImgjpHToe3zNr9x5ta0R0Tty6
5/19RBkAuFe4y7O/+d6IZiwHgrQPBsdfhVPtquLWlZcC3fk/nIXm5J9rQHoIUnNY
4jBeFE8cFnkyn0vTTYUwOD5jD0TRdXzpmrsxQLnIVGKcUy5FPkUzxRUhiYI6kpkn
6KBsQQbd1VzKPiB7PKLnT4S+eZs42mlMEg4tM1e3Joho96k07bsmlsyRFC63SCIO
wHnHDrAEGAqfjhdV2HFnE2tCuMXnikRcPw/sYzfDfU6w1PM5E/qDfz6orIOixGOr
hFAqn8uBhkEgQeLwwqT+RUay6+fmcYops63sErXBHoNy4vTzwFX6/AwZ69hwSKV9
VK4AHjbskuPcL0ChIS/wYNAHV1VlbjT35szfiZNNi1HAyth7nolkHuhg9cwtpsbH
Uu3k3jCfL3w/ZzotXW0B6NV+SxXm70L/I2SJaZ0XHplkjAKjk55UdGn4624LeFcp
GKGYy7ry1EQ7TIy1xx9e6l3MLNgk/LT558St6u/3z5m5a4A62V0ecHHqSFA3ZOY4
qg+BzUCV88vy3ktucswzx356/4bdylbDvEC3hAzhc+R/qpBUfzIvZ7/UiwzkHI08
VAtpKlQ8szZQqQpdJJ0X
=owoE
-----END PGP SIGNATURE-----

--iFlcMKnR1aHK8EC7ehDhQV6rKSxUsaFjB--
