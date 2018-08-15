Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:55844 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729264AbeHOQWa (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Aug 2018 12:22:30 -0400
Received: by mail-wm0-f67.google.com with SMTP id f21-v6so1393240wmc.5
        for <linux-media@vger.kernel.org>; Wed, 15 Aug 2018 06:30:18 -0700 (PDT)
From: petrcvekcz@gmail.com
To: hans.verkuil@cisco.com, jacopo@jmondi.org, mchehab@kernel.org,
        marek.vasut@gmail.com
Cc: Petr Cvek <petrcvekcz@gmail.com>, linux-media@vger.kernel.org,
        robert.jarzmik@free.fr, slapin@ossfans.org, philipp.zabel@gmail.com
Subject: [PATCH v2 3/4] media: i2c: ov9640: add missing SPDX identifiers
Date: Wed, 15 Aug 2018 15:30:26 +0200
Message-Id: <4b890bbac6ab58ded07de0f4972cee23492deb53.1534339750.git.petrcvekcz@gmail.com>
In-Reply-To: <cover.1534339750.git.petrcvekcz@gmail.com>
References: <cover.1534339750.git.petrcvekcz@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Petr Cvek <petrcvekcz@gmail.com>

Add missing SPDX identifiers to .c and .h files of the sensor driver.

Signed-off-by: Petr Cvek <petrcvekcz@gmail.com>
---
 drivers/media/i2c/ov9640.c | 5 +----
 drivers/media/i2c/ov9640.h | 5 +----
 2 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/media/i2c/ov9640.c b/drivers/media/i2c/ov9640.c
index ae55d13233f0..158959193453 100644
--- a/drivers/media/i2c/ov9640.c
+++ b/drivers/media/i2c/ov9640.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * OmniVision OV96xx Camera Driver
  *
@@ -14,10 +15,6 @@
  * Copyright 2006-7 Jonathan Corbet <corbet@lwn.net>
  * Copyright (C) 2008 Magnus Damm
  * Copyright (C) 2008, Guennadi Liakhovetski <kernel@pengutronix.de>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
  */
 
 #include <linux/init.h>
diff --git a/drivers/media/i2c/ov9640.h b/drivers/media/i2c/ov9640.h
index be5e4b29ac69..a8ed6992c1a8 100644
--- a/drivers/media/i2c/ov9640.h
+++ b/drivers/media/i2c/ov9640.h
@@ -1,11 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * OmniVision OV96xx Camera Header File
  *
  * Copyright (C) 2009 Marek Vasut <marek.vasut@gmail.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
  */
 
 #ifndef	__DRIVERS_MEDIA_VIDEO_OV9640_H__
-- 
2.18.0
