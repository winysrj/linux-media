Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.14]:56079 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750731AbcHSIRi (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 Aug 2016 04:17:38 -0400
To: linux-media@vger.kernel.org,
        Abhilash Jindal <klock.android@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Max Kellermann <max@duempel.org>,
        Michael Ira Krufky <mkrufky@linuxtv.org>,
        Shuah Khan <shuah@kernel.org>
From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH] [media] dvb_frontend: Use memdup_user() rather than
 duplicating its implementation
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Message-ID: <40f67371-815d-ad02-7bf7-db9998da0262@users.sourceforge.net>
Date: Fri, 19 Aug 2016 10:17:16 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Fri, 19 Aug 2016 10:04:54 +0200

* Reuse existing functionality from memdup_user() instead of keeping
  duplicate source code.

  This issue was detected by using the Coccinelle software.

* Return directly if this copy operation failed.

* Replace the specification of data structures by pointer dereferences
  to make the corresponding size determination a bit safer according to
  the Linux coding style convention.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/dvb-core/dvb_frontend.c | 28 ++++++----------------------
 1 file changed, 6 insertions(+), 22 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index be99c8d..01511e5 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -1969,17 +1969,9 @@ static int dvb_frontend_ioctl_properties(struct file *file,
 		if ((tvps->num == 0) || (tvps->num > DTV_IOCTL_MAX_MSGS))
 			return -EINVAL;
 
-		tvp = kmalloc(tvps->num * sizeof(struct dtv_property), GFP_KERNEL);
-		if (!tvp) {
-			err = -ENOMEM;
-			goto out;
-		}
-
-		if (copy_from_user(tvp, (void __user *)tvps->props,
-				   tvps->num * sizeof(struct dtv_property))) {
-			err = -EFAULT;
-			goto out;
-		}
+		tvp = memdup_user(tvps->props, tvps->num * sizeof(*tvp));
+		if (IS_ERR(tvp))
+			return PTR_ERR(tvp);
 
 		for (i = 0; i < tvps->num; i++) {
 			err = dtv_property_process_set(fe, tvp + i, file);
@@ -2002,17 +1994,9 @@ static int dvb_frontend_ioctl_properties(struct file *file,
 		if ((tvps->num == 0) || (tvps->num > DTV_IOCTL_MAX_MSGS))
 			return -EINVAL;
 
-		tvp = kmalloc(tvps->num * sizeof(struct dtv_property), GFP_KERNEL);
-		if (!tvp) {
-			err = -ENOMEM;
-			goto out;
-		}
-
-		if (copy_from_user(tvp, (void __user *)tvps->props,
-				   tvps->num * sizeof(struct dtv_property))) {
-			err = -EFAULT;
-			goto out;
-		}
+		tvp = memdup_user(tvps->props, tvps->num * sizeof(*tvp));
+		if (IS_ERR(tvp))
+			return PTR_ERR(tvp);
 
 		/*
 		 * Let's use our own copy of property cache, in order to
-- 
2.9.3

