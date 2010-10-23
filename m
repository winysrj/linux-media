Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:11992 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932288Ab0JWTmV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 23 Oct 2010 15:42:21 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o9NJgLp6013780
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 23 Oct 2010 15:42:21 -0400
Received: from xavier.bos.redhat.com (xavier.bos.redhat.com [10.16.16.50])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o9NJgLSL007517
	for <linux-media@vger.kernel.org>; Sat, 23 Oct 2010 15:42:21 -0400
Date: Sat, 23 Oct 2010 15:42:20 -0400
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 1/3] imon: fix my egregious brown paper bag w/rdev/idev split
Message-ID: <20101023194220.GC4825@redhat.com>
References: <20101023194107.GB4825@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101023194107.GB4825@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Somehow, I managed to screw things up when reworking the rdev/idev split
patch from David, and started trying to get ir_input_dev from idev
instead of rdev, thus resulting in button presses hanging the system.
This fixes it.

Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/media/IR/imon.c |   19 +++++++++----------
 1 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/media/IR/imon.c b/drivers/media/IR/imon.c
index 0391c3b..bcb2826 100644
--- a/drivers/media/IR/imon.c
+++ b/drivers/media/IR/imon.c
@@ -1477,7 +1477,7 @@ static void imon_incoming_packet(struct imon_context *ictx,
 	bool norelease = false;
 	int i;
 	u64 scancode;
-	struct input_dev *idev = NULL;
+	struct input_dev *rdev = NULL;
 	struct ir_input_dev *irdev = NULL;
 	int press_type = 0;
 	int msec;
@@ -1485,8 +1485,8 @@ static void imon_incoming_packet(struct imon_context *ictx,
 	static struct timeval prev_time = { 0, 0 };
 	u8 ktype;
 
-	idev = ictx->idev;
-	irdev = input_get_drvdata(idev);
+	rdev = ictx->rdev;
+	irdev = input_get_drvdata(rdev);
 
 	/* filter out junk data on the older 0xffdc imon devices */
 	if ((buf[0] == 0xff) && (buf[1] == 0xff) && (buf[2] == 0xff))
@@ -1570,8 +1570,7 @@ static void imon_incoming_packet(struct imon_context *ictx,
 		if (press_type == 0)
 			ir_keyup(irdev);
 		else {
-			ir_keydown(ictx->rdev, ictx->rc_scancode,
-				   ictx->rc_toggle);
+			ir_keydown(rdev, ictx->rc_scancode, ictx->rc_toggle);
 			spin_lock_irqsave(&ictx->kc_lock, flags);
 			ictx->last_keycode = ictx->kc;
 			spin_unlock_irqrestore(&ictx->kc_lock, flags);
@@ -1587,7 +1586,7 @@ static void imon_incoming_packet(struct imon_context *ictx,
 		do_gettimeofday(&t);
 		msec = tv2int(&t, &prev_time);
 		prev_time = t;
-		if (msec < idev->rep[REP_DELAY]) {
+		if (msec < ictx->idev->rep[REP_DELAY]) {
 			spin_unlock_irqrestore(&ictx->kc_lock, flags);
 			return;
 		}
@@ -1596,12 +1595,12 @@ static void imon_incoming_packet(struct imon_context *ictx,
 
 	spin_unlock_irqrestore(&ictx->kc_lock, flags);
 
-	input_report_key(idev, kc, press_type);
-	input_sync(idev);
+	input_report_key(ictx->idev, kc, press_type);
+	input_sync(ictx->idev);
 
 	/* panel keys don't generate a release */
-	input_report_key(idev, kc, 0);
-	input_sync(idev);
+	input_report_key(ictx->idev, kc, 0);
+	input_sync(ictx->idev);
 
 	ictx->last_keycode = kc;
 
-- 
1.7.2.3

-- 
Jarod Wilson
jarod@redhat.com

