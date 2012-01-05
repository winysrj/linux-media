Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:19342 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932319Ab2AEBBM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 4 Jan 2012 20:01:12 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q0511Bjd002509
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 4 Jan 2012 20:01:11 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 41/47] [media] mt2063: Fix i2c read message
Date: Wed,  4 Jan 2012 23:00:52 -0200
Message-Id: <1325725258-27934-42-git-send-email-mchehab@redhat.com>
In-Reply-To: <1325725258-27934-1-git-send-email-mchehab@redhat.com>
References: <1325725258-27934-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

While here, improve a few debug messages that helped to track the
issue and may be useful in the future.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/common/tuners/mt2063.c |   24 ++++++++++++++++--------
 1 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/drivers/media/common/tuners/mt2063.c b/drivers/media/common/tuners/mt2063.c
index fdf6050..599f864 100644
--- a/drivers/media/common/tuners/mt2063.c
+++ b/drivers/media/common/tuners/mt2063.c
@@ -305,35 +305,40 @@ static u32 mt2063_read(struct mt2063_state *state,
 	struct dvb_frontend *fe = state->frontend;
 	u32 i = 0;
 
-	dprintk(2, "\n");
+	dprintk(2, "addr 0x%02x, cnt %d\n", subAddress, cnt);
 
 	if (fe->ops.i2c_gate_ctrl)
 		fe->ops.i2c_gate_ctrl(fe, 1);
 
 	for (i = 0; i < cnt; i++) {
-		int ret;
 		u8 b0[] = { subAddress + i };
 		struct i2c_msg msg[] = {
 			{
 				.addr = state->config->tuner_address,
-				.flags = I2C_M_RD,
+				.flags = 0,
 				.buf = b0,
 				.len = 1
 			}, {
 				.addr = state->config->tuner_address,
 				.flags = I2C_M_RD,
-				.buf = pData + 1,
+				.buf = pData + i,
 				.len = 1
 			}
 		};
 
-		ret = i2c_transfer(state->i2c, msg, 2);
-		if (ret < 0)
+		status = i2c_transfer(state->i2c, msg, 2);
+		dprintk(2, "addr 0x%02x, ret = %d, val = 0x%02x\n",
+			   subAddress + i, status, *(pData + i));
+		if (status < 0)
 			break;
 	}
 	if (fe->ops.i2c_gate_ctrl)
 		fe->ops.i2c_gate_ctrl(fe, 0);
 
+	if (status < 0)
+		printk(KERN_ERR "Can't read from address 0x%02x,\n",
+		       subAddress + i);
+
 	return status;
 }
 
@@ -1801,7 +1806,8 @@ static int mt2063_init(struct dvb_frontend *fe)
 	state->rcvr_mode = MT2063_CABLE_QAM;
 
 	/*  Read the Part/Rev code from the tuner */
-	status = mt2063_read(state, MT2063_REG_PART_REV, state->reg, 1);
+	status = mt2063_read(state, MT2063_REG_PART_REV,
+			     &state->reg[MT2063_REG_PART_REV], 1);
 	if (status < 0) {
 		printk(KERN_ERR "Can't read mt2063 part ID\n");
 		return status;
@@ -1833,7 +1839,9 @@ static int mt2063_init(struct dvb_frontend *fe)
 
 	/* b7 != 0 ==> NOT MT2063 */
 	if (status < 0 || ((state->reg[MT2063_REG_RSVD_3B] & 0x80) != 0x00)) {
-		printk(KERN_ERR "mt2063: Unknown 2nd part ID\n");
+		printk(KERN_ERR "mt2063: Unknown part ID (0x%02x%02x)\n",
+		       state->reg[MT2063_REG_PART_REV],
+		       state->reg[MT2063_REG_RSVD_3B]);
 		return -ENODEV;	/*  Wrong tuner Part/Rev code */
 	}
 
-- 
1.7.7.5

