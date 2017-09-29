Return-path: <linux-media-owner@vger.kernel.org>
Received: from pandora.armlinux.org.uk ([78.32.30.218]:51758 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751667AbdI2Viy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 29 Sep 2017 17:38:54 -0400
From: Russell King <rmk+kernel@armlinux.org.uk>
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org
Subject: [PATCH RFC] media: staging/imx: fix complete handler
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1dy2zX-0003NB-5J@rmk-PC.armlinux.org.uk>
Date: Fri, 29 Sep 2017 22:38:39 +0100
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The complete handler walks all entities, expecting to find an imx
subdevice for each and every entity.

However, camera drivers such as smiapp can themselves contain multiple
entities, for which there will not be an imx subdevice.  This causes
imx_media_find_subdev_by_sd() to fail, making the imx capture system
unusable with such cameras.

Work around this by killing the error entirely, thereby allowing
the imx capture to be used with such cameras.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
Not the best solution, but the only one I can think of to fix the
regression that happened sometime between a previous revision of
Steve's patch set and the version that got merged.

 drivers/staging/media/imx/imx-media-dev.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/imx/imx-media-dev.c b/drivers/staging/media/imx/imx-media-dev.c
index d96f4512224f..6ba59939dd7a 100644
--- a/drivers/staging/media/imx/imx-media-dev.c
+++ b/drivers/staging/media/imx/imx-media-dev.c
@@ -345,8 +345,11 @@ static int imx_media_add_vdev_to_pad(struct imx_media_dev *imxmd,
 
 	sd = media_entity_to_v4l2_subdev(entity);
 	imxsd = imx_media_find_subdev_by_sd(imxmd, sd);
-	if (IS_ERR(imxsd))
-		return PTR_ERR(imxsd);
+	if (IS_ERR(imxsd)) {
+		v4l2_err(&imxmd->v4l2_dev, "failed to find subdev for entity %s, sd %p err %ld\n",
+			 entity->name, sd, PTR_ERR(imxsd));
+		return 0;
+	}
 
 	imxpad = &imxsd->pad[srcpad->index];
 	vdev_idx = imxpad->num_vdevs;
-- 
2.7.4
