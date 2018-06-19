Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:37750 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1030495AbeFSSuY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Jun 2018 14:50:24 -0400
Received: by mail-wr0-f195.google.com with SMTP id d8-v6so702755wro.4
        for <linux-media@vger.kernel.org>; Tue, 19 Jun 2018 11:50:23 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: mchehab@kernel.org, mchehab@s-opensource.com, rjkm@metzlerbros.de,
        mvoelkel@DigitalDevices.de
Cc: linux-media@vger.kernel.org
Subject: [PATCH v3 4/9] [media] dvb-frontends/mxl5xx: cleanup and fix licensing boilerplates
Date: Tue, 19 Jun 2018 20:50:11 +0200
Message-Id: <20180619185016.24402-5-d.scheller.oss@gmail.com>
In-Reply-To: <20180619185016.24402-1-d.scheller.oss@gmail.com>
References: <20180619185016.24402-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

mxl5xx.h doesn't carry any licensing boilerplate at all right now, so copy
the boilerplate over from the main driver file mxl5xx.c. Also, mxl5xx_defs
is missing a part of the licensing boilerplate text, so add it. While at
it, fix up some minor whitespace and blank line issues.

Cc: Ralph Metzler <rjkm@metzlerbros.de>
Cc: Manfred Voelkel <mvoelkel@DigitalDevices.de>
Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/dvb-frontends/mxl5xx.c      |  3 +--
 drivers/media/dvb-frontends/mxl5xx.h      | 21 +++++++++++++++++++++
 drivers/media/dvb-frontends/mxl5xx_defs.h |  5 +++++
 drivers/media/dvb-frontends/mxl5xx_regs.h |  3 +--
 4 files changed, 28 insertions(+), 4 deletions(-)

diff --git a/drivers/media/dvb-frontends/mxl5xx.c b/drivers/media/dvb-frontends/mxl5xx.c
index 1067701bdd06..323fd73d6e1e 100644
--- a/drivers/media/dvb-frontends/mxl5xx.c
+++ b/drivers/media/dvb-frontends/mxl5xx.c
@@ -15,9 +15,8 @@
  *
  * This program is distributed in the hope that it will be useful,
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
  * GNU General Public License for more details.
- *
  */
 
 #include <linux/kernel.h>
diff --git a/drivers/media/dvb-frontends/mxl5xx.h b/drivers/media/dvb-frontends/mxl5xx.h
index ad4c21846800..2ee821b15693 100644
--- a/drivers/media/dvb-frontends/mxl5xx.h
+++ b/drivers/media/dvb-frontends/mxl5xx.h
@@ -1,3 +1,24 @@
+/*
+ * Driver for the MaxLinear MxL5xx family of tuners/demods
+ *
+ * Copyright (C) 2014-2015 Ralph Metzler <rjkm@metzlerbros.de>
+ *                         Marcus Metzler <mocm@metzlerbros.de>
+ *                         developed for Digital Devices GmbH
+ *
+ * based on code:
+ * Copyright (c) 2011-2013 MaxLinear, Inc. All rights reserved
+ * which was released under GPL V2
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ */
+
 #ifndef _MXL5XX_H_
 #define _MXL5XX_H_
 
diff --git a/drivers/media/dvb-frontends/mxl5xx_defs.h b/drivers/media/dvb-frontends/mxl5xx_defs.h
index fd9e61e0188f..fd5c0f5b27ba 100644
--- a/drivers/media/dvb-frontends/mxl5xx_defs.h
+++ b/drivers/media/dvb-frontends/mxl5xx_defs.h
@@ -10,6 +10,11 @@
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License
  * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
  */
 
 enum MXL_BOOL_E {
diff --git a/drivers/media/dvb-frontends/mxl5xx_regs.h b/drivers/media/dvb-frontends/mxl5xx_regs.h
index 5001dafe1ba8..dacc1fdf4c7b 100644
--- a/drivers/media/dvb-frontends/mxl5xx_regs.h
+++ b/drivers/media/dvb-frontends/mxl5xx_regs.h
@@ -9,11 +9,10 @@
  *
  * This program is distributed in the hope that it will be useful, but WITHOUT
  * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
- * FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
+ * FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
  *
  * This program may alternatively be licensed under a proprietary license from
  * MaxLinear, Inc.
- *
  */
 
 #ifndef __MXL58X_REGISTERS_H__
-- 
2.16.4
