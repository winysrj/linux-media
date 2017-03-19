Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:34631 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752272AbdCSP2Z (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 19 Mar 2017 11:28:25 -0400
Received: by mail-wr0-f196.google.com with SMTP id u48so15113781wrc.1
        for <linux-media@vger.kernel.org>; Sun, 19 Mar 2017 08:28:01 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: serjk@netup.ru, aospan@netup.ru, linux-media@vger.kernel.org
Cc: mchehab@kernel.org
Subject: [PATCH] [media] dvb-frontends/cxd2841er: define symbol_rate_min/max in T/C fe-ops
Date: Sun, 19 Mar 2017 16:26:39 +0100
Message-Id: <20170319152639.18285-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Fixes "w_scan -f c" complaining with

  This dvb driver is *buggy*: the symbol rate limits are undefined - please
  report to linuxtv.org)

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/dvb-frontends/cxd2841er.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/cxd2841er.c b/drivers/media/dvb-frontends/cxd2841er.c
index 614bfb3..ce37dc2 100644
--- a/drivers/media/dvb-frontends/cxd2841er.c
+++ b/drivers/media/dvb-frontends/cxd2841er.c
@@ -3852,7 +3852,9 @@ static struct dvb_frontend_ops cxd2841er_t_c_ops = {
 			FE_CAN_MUTE_TS |
 			FE_CAN_2G_MODULATION,
 		.frequency_min = 42000000,
-		.frequency_max = 1002000000
+		.frequency_max = 1002000000,
+		.symbol_rate_min = 870000,
+		.symbol_rate_max = 11700000
 	},
 	.init = cxd2841er_init_tc,
 	.sleep = cxd2841er_sleep_tc,
-- 
2.10.2
