Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:59797 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754159AbaDKU2U (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Apr 2014 16:28:20 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH] fc2580: fix tuning failure on 32-bit arch
Date: Fri, 11 Apr 2014 23:27:48 +0300
Message-Id: <1397248068-4806-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There was some frequency calculation overflows which caused tuning
failure on 32-bit architecture. Use 64-bit numbers where needed in
order to avoid calculation overflows.

Thanks for the Finnish person, who asked remain anonymous, reporting,
testing and suggesting the fix.

Cc: <stable@vger.kernel.org>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/tuners/fc2580.c      | 6 +++---
 drivers/media/tuners/fc2580_priv.h | 1 +
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/media/tuners/fc2580.c b/drivers/media/tuners/fc2580.c
index 3aecaf4..f0c9c42 100644
--- a/drivers/media/tuners/fc2580.c
+++ b/drivers/media/tuners/fc2580.c
@@ -195,7 +195,7 @@ static int fc2580_set_params(struct dvb_frontend *fe)
 
 	f_ref = 2UL * priv->cfg->clock / r_val;
 	n_val = div_u64_rem(f_vco, f_ref, &k_val);
-	k_val_reg = 1UL * k_val * (1 << 20) / f_ref;
+	k_val_reg = div_u64(1ULL * k_val * (1 << 20), f_ref);
 
 	ret = fc2580_wr_reg(priv, 0x18, r18_val | ((k_val_reg >> 16) & 0xff));
 	if (ret < 0)
@@ -348,8 +348,8 @@ static int fc2580_set_params(struct dvb_frontend *fe)
 	if (ret < 0)
 		goto err;
 
-	ret = fc2580_wr_reg(priv, 0x37, 1UL * priv->cfg->clock * \
-			fc2580_if_filter_lut[i].mul / 1000000000);
+	ret = fc2580_wr_reg(priv, 0x37, div_u64(1ULL * priv->cfg->clock *
+			fc2580_if_filter_lut[i].mul, 1000000000));
 	if (ret < 0)
 		goto err;
 
diff --git a/drivers/media/tuners/fc2580_priv.h b/drivers/media/tuners/fc2580_priv.h
index be38a9e..646c994 100644
--- a/drivers/media/tuners/fc2580_priv.h
+++ b/drivers/media/tuners/fc2580_priv.h
@@ -22,6 +22,7 @@
 #define FC2580_PRIV_H
 
 #include "fc2580.h"
+#include <linux/math64.h>
 
 struct fc2580_reg_val {
 	u8 reg;
-- 
1.9.0

