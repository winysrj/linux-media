Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl0-f66.google.com ([209.85.160.66]:39381 "EHLO
        mail-pl0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934279AbeE2N3G (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 29 May 2018 09:29:06 -0400
From: Janani Sankara Babu <jananis37@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Janani Sankara Babu <jananis37@gmail.com>
Subject: [PATCH] Staging:media:imx Fix multiple assignments in a line
Date: Tue, 29 May 2018 19:08:22 -0400
Message-Id: <1527635302-5701-1-git-send-email-jananis37@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch solves multiple assignments warning shown by checkpatch
script.

Signed-off-by: Janani Sankara Babu <jananis37@gmail.com>
---
 drivers/staging/media/imx/imx-media-csi.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
index aeab05f..15068f7 100644
--- a/drivers/staging/media/imx/imx-media-csi.c
+++ b/drivers/staging/media/imx/imx-media-csi.c
@@ -1191,10 +1191,12 @@ static int csi_enum_frame_size(struct v4l2_subdev *sd,
 	} else {
 		crop = __csi_get_crop(priv, cfg, fse->which);

-		fse->min_width = fse->max_width = fse->index & 1 ?
+		fse->min_width = fse->index & 1 ?
 			crop->width / 2 : crop->width;
-		fse->min_height = fse->max_height = fse->index & 2 ?
+		fse->max_width = fse->min_width;
+		fse->min_height = fse->index & 2 ?
 			crop->height / 2 : crop->height;
+		fse->max_height = fse->min_height;
 	}

 	mutex_unlock(&priv->lock);
--
1.9.1
