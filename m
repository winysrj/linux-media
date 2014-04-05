Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:33699 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753576AbaDEUYD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 5 Apr 2014 16:24:03 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 1/4] msi001: fix possible integer overflow
Date: Sat,  5 Apr 2014 23:23:41 +0300
Message-Id: <1396729424-17576-2-git-send-email-crope@iki.fi>
In-Reply-To: <1396729424-17576-1-git-send-email-crope@iki.fi>
References: <1396729424-17576-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Coverity CID 1196502: Unintentional integer overflow
(OVERFLOW_BEFORE_WIDEN)

Potentially overflowing expression "(f_rf + f_if + f_if1) * lo_div"
with type "unsigned int" (32 bits, unsigned) is evaluated using 32-bit
arithmetic before being used in a context which expects an expression
of type "u64" (64 bits, unsigned). To avoid overflow, cast either
operand to "u64" before performing the multiplication.

Reported-by: <scan-admin@coverity.com>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/staging/media/msi3101/msi001.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/msi3101/msi001.c b/drivers/staging/media/msi3101/msi001.c
index ac43bae..bd0b93c 100644
--- a/drivers/staging/media/msi3101/msi001.c
+++ b/drivers/staging/media/msi3101/msi001.c
@@ -201,7 +201,7 @@ static int msi001_set_tuner(struct msi001 *s)
 	dev_dbg(&s->spi->dev, "%s: bandwidth selected=%d\n",
 			__func__, bandwidth_lut[i].freq);
 
-	f_vco = (f_rf + f_if + f_if1) * lo_div;
+	f_vco = (u64) (f_rf + f_if + f_if1) * lo_div;
 	tmp64 = f_vco;
 	m = do_div(tmp64, F_REF * R_REF);
 	n = (unsigned int) tmp64;
-- 
1.9.0

