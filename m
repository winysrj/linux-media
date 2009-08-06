Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58932 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756805AbZHFXBb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 6 Aug 2009 19:01:31 -0400
Message-Id: <200908062301.n76N1KRK030169@imap1.linux-foundation.org>
Subject: [patch 9/9] drivers/media/video/gspca: introduce missing kfree
To: mchehab@infradead.org
Cc: linux-media@vger.kernel.org, akpm@linux-foundation.org,
	julia@diku.dk, erik.andren@gmail.com
From: akpm@linux-foundation.org
Date: Thu, 06 Aug 2009 16:01:20 -0700
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Julia Lawall <julia@diku.dk>

Error handling code following a kmalloc should free the allocated data.

The semantic match that finds the problem is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@r exists@
local idexpression x;
statement S;
expression E;
identifier f,f1,l;
position p1,p2;
expression *ptr != NULL;
@@

x@p1 = \(kmalloc\|kzalloc\|kcalloc\)(...);
...
if (x == NULL) S
<... when != x
     when != if (...) { <+...x...+> }
(
x->f1 = E
|
 (x->f1 == NULL || ...)
|
 f(...,x->f1,...)
)
...>
(
 return \(0\|<+...x...+>\|ptr\);
|
 return@p2 ...;
)

@script:python@
p1 << r.p1;
p2 << r.p2;
@@

print "* file: %s kmalloc %s return %s" % (p1[0].file,p1[0].line,p2[0].line)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Acked-by: Erik Andren <erik.andren@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/gspca/m5602/m5602_s5k83a.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/media/video/gspca/m5602/m5602_s5k83a.c~drivers-media-video-gspca-introduce-missing-kfree drivers/media/video/gspca/m5602/m5602_s5k83a.c
--- a/drivers/media/video/gspca/m5602/m5602_s5k83a.c~drivers-media-video-gspca-introduce-missing-kfree
+++ a/drivers/media/video/gspca/m5602/m5602_s5k83a.c
@@ -178,8 +178,10 @@ sensor_found:
 
 	sens_priv->settings =
 	kmalloc(sizeof(s32)*ARRAY_SIZE(s5k83a_ctrls), GFP_KERNEL);
-	if (!sens_priv->settings)
+	if (!sens_priv->settings) {
+		kfree(sens_priv);
 		return -ENOMEM;
+	}
 
 	sd->gspca_dev.cam.cam_mode = s5k83a_modes;
 	sd->gspca_dev.cam.nmodes = ARRAY_SIZE(s5k83a_modes);
_
