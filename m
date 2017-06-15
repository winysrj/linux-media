Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway34.websitewelcome.com ([192.185.149.222]:32954 "EHLO
        gateway34.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752226AbdFOVIJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Jun 2017 17:08:09 -0400
Received: from cm15.websitewelcome.com (cm15.websitewelcome.com [100.42.49.9])
        by gateway34.websitewelcome.com (Postfix) with ESMTP id 44F5817E2F5
        for <linux-media@vger.kernel.org>; Thu, 15 Jun 2017 15:42:46 -0500 (CDT)
Date: Thu, 15 Jun 2017 15:42:44 -0500
From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
To: Antti Palosaari <crope@iki.fi>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Subject: [PATCH] af9013: add check on af9013_wr_regs() return value
Message-ID: <20170615204244.GA9150@embeddedgus>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Check return value from call to af9013_wr_regs(), so in case of
error print debug message and return.

Addresses-Coverity-ID: 1227035
Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
---
 drivers/media/dvb-frontends/af9013.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/dvb-frontends/af9013.c b/drivers/media/dvb-frontends/af9013.c
index 51f942f..dc7ccda 100644
--- a/drivers/media/dvb-frontends/af9013.c
+++ b/drivers/media/dvb-frontends/af9013.c
@@ -608,6 +608,8 @@ static int af9013_set_frontend(struct dvb_frontend *fe)
 
 		ret = af9013_wr_regs(state, 0xae00, coeff_lut[i].val,
 			sizeof(coeff_lut[i].val));
+		if (ret)
+			goto err;
 	}
 
 	/* program frequency control */
-- 
2.5.0
