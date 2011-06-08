Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:33809 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752510Ab1FHUZQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 8 Jun 2011 16:25:16 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p58KPGKb016092
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 8 Jun 2011 16:25:16 -0400
Received: from pedra (vpn-10-126.rdu.redhat.com [10.11.10.126])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id p58KP4Uj024316
	for <linux-media@vger.kernel.org>; Wed, 8 Jun 2011 16:25:15 -0400
Date: Wed, 8 Jun 2011 17:23:04 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 07/13] [media] DocBook/ca.xml: Describe structure ca_pid
Message-ID: <20110608172304.6001886d@pedra>
In-Reply-To: <cover.1307563765.git.mchehab@redhat.com>
References: <cover.1307563765.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This is the remaining missing structure at ca.xml. The ioctl's are still
missing through.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/Documentation/DocBook/media/dvb/ca.xml b/Documentation/DocBook/media/dvb/ca.xml
index 143ec5b..a6cb952 100644
--- a/Documentation/DocBook/media/dvb/ca.xml
+++ b/Documentation/DocBook/media/dvb/ca.xml
@@ -44,7 +44,7 @@ typedef struct ca_descr_info {
 <section id="ca-caps">
 <title>ca_caps_t</title>
 <programlisting>
-typedef struct ca_cap_s {
+typedef struct ca_caps {
 	unsigned int slot_num;  /&#x22C6; total number of CA card and module slots &#x22C6;/
 	unsigned int slot_type; /&#x22C6; OR of all supported types &#x22C6;/
 	unsigned int descr_num; /&#x22C6; total number of descrambler slots (keys) &#x22C6;/
@@ -75,7 +75,18 @@ typedef struct ca_descr {
 	unsigned char cw[8];
 } ca_descr_t;
 </programlisting>
- </section></section>
+</section>
+
+<section id="ca-pid">
+<title>ca-pid</title>
+<programlisting>
+typedef struct ca_pid {
+	unsigned int pid;
+	int index;		/&#x22C6; -1 == disable&#x22C6;/
+} ca_pid_t;
+</programlisting>
+</section></section>
+
 <section id="ca_function_calls">
 <title>CA Function Calls</title>
 
-- 
1.7.1


