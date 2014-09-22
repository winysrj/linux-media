Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:53385 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755148AbaIVWWx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Sep 2014 18:22:53 -0400
Received: by mail-wi0-f176.google.com with SMTP id fb4so3811643wid.15
        for <linux-media@vger.kernel.org>; Mon, 22 Sep 2014 15:22:52 -0700 (PDT)
From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Maxime Coquelin <maxime.coquelin@st.com>,
	Patrice Chotard <patrice.chotard@st.com>,
	linux-arm-kernel@lists.infradead.org, kernel@stlinux.com,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH 3/3] media: st-rc: Remove .owner field for driver
Date: Mon, 22 Sep 2014 23:22:48 +0100
Message-Id: <1411424568-12803-1-git-send-email-srinivas.kandagatla@linaro.org>
In-Reply-To: <1411424501-12673-1-git-send-email-srinivas.kandagatla@linaro.org>
References: <1411424501-12673-1-git-send-email-srinivas.kandagatla@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There is no need to init .owner field.

Based on the patch from Peter Griffin <peter.griffin@linaro.org>
"mmc: remove .owner field for drivers using module_platform_driver"

This patch removes the superflous .owner field for drivers which
use the module_platform_driver API, as this is overriden in
platform_driver_register anyway."

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
---
 drivers/media/rc/st_rc.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/rc/st_rc.c b/drivers/media/rc/st_rc.c
index 03bbb09..e309441 100644
--- a/drivers/media/rc/st_rc.c
+++ b/drivers/media/rc/st_rc.c
@@ -392,7 +392,6 @@ MODULE_DEVICE_TABLE(of, st_rc_match);
 static struct platform_driver st_rc_driver = {
 	.driver = {
 		.name = IR_ST_NAME,
-		.owner	= THIS_MODULE,
 		.of_match_table = of_match_ptr(st_rc_match),
 		.pm     = &st_rc_pm_ops,
 	},
-- 
1.9.1

