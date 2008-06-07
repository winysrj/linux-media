Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <dkuhlen@gmx.net>) id 1K4zUA-0005Zk-Tu
	for linux-dvb@linuxtv.org; Sat, 07 Jun 2008 16:33:39 +0200
From: Dominik Kuhlen <dkuhlen@gmx.net>
To: linux-dvb@linuxtv.org
Date: Sat, 7 Jun 2008 16:33:04 +0200
MIME-Version: 1.0
Message-Id: <200806071633.04876.dkuhlen@gmx.net>
Subject: [linux-dvb] Pinnacle PCTV Dual Sat Pro PCI (4000i) update
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0699170142=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0699170142==
Content-Type: multipart/signed;
  boundary="nextPart10556318.paC7Yva4KS";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart10556318.paC7Yva4KS
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi,

I have both tuners running on this card. (qemu with pciproxy works well :)
Next step is DMA setup/transfer. I cannot use qemu for this since the=20
IRQs get somehow shuffled when attaching to qemu :(

Has anybody ideas how to reverse engineer this?
Does it work using real win with rr0d or similar?

Thanks,
 Dominik

--nextPart10556318.paC7Yva4KS
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkhKnCAACgkQ6OXrfqftMKKS5ACcDTFOn9ZsPk91S3SlJ365Wir1
OHsAmwXGRP1MKUih8rOG0Ytwt6P0GY05
=SFJB
-----END PGP SIGNATURE-----

--nextPart10556318.paC7Yva4KS--


--===============0699170142==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0699170142==--
