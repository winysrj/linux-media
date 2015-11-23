Return-path: <linux-media-owner@vger.kernel.org>
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:41007 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751727AbbKWXtQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Nov 2015 18:49:16 -0500
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
	by mailout.nyi.internal (Postfix) with ESMTP id A60E52075B
	for <linux-media@vger.kernel.org>; Mon, 23 Nov 2015 18:49:15 -0500 (EST)
Received: from scrappy.walters.io (unknown [181.61.129.241])
	by mail.messagingengine.com (Postfix) with ESMTPA id 3C17468009D
	for <linux-media@vger.kernel.org>; Mon, 23 Nov 2015 18:49:13 -0500 (EST)
From: Dan Walters <dan@walters.io>
To: linux-media@vger.kernel.org
Date: Mon, 23 Nov 2015 18:28:13 -0500
Subject: [PATCH] dtv-scan-tables: Add all muxes currently in use for Colombia.
Message-Id: <20151123234914.3C17468009D@frontend2.nyi.internal>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Works for me in conjuction with the latest dvbv5-scan.

-Dan

---
 dvb-t/co-All | 34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)
 create mode 100644 dvb-t/co-All

diff --git a/dvb-t/co-All b/dvb-t/co-All
new file mode 100644
index 0000000..c06056a
--- /dev/null
+++ b/dvb-t/co-All
@@ -0,0 +1,34 @@
+# initial scan file for Colombia, national level
+# DVB-T2, 470-860MHz, 6MHz bandwidth
+# See: https://es.wikipedia.org/wiki/Televisi%C3%B3n_Digital_Terrestre_en_Colombia
+# See: https://www.crcom.gov.co/recursos_user/Documentos_CRC_2012/Actividades_Regulatorias/TDT/documentos_soporte_TDT_20120914.pdf#page=51
+
+[CHANNEL]
+	DELIVERY_SYSTEM = DVBT2
+	FREQUENCY = 473000000
+	BANDWIDTH_HZ = 6000000
+
+[CHANNEL]
+	DELIVERY_SYSTEM = DVBT2
+	FREQUENCY = 479000000
+	BANDWIDTH_HZ = 6000000
+
+[CHANNEL]
+	DELIVERY_SYSTEM = DVBT2
+	FREQUENCY = 485000000
+	BANDWIDTH_HZ = 6000000
+
+[CHANNEL]
+	DELIVERY_SYSTEM = DVBT2
+	FREQUENCY = 491000000
+	BANDWIDTH_HZ = 6000000
+
+[CHANNEL]
+	DELIVERY_SYSTEM = DVBT2
+	FREQUENCY = 551000000
+	BANDWIDTH_HZ = 6000000
+
+[CHANNEL]
+	DELIVERY_SYSTEM = DVBT2
+	FREQUENCY = 557000000
+	BANDWIDTH_HZ = 6000000
-- 
1.9.1

