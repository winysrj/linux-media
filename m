Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:35425 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750988AbdG3MfE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 30 Jul 2017 08:35:04 -0400
Received: by mail-lf0-f68.google.com with SMTP id w199so10508059lff.2
        for <linux-media@vger.kernel.org>; Sun, 30 Jul 2017 05:35:04 -0700 (PDT)
From: olli.salonen@iki.fi
To: linux-media@vger.kernel.org
Cc: Olli Salonen <olli.salonen@iki.fi>
Subject: [PATCH 2/2] mn88473: reset stream ID reg if no PLP given
Date: Sun, 30 Jul 2017 15:34:49 +0300
Message-Id: <1501418089-22418-2-git-send-email-olli.salonen@iki.fi>
In-Reply-To: <1501418089-22418-1-git-send-email-olli.salonen@iki.fi>
References: <1501418089-22418-1-git-send-email-olli.salonen@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Olli Salonen <olli.salonen@iki.fi>

If the PLP given is NO_STREAM_ID_FILTER (~0u) don't try to set that into the PLP register. Set PLP to 0 instead.

Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
---
 drivers/media/dvb-frontends/mn88473.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/mn88473.c b/drivers/media/dvb-frontends/mn88473.c
index 1587424..5824743 100644
--- a/drivers/media/dvb-frontends/mn88473.c
+++ b/drivers/media/dvb-frontends/mn88473.c
@@ -225,7 +225,9 @@ static int mn88473_set_frontend(struct dvb_frontend *fe)
 
 	/* PLP */
 	if (c->delivery_system == SYS_DVBT2) {
-		ret = regmap_write(dev->regmap[2], 0x36, c->stream_id);
+		ret = regmap_write(dev->regmap[2], 0x36,
+				(c->stream_id == NO_STREAM_ID_FILTER) ? 0 :
+				c->stream_id );
 		if (ret)
 			goto err;
 	}
-- 
2.7.4
