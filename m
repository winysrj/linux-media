Return-path: <mchehab@gaivota>
Received: from skyboo.net ([82.160.187.4]:36688 "EHLO skyboo.net"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753937Ab0L2Wsz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Dec 2010 17:48:55 -0500
Message-ID: <4D1BBACB.9020502@skyboo.net>
Date: Wed, 29 Dec 2010 23:48:43 +0100
From: =?UTF-8?B?TWFyaXVzeiBCaWHFgm/FhGN6eWs=?= <manio@skyboo.net>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: linux-media@vger.kernel.org
References: <4D17816B.2050500@skyboo.net> <4D187D96.5060303@redhat.com>
In-Reply-To: <4D187D96.5060303@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: [PATCH] ir-nec-decoder: fix repeat key issue
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Fixing the problem with NEC protocol and repeating keys under the following
circumstances. The problem occurs when there is a repeat code without
properly decoded scancode. This leads to repeat the wrong (last decoded)
scancode.

An example from real life:
I am pressing volume down, then several minutes later i am pressing
volume up, but the real scancode is wrongly decoded and only a repeat
event is emitted, so as a result volume is going down while i am holding
volume up button.

The patch fixes above problem using rc_keyup timeout (as pointed by Mauro).
It just prevents key repeats if they appear after rc_keyup.

Signed-off-by: Mariusz Białończyk <manio@skyboo.net>
---
The patch is created against staging/for_v2.6.38.

 drivers/media/rc/ir-nec-decoder.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/media/rc/ir-nec-decoder.c b/drivers/media/rc/ir-nec-decoder.c
index 5d15c31..7b58b4a 100644
--- a/drivers/media/rc/ir-nec-decoder.c
+++ b/drivers/media/rc/ir-nec-decoder.c
@@ -88,9 +88,13 @@ static int ir_nec_decode(struct rc_dev *dev, struct ir_raw_event ev)
 			data->state = STATE_BIT_PULSE;
 			return 0;
 		} else if (eq_margin(ev.duration, NEC_REPEAT_SPACE, NEC_UNIT / 2)) {
-			rc_repeat(dev);
-			IR_dprintk(1, "Repeat last key\n");
-			data->state = STATE_TRAILER_PULSE;
+			if (!dev->keypressed) {
+				IR_dprintk(1, "Discarding last key repeat: event after key up\n");
+			} else {
+				rc_repeat(dev);
+				IR_dprintk(1, "Repeat last key\n");
+				data->state = STATE_TRAILER_PULSE;
+			}
 			return 0;
 		}
 
-- 
Mariusz Białończyk
jabber/e-mail: manio@skyboo.net
http://manio.skyboo.net
