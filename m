Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:36527 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757091AbaIDChF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Sep 2014 22:37:05 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 34/37] af9033: implement DVBv5 post-Viterbi BER
Date: Thu,  4 Sep 2014 05:36:42 +0300
Message-Id: <1409798205-25645-34-git-send-email-crope@iki.fi>
In-Reply-To: <1409798205-25645-1-git-send-email-crope@iki.fi>
References: <1409798205-25645-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Implement following DTV API commands:
DTV_STAT_POST_ERROR_BIT_COUNT
DTV_STAT_POST_TOTAL_BIT_COUNT

These will provide post-Viterbi bit error rate reporting.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/af9033.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/media/dvb-frontends/af9033.c b/drivers/media/dvb-frontends/af9033.c
index 7b85346..b6b90e6 100644
--- a/drivers/media/dvb-frontends/af9033.c
+++ b/drivers/media/dvb-frontends/af9033.c
@@ -38,6 +38,8 @@ struct af9033_dev {
 	fe_status_t fe_status;
 	u32 ber;
 	u32 ucb;
+	u64 post_bit_error;
+	u64 post_bit_count;
 	u64 error_block_count;
 	u64 total_block_count;
 	struct delayed_work stat_work;
@@ -1093,6 +1095,8 @@ static void af9033_stat_work(struct work_struct *work)
 	if (dev->fe_status & FE_HAS_LOCK) {
 		/* outer FEC, 204 byte packets */
 		u16 abort_packet_count, rsd_packet_count;
+		/* inner FEC, bits */
+		u32 rsd_bit_err_count;
 
 		/*
 		 * Packet count used for measurement is 10000
@@ -1104,10 +1108,13 @@ static void af9033_stat_work(struct work_struct *work)
 			goto err;
 
 		abort_packet_count = (buf[1] << 8) | (buf[0] << 0);
+		rsd_bit_err_count = (buf[4] << 16) | (buf[3] << 8) | buf[2];
 		rsd_packet_count = (buf[6] << 8) | (buf[5] << 0);
 
 		dev->error_block_count += abort_packet_count;
 		dev->total_block_count += rsd_packet_count;
+		dev->post_bit_error += rsd_bit_err_count;
+		dev->post_bit_count += rsd_packet_count * 204 * 8;
 
 		c->block_count.len = 1;
 		c->block_count.stat[0].scale = FE_SCALE_COUNTER;
@@ -1116,6 +1123,14 @@ static void af9033_stat_work(struct work_struct *work)
 		c->block_error.len = 1;
 		c->block_error.stat[0].scale = FE_SCALE_COUNTER;
 		c->block_error.stat[0].uvalue = dev->error_block_count;
+
+		c->post_bit_count.len = 1;
+		c->post_bit_count.stat[0].scale = FE_SCALE_COUNTER;
+		c->post_bit_count.stat[0].uvalue = dev->post_bit_count;
+
+		c->post_bit_error.len = 1;
+		c->post_bit_error.stat[0].scale = FE_SCALE_COUNTER;
+		c->post_bit_error.stat[0].uvalue = dev->post_bit_error;
 	}
 
 err_schedule_delayed_work:
-- 
http://palosaari.fi/

