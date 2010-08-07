Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:59445 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752407Ab0HGPsG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 7 Aug 2010 11:48:06 -0400
Date: Sat, 7 Aug 2010 17:47:57 +0200 (CEST)
From: Laurent Riffard <laurent.riffard@free.fr>
To: linux-media@vger.kernel.org
cc: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH for linux-next] V4L/DVB: v4l2: v4l2-ctrls.c needs kzalloc/kfree
 prototype
Message-ID: <alpine.DEB.2.00.1008071734460.5908@calimero>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323329-1439989009-1281196079=:5908"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-1439989009-1281196079=:5908
Content-Type: TEXT/PLAIN; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT

linux-next 20100807 failed to compile:

drivers/media/video/v4l2-ctrls.c: In function ‘v4l2_ctrl_handler_init’:
drivers/media/video/v4l2-ctrls.c:766: error: implicit declaration of function ‘kzalloc’
drivers/media/video/v4l2-ctrls.c:767: warning: assignment makes pointer from integer without a cast
drivers/media/video/v4l2-ctrls.c: In function ‘v4l2_ctrl_handler_free’:
drivers/media/video/v4l2-ctrls.c:786: error: implicit declaration of function ‘kfree’
...

---
  drivers/media/video/v4l2-ctrls.c |    1 +
  1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/v4l2-ctrls.c b/drivers/media/video/v4l2-ctrls.c
index 84c1a53..951c8c6 100644
--- a/drivers/media/video/v4l2-ctrls.c
+++ b/drivers/media/video/v4l2-ctrls.c
@@ -19,6 +19,7 @@
   */

  #include <linux/ctype.h>
+#include <linux/slab.h>         /* for kzalloc/kfree */
  #include <media/v4l2-ioctl.h>
  #include <media/v4l2-device.h>
  #include <media/v4l2-ctrls.h>
-- 
1.7.2.1.26.gbb89e

--8323329-1439989009-1281196079=:5908--
