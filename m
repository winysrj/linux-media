Return-path: <linux-media-owner@vger.kernel.org>
Received: from sub5.mail.dreamhost.com ([208.113.200.129]:41070 "EHLO
        homiemail-a121.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751100AbeAEBbN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 4 Jan 2018 20:31:13 -0500
From: Brad Love <brad@nextdimension.cc>
To: linux-media@vger.kernel.org
Cc: Brad Love <brad@nextdimension.cc>
Subject: [PATCH v2 8/9] lgdt3306a: QAM streaming improvement
Date: Thu,  4 Jan 2018 19:30:24 -0600
Message-Id: <1515115824-5295-1-git-send-email-brad@nextdimension.cc>
In-Reply-To: <1515110659-20145-9-git-send-email-brad@nextdimension.cc>
References: <1515110659-20145-9-git-send-email-brad@nextdimension.cc>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add some register updates required for stable viewing
on Cablevision in NY. Does not adversely affect other providers.

Changes since v1:
- Change upper case hex to lower case.

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
+	ret = lgdt3306a_read_reg(state, 0x000a, &val);
+	val &= 0xfd;
+	val |= 0x02;
+	ret = lgdt3306a_write_reg(state, 0x000a, val);
+	if (lg_chkerr(ret))
+		goto fail;
+
+	/* 5.2 V0.36 Control of "no signal" detector function */
+	ret = lgdt3306a_read_reg(state, 0x2849, &val);
+	val &= 0xdf;
+	ret = lgdt3306a_write_reg(state, 0x2849, val);
+	if (lg_chkerr(ret))
+		goto fail;
+
+	/* 5.3 Fix for Blonder Tongue HDE-2H-QAM and AQM modulators */
+	ret = lgdt3306a_read_reg(state, 0x302b, &val);
+	val &= 0x7f;  /* SELFSYNCFINDEN_CQS=0; disable auto reset */
+	ret = lgdt3306a_write_reg(state, 0x302b, val);
+	if (lg_chkerr(ret))
+		goto fail;
+
 	/* 6. Reset */
 	ret = lgdt3306a_soft_reset(state);
 	if (lg_chkerr(ret))
-- 
2.7.4
