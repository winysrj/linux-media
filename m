Return-path: <linux-media-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:28217 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932561Ab2BNVsZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Feb 2012 16:48:25 -0500
From: linuxtv@stefanringel.de
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, Stefan Ringel <linuxtv@stefanringel.de>
Subject: [PATCH 05/22] mt2063: remove spurcheck
Date: Tue, 14 Feb 2012 22:47:29 +0100
Message-Id: <1329256066-8844-5-git-send-email-linuxtv@stefanringel.de>
In-Reply-To: <1329256066-8844-1-git-send-email-linuxtv@stefanringel.de>
References: <1329256066-8844-1-git-send-email-linuxtv@stefanringel.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Stefan Ringel <linuxtv@stefanringel.de>

Signed-off-by: Stefan Ringel <linuxtv@stefanringel.de>
---
 drivers/media/common/tuners/mt2063.c |  585 ----------------------------------
 1 files changed, 0 insertions(+), 585 deletions(-)

diff --git a/drivers/media/common/tuners/mt2063.c b/drivers/media/common/tuners/mt2063.c
index a79e4ef..ee59ebe 100644
--- a/drivers/media/common/tuners/mt2063.c
+++ b/drivers/media/common/tuners/mt2063.c
@@ -41,15 +41,6 @@ static LIST_HEAD(hybrid_tuner_instance_list);
  * 2 additional calculating, result etc.
  * 3 maximum debug information
 
-/* positive error codes used internally */
-
-/*  Info: Unavoidable LO-related spur may be present in the output  */
-#define MT2063_SPUR_PRESENT_ERR             (0x00800000)
-
-/*  Info: Mask of bits used for # of LO-related spurs that were avoided during tuning  */
-#define MT2063_SPUR_CNT_MASK                (0x001f0000)
-#define MT2063_SPUR_SHIFT                   (16)
-
 /*  Info: Upconverter frequency is out of range (may be reason for MT_UPC_UNLOCK) */
 #define MT2063_UPC_RANGE                    (0x04000000)
 
@@ -69,61 +60,6 @@ if (debug >= level)						\
 	printk(KERN_DEBUG "mt2063 %s: " fmt, __func__, ##arg);	\
 } while (0)
 
