Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:34722 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757154AbdJKHaH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 11 Oct 2017 03:30:07 -0400
From: Jacob Chen <jacob-chen@iotwrt.com>
To: linux-rockchip@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, heiko@sntech.de, robh+dt@kernel.org,
        mchehab@kernel.org, linux-media@vger.kernel.org,
        laurent.pinchart+renesas@ideasonboard.com, hans.verkuil@cisco.com,
        Jacob Chen <jacob-chen@iotwrt.com>
Subject: [PATCH v12 3/5] MAINTAINERS: add entry for Rockchip RGA driver
Date: Wed, 11 Oct 2017 15:29:36 +0800
Message-Id: <20171011072938.383-4-jacob-chen@iotwrt.com>
In-Reply-To: <20171011072938.383-1-jacob-chen@iotwrt.com>
References: <20171011072938.383-1-jacob-chen@iotwrt.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Jacob Chen <jacob-chen@iotwrt.com>
---
 MAINTAINERS | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 6671f375f7fc..335497bbc3f3 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11509,6 +11509,13 @@ F:	drivers/hid/hid-roccat*
 F:	include/linux/hid-roccat*
 F:	Documentation/ABI/*/sysfs-driver-hid-roccat*
 
+ROCKCHIP RASTER 2D GRAPHIC ACCELERATION UNIT DRIVER
+M:	Jacob chen <jacob-chen@iotwrt.com>
+L:	linux-media@vger.kernel.org
+S:	Maintained
+F:	drivers/media/platform/rockchip/rga/
+F:	Documentation/devicetree/bindings/media/rockchip-rga.txt
+
 ROCKER DRIVER
 M:	Jiri Pirko <jiri@resnulli.us>
 L:	netdev@vger.kernel.org
-- 
2.14.1
