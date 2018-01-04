Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:65000 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752690AbeADTor (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 4 Jan 2018 14:44:47 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org
Subject: [PATCH 1/2] media: staging: use tabs instead of spaces at Kconfig and davinci
Date: Thu,  4 Jan 2018 14:44:40 -0500
Message-Id: <96780202f1f7ffe13f6e0426394c8c93a2cbaa77.1515091119.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Even on text and Kconfigs, what we do on media is to use
tabs for indentation.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/staging/media/Kconfig           | 14 +++++++-------
 drivers/staging/media/davinci_vpfe/TODO | 10 +++++-----
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/media/Kconfig b/drivers/staging/media/Kconfig
index 227437f22acf..e68e1d343d53 100644
--- a/drivers/staging/media/Kconfig
+++ b/drivers/staging/media/Kconfig
@@ -1,19 +1,19 @@
 menuconfig STAGING_MEDIA
-        bool "Media staging drivers"
-        default n
-        ---help---
-          This option allows you to select a number of media drivers that
+	bool "Media staging drivers"
+	default n
+	---help---
+	  This option allows you to select a number of media drivers that
 	  don't have the "normal" Linux kernel quality level.
 	  Most of them don't follow properly the V4L, DVB and/or RC API's,
 	  so, they won't likely work fine with the existing applications.
 	  That also means that, once fixed, their API's will change to match
 	  the existing ones.
 
-          If you wish to work on these drivers, to help improve them, or
-          to report problems you have with them, please use the
+	  If you wish to work on these drivers, to help improve them, or
+	  to report problems you have with them, please use the
 	  linux-media@vger.kernel.org mailing list.
 
-          If in doubt, say N here.
+	  If in doubt, say N here.
 
 
 if STAGING_MEDIA && MEDIA_SUPPORT
diff --git a/drivers/staging/media/davinci_vpfe/TODO b/drivers/staging/media/davinci_vpfe/TODO
index 7015ab35ded5..3e5477e8cfa5 100644
--- a/drivers/staging/media/davinci_vpfe/TODO
+++ b/drivers/staging/media/davinci_vpfe/TODO
@@ -2,11 +2,11 @@ TODO (general):
 ==================================
 
 - User space interface refinement
-        - Controls should be used when possible rather than private ioctl
-        - No enums should be used
-        - Use of MC and V4L2 subdev APIs when applicable
-        - Single interface header might suffice
-        - Current interface forces to configure everything at once
+	- Controls should be used when possible rather than private ioctl
+	- No enums should be used
+	- Use of MC and V4L2 subdev APIs when applicable
+	- Single interface header might suffice
+	- Current interface forces to configure everything at once
 - Get rid of the dm365_ipipe_hw.[ch] layer
 - Active external sub-devices defined by link configuration; no strcmp
   needed
-- 
2.14.3
