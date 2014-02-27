Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f171.google.com ([74.125.82.171]:37679 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751580AbaB0Wn5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Feb 2014 17:43:57 -0500
Received: by mail-we0-f171.google.com with SMTP id u56so3475878wes.16
        for <linux-media@vger.kernel.org>; Thu, 27 Feb 2014 14:43:55 -0800 (PST)
From: James Hogan <james.hogan@imgtec.com>
To: Antti =?ISO-8859-1?Q?Sepp=E4l=E4?= <a.seppala@gmail.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org
Subject: Re: [RFC PATCH 2/3] ir-rc5-sz: Add ir encoding support
Date: Thu, 27 Feb 2014 22:43:37 +0000
Message-ID: <1521244.QqC8qHmuKo@radagast>
In-Reply-To: <CAKv9HNZ2E00RPno0PX5=V-4gy8kxxP7zgW-NH729Ye1g+Myz=w@mail.gmail.com>
References: <CAKv9HNYxY0isLt+uZvDZJJ=PX0SF93RsFeS6PsRMMk5gqtu8kQ@mail.gmail.com> <1757001.8sWyckB0oo@radagast> <CAKv9HNZ2E00RPno0PX5=V-4gy8kxxP7zgW-NH729Ye1g+Myz=w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart6735308.c28Pbi8rlf"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--nextPart6735308.c28Pbi8rlf
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"

On Sunday 16 February 2014 19:04:01 Antti Sepp=E4l=E4 wrote:
> On 12 February 2014 01:39, James Hogan <james.hogan@imgtec.com> wrote=
:
> > On Tuesday 11 February 2014 20:14:19 Antti Sepp=E4l=E4 wrote:
> >> Are you working on the wakeup protocol selector sysfs interface?
> >=20
> > I gave it a try yesterday, but it's a bit of a work in progress at =
the
> > moment. It's also a bit more effort for img-ir to work properly wit=
h it,
> > so I'd probably just limit the allowed wakeup protocols to the enab=
led
> > normal protocol at first in img-ir.
> >=20
> > Here's what I have (hopefully kmail won't corrupt it), feel free to=
 take
> > and improve/fix it. I'm not keen on the invasiveness of the
> > allowed_protos/enabled_protocols change (which isn't complete), but=
 it
> > should probably be abstracted at some point anyway.
>=20
> In general the approach here looks good. At least I couldn't figure
> any easy way to be less intrusive towards drivers/decoders and still
> support wakeup filters.

Thanks for taking a look (and sorry for the delay getting back to this,=
=20
holiday and sickness got in the way). FYI I've cleaned up my wakeup_pro=
tocols=20
patches a lot and will probably post tomorrow (after rebasing my patche=
s to=20
allow me to test img-ir properly with it).

Cheers
James
--nextPart6735308.c28Pbi8rlf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAABAgAGBQJTD7+jAAoJEKHZs+irPybfCKMP/jSXYCPq+wjy9D4DpFVPRXJc
AK2kXGdd40zOkEHcoKvwyrUDfFjCXpDDNHXy82KSPLIM9eYdHneRF9PGHIdMqdeV
/mYaDFNwuYehuPKHm5G1TOAypvINfLgDlzi0encJG5ZvGybLtBGKCSRZaIsrDIq5
5c4jG8B8d5tJazrGocy2OEWp5BER/q48tVU8ww5PjhopWUf8N/MY7jLRs0k44WDu
M8HLjCVYEscEJMhwjV0ZAXioxE4360Q2gTXiL1WbEjCICK42nat1u8VB1Ou1vlF1
uvpwSpSmURMWXNN+CNALXA47e/+ckfX850B1jLso9+BcopGNVn6d5fxYakh4/Wfb
9XlZhYjqteeKRNxiAPRn7k/NXXMy33LgvAgrl2adOk96A7B3/DX+gTCSZW2qtSDz
h4uuFVtMoUJtBir6BtKnBfGb6FM/bhsMiNhOn1lVpZDsfvXt1V7RZlY3USGZHHDr
vsy7D7w1QiNWBxhvvR2nYnCoo1YetzUouP1beMLG4tjnEwI8qPPtKJLrJ9oAZ8zk
PYlkqxXevBldsgQsdFTDp1EzCD8qHmm+nRNLMw3J9QYTKwa0t8Pg5HODDhCNRi6x
3T+XM1jZVeOLRt7qq5eLH0goG1pZQpBYtMKefD185zklDJW2dKU8ww3INeBD7u2R
SllnoHVhP8VYxYahNJSB
=6RW6
-----END PGP SIGNATURE-----

--nextPart6735308.c28Pbi8rlf--

