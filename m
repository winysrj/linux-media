Return-path: <mchehab@localhost>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:47985 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904Ab1GFRNs (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Jul 2011 13:13:48 -0400
Received: from eu_spt1 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LNX0005G96YL8@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 06 Jul 2011 18:13:46 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LNX00FXA96XDP@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 06 Jul 2011 18:13:46 +0100 (BST)
Date: Wed, 06 Jul 2011 19:13:41 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 3/3] s5p-csis: Enable v4l subdev device node
In-reply-to: <1309972421-29690-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	laurent.pinchart@ideasonboard.com, s.nawrocki@samsung.com,
	sw0312.kim@samsung.com, riverful.kim@samsung.com
Message-id: <1309972421-29690-4-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1309972421-29690-1-git-send-email-s.nawrocki@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

Set v4l2_subdev flags for a host driver to create a sub-device
node for the driver so the subdev can be directly configured
by applications.

Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
 drivers/media/video/s5p-fimc/mipi-csis.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/mipi-csis.c b/drivers/media/video/s5p-fimc/mipi-csis.c
index 5b38be7..180abd6 100644
--- a/drivers/media/video/s5p-fimc/mipi-csis.c
+++ b/drivers/media/video/s5p-fimc/mipi-csis.c
@@ -546,6 +546,7 @@ static int __devinit s5pcsis_probe(struct platform_device *pdev)
 	v4l2_subdev_init(&state->sd, &s5pcsis_subdev_ops);
 	state->sd.owner = THIS_MODULE;
 	strlcpy(state->sd.name, dev_name(&pdev->dev), sizeof(state->sd.name));
+	state->sd.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
 	state->csis_fmt = &s5pcsis_formats[0];
 
 	state->pads[CSIS_PAD_SINK].flags = MEDIA_PAD_FL_SINK;
-- 
1.7.5.4

