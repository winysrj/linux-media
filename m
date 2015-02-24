Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qa0-f44.google.com ([209.85.216.44]:38194 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753251AbbBXR33 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Feb 2015 12:29:29 -0500
Received: by mail-qa0-f44.google.com with SMTP id n8so28118741qaq.3
        for <linux-media@vger.kernel.org>; Tue, 24 Feb 2015 09:29:28 -0800 (PST)
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: linux-media@vger.kernel.org
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Shuah Khan <shuahkh@osg.samsung.com>
Subject: [PATCH] xc5000: fix memory corruption when unplugging device
Date: Tue, 24 Feb 2015 12:29:18 -0500
Message-Id: <1424798958-2819-1-git-send-email-dheitmueller@kernellabs.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch addresses a regression introduced in the following patch:

commit 5264a522a597032c009f9143686ebf0fa4e244fb
Author: Shuah Khan <shuahkh@osg.samsung.com>
Date:   Mon Sep 22 21:30:46 2014 -0300
    [media] media: tuner xc5000 - release firmwware from xc5000_release()

The "priv" struct is actually reference counted, so the xc5000_release()
function gets called multiple times for hybrid devices.  Because
release_firmware() was always being called, it would work fine as expected
on the first call but then the second call would corrupt aribtrary memory.

Set the pointer to NULL after releasing so that we don't call
release_firmware() twice.

This problem was detected in the HVR-950q where plugging/unplugging the
device multiple times would intermittently show panics in completely
unrelated areas of the kernel.

Signed-off-by: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Shuah Khan <shuahkh@osg.samsung.com>
---
 drivers/media/tuners/xc5000.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/media/tuners/xc5000.c b/drivers/media/tuners/xc5000.c
index 40f9db6..74b2092 100644
--- a/drivers/media/tuners/xc5000.c
+++ b/drivers/media/tuners/xc5000.c
@@ -1314,7 +1314,10 @@ static int xc5000_release(struct dvb_frontend *fe)
 
 	if (priv) {
 		cancel_delayed_work(&priv->timer_sleep);
-		release_firmware(priv->firmware);
+		if (priv->firmware) {
+			release_firmware(priv->firmware);
+			priv->firmware = NULL;
+		}
 		hybrid_tuner_release_state(priv);
 	}
 
-- 
1.9.1

