Return-path: <linux-media-owner@vger.kernel.org>
Received: from [217.156.133.130] ([217.156.133.130]:15220 "EHLO
	imgpgp01.kl.imgtec.org" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752139AbaCaK5H (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Mar 2014 06:57:07 -0400
Message-ID: <533949F5.3080001@imgtec.com>
Date: Mon, 31 Mar 2014 11:56:53 +0100
From: James Hogan <james.hogan@imgtec.com>
MIME-Version: 1.0
To: =?UTF-8?B?RGF2aWQgSMOkcmRlbWFu?= <david@hardeman.nu>
CC: <linux-media@vger.kernel.org>, <m.chehab@samsung.com>
Subject: Re: [PATCH 10/11] [RFC] rc-core: use the full 32 bits for NEC  scancodes
References: <20140329160705.13234.60349.stgit@zeus.muc.hardeman.nu> <20140329161136.13234.733.stgit@zeus.muc.hardeman.nu> <5339390B.6030709@imgtec.com> <4af025b742df648556360db390351166@hardeman.nu>
In-Reply-To: <4af025b742df648556360db390351166@hardeman.nu>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="L5FAmjDnkXPwtuj90obF11HktGi19mhKu"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--L5FAmjDnkXPwtuj90obF11HktGi19mhKu
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 31/03/14 11:19, David H=C3=A4rdeman wrote:
> On 2014-03-31 11:44, James Hogan wrote:
>> On 29/03/14 16:11, David H=C3=A4rdeman wrote:
>>> Using the full 32 bits for all kinds of NEC scancodes simplifies rc-c=
ore
>>> and the nec decoder without any loss of functionality.
>>>
>>> In order to maintain backwards compatibility, some heuristics are add=
ed
>>> in rc-main.c to convert scancodes to NEC32 as necessary.
>>>
>>> I plan to introduce a different ioctl later which makes the protocol
>>> explicit (and which expects all NEC scancodes to be 32 bit, thereby
>>> removing the need for guesswork).
>>>
>>> Signed-off-by: David H=C3=A4rdeman <david@hardeman.nu>
>>> ---
>>> diff --git a/drivers/media/rc/img-ir/img-ir-nec.c
>>> b/drivers/media/rc/img-ir/img-ir-nec.c
>>> index 40ee844..133ea45 100644
>>> --- a/drivers/media/rc/img-ir/img-ir-nec.c
>>> +++ b/drivers/media/rc/img-ir/img-ir-nec.c
>>> @@ -5,42 +5,20 @@
>>>   */
>>>
>>>  #include "img-ir-hw.h"
>>> -#include <linux/bitrev.h>
>>>
>>>  /* Convert NEC data to a scancode */
>>>  static int img_ir_nec_scancode(int len, u64 raw, enum rc_type
>>> *protocol,
>>>                     u32 *scancode, u64 enabled_protocols)
>>>  {
>>> -    unsigned int addr, addr_inv, data, data_inv;
>>>      /* a repeat code has no data */
>>>      if (!len)
>>>          return IMG_IR_REPEATCODE;
>>> +
>>>      if (len !=3D 32)
>>>          return -EINVAL;
>>> -    /* raw encoding: ddDDaaAA */
>>> -    addr     =3D (raw >>  0) & 0xff;
>>> -    addr_inv =3D (raw >>  8) & 0xff;
>>> -    data     =3D (raw >> 16) & 0xff;
>>> -    data_inv =3D (raw >> 24) & 0xff;
>>> -    if ((data_inv ^ data) !=3D 0xff) {
>>> -        /* 32-bit NEC (used by Apple and TiVo remotes) */
>>> -        /* scan encoding: AAaaDDdd (LSBit first) */
>>> -        *scancode =3D bitrev8(addr)     << 24 |
>>> -                bitrev8(addr_inv) << 16 |
>>> -                bitrev8(data)     <<  8 |
>>> -                bitrev8(data_inv);
>>> -    } else if ((addr_inv ^ addr) !=3D 0xff) {
>>> -        /* Extended NEC */
>>> -        /* scan encoding: AAaaDD */
>>> -        *scancode =3D addr     << 16 |
>>> -                addr_inv <<  8 |
>>> -                data;
>>> -    } else {
>>> -        /* Normal NEC */
>>> -        /* scan encoding: AADD */
>>> -        *scancode =3D addr << 8 |
>>> -                data;
>>> -    }
>>> +
>>> +    /* raw encoding : ddDDaaAA -> scan encoding: AAaaDDdd */
>>> +    *scancode =3D swab32((u32)raw);
>>
>> What's the point of the byte swapping?
>>
>> Surely the most natural NEC encoding would just treat it as a single
>> 32-bit (LSBit first) field rather than 4 8-bit fields that needs
>> swapping.
>=20
> Thanks for having a look at the patches, I agree with your comments on
> the other patches (and I have to respin some of them because I missed
> two drivers), but the comments to this patch confuses me a bit.
>=20
> That the NEC data is transmitted as 32 bits encoded with LSB bit order
> within each byte is AFAIK just about the only thing that all
> sources/documentation of the protocal can agree on (so bitrev:ing the
> bits within each byte makes sense, unless the hardware has done it
> already).

Agreed (in the case of img-ir there's a bit orientation setting which
ensures that the u64 raw has the correct bit order, in the case of NEC
the first bit received goes in the lowest order bit of the raw data).

> As for the byte order, AAaaDDdd corresponds to the transmission order
> and seems to be what most drivers expect/use for their RX data.

AAaaDDdd is big endian rendering, no? (like "%08x")

If it should be interpreted as LSBit first, then the first bits received
should go in the low bits of the scancode, and by extension the first
bytes received in the low bytes of the scancode, i.e. at the end of the
inherently big-endian hexadecimal rendering of the scancode.

> Are you suggesting that rc-core should standardize on ddDDaaAA order?

Yes (where ddDDaaAA means something like scancode
"0x(~cmd)(cmd)(~addr)(addr)")

This would mean that if the data is put in the right bit order (first
bit received in BIT(0), last bit received in BIT(31)), then the scancode
=3D raw, and if the data is received in the reverse bit order (like the
raw decoder, shifting the data left and inserting the last bit in
BIT(0)) then the scancode =3D bitrev32(raw).

Have I missed something?

Cheers
James


--L5FAmjDnkXPwtuj90obF11HktGi19mhKu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iQIcBAEBAgAGBQJTOUn1AAoJEGwLaZPeOHZ6is0P/2QhNldbfJeCAqgEBta4drx6
s0tJAwngstDEVlWKFmqFlZYDHwtbx0t55m4QbAnENjVvPS111kYY79xQ/Rnq7EL2
8BV+sIbj9hJxhlKGyPxljlK6vx6fZMy7ZkLAaD7h8thqRyqkpbAoGNTjWKGPTrb6
LbUds65jwRCCQ0tdGh7ziOupQYAR6xWMi0gqiua38h1gBvspqHV3sjopXOLWl0yq
eZ4Ixp7fz7YBjSNFlT8i+mdFfKVW/7VrSQcW1uNxXWg4FMBBRhSZL2l2jJPGsAGL
E2szaaXuL2fSfLWfjZ3Ac/HGA7j2YTFRKohE8UHN20KNXrwV1kcJToiGoEjP9Cyn
Vs8UHpIgxu3iQ4VZf6g6BpgeI+MCBVm5ZhW970r1dsI1w09uge3EuUA8o1wUFx3F
BsQ/kkrzfcnGKLK9ldQD2eJrSK1QPp2Rg9+5ViNfS0+Vpm7iHobJNHghQvHYLMuO
csCx1QJSgHDVYF4AinP+FFHeDr2JPRyO+CC3zq06ApFIdUz1A/T2YFi0eUajZTNi
ndF8f5McJnMOv7Z/nFctT4hdkyrRRejU6AerNj0Yb1Or5t06jUEWh6b3VhUB+6dL
6Hyu3UrEbAAy8uR639uwSV9Xjj7zvezgBi04JCYZ8ngE+K62YVTdM51hEAhG6sff
FKzfUyAfBnCCeNbz7+SC
=5tlt
-----END PGP SIGNATURE-----

--L5FAmjDnkXPwtuj90obF11HktGi19mhKu--
