Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:65314 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599Ab1GVWSI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jul 2011 18:18:08 -0400
Received: by gyh3 with SMTP id 3so1549101gyh.19
        for <linux-media@vger.kernel.org>; Fri, 22 Jul 2011 15:18:07 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 23 Jul 2011 00:18:07 +0200
Message-ID: <CAJbz7-29H=e=C2SyY-6Ru23Zzv6sH7wBbOm72ZWMxqOagakuKQ@mail.gmail.com>
Subject: [PATCH] cxd2820r: fix possible out-of-array lookup
From: HoP <jpetrous@gmail.com>
To: linux-media@vger.kernel.org, Antti <crope@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In case of i2c write operation there is only one element in msg[] array.
Don't access msg[1] in that case.

Signed-off-by: Honza Petrous <jpetrous@smartimp.cz>

--

diff -uBbp cxd2820r_core.c.orig cxd2820r_core.c
--- cxd2820r_core.c.orig	2011-07-22 23:31:56.319168405 +0200
+++ cxd2820r_core.c	2011-07-22 23:35:02.508046078 +0200
@@ -750,8 +750,6 @@ static int cxd2820r_tuner_i2c_xfer(struc
 		}, {
 			.addr = priv->cfg.i2c_address,
 			.flags = I2C_M_RD,
-			.len = msg[1].len,
-			.buf = msg[1].buf,
 		}
 	};

@@ -760,6 +758,8 @@ static int cxd2820r_tuner_i2c_xfer(struc
 	if (num == 2) { /* I2C read */
 		obuf[1] = (msg[0].addr << 1) | I2C_M_RD; /* I2C RD flag */
 		msg2[0].len = sizeof(obuf) - 1; /* maybe HW bug ? */
+		msg2[1].len = msg[1].len;
+		msg2[1].buf = msg[1].buf;
 	}
 	memcpy(&obuf[2], msg[0].buf, msg[0].len);
