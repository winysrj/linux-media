Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f50.google.com ([209.85.214.50]:57018 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753115Ab3EMF7c (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 May 2013 01:59:32 -0400
Received: by mail-bk0-f50.google.com with SMTP id ik5so2195923bkc.23
        for <linux-media@vger.kernel.org>; Sun, 12 May 2013 22:59:31 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 13 May 2013 13:59:30 +0800
Message-ID: <CAPgLHd_RFb8soKV_ceoozB4ms2tGY+o-m6j+Z9ES38NnrhgU7Q@mail.gmail.com>
Subject: [PATCH] [media] blackfin: fix error return code in bcap_probe()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: scott.jiang.linux@gmail.com, mchehab@redhat.com
Cc: yongjun_wei@trendmicro.com.cn,
	uclinux-dist-devel@blackfin.uclinux.org,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Fix to return a negative error code from the error handling
case instead of 0, as done elsewhere in this function.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/media/platform/blackfin/bfin_capture.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/platform/blackfin/bfin_capture.c b/drivers/media/platform/blackfin/bfin_capture.c
index 0e55b08..2d1e032 100644
--- a/drivers/media/platform/blackfin/bfin_capture.c
+++ b/drivers/media/platform/blackfin/bfin_capture.c
@@ -1070,6 +1070,7 @@ static int bcap_probe(struct platform_device *pdev)
 		if (!config->num_inputs) {
 			v4l2_err(&bcap_dev->v4l2_dev,
 					"Unable to work without input\n");
+			ret = -EINVAL;
 			goto err_unreg_vdev;
 		}
 
@@ -1079,6 +1080,7 @@ static int bcap_probe(struct platform_device *pdev)
 	} else {
 		v4l2_err(&bcap_dev->v4l2_dev,
 				"Unable to register sub device\n");
+		ret = -ENODEV;
 		goto err_unreg_vdev;
 	}
 

