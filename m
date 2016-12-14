Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43407 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755567AbcLNNSq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Dec 2016 08:18:46 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: linux-media@vger.kernel.org
Cc: Gregor Jasny <gjasny@googlemail.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [v4l-utils PATCH 2/3] dvb-sat: change the LNBf logic to make it more generic
Date: Wed, 14 Dec 2016 11:18:34 -0200
Message-Id: <20161214131835.11259-3-mchehab@s-opensource.com>
In-Reply-To: <20161214131835.11259-2-mchehab@s-opensource.com>
References: <20161214131835.11259-1-mchehab@s-opensource.com>
 <20161214131835.11259-2-mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are some new LNBf models with more than two frequency
ranges. Change the logic there to allow adding those new
LNBf types.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 lib/include/libdvbv5/dvb-sat.h |  14 +++
 lib/libdvbv5/dvb-fe.c          |   5 +-
 lib/libdvbv5/dvb-sat.c         | 213 +++++++++++++++++++++++------------------
 3 files changed, 137 insertions(+), 95 deletions(-)

diff --git a/lib/include/libdvbv5/dvb-sat.h b/lib/include/libdvbv5/dvb-sat.h
index 7f83369fce39..424c4f454c03 100644
--- a/lib/include/libdvbv5/dvb-sat.h
+++ b/lib/include/libdvbv5/dvb-sat.h
@@ -132,6 +132,20 @@ const char *dvb_sat_get_lnb_name(int index);
  */
 int dvb_sat_set_parms(struct dvb_v5_fe_parms *parms);
 
+/**
+ * @brief return the real satellite frequency
+ * @ingroup satellite
+ *
+ * @param parms	struct dvb_v5_fe_parms pointer.
+ *
+ * This function is called internally by the library to get the satellite
+ * frequency, considering the LO frequency.
+ *
+ * @return frequency.
+ */
+int dvb_sat_real_freq(struct dvb_v5_fe_parms *p, int freq);
+
+
 #ifdef __cplusplus
 }
 #endif
diff --git a/lib/libdvbv5/dvb-fe.c b/lib/libdvbv5/dvb-fe.c
index b0b8f5956d32..1e29c9f0186f 100644
--- a/lib/libdvbv5/dvb-fe.c
+++ b/lib/libdvbv5/dvb-fe.c
@@ -705,9 +705,8 @@ int __dvb_fe_get_parms(struct dvb_v5_fe_parms *p)
 
 		/* copy back params from temporary fe_prop */
 		for (i = 0; i < n; i++) {
-			if (dvb_fe_is_satellite(p->current_sys)
-			    && fe_prop[i].cmd == DTV_FREQUENCY)
-				fe_prop[i].u.data += parms->freq_offset;
+			if (fe_prop[i].cmd == DTV_FREQUENCY)
+				fe_prop[i].u.data = dvb_sat_real_freq(p, fe_prop[i].u.data);
 			dvb_fe_store_parm(&parms->p, fe_prop[i].cmd, fe_prop[i].u.data);
 		}
 
