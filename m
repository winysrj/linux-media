Return-path: <linux-media-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53029 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755656AbaJUQSP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Oct 2014 12:18:15 -0400
From: Takashi Iwai <tiwai@suse.de>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-doc@vger.kernel.org, linux-media@vger.kernel.org
Subject: [PATCH] DocBook: Reduce noise from make cleandocs
Date: Tue, 21 Oct 2014 18:18:12 +0200
Message-Id: <1413908292-26560-1-git-send-email-tiwai@suse.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I've got a harmless warning when running make cleandocs on an already
cleaned tree:
  Documentation/DocBook/media/Makefile:28: recipe for target 'cleanmediadocs' failed
  make[1]: [cleanmediadocs] Error 1 (ignored)

Suppress this by passing -f to rm.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
---
 Documentation/DocBook/media/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/DocBook/media/Makefile b/Documentation/DocBook/media/Makefile
index df2962d9e11e..8bf7c6191296 100644
--- a/Documentation/DocBook/media/Makefile
+++ b/Documentation/DocBook/media/Makefile
@@ -25,7 +25,7 @@ GENFILES := $(addprefix $(MEDIA_OBJ_DIR)/, $(MEDIA_TEMP))
 PHONY += cleanmediadocs
 
 cleanmediadocs:
-	-@rm `find $(MEDIA_OBJ_DIR) -type l` $(GENFILES) $(OBJIMGFILES) 2>/dev/null
+	-@rm -f `find $(MEDIA_OBJ_DIR) -type l` $(GENFILES) $(OBJIMGFILES) 2>/dev/null
 
 $(obj)/media_api.xml: $(GENFILES) FORCE
 
-- 
2.1.2

