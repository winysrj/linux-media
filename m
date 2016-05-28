Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.astim.si ([93.103.6.239]:37079 "EHLO mail.astim.si"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751231AbcE1JqF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 28 May 2016 05:46:05 -0400
Received: from PCSaso ([192.168.10.2])
	by mail.astim.si (8.14.4/8.14.4) with ESMTP id u4S9SoLj022848
	for <linux-media@vger.kernel.org>; Sat, 28 May 2016 11:28:52 +0200
From: "Saso Slavicic" <saso.linux@astim.si>
To: <linux-media@vger.kernel.org>
Subject: ascot2e.c off by one bug
Date: Sat, 28 May 2016 11:28:43 +0200
Message-ID: <000f01d1b8c3$54af4080$fe0dc180$@astim.si>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Language: sl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Tuning a card with Sony ASCOT2E produces the following error:

	kernel: i2c i2c-9: wr reg=0006: len=11 is too big!

MAX_WRITE_REGSIZE is defined as 10, buf[MAX_WRITE_REGSIZE + 1] buffer is
used in ascot2e_write_regs().

The problem is that exactly 10 bytes are written in ascot2e_set_params():

	/* Set BW_OFFSET (0x0F) value from parameter table */
	data[9] = ascot2e_sett[tv_system].bw_offset;
	ascot2e_write_regs(priv, 0x06, data, 10);

The test in write_regs is as follows:

	if (len + 1 >= sizeof(buf))

10 + 1 = 11 and that would be exactly the size of buf. Since 10 bytes +
buf[0] = reg would seem to fit into buf[], this shouldn't be an error.

The following patch fixes the problem for me, I have tested the card and it
seems to be working fine.

---
 drivers/media/dvb-frontends/ascot2e.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/dvb-frontends/ascot2e.c
b/drivers/media/dvb-frontends/ascot2e.c
--- a/drivers/media/dvb-frontends/ascot2e.c
+++ b/drivers/media/dvb-frontends/ascot2e.c
@@ -132,7 +132,7 @@ static int ascot2e_write_regs(struct ascot2e_priv *priv,
 		}
 	};
 
-	if (len + 1 >= sizeof(buf)) {
+	if (len + 1 > sizeof(buf)) {
 		dev_warn(&priv->i2c->dev,"wr reg=%04x: len=%d is too
big!\n",
 			 reg, len + 1);
 		return -E2BIG;

Regards,
Saso Slavicic


