Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:60040 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933687AbcCNVKH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Mar 2016 17:10:07 -0400
Received: from localhost.localdomain (localhost [127.0.0.1])
	by smtp.gentoo.org (Postfix) with ESMTP id F1DE1340A5C
	for <linux-media@vger.kernel.org>; Mon, 14 Mar 2016 21:10:04 +0000 (UTC)
From: Mike Frysinger <vapier@gentoo.org>
To: linux-media@vger.kernel.org
Subject: [PATCH] include sys/sysmacros.h for major() & minor()
Date: Mon, 14 Mar 2016 17:10:03 -0400
Message-Id: <1457989803-7148-1-git-send-email-vapier@gentoo.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Linux C libraries are looking to disentangle sysmacros.h from the
sys/types.h header to clean up namespace pollution.  Since these
macros are provided in glibc/etc... today, switch to pulling in
this header directly.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 contrib/test/mc_nextgen_test.c            | 1 +
 lib/libv4lconvert/control/libv4lcontrol.c | 1 +
 utils/libmedia_dev/get_media_devices.c    | 1 +
 utils/media-ctl/libmediactl.c             | 1 +
 4 files changed, 4 insertions(+)

diff --git a/contrib/test/mc_nextgen_test.c b/contrib/test/mc_nextgen_test.c
index a62fd13..4ba37b0 100644
--- a/contrib/test/mc_nextgen_test.c
+++ b/contrib/test/mc_nextgen_test.c
@@ -28,6 +28,7 @@
 #include <syslog.h>
 #include <stdio.h>
 #include <sys/types.h>
+#include <sys/sysmacros.h>
 #include <sys/stat.h>
 #include <sys/ioctl.h>
 #include <fcntl.h>
diff --git a/lib/libv4lconvert/control/libv4lcontrol.c b/lib/libv4lconvert/control/libv4lcontrol.c
index 3c8335c..59f28b1 100644
--- a/lib/libv4lconvert/control/libv4lcontrol.c
+++ b/lib/libv4lconvert/control/libv4lcontrol.c
@@ -20,6 +20,7 @@
  */
 
 #include <sys/types.h>
+#include <sys/sysmacros.h>
 #include <sys/mman.h>
 #include <fcntl.h>
 #include <sys/stat.h>
diff --git a/utils/libmedia_dev/get_media_devices.c b/utils/libmedia_dev/get_media_devices.c
index e3a2200..edfeb41 100644
--- a/utils/libmedia_dev/get_media_devices.c
+++ b/utils/libmedia_dev/get_media_devices.c
@@ -20,6 +20,7 @@
 #include <stdio.h>
 #include <unistd.h>
 #include <sys/types.h>
+#include <sys/sysmacros.h>
 #include <sys/stat.h>
 #include <string.h>
 #include <stdlib.h>
diff --git a/utils/media-ctl/libmediactl.c b/utils/media-ctl/libmediactl.c
index 4a82d24..16dddbe 100644
--- a/utils/media-ctl/libmediactl.c
+++ b/utils/media-ctl/libmediactl.c
@@ -24,6 +24,7 @@
 #include <sys/ioctl.h>
 #include <sys/stat.h>
 #include <sys/types.h>
+#include <sys/sysmacros.h>
 
 #include <ctype.h>
 #include <errno.h>
-- 
2.6.2

