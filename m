Return-path: <linux-media-owner@vger.kernel.org>
Received: from sub5.mail.dreamhost.com ([208.113.200.129]:42853 "EHLO
        homiemail-a125.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750711AbeEKRXP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 11 May 2018 13:23:15 -0400
From: Brad Love <brad@nextdimension.cc>
To: linux-media@vger.kernel.org, hverkuil@xs4all.nl
Cc: Brad Love <brad@nextdimension.cc>
Subject: [PATCH v2] Add config-compat.h override config-mycompat.h
Date: Fri, 11 May 2018 12:23:02 -0500
Message-Id: <1526059382-7781-1-git-send-email-brad@nextdimension.cc>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

config-mycompat.h is for use with kernels/distros whose maintainers have
integrated various backports, which the media_build system does not
detect for whatever reason. At that point there are options defined in
config-compat.h, which enable backports in compat.h, but which
already exist in the target kernel. This allows disabling of specific
backports for a particular build, allowing compliation to succeed.

For example, if the following three statements exist in config-mycompat.h:

#undef NEED_WRITEL_RELAXED
#undef NEED_PM_RUNTIME_GET
#undef NEED_PFN_TO_PHYS

Those three media_build backports will be disabled in compat.h and
compilation on a problematic kernel will succeed without issue.
conifg-mycompat.h should be used strictly for disabling media_build
backports causing compilation issues. The file will usually be
left empty, unless needed.

WARNING:
  v4l/config-mycompat.h is removed by distclean, the file
  should be saved externally and copied into v4l/ when required.

Signed-off-by: Brad Love <brad@nextdimension.cc>
---
Since v1:
- Make the description and explanation of config-mycompat.h purpose
  and usage as explicit as possible for clarity sake.

 v4l/Makefile |  3 ++-
 v4l/compat.h | 23 +++++++++++++++++++++++
 2 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/v4l/Makefile b/v4l/Makefile
index 270a624..385fa83 100644
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
index b93750f..34b7f3a 100644
--- a/v4l/compat.h
+++ b/v4l/compat.h
@@ -8,6 +8,29 @@
 #include <linux/version.h>
 
 #include "config-compat.h"
+/*
+ * config-mycompat.h is for use with kernels/distros whose maintainers
+ * have integrated various backports, which the media_build system does
+ * not pick up on for whatever reason. At that point there are options
+ * defined in config-compat.h, which enable backports here, in compat.h,
+ * but which already exist in the target kernel. This allows disabling of
+ * specific backports for a particular build, allowing compliation to succeed.
+
+ * For example, if the following three statements exist in config-mycompat.h:
+
+ * #undef NEED_WRITEL_RELAXED
+ * #undef NEED_PM_RUNTIME_GET
+ * #undef NEED_PFN_TO_PHYS
+
+ * Those three media_build backports will be disabled in this file and
+ * compilation on a problematic kernel will succeed without issue.
+ * conifg-mycompat.h should be used strictly for disabling media_build
+ * backports causing compilation issues. It will typically be left empty.
+ *
+ * WARNING: v4l/config-mycompat.h is removed by distclean, the file
+ * should be saved externally and copied into v4l/ when required.
+ */
+#include "config-mycompat.h"
 
 #ifndef SZ_512
 #define SZ_512				0x00000200
-- 
2.7.4
