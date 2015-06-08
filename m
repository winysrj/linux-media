Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:54763 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753541AbbFHTyc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Jun 2015 15:54:32 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-doc@vger.kernel.org
Subject: [PATCH 07/26] [media] DocBook: Add entry IDs for the enums defined at dvbproperty.xml
Date: Mon,  8 Jun 2015 16:53:51 -0300
Message-Id: <6b2d76465a381d963786b72237efdce7f14ef238.1433792665.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1433792665.git.mchehab@osg.samsung.com>
References: <cover.1433792665.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1433792665.git.mchehab@osg.samsung.com>
References: <cover.1433792665.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are lots of enums that are defined at dvbproperty.

Add xrefs for each entry there. This makes the hyperlinks at
frontend.h to go directly to the right documentation.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/Documentation/DocBook/media/dvb/dvbproperty.xml b/Documentation/DocBook/media/dvb/dvbproperty.xml
index 28e306ee5827..816d5ac56164 100644
--- a/Documentation/DocBook/media/dvb/dvbproperty.xml
+++ b/Documentation/DocBook/media/dvb/dvbproperty.xml
@@ -208,46 +208,46 @@ get/set up to 64 properties. The actual meaning of each property is described on
 	</thead>
 	<tbody valign="top">
 	<row>
-	    <entry>QPSK</entry>
+	    <entry id="QPSK"><constant>QPSK</constant></entry>
 	    <entry>QPSK modulation</entry>
 	</row><row>
-	    <entry>QAM_16</entry>
+	    <entry id="QAM-16"><constant>QAM_16</constant></entry>
 	    <entry>16-QAM modulation</entry>
 	</row><row>
-	    <entry>QAM_32</entry>
+	    <entry id="QAM-32"><constant>QAM_32</constant></entry>
 	    <entry>32-QAM modulation</entry>
 	</row><row>
-	    <entry>QAM_64</entry>
+	    <entry id="QAM-64"><constant>QAM_64</constant></entry>
 	    <entry>64-QAM modulation</entry>
 	</row><row>
-	    <entry>QAM_128</entry>
+	    <entry id="QAM-128"><constant>QAM_128</constant></entry>
 	    <entry>128-QAM modulation</entry>
 	</row><row>
-	    <entry>QAM_256</entry>
+	    <entry id="QAM-256"><constant>QAM_256</constant></entry>
 	    <entry>256-QAM modulation</entry>
 	</row><row>
-	    <entry>QAM_AUTO</entry>
+	    <entry id="QAM-AUTO"><constant>QAM_AUTO</constant></entry>
 	    <entry>Autodetect QAM modulation</entry>
 	</row><row>
-	    <entry>VSB_8</entry>
+	    <entry id="VSB-8"><constant>VSB_8</constant></entry>
 	    <entry>8-VSB modulation</entry>
 	</row><row>
-	    <entry>VSB_16</entry>
+	    <entry id="VSB-16"><constant>VSB_16</constant></entry>
 	    <entry>16-VSB modulation</entry>
 	</row><row>
-	    <entry>PSK_8</entry>
+	    <entry id="PSK-8"><constant>PSK_8</constant></entry>
 	    <entry>8-PSK modulation</entry>
 	</row><row>
-	    <entry>APSK_16</entry>
+	    <entry id="APSK-16"><constant>APSK_16</constant></entry>
 	    <entry>16-APSK modulation</entry>
 	</row><row>
-	    <entry>APSK_32</entry>
+	    <entry id="APSK-32"><constant>APSK_32</constant></entry>
 	    <entry>32-APSK modulation</entry>
 	</row><row>
-	    <entry>DQPSK</entry>
+	    <entry id="DQPSK"><constant>DQPSK</constant></entry>
 	    <entry>DQPSK modulation</entry>
 	</row><row>
-	    <entry>QAM_4_NR</entry>
+	    <entry id="QAM-4-NR"><constant>QAM_4_NR</constant></entry>
 	    <entry>4-QAM-NR modulation</entry>
 	</row>
         </tbody>
@@ -309,13 +309,13 @@ get/set up to 64 properties. The actual meaning of each property is described on
 	</thead>
 	<tbody valign="top">
 	<row>
-	    <entry>INVERSION_OFF</entry>
+	    <entry id="INVERSION-OFF"><constant>INVERSION_OFF</constant></entry>
 	    <entry>Don't do spectral band inversion.</entry>
 	</row><row>
