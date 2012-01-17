Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35037 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754717Ab2AQS5O (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Jan 2012 13:57:14 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q0HIvEl7024240
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 17 Jan 2012 13:57:14 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 2/4] [media] DocBook/dvbproperty.xml: Fix ISDB-T delivery system parameters
Date: Tue, 17 Jan 2012 16:57:07 -0200
Message-Id: <1326826629-29961-3-git-send-email-mchehab@redhat.com>
In-Reply-To: <1326826629-29961-2-git-send-email-mchehab@redhat.com>
References: <1326826629-29961-1-git-send-email-mchehab@redhat.com>
 <1326826629-29961-2-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The ISDB-T differs on its way to implement the hierarchical
transmissions: instead of using a low-priority/high-priority
FEC codes, it does that by using different layers, each layer
with their groups of segments. So, those parameters don't make sense
for ISDB-T.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 Documentation/DocBook/media/dvb/dvbproperty.xml |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/Documentation/DocBook/media/dvb/dvbproperty.xml b/Documentation/DocBook/media/dvb/dvbproperty.xml
index 0496641..2de2bb3 100644
--- a/Documentation/DocBook/media/dvb/dvbproperty.xml
+++ b/Documentation/DocBook/media/dvb/dvbproperty.xml
@@ -740,11 +740,8 @@ typedef enum fe_hierarchy {
 			<listitem><para><link linkend="DTV-MODULATION"><constant>DTV_MODULATION</constant></link></para></listitem>
 			<listitem><para><link linkend="DTV-BANDWIDTH-HZ"><constant>DTV_BANDWIDTH_HZ</constant></link></para></listitem>
 			<listitem><para><link linkend="DTV-INVERSION"><constant>DTV_INVERSION</constant></link></para></listitem>
-			<listitem><para><link linkend="DTV-CODE-RATE-HP"><constant>DTV_CODE_RATE_HP</constant></link></para></listitem>
-			<listitem><para><link linkend="DTV-CODE-RATE-LP"><constant>DTV_CODE_RATE_LP</constant></link></para></listitem>
 			<listitem><para><link linkend="DTV-GUARD-INTERVAL"><constant>DTV_GUARD_INTERVAL</constant></link></para></listitem>
 			<listitem><para><link linkend="DTV-TRANSMISSION-MODE"><constant>DTV_TRANSMISSION_MODE</constant></link></para></listitem>
-			<listitem><para><link linkend="DTV-HIERARCHY"><constant>DTV_HIERARCHY</constant></link></para></listitem>
 			<listitem><para><link linkend="DTV-ISDBT-LAYER-ENABLED"><constant>DTV_ISDBT_LAYER_ENABLED</constant></link></para></listitem>
 			<listitem><para><link linkend="DTV-ISDBT-PARTIAL-RECEPTION"><constant>DTV_ISDBT_PARTIAL_RECEPTION</constant></link></para></listitem>
 			<listitem><para><link linkend="DTV-ISDBT-SOUND-BROADCASTING"><constant>DTV_ISDBT_SOUND_BROADCASTING</constant></link></para></listitem>
-- 
1.7.8

