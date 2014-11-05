Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:53556 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754555AbaKEMDY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Nov 2014 07:03:24 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 1/5] [media] cx22700: Fix potential buffer overflow
Date: Wed,  5 Nov 2014 10:03:15 -0200
Message-Id: <667c952e7191ffb0a2703c8e173b0d5f0231a764.1415188985.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As new FEC types were added, we need a check to avoid overflows:
	drivers/media/dvb-frontends/cx22700.c:172 cx22700_set_tps() error: buffer overflow 'fec_tab' 6 <= 6
	drivers/media/dvb-frontends/cx22700.c:173 cx22700_set_tps() error: buffer overflow 'fec_tab' 6 <= 6

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/dvb-frontends/cx22700.c b/drivers/media/dvb-frontends/cx22700.c
index 3d399d9a6343..86563260d0f2 100644
--- a/drivers/media/dvb-frontends/cx22700.c
+++ b/drivers/media/dvb-frontends/cx22700.c
@@ -169,6 +169,9 @@ static int cx22700_set_tps(struct cx22700_state *state,
 
 	cx22700_writereg (state, 0x04, val);
 
+	if (p->code_rate_HP - FEC_1_2 >= sizeof(fec_tab) ||
+	    p->code_rate_LP - FEC_1_2 >= sizeof(fec_tab))
+		return -EINVAL;
 	val = fec_tab[p->code_rate_HP - FEC_1_2] << 3;
 	val |= fec_tab[p->code_rate_LP - FEC_1_2];
 
-- 
1.9.3

