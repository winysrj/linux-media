Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <dkuhlen@gmx.net>) id 1KLdqr-00040H-9b
	for linux-dvb@linuxtv.org; Wed, 23 Jul 2008 14:53:56 +0200
From: Dominik Kuhlen <dkuhlen@gmx.net>
To: linux-dvb@linuxtv.org
Date: Wed, 23 Jul 2008 14:53:19 +0200
References: <57d40a44867ed6741b900967bc99c102@localhost>
In-Reply-To: <57d40a44867ed6741b900967bc99c102@localhost>
MIME-Version: 1.0
Message-Id: <200807231453.19124.dkuhlen@gmx.net>
Subject: Re: [linux-dvb] Technotrend 3650 and Ubuntu Heron
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0573303702=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0573303702==
Content-Type: multipart/signed;
  boundary="nextPart4398476.ykxpAuNORT";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart4398476.ykxpAuNORT
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi,=20
On Wednesday 23 July 2008, alain@satfans.be wrote:
>=20
>  So that=19s where I am now. =20
>=20
>  Anyone a last tip before I give up Linux? =20
>  lsmod | grep dvb
>  shows there are no modules running (that is what he asks you about)
>  the drivers are compiled on:
>  /home/alain/3650/multiproto/
>  from there I do make install=20
>  and it seems to work..
>   insmod dvb-core.ko    works....
>  insmod dvb-pll.ko  doen't work (and with lsmod I have proved it is
> not already loaded somehow)
>  root@TELEVISION:~/3650/multiproto/v4l# insmod ./dvb-core.ko=20
>  root@TELEVISION:~/3650/multiproto/v4l# lsmod | grep dvb
>  dvb_core               89212  0=20
>  root@TELEVISION:~/3650/multiproto/v4l# insmod ./dvb-pll.ko=20
>  insmod: error inserting './dvb-pll.ko': -1 Unknown symbol in module=20
type=20
dmesg=20
to get the unknown symbol name.=20
this normally leads to the required module.

=2D--snip--

Dominik

--nextPart4398476.ykxpAuNORT
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkiHKb8ACgkQ6OXrfqftMKIrrACfZP92i5PFdC31l6egeBTf+HY0
xYgAoIr933O9f4bSadzLE7ZWBLmdwpSz
=bpl/
-----END PGP SIGNATURE-----

--nextPart4398476.ykxpAuNORT--


--===============0573303702==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0573303702==--
