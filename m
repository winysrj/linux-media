Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.bgcomp.co.uk ([81.187.35.205]:44713 "EHLO
	mailgate.bgcomp.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753560AbcBDRkd (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Feb 2016 12:40:33 -0500
Received: from eth7.localnet (ns1.bgcomp.co.uk [IPv6:2001:8b0:ca:2::fd])
	(using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	(Authenticated sender: b)
	by mailgate.bgcomp.co.uk (Postfix) with ESMTPSA id 5F7F31B657
	for <linux-media@vger.kernel.org>; Thu,  4 Feb 2016 17:32:48 +0000 (GMT)
From: Bob Goddard <linuxtv@1.linuxtv.bgcomp.co.uk>
To: linux-media@vger.kernel.org
Subject: [PATCH][media] Update dvb-s/Astra-28E with new transponders and corrections
Date: Thu, 04 Feb 2016 17:32:48 +0000
Message-ID: <4424321.3PBMCYi7If@eth7>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Update dvb-s/Astra-28.2E. 2 new transponders, corrected duplicate of
tp 92 in tp 93 and removed trailing space causing user tools segfault.

Signed-off-by: Bob Goddard <linuxtv@1.linuxtv.bgcomp.co.uk>
---
 dvb-s/Astra-28.2E | 27 ++++++++++++++++++++++++---
 1 file changed, 24 insertions(+), 3 deletions(-)

diff --git a/dvb-s/Astra-28.2E b/dvb-s/Astra-28.2E
index ea06c56..42168f6 100644
--- a/dvb-s/Astra-28.2E
+++ b/dvb-s/Astra-28.2E
@@ -264,6 +264,17 @@
 	MODULATION = QPSK
 	INVERSION = AUTO
 
+## Astra 2E
+# Transponder 31
+[CHANNEL]
+	DELIVERY_SYSTEM = DVBS
+	FREQUENCY = 12304000
+	POLARIZATION = HORIZONTAL
+	SYMBOL_RATE = 27500000
+	INNER_FEC = 2/3
+	MODULATION = QPSK
+	INVERSION = AUTO
+
 # Transponder 32
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBS2
@@ -572,7 +583,7 @@
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBS
 	FREQUENCY = 11170750
-	POLARIZATION = HORIZONTAL 
+	POLARIZATION = HORIZONTAL
 	SYMBOL_RATE = 22000000
 	INNER_FEC = 5/6
 	MODULATION = QPSK
@@ -611,8 +622,8 @@
 # Transponder 93
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBS
-	FREQUENCY = 11508500
-	POLARIZATION = VERTICAL
+	FREQUENCY = 11523500
+	POLARIZATION = HORIZONTAL
 	SYMBOL_RATE = 22000000
 	INNER_FEC = 5/6
 	MODULATION = QPSK
@@ -678,6 +689,16 @@
 	MODULATION = PSK/8
 	INVERSION = AUTO
 
+# Transponder 102
+[CHANNEL]
+	DELIVERY_SYSTEM = DVBS
+	FREQUENCY = 11656000
+	POLARIZATION = VERTICAL
+	SYMBOL_RATE = 22000000
+	INNER_FEC = 5/6
+	MODULATION = QPSK
+	INVERSION = AUTO
+
 # Transponder 103
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBS
-- 
2.6.2


