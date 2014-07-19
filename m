Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:52690 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760072AbaGSCir (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Jul 2014 22:38:47 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Olli Salonen <olli.salonen@iki.fi>, Antti Palosaari <crope@iki.fi>
Subject: [PATCH 02/10] si2168: improve scanning performance
Date: Sat, 19 Jul 2014 05:38:18 +0300
Message-Id: <1405737506-13186-2-git-send-email-crope@iki.fi>
In-Reply-To: <1405737506-13186-1-git-send-email-crope@iki.fi>
References: <1405737506-13186-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Olli Salonen <olli.salonen@iki.fi>

Improve scanning performance by setting property 0301 with a value
from Windows driver.

Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/si2168.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/media/dvb-frontends/si2168.c b/drivers/media/dvb-frontends/si2168.c
index 7980741..767dada 100644
--- a/drivers/media/dvb-frontends/si2168.c
+++ b/drivers/media/dvb-frontends/si2168.c
@@ -325,6 +325,13 @@ static int si2168_set_frontend(struct dvb_frontend *fe)
 	if (ret)
 		goto err;
 
+	memcpy(cmd.args, "\x14\x00\x01\x03\x0c\x00", 6);
+	cmd.wlen = 6;
+	cmd.rlen = 4;
+	ret = si2168_cmd_execute(s, &cmd);
+	if (ret)
+		goto err;
+
 	memcpy(cmd.args, "\x85", 1);
 	cmd.wlen = 1;
 	cmd.rlen = 1;
-- 
1.9.3

