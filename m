Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:38224 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751883AbbHaJOd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Aug 2015 05:14:33 -0400
From: Malcolm Priestley <tvboxspy@gmail.com>
To: linux-media@vger.kernel.org
Cc: Malcolm Priestley <tvboxspy@gmail.com>, klammerj@a1.net,
	<stable@vger.kernel.org>
Subject: [PATCH] media: dvb-core: Don't force CAN_INVERSION_AUTO in oneshot mode.
Date: Mon, 31 Aug 2015 10:13:45 +0100
Message-Id: <1441012425-25050-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When in FE_TUNE_MODE_ONESHOT the frontend must report
the actual capabilities so user can take appropriate
action.

With frontends that can't do auto inversion this is done
by dvb-core automatically so CAN_INVERSION_AUTO is valid.

However, when in FE_TUNE_MODE_ONESHOT this is not true.

So only set FE_CAN_INVERSION_AUTO in modes other than
FE_TUNE_MODE_ONESHOT

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
Cc: <stable@vger.kernel.org>
---
 drivers/media/dvb-core/dvb_frontend.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index c38ef1a..e2a3833 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -2313,9 +2313,9 @@ static int dvb_frontend_ioctl_legacy(struct file *file,
 		dev_dbg(fe->dvb->device, "%s: current delivery system on cache: %d, V3 type: %d\n",
 				 __func__, c->delivery_system, fe->ops.info.type);
 
-		/* Force the CAN_INVERSION_AUTO bit on. If the frontend doesn't
-		 * do it, it is done for it. */
-		info->caps |= FE_CAN_INVERSION_AUTO;
+		/* Set CAN_INVERSION_AUTO bit on in other than oneshot mode */
+		if (!(fepriv->tune_mode_flags & FE_TUNE_MODE_ONESHOT))
+			info->caps |= FE_CAN_INVERSION_AUTO;
 		err = 0;
 		break;
 	}
-- 
2.5.0

