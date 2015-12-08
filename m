Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:39924 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751267AbbLHPVW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 8 Dec 2015 10:21:22 -0500
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl
Subject: [v4l-utils PATCH 1/1] Allow building static binaries
Date: Tue,  8 Dec 2015 17:18:21 +0200
Message-Id: <1449587901-12784-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

	$ LDFLAGS="--static -static" ./configure --enable-static
	$ LDFLAGS=-static make

can be used to create static binaries. The issue was that shared libraries
were attempted to link statically which naturally failed.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 lib/libv4l1/Makefile.am | 3 +--
 lib/libv4l2/Makefile.am | 3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/lib/libv4l1/Makefile.am b/lib/libv4l1/Makefile.am
index 005ae10..c325390 100644
--- a/lib/libv4l1/Makefile.am
+++ b/lib/libv4l1/Makefile.am
@@ -23,7 +23,6 @@ libv4l1_la_LIBADD = ../libv4l2/libv4l2.la
 v4l1compat_la_SOURCES = v4l1compat.c
 
 v4l1compat_la_LIBADD = libv4l1.la
-v4l1compat_la_LDFLAGS = -avoid-version -module -shared -export-dynamic
-v4l1compat_la_LIBTOOLFLAGS = --tag=disable-static
+v4l1compat_la_LDFLAGS = -avoid-version -module -export-dynamic
 
 EXTRA_DIST = libv4l1-kernelcode-license.txt
diff --git a/lib/libv4l2/Makefile.am b/lib/libv4l2/Makefile.am
index b6f4d3b..878ccd9 100644
--- a/lib/libv4l2/Makefile.am
+++ b/lib/libv4l2/Makefile.am
@@ -22,7 +22,6 @@ libv4l2_la_LIBADD = ../libv4lconvert/libv4lconvert.la
 
 v4l2convert_la_SOURCES = v4l2convert.c
 v4l2convert_la_LIBADD = libv4l2.la
-v4l2convert_la_LDFLAGS = -avoid-version -module -shared -export-dynamic
-v4l2convert_la_LIBTOOLFLAGS = --tag=disable-static
+v4l2convert_la_LDFLAGS = -avoid-version -module -export-dynamic
 
 EXTRA_DIST = Android.mk v4l2-plugin-android.c
-- 
2.1.0.231.g7484e3b

