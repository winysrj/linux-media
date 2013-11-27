Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:45720 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756830Ab3K0U3P (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Nov 2013 15:29:15 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 1/2] af9033: fix broken I2C
Date: Wed, 27 Nov 2013 22:28:47 +0200
Message-Id: <1385584128-2632-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Driver did not work anymore since I2C has gone broken due
to recent commit:
commit 37ebaf6891ee81687bb558e8375c0712d8264ed8
[media] dvb-frontends: Don't use dynamic static allocation

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/af9033.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/af9033.c b/drivers/media/dvb-frontends/af9033.c
index 30ee590..08de532 100644
--- a/drivers/media/dvb-frontends/af9033.c
+++ b/drivers/media/dvb-frontends/af9033.c
@@ -171,7 +171,7 @@ static int af9033_wr_reg_val_tab(struct af9033_state *state,
 		const struct reg_val *tab, int tab_len)
 {
 	int ret, i, j;
-	u8 buf[MAX_XFER_SIZE];
+	u8 buf[212];
 
 	if (tab_len > sizeof(buf)) {
 		dev_warn(&state->i2c->dev,
-- 
1.8.4.2

