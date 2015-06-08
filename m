Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:54811 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753576AbbFHTyf (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Jun 2015 15:54:35 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-doc@vger.kernel.org
Subject: [PATCH 05/26] [media] DocBook: add entry IDs for enum fe_sec_tone_mode
Date: Mon,  8 Jun 2015 16:53:49 -0300
Message-Id: <97637525003be2950ed7612274b295b20a49f42c.1433792665.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1433792665.git.mchehab@osg.samsung.com>
References: <cover.1433792665.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1433792665.git.mchehab@osg.samsung.com>
References: <cover.1433792665.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

enum fe_sec_tone_mode is documented together with FE_SET_TONE.

Add xrefs for each entry there. This makes the hyperlinks at
frontend.h to go directly to the right documentation.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/Documentation/DocBook/media/dvb/fe-set-tone.xml b/Documentation/DocBook/media/dvb/fe-set-tone.xml
index 12cd4dd3a6ef..62d44e4ccc39 100644
--- a/Documentation/DocBook/media/dvb/fe-set-tone.xml
+++ b/Documentation/DocBook/media/dvb/fe-set-tone.xml
@@ -76,10 +76,10 @@
 	</thead>
 	<tbody valign="top">
 	<row>
-	    <entry align="char">SEC_TONE_ON</entry>
+	    <entry align="char" id="SEC-TONE-ON"><constant>SEC_TONE_ON</constant></entry>
 	    <entry align="char">Sends a 22kHz tone burst to the antenna</entry>
 	</row><row>
-	    <entry align="char">SEC_TONE_OFF</entry>
+	    <entry align="char" id="SEC-TONE-OFF"><constant>SEC_TONE_OFF</constant></entry>
 	    <entry align="char">Don't send a 22kHz tone to the antenna
 		(except if the FE_DISEQC_* ioctls are called)</entry>
 	</row>
-- 
2.4.2

