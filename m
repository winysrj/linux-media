Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl0-f68.google.com ([209.85.160.68]:46737 "EHLO
        mail-pl0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752859AbdKXCig (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 23 Nov 2017 21:38:36 -0500
From: Jacob Chen <jacob-chen@iotwrt.com>
To: linux-rockchip@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        mchehab@kernel.org, linux-media@vger.kernel.org,
        sakari.ailus@linux.intel.com, hans.verkuil@cisco.com,
        tfiga@chromium.org, zhengsq@rock-chips.com,
        laurent.pinchart@ideasonboard.com, zyc@rock-chips.com,
        eddie.cai.linux@gmail.com, jeffy.chen@rock-chips.com,
        allon.huang@rock-chips.com, devicetree@vger.kernel.org,
        heiko@sntech.de, robh+dt@kernel.org,
        Jacob Chen <jacob2.chen@rock-chips.com>
Subject: [PATCH v2 11/11] MAINTAINERS: add entry for Rockchip ISP1 driver
Date: Fri, 24 Nov 2017 10:37:06 +0800
Message-Id: <20171124023706.5702-12-jacob-chen@iotwrt.com>
In-Reply-To: <20171124023706.5702-1-jacob-chen@iotwrt.com>
References: <20171124023706.5702-1-jacob-chen@iotwrt.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jacob Chen <jacob2.chen@rock-chips.com>

Add MAINTAINERS entry for the rockchip isp1 driver.
This driver is maintained by rockchip officially and it
will be used for rockchip SoC on all linux-kernel based OS.

Signed-off-by: Jacob Chen <jacob2.chen@rock-chips.com>
---
 MAINTAINERS | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index b05bc2c5e85c..614196ed7265 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11665,6 +11665,16 @@ F:	drivers/hid/hid-roccat*
 F:	include/linux/hid-roccat*
 F:	Documentation/ABI/*/sysfs-driver-hid-roccat*
 
+ROCKCHIP ISP V1 DRIVER
+M:	Jacob chen <jacob2.chen@rock-chips.com>
+M:	Shunqian Zheng <zhengsq@rock-chips.com>
+M:	Yichong Zhong <zyc@rock-chips.com>
+L:	linux-media@vger.kernel.org
+S:	Maintained
+F:	drivers/media/platform/rockchip/isp1/
+F:	Documentation/devicetree/bindings/media/rockchip-isp1.txt
+F:	Documentation/devicetree/bindings/media/rockchip-mipi-dphy.txt
+
 ROCKCHIP RASTER 2D GRAPHIC ACCELERATION UNIT DRIVER
 M:	Jacob chen <jacob2.chen@rock-chips.com>
 L:	linux-media@vger.kernel.org
-- 
2.15.0
