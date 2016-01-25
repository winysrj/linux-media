Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:29422 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757027AbcAYMnJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Jan 2016 07:43:09 -0500
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl
Subject: [v4l-utils PATCH 1/2] v4l: libv4l1, libv4l2: Use $(mkdir_p) instead of deprecated $(MKDIR_P)
Date: Mon, 25 Jan 2016 14:41:23 +0200
Message-Id: <1453725684-4561-2-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1453725684-4561-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1453725684-4561-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

autoconf thinks $(MKDIR_P) is deprecated. Use $(mkdir_p) instead.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 lib/libv4l1/Makefile.am | 2 +-
 lib/libv4l2/Makefile.am | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/libv4l1/Makefile.am b/lib/libv4l1/Makefile.am
index 005ae10..f768eaa 100644
--- a/lib/libv4l1/Makefile.am
+++ b/lib/libv4l1/Makefile.am
@@ -7,7 +7,7 @@ if WITH_V4L_WRAPPERS
 libv4l1priv_LTLIBRARIES = v4l1compat.la
 
 install-exec-hook:
-	$(MKDIR_P) $(DESTDIR)/$(libdir)
+	$(mkdir_p) $(DESTDIR)/$(libdir)
 	(cd $(DESTDIR)/$(libdir) && rm -f v4l1compat.so && $(LN_S) $(libv4l1subdir)/v4l1compat.so v4l1compat.so)
 
 endif
diff --git a/lib/libv4l2/Makefile.am b/lib/libv4l2/Makefile.am
index b6f4d3b..1314a99 100644
--- a/lib/libv4l2/Makefile.am
+++ b/lib/libv4l2/Makefile.am
@@ -7,7 +7,7 @@ if WITH_V4L_WRAPPERS
 libv4l2priv_LTLIBRARIES = v4l2convert.la
 
 install-exec-hook:
-	$(MKDIR_P) $(DESTDIR)/$(libdir)
+	$(mkdir_p) $(DESTDIR)/$(libdir)
 	(cd $(DESTDIR)/$(libdir) && rm -f v4l2convert.so && $(LN_S) $(libv4l2subdir)/v4l2convert.so v4l2convert.so)
 
 endif
-- 
2.1.0.231.g7484e3b

