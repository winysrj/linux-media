Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f171.google.com ([74.125.82.171]:46960 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752471AbaIMUJA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Sep 2014 16:09:00 -0400
Received: by mail-we0-f171.google.com with SMTP id p10so2233476wes.30
        for <linux-media@vger.kernel.org>; Sat, 13 Sep 2014 13:08:59 -0700 (PDT)
From: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
Subject: [PATCH 2/2] libdvbv5: fix satellite LNBf handling
Date: Sat, 13 Sep 2014 22:08:28 +0200
Message-Id: <1410638908-24637-2-git-send-email-neolynx@gmail.com>
In-Reply-To: <1410638908-24637-1-git-send-email-neolynx@gmail.com>
References: <1410638908-24637-1-git-send-email-neolynx@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

the LNBf is part of the public structure, remove it from
dvb_v5_fe_parms_priv.

fix typo for C++.

Signed-off-by: André Roth <neolynx@gmail.com>
---
 lib/include/libdvbv5/dvb-sat.h | 2 +-
 lib/libdvbv5/dvb-fe-priv.h     | 1 -
 lib/libdvbv5/dvb-sat.c         | 2 +-
 3 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/lib/include/libdvbv5/dvb-sat.h b/lib/include/libdvbv5/dvb-sat.h
index d80a619..c80545c 100644
--- a/lib/include/libdvbv5/dvb-sat.h
+++ b/lib/include/libdvbv5/dvb-sat.h
@@ -84,7 +84,7 @@ struct dvb_sat_lnb {
 struct dvb_v5_fe_parms;
 
 #ifdef __cplusplus
-extern "C"
+extern "C" {
 #endif
 
 /* From libsat.c */
diff --git a/lib/libdvbv5/dvb-fe-priv.h b/lib/libdvbv5/dvb-fe-priv.h
index 9194431..195c3bf 100644
--- a/lib/libdvbv5/dvb-fe-priv.h
+++ b/lib/libdvbv5/dvb-fe-priv.h
@@ -65,7 +65,6 @@ struct dvb_v5_fe_parms_priv {
 	struct dvb_v5_stats		stats;
 
 	/* Satellite specific stuff */
-	const struct dvb_sat_lnb       	*lnb;
 	int				high_band;
 	unsigned			freq_offset;
 };
diff --git a/lib/libdvbv5/dvb-sat.c b/lib/libdvbv5/dvb-sat.c
index 8befe28..e8df06b 100644
--- a/lib/libdvbv5/dvb-sat.c
+++ b/lib/libdvbv5/dvb-sat.c
@@ -356,7 +356,7 @@ static int dvbsat_diseqc_set_input(struct dvb_v5_fe_parms_priv *parms,
 int dvb_sat_set_parms(struct dvb_v5_fe_parms *p)
 {
 	struct dvb_v5_fe_parms_priv *parms = (void *)p;
-	const struct dvb_sat_lnb *lnb = parms->lnb;
+	const struct dvb_sat_lnb *lnb = p->lnb;
 	enum dvb_sat_polarization pol;
 	dvb_fe_retrieve_parm(&parms->p, DTV_POLARIZATION, &pol);
 	uint32_t freq;
-- 
1.9.1

