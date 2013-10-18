Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f174.google.com ([209.85.192.174]:63204 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755855Ab3JRDIQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Oct 2013 23:08:16 -0400
Received: by mail-pd0-f174.google.com with SMTP id y13so3890618pdi.33
        for <linux-media@vger.kernel.org>; Thu, 17 Oct 2013 20:08:16 -0700 (PDT)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: hans.verkuil@cisco.com, sachin.kamat@linaro.org,
	m.chehab@samsung.com
Subject: [PATCH 5/6] [media] tvp7002: Include linux/of.h header
Date: Fri, 18 Oct 2013 08:37:14 +0530
Message-Id: <1382065635-27855-5-git-send-email-sachin.kamat@linaro.org>
In-Reply-To: <1382065635-27855-1-git-send-email-sachin.kamat@linaro.org>
References: <1382065635-27855-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

'of_match_ptr' is defined in linux/of.h. Include it explicitly to
avoid build breakage in the future.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/i2c/tvp7002.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/i2c/tvp7002.c b/drivers/media/i2c/tvp7002.c
index 24a08fa..912e1cc 100644
--- a/drivers/media/i2c/tvp7002.c
+++ b/drivers/media/i2c/tvp7002.c
@@ -29,6 +29,7 @@
 #include <linux/slab.h>
 #include <linux/videodev2.h>
 #include <linux/module.h>
+#include <linux/of.h>
 #include <linux/v4l2-dv-timings.h>
 #include <media/tvp7002.h>
 #include <media/v4l2-async.h>
-- 
1.7.9.5

