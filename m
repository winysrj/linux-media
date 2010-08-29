Return-path: <mchehab@pedra>
Received: from ozlabs.org ([203.10.76.45]:50739 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750727Ab0H2GlX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Aug 2010 02:41:23 -0400
Date: Sun, 29 Aug 2010 16:40:36 +1000
From: Anton Blanchard <anton@samba.org>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
	David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
Cc: linux-media@vger.kernel.org
Subject: IR code autorepeat issue?
Message-ID: <20100829064036.GB22853@kryten>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>


I'm seeing double IR events on 2.6.36-rc2 and a DViCO FusionHDTV DVB-T Dual
Express. I enabled some debug and it looks like we are only getting one IR
event from the device as expected:

[ 1351.032084] ir_keydown: i2c IR (FusionHDTV): key down event, key 0x0067, scancode 0x0051
[ 1351.281284] ir_keyup: keyup key 0x0067

ie one key down event and one key up event 250ms later. I wonder if the input
layer software autorepeat is the culprit. It seems to set autorepeat to start
at 250ms:

        /*
         * If delay and period are pre-set by the driver, then autorepeating
         * is handled by the driver itself and we don't do it in input.c.
         */
        init_timer(&dev->timer);
        if (!dev->rep[REP_DELAY] && !dev->rep[REP_PERIOD]) {
                dev->timer.data = (long) dev;
                dev->timer.function = input_repeat_key;
                dev->rep[REP_DELAY] = 250;
                dev->rep[REP_PERIOD] = 33;
        }

If I shorten the IR key up events to 100ms via the patch below the problem
goes away. I guess the other option would be to initialise REP_DELAY and
REP_PERIOD so the input layer autorepeat doesn't cut in at all. Thoughts?

Anton
--

diff --git a/drivers/media/IR/ir-keytable.c b/drivers/media/IR/ir-keytable.c
index 7e82a9d..cf44d5a 100644
--- a/drivers/media/IR/ir-keytable.c
+++ b/drivers/media/IR/ir-keytable.c
@@ -22,7 +22,7 @@
 #define IR_TAB_MAX_SIZE	8192
 
 /* FIXME: IR_KEYPRESS_TIMEOUT should be protocol specific */
-#define IR_KEYPRESS_TIMEOUT 250
+#define IR_KEYPRESS_TIMEOUT 100
 