-/* DECT Frequency Avoidance */
-#define MT2063_DECT_AVOID_US_FREQS      0x00000001
-
-#define MT2063_DECT_AVOID_EURO_FREQS    0x00000002
-
-#define MT2063_EXCLUDE_US_DECT_FREQUENCIES(s) (((s) & MT2063_DECT_AVOID_US_FREQS) != 0)
-
-#define MT2063_EXCLUDE_EURO_DECT_FREQUENCIES(s) (((s) & MT2063_DECT_AVOID_EURO_FREQS) != 0)
-
-enum MT2063_DECT_Avoid_Type {
-	MT2063_NO_DECT_AVOIDANCE = 0,				/* Do not create DECT exclusion zones.     */
-	MT2063_AVOID_US_DECT = MT2063_DECT_AVOID_US_FREQS,	/* Avoid US DECT frequencies.              */
-	MT2063_AVOID_EURO_DECT = MT2063_DECT_AVOID_EURO_FREQS,	/* Avoid European DECT frequencies.        */
-	MT2063_AVOID_BOTH					/* Avoid both regions. Not typically used. */
-};
-
-#define MT2063_MAX_ZONES 48
-
-struct MT2063_ExclZone_t {
-	u32 min_;
-	u32 max_;
-	struct MT2063_ExclZone_t *next_;
-};
-
-/*
- *  Structure of data needed for Spur Avoidance
- */
-struct MT2063_AvoidSpursData_t {
-	u32 f_ref;
-	u32 f_in;
-	u32 f_LO1;
-	u32 f_if1_Center;
-	u32 f_if1_Request;
-	u32 f_if1_bw;
-	u32 f_LO2;
-	u32 f_out;
-	u32 f_out_bw;
-	u32 f_LO1_Step;
-	u32 f_LO2_Step;
-	u32 f_LO1_FracN_Avoid;
-	u32 f_LO2_FracN_Avoid;
-	u32 f_zif_bw;
-	u32 f_min_LO_Separation;
-	u32 maxH1;
-	u32 maxH2;
-	enum MT2063_DECT_Avoid_Type avoidDECT;
-	u32 bSpurPresent;
-	u32 bSpurAvoided;
-	u32 nSpursFound;
-	u32 nZones;
-	struct MT2063_ExclZone_t *freeZones;
-	struct MT2063_ExclZone_t *usedZones;
-	struct MT2063_ExclZone_t MT2063_ExclZones[MT2063_MAX_ZONES];
-};
-
 /*
  * Parameter for function MT2063_SetPowerMask that specifies the power down
  * of various sections of the MT2063.
@@ -375,351 +311,20 @@ static int MT2063_Sleep(struct dvb_frontend *fe)
 
 
 
-/*
- * MT_ChooseFirstIF - Choose the best available 1st IF
- *                    If f_Desired is not excluded, choose that first.
- *                    Otherwise, return the value closest to f_Center that is
- *                    not excluded
- */
-static u32 MT2063_ChooseFirstIF(struct MT2063_AvoidSpursData_t *pAS_Info)
-{
-	/*
-	 * Update "f_Desired" to be the nearest "combinational-multiple" of
-	 * "f_LO1_Step".
-	 * The resulting number, F_LO1 must be a multiple of f_LO1_Step.
-	 * And F_LO1 is the arithmetic sum of f_in + f_Center.
-	 * Neither f_in, nor f_Center must be a multiple of f_LO1_Step.
-	 * However, the sum must be.
-	 */
-	const u32 f_Desired =
-	    pAS_Info->f_LO1_Step *
-	    ((pAS_Info->f_if1_Request + pAS_Info->f_in +
-	      pAS_Info->f_LO1_Step / 2) / pAS_Info->f_LO1_Step) -
-	    pAS_Info->f_in;
-	const u32 f_Step =
-	    (pAS_Info->f_LO1_Step >
-	     pAS_Info->f_LO2_Step) ? pAS_Info->f_LO1_Step : pAS_Info->
-	    f_LO2_Step;
-	u32 f_Center;
-	s32 i;
-	s32 j = 0;
-	u32 bDesiredExcluded = 0;
-	u32 bZeroExcluded = 0;
-	s32 tmpMin, tmpMax;
-	s32 bestDiff;
-	struct MT2063_ExclZone_t *pNode = pAS_Info->usedZones;
-	struct MT2063_FIFZone_t zones[MT2063_MAX_ZONES];
-
-	dprintk(2, "\n");
-
-	if (pAS_Info->nZones == 0)
-		return f_Desired;
 
-	/*
-	 *  f_Center needs to be an integer multiple of f_Step away
-	 *  from f_Desired
-	 */
-	if (pAS_Info->f_if1_Center > f_Desired)
-		f_Center =
-		    f_Desired +
-		    f_Step *
-		    ((pAS_Info->f_if1_Center - f_Desired +
-		      f_Step / 2) / f_Step);
 	else
-		f_Center =
-		    f_Desired -
-		    f_Step *
-		    ((f_Desired - pAS_Info->f_if1_Center +
-		      f_Step / 2) / f_Step);
-
-	/*
-	 * Take MT_ExclZones, center around f_Center and change the
-	 * resolution to f_Step
-	 */
-	while (pNode != NULL) {
-		/*  floor function  */
-		tmpMin =
-		    floor((s32) (pNode->min_ - f_Center), (s32) f_Step);
-
-		/*  ceil function  */
-		tmpMax =
-		    ceil((s32) (pNode->max_ - f_Center), (s32) f_Step);
-
-		if ((pNode->min_ < f_Desired) && (pNode->max_ > f_Desired))
-			bDesiredExcluded = 1;
-
-		if ((tmpMin < 0) && (tmpMax > 0))
-			bZeroExcluded = 1;
-
-		/*  See if this zone overlaps the previous  */
-		if ((j > 0) && (tmpMin < zones[j - 1].max_))
-			zones[j - 1].max_ = tmpMax;
-		else {
-			/*  Add new zone  */
-			zones[j].min_ = tmpMin;
-			zones[j].max_ = tmpMax;
-			j++;
-		}
-		pNode = pNode->next_;
-	}
 
-	/*
-	 *  If the desired is okay, return with it
-	 */
-	if (bDesiredExcluded == 0)
-		return f_Desired;
-
-	/*
-	 *  If the desired is excluded and the center is okay, return with it
-	 */
-	if (bZeroExcluded == 0)
-		return f_Center;
-
-	/*  Find the value closest to 0 (f_Center)  */
-	bestDiff = zones[0].min_;
-	for (i = 0; i < j; i++) {
-		if (abs(zones[i].min_) < abs(bestDiff))
-			bestDiff = zones[i].min_;
-		if (abs(zones[i].max_) < abs(bestDiff))
-			bestDiff = zones[i].max_;
-	}
-
-	if (bestDiff < 0)
-		return f_Center - ((u32) (-bestDiff) * f_Step);
-
-	return f_Center + (bestDiff * f_Step);
-}
-
-/**
- * gcd() - Uses Euclid's algorithm
- *
- * @u, @v:	Unsigned values whose GCD is desired.
- *
- * Returns THE greatest common divisor of u and v, if either value is 0,
- * the other value is returned as the result.
- */
-static u32 MT2063_gcd(u32 u, u32 v)
-{
-	u32 r;
-
-	while (v != 0) {
-		r = u % v;
-		u = v;
-		v = r;
-	}
-
-	return u;
-}
-
-/**
- * IsSpurInBand() - Checks to see if a spur will be present within the IF's
- *                  bandwidth. (fIFOut +/- fIFBW, -fIFOut +/- fIFBW)
- *
- *                    ma   mb                                     mc   md
- *                  <--+-+-+-------------------+-------------------+-+-+-->
- *                     |   ^                   0                   ^   |
- *                     ^   b=-fIFOut+fIFBW/2      -b=+fIFOut-fIFBW/2   ^
- *                     a=-fIFOut-fIFBW/2              -a=+fIFOut+fIFBW/2
- *
- *                  Note that some equations are doubled to prevent round-off
- *                  problems when calculating fIFBW/2
- *
- * @pAS_Info:	Avoid Spurs information block
- * @fm:		If spur, amount f_IF1 has to move negative
- * @fp:		If spur, amount f_IF1 has to move positive
- *
- *  Returns 1 if an LO spur would be present, otherwise 0.
- */
-static u32 IsSpurInBand(struct MT2063_AvoidSpursData_t *pAS_Info,
-			u32 *fm, u32 * fp)
-{
-	/*
-	 **  Calculate LO frequency settings.
-	 */
-	u32 n, n0;
-	const u32 f_LO1 = pAS_Info->f_LO1;
-	const u32 f_LO2 = pAS_Info->f_LO2;
-	const u32 d = pAS_Info->f_out + pAS_Info->f_out_bw / 2;
-	const u32 c = d - pAS_Info->f_out_bw;
-	const u32 f = pAS_Info->f_zif_bw / 2;
-	const u32 f_Scale = (f_LO1 / (UINT_MAX / 2 / pAS_Info->maxH1)) + 1;
-	s32 f_nsLO1, f_nsLO2;
-	s32 f_Spur;
-	u32 ma, mb, mc, md, me, mf;
-	u32 lo_gcd, gd_Scale, gc_Scale, gf_Scale, hgds, hgfs, hgcs;
-
-	dprintk(2, "\n");
-
-	*fm = 0;
-
-	/*
-	 ** For each edge (d, c & f), calculate a scale, based on the gcd
-	 ** of f_LO1, f_LO2 and the edge value.  Use the larger of this
-	 ** gcd-based scale factor or f_Scale.
-	 */
-	lo_gcd = MT2063_gcd(f_LO1, f_LO2);
-	gd_Scale = max((u32) MT2063_gcd(lo_gcd, d), f_Scale);
-	hgds = gd_Scale / 2;
-	gc_Scale = max((u32) MT2063_gcd(lo_gcd, c), f_Scale);
-	hgcs = gc_Scale / 2;
-	gf_Scale = max((u32) MT2063_gcd(lo_gcd, f), f_Scale);
-	hgfs = gf_Scale / 2;
-
-	n0 = DIV_ROUND_UP(f_LO2 - d, f_LO1 - f_LO2);
-
-	/*  Check out all multiples of LO1 from n0 to m_maxLOSpurHarmonic  */
-	for (n = n0; n <= pAS_Info->maxH1; ++n) {
-		md = (n * ((f_LO1 + hgds) / gd_Scale) -
-		      ((d + hgds) / gd_Scale)) / ((f_LO2 + hgds) / gd_Scale);
-
-		/*  If # fLO2 harmonics > m_maxLOSpurHarmonic, then no spurs present  */
-		if (md >= pAS_Info->maxH1)
-			break;
-
-		ma = (n * ((f_LO1 + hgds) / gd_Scale) +
-		      ((d + hgds) / gd_Scale)) / ((f_LO2 + hgds) / gd_Scale);
-
-		/*  If no spurs between +/- (f_out + f_IFBW/2), then try next harmonic  */
-		if (md == ma)
-			continue;
-
-		mc = (n * ((f_LO1 + hgcs) / gc_Scale) -
-		      ((c + hgcs) / gc_Scale)) / ((f_LO2 + hgcs) / gc_Scale);
-		if (mc != md) {
-			f_nsLO1 = (s32) (n * (f_LO1 / gc_Scale));
-			f_nsLO2 = (s32) (mc * (f_LO2 / gc_Scale));
-			f_Spur =
-			    (gc_Scale * (f_nsLO1 - f_nsLO2)) +
-			    n * (f_LO1 % gc_Scale) - mc * (f_LO2 % gc_Scale);
-
-			*fp = ((f_Spur - (s32) c) / (mc - n)) + 1;
-			*fm = (((s32) d - f_Spur) / (mc - n)) + 1;
-			return 1;
-		}
-
-		/*  Location of Zero-IF-spur to be checked  */
-		me = (n * ((f_LO1 + hgfs) / gf_Scale) +
-		      ((f + hgfs) / gf_Scale)) / ((f_LO2 + hgfs) / gf_Scale);
-		mf = (n * ((f_LO1 + hgfs) / gf_Scale) -
-		      ((f + hgfs) / gf_Scale)) / ((f_LO2 + hgfs) / gf_Scale);
-		if (me != mf) {
-			f_nsLO1 = n * (f_LO1 / gf_Scale);
-			f_nsLO2 = me * (f_LO2 / gf_Scale);
-			f_Spur =
-			    (gf_Scale * (f_nsLO1 - f_nsLO2)) +
-			    n * (f_LO1 % gf_Scale) - me * (f_LO2 % gf_Scale);
-
-			*fp = ((f_Spur + (s32) f) / (me - n)) + 1;
-			*fm = (((s32) f - f_Spur) / (me - n)) + 1;
-			return 1;
-		}
-
-		mb = (n * ((f_LO1 + hgcs) / gc_Scale) +
-		      ((c + hgcs) / gc_Scale)) / ((f_LO2 + hgcs) / gc_Scale);
-		if (ma != mb) {
-			f_nsLO1 = n * (f_LO1 / gc_Scale);
-			f_nsLO2 = ma * (f_LO2 / gc_Scale);
-			f_Spur =
-			    (gc_Scale * (f_nsLO1 - f_nsLO2)) +
-			    n * (f_LO1 % gc_Scale) - ma * (f_LO2 % gc_Scale);
-
-			*fp = (((s32) d + f_Spur) / (ma - n)) + 1;
-			*fm = (-(f_Spur + (s32) c) / (ma - n)) + 1;
-			return 1;
-		}
-	}
 
-	/*  No spurs found  */
 	return 0;
 }
 
