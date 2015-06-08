Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:54821 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753582AbbFHTyf (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Jun 2015 15:54:35 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-doc@vger.kernel.org
Subject: [PATCH 04/26] [media] DocBook: add entry IDs for enum fe_status
Date: Mon,  8 Jun 2015 16:53:48 -0300
Message-Id: <84cb75d774eb7de36cccdc421876419523eb3a0e.1433792665.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1433792665.git.mchehab@osg.samsung.com>
References: <cover.1433792665.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1433792665.git.mchehab@osg.samsung.com>
References: <cover.1433792665.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

enum fe_status is documented together with FE_READ_STATUS.

Add xrefs for each entry there. This makes the hyperlinks at
frontend.h to go directly to the right documentation.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/Documentation/DocBook/media/dvb/fe-read-status.xml b/Documentation/DocBook/media/dvb/fe-read-status.xml
index 3e4c794ceac3..bc0dc2a55f19 100644
--- a/Documentation/DocBook/media/dvb/fe-read-status.xml
+++ b/Documentation/DocBook/media/dvb/fe-read-status.xml
@@ -78,25 +78,25 @@ pointer to an integer where the status will be written.
 	</thead>
 	<tbody valign="top">
 	<row>
-	    <entry align="char">FE_HAS_SIGNAL</entry>
+	    <entry align="char" id="FE-HAS-SIGNAL"><constant>FE_HAS_SIGNAL</constant></entry>
 	    <entry align="char">The frontend has found something above the noise level</entry>
 	</row><row>
-	    <entry align="char">FE_HAS_CARRIER</entry>
+	    <entry align="char" id="FE-HAS-CARRIER"><constant>FE_HAS_CARRIER</constant></entry>
 	    <entry align="char">The frontend has found a DVB signal</entry>
 	</row><row>
-	    <entry align="char">FE_HAS_VITERBI</entry>
+	    <entry align="char" id="FE-HAS-VITERBI"><constant>FE_HAS_VITERBI</constant></entry>
 	    <entry align="char">The frontend FEC inner coding (Viterbi, LDPC or other inner code) is stable</entry>
 	</row><row>
-	    <entry align="char">FE_HAS_SYNC</entry>
+	    <entry align="char" id="FE-HAS-SYNC"><constant>FE_HAS_SYNC</constant></entry>
 	    <entry align="char">Synchronization bytes was found</entry>
 	</row><row>
-	    <entry align="char">FE_HAS_LOCK</entry>
+	    <entry align="char" id="FE-HAS-LOCK"><constant>FE_HAS_LOCK</constant></entry>
 	    <entry align="char">The DVB were locked and everything is working</entry>
 	</row><row>
-	    <entry align="char">FE_TIMEDOUT</entry>
+	    <entry align="char" id="FE-TIMEDOUT"><constant>FE_TIMEDOUT</constant></entry>
 	    <entry align="char">no lock within the last about 2 seconds</entry>
 	</row><row>
-	    <entry align="char">FE_REINIT</entry>
+	    <entry align="char" id="FE-REINIT"><constant>FE_REINIT</constant></entry>
 	    <entry align="char">The frontend was reinitialized, application is
 	    recommended to reset DiSEqC, tone and parameters</entry>
 	</row>
-- 
2.4.2

