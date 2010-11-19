Return-path: <mchehab@gaivota>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:33746 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757201Ab0KSXol (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Nov 2010 18:44:41 -0500
Subject: [PATCH 04/10] saa7134: merge saa7134_card_ir->timer and
	saa7134_card_ir->timer_end
To: linux-media@vger.kernel.org
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: jarod@wilsonet.com, mchehab@infradead.org
Date: Sat, 20 Nov 2010 00:42:57 +0100
Message-ID: <20101119234256.3511.56046.stgit@localhost.localdomain>
In-Reply-To: <20101119233959.3511.91287.stgit@localhost.localdomain>
References: <20101119233959.3511.91287.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Both timers are used for a similar purpose. Merging them allows for some
minor simplifications.

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/video/saa7134/saa7134-input.c |   10 ++++------
 drivers/media/video/saa7134/saa7134.h       |    1 -
 2 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/media/video/saa7134/saa7134-input.c b/drivers/media/video/saa7134/saa7134-input.c
index d75c307..98678d9 100644
--- a/drivers/media/video/saa7134/saa7134-input.c
+++ b/drivers/media/video/saa7134/saa7134-input.c
@@ -420,11 +420,11 @@ static int __saa7134_ir_start(void *priv)
 	if (ir->polling) {
 		setup_timer(&ir->timer, saa7134_input_timer,
 			    (unsigned long)dev);
-		ir->timer.expires  = jiffies + HZ;
+		ir->timer.expires = jiffies + HZ;
 		add_timer(&ir->timer);
 	} else if (ir->raw_decode) {
 		/* set timer_end for code completion */
-		setup_timer(&ir->timer_end, ir_raw_decode_timer_end,
+		setup_timer(&ir->timer, ir_raw_decode_timer_end,
 			    (unsigned long)dev);
 	}
 
@@ -443,10 +443,8 @@ static void __saa7134_ir_stop(void *priv)
 	if (!ir->running)
 		return;
 
-	if (ir->polling)
+	if (ir->polling || ir->raw_decode)
 		del_timer_sync(&ir->timer);
-	else if (ir->raw_decode)
-		del_timer_sync(&ir->timer_end);
 
 	ir->active = false;
 	ir->running = false;
@@ -923,7 +921,7 @@ static int saa7134_raw_decode_irq(struct saa7134_dev *dev)
 	 */
 	if (!ir->active) {
 		timeout = jiffies + jiffies_to_msecs(15);
-		mod_timer(&ir->timer_end, timeout);
+		mod_timer(&ir->timer, timeout);
 		ir->active = true;
 	}
 
diff --git a/drivers/media/video/saa7134/saa7134.h b/drivers/media/video/saa7134/saa7134.h
index f93951a..babfbe7 100644
--- a/drivers/media/video/saa7134/saa7134.h
+++ b/drivers/media/video/saa7134/saa7134.h
@@ -134,7 +134,6 @@ struct saa7134_card_ir {
 	bool			active;
 
 	struct timer_list       timer;
-	struct timer_list	timer_end;    /* timer_end for code completion */
 
 	/* IR core raw decoding */
 	u32                     raw_decode;

