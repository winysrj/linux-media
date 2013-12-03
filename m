Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:37048 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754108Ab3LCQhm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 3 Dec 2013 11:37:42 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH v2 1/3] af9033: fix broken I2C
Date: Tue,  3 Dec 2013 18:37:26 +0200
Message-Id: <1386088648-13463-2-git-send-email-crope@iki.fi>
In-Reply-To: <1386088648-13463-1-git-send-email-crope@iki.fi>
References: <1386088648-13463-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Driver did not work anymore since I2C has gone broken due
to recent commit:
commit 37ebaf6891ee81687bb558e8375c0712d8264ed8
[media] dvb-frontends: Don't use dynamic static allocation

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/af9033.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/media/dvb-frontends/af9033.c b/drivers/media/dvb-frontends/af9033.c
index 30ee590..65728c2 100644
--- a/drivers/media/dvb-frontends/af9033.c
+++ b/drivers/media/dvb-frontends/af9033.c
@@ -170,18 +170,18 @@ static int af9033_rd_reg_mask(struct af9033_state *state, u32 reg, u8 *val,
 static int af9033_wr_reg_val_tab(struct af9033_state *state,
 		const struct reg_val *tab, int tab_len)
 {
+#define MAX_TAB_LEN 212
 	int ret, i, j;
-	u8 buf[MAX_XFER_SIZE];
+	u8 buf[1 + MAX_TAB_LEN];
+
+	dev_dbg(&state->i2c->dev, "%s: tab_len=%d\n", __func__, tab_len);
 
 	if (tab_len > sizeof(buf)) {
-		dev_warn(&state->i2c->dev,
-			 "%s: i2c wr len=%d is too big!\n",
-			 KBUILD_MODNAME, tab_len);
+		dev_warn(&state->i2c->dev, "%s: tab len %d is too big\n",
+				KBUILD_MODNAME, tab_len);
 		return -EINVAL;
 	}
 
-	dev_dbg(&state->i2c->dev, "%s: tab_len=%d\n", __func__, tab_len);
-
 	for (i = 0, j = 0; i < tab_len; i++) {
 		buf[j] = tab[i].val;
 
-- 
1.8.4.2

