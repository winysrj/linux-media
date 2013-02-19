Return-path: <linux-media-owner@vger.kernel.org>
Received: from infernal.debian.net ([176.28.9.132]:51473 "EHLO
	infernal.debian.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933239Ab3BSVD4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Feb 2013 16:03:56 -0500
Date: Tue, 19 Feb 2013 22:03:53 +0100
From: Andreas Bombe <aeb@debian.org>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [media-ctl PATCH] Fix linking of shared libraries
Message-ID: <20130219210353.GA6935@amos.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When using libudev, it is actually libmediactl that uses it and not the
media-ctl executable. libv4l2subdev uses functions from libmediactl and
therefore needs to be linked against it.

Signed-off-by: Andreas Bombe <aeb@debian.org>
---

In light of their relative simplicity as well as cross dependency, does
it make sense to keep libmediactl and libv4l2subdev as separate
libraries?

 src/Makefile.am |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/src/Makefile.am b/src/Makefile.am
index 2583464..f754763 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -1,12 +1,12 @@
 lib_LTLIBRARIES = libmediactl.la libv4l2subdev.la
 libmediactl_la_SOURCES = mediactl.c
+libmediactl_la_CFLAGS = $(LIBUDEV_CFLAGS)
+libmediactl_la_LDFLAGS = $(LIBUDEV_LIBS)
 libv4l2subdev_la_SOURCES = v4l2subdev.c
+libv4l2subdev_la_LIBADD = libmediactl.la
 mediactl_includedir=$(includedir)/mediactl
 mediactl_include_HEADERS = mediactl.h v4l2subdev.h
 
 bin_PROGRAMS = media-ctl
-media_ctl_CFLAGS = $(LIBUDEV_CFLAGS)
-media_ctl_LDFLAGS = $(LIBUDEV_LIBS)
 media_ctl_SOURCES = main.c options.c options.h tools.h
 media_ctl_LDADD = libmediactl.la libv4l2subdev.la
-
-- 
1.7.10.4

