Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51459 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932210AbbE1Vtv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 May 2015 17:49:51 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [PATCH 17/35] DocBook: Improve xref check for undocumented ioctls
Date: Thu, 28 May 2015 18:49:20 -0300
Message-Id: <d6892a3a3674b88f48d9e620fb19c638cf33b0cf.1432844837.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1432844837.git.mchehab@osg.samsung.com>
References: <cover.1432844837.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1432844837.git.mchehab@osg.samsung.com>
References: <cover.1432844837.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are several badly documented undocumented ioctls.
Currently, it just generates an empty link. Instead of doing that,
only add references to the ones that exists, and add a warning
for all references that weren't found.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/Documentation/DocBook/media/Makefile b/Documentation/DocBook/media/Makefile
index 723932f85fb6..fdb0027f353c 100644
--- a/Documentation/DocBook/media/Makefile
+++ b/Documentation/DocBook/media/Makefile
@@ -305,10 +305,12 @@ $(MEDIA_OBJ_DIR)/media-entities.tmpl: $(MEDIA_OBJ_DIR)/v4l2.xml
 	@(								\
 	for ident in $(IOCTLS) ; do					\
 	  entity=`echo $$ident | tr _ -` ;				\
-	  id=`grep "<refname>$$ident" $(MEDIA_OBJ_DIR)/vidioc-*.xml $(MEDIA_OBJ_DIR)/media-ioc-*.xml | sed -r s,"^.*/(.*).xml.*","\1",` ; \
-	  echo "<!ENTITY $$entity \"<link"				\
+	  id=`grep -e "<refname>$$ident" -e "<section id=\"$$ident\"" $$(find $(MEDIA_SRC_DIR) -name *.xml -type f)| sed -r s,"^.*/(.*).xml.*","\1",` ; \
+	  if [ "$$id" != "" ]; then echo "<!ENTITY $$entity \"<link"	\
 	    "linkend='$$id'><constant>$$ident</constant></link>\">"	\
-	  >>$@ ;							\
+	  >>$@ ; else							\
+		echo "Warning: undocumented ioctl: $$ident. Please document it at the media DocBook!" >&2;	\
+	  fi;								\
 	done)
 	@(								\
 	echo -e "\n<!-- Defines -->") >>$@
-- 
2.4.1

