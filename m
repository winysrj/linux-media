Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qg0-f50.google.com ([209.85.192.50]:35332 "EHLO
	mail-qg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901AbbI1WbK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Sep 2015 18:31:10 -0400
Received: by qgt47 with SMTP id 47so134055641qgt.2
        for <linux-media@vger.kernel.org>; Mon, 28 Sep 2015 15:31:09 -0700 (PDT)
From: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
To: <linux-media@vger.kernel.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Subject: [PATCH] vivid: Add an option to configure the maximum number of devices
Date: Mon, 28 Sep 2015 19:27:07 -0300
Message-Id: <1443479227-22060-1-git-send-email-ezequiel@vanguardiasur.com.ar>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The vivid driver currently has a hard-coded limit of 64 devices,
however there's nothing that prevents the creation of even more devices.
This commit adds a new driver option (which defaults to 64) to
allow this maximum number to be configurable.

Signed-off-by: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
---
 drivers/media/platform/vivid/Kconfig      | 8 ++++++++
 drivers/media/platform/vivid/vivid-core.c | 2 +-
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/vivid/Kconfig b/drivers/media/platform/vivid/Kconfig
index c3090932f06d..0885e93ad436 100644
--- a/drivers/media/platform/vivid/Kconfig
+++ b/drivers/media/platform/vivid/Kconfig
@@ -20,3 +20,11 @@ config VIDEO_VIVID
 
 	  Say Y here if you want to test video apps or debug V4L devices.
 	  When in doubt, say N.
+
+config VIDEO_VIVID_MAX_DEVS
+	int "Maximum number of devices"
+	depends on VIDEO_VIVID
+	default "64"
+	---help---
+	  This allows you to specify the maximum number of devices supported
+	  by the vivid driver.
diff --git a/drivers/media/platform/vivid/vivid-core.c b/drivers/media/platform/vivid/vivid-core.c
index c63e798e10b7..b30c00ed5f38 100644
--- a/drivers/media/platform/vivid/vivid-core.c
+++ b/drivers/media/platform/vivid/vivid-core.c
@@ -51,7 +51,7 @@
 #define VIVID_MODULE_NAME "vivid"
 
 /* The maximum number of vivid devices */
-#define VIVID_MAX_DEVS 64
+#define VIVID_MAX_DEVS CONFIG_VIDEO_VIVID_MAX_DEVS
 
 MODULE_DESCRIPTION("Virtual Video Test Driver");
 MODULE_AUTHOR("Hans Verkuil");
-- 
2.5.2

