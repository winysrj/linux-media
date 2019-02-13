Return-Path: <SRS0=D6oO=QU=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8665DC282C2
	for <linux-media@archiver.kernel.org>; Wed, 13 Feb 2019 13:26:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5E06D222B1
	for <linux-media@archiver.kernel.org>; Wed, 13 Feb 2019 13:26:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390670AbfBMN0G (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 13 Feb 2019 08:26:06 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36201 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388743AbfBMN0G (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Feb 2019 08:26:06 -0500
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
        (Exim 4.76)
        (envelope-from <colin.king@canonical.com>)
        id 1gtuY3-0007OK-Sb; Wed, 13 Feb 2019 13:26:00 +0000
From:   Colin King <colin.king@canonical.com>
To:     Kyungmin Park <kyungmin.park@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Kukjin Kim <kgene@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] media: exynos4-is: remove redundant check on type
Date:   Wed, 13 Feb 2019 13:25:59 +0000
Message-Id: <20190213132559.30900-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The check to see if type is V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE is redundant
as this has been already checked at the start of the function and if
it's not that value then -ENOSYS is returned. Hence the sprintf can be
replaced by a simpler string copy.

Detected by CoverityScan, CID#1309450 ("Logically dead code")

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/media/platform/exynos4-is/fimc-isp-video.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/media/platform/exynos4-is/fimc-isp-video.c b/drivers/media/platform/exynos4-is/fimc-isp-video.c
index de6bd28f7e31..bb35a2017f21 100644
--- a/drivers/media/platform/exynos4-is/fimc-isp-video.c
+++ b/drivers/media/platform/exynos4-is/fimc-isp-video.c
@@ -606,9 +606,7 @@ int fimc_isp_video_device_register(struct fimc_isp *isp,
 
 	vdev = &iv->ve.vdev;
 	memset(vdev, 0, sizeof(*vdev));
-	snprintf(vdev->name, sizeof(vdev->name), "fimc-is-isp.%s",
-			type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE ?
-			"capture" : "output");
+	strscpy(vdev->name, "fimc-is-isp.capture", sizeof(vdev->name));
 	vdev->queue = q;
 	vdev->fops = &isp_video_fops;
 	vdev->ioctl_ops = &isp_video_ioctl_ops;
-- 
2.20.1

