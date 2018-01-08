Return-path: <linux-media-owner@vger.kernel.org>
Received: from szxga04-in.huawei.com ([45.249.212.190]:3700 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1757295AbeAHMfr (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 8 Jan 2018 07:35:47 -0500
From: Xiongfeng Wang <wangxiongfeng2@huawei.com>
To: <mchehab@kernel.org>
CC: <linux-media@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <wangxiongfeng2@huawei.com>, <arnd@arndb.de>
Subject: [PATCH] media: media-device: use strlcpy() instead of strncpy()
Date: Mon, 8 Jan 2018 20:40:59 +0800
Message-ID: <1515415259-195067-1-git-send-email-wangxiongfeng2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Xiongfeng Wang <xiongfeng.wang@linaro.org>

gcc-8 reports

drivers/media/media-device.c: In function 'media_device_get_topology':
./include/linux/string.h:245:9: warning: '__builtin_strncpy' specified
bound 64 equals destination size [-Wstringop-truncation]

We need to use strlcpy() to make sure the dest string is nul-terminated.

Signed-off-by: Xiongfeng Wang <xiongfeng.wang@linaro.org>
---
 drivers/media/media-device.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index e79f72b..f442444 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -255,7 +255,7 @@ static long media_device_get_topology(struct media_device *mdev,
 		memset(&kentity, 0, sizeof(kentity));
 		kentity.id = entity->graph_obj.id;
 		kentity.function = entity->function;
-		strncpy(kentity.name, entity->name,
+		strlcpy(kentity.name, entity->name,
 			sizeof(kentity.name));
 
 		if (copy_to_user(uentity, &kentity, sizeof(kentity)))
-- 
1.8.3.1
