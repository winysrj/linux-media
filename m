Return-path: <mchehab@pedra>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:35733 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757886Ab0HLTEe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Aug 2010 15:04:34 -0400
Received: by bwz3 with SMTP id 3so1136686bwz.19
        for <linux-media@vger.kernel.org>; Thu, 12 Aug 2010 12:04:32 -0700 (PDT)
From: Christopher Friedt <chrisfriedt@gmail.com>
To: linux-media@vger.kernel.org
Cc: Christopher Friedt <chrisfriedt@gmail.com>
Subject: [PATCH] v4l2-ctrls.c was missing slab.h
Date: Thu, 12 Aug 2010 21:04:11 +0200
Message-Id: <1281639851-20984-1-git-send-email-chrisfriedt@gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Fixed broken compile of drivers/media/video/v4l2-ctrls.c. 
It failed due to missing #include <linux/slab.h>, and errored-out with 
"implicit declaration of function kzalloc, kmalloc, ..."

Signed-off-by: Christopher Friedt <chrisfriedt@gmail.com>
---
 drivers/media/video/v4l2-ctrls.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/v4l2-ctrls.c b/drivers/media/video/v4l2-ctrls.c
index 84c1a53..1d09804 100644
--- a/drivers/media/video/v4l2-ctrls.c
+++ b/drivers/media/video/v4l2-ctrls.c
@@ -18,6 +18,7 @@
     Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
+#include <linux/slab.h>
 #include <linux/ctype.h>
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-device.h>
-- 
1.7.0.4

