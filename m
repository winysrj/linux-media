Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:33954 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932912AbcI1PNV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 28 Sep 2016 11:13:21 -0400
Received: by mail-pf0-f194.google.com with SMTP id 21so2283502pfy.1
        for <linux-media@vger.kernel.org>; Wed, 28 Sep 2016 08:13:21 -0700 (PDT)
From: Wei Yongjun <weiyj.lk@gmail.com>
To: Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Wei Yongjun <weiyongjun1@huawei.com>, kernel@stlinux.com,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org
Subject: [PATCH -next] staging: media: stih-cec: remove unused including <linux/version.h>
Date: Wed, 28 Sep 2016 15:13:13 +0000
Message-Id: <1475075593-22123-1-git-send-email-weiyj.lk@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Wei Yongjun <weiyongjun1@huawei.com>

Remove including <linux/version.h> that don't need it.

Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 drivers/staging/media/st-cec/stih-cec.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/media/st-cec/stih-cec.c b/drivers/staging/media/st-cec/stih-cec.c
index 2143448..b0aee1d 100644
--- a/drivers/staging/media/st-cec/stih-cec.c
+++ b/drivers/staging/media/st-cec/stih-cec.c
@@ -16,7 +16,6 @@
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
-#include <linux/version.h>
 
 #include <media/cec.h>

