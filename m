Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.anw.at ([195.234.101.228]:44752 "EHLO mail.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751355AbdFYVhY (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 25 Jun 2017 17:37:24 -0400
From: "Jasmin J." <jasmin@anw.at>
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, max.kellermann@gmail.com,
        rjkm@metzlerbros.de, d.scheller@gmx.net, jasmin@anw.at
Subject: [PATCH v2 7/7] [staging] cxd2099/cxd2099.c: Activate cxd2099 buffer mode
Date: Sun, 25 Jun 2017 23:37:11 +0200
Message-Id: <1498426631-17376-8-git-send-email-jasmin@anw.at>
In-Reply-To: <1498426631-17376-1-git-send-email-jasmin@anw.at>
References: <1498426631-17376-1-git-send-email-jasmin@anw.at>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jasmin Jessich <jasmin@anw.at>

Activate the cxd2099 buffer mode.

Signed-off-by: Jasmin Jessich <jasmin@anw.at>
---
 drivers/staging/media/cxd2099/cxd2099.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/media/cxd2099/cxd2099.c b/drivers/staging/media/cxd2099/cxd2099.c
index 3431cf6..f28916e 100644
--- a/drivers/staging/media/cxd2099/cxd2099.c
+++ b/drivers/staging/media/cxd2099/cxd2099.c
@@ -33,7 +33,8 @@
 
 #include "cxd2099.h"
 
-/* #define BUFFER_MODE 1 */
+/* comment this line to deactivate the cxd2099ar buffer mode */
+#define BUFFER_MODE 1
 
 static int read_data(struct dvb_ca_en50221 *ca, int slot, u8 *ebuf, int ecount);
 
-- 
2.7.4
