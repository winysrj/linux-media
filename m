Return-path: <linux-media-owner@vger.kernel.org>
Received: from serv03.imset.org ([176.31.106.97]:43500 "EHLO serv03.imset.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757577AbaFSIZc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Jun 2014 04:25:32 -0400
Message-ID: <53A29E79.2000304@dest-unreach.be>
Date: Thu, 19 Jun 2014 10:25:29 +0200
From: Niels Laukens <niels@dest-unreach.be>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org
CC: James Hogan <james.hogan@imgtec.com>,
	=?ISO-8859-1?Q?David_H=E4rdem?= =?ISO-8859-1?Q?an?=
	<david@hardeman.nu>,
	=?ISO-8859-1?Q?Antti_Sepp=E4l?= =?ISO-8859-1?Q?=E4?=
	<a.seppala@gmail.com>
Subject: [PATCH 1/2] drivers/media/rc/ir-nec-decode : add toggle feature
References: <53A29E5A.9030304@dest-unreach.be>
In-Reply-To: <53A29E5A.9030304@dest-unreach.be>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>From 83aa9f9fa0eaf9eb8005af49f5ce93d24a0b9f2e Mon Sep 17 00:00:00 2001
From: Niels Laukens <niels.laukens@vrt.be>
Date: Thu, 19 Jun 2014 10:05:11 +0200
Subject: [PATCH 1/2] drivers/media/rc/ir-nec-decode : add toggle feature (1/2)

Made the distinction between repeated key presses, and a single long
press. The NEC-protocol does not have a toggle-bit (cfr RC5/RC6), but
has specific repeat-codes.

This patch identifies a repeat code, and skips the scancode calculations
and the rc_keydown() in that case. In the case of a full code, it makes
sure that the rc_keydown() is regarded as a new event by using the
toggle feature.

Signed-off-by: Niels Laukens <niels@dest-unreach.be>
---
 drivers/media/rc/ir-nec-decoder.c | 7 ++++++-
 drivers/media/rc/rc-core-priv.h   | 1 +
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/media/rc/ir-nec-decoder.c b/drivers/media/rc/ir-nec-decoder.c
index 35c42e5..1f2482a 100644
--- a/drivers/media/rc/ir-nec-decoder.c
+++ b/drivers/media/rc/ir-nec-decoder.c
@@ -79,6 +79,7 @@ static int ir_nec_decode(struct rc_dev *dev, struct ir_raw_event ev)
 			break;
 
 		data->count = 0;
+		data->nec_repeat = false;
 		data->state = STATE_HEADER_SPACE;
 		return 0;
 
@@ -93,6 +94,7 @@ static int ir_nec_decode(struct rc_dev *dev, struct ir_raw_event ev)
 			if (!dev->keypressed) {
 				IR_dprintk(1, "Discarding last key repeat: event after key up\n");
 			} else {
+				data->nec_repeat = true;
 				rc_repeat(dev);
 				IR_dprintk(1, "Repeat last key\n");
 				data->state = STATE_TRAILER_PULSE;
@@ -158,6 +160,7 @@ static int ir_nec_decode(struct rc_dev *dev, struct ir_raw_event ev)
 		if (!geq_margin(ev.duration, NEC_TRAILER_SPACE, NEC_UNIT / 2))
 			break;
 
+		if (!data->nec_repeat) {
 		address     = bitrev8((data->bits >> 24) & 0xff);
 		not_address = bitrev8((data->bits >> 16) & 0xff);
 		command	    = bitrev8((data->bits >>  8) & 0xff);
@@ -189,7 +192,9 @@ static int ir_nec_decode(struct rc_dev *dev, struct ir_raw_event ev)
 		if (data->is_nec_x)
 			data->necx_repeat = true;
 
-		rc_keydown(dev, scancode, 0);
+		rc_keydown(dev, scancode, !dev->last_toggle);
+		}
+
 		data->state = STATE_INACTIVE;
 		return 0;
 	}
diff --git a/drivers/media/rc/rc-core-priv.h b/drivers/media/rc/rc-core-priv.h
index da536c9..37f3b74 100644
--- a/drivers/media/rc/rc-core-priv.h
+++ b/drivers/media/rc/rc-core-priv.h
@@ -49,6 +49,7 @@ struct ir_raw_event_ctrl {
 		u32 bits;
 		bool is_nec_x;
 		bool necx_repeat;
+		bool nec_repeat;
 	} nec;
 	struct rc5_dec {
 		int state;
-- 
1.8.5.2 (Apple Git-48)


