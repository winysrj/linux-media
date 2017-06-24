Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:34034 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751568AbdFXQDL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 24 Jun 2017 12:03:11 -0400
Received: by mail-wr0-f194.google.com with SMTP id k67so19936700wrc.1
        for <linux-media@vger.kernel.org>; Sat, 24 Jun 2017 09:03:10 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: rjkm@metzlerbros.de, jasmin@anw.at
Subject: [PATCH 5/9] [media] dvb-frontends/stv0910: Add missing set_frontend fe-op
Date: Sat, 24 Jun 2017 18:02:57 +0200
Message-Id: <20170624160301.17710-6-d.scheller.oss@gmail.com>
In-Reply-To: <20170624160301.17710-1-d.scheller.oss@gmail.com>
References: <20170624160301.17710-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

This was missing from the frontend_ops.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/dvb-frontends/stv0910.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/dvb-frontends/stv0910.c b/drivers/media/dvb-frontends/stv0910.c
index c1875be01631..d45c73a88dfb 100644
--- a/drivers/media/dvb-frontends/stv0910.c
+++ b/drivers/media/dvb-frontends/stv0910.c
@@ -1678,6 +1678,7 @@ static struct dvb_frontend_ops stv0910_ops = {
 	.sleep				= sleep,
 	.release                        = release,
 	.i2c_gate_ctrl                  = gate_ctrl,
+	.set_frontend			= set_parameters,
 	.get_frontend_algo              = get_algo,
 	.get_frontend                   = get_frontend,
 	.tune                           = tune,
-- 
2.13.0
