Return-path: <linux-media-owner@vger.kernel.org>
Received: from TYO200.gate.nec.co.jp ([210.143.35.50]:61350 "EHLO
	tyo200.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759896AbbJIAg7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Oct 2015 20:36:59 -0400
Received: from tyo202.gate.nec.co.jp ([10.7.69.202])
	by tyo200.gate.nec.co.jp (8.13.8/8.13.4) with ESMTP id t990awhm022431
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Fri, 9 Oct 2015 09:36:58 +0900 (JST)
From: Kosuke Tatsukawa <tatsu@ab.jp.nec.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] media: fix waitqueue_active without memory barrier in cpia2
 driver
Date: Fri, 9 Oct 2015 00:35:40 +0000
Message-ID: <17EC94B0A072C34B8DCF0D30AD16044A02874762@BPXM09GP.gisp.nec.co.jp>
Content-Language: ja-JP
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

cpia2_usb_disconnect() seems to be missing a memory barrier which might
cause the waker to not notice the waiter and miss sending a wake_up as
in the following figure.

	cpia2_usb_disconnect			sync
------------------------------------------------------------------------
					mutex_unlock(&cam->v4l2_lock);
if (waitqueue_active(&cam->wq_stream))
/* The CPU might reorder the test for
   the waitqueue up here, before
   prior writes complete */
					/* wait_event_interruptible */
					 /* __wait_event_interruptible */
					  /* ___wait_event */
					  long __int = prepare_to_wait_event(
					    &wq, &__wait, state);
					  if (!cam->streaming ||
					    frame->status == FRAME_READY)
cam->curbuff->status = FRAME_READY;
cam->curbuff->length = 0;
					  schedule()
------------------------------------------------------------------------

The attached patch removes the call to waitqueue_active() leaving just
wake_up() behind.  This fixes the problem because the call to
spin_lock_irqsave() in wake_up() will be an ACQUIRE operation.

I found this issue when I was looking through the linux source code
for places calling waitqueue_active() before wake_up*(), but without
preceding memory barriers, after sending a patch to fix a similar
issue in drivers/tty/n_tty.c  (Details about the original issue can be
found here: https://lkml.org/lkml/2015/9/28/849).

Signed-off-by: Kosuke Tatsukawa <tatsu@ab.jp.nec.com>
---
 drivers/media/usb/cpia2/cpia2_usb.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/cpia2/cpia2_usb.c b/drivers/media/usb/cpia2/cpia2_usb.c
index 351a78a..c1aa1ab 100644
--- a/drivers/media/usb/cpia2/cpia2_usb.c
+++ b/drivers/media/usb/cpia2/cpia2_usb.c
@@ -890,8 +890,7 @@ static void cpia2_usb_disconnect(struct usb_interface *intf)
 		DBG("Wakeup waiting processes\n");
 		cam->curbuff->status = FRAME_READY;
 		cam->curbuff->length = 0;
-		if (waitqueue_active(&cam->wq_stream))
-			wake_up_interruptible(&cam->wq_stream);
+		wake_up_interruptible(&cam->wq_stream);
 	}
 
 	DBG("Releasing interface\n");
-- 
1.7.1
