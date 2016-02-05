Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:55287 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755835AbcBETKc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Feb 2016 14:10:32 -0500
From: Javier Martinez Canillas <javier@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org,
	Javier Martinez Canillas <javier@osg.samsung.com>
Subject: [PATCH 5/8] [media] tvp5150: add internal signal generator to HW input list
Date: Fri,  5 Feb 2016 16:09:55 -0300
Message-Id: <1454699398-8581-6-git-send-email-javier@osg.samsung.com>
In-Reply-To: <1454699398-8581-1-git-send-email-javier@osg.samsung.com>
References: <1454699398-8581-1-git-send-email-javier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some tvp5150 variants, have an internal generator that can generate a
black screen output. Since this is a HW block, it should be in the HW
inputs list.

Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
---

 include/media/i2c/tvp5150.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/media/i2c/tvp5150.h b/include/media/i2c/tvp5150.h
index 649908a25605..685a1e718531 100644
--- a/include/media/i2c/tvp5150.h
+++ b/include/media/i2c/tvp5150.h
@@ -25,6 +25,7 @@
 #define TVP5150_COMPOSITE0 0
 #define TVP5150_COMPOSITE1 1
 #define TVP5150_SVIDEO     2
+#define TVP5150_GENERATOR  3
 
 /* TVP5150 HW outputs */
 #define TVP5150_NORMAL       0
-- 
2.5.0

