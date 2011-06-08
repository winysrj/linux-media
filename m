Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:13760 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752832Ab1FHBpx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 7 Jun 2011 21:45:53 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p581jq33028940
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 7 Jun 2011 21:45:52 -0400
Received: from pedra (vpn-236-210.phx2.redhat.com [10.3.236.210])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id p581jnc3007506
	for <linux-media@vger.kernel.org>; Tue, 7 Jun 2011 21:45:52 -0400
Date: Tue, 7 Jun 2011 22:45:30 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 02/15] [media] DocBook/frontend.xml: Better document
 fe_type_t
Message-ID: <20110607224530.0875fbaa@pedra>
In-Reply-To: <cover.1307496835.git.mchehab@redhat.com>
References: <cover.1307496835.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The fe_type_t documentation was incomplete and not linked to the
dvb/frontend.h.xml. Properly document it.

Also, drop a note that newer formats are only supported via
FE_GET_PROPERTY/FE_GET_SET_PROPERTY ioctls.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/Documentation/DocBook/media/Makefile b/Documentation/DocBook/media/Makefile
index d9a21d3..34afc54 100644
--- a/Documentation/DocBook/media/Makefile
+++ b/Documentation/DocBook/media/Makefile
@@ -124,6 +124,7 @@ DVB_DOCUMENTED = \
 	-e "s/\(linkend\=\"\)FE_SET_PROPERTY/\1FE_GET_PROPERTY/g" \
 	-e "s,\(struct\s\+\)\([a-z0-9_]\+\)\(\s\+{\),\1\<link linkend=\"\2\">\2\<\/link\>\3,g" \
 	-e "s,\(}\s\+\)\([a-z0-9_]\+_t\+\),\1\<link linkend=\"\2\">\2\<\/link\>,g" \
+	-e ":a;s/\(linkend=\".*\)_\(.*\">\)/\1-\2/;ta" \
 #	-e "s,\(\s\+\)\(FE_[A-Z0-9_]\+\)\([\s\=\,]*\),\1\<link linkend=\"\2\">\2\<\/link\>\3,g" \
 
 #
diff --git a/Documentation/DocBook/media/dvb/frontend.xml b/Documentation/DocBook/media/dvb/frontend.xml
index 60c6976..b52f66a 100644
--- a/Documentation/DocBook/media/dvb/frontend.xml
+++ b/Documentation/DocBook/media/dvb/frontend.xml
@@ -20,19 +20,44 @@ cards, in which case there exists no frontend device.</para>
 <section id="frontend_types">
 <title>Frontend Data Types</title>
 
-<section id="frontend_type">
-<title>frontend type</title>
+<section id="fe-type-t">
+<title>Frontend type</title>
 
 <para>For historical reasons frontend types are named after the type of modulation used in
-transmission.</para>
-<programlisting>
-	typedef enum fe_type {
-	FE_QPSK,   /&#x22C6; DVB-S &#x22C6;/
-	FE_QAM,    /&#x22C6; DVB-C &#x22C6;/
-	FE_OFDM    /&#x22C6; DVB-T &#x22C6;/
-	} fe_type_t;
-</programlisting>
+transmission. The fontend types are given by fe_type_t type, defined as:</para>
 
+<table pgwide="1" frame="none" id="fe-type">
+<title>Frontend types</title>
+<tgroup cols="2">
+   &cs-def;
+   <thead>
+     <row>
+       <entry>fe_type</entry>
+       <entry>Description</entry>
+     </row>
+  </thead>
+  <tbody valign="top">
+  <row>
+     <entry id="FE_QPSK"><constant>FE_QPSK</constant></entry>
+     <entry>For DVB-S standard</entry>
+  </row>
+  <row>
+     <entry id="FE_QAM"><constant>FE_QAM</constant></entry>
+     <entry>For DVB-C standard</entry>
+  </row>
+  <row>
+     <entry id="FE_OFDM"><constant>FE_OFDM</constant></entry>
+     <entry>For DVB-T standard. Also used for ISDB-T on compatibility mode</entry>
+  </row>
+  <row>
+     <entry id="FE_ATSC"><constant>FE_ATSC</constant></entry>
+     <entry>For ATSC standard (terrestrial or cable)</entry>
+  </row>
+</tbody></tgroup></table>
+
+<para>Newer formats like DVB-S2, ISDB-T, ISDB-S and DVB-T2 are not described at the above, as they're
+supported via the new <link linkend="FE_GET_SET_PROPERTY">FE_GET_PROPERTY/FE_GET_SET_PROPERTY</link> method.
+</para>
 </section>
 
 <section id="frontend_caps">
-- 
1.7.1


