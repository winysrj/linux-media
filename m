Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:55460 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752691AbeDQLlv (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 17 Apr 2018 07:41:51 -0400
Message-ID: <d9fa6ca0e79672dc523e1c56ba19ec07c5d5259d.camel@bootlin.com>
Subject: Re: [RFCv11 PATCH 00/29] Request API
From: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
To: Alexandre Courbot <acourbot@chromium.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Date: Tue, 17 Apr 2018 13:40:27 +0200
In-Reply-To: <CAPBb6MVg+3JHZC1F5qz2=ZiScnHpVD7kvouYYWOEFN3CaqFPeQ@mail.gmail.com>
References: <20180409142026.19369-1-hverkuil@xs4all.nl>
         <CAPBb6MVLpV6gbUWBnQpYiNoWmjqdhYOhicrsetT0S5p_w28HDw@mail.gmail.com>
         <95c7bf3a-06f0-46d6-d51f-47e851180681@xs4all.nl>
         <CAPBb6MVg+3JHZC1F5qz2=ZiScnHpVD7kvouYYWOEFN3CaqFPeQ@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-o0t4UM39zAC2BLapVorP"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-o0t4UM39zAC2BLapVorP
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, 2018-04-17 at 06:17 +0000, Alexandre Courbot wrote:
> On Tue, Apr 17, 2018 at 3:12 PM Hans Verkuil <hverkuil@xs4all.nl>
> wrote:
>=20
> > On 04/17/2018 06:33 AM, Alexandre Courbot wrote:
> > > On Mon, Apr 9, 2018 at 11:20 PM Hans Verkuil <hverkuil@xs4all.nl>
> > > wrote:
> > >=20
> > > > From: Hans Verkuil <hans.verkuil@cisco.com>
> > > > Hi all,
> > > > This is a cleaned up version of the v10 series (never posted to
> > > > the list since it was messy).
> > >=20
> > > Hi Hans,
> > >=20
> > > It took me a while to test and review this, but finally have been
> > > able
>=20
> to
> > > do it.
> > >=20
> > > First the result of the test: I have tried porting my dummy vim2m
> > > test
> > > program
> > > (https://gist.github.com/Gnurou/34c35f1f8e278dad454b51578d239a42
> > > for
> > > reference),
> > > and am getting a hang when trying to queue the second OUTPUT
> > > buffer
>=20
> (right
> > > after
> > > queuing the first request). If I move the calls the
> > > VIDIOC_STREAMON
>=20
> after
> > > the
> > > requests are queued, the hang seems to happen at that moment.
> > > Probably a
> > > deadlock, haven't looked in detail yet.
> > >=20
> > > I have a few other comments, will follow up per-patch.
> > >=20
> > I had a similar/same (?) report about this from Paul:
> > https://www.mail-archive.com/linux-media@vger.kernel.org/msg129177.h
> > tml
>=20
> I saw this and tried to move the call to STREAMON to after the
> requests are queued in my example program, but it then hanged there.
> So there is probably something more intricate taking place.

I figured out the issue (but forgot to report back to the list): Hans'
version of the request API doesn't set the POLLIN bit but POLLPRI
instead, so you need to select for expect_fds instead of read_fds in the
select call. That's pretty much all there is to it.

Hope this helps,

--=20
Paul Kocialkowski, Bootlin (formerly Free Electrons)
Embedded Linux and kernel engineering
https://bootlin.com
--=-o0t4UM39zAC2BLapVorP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEJZpWjZeIetVBefti3cLmz3+fv9EFAlrV3SsACgkQ3cLmz3+f
v9E50gf+OCRAsvwGbl7O14eYbkpGeRqXyfARqqvqor9/XahSPGMnphakRAGJgCrL
BYDplja1zlNTg7H3DD4uycbOC7nzPi1bhynQ+jqICdjb2Hc95NEzl/DqA+qIJXFR
ZhebDRWq3Q6pXbgdvy/HjHKt6VxdI4JEMnXiWAm74c6DWT7/13wOqqe8brmY2YZQ
GkSmnMIf22qLNuLqcgWqvn1R044hbRdORUxLW+pbJARuy42sdLPEYn5OaCW6dYWe
bdVrEuId0k0JMtO9z/gNLicu6mDf4SqTQLiDpQDsuJ4+iuEuT/LW0ttxBnIz7JYV
yISalEqZN8Ykvgdv6OuOe4yk97Ubdg==
=WEhp
-----END PGP SIGNATURE-----

--=-o0t4UM39zAC2BLapVorP--
