Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f176.google.com ([209.85.192.176]:36273 "EHLO
        mail-pf0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751437AbdFFXho (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 6 Jun 2017 19:37:44 -0400
Received: by mail-pf0-f176.google.com with SMTP id x63so4908116pff.3
        for <linux-media@vger.kernel.org>; Tue, 06 Jun 2017 16:37:44 -0700 (PDT)
From: Kevin Hilman <khilman@baylibre.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org
Cc: Sekhar Nori <nsekhar@ti.com>, David Lechner <david@lechnology.com>,
        Patrick Titiano <ptitiano@baylibre.com>,
        Benoit Parrot <bparrot@ti.com>,
        Prabhakar Lad <prabhakar.csengg@gmail.com>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2 1/4] [media] davinci: vpif_capture: drop compliance hack
Date: Tue,  6 Jun 2017 16:37:38 -0700
Message-Id: <20170606233741.26718-2-khilman@baylibre.com>
In-Reply-To: <20170606233741.26718-1-khilman@baylibre.com>
References: <20170606233741.26718-1-khilman@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Capture driver silently overrides pixel format with a hack (according to
the comments) to pass v4l2 compliance tests.  This isn't needed for
normal functionality, and works for composite video and raw camera capture
without.

In addition, the hack assumes that it only supports raw capture with a
single format (SBGGR8) which isn't true.  VPIF can also capture 10- and
12-bit raw formats as well.  Forthcoming patches will enable VPIF
input with raw-camera support and has been tested with 10-bit format
from the aptina,mt9v032 sensor.

Any compliance failures should be fixed with a real fix.

Signed-off-by: Kevin Hilman <khilman@baylibre.com>
---
 drivers/media/platform/davinci/vpif_capture.c | 15 ---------------
 1 file changed, 15 deletions(-)

diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
index 128e92d1dd5a..fc5c7622660c 100644
--- a/drivers/media/platform/davinci/vpif_capture.c
+++ b/drivers/media/platform/davinci/vpif_capture.c
@@ -936,21 +936,6 @@ static int vpif_try_fmt_vid_cap(struct file *file, void *priv,
 	struct channel_obj *ch = video_get_drvdata(vdev);
 	struct v4l2_pix_format *pixfmt = &fmt->fmt.pix;
 	struct common_obj *common = &(ch->common[VPIF_VIDEO_INDEX]);
-	struct vpif_params *vpif_params = &ch->vpifparams;
-
-	/*
-	 * to supress v4l-compliance warnings silently correct
-	 * the pixelformat
-	 */
-	if (vpif_params->iface.if_type == VPIF_IF_RAW_BAYER) {
-		if (pixfmt->pixelformat != V4L2_PIX_FMT_SBGGR8)
-			pixfmt->pixelformat = V4L2_PIX_FMT_SBGGR8;
-	} else {
-		if (pixfmt->pixelformat != V4L2_PIX_FMT_NV16)
-			pixfmt->pixelformat = V4L2_PIX_FMT_NV16;
-	}
-
-	common->fmt.fmt.pix.pixelformat = pixfmt->pixelformat;
 
 	vpif_update_std_info(ch);
 
-- 
2.9.3
