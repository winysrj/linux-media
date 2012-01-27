Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:55259 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502Ab2A0USl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Jan 2012 15:18:41 -0500
Received: by werb13 with SMTP id b13so1558381wer.19
        for <linux-media@vger.kernel.org>; Fri, 27 Jan 2012 12:18:40 -0800 (PST)
Message-ID: <4f23069f.6750b40a.1574.17f1@mx.google.com>
Subject: [PATCH 2/3] m88rs2000 - Remove +1 added to frequencies less than
 1060000kHz
From: Malcolm Priestley <tvboxspy@gmail.com>
To: linux-media@vger.kernel.org
Date: Fri, 27 Jan 2012 20:18:33 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This was added when a small error appeared in the upper end
frequencies in an old calculation.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/media/dvb/frontends/m88rs2000.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/media/dvb/frontends/m88rs2000.c b/drivers/media/dvb/frontends/m88rs2000.c
index 9d29b40..033b89d 100644
--- a/drivers/media/dvb/frontends/m88rs2000.c
+++ b/drivers/media/dvb/frontends/m88rs2000.c
@@ -516,7 +516,6 @@ static int m88rs2000_set_tuner(struct dvb_frontend *fe)
 		freq += c->frequency - 493000;
 		freq /= 1000;
 		freq *= 2;
-		freq += 1;
 		lo |= 0x10;
 	} else {
 		freq = c->frequency - 986000;
-- 
1.7.5.4



