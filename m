Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f179.google.com ([209.85.192.179]:44589 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934835AbaDJJB6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Apr 2014 05:01:58 -0400
Received: by mail-pd0-f179.google.com with SMTP id w10so3587292pde.24
        for <linux-media@vger.kernel.org>; Thu, 10 Apr 2014 02:01:57 -0700 (PDT)
Date: Thu, 10 Apr 2014 19:01:50 +1000
From: Vitaly Osipov <vitaly.osipov@gmail.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-media@vger.kernel.org, devel@driverdev.osuosl.org
Subject: [PATCH 1/2] staging: media: omap24xx: fix up checkpatch error message
Message-ID: <20140410090144.GA8604@witts-MacBook-Pro.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

tcm825x.c and tcm825x.h:

fixing ERROR: Macros with complex values should be enclosed in parenthesis

Signed-off-by: Vitaly Osipov <vitaly.osipov@gmail.com>
---
 drivers/staging/media/omap24xx/tcm825x.c |    8 ++++----
 drivers/staging/media/omap24xx/tcm825x.h |    4 ++--
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/media/omap24xx/tcm825x.c b/drivers/staging/media/omap24xx/tcm825x.c
index f4dd32d..2326481 100644
--- a/drivers/staging/media/omap24xx/tcm825x.c
+++ b/drivers/staging/media/omap24xx/tcm825x.c
@@ -89,10 +89,10 @@ static const struct tcm825x_reg rgb565	=	{ 0x02, TCM825X_PICFMT };
 
 /* Our own specific controls */
 #define V4L2_CID_ALC				V4L2_CID_PRIVATE_BASE
-#define V4L2_CID_H_EDGE_EN			V4L2_CID_PRIVATE_BASE + 1
-#define V4L2_CID_V_EDGE_EN			V4L2_CID_PRIVATE_BASE + 2
-#define V4L2_CID_LENS				V4L2_CID_PRIVATE_BASE + 3
-#define V4L2_CID_MAX_EXPOSURE_TIME		V4L2_CID_PRIVATE_BASE + 4
+#define V4L2_CID_H_EDGE_EN			(V4L2_CID_PRIVATE_BASE + 1)
+#define V4L2_CID_V_EDGE_EN			(V4L2_CID_PRIVATE_BASE + 2)
+#define V4L2_CID_LENS				(V4L2_CID_PRIVATE_BASE + 3)
+#define V4L2_CID_MAX_EXPOSURE_TIME		(V4L2_CID_PRIVATE_BASE + 4)
 #define V4L2_CID_LAST_PRIV			V4L2_CID_MAX_EXPOSURE_TIME
 
 /*  Video controls  */
diff --git a/drivers/staging/media/omap24xx/tcm825x.h b/drivers/staging/media/omap24xx/tcm825x.h
index 9970fb1..4a41127 100644
--- a/drivers/staging/media/omap24xx/tcm825x.h
+++ b/drivers/staging/media/omap24xx/tcm825x.h
@@ -21,8 +21,8 @@
 
 #define TCM825X_NAME "tcm825x"
 
-#define TCM825X_MASK(x)  x & 0x00ff
-#define TCM825X_ADDR(x) (x & 0xff00) >> 8
+#define TCM825X_MASK(x)  (x & 0x00ff)
+#define TCM825X_ADDR(x) ((x & 0xff00) >> 8)
 
 /* The TCM825X I2C sensor chip has a fixed slave address of 0x3d. */
 #define TCM825X_I2C_ADDR	0x3d
-- 
1.7.9.5

