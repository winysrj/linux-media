Return-path: <linux-media-owner@vger.kernel.org>
Received: from pequod.mess.org ([93.97.41.153]:34956 "EHLO pequod.mess.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755266Ab2GaKhg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 31 Jul 2012 06:37:36 -0400
From: Sean Young <sean@mess.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Jarod Wilson <jarod@wilsonet.com>, linux-media@vger.kernel.org
Cc: lirc-list@lists.sourceforge.net, Sean Young <sean@mess.org>
Subject: [PATCH] [media] nec-decoder: fix NEC decoding for Pioneer Laserdisc CU-700 remote
Date: Tue, 31 Jul 2012 11:37:29 +0100
Message-Id: <1343731049-9856-1-git-send-email-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This remote sends a header pulse of 8150us followed by a space of 4000us.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/ir-nec-decoder.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/rc/ir-nec-decoder.c b/drivers/media/rc/ir-nec-decoder.c
index 3c9431a..2ca509e 100644
--- a/drivers/media/rc/ir-nec-decoder.c
+++ b/drivers/media/rc/ir-nec-decoder.c
@@ -70,7 +70,7 @@ static int ir_nec_decode(struct rc_dev *dev, struct ir_raw_event ev)
 		if (!ev.pulse)
 			break;
 
-		if (eq_margin(ev.duration, NEC_HEADER_PULSE, NEC_UNIT / 2)) {
+		if (eq_margin(ev.duration, NEC_HEADER_PULSE, NEC_UNIT * 2)) {
 			data->is_nec_x = false;
 			data->necx_repeat = false;
 		} else if (eq_margin(ev.duration, NECX_HEADER_PULSE, NEC_UNIT / 2))
@@ -86,7 +86,7 @@ static int ir_nec_decode(struct rc_dev *dev, struct ir_raw_event ev)
 		if (ev.pulse)
 			break;
 
-		if (eq_margin(ev.duration, NEC_HEADER_SPACE, NEC_UNIT / 2)) {
+		if (eq_margin(ev.duration, NEC_HEADER_SPACE, NEC_UNIT)) {
 			data->state = STATE_BIT_PULSE;
 			return 0;
 		} else if (eq_margin(ev.duration, NEC_REPEAT_SPACE, NEC_UNIT / 2)) {
-- 
1.7.11.2

