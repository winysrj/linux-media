Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <dkuhlen@gmx.net>) id 1K7oqR-0002bu-JT
	for linux-dvb@linuxtv.org; Sun, 15 Jun 2008 11:48:21 +0200
From: Dominik Kuhlen <dkuhlen@gmx.net>
To: linux-dvb@linuxtv.org
Date: Sun, 15 Jun 2008 11:47:19 +0200
References: <200805122042.43456.ajurik@quick.cz>
	<1210716109l.6217l.2l@manu-laptop>
	<200805221013.10246.ajurik@quick.cz>
In-Reply-To: <200805221013.10246.ajurik@quick.cz>
MIME-Version: 1.0
Message-Id: <200806151147.19451.dkuhlen@gmx.net>
Subject: Re: [linux-dvb] Re : Re : No lock possible at some DVB-S2 channels
	with TT S2-3200/linux
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0756107356=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0756107356==
Content-Type: multipart/signed;
  boundary="nextPart2210621.8BVgqUExVT";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart2210621.8BVgqUExVT
Content-Type: multipart/mixed;
  boundary="Boundary-01=_nUOVILQOUME9azP"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--Boundary-01=_nUOVILQOUME9azP
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi,
On Thursday 22 May 2008, Ales Jurik wrote:
> Hi,
>=20
> my friend told me that he is sometimes able to get lock by decreasing (no=
t=20
> increasing) the frequency. Yesterday I've tested it and it seems to me he=
 was=20
> right. So I'm able to get (not very stable, for few minutes) lock as well=
 as=20
> by increasing and by decreasing frequency of the same channel (EurosportH=
D).=20
The derotator code in the stb0899 seems to be setting the initial frequency=
 to the lowest search range
