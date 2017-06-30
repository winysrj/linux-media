Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:34174 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752965AbdF3UvQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 30 Jun 2017 16:51:16 -0400
Received: by mail-wm0-f68.google.com with SMTP id p204so9893312wmg.1
        for <linux-media@vger.kernel.org>; Fri, 30 Jun 2017 13:51:16 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: rjkm@metzlerbros.de, jasmin@anw.at
Subject: [PATCH v2 05/10] [media] dvb-frontends/stv0910: Add missing set_frontend fe-op
Date: Fri, 30 Jun 2017 22:51:01 +0200
Message-Id: <20170630205106.1268-6-d.scheller.oss@gmail.com>
In-Reply-To: <20170630205106.1268-1-d.scheller.oss@gmail.com>
References: <20170630205106.1268-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

This was missing from the frontend_ops.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/dvb-frontends/stv0910.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/dvb-frontends/stv0910.c b/drivers/media/dvb-frontends/stv0910.c
index 045f8f5305ab..1f2d6f5ee58a 100644
--- a/drivers/media/dvb-frontends/stv0910.c
+++ b/drivers/media/dvb-frontends/stv0910.c
@@ -1670,6 +1670,7 @@ static struct dvb_frontend_ops stv0910_ops = {
 	.sleep				= sleep,
 	.release                        = release,
 	.i2c_gate_ctrl                  = gate_ctrl,
+	.set_frontend			= set_parameters,
 	.get_frontend_algo              = get_algo,
 	.get_frontend                   = get_frontend,
 	.tune                           = tune,
-- 
2.13.0
