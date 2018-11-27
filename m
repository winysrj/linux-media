Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:33486 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726312AbeK1AMz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Nov 2018 19:12:55 -0500
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Subject: [PATCH] dvb-sat: rename Astra 1E to Astra 19.2 E and move it to beginning
Date: Tue, 27 Nov 2018 11:14:52 -0200
Message-Id: <a5fc0e08339708a21a0d254ece4feab45421ce50.1543324451.git.mchehab+samsung@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The "European Universal" LNBf was now replaced by the model with
also supports the Astra satellites in almost all EU. We're keeping
seeing people reporting problems on Kaffeine and other digital TV
software due to that.

So, in order to make easier for new people that just want to make
their Satellite-based TV to work in Europe, let's move the Astra
entry to be the first one and giving it a better name, as the
Astra 1E satellite was retired a long time ago, and, since 2008,
the satellites that replaced it are known as "Astra 19.2 E",
in order to reflect their orbital position.

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 lib/libdvbv5/dvb-sat.c | 36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/lib/libdvbv5/dvb-sat.c b/lib/libdvbv5/dvb-sat.c
index 8c04f66f973b..18e2359c053b 100644
--- a/lib/libdvbv5/dvb-sat.c
+++ b/lib/libdvbv5/dvb-sat.c
@@ -53,7 +53,24 @@ struct dvb_sat_lnb_priv {
 static const struct dvb_sat_lnb_priv lnb_array[] = {
 	{
 		.desc = {
-			.name = N_("Universal, Europe"),
+			.name = N_("Astra 19.2E, European Universal Ku (extended)"),
+			.alias = "EXTENDED",
+			// Legacy fields - kept just to avoid API/ABI breakages
+			.lowfreq = 9750,
+			.highfreq = 10600,
+			.rangeswitch = 11700,
+			.freqrange = {
+				{ 10700, 11700 },
+				{ 11700, 12750 },
+			},
+		},
+		.freqrange = {
+			{ 10700, 11700, 9750, 11700},
+			{ 11700, 12750, 10600, 0 },
+		}
+	}, {
+		.desc = {
+			.name = N_("Old European Universal. Nowadays mostly replaced by Astra 19.2E"),
 			.alias = "UNIVERSAL",
 			// Legacy fields - kept just to avoid API/ABI breakages
 			.lowfreq = 9750,
@@ -81,23 +98,6 @@ static const struct dvb_sat_lnb_priv lnb_array[] = {
 		.freqrange = {
 			{ 12200, 12700, 11250 }
 		}
-	}, {
-		.desc = {
-			.name = N_("Astra 1E, European Universal Ku (extended)"),
-			.alias = "EXTENDED",
-			// Legacy fields - kept just to avoid API/ABI breakages
-			.lowfreq = 9750,
-			.highfreq = 10600,
-			.rangeswitch = 11700,
-			.freqrange = {
-				{ 10700, 11700 },
-				{ 11700, 12750 },
-			},
-		},
-		.freqrange = {
-			{ 10700, 11700, 9750, 11700},
-			{ 11700, 12750, 10600, 0 },
-		}
 	}, {
 		.desc = {
 			.name = N_("Standard"),
-- 
2.19.1
