Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:45036 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757796AbdJQRru (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 17 Oct 2017 13:47:50 -0400
From: Steve Longerbeam <slongerbeam@gmail.com>
To: Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH v2] media: staging/imx: do not return error in link_notify for unknown sources
Date: Tue, 17 Oct 2017 10:46:37 -0700
Message-Id: <1508262397-24074-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

imx_media_link_notify() should not return error if the source subdevice
of the link is not found in the list of subdevices that registered via
async. If the subdev has controls they will be inherited via a link_notify
that starts from a known source async subdev.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
Changes since v1:
 - expanded on commit message and comment.
---
 drivers/staging/media/imx/imx-media-dev.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/imx/imx-media-dev.c b/drivers/staging/media/imx/imx-media-dev.c
index b55e5eb..809d92e 100644
--- a/drivers/staging/media/imx/imx-media-dev.c
+++ b/drivers/staging/media/imx/imx-media-dev.c
@@ -508,8 +508,16 @@ static int imx_media_link_notify(struct media_link *link, u32 flags,
 	imxmd = dev_get_drvdata(sd->v4l2_dev->dev);
 
 	imxsd = imx_media_find_subdev_by_sd(imxmd, sd);
-	if (IS_ERR(imxsd))
-		return PTR_ERR(imxsd);
+	if (IS_ERR(imxsd)) {
+		/*
+		 * don't bother refreshing video device controls if the
+		 * source subdev isn't found in the async subdev list. If
+		 * this subdev has controls they will be inherited starting
+		 * from a known async subdev.
+		 */
+		return 0;
+	}
+
 	imxpad = &imxsd->pad[pad_idx];
 
 	/*
-- 
2.7.4
