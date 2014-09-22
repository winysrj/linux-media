Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f170.google.com ([74.125.82.170]:55379 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755145AbaIVWWm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Sep 2014 18:22:42 -0400
Received: by mail-we0-f170.google.com with SMTP id x48so2232626wes.29
        for <linux-media@vger.kernel.org>; Mon, 22 Sep 2014 15:22:41 -0700 (PDT)
From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Maxime Coquelin <maxime.coquelin@st.com>,
	Patrice Chotard <patrice.chotard@st.com>,
	linux-arm-kernel@lists.infradead.org, kernel@stlinux.com,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH 2/3] media: st-rc: move pm ops setup out of conditional compilation.
Date: Mon, 22 Sep 2014 23:22:38 +0100
Message-Id: <1411424558-12761-1-git-send-email-srinivas.kandagatla@linaro.org>
In-Reply-To: <1411424501-12673-1-git-send-email-srinivas.kandagatla@linaro.org>
References: <1411424501-12673-1-git-send-email-srinivas.kandagatla@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch moves setting of pm_ops out of the CONFIG_PM_SLEEP condition.
Setting pm ops under CONFIG_PM_SLEEP does not make any sense.
This patch also remove unnecessary also remove CONFIG_PM condition for pm
member in st_rc_driver structure.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
---
 drivers/media/rc/st_rc.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/media/rc/st_rc.c b/drivers/media/rc/st_rc.c
index e0f1312..03bbb09 100644
--- a/drivers/media/rc/st_rc.c
+++ b/drivers/media/rc/st_rc.c
@@ -376,9 +376,10 @@ static int st_rc_resume(struct device *dev)
 	return 0;
 }
 
-static SIMPLE_DEV_PM_OPS(st_rc_pm_ops, st_rc_suspend, st_rc_resume);
 #endif
 
+static SIMPLE_DEV_PM_OPS(st_rc_pm_ops, st_rc_suspend, st_rc_resume);
+
 #ifdef CONFIG_OF
 static struct of_device_id st_rc_match[] = {
 	{ .compatible = "st,comms-irb", },
@@ -393,9 +394,7 @@ static struct platform_driver st_rc_driver = {
 		.name = IR_ST_NAME,
 		.owner	= THIS_MODULE,
 		.of_match_table = of_match_ptr(st_rc_match),
-#ifdef CONFIG_PM
 		.pm     = &st_rc_pm_ops,
-#endif
 	},
 	.probe = st_rc_probe,
 	.remove = st_rc_remove,
-- 
1.9.1

