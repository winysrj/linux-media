Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([217.72.192.78]:50677 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751186AbdH3HUW (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 30 Aug 2017 03:20:22 -0400
Subject: [PATCH 2/6] [media] cx24116: Return directly after a failed kmalloc()
 in cx24116_writeregN()
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Max Kellermann <max.kellermann@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <d01b4a11-6e93-bc40-72de-dab9ce7b997a@users.sourceforge.net>
Message-ID: <cf4109fe-9994-470a-88a1-c7a7a030f1e6@users.sourceforge.net>
Date: Wed, 30 Aug 2017 09:20:12 +0200
MIME-Version: 1.0
In-Reply-To: <d01b4a11-6e93-bc40-72de-dab9ce7b997a@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Wed, 30 Aug 2017 07:55:49 +0200

* Return directly after a call of the function "kmalloc" failed
  at the beginning.

* Delete the jump target "error" which became unnecessary
  with this refactoring.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/dvb-frontends/cx24116.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/media/dvb-frontends/cx24116.c b/drivers/media/dvb-frontends/cx24116.c
index 96af4ffba0f9..69c156443b50 100644
--- a/drivers/media/dvb-frontends/cx24116.c
+++ b/drivers/media/dvb-frontends/cx24116.c
@@ -226,10 +226,8 @@ static int cx24116_writeregN(struct cx24116_state *state, int reg,
 	u8 *buf;
 
 	buf = kmalloc(len + 1, GFP_KERNEL);
-	if (buf == NULL) {
-		ret = -ENOMEM;
-		goto error;
-	}
+	if (!buf)
+		return -ENOMEM;
 
 	*(buf) = reg;
 	memcpy(buf + 1, data, len);
@@ -250,7 +248,6 @@ static int cx24116_writeregN(struct cx24116_state *state, int reg,
 		ret = -EREMOTEIO;
 	}
 
-error:
 	kfree(buf);
 
 	return ret;
-- 
2.14.1
