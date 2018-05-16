Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx.socionext.com ([202.248.49.38]:8654 "EHLO mx.socionext.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752574AbeEPIlN (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 May 2018 04:41:13 -0400
From: Katsuhiro Suzuki <suzuki.katsuhiro@socionext.com>
To: Abylay Ospan <aospan@netup.ru>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Cc: Masami Hiramatsu <masami.hiramatsu@linaro.org>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Katsuhiro Suzuki <suzuki.katsuhiro@socionext.com>
Subject: [PATCH] media: helene: fix tuning frequency of satellite
Date: Wed, 16 May 2018 17:41:11 +0900
Message-Id: <20180516084111.28618-1-suzuki.katsuhiro@socionext.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch fixes tuning frequency of satellite to kHz. That as same
as terrestrial one.

Signed-off-by: Katsuhiro Suzuki <suzuki.katsuhiro@socionext.com>
---
 drivers/media/dvb-frontends/helene.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/helene.c b/drivers/media/dvb-frontends/helene.c
index 04033f0c278b..0a4f312c4368 100644
--- a/drivers/media/dvb-frontends/helene.c
+++ b/drivers/media/dvb-frontends/helene.c
@@ -523,7 +523,7 @@ static int helene_set_params_s(struct dvb_frontend *fe)
 	enum helene_tv_system_t tv_system;
 	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct helene_priv *priv = fe->tuner_priv;
-	int frequencykHz = p->frequency;
+	int frequencykHz = p->frequency / 1000;
 	uint32_t frequency4kHz = 0;
 	u32 symbol_rate = p->symbol_rate/1000;
 
-- 
2.17.0
