Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:41791 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031075AbbD1XGl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Apr 2015 19:06:41 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	stable@vger.kernel.org
Subject: [PATCH 10/13] cx24117: fix a buffer overflow when checking userspace params
Date: Tue, 28 Apr 2015 20:06:17 -0300
Message-Id: <66cb24b59a7ecff2802f5be519d7c82285f8648e.1430262315.git.mchehab@osg.samsung.com>
In-Reply-To: <c40f617a2dc604b998f276803948c922ea1572ba.1430262315.git.mchehab@osg.samsung.com>
References: <c40f617a2dc604b998f276803948c922ea1572ba.1430262315.git.mchehab@osg.samsung.com>
In-Reply-To: <7a73d61faf3046af216692dbf1473bafc645ed9f.1430262315.git.mchehab@osg.samsung.com>
References: <7a73d61faf3046af216692dbf1473bafc645ed9f.1430262315.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The maximum size for a DiSEqC command is 6, according to the
userspace API. However, the code allows to write up much more values:
	drivers/media/dvb-frontends/cx24116.c:983 cx24116_send_diseqc_msg() error: buffer overflow 'd->msg' 6 <= 23

Cc: stable@vger.kernel.org
Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/dvb-frontends/cx24117.c b/drivers/media/dvb-frontends/cx24117.c
index acb965ce0358..af6363573efd 100644
--- a/drivers/media/dvb-frontends/cx24117.c
+++ b/drivers/media/dvb-frontends/cx24117.c
@@ -1043,7 +1043,7 @@ static int cx24117_send_diseqc_msg(struct dvb_frontend *fe,
 	dev_dbg(&state->priv->i2c->dev, ")\n");
 
 	/* Validate length */
-	if (d->msg_len > 15)
+	if (d->msg_len > sizeof(d->msg))
 		return -EINVAL;
 
 	/* DiSEqC message */
-- 
2.1.0

