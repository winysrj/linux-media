Return-path: <linux-media-owner@vger.kernel.org>
Received: from hermes.mlbassoc.com ([64.234.241.98]:54092 "EHLO
	mail.chez-thomas.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956Ab1JKWEl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Oct 2011 18:04:41 -0400
Message-ID: <4E94BD75.5040403@mlbassoc.com>
Date: Tue, 11 Oct 2011 16:04:37 -0600
From: Gary Thomas <gary@mlbassoc.com>
MIME-Version: 1.0
To: Enrico Butera <ebutera@users.berlios.de>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
Subject: Re: [RFC 0/3] omap3isp: add BT656 support
References: <1318345735-16778-1-git-send-email-ebutera@users.berlios.de>
In-Reply-To: <1318345735-16778-1-git-send-email-ebutera@users.berlios.de>
Content-Type: multipart/mixed;
 boundary="------------080106020107060500020206"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------080106020107060500020206
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 2011-10-11 09:08, Enrico Butera wrote:
> This patch series add support for BT656 to omap3isp. It is based
> on patches from Deepthy Ravi and Javier Martinez Canillas.
>
> To be applied on top of omap3isp-omap3isp-yuv branch at:
>
> git.linuxtv.org/pinchartl/media.git
>
> Enrico Butera (2):
>    omap3isp: ispvideo: export isp_video_mbus_to_pix
>    omap3isp: ispccdc: configure CCDC registers and add BT656 support
>
> Javier Martinez Canillas (1):
>    omap3isp: ccdc: Add interlaced field mode to platform data
>
>   drivers/media/video/omap3isp/ispccdc.c  |  143 ++++++++++++++++++++++++++-----
>   drivers/media/video/omap3isp/ispccdc.h  |    1 +
>   drivers/media/video/omap3isp/ispreg.h   |    1 +
>   drivers/media/video/omap3isp/ispvideo.c |    2 +-
>   drivers/media/video/omap3isp/ispvideo.h |    4 +-
>   include/media/omap3isp.h                |    3 +
>   6 files changed, 129 insertions(+), 25 deletions(-)
>

Sorry, this just locks up on boot for me, immediately after finding the TVP5150.
I applied your changes to the above tree
   commit 658d5e03dc1a7283e5119cd0e9504759dbd3d912
   Author: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
   Date:   Wed Aug 31 16:03:53 2011 +0200

However, it does not build for my OMAP3530 without the attached patches.

-- 
------------------------------------------------------------
Gary Thomas                 |  Consulting for the
MLB Associates              |    Embedded world
------------------------------------------------------------

--------------080106020107060500020206
Content-Type: text/plain;
 name="yuv.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="yuv.patch"

diff --git a/drivers/media/video/omap/omap_vout.c b/drivers/media/video/omap/omap_vout.c
index b5ef362..045bcf8 100644
--- a/drivers/media/video/omap/omap_vout.c
+++ b/drivers/media/video/omap/omap_vout.c
@@ -38,6 +38,7 @@
 #include <linux/irq.h>
 #include <linux/videodev2.h>
 #include <linux/dma-mapping.h>
+#include <linux/slab.h>
 
 #include <media/videobuf-dma-contig.h>
 #include <media/v4l2-device.h>
@@ -2194,6 +2195,7 @@ static int __init omap_vout_probe(struct platform_device *pdev)
 					"'%s' Display already enabled\n",
 					def_display->name);
 			}
+#if 0  // This code generates compile errors?
 			/* set the update mode */
 			if (def_display->caps &
 					OMAP_DSS_DISPLAY_CAP_MANUAL_UPDATE) {
@@ -2207,6 +2209,7 @@ static int __init omap_vout_probe(struct platform_device *pdev)
 					dssdrv->set_update_mode(def_display,
 							OMAP_DSS_UPDATE_AUTO);
 			}
+#endif
 		}
 	}
 
diff --git a/drivers/media/video/omap3isp/ispccdc.c b/drivers/media/video/omap3isp/ispccdc.c
index fde3268..7d059b6 100644
--- a/drivers/media/video/omap3isp/ispccdc.c
+++ b/drivers/media/video/omap3isp/ispccdc.c
@@ -31,6 +31,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/mm.h>
 #include <linux/sched.h>
+#include <linux/slab.h>
 #include <media/v4l2-event.h>
 
 #include "isp.h"

--------------080106020107060500020206--
