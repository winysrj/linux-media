Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:57532 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757441Ab3EaWXG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 May 2013 18:23:06 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: patches@lists.linaro.org, linux-arm-kernel@lists.infradead.org,
	Arnd Bergmann <arnd@arndb.de>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org,
	Konstantin Khlebnikov <khlebnikov@openvz.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [PATCH 13/15] [media] omap3isp: include linux/mm_types.h
Date: Sat,  1 Jun 2013 00:22:50 +0200
Message-Id: <1370038972-2318779-14-git-send-email-arnd@arndb.de>
In-Reply-To: <1370038972-2318779-1-git-send-email-arnd@arndb.de>
References: <1370038972-2318779-1-git-send-email-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The ispqueue.h file uses vm_flags_t, which is defined in
linux/mm_types.h, so we must include that header in order
to build in all configurations.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org
Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/omap3isp/ispqueue.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/omap3isp/ispqueue.h b/drivers/media/platform/omap3isp/ispqueue.h
index 908dfd7..e6e720c 100644
--- a/drivers/media/platform/omap3isp/ispqueue.h
+++ b/drivers/media/platform/omap3isp/ispqueue.h
@@ -31,6 +31,7 @@
 #include <linux/mutex.h>
 #include <linux/videodev2.h>
 #include <linux/wait.h>
+#include <linux/mm_types.h>
 
 struct isp_video_queue;
 struct page;
-- 
1.8.1.2

