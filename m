Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:2215 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751660Ab1FHUZT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 8 Jun 2011 16:25:19 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p58KPJbd012496
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 8 Jun 2011 16:25:19 -0400
Received: from pedra (vpn-10-126.rdu.redhat.com [10.11.10.126])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id p58KP4Ul024316
	for <linux-media@vger.kernel.org>; Wed, 8 Jun 2011 16:25:18 -0400
Date: Wed, 8 Jun 2011 17:23:06 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 09/13] [media] DocBook/demux.xml: Add the remaining data
 structures to the API spec
Message-ID: <20110608172306.0a903f02@pedra>
In-Reply-To: <cover.1307563765.git.mchehab@redhat.com>
References: <cover.1307563765.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Still, there are a few ioctl's not documented:

Error: no ID for constraint linkend: DMX_GET_PES_PIDS.
Error: no ID for constraint linkend: DMX_GET_CAPS.
Error: no ID for constraint linkend: DMX_SET_SOURCE.
Error: no ID for constraint linkend: DMX_ADD_PID.
Error: no ID for constraint linkend: DMX_REMOVE_PID.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/Documentation/DocBook/media/dvb/demux.xml b/Documentation/DocBook/media/dvb/demux.xml
index a297f0a..6758739 100644
--- a/Documentation/DocBook/media/dvb/demux.xml
+++ b/Documentation/DocBook/media/dvb/demux.xml
@@ -135,17 +135,42 @@ struct dmx_pes_filter_params
 
 <section id="dmx-stc">
 <title>struct dmx_stc</title>
- <programlisting>
+<programlisting>
 struct dmx_stc {
 	unsigned int num;	/&#x22C6; input : which STC? 0..N &#x22C6;/
 	unsigned int base;	/&#x22C6; output: divisor for stc to get 90 kHz clock &#x22C6;/
 	__u64 stc;		/&#x22C6; output: stc in 'base'&#x22C6;90 kHz units &#x22C6;/
 };
 </programlisting>
- </section>
+</section>
+
+<section id="dmx-caps">
+<title>struct dmx_caps</title>
+<programlisting>
+ typedef struct dmx_caps {
+	__u32 caps;
+	int num_decoders;
+} dmx_caps_t;
+</programlisting>
+</section>
 
+<section id="dmx-source-t">
+<title>enum dmx_source_t</title>
+<programlisting>
+typedef enum {
+	DMX_SOURCE_FRONT0 = 0,
+	DMX_SOURCE_FRONT1,
+	DMX_SOURCE_FRONT2,
+	DMX_SOURCE_FRONT3,
+	DMX_SOURCE_DVR0   = 16,
+	DMX_SOURCE_DVR1,
+	DMX_SOURCE_DVR2,
+	DMX_SOURCE_DVR3
+} dmx_source_t;
+</programlisting>
 </section>
 
+</section>
 <section id="dmx_fcalls">
 <title>Demux Function Calls</title>
 
-- 
1.7.1


