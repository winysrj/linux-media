Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:54814 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753577AbbFHTyf (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Jun 2015 15:54:35 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [PATCH 21/26] [media] DocBook: Remove comments before parsing enum values
Date: Mon,  8 Jun 2015 16:54:05 -0300
Message-Id: <bc2841ef6ebdfb6e384dccc61eb4c346ae19ecf5.1433792665.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1433792665.git.mchehab@osg.samsung.com>
References: <cover.1433792665.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1433792665.git.mchehab@osg.samsung.com>
References: <cover.1433792665.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The comments may affect enum value parsing. Use cpp to remove
them.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/Documentation/DocBook/media/Makefile b/Documentation/DocBook/media/Makefile
index 226152952f58..e7d44a0b00d6 100644
--- a/Documentation/DocBook/media/Makefile
+++ b/Documentation/DocBook/media/Makefile
@@ -87,7 +87,7 @@ ENUMS = \
 		$(srctree)/include/uapi/linux/v4l2-subdev.h)
 
 ENUM_DEFS = \
-	$(shell perl -e 'while (<>) { if ($$enum) {print "$$1\n" if (/\s*([A-Z]\S+)\b/); } $$enum = 0 if ($enum && /^\}/); $$enum = 1 if(/^\s*enum\s/); }' \
+	$(shell perl -e 'open IN,"cat @ARGV| cpp -fpreprocessed |"; while (<IN>) { if ($$enum) {print "$$1\n" if (/\s*([A-Z]\S+)\b/); } $$enum = 0 if ($$enum && /^\}/); $$enum = 1 if(/^\s*enum\s/); }; close IN;' \
 		$(srctree)/include/uapi/linux/dvb/audio.h \
 		$(srctree)/include/uapi/linux/dvb/ca.h \
 		$(srctree)/include/uapi/linux/dvb/dmx.h \
-- 
2.4.2

