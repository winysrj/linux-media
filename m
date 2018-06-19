Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:56014 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1030465AbeFSSu1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Jun 2018 14:50:27 -0400
Received: by mail-wm0-f65.google.com with SMTP id v16-v6so1998155wmh.5
        for <linux-media@vger.kernel.org>; Tue, 19 Jun 2018 11:50:27 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: mchehab@kernel.org, mchehab@s-opensource.com, rjkm@metzlerbros.de,
        mvoelkel@DigitalDevices.de
Cc: linux-media@vger.kernel.org
Subject: [PATCH v3 8/9] [media] dvb-frontends/stv6111: cleanup and fix licensing boilerplates
Date: Tue, 19 Jun 2018 20:50:15 +0200
Message-Id: <20180619185016.24402-9-d.scheller.oss@gmail.com>
In-Reply-To: <20180619185016.24402-1-d.scheller.oss@gmail.com>
References: <20180619185016.24402-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

The stv6111.h doesn't carry any header nor any licensing boilerplate at
all, so copy this from the main driver file stv6111.c. While at it,
apply the usual whitespace/blank line cleanup.

Cc: Ralph Metzler <rjkm@metzlerbros.de>
Cc: Manfred Voelkel <mvoelkel@DigitalDevices.de>
Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/dvb-frontends/stv6111.c |  3 +--
 drivers/media/dvb-frontends/stv6111.h | 15 +++++++++++++++
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb-frontends/stv6111.c b/drivers/media/dvb-frontends/stv6111.c
index 25208a120cb7..88c0cf4c5011 100644
--- a/drivers/media/dvb-frontends/stv6111.c
+++ b/drivers/media/dvb-frontends/stv6111.c
@@ -9,9 +9,8 @@
  *
  * This program is distributed in the hope that it will be useful,
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
  * GNU General Public License for more details.
- *
  */
 
 #include <linux/kernel.h>
diff --git a/drivers/media/dvb-frontends/stv6111.h b/drivers/media/dvb-frontends/stv6111.h
index 5bc1228dc9bd..809e62361a91 100644
--- a/drivers/media/dvb-frontends/stv6111.h
+++ b/drivers/media/dvb-frontends/stv6111.h
@@ -1,3 +1,18 @@
+/*
+ * Driver for the ST STV6111 tuner
+ *
+ * Copyright (C) 2014 Digital Devices GmbH
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
 #ifndef _STV6111_H_
 #define _STV6111_H_
 
-- 
2.16.4
