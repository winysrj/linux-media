Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr1-f65.google.com ([209.85.221.65]:35239 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725757AbeHIECM (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 9 Aug 2018 00:02:12 -0400
Received: by mail-wr1-f65.google.com with SMTP id g1-v6so3667437wru.2
        for <linux-media@vger.kernel.org>; Wed, 08 Aug 2018 18:39:54 -0700 (PDT)
From: petrcvekcz@gmail.com
To: marek.vasut@gmail.com, mchehab@kernel.org
Cc: Petr Cvek <petrcvekcz@gmail.com>, linux-media@vger.kernel.org,
        robert.jarzmik@free.fr, slapin@ossfans.org, philipp.zabel@gmail.com
Subject: [PATCH v1 5/5] MAINTAINERS: Add Petr Cvek as a maintainer for the ov9640 driver
Date: Thu,  9 Aug 2018 03:39:49 +0200
Message-Id: <9f5b7e4096be155e9e6ee6896c22fbb8ce3c16c4.1533774451.git.petrcvekcz@gmail.com>
In-Reply-To: <cover.1533774451.git.petrcvekcz@gmail.com>
References: <cover.1533774451.git.petrcvekcz@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Petr Cvek <petrcvekcz@gmail.com>

The soc_camera drivers are marked as orphaned. Add Petr Cvek as a new
maintainer for ov9640 driver after its switch from the soc_camera.

Signed-off-by: Petr Cvek <petrcvekcz@gmail.com>
---
 MAINTAINERS | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 40d5ec9292ca..cab3fa4ccb37 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10627,6 +10627,12 @@ S:	Maintained
 F:	drivers/media/i2c/ov7740.c
 F:	Documentation/devicetree/bindings/media/i2c/ov7740.txt
 
+OMNIVISION OV9640 SENSOR DRIVER
+M:	Petr Cvek <petrcvekcz@gmail.com>
+L:	linux-media@vger.kernel.org
+S:	Maintained
+F:	drivers/media/i2c/ov9640.*
+
 OMNIVISION OV9650 SENSOR DRIVER
 M:	Sakari Ailus <sakari.ailus@linux.intel.com>
 R:	Akinobu Mita <akinobu.mita@gmail.com>
-- 
2.18.0
