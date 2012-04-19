Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.linuxtv.org ([130.149.80.248]:39721 "EHLO www.linuxtv.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756276Ab2DSTy6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Apr 2012 15:54:58 -0400
Message-Id: <E1SKxRR-0001Fl-0n@www.linuxtv.org>
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Date: Thu, 19 Apr 2012 21:54:16 +0200
Subject: [git:v4l-dvb/for_v3.5] [media] drivers: media: radio: radio-keene.c: Remove unneeded include of version.h
To: linuxtv-commits@linuxtv.org
Cc: Marcos Paulo de Souza <marcos.souza.org@gmail.com>,
	linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Reply-to: linux-media@vger.kernel.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an automatic generated email to let you know that the following patch were queued at the 
http://git.linuxtv.org/media_tree.git tree:

Subject: [media] drivers: media: radio: radio-keene.c: Remove unneeded include of version.h
Author:  Marcos Paulo de Souza <marcos.souza.org@gmail.com>
Date:    Wed Apr 18 00:30:04 2012 -0300

The output of "make versioncheck" told us that:

drivers/media/radio/radio-keene.c: 31 linux/version.h not needed.

After take a look in the code, we can agree to remove it.

Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: <linux-media@vger.kernel.org>
Signed-off-by: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

 drivers/media/radio/radio-keene.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

---

http://git.linuxtv.org/media_tree.git?a=commitdiff;h=af22b83ab895e71400d59f07b6ee89297c3560b1

diff --git a/drivers/media/radio/radio-keene.c b/drivers/media/radio/radio-keene.c
index 55bd1d2..26a2b7a 100644
--- a/drivers/media/radio/radio-keene.c
+++ b/drivers/media/radio/radio-keene.c
@@ -28,7 +28,6 @@
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-event.h>
 #include <linux/usb.h>
-#include <linux/version.h>
 #include <linux/mutex.h>
 
 /* driver and module definitions */
