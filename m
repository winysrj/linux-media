Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8410 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754923Ab2AQS5O (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Jan 2012 13:57:14 -0500
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q0HIvEr5021189
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 17 Jan 2012 13:57:14 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 3/4] [media] DocBook/dvbproperty.xml: Remove DTV_MODULATION from ISDB-T
Date: Tue, 17 Jan 2012 16:57:08 -0200
Message-Id: <1326826629-29961-4-git-send-email-mchehab@redhat.com>
In-Reply-To: <1326826629-29961-3-git-send-email-mchehab@redhat.com>
References: <1326826629-29961-1-git-send-email-mchehab@redhat.com>
 <1326826629-29961-2-git-send-email-mchehab@redhat.com>
 <1326826629-29961-3-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On ISDB-T, each layer can have its own independent modulation,
applied to the carriers that belong to the segments associated
with them. So, there's no sense to define a global modulation
parameter.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 Documentation/DocBook/media/dvb/dvbproperty.xml |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/Documentation/DocBook/media/dvb/dvbproperty.xml b/Documentation/DocBook/media/dvb/dvbproperty.xml
index 2de2bb3..c7a4ca5 100644
--- a/Documentation/DocBook/media/dvb/dvbproperty.xml
+++ b/Documentation/DocBook/media/dvb/dvbproperty.xml
@@ -737,7 +737,6 @@ typedef enum fe_hierarchy {
 			<listitem><para><link linkend="DTV-TUNE"><constant>DTV_TUNE</constant></link></para></listitem>
 			<listitem><para><link linkend="DTV-CLEAR"><constant>DTV_CLEAR</constant></link></para></listitem>
 			<listitem><para><link linkend="DTV-FREQUENCY"><constant>DTV_FREQUENCY</constant></link></para></listitem>
-			<listitem><para><link linkend="DTV-MODULATION"><constant>DTV_MODULATION</constant></link></para></listitem>
 			<listitem><para><link linkend="DTV-BANDWIDTH-HZ"><constant>DTV_BANDWIDTH_HZ</constant></link></para></listitem>
 			<listitem><para><link linkend="DTV-INVERSION"><constant>DTV_INVERSION</constant></link></para></listitem>
 			<listitem><para><link linkend="DTV-GUARD-INTERVAL"><constant>DTV_GUARD_INTERVAL</constant></link></para></listitem>
-- 
1.7.8

