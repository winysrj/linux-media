Return-path: <mchehab@pedra>
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:47083 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755447Ab1GAIoQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 Jul 2011 04:44:16 -0400
From: =?iso-8859-1?Q?S=E9bastien_RAILLARD_=28COEXSI=29?= <sr@coexsi.fr>
To: "Linux Media Mailing List" <linux-media@vger.kernel.org>,
	<abraham.manu@gmail.com>
Subject: [DVB] Possible regression in stb6100 module for DVBS2 transponders
Date: Fri, 1 Jul 2011 10:44:15 +0200
Message-ID: <004e01cc37cb$1020b710$30622530$@coexsi.fr>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Language: fr
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Dear Manu,

I think there is a regression in your patch from December 2010 regarding the
stb6100 module.
With the latest version of stb6100 published in media_build git branch, we
can't tune the TT-S2-3200 on some DVBS2 transponders like Hotbird 13E
11681-H-27500 or Hotbird 13E 12692-H-27500.
After reverting to the previous stb6100_set_frequency function, it's working
fine.
So, there is maybe in issue in the last December code refactoring.

Reference of the patch: "[media] stb6100: Improve tuner performance"
http://git.linuxtv.org/media_tree.git?a=history;f=drivers/media/dvb/frontend
s/stb6100.c;h=bc1a8af4f6e105181670ee33ebe111f98425e0ff;hb=HEAD

See below for the code removed from the stb6100.c file (the
stb6100_set_frequency function) and the code added (the previous
stb6100_set_frequency function and the stb6100_write_regs function).

Best regards,
Sebastien.

----- CODE ADDED -----

static int stb6100_write_regs(struct stb6100_state *state, u8 regs[])
{
	stb6100_normalise_regs(regs);
	return stb6100_write_reg_range(state, &regs[1], 1, STB6100_NUMREGS -
1);
}

static int stb6100_set_frequency(struct dvb_frontend *fe, u32 frequency)
{
	int rc;
	const struct stb6100_lkup *ptr;
	struct stb6100_state *state = fe->tuner_priv;
	struct dvb_frontend_parameters p;

	u32 srate = 0, fvco, nint, nfrac;
	u8 regs[STB6100_NUMREGS];
	u8 g, psd2, odiv;

	if ((rc = stb6100_read_regs(state, regs)) < 0)
		return rc;

	if (fe->ops.get_frontend) {
		dprintk(verbose, FE_DEBUG, 1, "Get frontend parameters");
		fe->ops.get_frontend(fe, &p);
	}
	srate = p.u.qpsk.symbol_rate;

	regs[STB6100_DLB] = 0xdc;
	/* Disable LPEN */
	regs[STB6100_LPEN] &= ~STB6100_LPEN_LPEN; /* PLL Loop disabled */

	if ((rc = stb6100_write_regs(state, regs)) < 0)
		return rc;

	/* Baseband gain.	*/
	if (srate >= 15000000)
		g = 9;  //  +4 dB
	else if (srate >= 5000000)
		g = 11; //  +8 dB
	else
		g = 14; // +14 dB

	regs[STB6100_G] = (regs[STB6100_G] & ~STB6100_G_G) | g;
	regs[STB6100_G] &= ~STB6100_G_GCT; /* mask GCT */
	regs[STB6100_G] |= (1 << 5); /* 2Vp-p Mode */

	/* VCO divide ratio (LO divide ratio, VCO prescaler enable).	*/
	if (frequency <= 1075000)
		odiv = 1;
	else
		odiv = 0;
	regs[STB6100_VCO] = (regs[STB6100_VCO] & ~STB6100_VCO_ODIV) | (odiv
<< STB6100_VCO_ODIV_SHIFT);

	if ((frequency > 1075000) && (frequency <= 1325000))
		psd2 = 0;
	else
		psd2 = 1;
	regs[STB6100_K] = (regs[STB6100_K] & ~STB6100_K_PSD2) | (psd2 <<
STB6100_K_PSD2_SHIFT);

	/* OSM	*/
	for (ptr = lkup;
	     (ptr->val_high != 0) && !CHKRANGE(frequency, ptr->val_low,
ptr->val_high);
	     ptr++);
	if (ptr->val_high == 0) {
		printk(KERN_ERR "%s: frequency out of range: %u kHz\n",
__func__, frequency);
		return -EINVAL;
	}
	regs[STB6100_VCO] = (regs[STB6100_VCO] & ~STB6100_VCO_OSM) |
ptr->reg;

	/* F(VCO) = F(LO) * (ODIV == 0 ? 2 : 4)			*/
	fvco = frequency << (1 + odiv);
	/* N(I) = floor(f(VCO) / (f(XTAL) * (PSD2 ? 2 : 1)))	*/
	nint = fvco / (state->reference << psd2);
	/* N(F) = round(f(VCO) / f(XTAL) * (PSD2 ? 2 : 1) - N(I)) * 2 ^ 9
*/
	nfrac = DIV_ROUND_CLOSEST((fvco - (nint * state->reference << psd2))
					 << (9 - psd2),
				  state->reference);
	dprintk(verbose, FE_DEBUG, 1,
		"frequency = %u, srate = %u, g = %u, odiv = %u, psd2 = %u,
fxtal = %u, osm = %u, fvco = %u, N(I) = %u, N(F) = %u",
		frequency, srate, (unsigned int)g, (unsigned int)odiv,
		(unsigned int)psd2, state->reference,
		ptr->reg, fvco, nint, nfrac);
	regs[STB6100_NI] = nint;
	regs[STB6100_NF_LSB] = nfrac;
	regs[STB6100_K] = (regs[STB6100_K] & ~STB6100_K_NF_MSB) | ((nfrac >>
8) & STB6100_K_NF_MSB);
	regs[STB6100_VCO] |= STB6100_VCO_OSCH;		/* VCO search
enabled		*/
	regs[STB6100_VCO] |= STB6100_VCO_OCK;		/* VCO search clock
off		*/
	regs[STB6100_FCCK] |= STB6100_FCCK_FCCK;	/* LPF BW setting
clock enabled	*/
	regs[STB6100_LPEN] &= ~STB6100_LPEN_LPEN;	/* PLL loop disabled
*/
	/* Power up. */
	regs[STB6100_LPEN] |= STB6100_LPEN_SYNP	| STB6100_LPEN_OSCP |
STB6100_LPEN_BEN;

	msleep(2);
	if ((rc = stb6100_write_regs(state, regs)) < 0)
		return rc;

	msleep(2);
	regs[STB6100_LPEN] |= STB6100_LPEN_LPEN;	/* PLL loop enabled
*/
	if ((rc = stb6100_write_reg(state, STB6100_LPEN,
regs[STB6100_LPEN])) < 0)
		return rc;

	regs[STB6100_VCO] &= ~STB6100_VCO_OCK;		/* VCO fast search
*/
	if ((rc = stb6100_write_reg(state, STB6100_VCO, regs[STB6100_VCO]))
< 0)
		return rc;

	msleep(10);					/* wait for LO to
lock		*/
	regs[STB6100_VCO] &= ~STB6100_VCO_OSCH;		/* vco search
disabled		*/
	regs[STB6100_VCO] |= STB6100_VCO_OCK;		/* search clock off
*/
	if ((rc = stb6100_write_reg(state, STB6100_VCO, regs[STB6100_VCO]))
< 0)
		return rc;
	regs[STB6100_FCCK] &= ~STB6100_FCCK_FCCK;       /* LPF BW clock
disabled	*/
	stb6100_normalise_regs(regs);
	if ((rc = stb6100_write_reg_range(state, &regs[1], 1,
STB6100_NUMREGS - 3)) < 0)
		return rc;

	msleep(100);

	return 0;
}

