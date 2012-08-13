Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:5378 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754093Ab2HMV6g (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Aug 2012 17:58:36 -0400
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q7DLwZgl018315
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 13 Aug 2012 17:58:35 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] [media] frontend.h, Docbook: Improve status documentation
Date: Mon, 13 Aug 2012 18:58:32 -0300
Message-Id: <1344895112-32539-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

No functional changes. It just improves the description of the frontend
status, using Documentation/kernel-doc-nano-HOWTO.txt for the status
enumeration, and a table inside the DocBook.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 Documentation/DocBook/media/dvb/frontend.xml | 48 +++++++++++++++++++++-------
 include/linux/dvb/frontend.h                 | 29 +++++++++++------
 2 files changed, 57 insertions(+), 20 deletions(-)

diff --git a/Documentation/DocBook/media/dvb/frontend.xml b/Documentation/DocBook/media/dvb/frontend.xml
index 81082fb..1ab2e1a 100644
--- a/Documentation/DocBook/media/dvb/frontend.xml
+++ b/Documentation/DocBook/media/dvb/frontend.xml
@@ -207,18 +207,44 @@ spec.</para>
 <para>Several functions of the frontend device use the fe_status data type defined
 by</para>
 <programlisting>
- typedef enum fe_status {
-	 FE_HAS_SIGNAL     = 0x01,   /&#x22C6;  found something above the noise level &#x22C6;/
-	 FE_HAS_CARRIER    = 0x02,   /&#x22C6;  found a DVB signal  &#x22C6;/
-	 FE_HAS_VITERBI    = 0x04,   /&#x22C6;  FEC is stable  &#x22C6;/
-	 FE_HAS_SYNC       = 0x08,   /&#x22C6;  found sync bytes  &#x22C6;/
-	 FE_HAS_LOCK       = 0x10,   /&#x22C6;  everything's working... &#x22C6;/
-	 FE_TIMEDOUT       = 0x20,   /&#x22C6;  no lock within the last ~2 seconds &#x22C6;/
-	 FE_REINIT         = 0x40    /&#x22C6;  frontend was reinitialized,  &#x22C6;/
- } fe_status_t;                      /&#x22C6;  application is recommned to reset &#x22C6;/
+typedef enum fe_status {
+	FE_HAS_SIGNAL		= 0x01,
+	FE_HAS_CARRIER		= 0x02,
+	FE_HAS_VITERBI		= 0x04,
+	FE_HAS_SYNC		= 0x08,
+	FE_HAS_LOCK		= 0x10,
+	FE_TIMEDOUT		= 0x20,
+	FE_REINIT		= 0x40,
+} fe_status_t;
 </programlisting>
-<para>to indicate the current state and/or state changes of the frontend hardware.
-</para>
+<para>to indicate the current state and/or state changes of the frontend hardware:
+</para>
+
+<informaltable><tgroup cols="2"><tbody>
+<row>
+<entry align="char">FE_HAS_SIGNAL</entry>
+<entry align="char">The frontend has found something above the noise level</entry>
+</row><row>
+<entry align="char">FE_HAS_CARRIER</entry>
+<entry align="char">The frontend has found a DVB signal</entry>
+</row><row>
+<entry align="char">FE_HAS_VITERBI</entry>
+<entry align="char">The frontend FEC code is stable</entry>
+</row><row>
+<entry align="char">FE_HAS_SYNC</entry>
+<entry align="char">Syncronization bytes was found</entry>
+</row><row>
+<entry align="char">FE_HAS_LOCK</entry>
+<entry align="char">The DVB were locked and everything is working</entry>
+</row><row>
+<entry align="char">FE_TIMEDOUT</entry>
+<entry align="char">no lock within the last about 2 seconds</entry>
+</row><row>
+<entry align="char">FE_REINIT</entry>
+<entry align="char">The frontend was reinitialized, application is
+recommended to reset DiSEqC, tone and parameters</entry>
+</row>
+</tbody></tgroup></informaltable>
 
 </section>
 
diff --git a/include/linux/dvb/frontend.h b/include/linux/dvb/frontend.h
index c92b4d6..bb51edf 100644
--- a/include/linux/dvb/frontend.h
+++ b/include/linux/dvb/frontend.h
@@ -121,16 +121,27 @@ typedef enum fe_sec_mini_cmd {
 } fe_sec_mini_cmd_t;
 
 
+/**
+ * enum fe_status - enumerates the possible frontend status
+ * @FE_HAS_SIGNAL:	found something above the noise level
+ * @FE_HAS_CARRIER:	found a DVB signal
+ * @FE_HAS_VITERBI:	FEC is stable
+ * @FE_HAS_SYNC:	found sync bytes
+ * @FE_HAS_LOCK:	everything's working
+ * @FE_TIMEDOUT:	no lock within the last ~2 seconds
+ * @FE_REINIT:		frontend was reinitialized, application is recommended
+ *			to reset DiSEqC, tone and parameters
+ */
+
 typedef enum fe_status {
-	FE_HAS_SIGNAL	= 0x01,   /* found something above the noise level */
-	FE_HAS_CARRIER	= 0x02,   /* found a DVB signal  */
-	FE_HAS_VITERBI	= 0x04,   /* FEC is stable  */
-	FE_HAS_SYNC	= 0x08,   /* found sync bytes  */
-	FE_HAS_LOCK	= 0x10,   /* everything's working... */
-	FE_TIMEDOUT	= 0x20,   /* no lock within the last ~2 seconds */
-	FE_REINIT	= 0x40    /* frontend was reinitialized,  */
-} fe_status_t;			  /* application is recommended to reset */
-				  /* DiSEqC, tone and parameters */
+	FE_HAS_SIGNAL		= 0x01,
+	FE_HAS_CARRIER		= 0x02,
+	FE_HAS_VITERBI		= 0x04,
+	FE_HAS_SYNC		= 0x08,
+	FE_HAS_LOCK		= 0x10,
+	FE_TIMEDOUT		= 0x20,
+	FE_REINIT		= 0x40,
+} fe_status_t;
 
 typedef enum fe_spectral_inversion {
 	INVERSION_OFF,
-- 
1.7.11.2

