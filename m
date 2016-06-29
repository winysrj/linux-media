Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:35100 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751587AbcF2Xj7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Jun 2016 19:39:59 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 2/5] m88ds3103: calculate DiSEqC message sending time
Date: Thu, 30 Jun 2016 02:39:45 +0300
Message-Id: <1467243588-26204-2-git-send-email-crope@iki.fi>
In-Reply-To: <1467243588-26204-1-git-send-email-crope@iki.fi>
References: <1467243588-26204-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

DiSEqC message sending takes 13.5 ms per byte, which is 54 ms total
when typical 4 byte message is sent. Don't hard-code time limit to
54 ms, but calculate it. Time limit is only used to determine when to
start poll "DiSEqC Tx ready" status from the chip.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/m88ds3103.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb-frontends/m88ds3103.c b/drivers/media/dvb-frontends/m88ds3103.c
index 7c19601..6f03ca8 100644
--- a/drivers/media/dvb-frontends/m88ds3103.c
+++ b/drivers/media/dvb-frontends/m88ds3103.c
@@ -1116,8 +1116,9 @@ static int m88ds3103_diseqc_send_master_cmd(struct dvb_frontend *fe,
 	#define SEND_MASTER_CMD_TIMEOUT 120
 	timeout = jiffies + msecs_to_jiffies(SEND_MASTER_CMD_TIMEOUT);
 
-	/* DiSEqC message typical period is 54 ms */
-	usleep_range(50000, 54000);
+	/* DiSEqC message period is 13.5 ms per byte */
+	utmp = diseqc_cmd->msg_len * 13500;
+	usleep_range(utmp - 4000, utmp);
 
 	for (utmp = 1; !time_after(jiffies, timeout) && utmp;) {
 		ret = regmap_read(dev->regmap, 0xa1, &utmp);
-- 
http://palosaari.fi/

