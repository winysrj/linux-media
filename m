Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:47964 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751084AbaKDBHQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 3 Nov 2014 20:07:16 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>, Bimow Chen <Bimow.Chen@ite.com.tw>
Subject: [PATCH 2/6] af9033: fix AF9033 DVBv3 signal strength measurement
Date: Tue,  4 Nov 2014 03:07:00 +0200
Message-Id: <1415063224-28453-2-git-send-email-crope@iki.fi>
In-Reply-To: <1415063224-28453-1-git-send-email-crope@iki.fi>
References: <1415063224-28453-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Previous patch changes used signal strength firmware register from
0x800048 to 0x80004a in case of AF9033/AF9035 chip. In practice
reported values were running upside-down, when RR strength increases
reported value decreases and vice versa. That is because of 0x80004a
returns values that are dBm scale, but negative RF strength dBm
returned as positive number.

0x800048 returns 0-100, like percentage
0x80004a returns 0-255 dBm, without a negative sign

So restore old measurement now.

Cc: Bimow Chen <Bimow.Chen@ite.com.tw>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/af9033.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/af9033.c b/drivers/media/dvb-frontends/af9033.c
index 2b3d2f0..e3bae77 100644
--- a/drivers/media/dvb-frontends/af9033.c
+++ b/drivers/media/dvb-frontends/af9033.c
@@ -867,7 +867,11 @@ static int af9033_read_signal_strength(struct dvb_frontend *fe, u16 *strength)
 	u8 u8tmp, gain_offset, buf[7];
 
 	if (dev->is_af9035) {
-		ret = af9033_rd_reg(dev, 0x80004a, &u8tmp);
+		/* read signal strength of 0-100 scale */
+		ret = af9033_rd_reg(dev, 0x800048, &u8tmp);
+		if (ret < 0)
+			goto err;
+
 		/* scale value to 0x0000-0xffff */
 		*strength = u8tmp * 0xffff / 100;
 	} else {
-- 
http://palosaari.fi/

