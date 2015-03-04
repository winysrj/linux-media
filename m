Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:12578 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933038AbbCDQQN (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Mar 2015 11:16:13 -0500
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org, linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
	kyungmin.park@samsung.com, pavel@ucw.cz, cooloney@gmail.com,
	rpurdie@rpsys.net, sakari.ailus@iki.fi, s.nawrocki@samsung.com,
	Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: [PATCH/RFC v12 04/19] dt-binding: leds: Add common LED DT bindings
 macros
Date: Wed, 04 Mar 2015 17:14:25 +0100
Message-id: <1425485680-8417-5-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1425485680-8417-1-git-send-email-j.anaszewski@samsung.com>
References: <1425485680-8417-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add macros for defining boost mode and trigger type properties
of flash LED devices.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Bryan Wu <cooloney@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
---
 include/dt-bindings/leds/max77693.h |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)
 create mode 100644 include/dt-bindings/leds/max77693.h

diff --git a/include/dt-bindings/leds/max77693.h b/include/dt-bindings/leds/max77693.h
new file mode 100644
index 0000000..79fcef7
--- /dev/null
+++ b/include/dt-bindings/leds/max77693.h
@@ -0,0 +1,21 @@
+/*
+ * This header provides macros for the common LEDs device tree bindings.
+ *
+ * Copyright (C) 2015, Samsung Electronics Co., Ltd.
+ *
+ * Author: Jacek Anaszewski <j.anaszewski@samsung.com>
+ */
+
+#ifndef __DT_BINDINGS_LEDS_H__
+#define __DT_BINDINGS_LEDS_H
+
+/* External trigger type */
+#define LEDS_TRIG_TYPE_EDGE	0
+#define LEDS_TRIG_TYPE_LEVEL	1
+
+/* Boost modes */
+#define LEDS_BOOST_OFF		0
+#define LEDS_BOOST_ADAPTIVE	1
+#define LEDS_BOOST_FIXED	2
+
+#endif /* __DT_BINDINGS_LEDS_H */
-- 
1.7.9.5

