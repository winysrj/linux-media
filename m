Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.12]:61258 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751127AbdH3UWX (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 30 Aug 2017 16:22:23 -0400
Subject: [PATCH 2/4] [media] ds3000: Improve a size determination in
 ds3000_attach()
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Max Kellermann <max.kellermann@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <c854b845-3b79-ca7a-a597-4abc5f32ec54@users.sourceforge.net>
Message-ID: <01634417-dd3f-acc0-f550-11a33e5c2a59@users.sourceforge.net>
Date: Wed, 30 Aug 2017 22:22:17 +0200
MIME-Version: 1.0
In-Reply-To: <c854b845-3b79-ca7a-a597-4abc5f32ec54@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Wed, 30 Aug 2017 21:49:22 +0200

Replace the specification of a data structure by a pointer dereference
as the parameter for the operator "sizeof" to make the corresponding size
determination a bit safer according to the Linux coding style convention.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/dvb-frontends/ds3000.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/ds3000.c b/drivers/media/dvb-frontends/ds3000.c
index c2959a9695a7..988a464de3e9 100644
--- a/drivers/media/dvb-frontends/ds3000.c
+++ b/drivers/media/dvb-frontends/ds3000.c
@@ -839,7 +839,7 @@ struct dvb_frontend *ds3000_attach(const struct ds3000_config *config,
 	dprintk("%s\n", __func__);
 
 	/* allocate memory for the internal state */
-	state = kzalloc(sizeof(struct ds3000_state), GFP_KERNEL);
+	state = kzalloc(sizeof(*state), GFP_KERNEL);
 	if (!state)
 		goto error2;
 
-- 
2.14.1
