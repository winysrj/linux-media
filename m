Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:38470 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753076AbdJLDdR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 11 Oct 2017 23:33:17 -0400
From: Jacob Chen <jacob-chen@iotwrt.com>
To: linux-rockchip@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        hans.verkuil@cisco.com, Jacob Chen <jacob-chen@iotwrt.com>
Subject: [PATCH v13] MAINTAINERS: add entry for Rockchip RGA driver
Date: Thu, 12 Oct 2017 11:33:09 +0800
Message-Id: <20171012033309.2062-1-jacob-chen@iotwrt.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Jacob Chen <jacob-chen@iotwrt.com>
---
 MAINTAINERS | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 6671f375f7fc..b13dae0cbf42 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11509,6 +11509,13 @@ F:	drivers/hid/hid-roccat*
 F:	include/linux/hid-roccat*
 F:	Documentation/ABI/*/sysfs-driver-hid-roccat*
 
+ROCKCHIP RASTER 2D GRAPHIC ACCELERATION UNIT DRIVER
+M:	Jacob chen <jacob2.chen@rock-chips.com>
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
