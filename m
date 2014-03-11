Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:45766 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754118AbaCKIfT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Mar 2014 04:35:19 -0400
From: Archit Taneja <archit@ti.com>
To: <k.debski@samsung.com>, <hverkuil@xs4all.nl>
CC: <linux-media@vger.kernel.org>, <linux-omap@vger.kernel.org>,
	Archit Taneja <archit@ti.com>
Subject: [PATCH v3 11/14] v4l: ti-vpe: Fix initial configuration queue data
Date: Tue, 11 Mar 2014 14:03:50 +0530
Message-ID: <1394526833-24805-12-git-send-email-archit@ti.com>
In-Reply-To: <1394526833-24805-1-git-send-email-archit@ti.com>
References: <1393922965-15967-1-git-send-email-archit@ti.com>
 <1394526833-24805-1-git-send-email-archit@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The vpe output and capture queues are initially configured to default values in
vpe_open(). A G_FMT before any S_FMTs will result in these values being
populated.

The colorspace and bytesperline parameter of this initial configuration are
incorrect. This breaks compliance when as we get 'TRY_FMT(G_FMT) != G_FMT'.

Fix the initial queue configuration such that it wouldn't need to be fixed by
try_fmt.

Signed-off-by: Archit Taneja <archit@ti.com>
---
 drivers/media/platform/ti-vpe/vpe.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/ti-vpe/vpe.c b/drivers/media/platform/ti-vpe/vpe.c
index 5591d04..85d1122 100644
--- a/drivers/media/platform/ti-vpe/vpe.c
+++ b/drivers/media/platform/ti-vpe/vpe.c
@@ -2012,9 +2012,11 @@ static int vpe_open(struct file *file)
 	s_q_data->fmt = &vpe_formats[2];
 	s_q_data->width = 1920;
 	s_q_data->height = 1080;
-	s_q_data->sizeimage[VPE_LUMA] = (s_q_data->width * s_q_data->height *
+	s_q_data->bytesperline[VPE_LUMA] = (s_q_data->width *
 			s_q_data->fmt->vpdma_fmt[VPE_LUMA]->depth) >> 3;
-	s_q_data->colorspace = V4L2_COLORSPACE_SMPTE170M;
+	s_q_data->sizeimage[VPE_LUMA] = (s_q_data->bytesperline[VPE_LUMA] *
+			s_q_data->height);
+	s_q_data->colorspace = V4L2_COLORSPACE_REC709;
 	s_q_data->field = V4L2_FIELD_NONE;
 	s_q_data->c_rect.left = 0;
 	s_q_data->c_rect.top = 0;
-- 
1.8.3.2

