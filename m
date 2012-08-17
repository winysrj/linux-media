Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:49039 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933165Ab2HQBf5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Aug 2012 21:35:57 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Hin-Tak Leung <htl10@users.sourceforge.net>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH 6/6] DVB API: LNA documentation
Date: Fri, 17 Aug 2012 04:35:10 +0300
Message-Id: <1345167310-8738-7-git-send-email-crope@iki.fi>
In-Reply-To: <1345167310-8738-1-git-send-email-crope@iki.fi>
References: <1345167310-8738-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 Documentation/DocBook/media/dvb/dvbproperty.xml | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/Documentation/DocBook/media/dvb/dvbproperty.xml b/Documentation/DocBook/media/dvb/dvbproperty.xml
index d188be9..2dfa6a0 100644
--- a/Documentation/DocBook/media/dvb/dvbproperty.xml
+++ b/Documentation/DocBook/media/dvb/dvbproperty.xml
@@ -827,6 +827,17 @@ enum fe_interleaving {
 };
 	</programlisting>
 	</section>
+	<section id="DTV-LNA">
+	<title><constant>DTV_LNA</constant></title>
+	<para>Low-noise amplifier.</para>
+	<para>Hardware might offer controllable LNA which can be set manually
+		using that parameter. Usually LNA could be found only from
+		terrestrial devices if at all.</para>
+	<para>Possible values: 0, 1, INT_MIN</para>
+	<para>0, LNA off</para>
+	<para>1, LNA on</para>
+	<para>INT_MIN, LNA auto</para>
+	</section>
 </section>
 	<section id="frontend-property-terrestrial-systems">
 	<title>Properties used on terrestrial delivery systems</title>
@@ -847,6 +858,7 @@ enum fe_interleaving {
 				<listitem><para><link linkend="DTV-GUARD-INTERVAL"><constant>DTV_GUARD_INTERVAL</constant></link></para></listitem>
 				<listitem><para><link linkend="DTV-TRANSMISSION-MODE"><constant>DTV_TRANSMISSION_MODE</constant></link></para></listitem>
 				<listitem><para><link linkend="DTV-HIERARCHY"><constant>DTV_HIERARCHY</constant></link></para></listitem>
+				<listitem><para><link linkend="DTV-LNA"><constant>DTV_LNA</constant></link></para></listitem>
 			</itemizedlist>
 		</section>
 		<section id="dvbt2-params">
@@ -870,6 +882,7 @@ enum fe_interleaving {
 			<listitem><para><link linkend="DTV-TRANSMISSION-MODE"><constant>DTV_TRANSMISSION_MODE</constant></link></para></listitem>
 			<listitem><para><link linkend="DTV-HIERARCHY"><constant>DTV_HIERARCHY</constant></link></para></listitem>
 			<listitem><para><link linkend="DTV-DVBT2-PLP-ID"><constant>DTV_DVBT2_PLP_ID</constant></link></para></listitem>
+			<listitem><para><link linkend="DTV-LNA"><constant>DTV_LNA</constant></link></para></listitem>
 		</itemizedlist>
 		</section>
 		<section id="isdbt">
@@ -981,6 +994,7 @@ enum fe_interleaving {
 				<listitem><para><link linkend="DTV-GUARD-INTERVAL"><constant>DTV_GUARD_INTERVAL</constant></link></para></listitem>
 				<listitem><para><link linkend="DTV-TRANSMISSION-MODE"><constant>DTV_TRANSMISSION_MODE</constant></link></para></listitem>
 				<listitem><para><link linkend="DTV-INTERLEAVING"><constant>DTV_INTERLEAVING</constant></link></para></listitem>
+				<listitem><para><link linkend="DTV-LNA"><constant>DTV_LNA</constant></link></para></listitem>
 			</itemizedlist>
 		</section>
 	</section>
@@ -1001,6 +1015,7 @@ enum fe_interleaving {
 			<listitem><para><link linkend="DTV-INVERSION"><constant>DTV_INVERSION</constant></link></para></listitem>
 			<listitem><para><link linkend="DTV-SYMBOL-RATE"><constant>DTV_SYMBOL_RATE</constant></link></para></listitem>
 			<listitem><para><link linkend="DTV-INNER-FEC"><constant>DTV_INNER_FEC</constant></link></para></listitem>
+			<listitem><para><link linkend="DTV-LNA"><constant>DTV_LNA</constant></link></para></listitem>
 		</itemizedlist>
 	</section>
 	<section id="dvbc-annex-b-params">
@@ -1015,6 +1030,7 @@ enum fe_interleaving {
 			<listitem><para><link linkend="DTV-FREQUENCY"><constant>DTV_FREQUENCY</constant></link></para></listitem>
 			<listitem><para><link linkend="DTV-MODULATION"><constant>DTV_MODULATION</constant></link></para></listitem>
 			<listitem><para><link linkend="DTV-INVERSION"><constant>DTV_INVERSION</constant></link></para></listitem>
+			<listitem><para><link linkend="DTV-LNA"><constant>DTV_LNA</constant></link></para></listitem>
 		</itemizedlist>
 	</section>
 	</section>
-- 
1.7.11.2

