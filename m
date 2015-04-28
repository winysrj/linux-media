Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:41799 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031184AbbD1XGm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Apr 2015 19:06:42 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Antti Palosaari <crope@iki.fi>, stable@vger.kernel.org
Subject: [PATCH 09/13] af9013: Don't accept invalid bandwidth
Date: Tue, 28 Apr 2015 20:06:16 -0300
Message-Id: <281da911b81d52c8b8fdc72b77b4cfc5c54416ca.1430262315.git.mchehab@osg.samsung.com>
In-Reply-To: <c40f617a2dc604b998f276803948c922ea1572ba.1430262315.git.mchehab@osg.samsung.com>
References: <c40f617a2dc604b998f276803948c922ea1572ba.1430262315.git.mchehab@osg.samsung.com>
In-Reply-To: <7a73d61faf3046af216692dbf1473bafc645ed9f.1430262315.git.mchehab@osg.samsung.com>
References: <7a73d61faf3046af216692dbf1473bafc645ed9f.1430262315.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If userspace sends an invalid bandwidth, it should either return
EINVAL or switch to auto mode.

This driver will go past an array and program the hardware on a
wrong way if this happens.

Cc: stable@vger.kernel.org
Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/dvb-frontends/af9013.c b/drivers/media/dvb-frontends/af9013.c
index 8001690d7576..ba6c8f6c42a1 100644
--- a/drivers/media/dvb-frontends/af9013.c
+++ b/drivers/media/dvb-frontends/af9013.c
@@ -605,6 +605,10 @@ static int af9013_set_frontend(struct dvb_frontend *fe)
 			}
 		}
 
+		/* Return an error if can't find bandwidth or the right clock */
+		if (i == ARRAY_SIZE(coeff_lut))
+			return -EINVAL;
+
 		ret = af9013_wr_regs(state, 0xae00, coeff_lut[i].val,
 			sizeof(coeff_lut[i].val));
 	}
-- 
2.1.0

