Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:54956 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751275AbeCIPxq (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 9 Mar 2018 10:53:46 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 06/11] media: lgdt330x: do some cleanups at status logic
Date: Fri,  9 Mar 2018 12:53:31 -0300
Message-Id: <8bb3335a3aaa81978ec1566fea96f00908713dea.1520610788.git.mchehab@s-opensource.com>
In-Reply-To: <c673e447c4776af9137fa9edd334ebf5298f1f08.1520610788.git.mchehab@s-opensource.com>
References: <c673e447c4776af9137fa9edd334ebf5298f1f08.1520610788.git.mchehab@s-opensource.com>
In-Reply-To: <c673e447c4776af9137fa9edd334ebf5298f1f08.1520610788.git.mchehab@s-opensource.com>
References: <c673e447c4776af9137fa9edd334ebf5298f1f08.1520610788.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Simplify a few ifs there.

While here, add debug messages for the 8-vsb and qam log status
flags.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/dvb-frontends/lgdt330x.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/media/dvb-frontends/lgdt330x.c b/drivers/media/dvb-frontends/lgdt330x.c
index a6fd5a239026..e93ffe8891e5 100644
--- a/drivers/media/dvb-frontends/lgdt330x.c
+++ b/drivers/media/dvb-frontends/lgdt330x.c
@@ -515,10 +515,8 @@ static int lgdt3302_read_status(struct dvb_frontend *fe,
 		*status |= FE_HAS_SYNC;
 
 	/* FEC error status */
-	if ((buf[2] & 0x0c) == 0x08) {
-		*status |= FE_HAS_LOCK;
-		*status |= FE_HAS_VITERBI;
-	}
+	if ((buf[2] & 0x0c) == 0x08)
+		*status |= FE_HAS_LOCK | FE_HAS_VITERBI;
 
 	/* Carrier Recovery Lock Status Register */
 	i2c_read_demod_bytes(state, CARRIER_LOCK, buf, 1);
@@ -578,6 +576,8 @@ static int lgdt3303_read_status(struct dvb_frontend *fe,
 		else
 			break;
 		i2c_read_demod_bytes(state, 0x8a, buf, 1);
+		dprintk(state, "QAM LOCK = 0x%02x\n", buf[0]);
+
 		if ((buf[0] & 0x04) == 0x04)
 			*status |= FE_HAS_SYNC;
 		if ((buf[0] & 0x01) == 0x01)
@@ -591,12 +591,12 @@ static int lgdt3303_read_status(struct dvb_frontend *fe,
 		else
 			break;
 		i2c_read_demod_bytes(state, 0x38, buf, 1);
+		dprintk(state, "8-VSB LOCK = 0x%02x\n", buf[0]);
+
 		if ((buf[0] & 0x02) == 0x00)
 			*status |= FE_HAS_SYNC;
-		if ((buf[0] & 0x01) == 0x01) {
-			*status |= FE_HAS_LOCK;
-			*status |= FE_HAS_VITERBI;
-		}
+		if ((buf[0] & 0xfd) == 0x01)
+			*status |= FE_HAS_VITERBI | FE_HAS_LOCK;
 		break;
 	default:
 		dev_warn(&state->client->dev,
-- 
2.14.3
