Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr1-f68.google.com ([209.85.221.68]:44389 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731149AbeG0NoF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 27 Jul 2018 09:44:05 -0400
Received: by mail-wr1-f68.google.com with SMTP id r16-v6so4856508wrt.11
        for <linux-media@vger.kernel.org>; Fri, 27 Jul 2018 05:22:23 -0700 (PDT)
From: Rui Miguel Silva <rui.silva@linaro.org>
To: sakari.ailus@linux.intel.com
Cc: linux-media@vger.kernel.org, Ryan Harkin <ryan.harkin@linaro.org>,
        Rui Miguel Silva <rui.silva@linaro.org>
Subject: [PATCH]  media: ov2680: Add Omnivision OV2680 maintainer
Date: Fri, 27 Jul 2018 13:22:02 +0100
Message-Id: <20180727122202.26223-1-rui.silva@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add myself as maintainer of the Omnivision OV2680 sensor driver.

Signed-off-by: Rui Miguel Silva <rui.silva@linaro.org>
---
 MAINTAINERS | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 0fe4228f78cb..a9d296277676 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10463,6 +10463,14 @@ T:	git git://linuxtv.org/media_tree.git
 S:	Maintained
 F:	drivers/media/i2c/ov13858.c
 
+OMNIVISION OV2680 SENSOR DRIVER
+M:	Rui Miguel Silva <rmfrfs@gmail.com>
+L:	linux-media@vger.kernel.org
+T:	git git://linuxtv.org/media_tree.git
+S:	Maintained
+F:	drivers/media/i2c/ov2680.c
+F:	Documentation/devicetree/bindings/media/i2c/ov2680.txt
+
 OMNIVISION OV2685 SENSOR DRIVER
 M:	Shunqian Zheng <zhengsq@rock-chips.com>
 L:	linux-media@vger.kernel.org
-- 
2.18.0
