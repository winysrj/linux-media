Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f49.google.com ([209.85.214.49]:50118 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904Ab3EMF5i (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 May 2013 01:57:38 -0400
Received: by mail-bk0-f49.google.com with SMTP id na10so14209bkb.36
        for <linux-media@vger.kernel.org>; Sun, 12 May 2013 22:57:37 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 13 May 2013 13:57:37 +0800
Message-ID: <CAPgLHd_crJZgL3HxbCju0Zsq9q+vq8BrTnVxmhZWK9x464PF3A@mail.gmail.com>
Subject: [PATCH] [media] vpif_capture: fix error return code in vpif_probe()
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
 drivers/media/platform/davinci/vpif_capture.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
index 5f98df1..ef0fc94 100644
--- a/drivers/media/platform/davinci/vpif_capture.c
+++ b/drivers/media/platform/davinci/vpif_capture.c
@@ -2170,6 +2170,7 @@ static __init int vpif_probe(struct platform_device *pdev)
 
 		if (!vpif_obj.sd[i]) {
 			vpif_err("Error registering v4l2 subdevice\n");
+			err = -ENODEV;
 			goto probe_subdev_out;
 		}
 		v4l2_info(&vpif_obj.v4l2_dev, "registered sub device %s\n",

