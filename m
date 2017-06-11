Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:46452 "EHLO
        lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751764AbdFKI2m (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 11 Jun 2017 04:28:42 -0400
Subject: Re: [PATCH v8 00/34] i.MX Media Driver
To: Steve Longerbeam <slongerbeam@gmail.com>, p.zabel@pengutronix.de,
        linux-media@vger.kernel.org
References: <1496860453-6282-1-git-send-email-steve_longerbeam@mentor.com>
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <d99752a4-35aa-33bb-b3d9-85268c38e761@xs4all.nl>
Date: Sun, 11 Jun 2017 10:28:39 +0200
MIME-Version: 1.0
In-Reply-To: <1496860453-6282-1-git-send-email-steve_longerbeam@mentor.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Steve, Philipp,

While preparing the pull request I noticed that the MAINTAINERS file wasn't
updated. Steve, can you post a patch adding entries for the imx and ov5640 driver?
Philipp, can you do the same for the video mux? I assume you're the maintainer
for this?

Thanks!

I also made it possible to compile-test this driver with this patch:

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
diff --git a/drivers/staging/media/imx/Kconfig b/drivers/staging/media/imx/Kconfig
index 7eff50bcea39..22f968cf32b1 100644
--- a/drivers/staging/media/imx/Kconfig
+++ b/drivers/staging/media/imx/Kconfig
@@ -1,6 +1,7 @@
 config VIDEO_IMX_MEDIA
 	tristate "i.MX5/6 V4L2 media core driver"
-	depends on MEDIA_CONTROLLER && VIDEO_V4L2 && ARCH_MXC && IMX_IPUV3_CORE
+	depends on MEDIA_CONTROLLER && VIDEO_V4L2
+	depends on (ARCH_MXC && IMX_IPUV3_CORE) || COMPILE_TEST
 	select V4L2_FWNODE
 	---help---
 	  Say yes here to enable support for video4linux media controller
diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
index c306146a4247..a2d26693912e 100644
--- a/drivers/staging/media/imx/imx-media-csi.c
+++ b/drivers/staging/media/imx/imx-media-csi.c
@@ -13,6 +13,7 @@
 #include <linux/gcd.h>
 #include <linux/interrupt.h>
 #include <linux/module.h>
+#include <linux/pinctrl/consumer.h>
 #include <linux/platform_device.h>
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-device.h>

Steve, if you're OK with that I was planning to just modify your original patch
rather than adding another patch on top.

Regards,

	Hans
