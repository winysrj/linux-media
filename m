Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:35420 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750988AbdG3MfB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 30 Jul 2017 08:35:01 -0400
Received: by mail-lf0-f67.google.com with SMTP id w199so10507993lff.2
        for <linux-media@vger.kernel.org>; Sun, 30 Jul 2017 05:35:01 -0700 (PDT)
From: olli.salonen@iki.fi
To: linux-media@vger.kernel.org
Cc: Olli Salonen <olli.salonen@iki.fi>
Subject: [PATCH 1/2] mn88472: reset stream ID reg if no PLP given
Date: Sun, 30 Jul 2017 15:34:48 +0300
Message-Id: <1501418089-22418-1-git-send-email-olli.salonen@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Olli Salonen <olli.salonen@iki.fi>

If the PLP given is NO_STREAM_ID_FILTER (~0u) don't try to set that into the PLP register. Set PLP to 0 instead.

Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
---
 drivers/media/dvb-frontends/mn88472.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/mn88472.c b/drivers/media/dvb-frontends/mn88472.c
index f6938f96..5e8fd63 100644
--- a/drivers/media/dvb-frontends/mn88472.c
+++ b/drivers/media/dvb-frontends/mn88472.c
@@ -377,7 +377,9 @@ static int mn88472_set_frontend(struct dvb_frontend *fe)
 		ret = regmap_write(dev->regmap[1], 0xf6, 0x05);
 		if (ret)
 			goto err;
-		ret = regmap_write(dev->regmap[2], 0x32, c->stream_id);
+		ret = regmap_write(dev->regmap[2], 0x32,
+				(c->stream_id == NO_STREAM_ID_FILTER) ? 0 :
+				c->stream_id );
 		if (ret)
 			goto err;
 		break;
-- 
2.7.4
