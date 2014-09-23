Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f170.google.com ([74.125.82.170]:63753 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755502AbaIWQxW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Sep 2014 12:53:22 -0400
Received: by mail-we0-f170.google.com with SMTP id x48so3497437wes.15
        for <linux-media@vger.kernel.org>; Tue, 23 Sep 2014 09:53:21 -0700 (PDT)
From: Olli Salonen <olli.salonen@iki.fi>
To: linux-media@vger.kernel.org
Cc: Olli Salonen <olli.salonen@iki.fi>
Subject: [PATCH] si2168: add FE_CAN_MULTISTREAM into caps
Date: Tue, 23 Sep 2014 19:53:09 +0300
Message-Id: <1411491189-5554-1-git-send-email-olli.salonen@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

PLP selection was implemented for Si2168 last month (patchwork 25387). However, FE_CAN_MULTISTREAM was not added to dvb_frontend_ops of si2168. This patch adds FE_CAN_MULTISTREAM, which indicates that multiple PLP are supported.

Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
---
 drivers/media/dvb-frontends/si2168.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/si2168.c b/drivers/media/dvb-frontends/si2168.c
index 55a4212..c7e7446 100644
--- a/drivers/media/dvb-frontends/si2168.c
+++ b/drivers/media/dvb-frontends/si2168.c
@@ -598,7 +598,8 @@ static const struct dvb_frontend_ops si2168_ops = {
 			FE_CAN_GUARD_INTERVAL_AUTO |
 			FE_CAN_HIERARCHY_AUTO |
 			FE_CAN_MUTE_TS |
-			FE_CAN_2G_MODULATION
+			FE_CAN_2G_MODULATION |
+			FE_CAN_MULTISTREAM
 	},
 
 	.get_tune_settings = si2168_get_tune_settings,
-- 
1.9.1

