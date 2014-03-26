Return-path: <linux-media-owner@vger.kernel.org>
Received: from [217.156.133.130] ([217.156.133.130]:29840 "EHLO
	imgpgp01.kl.imgtec.org" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751580AbaCZPyO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Mar 2014 11:54:14 -0400
Message-ID: <5332F819.2040207@imgtec.com>
Date: Wed, 26 Mar 2014 15:54:01 +0000
From: James Hogan <james.hogan@imgtec.com>
MIME-Version: 1.0
To: =?UTF-8?B?RGF2aWQgSMOkcmRlbWFu?= <david@hardeman.nu>
CC: =?UTF-8?B?QW50dGkgU2VwcMOkbMOk?= <a.seppala@gmail.com>,
	"Mauro Carvalho Chehab" <m.chehab@samsung.com>,
	<linux-media@vger.kernel.org>
Subject: Re: [PATCH 1/5] rc-main: add generic scancode filtering
References: <1393629426-31341-1-git-send-email-james.hogan@imgtec.com> <1393629426-31341-2-git-send-email-james.hogan@imgtec.com> <20140324235146.GA25627@hardeman.nu> <10422443.FIKnYVGtAm@radagast> <20140325232130.GA2515@hardeman.nu> <CAKv9HNaRT4WdcDiuFODM7Jpg02phxRyEDDJ5CgbL0W3BjnYBGw@mail.gmail.com> <e38b3c86fdbfa448549762a6a700c296@hardeman.nu>
In-Reply-To: <e38b3c86fdbfa448549762a6a700c296@hardeman.nu>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="XNLHw81Mnuh7Ur0RhbCFwD4bsELLB2EIR"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--XNLHw81Mnuh7Ur0RhbCFwD4bsELLB2EIR
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 26/03/14 13:44, David H=C3=A4rdeman wrote:
> On 2014-03-26 08:08, Antti Sepp=C3=A4l=C3=A4 wrote:
>> On 26 March 2014 01:21, David H=C3=A4rdeman <david@hardeman.nu> wrote:=

>>> On Tue, Mar 25, 2014 at 09:12:11AM +0000, James Hogan wrote:
>>>> On Tuesday 25 March 2014 00:51:46 David H=C3=A4rdeman wrote:
>>>>> What's the purpose of providing the sw scancode filtering in the
>>>>> case where
>>>>> there's no hardware filtering support at all?
>>>>
>>>> Consistency is probably the main reason, but I'll admit it's not
>>>> perfectly
>>>> consistent between generic/hardware filtering (mostly thanks to NEC
>>>> scancode
>>>> complexities), and I have no particular objection to dropping it if
>>>> that isn't
>>>> considered a good enough reason.
>>>
>>> I'm kind of sceptical...and given how difficult it is to remove
>>> functionality that is in a released kernel...I think that particular
>>> part (i.e. the software filtering) should be removed until it has had=

>>> further discussion...
> ...
>>> I don't understand. What's the purpose of a "software fallback" for
>>> scancode filtering? Antti?
>>>
>>
>> Well since the ImgTec patches will create a new sysfs interface for
>> the HW scancode filtering I figured that it would be nice for it to
>> also function on devices which lack the hardware filtering
>> capabilities. Especially since it's only three lines of code. :)
>>
>> Therefore I suggested the software fallback. At the time I had no clue=

>> that there might be added complexities with nec scancodes.
>=20
> It's not only NEC scancodes, the sw scancode filter is state that is
> changeable from user-space and which will require reader/writer
> synchronization during the RX path (which is the "hottest" path in
> rc-core). I've posted patches before which make the RX path lockless,
> this change makes complicates such changes.
>=20
> Additionally, the provision of the sw fallback means that userspace has=

> no idea if there is an actual hardware filter present or not, meaning
> that a userspace program that is aware of the scancode filter will
> always enable it.
>=20
> So, I still think the SW part should be reverted, at least for now (i.e=
=2E
> the sysfs file should only be present if there is hardware support).

I've prepared a revert patch (which also reverts a part of a later patch
which takes SW filtering into account when updating the filter on a
protocol change). I'll double check it works right later and submit.

Note that this still leaves the sysfs nodes there though, but if
!s_filter then they read as 0 and only accept the value 0 to be written
(mask =3D=3D 0 represents no filtering).

Cheers
James


--XNLHw81Mnuh7Ur0RhbCFwD4bsELLB2EIR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iQIcBAEBAgAGBQJTMvgZAAoJEGwLaZPeOHZ63X8QAL/6Aiq/TV8VU1FyASYGxjGT
YFlDH5goy8P7GFOeu1z4LNESgeIsjHNQiOW6DUiMvKmDtM5BmeWDcFeSIUz+vzWA
VuSOsIZy4GbSsa9NL3MzSMu6fcyuO/z9U7v25++A9Il5Q30M9XRgFzbT20D31u3f
cAZF8VgIeEepViZWWo5qNBhLzWOa+6fRstOdZp+ASvASTUyBt0fmwgRcjHDwgstP
Gzp5bIruN3r/imSEPALKLgKp156fSnNocnekrW3iz7xGZtQP7uUlAtsFxf3UDRfE
ZFCe3F3q75vilFX00r5aJ70/Cc7hLsk7YBzwAk9GlquRZIfWiYSq8o/vhxlEY/3C
6wjT6oSNc1CF7aZHvORrP12KbYnRoOQXZZZmND/LUSIg5fheIhAEBI19W+vwBU8a
gkGwaJ8afxf2BDDEp97oXmqzwE9XDDb4oxY2vhS6gpYS+C+qBgE1yKVkn2pIWZGf
qmOXxtYX+IcFu9fZtDoMgIBIuC7Q85Gnn8Jo2EfuUTi5xPPKJrLzxfOzth4YC7ws
YNwl5rooAYfoOrt50caeQkvoJPPzX4qorg5MzRs0sI6IfHqY6nX6ZsWDhufo3GGM
z6CVPYPFEd/0XLup9+Crr6C2XbgyeLO4lbQdu53IjK9sfXS8NKlfEXR7xbVpM//i
DKeeSKEI5p7n6nMeS3N9
=AEdc
-----END PGP SIGNATURE-----

--XNLHw81Mnuh7Ur0RhbCFwD4bsELLB2EIR--
