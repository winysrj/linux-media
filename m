Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f195.google.com ([209.85.220.195]:35611 "EHLO
        mail-qk0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752469AbdCEBT0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 4 Mar 2017 20:19:26 -0500
Received: by mail-qk0-f195.google.com with SMTP id n127so36255428qkf.2
        for <linux-media@vger.kernel.org>; Sat, 04 Mar 2017 17:19:25 -0800 (PST)
From: Bill Murphy <gc2majortom@gmail.com>
To: linux-media@vger.kernel.org
Cc: Bill Murphy <gc2majortom@gmail.com>
Subject: [PATCH] dvb-sat: add support for North American Standard Ku LNB This is the standard LNB used in North America. It is designed with L.O. Freq of 10750 MHz. Intended for the North American FSS Ku Band, 11700 to 12200 MHz.
Date: Sat,  4 Mar 2017 20:09:31 -0500
Message-Id: <1488676171-11800-1-git-send-email-gc2majortom@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Bill Murphy <gc2majortom@gmail.com>
---
 lib/libdvbv5/dvb-sat.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/lib/libdvbv5/dvb-sat.c b/lib/libdvbv5/dvb-sat.c
index 59cb7a6..acac73a 100644
--- a/lib/libdvbv5/dvb-sat.c
+++ b/lib/libdvbv5/dvb-sat.c
@@ -113,6 +113,19 @@ static const struct dvb_sat_lnb_priv lnb[] = {
 		},
 	}, {
 		.desc = {
+			.name = N_("Standard, North America"),
+			.alias = "NA STANDARD",
+			// Legacy fields - kept just to avoid API/ABI breakages
+			.lowfreq = 10750,
+			.freqrange = {
+				{ 11700, 12200 }
+			},
+		},
+		.freqrange = {
+			{ 11700, 12200, 10750, 0 }
+		},
+	}, {
+		.desc = {
 			.name = N_("L10700"),
 			.alias = "L10700",
 			// Legacy fields - kept just to avoid API/ABI breakages
-- 
2.7.4
