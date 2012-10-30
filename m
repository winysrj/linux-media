Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:35987 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482Ab2J3PMl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Oct 2012 11:12:41 -0400
Received: by mail-wg0-f44.google.com with SMTP id dr13so258060wgb.1
        for <linux-media@vger.kernel.org>; Tue, 30 Oct 2012 08:12:40 -0700 (PDT)
From: Javier Martin <javier.martin@vista-silicon.com>
To: linux-media@vger.kernel.org
Cc: elezegarcia@gmail.com, sakari.ailus@iki.fi,
	sylvester.nawrocki@gmail.com, mchehab@redhat.com,
	Javier Martin <javier.martin@vista-silicon.com>
Subject: [PATCH] media: m2m-deinterlace: Do not set debugging flag to true.
Date: Tue, 30 Oct 2012 16:12:32 +0100
Message-Id: <1351609952-18313-1-git-send-email-javier.martin@vista-silicon.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Default value should be 'debugging disabled'.

Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
---
 drivers/media/platform/m2m-deinterlace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/m2m-deinterlace.c b/drivers/media/platform/m2m-deinterlace.c
index 1107167..931d580 100644
--- a/drivers/media/platform/m2m-deinterlace.c
+++ b/drivers/media/platform/m2m-deinterlace.c
@@ -28,7 +28,7 @@ MODULE_AUTHOR("Javier Martin <javier.martin@vista-silicon.com");
 MODULE_LICENSE("GPL");
 MODULE_VERSION("0.0.1");
 
-static bool debug = true;
+static bool debug;
 module_param(debug, bool, 0644);
 
 /* Flags that indicate a format can be used for capture/output */
-- 
1.7.9.5

