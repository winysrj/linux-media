Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:54768 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753542AbbFHTyc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Jun 2015 15:54:32 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-doc@vger.kernel.org
Subject: [PATCH 02/26] [media] DocBook: Add entry IDs for enum fe_caps
Date: Mon,  8 Jun 2015 16:53:46 -0300
Message-Id: <d71d4fe86435f957cb310ad933a16372f9fa2f58.1433792665.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1433792665.git.mchehab@osg.samsung.com>
References: <cover.1433792665.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1433792665.git.mchehab@osg.samsung.com>
References: <cover.1433792665.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

enum fe_caps is documented at FE_GET_INFO ioctl. Add xrefs
for each entry there. This makes the hyperlinks at frontend.h
to go directly to the right documentation.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/Documentation/DocBook/media/dvb/fe-get-info.xml b/Documentation/DocBook/media/dvb/fe-get-info.xml
index 0e0245e45d26..ed0eeb29dd65 100644
--- a/Documentation/DocBook/media/dvb/fe-get-info.xml
+++ b/Documentation/DocBook/media/dvb/fe-get-info.xml
@@ -135,128 +135,128 @@ driver is not compatible with this specification the ioctl returns an error.
 	</thead>
 	<tbody valign="top">
 	<row>
-	<entry><constant>FE_IS_STUPID</constant></entry>
+	<entry id="FE-IS-STUPID"><constant>FE_IS_STUPID</constant></entry>
 	<entry>There's something wrong at the frontend, and it can't
 	    report its capabilities</entry>
 	</row>
 	<row>
-	<entry><constant>FE_CAN_INVERSION_AUTO</constant></entry>
+	<entry id="FE-CAN-INVERSION-AUTO"><constant>FE_CAN_INVERSION_AUTO</constant></entry>
 	<entry>The frontend is capable of auto-detecting inversion</entry>
 	</row>
 	<row>
-	<entry><constant>FE_CAN_FEC_1_2</constant></entry>
+	<entry id="FE-CAN-FEC-1-2"><constant>FE_CAN_FEC_1_2</constant></entry>
 	<entry>The frontend supports FEC 1/2</entry>
 	</row>
 	<row>
-	<entry><constant>FE_CAN_FEC_2_3</constant></entry>
+	<entry id="FE-CAN-FEC-2-3"><constant>FE_CAN_FEC_2_3</constant></entry>
 	<entry>The frontend supports FEC 2/3</entry>
 	</row>
 	<row>
-	<entry><constant>FE_CAN_FEC_3_4</constant></entry>
+	<entry id="FE-CAN-FEC-3-4"><constant>FE_CAN_FEC_3_4</constant></entry>
 	<entry>The frontend supports FEC 3/4</entry>
 	</row>
 	<row>
-	<entry><constant>FE_CAN_FEC_4_5</constant></entry>
+	<entry id="FE-CAN-FEC-4-5"><constant>FE_CAN_FEC_4_5</constant></entry>
 	<entry>The frontend supports FEC 4/5</entry>
 	</row>
 	<row>
-	<entry><constant>FE_CAN_FEC_5_6</constant></entry>
+	<entry id="FE-CAN-FEC-5-6"><constant>FE_CAN_FEC_5_6</constant></entry>
 	<entry>The frontend supports FEC 5/6</entry>
 	</row>
 	<row>
-	<entry><constant>FE_CAN_FEC_6_7</constant></entry>
+	<entry id="FE-CAN-FEC-6-7"><constant>FE_CAN_FEC_6_7</constant></entry>
 	<entry>The frontend supports FEC 6/7</entry>
 	</row>
 	<row>
-	<entry><constant>FE_CAN_FEC_7_8</constant></entry>
+	<entry id="FE-CAN-FEC-7-8"><constant>FE_CAN_FEC_7_8</constant></entry>
 	<entry>The frontend supports FEC 7/8</entry>
 	</row>
 	<row>
-	<entry><constant>FE_CAN_FEC_8_9</constant></entry>
+	<entry id="FE-CAN-FEC-8-9"><constant>FE_CAN_FEC_8_9</constant></entry>
 	<entry>The frontend supports FEC 8/9</entry>
 	</row>
 	<row>
-	<entry><constant>FE_CAN_FEC_AUTO</constant></entry>
+	<entry id="FE-CAN-FEC-AUTO"><constant>FE_CAN_FEC_AUTO</constant></entry>
 	<entry>The frontend can autodetect FEC.</entry>
 	</row>
 	<row>
-	<entry><constant>FE_CAN_QPSK</constant></entry>
+	<entry id="FE-CAN-QPSK"><constant>FE_CAN_QPSK</constant></entry>
 	<entry>The frontend supports QPSK modulation</entry>
 	</row>
 	<row>
-	<entry><constant>FE_CAN_QAM_16</constant></entry>
+	<entry id="FE-CAN-QAM-16"><constant>FE_CAN_QAM_16</constant></entry>
 	<entry>The frontend supports 16-QAM modulation</entry>
 	</row>
 	<row>
-	<entry><constant>FE_CAN_QAM_32</constant></entry>
+	<entry id="FE-CAN-QAM-32"><constant>FE_CAN_QAM_32</constant></entry>
 	<entry>The frontend supports 32-QAM modulation</entry>
 	</row>
 	<row>
