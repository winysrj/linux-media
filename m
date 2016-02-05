Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:55291 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753023AbcBETKf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Feb 2016 14:10:35 -0500
From: Javier Martinez Canillas <javier@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org,
	Javier Martinez Canillas <javier@osg.samsung.com>
Subject: [PATCH 6/8] [media] tvp5150: move input definition header to dt-bindings
Date: Fri,  5 Feb 2016 16:09:56 -0300
Message-Id: <1454699398-8581-7-git-send-email-javier@osg.samsung.com>
In-Reply-To: <1454699398-8581-1-git-send-email-javier@osg.samsung.com>
References: <1454699398-8581-1-git-send-email-javier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a header file for the tvp5150 input connectors constants that
can be shared between the driver and Device Tree source files.

Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
---

 drivers/media/i2c/tvp5150.c                        | 2 +-
 include/{media/i2c => dt-bindings/media}/tvp5150.h | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)
 rename include/{media/i2c => dt-bindings/media}/tvp5150.h (90%)

diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
index 093ff80f944c..3a32fd1df805 100644
--- a/drivers/media/i2c/tvp5150.c
+++ b/drivers/media/i2c/tvp5150.c
@@ -5,6 +5,7 @@
  * This code is placed under the terms of the GNU General Public License v2
  */
 
+#include <dt-bindings/media/tvp5150.h>
 #include <linux/i2c.h>
 #include <linux/slab.h>
 #include <linux/videodev2.h>
@@ -13,7 +14,6 @@
 #include <linux/module.h>
 #include <media/v4l2-async.h>
 #include <media/v4l2-device.h>
-#include <media/i2c/tvp5150.h>
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-of.h>
 #include <media/v4l2-mc.h>
diff --git a/include/media/i2c/tvp5150.h b/include/dt-bindings/media/tvp5150.h
similarity index 90%
rename from include/media/i2c/tvp5150.h
rename to include/dt-bindings/media/tvp5150.h
index 685a1e718531..dc347569854f 100644
--- a/include/media/i2c/tvp5150.h
+++ b/include/dt-bindings/media/tvp5150.h
@@ -18,8 +18,8 @@
     Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 */
 
-#ifndef _TVP5150_H_
-#define _TVP5150_H_
+#ifndef _DT_BINDINGS_MEDIA_TVP5150_H
+#define _DT_BINDINGS_MEDIA_TVP5150_H
 
 /* TVP5150 HW inputs */
 #define TVP5150_COMPOSITE0 0
@@ -31,4 +31,4 @@
 #define TVP5150_NORMAL       0
 #define TVP5150_BLACK_SCREEN 1
 
-#endif
+#endif /* _DT_BINDINGS_MEDIA_TVP5150_H */
-- 
2.5.0

