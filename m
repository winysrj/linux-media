Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:48257 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754038AbcFPVlW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Jun 2016 17:41:22 -0400
From: Javier Martinez Canillas <javier@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Javier Martinez Canillas <javier@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Jacek Anaszewski <j.anaszewski@samsung.com>,
	Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Subject: [PATCH 3/6] [media] s5p-jpeg: set capablity bus_info as required by VIDIOC_QUERYCAP
Date: Thu, 16 Jun 2016 17:40:32 -0400
Message-Id: <1466113235-25909-4-git-send-email-javier@osg.samsung.com>
In-Reply-To: <1466113235-25909-1-git-send-email-javier@osg.samsung.com>
References: <1466113235-25909-1-git-send-email-javier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The driver doesn't set the struct v4l2_capability cap_info field so the
v4l2-compliance tool reports the following errors for VIDIOC_QUERYCAP:

Required ioctls:
                VIDIOC_QUERYCAP returned 0 (Success)
                fail: v4l2-compliance.cpp(304): string empty
                fail: v4l2-compliance.cpp(528): check_ustring(vcap.bus_info, sizeof(vcap.bus_info))
        test VIDIOC_QUERYCAP: FAIL

This patch fixes by setting the field in VIDIOC_QUERYCAP ioctl handler:

Required ioctls:
                VIDIOC_QUERYCAP returned 0 (Success)
        test VIDIOC_QUERYCAP: OK

Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
---

 drivers/media/platform/s5p-jpeg/jpeg-core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
index 17bc94092864..e3ff3d4bd72e 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
@@ -1256,7 +1256,8 @@ static int s5p_jpeg_querycap(struct file *file, void *priv,
 		strlcpy(cap->card, S5P_JPEG_M2M_NAME " decoder",
 			sizeof(cap->card));
 	}
-	cap->bus_info[0] = 0;
+	snprintf(cap->bus_info, sizeof(cap->bus_info), "platform:%s",
+		 dev_name(ctx->jpeg->dev));
 	cap->device_caps = V4L2_CAP_STREAMING | V4L2_CAP_VIDEO_M2M;
 	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
 	return 0;
-- 
2.5.5

