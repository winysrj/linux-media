Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.12]:52450 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750758AbdH3UVT (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 30 Aug 2017 16:21:19 -0400
Subject: [PATCH 1/4] [media] ds3000: Delete an error message for a failed
 memory allocation in two functions
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Max Kellermann <max.kellermann@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <c854b845-3b79-ca7a-a597-4abc5f32ec54@users.sourceforge.net>
Message-ID: <3f061ac7-4738-ec12-3f4b-dca8c2b6eba5@users.sourceforge.net>
Date: Wed, 30 Aug 2017 22:21:13 +0200
MIME-Version: 1.0
In-Reply-To: <c854b845-3b79-ca7a-a597-4abc5f32ec54@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Wed, 30 Aug 2017 21:41:28 +0200

Omit an extra message for a memory allocation failure in these functions.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/dvb-frontends/ds3000.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/media/dvb-frontends/ds3000.c b/drivers/media/dvb-frontends/ds3000.c
index 0b17a45c5640..c2959a9695a7 100644
--- a/drivers/media/dvb-frontends/ds3000.c
+++ b/drivers/media/dvb-frontends/ds3000.c
@@ -280,7 +280,5 @@ static int ds3000_writeFW(struct ds3000_state *state, int reg,
-	if (buf == NULL) {
-		printk(KERN_ERR "Unable to kmalloc\n");
+	if (!buf)
 		return -ENOMEM;
-	}
 
 	*(buf) = reg;
 
@@ -845,7 +843,5 @@ struct dvb_frontend *ds3000_attach(const struct ds3000_config *config,
-	if (state == NULL) {
-		printk(KERN_ERR "Unable to kmalloc\n");
+	if (!state)
 		goto error2;
-	}
 
 	state->config = config;
 	state->i2c = i2c;
-- 
2.14.1
