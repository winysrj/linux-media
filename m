Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.linuxtv.org ([130.149.80.248]:39723 "EHLO www.linuxtv.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756374Ab2DSTy6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Apr 2012 15:54:58 -0400
Message-Id: <E1SKxRR-0001G2-5c@www.linuxtv.org>
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Date: Thu, 19 Apr 2012 21:53:59 +0200
Subject: [git:v4l-dvb/for_v3.5] [media] drivers: media: video: adp1653.c: Remove unneeded include of version.h
To: linuxtv-commits@linuxtv.org
Cc: Marcos Paulo de Souza <marcos.souza.org@gmail.com>,
	linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Reply-to: linux-media@vger.kernel.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an automatic generated email to let you know that the following patch were queued at the 
http://git.linuxtv.org/media_tree.git tree:

Subject: [media] drivers: media: video: adp1653.c: Remove unneeded include of version.h
Author:  Marcos Paulo de Souza <marcos.souza.org@gmail.com>
Date:    Wed Apr 18 00:30:05 2012 -0300

The output of "make versioncheck" told us that:

drivers/media/video/adp1653.c: 37 linux/version.h not needed.

After we take a look at the code, we can afree to remove it.

Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: <linux-media@vger.kernel.org>
Signed-off-by: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

 drivers/media/video/adp1653.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

---

http://git.linuxtv.org/media_tree.git?a=commitdiff;h=713ca5dfd050efa61eb92be51a9ccbdaee2239cd

diff --git a/drivers/media/video/adp1653.c b/drivers/media/video/adp1653.c
index 5b045b4..24afc99 100644
--- a/drivers/media/video/adp1653.c
+++ b/drivers/media/video/adp1653.c
@@ -34,7 +34,6 @@
 #include <linux/module.h>
 #include <linux/i2c.h>
 #include <linux/slab.h>
-#include <linux/version.h>
 #include <media/adp1653.h>
 #include <media/v4l2-device.h>
 
