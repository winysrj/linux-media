Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f54.google.com ([209.85.218.54]:36703 "EHLO
	mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758424AbcHCUuD (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Aug 2016 16:50:03 -0400
Received: by mail-oi0-f54.google.com with SMTP id f189so23091085oig.3
        for <linux-media@vger.kernel.org>; Wed, 03 Aug 2016 13:50:03 -0700 (PDT)
Subject: Re: TW2866 i2c driver and solo6x10
To: Andrey Utkin <andrey_utkin@fastmail.com>,
	linux-media@vger.kernel.org
References: <d5269058-c953-5b3e-7b19-0b4c6474714c@gmail.com>
 <20160803192819.GB24606@zver>
From: Marty Plummer <netz.kernel@gmail.com>
Message-ID: <c569d6b2-c9d8-49fe-0bd2-fbd23b15d538@gmail.com>
Date: Wed, 3 Aug 2016 15:26:39 -0500
MIME-Version: 1.0
In-Reply-To: <20160803192819.GB24606@zver>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="iAH38SJt6k1hQ02raO1UR0FaSPId66WI1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--iAH38SJt6k1hQ02raO1UR0FaSPId66WI1
Content-Type: multipart/mixed; boundary="cxfB6gk11e89pNH7l6eWrF67bni3Cdset"
From: Marty Plummer <netz.kernel@gmail.com>
To: Andrey Utkin <andrey_utkin@fastmail.com>, linux-media@vger.kernel.org
Message-ID: <c569d6b2-c9d8-49fe-0bd2-fbd23b15d538@gmail.com>
Subject: Re: TW2866 i2c driver and solo6x10
References: <d5269058-c953-5b3e-7b19-0b4c6474714c@gmail.com>
 <20160803192819.GB24606@zver>
In-Reply-To: <20160803192819.GB24606@zver>

--cxfB6gk11e89pNH7l6eWrF67bni3Cdset
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 08/03/2016 02:28 PM, Andrey Utkin wrote:
> On Wed, Jul 27, 2016 at 11:51:22PM -0500, Marty Plummer wrote:
>> I have one of those rebranded chinese security dvrs, the ones with all=
 the gaping
>> security holes. I'd like to fix that up and setup a good rtsp server o=
n it, but
>> first comes low-level stuff, drivers and such. I've been squinting at =
the pcb and
>> ID'ing chips for a bit now, and I've figured most of them out. Looks l=
ike the actual
>> video processing is done on 4 tw2866 chips, though the kernel module h=
as symbols
>> referring to tw2865. I've seen another driver in the kernel tree, the =
bluecherry
>> solo6x10, but that's on the pci bus. as far as I can figure, the dvr u=
ses i2c for
>> them. So, what I'm wondering is would it be feasible to factor out som=
e of the solo
>> functionality into a generic tw2865 driver and be able to pull from th=
at for an i2c
>> kernel module? I'd really hate to have to rewrite the whole thing, dup=
licated code
>> and overworking are generally a bad idea, even if I do have a datashee=
t for the chip
>> in question
>=20
>=20
> Hi Matt,
>=20
> Bluecherry LLC software developer here (barely knowing about tw28xx stu=
ff).
>=20
> If I was you, I'd restrain from such project unless I had a bulk of suc=
h
> hardware, not just single unit. This is because things are hard to get
> right without tinkering step by step. Also somebody would still need to=

> do fair amount of coding. And unless you are already qualified to do it=

> alone, you'd need many cycles of asking questions and providing lots of=

> details of your actual system. If you are interested in merging your
> results upstream, then there's even more efforts to put.
> As a developer affiliated with Bluecherry LLC, I will do my best to hel=
p
> you, but I am mere mortal with all sorts of constraints - knowledge,
> time, etc. But I or Bluecherry won't just make everything for you, even=

> if you send us a sample of hardware (which would be a good start for a
> volunteer willing to take that challenge).
> So feel free to post here your specific questions if you go for it.
>=20
An understanable sentement, but its not just about me (though I actually =
own two
of the same dvr's). There is a large number, if reports are to be believe=
d, of
more or less identical dvr systems with the same security holes and hard-=
coded
credentials, with no vendor firmware updates. In addition, I am also in p=
ossesion
of the chip vendor sdk with full source code for the kernel and modules a=
nd a
host of pertenant datasheets. My end goal is something along the line of =
openwrt
or lede for these systems in the interest of the community at large.

I'm not averse to the concept of hard work, and while I'm very experience=
d when
it comes to kernel hacking I think I can manage well enough with relevant=
 source
and examples, of which there is a large amount.

One concern I have is dealing with devicetree, but I think I can manage.


--cxfB6gk11e89pNH7l6eWrF67bni3Cdset--

--iAH38SJt6k1hQ02raO1UR0FaSPId66WI1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJXolOFAAoJEHWEtN3AMJGNr2AP/jfQ6zy2CcfzxP91nsV9uL2s
Ez7cRtUNqUupOxqg0FPrRvuhv4Uv6egBmyswYn0o2SvqT54sAxVQzArUxDr+lH6E
kFjIg5LQe/KRsD9VTX6rpjCpVclCT51fU3eos5z7d+7tR8WaCFXN7juLl10N2G8f
BHdZhhK6mvMhY0sbnNgdqBV8GHMLhuHAzwx/zgHQpCJQfZO0dMhE8kruIV5Pr72l
AtuMmL2Bh2DH61TN3/MAi5iHJmEi6z9Zb3iJ728Vw7M/aeRPX1pjmR0/7nsC01aH
a3fPl2bNt29cI8mGslVNMbBqzpj5RgVbKJqTnPa6WnCvRT7RYyMoO6ynblzwPalt
QscS8eH10v79OyhbauhSSHZ/ynXx3zaPiGT42sLDbdNl3Fog982gqsRY85LkF/7p
WAjxG+oTndvwaHlNEe8j9Fk2/JgEVr84LOsCtaHIH08h0Zwg77s/ny2XGA177JhL
93I/nUmY3hpQixIWQ+Uu5SlPnZwOVHomE+qPetrup1ahRnT8brV3rsqaw+6YVBib
jTaNLZVejdCXIaaEmnlLoDiGBj8Nwqma9HXtzGq6EsbZtTGb/gieID2GbPBc/A0R
YXlTLZUzWTxPFLqWkLl2bt+XxZMgubfhMtWqWE8ffWPYfcMtF6CRCC7mv6zOq0AT
x0kp24bRHYAbAe3yYVT6
=l79z
-----END PGP SIGNATURE-----

--iAH38SJt6k1hQ02raO1UR0FaSPId66WI1--
