Return-path: <linux-media-owner@vger.kernel.org>
Received: from multi.imgtec.com ([194.200.65.239]:53824 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752206AbaBJJ7g (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Feb 2014 04:59:36 -0500
Message-ID: <52F8A2AD.8040403@imgtec.com>
Date: Mon, 10 Feb 2014 09:58:05 +0000
From: James Hogan <james.hogan@imgtec.com>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Antti_Sepp=E4l=E4?= <a.seppala@gmail.com>
CC: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	<linux-media@vger.kernel.org>
Subject: Re: [RFC 0/4] rc: ir-raw: Add encode, implement NEC encode
References: <1391716763-2689-1-git-send-email-james.hogan@imgtec.com> <CAKv9HNYxY0isLt+uZvDZJJ=PX0SF93RsFeS6PsRMMk5gqtu8kQ@mail.gmail.com>
In-Reply-To: <CAKv9HNYxY0isLt+uZvDZJJ=PX0SF93RsFeS6PsRMMk5gqtu8kQ@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="UqOVNqW7tGN4vGD7iH8dAHH3SKMce5Nkx"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--UqOVNqW7tGN4vGD7iH8dAHH3SKMce5Nkx
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Antti,

On 08/02/14 11:30, Antti Sepp=E4l=E4 wrote:
>> The first patch adds an encode callback to the existing raw ir handler=

>> struct and a helper function to encode a scancode for a given protocol=
=2E
>>
>=20
> The mechanism used here to encode works fine as long as there is only
> one protocol selected. If there are several which all support encoding
> then there's no easy way to tell which one will be used to do the
> actual encoding.

True, I suppose it needs a wakeup_protocol sysfs file for that really (I
can't imagine a need or method to wake on multiple protocols, a
demodulating hardware decoder like img-ir can only have one set of
timings at a time, and a raw hardware decoder like nuvoton would seem
unlikely to have multiple wake match buffers - and if it did the sysfs
interface would probably need extending to take multiple
single-protocol/filter sets anyway).

This should probably be done prior to the new sysfs interface reaching
mainline, so that userland can always be expected to write the protocol
prior to the wakeup filter (rather than userland expecting the wake
protocol to follow the current protocol).

>> Finally for debug purposes patch 4 modifies img-ir-raw to loop back th=
e
>> encoded data when a filter is altered. Should be pretty easy to apply
>> similarly to any raw ir driver to try it out.
>>
>=20
> I believe we have rc-loopback driver for exactly this purpose. Could
> you use it instead? Also adding the scancode filter to it would
> demonstrate its usage.

True I could have done, I used img-ir simply out of convenience and
familiarity :). Would it make sense to generate an input event when
setting the filter though, or perhaps since the whole point of the
loopback driver is presumably debug it doesn't matter?

To actually add filtering support to loopback would require either:
* raw-decoder/rc-core level scancode filtering for raw ir drivers
* OR loopback driver to encode like nuvoton and fuzzy match the IR signal=
s.

> One other thing I noticed while reviewing your patches was that
> currently the dev->s_filter callback return value is ignored by
> store_filter. It would be useful to return an error to userspace if
> scancode storage was not possible for whatever reason.

Thanks, well spotted, I'll do a fix for that soon.

Cheers
James


--UqOVNqW7tGN4vGD7iH8dAHH3SKMce5Nkx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iQIcBAEBAgAGBQJS+KK0AAoJEKHZs+irPybfxcEP/RCCVclGHHiKgZG2gLoUAnQ8
cdkCuUUkQdj75xem0r9nu7AxEKX3V6omBFUYlDSYB4X2hm5JldZtr2rsrNecmB8z
0joMABCX4KFtoGMROyHuAaQH3HwLoM1dJzVUhRHImUei51WtOBQCXwn91pdOaTt2
OexwBbHSkgvIiT+1+5GlnQbkzD/pbkgw+AQ5QJCMNJs4ZQcn0czAFe6S95GaBtQ6
JnJHsFSdqbzdqzLFCoTP47wQ0sGN4t+CeXPNZk5taViXrxnPlru9dRQ9s8PMzDeg
/6QJ+naveb8+HYVi3IQWFTdBYIqqvFg+Yej/C+td9MTmtHwaLLbfQFLujZd63Utd
I57L/bU1OxIYaMHHSE6oWczXcJK/6+9M90JujRr2HV8WFovO6LiH0FJuUWrtI8lP
Ge39r9dOeFUopHkyKr5KfxVbvxNXFY6oiEwAI6WbuMxI9eExYaDnMxM3v9Y7XPbS
bkhEdLjqfc99VV5GPN4C8ofVXEMKt3V1vIzLrrpBDfW+ov2a2oK9/BX74SB7sUEL
AKyrsWtwv3B2v8p466brq2ZxVGRNvZLF0+qZivWFS5sFToGMQl7KHw12FTK+xol6
KfewM6VjY9jpXdTm77zXNc6YVPKfAmg0KO/5GaqtIsjSeVmPJStomDiaJ4pqP7u4
+WkGb8UtITIbdl5eWuh/
=7t3l
-----END PGP SIGNATURE-----

--UqOVNqW7tGN4vGD7iH8dAHH3SKMce5Nkx--

