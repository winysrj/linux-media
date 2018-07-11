Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:50684 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732530AbeGKN1W (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 11 Jul 2018 09:27:22 -0400
From: Ezequiel Garcia <ezequiel@collabora.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Peter Korsgaard <jacmet@sunsite.dk>,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH] libv4l: fixup lfs mismatch in preload libraries
Date: Wed, 11 Jul 2018 10:22:51 -0300
Message-Id: <20180711132251.13172-1-ezequiel@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Peter Korsgaard <jacmet@sunsite.dk>

Ensure that the lfs variants are not transparently used instead of the !lfs
ones so both can be wrapped, independently of any custom CFLAGS/CPPFLAGS.

Without this patch, the following assembler errors appear
during cross-compiling with Buildroot:

/tmp/ccc3gdJg.s: Assembler messages:
/tmp/ccc3gdJg.s:67: Error: symbol `open64' is already defined
/tmp/ccc3gdJg.s:130: Error: symbol `mmap64' is already defined

Signed-off-by: Peter Korsgaard <jacmet@sunsite.dk>
Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
---
 lib/libv4l1/v4l1compat.c  | 3 +++
 lib/libv4l2/v4l2convert.c | 3 +++
 2 files changed, 6 insertions(+)

diff --git a/lib/libv4l1/v4l1compat.c b/lib/libv4l1/v4l1compat.c
index cb79629ff88f..e5c9e56261e2 100644
--- a/lib/libv4l1/v4l1compat.c
+++ b/lib/libv4l1/v4l1compat.c
@@ -19,6 +19,9 @@
 # Foundation, Inc., 51 Franklin Street, Suite 500, Boston, MA  02110-1335  USA
  */
 
+/* ensure we see *64 variants and they aren't transparently used */
+#undef _LARGEFILE_SOURCE
+#undef _FILE_OFFSET_BITS
 #define _LARGEFILE64_SOURCE 1
 
 #include <config.h>
diff --git a/lib/libv4l2/v4l2convert.c b/lib/libv4l2/v4l2convert.c
index 7c9a04c086ed..13ca4cfb1b08 100644
--- a/lib/libv4l2/v4l2convert.c
+++ b/lib/libv4l2/v4l2convert.c
@@ -23,6 +23,9 @@
 /* prevent GCC 4.7 inlining error */
 #undef _FORTIFY_SOURCE
 
+/* ensure we see *64 variants and they aren't transparently used */
+#undef _LARGEFILE_SOURCE
+#undef _FILE_OFFSET_BITS
 #define _LARGEFILE64_SOURCE 1
 
 #ifdef ANDROID
-- 
2.18.0.rc2
