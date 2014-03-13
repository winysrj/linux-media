Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:42488 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754170AbaCMLpd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Mar 2014 07:45:33 -0400
From: Archit Taneja <archit@ti.com>
To: <k.debski@samsung.com>, <hverkuil@xs4all.nl>
CC: <linux-media@vger.kernel.org>, <linux-omap@vger.kernel.org>,
	Archit Taneja <archit@ti.com>
Subject: [PATCH v4 09/14] v4l: ti-vpe: report correct capabilities in querycap
Date: Thu, 13 Mar 2014 17:14:11 +0530
Message-ID: <1394711056-10878-10-git-send-email-archit@ti.com>
In-Reply-To: <1394711056-10878-1-git-send-email-archit@ti.com>
References: <1394526833-24805-1-git-send-email-archit@ti.com>
 <1394711056-10878-1-git-send-email-archit@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

querycap currently returns V4L2_CAP_VIDEO_M2M as a capability, this should be
V4L2_CAP_VIDEO_M2M_MPLANE instead, as the driver supports multiplanar formats.

Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Archit Taneja <archit@ti.com>
---
 drivers/media/platform/ti-vpe/vpe.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/ti-vpe/vpe.c b/drivers/media/platform/ti-vpe/vpe.c
index f3f1c10..c066eb8 100644
--- a/drivers/media/platform/ti-vpe/vpe.c
+++ b/drivers/media/platform/ti-vpe/vpe.c
@@ -1347,7 +1347,7 @@ static int vpe_querycap(struct file *file, void *priv,
 	strncpy(cap->driver, VPE_MODULE_NAME, sizeof(cap->driver) - 1);
 	strncpy(cap->card, VPE_MODULE_NAME, sizeof(cap->card) - 1);
 	strlcpy(cap->bus_info, VPE_MODULE_NAME, sizeof(cap->bus_info));
-	cap->device_caps  = V4L2_CAP_VIDEO_M2M | V4L2_CAP_STREAMING;
+	cap->device_caps  = V4L2_CAP_VIDEO_M2M_MPLANE | V4L2_CAP_STREAMING;
 	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
 	return 0;
 }
-- 
1.8.3.2

