Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:54750 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753484AbbFHTyc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Jun 2015 15:54:32 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-doc@vger.kernel.org
Subject: [PATCH 09/26] [media] DocBook: add IDs for enum fe_bandwidth
Date: Mon,  8 Jun 2015 16:53:53 -0300
Message-Id: <64dc2d4c4f4b74a8734fc412a086b4bc00e7cf79.1433792665.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1433792665.git.mchehab@osg.samsung.com>
References: <cover.1433792665.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1433792665.git.mchehab@osg.samsung.com>
References: <cover.1433792665.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

enum fe_bandwidth is documented at the frontend legacy xml
file.

Add xrefs for each entry there. This makes the hyperlinks at
frontend.h to go directly to the right documentation.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/Documentation/DocBook/media/dvb/frontend_legacy_api.xml b/Documentation/DocBook/media/dvb/frontend_legacy_api.xml
index 3005cec58eb0..8523caf91a2c 100644
--- a/Documentation/DocBook/media/dvb/frontend_legacy_api.xml
+++ b/Documentation/DocBook/media/dvb/frontend_legacy_api.xml
@@ -75,25 +75,25 @@ supported via the new <link linkend="FE_GET_PROPERTY">FE_GET_PROPERTY/FE_GET_SET
 	</thead>
 	<tbody valign="top">
 	<row>
-	    <entry>BANDWIDTH_AUTO</entry>
+	    <entry id="BANDWIDTH-AUTO"><constant>BANDWIDTH_AUTO</constant></entry>
 	    <entry>Autodetect bandwidth (if supported)</entry>
 	</row><row>
-	    <entry>BANDWIDTH_1_712_MHZ</entry>
+	    <entry id="BANDWIDTH-1-712-MHZ"><constant>BANDWIDTH_1_712_MHZ</constant></entry>
 	    <entry>1.712 MHz</entry>
 	</row><row>
-	    <entry>BANDWIDTH_5_MHZ</entry>
+	    <entry id="BANDWIDTH-5-MHZ"><constant>BANDWIDTH_5_MHZ</constant></entry>
 	    <entry>5 MHz</entry>
 	</row><row>
-	    <entry>BANDWIDTH_6_MHZ</entry>
+	    <entry id="BANDWIDTH-6-MHZ"><constant>BANDWIDTH_6_MHZ</constant></entry>
 	    <entry>6 MHz</entry>
 	</row><row>
-	    <entry>BANDWIDTH_7_MHZ</entry>
+	    <entry id="BANDWIDTH-7-MHZ"><constant>BANDWIDTH_7_MHZ</constant></entry>
 	    <entry>7 MHz</entry>
 	</row><row>
-	    <entry>BANDWIDTH_8_MHZ</entry>
+	    <entry id="BANDWIDTH-8-MHZ"><constant>BANDWIDTH_8_MHZ</constant></entry>
 	    <entry>8 MHz</entry>
 	</row><row>
-	    <entry>BANDWIDTH_10_MHZ</entry>
+	    <entry id="BANDWIDTH-10-MHZ"><constant>BANDWIDTH_10_MHZ</constant></entry>
 	    <entry>10 MHz</entry>
 	</row>
         </tbody>
-- 
2.4.2

