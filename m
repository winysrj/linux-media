Return-path: <linux-media-owner@vger.kernel.org>
Received: from vader.hardeman.nu ([95.142.160.32]:41415 "EHLO hardeman.nu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932069AbdEAQKO (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 1 May 2017 12:10:14 -0400
Subject: [PATCH 4/7] rc-core: sanyo - leave the internals of rc_dev alone
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, sean@mess.org
Date: Mon, 01 May 2017 18:10:12 +0200
Message-ID: <149365501201.13489.12300860491124752633.stgit@zeus.hardeman.nu>
In-Reply-To: <149365487447.13489.15793446874818182829.stgit@zeus.hardeman.nu>
References: <149365487447.13489.15793446874818182829.stgit@zeus.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Leave repeat handling to rc-core.

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/rc/ir-sanyo-decoder.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/media/rc/ir-sanyo-decoder.c b/drivers/media/rc/ir-sanyo-decoder.c
index 520bb77dcb62..e6a906a34f90 100644
--- a/drivers/media/rc/ir-sanyo-decoder.c
+++ b/drivers/media/rc/ir-sanyo-decoder.c
@@ -110,13 +110,9 @@ static int ir_sanyo_decode(struct rc_dev *dev, struct ir_raw_event ev)
 			break;
 
 		if (!data->count && geq_margin(ev.duration, SANYO_REPEAT_SPACE, SANYO_UNIT / 2)) {
-			if (!dev->keypressed) {
-				IR_dprintk(1, "SANYO discarding last key repeat: event after key up\n");
-			} else {
-				rc_repeat(dev);
-				IR_dprintk(1, "SANYO repeat last key\n");
-				data->state = STATE_INACTIVE;
-			}
+			rc_repeat(dev);
+			IR_dprintk(1, "SANYO repeat last key\n");
+			data->state = STATE_INACTIVE;
 			return 0;
 		}
 
