Return-path: <linux-media-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43668 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750745Ab2CBEft (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 1 Mar 2012 23:35:49 -0500
Message-ID: <1330662942.8460.229.camel@deadeye>
Subject: Re: [PATCH 1/5] staging: lirc_serial: Fix init/exit order
From: Ben Hutchings <ben@decadent.org.uk>
To: Jonathan Nieder <jrnieder@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
	Jarod Wilson <jarod@redhat.com>,
	Torsten Crass <torsten.crass@eBiology.de>
Date: Fri, 02 Mar 2012 04:35:42 +0000
In-Reply-To: <20120302034545.GA31860@burratino>
References: <1321422581.2885.50.camel@deadeye>
	 <20120302034545.GA31860@burratino>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-E72ecY/X89wKpFpFW4Fb"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-E72ecY/X89wKpFpFW4Fb
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2012-03-01 at 21:45 -0600, Jonathan Nieder wrote:
[...]
> From <http://bugs.debian.org/645811> I see that you tested these patches:
>=20
>  affc9a0d59ac [media] staging: lirc_serial: Do not assume error codes
>               returned by request_irq()
>  9b98d6067971 [media] staging: lirc_serial: Fix bogus error codes
>  1ff1d88e8629 [media] staging: lirc_serial: Fix deadlock on resume failur=
e
>  c8e57e1b766c [media] staging: lirc_serial: Free resources on failure
>               paths of lirc_serial_probe()
>  9105b8b20041 [media] staging: lirc_serial: Fix init/exit order
>=20
> in a VM.  They were applied in 3.3-rc1 and have been in the Debian
> kernel since 3.1.4-1 at the end of November.
>=20
> Would some of these patches (e.g., at least patches 1, 2, and 5) be
> appropriate for inclusion in the 3.0.y and 3.2.y stable kernels from
> kernel.org?

Assuming they haven't caused any regressions, I think everything except
9b98d6067971 (4/5) would be appropriate.

Ben.

--=20
Ben Hutchings
One of the nice things about standards is that there are so many of them.

--=-E72ecY/X89wKpFpFW4Fb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUAT1BOHue/yOyVhhEJAQqHrxAApRsqtquoHu0S1HVD1ggZ6dn0ydFDuV6o
TC0d9qEsvi0GtyQbBVmlbRNpA963R92MkqHzsc8I+9+nE6uXE+fm0f9agaz4OR3o
wFPEkB/5+GCvQvLeVsMyexMk7nwWcRCI9BGH5Sr95QkTjxagQlIbNfd0BXhuCeS0
dMPpDPNUYvjBf41ZmUfqN0Ia31bQBn70aqP9ktCOjEzBmJwJP887iffHPTAiG2l4
4TQSof406p9z7qj4Pp8NFBGwVWOkbVvyJYnf77omdPzo+vi3AZ6qaSLnS0hThFdk
tsdVh2JvjN1fFzBE5PKs28rb2RAmA7lXtpo5PqJIUGGS2S/WHxg0bSL860Gtall0
JuLnnDz3UKlab0jTGnOujarjqiGKs/8/oDFVEVw5EetJL+kawRzxJUVLdki6Q9ip
aQWtPw+R+o6M0bzqk3p6QkYHbabKlthHoCU0i/kQfMUDinh7rkPGY0hTbcIv8Pmp
d+6VRUFHupSBvwkveZ8YNAYmv0cvYvWeFGo7Jq60Bvwox/PP3xK2tMvuONw6o9K5
pBaSBRXbqBPBarHu75ZzuCiyhQDhHvwrLKBdYlOpEtA1m2GKF1opoTt2qIWEUrAk
juUsWH2BHad1ZgoQyZL+SbZO3d+Gr54aAlPIRad+J5aQUCdMWJwIfMupqUpKlO6E
xXt1Xkd8P3I=
=Ffzp
-----END PGP SIGNATURE-----

--=-E72ecY/X89wKpFpFW4Fb--
