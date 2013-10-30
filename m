Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f47.google.com ([209.85.214.47]:53732 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470Ab3J3DKq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Oct 2013 23:10:46 -0400
Received: by mail-bk0-f47.google.com with SMTP id d7so48466bkh.6
        for <linux-media@vger.kernel.org>; Tue, 29 Oct 2013 20:10:45 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 30 Oct 2013 11:10:45 +0800
Message-ID: <CAPgLHd_VJKy0Eqsyjb=_CKbCZTEvpq6Gh+ri3YSTHPEqLN=U0w@mail.gmail.com>
Subject: [PATCH -next] [media] v4l: ti-vpe: fix error return code in vpe_probe()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: m.chehab@samsung.com, grant.likely@linaro.org,
	rob.herring@calxeda.com, archit@ti.com, hans.verkuil@cisco.com,
	k.debski@samsung.com
Cc: yongjun_wei@trendmicro.com.cn, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Fix to return a negative error code from the error handling
case instead of 0, as done elsewhere in this function.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/media/platform/ti-vpe/vpe.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/ti-vpe/vpe.c b/drivers/media/platform/ti-vpe/vpe.c
index 4e58069..0dbfd52 100644
--- a/drivers/media/platform/ti-vpe/vpe.c
+++ b/drivers/media/platform/ti-vpe/vpe.c
@@ -2007,8 +2007,10 @@ static int vpe_probe(struct platform_device *pdev)
 	vpe_top_vpdma_reset(dev);
 
 	dev->vpdma = vpdma_create(pdev);
-	if (IS_ERR(dev->vpdma))
+	if (IS_ERR(dev->vpdma)) {
+		ret = PTR_ERR(dev->vpdma);
 		goto runtime_put;
+	}
 
 	vfd = &dev->vfd;
 	*vfd = vpe_videodev;

