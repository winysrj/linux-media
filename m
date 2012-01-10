Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:47799 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751552Ab2AJXpk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Jan 2012 18:45:40 -0500
Received: by wgbdr10 with SMTP id dr10so163096wgb.1
        for <linux-media@vger.kernel.org>; Tue, 10 Jan 2012 15:45:39 -0800 (PST)
Message-ID: <1326239131.2956.3.camel@tvbox>
Subject: [PATCH][BUG] it913x-fe fix typo error making SNR levels unstable.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: linux-media@vger.kernel.org
Date: Tue, 10 Jan 2012 23:45:31 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Fix error where SNR unstable and jumps levels.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/media/dvb/frontends/it913x-fe.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/dvb/frontends/it913x-fe.c b/drivers/media/dvb/frontends/it913x-fe.c
index 7290801..ccc36bf 100644
--- a/drivers/media/dvb/frontends/it913x-fe.c
+++ b/drivers/media/dvb/frontends/it913x-fe.c
@@ -525,7 +525,7 @@ static int it913x_fe_read_snr(struct dvb_frontend *fe, u16 *snr)
 
 	ret = it913x_read_reg(state, 0x2c, reg, sizeof(reg));
 
-	snr_val = (u32)(reg[2] << 16) | (reg[1] < 8) | reg[0];
+	snr_val = (u32)(reg[2] << 16) | (reg[1] << 8) | reg[0];
 
 	ret |= it913x_read_reg(state, 0xf78b, reg, 1);
 	if (reg[0])
-- 
1.7.7.3


