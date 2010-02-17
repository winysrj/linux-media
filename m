Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751846Ab0BQRH4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Feb 2010 12:07:56 -0500
Message-ID: <4B7C2267.6050302@redhat.com>
Date: Wed, 17 Feb 2010 15:07:51 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: randy dunlap <randy.dunlap@oracle.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/4] DocBook/Makefile: Make it less verbose
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Don't show build commands for html main file and media dir creation, if V=0.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

---
 Documentation/DocBook/Makefile |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

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

