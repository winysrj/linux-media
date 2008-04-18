Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <dkuhlen@gmx.net>) id 1Jmp2U-0003AQ-PT
	for linux-dvb@linuxtv.org; Fri, 18 Apr 2008 13:45:59 +0200
From: Dominik Kuhlen <dkuhlen@gmx.net>
To: linux-dvb@linuxtv.org
Date: Fri, 18 Apr 2008 13:45:23 +0200
References: <1207866617l.6780l.0l@manu-laptop>
	<1207967191l.6061l.0l@manu-laptop>
	<1208470788l.6560l.0l@manu-laptop>
In-Reply-To: <1208470788l.6560l.0l@manu-laptop>
MIME-Version: 1.0
Message-Id: <200804181345.23784.dkuhlen@gmx.net>
Subject: Re: [linux-dvb] Re : Re : TT-3200 (DVB-S/S2) bad reception/no lock
	issue
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0570270567=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0570270567==
Content-Type: multipart/signed;
  boundary="nextPart1250313.Elr1Tp4amc";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart1250313.Elr1Tp4amc
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi,
On Friday 18 April 2008, manu wrote:
> On 04/11/2008 10:26:31 PM, manu wrote:
> > On 04/10/2008 06:30:17 PM, manu wrote:
> > > 	Hi all,
> > > I already reported on that sooner, but now I have a log (with
> > stb0899=20
> > > verbose=3D5) so I hope it makes it a bit easier to debug.
> > > Still the same behaviour: one transponder (freq=3D11093 MHz) is=20
> > ALWAYS
> >=20
> > > perfect (fast lock perfect picture even with bad weather) and for 3=20
> > > other transponders (11555 MHz as in the log, 11635 Mhz and 11675
> > MHz)=20
> > > the lock is much less frequent and if it locks the picture is much=20
> > > worse even in not so cloudy weather. It is as if the card was much
> > > more=20
> > > picky with the other 3 transponders. Is it normal to have such=20
> > > discrepancies on the same sat?
> > > Sometimes just locking on the "good" transponder and then switching=20
> > > back to a bad one gives good results: good lock and better SNR and=20
> > > picture (seen in mythtv).
> > > Anyway here is the log, I hope this is of some help.
> >=20
> > May I add also that rmmoding budget_ci,budget_core,stb0899 and then=20
> > modprobing them back gives better picture/locking sometimes.
> > Bye
> > Manu
>=20
> Any thought on this? InMythtv, going to a channel on a goodn=20
> transponder and then switching back to a bad one will give a lock and=20
> better picture, so...=20
> Bye
> Manu

Just out of curiosity:
Could you please try to set the channel frequencies in the channels list to
about 4MHz lower than they are currently? (e.g. 11551MHz instead of 11555MH=
z)


Dominik



--nextPart1250313.Elr1Tp4amc
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iD8DBQBICInT6OXrfqftMKIRAozEAKC901v6ts1+UGxuLi1volMe2EPUuACfcJyD
evH3k8gl0cBGWT9+yZAUMEU=
=AHKr
-----END PGP SIGNATURE-----

--nextPart1250313.Elr1Tp4amc--


--===============0570270567==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0570270567==--