-/*
- * MT_AvoidSpurs() - Main entry point to avoid spurs.
- *                   Checks for existing spurs in present LO1, LO2 freqs
- *                   and if present, chooses spur-free LO1, LO2 combination
- *                   that tunes the same input/output frequencies.
- */
-static u32 MT2063_AvoidSpurs(struct MT2063_AvoidSpursData_t *pAS_Info)
-{
-	u32 status = 0;
-	u32 fm, fp;		/*  restricted range on LO's        */
-	pAS_Info->bSpurAvoided = 0;
-	pAS_Info->nSpursFound = 0;
 
-	dprintk(2, "\n");
 
-	if (pAS_Info->maxH1 == 0)
-		return 0;
 
 	/*
-	 * Avoid LO Generated Spurs
 	 *
-	 * Make sure that have no LO-related spurs within the IF output
-	 * bandwidth.
 	 *
-	 * If there is an LO spur in this band, start at the current IF1 frequency
-	 * and work out until we find a spur-free frequency or run up against the
-	 * 1st IF SAW band edge.  Use temporary copies of fLO1 and fLO2 so that they
-	 * will be unchanged if a spur-free setting is not found.
 	 */
-	pAS_Info->bSpurPresent = IsSpurInBand(pAS_Info, &fm, &fp);
-	if (pAS_Info->bSpurPresent) {
-		u32 zfIF1 = pAS_Info->f_LO1 - pAS_Info->f_in;	/*  current attempt at a 1st IF  */
-		u32 zfLO1 = pAS_Info->f_LO1;	/*  current attempt at an LO1 freq  */
-		u32 zfLO2 = pAS_Info->f_LO2;	/*  current attempt at an LO2 freq  */
-		u32 delta_IF1;
-		u32 new_IF1;
-
-		/*
-		 **  Spur was found, attempt to find a spur-free 1st IF
-		 */
-		do {
-			pAS_Info->nSpursFound++;
-
-
-			/*  Choose next IF1 that is closest to f_IF1_CENTER              */
-			new_IF1 = MT2063_ChooseFirstIF(pAS_Info);
-
-			if (new_IF1 > zfIF1) {
-				pAS_Info->f_LO1 += (new_IF1 - zfIF1);
-				pAS_Info->f_LO2 += (new_IF1 - zfIF1);
-			} else {
-				pAS_Info->f_LO1 -= (zfIF1 - new_IF1);
-				pAS_Info->f_LO2 -= (zfIF1 - new_IF1);
-			}
-			zfIF1 = new_IF1;
-
-			if (zfIF1 > pAS_Info->f_if1_Center)
-				delta_IF1 = zfIF1 - pAS_Info->f_if1_Center;
-			else
-				delta_IF1 = pAS_Info->f_if1_Center - zfIF1;
-
-			pAS_Info->bSpurPresent = IsSpurInBand(pAS_Info, &fm, &fp);
-		/*
-		 *  Continue while the new 1st IF is still within the 1st IF bandwidth
-		 *  and there is a spur in the band (again)
-		 */
-		} while ((2 * delta_IF1 + pAS_Info->f_out_bw <= pAS_Info->f_if1_bw) && pAS_Info->bSpurPresent);
-
-		/*
-		 * Use the LO-spur free values found.  If the search went all
-		 * the way to the 1st IF band edge and always found spurs, just
-		 * leave the original choice.  It's as "good" as any other.
-		 */
-		if (pAS_Info->bSpurPresent == 1) {
-			status |= MT2063_SPUR_PRESENT_ERR;
-			pAS_Info->f_LO1 = zfLO1;
-			pAS_Info->f_LO2 = zfLO2;
-		} else
-			pAS_Info->bSpurAvoided = 1;
-	}
-
-	status |=
-	    ((pAS_Info->
-	      nSpursFound << MT2063_SPUR_SHIFT) & MT2063_SPUR_CNT_MASK);
-
-	return status;
-}
 
 /*
  * Constants used by the tuning algorithm
@@ -1229,133 +834,13 @@ static u32 MT2063_SoftwareShutdown(struct mt2063_state *state, u8 Shutdown)
 	return status;
 }
 
-static u32 MT2063_Round_fLO(u32 f_LO, u32 f_LO_Step, u32 f_ref)
-{
-	return f_ref * (f_LO / f_ref)
-	    + f_LO_Step * (((f_LO % f_ref) + (f_LO_Step / 2)) / f_LO_Step);
-}
 
-/**
- * fLO_FractionalTerm() - Calculates the portion contributed by FracN / denom.
- *                        This function preserves maximum precision without
- *                        risk of overflow.  It accurately calculates
- *                        f_ref * num / denom to within 1 HZ with fixed math.
- *
- * @num :	Fractional portion of the multiplier
- * @denom:	denominator portion of the ratio
- * @f_Ref:	SRO frequency.
- *
- * This calculation handles f_ref as two separate 14-bit fields.
- * Therefore, a maximum value of 2^28-1 may safely be used for f_ref.
- * This is the genesis of the magic number "14" and the magic mask value of
- * 0x03FFF.
- *
- * This routine successfully handles denom values up to and including 2^18.
- *  Returns:        f_ref * num / denom
- */
-static u32 MT2063_fLO_FractionalTerm(u32 f_ref, u32 num, u32 denom)
-{
-	u32 t1 = (f_ref >> 14) * num;
-	u32 term1 = t1 / denom;
-	u32 loss = t1 % denom;
-	u32 term2 =
-	    (((f_ref & 0x00003FFF) * num + (loss << 14)) + (denom / 2)) / denom;
-	return (term1 << 14) + term2;
-}
 
