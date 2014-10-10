Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.uli-eckhardt.de ([85.214.28.137]:36910 "EHLO
	mail.uli-eckhardt.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751732AbaJJQ1f (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Oct 2014 12:27:35 -0400
Message-ID: <543808F4.1010500@uli-eckhardt.de>
Date: Fri, 10 Oct 2014 18:27:32 +0200
From: Ulrich Eckhardt <uli-lirc@uli-eckhardt.de>
MIME-Version: 1.0
To: m.chehab@samsung.com
CC: jarod@wilsonet.com, linux-media@vger.kernel.org
Subject: [PATCH][media] imon: infrared control stopped working in kernel 3.17
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

with kernel 3.17 the imon remote control for device 15c2:0034 (built into the
Thermaltake DH102) does not work anymore, only the front panel buttons.

I digged through the changes made for imon.c and found the problem in
the following part of the commit 120703f9eb32033f0e39bdc552c0273c8ab45f33:

@@ -1579,7 +1579,10 @@ static void imon_incoming_packet(struct 
imon_context *ictx,
  		if (press_type == 0)
  			rc_keyup(ictx->rdev);
  		else {
-			rc_keydown(ictx->rdev, ictx->rc_scancode, ictx->rc_toggle);
+			if (ictx->rc_type == RC_BIT_RC6_MCE)
+				rc_keydown(ictx->rdev,
+					   ictx->rc_type == RC_BIT_RC6_MCE ? RC_TYPE_RC6_MCE : RC_TYPE_OTHER,
+					   ictx->rc_scancode, ictx->rc_toggle);
  			spin_lock_irqsave(&ictx->kc_lock, flags);
  			ictx->last_keycode = ictx->kc;
  			spin_unlock_irqrestore(&ictx->kc_lock, flags);

The if statement around rc_keydown handles only the RC6 protocol,
but the remote control is send via the RC_TYPE_OTHER protocol.

The following patch fixes this problem:

-----------------------------------------------------------------

With kernel 3.17 the imon remote control for device 15c2:0034 does not work anymore,
which uses the OTHER protocol. Only the front panel buttons which uses the RC6
protocol are working. This patch adds the missing comparison for the RC_BIT_OTHER.

Signed-off-by: Ulrich Eckhardt <uli@uli-eckhardt.de>

diff --git a/drivers/media/rc/imon.c b/drivers/media/rc/imon.c
--- a/drivers/media/rc/imon.c
+++ b/drivers/media/rc/imon.c
@@ -1579,7 +1579,8 @@
                if (press_type == 0)
                        rc_keyup(ictx->rdev);
                else {
-                       if (ictx->rc_type == RC_BIT_RC6_MCE)
+                       if (ictx->rc_type == RC_BIT_RC6_MCE ||
+                           ictx->rc_type == RC_BIT_OTHER)
                                rc_keydown(ictx->rdev,
                                           ictx->rc_type == RC_BIT_RC6_MCE ? RC_TYPE_RC6_MCE : RC_TYPE_OTHER,
                                           ictx->rc_scancode, ictx->rc_toggle);




------------------------------------------------------------------

Best Regards
Uli
-- 
Ulrich Eckhardt                  http://www.uli-eckhardt.de

Ein Blitzableiter auf dem Kirchturm ist das denkbar stärkste 
Misstrauensvotum gegen den lieben Gott. (Karl Krauss)
