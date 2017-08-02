Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:55174
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752129AbdHBSdE (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 2 Aug 2017 14:33:04 -0400
From: "Reynaldo H. Verdejo Pinochet" <reynaldo@osg.samsung.com>
To: linux-media@vger.kernel.org
Cc: "Reynaldo H. Verdejo Pinochet" <reynaldo@osg.samsung.com>
Subject: [PATCH 2/2] scan-tables: add initial table for San Jose, California
Date: Wed,  2 Aug 2017 11:32:50 -0700
Message-Id: <20170802183250.9553-3-reynaldo@osg.samsung.com>
In-Reply-To: <20170802183250.9553-1-reynaldo@osg.samsung.com>
References: <20170802183250.9553-1-reynaldo@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Reynaldo H. Verdejo Pinochet <reynaldo@osg.samsung.com>
---
 atsc/us-CA-San-Jose | 161 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 161 insertions(+)
 create mode 100644 atsc/us-CA-San-Jose

diff --git a/atsc/us-CA-San-Jose b/atsc/us-CA-San-Jose
new file mode 100644
index 0000000..ff514b9
--- /dev/null
+++ b/atsc/us-CA-San-Jose
@@ -0,0 +1,161 @@
+# Initial ATSC scan table for San Jose, California.
+#
+# This file was prepared from official (as of August 1 2017) FCC data[1]
+# for CA 950123, with an added entry for KAXT-CD which is broadcasting
+# in the area on UHF channel 42 but doesn't show up in the FCC database
+# search results for the ZIP code.
+#
+# [1] https://www.fcc.gov/media/engineering/dtvmaps
+#
+# Prepared by: Reynaldo H. Verdejo Pinochet <reynaldo@osg.samsung.com>
+
+[CHANNEL]
+	DELIVERY_SYSTEM = ATSC
+	FREQUENCY = 177000000
+	MODULATION = VSB/8
+	INVERSION = AUTO
+
+[CHANNEL]
+	DELIVERY_SYSTEM = ATSC
+	FREQUENCY = 183000000
+	MODULATION = VSB/8
+	INVERSION = AUTO
+
+[CHANNEL]
+	DELIVERY_SYSTEM = ATSC
+	FREQUENCY = 207000000
+	MODULATION = VSB/8
+	INVERSION = AUTO
+
+[CHANNEL]
+	DELIVERY_SYSTEM = ATSC
+	FREQUENCY = 213000000
+	MODULATION = VSB/8
+	INVERSION = AUTO
+
+[CHANNEL]
+	DELIVERY_SYSTEM = ATSC
+	FREQUENCY = 473000000
+	MODULATION = VSB/8
+	INVERSION = AUTO
+
+[CHANNEL]
+	DELIVERY_SYSTEM = ATSC
+	FREQUENCY = 503000000
+	MODULATION = VSB/8
+	INVERSION = AUTO
+
+[CHANNEL]
+	DELIVERY_SYSTEM = ATSC
+	FREQUENCY = 527000000
+	MODULATION = VSB/8
+	INVERSION = AUTO
+
+[CHANNEL]
+	DELIVERY_SYSTEM = ATSC
+	FREQUENCY = 551000000
+	MODULATION = VSB/8
+	INVERSION = AUTO
+
+[CHANNEL]
+	DELIVERY_SYSTEM = ATSC
+	FREQUENCY = 563000000
+	MODULATION = VSB/8
+	INVERSION = AUTO
+
+[CHANNEL]
+	DELIVERY_SYSTEM = ATSC
+	FREQUENCY = 569000000
+	MODULATION = VSB/8
+	INVERSION = AUTO
+
+[CHANNEL]
+	DELIVERY_SYSTEM = ATSC
+	FREQUENCY = 575000000
+	MODULATION = VSB/8
+	INVERSION = AUTO
+
+[CHANNEL]
+	DELIVERY_SYSTEM = ATSC
+	FREQUENCY = 587000000
+	MODULATION = VSB/8
+	INVERSION = AUTO
+
+[CHANNEL]
+	DELIVERY_SYSTEM = ATSC
+	FREQUENCY = 593000000
+	MODULATION = VSB/8
+	INVERSION = AUTO
+
+[CHANNEL]
+	DELIVERY_SYSTEM = ATSC
+	FREQUENCY = 605000000
+	MODULATION = VSB/8
+	INVERSION = AUTO
+
+[CHANNEL]
+	DELIVERY_SYSTEM = ATSC
+	FREQUENCY = 617000000
+	MODULATION = VSB/8
+	INVERSION = AUTO
+
+[CHANNEL]
+	DELIVERY_SYSTEM = ATSC
+	FREQUENCY = 623000000
+	MODULATION = VSB/8
+	INVERSION = AUTO
+
+[CHANNEL]
+	DELIVERY_SYSTEM = ATSC
+	FREQUENCY = 635000000
+	MODULATION = VSB/8
+	INVERSION = AUTO
+
+[CHANNEL]
+	DELIVERY_SYSTEM = ATSC
+	FREQUENCY = 641000000
+	MODULATION = VSB/8
+	INVERSION = AUTO
+
+[CHANNEL]
+	DELIVERY_SYSTEM = ATSC
+	FREQUENCY = 647000000
+	MODULATION = VSB/8
+	INVERSION = AUTO
+
+[CHANNEL]
+	DELIVERY_SYSTEM = ATSC
+	FREQUENCY = 653000000
+	MODULATION = VSB/8
+	INVERSION = AUTO
+
+[CHANNEL]
+	DELIVERY_SYSTEM = ATSC
+	FREQUENCY = 659000000
+	MODULATION = VSB/8
+	INVERSION = AUTO
+
+[CHANNEL]
+	DELIVERY_SYSTEM = ATSC
+	FREQUENCY = 671000000
+	MODULATION = VSB/8
+	INVERSION = AUTO
+
+[CHANNEL]
+	DELIVERY_SYSTEM = ATSC
+	FREQUENCY = 683000000
+	MODULATION = VSB/8
+	INVERSION = AUTO
+
+[CHANNEL]
+	DELIVERY_SYSTEM = ATSC
+	FREQUENCY = 689000000
+	MODULATION = VSB/8
+	INVERSION = AUTO
+
+[CHANNEL]
+	DELIVERY_SYSTEM = ATSC
+	FREQUENCY = 695000000
+	MODULATION = VSB/8
+	INVERSION = AUTO
+
-- 
2.13.2