-/*
- * CalcLO1Mult()- Calculates Integer divider value and the numerator
- *                value for a FracN PLL.
- *
- *                This function assumes that the f_LO and f_Ref are
- *                evenly divisible by f_LO_Step.
- *
- * @Div:	OUTPUT: Whole number portion of the multiplier
- * @FracN:	OUTPUT: Fractional portion of the multiplier
- * @f_LO:	desired LO frequency.
- * @f_LO_Step:	Minimum step size for the LO (in Hz).
- * @f_Ref:	SRO frequency.
- * @f_Avoid:	Range of PLL frequencies to avoid near integer multiples
- *		of f_Ref (in Hz).
- *
- * Returns:        Recalculated LO frequency.
- */
-static u32 MT2063_CalcLO1Mult(u32 *Div,
-			      u32 *FracN,
-			      u32 f_LO,
-			      u32 f_LO_Step, u32 f_Ref)
-{
-	/*  Calculate the whole number portion of the divider */
-	*Div = f_LO / f_Ref;
-
-	/*  Calculate the numerator value (round to nearest f_LO_Step) */
-	*FracN =
-	    (64 * (((f_LO % f_Ref) + (f_LO_Step / 2)) / f_LO_Step) +
-	     (f_Ref / f_LO_Step / 2)) / (f_Ref / f_LO_Step);
-
-	return (f_Ref * (*Div)) + MT2063_fLO_FractionalTerm(f_Ref, *FracN, 64);
-}
-
-/**
- * CalcLO2Mult() - Calculates Integer divider value and the numerator
- *                 value for a FracN PLL.
- *
- *                  This function assumes that the f_LO and f_Ref are
- *                  evenly divisible by f_LO_Step.
- *
- * @Div:	OUTPUT: Whole number portion of the multiplier
- * @FracN:	OUTPUT: Fractional portion of the multiplier
- * @f_LO:	desired LO frequency.
- * @f_LO_Step:	Minimum step size for the LO (in Hz).
- * @f_Ref:	SRO frequency.
- * @f_Avoid:	Range of PLL frequencies to avoid near
- *		integer multiples of f_Ref (in Hz).
- *
- * Returns: Recalculated LO frequency.
- */
-static u32 MT2063_CalcLO2Mult(u32 *Div,
-			      u32 *FracN,
-			      u32 f_LO,
-			      u32 f_LO_Step, u32 f_Ref)
-{
-	/*  Calculate the whole number portion of the divider */
-	*Div = f_LO / f_Ref;
-
-	/*  Calculate the numerator value (round to nearest f_LO_Step) */
-	*FracN =
-	    (8191 * (((f_LO % f_Ref) + (f_LO_Step / 2)) / f_LO_Step) +
-	     (f_Ref / f_LO_Step / 2)) / (f_Ref / f_LO_Step);
 
-	return (f_Ref * (*Div)) + MT2063_fLO_FractionalTerm(f_Ref, *FracN,
-							    8191);
 }
 
