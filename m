Return-path: <linux-media-owner@vger.kernel.org>
Received: from vader.hardeman.nu ([95.142.160.32]:41411 "EHLO hardeman.nu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932069AbdEAQKI (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 1 May 2017 12:10:08 -0400
Subject: [PATCH 3/7] rc-core: img-nec-decoder - leave the internals of
 rc_dev alone
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, sean@mess.org
Date: Mon, 01 May 2017 18:10:06 +0200
Message-ID: <149365500692.13489.9572857464621441673.stgit@zeus.hardeman.nu>
In-Reply-To: <149365487447.13489.15793446874818182829.stgit@zeus.hardeman.nu>
References: <149365487447.13489.15793446874818182829.stgit@zeus.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Obvious fix, leave repeat handling to rc-core

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/rc/ir-nec-decoder.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/media/rc/ir-nec-decoder.c b/drivers/media/rc/ir-nec-decoder.c
index 3ce850314dca..75b9137f6faf 100644
--- a/drivers/media/rc/ir-nec-decoder.c
+++ b/drivers/media/rc/ir-nec-decoder.c
@@ -88,13 +88,9 @@ static int ir_nec_decode(struct rc_dev *dev, struct ir_raw_event ev)
 			data->state = STATE_BIT_PULSE;
 			return 0;
 		} else if (eq_margin(ev.duration, NEC_REPEAT_SPACE, NEC_UNIT / 2)) {
-			if (!dev->keypressed) {
-				IR_dprintk(1, "Discarding last key repeat: event after key up\n");
-			} else {
-				rc_repeat(dev);
-				IR_dprintk(1, "Repeat last key\n");
-				data->state = STATE_TRAILER_PULSE;
-			}
+			rc_repeat(dev);
+			IR_dprintk(1, "Repeat last key\n");
+			data->state = STATE_TRAILER_PULSE;
 			return 0;
 		}
 
