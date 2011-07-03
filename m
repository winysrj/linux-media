Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.23]:47033 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751416Ab1GCWn0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 3 Jul 2011 18:43:26 -0400
From: Oliver Endriss <o.endriss@gmx.de>
To: "Linux Media Mailing List" <linux-media@vger.kernel.org>
Subject: Re: [DVB] TT S-1500b tuning issue
Date: Mon, 4 Jul 2011 00:42:59 +0200
Cc: =?iso-8859-1?q?S=E9bastien_RAILLARD?= (COEXSI) <sr@coexsi.fr>,
	Malcolm Priestley <tvboxspy@gmail.com>
References: <00a301cc365e$b6d415c0$247c4140$@coexsi.fr>
In-Reply-To: <00a301cc365e$b6d415c0$247c4140$@coexsi.fr>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_0BPEONZYsCeMZ15"
Message-Id: <201107040043.00393@orion.escape-edv.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

--Boundary-00=_0BPEONZYsCeMZ15
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Wednesday 29 June 2011 15:16:10 S=E9bastien RAILLARD wrote:
> Dear all,
>=20
> We have found what seems to be a tuning issue in the driver for the ALPS
> BSBE1-D01A used in the new TT-S-1500b card from Technotrend.
> On some transponders, like ASTRA 19.2E 11817-V-27500, the card can work v=
ery
> well (no lock issues) for hours.
>=20
> On some other transponders, like ASTRA 19.2E 11567-V-22000, the card near=
ly
> never manage to get the lock: it's looking like the signal isn't good
> enough.

Afaics the problem is caused by the tuning loop
    for (tm =3D -6; tm < 7;)
in stv0288_set_frontend().

I doubt that this code works reliably.
Apparently it never obtains a lock within the given delay (30us).

Could you please try the attached patch?
It disables the loop and tries to tune to the center frequency.

CU
Oliver

=2D-=20
=2D---------------------------------------------------------------
VDR Remote Plugin 0.4.0: http://www.escape-edv.de/endriss/vdr/
4 MByte Mod: http://www.escape-edv.de/endriss/dvb-mem-mod/
=46ull-TS Mod: http://www.escape-edv.de/endriss/dvb-full-ts-mod/
=2D---------------------------------------------------------------

--Boundary-00=_0BPEONZYsCeMZ15
Content-Type: text/x-diff;
  charset="iso-8859-1";
  name="stv0288-scan-disable.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="stv0288-scan-disable.diff"

diff --git a/drivers/media/dvb/frontends/stv0288.c b/drivers/media/dvb/frontends/stv0288.c
index 8e0cfad..4ffe7da 100644
--- a/drivers/media/dvb/frontends/stv0288.c
+++ b/drivers/media/dvb/frontends/stv0288.c
@@ -488,6 +488,10 @@ static int stv0288_set_frontend(struct dvb_frontend *fe,
 	/* Carrier lock control register */
 	stv0288_writeregI(state, 0x15, 0xc5);
 
+#if 1 /* TEST */
+	stv0288_writeregI(state, 0x2b, 0);
+	stv0288_writeregI(state, 0x2c, 0);
+#else
 	tda[0] = 0x2b; /* CFRM */
 	tda[2] = 0x0; /* CFRL */
 	for (tm = -6; tm < 7;) {
@@ -503,6 +507,7 @@ static int stv0288_set_frontend(struct dvb_frontend *fe,
 		stv0288_writeregI(state, 0x2c, tda[2]);
 		udelay(30);
 	}
+#endif
 
 	state->tuner_frequency = c->frequency;
 	state->fec_inner = FEC_AUTO;

--Boundary-00=_0BPEONZYsCeMZ15--
