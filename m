Return-path: <mchehab@gaivota>
Received: from mx1.redhat.com ([209.132.183.28]:42862 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753586Ab1AFUAR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 6 Jan 2011 15:00:17 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id p06K0GvN013548
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 6 Jan 2011 15:00:17 -0500
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Cc: Jarod Wilson <jarod@redhat.com>
Subject: [PATCH 6/6] rc/mceusb: timeout should be in ns, not us
Date: Thu,  6 Jan 2011 14:59:37 -0500
Message-Id: <1294343977-31929-7-git-send-email-jarod@redhat.com>
In-Reply-To: <1294343839-31784-1-git-send-email-jarod@redhat.com>
References: <1294343839-31784-1-git-send-email-jarod@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Fixes an egregious bug in mceusb driver, where the receiver was being
put into idle mode far sooner than it should have, thanks to storing a
timeout value that in us where it should be ns. Basically, the receiver
kept going into idle mode before a trailing space had been fully
received, which was causing problems for some protocols, most notably
manifesting as lirc userspace never receiving a trailing space for any
rc5 signals.

Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/media/rc/mceusb.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/rc/mceusb.c b/drivers/media/rc/mceusb.c
index 2d91134..079353e 100644
--- a/drivers/media/rc/mceusb.c
+++ b/drivers/media/rc/mceusb.c
@@ -816,7 +816,7 @@ static void mceusb_handle_command(struct mceusb_dev *ir, int index)
 	switch (ir->buf_in[index]) {
 	/* 2-byte return value commands */
 	case MCE_CMD_S_TIMEOUT:
-		ir->rc->timeout = MS_TO_US((hi << 8 | lo) / 2);
+		ir->rc->timeout = MS_TO_NS((hi << 8 | lo) / 2);
 		break;
 
 	/* 1-byte return value commands */
@@ -1060,7 +1060,7 @@ static struct rc_dev *mceusb_init_rc_dev(struct mceusb_dev *ir)
 	rc->priv = ir;
 	rc->driver_type = RC_DRIVER_IR_RAW;
 	rc->allowed_protos = RC_TYPE_ALL;
-	rc->timeout = MS_TO_US(1000);
+	rc->timeout = MS_TO_NS(1000);
 	if (!ir->flags.no_tx) {
 		rc->s_tx_mask = mceusb_set_tx_mask;
 		rc->s_tx_carrier = mceusb_set_tx_carrier;
-- 
1.7.3.4

