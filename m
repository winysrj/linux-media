Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:33202 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732237AbeKXEBJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Nov 2018 23:01:09 -0500
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Akihiro Tsukada <tskd08@gmail.com>, Michael Buesch <m@bues.ch>
Subject: [PATCH] media: dvb-pll: don't re-validate tuner frequencies
Date: Fri, 23 Nov 2018 12:15:58 -0500
Message-Id: <47d7c8b16d765432221da31a4570a1689a8e3580.1542993354.git.mchehab+samsung@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The dvb_frontend core already checks for the frequencies. No
need for any additional check inside the driver.

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 drivers/media/dvb-frontends/dvb-pll.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/media/dvb-frontends/dvb-pll.c b/drivers/media/dvb-frontends/dvb-pll.c
index fff5816f6ec4..29836c1a40e9 100644
--- a/drivers/media/dvb-frontends/dvb-pll.c
+++ b/drivers/media/dvb-frontends/dvb-pll.c
@@ -610,9 +610,6 @@ static int dvb_pll_configure(struct dvb_frontend *fe, u8 *buf,
 	u32 div;
 	int i;
 
-	if (frequency && (frequency < desc->min || frequency > desc->max))
-		return -EINVAL;
-
 	for (i = 0; i < desc->count; i++) {
 		if (frequency > desc->entries[i].limit)
 			continue;
-- 
2.19.1
