Return-path: <linux-media-owner@vger.kernel.org>
Received: from venus.vo.lu ([80.90.45.96]:57460 "EHLO venus.vo.lu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932942Ab3FROUl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Jun 2013 10:20:41 -0400
Received: from [2001:7e8:2221:300:230:5ff:fec0:2d3b] (helo=devbox)
	by ibiza.bxl.tuxicoman.be with smtp (Exim 4.80.1)
	(envelope-from <gmsoft@tuxicoman.be>)
	id 1Uowlq-0006xe-SD
	for linux-media@vger.kernel.org; Tue, 18 Jun 2013 16:20:32 +0200
From: Guy Martin <gmsoft@tuxicoman.be>
To: linux-media@vger.kernel.org
Subject: [PATCH 5/6] libdvbv5: Use a temporary copy of the dvb parameters when tuning
Date: Tue, 18 Jun 2013 16:19:08 +0200
Message-Id: <42ac663a85e646b5594c57ce1c61ee492c9a0a1f.1371561676.git.gmsoft@tuxicoman.be>
In-Reply-To: <cover.1371561676.git.gmsoft@tuxicoman.be>
References: <cover.1371561676.git.gmsoft@tuxicoman.be>
In-Reply-To: <cover.1371561676.git.gmsoft@tuxicoman.be>
References: <cover.1371561676.git.gmsoft@tuxicoman.be>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch copies the parms provided into a temporary buffer. This buffer will then
be used for any modification that needs to be performed. It makes the function
dvb_fe_set_parms() thread-safe. Also, since the DTV_FREQUENCY is not modified, it fixes
a bug where dvbv5-scan retrieves the frequency from the parms and write it to the
channel file.

Signed-off-by: Guy Martin <gmsoft@tuxicoman.be>
---
 lib/include/dvb-sat.h  |  1 -
 lib/libdvbv5/dvb-fe.c  | 71 ++++++++++++++++++++++----------------------------
 lib/libdvbv5/dvb-sat.c | 11 --------
 3 files changed, 31 insertions(+), 52 deletions(-)

diff --git a/lib/include/dvb-sat.h b/lib/include/dvb-sat.h
index 23df228..8b20c9e 100644
--- a/lib/include/dvb-sat.h
+++ b/lib/include/dvb-sat.h
@@ -49,7 +49,6 @@ int print_lnb(int i);
 void print_all_lnb(void);
 const struct dvb_sat_lnb *dvb_sat_get_lnb(int i);
 int dvb_sat_set_parms(struct dvb_v5_fe_parms *parms);
-int dvb_sat_get_parms(struct dvb_v5_fe_parms *parms);
 
 #ifdef __cplusplus
 }
diff --git a/lib/libdvbv5/dvb-fe.c b/lib/libdvbv5/dvb-fe.c
index b786a85..408423f 100644
--- a/lib/libdvbv5/dvb-fe.c
+++ b/lib/libdvbv5/dvb-fe.c
@@ -551,7 +551,7 @@ int dvb_fe_get_parms(struct dvb_v5_fe_parms *parms)
 			       delivery_system_name[parms->current_sys]);
 			dvb_fe_prt_parms(parms);
 		}
-		goto ret;
+		return 0;
 	}
 	/* DVBv3 call */
 	if (ioctl(parms->fd, FE_GET_FRONTEND, &v3_parms) == -1) {
@@ -592,32 +592,27 @@ int dvb_fe_get_parms(struct dvb_v5_fe_parms *parms)
 		return -EINVAL;
 	}
 
