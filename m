Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:50850 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751576Ab1FHUZO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 8 Jun 2011 16:25:14 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p58KPE1J016036
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 8 Jun 2011 16:25:14 -0400
Received: from pedra (vpn-10-126.rdu.redhat.com [10.11.10.126])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id p58KP4Ui024316
	for <linux-media@vger.kernel.org>; Wed, 8 Jun 2011 16:25:13 -0400
Date: Wed, 8 Jun 2011 17:23:03 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 06/13] [media] Docbook/ca.xml: match section ID's with the
 reference links
Message-ID: <20110608172303.69e87fbb@pedra>
In-Reply-To: <cover.1307563765.git.mchehab@redhat.com>
References: <cover.1307563765.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Make sure that both ca.h.xml and ca.xml will match the same names for
the sections/links.

This way, it is now possible to identify API spec gaps:

Error: no ID for constraint linkend: ca-pid.
Error: no ID for constraint linkend: ca-pid.
Error: no ID for constraint linkend: CA_RESET.
Error: no ID for constraint linkend: CA_GET_CAP.
Error: no ID for constraint linkend: CA_GET_SLOT_INFO.
Error: no ID for constraint linkend: CA_GET_DESCR_INFO.
Error: no ID for constraint linkend: CA_GET_MSG.
Error: no ID for constraint linkend: CA_SEND_MSG.
Error: no ID for constraint linkend: CA_SET_DESCR.
Error: no ID for constraint linkend: CA_SET_PID.

Basically, in this case, no CA ioctl is described at the specs, and one
file structure (ca-pid) is missing.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/Documentation/DocBook/media/Makefile b/Documentation/DocBook/media/Makefile
index 18604dd..249edd3 100644
--- a/Documentation/DocBook/media/Makefile
+++ b/Documentation/DocBook/media/Makefile
@@ -150,7 +150,7 @@ DVB_DOCUMENTED = \
 	-e "s,\(define\s\+\)\(DTV_[A-Z0-9_]\+\)\(\s\+[0-9]\+\),\1\<link linkend=\"\2\">\2\<\/link\>\3,g" \
 	-e "s,<link linkend=\".*\">\(DTV_IOCTL_MAX_MSGS\|dtv_cmds_h\)<\/link>,\1,g" \
 	-e ":a;s/\(linkend=\".*\)_\(.*\">\)/\1-\2/;ta" \
-	-e "s,\(audio-mixer\|audio-karaoke\|audio-status\)-t,\1,g" \
+	-e "s,\(audio-mixer\|audio-karaoke\|audio-status\|ca-slot-info\|ca-descr-info\|ca-caps\|ca-msg\|ca-descr\|ca-pid\)-t,\1,g" \
 	-e "s,DTV-ISDBT-LAYER[A-C],DTV-ISDBT-LAYER,g" \
 	-e "s,\(define\s\+\)\([A-Z0-9_]\+\)\(\s\+_IO\),\1\<link linkend=\"\2\">\2\<\/link\>\3,g" \
 
diff --git a/Documentation/DocBook/media/dvb/ca.xml b/Documentation/DocBook/media/dvb/ca.xml
index b1f1d2f..143ec5b 100644
--- a/Documentation/DocBook/media/dvb/ca.xml
+++ b/Documentation/DocBook/media/dvb/ca.xml
@@ -8,73 +8,72 @@ including <emphasis role="tt">linux/dvb/ca.h</emphasis> in your application.
 <title>CA Data Types</title>
 
 
-<section id="ca_slot_info_t">
+<section id="ca-slot-info">
 <title>ca_slot_info_t</title>
  <programlisting>
