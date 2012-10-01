Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38244 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751226Ab2JARnc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Oct 2012 13:43:32 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q91HhWmr032284
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 1 Oct 2012 13:43:32 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] tda1004x: Lock I2C bus during firmware load
Date: Mon,  1 Oct 2012 14:43:23 -0300
Message-Id: <1349113403-25671-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

tda1004x doesn't allow firmware loads while it is busy with something
else. Avoid it to happen by locking the I2C bus during firmware transfer.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb-frontends/tda1004x.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb-frontends/tda1004x.c b/drivers/media/dvb-frontends/tda1004x.c
index 35d72b4..a2631be 100644
--- a/drivers/media/dvb-frontends/tda1004x.c
+++ b/drivers/media/dvb-frontends/tda1004x.c
@@ -329,6 +329,7 @@ static int tda1004x_do_upload(struct tda1004x_state *state,
 	tda1004x_write_byteI(state, dspCodeCounterReg, 0);
 	fw_msg.addr = state->config->demod_address;
 
+	i2c_lock_adapter(state->i2c);
 	buf[0] = dspCodeInReg;
 	while (pos != len) {
 		// work out how much to send this time
@@ -339,15 +340,18 @@ static int tda1004x_do_upload(struct tda1004x_state *state,
 		// send the chunk
 		memcpy(buf + 1, mem + pos, tx_size);
 		fw_msg.len = tx_size + 1;
-		if (i2c_transfer(state->i2c, &fw_msg, 1) != 1) {
+		if (__i2c_transfer(state->i2c, &fw_msg, 1) != 1) {
 			printk(KERN_ERR "tda1004x: Error during firmware upload\n");
+			i2c_unlock_adapter(state->i2c);
 			return -EIO;
 		}
 		pos += tx_size;
 
 		dprintk("%s: fw_pos=0x%x\n", __func__, pos);
 	}
-	// give the DSP a chance to settle 03/10/05 Hac
+	i2c_unlock_adapter(state->i2c);
+
+	/* give the DSP a chance to settle 03/10/05 Hac */
 	msleep(100);
 
 	return 0;
-- 
1.7.11.4