-/*
- * FindClearTuneFilter() - Calculate the corrrect ClearTune filter to be
- *			   used for a given input frequency.
- *
- * @state:	ptr to tuner data structure
- * @f_in:	RF input center frequency (in Hz).
- *
- * Returns: ClearTune filter number (0-31)
- */
-static u32 FindClearTuneFilter(struct mt2063_state *state, u32 f_in)
 {
-	u32 RFBand;
-	u32 idx;		/*  index loop                      */
 
-	/*
-	 **  Find RF Band setting
-	 */
-	RFBand = 31;		/*  def when f_in > all    */
-	for (idx = 0; idx < 31; ++idx) {
-		if (state->CTFiltMax[idx] >= f_in) {
-			RFBand = idx;
-			break;
-		}
-	}
-	return RFBand;
-}
 
 /*
  * MT2063_Tune() - Change the tuner's tuned frequency to RFin.
@@ -1402,7 +887,6 @@ static u32 MT2063_Tune(struct mt2063_state *state, u32 f_in)
 			    mt2063_setreg(state, MT2063_REG_CTUNE_CTRL, val);
 		}
 		val = state->reg[MT2063_REG_CTUNE_OV];
-		RFBand = FindClearTuneFilter(state, f_in);
 		state->reg[MT2063_REG_CTUNE_OV] =
 		    (u8) ((state->reg[MT2063_REG_CTUNE_OV] & ~0x1F)
 			      | RFBand);
@@ -1426,43 +910,6 @@ static u32 MT2063_Tune(struct mt2063_state *state, u32 f_in)
 	 * Assign in the requested values
 	 */
 	state->AS_Data.f_in = f_in;
