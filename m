Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34453 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933076Ab0BYReJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Feb 2010 12:34:09 -0500
Date: Thu, 25 Feb 2010 14:33:27 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCHv2 1/4] DocBook/Makefile: Make it less verbose
Message-ID: <20100225143327.4e4fc43e@pedra>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Don't show build commants for html main file and media dir cration if V=0.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

Conflicts:

	Documentation/DocBook/Makefile

diff --git a/Documentation/DocBook/Makefile b/Documentation/DocBook/Makefile
index 325cfd1..7c590ef 100644
--- a/Documentation/DocBook/Makefile
+++ b/Documentation/DocBook/Makefile
@@ -46,8 +46,9 @@ pdfdocs: $(PDF)
 
 HTML := $(sort $(patsubst %.xml, %.html, $(BOOKS)))
 htmldocs: $(HTML)
-	$(call build_main_index)
-	$(call build_images)
+	@$($(quiet)cmd_build_main_index)
+	@$($(call build_main_index))
+	@($(call build_images))
 
 MAN := $(patsubst %.xml, %.9, $(BOOKS))
 mandocs: $(MAN)
@@ -145,6 +146,8 @@ quiet_cmd_db2pdf = PDF     $@
 %.pdf : %.xml
 	$(call cmd,db2pdf)
 
+      cmd_build_main_index = :
+quiet_cmd_build_main_index = echo '  BUILD   $@'
 
 index = index.html
 main_idx = Documentation/DocBook/$(index)
-- 
1.6.6.1