-	    <entry>INVERSION_ON</entry>
+	    <entry id="INVERSION-ON"><constant>INVERSION_ON</constant></entry>
 	    <entry>Do spectral band inversion.</entry>
 	</row><row>
-	    <entry>INVERSION_AUTO</entry>
+	    <entry id="INVERSION-AUTO"><constant>INVERSION_AUTO</constant></entry>
 	    <entry>Autodetect spectral band inversion.</entry>
 	</row>
         </tbody>
@@ -351,48 +351,48 @@ get/set up to 64 properties. The actual meaning of each property is described on
 	</thead>
 	<tbody valign="top">
 	<row>
-	    <entry>TRANSMISSION_MODE_AUTO</entry>
+	    <entry id="TRANSMISSION-MODE-AUTO"><constant>TRANSMISSION_MODE_AUTO</constant></entry>
 	    <entry>Autodetect transmission mode. The hardware will try to find
 		the correct FFT-size (if capable) to fill in the missing
 		parameters.</entry>
 	</row><row>
-	    <entry>FEC_NONE</entry>
+	    <entry id="FEC-NONE"><constant>FEC_NONE</constant></entry>
 	    <entry>No Forward Error Correction Code</entry>
 	</row><row>
-	    <entry>FEC_AUTO</entry>
+	    <entry id="FEC-AUTO"><constant>FEC_AUTO</constant></entry>
 	    <entry>Autodetect Error Correction Code</entry>
 	</row><row>
-	    <entry>FEC_1_2</entry>
+	    <entry id="FEC-1-2"><constant>FEC_1_2</constant></entry>
 	    <entry>Forward Error Correction Code 1/2</entry>
 	</row><row>
-	    <entry>FEC_2_3</entry>
+	    <entry id="FEC-2-3"><constant>FEC_2_3</constant></entry>
 	    <entry>Forward Error Correction Code 2/3</entry>
 	</row><row>
-	    <entry>FEC_3_4</entry>
+	    <entry id="FEC-3-4"><constant>FEC_3_4</constant></entry>
 	    <entry>Forward Error Correction Code 3/4</entry>
 	</row><row>
-	    <entry>FEC_4_5</entry>
+	    <entry id="FEC-4-5"><constant>FEC_4_5</constant></entry>
 	    <entry>Forward Error Correction Code 4/5</entry>
 	</row><row>
-	    <entry>FEC_5_6</entry>
+	    <entry id="FEC-5-6"><constant>FEC_5_6</constant></entry>
 	    <entry>Forward Error Correction Code 5/6</entry>
 	</row><row>
-	    <entry>FEC_6_7</entry>
+	    <entry id="FEC-6-7"><constant>FEC_6_7</constant></entry>
 	    <entry>Forward Error Correction Code 6/7</entry>
 	</row><row>
-	    <entry>FEC_7_8</entry>
+	    <entry id="FEC-7-8"><constant>FEC_7_8</constant></entry>
 	    <entry>Forward Error Correction Code 7/8</entry>
 	</row><row>
-	    <entry>FEC_8_9</entry>
+	    <entry id="FEC-8-9"><constant>FEC_8_9</constant></entry>
 	    <entry>Forward Error Correction Code 8/9</entry>
 	</row><row>
-	    <entry>FEC_9_10</entry>
+	    <entry id="FEC-9-10"><constant>FEC_9_10</constant></entry>
 	    <entry>Forward Error Correction Code 9/10</entry>
 	</row><row>
-	    <entry>FEC_2_5</entry>
+	    <entry id="FEC-2-5"><constant>FEC_2_5</constant></entry>
 	    <entry>Forward Error Correction Code 2/5</entry>
 	</row><row>
-	    <entry>FEC_3_5</entry>
+	    <entry id="FEC-3-5"><constant>FEC_3_5</constant></entry>
 	    <entry>Forward Error Correction Code 3/5</entry>
 	</row>
         </tbody>
