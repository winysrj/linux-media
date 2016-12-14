Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43403 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755548AbcLNNSq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Dec 2016 08:18:46 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: linux-media@vger.kernel.org
Cc: Gregor Jasny <gjasny@googlemail.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [v4l-utils PATCH 1/3] dvb-sat: embeed most stuff internally at struct LNBf
Date: Wed, 14 Dec 2016 11:18:33 -0200
Message-Id: <20161214131835.11259-2-mchehab@s-opensource.com>
In-Reply-To: <20161214131835.11259-1-mchehab@s-opensource.com>
References: <20161214131835.11259-1-mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We'll need to change the way dvb-sat.c handle LNBfs, in order
to be able to support more advanced LNBf with 4 oscilators.

So, let's first use an obscure most stuff for userspace.
Please notice that, unfortunately, this will break the API.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 lib/include/libdvbv5/dvb-sat.h | 25 -----------
 lib/libdvbv5/dvb-sat.c         | 94 +++++++++++++++++++++++++++++-------------
 2 files changed, 66 insertions(+), 53 deletions(-)

diff --git a/lib/include/libdvbv5/dvb-sat.h b/lib/include/libdvbv5/dvb-sat.h
index 3f796435fa77..7f83369fce39 100644
--- a/lib/include/libdvbv5/dvb-sat.h
+++ b/lib/include/libdvbv5/dvb-sat.h
@@ -36,32 +36,12 @@
  */
 
 /**
- * @struct dvbsat_freqrange
- * @brief Defines a frequency range used by Satellite
- * @ingroup satellite
- *
- * @param low	low frequency, in kHz
- * @param high	high frequency, in kHz
- */
-struct dvbsat_freqrange {
-	unsigned low, high;
-};
-
-/**
  * @struct dvb_sat_lnb
  * @brief Stores the information of a LNBf
  * @ingroup satellite
  *
  * @param name		long name of the LNBf type
  * @param alias		short name for the LNBf type
- * @param lowfreq	Low frequency Intermediate Frequency of the LNBf, in kHz
- * @param highfreq	High frequency Intermediate frequency of the LNBf,
- *			in kHz
- * @param rangeswitch	For LNBf that has multiple frequency ranges controlled
- *			by a voltage change, specify the start frequency where
- *			the second range will be applied.
- * @param freqrange	Contains the range(s) of frequencies supported by a
- *			given LNBf.
  *
  * The LNBf (low-noise block downconverter) is a type of amplifier that is
  * installed inside the parabolic dishes. It converts the antenna signal to
@@ -73,11 +53,6 @@ struct dvbsat_freqrange {
 struct dvb_sat_lnb {
 	const char *name;
 	const char *alias;
-	unsigned lowfreq, highfreq;
-
-	unsigned rangeswitch;
-
-	struct dvbsat_freqrange freqrange[2];
 };
 
 struct dvb_v5_fe_parms;
diff --git a/lib/libdvbv5/dvb-sat.c b/lib/libdvbv5/dvb-sat.c
index 557bc7765e23..254a1e2c7df7 100644
--- a/lib/libdvbv5/dvb-sat.c
+++ b/lib/libdvbv5/dvb-sat.c
@@ -38,10 +38,28 @@
 
 # define N_(string) string
 
-static const struct dvb_sat_lnb lnb[] = {
+struct dvbsat_freqrange {
+	unsigned low, high;
+};
+
+struct dvb_sat_lnb_priv {
+	struct dvb_sat_lnb desc;
+
+	/* Private members used internally */
+
+	unsigned lowfreq, highfreq;
+
+	unsigned rangeswitch;
+
+	struct dvbsat_freqrange freqrange[2];
+};
+
+static const struct dvb_sat_lnb_priv lnb[] = {
 	{
-		.name = N_("Universal, Europe"),
-		.alias = "UNIVERSAL",
+		.desc = {
+			.name = N_("Universal, Europe"),
+			.alias = "UNIVERSAL",
+		},
 		.lowfreq = 9750,
 		.highfreq = 10600,
 		.rangeswitch = 11700,
@@ -50,15 +68,19 @@ static const struct dvb_sat_lnb lnb[] = {
 			{ 11600, 12700 },
 		}
 	}, {
-		.name = N_("Expressvu, North America"),
-		.alias = "DBS",
+		.desc = {
+			.name = N_("Expressvu, North America"),
+			.alias = "DBS",
+		},
 		.lowfreq = 11250,
 		.freqrange = {
 			{ 12200, 12700 }
 		}
 	}, {
-		.name = N_("Astra 1E, European Universal Ku (extended)"),
-		.alias = "EXTENDED",
+		.desc = {
+			.name = N_("Astra 1E, European Universal Ku (extended)"),
+			.alias = "EXTENDED",
+		},
 		.lowfreq = 9750,
 		.highfreq = 10600,
 		.rangeswitch = 11700,
@@ -67,59 +89,75 @@ static const struct dvb_sat_lnb lnb[] = {
 			{ 11700, 12750 },
 		}
 	}, {
-		.name = N_("Standard"),
-		.alias = "STANDARD",
+		.desc = {
+			.name = N_("Standard"),
+			.alias = "STANDARD",
+		},
 		.lowfreq = 10000,
 		.freqrange = {
 			{ 10945, 11450 }
 		},
 	}, {
-		.name = N_("L10700"),
-		.alias = "L10700",
+		.desc = {
+			.name = N_("L10700"),
+			.alias = "L10700",
+		},
 		.lowfreq = 10700,
 		.freqrange = {
 		       { 11750, 12750 }
 		},
 	}, {
-		.name = N_("L11300"),
-		.alias = "L11300",
+		.desc = {
+			.name = N_("L11300"),
+			.alias = "L11300",
+		},
 		.lowfreq = 11300,
 		.freqrange = {
 			{ 12250, 12750 }
 		},
 	}, {
-		.name = N_("Astra"),
-		.alias = "ENHANCED",
+		.desc = {
+			.name = N_("Astra"),
+			.alias = "ENHANCED",
+		},
 		.lowfreq = 9750,
 		.freqrange = {
 			{ 10700, 11700 }
 		},
 	}, {
-		.name = N_("Big Dish - Monopoint LNBf"),
-		.alias = "C-BAND",
+		.desc = {
+			.name = N_("Big Dish - Monopoint LNBf"),
+			.alias = "C-BAND",
+		},
 		.lowfreq = 5150,
 		.freqrange = {
 			{ 3700, 4200 }
 		},
 	}, {
-		.name = N_("Big Dish - Multipoint LNBf"),
-		.alias = "C-MULT",
+		.desc = {
+			.name = N_("Big Dish - Multipoint LNBf"),
+			.alias = "C-MULT",
+		},
 		.lowfreq = 5150,
 		.highfreq = 5750,
 		.freqrange = {
 			{ 3700, 4200 }
 		},
 	}, {
-		.name = N_("DishPro LNBf"),
-		.alias = "DISHPRO",
+		.desc = {
+			.name = N_("DishPro LNBf"),
+			.alias = "DISHPRO",
+		},
 		.lowfreq = 11250,
 		.highfreq = 14350,
 		.freqrange = {
 			{ 12200, 12700 }
 		}
 	}, {
-		.name = N_("Japan 110BS/CS LNBf"),
-		.alias = "110BS",
+		.desc = {
+			.name = N_("Japan 110BS/CS LNBf"),
+			.alias = "110BS",
+		},
 		.lowfreq = 10678,
 		.freqrange = {
 			{ 11710, 12751 }
@@ -132,7 +170,7 @@ int dvb_sat_search_lnb(const char *name)
 	int i = 0;
 
 	for (i = 0; i < ARRAY_SIZE(lnb); i++) {
-		if (!strcasecmp(name, lnb[i].alias))
+		if (!strcasecmp(name, lnb[i].desc.alias))
 			return i;
 	}
 	return -1;
@@ -143,7 +181,7 @@ int dvb_print_lnb(int i)
 	if (i < 0 || i >= ARRAY_SIZE(lnb))
 		return -1;
 
-	printf("%s\n\t%s\n", lnb[i].alias, dvb_sat_get_lnb_name(i));
+	printf("%s\n\t%s\n", lnb[i].desc.alias, dvb_sat_get_lnb_name(i));
 	printf(_("\t%d to %d MHz"),
 	       lnb[i].freqrange[0].low, lnb[i].freqrange[0].high);
 	if (lnb[i].freqrange[1].low)
@@ -180,7 +218,7 @@ const struct dvb_sat_lnb *dvb_sat_get_lnb(int i)
 	if (i < 0 || i >= ARRAY_SIZE(lnb))
 		return NULL;
 
-	return &lnb[i];
+	return (void *)&lnb[i];
 }
 
 const char *dvb_sat_get_lnb_name(int i)
@@ -188,7 +226,7 @@ const char *dvb_sat_get_lnb_name(int i)
 	if (i < 0 || i >= ARRAY_SIZE(lnb))
 		return NULL;
 
-	return _(lnb[i].name);
+	return _(lnb[i].desc.name);
 }
 
 
@@ -400,7 +438,7 @@ static int dvbsat_diseqc_set_input(struct dvb_v5_fe_parms_priv *parms,
 int dvb_sat_set_parms(struct dvb_v5_fe_parms *p)
 {
 	struct dvb_v5_fe_parms_priv *parms = (void *)p;
-	const struct dvb_sat_lnb *lnb = p->lnb;
+	const struct dvb_sat_lnb_priv *lnb = (void *)p->lnb;
 	enum dvb_sat_polarization pol;
 	dvb_fe_retrieve_parm(&parms->p, DTV_POLARIZATION, &pol);
 	uint32_t freq;
-- 
2.9.3

