Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:49545 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752576Ab3BNKIY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Feb 2013 05:08:24 -0500
Message-ID: <511CB792.1020608@ti.com>
Date: Thu, 14 Feb 2013 12:08:18 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
MIME-Version: 1.0
To: Florian Neuhaus <florian.neuhaus@reberinformatik.ch>,
	"Taneja, Archit" <archit@ti.com>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: AW: omapdss/omap3isp/omapfb: Picture from omap3isp can't recover
 after a blank/unblank (or overlay disables after resuming)
References: <6EE9CD707FBED24483D4CB0162E85467245822C8@AMSPRD0711MB532.eurprd07.prod.outlook.com> <51138BCA.4010701@ti.com> <6EE9CD707FBED24483D4CB0162E8546724593AEC@AMSPRD0711MB532.eurprd07.prod.outlook.com>
In-Reply-To: <6EE9CD707FBED24483D4CB0162E8546724593AEC@AMSPRD0711MB532.eurprd07.prod.outlook.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="------------enig208871A805FDC5A0BB85F8FB"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--------------enig208871A805FDC5A0BB85F8FB
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 2013-02-14 11:30, Florian Neuhaus wrote:
> Hi Tomi,
>=20
> Tomi Valkeinen wrote on 2013-02-07:
>=20
>> FIFO underflow means that the DSS hardware wasn't able to fetch enough=
=20
>> pixel data in time to output them to the panel. Sometimes this happens=
=20
>> because of plain misconfiguration, but usually it happens because of=20
>> the hardware just can't do things fast enough with the configuration=20
>> the user has set.
>>
>> In this case I see that you are using VRFB rotation on fb0, and the=20
>> rotation is
>> 270 degrees. Rotating the fb is heavy, especially 90 and 270 degrees. =

>> It may be that when the DSS is resumed, there's a peak in the mem=20
>> usage as DSS suddenly needs to fetch lots of data.
>>
>> Another issue that could be involved is power management. After the=20
>> DSS is suspended, parts of OMAP may be put to sleep. When the DSS is=20
>> resumed, these parts need to be woken up, and it may be that there's a=
=20
>> higher mem latency for a short period of time right after resume.=20
>> Which could again cause DSS not getting enough pixel data.
>>
>> You say the issue doesn't happen if you disable fb0. What happens if=20
>> you disable fb0, blank the screen, then unblank the screen, and after =

>> that enable fb0 again?
>=20
> By "disable fb0" do you mean disconnect fb0 from ovl0 or disable ovl0?
> I have done both:
> http://pastebin.com/Bxm1Z2RY
>=20
> This works as expected.

I think both disconnecting fb0 and ovl0, and disabling ovl0 end up doing
the same, which is disabling ovl0. Which is what I meant.

So, if I understand correctly, this only happens at unblank, and can be
circumvented by temporarily keeping ovl0 disabled during the unblank,
and enabling ovl0 afterwards works fine.

So for some reason the time of unblank is "extra heavy" for the memory bu=
s.

Archit, I have a feeling that enabling the LCD is heavier on the memory
bus than what happens at VBLANK, even if both start fetching the pixels
for a fresh frame. You've been twiddling with the FIFO stuff, am I right
there?

> Further tests I have done:
>=20
> Enable fb1/ovl1 and hit some keys on the keyboard to let fb0/ovl0 updat=
e in the
> background causes a fifo underflow too:
> http://pastebin.com/f3JnMLsV
>=20
> This happens only, if I enable the vrfb (rotate=3D3). So the whole thin=
g
> seems to be a rotation issue. Do you have some hints to trace down
> the problem?

Not rotation issue as such, but memory bandwidth issue.

>> How about if you disable VRFB rotation, either totally, or set the=20
>> rotation to 0 or 180 degrees?
>=20
> Disable rotation is not an option for me, as we have a "wrong" oriented=

> portrait display with 480x800 which we must use in landscape mode...

I understand, I only meant that for testing purposes. VRFB rotation with
0 and 180 cause a slight impact on the mem bus, whereas 90 and 270
rotation cause a large impact. Also, as I mentioned earlier, the PM may
also affect this, as things may have been shut down in the OMAP. So
disabling PM related features could also "fix" the problem.

In many cases underflows are rather hard to debug and solve. There are
things in the DSS hardware like FIFO thresholds and prefetch, and VRFB
tile sizes, which can be changed (although unfortunately only by
modifying the drivers). How they should be changed if a difficult
question, though, and whether it'll help is also a question mark.

If you want to tweak those, I suggest you study them from the TRM.

 Tomi



--------------enig208871A805FDC5A0BB85F8FB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with undefined - http://www.enigmail.net/

iQIcBAEBAgAGBQJRHLeSAAoJEPo9qoy8lh71iEgP/35V1zEbD2xK8sfeuY5iYNN8
XneVApPJFczW0gLultiXVNrBDxqng3D4cNzZXvjyV0rDsxDDSwsH27Rz6T9Kq3vU
Ot2u+t86YkI2iB63fYyTvFJx21/o3xLfDZ+eyZqYOM1CGcIDvysYE6aqGk3eEJIB
lYCzY41k8Xmi1mumlwo9ucn/UoD2BPKyQPO+Dn+TyEjxvRkSAL5SG664jl9VWJ7G
CKxk4gkJ/aFjGU+zP9g/t6swjrhtsK96h8Z+u8yBKo/GC6d1COIcPqVQYwkHZ3WQ
dl0yn9GCGPPZebsw2CnvhC2nnJY3xJlP7odbPYmeQUbyKipoN65t5D4Nbjm9PbLv
fHId4hSYMrh/1EJ3AghzcMnK9GxRMr6IezsLTdNFT7p/l2BX8Y+tnvZ+eyks8who
E4lDc0JZbyp1iKn/IdfbZ7ZmIXWk7yT9GOfJO9BSweQBsa8/AwV9HKbseDCYsp5g
WeXPo4DtPwhJdmKs0nczM1u2N7H4s3atN/VGv5cc9Uy9tGCJK1XZhcTPEHr3zGk9
Qa4yyxOQ6h8PWtj6/2rNFOyODqRRXrqwNxX3ckSK0HLsONzc+E9RM4go8EoW/8LP
NqtnXfRyzE3V4/beX6QADhB3tLoIrMSA8I5prGqCmDB4bf7AP1614mf0vacOaoDB
SMNSWnRWvYBthSX2VW9k
=30nP
-----END PGP SIGNATURE-----

--------------enig208871A805FDC5A0BB85F8FB--
