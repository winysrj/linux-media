Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:45756 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753443AbeDIQsN (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 9 Apr 2018 12:48:13 -0400
Received: by mail-wr0-f193.google.com with SMTP id u11so10256278wri.12
        for <linux-media@vger.kernel.org>; Mon, 09 Apr 2018 09:48:13 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Subject: [PATCH v2 19/19] [media] ddbridge: set driver version to 0.9.33-integrated
Date: Mon,  9 Apr 2018 18:47:52 +0200
Message-Id: <20180409164752.641-20-d.scheller.oss@gmail.com>
In-Reply-To: <20180409164752.641-1-d.scheller.oss@gmail.com>
References: <20180409164752.641-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Set DDBRIDGE_VERSION in ddbridge.h to 0.9.33-integrated to reflect the
updated driver.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/pci/ddbridge/ddbridge.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/ddbridge/ddbridge.h b/drivers/media/pci/ddbridge/ddbridge.h
index 72fe33cb72b9..a66b1125cc74 100644
--- a/drivers/media/pci/ddbridge/ddbridge.h
+++ b/drivers/media/pci/ddbridge/ddbridge.h
@@ -63,7 +63,7 @@
 #include <media/dvb_ca_en50221.h>
 #include <media/dvb_net.h>
 
-#define DDBRIDGE_VERSION "0.9.32-integrated"
+#define DDBRIDGE_VERSION "0.9.33-integrated"
 
 #define DDB_MAX_I2C    32
 #define DDB_MAX_PORT   32
-- 
2.16.1
