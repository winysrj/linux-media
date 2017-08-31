Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([217.72.192.78]:57538 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751283AbdHaT6A (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 31 Aug 2017 15:58:00 -0400
Subject: [PATCH 2/3] [media] mb86a20s: Improve a size determination in
 mb86a20s_attach()
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Max Kellermann <max.kellermann@gmail.com>,
        Nicolas Iooss <nicolas.iooss_linux@m4x.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <9571ee6c-5137-15f4-4cdb-9f03b5cb9268@users.sourceforge.net>
Message-ID: <5b72d4ab-0bcb-27ab-6240-18d251f49e6c@users.sourceforge.net>
Date: Thu, 31 Aug 2017 21:57:53 +0200
MIME-Version: 1.0
In-Reply-To: <9571ee6c-5137-15f4-4cdb-9f03b5cb9268@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Thu, 31 Aug 2017 21:13:26 +0200

Replace the specification of a data structure by a pointer dereference
as the parameter for the operator "sizeof" to make the corresponding size
determination a bit safer according to the Linux coding style convention.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/dvb-frontends/mb86a20s.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/mb86a20s.c b/drivers/media/dvb-frontends/mb86a20s.c
index 340984100aec..ba7a433dd424 100644
--- a/drivers/media/dvb-frontends/mb86a20s.c
+++ b/drivers/media/dvb-frontends/mb86a20s.c
@@ -2071,7 +2071,7 @@ struct dvb_frontend *mb86a20s_attach(const struct mb86a20s_config *config,
 	dev_dbg(&i2c->dev, "%s called.\n", __func__);
 
 	/* allocate memory for the internal state */
-	state = kzalloc(sizeof(struct mb86a20s_state), GFP_KERNEL);
+	state = kzalloc(sizeof(*state), GFP_KERNEL);
 	if (!state)
 		goto error;
 
-- 
2.14.1
