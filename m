Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f51.google.com ([209.85.214.51]:49889 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904Ab3EMF5Y (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 May 2013 01:57:24 -0400
Received: by mail-bk0-f51.google.com with SMTP id ji2so2217023bkc.24
        for <linux-media@vger.kernel.org>; Sun, 12 May 2013 22:57:23 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 13 May 2013 13:57:23 +0800
Message-ID: <CAPgLHd_iDfVzq2S_uSh1tBVpQdFa4oyMpWGovDDNCYsh0bLJog@mail.gmail.com>
Subject: [PATCH] [media] vpif_display: fix error return code in vpif_probe()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: prabhakar.csengg@gmail.com, mchehab@redhat.com
Cc: yongjun_wei@trendmicro.com.cn, linux-media@vger.kernel.org,
	davinci-linux-open-source@linux.davincidsp.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Fix to return -ENODEV in the subdevice register error handling
case instead of 0, as done elsewhere in this function.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/media/platform/davinci/vpif_display.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/davinci/vpif_display.c b/drivers/media/platform/davinci/vpif_display.c
index 1b3fb5c..50b2f39 100644
--- a/drivers/media/platform/davinci/vpif_display.c
+++ b/drivers/media/platform/davinci/vpif_display.c
@@ -1813,6 +1813,7 @@ static __init int vpif_probe(struct platform_device *pdev)
 						NULL);
 		if (!vpif_obj.sd[i]) {
 			vpif_err("Error registering v4l2 subdevice\n");
+			err = -ENODEV;
 			goto probe_subdev_out;
 		}
 