-ret:
-	/* For satellite, need to recover from LNBf IF frequency */
-	if (dvb_fe_is_satellite(parms->current_sys))
-		return dvb_sat_get_parms(parms);
-
 	return 0;
 }
 
 int dvb_fe_set_parms(struct dvb_v5_fe_parms *parms)
 {
+	/* Use a temporary copy of the parameters so we can safely perform
+	 * adjustments for satellite */
+	struct dvb_v5_fe_parms tmp_parms = *parms;
+
 	struct dtv_properties prop;
 	struct dvb_frontend_parameters v3_parms;
-	uint32_t freq;
 	uint32_t bw;
 
-	struct dtv_property fe_prop[DTV_MAX_COMMAND];
-
-	if (dvb_fe_is_satellite(parms->current_sys)) {
-		dvb_fe_retrieve_parm(parms, DTV_FREQUENCY, &freq);
-		dvb_sat_set_parms(parms);
-	}
+	if (dvb_fe_is_satellite(tmp_parms.current_sys))
+		dvb_sat_set_parms(&tmp_parms);
 
-	int n = dvb_copy_fe_props(parms->dvb_prop, parms->n_props, fe_prop);
+	/* Filter out any user DTV_foo property such as DTV_POLARIZATION */
+	tmp_parms.n_props = dvb_copy_fe_props(tmp_parms.dvb_prop, tmp_parms.n_props, tmp_parms.dvb_prop);
 
-	prop.props = fe_prop;
-	prop.num = n;
+	prop.props = tmp_parms.dvb_prop;
+	prop.num = tmp_parms.n_props;
 	prop.props[prop.num].cmd = DTV_TUNE;
 	prop.num++;
 
@@ -628,53 +623,49 @@ int dvb_fe_set_parms(struct dvb_v5_fe_parms *parms)
 				dvb_fe_prt_parms(parms);
 			return -1;
 		}
-		goto ret;
+		return 0;
 	}
 	/* DVBv3 call */
 