-	<entry><constant>FE_CAN_QAM_64</constant></entry>
+	<entry id="FE-CAN-QAM-64"><constant>FE_CAN_QAM_64</constant></entry>
 	<entry>The frontend supports 64-QAM modulation</entry>
 	</row>
 	<row>
-	<entry><constant>FE_CAN_QAM_128</constant></entry>
+	<entry id="FE-CAN-QAM-128"><constant>FE_CAN_QAM_128</constant></entry>
 	<entry>The frontend supports 128-QAM modulation</entry>
 	</row>
 	<row>
-	<entry><constant>FE_CAN_QAM_256</constant></entry>
+	<entry id="FE-CAN-QAM-256"><constant>FE_CAN_QAM_256</constant></entry>
 	<entry>The frontend supports 256-QAM modulation</entry>
 	</row>
 	<row>
-	<entry><constant>FE_CAN_QAM_AUTO</constant></entry>
+	<entry id="FE-CAN-QAM-AUTO"><constant>FE_CAN_QAM_AUTO</constant></entry>
 	<entry>The frontend can autodetect modulation</entry>
 	</row>
 	<row>
-	<entry><constant>FE_CAN_TRANSMISSION_MODE_AUTO</constant></entry>
+	<entry id="FE-CAN-TRANSMISSION-MODE-AUTO"><constant>FE_CAN_TRANSMISSION_MODE_AUTO</constant></entry>
 	<entry>The frontend can autodetect the transmission mode</entry>
 	</row>
 	<row>
-	<entry><constant>FE_CAN_BANDWIDTH_AUTO</constant></entry>
+	<entry id="FE-CAN-BANDWIDTH-AUTO"><constant>FE_CAN_BANDWIDTH_AUTO</constant></entry>
 	<entry>The frontend can autodetect the bandwidth</entry>
 	</row>
 	<row>
-	<entry><constant>FE_CAN_GUARD_INTERVAL_AUTO</constant></entry>
+	<entry id="FE-CAN-GUARD-INTERVAL-AUTO"><constant>FE_CAN_GUARD_INTERVAL_AUTO</constant></entry>
 	<entry>The frontend can autodetect the guard interval</entry>
 	</row>
 	<row>
-	<entry><constant>FE_CAN_HIERARCHY_AUTO</constant></entry>
+	<entry id="FE-CAN-HIERARCHY-AUTO"><constant>FE_CAN_HIERARCHY_AUTO</constant></entry>
 	<entry>The frontend can autodetect hierarch</entry>
 	</row>
 	<row>
-	<entry><constant>FE_CAN_8VSB</constant></entry>
+	<entry id="FE-CAN-8VSB"><constant>FE_CAN_8VSB</constant></entry>
 	<entry>The frontend supports 8-VSB modulation</entry>
 	</row>
 	<row>
-	<entry><constant>FE_CAN_16VSB</constant></entry>
+	<entry id="FE-CAN-16VSB"><constant>FE_CAN_16VSB</constant></entry>
 	<entry>The frontend supports 16-VSB modulation</entry>
 	</row>
 	<row>
-	<entry><constant>FE_HAS_EXTENDED_CAPS</constant></entry>
+	<entry id="FE-HAS-EXTENDED-CAPS"><constant>FE_HAS_EXTENDED_CAPS</constant></entry>
 	<entry>Currently, unused</entry>
 	</row>
 	<row>
-	<entry><constant>FE_CAN_MULTISTREAM</constant></entry>
+	<entry id="FE-CAN-MULTISTREAM"><constant>FE_CAN_MULTISTREAM</constant></entry>
 	<entry>The frontend supports multistream filtering</entry>
 	</row>
 	<row>
-	<entry><constant>FE_CAN_TURBO_FEC</constant></entry>
+	<entry id="FE-CAN-TURBO-FEC"><constant>FE_CAN_TURBO_FEC</constant></entry>
 	<entry>The frontend supports turbo FEC modulation</entry>
 	</row>
 	<row>
-	<entry><constant>FE_CAN_2G_MODULATION</constant></entry>
+	<entry id="FE-CAN-2G-MODULATION"><constant>FE_CAN_2G_MODULATION</constant></entry>
 	<entry>The frontend supports "2nd generation modulation" (DVB-S2/T2)></entry>
 	</row>
 	<row>
-	<entry><constant>FE_NEEDS_BENDING</constant></entry>
+	<entry id="FE-NEEDS-BENDING"><constant>FE_NEEDS_BENDING</constant></entry>
 	<entry>Not supported anymore, don't use it</entry>
 	</row>
 	<row>
-	<entry><constant>FE_CAN_RECOVER</constant></entry>
+	<entry id="FE-CAN-RECOVER"><constant>FE_CAN_RECOVER</constant></entry>
 	<entry>The frontend can recover from a cable unplug automatically</entry>
 	</row>
 	<row>
-	<entry><constant>FE_CAN_MUTE_TS</constant></entry>
+	<entry id="FE-CAN-MUTE-TS"><constant>FE_CAN_MUTE_TS</constant></entry>
 	<entry>The frontend can stop spurious TS data output</entry>
 	</row>
         </tbody>
-- 
2.4.2

