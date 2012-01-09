Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:63097 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933081Ab2AITuK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Jan 2012 14:50:10 -0500
Received: by iaeh11 with SMTP id h11so7039329iae.19
        for <linux-media@vger.kernel.org>; Mon, 09 Jan 2012 11:50:10 -0800 (PST)
From: Devendra Naga <devendra.aaru@gmail.com>
To: mchehab@infradead.org, o.endriss@gmx.de, rjkm@metzlerbros.de,
	crope@iki.fi, linux-media@vger.kernel.org
Cc: devendra.aaru@gmail.com
Subject: [PATCH 1/1] remove version.h includes in drivers/media/dvb/frontends.
Date: Tue, 10 Jan 2012 01:19:35 +0530
Message-Id: <1326138575-25825-1-git-send-email-devendra.aaru@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

when compiling with make versioncheck, got

/home/devendra/linux/drivers/media/dvb/frontends/drxk_hard.c: 31 linux/version.h not needed.
/home/devendra/linux/drivers/media/dvb/frontends/tda18271c2dd.c: 32 linux/version.h not needed.

Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
---
 drivers/media/dvb/frontends/drxk_hard.c    |    1 -
 drivers/media/dvb/frontends/tda18271c2dd.c |    1 -
 2 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb/frontends/drxk_hard.c b/drivers/media/dvb/frontends/drxk_hard.c
index f6431ef..0024d9b 100644
--- a/drivers/media/dvb/frontends/drxk_hard.c
+++ b/drivers/media/dvb/frontends/drxk_hard.c
@@ -28,7 +28,6 @@
 #include <linux/delay.h>
 #include <linux/firmware.h>
 #include <linux/i2c.h>
-#include <linux/version.h>
 #include <asm/div64.h>
 
 #include "dvb_frontend.h"
diff --git a/drivers/media/dvb/frontends/tda18271c2dd.c b/drivers/media/dvb/frontends/tda18271c2dd.c
index 1b1bf20..fbd108e 100644
--- a/drivers/media/dvb/frontends/tda18271c2dd.c
+++ b/drivers/media/dvb/frontends/tda18271c2dd.c
@@ -29,7 +29,6 @@
 #include <linux/delay.h>
 #include <linux/firmware.h>
 #include <linux/i2c.h>
-#include <linux/version.h>
 #include <asm/div64.h>
 
 #include "dvb_frontend.h"
-- 
1.7.1