---- CODE REMOVED ----

static int stb6100_set_frequency(struct dvb_frontend *fe, u32 frequency)
{
	int rc;
	const struct stb6100_lkup *ptr;
	struct stb6100_state *state = fe->tuner_priv;
	struct dvb_frontend_parameters p;

	u32 srate = 0, fvco, nint, nfrac;
	u8 regs[STB6100_NUMREGS];
	u8 g, psd2, odiv;

	dprintk(verbose, FE_DEBUG, 1, "Version 2010-8-14 13:51");

	if (fe->ops.get_frontend) {
		dprintk(verbose, FE_DEBUG, 1, "Get frontend parameters");
		fe->ops.get_frontend(fe, &p);
	}
	srate = p.u.qpsk.symbol_rate;

	/* Set up tuner cleanly, LPF calibration on */
	rc = stb6100_write_reg(state, STB6100_FCCK, 0x4d |
STB6100_FCCK_FCCK);
	if (rc < 0)
		return rc;  /* allow LPF calibration */

	/* PLL Loop disabled, bias on, VCO on, synth on */
	regs[STB6100_LPEN] = 0xeb;
	rc = stb6100_write_reg(state, STB6100_LPEN, regs[STB6100_LPEN]);
	if (rc < 0)
		return rc;

	/* Program the registers with their data values */

	/* VCO divide ratio (LO divide ratio, VCO prescaler enable).	*/
	if (frequency <= 1075000)
		odiv = 1;
	else
		odiv = 0;

	/* VCO enabled, search clock off as per LL3.7, 3.4.1 */
	regs[STB6100_VCO] = 0xe0 | (odiv << STB6100_VCO_ODIV_SHIFT);

	/* OSM	*/
	for (ptr = lkup;
	     (ptr->val_high != 0) && !CHKRANGE(frequency, ptr->val_low,
ptr->val_high);
	     ptr++);

	if (ptr->val_high == 0) {
		printk(KERN_ERR "%s: frequency out of range: %u kHz\n",
__func__, frequency);
		return -EINVAL;
	}
	regs[STB6100_VCO] = (regs[STB6100_VCO] & ~STB6100_VCO_OSM) |
ptr->reg;
	rc = stb6100_write_reg(state, STB6100_VCO, regs[STB6100_VCO]);
	if (rc < 0)
		return rc;

	if ((frequency > 1075000) && (frequency <= 1325000))
		psd2 = 0;
	else
		psd2 = 1;
	/* F(VCO) = F(LO) * (ODIV == 0 ? 2 : 4)			*/
	fvco = frequency << (1 + odiv);
	/* N(I) = floor(f(VCO) / (f(XTAL) * (PSD2 ? 2 : 1)))	*/
	nint = fvco / (state->reference << psd2);
	/* N(F) = round(f(VCO) / f(XTAL) * (PSD2 ? 2 : 1) - N(I)) * 2 ^ 9
*/
	nfrac = DIV_ROUND_CLOSEST((fvco - (nint * state->reference << psd2))
					 << (9 - psd2), state->reference);

	/* NI */
	regs[STB6100_NI] = nint;
	rc = stb6100_write_reg(state, STB6100_NI, regs[STB6100_NI]);
	if (rc < 0)
		return rc;

	/* NF */
	regs[STB6100_NF_LSB] = nfrac;
	rc = stb6100_write_reg(state, STB6100_NF_LSB, regs[STB6100_NF_LSB]);
	if (rc < 0)
		return rc;

	/* K */
	regs[STB6100_K] = (0x38 & ~STB6100_K_PSD2) | (psd2 <<
STB6100_K_PSD2_SHIFT);
	regs[STB6100_K] = (regs[STB6100_K] & ~STB6100_K_NF_MSB) | ((nfrac >>
8) & STB6100_K_NF_MSB);
	rc = stb6100_write_reg(state, STB6100_K, regs[STB6100_K]);
	if (rc < 0)
		return rc;

	/* G Baseband gain. */
	if (srate >= 15000000)
		g = 9;  /*  +4 dB */
	else if (srate >= 5000000)
		g = 11; /*  +8 dB */
	else
		g = 14; /* +14 dB */

	regs[STB6100_G] = (0x10 & ~STB6100_G_G) | g;
	regs[STB6100_G] &= ~STB6100_G_GCT; /* mask GCT */
	regs[STB6100_G] |= (1 << 5); /* 2Vp-p Mode */
	rc = stb6100_write_reg(state, STB6100_G, regs[STB6100_G]);
	if (rc < 0)
		return rc;

	/* F we don't write as it is set up in BW set */

	/* DLB set DC servo loop BW to 160Hz (LLA 3.8 / 2.1) */
	regs[STB6100_DLB] = 0xcc;
	rc = stb6100_write_reg(state, STB6100_DLB, regs[STB6100_DLB]);
	if (rc < 0)
		return rc;

	dprintk(verbose, FE_DEBUG, 1,
		"frequency = %u, srate = %u, g = %u, odiv = %u, psd2 = %u,
fxtal = %u, osm = %u, fvco = %u, N(I) = %u, N(F) = %u",
		frequency, srate, (unsigned int)g, (unsigned int)odiv,
		(unsigned int)psd2, state->reference,
		ptr->reg, fvco, nint, nfrac);

	/* Set up the test registers */
	regs[STB6100_TEST1] = 0x8f;
	rc = stb6100_write_reg(state, STB6100_TEST1, regs[STB6100_TEST1]);
	if (rc < 0)
		return rc;
	regs[STB6100_TEST3] = 0xde;
	rc = stb6100_write_reg(state, STB6100_TEST3, regs[STB6100_TEST3]);
	if (rc < 0)
		return rc;

	/* Bring up tuner according to LLA 3.7 3.4.1, step 2 */
	regs[STB6100_LPEN] = 0xfb; /* PLL Loop enabled, bias on, VCO on,
synth on */
	rc = stb6100_write_reg(state, STB6100_LPEN, regs[STB6100_LPEN]);
	if (rc < 0)
		return rc;

	msleep(2);

	/* Bring up tuner according to LLA 3.7 3.4.1, step 3 */
	regs[STB6100_VCO] &= ~STB6100_VCO_OCK;		/* VCO fast search
*/
	rc = stb6100_write_reg(state, STB6100_VCO, regs[STB6100_VCO]);
	if (rc < 0)
		return rc;

	msleep(10);  /*  This is dangerous as another (related) thread may
start */ /* wait for LO to lock */

	regs[STB6100_VCO] &= ~STB6100_VCO_OSCH;		/* vco search
disabled		*/
	regs[STB6100_VCO] |= STB6100_VCO_OCK;		/* search clock off
*/
	rc = stb6100_write_reg(state, STB6100_VCO, regs[STB6100_VCO]);
	if (rc < 0)
		return rc;

	rc = stb6100_write_reg(state, STB6100_FCCK, 0x0d);
	if (rc < 0)
		return rc;  /* Stop LPF calibration */

	msleep(10);  /*  This is dangerous as another (related) thread may
start */
		     /* wait for stabilisation, (should not be necessary)
*/
	return 0;
}

-------- END ---------




