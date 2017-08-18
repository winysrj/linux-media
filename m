Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f175.google.com ([209.85.128.175]:33947 "EHLO
        mail-wr0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753514AbdHROQx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Aug 2017 10:16:53 -0400
Received: by mail-wr0-f175.google.com with SMTP id y96so68404312wrc.1
        for <linux-media@vger.kernel.org>; Fri, 18 Aug 2017 07:16:52 -0700 (PDT)
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>
Subject: [PATCH 4/7] media: venus: fill missing video_device name
Date: Fri, 18 Aug 2017 17:16:03 +0300
Message-Id: <20170818141606.4835-5-stanimir.varbanov@linaro.org>
In-Reply-To: <20170818141606.4835-1-stanimir.varbanov@linaro.org>
References: <20170818141606.4835-1-stanimir.varbanov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This fills missing (forgotten) video device name with
appropriate string so that udev can distinguishes between
decoder and encoder devices.

Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
---
 drivers/media/platform/qcom/venus/vdec.c | 1 +
 drivers/media/platform/qcom/venus/venc.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/media/platform/qcom/venus/vdec.c b/drivers/media/platform/qcom/venus/vdec.c
index 44d4848e878a..32a1feb2fe6a 100644
--- a/drivers/media/platform/qcom/venus/vdec.c
+++ b/drivers/media/platform/qcom/venus/vdec.c
@@ -1069,6 +1069,7 @@ static int vdec_probe(struct platform_device *pdev)
 	if (!vdev)
 		return -ENOMEM;
 
+	strlcpy(vdev->name, "qcom-venus-decoder", sizeof(vdev->name));
 	vdev->release = video_device_release;
 	vdev->fops = &vdec_fops;
 	vdev->ioctl_ops = &vdec_ioctl_ops;
diff --git a/drivers/media/platform/qcom/venus/venc.c b/drivers/media/platform/qcom/venus/venc.c
index 4bffadd67238..bcb50d39f88a 100644
--- a/drivers/media/platform/qcom/venus/venc.c
+++ b/drivers/media/platform/qcom/venus/venc.c
@@ -1192,6 +1192,7 @@ static int venc_probe(struct platform_device *pdev)
 	if (!vdev)
 		return -ENOMEM;
 
+	strlcpy(vdev->name, "qcom-venus-encoder", sizeof(vdev->name));
 	vdev->release = video_device_release;
 	vdev->fops = &venc_fops;
 	vdev->ioctl_ops = &venc_ioctl_ops;
-- 
2.11.0
