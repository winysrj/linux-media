Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:52386 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750771Ab0DHUG1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Apr 2010 16:06:27 -0400
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: Huang Weiyi <weiyi.huang@gmail.com>,
	"mchehab@redhat.com" <mchehab@redhat.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Thu, 8 Apr 2010 15:06:14 -0500
Subject: RE: [PATCH 06/16] V4L/DVB: vpif: remove unused #include
 <linux/version.h>
Message-ID: <A69FA2915331DC488A831521EAE36FE4016A9D3223@dlee06.ent.ti.com>
References: <1270727366-3848-1-git-send-email-weiyi.huang@gmail.com>
In-Reply-To: <1270727366-3848-1-git-send-email-weiyi.huang@gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Muralidharan Karicheri <mkaricheri@gmail.com>

Murali Karicheri
Software Design Engineer
Texas Instruments Inc.
Germantown, MD 20874
phone: 301-407-9583
email: m-karicheri2@ti.com

>-----Original Message-----
>From: linux-media-owner@vger.kernel.org [mailto:linux-media-
>owner@vger.kernel.org] On Behalf Of Huang Weiyi
>Sent: Thursday, April 08, 2010 7:49 AM
>To: mchehab@redhat.com
>Cc: linux-media@vger.kernel.org; Huang Weiyi
>Subject: [PATCH 06/16] V4L/DVB: vpif: remove unused #include
><linux/version.h>
>
>Remove unused #include <linux/version.h>('s) in
>  drivers/media/video/davinci/vpif_capture.c
>  drivers/media/video/davinci/vpif_display.c
>
>Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>
>---
> drivers/media/video/davinci/vpif_capture.c |    1 -
> drivers/media/video/davinci/vpif_display.c |    1 -
> 2 files changed, 0 insertions(+), 2 deletions(-)
>
>diff --git a/drivers/media/video/davinci/vpif_capture.c
>b/drivers/media/video/davinci/vpif_capture.c
>index 2e5a7fb..f74b551 100644
>--- a/drivers/media/video/davinci/vpif_capture.c
>+++ b/drivers/media/video/davinci/vpif_capture.c
>@@ -33,7 +33,6 @@
> #include <linux/i2c.h>
> #include <linux/platform_device.h>
> #include <linux/io.h>
>-#include <linux/version.h>
> #include <linux/slab.h>
> #include <media/v4l2-device.h>
> #include <media/v4l2-ioctl.h>
>diff --git a/drivers/media/video/davinci/vpif_display.c
>b/drivers/media/video/davinci/vpif_display.c
>index 13c3a1b..f8cd5e5 100644
>--- a/drivers/media/video/davinci/vpif_display.c
>+++ b/drivers/media/video/davinci/vpif_display.c
>@@ -29,7 +29,6 @@
> #include <linux/i2c.h>
> #include <linux/platform_device.h>
> #include <linux/io.h>
>-#include <linux/version.h>
> #include <linux/slab.h>
>
> #include <asm/irq.h>
>--
>1.6.1.3
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-media" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
