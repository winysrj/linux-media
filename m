Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:35270 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755504AbdGCRVT (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 3 Jul 2017 13:21:19 -0400
Received: by mail-wm0-f68.google.com with SMTP id u23so21756991wma.2
        for <linux-media@vger.kernel.org>; Mon, 03 Jul 2017 10:21:18 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: jasmin@anw.at, rjkm@metzlerbros.de
Subject: [PATCH v3 05/10] [media] dvb-frontends/stv0910: Add missing set_frontend fe-op
Date: Mon,  3 Jul 2017 19:20:58 +0200
Message-Id: <20170703172104.27283-6-d.scheller.oss@gmail.com>
In-Reply-To: <20170703172104.27283-1-d.scheller.oss@gmail.com>
References: <20170703172104.27283-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

This was missing from the frontend_ops.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
Tested-by: Richard Scobie <r.scobie@clear.net.nz>
---
 drivers/media/dvb-frontends/stv0910.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/dvb-frontends/stv0910.c b/drivers/media/dvb-frontends/stv0910.c
index dc4d829bb47a..7e8a460449c5 100644
--- a/drivers/media/dvb-frontends/stv0910.c
+++ b/drivers/media/dvb-frontends/stv0910.c
@@ -1668,6 +1668,7 @@ static struct dvb_frontend_ops stv0910_ops = {
 	.sleep				= sleep,
 	.release                        = release,
 	.i2c_gate_ctrl                  = gate_ctrl,
+	.set_frontend			= set_parameters,
 	.get_frontend_algo              = get_algo,
 	.get_frontend                   = get_frontend,
 	.tune                           = tune,
-- 
2.13.0
