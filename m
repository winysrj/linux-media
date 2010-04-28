Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:14993 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753349Ab0D1RhC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Apr 2010 13:37:02 -0400
Date: Wed, 28 Apr 2010 13:37:00 -0400
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Cc: linux-input@vger.kernel.org
Subject: [PATCH] IR/imon: add proper auto-repeat support
Message-ID: <20100428173700.GA14240@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Set the EV_REP bit, so reported key repeats actually make their
way out to userspace, and fix up the handling of repeats a bit,
routines for which are shamelessly heisted from ati_remote2.c.

Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/media/IR/imon.c |   38 +++++++++++++++++++++++++++++++-------
 1 files changed, 31 insertions(+), 7 deletions(-)

diff --git a/drivers/media/IR/imon.c b/drivers/media/IR/imon.c
index b65c31a..16e2e7f 100644
--- a/drivers/media/IR/imon.c
+++ b/drivers/media/IR/imon.c
@@ -130,6 +130,7 @@ struct imon_context {
 	u64 ir_type;			/* iMON or MCE (RC6) IR protocol? */
 	u8 mce_toggle_bit;		/* last mce toggle bit */
 	bool release_code;		/* some keys send a release code */
+	unsigned long jiffies;		/* repeat timer */
 
 	u8 display_type;		/* store the display type */
 	bool pad_mouse;			/* toggle kbd(0)/mouse(1) mode */
@@ -146,7 +147,6 @@ struct imon_context {
 };
 
 #define TOUCH_TIMEOUT	(HZ/30)
-#define MCE_TIMEOUT_MS	200
 
 /* vfd character device file operations */
 static const struct file_operations vfd_fops = {
@@ -1394,6 +1394,8 @@ static int imon_parse_press_type(struct imon_context *ictx,
 				 unsigned char *buf, u8 ktype)
 {
 	int press_type = 0;
+	int rep_delay = ictx->idev->rep[REP_DELAY];
+	int rep_period = ictx->idev->rep[REP_PERIOD];
 
 	/* key release of 0x02XXXXXX key */
 	if (ictx->kc == KEY_RESERVED && buf[0] == 0x02 && buf[3] == 0x00)
@@ -1418,12 +1420,12 @@ static int imon_parse_press_type(struct imon_context *ictx,
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
@@ -1458,12 +1460,14 @@ static void imon_incoming_packet(struct imon_context *ictx,
 	u32 remote_key = 0;
 	struct input_dev *idev = NULL;
 	int press_type = 0;
-	int msec;
+	int msec, rep_delay, rep_period;
 	struct timeval t;
 	static struct timeval prev_time = { 0, 0 };
 	u8 ktype = IMON_KEY_IMON;
 
 	idev = ictx->idev;
+	rep_delay = idev->rep[REP_DELAY];
+	rep_period = idev->rep[REP_PERIOD];
 
 	/* filter out junk data on the older 0xffdc imon devices */
 	if ((buf[0] == 0xff) && (buf[7] == 0xff))
@@ -1529,8 +1533,28 @@ static void imon_incoming_packet(struct imon_context *ictx,
 	}
 
 	press_type = imon_parse_press_type(ictx, buf, ktype);
-	if (press_type < 0)
+
+	switch (press_type) {
+	/* release */
+	case 0:
+		break;
+	/* press */
+	case 1:
+		ictx->jiffies = jiffies + msecs_to_jiffies(rep_delay);
+		break;
+	/* repeat */
+	case 2:
+		/* don't repeat too fast */
+		if (!time_after_eq(jiffies, ictx->jiffies))
+			return;
+
+		ictx->jiffies = jiffies + msecs_to_jiffies(rep_period);
+		break;
+	case -EINVAL:
+	default:
 		goto not_input_data;
+		break;
+	}
 
 	if (ictx->kc == KEY_UNKNOWN)
 		goto unknown_key;
@@ -1541,7 +1565,7 @@ static void imon_incoming_packet(struct imon_context *ictx,
 		do_gettimeofday(&t);
 		msec = tv2int(&t, &prev_time);
 		prev_time = t;
-		if (msec < 200)
+		if (msec < rep_delay)
 			return;
 	}
 
@@ -1686,7 +1710,7 @@ static struct input_dev *imon_init_idev(struct imon_context *ictx)
 	strlcat(ictx->phys_idev, "/input0", sizeof(ictx->phys_idev));
 	idev->phys = ictx->phys_idev;
 
-	idev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_REL);
+	idev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_REP) | BIT_MASK(EV_REL);
 
 	idev->keybit[BIT_WORD(BTN_MOUSE)] =
 		BIT_MASK(BTN_LEFT) | BIT_MASK(BTN_RIGHT);

-- 
Jarod Wilson
jarod@redhat.com

