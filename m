Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f45.google.com ([209.85.214.45]:44281 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753958Ab3HWC7p (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Aug 2013 22:59:45 -0400
Received: by mail-bk0-f45.google.com with SMTP id mx11so31864bkb.32
        for <linux-media@vger.kernel.org>; Thu, 22 Aug 2013 19:59:44 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 23 Aug 2013 10:59:44 +0800
Message-ID: <CAPgLHd89o=SNERB1cCyQKUmyQE9q-hx6nj19yvVd_PzkOfp4BA@mail.gmail.com>
Subject: [PATCH -next] [media] davinci: vpif_display: fix error return code in vpif_probe()
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

Introduce by commit 4b8a531e6bb0686203e9cf82a54dfe189de7d5c2.
([media] media: davinci: vpif: display: add V4L2-async support)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/media/platform/davinci/vpif_display.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/davinci/vpif_display.c b/drivers/media/platform/davinci/vpif_display.c
index 6336dfc..0e03b9a 100644
--- a/drivers/media/platform/davinci/vpif_display.c
+++ b/drivers/media/platform/davinci/vpif_display.c
@@ -1824,6 +1824,7 @@ static __init int vpif_probe(struct platform_device *pdev)
 							  NULL);
 			if (!vpif_obj.sd[i]) {
 				vpif_err("Error registering v4l2 subdevice\n");
+				err = -ENODEV;
 				goto probe_subdev_out;
 			}
 

