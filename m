Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:40263 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757603Ab2ENUoP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 May 2012 16:44:15 -0400
Received: by wgbdr13 with SMTP id dr13so5081079wgb.1
        for <linux-media@vger.kernel.org>; Mon, 14 May 2012 13:44:14 -0700 (PDT)
Message-ID: <1337028230.5696.5.camel@router7789>
Subject: [PATCH] m88rs2000 - only flip bit 2 on reg 0x70 on 16th try
From: Malcolm Priestley <tvboxspy@gmail.com>
To: linux-media@vger.kernel.org
Cc: "Igor M. Liplianin" <liplianin@me.by>
Date: Mon, 14 May 2012 21:43:50 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Continuous flip of bit2 reg 0x70 can cause device to become unresponsive.

Also correct reg read mistake.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/media/dvb/frontends/m88rs2000.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb/frontends/m88rs2000.c b/drivers/media/dvb/frontends/m88rs2000.c
index 045ee5a..c9ab2ce 100644
--- a/drivers/media/dvb/frontends/m88rs2000.c
+++ b/drivers/media/dvb/frontends/m88rs2000.c
@@ -772,13 +772,13 @@ static int m88rs2000_set_frontend(struct dvb_frontend *fe)
 		return -ENODEV;
 
 	for (i = 0; i < 25; i++) {
-		u8 reg = m88rs2000_demod_read(state, 0x8c);
+		reg = m88rs2000_demod_read(state, 0x8c);
 		if ((reg & 0x7) == 0x7) {
 			status = FE_HAS_LOCK;
 			break;
 		}
 		state->no_lock_count++;
-		if (state->no_lock_count > 15) {
+		if (state->no_lock_count == 15) {
 			reg = m88rs2000_demod_read(state, 0x70);
 			reg ^= 0x4;
 			m88rs2000_demod_write(state, 0x70, reg);
-- 
1.7.9.5


