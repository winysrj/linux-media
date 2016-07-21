Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:65471 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753001AbcGUPQL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Jul 2016 11:16:11 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl
Subject: [v4l-utils RFC 1/3] mediatext: Extract list of V4L2 pixel format strings and 4cc codes
Date: Thu, 21 Jul 2016 18:15:44 +0300
Message-Id: <1469114146-11109-2-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1469114146-11109-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1469114146-11109-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Extract the list of V4L2 pixel format strings and 4cc codes from
videodev2.h for use in mediatext in order to convert user given format
names to 4cc codes that IOCTLs use.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 utils/media-ctl/Makefile.am | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/utils/media-ctl/Makefile.am b/utils/media-ctl/Makefile.am
index ee7dcc9..8fe653d 100644
--- a/utils/media-ctl/Makefile.am
+++ b/utils/media-ctl/Makefile.am
@@ -12,7 +12,12 @@ media-bus-format-codes.h: ../../include/linux/media-bus-format.h
 	sed -e '/#define MEDIA_BUS_FMT/ ! d; s/.*#define //; /FIXED/ d; s/\t.*//; s/.*/ &,/;' \
 	< $< > $@
 
-BUILT_SOURCES = media-bus-format-names.h media-bus-format-codes.h
+v4l2-pix-formats.h: ../../include/linux/videodev2.h
+	sed -e '/#define V4L2_PIX_FMT_/ ! d; s/.*FMT_//; s/[\t ].*//; s/.*/{ \"&\", V4L2_PIX_FMT_& },/;' \
+	< $< > $@
+
+BUILT_SOURCES = media-bus-format-names.h media-bus-format-codes.h \
+	v4l2-pix-formats.h
 CLEANFILES = $(BUILT_SOURCES)
 
 nodist_libv4l2subdev_la_SOURCES = $(BUILT_SOURCES)
-- 
2.7.4

