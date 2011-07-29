Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:48047 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753056Ab1G2G5z (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jul 2011 02:57:55 -0400
Received: by vxh35 with SMTP id 35so2453530vxh.19
        for <linux-media@vger.kernel.org>; Thu, 28 Jul 2011 23:57:54 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 29 Jul 2011 08:57:54 +0200
Message-ID: <CAJbz7-0BNRvKb82fhcvZf63hXp-RXV+WT4uX0h9_zaDPfTPgiA@mail.gmail.com>
Subject: [PATH v2] cxd2820r: fix possible out-of-array lookup
From: HoP <jpetrous@gmail.com>
To: linux-media@vger.kernel.org, Antti <crope@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When I2C_WRITE is used the msg[] array contains one element only.
Don't access msg[1] in that case. Also moved rest of msg2[1]
setting to be used only if needed.

Signed-off-by: Honza Petrous <jpetrous@smartimp.cz>

---

diff -r ae517614bf00 drivers/media/dvb/frontends/cxd2820r_core.c
--- a/drivers/media/dvb/frontends/cxd2820r_core.c	Thu Jul 28 15:44:49 2011 +0200
+++ b/drivers/media/dvb/frontends/cxd2820r_core.c	Thu Jul 28 16:20:17 2011 +0200
@@ -747,12 +747,7 @@ static int cxd2820r_tuner_i2c_xfer(struc
 			.flags = 0,
 			.len = sizeof(obuf),
 			.buf = obuf,
-		}, {
-			.addr = priv->cfg.i2c_address,
-			.flags = I2C_M_RD,
-			.len = msg[1].len,
-			.buf = msg[1].buf,
-		}
+		},
 	};

 	obuf[0] = 0x09;
@@ -760,6 +755,11 @@ static int cxd2820r_tuner_i2c_xfer(struc
 	if (num == 2) { /* I2C read */
 		obuf[1] = (msg[0].addr << 1) | I2C_M_RD; /* I2C RD flag */
 		msg2[0].len = sizeof(obuf) - 1; /* maybe HW bug ? */
+
+		msg2[1].addr = priv->cfg.i2c_address,
+		msg2[1].flags = I2C_M_RD,
+		msg2[1].len = msg[1].len,
+		msg2[1].buf = msg[1].buf,
 	}
 	memcpy(&obuf[2], msg[0].buf, msg[0].len);
