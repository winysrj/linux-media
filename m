Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:54357 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934033AbbKSUEy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Nov 2015 15:04:54 -0500
From: Matthias Schwarzott <zzam@gentoo.org>
To: linux-media@vger.kernel.org
Cc: mchehab@osg.samsung.com, crope@iki.fi, xpert-reactos@gmx.de,
	Matthias Schwarzott <zzam@gentoo.org>
Subject: [PATCH 03/10] si2165: create function si2165_write_reg_list for writing register lists
Date: Thu, 19 Nov 2015 21:03:55 +0100
Message-Id: <1447963442-9764-4-git-send-email-zzam@gentoo.org>
In-Reply-To: <1447963442-9764-1-git-send-email-zzam@gentoo.org>
References: <1447963442-9764-1-git-send-email-zzam@gentoo.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>
---
 drivers/media/dvb-frontends/si2165.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/drivers/media/dvb-frontends/si2165.c b/drivers/media/dvb-frontends/si2165.c
index a0e4600..222d775 100644
--- a/drivers/media/dvb-frontends/si2165.c
+++ b/drivers/media/dvb-frontends/si2165.c
@@ -243,6 +243,27 @@ err:
 	return ret;
 }
 
+#define REG16(reg, val) { (reg), (val) & 0xff }, { (reg)+1, (val)>>8 & 0xff }
+struct si2165_reg_value_pair {
+	u16 reg;
+	u8 val;
+};
+
+static int si2165_write_reg_list(struct si2165_state *state,
+				 const struct si2165_reg_value_pair *regs,
+				 int count)
+{
+	int i;
+	int ret;
+
+	for (i = 0; i < count; i++) {
+		ret = si2165_writereg8(state, regs[i].reg, regs[i].val);
+		if (ret < 0)
+			return ret;
+	}
+	return 0;
+}
+
 static int si2165_get_tune_settings(struct dvb_frontend *fe,
 				    struct dvb_frontend_tune_settings *s)
 {
-- 
2.6.3

