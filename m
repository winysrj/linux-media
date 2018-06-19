Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:39429 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1030446AbeFSSu0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Jun 2018 14:50:26 -0400
Received: by mail-wr0-f194.google.com with SMTP id w7-v6so695178wrn.6
        for <linux-media@vger.kernel.org>; Tue, 19 Jun 2018 11:50:25 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: mchehab@kernel.org, mchehab@s-opensource.com, rjkm@metzlerbros.de,
        mvoelkel@DigitalDevices.de
Cc: linux-media@vger.kernel.org
Subject: [PATCH v3 6/9] [media] dvb-frontends/stv0910: cleanup and fix licensing boilerplates
Date: Tue, 19 Jun 2018 20:50:13 +0200
Message-Id: <20180619185016.24402-7-d.scheller.oss@gmail.com>
In-Reply-To: <20180619185016.24402-1-d.scheller.oss@gmail.com>
References: <20180619185016.24402-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

The stv0910.h doesn't carry any header nor any licensing boilerplate at
all, so copy this from the main driver file stv0910.c. While at it,
apply the usual whitespace/blank line cleanup aswell.

Cc: Ralph Metzler <rjkm@metzlerbros.de>
Cc: Manfred Voelkel <mvoelkel@DigitalDevices.de>
Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/dvb-frontends/stv0910.c      |  2 +-
 drivers/media/dvb-frontends/stv0910.h      | 17 +++++++++++++++++
 drivers/media/dvb-frontends/stv0910_regs.h |  2 +-
 3 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb-frontends/stv0910.c b/drivers/media/dvb-frontends/stv0910.c
index 8d72de0ff5b0..16f73c16ac61 100644
--- a/drivers/media/dvb-frontends/stv0910.c
+++ b/drivers/media/dvb-frontends/stv0910.c
@@ -11,7 +11,7 @@
  *
  * This program is distributed in the hope that it will be useful,
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
  * GNU General Public License for more details.
  */
 
diff --git a/drivers/media/dvb-frontends/stv0910.h b/drivers/media/dvb-frontends/stv0910.h
index f37171b7a2de..c3985bee749f 100644
--- a/drivers/media/dvb-frontends/stv0910.h
+++ b/drivers/media/dvb-frontends/stv0910.h
@@ -1,3 +1,20 @@
+/*
+ * Driver for the ST STV0910 DVB-S/S2 demodulator.
+ *
+ * Copyright (C) 2014-2015 Ralph Metzler <rjkm@metzlerbros.de>
+ *                         Marcus Metzler <mocm@metzlerbros.de>
+ *                         developed for Digital Devices GmbH
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 only, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ */
+
 #ifndef _STV0910_H_
 #define _STV0910_H_
 
diff --git a/drivers/media/dvb-frontends/stv0910_regs.h b/drivers/media/dvb-frontends/stv0910_regs.h
index f0eb915090bd..4440892df61f 100644
--- a/drivers/media/dvb-frontends/stv0910_regs.h
+++ b/drivers/media/dvb-frontends/stv0910_regs.h
@@ -1,7 +1,7 @@
 /*
  * @DVB-S/DVB-S2 STMicroelectronics STV0900 register definitions
  * Author Manfred Voelkel, August 2013
- * (c) 2013 Digital Devices GmbH Germany.  All rights reserved
+ * (c) 2013 Digital Devices GmbH Germany. All rights reserved
  *
  * =======================================================================
  * Registers Declaration (Internal ST, All Applications )
-- 
2.16.4
