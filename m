Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:58934 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752832Ab1FHBp4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 7 Jun 2011 21:45:56 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p581jtjr030482
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 7 Jun 2011 21:45:56 -0400
Received: from pedra (vpn-236-210.phx2.redhat.com [10.3.236.210])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id p581jnc5007506
	for <linux-media@vger.kernel.org>; Tue, 7 Jun 2011 21:45:55 -0400
Date: Tue, 7 Jun 2011 22:45:32 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 04/15] [media] DocBook/frontend.xml: Correlate dvb delivery
 systems
Message-ID: <20110607224532.006e426e@pedra>
In-Reply-To: <cover.1307496835.git.mchehab@redhat.com>
References: <cover.1307496835.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

As the DVB API provides two ways to specify the delivery
systems, correlate both ways into a table.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/Documentation/DocBook/media/dvb/frontend.xml b/Documentation/DocBook/media/dvb/frontend.xml
index b52f66a..65a790e 100644
--- a/Documentation/DocBook/media/dvb/frontend.xml
+++ b/Documentation/DocBook/media/dvb/frontend.xml
@@ -23,40 +23,45 @@ cards, in which case there exists no frontend device.</para>
 <section id="fe-type-t">
 <title>Frontend type</title>
 
-<para>For historical reasons frontend types are named after the type of modulation used in
+<para>For historical reasons, frontend types are named by the type of modulation used in
 transmission. The fontend types are given by fe_type_t type, defined as:</para>
 
 <table pgwide="1" frame="none" id="fe-type">
 <title>Frontend types</title>
-<tgroup cols="2">
+<tgroup cols="3">
    &cs-def;
    <thead>
      <row>
        <entry>fe_type</entry>
        <entry>Description</entry>
+       <entry><link linkend="DTV-DELIVERY-SYSTEM">DTV_DELIVERY_SYSTEM</link> equivalent type</entry>
      </row>
   </thead>
   <tbody valign="top">
   <row>
      <entry id="FE_QPSK"><constant>FE_QPSK</constant></entry>
      <entry>For DVB-S standard</entry>
+     <entry><constant>SYS_DVBS</constant></entry>
   </row>
   <row>
      <entry id="FE_QAM"><constant>FE_QAM</constant></entry>
-     <entry>For DVB-C standard</entry>
+     <entry>For DVB-C annex A/C standard</entry>
+     <entry><constant>SYS_DVBC_ANNEX_AC</constant></entry>
   </row>
   <row>
      <entry id="FE_OFDM"><constant>FE_OFDM</constant></entry>
-     <entry>For DVB-T standard. Also used for ISDB-T on compatibility mode</entry>
+     <entry>For DVB-T standard</entry>
+     <entry><constant>SYS_DVBT</constant></entry>
   </row>
   <row>
      <entry id="FE_ATSC"><constant>FE_ATSC</constant></entry>
-     <entry>For ATSC standard (terrestrial or cable)</entry>
+     <entry>For ATSC standard (terrestrial) or for DVB-C Annex B (cable) used in US.</entry>
+     <entry><constant>SYS_ATSC</constant> (terrestrial) or <constant>SYS_DVBC_ANNEX_B</constant> (cable)</entry>
   </row>
 </tbody></tgroup></table>
 
 <para>Newer formats like DVB-S2, ISDB-T, ISDB-S and DVB-T2 are not described at the above, as they're
-supported via the new <link linkend="FE_GET_SET_PROPERTY">FE_GET_PROPERTY/FE_GET_SET_PROPERTY</link> method.
+supported via the new <link linkend="FE_GET_SET_PROPERTY">FE_GET_PROPERTY/FE_GET_SET_PROPERTY</link> ioctl's, using the <link linkend="DTV-DELIVERY-SYSTEM">DTV_DELIVERY_SYSTEM</link> parameter.
 </para>
 </section>
 
-- 
1.7.1


