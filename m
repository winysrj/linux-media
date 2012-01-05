Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53916 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932318Ab2AEBBM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 4 Jan 2012 20:01:12 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q0511BfI016666
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 4 Jan 2012 20:01:11 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 40/47] [media] mt2063: Print a message about the detected mt2063 type
Date: Wed,  4 Jan 2012 23:00:51 -0200
Message-Id: <1325725258-27934-41-git-send-email-mchehab@redhat.com>
In-Reply-To: <1325725258-27934-1-git-send-email-mchehab@redhat.com>
References: <1325725258-27934-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This also helps to identify when a device is not initialized,
if the bridge doesn't return an error for a I2C failed transfer.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/common/tuners/mt2063.c |   26 ++++++++++++++++++++++----
 1 files changed, 22 insertions(+), 4 deletions(-)

diff --git a/drivers/media/common/tuners/mt2063.c b/drivers/media/common/tuners/mt2063.c
index db347d9..fdf6050 100644
--- a/drivers/media/common/tuners/mt2063.c
+++ b/drivers/media/common/tuners/mt2063.c
@@ -1790,6 +1790,7 @@ static int mt2063_init(struct dvb_frontend *fe)
 	struct mt2063_state *state = fe->tuner_priv;
 	u8 all_resets = 0xF0;	/* reset/load bits */
 	const u8 *def = NULL;
+	char *step;
 	u32 FCRUN;
 	s32 maxReads;
 	u32 fcu_osc;
@@ -1807,10 +1808,24 @@ static int mt2063_init(struct dvb_frontend *fe)
 	}
 
 	/* Check the part/rev code */
-	if (((state->reg[MT2063_REG_PART_REV] != MT2063_B0)	/*  MT2063 B0  */
-	    && (state->reg[MT2063_REG_PART_REV] != MT2063_B1)	/*  MT2063 B1  */
-	    && (state->reg[MT2063_REG_PART_REV] != MT2063_B3)))	/*  MT2063 B3  */
+	switch (state->reg[MT2063_REG_PART_REV]) {
+	case MT2063_B0:
+		step = "B0";
+		break;
+	case MT2063_B1:
+		step = "B1";
+		break;
+	case MT2063_B2:
+		step = "B2";
+		break;
+	case MT2063_B3:
+		step = "B3";
+		break;
+	default:
+		printk(KERN_ERR "mt2063: Unknown mt2063 device ID (0x%02x)\n",
+		       state->reg[MT2063_REG_PART_REV]);
 		return -ENODEV;	/*  Wrong tuner Part/Rev code */
+	}
 
 	/*  Check the 2nd byte of the Part/Rev code from the tuner */
 	status = mt2063_read(state, MT2063_REG_RSVD_3B,
@@ -1818,10 +1833,13 @@ static int mt2063_init(struct dvb_frontend *fe)
 
 	/* b7 != 0 ==> NOT MT2063 */
 	if (status < 0 || ((state->reg[MT2063_REG_RSVD_3B] & 0x80) != 0x00)) {
-		printk(KERN_ERR "Can't read mt2063 2nd part ID\n");
+		printk(KERN_ERR "mt2063: Unknown 2nd part ID\n");
 		return -ENODEV;	/*  Wrong tuner Part/Rev code */
 	}
 
+	dprintk(1, "Discovered a mt2063 %s (2nd part number 0x%02x)\n",
+		step, state->reg[MT2063_REG_RSVD_3B]);
+
 	/*  Reset the tuner  */
 	status = mt2063_write(state, MT2063_REG_LO2CQ_3, &all_resets, 1);
 	if (status < 0)
-- 
1.7.7.5

