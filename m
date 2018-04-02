Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:34514 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753224AbeDBSYt (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 2 Apr 2018 14:24:49 -0400
Received: by mail-wm0-f68.google.com with SMTP id w2so7412192wmw.1
        for <linux-media@vger.kernel.org>; Mon, 02 Apr 2018 11:24:48 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Subject: [PATCH 20/20] [media] ddbridge: set driver version to 0.9.33-integrated
Date: Mon,  2 Apr 2018 20:24:27 +0200
Message-Id: <20180402182427.20918-21-d.scheller.oss@gmail.com>
In-Reply-To: <20180402182427.20918-1-d.scheller.oss@gmail.com>
References: <20180402182427.20918-1-d.scheller.oss@gmail.com>
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
