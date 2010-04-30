Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1797 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934240Ab0D3TGR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Apr 2010 15:06:17 -0400
Date: Fri, 30 Apr 2010 15:06:12 -0400
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Cc: linux-input@vger.kernel.org,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH v2] IR/imon: add proper auto-repeat support
Message-ID: <20100430190611.GA30308@redhat.com>
References: <20100428173700.GA14240@redhat.com>
 <20100428204112.GA6663@core.coreip.homeip.net>
 <20100428210058.GO15951@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100428210058.GO15951@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Simplified from version 1, in that hacks heisted from ati_remote2.c
aren't actually necessary, the real fix for too many repeats was
from setting too long a timer release value (200ms) on repeats in
mce mode -- this patch drops the release timeout to 33ms, matching
the input subsystem default input_dev->rep[REP_PERIOD].

Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/media/IR/imon.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/media/IR/imon.c b/drivers/media/IR/imon.c
index b65c31a..09d4e44 100644
--- a/drivers/media/IR/imon.c
+++ b/drivers/media/IR/imon.c
@@ -146,7 +146,6 @@ struct imon_context {
 };
 
 #define TOUCH_TIMEOUT	(HZ/30)
-#define MCE_TIMEOUT_MS	200
 
 /* vfd character device file operations */
 static const struct file_operations vfd_fops = {
@@ -1394,6 +1393,8 @@ static int imon_parse_press_type(struct imon_context *ictx,
 				 unsigned char *buf, u8 ktype)
 {
 	int press_type = 0;
+	int rep_delay = ictx->idev->rep[REP_DELAY];
+	int rep_period = ictx->idev->rep[REP_PERIOD];
 
 	/* key release of 0x02XXXXXX key */
 	if (ictx->kc == KEY_RESERVED && buf[0] == 0x02 && buf[3] == 0x00)
@@ -1418,12 +1419,12 @@ static int imon_parse_press_type(struct imon_context *ictx,
 			ictx->mce_toggle_bit = buf[2];
 			press_type = 1;
 			mod_timer(&ictx->itimer,
-				  jiffies + msecs_to_jiffies(MCE_TIMEOUT_MS));
+				  jiffies + msecs_to_jiffies(rep_delay));
 		/* repeat */
 		} else {
 			press_type = 2;
 			mod_timer(&ictx->itimer,
-				  jiffies + msecs_to_jiffies(MCE_TIMEOUT_MS));
+				  jiffies + msecs_to_jiffies(rep_period));
 		}
 
 	/* incoherent or irrelevant data */
@@ -1541,7 +1542,7 @@ static void imon_incoming_packet(struct imon_context *ictx,
 		do_gettimeofday(&t);
 		msec = tv2int(&t, &prev_time);
 		prev_time = t;
-		if (msec < 200)
+		if (msec < idev->rep[REP_DELAY])
 			return;
 	}
 
@@ -1686,7 +1687,7 @@ static struct input_dev *imon_init_idev(struct imon_context *ictx)
 	strlcat(ictx->phys_idev, "/input0", sizeof(ictx->phys_idev));
 	idev->phys = ictx->phys_idev;
 
-	idev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_REL);
+	idev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_REP) | BIT_MASK(EV_REL);
 
 	idev->keybit[BIT_WORD(BTN_MOUSE)] =
 		BIT_MASK(BTN_LEFT) | BIT_MASK(BTN_RIGHT);

-- 
Jarod Wilson
jarod@redhat.com

