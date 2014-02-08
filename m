Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:42436 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751503AbaBHJiv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 8 Feb 2014 04:38:51 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Luis Alves <ljalvs@gmail.com>, Antti Palosaari <crope@iki.fi>
Subject: [PATCH 3/8] rtl2832: Fix deadlock on i2c mux select function.
Date: Sat,  8 Feb 2014 11:37:56 +0200
Message-Id: <1391852281-18291-4-git-send-email-crope@iki.fi>
In-Reply-To: <1391852281-18291-1-git-send-email-crope@iki.fi>
References: <1391852281-18291-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Luis Alves <ljalvs@gmail.com>

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/rtl2832.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb-frontends/rtl2832.c b/drivers/media/dvb-frontends/rtl2832.c
index c0366a8..cfc5438 100644
--- a/drivers/media/dvb-frontends/rtl2832.c
+++ b/drivers/media/dvb-frontends/rtl2832.c
@@ -917,7 +917,7 @@ static int rtl2832_select(struct i2c_adapter *adap, void *mux_priv, u32 chan_id)
 	buf[0] = 0x00;
 	buf[1] = 0x01;
 
-	ret = i2c_transfer(adap, msg, 1);
+	ret = __i2c_transfer(adap, msg, 1);
 	if (ret != 1)
 		goto err;
 
@@ -930,7 +930,7 @@ static int rtl2832_select(struct i2c_adapter *adap, void *mux_priv, u32 chan_id)
 	else
 		buf[1] = 0x10; /* close */
 
-	ret = i2c_transfer(adap, msg, 1);
+	ret = __i2c_transfer(adap, msg, 1);
 	if (ret != 1)
 		goto err;
 
-- 
1.8.5.3

