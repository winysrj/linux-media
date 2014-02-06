Return-path: <linux-media-owner@vger.kernel.org>
Received: from multi.imgtec.com ([194.200.65.239]:5175 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751187AbaBFOmE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 6 Feb 2014 09:42:04 -0500
Message-ID: <52F39F30.70104@imgtec.com>
Date: Thu, 6 Feb 2014 14:41:52 +0000
From: James Hogan <james.hogan@imgtec.com>
MIME-Version: 1.0
To: Rob Herring <robherring2@gmail.com>
CC: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	<linux-media@vger.kernel.org>, Rob Herring <robh+dt@kernel.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	Rob Landley <rob@landley.net>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	Tomasz Figa <tomasz.figa@gmail.com>
Subject: Re: [PATCH v2 06/15] dt: binding: add binding for ImgTec IR block
References: <1389967140-20704-1-git-send-email-james.hogan@imgtec.com> <1389967140-20704-7-git-send-email-james.hogan@imgtec.com> <CAL_Jsq+wk6_9Da5Xj3Ys-MZYPTpu6V3pAEpGFv44148BodmmrQ@mail.gmail.com>
In-Reply-To: <CAL_Jsq+wk6_9Da5Xj3Ys-MZYPTpu6V3pAEpGFv44148BodmmrQ@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="L03ftL0pIiPVemqqKAGGbThAa35xuOQ4J"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--L03ftL0pIiPVemqqKAGGbThAa35xuOQ4J
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Rob,

On 06/02/14 14:33, Rob Herring wrote:
> On Fri, Jan 17, 2014 at 7:58 AM, James Hogan <james.hogan@imgtec.com> w=
rote:
>> +Required properties:
>> +- compatible:          Should be "img,ir1"
>=20
> Kind of short for a name. I don't have anything much better, but how
> about img,ir-rev1.

Okay, that sounds reasonable.

>> +Optional properties:
>> +- clocks:              List of clock specifiers as described in stand=
ard
>> +                       clock bindings.
>> +- clock-names:         List of clock names corresponding to the clock=
s
>> +                       specified in the clocks property.
>> +                       Accepted clock names are:
>> +                       "core": Core clock (defaults to 32.768KHz if o=
mitted).
>> +                       "sys":  System side (fast) clock.
>> +                       "mod":  Power modulation clock.
>=20
> You need to define the order of clocks including how they are
> interpreted with different number of clocks (not relying on the name).

Would it be sufficient to specify that "clock-names" is required if
"clocks" is provided (i.e. unnamed clocks aren't used), or is there some
other reason that clock-names shouldn't be relied upon?

Thanks for reviewing,

Cheers
James

> Although, if the h/w block really has different number of clock
> inputs, then it is a different h/w block and should have a different
> compatible string.


--L03ftL0pIiPVemqqKAGGbThAa35xuOQ4J
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iQIcBAEBAgAGBQJS8583AAoJEKHZs+irPybfUK0QAKX5HgxxdKV+Hu0wszAKeSn2
mqTEXNw7ywyxJMsczbn5ME2S8b7tx9yRjfvaIdZB/Qz6AHOR1xw3EHS/q4P9DR/P
WiOGWrhJrqiFJP5OC18b4Qx9RA/cU80vX4n1MkW/D5C/eef0G13imxFedF/WgWmC
PTg6+shbk+TBOGF0EY7wlg9kVxzvBsts5kK4/af/2uGhxHz6bS31nyKbEZRfdIxQ
xjbrmvY3p5dzIb0rKmIoxuGoef3FItXbNDD9dQ4G4uw3yGv4M4UtXl6DJ2QRBAYJ
U9SKI6EubsGAEFTDdtMHIpMaMuQ7R2t356gsu0UR6oHF4opCpJ1iXsY5ExTQgoVT
/+gQRevuf7lgcu9eULk9I5t8DjZ3hc16OrPOF88+ftaN1u7JZwXDKlMlxS+z2Bb2
ABnCEe1nbLnfKC/KI5fGnAs5lOs3vOsWbmUBsJhXeb7EHa92n9zp27f7fbwBoGsN
gSpbSBE4g1ACAm4fxal0WggVMDjErTfrlzFCab0PoNbmNr6wtuEoWfab/vVJqcAW
o3LZKq/i66dMMauIjjFPoriEHHJu08HW4y+JQPbHlUv571S9ZUO7SK49MnA8ghaX
iWanmdYJBF8rsQaFQaGzdFkqrrq/wrBolUXUx/nRBDgJnje6QHnp0nwfKD4AuRHo
wGmlDpX1uYoWAjTAwp/L
=c4KR
-----END PGP SIGNATURE-----

--L03ftL0pIiPVemqqKAGGbThAa35xuOQ4J--

