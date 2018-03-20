Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:45875 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751485AbeCTVBn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 20 Mar 2018 17:01:43 -0400
Received: by mail-wr0-f195.google.com with SMTP id h2so3130212wre.12
        for <linux-media@vger.kernel.org>; Tue, 20 Mar 2018 14:01:43 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: gregkh@linuxfoundation.org, mvoelkel@DigitalDevices.de,
        rjkm@metzlerbros.de, jasmin@anw.at
Subject: [PATCH 2/5] [media] dvb-frontends/mxl5xx: add SPDX license headers
Date: Tue, 20 Mar 2018 22:01:29 +0100
Message-Id: <20180320210132.7873-3-d.scheller.oss@gmail.com>
In-Reply-To: <20180320210132.7873-1-d.scheller.oss@gmail.com>
References: <20180320210132.7873-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Add SPDX license headers to the mxl5xx DVB frontend driver and it's
related includes, and fix MODULE_LICENSE while at it.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/dvb-frontends/mxl5xx.c      |  6 +++---
 drivers/media/dvb-frontends/mxl5xx.h      | 13 +++++++++++++
 drivers/media/dvb-frontends/mxl5xx_defs.h |  1 +
 drivers/media/dvb-frontends/mxl5xx_regs.h |  4 ++--
 4 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/drivers/media/dvb-frontends/mxl5xx.c b/drivers/media/dvb-frontends/mxl5xx.c
index 483ee7d6198e..57ea61f53dbe 100644
--- a/drivers/media/dvb-frontends/mxl5xx.c
+++ b/drivers/media/dvb-frontends/mxl5xx.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0-only
 /*
  * Driver for the MaxLinear MxL5xx family of tuners/demods
  *
@@ -15,9 +16,8 @@
  *
  * This program is distributed in the hope that it will be useful,
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
  * GNU General Public License for more details.
- *
  */
 
 #include <linux/kernel.h>
@@ -1895,4 +1895,4 @@ EXPORT_SYMBOL_GPL(mxl5xx_attach);
 
 MODULE_DESCRIPTION("MaxLinear MxL5xx DVB-S/S2 tuner-demodulator driver");
 MODULE_AUTHOR("Ralph and Marcus Metzler, Metzler Brothers Systementwicklung GbR");
-MODULE_LICENSE("GPL");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/media/dvb-frontends/mxl5xx.h b/drivers/media/dvb-frontends/mxl5xx.h
index ad4c21846800..34e786dc7bb9 100644
--- a/drivers/media/dvb-frontends/mxl5xx.h
+++ b/drivers/media/dvb-frontends/mxl5xx.h
@@ -1,3 +1,16 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
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
+ */
+
 #ifndef _MXL5XX_H_
 #define _MXL5XX_H_
 
diff --git a/drivers/media/dvb-frontends/mxl5xx_defs.h b/drivers/media/dvb-frontends/mxl5xx_defs.h
index fd9e61e0188f..a6062b4b39cb 100644
--- a/drivers/media/dvb-frontends/mxl5xx_defs.h
+++ b/drivers/media/dvb-frontends/mxl5xx_defs.h
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
 /*
  * Defines for the Maxlinear MX58x family of tuners/demods
  *
diff --git a/drivers/media/dvb-frontends/mxl5xx_regs.h b/drivers/media/dvb-frontends/mxl5xx_regs.h
index 5001dafe1ba8..d231151c437f 100644
--- a/drivers/media/dvb-frontends/mxl5xx_regs.h
+++ b/drivers/media/dvb-frontends/mxl5xx_regs.h
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
 /*
  * Copyright (c) 2011-2013 MaxLinear, Inc. All rights reserved
  *
@@ -9,11 +10,10 @@
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
2.16.1
