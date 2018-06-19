Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:34652 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1030465AbeFSSuZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Jun 2018 14:50:25 -0400
Received: by mail-wm0-f67.google.com with SMTP id l15-v6so19877828wmc.1
        for <linux-media@vger.kernel.org>; Tue, 19 Jun 2018 11:50:24 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: mchehab@kernel.org, mchehab@s-opensource.com, rjkm@metzlerbros.de,
        mvoelkel@DigitalDevices.de
Cc: linux-media@vger.kernel.org
Subject: [PATCH v3 5/9] [media] dvb-frontends/mxl5xx: add SPDX license identifier
Date: Tue, 19 Jun 2018 20:50:12 +0200
Message-Id: <20180619185016.24402-6-d.scheller.oss@gmail.com>
In-Reply-To: <20180619185016.24402-1-d.scheller.oss@gmail.com>
References: <20180619185016.24402-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

As it is clear that the driver is licensed under the terms of GPLv2-only
by now, add a matching SPDX license identifier to all driver files.

Cc: Ralph Metzler <rjkm@metzlerbros.de>
Cc: Manfred Voelkel <mvoelkel@DigitalDevices.de>
Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/dvb-frontends/mxl5xx.c      | 1 +
 drivers/media/dvb-frontends/mxl5xx.h      | 1 +
 drivers/media/dvb-frontends/mxl5xx_defs.h | 1 +
 drivers/media/dvb-frontends/mxl5xx_regs.h | 1 +
 4 files changed, 4 insertions(+)

diff --git a/drivers/media/dvb-frontends/mxl5xx.c b/drivers/media/dvb-frontends/mxl5xx.c
index 323fd73d6e1e..922449f940a0 100644
--- a/drivers/media/dvb-frontends/mxl5xx.c
+++ b/drivers/media/dvb-frontends/mxl5xx.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * Driver for the MaxLinear MxL5xx family of tuners/demods
  *
diff --git a/drivers/media/dvb-frontends/mxl5xx.h b/drivers/media/dvb-frontends/mxl5xx.h
index 2ee821b15693..5113759d7fb7 100644
--- a/drivers/media/dvb-frontends/mxl5xx.h
+++ b/drivers/media/dvb-frontends/mxl5xx.h
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Driver for the MaxLinear MxL5xx family of tuners/demods
  *
diff --git a/drivers/media/dvb-frontends/mxl5xx_defs.h b/drivers/media/dvb-frontends/mxl5xx_defs.h
index fd5c0f5b27ba..295a2d75b5a7 100644
--- a/drivers/media/dvb-frontends/mxl5xx_defs.h
+++ b/drivers/media/dvb-frontends/mxl5xx_defs.h
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Defines for the Maxlinear MX58x family of tuners/demods
  *
diff --git a/drivers/media/dvb-frontends/mxl5xx_regs.h b/drivers/media/dvb-frontends/mxl5xx_regs.h
index dacc1fdf4c7b..1b9715691b3c 100644
--- a/drivers/media/dvb-frontends/mxl5xx_regs.h
+++ b/drivers/media/dvb-frontends/mxl5xx_regs.h
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright (c) 2011-2013 MaxLinear, Inc. All rights reserved
  *
-- 
2.16.4
