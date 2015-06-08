Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:54824 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753583AbbFHTyf (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Jun 2015 15:54:35 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-doc@vger.kernel.org
Subject: [PATCH 10/26] [media] DocBook: remove a wrong cut-and-paste data
Date: Mon,  8 Jun 2015 16:53:54 -0300
Message-Id: <df63c8823ece988693c388d1ccc27dcf9361065a.1433792665.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1433792665.git.mchehab@osg.samsung.com>
References: <cover.1433792665.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1433792665.git.mchehab@osg.samsung.com>
References: <cover.1433792665.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

By cut-and-paste mistake, TRANSMISSION_MODE_AUTO were documented
twice, one at the wrong place.

Remove the wrong one.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/Documentation/DocBook/media/dvb/dvbproperty.xml b/Documentation/DocBook/media/dvb/dvbproperty.xml
index 33f2313aca07..7e5147e6c2f2 100644
--- a/Documentation/DocBook/media/dvb/dvbproperty.xml
+++ b/Documentation/DocBook/media/dvb/dvbproperty.xml
@@ -351,11 +351,6 @@ get/set up to 64 properties. The actual meaning of each property is described on
 	</thead>
 	<tbody valign="top">
 	<row>
-	    <entry id="TRANSMISSION-MODE-AUTO"><constant>TRANSMISSION_MODE_AUTO</constant></entry>
-	    <entry>Autodetect transmission mode. The hardware will try to find
-		the correct FFT-size (if capable) to fill in the missing
-		parameters.</entry>
-	</row><row>
 	    <entry id="FEC-NONE"><constant>FEC_NONE</constant></entry>
 	    <entry>No Forward Error Correction Code</entry>
 	</row><row>
-- 
2.4.2

