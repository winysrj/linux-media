Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:39755 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S967462AbeBNL7j (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Feb 2018 06:59:39 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: stable@vger.kernel.org
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH for v3.16 01/14] adv7604: use correct drive strength defines
Date: Wed, 14 Feb 2018 12:59:25 +0100
Message-Id: <20180214115938.28296-2-hverkuil@xs4all.nl>
In-Reply-To: <20180214115938.28296-1-hverkuil@xs4all.nl>
References: <20180214115938.28296-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The prefix is ADV7604_, not ADV76XX.

Fixes: f31b62e14a ("adv7604: add hdmi driver strength adjustment")

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/adv7604.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index af8a99716de5..9e0e592f50ab 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -2735,9 +2735,9 @@ static int adv7604_parse_dt(struct adv7604_state *state)
 	state->pdata.alt_data_sat = 1;
 	state->pdata.op_format_mode_sel = ADV7604_OP_FORMAT_MODE0;
 	state->pdata.bus_order = ADV7604_BUS_ORDER_RGB;
-	state->pdata.dr_str_data = ADV76XX_DR_STR_MEDIUM_HIGH;
-	state->pdata.dr_str_clk = ADV76XX_DR_STR_MEDIUM_HIGH;
-	state->pdata.dr_str_sync = ADV76XX_DR_STR_MEDIUM_HIGH;
+	state->pdata.dr_str_data = ADV7604_DR_STR_MEDIUM_HIGH;
+	state->pdata.dr_str_clk = ADV7604_DR_STR_MEDIUM_HIGH;
+	state->pdata.dr_str_sync = ADV7604_DR_STR_MEDIUM_HIGH;
 
 	return 0;
 }
-- 
2.15.1
