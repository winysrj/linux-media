Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f171.google.com ([209.85.192.171]:64398 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751421AbaLZKnH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Dec 2014 05:43:07 -0500
Received: by mail-pd0-f171.google.com with SMTP id y13so12907766pdi.16
        for <linux-media@vger.kernel.org>; Fri, 26 Dec 2014 02:43:05 -0800 (PST)
From: tskd08@gmail.com
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com, Akihiro Tsukada <tskd08@gmail.com>
Subject: [PATCH] dvb: tc90522: re-add symbol-rate report
Date: Fri, 26 Dec 2014 19:42:52 +0900
Message-Id: <1419590572-16099-1-git-send-email-tskd08@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Akihiro Tsukada <tskd08@gmail.com>

symbol-rate report was wrongly removed off by the commit:906aaf5a .

Signed-off-by: Akihiro Tsukada <tskd08@gmail.com>
---
 drivers/media/dvb-frontends/tc90522.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/dvb-frontends/tc90522.c b/drivers/media/dvb-frontends/tc90522.c
index a06d6f5..813f2ac 100644
--- a/drivers/media/dvb-frontends/tc90522.c
+++ b/drivers/media/dvb-frontends/tc90522.c
@@ -202,6 +202,7 @@ static int tc90522s_get_frontend(struct dvb_frontend *fe)
 
 	c = &fe->dtv_property_cache;
 	c->delivery_system = SYS_ISDBS;
+	c->symbol_rate = 28860000;
 
 	layers = 0;
 	ret = reg_read(fe, 0xe6, val, 5);
-- 
2.2.1

