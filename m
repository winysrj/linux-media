Return-path: <linux-media-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:49876 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757256AbZLIUJY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 9 Dec 2009 15:09:24 -0500
Received: from list by lo.gmane.org with local (Exim 4.50)
	id 1NISql-0000o8-Oj
	for linux-media@vger.kernel.org; Wed, 09 Dec 2009 21:09:27 +0100
Received: from cpc4-dals10-0-0-cust795.hari.cable.virginmedia.com ([92.234.3.28])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Wed, 09 Dec 2009 21:09:27 +0100
Received: from mariofutire by cpc4-dals10-0-0-cust795.hari.cable.virginmedia.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Wed, 09 Dec 2009 21:09:27 +0100
To: linux-media@vger.kernel.org
From: Andrea <mariofutire@googlemail.com>
Subject: [PATCH] PWC: parameter trace is only available in debug
Date: Wed, 09 Dec 2009 20:09:07 +0000
Message-ID: <hfp053$19h$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090201050205080605030201"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------090201050205080605030201
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

This patch fixes a small issue where modinfo says the parameter "trace" is always available, while
it only works if CONFIG_USB_PWC_DEBUG is enabled.


--------------090201050205080605030201
Content-Type: text/x-patch;
 name="v4l.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="v4l.diff"

diff -r 065f9e34e07b linux/drivers/media/video/pwc/pwc-if.c
--- a/linux/drivers/media/video/pwc/pwc-if.c	Mon Dec 07 10:08:33 2009 -0200
+++ b/linux/drivers/media/video/pwc/pwc-if.c	Wed Dec 09 20:04:45 2009 +0000
@@ -1959,7 +1959,9 @@
 MODULE_PARM_DESC(fps, "Initial frames per second. Varies with model, useful range 5-30");
 MODULE_PARM_DESC(fbufs, "Number of internal frame buffers to reserve");
 MODULE_PARM_DESC(mbufs, "Number of external (mmap()ed) image buffers");
+#ifdef CONFIG_USB_PWC_DEBUG
 MODULE_PARM_DESC(trace, "For debugging purposes");
+#endif
 MODULE_PARM_DESC(power_save, "Turn power save feature in camera on or off");
 MODULE_PARM_DESC(compression, "Preferred compression quality. Range 0 (uncompressed) to 3 (high compression)");
 MODULE_PARM_DESC(leds, "LED on,off time in milliseconds");

--------------090201050205080605030201--

