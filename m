Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.134]:56093 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752178AbdGUQWC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 21 Jul 2017 12:22:02 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] [media] imx: add VIDEO_V4L2_SUBDEV_API dependency
Date: Fri, 21 Jul 2017 18:21:25 +0200
Message-Id: <20170721162144.3339864-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Without this, I get a build error:

drivers/staging/media/imx/imx-media-vdic.c: In function '__vdic_get_fmt':
drivers/staging/media/imx/imx-media-vdic.c:554:10: error: implicit declaration of function 'v4l2_subdev_get_try_format'; did you mean 'v4l2_subdev_notify_event'? [-Werror=implicit-function-declaration]

Fixes: e130291212df ("[media] media: Add i.MX media core driver")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/staging/media/imx/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/media/imx/Kconfig b/drivers/staging/media/imx/Kconfig
index 7eff50bcea39..719508fcb0e9 100644
--- a/drivers/staging/media/imx/Kconfig
+++ b/drivers/staging/media/imx/Kconfig
@@ -1,6 +1,7 @@
 config VIDEO_IMX_MEDIA
 	tristate "i.MX5/6 V4L2 media core driver"
 	depends on MEDIA_CONTROLLER && VIDEO_V4L2 && ARCH_MXC && IMX_IPUV3_CORE
+	depends on VIDEO_V4L2_SUBDEV_API
 	select V4L2_FWNODE
 	---help---
 	  Say yes here to enable support for video4linux media controller
-- 
2.9.0
