Return-path: <mchehab@pedra>
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:37573 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753401Ab0HLSMI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Aug 2010 14:12:08 -0400
Date: Thu, 12 Aug 2010 20:46:07 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
cc: linux-media@vger.kernel.org,
	Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: [PATCH] fix v4l2-ctrls compilation
Message-ID: <alpine.SOC.1.00.1008122042270.24365@math.ut.ee>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Current git has broken v4l2-ctrls compilation - kzalloc et al are 
missing prototypes. Fix it by including linux/slab.h that contains the 
definitions.

Signed-off-by: Meelis Roos <mroos@linux.ee>

diff --git a/drivers/media/video/v4l2-ctrls.c b/drivers/media/video/v4l2-ctrls.c
index 84c1a53..ea8d32c 100644
--- a/drivers/media/video/v4l2-ctrls.c
+++ b/drivers/media/video/v4l2-ctrls.c
@@ -19,6 +19,7 @@
  */
 
 #include <linux/ctype.h>
+#include <linux/slab.h>
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ctrls.h>

-- 
Meelis Roos <mroos@linux.ee>
