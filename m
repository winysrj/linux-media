Return-path: <mchehab@pedra>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:38207 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221Ab1BAWky (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Feb 2011 17:40:54 -0500
Received: by mail-fx0-f46.google.com with SMTP id 20so7348272fxm.19
        for <linux-media@vger.kernel.org>; Tue, 01 Feb 2011 14:40:53 -0800 (PST)
Subject: [PATCH 2/9 v2] ds3000: decrease mpeg clock output
To: mchehab@infradead.org, linux-media@vger.kernel.org
From: "Igor M. Liplianin" <liplianin@me.by>
Date: Wed, 2 Feb 2011 00:40:17 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201102020040.18039.liplianin@me.by>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

TeVii s480 works fine with that on DVB-S2 channels

Signed-off-by: Igor M. Liplianin <liplianin@me.by>
---
 drivers/media/dvb/frontends/ds3000.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/dvb/frontends/ds3000.c b/drivers/media/dvb/frontends/ds3000.c
index 4773916..b20005c 100644
--- a/drivers/media/dvb/frontends/ds3000.c
+++ b/drivers/media/dvb/frontends/ds3000.c
@@ -1230,7 +1230,7 @@ static int ds3000_tune(struct dvb_frontend *fe,
 				ds3000_writereg(state,
 					ds3000_dvbs2_init_tab[i],
 					ds3000_dvbs2_init_tab[i + 1]);
-			ds3000_writereg(state, 0xfe, 0x54);
+			ds3000_writereg(state, 0xfe, 0x98);
 			break;
 		default:
 			return 1;
-- 
1.7.1

