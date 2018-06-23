Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:42475 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751458AbeFWPgZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 23 Jun 2018 11:36:25 -0400
Received: by mail-wr0-f196.google.com with SMTP id w10-v6so9413619wrk.9
        for <linux-media@vger.kernel.org>; Sat, 23 Jun 2018 08:36:24 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: mchehab@kernel.org, mchehab@s-opensource.com
Cc: linux-media@vger.kernel.org
Subject: [PATCH 06/19] [media] ddbridge: remove unused MDIO defines and hwinfo member
Date: Sat, 23 Jun 2018 17:36:02 +0200
Message-Id: <20180623153615.27630-7-d.scheller.oss@gmail.com>
In-Reply-To: <20180623153615.27630-1-d.scheller.oss@gmail.com>
References: <20180623153615.27630-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

ddbridge has a few MDIO related remainders (defines, hwinfo struct) which
aren't of any use for the in-kernel driver at all (they're only used in
conjunction with the OctoNet SAT>IP boxes which the kernel driver doesn't
have any support for), so clean this up.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/pci/ddbridge/ddbridge-regs.h | 8 --------
 drivers/media/pci/ddbridge/ddbridge.h      | 1 -
 2 files changed, 9 deletions(-)

diff --git a/drivers/media/pci/ddbridge/ddbridge-regs.h b/drivers/media/pci/ddbridge/ddbridge-regs.h
index b978b5991940..f9e1cbb99b53 100644
--- a/drivers/media/pci/ddbridge/ddbridge-regs.h
+++ b/drivers/media/pci/ddbridge/ddbridge-regs.h
@@ -33,14 +33,6 @@
 #define GPIO_INPUT       0x24
 #define GPIO_DIRECTION   0x28
 
-/* ------------------------------------------------------------------------- */
-/* MDIO */
-
-#define MDIO_CTRL        0x20
-#define MDIO_ADR         0x24
-#define MDIO_REG         0x28
-#define MDIO_VAL         0x2C
-
 /* ------------------------------------------------------------------------- */
 
 #define BOARD_CONTROL    0x30
diff --git a/drivers/media/pci/ddbridge/ddbridge.h b/drivers/media/pci/ddbridge/ddbridge.h
index a66b1125cc74..9c645bee428a 100644
--- a/drivers/media/pci/ddbridge/ddbridge.h
+++ b/drivers/media/pci/ddbridge/ddbridge.h
@@ -127,7 +127,6 @@ struct ddb_info {
 	u8    temp_bus;
 	u32   board_control;
 	u32   board_control_2;
-	u8    mdio_num;
 	u8    con_clock; /* use a continuous clock */
 	u8    ts_quirks;
 #define TS_QUIRK_SERIAL   1
-- 
2.16.4
