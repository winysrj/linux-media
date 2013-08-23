Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f42.google.com ([209.85.214.42]:61009 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752763Ab3HWDAD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Aug 2013 23:00:03 -0400
Received: by mail-bk0-f42.google.com with SMTP id my10so31305bkb.29
        for <linux-media@vger.kernel.org>; Thu, 22 Aug 2013 20:00:01 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 23 Aug 2013 11:00:01 +0800
Message-ID: <CAPgLHd-0+fYLMh+Ff+cgewBPy1itjp-EtbAjzs5UrJsqrY3aNg@mail.gmail.com>
Subject: [PATCH -next] [media] davinci: vpif_capture: fix error return code in vpif_probe()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: prabhakar.csengg@gmail.com, m.chehab@samsung.com
Cc: yongjun_wei@trendmicro.com.cn, linux-media@vger.kernel.org,
	davinci-linux-open-source@linux.davincidsp.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Fix to return -ENODEV in the subdevice register error handling
case instead of 0, as done elsewhere in this function.

Introduced by commit 873229e4fdf34196aa5d707957c59ba54c25eaba
([media] media: davinci: vpif: capture: add V4L2-async support)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/media/platform/davinci/vpif_capture.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
index 7fbde6d..e4b6a26 100644
--- a/drivers/media/platform/davinci/vpif_capture.c
+++ b/drivers/media/platform/davinci/vpif_capture.c
@@ -2160,6 +2160,7 @@ static __init int vpif_probe(struct platform_device *pdev)
 
 			if (!vpif_obj.sd[i]) {
 				vpif_err("Error registering v4l2 subdevice\n");
+				err = -ENOMEM;
 				goto probe_subdev_out;
 			}
 			v4l2_info(&vpif_obj.v4l2_dev,

