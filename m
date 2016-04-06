Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:62844 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752812AbcDFD1O (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 5 Apr 2016 23:27:14 -0400
Date: Wed, 6 Apr 2016 05:26:56 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Shuah Khan <shuahkh@osg.samsung.com>,
	Steven Toth <stoth@hauppauge.com>
Subject: [PATCH] au0828: remove unused macro
Message-ID: <Pine.LNX.4.64.1604060520440.12238@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

An V4L2_CID_PRIVATE_SHARPNESS macro is defined in the su0828 driver, but 
never used. Remove it.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
diff --git a/drivers/media/usb/au0828/au0828.h b/drivers/media/usb/au0828/au0828.h
index 23f869c..6871a21 100644
--- a/drivers/media/usb/au0828/au0828.h
+++ b/drivers/media/usb/au0828/au0828.h
@@ -54,7 +54,6 @@
 #define NTSC_STD_H      480
 
 #define AU0828_INTERLACED_DEFAULT       1
-#define V4L2_CID_PRIVATE_SHARPNESS  (V4L2_CID_PRIVATE_BASE + 0)
 
 /* Defination for AU0828 USB transfer */
 #define AU0828_MAX_ISO_BUFS    12  /* maybe resize this value in the future */
