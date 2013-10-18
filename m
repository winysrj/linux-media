Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f177.google.com ([209.85.192.177]:34892 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753528Ab3JRDIH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Oct 2013 23:08:07 -0400
Received: by mail-pd0-f177.google.com with SMTP id p10so1690110pdj.22
        for <linux-media@vger.kernel.org>; Thu, 17 Oct 2013 20:08:07 -0700 (PDT)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: hans.verkuil@cisco.com, sachin.kamat@linaro.org,
	m.chehab@samsung.com
Subject: [PATCH 1/6] [media] adv7343: Include linux/of.h header
Date: Fri, 18 Oct 2013 08:37:10 +0530
Message-Id: <1382065635-27855-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

'of_match_ptr' is defined in linux/of.h. Include it explicitly to
avoid build breakage in the future.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/i2c/adv7343.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/i2c/adv7343.c b/drivers/media/i2c/adv7343.c
index aeb56c5..d4e15a6 100644
--- a/drivers/media/i2c/adv7343.c
+++ b/drivers/media/i2c/adv7343.c
@@ -25,6 +25,7 @@
 #include <linux/module.h>
 #include <linux/videodev2.h>
 #include <linux/uaccess.h>
+#include <linux/of.h>
 
 #include <media/adv7343.h>
 #include <media/v4l2-async.h>
-- 
1.7.9.5

