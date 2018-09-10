Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:58194 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727810AbeIJUQn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Sep 2018 16:16:43 -0400
From: Ezequiel Garcia <ezequiel@collabora.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH 1/2] vicodec: Drop unneeded symbol dependency
Date: Mon, 10 Sep 2018 12:21:53 -0300
Message-Id: <20180910152154.14291-1-ezequiel@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The vicodec doesn't use the Subdev API, so drop the dependency.

Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
---
 drivers/media/platform/vicodec/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/vicodec/Kconfig b/drivers/media/platform/vicodec/Kconfig
index 2503bcb1529f..ad13329e3461 100644
--- a/drivers/media/platform/vicodec/Kconfig
+++ b/drivers/media/platform/vicodec/Kconfig
@@ -1,6 +1,6 @@
 config VIDEO_VICODEC
 	tristate "Virtual Codec Driver"
-	depends on VIDEO_DEV && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
+	depends on VIDEO_DEV && VIDEO_V4L2
 	select VIDEOBUF2_VMALLOC
 	select V4L2_MEM2MEM_DEV
 	default n
-- 
2.19.0.rc2
