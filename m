Return-path: <linux-media-owner@vger.kernel.org>
Received: from srv-hp10-72.netsons.net ([94.141.22.72]:35249 "EHLO
        srv-hp10-72.netsons.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752598AbeDLQvd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 12 Apr 2018 12:51:33 -0400
From: Luca Ceresoli <luca@lucaceresoli.net>
To: linux-media@vger.kernel.org
Cc: Luca Ceresoli <luca@lucaceresoli.net>,
        Leon Luo <leonl@leopardimaging.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 01/13] imx274: document reset delays more clearly
Date: Thu, 12 Apr 2018 18:51:06 +0200
Message-Id: <1523551878-15754-2-git-send-email-luca@lucaceresoli.net>
In-Reply-To: <1523551878-15754-1-git-send-email-luca@lucaceresoli.net>
References: <1523551878-15754-1-git-send-email-luca@lucaceresoli.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Document the unit to avoid having to look through the code to compute it.
Also clarify that these are min and max values.

Signed-off-by: Luca Ceresoli <luca@lucaceresoli.net>
---
 drivers/media/i2c/imx274.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/imx274.c b/drivers/media/i2c/imx274.c
index daec33f4196a..5e425db9204d 100644
--- a/drivers/media/i2c/imx274.c
+++ b/drivers/media/i2c/imx274.c
@@ -87,7 +87,7 @@
 #define IMX274_SHR_LIMIT_CONST			(4)
 
 /*
- * Constants for sensor reset delay
+ * Min and max sensor reset delay (microseconds)
  */
 #define IMX274_RESET_DELAY1			(2000)
 #define IMX274_RESET_DELAY2			(2200)
-- 
2.7.4
