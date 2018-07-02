Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx.socionext.com ([202.248.49.38]:13256 "EHLO mx.socionext.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751557AbeGBFL4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 2 Jul 2018 01:11:56 -0400
From: Katsuhiro Suzuki <suzuki.katsuhiro@socionext.com>
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        linux-media@vger.kernel.org
Cc: Sumit Semwal <sumit.semwal@linaro.org>,
        Masami Hiramatsu <masami.hiramatsu@linaro.org>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Katsuhiro Suzuki <suzuki.katsuhiro@socionext.com>
Subject: [RESEND PATCH] media: helene: fix xtal frequency setting at power on
Date: Mon,  2 Jul 2018 14:11:47 +0900
Message-Id: <20180702051147.21858-1-suzuki.katsuhiro@socionext.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch fixes crystal frequency setting when power on this device.

Signed-off-by: Katsuhiro Suzuki <suzuki.katsuhiro@socionext.com>
Acked-by: Abylay Ospan <aospan@netup.ru>

---

Changes from before:
  - Add Abylay's Ack

---
 drivers/media/dvb-frontends/helene.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/helene.c b/drivers/media/dvb-frontends/helene.c
index 0a4f312c4368..8fcf7a00782a 100644
--- a/drivers/media/dvb-frontends/helene.c
+++ b/drivers/media/dvb-frontends/helene.c
@@ -924,7 +924,10 @@ static int helene_x_pon(struct helene_priv *priv)
 	helene_write_regs(priv, 0x99, cdata, sizeof(cdata));
 
 	/* 0x81 - 0x94 */
-	data[0] = 0x18; /* xtal 24 MHz */
+	if (priv->xtal == SONY_HELENE_XTAL_16000)
+		data[0] = 0x10; /* xtal 16 MHz */
+	else
+		data[0] = 0x18; /* xtal 24 MHz */
 	data[1] = (uint8_t)(0x80 | (0x04 & 0x1F)); /* 4 x 25 = 100uA */
 	data[2] = (uint8_t)(0x80 | (0x26 & 0x7F)); /* 38 x 0.25 = 9.5pF */
 	data[3] = 0x80; /* REFOUT signal output 500mVpp */
-- 
2.17.0
