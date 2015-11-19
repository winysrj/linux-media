Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:42054 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933432AbbKSOjC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Nov 2015 09:39:02 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Ben Hutchings <ben@decadent.org.uk>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Lukas Wunner <lukas@wunner.de>,
	Daniel Baluta <daniel.baluta@intel.com>,
	Michal Marek <mmarek@suse.cz>,
	Danilo Cesar Lemes de Paula <danilo.cesar@collabora.co.uk>,
	linux-doc@vger.kernel.org
Subject: [PATCH 3/3] DocBook: make index.html generation less verbose by default
Date: Thu, 19 Nov 2015 12:38:46 -0200
Message-Id: <4178c97531d615b88b2208ad6fd1284b4fc50519.1447943571.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1447943571.git.mchehab@osg.samsung.com>
References: <cover.1447943571.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1447943571.git.mchehab@osg.samsung.com>
References: <cover.1447943571.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When make htmldocs is called on non-verbose mode, it will still be
verbose with index.html generation for no good reason, printing:

	rm -rf Documentation/DocBook/index.html; echo '<h1>Linux Kernel HTML Documentation</h1>' >> Documentation/DocBook/index.html && echo '<h2>Kernel Version: 4.4.0-rc1</h2>' >> Documentation/DocBook/index.html && cat Documentation/DocBook/iio.html >> Documentation/DocBook/index.html

Instead, use the standard non-verbose mode, using:

	  HTML    Documentation/DocBook/index.html

if not called with V=1.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 Documentation/DocBook/Makefile | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/Documentation/DocBook/Makefile b/Documentation/DocBook/Makefile
index 5b4176673ada..d70f9b68174e 100644
--- a/Documentation/DocBook/Makefile
+++ b/Documentation/DocBook/Makefile
@@ -50,7 +50,7 @@ pdfdocs: $(PDF)
 
 HTML := $(sort $(patsubst %.xml, %.html, $(BOOKS)))
 htmldocs: $(HTML)
-	$(call build_main_index)
+	$(call cmd,build_main_index)
 	$(call install_media_images)
 
 MAN := $(patsubst %.xml, %.9, $(BOOKS))
@@ -138,7 +138,8 @@ quiet_cmd_db2pdf = PDF     $@
 
 index = index.html
 main_idx = $(obj)/$(index)
-build_main_index = rm -rf $(main_idx); \
+quiet_cmd_build_main_index = HTML    $(main_idx)
+      cmd_build_main_index = rm -rf $(main_idx); \
 		   echo '<h1>Linux Kernel HTML Documentation</h1>' >> $(main_idx) && \
 		   echo '<h2>Kernel Version: $(KERNELVERSION)</h2>' >> $(main_idx) && \
 		   cat $(HTML) >> $(main_idx)
-- 
2.5.0


