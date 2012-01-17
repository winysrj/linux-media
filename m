Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34323 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754707Ab2AQS5O (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Jan 2012 13:57:14 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q0HIvEMO007461
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 17 Jan 2012 13:57:14 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 1/4] [media] DocBook/dvbproperty.xml: Fix the units for DTV_FREQUENCY
Date: Tue, 17 Jan 2012 16:57:06 -0200
Message-Id: <1326826629-29961-2-git-send-email-mchehab@redhat.com>
In-Reply-To: <1326826629-29961-1-git-send-email-mchehab@redhat.com>
References: <1326826629-29961-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The units for DTV_FREQUENCY are kHz for satellital delivery systems
(DVB-S/DVB-S2/DVB-TURBO/ISDB-S). Fix it at the API spec.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 Documentation/DocBook/media/dvb/dvbproperty.xml |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/Documentation/DocBook/media/dvb/dvbproperty.xml b/Documentation/DocBook/media/dvb/dvbproperty.xml
index ffee1fb..0496641 100644
--- a/Documentation/DocBook/media/dvb/dvbproperty.xml
+++ b/Documentation/DocBook/media/dvb/dvbproperty.xml
@@ -163,14 +163,16 @@ get/set up to 64 properties. The actual meaning of each property is described on
 	<section id="DTV-FREQUENCY">
 		<title><constant>DTV_FREQUENCY</constant></title>
 
-		<para>Central frequency of the channel, in HZ.</para>
+		<para>Central frequency of the channel.</para>
 
 		<para>Notes:</para>
-		<para>1)For ISDB-T, the channels are usually transmitted with an offset of 143kHz.
+		<para>1)For satellital delivery systems, it is measured in kHz.
+			For the other ones, it is measured in Hz.</para>
+		<para>2)For ISDB-T, the channels are usually transmitted with an offset of 143kHz.
 			E.g. a valid frequncy could be 474143 kHz. The stepping is bound to the bandwidth of
 			the channel which is 6MHz.</para>
 
-		<para>2)As in ISDB-Tsb the channel consists of only one or three segments the
+		<para>3)As in ISDB-Tsb the channel consists of only one or three segments the
 			frequency step is 429kHz, 3*429 respectively. As for ISDB-T the
 			central frequency of the channel is expected.</para>
 	</section>
-- 
1.7.8

