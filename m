Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:37142 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862AbaBHV1O (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 8 Feb 2014 16:27:14 -0500
Received: by mail-wi0-f172.google.com with SMTP id e4so1795272wiv.5
        for <linux-media@vger.kernel.org>; Sat, 08 Feb 2014 13:27:13 -0800 (PST)
From: "Luis Alves" <ljalvs@gmail.com>
To: "'Antti Palosaari'" <crope@iki.fi>, <linux-media@vger.kernel.org>
Cc: "'Mauro Carvalho Chehab'" <m.chehab@samsung.com>,
	"'Hans Verkuil'" <hverkuil@xs4all.nl>
References: <1391852281-18291-1-git-send-email-crope@iki.fi> <1391852281-18291-4-git-send-email-crope@iki.fi>
In-Reply-To: <1391852281-18291-4-git-send-email-crope@iki.fi>
Subject: RE: [PATCH 3/8] rtl2832: Fix deadlock on i2c mux select function.
Date: Sat, 8 Feb 2014 21:27:10 -0000
Message-ID: <000301cf2514$87c87a30$97596e90$@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Language: pt
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Luis Alves <ljalvs@gmail.com>

Signed-off-by: Luis Alves <ljalvs@gmail.com>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/rtl2832.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb-frontends/rtl2832.c
b/drivers/media/dvb-frontends/rtl2832.c
index c0366a8..cfc5438 100644
--- a/drivers/media/dvb-frontends/rtl2832.c
+++ b/drivers/media/dvb-frontends/rtl2832.c
@@ -917,7 +917,7 @@ static int rtl2832_select(struct i2c_adapter *adap, void
*mux_priv, u32 chan_id)
 	buf[0] = 0x00;
 	buf[1] = 0x01;
 
-	ret = i2c_transfer(adap, msg, 1);
+	ret = __i2c_transfer(adap, msg, 1);
 	if (ret != 1)
 		goto err;
 
@@ -930,7 +930,7 @@ static int rtl2832_select(struct i2c_adapter *adap, void
*mux_priv, u32 chan_id)
 	else
 		buf[1] = 0x10; /* close */
 
-	ret = i2c_transfer(adap, msg, 1);
+	ret = __i2c_transfer(adap, msg, 1);
 	if (ret != 1)
 		goto err;
 
-- 
1.8.5.3


