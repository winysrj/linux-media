Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:60127 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933949AbeF2Mqy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 29 Jun 2018 08:46:54 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: kernel@pengutronix.de
Subject: [PATCH 1/3] media: coda: jpeg: allow non-JPEG colorspace
Date: Fri, 29 Jun 2018 14:46:46 +0200
Message-Id: <20180629124648.31739-1-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The hardware codec is not colorspace aware. We should trust userspace to
set the correct colorimetry information on the OUTPUT queue and mirror
the exact same setting on the CAPTURE queue.

There is no reason to restrict colorspace to JPEG for JPEG images, if
userspace injects the correct colorspace information into the JPEG
headers after encoding.

Fixes: b14ac545688d ("[media] coda: improve colorimetry handling")
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-common.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index b86d704ae10c..d951b81ac480 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -569,8 +569,6 @@ static int coda_try_fmt(struct coda_ctx *ctx, const struct coda_codec *codec,
 					f->fmt.pix.height * 2;
 		break;
 	case V4L2_PIX_FMT_JPEG:
-		f->fmt.pix.colorspace = V4L2_COLORSPACE_JPEG;
-		/* fallthrough */
 	case V4L2_PIX_FMT_H264:
 	case V4L2_PIX_FMT_MPEG4:
 	case V4L2_PIX_FMT_MPEG2:
-- 
2.17.1
