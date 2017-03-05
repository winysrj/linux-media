Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f196.google.com ([209.85.220.196]:34896 "EHLO
        mail-qk0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752077AbdCENJD (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 5 Mar 2017 08:09:03 -0500
Received: by mail-qk0-f196.google.com with SMTP id n127so37964486qkf.2
        for <linux-media@vger.kernel.org>; Sun, 05 Mar 2017 05:09:02 -0800 (PST)
From: Bill Murphy <gc2majortom@gmail.com>
To: linux-media@vger.kernel.org
Cc: Bill Murphy <gc2majortom@gmail.com>
Subject: [PATCH] [v4l-utils] dvb-sat: add support for North American Standard Ku LNB This is the standard LNB used in North America, it is designed with L.O. Freq of 10750 MHz. Intended for the North American FSS Ku Band, 11700 to 12200 MHz.
Date: Sun,  5 Mar 2017 08:08:33 -0500
Message-Id: <1488719313-23540-1-git-send-email-gc2majortom@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Bill Murphy <gc2majortom@gmail.com>
---
 lib/libdvbv5/dvb-sat.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/lib/libdvbv5/dvb-sat.c b/lib/libdvbv5/dvb-sat.c
index 59cb7a6..22a45b1 100644
--- a/lib/libdvbv5/dvb-sat.c
+++ b/lib/libdvbv5/dvb-sat.c
@@ -126,6 +126,19 @@ static const struct dvb_sat_lnb_priv lnb[] = {
 		},
 	}, {
 		.desc = {
+			.name = N_("L10750"),
+			.alias = "L10750",
+			// Legacy fields - kept just to avoid API/ABI breakages
+			.lowfreq = 10750,
+			.freqrange = {
+				{ 11700, 12200 }
+			},
+		},
+		.freqrange = {
+		       { 11700, 12200, 10750, 0 }
+		},
+	}, {
+		.desc = {
 			.name = N_("L11300"),
 			.alias = "L11300",
 			// Legacy fields - kept just to avoid API/ABI breakages
-- 
2.7.4