-	/*  Request a 1st IF such that LO1 is on a step size */
-	state->AS_Data.f_if1_Request =
-	    MT2063_Round_fLO(state->AS_Data.f_if1_Request + f_in,
-			     state->AS_Data.f_LO1_Step,
-			     state->AS_Data.f_ref) - f_in;
-
-
-	f_IF1 = MT2063_ChooseFirstIF(&state->AS_Data);
-
-	state->AS_Data.f_LO1 =
-	    MT2063_Round_fLO(f_IF1 + f_in, state->AS_Data.f_LO1_Step,
-			     state->AS_Data.f_ref);
-
-	state->AS_Data.f_LO2 =
-	    MT2063_Round_fLO(state->AS_Data.f_LO1 - state->AS_Data.f_out - f_in,
-			     state->AS_Data.f_LO2_Step, state->AS_Data.f_ref);
-
-	/*
-	 * Check for any LO spurs in the output bandwidth and adjust
-	 * the LO settings to avoid them if needed
-	 */
-	status |= MT2063_AvoidSpurs(&state->AS_Data);
-	/*
-	 * MT_AvoidSpurs spurs may have changed the LO1 & LO2 values.
-	 * Recalculate the LO frequencies and the values to be placed
-	 * in the tuning registers.
-	 */
-	state->AS_Data.f_LO1 =
-	    MT2063_CalcLO1Mult(&LO1, &Num1, state->AS_Data.f_LO1,
-			       state->AS_Data.f_LO1_Step, state->AS_Data.f_ref);
-	state->AS_Data.f_LO2 =
-	    MT2063_Round_fLO(state->AS_Data.f_LO1 - state->AS_Data.f_out - f_in,
-			     state->AS_Data.f_LO2_Step, state->AS_Data.f_ref);
-	state->AS_Data.f_LO2 =
-	    MT2063_CalcLO2Mult(&LO2, &Num2, state->AS_Data.f_LO2,
-			       state->AS_Data.f_LO2_Step, state->AS_Data.f_ref);
-
 	/*
 	 *  Check the upconverter and downconverter frequency ranges
 	 */
