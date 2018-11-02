Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:36426 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725935AbeKBUFg (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 2 Nov 2018 16:05:36 -0400
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] v4l2-controls: add a missing include
Date: Fri,  2 Nov 2018 06:58:43 -0400
Message-Id: <dafb7f9aef2fd44991ff1691721ff765a23be27b.1541156321.git.mchehab+samsung@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As warned by "make headers_check", the definition for the linux-specific
integer types is missing:

	./usr/include/linux/v4l2-controls.h:1105: found __[us]{8,16,32,64} type without #include <linux/types.h>

Fixes: c27bb30e7b6d ("media: v4l: Add definitions for MPEG-2 slice format and metadata")
Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 include/uapi/linux/v4l2-controls.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
index 51b095898f4b..86a54916206f 100644
--- a/include/uapi/linux/v4l2-controls.h
+++ b/include/uapi/linux/v4l2-controls.h
@@ -47,6 +47,8 @@
  *  videodev2.h.
  */
 
+#include <linux/types.h>
+
 #ifndef __LINUX_V4L2_CONTROLS_H
 #define __LINUX_V4L2_CONTROLS_H
 
-- 
2.19.1
