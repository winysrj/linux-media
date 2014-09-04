Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:46558 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757092AbaIDChF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Sep 2014 22:37:05 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 35/37] af9033: wrap DVBv3 UCB to DVBv5 UCB stats
Date: Thu,  4 Sep 2014 05:36:43 +0300
Message-Id: <1409798205-25645-35-git-send-email-crope@iki.fi>
In-Reply-To: <1409798205-25645-1-git-send-email-crope@iki.fi>
References: <1409798205-25645-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove 'duplicate' DVBv3 read UCB implementation and return value,
calculated already for DVBv5 statistics.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/af9033.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/media/dvb-frontends/af9033.c b/drivers/media/dvb-frontends/af9033.c
index b6b90e6..673d60e 100644
--- a/drivers/media/dvb-frontends/af9033.c
+++ b/drivers/media/dvb-frontends/af9033.c
@@ -932,14 +932,8 @@ static int af9033_read_ber(struct dvb_frontend *fe, u32 *ber)
 static int af9033_read_ucblocks(struct dvb_frontend *fe, u32 *ucblocks)
 {
 	struct af9033_dev *dev = fe->demodulator_priv;
-	int ret;
-
-	ret = af9033_update_ch_stat(dev);
-	if (ret < 0)
-		return ret;
-
-	*ucblocks = dev->ucb;
 
+	*ucblocks = dev->error_block_count;
 	return 0;
 }
 
-- 
http://palosaari.fi/

