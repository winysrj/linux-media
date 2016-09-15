Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:34838 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756504AbcIOCWL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Sep 2016 22:22:11 -0400
Received: by mail-pf0-f194.google.com with SMTP id z84so1539965pfi.2
        for <linux-media@vger.kernel.org>; Wed, 14 Sep 2016 19:22:11 -0700 (PDT)
From: Wei Yongjun <weiyj.lk@gmail.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Arnd Bergmann <arnd@arndb.de>
Cc: Wei Yongjun <weiyongjun1@huawei.com>, linux-media@vger.kernel.org
Subject: [PATCH -next] [media] pxa_camera: remove duplicated include from pxa_camera.c
Date: Thu, 15 Sep 2016 02:22:03 +0000
Message-Id: <1473906123-29669-1-git-send-email-weiyj.lk@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Wei Yongjun <weiyongjun1@huawei.com>

Remove duplicated include.

Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 drivers/media/platform/pxa_camera.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/platform/pxa_camera.c b/drivers/media/platform/pxa_camera.c
index 1bce7eb..2d68b80 100644
--- a/drivers/media/platform/pxa_camera.c
+++ b/drivers/media/platform/pxa_camera.c
@@ -26,7 +26,6 @@
 #include <linux/moduleparam.h>
 #include <linux/of.h>
 #include <linux/time.h>
-#include <linux/device.h>
 #include <linux/platform_device.h>
 #include <linux/clk.h>
 #include <linux/sched.h>



