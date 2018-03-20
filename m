Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:43916 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751319AbeCTVBi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 20 Mar 2018 17:01:38 -0400
Received: by mail-wr0-f195.google.com with SMTP id o1so3118070wro.10
        for <linux-media@vger.kernel.org>; Tue, 20 Mar 2018 14:01:37 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: gregkh@linuxfoundation.org, mvoelkel@DigitalDevices.de,
        rjkm@metzlerbros.de, jasmin@anw.at
Subject: [PATCH 1/5] [media] stv0910/stv6111: add SPDX license headers
Date: Tue, 20 Mar 2018 22:01:28 +0100
Message-Id: <20180320210132.7873-2-d.scheller.oss@gmail.com>
In-Reply-To: <20180320210132.7873-1-d.scheller.oss@gmail.com>
References: <20180320210132.7873-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Add SPDX license headers to the stv0910 and stv6111 DVB frontend
drivers. Both drivers are licensed as GPL-2.0-only, so fix this in the
MODULE_LICENSE while at it. Also, the includes were lacking any license
headers at all, so add them now.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/dvb-frontends/stv0910.c | 5 +++--
 drivers/media/dvb-frontends/stv0910.h | 9 +++++++++
 drivers/media/dvb-frontends/stv6111.c | 6 +++---
 drivers/media/dvb-frontends/stv6111.h | 7 +++++++
 4 files changed, 22 insertions(+), 5 deletions(-)

diff --git a/drivers/media/dvb-frontends/stv0910.c b/drivers/media/dvb-frontends/stv0910.c
index 52355c14fd64..ce82264e99ef 100644
--- a/drivers/media/dvb-frontends/stv0910.c
+++ b/drivers/media/dvb-frontends/stv0910.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0-only
 /*
  * Driver for the ST STV0910 DVB-S/S2 demodulator.
  *
@@ -11,7 +12,7 @@
  *
  * This program is distributed in the hope that it will be useful,
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
  * GNU General Public License for more details.
  */
 
@@ -1836,4 +1837,4 @@ EXPORT_SYMBOL_GPL(stv0910_attach);
 
 MODULE_DESCRIPTION("ST STV0910 multistandard frontend driver");
 MODULE_AUTHOR("Ralph and Marcus Metzler, Manfred Voelkel");
-MODULE_LICENSE("GPL");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/media/dvb-frontends/stv0910.h b/drivers/media/dvb-frontends/stv0910.h
index fccd8d9b665f..93de08540ce4 100644
--- a/drivers/media/dvb-frontends/stv0910.h
+++ b/drivers/media/dvb-frontends/stv0910.h
@@ -1,3 +1,12 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Driver for the ST STV0910 DVB-S/S2 demodulator.
+ *
+ * Copyright (C) 2014-2015 Ralph Metzler <rjkm@metzlerbros.de>
+ *                         Marcus Metzler <mocm@metzlerbros.de>
+ *                         developed for Digital Devices GmbH
+ */
+
 #ifndef _STV0910_H_
 #define _STV0910_H_
 
diff --git a/drivers/media/dvb-frontends/stv6111.c b/drivers/media/dvb-frontends/stv6111.c
index 9b715b6fe152..47f4da2e577c 100644
--- a/drivers/media/dvb-frontends/stv6111.c
+++ b/drivers/media/dvb-frontends/stv6111.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0-only
 /*
  * Driver for the ST STV6111 tuner
  *
@@ -9,9 +10,8 @@
  *
  * This program is distributed in the hope that it will be useful,
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
  * GNU General Public License for more details.
- *
  */
 
 #include <linux/kernel.h>
@@ -688,4 +688,4 @@ EXPORT_SYMBOL_GPL(stv6111_attach);
 
 MODULE_DESCRIPTION("ST STV6111 satellite tuner driver");
 MODULE_AUTHOR("Ralph Metzler, Manfred Voelkel");
-MODULE_LICENSE("GPL");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/media/dvb-frontends/stv6111.h b/drivers/media/dvb-frontends/stv6111.h
index 5bc1228dc9bd..d2552040eddd 100644
--- a/drivers/media/dvb-frontends/stv6111.h
+++ b/drivers/media/dvb-frontends/stv6111.h
@@ -1,3 +1,10 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Driver for the ST STV6111 tuner
+ *
+ * Copyright (C) 2014 Digital Devices GmbH
+ */
+
 #ifndef _STV6111_H_
 #define _STV6111_H_
 
-- 
2.16.1