@@ -879,37 +879,37 @@ typedef enum atscmh_sccc_code_mode {
 	</thead>
 	<tbody valign="top">
 	<row>
-	    <entry>GUARD_INTERVAL_AUTO</entry>
+	    <entry id="GUARD-INTERVAL-AUTO"><constant>GUARD_INTERVAL_AUTO</constant></entry>
 	    <entry>Autodetect the guard interval</entry>
 	</row><row>
-	    <entry>GUARD_INTERVAL_1_128</entry>
+	    <entry id="GUARD-INTERVAL-1-128"><constant>GUARD_INTERVAL_1_128</constant></entry>
 	    <entry>Guard interval 1/128</entry>
 	</row><row>
-	    <entry>GUARD_INTERVAL_1_32</entry>
+	    <entry id="GUARD-INTERVAL-1-32"><constant>GUARD_INTERVAL_1_32</constant></entry>
 	    <entry>Guard interval 1/32</entry>
 	</row><row>
-	    <entry>GUARD_INTERVAL_1_16</entry>
+	    <entry id="GUARD-INTERVAL-1-16"><constant>GUARD_INTERVAL_1_16</constant></entry>
 	    <entry>Guard interval 1/16</entry>
 	</row><row>
-	    <entry>GUARD_INTERVAL_1_8</entry>
+	    <entry id="GUARD-INTERVAL-1-8"><constant>GUARD_INTERVAL_1_8</constant></entry>
 	    <entry>Guard interval 1/8</entry>
 	</row><row>
-	    <entry>GUARD_INTERVAL_1_4</entry>
+	    <entry id="GUARD-INTERVAL-1-4"><constant>GUARD_INTERVAL_1_4</constant></entry>
 	    <entry>Guard interval 1/4</entry>
 	</row><row>
-	    <entry>GUARD_INTERVAL_19_128</entry>
+	    <entry id="GUARD-INTERVAL-19-128"><constant>GUARD_INTERVAL_19_128</constant></entry>
 	    <entry>Guard interval 19/128</entry>
 	</row><row>
-	    <entry>GUARD_INTERVAL_19_256</entry>
+	    <entry id="GUARD-INTERVAL-19-256"><constant>GUARD_INTERVAL_19_256</constant></entry>
 	    <entry>Guard interval 19/256</entry>
 	</row><row>
-	    <entry>GUARD_INTERVAL_PN420</entry>
+	    <entry id="GUARD-INTERVAL-PN420"><constant>GUARD_INTERVAL_PN420</constant></entry>
 	    <entry>PN length 420 (1/4)</entry>
 	</row><row>
-	    <entry>GUARD_INTERVAL_PN595</entry>
+	    <entry id="GUARD-INTERVAL-PN595"><constant>GUARD_INTERVAL_PN595</constant></entry>
 	    <entry>PN length 595 (1/6)</entry>
 	</row><row>
-	    <entry>GUARD_INTERVAL_PN945</entry>
+	    <entry id="GUARD-INTERVAL-PN945"><constant>GUARD_INTERVAL_PN945</constant></entry>
 	    <entry>PN length 945 (1/9)</entry>
 	</row>
         </tbody>
@@ -946,33 +946,33 @@ typedef enum atscmh_sccc_code_mode {
 	</thead>
 	<tbody valign="top">
 	<row>
-	    <entry>TRANSMISSION_MODE_AUTO</entry>
+	    <entry id="TRANSMISSION-MODE-AUTO"><constant>TRANSMISSION_MODE_AUTO</constant></entry>
 	    <entry>Autodetect transmission mode. The hardware will try to find
 		the correct FFT-size (if capable) to fill in the missing
 		parameters.</entry>
 	</row><row>
-	    <entry>TRANSMISSION_MODE_1K</entry>
+	    <entry id="TRANSMISSION-MODE-1K"><constant>TRANSMISSION_MODE_1K</constant></entry>
 	    <entry>Transmission mode 1K</entry>
 	</row><row>
-	    <entry>TRANSMISSION_MODE_2K</entry>
+	    <entry id="TRANSMISSION-MODE-2K"><constant>TRANSMISSION_MODE_2K</constant></entry>
 	    <entry>Transmission mode 2K</entry>
 	</row><row>
-	    <entry>TRANSMISSION_MODE_8K</entry>
+	    <entry id="TRANSMISSION-MODE-8K"><constant>TRANSMISSION_MODE_8K</constant></entry>
 	    <entry>Transmission mode 8K</entry>
 	</row><row>
-	    <entry>TRANSMISSION_MODE_4K</entry>
+	    <entry id="TRANSMISSION-MODE-4K"><constant>TRANSMISSION_MODE_4K</constant></entry>
 	    <entry>Transmission mode 4K</entry>
 	</row><row>
-	    <entry>TRANSMISSION_MODE_16K</entry>
+	    <entry id="TRANSMISSION-MODE-16K"><constant>TRANSMISSION_MODE_16K</constant></entry>
 	    <entry>Transmission mode 16K</entry>
 	</row><row>
-	    <entry>TRANSMISSION_MODE_32K</entry>
+	    <entry id="TRANSMISSION-MODE-32K"><constant>TRANSMISSION_MODE_32K</constant></entry>
 	    <entry>Transmission mode 32K</entry>
 	</row><row>
-	    <entry>TRANSMISSION_MODE_C1</entry>
+	    <entry id="TRANSMISSION-MODE-C1"><constant>TRANSMISSION_MODE_C1</constant></entry>
 	    <entry>Single Carrier (C=1) transmission mode (DTMB)</entry>
 	</row><row>
-	    <entry>TRANSMISSION_MODE_C3780</entry>
+	    <entry id="TRANSMISSION-MODE-C3780"><constant>TRANSMISSION_MODE_C3780</constant></entry>
 	    <entry>Multi Carrier (C=3780) transmission mode (DTMB)</entry>
 	</row>
         </tbody>
@@ -1012,19 +1012,19 @@ typedef enum atscmh_sccc_code_mode {
 	</thead>
 	<tbody valign="top">
 	<row>
-	     <entry>HIERARCHY_NONE</entry>
+	     <entry id="HIERARCHY-NONE"><constant>HIERARCHY_NONE</constant></entry>
 	    <entry>No hierarchy</entry>
 	</row><row>
-	     <entry>HIERARCHY_AUTO</entry>
+	     <entry id="HIERARCHY-AUTO"><constant>HIERARCHY_AUTO</constant></entry>
 	    <entry>Autodetect hierarchy (if supported)</entry>
 	</row><row>
-	     <entry>HIERARCHY_1</entry>
+	     <entry id="HIERARCHY-1"><constant>HIERARCHY_1</constant></entry>
 	    <entry>Hierarchy 1</entry>
 	</row><row>
-	     <entry>HIERARCHY_2</entry>
+	     <entry id="HIERARCHY-2"><constant>HIERARCHY_2</constant></entry>
 	    <entry>Hierarchy 2</entry>
 	</row><row>
-	     <entry>HIERARCHY_4</entry>
+	     <entry id="HIERARCHY-4"><constant>HIERARCHY_4</constant></entry>
 	    <entry>Hierarchy 4</entry>
 	</row>
         </tbody>
@@ -1117,10 +1117,10 @@ enum fe_interleaving {
 			and <constant>uvalue</constant> is for unsigned values (counters, relative scale)</para></listitem>
 		<listitem><para><constant>scale</constant> - Scale for the value. It can be:</para>
 			<itemizedlist mark='bullet' id="fecap-scale-params">
-				<listitem><para><constant>FE_SCALE_NOT_AVAILABLE</constant> - The parameter is supported by the frontend, but it was not possible to collect it (could be a transitory or permanent condition)</para></listitem>
-				<listitem><para><constant>FE_SCALE_DECIBEL</constant> - parameter is a signed value, measured in 1/1000 dB</para></listitem>
-				<listitem><para><constant>FE_SCALE_RELATIVE</constant> - parameter is a unsigned value, where 0 means 0% and 65535 means 100%.</para></listitem>
-				<listitem><para><constant>FE_SCALE_COUNTER</constant> - parameter is a unsigned value that counts the occurrence of an event, like bit error, block error, or lapsed time.</para></listitem>
+				<listitem id="FE-SCALE-NOT-AVAILABLE"><para><constant>FE_SCALE_NOT_AVAILABLE</constant> - The parameter is supported by the frontend, but it was not possible to collect it (could be a transitory or permanent condition)</para></listitem>
+				<listitem id="FE-SCALE-DECIBEL"><para><constant>FE_SCALE_DECIBEL</constant> - parameter is a signed value, measured in 1/1000 dB</para></listitem>
+				<listitem id="FE-SCALE-RELATIVE"><para><constant>FE_SCALE_RELATIVE</constant> - parameter is a unsigned value, where 0 means 0% and 65535 means 100%.</para></listitem>
+				<listitem id="FE-SCALE-COUNTER"><para><constant>FE_SCALE_COUNTER</constant> - parameter is a unsigned value that counts the occurrence of an event, like bit error, block error, or lapsed time.</para></listitem>
 			</itemizedlist>
 		</listitem>
 	</itemizedlist>
-- 
2.4.2

