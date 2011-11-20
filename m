Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:15571 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750993Ab1KTO40 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 20 Nov 2011 09:56:26 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pAKEuQKr013360
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sun, 20 Nov 2011 09:56:26 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH 1/8] [media] dvb: Allow select between DVB-C Annex A and Annex C
Date: Sun, 20 Nov 2011 12:56:11 -0200
Message-Id: <1321800978-27912-1-git-send-email-mchehab@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

DVB-C, as defined by ITU-T J.83 has 3 annexes. The differences between
Annex A and Annex C is that Annex C uses a subset of the modulation
types, and uses a different rolloff factor. A different rolloff means
that the bandwidth required is slicely different, and may affect the
saw filter configuration at the tuners. Also, some demods have different
configurations, depending on using Annex A or Annex C.

So, allow userspace to specify it, by changing the rolloff factor.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 Documentation/DocBook/media/dvb/dvbproperty.xml |    4 ++++
 drivers/media/dvb/dvb-core/dvb_frontend.c       |    2 ++
 include/linux/dvb/frontend.h                    |    2 ++
 3 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/Documentation/DocBook/media/dvb/dvbproperty.xml b/Documentation/DocBook/media/dvb/dvbproperty.xml
index 3bc8a61..6ac8039 100644
--- a/Documentation/DocBook/media/dvb/dvbproperty.xml
+++ b/Documentation/DocBook/media/dvb/dvbproperty.xml
@@ -311,6 +311,8 @@ typedef enum fe_rolloff {
 	ROLLOFF_20,
 	ROLLOFF_25,
 	ROLLOFF_AUTO,
+	ROLLOFF_15, /* DVB-C Annex A */
+	ROLLOFF_13, /* DVB-C Annex C */
 } fe_rolloff_t;
 		</programlisting>
 		</section>
@@ -778,8 +780,10 @@ typedef enum fe_hierarchy {
 			<listitem><para><link linkend="DTV-MODULATION"><constant>DTV_MODULATION</constant></link></para></listitem>
 			<listitem><para><link linkend="DTV-INVERSION"><constant>DTV_INVERSION</constant></link></para></listitem>
 			<listitem><para><link linkend="DTV-SYMBOL-RATE"><constant>DTV_SYMBOL_RATE</constant></link></para></listitem>
+			<listitem><para><link linkend="DTV-ROLLOFF"><constant>DTV_ROLLOFF</constant></link></para></listitem>
 			<listitem><para><link linkend="DTV-INNER-FEC"><constant>DTV_INNER_FEC</constant></link></para></listitem>
 		</itemizedlist>
+		<para>The Rolloff of 0.15 (ROLLOFF_15) is assumed, as ITU-T J.83 Annex A is more common. For Annex C, rolloff should be 0.13 (ROLLOFF_13). All other values are invalid.</para>
 	</section>
 	<section id="dvbc-annex-b-params">
 		<title>DVB-C Annex B delivery system</title>
diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
index 2c0acdb..c849455 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
@@ -876,6 +876,7 @@ static int dvb_frontend_clear_cache(struct dvb_frontend *fe)
 	c->symbol_rate = QAM_AUTO;
 	c->code_rate_HP = FEC_AUTO;
 	c->code_rate_LP = FEC_AUTO;
+	c->rolloff = ROLLOFF_AUTO;
 
 	c->isdbt_partial_reception = -1;
 	c->isdbt_sb_mode = -1;
@@ -1030,6 +1031,7 @@ static void dtv_property_cache_init(struct dvb_frontend *fe,
 		break;
 	case FE_QAM:
 		c->delivery_system = SYS_DVBC_ANNEX_AC;
+		c->rolloff = ROLLOFF_15; /* implied for Annex A */
 		break;
 	case FE_OFDM:
 		c->delivery_system = SYS_DVBT;
diff --git a/include/linux/dvb/frontend.h b/include/linux/dvb/frontend.h
index 1b1094c..d9251df 100644
--- a/include/linux/dvb/frontend.h
+++ b/include/linux/dvb/frontend.h
@@ -329,6 +329,8 @@ typedef enum fe_rolloff {
 	ROLLOFF_20,
 	ROLLOFF_25,
 	ROLLOFF_AUTO,
+	ROLLOFF_15,	/* DVB-C Annex A */
+	ROLLOFF_13,	/* DVB-C Annex C */
 } fe_rolloff_t;
 
 typedef enum fe_delivery_system {
-- 
1.7.7.1

