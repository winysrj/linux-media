Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr1-f67.google.com ([209.85.221.67]:47103 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726522AbeGOPlN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 15 Jul 2018 11:41:13 -0400
Received: by mail-wr1-f67.google.com with SMTP id s11-v6so29430470wra.13
        for <linux-media@vger.kernel.org>; Sun, 15 Jul 2018 08:17:55 -0700 (PDT)
Date: Sun, 15 Jul 2018 17:17:53 +0200
From: Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>
To: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Cc: Sean Young <sean@mess.org>, linux-media@vger.kernel.org,
        Pavel Machek <pavel@ucw.cz>,
        Timo Kokkonen <timo.t.kokkonen@iki.fi>,
        Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH v3 2/2] media: rc: remove ir-rx51 in favour of generic
 pwm-ir-tx
Message-ID: <20180715151753.2rfv5qht63romadr@pali>
References: <20180713122230.19278-1-sean@mess.org>
 <20180713122230.19278-2-sean@mess.org>
 <f44eb6ba-c94f-a397-1577-da647b880ac1@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="p5s5h7j54zszpyl6"
Content-Disposition: inline
In-Reply-To: <f44eb6ba-c94f-a397-1577-da647b880ac1@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--p5s5h7j54zszpyl6
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Friday 13 July 2018 17:38:25 Ivaylo Dimitrov wrote:
> Hi,
>=20
> On 13.07.2018 15:22, Sean Young wrote:
> > The ir-rx51 is a pwm-based TX driver specific to the N900. This can be
> > handled entirely by the generic pwm-ir-tx driver.
> >=20
> > Note that the suspend code in the ir-rx51 driver is unnecessary, since
> > during transmit, the process is not in interruptable sleep. The process
> > is not put to sleep until the transmit completes.
> >=20
> > Compile tested only.
> >=20
>=20
> I would like to see this being tested on a real HW, however I am on a
> holiday for the next week so won't be able to test till I am back.
>=20
> @Pali - do you have n900 with fremantle, upstream kernel and pierogi to t=
est
> pwm-ir-tx on it?

Hi! Currently on my N900 with Maemo Fremantle is 2.6.28 and 3.12
kernels. And 3.12 is a far away from current upstream kernel.

--=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--p5s5h7j54zszpyl6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQS4VrIQdKium2krgIWL8Mk9A+RDUgUCW0tlnQAKCRCL8Mk9A+RD
UrylAJsFTCNUop4EulbO8I0xpEXbugOhfACgqv9/Y1Z0KkC2WxYB/pyw9oytilI=
=H7g+
-----END PGP SIGNATURE-----

--p5s5h7j54zszpyl6--
