Return-path: <linux-media-owner@vger.kernel.org>
Received: from 25.mail-out.ovh.net ([91.121.27.228]:55055 "HELO
	25.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752127Ab0EFME6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 May 2010 08:04:58 -0400
Message-ID: <1bc22666c5df5b6abebb23a35b3e666b.squirrel@webmail.ovh.net>
Date: Thu, 6 May 2010 07:04:56 -0500 (GMT+5)
Subject: [PATCH] tda10048: fix bitmask for the transmission mode
From: "Guillaume Audirac" <guillaume.audirac@webag.fr>
To: linux-media@vger.kernel.org
Reply-To: guillaume.audirac@webag.fr
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,


Add a missing bit for reading the transmission mode (2K/8K) in
tda10048_get_tps

Signed-off-by: Guillaume Audirac <guillaume.audirac@webag.fr>
---
 drivers/media/dvb/frontends/tda10048.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/dvb/frontends/tda10048.c
b/drivers/media/dvb/frontends/tda10048.c
index 9006107..9a0ba30 100644
--- a/drivers/media/dvb/frontends/tda10048.c
+++ b/drivers/media/dvb/frontends/tda10048.c
@@ -689,7 +689,7 @@ static int tda10048_get_tps(struct tda10048_state *state,
 		p->guard_interval =  GUARD_INTERVAL_1_4;
 		break;
 	}
-	switch (val & 0x02) {
+	switch (val & 0x03) {
 	case 0:
 		p->transmission_mode = TRANSMISSION_MODE_2K;
 		break;
-- 
1.6.3.3

-- 
Guillaume

