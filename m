Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w2.samsung.com ([211.189.100.14]:59054 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751415AbaFXVf4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Jun 2014 17:35:56 -0400
Received: from uscpsbgex2.samsung.com
 (u123.gpu85.samsung.co.kr [203.254.195.123]) by usmailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N7O00FIYZZU0Q40@usmailout4.samsung.com> for
 linux-media@vger.kernel.org; Tue, 24 Jun 2014 17:35:54 -0400 (EDT)
Received: from sisasmtp.sisa.samsung.com ([105.144.21.115])
 by usmmp1.samsung.com
 (Oracle Communications Messaging Server 7u4-27.01(7.0.4.27.0) 64bit (built Aug
 30 2012)) with ESMTP id <0N7O002E5ZZU6E90@usmmp1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 24 Jun 2014 17:35:54 -0400 (EDT)
From: "Reynaldo H. Verdejo Pinochet" <r.verdejo@sisa.samsung.com>
To: linux-media@vger.kernel.org
Cc: "Reynaldo H. Verdejo Pinochet" <r.verdejo@sisa.samsung.com>
Subject: [PATCH][libdvbv5] dvb-sat: add universal Ku band (extended) LNBF def
Date: Tue, 24 Jun 2014 17:35:40 -0400
Message-id: <1403645740-16050-1-git-send-email-r.verdejo@sisa.samsung.com>
MIME-version: 1.0
Content-type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

These are quite common and off the shelf, universal
Ku band LBNFs. They started been used in Europe
after the lunch of the Astra 1E and can be found
pretty much everywhere.

Signed-off-by: Reynaldo H. Verdejo Pinochet <r.verdejo@sisa.samsung.com>
---
 lib/libdvbv5/dvb-sat.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/lib/libdvbv5/dvb-sat.c b/lib/libdvbv5/dvb-sat.c
index df2ffcd..4c7d2cd 100644
--- a/lib/libdvbv5/dvb-sat.c
+++ b/lib/libdvbv5/dvb-sat.c
@@ -44,6 +44,16 @@ static const struct dvb_sat_lnb lnb[] = {
 		.freqrange = {
 			{ 12200, 12700 }
 		}
+    }, {
+        .name = "Astra 1E, European Universal Ku (extended)",
+        .alias = "EXTENDEDU",
+		.lowfreq = 9750,
+		.highfreq = 10600,
+		.rangeswitch = 11700,
+		.freqrange = {
+			{ 10700, 11700 },
+			{ 11700, 12750 },
+		}
 	}, {
 		.name = "Standard",
 		.alias = "STANDARD",
-- 
2.0.0

