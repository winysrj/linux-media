Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f41.google.com ([209.85.160.41]:47616 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756137Ab3JRDIT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Oct 2013 23:08:19 -0400
Received: by mail-pb0-f41.google.com with SMTP id rp16so3220599pbb.28
        for <linux-media@vger.kernel.org>; Thu, 17 Oct 2013 20:08:18 -0700 (PDT)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: hans.verkuil@cisco.com, sachin.kamat@linaro.org,
	m.chehab@samsung.com
Subject: [PATCH 6/6] [media] gpio-ir-recv: Include linux/of.h header
Date: Fri, 18 Oct 2013 08:37:15 +0530
Message-Id: <1382065635-27855-6-git-send-email-sachin.kamat@linaro.org>
In-Reply-To: <1382065635-27855-1-git-send-email-sachin.kamat@linaro.org>
References: <1382065635-27855-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

'of_match_ptr' is defined in linux/of.h. Include it explicitly to
avoid build breakage in the future.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/rc/gpio-ir-recv.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/rc/gpio-ir-recv.c b/drivers/media/rc/gpio-ir-recv.c
index 07aacfa..80c611c 100644
--- a/drivers/media/rc/gpio-ir-recv.c
+++ b/drivers/media/rc/gpio-ir-recv.c
@@ -16,6 +16,7 @@
 #include <linux/interrupt.h>
 #include <linux/gpio.h>
 #include <linux/slab.h>
+#include <linux/of.h>
 #include <linux/of_gpio.h>
 #include <linux/platform_device.h>
 #include <linux/irq.h>
-- 
1.7.9.5

