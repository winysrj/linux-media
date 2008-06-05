Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <dkuhlen@gmx.net>) id 1K4Lzt-0004pq-5q
	for linux-dvb@linuxtv.org; Thu, 05 Jun 2008 22:23:49 +0200
From: Dominik Kuhlen <dkuhlen@gmx.net>
To: linux-dvb@linuxtv.org
Date: Thu, 5 Jun 2008 22:23:10 +0200
References: <1212610778l.7239l.1l@manu-laptop>
In-Reply-To: <1212610778l.7239l.1l@manu-laptop>
MIME-Version: 1.0
Message-Id: <200806052223.10682.dkuhlen@gmx.net>
Subject: Re: [linux-dvb] No lock on a particular transponder with TT S2-3200
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0994578687=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0994578687==
Content-Type: multipart/signed;
  boundary="nextPart404238081.FL0Ko4cL0K";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart404238081.FL0Ko4cL0K
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Wednesday 04 June 2008, manu wrote:
> 	Hi all,
> one more datapoint for the TT 3200 tuning problems. I solved all my=20
> locking problems by add 4MHz to the reported frequencies (coming from=20
> the stream tables); note that one of the transponders always locked=20
> even without this correction (its freq is 11093MHz, the others are :=20
> 11555, 11635, 11675MHz), so as you see the others are much higher.
> Now there is another transponder at 11495MHz but this one I cant lock=20
> on it even with my correction. Here are its characteristic as reported=20
=2D--snip---
According to=20
http://www.ses-astra.com/consumer/de/Sender/senderlisten/2001_20080603_pdf.=
pdf
this transponder is analog TV with some ADRs.


 Dominik

--nextPart404238081.FL0Ko4cL0K
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkhISy4ACgkQ6OXrfqftMKI0/gCfRzCiEIjh5S1ihiVIfeJDB83B
a3oAnR5pFWBprqMGb7MR9tBp1G7b7ORJ
=r9qn
-----END PGP SIGNATURE-----

--nextPart404238081.FL0Ko4cL0K--


--===============0994578687==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0994578687==--
