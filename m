Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:37307 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751479AbdJOUwI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 15 Oct 2017 16:52:08 -0400
Received: by mail-wm0-f67.google.com with SMTP id r68so6159691wmr.4
        for <linux-media@vger.kernel.org>; Sun, 15 Oct 2017 13:52:07 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: jasmin@anw.at, rjkm@metzlerbros.de
Subject: [PATCH 8/8] [media] ddbridge: update driver version number
Date: Sun, 15 Oct 2017 22:51:57 +0200
Message-Id: <20171015205157.14342-9-d.scheller.oss@gmail.com>
In-Reply-To: <20171015205157.14342-1-d.scheller.oss@gmail.com>
References: <20171015205157.14342-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Update the driver version number/string to 0.9.32-integrated.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/pci/ddbridge/ddbridge.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/ddbridge/ddbridge.h b/drivers/media/pci/ddbridge/ddbridge.h
index e8432e49564c..70ac9e576c74 100644
--- a/drivers/media/pci/ddbridge/ddbridge.h
+++ b/drivers/media/pci/ddbridge/ddbridge.h
@@ -63,7 +63,7 @@
 #include "dvb_ca_en50221.h"
 #include "dvb_net.h"
 
-#define DDBRIDGE_VERSION "0.9.31intermediate-integrated"
+#define DDBRIDGE_VERSION "0.9.32-integrated"
 
 #define DDB_MAX_I2C    32
 #define DDB_MAX_PORT   32
-- 
2.13.6
