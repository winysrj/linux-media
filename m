Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:30917 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751766AbcBUVcF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Feb 2016 16:32:05 -0500
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl
Subject: [v4l-utils PATCH 2/4] libv4l2subdev: Use generated format definitions in libv4l2subdev
Date: Sun, 21 Feb 2016 23:29:45 +0200
Message-Id: <1456090187-1191-3-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1456090187-1191-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1456090187-1191-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of manually adding each and every new media bus pixel code to
libv4l2subdev, generate the list automatically. The pre-existing formats
that do not match the list are not modified so that existing users are
unaffected by this change, with the exception of converting codes to
strings, which will use the new definitions.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 utils/media-ctl/.gitignore      | 1 +
 utils/media-ctl/Makefile.am     | 8 ++++++++
 utils/media-ctl/libv4l2subdev.c | 1 +
 3 files changed, 10 insertions(+)

diff --git a/utils/media-ctl/.gitignore b/utils/media-ctl/.gitignore
index 95b6a57..799ab33 100644
--- a/utils/media-ctl/.gitignore
+++ b/utils/media-ctl/.gitignore
@@ -1 +1,2 @@
 media-ctl
+media-bus-format-names.h
diff --git a/utils/media-ctl/Makefile.am b/utils/media-ctl/Makefile.am
index a3931fb..23ad90b 100644
--- a/utils/media-ctl/Makefile.am
+++ b/utils/media-ctl/Makefile.am
@@ -4,6 +4,14 @@ libmediactl_la_SOURCES = libmediactl.c mediactl-priv.h
 libmediactl_la_CFLAGS = -static $(LIBUDEV_CFLAGS)
 libmediactl_la_LDFLAGS = -static $(LIBUDEV_LIBS)
 
+media-bus-format-names.h: ../../include/linux/media-bus-format.h
+	sed -e '/#define MEDIA_BUS_FMT/ ! d; s/.*FMT_//; /FIXED/ d; s/\t.*//; s/.*/{ \"&\", MEDIA_BUS_FMT_& },/;' \
+	< $< > $@
+
+BUILT_SOURCES = media-bus-format-names.h
+CLEANFILES = $(BUILT_SOURCES)
+
+nodist_libv4l2subdev_la_SOURCES = $(BUILT_SOURCES)
 libv4l2subdev_la_SOURCES = libv4l2subdev.c
 libv4l2subdev_la_LIBADD = libmediactl.la
 libv4l2subdev_la_CFLAGS = -static
diff --git a/utils/media-ctl/libv4l2subdev.c b/utils/media-ctl/libv4l2subdev.c
index e45834f..f3c0a9a 100644
--- a/utils/media-ctl/libv4l2subdev.c
+++ b/utils/media-ctl/libv4l2subdev.c
@@ -719,6 +719,7 @@ static const struct {
 	const char *name;
 	enum v4l2_mbus_pixelcode code;
 } mbus_formats[] = {
+#include "media-bus-format-names.h"
 	{ "Y8", MEDIA_BUS_FMT_Y8_1X8},
 	{ "Y10", MEDIA_BUS_FMT_Y10_1X10 },
 	{ "Y12", MEDIA_BUS_FMT_Y12_1X12 },
-- 
2.1.0.231.g7484e3b