diff --git a/lib/libdvbv5/dvb-sat.c b/lib/libdvbv5/dvb-sat.c
index 254a1e2c7df7..bde0cfa3accb 100644
--- a/lib/libdvbv5/dvb-sat.c
+++ b/lib/libdvbv5/dvb-sat.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2011-2012 - Mauro Carvalho Chehab
+ * Copyright (c) 2011-2016 - Mauro Carvalho Chehab
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU Lesser General Public License as published by
@@ -39,19 +39,15 @@
 # define N_(string) string
 
 struct dvbsat_freqrange {
-	unsigned low, high;
+	unsigned low, high, int_freq, rangeswitch;
+	enum dvb_sat_polarization pol;
 };
 
 struct dvb_sat_lnb_priv {
 	struct dvb_sat_lnb desc;
 
 	/* Private members used internally */
-
-	unsigned lowfreq, highfreq;
-
-	unsigned rangeswitch;
-
-	struct dvbsat_freqrange freqrange[2];
+	struct dvbsat_freqrange freqrange[4];
 };
 
 static const struct dvb_sat_lnb_priv lnb[] = {
@@ -60,107 +56,92 @@ static const struct dvb_sat_lnb_priv lnb[] = {
 			.name = N_("Universal, Europe"),
 			.alias = "UNIVERSAL",
 		},
-		.lowfreq = 9750,
-		.highfreq = 10600,
-		.rangeswitch = 11700,
 		.freqrange = {
-			{ 10800, 11800 },
-			{ 11600, 12700 },
+			{ 10800, 11800, 9750, 11700 },
+			{ 11600, 12700, 10600, 0 },
 		}
 	}, {
 		.desc = {
 			.name = N_("Expressvu, North America"),
 			.alias = "DBS",
 		},
-		.lowfreq = 11250,
 		.freqrange = {
-			{ 12200, 12700 }
+			{ 12200, 12700, 11250 }
 		}
 	}, {
 		.desc = {
 			.name = N_("Astra 1E, European Universal Ku (extended)"),
 			.alias = "EXTENDED",
 		},
-		.lowfreq = 9750,
-		.highfreq = 10600,
-		.rangeswitch = 11700,
 		.freqrange = {
-			{ 10700, 11700 },
-			{ 11700, 12750 },
+			{ 10700, 11700, 9750, 11700},
+			{ 11700, 12750, 10600, 0 },
 		}
 	}, {
 		.desc = {
 			.name = N_("Standard"),
 			.alias = "STANDARD",
 		},
-		.lowfreq = 10000,
 		.freqrange = {
-			{ 10945, 11450 }
+			{ 10945, 11450, 10000, 0 }
 		},
 	}, {
 		.desc = {
 			.name = N_("L10700"),
 			.alias = "L10700",
 		},
-		.lowfreq = 10700,
 		.freqrange = {
-		       { 11750, 12750 }
+		       { 11750, 12750, 10700, 0 }
 		},
 	}, {
 		.desc = {
 			.name = N_("L11300"),
 			.alias = "L11300",
 		},
-		.lowfreq = 11300,
 		.freqrange = {
-			{ 12250, 12750 }
+			{ 12250, 12750, 11300, 0 }
 		},
 	}, {
 		.desc = {
 			.name = N_("Astra"),
 			.alias = "ENHANCED",
 		},
-		.lowfreq = 9750,
 		.freqrange = {
-			{ 10700, 11700 }
+			{ 10700, 11700, 9750, 0 }
 		},
 	}, {
 		.desc = {
 			.name = N_("Big Dish - Monopoint LNBf"),
 			.alias = "C-BAND",
 		},
-		.lowfreq = 5150,
 		.freqrange = {
-			{ 3700, 4200 }
+			{ 3700, 4200, 5150, 0 }
 		},
 	}, {
 		.desc = {
 			.name = N_("Big Dish - Multipoint LNBf"),
 			.alias = "C-MULT",
 		},
-		.lowfreq = 5150,
-		.highfreq = 5750,
 		.freqrange = {
-			{ 3700, 4200 }
+			{ 3700, 4200, 5150, 0, POLARIZATION_R },
+			{ 3700, 4200, 5750, 0, POLARIZATION_L }
 		},
 	}, {
 		.desc = {
 			.name = N_("DishPro LNBf"),
 			.alias = "DISHPRO",
 		},
-		.lowfreq = 11250,
-		.highfreq = 14350,
 		.freqrange = {
-			{ 12200, 12700 }
+			{ 12200, 12700, 11250, 0, POLARIZATION_V },
+			{ 12200, 12700, 14350, 0, POLARIZATION_H }
 		}
 	}, {
 		.desc = {
 			.name = N_("Japan 110BS/CS LNBf"),
 			.alias = "110BS",
 		},
-		.lowfreq = 10678,
 		.freqrange = {
-			{ 11710, 12751 }
+			{ 11710, 12751, 10678, 0 }
 		}
 	},
 };
@@ -176,29 +157,31 @@ int dvb_sat_search_lnb(const char *name)
 	return -1;
 }
 
