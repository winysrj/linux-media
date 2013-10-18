Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:44718 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756034Ab3JRDIO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Oct 2013 23:08:14 -0400
Received: by mail-pa0-f44.google.com with SMTP id fb1so1663171pad.3
        for <linux-media@vger.kernel.org>; Thu, 17 Oct 2013 20:08:13 -0700 (PDT)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: hans.verkuil@cisco.com, sachin.kamat@linaro.org,
	m.chehab@samsung.com
Subject: [PATCH 4/6] [media] tvp514x: Include linux/of.h header
Date: Fri, 18 Oct 2013 08:37:13 +0530
Message-Id: <1382065635-27855-4-git-send-email-sachin.kamat@linaro.org>
In-Reply-To: <1382065635-27855-1-git-send-email-sachin.kamat@linaro.org>
References: <1382065635-27855-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

'of_match_ptr' is defined in linux/of.h. Include it explicitly to
avoid build breakage in the future.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/i2c/tvp514x.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/i2c/tvp514x.c b/drivers/media/i2c/tvp514x.c
index 91f3dd4..83d85df 100644
--- a/drivers/media/i2c/tvp514x.c
+++ b/drivers/media/i2c/tvp514x.c
@@ -35,6 +35,7 @@
 #include <linux/videodev2.h>
 #include <linux/module.h>
 #include <linux/v4l2-mediabus.h>
+#include <linux/of.h>
 
 #include <media/v4l2-async.h>
 #include <media/v4l2-device.h>
-- 
1.7.9.5