- /&#x22C6; slot interface types and info &#x22C6;/
+typedef struct ca_slot_info {
+	int num;               /&#x22C6; slot number &#x22C6;/
 
- typedef struct ca_slot_info_s {
-	 int num;               /&#x22C6; slot number &#x22C6;/
+	int type;              /&#x22C6; CA interface this slot supports &#x22C6;/
+#define CA_CI            1     /&#x22C6; CI high level interface &#x22C6;/
+#define CA_CI_LINK       2     /&#x22C6; CI link layer level interface &#x22C6;/
+#define CA_CI_PHYS       4     /&#x22C6; CI physical layer level interface &#x22C6;/
+#define CA_DESCR         8     /&#x22C6; built-in descrambler &#x22C6;/
+#define CA_SC          128     /&#x22C6; simple smart card interface &#x22C6;/
 
-	 int type;           /&#x22C6; CA interface this slot supports &#x22C6;/
- #define CA_CI            1  /&#x22C6; CI high level interface &#x22C6;/
- #define CA_CI_LINK       2  /&#x22C6; CI link layer level interface &#x22C6;/
- #define CA_CI_PHYS       4  /&#x22C6; CI physical layer level interface &#x22C6;/
- #define CA_SC          128  /&#x22C6; simple smart card interface &#x22C6;/
-
-	 unsigned int flags;
- #define CA_CI_MODULE_PRESENT 1 /&#x22C6; module (or card) inserted &#x22C6;/
- #define CA_CI_MODULE_READY   2
- } ca_slot_info_t;
+	unsigned int flags;
+#define CA_CI_MODULE_PRESENT 1 /&#x22C6; module (or card) inserted &#x22C6;/
+#define CA_CI_MODULE_READY   2
+} ca_slot_info_t;
 </programlisting>
 
 </section>
-<section id="ca_descr_info_t">
+<section id="ca-descr-info">
 <title>ca_descr_info_t</title>
- <programlisting>
- typedef struct ca_descr_info_s {
-	 unsigned int num;  /&#x22C6; number of available descramblers (keys) &#x22C6;/
-	 unsigned int type; /&#x22C6; type of supported scrambling system &#x22C6;/
- #define CA_ECD           1
- #define CA_NDS           2
- #define CA_DSS           4
- } ca_descr_info_t;
+<programlisting>
+typedef struct ca_descr_info {
+	unsigned int num;  /&#x22C6; number of available descramblers (keys) &#x22C6;/
+	unsigned int type; /&#x22C6; type of supported scrambling system &#x22C6;/
+#define CA_ECD           1
+#define CA_NDS           2
+#define CA_DSS           4
+} ca_descr_info_t;
 </programlisting>
 
 </section>
-<section id="ca_cap_t">
-<title>ca_cap_t</title>
- <programlisting>
- typedef struct ca_cap_s {
-	 unsigned int slot_num;  /&#x22C6; total number of CA card and module slots &#x22C6;/
-	 unsigned int slot_type; /&#x22C6; OR of all supported types &#x22C6;/
-	 unsigned int descr_num; /&#x22C6; total number of descrambler slots (keys) &#x22C6;/
-	 unsigned int descr_type;/&#x22C6; OR of all supported types &#x22C6;/
+<section id="ca-caps">
+<title>ca_caps_t</title>
+<programlisting>
+typedef struct ca_cap_s {
+	unsigned int slot_num;  /&#x22C6; total number of CA card and module slots &#x22C6;/
+	unsigned int slot_type; /&#x22C6; OR of all supported types &#x22C6;/
+	unsigned int descr_num; /&#x22C6; total number of descrambler slots (keys) &#x22C6;/
+	unsigned int descr_type;/&#x22C6; OR of all supported types &#x22C6;/
  } ca_cap_t;
 </programlisting>
 
 </section>
-<section id="ca_msg_t">
+<section id="ca-msg">
 <title>ca_msg_t</title>
- <programlisting>
- /&#x22C6; a message to/from a CI-CAM &#x22C6;/
- typedef struct ca_msg_s {
-	 unsigned int index;
-	 unsigned int type;
-	 unsigned int length;
-	 unsigned char msg[256];
- } ca_msg_t;
+<programlisting>
+/&#x22C6; a message to/from a CI-CAM &#x22C6;/
+typedef struct ca_msg {
+	unsigned int index;
+	unsigned int type;
+	unsigned int length;
+	unsigned char msg[256];
+} ca_msg_t;
 </programlisting>
 
 </section>
-<section id="ca_descr_t">
+<section id="ca-descr">
 <title>ca_descr_t</title>
- <programlisting>
- typedef struct ca_descr_s {
-	 unsigned int index;
-	 unsigned int parity;
-	 unsigned char cw[8];
- } ca_descr_t;
+<programlisting>
+typedef struct ca_descr {
+	unsigned int index;
+	unsigned int parity;
+	unsigned char cw[8];
+} ca_descr_t;
 </programlisting>
  </section></section>
 <section id="ca_function_calls">
-- 
1.7.1


