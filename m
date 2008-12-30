Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from koos.idefix.net ([82.95.196.202] helo=kzdoos.xs4all.nl)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <koos@kzdoos.xs4all.nl>) id 1LHbvw-0003JD-IL
	for linux-dvb@linuxtv.org; Tue, 30 Dec 2008 11:34:46 +0100
Date: Tue, 30 Dec 2008 11:34:38 +0100
From: Koos van den Hout <koos@kzdoos.xs4all.nl>
To: Christoph Pfister <christophpfister@gmail.com>
Message-ID: <20081230103438.GA12942@kzdoos.xs4all.nl>
References: <20081224112111.GA15004@kzdoos.xs4all.nl>
	<19a3b7a80812291613kc566f0cua89156b43f1ec7d7@mail.gmail.com>
Mime-Version: 1.0
In-Reply-To: <19a3b7a80812291613kc566f0cua89156b43f1ec7d7@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Scan file dvb-t nl-Utrecht
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1298196468=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>


--===============1298196468==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="x+6KMIRAuhnl3hBn"
Content-Disposition: inline


--x+6KMIRAuhnl3hBn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Quoting Christoph Pfister who wrote on Tue 2008-12-30 at 01:13:

> 2008/12/24 Koos van den Hout <koos@kzdoos.xs4all.nl>:
> > As attached, tested yesterday evening with scan from Ubuntu dvb-utils
> > 1.1.1-3.
> Those nl-* files were removed in favour of a nl-All file 11 months
> ago. I've recreated the nl-All file as some channels have changed
> since then [1], so all issues should be solved now.

I found the repository and nl-All in the mean time, which is indeed a
complete overview. It seems the files delivered with Ubuntu are somewhat
dated compared to the dvb-apps repository.

You *could* add the following entry:

T 850000000 8MHz 1/2 NONE QAM64 8k 1/4 NONE # UHF 68

Which is the local RTV-Stadskanaal dvb-t station (FTA), source
http://www.rtvvis.nl/rtvvis-freq.tv DVB-T Lokaal NL.htm

Another one I tested in the deep south of the Netherlands:

# Liege - Belgique
# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
T 834000000 8MHz 3/4 NONE QAM16 8k 1/4 NONE

Frequency found from=20
http://nl.wikipedia.org/wiki/DVB-T-frequenties

encoding, error correction and guard rate found by experiment: this was the
setting that gave 0 errors / uncorrectable blocks and good image/sound.

                                           Koos van den Hout

--=20
The Virtual Bookcase, the site about books, book    | Koos van den Hout
news and reviews http://www.virtualbookcase.com/    | http://idefix.net/~ko=
os/
PGP keyid DSS/1024 0xF0D7C263 or RSA/1024 0xCA845CB5|

--x+6KMIRAuhnl3hBn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFJWfk+LGY7XfDXwmMRAvk/AKDyPJsVUDsrSbDgXRc6qlMpNqMYFQCghCjx
6jzJ2ft++TSHwamTo34o/bU=
=C0MY
-----END PGP SIGNATURE-----

--x+6KMIRAuhnl3hBn--


--===============1298196468==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1298196468==--
