Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:60483 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754184AbaCMLpg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Mar 2014 07:45:36 -0400
From: Archit Taneja <archit@ti.com>
To: <k.debski@samsung.com>, <hverkuil@xs4all.nl>
CC: <linux-media@vger.kernel.org>, <linux-omap@vger.kernel.org>,
	Archit Taneja <archit@ti.com>
Subject: [PATCH v4 10/14] v4l: ti-vpe: Use correct bus_info name for the device in querycap
Date: Thu, 13 Mar 2014 17:14:12 +0530
Message-ID: <1394711056-10878-11-git-send-email-archit@ti.com>
In-Reply-To: <1394711056-10878-1-git-send-email-archit@ti.com>
References: <1394526833-24805-1-git-send-email-archit@ti.com>
 <1394711056-10878-1-git-send-email-archit@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The bus_info parameter in v4l2_capabilities expects a 'platform_' prefix. This
wasn't done in the driver and hence was breaking compliance. Update the bus_info
parameter accordingly.

Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Archit Taneja <archit@ti.com>
---
 drivers/media/platform/ti-vpe/vpe.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/ti-vpe/vpe.c b/drivers/media/platform/ti-vpe/vpe.c
index c066eb8..3a312ea 100644
--- a/drivers/media/platform/ti-vpe/vpe.c
+++ b/drivers/media/platform/ti-vpe/vpe.c
@@ -1346,7 +1346,8 @@ static int vpe_querycap(struct file *file, void *priv,
 {
 	strncpy(cap->driver, VPE_MODULE_NAME, sizeof(cap->driver) - 1);
 	strncpy(cap->card, VPE_MODULE_NAME, sizeof(cap->card) - 1);
-	strlcpy(cap->bus_info, VPE_MODULE_NAME, sizeof(cap->bus_info));
+	snprintf(cap->bus_info, sizeof(cap->bus_info), "platform:%s",
+		VPE_MODULE_NAME);
 	cap->device_caps  = V4L2_CAP_VIDEO_M2M_MPLANE | V4L2_CAP_STREAMING;
 	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
 	return 0;
-- 
1.8.3.2

