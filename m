Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:56585 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755432Ab3HXTub (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 24 Aug 2013 15:50:31 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] [media] msi3101: Fix compilation on i386
Date: Sat, 24 Aug 2013 13:49:46 -0300
Message-Id: <1377362986-9818-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

as reported by: kbuild test robot <fengguang.wu@intel.com>:
	[linuxtv-media:master 459/499] sdr-msi3101.c:undefined reference to `__umoddi3'

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/staging/media/msi3101/sdr-msi3101.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/media/msi3101/sdr-msi3101.c b/drivers/staging/media/msi3101/sdr-msi3101.c
index eebe1d0..24c7b70 100644
--- a/drivers/staging/media/msi3101/sdr-msi3101.c
+++ b/drivers/staging/media/msi3101/sdr-msi3101.c
@@ -40,6 +40,7 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/gcd.h>
+#include <asm/div64.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-ctrls.h>
@@ -1332,7 +1333,7 @@ static int msi3101_set_tuner(struct msi3101_state *s)
 	int ret, i, len;
 	unsigned int n, m, thresh, frac, vco_step, tmp, f_if1;
 	u32 reg;
-	u64 f_vco;
+	u64 f_vco, tmp64;
 	u8 mode, filter_mode, lo_div;
 	const struct msi3101_gain *gain_lut;
 	static const struct {
@@ -1436,8 +1437,10 @@ static int msi3101_set_tuner(struct msi3101_state *s)
 #define F_OUT_STEP 1
 #define R_REF 4
 	f_vco = (f_rf + f_if + f_if1) * lo_div;
-	n = f_vco / (F_REF * R_REF);
-	m = f_vco % (F_REF * R_REF);
+
+	tmp64 = f_vco;
+	m = do_div(tmp64, F_REF * R_REF);
+	n = (unsigned int) tmp64;
 
 	vco_step = F_OUT_STEP * lo_div;
 	thresh = (F_REF * R_REF) / vco_step;
-- 
1.8.3.1

