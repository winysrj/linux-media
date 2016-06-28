Return-path: <linux-media-owner@vger.kernel.org>
Received: from resqmta-po-03v.sys.comcast.net ([96.114.154.162]:56290 "EHLO
	resqmta-po-03v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752202AbcF1TRW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Jun 2016 15:17:22 -0400
From: Shuah Khan <shuahkh@osg.samsung.com>
To: kyungmin.park@samsung.com, k.debski@samsung.com,
	jtp.park@samsung.com, mchehab@osg.samsung.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH REBASE 1/3] media: s5p-mfc fix video device release double release in probe error path
Date: Tue, 28 Jun 2016 13:17:16 -0600
Message-Id: <97b8e5a8e26d758762ce0d22212284ca6a0a3ac2.1467140929.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1467140929.git.shuahkh@osg.samsung.com>
References: <cover.1467140929.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1467140929.git.shuahkh@osg.samsung.com>
References: <cover.1467140929.git.shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix Decoder and encoder video device double release in probe error path.
video_device_release(dev->vfd_dec) get called twice if decoder register
fails. Also, video_device_release(dev->vfd_enc) get called twice if encoder
register fails.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index 6ee620e..274b4f1 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -1266,7 +1266,6 @@ static int s5p_mfc_probe(struct platform_device *pdev)
 	ret = video_register_device(dev->vfd_dec, VFL_TYPE_GRABBER, 0);
 	if (ret) {
 		v4l2_err(&dev->v4l2_dev, "Failed to register video device\n");
-		video_device_release(dev->vfd_dec);
 		goto err_dec_reg;
 	}
 	v4l2_info(&dev->v4l2_dev,
@@ -1275,7 +1274,6 @@ static int s5p_mfc_probe(struct platform_device *pdev)
 	ret = video_register_device(dev->vfd_enc, VFL_TYPE_GRABBER, 0);
 	if (ret) {
 		v4l2_err(&dev->v4l2_dev, "Failed to register video device\n");
-		video_device_release(dev->vfd_enc);
 		goto err_enc_reg;
 	}
 	v4l2_info(&dev->v4l2_dev,
-- 
2.7.4

