Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway21.websitewelcome.com ([192.185.46.109]:14681 "EHLO
        gateway21.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751683AbeA3A4B (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 29 Jan 2018 19:56:01 -0500
Received: from cm14.websitewelcome.com (cm14.websitewelcome.com [100.42.49.7])
        by gateway21.websitewelcome.com (Postfix) with ESMTP id C896E400D25C1
        for <linux-media@vger.kernel.org>; Mon, 29 Jan 2018 18:33:19 -0600 (CST)
Date: Mon, 29 Jan 2018 18:33:18 -0600
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Subject: [PATCH 8/8] platform: vivid-cec: fix potential integer overflow in
 vivid_cec_pin_adap_events
Message-ID: <00eea53890802b679c138fc7f68a0f162261d95c.1517268668.git.gustavo@embeddedor.com>
References: <cover.1517268667.git.gustavo@embeddedor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1517268667.git.gustavo@embeddedor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Cast len to const u64 in order to avoid a potential integer
overflow. This variable is being used in a context that expects
an expression of type const u64.

Addresses-Coverity-ID: 1454996 ("Unintentional integer overflow")
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/media/platform/vivid/vivid-cec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/vivid/vivid-cec.c b/drivers/media/platform/vivid/vivid-cec.c
index b55d278..30240ab 100644
--- a/drivers/media/platform/vivid/vivid-cec.c
+++ b/drivers/media/platform/vivid/vivid-cec.c
@@ -83,7 +83,7 @@ static void vivid_cec_pin_adap_events(struct cec_adapter *adap, ktime_t ts,
 	if (adap == NULL)
 		return;
 	ts = ktime_sub_us(ts, (CEC_TIM_START_BIT_TOTAL +
-			       len * 10 * CEC_TIM_DATA_BIT_TOTAL));
+			       (const u64)len * 10 * CEC_TIM_DATA_BIT_TOTAL));
 	cec_queue_pin_cec_event(adap, false, ts);
 	ts = ktime_add_us(ts, CEC_TIM_START_BIT_LOW);
 	cec_queue_pin_cec_event(adap, true, ts);
-- 
2.7.4
