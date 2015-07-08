Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:35904 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757945AbbGHTIy (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Jul 2015 15:08:54 -0400
From: Laurent Navet <laurent.navet@gmail.com>
To: mchehab@osg.samsung.com
Cc: shuah.kh@samsung.com, crope@iki.fi, stefanr@s5r6.in-berlin.de,
	tskd08@gmail.com, ruchandani.tina@gmail.com,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Laurent Navet <laurent.navet@gmail.com>
Subject: [PATCH] [media] dvb-core: remove ktime_add_us() call
Date: Wed,  8 Jul 2015 21:16:24 +0200
Message-Id: <1436382984-11947-1-git-send-email-laurent.navet@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Calling ktime_add_us() seems useless as is only useful for it's return 
value which is ignored.
Also fix coverity CID 1309761.

Signed-off-by: Laurent Navet <laurent.navet@gmail.com>
---
 drivers/media/dvb-core/dvb_frontend.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index 842b9c8..4205628 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -901,7 +901,6 @@ void dvb_frontend_sleep_until(ktime_t *waketime, u32 add_usec)
 {
 	s32 delta, newdelta;
 
-	ktime_add_us(*waketime, add_usec);
 	delta = ktime_us_delta(ktime_get_real(), *waketime);
 	if (delta > 2500) {
 		msleep((delta - 1500) / 1000);
-- 
2.1.4

