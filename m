Return-path: <linux-media-owner@vger.kernel.org>
Received: from sub5.mail.dreamhost.com ([208.113.200.129]:34904 "EHLO
        homiemail-a80.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1756870AbeDZR1m (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 26 Apr 2018 13:27:42 -0400
From: Brad Love <brad@nextdimension.cc>
To: linux-media@vger.kernel.org
Cc: Brad Love <brad@nextdimension.cc>
Subject: [PATCH 7/7] Add config-compat.h override config-mycompat.h
Date: Thu, 26 Apr 2018 12:19:22 -0500
Message-Id: <1524763162-4865-8-git-send-email-brad@nextdimension.cc>
In-Reply-To: <1524763162-4865-1-git-send-email-brad@nextdimension.cc>
References: <1524763162-4865-1-git-send-email-brad@nextdimension.cc>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

config-mycompat.h is for overriding macros which are incorrectly
enabled on certain kernels by the build system. The file should be
left empty, unless build errors are encountered for a kernel. The
file is removed by distclean, therefore should be externally
sourced, before the build process starts, when required.

In standard operation the file is empty, but if a particular kernel has
incorrectly enabled options defined this allows them to be undefined.

Signed-off-by: Brad Love <brad@nextdimension.cc>
---
 v4l/Makefile | 3 ++-
 v4l/compat.h | 7 +++++++
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/v4l/Makefile b/v4l/Makefile
index 270a624..ee18d11 100644
--- a/v4l/Makefile
+++ b/v4l/Makefile
@@ -273,6 +273,7 @@ links::
 	@find ../linux/drivers/misc -name '*.[ch]' -type f -print0 | xargs -0n 255 ln -sf --target-directory=.
 
 config-compat.h:: $(obj)/.version .myconfig scripts/make_config_compat.pl
+	-touch $(obj)/config-mycompat.h
 	perl scripts/make_config_compat.pl $(SRCDIR) $(obj)/.myconfig $(obj)/config-compat.h
 
 kernel-links makelinks::
@@ -298,7 +299,7 @@ clean::
 distclean:: clean
 	-rm -f .version .*.o.flags .*.o.d *.mod.gcno Makefile.media \
 		Kconfig Kconfig.kern .config .config.cmd .myconfig \
-		.kconfig.dep
+		.kconfig.dep config-mycompat.h
 	-rm -rf .tmp_versions .tmp*.ver .tmp*.o .*.gcno .cache.mk
 	-rm -f scripts/lxdialog scripts/kconfig
 	@find .. -name '*.orig' -exec rm '{}' \;
diff --git a/v4l/compat.h b/v4l/compat.h
index 87ce401..db48fdf 100644
--- a/v4l/compat.h
+++ b/v4l/compat.h
@@ -8,6 +8,13 @@
 #include <linux/version.h>
 
 #include "config-compat.h"
+/* config-mycompat.h is for overriding #defines which
+ * are incorrectly enabled on certain kernels. The file
+ * should be left empty, unless build errors are encountered
+ * for a kernel. The file is removed by distclean, therefore
+ * should be externally sourced, before compilation, when required.
+ */
+#include "config-mycompat.h"
 
 #ifndef SZ_512
 #define SZ_512				0x00000200
-- 
2.7.4
