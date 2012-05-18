Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:64529 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967427Ab2ERVIM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 May 2012 17:08:12 -0400
Received: by weyu7 with SMTP id u7so2057432wey.19
        for <linux-media@vger.kernel.org>; Fri, 18 May 2012 14:08:11 -0700 (PDT)
From: Gregor Jasny <gjasny@googlemail.com>
To: linux-media@vger.kernel.org
Cc: Gregor Jasny <gjasny@googlemail.com>
Subject: [Fixed PATCH] libdvbv5: constify and hide dvb_sat_lnb
Date: Fri, 18 May 2012 23:07:52 +0200
Message-Id: <1337375272-15696-1-git-send-email-gjasny@googlemail.com>
In-Reply-To: <1337374847-12771-1-git-send-email-gjasny@googlemail.com>
References: <1337374847-12771-1-git-send-email-gjasny@googlemail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Gregor Jasny <gjasny@googlemail.com>
---
 lib/include/dvb-fe.h  |    2 +-
 lib/include/libsat.h  |    2 +-
 lib/libdvbv5/libsat.c |    4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/lib/include/dvb-fe.h b/lib/include/dvb-fe.h
index 872a558..062edd8 100644
--- a/lib/include/dvb-fe.h
+++ b/lib/include/dvb-fe.h
@@ -76,7 +76,7 @@ struct dvb_v5_fe_parms {
 	struct dvb_v5_stats		stats;
 
 	/* Satellite specific stuff, specified by the library client */
-	struct dvb_sat_lnb       	*lnb;
+	const struct dvb_sat_lnb       	*lnb;
 	int				sat_number;
 	unsigned			freq_bpf;
 
diff --git a/lib/include/libsat.h b/lib/include/libsat.h
index 2e74a11..57e5511 100644
--- a/lib/include/libsat.h
+++ b/lib/include/libsat.h
@@ -47,7 +47,7 @@ extern "C" {
 int dvb_sat_search_lnb(const char *name);
 int print_lnb(int i);
 void print_all_lnb(void);
-struct dvb_sat_lnb *dvb_sat_get_lnb(int i);
+const struct dvb_sat_lnb *dvb_sat_get_lnb(int i);
 int dvb_sat_set_parms(struct dvb_v5_fe_parms *parms);
 int dvb_sat_get_parms(struct dvb_v5_fe_parms *parms);
 
diff --git a/lib/libdvbv5/libsat.c b/lib/libdvbv5/libsat.c
index 126dc4e..34268c2 100644
--- a/lib/libdvbv5/libsat.c
+++ b/lib/libdvbv5/libsat.c
@@ -25,7 +25,7 @@
 #include "dvb-fe.h"
 #include "dvb-v5-std.h"
 
-struct dvb_sat_lnb lnb[] = {
+static const struct dvb_sat_lnb lnb[] = {
 	{
 		.name = "Europe",
 		.alias = "UNIVERSAL",
@@ -347,7 +347,7 @@ static int dvbsat_diseqc_set_input(struct dvb_v5_fe_parms *parms, uint16_t t)
 
 int dvb_sat_set_parms(struct dvb_v5_fe_parms *parms)
 {
-	struct dvb_sat_lnb *lnb = parms->lnb;
+	const struct dvb_sat_lnb *lnb = parms->lnb;
         enum dvb_sat_polarization pol;
         dvb_fe_retrieve_parm(parms, DTV_POLARIZATION,& pol);
 	uint32_t freq;
-- 
1.7.10

