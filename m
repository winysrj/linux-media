Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:41695 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751455AbeCTVBk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 20 Mar 2018 17:01:40 -0400
Received: by mail-wr0-f196.google.com with SMTP id f14so3135217wre.8
        for <linux-media@vger.kernel.org>; Tue, 20 Mar 2018 14:01:40 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: gregkh@linuxfoundation.org, mvoelkel@DigitalDevices.de,
        rjkm@metzlerbros.de, jasmin@anw.at
Subject: [PATCH 3/5] [media] dvb-frontends/cxd2099: add SPDX license headers
Date: Tue, 20 Mar 2018 22:01:30 +0100
Message-Id: <20180320210132.7873-4-d.scheller.oss@gmail.com>
In-Reply-To: <20180320210132.7873-1-d.scheller.oss@gmail.com>
References: <20180320210132.7873-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Add SPDX license headers in the cxd2099 driver files and fix MODULE_LICENSE
accordingly.

Cc: Jasmin Jessich <jasmin@anw.at>
Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/dvb-frontends/cxd2099.c | 5 +++--
 drivers/media/dvb-frontends/cxd2099.h | 3 ++-
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/media/dvb-frontends/cxd2099.c b/drivers/media/dvb-frontends/cxd2099.c
index 4a0ce3037fd6..6b5f7fdde77b 100644
--- a/drivers/media/dvb-frontends/cxd2099.c
+++ b/drivers/media/dvb-frontends/cxd2099.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0-only
 /*
  * cxd2099.c: Driver for the Sony CXD2099AR Common Interface Controller
  *
@@ -9,7 +10,7 @@
  *
  * This program is distributed in the hope that it will be useful,
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
  * GNU General Public License for more details.
  */
 
@@ -701,4 +702,4 @@ module_i2c_driver(cxd2099_driver);
 
 MODULE_DESCRIPTION("Sony CXD2099AR Common Interface controller driver");
 MODULE_AUTHOR("Ralph Metzler");
-MODULE_LICENSE("GPL");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/media/dvb-frontends/cxd2099.h b/drivers/media/dvb-frontends/cxd2099.h
index ec1910dec3f3..094bf4ffe2a8 100644
--- a/drivers/media/dvb-frontends/cxd2099.h
+++ b/drivers/media/dvb-frontends/cxd2099.h
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
 /*
  * cxd2099.h: Driver for the Sony CXD2099AR Common Interface Controller
  *
@@ -9,7 +10,7 @@
  *
  * This program is distributed in the hope that it will be useful,
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
  * GNU General Public License for more details.
  */
 
-- 
2.16.1
