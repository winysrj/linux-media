Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f176.google.com ([209.85.192.176]:54170 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755855Ab3JRDIK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Oct 2013 23:08:10 -0400
Received: by mail-pd0-f176.google.com with SMTP id g10so3070239pdj.21
        for <linux-media@vger.kernel.org>; Thu, 17 Oct 2013 20:08:09 -0700 (PDT)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: hans.verkuil@cisco.com, sachin.kamat@linaro.org,
	m.chehab@samsung.com,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [PATCH 2/6] [media] mt9p031: Include linux/of.h header
Date: Fri, 18 Oct 2013 08:37:11 +0530
Message-Id: <1382065635-27855-2-git-send-email-sachin.kamat@linaro.org>
In-Reply-To: <1382065635-27855-1-git-send-email-sachin.kamat@linaro.org>
References: <1382065635-27855-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

'of_match_ptr' is defined in linux/of.h. Include it explicitly to
avoid build breakage in the future.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/i2c/mt9p031.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/i2c/mt9p031.c b/drivers/media/i2c/mt9p031.c
index 4734836..1c2303d 100644
--- a/drivers/media/i2c/mt9p031.c
+++ b/drivers/media/i2c/mt9p031.c
@@ -19,6 +19,7 @@
 #include <linux/i2c.h>
 #include <linux/log2.h>
 #include <linux/module.h>
+#include <linux/of.h>
 #include <linux/of_gpio.h>
 #include <linux/pm.h>
 #include <linux/regulator/consumer.h>
-- 
1.7.9.5

