Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f46.google.com ([209.85.214.46]:37100 "EHLO
	mail-it0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529AbcFOJ0W (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Jun 2016 05:26:22 -0400
Received: by mail-it0-f46.google.com with SMTP id e5so15349034ith.0
        for <linux-media@vger.kernel.org>; Wed, 15 Jun 2016 02:26:21 -0700 (PDT)
From: Patrick Ohly <patrick.ohly@intel.com>
To: linux-media@vger.kernel.org
Cc: patrick.ohly@intel.com
Subject: [PATCH] jpeg_memsrcdest: extend feature check
Date: Wed, 15 Jun 2016 11:26:05 +0200
Message-Id: <1465982765-580-1-git-send-email-patrick.ohly@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

libjpeg.h in OpenEmbedded master (from libjpeg-turbo 1.5.0) provides
these methods if "JPEG_LIB_VERSION >= 80 ||
defined(MEM_SRCDST_SUPPORTED)".

The support for the jpeg_mem functions was added even when not
emulating the libjpeg8 API, controlled via the MEM_SRCDST_SUPPORTED
define, so checking for the version alone is not enough anymore.

See https://github.com/libjpeg-turbo/libjpeg-turbo/commit/ab70623eb29e09e67222be5b9e1ea320fe5aa0e9

This fixes errors about conflicting declarations (signed vs. unsigned
char).

Signed-off-by: Patrick Ohly <patrick.ohly@intel.com>
---
 lib/libv4lconvert/jpeg_memsrcdest.c | 4 ++--
 lib/libv4lconvert/jpeg_memsrcdest.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/lib/libv4lconvert/jpeg_memsrcdest.c b/lib/libv4lconvert/jpeg_memsrcdest.c
index 323e7af..578c465 100644
--- a/lib/libv4lconvert/jpeg_memsrcdest.c
+++ b/lib/libv4lconvert/jpeg_memsrcdest.c
@@ -30,8 +30,8 @@
 #include "jpeg_memsrcdest.h"
 
 /* libjpeg8 and later come with their own (API compatible) memory source
-   and dest */
-#if JPEG_LIB_VERSION < 80
+   and dest, and older versions may have it backported */
+#if JPEG_LIB_VERSION < 80 && !defined(MEM_SRCDST_SUPPORTED)
 
 /* Expanded data source object for memory input */
 
diff --git a/lib/libv4lconvert/jpeg_memsrcdest.h b/lib/libv4lconvert/jpeg_memsrcdest.h
index 28a6477..b13bf3f 100644
--- a/lib/libv4lconvert/jpeg_memsrcdest.h
+++ b/lib/libv4lconvert/jpeg_memsrcdest.h
@@ -1,6 +1,6 @@
 #include <jpeglib.h>
 
-#if JPEG_LIB_VERSION < 80
+#if JPEG_LIB_VERSION < 80 && !defined(MEM_SRCDST_SUPPORTED)
 
 void
 jpeg_mem_src (j_decompress_ptr cinfo, unsigned char * buffer,
-- 
2.1.4

