Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:47962 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751826AbdJ1UlJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 28 Oct 2017 16:41:09 -0400
From: Steve Longerbeam <slongerbeam@gmail.com>
To: Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH 4/9] media: staging/imx: remove devname string from imx_media_subdev
Date: Sat, 28 Oct 2017 13:36:44 -0700
Message-Id: <1509223009-6392-5-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1509223009-6392-1-git-send-email-steve_longerbeam@mentor.com>
References: <1509223009-6392-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

A separate string for the device name, for DEVNAME async match, was
never needed. Just assign the asd device name to the passed platform
device name pointer in imx_media_add_async_subdev().

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 drivers/staging/media/imx/imx-media-dev.c | 3 +--
 drivers/staging/media/imx/imx-media.h     | 2 --
 2 files changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/staging/media/imx/imx-media-dev.c b/drivers/staging/media/imx/imx-media-dev.c
index f63808f..b948ce8 100644
--- a/drivers/staging/media/imx/imx-media-dev.c
+++ b/drivers/staging/media/imx/imx-media-dev.c
@@ -112,8 +112,7 @@ imx_media_add_async_subdev(struct imx_media_dev *imxmd,
 		asd->match.fwnode.fwnode = of_fwnode_handle(np);
 	} else {
 		asd->match_type = V4L2_ASYNC_MATCH_DEVNAME;
-		strncpy(imxsd->devname, devname, sizeof(imxsd->devname));
-		asd->match.device_name.name = imxsd->devname;
+		asd->match.device_name.name = devname;
 		imxsd->pdev = pdev;
 	}
 
diff --git a/drivers/staging/media/imx/imx-media.h b/drivers/staging/media/imx/imx-media.h
index 925b46b..299d4df 100644
--- a/drivers/staging/media/imx/imx-media.h
+++ b/drivers/staging/media/imx/imx-media.h
@@ -128,8 +128,6 @@ struct imx_media_subdev {
 
 	/* the platform device if this is an IPU-internal subdev */
 	struct platform_device *pdev;
-	/* the devname is needed for async devname match */
-	char devname[32];
 };
 
 struct imx_media_dev {
-- 
2.7.4
