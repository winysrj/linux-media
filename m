Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f178.google.com ([209.85.192.178]:34333 "EHLO
        mail-pf0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751147AbdFBVeo (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 2 Jun 2017 17:34:44 -0400
Received: by mail-pf0-f178.google.com with SMTP id 9so57174754pfj.1
        for <linux-media@vger.kernel.org>; Fri, 02 Jun 2017 14:34:44 -0700 (PDT)
From: Kevin Hilman <khilman@baylibre.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org
Cc: Sekhar Nori <nsekhar@ti.com>,
        Patrick Titiano <ptitiano@baylibre.com>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 1/4] [media] davinci: vpif_capture: drop compliance hack
Date: Fri,  2 Jun 2017 14:34:28 -0700
Message-Id: <20170602213431.10777-2-khilman@baylibre.com>
In-Reply-To: <20170602213431.10777-1-khilman@baylibre.com>
References: <20170602213431.10777-1-khilman@baylibre.com>
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
