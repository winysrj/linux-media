Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:4731 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752938Ab3CRQin (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Mar 2013 12:38:43 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Ezequiel Garcia <elezegarcia@gmail.com>,
	Frank Schaefer <fschaefer.oss@googlemail.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 5/6] DocBook media: fix syntax problems in dvbproperty.xml
Date: Mon, 18 Mar 2013 17:38:19 +0100
Message-Id: <1363624700-29270-6-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1363624700-29270-1-git-send-email-hverkuil@xs4all.nl>
References: <1363624700-29270-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Caught by xmllint.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/DocBook/media/dvb/dvbproperty.xml |   46 +++++++++++------------
 1 file changed, 22 insertions(+), 24 deletions(-)

diff --git a/Documentation/DocBook/media/dvb/dvbproperty.xml b/Documentation/DocBook/media/dvb/dvbproperty.xml
index 4a5eaee..341b3f0 100644
--- a/Documentation/DocBook/media/dvb/dvbproperty.xml
+++ b/Documentation/DocBook/media/dvb/dvbproperty.xml
@@ -903,14 +903,12 @@ enum fe_interleaving {
 			<constant>svalue</constant> is for signed values of the measure (dB measures)
 			and <constant>uvalue</constant> is for unsigned values (counters, relative scale)</para></listitem>
 		<listitem><para><constant>scale</constant> - Scale for the value. It can be:</para>
-			<section id = "fecap-scale-params">
-			<itemizedlist mark='bullet'>
+			<itemizedlist mark='bullet' id="fecap-scale-params">
 				<listitem><para><constant>FE_SCALE_NOT_AVAILABLE</constant> - The parameter is supported by the frontend, but it was not possible to collect it (could be a transitory or permanent condition)</para></listitem>
 				<listitem><para><constant>FE_SCALE_DECIBEL</constant> - parameter is a signed value, measured in 1/1000 dB</para></listitem>
 				<listitem><para><constant>FE_SCALE_RELATIVE</constant> - parameter is a unsigned value, where 0 means 0% and 65535 means 100%.</para></listitem>
 				<listitem><para><constant>FE_SCALE_COUNTER</constant> - parameter is a unsigned value that counts the occurrence of an event, like bit error, block error, or lapsed time.</para></listitem>
 			</itemizedlist>
-			</section>
 		</listitem>
 	</itemizedlist>
 	<section id="DTV-STAT-SIGNAL-STRENGTH">
@@ -918,9 +916,9 @@ enum fe_interleaving {
 		<para>Indicates the signal strength level at the analog part of the tuner or of the demod.</para>
 		<para>Possible scales for this metric are:</para>
 		<itemizedlist mark='bullet'>
-			<listitem><constant>FE_SCALE_NOT_AVAILABLE</constant> - it failed to measure it, or the measurement was not complete yet.</listitem>
-			<listitem><constant>FE_SCALE_DECIBEL</constant> - signal strength is in 0.0001 dBm units, power measured in miliwatts. This value is generally negative.</listitem>
-			<listitem><constant>FE_SCALE_RELATIVE</constant> - The frontend provides a 0% to 100% measurement for power (actually, 0 to 65535).</listitem>
+			<listitem><para><constant>FE_SCALE_NOT_AVAILABLE</constant> - it failed to measure it, or the measurement was not complete yet.</para></listitem>
+			<listitem><para><constant>FE_SCALE_DECIBEL</constant> - signal strength is in 0.0001 dBm units, power measured in miliwatts. This value is generally negative.</para></listitem>
+			<listitem><para><constant>FE_SCALE_RELATIVE</constant> - The frontend provides a 0% to 100% measurement for power (actually, 0 to 65535).</para></listitem>
 		</itemizedlist>
 	</section>
 	<section id="DTV-STAT-CNR">
@@ -928,9 +926,9 @@ enum fe_interleaving {
 		<para>Indicates the Signal to Noise ratio for the main carrier.</para>
 		<para>Possible scales for this metric are:</para>
 		<itemizedlist mark='bullet'>
-			<listitem><constant>FE_SCALE_NOT_AVAILABLE</constant> - it failed to measure it, or the measurement was not complete yet.</listitem>
-			<listitem><constant>FE_SCALE_DECIBEL</constant> - Signal/Noise ratio is in 0.0001 dB units.</listitem>
-			<listitem><constant>FE_SCALE_RELATIVE</constant> - The frontend provides a 0% to 100% measurement for Signal/Noise (actually, 0 to 65535).</listitem>
+			<listitem><para><constant>FE_SCALE_NOT_AVAILABLE</constant> - it failed to measure it, or the measurement was not complete yet.</para></listitem>
+			<listitem><para><constant>FE_SCALE_DECIBEL</constant> - Signal/Noise ratio is in 0.0001 dB units.</para></listitem>
+			<listitem><para><constant>FE_SCALE_RELATIVE</constant> - The frontend provides a 0% to 100% measurement for Signal/Noise (actually, 0 to 65535).</para></listitem>
 		</itemizedlist>
 	</section>
 	<section id="DTV-STAT-PRE-ERROR-BIT-COUNT">
@@ -943,8 +941,8 @@ enum fe_interleaving {
 		      The frontend may reset it when a channel/transponder is tuned.</para>
 		<para>Possible scales for this metric are:</para>
 		<itemizedlist mark='bullet'>
-			<listitem><constant>FE_SCALE_NOT_AVAILABLE</constant> - it failed to measure it, or the measurement was not complete yet.</listitem>
-			<listitem><constant>FE_SCALE_COUNTER</constant> - Number of error bits counted before the inner coding.</listitem>
+			<listitem><para><constant>FE_SCALE_NOT_AVAILABLE</constant> - it failed to measure it, or the measurement was not complete yet.</para></listitem>
+			<listitem><para><constant>FE_SCALE_COUNTER</constant> - Number of error bits counted before the inner coding.</para></listitem>
 		</itemizedlist>
 	</section>
 	<section id="DTV-STAT-PRE-TOTAL-BIT-COUNT">
@@ -957,9 +955,9 @@ enum fe_interleaving {
 		      The frontend may reset it when a channel/transponder is tuned.</para>
 		<para>Possible scales for this metric are:</para>
 		<itemizedlist mark='bullet'>
-			<listitem><constant>FE_SCALE_NOT_AVAILABLE</constant> - it failed to measure it, or the measurement was not complete yet.</listitem>
-			<listitem><constant>FE_SCALE_COUNTER</constant> - Number of bits counted while measuring
-				 <link linkend="DTV-STAT-PRE-ERROR-BIT-COUNT"><constant>DTV_STAT_PRE_ERROR_BIT_COUNT</constant></link>.</listitem>
+			<listitem><para><constant>FE_SCALE_NOT_AVAILABLE</constant> - it failed to measure it, or the measurement was not complete yet.</para></listitem>
+			<listitem><para><constant>FE_SCALE_COUNTER</constant> - Number of bits counted while measuring
+				 <link linkend="DTV-STAT-PRE-ERROR-BIT-COUNT"><constant>DTV_STAT_PRE_ERROR_BIT_COUNT</constant></link>.</para></listitem>
 		</itemizedlist>
 	</section>
 	<section id="DTV-STAT-POST-ERROR-BIT-COUNT">
@@ -972,8 +970,8 @@ enum fe_interleaving {
 		      The frontend may reset it when a channel/transponder is tuned.</para>
 		<para>Possible scales for this metric are:</para>
 		<itemizedlist mark='bullet'>
-			<listitem><constant>FE_SCALE_NOT_AVAILABLE</constant> - it failed to measure it, or the measurement was not complete yet.</listitem>
-			<listitem><constant>FE_SCALE_COUNTER</constant> - Number of error bits counted after the inner coding.</listitem>
+			<listitem><para><constant>FE_SCALE_NOT_AVAILABLE</constant> - it failed to measure it, or the measurement was not complete yet.</para></listitem>
+			<listitem><para><constant>FE_SCALE_COUNTER</constant> - Number of error bits counted after the inner coding.</para></listitem>
 		</itemizedlist>
 	</section>
 	<section id="DTV-STAT-POST-TOTAL-BIT-COUNT">
@@ -986,9 +984,9 @@ enum fe_interleaving {
 		      The frontend may reset it when a channel/transponder is tuned.</para>
 		<para>Possible scales for this metric are:</para>
 		<itemizedlist mark='bullet'>
-			<listitem><constant>FE_SCALE_NOT_AVAILABLE</constant> - it failed to measure it, or the measurement was not complete yet.</listitem>
-			<listitem><constant>FE_SCALE_COUNTER</constant> - Number of bits counted while measuring
-				 <link linkend="DTV-STAT-POST-ERROR-BIT-COUNT"><constant>DTV_STAT_POST_ERROR_BIT_COUNT</constant></link>.</listitem>
+			<listitem><para><constant>FE_SCALE_NOT_AVAILABLE</constant> - it failed to measure it, or the measurement was not complete yet.</para></listitem>
+			<listitem><para><constant>FE_SCALE_COUNTER</constant> - Number of bits counted while measuring
+				 <link linkend="DTV-STAT-POST-ERROR-BIT-COUNT"><constant>DTV_STAT_POST_ERROR_BIT_COUNT</constant></link>.</para></listitem>
 		</itemizedlist>
 	</section>
 	<section id="DTV-STAT-ERROR-BLOCK-COUNT">
@@ -998,8 +996,8 @@ enum fe_interleaving {
 		      The frontend may reset it when a channel/transponder is tuned.</para>
 		<para>Possible scales for this metric are:</para>
 		<itemizedlist mark='bullet'>
-			<listitem><constant>FE_SCALE_NOT_AVAILABLE</constant> - it failed to measure it, or the measurement was not complete yet.</listitem>
-			<listitem><constant>FE_SCALE_COUNTER</constant> - Number of error blocks counted after the outer coding.</listitem>
+			<listitem><para><constant>FE_SCALE_NOT_AVAILABLE</constant> - it failed to measure it, or the measurement was not complete yet.</para></listitem>
+			<listitem><para><constant>FE_SCALE_COUNTER</constant> - Number of error blocks counted after the outer coding.</para></listitem>
 		</itemizedlist>
 	</section>
 	<section id="DTV-STAT-TOTAL-BLOCK-COUNT">
@@ -1011,9 +1009,9 @@ enum fe_interleaving {
 		by <link linkend="DTV-STAT-TOTAL-BLOCK-COUNT"><constant>DTV-STAT-TOTAL-BLOCK-COUNT</constant></link>.</para>
 		<para>Possible scales for this metric are:</para>
 		<itemizedlist mark='bullet'>
-			<listitem><constant>FE_SCALE_NOT_AVAILABLE</constant> - it failed to measure it, or the measurement was not complete yet.</listitem>
-			<listitem><constant>FE_SCALE_COUNTER</constant> - Number of blocks counted while measuring
-			<link linkend="DTV-STAT-ERROR-BLOCK-COUNT"><constant>DTV_STAT_ERROR_BLOCK_COUNT</constant></link>.</listitem>
+			<listitem><para><constant>FE_SCALE_NOT_AVAILABLE</constant> - it failed to measure it, or the measurement was not complete yet.</para></listitem>
+			<listitem><para><constant>FE_SCALE_COUNTER</constant> - Number of blocks counted while measuring
+			<link linkend="DTV-STAT-ERROR-BLOCK-COUNT"><constant>DTV_STAT_ERROR_BLOCK_COUNT</constant></link>.</para></listitem>
 		</itemizedlist>
 	</section>
 	</section>
-- 
1.7.10.4

