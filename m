Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28411 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754199Ab2HMWdr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Aug 2012 18:33:47 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q7DMXlhP009889
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 13 Aug 2012 18:33:47 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] [media] dvb: frontend API: Add a flag to indicate that get_frontend() can be called
Date: Mon, 13 Aug 2012 19:33:38 -0300
Message-Id: <1344897218-28307-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

get_frontend() can't be called too early, as the device may not have it
yet. Yet, get_frontend() on OFDM standards can happen before FE_HAS_LOCK,
as the TMCC carriers (ISDB-T) or the TPS carriers (DVB-T) require a very
low signal to noise relation to be detected. The other carriers use

different modulations, so they require a higher SNR.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

---

v2: rebase for patch at http://patchwork.linuxtv.org/patch/9562
---
 Documentation/DocBook/media/dvb/frontend.xml | 13 ++++++++++++-
 include/linux/dvb/frontend.h                 |  4 ++++
 2 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/Documentation/DocBook/media/dvb/frontend.xml b/Documentation/DocBook/media/dvb/frontend.xml
index 1ab2e1a..3c2b8c0 100644
--- a/Documentation/DocBook/media/dvb/frontend.xml
+++ b/Documentation/DocBook/media/dvb/frontend.xml
@@ -215,6 +215,7 @@ typedef enum fe_status {
 	FE_HAS_LOCK		= 0x10,
 	FE_TIMEDOUT		= 0x20,
 	FE_REINIT		= 0x40,
+	FE_HAS_PARAMETERS	= 0x80,
 } fe_status_t;
 </programlisting>
 <para>to indicate the current state and/or state changes of the frontend hardware:
@@ -243,7 +244,17 @@ typedef enum fe_status {
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
diff --git a/include/linux/dvb/frontend.h b/include/linux/dvb/frontend.h
index bb51edf..8ff49c6 100644
--- a/include/linux/dvb/frontend.h
+++ b/include/linux/dvb/frontend.h
@@ -131,6 +131,9 @@ typedef enum fe_sec_mini_cmd {
  * @FE_TIMEDOUT:	no lock within the last ~2 seconds
  * @FE_REINIT:		frontend was reinitialized, application is recommended
  *			to reset DiSEqC, tone and parameters
+ * @FE_HAS_PARAMETERS:	get_frontend() can now be called to provide the
+ *			detected network parameters. This should be risen
+ *			for example when the DVB-T TPS/ISDB-T TMCC is locked.
  */
 
 typedef enum fe_status {
@@ -141,6 +144,7 @@ typedef enum fe_status {
 	FE_HAS_LOCK		= 0x10,
 	FE_TIMEDOUT		= 0x20,
 	FE_REINIT		= 0x40,
+	FE_HAS_PARAMETERS	= 0x80,
 } fe_status_t;
 
 typedef enum fe_spectral_inversion {
-- 
1.7.11.2

