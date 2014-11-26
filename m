Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.bredband2.com ([83.219.192.166]:35043 "EHLO
	smtp.bredband2.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753039AbaKZVv7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Nov 2014 16:51:59 -0500
Received: from localhost.localdomain (92-244-23-216.customers.ownit.se [92.244.23.216])
	(Authenticated sender: ed8153)
	by smtp.bredband2.com (Postfix) with ESMTPA id 9845C121856
	for <linux-media@vger.kernel.org>; Wed, 26 Nov 2014 22:51:47 +0100 (CET)
From: Benjamin Larsson <benjamin@southpole.se>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 2/2] mn88472: document demod reset
Date: Wed, 26 Nov 2014 22:51:47 +0100
Message-Id: <1417038707-6297-2-git-send-email-benjamin@southpole.se>
In-Reply-To: <1417038707-6297-1-git-send-email-benjamin@southpole.se>
References: <1417038707-6297-1-git-send-email-benjamin@southpole.se>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Benjamin Larsson <benjamin@southpole.se>
---
 drivers/staging/media/mn88472/mn88472.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/media/mn88472/mn88472.c b/drivers/staging/media/mn88472/mn88472.c
index f648b58..36ef39b 100644
--- a/drivers/staging/media/mn88472/mn88472.c
+++ b/drivers/staging/media/mn88472/mn88472.c
@@ -190,6 +190,8 @@ static int mn88472_set_frontend(struct dvb_frontend *fe)
 	ret = regmap_write(dev->regmap[0], 0xae, 0x00);
 	ret = regmap_write(dev->regmap[2], 0x08, 0x1d);
 	ret = regmap_write(dev->regmap[0], 0xd9, 0xe3);
+
+	/* Reset demod */
 	ret = regmap_write(dev->regmap[2], 0xf8, 0x9f);
 	if (ret)
 		goto err;
-- 
2.1.0

