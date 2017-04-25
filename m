Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:33185 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1948109AbdDYOi1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 25 Apr 2017 10:38:27 -0400
Received: by mail-pg0-f66.google.com with SMTP id 63so11754078pgh.0
        for <linux-media@vger.kernel.org>; Tue, 25 Apr 2017 07:38:27 -0700 (PDT)
From: Wei Yongjun <weiyj.lk@gmail.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Kamil Debski <kamil@wypas.org>
Cc: Wei Yongjun <weiyongjun1@huawei.com>, linux-media@vger.kernel.org
Subject: [PATCH -next] [media] s5p-cec: remove unused including <linux/version.h>
Date: Tue, 25 Apr 2017 14:38:18 +0000
Message-Id: <20170425143818.1578-1-weiyj.lk@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Wei Yongjun <weiyongjun1@huawei.com>

Remove including <linux/version.h> that is not needed.

Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 drivers/media/platform/s5p-cec/s5p_cec.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/platform/s5p-cec/s5p_cec.h b/drivers/media/platform/s5p-cec/s5p_cec.h
index 7015845..8bcd8dc 100644
--- a/drivers/media/platform/s5p-cec/s5p_cec.h
+++ b/drivers/media/platform/s5p-cec/s5p_cec.h
@@ -22,7 +22,6 @@
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
 #include <linux/timer.h>
-#include <linux/version.h>
 #include <linux/workqueue.h>
 #include <media/cec.h>
 
