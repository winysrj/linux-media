Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51496 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932214AbbE1Vtw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 May 2015 17:49:52 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [PATCH 20/35] DocBook: Rename ioctl xml files
Date: Thu, 28 May 2015 18:49:23 -0300
Message-Id: <e2281aaab880b81fd6700881cbca80a6e89196e9.1432844837.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1432844837.git.mchehab@osg.samsung.com>
References: <cover.1432844837.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1432844837.git.mchehab@osg.samsung.com>
References: <cover.1432844837.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

for the xml files describing ioctls, use the same nomenclature
as on V4L2: the ioctl name, in lower case, using - instead of _.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

 rename Documentation/DocBook/media/dvb/{frontend_get_info.xml => fe-get-info.xml} (100%)
 rename Documentation/DocBook/media/dvb/{frontend_read_status.xml => fe-read-status.xml} (100%)

diff --git a/Documentation/DocBook/media/dvb/frontend_get_info.xml b/Documentation/DocBook/media/dvb/fe-get-info.xml
similarity index 100%
rename from Documentation/DocBook/media/dvb/frontend_get_info.xml
rename to Documentation/DocBook/media/dvb/fe-get-info.xml
diff --git a/Documentation/DocBook/media/dvb/frontend_read_status.xml b/Documentation/DocBook/media/dvb/fe-read-status.xml
similarity index 100%
rename from Documentation/DocBook/media/dvb/frontend_read_status.xml
rename to Documentation/DocBook/media/dvb/fe-read-status.xml
diff --git a/Documentation/DocBook/media/dvb/frontend.xml b/Documentation/DocBook/media/dvb/frontend.xml
index 659f71ab67ef..079f631cc848 100644
--- a/Documentation/DocBook/media/dvb/frontend.xml
+++ b/Documentation/DocBook/media/dvb/frontend.xml
@@ -37,7 +37,7 @@ specification is available at
 	<link linkend="FE_GET_INFO">FE_GET_INFO</link>.</para>
 </section>
 
-&sub-frontend_get_info;
+&sub-fe-get-info;
 
 <section id="dvb-fe-read-status">
 <title>Querying frontend status</title>
@@ -46,7 +46,7 @@ specification is available at
 	<link linkend="FE_READ_STATUS">FE_READ_STATUS</link>.</para>
 </section>
 
-&sub-frontend_read_status;
+&sub-fe-read-status;
 
 &sub-dvbproperty;
 
-- 
2.4.1

