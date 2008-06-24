Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ug-out-1314.google.com ([66.249.92.173])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <filippo.argiolas@gmail.com>) id 1KBCUV-0002IN-CF
	for linux-dvb@linuxtv.org; Tue, 24 Jun 2008 19:39:40 +0200
Received: by ug-out-1314.google.com with SMTP id m3so670081uge.20
	for <linux-dvb@linuxtv.org>; Tue, 24 Jun 2008 10:39:35 -0700 (PDT)
From: Filippo Argiolas <filippo.argiolas@gmail.com>
To: Philip Pemberton <lists@philpem.me.uk>
In-Reply-To: <4845BB33.9080508@philpem.me.uk>
References: <4845BB33.9080508@philpem.me.uk>
Date: Tue, 24 Jun 2008 19:39:02 +0200
Message-Id: <1214329142.17965.8.camel@tux>
Mime-Version: 1.0
Cc: linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] RC-6 remotes on dib0700 (Nova-T-500) and
	cx88	(HVR-3000)
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1433550148=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>


--===============1433550148==
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-fexg+Qw8ZQr84ijNZ1mv"


--=-fexg+Qw8ZQr84ijNZ1mv
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Il giorno mar, 03/06/2008 alle 22.44 +0100, Philip Pemberton ha scritto:
> Hi,
>    Has anyone managed to get a remote using the Philips RC-6 protocol wor=
king=20
> with either the cx88 driver, or the dib0070 driver?
>=20
>    The HVR-3000 (cx88) only works with the standard Hauppauge remote (RC-=
5=20
> protocol) and ignores everything else, though the hardware seems to be ca=
pable=20
> of decoding more than that (insofar as it's just an IR sensor wired to a =
GPIO).
>=20
>    The Nova-T-500 appears to support three protocols -- RC-5, RC-6 and NE=
C. If=20
> I change the module parameters, I can get the RC-5 remote to work, but if=
 I=20
> change the protocol to RC-6, neither the RC-6 remote nor the Hauppauge re=
mote=20
> will work -- as in, there's nothing in /dev/input/event# (where # =3D 2 f=
or the=20
> HVR, 3 for the T-500).

Hi, regarding dib0700, I don't have any rc-6 remote to test if it works
but afaict at the moment there is no particular support for rc6 remotes
within the dib0700 driver (I wrote the patch to support nec remotes,
before only rc5 were supported).=20
At the moment if you set rc6 protocol the device is set correctly to
that protocol and keypresses are processed as rc5 ones so you should at
least get some "unknown key" message in the kernel log. If not, there is
a good chance that the device is not really able to process rc6 events
since nothing is being set in the keypress register.
Note that I'm just supposing, I cannot say nothing certain without a
remote to make some test.

Cheers

Filippo


--=-fexg+Qw8ZQr84ijNZ1mv
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Questa =?ISO-8859-1?Q?=E8?= una parte del messaggio
	firmata digitalmente

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD4DBQBIYTE2DNBLuf7fMcERAgaZAJ9WLkfThrnbPzSi/Ktyaqumf7ep0ACXaQlz
ri4F4xhZG8CABJoIzNYOtA==
=ZHFu
-----END PGP SIGNATURE-----

--=-fexg+Qw8ZQr84ijNZ1mv--



--===============1433550148==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1433550148==--
