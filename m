Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:45762 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753866AbaCKIfQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Mar 2014 04:35:16 -0400
From: Archit Taneja <archit@ti.com>
To: <k.debski@samsung.com>, <hverkuil@xs4all.nl>
CC: <linux-media@vger.kernel.org>, <linux-omap@vger.kernel.org>,
	Archit Taneja <archit@ti.com>
Subject: [PATCH v3 10/14] v4l: ti-vpe: Use correct bus_info name for the device in querycap
Date: Tue, 11 Mar 2014 14:03:49 +0530
Message-ID: <1394526833-24805-11-git-send-email-archit@ti.com>
In-Reply-To: <1394526833-24805-1-git-send-email-archit@ti.com>
References: <1393922965-15967-1-git-send-email-archit@ti.com>
 <1394526833-24805-1-git-send-email-archit@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The bus_info parameter in v4l2_capabilities expects a 'platform_' prefix. This
wasn't done in the driver and hence was breaking compliance. Update the bus_info
parameter accordingly.

Signed-off-by: Archit Taneja <archit@ti.com>
---
 drivers/media/platform/ti-vpe/vpe.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/ti-vpe/vpe.c b/drivers/media/platform/ti-vpe/vpe.c
index 46b9d44..5591d04 100644
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

