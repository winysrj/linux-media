Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:34257 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750820AbdJCTKC (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 3 Oct 2017 15:10:02 -0400
From: Steve Longerbeam <slongerbeam@gmail.com>
To: Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Russell King <rmk+kernel@armlinux.org.uk>
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH] media: staging/imx: do not return error in link_notify for unknown sources
Date: Tue,  3 Oct 2017 12:09:13 -0700
Message-Id: <1507057753-31808-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

imx_media_link_notify() should not return error if the source subdevice
is not recognized by imx-media, that isn't an error. If the subdev has
controls they will be inherited starting from a known subdev.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 drivers/staging/media/imx/imx-media-dev.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/imx/imx-media-dev.c b/drivers/staging/media/imx/imx-media-dev.c
index b55e5eb..dd47861 100644
--- a/drivers/staging/media/imx/imx-media-dev.c
+++ b/drivers/staging/media/imx/imx-media-dev.c
@@ -508,8 +508,15 @@ static int imx_media_link_notify(struct media_link *link, u32 flags,
 	imxmd = dev_get_drvdata(sd->v4l2_dev->dev);
 
 	imxsd = imx_media_find_subdev_by_sd(imxmd, sd);
-	if (IS_ERR(imxsd))
-		return PTR_ERR(imxsd);
+	if (IS_ERR(imxsd)) {
+		/*
+		 * don't bother if the source subdev isn't known to
+		 * imx-media. If the subdev has controls they will be
+		 * inherited starting from a known subdev.
+		 */
+		return 0;
+	}
+
 	imxpad = &imxsd->pad[pad_idx];
 
 	/*
-- 
2.7.4
