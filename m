Return-path: <mchehab@gaivota>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:33742 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757201Ab0KSXoj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Nov 2010 18:44:39 -0500
Subject: [PATCH 08/10] bttv: merge ir decoding timers
To: linux-media@vger.kernel.org
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: jarod@wilsonet.com, mchehab@infradead.org
Date: Sat, 20 Nov 2010 00:43:17 +0100
Message-ID: <20101119234317.3511.48553.stgit@localhost.localdomain>
In-Reply-To: <20101119233959.3511.91287.stgit@localhost.localdomain>
References: <20101119233959.3511.91287.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Similarly to saa7134, bttv_ir has two timers, only one of which is used
at a time and which serve the same purpose. Merge them.

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/video/bt8xx/bttv-input.c |    8 +++-----
 drivers/media/video/bt8xx/bttvp.h      |    3 +--
 2 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/media/video/bt8xx/bttv-input.c b/drivers/media/video/bt8xx/bttv-input.c
index c8bf423..8013d91 100644
--- a/drivers/media/video/bt8xx/bttv-input.c
+++ b/drivers/media/video/bt8xx/bttv-input.c
@@ -283,8 +283,7 @@ static int bttv_rc5_irq(struct bttv *btv)
 		ir->base_time = tv;
 		ir->last_bit = 0;
 
-		mod_timer(&ir->timer_end,
-			  current_jiffies + msecs_to_jiffies(30));
+		mod_timer(&ir->timer, current_jiffies + msecs_to_jiffies(30));
 	}
 
 	/* toggle GPIO pin 4 to reset the irq */
@@ -303,8 +302,7 @@ static void bttv_ir_start(struct bttv *btv, struct bttv_ir *ir)
 		add_timer(&ir->timer);
 	} else if (ir->rc5_gpio) {
 		/* set timer_end for code completion */
-		setup_timer(&ir->timer_end, bttv_rc5_timer_end,
-			    (unsigned long)ir);
+		setup_timer(&ir->timer, bttv_rc5_timer_end, (unsigned long)ir);
 		ir->shift_by = 1;
 		ir->start = 3;
 		ir->addr = 0x0;
@@ -322,7 +320,7 @@ static void bttv_ir_stop(struct bttv *btv)
 	if (btv->remote->rc5_gpio) {
 		u32 gpio;
 
-		del_timer_sync(&btv->remote->timer_end);
+		del_timer_sync(&btv->remote->timer);
 		flush_scheduled_work();
 
 		gpio = bttv_gpio_read(&btv->c);
diff --git a/drivers/media/video/bt8xx/bttvp.h b/drivers/media/video/bt8xx/bttvp.h
index 3d5b2bc..0712320 100644
--- a/drivers/media/video/bt8xx/bttvp.h
+++ b/drivers/media/video/bt8xx/bttvp.h
@@ -122,6 +122,7 @@ struct bttv_format {
 
 struct bttv_ir {
 	struct rc_dev           *dev;
+	struct timer_list       timer;
 
 	char                    name[32];
 	char                    phys[32];
@@ -136,11 +137,9 @@ struct bttv_ir {
 	int                     start; // What should RC5_START() be
 	int                     addr; // What RC5_ADDR() should be.
 	int                     rc5_remote_gap;
-	struct timer_list       timer;
 
 	/* RC5 gpio */
 	u32                     rc5_gpio;
-	struct timer_list       timer_end;  /* timer_end for code completion */
 	u32                     last_bit;   /* last raw bit seen */
 	u32                     code;       /* raw code under construction */
 	struct timeval          base_time;  /* time of last seen code */

