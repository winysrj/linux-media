Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:60283 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115AbbD3OJA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Apr 2015 10:09:00 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Antti Palosaari <crope@iki.fi>,
	Olli Salonen <olli.salonen@iki.fi>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	=?UTF-8?q?David=20H=C3=A4rdeman?= <david@hardeman.nu>,
	CrazyCat <crazycat69@narod.ru>
Subject: [PATCH 02/22] dw2102: fix bad indenting
Date: Thu, 30 Apr 2015 11:08:22 -0300
Message-Id: <ba445599d624310ac77c2595b7d07f133e2190ad.1430402823.git.mchehab@osg.samsung.com>
In-Reply-To: <cf299adba61007966689167eae0f09265aa9abbc.1430402823.git.mchehab@osg.samsung.com>
References: <cf299adba61007966689167eae0f09265aa9abbc.1430402823.git.mchehab@osg.samsung.com>
In-Reply-To: <cf299adba61007966689167eae0f09265aa9abbc.1430402823.git.mchehab@osg.samsung.com>
References: <cf299adba61007966689167eae0f09265aa9abbc.1430402823.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/usb/dvb-usb/dw2102.c:440 dw2104_i2c_transfer() warn: inconsistent indenting

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/usb/dvb-usb/dw2102.c b/drivers/media/usb/dvb-usb/dw2102.c
index f1f357f43ff0..28fd6bacb852 100644
--- a/drivers/media/usb/dvb-usb/dw2102.c
+++ b/drivers/media/usb/dvb-usb/dw2102.c
@@ -437,7 +437,7 @@ static int dw2104_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg msg[], i
 						ibuf, msg[j].len + 2,
 						DW210X_READ_MSG);
 				memcpy(msg[j].buf, ibuf + 2, msg[j].len);
-			mdelay(10);
+				mdelay(10);
 			} else if (((msg[j].buf[0] == 0xb0) &&
 						(msg[j].addr == 0x68)) ||
 						((msg[j].buf[0] == 0xf7) &&
-- 
2.1.0

