Return-path: <linux-media-owner@vger.kernel.org>
Received: from hapkido.dreamhost.com ([66.33.216.122]:43544 "EHLO
        hapkido.dreamhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751145AbeAEAFT (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 4 Jan 2018 19:05:19 -0500
Received: from homiemail-a116.g.dreamhost.com (sub5.mail.dreamhost.com [208.113.200.129])
        by hapkido.dreamhost.com (Postfix) with ESMTP id D159B8ED86
        for <linux-media@vger.kernel.org>; Thu,  4 Jan 2018 16:05:18 -0800 (PST)
From: Brad Love <brad@nextdimension.cc>
To: linux-media@vger.kernel.org
Cc: Brad Love <brad@nextdimension.cc>
Subject: [PATCH 8/9] lgdt3306a: QAM streaming improvement
Date: Thu,  4 Jan 2018 18:04:18 -0600
Message-Id: <1515110659-20145-9-git-send-email-brad@nextdimension.cc>
In-Reply-To: <1515110659-20145-1-git-send-email-brad@nextdimension.cc>
References: <1515110659-20145-1-git-send-email-brad@nextdimension.cc>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add some register updates required for stable viewing
on Cablevision in NY. Does not adversely affect other providers.

Signed-off-by: Brad Love <brad@nextdimension.cc>
---
 drivers/media/dvb-frontends/lgdt3306a.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/media/dvb-frontends/lgdt3306a.c b/drivers/media/dvb-frontends/lgdt3306a.c
index d2477ed..2f540f1 100644
--- a/drivers/media/dvb-frontends/lgdt3306a.c
+++ b/drivers/media/dvb-frontends/lgdt3306a.c
@@ -598,6 +598,28 @@ static int lgdt3306a_set_qam(struct lgdt3306a_state *state, int modulation)
 	if (lg_chkerr(ret))
 		goto fail;
 
+	/* 5.1 V0.36 SRDCHKALWAYS : For better QAM detection */
+	ret = lgdt3306a_read_reg(state, 0x000A, &val);
+	val &= 0xFD;
+	val |= 0x02;
+	ret = lgdt3306a_write_reg(state, 0x000A, val);
+	if (lg_chkerr(ret))
+		goto fail;
+
+	/* 5.2 V0.36 Control of "no signal" detector function */
+	ret = lgdt3306a_read_reg(state, 0x2849, &val);
+	val &= 0xDF;
+	ret = lgdt3306a_write_reg(state, 0x2849, val);
+	if (lg_chkerr(ret))
+		goto fail;
+
+	/* 5.3 Fix for Blonder Tongue HDE-2H-QAM and AQM modulators */
+	ret = lgdt3306a_read_reg(state, 0x302B, &val);
+	val &= 0x7F;  /* SELFSYNCFINDEN_CQS=0; disable auto reset */
+	ret = lgdt3306a_write_reg(state, 0x302B, val);
+	if (lg_chkerr(ret))
+		goto fail;
+
 	/* 6. Reset */
 	ret = lgdt3306a_soft_reset(state);
 	if (lg_chkerr(ret))
-- 
2.7.4
