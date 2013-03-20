Return-path: <linux-media-owner@vger.kernel.org>
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:18943 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751725Ab3CTNna (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Mar 2013 09:43:30 -0400
Date: Wed, 20 Mar 2013 14:43:21 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Linux Media <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [media] drxk_hard: Drop unused parameter
Message-ID: <20130320144321.1095091f@endymion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Last parameter of function GetLockStatus() isn't used so drop it.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb-frontends/drxk_hard.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- linux-3.8.orig/drivers/media/dvb-frontends/drxk_hard.c	2013-02-19 00:58:34.000000000 +0100
+++ linux-3.8/drivers/media/dvb-frontends/drxk_hard.c	2013-03-07 09:38:36.116748279 +0100
@@ -1947,8 +1947,7 @@ static int ShutDown(struct drxk_state *s
 	return 0;
 }
 
-static int GetLockStatus(struct drxk_state *state, u32 *pLockStatus,
-			 u32 Time)
+static int GetLockStatus(struct drxk_state *state, u32 *pLockStatus)
 {
 	int status = -EINVAL;
 
@@ -6398,7 +6397,7 @@ static int drxk_read_status(struct dvb_f
 		return -EAGAIN;
 
 	*status = 0;
-	GetLockStatus(state, &stat, 0);
+	GetLockStatus(state, &stat);
 	if (stat == MPEG_LOCK)
 		*status |= 0x1f;
 	if (stat == FEC_LOCK)


-- 
Jean Delvare
