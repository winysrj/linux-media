Return-path: <mchehab@pedra>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:32827 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754221Ab1FONcK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Jun 2011 09:32:10 -0400
Date: Wed, 15 Jun 2011 15:32:06 +0200
From: Tejun Heo <tj@kernel.org>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Patrick Boettcher <pboettcher@kernellabs.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] dvb-usb/technisat-usb2: don't use flush_scheduled_work()
Message-ID: <20110615133206.GW8141@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

flush_scheduled_work() is deprecated and scheduled to be removed.
technisat-usb2 already sync-cancels the only work item it uses and
there's no reason for it to call flush_scheduled_work().  Don't use
it.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Patrick Boettcher <pboettcher@kernellabs.com>
---
I was re-scanning source tree to prepare for deprecation of
flush_scheduled_work() and found out new driver added usage
unnecessarily.  Can you please include this patch so that it gets
propagated to linux-next soonish?

Thank you.

 drivers/media/dvb/dvb-usb/technisat-usb2.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

Index: work/drivers/media/dvb/dvb-usb/technisat-usb2.c
===================================================================
--- work.orig/drivers/media/dvb/dvb-usb/technisat-usb2.c
+++ work/drivers/media/dvb/dvb-usb/technisat-usb2.c
@@ -765,10 +765,8 @@ static void technisat_usb2_disconnect(st
 	/* work and stuff was only created when the device is is hot-state */
 	if (dev != NULL) {
 		struct technisat_usb2_state *state = dev->priv;
-		if (state != NULL) {
+		if (state != NULL)
 			cancel_delayed_work_sync(&state->green_led_work);
-			flush_scheduled_work();
-		}
 	}
 
 	dvb_usb_device_exit(intf);
