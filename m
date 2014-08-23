Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:37873 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894AbaHWQnE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 23 Aug 2014 12:43:04 -0400
Received: by mail-wi0-f175.google.com with SMTP id ho1so878538wib.2
        for <linux-media@vger.kernel.org>; Sat, 23 Aug 2014 09:43:03 -0700 (PDT)
From: Gregor Jasny <gjasny@googlemail.com>
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com, Gregor Jasny <gjasny@googlemail.com>
Subject: [PATCH 1/5] libdvbv5: Remove dvbsat_polarization_name (same as dvb_sat_pol_name)
Date: Sat, 23 Aug 2014 18:42:39 +0200
Message-Id: <1408812163-18309-2-git-send-email-gjasny@googlemail.com>
In-Reply-To: <1408812163-18309-1-git-send-email-gjasny@googlemail.com>
References: <1408812163-18309-1-git-send-email-gjasny@googlemail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Gregor Jasny <gjasny@googlemail.com>
---
 lib/include/libdvbv5/dvb-sat.h | 2 --
 lib/libdvbv5/dvb-sat.c         | 7 -------
 2 files changed, 9 deletions(-)

diff --git a/lib/include/libdvbv5/dvb-sat.h b/lib/include/libdvbv5/dvb-sat.h
index a414448..f14e7e4 100644
--- a/lib/include/libdvbv5/dvb-sat.h
+++ b/lib/include/libdvbv5/dvb-sat.h
@@ -37,8 +37,6 @@ struct dvb_sat_lnb {
 
 struct dvb_v5_fe_parms;
 
-extern const char *dvbsat_polarization_name[5];
-
 #ifdef __cplusplus
 extern "C" {
 #endif
diff --git a/lib/libdvbv5/dvb-sat.c b/lib/libdvbv5/dvb-sat.c
index 795524a..d0a6076 100644
--- a/lib/libdvbv5/dvb-sat.c
+++ b/lib/libdvbv5/dvb-sat.c
@@ -405,10 +405,3 @@ ret:
 	return rc;
 }
 
-const char *dvbsat_polarization_name[5] = {
-	"OFF",
-	"H",
-	"V",
-	"L",
-	"R",
-};
-- 
2.1.0