-	dvb_fe_retrieve_parm(parms, DTV_FREQUENCY, &v3_parms.frequency);
-	dvb_fe_retrieve_parm(parms, DTV_INVERSION, &v3_parms.inversion);
-	switch (parms->current_sys) {
+	dvb_fe_retrieve_parm(&tmp_parms, DTV_FREQUENCY, &v3_parms.frequency);
+	dvb_fe_retrieve_parm(&tmp_parms, DTV_INVERSION, &v3_parms.inversion);
+	switch (tmp_parms.current_sys) {
 	case SYS_DVBS:
-		dvb_fe_retrieve_parm(parms, DTV_SYMBOL_RATE, &v3_parms.u.qpsk.symbol_rate);
-		dvb_fe_retrieve_parm(parms, DTV_INNER_FEC, &v3_parms.u.qpsk.fec_inner);
+		dvb_fe_retrieve_parm(&tmp_parms, DTV_SYMBOL_RATE, &v3_parms.u.qpsk.symbol_rate);
+		dvb_fe_retrieve_parm(&tmp_parms, DTV_INNER_FEC, &v3_parms.u.qpsk.fec_inner);
 		break;
 	case SYS_DVBC_ANNEX_AC:
-		dvb_fe_retrieve_parm(parms, DTV_SYMBOL_RATE, &v3_parms.u.qam.symbol_rate);
-		dvb_fe_retrieve_parm(parms, DTV_INNER_FEC, &v3_parms.u.qam.fec_inner);
-		dvb_fe_retrieve_parm(parms, DTV_MODULATION, &v3_parms.u.qam.modulation);
+		dvb_fe_retrieve_parm(&tmp_parms, DTV_SYMBOL_RATE, &v3_parms.u.qam.symbol_rate);
+		dvb_fe_retrieve_parm(&tmp_parms, DTV_INNER_FEC, &v3_parms.u.qam.fec_inner);
+		dvb_fe_retrieve_parm(&tmp_parms, DTV_MODULATION, &v3_parms.u.qam.modulation);
 		break;
 	case SYS_ATSC:
 	case SYS_ATSCMH:
 	case SYS_DVBC_ANNEX_B:
-		dvb_fe_retrieve_parm(parms, DTV_MODULATION, &v3_parms.u.vsb.modulation);
+		dvb_fe_retrieve_parm(&tmp_parms, DTV_MODULATION, &v3_parms.u.vsb.modulation);
 		break;
 	case SYS_DVBT:
 		for (bw = 0; fe_bandwidth_name[bw] != 0; bw++) {
 			if (fe_bandwidth_name[bw] == v3_parms.u.ofdm.bandwidth)
 				break;
 		}
-		dvb_fe_retrieve_parm(parms, DTV_BANDWIDTH_HZ, &bw);
-		dvb_fe_retrieve_parm(parms, DTV_CODE_RATE_HP, &v3_parms.u.ofdm.code_rate_HP);
-		dvb_fe_retrieve_parm(parms, DTV_CODE_RATE_LP, &v3_parms.u.ofdm.code_rate_LP);
-		dvb_fe_retrieve_parm(parms, DTV_MODULATION, &v3_parms.u.ofdm.constellation);
-		dvb_fe_retrieve_parm(parms, DTV_TRANSMISSION_MODE, &v3_parms.u.ofdm.transmission_mode);
-		dvb_fe_retrieve_parm(parms, DTV_GUARD_INTERVAL, &v3_parms.u.ofdm.guard_interval);
-		dvb_fe_retrieve_parm(parms, DTV_HIERARCHY, &v3_parms.u.ofdm.hierarchy_information);
+		dvb_fe_retrieve_parm(&tmp_parms, DTV_BANDWIDTH_HZ, &bw);
+		dvb_fe_retrieve_parm(&tmp_parms, DTV_CODE_RATE_HP, &v3_parms.u.ofdm.code_rate_HP);
+		dvb_fe_retrieve_parm(&tmp_parms, DTV_CODE_RATE_LP, &v3_parms.u.ofdm.code_rate_LP);
+		dvb_fe_retrieve_parm(&tmp_parms, DTV_MODULATION, &v3_parms.u.ofdm.constellation);
+		dvb_fe_retrieve_parm(&tmp_parms, DTV_TRANSMISSION_MODE, &v3_parms.u.ofdm.transmission_mode);
+		dvb_fe_retrieve_parm(&tmp_parms, DTV_GUARD_INTERVAL, &v3_parms.u.ofdm.guard_interval);
+		dvb_fe_retrieve_parm(&tmp_parms, DTV_HIERARCHY, &v3_parms.u.ofdm.hierarchy_information);
 		break;
 	default:
 		return -EINVAL;
 	}
-	if (ioctl(parms->fd, FE_SET_FRONTEND, &v3_parms) == -1) {
+	if (ioctl(tmp_parms.fd, FE_SET_FRONTEND, &v3_parms) == -1) {
 		dvb_perror("FE_SET_FRONTEND");
-		if (parms->verbose)
-			dvb_fe_prt_parms(parms);
+		if (tmp_parms.verbose)
+			dvb_fe_prt_parms(&tmp_parms);
 		return -1;
 	}
-ret:
-	/* For satellite, need to recover from LNBf IF frequency */
-	if (dvb_fe_is_satellite(parms->current_sys))
-		dvb_fe_store_parm(parms, DTV_FREQUENCY, freq);
 
 	return 0;
 }
diff --git a/lib/libdvbv5/dvb-sat.c b/lib/libdvbv5/dvb-sat.c
index f84b5a4..3cbcf03 100644
--- a/lib/libdvbv5/dvb-sat.c
+++ b/lib/libdvbv5/dvb-sat.c
@@ -394,17 +394,6 @@ ret:
 	return rc;
 }
 
-int dvb_sat_get_parms(struct dvb_v5_fe_parms *parms)
-{
-	uint32_t freq = 0;
-
-	dvb_fe_retrieve_parm(parms, DTV_FREQUENCY, &freq);
-	freq = abs(freq + parms->freq_offset);
-	dvb_fe_store_parm(parms, DTV_FREQUENCY, freq);
-
-	return 0;
-}
-
 const char *dvbsat_polarization_name[5] = {
 	"OFF",
 	"H",
-- 
1.8.1.5


