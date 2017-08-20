Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:35366 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752533AbdHTKlW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 20 Aug 2017 06:41:22 -0400
Received: by mail-wr0-f194.google.com with SMTP id p8so10242164wrf.2
        for <linux-media@vger.kernel.org>; Sun, 20 Aug 2017 03:41:22 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: jasmin@anw.at, rjkm@metzlerbros.de
Subject: [PATCH 6/6] [media] ddbridge: bump version string to 0.9.31intermediate-integrated
Date: Sun, 20 Aug 2017 12:41:14 +0200
Message-Id: <20170820104114.6515-7-d.scheller.oss@gmail.com>
In-Reply-To: <20170820104114.6515-1-d.scheller.oss@gmail.com>
References: <20170820104114.6515-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/pci/ddbridge/ddbridge.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/ddbridge/ddbridge.h b/drivers/media/pci/ddbridge/ddbridge.h
index c1a1edfe15aa..e9afa96bd9df 100644
--- a/drivers/media/pci/ddbridge/ddbridge.h
+++ b/drivers/media/pci/ddbridge/ddbridge.h
@@ -63,7 +63,7 @@
 #include "dvb_ca_en50221.h"
 #include "dvb_net.h"
 
-#define DDBRIDGE_VERSION "0.9.29-integrated"
+#define DDBRIDGE_VERSION "0.9.31intermediate-integrated"
 
 #define DDB_MAX_I2C    32
 #define DDB_MAX_PORT   32
-- 
2.13.0
