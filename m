Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:41659 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030957AbbD1XEm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Apr 2015 19:04:42 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	stable@vger.kernel.org
Subject: [PATCH 08/13] cx24116: fix a buffer overflow when checking userspace params
Date: Tue, 28 Apr 2015 20:04:30 -0300
Message-Id: <c40f617a2dc604b998f276803948c922ea1572ba.1430262253.git.mchehab@osg.samsung.com>
In-Reply-To: <7a73d61faf3046af216692dbf1473bafc645ed9f.1430262253.git.mchehab@osg.samsung.com>
References: <7a73d61faf3046af216692dbf1473bafc645ed9f.1430262253.git.mchehab@osg.samsung.com>
In-Reply-To: <7a73d61faf3046af216692dbf1473bafc645ed9f.1430262253.git.mchehab@osg.samsung.com>
References: <7a73d61faf3046af216692dbf1473bafc645ed9f.1430262253.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The maximum size for a DiSEqC command is 6, according to the
userspace API. However, the code allows to write up much more values:
	drivers/media/dvb-frontends/cx24116.c:983 cx24116_send_diseqc_msg() error: buffer overflow 'd->msg' 6 <= 23

Cc: stable@vger.kernel.org
Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/dvb-frontends/cx24116.c b/drivers/media/dvb-frontends/cx24116.c
index 2916d7c74a1d..7bc68b355c0b 100644
--- a/drivers/media/dvb-frontends/cx24116.c
+++ b/drivers/media/dvb-frontends/cx24116.c
@@ -963,6 +963,10 @@ static int cx24116_send_diseqc_msg(struct dvb_frontend *fe,
 	struct cx24116_state *state = fe->demodulator_priv;
 	int i, ret;
 
+	/* Validate length */
+	if (d->msg_len > sizeof(d->msg))
+                return -EINVAL;
+
 	/* Dump DiSEqC message */
 	if (debug) {
 		printk(KERN_INFO "cx24116: %s(", __func__);
@@ -974,10 +978,6 @@ static int cx24116_send_diseqc_msg(struct dvb_frontend *fe,
 		printk(") toneburst=%d\n", toneburst);
 	}
 
-	/* Validate length */
-	if (d->msg_len > (CX24116_ARGLEN - CX24116_DISEQC_MSGOFS))
-		return -EINVAL;
-
 	/* DiSEqC message */
 	for (i = 0; i < d->msg_len; i++)
 		state->dsec_cmd.args[CX24116_DISEQC_MSGOFS + i] = d->msg[i];
-- 
2.1.0

