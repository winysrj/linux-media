Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.anw.at ([195.234.101.228]:35906 "EHLO mail.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756286AbdEGWE5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 7 May 2017 18:04:57 -0400
From: "Jasmin J." <jasmin@anw.at>
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, max.kellermann@gmail.com,
        rjkm@metzlerbros.de, d.scheller@gmx.net, jasmin@anw.at
Subject: [PATCH 7/7] [staging] cxd2099/cxd2099.c: Activate cxd2099 buffer mode
Date: Sun,  7 May 2017 22:51:53 +0200
Message-Id: <1494190313-18557-8-git-send-email-jasmin@anw.at>
In-Reply-To: <1494190313-18557-1-git-send-email-jasmin@anw.at>
References: <1494190313-18557-1-git-send-email-jasmin@anw.at>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jasmin Jessich <jasmin@anw.at>

Now the cxd2099 buffer mode is activated, but can be deactivated by
setting BUFFER_MODE to 0 at the compiler command line or by editiing
the file.

Signed-off-by: Jasmin Jessich <jasmin@anw.at>
---
 drivers/staging/media/cxd2099/cxd2099.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/media/cxd2099/cxd2099.c b/drivers/staging/media/cxd2099/cxd2099.c
index 64de129..dcad557 100644
--- a/drivers/staging/media/cxd2099/cxd2099.c
+++ b/drivers/staging/media/cxd2099/cxd2099.c
@@ -33,7 +33,9 @@
 
 #include "cxd2099.h"
 
-/* #define BUFFER_MODE 1 */
+#ifndef BUFFER_MODE
+#define BUFFER_MODE 1
+#endif
 
 static int read_data(struct dvb_ca_en50221 *ca, int slot, u8 *ebuf, int ecount);
 
-- 
2.7.4