+static char *pol_name[] = {
+	[POLARIZATION_OFF] = "",
+	[POLARIZATION_H] = N_("Horizontal: "),
+	[POLARIZATION_V] = N_("Vertical  : "),
+	[POLARIZATION_L] = N_("Left      : "),
+	[POLARIZATION_R] = N_("Right     : "),
+};
+
 int dvb_print_lnb(int i)
 {
+	int j;
+
 	if (i < 0 || i >= ARRAY_SIZE(lnb))
 		return -1;
 
-	printf("%s\n\t%s\n", lnb[i].desc.alias, dvb_sat_get_lnb_name(i));
-	printf(_("\t%d to %d MHz"),
-	       lnb[i].freqrange[0].low, lnb[i].freqrange[0].high);
-	if (lnb[i].freqrange[1].low)
-		printf(_(" and %d to %d MHz"),
-		       lnb[i].freqrange[1].low, lnb[i].freqrange[1].high);
-	printf("\n\t%s LO, ", lnb[i].highfreq ? _("Dual") : _("Single"));
-	if (!lnb[i].highfreq) {
-		printf("IF = %d MHz\n", lnb[i].lowfreq);
-		return 0;
-	}
-	if (!lnb[i].rangeswitch) {
-		printf(_("Bandstacking, LO POL_R %d MHZ, LO POL_L %d MHz\n"),
-		       lnb[i].lowfreq, lnb[i].highfreq);
-		return 0;
+	printf("%s\n\t%s%s\n", lnb[i].desc.alias, dvb_sat_get_lnb_name(i),
+	       lnb[i].freqrange[0].pol ? _(" (bandstacking)") : "");
+
+	for (j = 0; j < ARRAY_SIZE(lnb[i].freqrange) && lnb[i].freqrange[j].low; j++) {
+		printf(_("\t%s%d to %d MHz, LO: %d MHz\n"),
+			_(pol_name[lnb[i].freqrange[j].pol]),
+			lnb[i].freqrange[j].low,
+			lnb[i].freqrange[j].high,
+			lnb[i].freqrange[j].int_freq);
 	}
-	printf(_("IF = lowband %d MHz, highband %d MHz\n"),
-	       lnb[i].lowfreq, lnb[i].highfreq);
 
 	return 0;
 }
@@ -376,7 +359,7 @@ static int dvbsat_diseqc_set_input(struct dvb_v5_fe_parms_priv *parms,
 	int mini_b = 0;
 	struct diseqc_cmd cmd;
 
-	if (!lnb->rangeswitch) {
+	if (!lnb->freqrange[0].rangeswitch) {
 		/*
 		 * Bandstacking switches don't use 2 bands nor use
 		 * DISEqC for setting the polarization. It also doesn't
@@ -430,62 +413,108 @@ static int dvbsat_diseqc_set_input(struct dvb_v5_fe_parms_priv *parms,
 	return rc;
 }
 
+int dvb_sat_real_freq(struct dvb_v5_fe_parms *p, int freq)
+{
+	struct dvb_v5_fe_parms_priv *parms = (void *)p;
+	int new_freq, i;
+
+	if (!dvb_fe_is_satellite(p->current_sys))
+		return freq;
+
+	new_freq = freq + parms->freq_offset;
+	for (i = 0; i < ARRAY_SIZE(lnb->freqrange) && lnb->freqrange[i].low; i++) {
+		if (freq < lnb->freqrange[i].low * 1000 || freq > lnb->freqrange[i].high * 1000)
+			continue;
+
+		return new_freq;
+	}
+
+	return parms->freq_offset - freq;
+}
+
+
 /*
  * DVB satellite get/set params hooks
  */
 
 
-int dvb_sat_set_parms(struct dvb_v5_fe_parms *p)
+static int dvb_sat_get_freq(struct dvb_v5_fe_parms *p, uint16_t *t)
 {
 	struct dvb_v5_fe_parms_priv *parms = (void *)p;
 	const struct dvb_sat_lnb_priv *lnb = (void *)p->lnb;
 	enum dvb_sat_polarization pol;
-	dvb_fe_retrieve_parm(&parms->p, DTV_POLARIZATION, &pol);
 	uint32_t freq;
-	uint16_t t = 0;
-	int rc;
-
-	parms->high_band = 0;
-	dvb_fe_retrieve_parm(&parms->p, DTV_FREQUENCY, &freq);
+	int j;
 
 	if (!lnb) {
 		dvb_logerr(_("Need a LNBf to work"));
-		return -EINVAL;
+		return 0;
 	}
 
-	/* Simple case: LNBf with just Single LO */
-	if (!lnb->highfreq) {
-		parms->freq_offset = lnb->lowfreq * 1000;
-		goto ret;
-	}
+	parms->high_band = 0;
+	parms->freq_offset = 0;
 
-	/* polarization-controlled multi LNBf */
-	if (!lnb->rangeswitch) {
-		if ((pol == POLARIZATION_V) || (pol == POLARIZATION_R))
-			parms->freq_offset = lnb->lowfreq * 1000;
-		else
-			parms->freq_offset = lnb->highfreq * 1000;
-		goto ret;
+	dvb_fe_retrieve_parm(&parms->p, DTV_FREQUENCY, &freq);
+
+	if (!lnb->freqrange[1].low) {
+		/* Trivial case: LNBf with a single local oscilator(LO) */
+		parms->freq_offset = lnb->freqrange[0].int_freq * 1000;
+		return freq;
 	}
 
-	/* Voltage-controlled multiband switch */
-	parms->high_band = (freq > lnb->rangeswitch * 1000) ? 1 : 0;
-
-	/* Adjust frequency */
-	if (parms->high_band)
-		parms->freq_offset = lnb->highfreq * 1000;
-	else
-		parms->freq_offset = lnb->lowfreq * 1000;
-
-	/* For SCR/Unicable setups */
-	if (parms->p.freq_bpf) {
-		t = (((freq / 1000) + parms->p.freq_bpf + 2) / 4) - 350;
-		parms->freq_offset += ((t + 350) * 4) * 1000;
-		if (parms->p.verbose)
-			dvb_log("BPF: %d KHz", parms->p.freq_bpf);
+	if (lnb->freqrange[0].pol) {
+		/* polarization-controlled multi-LO multipoint LNBf (bandstacking) */
+		dvb_fe_retrieve_parm(&parms->p, DTV_POLARIZATION, &pol);
+
+		for (j = 0; j < ARRAY_SIZE(lnb->freqrange) && lnb->freqrange[j].low; j++) {
+			if (freq < lnb->freqrange[j].low * 1000 ||
+			    freq > lnb->freqrange[j].high * 1000 ||
+			    pol != lnb->freqrange[j].pol)
+				continue;
+
+			parms->freq_offset = lnb->freqrange[j].int_freq * 1000;
+			return freq;
+		}
+	} else {
+		/* Multi-LO (dual-band) LNBf using DiSEqC */
+		for (j = 0; j < ARRAY_SIZE(lnb->freqrange) && lnb->freqrange[j].low; j++) {
+			if (freq < lnb->freqrange[j].low * 1000 || freq > lnb->freqrange[j].high * 1000)
+				continue;
+			if (freq > lnb->freqrange[j].rangeswitch * 1000)
+				j++;
+
+			/* Sets DiSEqC to high_band if not low band */
+			if (j)
+				parms->high_band = 1;
+
+			if (parms->p.freq_bpf) {
+				/* For SCR/Unicable setups */
+				*t = (((freq / 1000) + parms->p.freq_bpf + 2) / 4) - 350;
+				parms->freq_offset += ((*t + 350) * 4) * 1000;
+				if (parms->p.verbose)
+					dvb_log("BPF: %d KHz", parms->p.freq_bpf);
+			} else {
+				parms->freq_offset = lnb->freqrange[j].int_freq * 1000;
+			}
+			return freq;
+		}
 	}
+	dvb_logerr("frequency: %.2f MHz is out of LNBf range\n",
+		   freq / 1000.);
+	return 0;
+}
+
+int dvb_sat_set_parms(struct dvb_v5_fe_parms *p)
+{
+	struct dvb_v5_fe_parms_priv *parms = (void *)p;
+	uint32_t freq;
+	uint16_t t = 0;
+	int rc;
+
+	freq = dvb_sat_get_freq(p, &t);
+	if (!freq)
+		return -EINVAL;
 
-ret:
 	if (parms->p.verbose)
 		dvb_log("frequency: %.2f MHz, high_band: %d", freq / 1000., parms->high_band);
 
-- 
2.9.3

