Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:39384 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758651AbeAIOsv (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 9 Jan 2018 09:48:51 -0500
From: Shunqian Zheng <zhengsq@rock-chips.com>
To: mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        ddl@rock-chips.com, tfiga@chromium.org,
        Shunqian Zheng <zhengsq@rock-chips.com>
Subject: [PATCH v4 5/5] [media] MAINTAINERS: add entries for OV2685/OV5695 sensor drivers
Date: Tue,  9 Jan 2018 22:48:24 +0800
Message-Id: <1515509304-15941-6-git-send-email-zhengsq@rock-chips.com>
In-Reply-To: <1515509304-15941-1-git-send-email-zhengsq@rock-chips.com>
References: <1515509304-15941-1-git-send-email-zhengsq@rock-chips.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add maintainer entries for the OV2685 and OV5695 V4L2 sensor drivers.

Signed-off-by: Shunqian Zheng <zhengsq@rock-chips.com>
---
 MAINTAINERS | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 85773bf..32afc69 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10032,6 +10032,13 @@ T:	git git://linuxtv.org/media_tree.git
 S:	Maintained
 F:	drivers/media/i2c/ov13858.c
 
+OMNIVISION OV2685 SENSOR DRIVER
+M:	Shunqian Zheng <zhengsq@rock-chips.com>
+L:	linux-media@vger.kernel.org
+T:	git git://linuxtv.org/media_tree.git
+S:	Maintained
+F:	drivers/media/i2c/ov2685.c
+
 OMNIVISION OV5640 SENSOR DRIVER
 M:	Steve Longerbeam <slongerbeam@gmail.com>
 L:	linux-media@vger.kernel.org
@@ -10046,6 +10053,13 @@ T:	git git://linuxtv.org/media_tree.git
 S:	Maintained
 F:	drivers/media/i2c/ov5647.c
 
+OMNIVISION OV5695 SENSOR DRIVER
+M:	Shunqian Zheng <zhengsq@rock-chips.com>
+L:	linux-media@vger.kernel.org
+T:	git git://linuxtv.org/media_tree.git
+S:	Maintained
+F:	drivers/media/i2c/ov5695.c
+
 OMNIVISION OV7670 SENSOR DRIVER
 M:	Jonathan Corbet <corbet@lwn.net>
 L:	linux-media@vger.kernel.org
-- 
1.9.1