and never changes this (as it should increase steadily to find a lock)
>=20
> It was also detected (not by me, I don't have riser card) that when the c=
ard=20
> is connected not directly into PCI slot but with some riser card, the nee=
ded=20
> difference for getting lock is higher (up to 10MHz). So also some noise f=
rom=20
> PC is going into calculations.
>=20
> I don't think the problem is in computation of frequency but in for examp=
le=20
> not stable signal amplitude at input of demodulator or in not fluently=20
> changing the gain and bandwith of tuner within the band. As I see in the =
code=20
> some parameters are changing in steps and maybe 3 steps for whole band is=
 not=20
> enough? Especially in real conditions (not in lab)?=20
Could you please try the attached patch if this fixes the problem with=20
nominal frequency/symbolrate settings?
>=20
> But under Windows no problems were detected, so it seems that all that=20
> problems are solveable by driver (software).
>=20
> BR,
>=20
> Ales
>=20
>=20
>=20
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>=20


Dominik

--Boundary-01=_nUOVILQOUME9azP
Content-Type: text/x-diff;
  charset="iso-8859-1";
  name="fix_stb0899_tuning.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="fix_stb0899_tuning.patch"

diff -r fbcc9fa65f56 linux/drivers/media/dvb/frontends/stb0899_algo.c
=2D-- a/linux/drivers/media/dvb/frontends/stb0899_algo.c	Wed May 28 12:08:4=
8 2008 +0400
+++ b/linux/drivers/media/dvb/frontends/stb0899_algo.c	Sun Jun 15 11:37:56 =
2008 +0200
@@ -48,6 +48,49 @@ static u32 stb0899_calc_srate(u32 master
 	tmp >>=3D 24;
=20
 	return tmp;
+}
+
+s32 stb0899_get_frequency_offset(struct stb0899_state *state) {
+	s32 offset =3D 0;
+	s16 w;
+	u8 cfr[2];
+
+	struct stb0899_internal *internal =3D &state->internal;
+	switch (state->delsys) {
+	case DVBFE_DELSYS_DVBS:
+		stb0899_read_regs(state, STB0899_CFRM, cfr, 2); /* get derotator frequen=
cy	*/
+		/* don't why it is 3/2 here */
+		w =3D MAKEWORD16(cfr[0], cfr[1]);
+		offset =3D w * 3/2;
+		break;
+	case DVBFE_DELSYS_DVBS2:
+		offset =3D STB0899_READ_S2REG(STB0899_S2DEMOD, CRL_FREQ);
+		if (offset & 0x20000000) {
+			/* sign extension */
+			offset |=3D 0xc0000000;
+		}
+		/*
+		 * what is the range of offsetfreq here: assume +- 20MHz as sane range
+		 * 1MHz -> offsetfreq =3D 1000kHz * (2^30/1000) / 99 =3D 10 845 877
+		 * offset/kHz =3D offsetfreq * mclk / 1e6 / 2^30 * 1e3
+		 *            =3D (((offsetfreq / 1024) * 1000) * (mclk/1e6)) / 2^20
+		 */
+#if 0
+		/* 64 Bit arithmetic */
+		offset =3D (s32)((s64)offset *
+		                   ((s64)internal->master_clk / (s64)1000000) /
+		                   (s64)((1 << 30) / (s64)1000));
+#else
+		/* 32 Bit arithmetic */
+		offset =3D ((((offset / 1024) * 1000) / (1<<7)) * (s32)(internal->master=
_clk/1000000)) / (s32)(1<<13);
+#endif
+		break;
+	case DVBFE_DELSYS_DSS:
+	default:
+		/* TODO: */
+		break;
+	}
+	return offset;
 }
=20
 /*
@@ -132,6 +175,8 @@ long stb0899_carr_width(struct stb0899_s
 	return (internal->srate + (internal->srate * internal->rolloff) / 100);
 }
=20
+
+#if 0
 /*
  * stb0899_first_subrange
  * Compute the first subrange of the search
@@ -161,6 +206,7 @@ static void stb0899_first_subrange(struc
 	internal->tuner_offst =3D 0L;
 	internal->sub_dir =3D 1;
 }
+#endif
=20
 /*
  * stb0899_check_tmg
@@ -212,7 +258,7 @@ static enum stb0899_status stb0899_searc
 	internal->status =3D NOTIMING;
=20
 	/* timing loop computation & symbol rate optimisation	*/
=2D	derot_limit =3D (internal->sub_range / 2L) / internal->mclk;
+	derot_limit =3D 0;//(internal->sub_range / 2L) / internal->mclk;
 	derot_step =3D (params->srate / 2L) / internal->mclk;
=20
 	while ((stb0899_check_tmg(state) !=3D TIMINGOK) && next_loop) {
@@ -267,6 +313,7 @@ static enum stb0899_status stb0899_check
 	return internal->status;
 }
=20
+#if 0
 /*
  * stb0899_search_carrier
  * Search for a QPSK carrier with the derotator
@@ -322,6 +369,7 @@ static enum stb0899_status stb0899_searc
=20
 	return internal->status;
 }
+#endif
=20
 /*
  * stb0899_check_data
@@ -390,7 +438,7 @@ static enum stb0899_status stb0899_searc
 	struct stb0899_params *params =3D &state->params;
=20
 	derot_step =3D (params->srate / 4L) / internal->mclk;
=2D	derot_limit =3D (internal->sub_range / 2L) / internal->mclk;
+	derot_limit =3D 0;//(internal->sub_range / 2L) / internal->mclk;
 	derot_freq =3D internal->derot_freq;
=20
 	do {
@@ -426,6 +474,7 @@ static enum stb0899_status stb0899_searc
 	return internal->status;
 }
=20
+#if 0
 /*
  * stb0899_check_range
  * check if the found frequency is in the correct range
@@ -477,6 +526,7 @@ static void next_sub_range(struct stb089
 	internal->freq =3D params->freq + (internal->sub_dir * internal->tuner_of=
fst) / 1000;
 	internal->sub_dir =3D -internal->sub_dir;
 }
+#endif
=20
 /*
  * stb0899_dvbs_algo
@@ -494,6 +544,7 @@ enum stb0899_status stb0899_dvbs_algo(st
 	u8 eq_const[10];
 	s32 clnI =3D 3;
 	u32 bandwidth =3D 0;
+	int count;
=20
 	/* BETA values rated @ 99MHz	*/
 	s32 betaTab[5][4] =3D {
@@ -571,7 +622,9 @@ enum stb0899_status stb0899_dvbs_algo(st
 	stb0899_write_reg(state, STB0899_EQON, 0x01); /* Equalizer OFF while acqu=
iring	*/
 	stb0899_write_reg(state, STB0899_VITSYNC, 0x19);
=20
=2D	stb0899_first_subrange(state);
+	/* start where the user told us.... */
+	internal->freq =3D params->freq;
+	count =3D 0;
 	do {
 		/* Initialisations	*/
 		cfr[0] =3D cfr[1] =3D 0;
@@ -589,7 +642,7 @@ enum stb0899_status stb0899_dvbs_algo(st
 		stb0899_i2c_gate_ctrl(&state->frontend, 1);
=20
 		/* Move tuner to frequency	*/
=2D		dprintk(state->verbose, FE_DEBUG, 1, "Tuner set frequency");
+		dprintk(state->verbose, FE_DEBUG, 1, "Tuner set frequency: %d", internal=
=2D>freq);
 		if (state->config->tuner_set_frequency)
 			state->config->tuner_set_frequency(&state->frontend, internal->freq);
=20
@@ -617,7 +670,7 @@ enum stb0899_status stb0899_dvbs_algo(st
 				"TIMING OK ! Derot freq=3D%d, mclk=3D%d",
 				internal->derot_freq, internal->mclk);
=20
=2D			if (stb0899_search_carrier(state) =3D=3D CARRIEROK) {	/* Search for c=
arrier	*/
+			if (stb0899_check_carrier(state) =3D=3D CARRIEROK) {	/* Check for carri=
er	*/
 				dprintk(state->verbose, FE_DEBUG, 1,
 					"CARRIER OK ! Derot freq=3D%d, mclk=3D%d",
 					internal->derot_freq, internal->mclk);
@@ -627,12 +680,13 @@ enum stb0899_status stb0899_dvbs_algo(st
 						"DATA OK ! Derot freq=3D%d, mclk=3D%d",
 						internal->derot_freq, internal->mclk);
=20
=2D					if (stb0899_check_range(state) =3D=3D RANGEOK) {
+						internal->status =3D RANGEOK;
 						dprintk(state->verbose, FE_DEBUG, 1,
 							"RANGE OK ! derot freq=3D%d, mclk=3D%d",
 							internal->derot_freq, internal->mclk);
=20
=2D						internal->freq =3D params->freq + ((internal->derot_freq * interna=
l->mclk) / 1000);
+						dprintk(state->verbose, FE_DEBUG, 1, "derot=3D%d user_freq=3D%d\n", =
internal->derot_freq, params->freq);
+						internal->freq =3D params->freq + stb0899_get_frequency_offset(state=
);
 						reg =3D stb0899_read_reg(state, STB0899_PLPARM);
 						internal->fecrate =3D STB0899_GETFIELD(VITCURPUN, reg);
 						dprintk(state->verbose, FE_DEBUG, 1,
@@ -642,14 +696,13 @@ enum stb0899_status stb0899_dvbs_algo(st
 						dprintk(state->verbose, FE_DEBUG, 1,
 							"internal puncture rate=3D%d",
 							internal->fecrate);
=2D					}
 				}
 			}
 		}
=2D		if (internal->status !=3D RANGEOK)
=2D			next_sub_range(state);
=20
=2D	} while (internal->sub_range && internal->status !=3D RANGEOK);
+		/* avoid infinite loop */
+		count++;
+	} while (count < 3 && internal->status !=3D RANGEOK);
=20
 	/* Set the timing loop to tracking	*/
 	stb0899_write_reg(state, STB0899_RTC, 0x33);
@@ -1491,16 +1544,8 @@ enum stb0899_status stb0899_dvbs2_algo(s
 		STB0899_SETFIELD_VAL(EQ_SHIFT, reg, 0x02);
 		stb0899_write_s2reg(state, STB0899_S2DEMOD, STB0899_BASE_EQ_CNTRL, STB08=
99_OFF0_EQ_CNTRL, reg);
=20
=2D		/* Store signal parameters	*/
=2D		offsetfreq =3D STB0899_READ_S2REG(STB0899_S2DEMOD, CRL_FREQ);
=2D
=2D		offsetfreq =3D offsetfreq / ((1 << 30) / 1000);
=2D		offsetfreq *=3D (internal->master_clk / 1000000);
=2D		reg =3D STB0899_READ_S2REG(STB0899_S2DEMOD, DMD_CNTRL2);
=2D		if (STB0899_GETFIELD(SPECTRUM_INVERT, reg))
=2D			offsetfreq *=3D -1;
=2D
=2D		internal->freq =3D internal->freq - offsetfreq;
+		/* store acutal frequency */
+		internal->freq =3D internal->freq + stb0899_get_frequency_offset(state);
 		internal->srate =3D stb0899_dvbs2_get_srate(state);
=20
 		reg =3D STB0899_READ_S2REG(STB0899_S2DEMOD, UWP_STAT2);
diff -r fbcc9fa65f56 linux/drivers/media/dvb/frontends/stb0899_drv.c
=2D-- a/linux/drivers/media/dvb/frontends/stb0899_drv.c	Wed May 28 12:08:48=
 2008 +0400
+++ b/linux/drivers/media/dvb/frontends/stb0899_drv.c	Sun Jun 15 11:37:56 2=
008 +0200
@@ -1718,6 +1718,7 @@ static enum dvbfe_search stb0899_search(
 	return DVBFE_ALGO_SEARCH_ERROR;
 }
=20
+#if 0
 static enum stb0899_status stb0899_track_carrier(struct stb0899_state *sta=
te)
 {
 	u8 reg;
@@ -1906,6 +1907,8 @@ static int stb0899_get_modcod(struct stb
 	return 0;
 }
=20
+#endif
+
 /*
  * stb0899_track
  * periodically check the signal level against a specified
@@ -1992,6 +1995,8 @@ static int stb0899_get_params(struct dvb
 {
 	struct stb0899_state *state		=3D fe->demodulator_priv;
 	struct stb0899_internal *internal	=3D &state->internal;
+	struct stb0899_params *intparams		=3D &state->params;
+
=20
 	params->frequency			=3D internal->freq;
 	params->inversion			=3D internal->inversion;
@@ -1999,6 +2004,7 @@ static int stb0899_get_params(struct dvb
 	switch (state->delsys) {
 	case DVBFE_DELSYS_DVBS:
 		dprintk(verbose, FE_DEBUG, 1, "Get DVB-S params");
+		params->frequency =3D intparams->freq + stb0899_get_frequency_offset(sta=
te);
 		params->delsys.dvbs.symbol_rate		=3D internal->srate;
 		params->delsys.dvbs.modulation		=3D DVBFE_MOD_QPSK;
 		break;
@@ -2009,6 +2015,9 @@ static int stb0899_get_params(struct dvb
 		break;
 	case DVBFE_DELSYS_DVBS2:
 		dprintk(verbose, FE_DEBUG, 1, "Get DVB-S2 params");
+
+		params->frequency =3D intparams->freq + stb0899_get_frequency_offset(sta=
te);
+
 		params->delsys.dvbs2.symbol_rate	=3D internal->srate;
 		break;
 	default:
diff -r fbcc9fa65f56 linux/drivers/media/dvb/frontends/stb0899_priv.h
=2D-- a/linux/drivers/media/dvb/frontends/stb0899_priv.h	Wed May 28 12:08:4=
8 2008 +0400
+++ b/linux/drivers/media/dvb/frontends/stb0899_priv.h	Sun Jun 15 11:37:56 =
2008 +0200
@@ -165,13 +165,11 @@ struct stb0899_params {
=20
 struct stb0899_internal {
 	u32			master_clk;
=2D	u32			freq;			/* Demod internal Frequency		*/
+	u32			freq;			/* Demod internal Frequency (kHz)	*/
 	u32			srate;			/* Demod internal Symbol rate		*/
 	enum stb0899_fec	fecrate;		/* Demod internal FEC rate		*/
=2D	u32			srch_range;		/* Demod internal Search Range		*/
=2D	u32			sub_range;		/* Demod current sub range (Hz)		*/
+	u32			srch_range;		/* Demod internal Search Range (Hz)	*/
 	u32			tuner_step;		/* Tuner step (Hz)			*/
=2D	u32			tuner_offst;		/* Relative offset to carrier (Hz)	*/
 	u32			tuner_bw;		/* Current bandwidth of the tuner (Hz)	*/
=20
 	s32			mclk;			/* Masterclock Divider factor (binary)	*/
@@ -184,7 +182,6 @@ struct stb0899_internal {
 	s16			derot_step;		/* Derotator step (binary value)	*/
 	s16			t_derot;		/* Derotator time constant (ms)		*/
 	s16			t_data;			/* Data recovery time constant (ms)	*/
=2D	s16			sub_dir;		/* Direction of the next sub range	*/
=20
 	s16			t_agc1;			/* Agc1 time constant (ms)		*/
 	s16			t_agc2;			/* Agc2 time constant (ms)		*/
@@ -270,5 +267,11 @@ extern enum stb0899_status stb0899_dvbs_
 extern enum stb0899_status stb0899_dvbs_algo(struct stb0899_state *state);
 extern enum stb0899_status stb0899_dvbs2_algo(struct stb0899_state *state);
 extern long stb0899_carr_width(struct stb0899_state *state);
+/*
+ * read offset registers and
+ * calculate frequency offset in kHz
+ * according to the currently selected standard
+ */
+extern s32 stb0899_get_frequency_offset(struct stb0899_state *state);
=20
 #endif //__STB0899_PRIV_H

--Boundary-01=_nUOVILQOUME9azP--

--nextPart2210621.8BVgqUExVT
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkhU5ScACgkQ6OXrfqftMKJWhwCfSOQ9PGuVEQ1vRN8dMitjsZG0
QhEAmQFJzBY5q2Lgu6QaPUABZBJmZDJ9
=MtWW
-----END PGP SIGNATURE-----

--nextPart2210621.8BVgqUExVT--


--===============0756107356==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0756107356==--
