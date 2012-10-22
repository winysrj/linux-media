Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qa0-f46.google.com ([209.85.216.46]:54468 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753117Ab2JVFgN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Oct 2012 01:36:13 -0400
Received: by mail-qa0-f46.google.com with SMTP id c26so1016222qad.19
        for <linux-media@vger.kernel.org>; Sun, 21 Oct 2012 22:36:13 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 22 Oct 2012 13:36:13 +0800
Message-ID: <CAPgLHd-f6x_m-yi-Ki0hNV=7NsOG1rarmRcwDe8Kp+yEFJw4TQ@mail.gmail.com>
Subject: [PATCH] [media] davinci: vpbe: fix missing unlock on error in vpbe_initialize()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: mchehab@infradead.org
Cc: yongjun_wei@trendmicro.com.cn, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Add the missing unlock on the error handling path in function
vpbe_initialize().

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
no test
---
 drivers/media/platform/davinci/vpbe.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/davinci/vpbe.c b/drivers/media/platform/davinci/vpbe.c
index 69d7a58..875e63d 100644
--- a/drivers/media/platform/davinci/vpbe.c
+++ b/drivers/media/platform/davinci/vpbe.c
@@ -632,8 +632,10 @@ static int vpbe_initialize(struct device *dev, struct vpbe_device *vpbe_dev)
 
 	err = bus_for_each_dev(&platform_bus_type, NULL, vpbe_dev,
 			       platform_device_get);
-	if (err < 0)
-		return err;
+	if (err < 0) {
+		ret = err;
+		goto fail_dev_unregister;
+	}
 
 	vpbe_dev->venc = venc_sub_dev_init(&vpbe_dev->v4l2_dev,
 					   vpbe_dev->cfg->venc.module_name);


