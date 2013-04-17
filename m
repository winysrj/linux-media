Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38718 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754659Ab3DQAmu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Apr 2013 20:42:50 -0400
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r3H0gnVw024253
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 16 Apr 2013 20:42:49 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH v2 12/31] [media] r820t: Invert bits for read ops
Date: Tue, 16 Apr 2013 21:42:23 -0300
Message-Id: <1366159362-3773-13-git-send-email-mchehab@redhat.com>
In-Reply-To: <1366159362-3773-1-git-send-email-mchehab@redhat.com>
References: <1366159362-3773-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On read, the bit order is inverted.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/tuners/r820t.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/media/tuners/r820t.c b/drivers/media/tuners/r820t.c
index 48ff6bb..79ab2b7 100644
--- a/drivers/media/tuners/r820t.c
+++ b/drivers/media/tuners/r820t.c
@@ -35,8 +35,10 @@
 #include <linux/videodev2.h>
 #include <linux/mutex.h>
 #include <linux/slab.h>
-#include "tuner-i2c.h"
+#include <linux/bitrev.h>
 #include <asm/div64.h>
+
+#include "tuner-i2c.h"
 #include "r820t.h"
 
 /*
@@ -414,7 +416,7 @@ static int r820t_write_reg_mask(struct r820t_priv *priv, u8 reg, u8 val,
 
 static int r820_read(struct r820t_priv *priv, u8 reg, u8 *val, int len)
 {
-	int rc;
+	int rc, i;
 	u8 *p = &priv->buf[1];
 
 	priv->buf[0] = reg;
@@ -431,7 +433,8 @@ static int r820_read(struct r820t_priv *priv, u8 reg, u8 *val, int len)
 		  __func__, reg, len, len, p);
 
 	/* Copy data to the output buffer */
-	memcpy(val, p, len);
+	for (i = 0; i < len; i++)
+		val[i] = bitrev8(p[i]);
 
 	return 0;
 }
-- 
1.8.1.4

