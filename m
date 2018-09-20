Return-path: <linux-media-owner@vger.kernel.org>
Received: from szxga07-in.huawei.com ([45.249.212.35]:39704 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726101AbeITKxy (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Sep 2018 06:53:54 -0400
From: zhong jiang <zhongjiang@huawei.com>
To: <mchehab@kernel.org>
CC: <todor.tomov@linaro.org>, <linux-media@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] media: qcom: remove duplicated include file
Date: Thu, 20 Sep 2018 12:59:55 +0800
Message-ID: <1537419595-29990-1-git-send-email-zhongjiang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

device.h have duplicated include. hence just remove
redundant include file.

Signed-off-by: zhong jiang <zhongjiang@huawei.com>
---
 drivers/media/platform/qcom/camss/camss.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/platform/qcom/camss/camss.h b/drivers/media/platform/qcom/camss/camss.h
index 418996d..0823a71 100644
--- a/drivers/media/platform/qcom/camss/camss.h
+++ b/drivers/media/platform/qcom/camss/camss.h
@@ -10,7 +10,6 @@
 #ifndef QC_MSM_CAMSS_H
 #define QC_MSM_CAMSS_H
 
-#include <linux/device.h>
 #include <linux/types.h>
 #include <media/v4l2-async.h>
 #include <media/v4l2-device.h>
-- 
1.7.12.4
