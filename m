Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:33099 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753772AbcJ3Bxc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 29 Oct 2016 21:53:32 -0400
Received: by mail-pf0-f193.google.com with SMTP id a136so1665002pfa.0
        for <linux-media@vger.kernel.org>; Sat, 29 Oct 2016 18:53:31 -0700 (PDT)
From: Wei Yongjun <weiyj.lk@gmail.com>
To: Patrice Chotard <patrice.chotard@st.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Wei Yongjun <weiyongjun1@huawei.com>,
        linux-arm-kernel@lists.infradead.org, kernel@stlinux.com,
        linux-media@vger.kernel.org
Subject: [PATCH -next] [media] c8sectpfe: fix error return code in c8sectpfe_probe()
Date: Sun, 30 Oct 2016 01:53:10 +0000
Message-Id: <1477792390-24533-1-git-send-email-weiyj.lk@gmail.com>
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
 drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c b/drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c
index 42b123f..69d9a16 100644
--- a/drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c
+++ b/drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c
@@ -813,6 +813,7 @@ static int c8sectpfe_probe(struct platform_device *pdev)
 		i2c_bus = of_parse_phandle(child, "i2c-bus", 0);
 		if (!i2c_bus) {
 			dev_err(&pdev->dev, "No i2c-bus found\n");
+			ret = -ENODEV;
 			goto err_clk_disable;
 		}
 		tsin->i2c_adapter =
@@ -820,6 +821,7 @@ static int c8sectpfe_probe(struct platform_device *pdev)
 		if (!tsin->i2c_adapter) {
 			dev_err(&pdev->dev, "No i2c adapter found\n");
 			of_node_put(i2c_bus);
+			ret = -ENODEV;
 			goto err_clk_disable;
 		}
 		of_node_put(i2c_bus);

