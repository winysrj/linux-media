Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:27218 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753037Ab1FHBqL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 7 Jun 2011 21:46:11 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p581kBTG006761
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 7 Jun 2011 21:46:11 -0400
Received: from pedra (vpn-236-210.phx2.redhat.com [10.3.236.210])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id p581jncF007506
	for <linux-media@vger.kernel.org>; Tue, 7 Jun 2011 21:46:10 -0400
Date: Tue, 7 Jun 2011 22:45:41 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 14/15] [media] DocBook/dvbproperty.xml: Add ATSC standard
Message-ID: <20110607224541.58803d24@pedra>
In-Reply-To: <cover.1307496835.git.mchehab@redhat.com>
References: <cover.1307496835.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/Documentation/DocBook/media/dvb/dvbproperty.xml b/Documentation/DocBook/media/dvb/dvbproperty.xml
index 262d995..9cbb289 100644
--- a/Documentation/DocBook/media/dvb/dvbproperty.xml
+++ b/Documentation/DocBook/media/dvb/dvbproperty.xml
@@ -766,6 +766,19 @@ typedef enum fe_hierarchy {
 			<listitem><para><link linkend="DTV-ISDBT-LAYER-TIME-INTERLEAVING"><constant>DTV_ISDBT_LAYERC_TIME_INTERLEAVING</constant></link></para></listitem>
 		</itemizedlist>
 		</section>
+		<section id="atsc-params">
+			<title>ATSC delivery system</title>
+			<para>The following parameters are valid for ATSC:</para>
+			<itemizedlist mark='opencircle'>
+				<listitem><para><link linkend="DTV-API-VERSION"><constant>DTV_API_VERSION</constant></link></para></listitem>
+				<listitem><para><link linkend="DTV-DELIVERY-SYSTEM"><constant>DTV_DELIVERY_SYSTEM</constant></link></para></listitem>
+				<listitem><para><link linkend="DTV-TUNE"><constant>DTV_TUNE</constant></link></para></listitem>
+				<listitem><para><link linkend="DTV-CLEAR"><constant>DTV_CLEAR</constant></link></para></listitem>
+				<listitem><para><link linkend="DTV-FREQUENCY"><constant>DTV_FREQUENCY</constant></link></para></listitem>
+				<listitem><para><link linkend="DTV-MODULATION"><constant>DTV_MODULATION</constant></link></para></listitem>
+				<listitem><para><link linkend="DTV-BANDWIDTH-HZ"><constant>DTV_BANDWIDTH_HZ</constant></link></para></listitem>
+			</itemizedlist>
+		</section>
 	</section>
 	<section id="frontend-property-cable-systems">
 	<section id="dvbc-params">
@@ -796,8 +809,6 @@ typedef enum fe_hierarchy {
 			<listitem><para><link linkend="DTV-FREQUENCY"><constant>DTV_FREQUENCY</constant></link></para></listitem>
 			<listitem><para><link linkend="DTV-MODULATION"><constant>DTV_MODULATION</constant></link></para></listitem>
 			<listitem><para><link linkend="DTV-INVERSION"><constant>DTV_INVERSION</constant></link></para></listitem>
-			<listitem><para><link linkend="DTV-SYMBOL-RATE"><constant>DTV_SYMBOL_RATE</constant></link></para></listitem>
-			<listitem><para><link linkend="DTV-INNER-FEC"><constant>DTV_INNER_FEC</constant></link></para></listitem>
 		</itemizedlist>
 	</section>
 	<title>Properties used on cable delivery systems</title>
diff --git a/Documentation/DocBook/media/dvb/frontend.xml b/Documentation/DocBook/media/dvb/frontend.xml
index 1417d50..304d54e 100644
--- a/Documentation/DocBook/media/dvb/frontend.xml
+++ b/Documentation/DocBook/media/dvb/frontend.xml
@@ -276,7 +276,7 @@ OFDM frontends the <constant>frequency</constant> specifies the absolute frequen
 </section>
 <section id="dvb-vsb-parameters">
 <title>VSB parameters</title>
-<para>DVB-T frontends are supported by the <constant>dvb_vsb_parameters</constant> structure:</para>
+<para>ATSC frontends are supported by the <constant>dvb_vsb_parameters</constant> structure:</para>
 <programlisting>
 struct dvb_vsb_parameters {
 	fe_modulation_t modulation;	/&#x22C6; modulation type (see above) &#x22C6;/
-- 
1.7.1


