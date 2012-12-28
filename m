Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58979 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754171Ab2L1Xmx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Dec 2012 18:42:53 -0500
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id qBSNgr2w004031
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 28 Dec 2012 18:42:53 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [RFC PATCH] [media] dvb: frontend API: Add a flag to indicate that get_frontend() can be called
Date: Fri, 28 Dec 2012 21:42:26 -0200
Message-Id: <1356738146-9352-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

get_frontend() can't be called too early, as the device may not have it
yet. Yet, get_frontend() on OFDM standards can happen before FE_HAS_LOCK,
as the TMCC carriers (ISDB-T) or the TPS carriers (DVB-T) require a very
low signal to noise relation to be detected. The other carriers use
different modulations, so they require a higher SNR.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 Documentation/DocBook/media/dvb/frontend.xml | 13 ++++++++++++-
 drivers/media/dvb-frontends/mb86a20s.c       | 17 ++++++++++-------
 include/uapi/linux/dvb/frontend.h            |  4 ++++
 3 files changed, 26 insertions(+), 8 deletions(-)

v3: rebase it to apply with current tip and add an implementation example.

Obsoletes: http://patchwork.linuxtv.org/patch/13783/

diff --git a/Documentation/DocBook/media/dvb/frontend.xml b/Documentation/DocBook/media/dvb/frontend.xml
index 426c252..5feff4e 100644
--- a/Documentation/DocBook/media/dvb/frontend.xml
+++ b/Documentation/DocBook/media/dvb/frontend.xml
@@ -216,6 +216,7 @@ typedef enum fe_status {
 	FE_HAS_LOCK		= 0x10,
 	FE_TIMEDOUT		= 0x20,
 	FE_REINIT		= 0x40,
+	FE_HAS_PARAMETERS	= 0x80,
 } fe_status_t;
 </programlisting>
 <para>to indicate the current state and/or state changes of the frontend hardware:
@@ -244,7 +245,17 @@ typedef enum fe_status {
 <entry align="char">FE_REINIT</entry>
 <entry align="char">The frontend was reinitialized, application is
 recommended to reset DiSEqC, tone and parameters</entry>
-</row>
+</row><row>
+<entry align="char">FE_HAS_PARAMETERS</entry>
+<entry align="char"><link linkend="FE_GET_SET_PROPERTY">
+<constant>FE_GET_PROPERTY/FE_SET_PROPERTY</constant></link> or
+<link linkend="FE_GET_FRONTEND"><constant>FE_GET_FRONTEND</constant></link> can now be
+called to provide the detected network parameters.
+This should be risen for example when the DVB-T TPS/ISDB-T TMCC is locked.
+This status can be risen before FE_HAS_SYNC, as the SNR required for
+parameters detection is lower than the requirement for the other
+carriers on the OFDM delivery systems.
+</entry></row>
 </tbody></tgroup></informaltable>
 
 </section>
diff --git a/drivers/media/dvb-frontends/mb86a20s.c b/drivers/media/dvb-frontends/mb86a20s.c
index fade566..35153b6 100644
--- a/drivers/media/dvb-frontends/mb86a20s.c
+++ b/drivers/media/dvb-frontends/mb86a20s.c
@@ -333,19 +333,22 @@ static int mb86a20s_read_status(struct dvb_frontend *fe, fe_status_t *status)
 		fe->ops.i2c_gate_ctrl(fe, 1);
 
 	if (val >= 2)
-		*status |= FE_HAS_SIGNAL;
+		*status |= FE_HAS_SIGNAL;	/* Tuner locked */
 
 	if (val >= 4)
-		*status |= FE_HAS_CARRIER;
+		*status |= FE_HAS_CARRIER;	/* Mode reliably detected */
 
-	if (val >= 5)
-		*status |= FE_HAS_VITERBI;
+	if (val >= 6)
+		*status |= FE_HAS_VITERBI;	/* PLL locked and broadband detected */
 
 	if (val >= 7)
-		*status |= FE_HAS_SYNC;
+		*status |= FE_HAS_SYNC;		/* Frame sync */
 
-	if (val >= 8)				/* Maybe 9? */
-		*status |= FE_HAS_LOCK;
+	if (val >= 8)
+		*status |= FE_HAS_PARAMETERS;	/* TMCC locked */
+
+	if (val >= 9)
+		*status |= FE_HAS_LOCK;		/* TS output started */
 
 	dprintk("val = %d, status = 0x%02x\n", val, *status);
 
diff --git a/include/uapi/linux/dvb/frontend.h b/include/uapi/linux/dvb/frontend.h
index c12d452..e4daeee 100644
--- a/include/uapi/linux/dvb/frontend.h
+++ b/include/uapi/linux/dvb/frontend.h
@@ -132,6 +132,9 @@ typedef enum fe_sec_mini_cmd {
  * @FE_TIMEDOUT:	no lock within the last ~2 seconds
  * @FE_REINIT:		frontend was reinitialized, application is recommended
  *			to reset DiSEqC, tone and parameters
+ * @FE_HAS_PARAMETERS:	get_frontend() can now be called to provide the
+ *			detected network parameters. This should be risen
+ *			for example when the DVB-T TPS/ISDB-T TMCC is locked.
  */
 
 typedef enum fe_status {
@@ -142,6 +145,7 @@ typedef enum fe_status {
 	FE_HAS_LOCK		= 0x10,
 	FE_TIMEDOUT		= 0x20,
 	FE_REINIT		= 0x40,
+	FE_HAS_PARAMETERS	= 0x80,
 } fe_status_t;
 
 typedef enum fe_spectral_inversion {
-- 
1.7.11.7

