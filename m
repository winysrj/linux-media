Return-path: <linux-media-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:33599 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755332AbbESMug (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 19 May 2015 08:50:36 -0400
Date: Tue, 19 May 2015 14:17:31 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: Federico Simoncelli <fsimonce@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Lars-Peter Clausen <lars@metafoo.de>,
	Antti Palosaari <crope@iki.fi>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Ondrej Zary <linux@rainbow-software.org>,
	Ramakrishnan Muthukrishnan <ramakrmu@cisco.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Takashi Iwai <tiwai@suse.de>,
	Amber Thrall <amber.rose.thrall@gmail.com>,
	James Harper <james.harper@ejbdigital.com.au>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH 2/2] drivers: Simplify the return code
Message-ID: <20150519141731.78744f2f@wiggum>
In-Reply-To: <577085828.1080862.1432037155994.JavaMail.zimbra@redhat.com>
References: <0fee1624f3df1827cb6d0154253f9c45793bf3e1.1432033220.git.mchehab@osg.samsung.com>
	<0fee1624f3df1827cb6d0154253f9c45793bf3e1.1432033220.git.mchehab@osg.samsung.com>
	<a24b23db60ffee5cb32403d7c8cacd25b13f4510.1432033220.git.mchehab@osg.samsung.com>
	<577085828.1080862.1432037155994.JavaMail.zimbra@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/1UWiG9fIb9onu/+zYSE6EV4"; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Sig_/1UWiG9fIb9onu/+zYSE6EV4
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 19 May 2015 08:05:56 -0400 (EDT)
Federico Simoncelli <fsimonce@redhat.com> wrote:
> > diff --git a/drivers/media/dvb-frontends/lgs8gxx.c
> > b/drivers/media/dvb-frontends/lgs8gxx.c
> > index 3c92f36ea5c7..9b0166cdc7c2 100644
> > --- a/drivers/media/dvb-frontends/lgs8gxx.c
> > +++ b/drivers/media/dvb-frontends/lgs8gxx.c
> > @@ -544,11 +544,7 @@ static int lgs8gxx_set_mpeg_mode(struct lgs8gxx_st=
ate
> > *priv,
> >  	t |=3D clk_pol ? TS_CLK_INVERTED : TS_CLK_NORMAL;
> >  	t |=3D clk_gated ? TS_CLK_GATED : TS_CLK_FREERUN;
> > =20
> > -	ret =3D lgs8gxx_write_reg(priv, reg_addr, t);
> > -	if (ret !=3D 0)
> > -		return ret;
> > -
> > -	return 0;
> > +	return lgs8gxx_write_reg(priv, reg_addr, t);
> >  }
>=20
> Personally I prefer the current style because it's more consistent with a=
ll
> the other calls in the same function (return ret when ret !=3D 0).
>=20
> It also allows you to easily add/remove calls without having to deal with
> the last special case return my_last_fun_call(...).
>=20
> Anyway it's not a big deal, I think it's your call.


I agree. I also prefer the current style for these reasons. The compiler wi=
ll also generate the same code in both cases.
I don't think it really simplifies the code.
But if you really insist on doing this change, go for it. You get my ack fo=
r fc0011

--=20
Michael

--Sig_/1UWiG9fIb9onu/+zYSE6EV4
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJVWyndAAoJEPUyvh2QjYsO0eMP/AwLdMuQfRJ6pFxFWeO22g9D
0whjaAdSP1H9v0V3J3gFzM5F9JodtgSkNY2jWPubLSSKs8YLEz9nFTULUY206vRs
EhuBNI1Mpthj5SNFbQBC29omwe0h/YBnjJRN8i/abNCa3uGbiZWAP2Sx85+xcjk0
oAhg11G73wqS+skCE8+wiSTycqZFR3FOhk3G8VWH36h1klKm+vWYyThzWi5Y/UNe
NrpMO8n7Xvjtc8X2ViCJjhITXc1RmWreJjzZ09lhpVioWpcQYD2ZYiK2E6Pyzi+l
ABx9p1tL3F/on1SXK8rCVFOtbtgSm4ich/b1OREAxbSMrZ8zmXSCxEOTCKrI6Zy/
lfTxhdLsAVbctcomtClfAJIjDgaQd16Ti1iRX0NPCD+olGXtAJzACEexkAYDQPBa
2yGdlvu2HT709+hh/+dWV3x+d6TO/UEsDwpyb68AzjzMYIYcKOTEibKWwnmv7opn
noXRF/vVdW4fjfEea6iGCnwFTjIBDLyXYdcyQ5QSkkVxHHv43ca7NshPUig06/Yb
txOm39iEj6MNnMJ1syBhDCoK70vdq9qLFBqCm5MvbLV+ifNHvEtq2hYy+p8JgLL1
Xo7uagjXna9QZXYjaKVClEqpqEo0MgLymfRxCXnAbQ0SCDb41NjjaasHj6nrDePi
r90kCpvMHwp5M+V6NSZT
=Qi3f
-----END PGP SIGNATURE-----

--Sig_/1UWiG9fIb9onu/+zYSE6EV4--
