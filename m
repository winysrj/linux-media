Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.dream-property.net ([82.149.226.172]:40725 "EHLO
	mail.dream-property.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753545Ab1ICR0o (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 3 Sep 2011 13:26:44 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail.dream-property.net (Postfix) with ESMTP id 3CBED3153E1E
	for <linux-media@vger.kernel.org>; Sat,  3 Sep 2011 19:26:42 +0200 (CEST)
Received: from mail.dream-property.net ([127.0.0.1])
	by localhost (mail.dream-property.net [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id bD+ZJ2vHmbcM for <linux-media@vger.kernel.org>;
	Sat,  3 Sep 2011 19:26:35 +0200 (CEST)
Received: from pepe.dream-property.nete (dreamboxupdate.com [82.149.226.174])
	by mail.dream-property.net (Postfix) with SMTP id 459E13153E1C
	for <linux-media@vger.kernel.org>; Sat,  3 Sep 2011 19:26:34 +0200 (CEST)
From: Andreas Oberritter <obi@linuxtv.org>
To: linux-media@vger.kernel.org
Subject: [PATCH 1/2] DVB: improve documentation for satellite delivery systems
Date: Sat,  3 Sep 2011 17:26:33 +0000
Message-Id: <1315070794-6323-1-git-send-email-obi@linuxtv.org>
In-Reply-To: <4E625385.4050008@redhat.com>
References: <4E625385.4050008@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

- Move voltage and tone to DVB-S.
- Add turbo code.
- In DVB-S2 and turbo code sections, refer to DVB-S, as both
  are extensions to DVB-S.
- Add modulation to DVB-S2.

Signed-off-by: Andreas Oberritter <obi@linuxtv.org>
---
 Documentation/DocBook/media/dvb/dvbproperty.xml |   23 +++++++++--------------
 1 files changed, 9 insertions(+), 14 deletions(-)

diff --git a/Documentation/DocBook/media/dvb/dvbproperty.xml b/Documentation/DocBook/media/dvb/dvbproperty.xml
index 75bea04..3bc8a61 100644
--- a/Documentation/DocBook/media/dvb/dvbproperty.xml
+++ b/Documentation/DocBook/media/dvb/dvbproperty.xml
@@ -810,6 +810,8 @@ typedef enum fe_hierarchy {
 			<listitem><para><link linkend="DTV-INVERSION"><constant>DTV_INVERSION</constant></link></para></listitem>
 			<listitem><para><link linkend="DTV-SYMBOL-RATE"><constant>DTV_SYMBOL_RATE</constant></link></para></listitem>
 			<listitem><para><link linkend="DTV-INNER-FEC"><constant>DTV_INNER_FEC</constant></link></para></listitem>
+			<listitem><para><link linkend="DTV-VOLTAGE"><constant>DTV_VOLTAGE</constant></link></para></listitem>
+			<listitem><para><link linkend="DTV-TONE"><constant>DTV_TONE</constant></link></para></listitem>
 		</itemizedlist>
 		<para>Future implementations might add those two missing parameters:</para>
 		<itemizedlist mark='opencircle'>
@@ -819,25 +821,18 @@ typedef enum fe_hierarchy {
 	</section>
 	<section id="dvbs2-params">
 		<title>DVB-S2 delivery system</title>
-		<para>The following parameters are valid for DVB-S2:</para>
+		<para>In addition to all parameters valid for DVB-S, DVB-S2 supports the following parameters:</para>
 		<itemizedlist mark='opencircle'>
-			<listitem><para><link linkend="DTV-API-VERSION"><constant>DTV_API_VERSION</constant></link></para></listitem>
-			<listitem><para><link linkend="DTV-DELIVERY-SYSTEM"><constant>DTV_DELIVERY_SYSTEM</constant></link></para></listitem>
-			<listitem><para><link linkend="DTV-TUNE"><constant>DTV_TUNE</constant></link></para></listitem>
-			<listitem><para><link linkend="DTV-CLEAR"><constant>DTV_CLEAR</constant></link></para></listitem>
-			<listitem><para><link linkend="DTV-FREQUENCY"><constant>DTV_FREQUENCY</constant></link></para></listitem>
-			<listitem><para><link linkend="DTV-INVERSION"><constant>DTV_INVERSION</constant></link></para></listitem>
-			<listitem><para><link linkend="DTV-SYMBOL-RATE"><constant>DTV_SYMBOL_RATE</constant></link></para></listitem>
-			<listitem><para><link linkend="DTV-INNER-FEC"><constant>DTV_INNER_FEC</constant></link></para></listitem>
-			<listitem><para><link linkend="DTV-VOLTAGE"><constant>DTV_VOLTAGE</constant></link></para></listitem>
-			<listitem><para><link linkend="DTV-TONE"><constant>DTV_TONE</constant></link></para></listitem>
+			<listitem><para><link linkend="DTV-MODULATION"><constant>DTV_MODULATION</constant></link></para></listitem>
 			<listitem><para><link linkend="DTV-PILOT"><constant>DTV_PILOT</constant></link></para></listitem>
 			<listitem><para><link linkend="DTV-ROLLOFF"><constant>DTV_ROLLOFF</constant></link></para></listitem>
 		</itemizedlist>
-		<para>Future implementations might add those two missing parameters:</para>
+	</section>
+	<section id="turbo-params">
+		<title>Turbo code delivery system</title>
+		<para>In addition to all parameters valid for DVB-S, turbo code supports the following parameters:</para>
 		<itemizedlist mark='opencircle'>
-			<listitem><para><link linkend="DTV-DISEQC-MASTER"><constant>DTV_DISEQC_MASTER</constant></link></para></listitem>
-			<listitem><para><link linkend="DTV-DISEQC-SLAVE-REPLY"><constant>DTV_DISEQC_SLAVE_REPLY</constant></link></para></listitem>
+			<listitem><para><link linkend="DTV-MODULATION"><constant>DTV_MODULATION</constant></link></para></listitem>
 		</itemizedlist>
 	</section>
 	<section id="isdbs-params">
-- 
1.7.2.5

