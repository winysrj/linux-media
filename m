Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:42028 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753840AbaIXBbi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Sep 2014 21:31:38 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Akihiro Tsukada <tskd08@gmail.com>
Subject: [PATCH] [media] qm1d1c0042: fix compilation on 32 bits
Date: Tue, 23 Sep 2014 22:31:11 -0300
Message-Id: <aee9cf18e96ed8384a04bd3eda69c7b9e888ee5b.1411522264.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

   drivers/built-in.o: In function `qm1d1c0042_set_params':
>> qm1d1c0042.c:(.text+0x2519730): undefined reference to `__divdi3'

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/tuners/qm1d1c0042.c b/drivers/media/tuners/qm1d1c0042.c
index 585594b9c4f8..2a990f406cf5 100644
--- a/drivers/media/tuners/qm1d1c0042.c
+++ b/drivers/media/tuners/qm1d1c0042.c
@@ -28,6 +28,7 @@
  */
 
 #include <linux/kernel.h>
+#include <linux/math64.h>
 #include "qm1d1c0042.h"
 
 #define QM1D1C0042_NUM_REGS 0x20
@@ -234,7 +235,9 @@ static int qm1d1c0042_set_params(struct dvb_frontend *fe)
 	 * sd = b          (b >= 0)
 	 *      1<<22 + b  (b < 0)
 	 */
-	b = (((s64) freq) << 20) / state->cfg.xtal_freq - (((s64) a) << 20);
+	b = (s32)div64_s64(((s64) freq) << 20,
+			   state->cfg.xtal_freq - (((s64) a) << 20));
+
 	if (b >= 0)
 		sd = b;
 	else
-- 
1.9.3

