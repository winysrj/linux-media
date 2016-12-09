Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:47684 "EHLO mail.kapsi.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751729AbcLINzH (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 9 Dec 2016 08:55:07 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 2/2] si2168: implement ucb statistics
Date: Fri,  9 Dec 2016 15:54:56 +0200
Message-Id: <1481291696-11869-2-git-send-email-crope@iki.fi>
In-Reply-To: <1481291696-11869-1-git-send-email-crope@iki.fi>
References: <1481291696-11869-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Implement DVBv5 UCB. Only uncorrected blocks are currently counted.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/si2168.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/media/dvb-frontends/si2168.c b/drivers/media/dvb-frontends/si2168.c
index 5fbb6c1..680ba06 100644
--- a/drivers/media/dvb-frontends/si2168.c
+++ b/drivers/media/dvb-frontends/si2168.c
@@ -178,6 +178,28 @@ static int si2168_read_status(struct dvb_frontend *fe, enum fe_status *status)
 		c->post_bit_count.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
 	}
 
+	/* UCB */
+	if (*status & FE_HAS_SYNC) {
+		memcpy(cmd.args, "\x84\x01", 2);
+		cmd.wlen = 2;
+		cmd.rlen = 3;
+		ret = si2168_cmd_execute(client, &cmd);
+		if (ret)
+			goto err;
+
+		utmp1 = cmd.args[2] << 8 | cmd.args[1] << 0;
+		dev_dbg(&client->dev, "block_error=%u\n", utmp1);
+
+		/* Sometimes firmware returns bogus value */
+		if (utmp1 == 0xffff)
+			utmp1 = 0;
+
+		c->block_error.stat[0].scale = FE_SCALE_COUNTER;
+		c->block_error.stat[0].uvalue += utmp1;
+	} else {
+		c->block_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+	}
+
 	return 0;
 err:
 	dev_dbg(&client->dev, "failed=%d\n", ret);
@@ -535,6 +557,8 @@ static int si2168_init(struct dvb_frontend *fe)
 	c->post_bit_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
 	c->post_bit_count.len = 1;
 	c->post_bit_count.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+	c->block_error.len = 1;
+	c->block_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
 
 	dev->active = true;
 
-- 
http://palosaari.fi/

