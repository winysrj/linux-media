Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:40387 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753271AbbHVR2f (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 22 Aug 2015 13:28:35 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-doc@vger.kernel.org
Subject: [PATCH 27/39] [media] v4l2-mediabus: Add to DocBook
Date: Sat, 22 Aug 2015 14:28:12 -0300
Message-Id: <c8b166b3905b74ffe0a1398c9cfef2b5aaad5d05.1440264165.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440264165.git.mchehab@osg.samsung.com>
References: <cover.1440264165.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440264165.git.mchehab@osg.samsung.com>
References: <cover.1440264165.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix the format of the comments and add to DocBook.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/Documentation/DocBook/device-drivers.tmpl b/Documentation/DocBook/device-drivers.tmpl
index 8d1e04c94dce..53a7c5d8b996 100644
--- a/Documentation/DocBook/device-drivers.tmpl
+++ b/Documentation/DocBook/device-drivers.tmpl
@@ -236,9 +236,7 @@ X!Isound/sound_firmware.c
 !Iinclude/media/v4l2-dv-timings.h
 !Iinclude/media/videobuf2-core.h
 !Iinclude/media/videobuf2-memops.h
-<!-- FIXME: Removed for now due to document generation inconsistency
-X!Iinclude/media/v4l2-mediabus.h
--->
+!Iinclude/media/v4l2-mediabus.h
 
   </chapter>
 
diff --git a/include/media/v4l2-mediabus.h b/include/media/v4l2-mediabus.h
index 73069e4c2796..34cc99e093ef 100644
--- a/include/media/v4l2-mediabus.h
+++ b/include/media/v4l2-mediabus.h
@@ -65,7 +65,7 @@
 					 V4L2_MBUS_CSI2_CHANNEL_2 | V4L2_MBUS_CSI2_CHANNEL_3)
 
 /**
- * v4l2_mbus_type - media bus type
+ * enum v4l2_mbus_type - media bus type
  * @V4L2_MBUS_PARALLEL:	parallel interface with hsync and vsync
  * @V4L2_MBUS_BT656:	parallel interface with embedded synchronisation, can
  *			also be used for BT.1120
@@ -78,7 +78,7 @@ enum v4l2_mbus_type {
 };
 
 /**
- * v4l2_mbus_config - media bus configuration
+ * struct v4l2_mbus_config - media bus configuration
  * @type:	in: interface type
  * @flags:	in / out: configuration flags, depending on @type
  */
-- 
2.4.3

