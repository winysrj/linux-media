Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:44813 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965820AbeCAIo3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 1 Mar 2018 03:44:29 -0500
Received: by mail-pf0-f193.google.com with SMTP id 17so2158311pfw.11
        for <linux-media@vger.kernel.org>; Thu, 01 Mar 2018 00:44:29 -0800 (PST)
From: Shunqian Zheng <zhengsq@rock-chips.com>
To: sakari.ailus@linux.intel.com, mchehab@kernel.org
Cc: linux-media@vger.kernel.org, tfiga@chromium.org,
        Shunqian Zheng <zhengsq@rock-chips.com>
Subject: [PATCH] media: ov2685: Not delay latch for gain
Date: Thu,  1 Mar 2018 16:44:16 +0800
Message-Id: <1519893856-4738-1-git-send-email-zhengsq@rock-chips.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Update the register 0x3503 to use 'no delay latch' for gain.
This makes sensor to output the first frame as normal rather
than a very dark one.

Signed-off-by: Shunqian Zheng <zhengsq@rock-chips.com>
---
 drivers/media/i2c/ov2685.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/ov2685.c b/drivers/media/i2c/ov2685.c
index 9ac702e..83c55e8 100644
--- a/drivers/media/i2c/ov2685.c
+++ b/drivers/media/i2c/ov2685.c
@@ -119,7 +119,7 @@ struct ov2685 {
 	{0x3087, 0x00},
 	{0x3501, 0x4e},
 	{0x3502, 0xe0},
-	{0x3503, 0x07},
+	{0x3503, 0x27},
 	{0x350b, 0x36},
 	{0x3600, 0xb4},
 	{0x3603, 0x35},
-- 
1.9.1
