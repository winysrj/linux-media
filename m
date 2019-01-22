Return-Path: <SRS0=JQ9q=P6=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DDC9C282C4
	for <linux-media@archiver.kernel.org>; Tue, 22 Jan 2019 08:22:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4897620861
	for <linux-media@archiver.kernel.org>; Tue, 22 Jan 2019 08:22:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727150AbfAVIWl (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 22 Jan 2019 03:22:41 -0500
Received: from mga09.intel.com ([134.134.136.24]:8181 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727087AbfAVIWl (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 Jan 2019 03:22:41 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Jan 2019 00:22:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,505,1539673200"; 
   d="scan'208";a="108768034"
Received: from shsi06.sh.intel.com (HELO localhost) ([10.239.154.107])
  by orsmga007.jf.intel.com with ESMTP; 22 Jan 2019 00:22:38 -0800
From:   "Liu, Xinwu" <xinwu.liu@intel.com>
To:     mchehab@kernel.org
Cc:     hans.verkuil@cisco.com, sakari.ailus@linux.intel.com,
        niklas.soderlund+renesas@ragnatech.se, ezequiel@collabora.com,
        sque@chromium.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, xinwu.liu@intel.com
Subject: [PATCH] media: v4l2-core: expose the device after it was registered.
Date:   Tue, 22 Jan 2019 16:34:44 +0800
Message-Id: <1548146084-20445-1-git-send-email-xinwu.liu@intel.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

device_register exposes the device to userspace.

Therefore, while the register process is ongoing, the userspace program
will fail to open the device (ENODEV will be set to errno currently).
The program in userspace must re-open the device to cover this case.

It is more reasonable to expose the device after everythings ready.

Signed-off-by: Liu, Xinwu <xinwu.liu@intel.com>
---
 drivers/media/v4l2-core/v4l2-dev.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-dev.c b/drivers/media/v4l2-core/v4l2-dev.c
index d7528f8..01e5cc9 100644
--- a/drivers/media/v4l2-core/v4l2-dev.c
+++ b/drivers/media/v4l2-core/v4l2-dev.c
@@ -993,16 +993,11 @@ int __video_register_device(struct video_device *vdev,
 		goto cleanup;
 	}
 
-	/* Part 4: register the device with sysfs */
+	/* Part 4: Prepare to register the device */
 	vdev->dev.class = &video_class;
 	vdev->dev.devt = MKDEV(VIDEO_MAJOR, vdev->minor);
 	vdev->dev.parent = vdev->dev_parent;
 	dev_set_name(&vdev->dev, "%s%d", name_base, vdev->num);
-	ret = device_register(&vdev->dev);
-	if (ret < 0) {
-		pr_err("%s: device_register failed\n", __func__);
-		goto cleanup;
-	}
 	/* Register the release callback that will be called when the last
 	   reference to the device goes away. */
 	vdev->dev.release = v4l2_device_release;
@@ -1020,6 +1015,13 @@ int __video_register_device(struct video_device *vdev,
 	/* Part 6: Activate this minor. The char device can now be used. */
 	set_bit(V4L2_FL_REGISTERED, &vdev->flags);
 
+	/* Part 7: Register the device with sysfs */
+	ret = device_register(&vdev->dev);
+	if (ret < 0) {
+		pr_err("%s: device_register failed\n", __func__);
+		goto cleanup;
+	}
+
 	return 0;
 
 cleanup:
-- 
2.7.4

