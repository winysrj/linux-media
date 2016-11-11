Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:32930 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756506AbcKKNk2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 11 Nov 2016 08:40:28 -0500
Received: by mail-pf0-f195.google.com with SMTP id 144so2596997pfv.0
        for <linux-media@vger.kernel.org>; Fri, 11 Nov 2016 05:40:28 -0800 (PST)
From: Wei Yongjun <weiyj.lk@gmail.com>
To: Songjun Wu <songjun.wu@microchip.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Wei Yongjun <weiyongjun1@huawei.com>, linux-media@vger.kernel.org
Subject: [PATCH -next] [media] atmel-isc: fix error return code in atmel_isc_probe()
Date: Fri, 11 Nov 2016 13:40:20 +0000
Message-Id: <1478871620-24274-1-git-send-email-weiyj.lk@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Wei Yongjun <weiyongjun1@huawei.com>

Fix to return error code -ENODEV from the error handling
case instead of 0, as done elsewhere in this function.

Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 drivers/media/platform/atmel/atmel-isc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/atmel/atmel-isc.c b/drivers/media/platform/atmel/atmel-isc.c
index 8e25d3f..fa68fe9 100644
--- a/drivers/media/platform/atmel/atmel-isc.c
+++ b/drivers/media/platform/atmel/atmel-isc.c
@@ -1424,6 +1424,7 @@ static int atmel_isc_probe(struct platform_device *pdev)
 
 	if (list_empty(&isc->subdev_entities)) {
 		dev_err(dev, "no subdev found\n");
+		ret = -ENODEV;
 		goto unregister_v4l2_device;
 	}

