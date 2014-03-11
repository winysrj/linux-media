Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:45769 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754125AbaCKIfY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Mar 2014 04:35:24 -0400
From: Archit Taneja <archit@ti.com>
To: <k.debski@samsung.com>, <hverkuil@xs4all.nl>
CC: <linux-media@vger.kernel.org>, <linux-omap@vger.kernel.org>,
	Archit Taneja <archit@ti.com>
Subject: [PATCH v3 12/14] v4l: ti-vpe: zero out reserved fields in try_fmt
Date: Tue, 11 Mar 2014 14:03:51 +0530
Message-ID: <1394526833-24805-13-git-send-email-archit@ti.com>
In-Reply-To: <1394526833-24805-1-git-send-email-archit@ti.com>
References: <1393922965-15967-1-git-send-email-archit@ti.com>
 <1394526833-24805-1-git-send-email-archit@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Zero out the reserved formats in v4l2_pix_format_mplane and
v4l2_plane_pix_format members of the returned v4l2_format pointer when passed
through TRY_FMT ioctl.

This ensures that the user doesn't interpret the non-zero fields as some data
passed by the driver, and ensures compliance.

Signed-off-by: Archit Taneja <archit@ti.com>
---
 drivers/media/platform/ti-vpe/vpe.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/platform/ti-vpe/vpe.c b/drivers/media/platform/ti-vpe/vpe.c
index 85d1122..970408a 100644
--- a/drivers/media/platform/ti-vpe/vpe.c
+++ b/drivers/media/platform/ti-vpe/vpe.c
@@ -1488,6 +1488,7 @@ static int __vpe_try_fmt(struct vpe_ctx *ctx, struct v4l2_format *f,
 		}
 	}
 
+	memset(pix->reserved, 0, sizeof(pix->reserved));
 	for (i = 0; i < pix->num_planes; i++) {
 		plane_fmt = &pix->plane_fmt[i];
 		depth = fmt->vpdma_fmt[i]->depth;
@@ -1499,6 +1500,8 @@ static int __vpe_try_fmt(struct vpe_ctx *ctx, struct v4l2_format *f,
 
 		plane_fmt->sizeimage =
 				(pix->height * pix->width * depth) >> 3;
+
+		memset(plane_fmt->reserved, 0, sizeof(plane_fmt->reserved));
 	}
 
 	return 0;
-- 
1.8.3.2

