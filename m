Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:37568 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757093AbaIDChF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Sep 2014 22:37:05 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 36/37] af9033: wrap DVBv3 BER to DVBv5 BER
Date: Thu,  4 Sep 2014 05:36:44 +0300
Message-Id: <1409798205-25645-36-git-send-email-crope@iki.fi>
In-Reply-To: <1409798205-25645-1-git-send-email-crope@iki.fi>
References: <1409798205-25645-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

DVBv5 BER is calculated anyway, so just return it for legacy
read_ber() API too.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/af9033.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/media/dvb-frontends/af9033.c b/drivers/media/dvb-frontends/af9033.c
index 673d60e..f5267fd 100644
--- a/drivers/media/dvb-frontends/af9033.c
+++ b/drivers/media/dvb-frontends/af9033.c
@@ -38,6 +38,7 @@ struct af9033_dev {
 	fe_status_t fe_status;
 	u32 ber;
 	u32 ucb;
+	u64 post_bit_error_prev; /* for old read_ber we return (curr - prev) */
 	u64 post_bit_error;
 	u64 post_bit_count;
 	u64 error_block_count;
@@ -918,13 +919,9 @@ err:
 static int af9033_read_ber(struct dvb_frontend *fe, u32 *ber)
 {
 	struct af9033_dev *dev = fe->demodulator_priv;
-	int ret;
-
-	ret = af9033_update_ch_stat(dev);
-	if (ret < 0)
-		return ret;
 
-	*ber = dev->ber;
+	*ber = (dev->post_bit_error - dev->post_bit_error_prev);
+	dev->post_bit_error_prev = dev->post_bit_error;
 
 	return 0;
 }
-- 
http://palosaari.fi/

