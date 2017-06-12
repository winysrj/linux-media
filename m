Return-path: <linux-media-owner@vger.kernel.org>
Received: from relmlor4.renesas.com ([210.160.252.174]:58135 "EHLO
        relmlie3.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752074AbdFLNkP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Jun 2017 09:40:15 -0400
From: Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>
To: robh+dt@kernel.org, mark.rutland@arm.com, mchehab@kernel.org,
        hverkuil@xs4all.nl, sakari.ailus@linux.intel.com, crope@iki.fi
Cc: chris.paterson2@renesas.com, laurent.pinchart@ideasonboard.com,
        geert+renesas@glider.be, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>
Subject: [PATCH v8 8/8] MAINTAINERS: Add entry for R-Car DRIF & MAX2175 drivers
Date: Mon, 12 Jun 2017 14:26:20 +0100
Message-Id: <20170612132620.1024-9-ramesh.shanmugasundaram@bp.renesas.com>
In-Reply-To: <20170612132620.1024-1-ramesh.shanmugasundaram@bp.renesas.com>
References: <20170612132620.1024-1-ramesh.shanmugasundaram@bp.renesas.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add maintainter entry for the R-Car DRIF and MAX2175 drivers.

Signed-off-by: Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>
---
 MAINTAINERS | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 053c3bdd1fe5..cfa78fe5142a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8031,6 +8031,16 @@ S:	Maintained
 F:	Documentation/hwmon/max20751
 F:	drivers/hwmon/max20751.c
 
+MAX2175 SDR TUNER DRIVER
+M:	Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>
+L:	linux-media@vger.kernel.org
+T:	git git://linuxtv.org/media_tree.git
+S:	Maintained
+F:	Documentation/devicetree/bindings/media/i2c/max2175.txt
+F:	Documentation/media/v4l-drivers/max2175.rst
+F:	drivers/media/i2c/max2175*
+F:	include/uapi/linux/max2175.h
+
 MAX6650 HARDWARE MONITOR AND FAN CONTROLLER DRIVER
 L:	linux-hwmon@vger.kernel.org
 S:	Orphan
@@ -8111,6 +8121,15 @@ L:	linux-iio@vger.kernel.org
 S:	Maintained
 F:	drivers/iio/dac/cio-dac.c
 
+MEDIA DRIVERS FOR RENESAS - DRIF
+M:	Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>
+L:	linux-media@vger.kernel.org
+L:	linux-renesas-soc@vger.kernel.org
+T:	git git://linuxtv.org/media_tree.git
+S:	Supported
+F:	Documentation/devicetree/bindings/media/renesas,drif.txt
+F:	drivers/media/platform/rcar_drif.c
+
 MEDIA DRIVERS FOR RENESAS - FCP
 M:	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
 L:	linux-media@vger.kernel.org
-- 
2.12.2
