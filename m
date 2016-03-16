Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f170.google.com ([209.85.217.170]:34539 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965106AbcCPLFQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Mar 2016 07:05:16 -0400
Received: by mail-lb0-f170.google.com with SMTP id k12so45317918lbb.1
        for <linux-media@vger.kernel.org>; Wed, 16 Mar 2016 04:05:15 -0700 (PDT)
From: Olli Salonen <olli.salonen@iki.fi>
To: linux-media@vger.kernel.org
Cc: Olli Salonen <olli.salonen@iki.fi>
Subject: [PATCHv2 2/2] ds3000: return error if invalid symbol rate is set
Date: Wed, 16 Mar 2016 13:04:51 +0200
Message-Id: <1458126291-13914-2-git-send-email-olli.salonen@iki.fi>
In-Reply-To: <1458126291-13914-1-git-send-email-olli.salonen@iki.fi>
References: <1458126291-13914-1-git-send-email-olli.salonen@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Return -EINVAL if ds3000_set_frontend is called with invalid parameters.

v1 of the patch series got incorrect subject lines.

Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
---
 drivers/media/dvb-frontends/ds3000.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/media/dvb-frontends/ds3000.c b/drivers/media/dvb-frontends/ds3000.c
index addffc3..447b518 100644
--- a/drivers/media/dvb-frontends/ds3000.c
+++ b/drivers/media/dvb-frontends/ds3000.c
@@ -959,6 +959,15 @@ static int ds3000_set_frontend(struct dvb_frontend *fe)
 	/* enable ac coupling */
 	ds3000_writereg(state, 0x25, 0x8a);
 
+	if ((c->symbol_rate < ds3000_ops.info.symbol_rate_min) ||
+			(c->symbol_rate > ds3000_ops.info.symbol_rate_max)) {
+		dprintk("%s() symbol_rate %u out of range (%u ... %u)\n",
+				__func__, c->symbol_rate,
+				ds3000_ops.info.symbol_rate_min,
+				ds3000_ops.info.symbol_rate_max);
+		return -EINVAL;
+	}
+
 	/* enhance symbol rate performance */
 	if ((c->symbol_rate / 1000) <= 5000) {
 		value = 29777 / (c->symbol_rate / 1000) + 1;
-- 
1.9.1

