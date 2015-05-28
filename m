Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51333 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754736AbbE1Vto (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 May 2015 17:49:44 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [PATCH 18/35] DocBook: remove duplicated ioctl from v4l2-subdev
Date: Thu, 28 May 2015 18:49:21 -0300
Message-Id: <474a59d6386e0e2160c5280bf17d89ada439b188.1432844837.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1432844837.git.mchehab@osg.samsung.com>
References: <cover.1432844837.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1432844837.git.mchehab@osg.samsung.com>
References: <cover.1432844837.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Those ioctls are already parsed. No need to explicitly add
them.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/Documentation/DocBook/media/Makefile b/Documentation/DocBook/media/Makefile
index fdb0027f353c..c82e051f2821 100644
--- a/Documentation/DocBook/media/Makefile
+++ b/Documentation/DocBook/media/Makefile
@@ -65,13 +65,6 @@ IOCTLS = \
 	$(shell perl -ne 'print "$$1 " if /\#define\s+([^\s]+)\s+_IO/' $(srctree)/include/uapi/linux/dvb/video.h) \
 	$(shell perl -ne 'print "$$1 " if /\#define\s+([^\s]+)\s+_IO/' $(srctree)/include/uapi/linux/media.h) \
 	$(shell perl -ne 'print "$$1 " if /\#define\s+([^\s]+)\s+_IO/' $(srctree)/include/uapi/linux/v4l2-subdev.h) \
-	VIDIOC_SUBDEV_G_FRAME_INTERVAL \
-	VIDIOC_SUBDEV_S_FRAME_INTERVAL \
-	VIDIOC_SUBDEV_ENUM_MBUS_CODE \
-	VIDIOC_SUBDEV_ENUM_FRAME_SIZE \
-	VIDIOC_SUBDEV_ENUM_FRAME_INTERVAL \
-	VIDIOC_SUBDEV_G_SELECTION \
-	VIDIOC_SUBDEV_S_SELECTION \
 
 DEFINES = \
 	$(shell perl -ne 'print "$$1 " if /\#define\s+(DTV_[^\s]+)\s+/' $(srctree)/include/uapi/linux/dvb/frontend.h) \
-- 
2.4.1

