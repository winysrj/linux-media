Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f180.google.com ([209.85.192.180]:57399 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755855Ab3JRDIM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Oct 2013 23:08:12 -0400
Received: by mail-pd0-f180.google.com with SMTP id p10so1667039pdj.25
        for <linux-media@vger.kernel.org>; Thu, 17 Oct 2013 20:08:11 -0700 (PDT)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: hans.verkuil@cisco.com, sachin.kamat@linaro.org,
	m.chehab@samsung.com
Subject: [PATCH 3/6] [media] ths8200: Include linux/of.h header
Date: Fri, 18 Oct 2013 08:37:12 +0530
Message-Id: <1382065635-27855-3-git-send-email-sachin.kamat@linaro.org>
In-Reply-To: <1382065635-27855-1-git-send-email-sachin.kamat@linaro.org>
References: <1382065635-27855-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

'of_match_ptr' is defined in linux/of.h. Include it explicitly to
avoid build breakage in the future.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/i2c/ths8200.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/i2c/ths8200.c b/drivers/media/i2c/ths8200.c
index a58a8f6..51e1964 100644
--- a/drivers/media/i2c/ths8200.c
+++ b/drivers/media/i2c/ths8200.c
@@ -19,6 +19,7 @@
 
 #include <linux/i2c.h>
 #include <linux/module.h>
+#include <linux/of.h>
 #include <linux/v4l2-dv-timings.h>
 
 #include <media/v4l2-dv-timings.h>
-- 
1.7.9.5

