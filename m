Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:42041 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076AbbKSOjA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Nov 2015 09:39:00 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Ben Hutchings <ben@decadent.org.uk>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Michal Marek <mmarek@suse.cz>,
	Daniel Baluta <daniel.baluta@intel.com>,
	Jim Davis <jim.epost@gmail.com>,
	Danilo Cesar Lemes de Paula <danilo.cesar@collabora.co.uk>,
	linux-doc@vger.kernel.org
Subject: [PATCH 2/3] DocBook: Cleanup: remove an unused $(call) line
Date: Thu, 19 Nov 2015 12:38:45 -0200
Message-Id: <9cfe95c36787dc28543fb2e167db6d5efe88cda9.1447943571.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1447943571.git.mchehab@osg.samsung.com>
References: <cover.1447943571.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1447943571.git.mchehab@osg.samsung.com>
References: <cover.1447943571.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There's no build_images function to call. So remove it.

This is just a cleanup patch, with doesn't affect the build.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 Documentation/DocBook/Makefile | 1 -
 1 file changed, 1 deletion(-)

diff --git a/Documentation/DocBook/Makefile b/Documentation/DocBook/Makefile
index bab296c5f565..5b4176673ada 100644
--- a/Documentation/DocBook/Makefile
+++ b/Documentation/DocBook/Makefile
@@ -51,7 +51,6 @@ pdfdocs: $(PDF)
 HTML := $(sort $(patsubst %.xml, %.html, $(BOOKS)))
 htmldocs: $(HTML)
 	$(call build_main_index)
-	$(call build_images)
 	$(call install_media_images)
 
 MAN := $(patsubst %.xml, %.9, $(BOOKS))
-- 
2.5.0


