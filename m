Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:33351 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828AbbJ2HRA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Oct 2015 03:17:00 -0400
Date: Thu, 29 Oct 2015 00:16:57 -0700
From: Tina Ruchandani <ruchandani.tina@gmail.com>
To: linux-media@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH] [media] rc-core: Remove 'struct timeval' usage
Message-ID: <20151029071657.GA11549@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

streamzap uses 'struct timeval' to store the start time of a signal for
gap tracking. struct timeval uses a 32-bit seconds representation which
will overflow in year 2038 and beyond. Replace struct timeval with ktime_t
which uses a 64-bit seconds representation and is 2038 safe. This patch 
uses ktime_get_real() preserving the use of wall-clock time in the 
original code.

Signed-off-by: Tina Ruchandani <ruchandani.tina@gmail.com>
---
 drivers/media/rc/streamzap.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/media/rc/streamzap.c b/drivers/media/rc/streamzap.c
index 5a17cb8..815243c 100644
--- a/drivers/media/rc/streamzap.c
+++ b/drivers/media/rc/streamzap.c
@@ -34,6 +34,7 @@
 #include <linux/device.h>
 #include <linux/module.h>
 #include <linux/slab.h>
+#include <linux/ktime.h>
 #include <linux/usb.h>
 #include <linux/usb/input.h>
 #include <media/rc-core.h>
@@ -96,8 +97,8 @@ struct streamzap_ir {
 	/* sum of signal lengths received since signal start */
 	unsigned long		sum;
 	/* start time of signal; necessary for gap tracking */
-	struct timeval		signal_last;
-	struct timeval		signal_start;
+	ktime_t			signal_last;
+	ktime_t			signal_start;
 	bool			timeout_enabled;
 
 	char			name[128];
@@ -136,20 +137,18 @@ static void sz_push_full_pulse(struct streamzap_ir *sz,
 	DEFINE_IR_RAW_EVENT(rawir);
 
 	if (sz->idle) {
-		long deltv;
+		int delta;
 
 		sz->signal_last = sz->signal_start;
-		do_gettimeofday(&sz->signal_start);
+		sz->signal_start = ktime_get_real();
 
-		deltv = sz->signal_start.tv_sec - sz->signal_last.tv_sec;
+		delta = ktime_us_delta(sz->signal_start, sz->signal_last);
 		rawir.pulse = false;
-		if (deltv > 15) {
+		if (delta > (15 * USEC_PER_SEC)) {
 			/* really long time */
 			rawir.duration = IR_MAX_DURATION;
 		} else {
-			rawir.duration = (int)(deltv * 1000000 +
-				sz->signal_start.tv_usec -
-				sz->signal_last.tv_usec);
+			rawir.duration = delta;
 			rawir.duration -= sz->sum;
 			rawir.duration = US_TO_NS(rawir.duration);
 			rawir.duration = (rawir.duration > IR_MAX_DURATION) ?
@@ -428,7 +427,7 @@ static int streamzap_probe(struct usb_interface *intf,
 	sz->max_timeout = US_TO_NS(SZ_TIMEOUT * SZ_RESOLUTION);
 	#endif
 
-	do_gettimeofday(&sz->signal_start);
+	sz->signal_start = ktime_get_real();
 
 	/* Complete final initialisations */
 	usb_fill_int_urb(sz->urb_in, usbdev, pipe, sz->buf_in,
-- 
2.6.0.rc2.230.g3dd15c0

