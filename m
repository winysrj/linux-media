Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:34163 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754870AbbE2B3C (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 May 2015 21:29:02 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [PATCH 1/8] DocBook/Makefile: improve typedef parser
Date: Thu, 28 May 2015 22:28:50 -0300
Message-Id: <66b62f4cc0526190f4458dc78c469362f55ca6db.1432862317.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1432862317.git.mchehab@osg.samsung.com>
References: <cover.1432862317.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1432862317.git.mchehab@osg.samsung.com>
References: <cover.1432862317.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The typedef parser is wrong and doesn't get some of the
types defined at the DVB API. Improve it, as we want to add
cross-references to those types.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/Documentation/DocBook/media/Makefile b/Documentation/DocBook/media/Makefile
index e07e8844efde..dbc9a56e8260 100644
--- a/Documentation/DocBook/media/Makefile
+++ b/Documentation/DocBook/media/Makefile
@@ -70,8 +70,8 @@ DEFINES = \
 	$(shell perl -ne 'print "$$1 " if /\#define\s+(DTV_[^\s]+)\s+/' $(srctree)/include/uapi/linux/dvb/frontend.h) \
 
 TYPES = \
-	$(shell perl -ne 'print "$$1 " if /^typedef\s+[^\s]+\s+([^\s]+)\;/' $(srctree)/include/uapi/linux/videodev2.h) \
-	$(shell perl -ne 'print "$$1 " if /^}\s+([a-z0-9_]+_t)/' $(srctree)/include/uapi/linux/dvb/frontend.h)
+	$(shell perl -ne 'print "$$1 " if /^typedef\s+.*\s+(\S+)\;/' $(srctree)/include/uapi/linux/videodev2.h) \
+	$(shell perl -ne 'print "$$1 " if /^typedef\s+.*\s+(\S+)\;/' $(srctree)/include/uapi/linux/dvb/frontend.h)
 
 ENUMS = \
 	$(shell perl -ne 'print "$$1 " if /^enum\s+([^\s]+)\s+/' $(srctree)/include/uapi/linux/videodev2.h) \
-- 
2.4.1

