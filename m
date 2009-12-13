Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pw0-f42.google.com ([209.85.160.42]:59660 "HELO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750875AbZLMOFa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Dec 2009 09:05:30 -0500
Received: by pwj9 with SMTP id 9so1447149pwj.21
        for <linux-media@vger.kernel.org>; Sun, 13 Dec 2009 06:05:29 -0800 (PST)
From: Huang Weiyi <weiyi.huang@gmail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org, Huang Weiyi <weiyi.huang@gmail.com>
Subject: [PATCH 2/6] V4L/DVB: Davinci VPFE Capture: remove unused #include <linux/version.h>
Date: Sun, 13 Dec 2009 22:05:21 +0800
Message-Id: <1260713121-5428-1-git-send-email-weiyi.huang@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove unused #include <linux/version.h>('s) in
  drivers/media/video/davinci/vpfe_capture.c

Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>
---
 drivers/media/video/davinci/vpfe_capture.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/davinci/vpfe_capture.c b/drivers/media/video/davinci/vpfe_capture.c
index 12a1b3d..08e51d7 100644
--- a/drivers/media/video/davinci/vpfe_capture.c
+++ b/drivers/media/video/davinci/vpfe_capture.c
@@ -70,7 +70,6 @@
 #include <linux/init.h>
 #include <linux/platform_device.h>
 #include <linux/interrupt.h>
-#include <linux/version.h>
 #include <media/v4l2-common.h>
 #include <linux/io.h>
 #include <media/davinci/vpfe_capture.h>
-- 
1.6.1.3

