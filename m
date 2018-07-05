Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:50684 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753806AbeGEW7n (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 5 Jul 2018 18:59:43 -0400
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Shuah Khan <shuah@kernel.org>,
        Jaedon Shin <jaedon.shin@gmail.com>,
        Colin Ian King <colin.king@canonical.com>,
        Satendra Singh Thakur <satendra.t@samsung.com>
Subject: [PATCH v2 3/3] dvb_frontend: ensure that the step is ok for both FE and tuner
Date: Thu,  5 Jul 2018 19:59:37 -0300
Message-Id: <e6f3449586d22b3f0d88258a6ca323134d37fbfd.1530830503.git.mchehab+samsung@kernel.org>
In-Reply-To: <cover.1530830503.git.mchehab+samsung@kernel.org>
References: <cover.1530830503.git.mchehab+samsung@kernel.org>
In-Reply-To: <cover.1530830503.git.mchehab+samsung@kernel.org>
References: <cover.1530830503.git.mchehab+samsung@kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The frequency step should take into account the tuner step,
as, if tuner step is bigger than frontend step, the zigzag
algorithm won't be doing the right thing, as it will be
tuning multiple times at the same frequency.

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 drivers/media/dvb-core/dvb_frontend.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index 3b9dca7d7d02..67198de8a1ba 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -939,7 +939,10 @@ static void dvb_frontend_get_frequency_limits(struct dvb_frontend *fe,
 static u32 dvb_frontend_get_stepsize(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
-	u32 step = fe->ops.info.frequency_stepsize_hz;
+	u32 fe_step = fe->ops.info.frequency_stepsize_hz;
+	u32 tuner_step = fe->ops.tuner_ops.info.frequency_step_hz;
+	u32 step = max(fe_step, tuner_step);
+
 	switch (c->delivery_system) {
 	case SYS_DVBS:
 	case SYS_DVBS2:
-- 
2.17.1
