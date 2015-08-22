Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:40461 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753440AbbHVR2i (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 22 Aug 2015 13:28:38 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-doc@vger.kernel.org
Subject: [PATCH 26/39] [media] videobuf2-memops.h: add to device-drivers DocBook
Date: Sat, 22 Aug 2015 14:28:11 -0300
Message-Id: <6c4058e5bef64b7a95e1d6e026aa6cfa29669971.1440264165.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440264165.git.mchehab@osg.samsung.com>
References: <cover.1440264165.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440264165.git.mchehab@osg.samsung.com>
References: <cover.1440264165.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The comment metadata was wrong:

Warning(.//include/media/videobuf2-memops.h:25): cannot understand function prototype: 'struct vb2_vmarea_handler '
Warning(.//include/media/videobuf2-memops.h): no structured comments found

Fix and add to DocBook.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/Documentation/DocBook/device-drivers.tmpl b/Documentation/DocBook/device-drivers.tmpl
index e636bbd41933..8d1e04c94dce 100644
--- a/Documentation/DocBook/device-drivers.tmpl
+++ b/Documentation/DocBook/device-drivers.tmpl
@@ -235,9 +235,9 @@ X!Isound/sound_firmware.c
 !Iinclude/media/v4l2-event.h
 !Iinclude/media/v4l2-dv-timings.h
 !Iinclude/media/videobuf2-core.h
+!Iinclude/media/videobuf2-memops.h
 <!-- FIXME: Removed for now due to document generation inconsistency
 X!Iinclude/media/v4l2-mediabus.h
-X!Iinclude/media/videobuf2-memops.h
 -->
 
   </chapter>
diff --git a/include/media/videobuf2-memops.h b/include/media/videobuf2-memops.h
index f05444ca8c0c..9f36641a6781 100644
--- a/include/media/videobuf2-memops.h
+++ b/include/media/videobuf2-memops.h
@@ -17,7 +17,8 @@
 #include <media/videobuf2-core.h>
 
 /**
- * vb2_vmarea_handler - common vma refcount tracking handler
+ * struct vb2_vmarea_handler - common vma refcount tracking handler
+ *
  * @refcount:	pointer to refcount entry in the buffer
  * @put:	callback to function that decreases buffer refcount
  * @arg:	argument for @put callback
-- 
2.4.3

