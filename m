Return-path: <linux-media-owner@vger.kernel.org>
Received: from szxga07-in.huawei.com ([45.249.212.35]:38896 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388909AbeIUJ3i (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 21 Sep 2018 05:29:38 -0400
From: zhong jiang <zhongjiang@huawei.com>
To: <mchehab@kernel.org>
CC: <todor.tomov@linaro.org>, <linux-media@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCHv2] media: qcom: remove duplicated include file
Date: Fri, 21 Sep 2018 11:30:20 +0800
Message-ID: <1537500620-21069-1-git-send-email-zhongjiang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We include device.h twice in camss.h. It's unnecessary.
hence just remove it.

Signed-off-by: zhong jiang <zhongjiang@huawei.com>
---
 drivers/media/platform/qcom/camss/camss.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/platform/qcom/camss/camss.h b/drivers/media/platform/qcom/camss/camss.h
index 418996d..f32289c 100644
--- a/drivers/media/platform/qcom/camss/camss.h
+++ b/drivers/media/platform/qcom/camss/camss.h
@@ -17,7 +17,6 @@
 #include <media/v4l2-subdev.h>
 #include <media/media-device.h>
 #include <media/media-entity.h>
-#include <linux/device.h>
 
 #include "camss-csid.h"
 #include "camss-csiphy.h"
-- 
1.7.12.4
