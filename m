Return-path: <linux-media-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:34607 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752705AbeDRP0W (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 18 Apr 2018 11:26:22 -0400
From: Colin King <colin.king@canonical.com>
To: Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] media: cec: set ev rather than v with CEC_PIN_EVENT_FL_DROPPED bit
Date: Wed, 18 Apr 2018 16:26:19 +0100
Message-Id: <20180418152619.30538-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

Setting v with the CEC_PIN_EVENT_FL_DROPPED is incorrect, instead
ev should be set with this bit. Fix this.

Detected by CoverityScan, CID#1467974 ("Extra high-order bits")

Fixes: 6ec1cbf6b125 ("media: cec: improve CEC pin event handling")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/media/cec/cec-pin.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/cec/cec-pin.c b/drivers/media/cec/cec-pin.c
index 2a5df99735fa..6e311424f0dc 100644
--- a/drivers/media/cec/cec-pin.c
+++ b/drivers/media/cec/cec-pin.c
@@ -119,7 +119,7 @@ static void cec_pin_update(struct cec_pin *pin, bool v, bool force)
 
 		if (pin->work_pin_events_dropped) {
 			pin->work_pin_events_dropped = false;
-			v |= CEC_PIN_EVENT_FL_DROPPED;
+			ev |= CEC_PIN_EVENT_FL_DROPPED;
 		}
 		pin->work_pin_events[pin->work_pin_events_wr] = ev;
 		pin->work_pin_ts[pin->work_pin_events_wr] = ktime_get();
-- 
2.17.0
