Return-path: <linux-media-owner@vger.kernel.org>
Received: from sub5.mail.dreamhost.com ([208.113.200.129]:41181 "EHLO
        homiemail-a120.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752054AbeERTYZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 May 2018 15:24:25 -0400
From: Brad Love <brad@nextdimension.cc>
To: linux-media@vger.kernel.org, jasmin@anw.at
Cc: Brad Love <brad@nextdimension.cc>
Subject: [PATCH] Fix spurious config-mycompat.h warnings
Date: Fri, 18 May 2018 14:24:19 -0500
Message-Id: <1526671459-19247-1-git-send-email-brad@nextdimension.cc>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Apparently a zero byte file size leads to "could not open" warnings.
Adding a single comment to the file removes the warnings displayed
after compilation.

To prevent overwriting a user supplied config-mycompat.h the file
is only created if it does not already exist.

Also fix for possible spaces in the path.

Works without warning when using both the do-it-all build script
as well as manual operation via make targets.

Signed-off-by: Brad Love <brad@nextdimension.cc>
---
 v4l/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/v4l/Makefile b/v4l/Makefile
index 385fa83..a7c7b60 100644
--- a/v4l/Makefile
+++ b/v4l/Makefile
@@ -273,7 +273,7 @@ links::
 	@find ../linux/drivers/misc -name '*.[ch]' -type f -print0 | xargs -0n 255 ln -sf --target-directory=.
 
 config-compat.h:: $(obj)/.version .myconfig scripts/make_config_compat.pl
-	-touch $(obj)/config-mycompat.h
+	[ ! -f "$(obj)/config-mycompat.h" ] && echo "/* empty config-mycompat.h */" > "$(obj)/config-mycompat.h" || true
 	perl scripts/make_config_compat.pl $(SRCDIR) $(obj)/.myconfig $(obj)/config-compat.h
 
 kernel-links makelinks::
-- 
2.7.4
