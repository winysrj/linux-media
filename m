Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:25646 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753014AbaHTNok (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Aug 2014 09:44:40 -0400
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org, devicetree@vger.kernel.org,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: kyungmin.park@samsung.com, b.zolnierkie@samsung.com,
	Jacek Anaszewski <j.anaszewski@samsung.com>,
	Bryan Wu <cooloney@gmail.com>,
	Richard Purdie <rpurdie@rpsys.net>
Subject: [PATCH/RFC v5 03/10] Documentation: leds: add exemplary asynchronous
 mux driver
Date: Wed, 20 Aug 2014 15:44:12 +0200
Message-id: <1408542259-415-4-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1408542259-415-1-git-send-email-j.anaszewski@samsung.com>
References: <1408542259-415-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Exemplary driver showing usage of the Flash Manager API
for registering/unregistering asynchronous multiplexers

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Bryan Wu <cooloney@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
---
 Documentation/leds/leds-async-mux.c |   65 +++++++++++++++++++++++++++++++++++
 1 file changed, 65 insertions(+)
 create mode 100644 Documentation/leds/leds-async-mux.c

diff --git a/Documentation/leds/leds-async-mux.c b/Documentation/leds/leds-async-mux.c
new file mode 100644
index 0000000..ee35d2f
--- /dev/null
+++ b/Documentation/leds/leds-async-mux.c
@@ -0,0 +1,65 @@
+/*
+ * Exemplary driver showing usage of the Flash Manager API
+ * for registering/unregistering asynchronous multiplexers.
+ *
+ *	Copyright (C) 2014, Samsung Electronics Co., Ltd.
+ *	Author: Jacek Anaszewski <j.anaszewski@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ */
+
+#include <linux/platform_device.h>
+#include <linux/module.h>
+#include <linux/led-class-flash.h>
+#include <linux/led-flash-manager.h>
+#include <linux/leds.h>
+#include <linux/of.h>
+
+static int led_async_mux_select_line(u32 line_id, void *mux)
+{
+	pr_info("led_async_mux_select_line line_id: %d\n", line_id);
+	return 0;
+}
+
+struct led_flash_mux_ops mux_ops = {
+	.select_line = led_async_mux_select_line,
+};
+
+static int led_async_mux_probe(struct platform_device *pdev)
+{
+	struct led_flash_mux mux;
+
+	mux.ops = &mux_ops;
+	mux.owner = THIS_MODULE;
+	mux.node = pdev->dev->of_node;
+
+	return led_flash_manager_bind_async_mux(&mux);
+}
+
+static int led_async_mux_remove(struct platform_device *pdev)
+{
+	return led_flash_manager_unbind_async_mux(pdev->dev->of_node);
+}
+
+static struct of_device_id led_async_mux_dt_match[] = {
+	{.compatible = "led-async-mux"},
+	{},
+};
+
+static struct platform_driver led_async_mux_driver = {
+	.probe		= led_async_mux_probe,
+	.remove		= led_async_mux_remove,
+	.driver		= {
+		.name		= "led-async-mux",
+		.owner		= THIS_MODULE,
+		.of_match_table = led_async_mux_dt_match,
+	},
+};
+
+module_platform_driver(led_async_mux_driver);
+
+MODULE_AUTHOR("Jacek Anaszewski <j.anaszewski@samsung.com>");
+MODULE_DESCRIPTION("LED async mux");
+MODULE_LICENSE("GPL");
-- 
1.7.9.5

