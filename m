Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:52217 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755924AbaHERAf (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Aug 2014 13:00:35 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Kamil Debski <k.debski@samsung.com>, kernel@pengutronix.de,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 15/15] [media] coda: disable old cropping ioctls
Date: Tue,  5 Aug 2014 19:00:20 +0200
Message-Id: <1407258020-12078-16-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1407258020-12078-1-git-send-email-p.zabel@pengutronix.de>
References: <1407258020-12078-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Since we neither support composing on the OUTPUT side, nor cropping
on the CAPTURE side, disable VIDIOC_CROPCAP and VIDIOC_G/S_CROP
altogether. This silences a GStreamer warning when GStreamer tries
to obtain the pixel aspect ratio using VIDIOC_CROPCAP.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-common.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index a1080a7..ffb4c76 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -1661,6 +1661,11 @@ static int coda_register_device(struct coda_dev *dev, struct video_device *vfd)
 	vfd->vfl_dir	= VFL_DIR_M2M;
 	video_set_drvdata(vfd, dev);
 
+	/* Not applicable, use the selection API instead */
+	v4l2_disable_ioctl(vfd, VIDIOC_CROPCAP);
+	v4l2_disable_ioctl(vfd, VIDIOC_G_CROP);
+	v4l2_disable_ioctl(vfd, VIDIOC_S_CROP);
+
 	return video_register_device(vfd, VFL_TYPE_GRABBER, 0);
 }
 
-- 
2.0.1

