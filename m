Return-path: <linux-media-owner@vger.kernel.org>
Received: from hermes.mlbassoc.com ([64.234.241.98]:53767 "EHLO
	mail.chez-thomas.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753642Ab1LAMvK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Dec 2011 07:51:10 -0500
Message-ID: <4ED7783D.8080801@mlbassoc.com>
Date: Thu, 01 Dec 2011 05:51:09 -0700
From: Gary Thomas <gary@mlbassoc.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: [PATCH] omap_vout: Fix compile error in 3.1
Content-Type: multipart/mixed;
 boundary="------------090502070509030005050807"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------090502070509030005050807
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

This patch is against the mainline v3.1 release (c3b92c8) and
fixes a compile error when building for OMAP3+DSS+VOUT

-- 
------------------------------------------------------------
Gary Thomas                 |  Consulting for the
MLB Associates              |    Embedded world
------------------------------------------------------------

--------------090502070509030005050807
Content-Type: text/plain;
 name="0001-omap_vout-Fix-compile-error.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0001-omap_vout-Fix-compile-error.patch"

>From 9c98079cf3a8b82c48139a5c9fc213c88064bb44 Mon Sep 17 00:00:00 2001
From: Gary Thomas <gary@mlbassoc.com>
Date: Thu, 1 Dec 2011 05:47:20 -0700
Subject: [PATCH] omap_vout: Fix compile error

Signed-off-by: Gary Thomas <gary@mlbassoc.com>
---
 drivers/media/video/omap/omap_vout.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/omap/omap_vout.c b/drivers/media/video/omap/omap_vout.c
index b3a5ecd..3422da0 100644
--- a/drivers/media/video/omap/omap_vout.c
+++ b/drivers/media/video/omap/omap_vout.c
@@ -38,6 +38,7 @@
 #include <linux/irq.h>
 #include <linux/videodev2.h>
 #include <linux/dma-mapping.h>
+#include <linux/slab.h>
 
 #include <media/videobuf-dma-contig.h>
 #include <media/v4l2-device.h>
-- 
1.7.6.4


--------------090502070509030005050807--
