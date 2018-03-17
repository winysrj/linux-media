Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:43356 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752676AbeCQOzh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 17 Mar 2018 10:55:37 -0400
Received: by mail-wr0-f193.google.com with SMTP id o1so14329030wro.10
        for <linux-media@vger.kernel.org>; Sat, 17 Mar 2018 07:55:36 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: Jasmin Jessich <jasmin@anw.at>
Subject: [PATCH] [media] ddbridge, cxd2099: include guard, fix unneeded NULL init, strings
Date: Sat, 17 Mar 2018 15:55:32 +0100
Message-Id: <20180317145532.23202-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Three really tiny minors in this single commit which all on their own
would just clutter up the commit history unnecessarily:

* ddbridge-regs.h is lacking an include guard. Add it.
* Fix an unnecessary NULL initialisation in ddbridge-ci. The declaration
  of the ci struct ptr is immediately followed by kzalloc().
* Clarify that the CXD2099AR is a Sony device in the cxd2099 driver at a
  few places including Kconfig.

Cc Jasmin for the cxd2099 changes.

Cc: Jasmin Jessich <jasmin@anw.at>
Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
Please pull for the 4.17 merge window.

 drivers/media/dvb-frontends/Kconfig        | 2 +-
 drivers/media/dvb-frontends/cxd2099.c      | 4 ++--
 drivers/media/dvb-frontends/cxd2099.h      | 2 +-
 drivers/media/pci/ddbridge/ddbridge-ci.c   | 2 +-
 drivers/media/pci/ddbridge/ddbridge-regs.h | 4 ++++
 5 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/media/dvb-frontends/Kconfig b/drivers/media/dvb-frontends/Kconfig
index 687086cdb870..fda645cbe68e 100644
--- a/drivers/media/dvb-frontends/Kconfig
+++ b/drivers/media/dvb-frontends/Kconfig
@@ -903,7 +903,7 @@ comment "Common Interface (EN50221) controller drivers"
 	depends on DVB_CORE
 
 config DVB_CXD2099
-	tristate "CXD2099AR Common Interface driver"
+	tristate "Sony CXD2099AR Common Interface driver"
 	depends on DVB_CORE && I2C
 	select REGMAP_I2C
 	default m if !MEDIA_SUBDRV_AUTOSELECT
diff --git a/drivers/media/dvb-frontends/cxd2099.c b/drivers/media/dvb-frontends/cxd2099.c
index c0a5849b76bb..4a0ce3037fd6 100644
--- a/drivers/media/dvb-frontends/cxd2099.c
+++ b/drivers/media/dvb-frontends/cxd2099.c
@@ -1,5 +1,5 @@
 /*
- * cxd2099.c: Driver for the CXD2099AR Common Interface Controller
+ * cxd2099.c: Driver for the Sony CXD2099AR Common Interface Controller
  *
  * Copyright (C) 2010-2013 Digital Devices GmbH
  *
@@ -699,6 +699,6 @@ static struct i2c_driver cxd2099_driver = {
 
 module_i2c_driver(cxd2099_driver);
 
-MODULE_DESCRIPTION("CXD2099AR Common Interface controller driver");
+MODULE_DESCRIPTION("Sony CXD2099AR Common Interface controller driver");
 MODULE_AUTHOR("Ralph Metzler");
 MODULE_LICENSE("GPL");
diff --git a/drivers/media/dvb-frontends/cxd2099.h b/drivers/media/dvb-frontends/cxd2099.h
index 8fa45a4c615a..ec1910dec3f3 100644
--- a/drivers/media/dvb-frontends/cxd2099.h
+++ b/drivers/media/dvb-frontends/cxd2099.h
@@ -1,5 +1,5 @@
 /*
- * cxd2099.h: Driver for the CXD2099AR Common Interface Controller
+ * cxd2099.h: Driver for the Sony CXD2099AR Common Interface Controller
  *
  * Copyright (C) 2010-2011 Digital Devices GmbH
  *
diff --git a/drivers/media/pci/ddbridge/ddbridge-ci.c b/drivers/media/pci/ddbridge/ddbridge-ci.c
index a9dbc4ebf94f..cfe23d02e561 100644
--- a/drivers/media/pci/ddbridge/ddbridge-ci.c
+++ b/drivers/media/pci/ddbridge/ddbridge-ci.c
@@ -164,7 +164,7 @@ static struct dvb_ca_en50221 en_templ = {
 
 static void ci_attach(struct ddb_port *port)
 {
-	struct ddb_ci *ci = NULL;
+	struct ddb_ci *ci;
 
 	ci = kzalloc(sizeof(*ci), GFP_KERNEL);
 	if (!ci)
diff --git a/drivers/media/pci/ddbridge/ddbridge-regs.h b/drivers/media/pci/ddbridge/ddbridge-regs.h
index 23d74ff83fe4..b978b5991940 100644
--- a/drivers/media/pci/ddbridge/ddbridge-regs.h
+++ b/drivers/media/pci/ddbridge/ddbridge-regs.h
@@ -17,6 +17,9 @@
  * http://www.gnu.org/copyleft/gpl.html
  */
 
+#ifndef __DDBRIDGE_REGS_H__
+#define __DDBRIDGE_REGS_H__
+
 /* ------------------------------------------------------------------------- */
 /* SPI Controller */
 
@@ -154,3 +157,4 @@
 #define LNB_BUF_LEVEL(i)		(LNB_BASE + (i) * 0x20 + 0x10)
 #define LNB_BUF_WRITE(i)		(LNB_BASE + (i) * 0x20 + 0x14)
 
+#endif /* __DDBRIDGE_REGS_H__ */
-- 
2.16.1
