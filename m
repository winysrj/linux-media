Return-path: <linux-media-owner@vger.kernel.org>
Received: from venus.vo.lu ([80.90.45.96]:57462 "EHLO venus.vo.lu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932941Ab3FROUl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Jun 2013 10:20:41 -0400
Received: from [2001:7e8:2221:300:230:5ff:fec0:2d3b] (helo=devbox)
	by ibiza.bxl.tuxicoman.be with smtp (Exim 4.80.1)
	(envelope-from <gmsoft@tuxicoman.be>)
	id 1Uowln-0006xS-1M
	for linux-media@vger.kernel.org; Tue, 18 Jun 2013 16:20:28 +0200
From: Guy Martin <gmsoft@tuxicoman.be>
To: linux-media@vger.kernel.org
Subject: [PATCH 3/6] libdvbv5: Export dvb_fe_is_satellite()
Date: Tue, 18 Jun 2013 16:19:06 +0200
Message-Id: <8745561db2ff7870ad9feb1ee0c7a32537dee18d.1371561676.git.gmsoft@tuxicoman.be>
In-Reply-To: <cover.1371561676.git.gmsoft@tuxicoman.be>
References: <cover.1371561676.git.gmsoft@tuxicoman.be>
In-Reply-To: <cover.1371561676.git.gmsoft@tuxicoman.be>
References: <cover.1371561676.git.gmsoft@tuxicoman.be>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch makes the function dvb_fe_is_satellite() availble from libdvbv5. This function is simple
but yet very handful to have around.

Signed-off-by: Guy Martin <gmsoft@tuxicoman.be>
---
 lib/include/dvb-fe.h  |  1 +
 lib/libdvbv5/dvb-fe.c | 14 +++++++-------
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/lib/include/dvb-fe.h b/lib/include/dvb-fe.h
index d725a42..7352218 100644
--- a/lib/include/dvb-fe.h
+++ b/lib/include/dvb-fe.h
@@ -203,6 +203,7 @@ int dvb_fe_diseqc_cmd(struct dvb_v5_fe_parms *parms, const unsigned len,
 		      const unsigned char *buf);
 int dvb_fe_diseqc_reply(struct dvb_v5_fe_parms *parms, unsigned *len, char *buf,
 		       int timeout);
+int dvb_fe_is_satellite(uint32_t delivery_system);
 
 #ifdef __cplusplus
 }
diff --git a/lib/libdvbv5/dvb-fe.c b/lib/libdvbv5/dvb-fe.c
index 550b6e2..b786a85 100644
--- a/lib/libdvbv5/dvb-fe.c
+++ b/lib/libdvbv5/dvb-fe.c
@@ -230,7 +230,7 @@ struct dvb_v5_fe_parms *dvb_fe_open2(int adapter, int frontend, unsigned verbose
 }
 
 
-static int is_satellite(uint32_t delivery_system)
+int dvb_fe_is_satellite(uint32_t delivery_system)
 {
 	switch (delivery_system) {
 	case SYS_DVBS:
@@ -254,7 +254,7 @@ void dvb_fe_close(struct dvb_v5_fe_parms *parms)
 		return;
 
 	/* Disable LNBf power */
-	if (is_satellite(parms->current_sys))
+	if (dvb_fe_is_satellite(parms->current_sys))
 		dvb_fe_sec_voltage(parms, 0, 0);
 
 	close(parms->fd);
@@ -298,8 +298,8 @@ int dvb_set_sys(struct dvb_v5_fe_parms *parms,
 
 	if (sys != parms->current_sys) {
 		/* Disable LNBf power */
-		if (is_satellite(parms->current_sys) &&
-		    !is_satellite(sys))
+		if (dvb_fe_is_satellite(parms->current_sys) &&
+		    !dvb_fe_is_satellite(sys))
 			dvb_fe_sec_voltage(parms, 0, 0);
 
 		/* Can't change standard with the legacy FE support */
@@ -594,7 +594,7 @@ int dvb_fe_get_parms(struct dvb_v5_fe_parms *parms)
 
 ret:
 	/* For satellite, need to recover from LNBf IF frequency */
-	if (is_satellite(parms->current_sys))
+	if (dvb_fe_is_satellite(parms->current_sys))
 		return dvb_sat_get_parms(parms);
 
 	return 0;
@@ -609,7 +609,7 @@ int dvb_fe_set_parms(struct dvb_v5_fe_parms *parms)
 
 	struct dtv_property fe_prop[DTV_MAX_COMMAND];
 
-	if (is_satellite(parms->current_sys)) {
+	if (dvb_fe_is_satellite(parms->current_sys)) {
 		dvb_fe_retrieve_parm(parms, DTV_FREQUENCY, &freq);
 		dvb_sat_set_parms(parms);
 	}
@@ -673,7 +673,7 @@ int dvb_fe_set_parms(struct dvb_v5_fe_parms *parms)
 	}
 ret:
 	/* For satellite, need to recover from LNBf IF frequency */
-	if (is_satellite(parms->current_sys))
+	if (dvb_fe_is_satellite(parms->current_sys))
 		dvb_fe_store_parm(parms, DTV_FREQUENCY, freq);
 
 	return 0;
-- 
1.8.1.5


