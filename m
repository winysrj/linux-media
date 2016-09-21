Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:35276 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755814AbcIUPJp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 21 Sep 2016 11:09:45 -0400
Received: by mail-pf0-f196.google.com with SMTP id 6so2505874pfl.2
        for <linux-media@vger.kernel.org>; Wed, 21 Sep 2016 08:09:45 -0700 (PDT)
From: Wei Yongjun <weiyj.lk@gmail.com>
To: Fabien Dessenne <fabien.dessenne@st.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Wei Yongjun <weiyongjun1@huawei.com>, linux-media@vger.kernel.org
Subject: [PATCH -next] [media] bdisp: fix error return code in bdisp_probe()
Date: Wed, 21 Sep 2016 15:09:38 +0000
Message-Id: <1474470578-2870-1-git-send-email-weiyj.lk@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Wei Yongjun <weiyongjun1@huawei.com>

Fix to return error code -EINVAL from the platform_get_resource() error
handling case instead of 0, as done elsewhere in this function.

Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 drivers/media/platform/sti/bdisp/bdisp-v4l2.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/sti/bdisp/bdisp-v4l2.c b/drivers/media/platform/sti/bdisp/bdisp-v4l2.c
index 45f82b5..8236081 100644
--- a/drivers/media/platform/sti/bdisp/bdisp-v4l2.c
+++ b/drivers/media/platform/sti/bdisp/bdisp-v4l2.c
@@ -1337,6 +1337,7 @@ static int bdisp_probe(struct platform_device *pdev)
 	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
 	if (!res) {
 		dev_err(dev, "failed to get IRQ resource\n");
+		ret = -EINVAL;
 		goto err_clk;
 	}