@@ -1763,38 +1210,6 @@ static int mt2063_init(struct dvb_frontend *fe)
 	state->AS_Data.avoidDECT = MT2063_AVOID_BOTH;
 	state->ctfilt_sw = 0;
 
-	state->CTFiltMax[0] = 69230000;
-	state->CTFiltMax[1] = 105770000;
-	state->CTFiltMax[2] = 140350000;
-	state->CTFiltMax[3] = 177110000;
-	state->CTFiltMax[4] = 212860000;
-	state->CTFiltMax[5] = 241130000;
-	state->CTFiltMax[6] = 274370000;
-	state->CTFiltMax[7] = 309820000;
-	state->CTFiltMax[8] = 342450000;
-	state->CTFiltMax[9] = 378870000;
-	state->CTFiltMax[10] = 416210000;
-	state->CTFiltMax[11] = 456500000;
-	state->CTFiltMax[12] = 495790000;
-	state->CTFiltMax[13] = 534530000;
-	state->CTFiltMax[14] = 572610000;
-	state->CTFiltMax[15] = 598970000;
-	state->CTFiltMax[16] = 635910000;
-	state->CTFiltMax[17] = 672130000;
-	state->CTFiltMax[18] = 714840000;
-	state->CTFiltMax[19] = 739660000;
-	state->CTFiltMax[20] = 770410000;
-	state->CTFiltMax[21] = 814660000;
-	state->CTFiltMax[22] = 846950000;
-	state->CTFiltMax[23] = 867820000;
-	state->CTFiltMax[24] = 915980000;
-	state->CTFiltMax[25] = 947450000;
-	state->CTFiltMax[26] = 983110000;
-	state->CTFiltMax[27] = 1021630000;
-	state->CTFiltMax[28] = 1061870000;
-	state->CTFiltMax[29] = 1098330000;
-	state->CTFiltMax[30] = 1138990000;
-
 	/*
 	 **   Fetch the FCU osc value and use it and the fRef value to
 	 **   scale all of the Band Max values
-- 
1.7.7.6

